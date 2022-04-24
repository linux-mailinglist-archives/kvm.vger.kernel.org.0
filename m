Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363AB50D106
	for <lists+kvm@lfdr.de>; Sun, 24 Apr 2022 12:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239037AbiDXKTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 06:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239006AbiDXKTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 06:19:01 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25580140A5;
        Sun, 24 Apr 2022 03:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650795361; x=1682331361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ay5OMiAFRmre8MjfAZWNoQ/Mn5N9l/Abp3RB2vmddBI=;
  b=HE85WumgARlpkn5UQXFPx3BokJ4bUbDSaf9iMkWuyfuDTUuybZn8c3/e
   wygPR7/MOZ4x5XQ80RWb66dTTcF1zLj5dYxBM2fx7yh2PwGPNl4alibbv
   I+EJIXVbQY1HKDgBrsGAt8iRMbLrDIbvKIVow2c2Kv0K2qdsWNSBOHg6c
   LxN94Pq2x6EeOixrJr6LrqUOjiB7zLD2zc/+zB2DJne+Xx2/NXn5KtKIT
   dYwTBc6iooewZWMMdE3wEmYP6dWvjmORAEbj6qS54PA+KDfaGXKiO30nF
   iVlKu7B71M+KgPAPbFDghCw7/OJ/j+5XZsAbjMGp9/NU9vE0ZJcCRJv38
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="264813944"
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="264813944"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:15:59 -0700
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="616086713"
Received: from 984fee00be24.jf.intel.com ([10.165.54.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:15:59 -0700
From:   Lei Wang <lei4.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     lei4.wang@intel.com, chenyi.qiang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 3/8] KVM: X86: Expose IA32_PKRS MSR
Date:   Sun, 24 Apr 2022 03:15:52 -0700
Message-Id: <20220424101557.134102-4-lei4.wang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220424101557.134102-1-lei4.wang@intel.com>
References: <20220424101557.134102-1-lei4.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chenyi Qiang <chenyi.qiang@intel.com>

Protection Key for Superviosr Pages (PKS) uses IA32_PKRS MSR (PKRS) at
index 0x6E1 to allow software to manage superviosr key rights, i.e. it
can enforce additional permissions checks besides normal paging
protections via a MSR update without TLB flushes when permissions
change.

For performance consideration, PKRS intercept in KVM will be disabled
when PKS is supported in guest so that PKRS can be accessed without VM
exit.

PKS introduces dedicated control fields in VMCS to switch PKRS, which
only does the retore part. In addition, every VM exit saves PKRS into
the guest-state area in VMCS, while VM enter won't save the host value
due to the expectation that the host won't change the MSR often. Update
the host's value in VMCS manually if the MSR has been changed by the
kernel since the last time the VMCS was run.

Introduce a function get_current_pkrs() in arch/x86/mm/pkeys.c to export
the per-cpu variable pkrs_cache to avoid frequent rdmsr of PKRS.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Co-developed-by: Lei Wang <lei4.wang@intel.com>
Signed-off-by: Lei Wang <lei4.wang@intel.com>
---
 arch/x86/kvm/vmx/vmcs.h |  1 +
 arch/x86/kvm/vmx/vmx.c  | 63 +++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.h  |  9 +++++-
 arch/x86/kvm/x86.c      |  9 +++++-
 arch/x86/kvm/x86.h      |  6 ++++
 arch/x86/mm/pkeys.c     |  6 ++++
 include/linux/pks.h     |  7 +++++
 7 files changed, 94 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index e325c290a816..ee37741b2b9d 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -42,6 +42,7 @@ struct vmcs_host_state {
 #ifdef CONFIG_X86_64
 	u16           ds_sel, es_sel;
 #endif
+	u32           pkrs;
 };
 
 struct vmcs_controls_shadow {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 395b2deb76aa..9d0588e85410 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -28,6 +28,7 @@
 #include <linux/tboot.h>
 #include <linux/trace_events.h>
 #include <linux/entry-kvm.h>
+#include <linux/pkeys.h>
 
 #include <asm/apic.h>
 #include <asm/asm.h>
@@ -172,6 +173,7 @@ static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_CORE_C3_RESIDENCY,
 	MSR_CORE_C6_RESIDENCY,
 	MSR_CORE_C7_RESIDENCY,
+	MSR_IA32_PKRS,
 };
 
 /*
@@ -1111,6 +1113,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 #endif
 	unsigned long fs_base, gs_base;
 	u16 fs_sel, gs_sel;
+	u32 host_pkrs;
 	int i;
 
 	vmx->req_immediate_exit = false;
@@ -1146,6 +1149,17 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 */
 	host_state->ldt_sel = kvm_read_ldt();
 
+	/*
+	 * Update the host pkrs vmcs field before vcpu runs.
+	 * The setting of VM_EXIT_LOAD_IA32_PKRS can ensure
+	 * kvm_cpu_cap_has(X86_FEATURE_PKS) &&
+	 * guest_cpuid_has(vcpu, X86_FEATURE_PKS)
+	 */
+	if (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_IA32_PKRS) {
+		host_pkrs = get_current_pkrs();
+		vmx_set_host_pkrs(host_state, host_pkrs);
+	}
+
 #ifdef CONFIG_X86_64
 	savesegment(ds, host_state->ds_sel);
 	savesegment(es, host_state->es_sel);
@@ -1901,6 +1915,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
+	case MSR_IA32_PKRS:
+		if (!kvm_cpu_cap_has(X86_FEATURE_PKS) ||
+		    (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_PKS)))
+			return 1;
+		msr_info->data = kvm_read_pkrs(vcpu);
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2242,7 +2263,17 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
-
+	case MSR_IA32_PKRS:
+		if (!kvm_pkrs_valid(data))
+			return 1;
+		if (!kvm_cpu_cap_has(X86_FEATURE_PKS) ||
+		    (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_PKS)))
+			return 1;
+		vcpu->arch.pkrs = data;
+		kvm_register_mark_available(vcpu, VCPU_EXREG_PKRS);
+		vmcs_write64(GUEST_IA32_PKRS, data);
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_index);
@@ -2533,7 +2564,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_LOAD_IA32_PKRS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2557,7 +2589,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_IA32_PKRS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -4166,7 +4199,8 @@ static u32 vmx_vmentry_ctrl(void)
 				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
 	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
 	return vmentry_ctrl &
