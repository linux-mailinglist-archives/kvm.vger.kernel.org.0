Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D17DD714352
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbjE2Edx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbjE2E3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:29:48 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CC71BC9;
        Sun, 28 May 2023 21:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334348; x=1716870348;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FONhoiF/ieubAuvsEyMfYCuMeHnnA+eRKHu8LTc5jpM=;
  b=XyaF+cgqv+efJrR7yA55UHUa8V7M19Q04sM56o71JBpJA1paFpsJ4x8n
   oyzBd0XUEcc5Qinn6fw6PG7PZotsS88iigUCH7F0NglvVWDzJ1T4zLXnK
   KafAgCHxlwelMZ4lCppetE4vr5vN2M8A8oSvOmgzi6NC9UCPhZN2HNoAe
   ADZm/tE/jQnXBL8PJTpE1ixOk47aE9ijOxTrtE7oZCvLSgjw4HOxYfySK
   3YAAjPl1HXay81TmI875N2TRhv+FJ+BilJWwCdC+Chks3zIOAeRlqHrLa
   J7dTmLbpqRu5zq4CZ2GDsHuczVkxW1CKifxFaIorRtnOKgkYd/SMRKe03
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334966244"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334966244"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784516"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784516"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:35 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 083/113] KVM: TDX: Add a place holder to handle TDX VM exit
Date:   Sun, 28 May 2023 21:20:05 -0700
Message-Id: <e73817036a491491a3bfa3717e2f2e2a8793de67.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up handle_exit and handle_exit_irqoff methods and add a place holder
to handle VM exit.  Add helper functions to get exit info, exit
qualification, etc.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c    |  37 ++++++++++++-
 arch/x86/kvm/vmx/tdx.c     | 110 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  10 ++++
 3 files changed, 154 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 709a053427c4..1b7bcc67429d 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -239,6 +239,25 @@ static bool vt_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	return tdx_protected_apic_has_interrupt(vcpu);
 }
 
+static int vt_handle_exit(struct kvm_vcpu *vcpu,
+			     enum exit_fastpath_completion fastpath)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_handle_exit(vcpu, fastpath);
+
+	return vmx_handle_exit(vcpu, fastpath);
+}
+
+static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_handle_exit_irqoff(vcpu);
+		return;
+	}
+
+	vmx_handle_exit_irqoff(vcpu);
+}
+
 static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
@@ -445,6 +464,18 @@ static void vt_request_immediate_exit(struct kvm_vcpu *vcpu)
 	vmx_request_immediate_exit(vcpu);
 }
 
+static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+			u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_get_exit_info(vcpu, reason, info1, info2, intr_info,
+				  error_code);
+		return;
+	}
+
+	vmx_get_exit_info(vcpu, reason, info1, info2, intr_info, error_code);
+}
+
 static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	if (is_td_vcpu(vcpu))
@@ -541,7 +572,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.vcpu_pre_run = vt_vcpu_pre_run,
 	.vcpu_run = vt_vcpu_run,
-	.handle_exit = vmx_handle_exit,
+	.handle_exit = vt_handle_exit,
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
 	.update_emulated_instruction = vmx_update_emulated_instruction,
 	.set_interrupt_shadow = vt_set_interrupt_shadow,
@@ -576,7 +607,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_identity_map_addr = vmx_set_identity_map_addr,
 	.get_mt_mask = vt_get_mt_mask,
 
-	.get_exit_info = vmx_get_exit_info,
+	.get_exit_info = vt_get_exit_info,
 
 	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
 
@@ -590,7 +621,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.load_mmu_pgd = vt_load_mmu_pgd,
 
 	.check_intercept = vmx_check_intercept,
-	.handle_exit_irqoff = vmx_handle_exit_irqoff,
+	.handle_exit_irqoff = vt_handle_exit_irqoff,
 
 	.request_immediate_exit = vt_request_immediate_exit,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index bde10bfbff83..8fbf68f6bfcd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -87,6 +87,26 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
 }
 
