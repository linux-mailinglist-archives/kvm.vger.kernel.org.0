Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D55528D855
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 04:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgJNCKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 22:10:44 -0400
Received: from mga06.intel.com ([134.134.136.31]:51139 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729057AbgJNCJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 22:09:51 -0400
IronPort-SDR: q30WKea/oVQwzhoGV8YNGVV9WVj1KfujdcI7EBbhSlzgklJpvPsWxAfhkzE4r3BFM1db1dPjWi
 tnkvihH/kTSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9773"; a="227659792"
X-IronPort-AV: E=Sophos;i="5.77,373,1596524400"; 
   d="scan'208";a="227659792"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 19:09:50 -0700
IronPort-SDR: K/c8ZMqpDYwp2/U0n8XulX8u5viSg2vDqEwnkdEAYPWsNwXIWrgINepuJcU+oSkc4QkPGnufl+
 7q1tURuhi2CA==
X-IronPort-AV: E=Sophos;i="5.77,373,1596524400"; 
   d="scan'208";a="530645115"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 19:09:47 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v2 2/7] KVM: VMX: Expose IA32_PKRS MSR
Date:   Wed, 14 Oct 2020 10:11:51 +0800
Message-Id: <20201014021157.18022-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201014021157.18022-1-chenyi.qiang@intel.com>
References: <20201014021157.18022-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protection Keys for Supervisor Pages (PKS) uses IA32_PKRS MSR (PKRS) at
index 0x6E1 to allow software to manage supervisor protection key
rights. For performance consideration, PKRS intercept will be disabled
so that the guest can access the PKRS without VM exits.
PKS introduces dedicated control fields in VMCS to switch PKRS, which
only does the retore part. In addition, every VM exit saves PKRS into
the guest-state area in VMCS, while VM enter won't save the host value
due to the expectation that the host won't change the MSR often. Update
the host's value in VMCS manually if the MSR has been changed by the
kernel since the last time the VMCS was run.
The function get_current_pkrs() in arch/x86/mm/pkeys.c exports the
per-cpu variable pkrs_cache to avoid frequent rdmsr of PKRS.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/pkeys.h    |  1 +
 arch/x86/kvm/vmx/capabilities.h |  6 +++
 arch/x86/kvm/vmx/nested.c       |  1 +
 arch/x86/kvm/vmx/vmcs.h         |  1 +
 arch/x86/kvm/vmx/vmx.c          | 66 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.h              |  6 +++
 arch/x86/mm/pkeys.c             |  6 +++
 include/linux/pkeys.h           |  4 ++
 8 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pkeys.h b/arch/x86/include/asm/pkeys.h
index cae0153a5480..2e666dd2ea31 100644
--- a/arch/x86/include/asm/pkeys.h
+++ b/arch/x86/include/asm/pkeys.h
@@ -142,6 +142,7 @@ u32 update_pkey_val(u32 pk_reg, int pkey, unsigned int flags);
 #ifdef CONFIG_ARCH_HAS_SUPERVISOR_PKEYS
 int pks_key_alloc(const char *const pkey_user);
 void pks_key_free(int pkey);
+u32 get_current_pkrs(void);
 
 void pks_mknoaccess(int pkey, bool global);
 void pks_mkread(int pkey, bool global);
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4bbd8b448d22..7099e3105f48 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -103,6 +103,12 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
 }
 
+static inline bool cpu_has_load_ia32_pkrs(void)
+{
+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PKRS) &&
+	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PKRS);
+}
+
 static inline bool cpu_has_vmx_mpx(void)
 {
 	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_BNDCFGS) &&
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1bb6b31eb646..14f56e8dd060 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -294,6 +294,7 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
 	dest->ds_sel = src->ds_sel;
 	dest->es_sel = src->es_sel;
 #endif
