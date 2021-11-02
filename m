Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254E9442AA7
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 10:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhKBJtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 05:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbhKBJtg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 05:49:36 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55110C061764
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 02:47:02 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id d19-20020a0566022d5300b005e178955ce3so8324858iow.18
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 02:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DbmokXu45N05i00rjRKFS9Aukc67vZn4OjwqX1uC/YU=;
        b=EdDi9FOXMCGHRhU016qAQn/ZmuBFvVQyBV401phw9A0mM29D7FCBkKrqoRN+ddaDKu
         WMNSZyuCDNWevO/SP5n9ML9GzsOq3KJVi026ObUqHeQqAO6uvqeRwYkUUMyOGQWHiYA2
         tnvJWSLvjtmZY8JFr6NQakWEW4/5U9vJZL8Lqm47kV26cjyA2ANUqH8OMBybG6CG908N
         x0okPVWvlaqCs8jLleOKU+LoC7nP19scolOl5HFZ8y+ukdy5eVk5p2toXh3eLSrG2BBJ
         +fwB5JpZB8U6m0jYd/lt9RgHDohbN545YLjTCvSuLn+ccimIQxFvgF0GnE25PMzP3z+b
         oMng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DbmokXu45N05i00rjRKFS9Aukc67vZn4OjwqX1uC/YU=;
        b=Txepl2HFkKatL+k7yQ3S27hDUi+y+YfWKUKT4NdEU8w+x8z9XaBkKAPc8xolD3wL1z
         Z2yOhSpPS0TDHmkiRsBagFer5TW+eY11s2fFMMb1dc279j36YgxdfA2+Yd1DXszbgRpg
         wmInTS2n0Mo4Gt3A/mYcO326gFtR6JMJYb30yJteRjeKZRcJesZkR4avFbEaX95hCehu
         DSSiYDdEgjbTVGdMC/GTQD1badzZ3IWyKxLuICHqig1rV0o5EDhyql8qATQJ8vOIuCXf
         2bqcKOCw7J2jJJFh0x4gDKZquv0msecaxqGBcyfbUBNDvP3XADQq17zR3Wui0ZKJ3WnF
         2eyg==
X-Gm-Message-State: AOAM5306QsElZW9sSsiObAldtGgC6q9khWSmAARn5kntfU8d3gJpQicy
        wiTx2L6ILeatvAYEnKBZEO13hDl9X0M=
X-Google-Smtp-Source: ABdhPJyDtijBd6vvihLRehY/zlMTHVriiJWyurunjgvekkIvbB0W9BlpBBhTD9Sttnoy8lUPFahbqXpiX6c=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:a884:: with SMTP id l4mr26257855jam.44.1635846421777;
 Tue, 02 Nov 2021 02:47:01 -0700 (PDT)
Date:   Tue,  2 Nov 2021 09:46:47 +0000
In-Reply-To: <20211102094651.2071532-1-oupton@google.com>
Message-Id: <20211102094651.2071532-3-oupton@google.com>
Mime-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2 2/6] KVM: arm64: Stash OSLSR_EL1 in the cpu context
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An upcoming change to KVM will context switch the OS Lock status between
guest/host. Add OSLSR_EL1 to the cpu context and handle guest reads
using the stored value.

Wire up a custom handler for writes from userspace and prevent any of
the invariant bits from changing.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/sys_regs.c         | 31 ++++++++++++++++++++++++-------
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..c98f65c4a1f7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -172,6 +172,7 @@ enum vcpu_sysreg {
 	MDSCR_EL1,	/* Monitor Debug System Control Register */
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
 	DISR_EL1,	/* Deferred Interrupt Status Register */
+	OSLSR_EL1,	/* OS Lock Status Register */
 
 	/* Performance Monitors Registers */
 	PMCR_EL0,	/* Control Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 17fa6ddf5405..0326b3df0736 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -291,12 +291,28 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	if (p->is_write) {
+	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
-	} else {
-		p->regval = (1 << 3);
-		return true;
-	}
+
+	p->regval = __vcpu_sys_reg(vcpu, r->reg);
+	return true;
+}
+
+static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+			 const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	u64 id = sys_reg_to_index(rd);
+	u64 val;
+	int err;
+
+	err = reg_from_user(&val, uaddr, id);
+	if (err)
+		return err;
+
+	if (val != rd->val)
+		return -EINVAL;
+
+	return 0;
 }
 
 static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
@@ -1441,7 +1457,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1 },
+	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008,
+		.set_user = set_oslsr_el1, },
 	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGCLAIMSET_EL1), trap_raz_wi },
@@ -1916,7 +1933,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
 	DBGBXVR(1),
 	/* DBGOSLSR */
-	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1 },
+	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
 	DBGBXVR(2),
 	DBGBXVR(3),
 	/* DBGOSDLR */
-- 
2.33.1.1089.g2158813163f-goog