+static __always_inline unsigned long tdexit_exit_qual(struct kvm_vcpu *vcpu)
+{
+	return kvm_rcx_read(vcpu);
+}
+
+static __always_inline unsigned long tdexit_ext_exit_qual(struct kvm_vcpu *vcpu)
+{
+	return kvm_rdx_read(vcpu);
+}
+
+static __always_inline unsigned long tdexit_gpa(struct kvm_vcpu *vcpu)
+{
+	return kvm_r8_read(vcpu);
+}
+
+static __always_inline unsigned long tdexit_intr_info(struct kvm_vcpu *vcpu)
+{
+	return kvm_r9_read(vcpu);
+}
+
 static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
 {
 	return tdx->tdvpr_pa;
@@ -721,6 +741,12 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 {
 	guest_state_enter_irqoff();
 	tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr_pa, vcpu->arch.regs, 0);
+	if ((u16)tdx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
+	    is_nmi(tdexit_intr_info(vcpu))) {
+		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
+		vmx_do_nmi_irqoff();
+		kvm_after_interrupt(vcpu);
+	}
 	guest_state_exit_irqoff();
 }
 
@@ -763,6 +789,25 @@ void tdx_inject_nmi(struct kvm_vcpu *vcpu)
 	td_management_write8(to_tdx(vcpu), TD_VCPU_PEND_NMI, 1);
 }
 
+void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u16 exit_reason = tdx->exit_reason.basic;
+
+	if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+		vmx_handle_external_interrupt_irqoff(vcpu,
+						     tdexit_intr_info(vcpu));
+	else if (exit_reason == EXIT_REASON_EXCEPTION_NMI)
+		vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
+}
+
+static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
+{
+	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+	vcpu->mmio_needed = 0;
+	return 0;
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
@@ -1089,6 +1134,71 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	__vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
 }
 
+int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
+{
+	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
+
+	/* See the comment of tdh_sept_seamcall(). */
+	if (unlikely(exit_reason.full == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)))
+		return 1;
+
+	/*
+	 * TDH.VP.ENTRY checks TD EPOCH which contend with TDH.MEM.TRACK and
+	 * vcpu TDH.VP.ENTER.
+	 */
+	if (unlikely(exit_reason.full == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_TD_EPOCH)))
+		return 1;
+
+	if (unlikely(exit_reason.full == TDX_SEAMCALL_UD)) {
+		kvm_spurious_fault();
+		/*
+		 * In the case of reboot or kexec, loop with TDH.VP.ENTER and
+		 * TDX_SEAMCALL_UD to avoid unnecessarily activity.
+		 */
+		return 1;
+	}
+
+	if (unlikely(exit_reason.non_recoverable || exit_reason.error)) {
+		if (unlikely(exit_reason.basic == EXIT_REASON_TRIPLE_FAULT))
+			return tdx_handle_triple_fault(vcpu);
+
+		kvm_pr_unimpl("TD exit 0x%llx, %d hkid 0x%x hkid pa 0x%llx\n",
+			      exit_reason.full, exit_reason.basic,
+			      to_kvm_tdx(vcpu->kvm)->hkid,
+			      set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid));
+		goto unhandled_exit;
+	}
+
+	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
+
+	switch (exit_reason.basic) {
+	default:
+		break;
+	}
+
+unhandled_exit:
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->run->internal.ndata = 2;
+	vcpu->run->internal.data[0] = exit_reason.full;
+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+	return 0;
+}
+
+void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	*reason = tdx->exit_reason.full;
+
+	*info1 = tdexit_exit_qual(vcpu);
+	*info2 = tdexit_ext_exit_qual(vcpu);
+
+	*intr_info = tdexit_intr_info(vcpu);
+	*error_code = 0;
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 881dad6b57af..7077ba54b304 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -156,11 +156,16 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu);
+void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu);
+int tdx_handle_exit(struct kvm_vcpu *vcpu,
+		enum exit_fastpath_completion fastpath);
 u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);
 void tdx_inject_nmi(struct kvm_vcpu *vcpu);
+void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -189,11 +194,16 @@ static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 static inline bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu) { return false; }
+static inline void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu) {}
+static inline int tdx_handle_exit(struct kvm_vcpu *vcpu,
+		enum exit_fastpath_completion fastpath) { return 0; }
 static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 					 int trig_mode, int vector) {}
 static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
+static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
+				     u64 *info2, u32 *intr_info, u32 *error_code) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.25.1