-		~(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | VM_ENTRY_LOAD_IA32_EFER);
+		~(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | VM_ENTRY_LOAD_IA32_EFER |
+		  VM_ENTRY_LOAD_IA32_PKRS);
 }
 
 static u32 vmx_vmexit_ctrl(void)
@@ -4178,7 +4212,8 @@ static u32 vmx_vmexit_ctrl(void)
 				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
 	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
 	return vmexit_ctrl &
-		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
+		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER |
+		  VM_EXIT_LOAD_IA32_PKRS);
 }
 
 static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
@@ -5923,6 +5958,8 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 		       vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL));
 	if (vmentry_ctl & VM_ENTRY_LOAD_BNDCFGS)
 		pr_err("BndCfgS = 0x%016llx\n", vmcs_read64(GUEST_BNDCFGS));
+	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_PKRS)
+		pr_err("PKRS = 0x%016llx\n", vmcs_read64(GUEST_IA32_PKRS));
 	pr_err("Interruptibility = %08x  ActivityState = %08x\n",
 	       vmcs_read32(GUEST_INTERRUPTIBILITY_INFO),
 	       vmcs_read32(GUEST_ACTIVITY_STATE));
@@ -5964,6 +6001,8 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 		       vmcs_read64(HOST_IA32_PERF_GLOBAL_CTRL));
 	if (vmcs_read32(VM_EXIT_MSR_LOAD_COUNT) > 0)
 		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
