Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF70118E466
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 21:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgCUU0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 16:26:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:8930 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbgCUU0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Mar 2020 16:26:08 -0400
IronPort-SDR: ixA0IaHfS/Gwmjsb8pJoSroifekJiuXC1JLHBwIg/RJuYtgPhXZPbxY/JxQVpZiMHmpwoG96Yq
 daoes3Mm6j0g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 13:26:06 -0700
IronPort-SDR: 7nMX4cW89hRpqE+mVgmdq2zaghIxMCvXFhPSJl7oso41ilTWLax9IiQcvZNCm/H8pfdb85hFW8
 Ogz9Lt2pOqeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,289,1580803200"; 
   d="scan'208";a="280773543"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 21 Mar 2020 13:26:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/9] KVM: VMX: Move hardware_setup() definition below vmx_x86_ops
Date:   Sat, 21 Mar 2020 13:25:57 -0700
Message-Id: <20200321202603.19355-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200321202603.19355-1-sean.j.christopherson@intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move VMX's hardware_setup() below its vmx_x86_ops definition so that a
future patch can refactor hardware_setup() to modify vmx_x86_ops
directly instead of indirectly modifying the ops via the global
kvm_x86_ops.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 346 ++++++++++++++++++++---------------------
 1 file changed, 173 insertions(+), 173 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ffcdcc86f5b7..82dab775d520 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7652,179 +7652,6 @@ static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	return to_vmx(vcpu)->nested.vmxon;
 }
 
-static __init int hardware_setup(void)
-{
-	unsigned long host_bndcfgs;
-	struct desc_ptr dt;
-	int r, i, ept_lpage_level;
-
-	store_idt(&dt);
-	host_idt_base = dt.address;
-
-	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i)
-		kvm_define_shared_msr(i, vmx_msr_index[i]);
-
-	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
-		return -EIO;
-
-	if (boot_cpu_has(X86_FEATURE_NX))
-		kvm_enable_efer_bits(EFER_NX);
-
-	if (boot_cpu_has(X86_FEATURE_MPX)) {
-		rdmsrl(MSR_IA32_BNDCFGS, host_bndcfgs);
-		WARN_ONCE(host_bndcfgs, "KVM: BNDCFGS in host will be lost");
-	}
-
-	if (!cpu_has_vmx_mpx())
-		supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
-				    XFEATURE_MASK_BNDCSR);
-
-	if (!cpu_has_vmx_vpid() || !cpu_has_vmx_invvpid() ||
-	    !(cpu_has_vmx_invvpid_single() || cpu_has_vmx_invvpid_global()))
-		enable_vpid = 0;
-
-	if (!cpu_has_vmx_ept() ||
-	    !cpu_has_vmx_ept_4levels() ||
-	    !cpu_has_vmx_ept_mt_wb() ||
-	    !cpu_has_vmx_invept_global())
-		enable_ept = 0;
-
-	if (!cpu_has_vmx_ept_ad_bits() || !enable_ept)
-		enable_ept_ad_bits = 0;
-
-	if (!cpu_has_vmx_unrestricted_guest() || !enable_ept)
-		enable_unrestricted_guest = 0;
-
-	if (!cpu_has_vmx_flexpriority())
-		flexpriority_enabled = 0;
-
-	if (!cpu_has_virtual_nmis())
-		enable_vnmi = 0;
-
-	/*
-	 * set_apic_access_page_addr() is used to reload apic access
-	 * page upon invalidation.  No need to do anything if not
-	 * using the APIC_ACCESS_ADDR VMCS field.
-	 */
-	if (!flexpriority_enabled)
-		kvm_x86_ops->set_apic_access_page_addr = NULL;
-
-	if (!cpu_has_vmx_tpr_shadow())
-		kvm_x86_ops->update_cr8_intercept = NULL;
-
-#if IS_ENABLED(CONFIG_HYPERV)
-	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
-	    && enable_ept) {
-		kvm_x86_ops->tlb_remote_flush = hv_remote_flush_tlb;
-		kvm_x86_ops->tlb_remote_flush_with_range =
-				hv_remote_flush_tlb_with_range;
-	}
-#endif
-
-	if (!cpu_has_vmx_ple()) {
-		ple_gap = 0;
-		ple_window = 0;
-		ple_window_grow = 0;
-		ple_window_max = 0;
-		ple_window_shrink = 0;
-	}
-
-	if (!cpu_has_vmx_apicv()) {
-		enable_apicv = 0;
-		kvm_x86_ops->sync_pir_to_irr = NULL;
-	}
-
-	if (cpu_has_vmx_tsc_scaling()) {
-		kvm_has_tsc_control = true;
-		kvm_max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
-		kvm_tsc_scaling_ratio_frac_bits = 48;
-	}
-
-	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
-
-	if (enable_ept)
-		vmx_enable_tdp();
-
-	if (!enable_ept)
-		ept_lpage_level = 0;
-	else if (cpu_has_vmx_ept_1g_page())
-		ept_lpage_level = PT_PDPE_LEVEL;
-	else if (cpu_has_vmx_ept_2m_page())
-		ept_lpage_level = PT_DIRECTORY_LEVEL;
-	else
-		ept_lpage_level = PT_PAGE_TABLE_LEVEL;
-	kvm_configure_mmu(enable_ept, ept_lpage_level);
-
-	/*
-	 * Only enable PML when hardware supports PML feature, and both EPT
-	 * and EPT A/D bit features are enabled -- PML depends on them to work.
-	 */
-	if (!enable_ept || !enable_ept_ad_bits || !cpu_has_vmx_pml())
-		enable_pml = 0;
-
-	if (!enable_pml) {
-		kvm_x86_ops->slot_enable_log_dirty = NULL;
-		kvm_x86_ops->slot_disable_log_dirty = NULL;
-		kvm_x86_ops->flush_log_dirty = NULL;
-		kvm_x86_ops->enable_log_dirty_pt_masked = NULL;
-	}
-
-	if (!cpu_has_vmx_preemption_timer())
-		enable_preemption_timer = false;
-
-	if (enable_preemption_timer) {
-		u64 use_timer_freq = 5000ULL * 1000 * 1000;
-		u64 vmx_msr;
-
-		rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
-		cpu_preemption_timer_multi =
-			vmx_msr & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
-
-		if (tsc_khz)
-			use_timer_freq = (u64)tsc_khz * 1000;
-		use_timer_freq >>= cpu_preemption_timer_multi;
-
-		/*
-		 * KVM "disables" the preemption timer by setting it to its max
-		 * value.  Don't use the timer if it might cause spurious exits
-		 * at a rate faster than 0.1 Hz (of uninterrupted guest time).
-		 */
-		if (use_timer_freq > 0xffffffffu / 10)
-			enable_preemption_timer = false;
-	}
-
-	if (!enable_preemption_timer) {
-		kvm_x86_ops->set_hv_timer = NULL;
-		kvm_x86_ops->cancel_hv_timer = NULL;
-		kvm_x86_ops->request_immediate_exit = __kvm_request_immediate_exit;
-	}
-
-	kvm_set_posted_intr_wakeup_handler(wakeup_handler);
-
-	kvm_mce_cap_supported |= MCG_LMCE_P;
-
-	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
-		return -EINVAL;
-	if (!enable_ept || !cpu_has_vmx_intel_pt())
-		pt_mode = PT_MODE_SYSTEM;
-
-	if (nested) {
-		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
-					   vmx_capability.ept);
-
-		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
-		if (r)
-			return r;
-	}
-
-	vmx_set_cpu_caps();
-
-	r = alloc_kvm_area();
-	if (r)
-		nested_vmx_hardware_unsetup();
-	return r;
-}
-
 static __exit void hardware_unsetup(void)
 {
 	if (nested)
@@ -7978,6 +7805,179 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 };
 
