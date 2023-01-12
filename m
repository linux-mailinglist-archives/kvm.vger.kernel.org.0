Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241C0667F4B
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbjALTa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240600AbjALT2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:28:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E831F558A
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:22:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A178BB82012
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6E0C433D2;
        Thu, 12 Jan 2023 19:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551374;
        bh=YbxxZ5lRfnwbbRG0VbaHGOSVQotbfIj6jGxL9LmQf7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7qUiG8aQCMsIVMxxzk7mgi99I3RqBAVkfp/KEJwwAZe8m/FRkXsNNHWq7ZYvrjuG
         UrLOozZNl4LkhICLlToMtRa0xEkXxztsjwPmO3bRUwKpk7NPypxohfwLnibBRFgyuG
         lwmRKgpaG0NSjZrakNfXXDhdLSSPlKanbWXHdlzEvLRGytLvGrYu1eBk1o+DkWii+t
         smRNH95d6BZEjOVkV7aHWWkBqK3iU6K9xXsPw9DWbv9NiL0v4cnrg64kYxh7ob5646
         KTPhSzo05nEmJehGb8PYbP2cSeH274vdprEJrV08wsh70v3TDoriZLALYMGKB+UivC
         NN+EkXKRYnOmA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG36z-001IWu-I0;
        Thu, 12 Jan 2023 19:19:41 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v7 17/68] KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor
Date:   Thu, 12 Jan 2023 19:18:36 +0000
Message-Id: <20230112191927.1814989-18-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can no longer blindly copy the VCPU's PSTATE into SPSR_EL2 and return
to the guest and vice versa when taking an exception to the hypervisor,
because we emulate virtual EL2 in EL1 and therefore have to translate
the mode field from EL2 to EL1 and vice versa.

This requires keeping track of the state we enter the guest, for which
we transiently use a dedicated flag.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h          |  2 ++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 19 ++++++++++++++++-
 arch/arm64/kvm/hyp/vhe/switch.c            | 24 ++++++++++++++++++++++
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1b585a4dd122..70eab7a6386b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -645,6 +645,8 @@ struct kvm_vcpu_arch {
 #define DEBUG_STATE_SAVE_SPE	__vcpu_single_flag(iflags, BIT(5))
 /* Save TRBE context if active  */
 #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
+/* vcpu running in HYP context */
+#define VCPU_HYP_CONTEXT	__vcpu_single_flag(iflags, BIT(7))
 
 /* SVE enabled for host EL0 */
 #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index fb6a5299771a..90d57fbf7e7f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -157,9 +157,26 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
 	write_sysreg_el1(ctxt_sys_reg(ctxt, SPSR_EL1),	SYS_SPSR);
 }
 
+/* Read the VCPU state's PSTATE, but translate (v)EL2 to EL1. */
+static inline u64 to_hw_pstate(const struct kvm_cpu_context *ctxt)
+{
+	u64 mode = ctxt->regs.pstate & (PSR_MODE_MASK | PSR_MODE32_BIT);
+
+	switch (mode) {
+	case PSR_MODE_EL2t:
+		mode = PSR_MODE_EL1t;
+		break;
+	case PSR_MODE_EL2h:
+		mode = PSR_MODE_EL1h;
+		break;
+	}
+
+	return (ctxt->regs.pstate & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
+}
+
 static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 {
-	u64 pstate = ctxt->regs.pstate;
+	u64 pstate = to_hw_pstate(ctxt);
 	u64 mode = pstate & PSR_AA32_MODE_MASK;
 
 	/*
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 81bf236d9c27..cd3f3117bf16 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -120,6 +120,25 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
 
 static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	/*
+	 * If we were in HYP context on entry, adjust the PSTATE view
+	 * so that the usual helpers work correctly.
+	 */
+	if (unlikely(vcpu_get_flag(vcpu, VCPU_HYP_CONTEXT))) {
+		u64 mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
+
+		switch (mode) {
+		case PSR_MODE_EL1t:
+			mode = PSR_MODE_EL2t;
+			break;
+		case PSR_MODE_EL1h:
+			mode = PSR_MODE_EL2h;
+			break;
+		}
+
+		*vcpu_cpsr(vcpu) &= ~(PSR_MODE_MASK | PSR_MODE32_BIT);
+		*vcpu_cpsr(vcpu) |= mode;
+	}
 }
 
 /* Switch to the guest for VHE systems running in EL2 */
@@ -154,6 +173,11 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
+	if (is_hyp_ctxt(vcpu))
+		vcpu_set_flag(vcpu, VCPU_HYP_CONTEXT);
+	else
+		vcpu_clear_flag(vcpu, VCPU_HYP_CONTEXT);
+
 	do {
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
-- 
2.34.1

