Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C76543F3F4
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 02:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhJ2AfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 20:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbhJ2AfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 20:35:10 -0400
Received: from mail-ot1-x34a.google.com (mail-ot1-x34a.google.com [IPv6:2607:f8b0:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7EEC061570
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 17:32:42 -0700 (PDT)
Received: by mail-ot1-x34a.google.com with SMTP id r3-20020a056830236300b0054d43b72ba5so4348899oth.17
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 17:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/sJBbEboFqrI/MxFIGHyMR9wTr4lxmpL5NLpkV9j8hQ=;
        b=CS2JS7vwBb0zhIoVa/v/R9TXNAMyxaDHa0+R30BfqVftv8Ib04TdU50zJzA+/zP95r
         LVY/dLq68XY1xApshEteH2mXaeynz6bRdH8aOhxFWwVQq86cfvuFfYEuLJcCDXYHorQQ
         MBdvOweKuyeYEOk2XfpMSh9hjycA1O037blIDV4CbL2jP9YGYfyQ0Hksc9zg3IRdEWR+
         OkR4YO4AK+9nmA8SLd2rhR9AZRlmkUkQX/ZliV8doGjv6mAtlv6wrG0JZJMVvIUYHXIP
         uwOtf00tTbn/yxsHw7L6jgh0PYBAuz8JofNLLKjix4GWKWTuPPCxWWXzMtaX9BEjLxr+
         3Sbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/sJBbEboFqrI/MxFIGHyMR9wTr4lxmpL5NLpkV9j8hQ=;
        b=bNJwg6+ly5ZmV7vBt0dmlZk/pCVWKa0XoX0SWx8ccdSh8fHcjHIKoDniHxwyWtSgeo
         +gDBmpi6fkOc5MWF3QUWMiJv2a1czG68QmqmFL4Ocm+Vbaw6X43FwQS0oA4FVMiGJHmB
         oCjxBY+blm04D+aIkEja2+ThaHAen/AzZTJcoAgWkU29yWAE5QNRESNStqGc717cGco8
         uvLfZHEAbldsGZ5pnGoir81jTzvfYKZbGeGpxpBj6n4lTRHhz4Q9xqnpA6EW1DntcGbP
         5L6xz5HTtHSLb/MC5zMCsDDmwZN1qv/zEXXHBkZXgzd2FuHxaprE5QmzxXKNBNkYmVNg
         PCDQ==
X-Gm-Message-State: AOAM531mXNdov3mrkvliosbMRi45WKxXfVfDXt4ebGUXyUzX0ut6CcDA
        WiYeJ34MH1kmA6Z5HRoQR0drub879+g=
X-Google-Smtp-Source: ABdhPJy9nXHALTXt4MgBaSGvD9mD2E3itk627BvZ8WCtIIPahARJ3cpAv7JLd0lNeNrT9GzDK78pS6NEvAI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6808:6ce:: with SMTP id
 m14mr5671351oih.134.1635467562084; Thu, 28 Oct 2021 17:32:42 -0700 (PDT)
Date:   Fri, 29 Oct 2021 00:32:00 +0000
In-Reply-To: <20211029003202.158161-1-oupton@google.com>
Message-Id: <20211029003202.158161-2-oupton@google.com>
Mime-Version: 1.0
References: <20211029003202.158161-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 1/3] KVM: arm64: Stash OSLSR_EL1 in the cpu context
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

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/sys_regs.c         | 13 ++++++-------
 2 files changed, 7 insertions(+), 7 deletions(-)

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
index 1d46e185f31e..0eb03e7508fe 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -291,12 +291,11 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	if (p->is_write) {
+	if (p->is_write)
 		return ignore_write(vcpu, p);
-	} else {
-		p->regval = (1 << 3);
-		return true;
-	}
+
+	p->regval = vcpu_read_sys_reg(vcpu, r->reg);
+	return true;
 }
 
 static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
@@ -1441,7 +1440,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1 },
+	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008 },
 	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGCLAIMSET_EL1), trap_raz_wi },
@@ -1916,7 +1915,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
 	DBGBXVR(1),
 	/* DBGOSLSR */
-	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1 },
+	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
 	DBGBXVR(2),
 	DBGBXVR(3),
 	/* DBGOSDLR */
-- 
2.33.0.1079.g6e70778dc9-goog

