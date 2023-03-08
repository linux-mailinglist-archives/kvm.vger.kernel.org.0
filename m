Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921E76AFEF4
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 07:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjCHGg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 01:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjCHGg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 01:36:27 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0BF9FBCD;
        Tue,  7 Mar 2023 22:36:25 -0800 (PST)
Received: by gandalf.ozlabs.org (Postfix, from userid 1003)
        id 4PWjJS1vqHz4xDq; Wed,  8 Mar 2023 17:36:24 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ozlabs.org;
        s=201707; t=1678257384;
        bh=n9I012yV3RIBQ7Uy0VNcPdIQyI03gj8SpBBjx68o6ao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pnTk4/Gqg0WAShNPxeYrCXCYpeq+fKdm//Ac7dwpWfWz+/Qr90l23A9uynefMUDvF
         qEN7V4no8QJPvJsUzjJOHY/xIr2oiKwPwoyzoPEZ7bbO9IbEN9ZXeRFhHIFpQxMNkX
         wBO45N5RcIDPa7ix4qXG9hl5ErvwCY+JTx3YvP59/UQDVNpl2Q1MADWbRBniCFeQMa
         mEUdFZKyDBrTOIyUmDlbPImDebYOxi/lv0zHb4Pgd2UPPy8PCxOGKqusvivSWLVAVg
         f7t34G4Lrkoo6NAC6gDalAaFfSImbEFmyYPYxpur82cP0g9+ZdNZ14bzbIpZUtDIOc
         UoOwjQH9nIYFA==
Date:   Wed, 8 Mar 2023 17:36:11 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     linuxppc-dev@ozlabs.org, kvm@vger.kernel.org
Cc:     Michael Neuling <mikey@neuling.org>,
        Nick Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Subject: [PATCH 3/3] powerpc/kvm: Enable prefixed instructions for HV KVM and
 disable for PR KVM
Message-ID: <ZAgs25dCmLrVkBdU@cleo>
References: <ZAgsR04beDcARCiw@cleo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAgsR04beDcARCiw@cleo>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we can read prefixed instructions from a HV KVM guest and
emulate prefixed load/store instructions to emulated MMIO locations,
we can add HFSCR_PREFIXED into the set of bits that are set in the
HFSCR for a HV KVM guest on POWER10, allowing the guest to use
prefixed instructions.

PR KVM has not yet been extended to handle prefixed instructions in
all situations where we might need to emulate them, so prevent the
guest from enabling prefixed instructions in the FSCR for now.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Tested-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/include/asm/reg.h       | 1 +
 arch/powerpc/kvm/book3s_hv.c         | 9 +++++++--
 arch/powerpc/kvm/book3s_pr.c         | 2 ++
 arch/powerpc/kvm/book3s_rmhandlers.S | 1 +
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 1e8b2e04e626..7434a3300d84 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -417,6 +417,7 @@
 #define   FSCR_DSCR	__MASK(FSCR_DSCR_LG)
 #define   FSCR_INTR_CAUSE (ASM_CONST(0xFF) << 56)	/* interrupt cause */
 #define SPRN_HFSCR	0xbe	/* HV=1 Facility Status & Control Register */
+#define   HFSCR_PREFIX	__MASK(FSCR_PREFIX_LG)
 #define   HFSCR_MSGP	__MASK(FSCR_MSGP_LG)
 #define   HFSCR_TAR	__MASK(FSCR_TAR_LG)
 #define   HFSCR_EBB	__MASK(FSCR_EBB_LG)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 0d17f4443021..c5b24ab90fb2 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2921,13 +2921,18 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 
 	/*
 	 * Set the default HFSCR for the guest from the host value.
-	 * This value is only used on POWER9.
-	 * On POWER9, we want to virtualize the doorbell facility, so we
+	 * This value is only used on POWER9 and later.
+	 * On >= POWER9, we want to virtualize the doorbell facility, so we
 	 * don't set the HFSCR_MSGP bit, and that causes those instructions
 	 * to trap and then we emulate them.
 	 */
 	vcpu->arch.hfscr = HFSCR_TAR | HFSCR_EBB | HFSCR_PM | HFSCR_BHRB |
 		HFSCR_DSCR | HFSCR_VECVSX | HFSCR_FP;
+
+	/* On POWER10 and later, allow prefixed instructions */
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		vcpu->arch.hfscr |= HFSCR_PREFIX;
+
 	if (cpu_has_feature(CPU_FTR_HVMODE)) {
 		vcpu->arch.hfscr &= mfspr(SPRN_HFSCR);
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 940ab010a471..fa010d92a8d2 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1044,6 +1044,8 @@ void kvmppc_set_fscr(struct kvm_vcpu *vcpu, u64 fscr)
 {
 	if (fscr & FSCR_SCV)
 		fscr &= ~FSCR_SCV; /* SCV must not be enabled */
+	/* Prohibit prefixed instructions for now */
+	fscr &= ~FSCR_PREFIX;
 	if ((vcpu->arch.fscr & FSCR_TAR) && !(fscr & FSCR_TAR)) {
 		/* TAR got dropped, drop it in shadow too */
 		kvmppc_giveup_fac(vcpu, FSCR_TAR_LG);
diff --git a/arch/powerpc/kvm/book3s_rmhandlers.S b/arch/powerpc/kvm/book3s_rmhandlers.S
index 03886ca24498..0a557ffca9fe 100644
--- a/arch/powerpc/kvm/book3s_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_rmhandlers.S
@@ -123,6 +123,7 @@ INTERRUPT_TRAMPOLINE	BOOK3S_INTERRUPT_ALTIVEC
 kvmppc_handler_skip_ins:
 
 	/* Patch the IP to the next instruction */
+	/* Note that prefixed instructions are disabled in PR KVM for now */
 	mfsrr0	r12
 	addi	r12, r12, 4
 	mtsrr0	r12
-- 
2.37.3