+static __init int hardware_setup(void)
+{
+	unsigned long host_bndcfgs;
+	struct desc_ptr dt;
+	int r, i, ept_lpage_level;
+
+	store_idt(&dt);
+	host_idt_base = dt.address;
+
+	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i)
+		kvm_define_shared_msr(i, vmx_msr_index[i]);
+
+	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
+		return -EIO;
+
+	if (boot_cpu_has(X86_FEATURE_NX))
+		kvm_enable_efer_bits(EFER_NX);
+
+	if (boot_cpu_has(X86_FEATURE_MPX)) {
+		rdmsrl(MSR_IA32_BNDCFGS, host_bndcfgs);
+		WARN_ONCE(host_bndcfgs, "KVM: BNDCFGS in host will be lost");
+	}
+
+	if (!cpu_has_vmx_mpx())
+		supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
+				    XFEATURE_MASK_BNDCSR);
+
+	if (!cpu_has_vmx_vpid() || !cpu_has_vmx_invvpid() ||
+	    !(cpu_has_vmx_invvpid_single() || cpu_has_vmx_invvpid_global()))
+		enable_vpid = 0;
+
+	if (!cpu_has_vmx_ept() ||
+	    !cpu_has_vmx_ept_4levels() ||
+	    !cpu_has_vmx_ept_mt_wb() ||
+	    !cpu_has_vmx_invept_global())
+		enable_ept = 0;
+
+	if (!cpu_has_vmx_ept_ad_bits() || !enable_ept)
+		enable_ept_ad_bits = 0;
+
+	if (!cpu_has_vmx_unrestricted_guest() || !enable_ept)
+		enable_unrestricted_guest = 0;
+
+	if (!cpu_has_vmx_flexpriority())
+		flexpriority_enabled = 0;
+
+	if (!cpu_has_virtual_nmis())
+		enable_vnmi = 0;
+
+	/*
+	 * set_apic_access_page_addr() is used to reload apic access
+	 * page upon invalidation.  No need to do anything if not
+	 * using the APIC_ACCESS_ADDR VMCS field.
+	 */
+	if (!flexpriority_enabled)
+		kvm_x86_ops->set_apic_access_page_addr = NULL;
+
+	if (!cpu_has_vmx_tpr_shadow())
+		kvm_x86_ops->update_cr8_intercept = NULL;
+
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
+	    && enable_ept) {
+		kvm_x86_ops->tlb_remote_flush = hv_remote_flush_tlb;
+		kvm_x86_ops->tlb_remote_flush_with_range =
+				hv_remote_flush_tlb_with_range;
+	}
+#endif
+
+	if (!cpu_has_vmx_ple()) {
+		ple_gap = 0;
+		ple_window = 0;
+		ple_window_grow = 0;
+		ple_window_max = 0;
+		ple_window_shrink = 0;
+	}
+
+	if (!cpu_has_vmx_apicv()) {
+		enable_apicv = 0;
+		kvm_x86_ops->sync_pir_to_irr = NULL;
+	}
+
+	if (cpu_has_vmx_tsc_scaling()) {
+		kvm_has_tsc_control = true;
+		kvm_max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
+		kvm_tsc_scaling_ratio_frac_bits = 48;
+	}
+
+	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
+
+	if (enable_ept)
+		vmx_enable_tdp();
+
+	if (!enable_ept)
+		ept_lpage_level = 0;
+	else if (cpu_has_vmx_ept_1g_page())
+		ept_lpage_level = PT_PDPE_LEVEL;
+	else if (cpu_has_vmx_ept_2m_page())
+		ept_lpage_level = PT_DIRECTORY_LEVEL;
+	else
+		ept_lpage_level = PT_PAGE_TABLE_LEVEL;
+	kvm_configure_mmu(enable_ept, ept_lpage_level);
+
+	/*
+	 * Only enable PML when hardware supports PML feature, and both EPT
+	 * and EPT A/D bit features are enabled -- PML depends on them to work.
+	 */
+	if (!enable_ept || !enable_ept_ad_bits || !cpu_has_vmx_pml())
+		enable_pml = 0;
+
+	if (!enable_pml) {
+		kvm_x86_ops->slot_enable_log_dirty = NULL;
+		kvm_x86_ops->slot_disable_log_dirty = NULL;
+		kvm_x86_ops->flush_log_dirty = NULL;
+		kvm_x86_ops->enable_log_dirty_pt_masked = NULL;
+	}
+
+	if (!cpu_has_vmx_preemption_timer())
+		enable_preemption_timer = false;
+
+	if (enable_preemption_timer) {
+		u64 use_timer_freq = 5000ULL * 1000 * 1000;
+		u64 vmx_msr;
+
+		rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
+		cpu_preemption_timer_multi =
+			vmx_msr & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
+
+		if (tsc_khz)
+			use_timer_freq = (u64)tsc_khz * 1000;
+		use_timer_freq >>= cpu_preemption_timer_multi;
+
+		/*
+		 * KVM "disables" the preemption timer by setting it to its max
+		 * value.  Don't use the timer if it might cause spurious exits
+		 * at a rate faster than 0.1 Hz (of uninterrupted guest time).
+		 */
+		if (use_timer_freq > 0xffffffffu / 10)
+			enable_preemption_timer = false;
+	}
+
+	if (!enable_preemption_timer) {
+		kvm_x86_ops->set_hv_timer = NULL;
+		kvm_x86_ops->cancel_hv_timer = NULL;
+		kvm_x86_ops->request_immediate_exit = __kvm_request_immediate_exit;
+	}
+
+	kvm_set_posted_intr_wakeup_handler(wakeup_handler);
+
+	kvm_mce_cap_supported |= MCG_LMCE_P;
+
+	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
+		return -EINVAL;
+	if (!enable_ept || !cpu_has_vmx_intel_pt())
+		pt_mode = PT_MODE_SYSTEM;
+
+	if (nested) {
+		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
+					   vmx_capability.ept);
+
+		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
+		if (r)
+			return r;
+	}
+
+	vmx_set_cpu_caps();
+
+	r = alloc_kvm_area();
+	if (r)
+		nested_vmx_hardware_unsetup();
+	return r;
+}
+
 static struct kvm_x86_init_ops vmx_init_ops __initdata = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
-- 
2.24.1