+	dest->pkrs = src->pkrs;
 }
 
 static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 7a3675fddec2..39ec3d0c844b 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -40,6 +40,7 @@ struct vmcs_host_state {
 #ifdef CONFIG_X86_64
 	u16           ds_sel, es_sel;
 #endif
+	u32           pkrs;
 };
 
 struct vmcs_controls_shadow {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 96979c09ebd1..e5da5dbe19d4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1147,6 +1147,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 #endif
 	unsigned long fs_base, gs_base;
 	u16 fs_sel, gs_sel;
+	u32 host_pkrs;
 	int i;
 
 	vmx->req_immediate_exit = false;
@@ -1179,6 +1180,20 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 */
 	host_state->ldt_sel = kvm_read_ldt();
 
+	/*
+	 * Update the host pkrs vmcs field before vcpu runs.
+	 * The setting of VM_EXIT_LOAD_IA32_PKRS can ensure
+	 * kvm_cpu_cap_has(X86_FEATURE_PKS) &&
+	 * guest_cpuid_has(vcpu, X86_FEATURE_VMX).
+	 */
+	if (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_IA32_PKRS) {
+		host_pkrs = get_current_pkrs();
+		if (unlikely(host_pkrs != host_state->pkrs)) {
+			vmcs_write64(HOST_IA32_PKRS, host_pkrs);
+			host_state->pkrs = host_pkrs;
+		}
+	}
+
 #ifdef CONFIG_X86_64
 	savesegment(ds, host_state->ds_sel);
 	savesegment(es, host_state->es_sel);
@@ -1967,6 +1982,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
+	case MSR_IA32_PKRS:
+		if (!kvm_cpu_cap_has(X86_FEATURE_PKS) ||
+		    (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_PKS)))
+			return 1;
+		msr_info->data = vmcs_read64(GUEST_IA32_PKRS);
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
@@ -2237,6 +2259,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_IA32_PKRS:
+		if (!kvm_pkrs_valid(data))
+			return 1;
+		if (!kvm_cpu_cap_has(X86_FEATURE_PKS) ||
+		    (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_PKS)))
+			return 1;
+		vmcs_write64(GUEST_IA32_PKRS, data);
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
@@ -2526,7 +2557,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_LOAD_IA32_PKRS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2550,7 +2582,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_IA32_PKRS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -5898,6 +5931,8 @@ void dump_vmcs(void)
 		       vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL));
 	if (vmentry_ctl & VM_ENTRY_LOAD_BNDCFGS)
 		pr_err("BndCfgS = 0x%016llx\n", vmcs_read64(GUEST_BNDCFGS));
+	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_PKRS)
+		pr_err("PKRS = 0x%016llx\n", vmcs_read64(GUEST_IA32_PKRS));
 	pr_err("Interruptibility = %08x  ActivityState = %08x\n",
 	       vmcs_read32(GUEST_INTERRUPTIBILITY_INFO),
 	       vmcs_read32(GUEST_ACTIVITY_STATE));
@@ -5933,6 +5968,8 @@ void dump_vmcs(void)
 	    vmexit_ctl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
 		pr_err("PerfGlobCtl = 0x%016llx\n",
 		       vmcs_read64(HOST_IA32_PERF_GLOBAL_CTRL));
+	if (vmexit_ctl & VM_EXIT_LOAD_IA32_PKRS)
+		pr_err("PKRS = 0x%016llx\n", vmcs_read64(HOST_IA32_PKRS));
 
 	pr_err("*** Control State ***\n");
 	pr_err("PinBased=%08x CPUBased=%08x SecondaryExec=%08x\n",
@@ -7312,6 +7349,26 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
+static void vmx_update_pkrs_cfg(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
+	bool pks_supported = guest_cpuid_has(vcpu, X86_FEATURE_PKS);
+
+	/*
+	 * set intercept for PKRS when the guest doesn't support pks
+	 */
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PKRS, MSR_TYPE_RW, !pks_supported);
+
+	if (pks_supported) {
+		vm_entry_controls_setbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
+		vm_exit_controls_setbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
+	} else {
+		vm_entry_controls_clearbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
+		vm_exit_controls_clearbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
+	}
+}
+
 static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7333,6 +7390,11 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			~(FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
 			  FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX);
 
+	if (kvm_cpu_cap_has(X86_FEATURE_PKS))
+		vmx_update_pkrs_cfg(vcpu);
+	else
+		guest_cpuid_clear(vcpu, X86_FEATURE_PKS);
+
 	if (nested_vmx_allowed(vcpu)) {
 		nested_vmx_cr_fixed1_bits_update(vcpu);
 		nested_vmx_entry_exit_ctls_update(vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 995ab696dcf0..193fdb514db5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -367,6 +367,12 @@ static inline bool kvm_dr6_valid(u64 data)
 	return !(data >> 32);
 }
 
+static inline bool kvm_pkrs_valid(u64 data)
+{
+	/* bit[63,32] must be zero */
+	return !(data >> 32);
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index aeb17a28719d..2921a835bd3c 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -441,6 +441,12 @@ void pks_key_free(int pkey)
 }
 EXPORT_SYMBOL_GPL(pks_key_free);
 
+u32 get_current_pkrs(void)
+{
+	return this_cpu_read(pkrs_cache);
+}
+EXPORT_SYMBOL_GPL(get_current_pkrs);
+
 static int pks_keys_allocated_show(struct seq_file *m, void *p)
 {
 	int i;
diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
index 8f3bfec83949..239ba84bdf9a 100644
--- a/include/linux/pkeys.h
+++ b/include/linux/pkeys.h
@@ -69,6 +69,10 @@ static inline void pks_mkrdwr(int pkey, bool global)
 {
 	WARN_ON_ONCE(1);
 }
+static inline u32 get_current_pkrs(void)
+{
+	return 0;
+}
 #endif /* ! CONFIG_ARCH_HAS_SUPERVISOR_PKEYS */
 
 #endif /* _LINUX_PKEYS_H */
-- 
2.17.1

