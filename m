Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3164A4A8A5B
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 18:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352982AbiBCRmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 12:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349810AbiBCRmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 12:42:05 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CEDC061714
        for <kvm@vger.kernel.org>; Thu,  3 Feb 2022 09:42:05 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id z11-20020a056e0217cb00b002bab54d8254so2140164ilu.18
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 09:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eNO0KOJWga9XORILDX/6xRydNTZFNjDRV4Q2RutcMDE=;
        b=GBv1qQNEjxsI0j7Wx8ZWFo2Xf9aA/iwwbdY4D2ib9NMc5RAyaEI9xPszBHc6PgzJqp
         e89C+vu8i0F1WihIzj64EqPHI91Yl9RWma4jftvX9hpYd3X0d3vsINZyjzavb/31i4Y4
         tU0xthBX8swm8n22k5vrparcbSuj14DCfjU1+IE5P4dyv/ajs/q91caTVB0ubh23/+z0
         bPz4j1lD1lQSybPZDQyXCTwn4AvlXJlfNXWnz9a6Q0BylSt3q0DPGJS70uAZHGcVUV+7
         ppxLCN1QaWZ1mFkt5u2uGJLfQ9zg/kdVkF4MhTABNmsTPRLNo8bxOrMjK42JXjsuGDtc
         HK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eNO0KOJWga9XORILDX/6xRydNTZFNjDRV4Q2RutcMDE=;
        b=a3uxkBPdd1cHA9AyPzPw4vYdRtbDoDO5jyz9Dr8FgTV9L/NCGGJfmpDpUXkUBuJJLX
         4da73JFkXdmDtjlBLq3wrwDDb3Pv49+6kXPwv9okR4TbRedT8Xo4rsinjmfIVNNqkQaf
         C/G9FRqFMAKTHxGnC8zU+PwvuDwJadoXxqb9usvK0PKxfkFJ0WwztwtrUfiNvMeG3Xlr
         +T+UWtlQYx29BvV/FAWnyUEIjOBvznWXxELGxRbY8ek3Fn8Fi5rAp6nEyMs/nuPAXbBC
         ALZ4CWDrG9HIdPMH39eMhzfRRNNyb0+3QGO0G/NOF1kUhHRVF3JGmlCUIeZlX4hWfGcq
         492A==
X-Gm-Message-State: AOAM533ictck9WZkxQD2t2Zls22cbFBkvZmAZEeprPzwyicOTRLWm8HH
        9N/m4JNxt4YprmWE5VOWnsYj+Q1EFVs=
X-Google-Smtp-Source: ABdhPJzBadVawvG3pIMPz85Q8F2QVyG0XJIbz1c+pZ3R9l8pHkHxELFQ925oh8/bg6lkUKCHM5LsTt5xPbw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:188c:: with SMTP id
 o12mr11609950ilu.44.1643910124940; Thu, 03 Feb 2022 09:42:04 -0800 (PST)
Date:   Thu,  3 Feb 2022 17:41:55 +0000
In-Reply-To: <20220203174159.2887882-1-oupton@google.com>
Message-Id: <20220203174159.2887882-3-oupton@google.com>
Mime-Version: 1.0
References: <20220203174159.2887882-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v5 2/6] KVM: arm64: Stash OSLSR_EL1 in the cpu context
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
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An upcoming change to KVM will emulate the OS Lock from the PoV of the
guest. Add OSLSR_EL1 to the cpu context and handle reads using the
stored value. Define some mnemonics for for handling the OSLM field and
use them to make the reset value of OSLSR_EL1 more readable.

Wire up a custom handler for writes from userspace and prevent any of
the invariant bits from changing. Note that the OSLK bit is not
invariant and will be made writable by the aforementioned change.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/asm/sysreg.h   |  5 +++++
 arch/arm64/kvm/sys_regs.c         | 31 ++++++++++++++++++++++++-------
 3 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5bc01e62c08a..cc1cc40d89f0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -171,6 +171,7 @@ enum vcpu_sysreg {
 	PAR_EL1,	/* Physical Address Register */
 	MDSCR_EL1,	/* Monitor Debug System Control Register */
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
+	OSLSR_EL1,	/* OS Lock Status Register */
 	DISR_EL1,	/* Deferred Interrupt Status Register */
 
 	/* Performance Monitors Registers */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 898bee0004ae..abc85eaa453d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -129,7 +129,12 @@
 #define SYS_DBGWCRn_EL1(n)		sys_reg(2, 0, 0, n, 7)
 #define SYS_MDRAR_EL1			sys_reg(2, 0, 1, 0, 0)
 #define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
+
 #define SYS_OSLSR_EL1			sys_reg(2, 0, 1, 1, 4)
+#define SYS_OSLSR_OSLM_MASK		(BIT(3) | BIT(0))
+#define SYS_OSLSR_OSLM_NI		0
+#define SYS_OSLSR_OSLM_IMPLEMENTED	BIT(3)
+
 #define SYS_OSDLR_EL1			sys_reg(2, 0, 1, 3, 4)
 #define SYS_DBGPRCR_EL1			sys_reg(2, 0, 1, 4, 4)
 #define SYS_DBGCLAIMSET_EL1		sys_reg(2, 0, 7, 8, 6)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 85208acd273d..b8286c31e01c 100644
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
@@ -1448,7 +1464,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1 },
+	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1,
+		SYS_OSLSR_OSLM_IMPLEMENTED, .set_user = set_oslsr_el1, },
 	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGCLAIMSET_EL1), trap_raz_wi },
@@ -1923,7 +1940,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
 	DBGBXVR(1),
 	/* DBGOSLSR */
-	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1 },
+	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
 	DBGBXVR(2),
 	DBGBXVR(3),
 	/* DBGOSDLR */
-- 
2.35.0.263.gb82422642f-goog

