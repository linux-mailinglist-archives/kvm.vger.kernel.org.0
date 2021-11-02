Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3D9442AA8
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 10:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhKBJtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 05:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhKBJth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 05:49:37 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADF7C061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 02:47:03 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id f8-20020a05660215c800b005e166630a3dso10054570iow.15
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 02:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LW62NaqnzOIPyMSkIbkMT7S/DeS5QsuklZa8PoVQ7Ts=;
        b=R/UakULhkBCZbgzgewMj4LYGsljk3XONwmfkNrEjAIjteagmlKOo4UF2SA7WdVeTSl
         0Ny1s3tjQ10f2WBLLhD1ataKqHZkMAkCOZMUssW6Opwyk1jMZvw5R19QIAoNJjuKNnKw
         42oDFamwIXC/r7dOUEcdglXAseWkrKE16BTwsnnM1Vsrp38xTrwIhKXo+On/29TCtH0o
         lrpyIewcC3C3OAYPDk8xI5TzCTVHl6pdHu/t+g+3OzK5/F/+vSUZNK0voHyXiQEGY0P3
         0EdJPxNWVIvmk8u9BQbWpnEskUwkfrRXvhZ6QBOQJJDNsJYcxZ6Vw3i65S12CDqx+hta
         9QKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LW62NaqnzOIPyMSkIbkMT7S/DeS5QsuklZa8PoVQ7Ts=;
        b=ta9Ey2C4NNtFJLYxoWngi+kQSxiV41y02WUQgqY5ksQByzPHoF006XoKrQrxGRFnOy
         CWpT3V+30A17KSqSyTUvHP+G2HczaubQbLTlXErCDuAbXwd0b3ygwVJUtjN2ymc1Y8/s
         pHWKy/nX+Iy18XtEed/dsV1yu75EFRFax6oZGFApHAVQUtzuy3bssPPcUlptJrovA+Gw
         Cy9/qvaUUSAuOeZiJJbH0eH4f39bODqvNqSoPDL1seTwAkMdInxMgGKXrqQjAmh/JpyC
         ak/13RZQJ/91/l8EzHFPENPp2849FZmHfIAxhL8ZGOQL6B8em6NRuLTtFY7OCj3SxH8v
         UWjw==
X-Gm-Message-State: AOAM533hqbEQLrV+MvUflYk+CIjryqQA8cSyuabuxmPu8/kKR9CVr2Pt
        zOkJc7H3iC8NfZvw0BcOh368eQFhE44=
X-Google-Smtp-Source: ABdhPJyAAd3EZ7PG9zgAtlS9xNQ7IEiF/KnBkc8peoyeSw7zPj/Pr+fPOvN0382WKxo0+yGxzbd0/Ii9uzE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:650f:: with SMTP id z15mr19435494iob.27.1635846422770;
 Tue, 02 Nov 2021 02:47:02 -0700 (PDT)
Date:   Tue,  2 Nov 2021 09:46:48 +0000
In-Reply-To: <20211102094651.2071532-1-oupton@google.com>
Message-Id: <20211102094651.2071532-4-oupton@google.com>
Mime-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2 3/6] KVM: arm64: Allow guest to set the OSLK bit
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

Allow writes to OSLAR and forward the OSLK bit to OSLSR. Change the
reset value of the OSLK bit to 1. Allow the value to be migrated by
making OSLSR_EL1.OSLK writable from userspace.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/sysreg.h |  6 ++++++
 arch/arm64/kvm/sys_regs.c       | 35 +++++++++++++++++++++++++--------
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b268082d67ed..6ba4dc97b69d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -127,7 +127,13 @@
 #define SYS_DBGWCRn_EL1(n)		sys_reg(2, 0, 0, n, 7)
 #define SYS_MDRAR_EL1			sys_reg(2, 0, 1, 0, 0)
 #define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
+
+#define SYS_OSLAR_OSLK			BIT(0)
+
 #define SYS_OSLSR_EL1			sys_reg(2, 0, 1, 1, 4)
+
+#define SYS_OSLSR_OSLK			BIT(1)
+
 #define SYS_OSDLR_EL1			sys_reg(2, 0, 1, 3, 4)
 #define SYS_DBGPRCR_EL1			sys_reg(2, 0, 1, 4, 4)
 #define SYS_DBGCLAIMSET_EL1		sys_reg(2, 0, 7, 8, 6)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0326b3df0736..acd8aa2e5a44 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -44,6 +44,10 @@
  * 64bit interface.
  */
 
+static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
+static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
+static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
+
 static bool read_from_write_only(struct kvm_vcpu *vcpu,
 				 struct sys_reg_params *params,
 				 const struct sys_reg_desc *r)
@@ -287,6 +291,24 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 	return trap_raz_wi(vcpu, p, r);
 }
 
+static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	u64 oslsr;
+
+	if (!p->is_write)
+		return read_from_write_only(vcpu, p, r);
+
+	/* Forward the OSLK bit to OSLSR */
+	oslsr = __vcpu_sys_reg(vcpu, OSLSR_EL1) & ~SYS_OSLSR_OSLK;
+	if (p->regval & SYS_OSLAR_OSLK)
+		oslsr |= SYS_OSLSR_OSLK;
+
+	__vcpu_sys_reg(vcpu, OSLSR_EL1) = oslsr;
+	return true;
+}
+
 static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
@@ -309,9 +331,10 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	if (err)
 		return err;
 
-	if (val != rd->val)
+	if ((val | SYS_OSLSR_OSLK) != rd->val)
 		return -EINVAL;
 
+	__vcpu_sys_reg(vcpu, rd->reg) = val;
 	return 0;
 }
 
@@ -1176,10 +1199,6 @@ static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
 	return __access_id_reg(vcpu, p, r, true);
 }
 
-static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
-static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
-static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
-
 /* Visibility overrides for SVE-specific control registers */
 static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
@@ -1456,8 +1475,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	DBG_BCR_BVR_WCR_WVR_EL1(15),
 
 	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008,
+	{ SYS_DESC(SYS_OSLAR_EL1), trap_oslar_el1 },
+	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x0000000A,
 		.set_user = set_oslsr_el1, },
 	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
@@ -1930,7 +1949,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 
 	DBGBXVR(0),
 	/* DBGOSLAR */
-	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
+	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_oslar_el1 },
 	DBGBXVR(1),
 	/* DBGOSLSR */
 	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
-- 
2.33.1.1089.g2158813163f-goog