+	if (vmexit_ctl & VM_EXIT_LOAD_IA32_PKRS)
+		pr_err("PKRS = 0x%016llx\n", vmcs_read64(HOST_IA32_PKRS));
 
 	pr_err("*** Control State ***\n");
 	pr_err("PinBased=%08x CPUBased=%08x SecondaryExec=%08x\n",
@@ -7406,6 +7445,20 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_PKS)) {
+		if (guest_cpuid_has(vcpu, X86_FEATURE_PKS)) {
+			vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PKRS, MSR_TYPE_RW);
+
+			vm_entry_controls_setbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
+			vm_exit_controls_setbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
+		} else {
+			vmx_enable_intercept_for_msr(vcpu, MSR_IA32_PKRS, MSR_TYPE_RW);
+
+			vm_entry_controls_clearbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
+			vm_exit_controls_clearbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
+		}
+	}
 }
 
 static __init void vmx_set_cpu_caps(void)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 661df9584b12..91723a226bf3 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -352,7 +352,7 @@ struct vcpu_vmx {
 	struct lbr_desc lbr_desc;
 
 	/* Save desired MSR intercept (read: pass-through) state */
-#define MAX_POSSIBLE_PASSTHROUGH_MSRS	15
+#define MAX_POSSIBLE_PASSTHROUGH_MSRS	16
 	struct {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
@@ -580,4 +580,11 @@ static inline int vmx_get_instr_info_reg2(u32 vmx_instr_info)
 	return (vmx_instr_info >> 28) & 0xf;
 }
 
+static inline void vmx_set_host_pkrs(struct vmcs_host_state *host, u32 pkrs){
+	if (unlikely(pkrs != host->pkrs)) {
+		vmcs_write64(HOST_IA32_PKRS, pkrs);
+		host->pkrs = pkrs;
+	}
+}
+
 #endif /* __KVM_X86_VMX_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 547ba00ef64f..d784bf3a4b3e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1396,7 +1396,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
 	MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
 	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
-	MSR_IA32_UMWAIT_CONTROL,
+	MSR_IA32_UMWAIT_CONTROL, MSR_IA32_PKRS,
 
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
 	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
@@ -6638,6 +6638,10 @@ static void kvm_init_msr_list(void)
 				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
 				continue;
 			break;
+		case MSR_IA32_PKRS:
+			if (!kvm_cpu_cap_has(X86_FEATURE_PKS))
+				continue;
+			break;
 		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
 			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
@@ -11410,6 +11414,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	kvm_rip_write(vcpu, 0xfff0);
 
+	if (!init_event && kvm_cpu_cap_has(X86_FEATURE_PKS))
+		__kvm_set_msr(vcpu, MSR_IA32_PKRS, 0, true);
+
 	vcpu->arch.cr3 = 0;
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 588792f00334..7610f0d40b0f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -404,6 +404,12 @@ static inline void kvm_machine_check(void)
 #endif
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
index 74ba51b9853b..bd75af62b685 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -495,4 +495,10 @@ void pks_update_exception(struct pt_regs *regs, u8 pkey, u8 protection)
 }
 EXPORT_SYMBOL_GPL(pks_update_exception);
 
+u32 get_current_pkrs(void)
+{
+	return this_cpu_read(pkrs_cache);
+}
+EXPORT_SYMBOL_GPL(get_current_pkrs);
+
 #endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
diff --git a/include/linux/pks.h b/include/linux/pks.h
index ce8eea81f208..0a71f8f4055d 100644
--- a/include/linux/pks.h
+++ b/include/linux/pks.h
@@ -53,6 +53,8 @@ static inline void pks_set_readwrite(u8 pkey)
 typedef bool (*pks_key_callback)(struct pt_regs *regs, unsigned long address,
 				 bool write);
 
+u32 get_current_pkrs(void);
+
 #else /* !CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
 static inline bool pks_available(void)
@@ -68,6 +70,11 @@ static inline void pks_update_exception(struct pt_regs *regs,
 					u8 protection)
 { }
 
+static inline u32 get_current_pkrs(void)
+{
+	return 0;
+}
+
 #endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
 #ifdef CONFIG_PKS_TEST
-- 
2.25.1

