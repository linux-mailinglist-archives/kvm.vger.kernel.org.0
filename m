Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D5C327B3C
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 10:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbhCAJw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 04:52:28 -0500
Received: from mga05.intel.com ([192.55.52.43]:62391 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234257AbhCAJsH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 04:48:07 -0500
IronPort-SDR: lv4DVmI3UWkDDlcnXPBBGJrEp5c5AZ20gpP/Kix08E04LPLhvja7obMiZLZJqOoFNy89KIqOIE
 dWvCBzG765rQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="271409727"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="271409727"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 01:46:55 -0800
IronPort-SDR: NzZDQFvYfOW01waGPAYA0iCvXUkEtTdJKVb6Kd0sw/2BtFO626gH39dovdPZR1wmbciPWkzR/Q
 lWfyf5+wHMUg==
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="599267719"
Received: from jscomeax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.139.76])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 01:46:51 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 24/25] KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC
Date:   Mon,  1 Mar 2021 22:45:57 +1300
Message-Id: <b9a77bf6f924026308a088bc3426b9d252ab383b.1614590788.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614590788.git.kai.huang@intel.com>
References: <cover.1614590788.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Enable SGX virtualization now that KVM has the VM-Exit handlers needed
to trap-and-execute ENCLS to ensure correctness and/or enforce the CPU
model exposed to the guest.  Add a KVM module param, "sgx", to allow an
admin to disable SGX virtualization independent of the kernel.

When supported in hardware and the kernel, advertise SGX1, SGX2 and SGX
LC to userspace via CPUID and wire up the ENCLS_EXITING bitmap based on
the guest's SGX capabilities, i.e. to allow ENCLS to be executed in an
SGX-enabled guest.  With the exception of the provision key, all SGX
attribute bits may be exposed to the guest.  Guest access to the
provision key, which is controlled via securityfs, will be added in a
future patch.

Note, KVM does not yet support exposing ENCLS_C leafs or ENCLV leafs.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/cpuid.c      | 57 +++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/nested.c | 26 +++++++++++--
 arch/x86/kvm/vmx/nested.h |  5 +++
 arch/x86/kvm/vmx/sgx.c    | 80 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/sgx.h    | 13 +++++++
 arch/x86/kvm/vmx/vmcs12.c |  1 +
 arch/x86/kvm/vmx/vmcs12.h |  4 +-
 arch/x86/kvm/vmx/vmx.c    | 35 ++++++++++++++++-
 8 files changed, 212 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a0e7be9ed449..a0d45607b702 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -18,6 +18,7 @@
 #include <asm/processor.h>
 #include <asm/user.h>
 #include <asm/fpu/xstate.h>
+#include <asm/sgx.h>
 #include "cpuid.h"
 #include "lapic.h"
 #include "mmu.h"
@@ -171,6 +172,21 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vcpu->arch.guest_supported_xcr0 =
 			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
 
+	/*
+	 * Bits 127:0 of the allowed SECS.ATTRIBUTES (CPUID.0x12.0x1) enumerate
+	 * the supported XSAVE Feature Request Mask (XFRM), i.e. the enclave's
+	 * requested XCR0 value.  The enclave's XFRM must be a subset of XCRO
+	 * at the time of EENTER, thus adjust the allowed XFRM by the guest's
+	 * supported XCR0.  Similar to XCR0 handling, FP and SSE are forced to
+	 * '1' even on CPUs that don't support XSAVE.
+	 */
+	best = kvm_find_cpuid_entry(vcpu, 0x12, 0x1);
+	if (best) {
+		best->ecx &= vcpu->arch.guest_supported_xcr0 & 0xffffffff;
+		best->edx &= vcpu->arch.guest_supported_xcr0 >> 32;
+		best->ecx |= XFEATURE_MASK_FPSSE;
+	}
+
 	kvm_update_pv_runtime(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
@@ -429,7 +445,7 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_mask(CPUID_7_0_EBX,
-		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
+		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
 		F(BMI2) | F(ERMS) | F(INVPCID) | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
 		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
 		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
@@ -440,7 +456,8 @@ void kvm_set_cpu_caps(void)
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
+		F(SGX_LC)
 	);
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & F(LA57))
@@ -479,6 +496,10 @@ void kvm_set_cpu_caps(void)
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES)
 	);
 
+	kvm_cpu_cap_init(CPUID_12_EAX,
+		SF(SGX1) | SF(SGX2)
+	);
+
 	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
 		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
@@ -800,6 +821,38 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->edx = 0;
 		}
 		break;
+	case 0x12:
+		/* Intel SGX */
+		if (!kvm_cpu_cap_has(X86_FEATURE_SGX)) {
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			break;
+		}
+
+		/*
+		 * Index 0: Sub-features, MISCSELECT (a.k.a extended features)
+		 * and max enclave sizes.   The SGX sub-features and MISCSELECT
+		 * are restricted by kernel and KVM capabilities (like most
+		 * feature flags), while enclave size is unrestricted.
+		 */
+		cpuid_entry_override(entry, CPUID_12_EAX);
+		entry->ebx &= SGX_MISC_EXINFO;
+
+		entry = do_host_cpuid(array, function, 1);
+		if (!entry)
+			goto out;
+
+		/*
+		 * Index 1: SECS.ATTRIBUTES.  ATTRIBUTES are restricted a la
+		 * feature flags.  Advertise all supported flags, including
+		 * privileged attributes that require explicit opt-in from
+		 * userspace.  ATTRIBUTES.XFRM is not adjusted as userspace is
+		 * expected to derive it from supported XCR0.
+		 */
+		entry->eax &= SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT |
+			      /* PROVISIONKEY | */ SGX_ATTR_EINITTOKENKEY |
+			      SGX_ATTR_KSS;
+		entry->ebx &= 0;
+		break;
 	/* Intel PT */
 	case 0x14:
 		if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT)) {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 28848e9f70e2..ba8b7755cd12 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -11,6 +11,7 @@
 #include "mmu.h"
 #include "nested.h"
 #include "pmu.h"
+#include "sgx.h"
 #include "trace.h"
 #include "vmx.h"
 #include "x86.h"
@@ -2306,6 +2307,9 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_UNRESTRICTED_GUEST))
 		    exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
 
+		if (exec_control & SECONDARY_EXEC_ENCLS_EXITING)
+			vmx_write_encls_bitmap(&vmx->vcpu, vmcs12);
+
 		secondary_exec_controls_set(vmx, exec_control);
 	}
 
@@ -5707,6 +5711,20 @@ static bool nested_vmx_exit_handled_cr(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+static bool nested_vmx_exit_handled_encls(struct kvm_vcpu *vcpu,
+					  struct vmcs12 *vmcs12)
+{
+	u32 encls_leaf;
+
+	if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING))
+		return false;
+
+	encls_leaf = kvm_rax_read(vcpu);
+	if (encls_leaf > 62)
+		encls_leaf = 63;
+	return vmcs12->encls_exiting_bitmap & BIT_ULL(encls_leaf);
+}
+
 static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 	struct vmcs12 *vmcs12, gpa_t bitmap)
 {
@@ -5803,9 +5821,6 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
 	case EXIT_REASON_VMFUNC:
 		/* VM functions are emulated through L2->L0 vmexits. */
 		return true;
-	case EXIT_REASON_ENCLS:
-		/* SGX is never exposed to L1 */
-		return true;
 	default:
 		break;
 	}
@@ -5929,6 +5944,8 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
 	case EXIT_REASON_TPAUSE:
 		return nested_cpu_has2(vmcs12,
 			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE);
+	case EXIT_REASON_ENCLS:
+		return nested_vmx_exit_handled_encls(vcpu, vmcs12);
 	default:
 		return true;
 	}
@@ -6504,6 +6521,9 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		msrs->secondary_ctls_high |=
 			SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
 
+	if (enable_sgx)
+		msrs->secondary_ctls_high |= SECONDARY_EXEC_ENCLS_EXITING;
+
 	/* miscellaneous data */
 	rdmsr(MSR_IA32_VMX_MISC,
 		msrs->misc_low,
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 197148d76b8f..184418baeb3c 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -244,6 +244,11 @@ static inline bool nested_exit_on_intr(struct kvm_vcpu *vcpu)
 		PIN_BASED_EXT_INTR_MASK;
 }
 
+static inline bool nested_cpu_has_encls_exit(struct vmcs12 *vmcs12)
+{
+	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING);
+}
+
 /*
  * if fixed0[i] == 1: val[i] must be 1
  * if fixed1[i] == 0: val[i] must be 0
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 55be2ea90de5..77a9354ae82a 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -5,11 +5,13 @@
 
 #include "cpuid.h"
 #include "kvm_cache_regs.h"
+#include "nested.h"
 #include "sgx.h"
 #include "vmx.h"
 #include "x86.h"
 
-bool __read_mostly enable_sgx;
+bool __read_mostly enable_sgx = 1;
+module_param_named(sgx, enable_sgx, bool, 0444);
 
 /* Initial value of guest's virtual SGX_LEPUBKEYHASHn MSRs */
 static u64 sgx_pubkey_hash[4] __ro_after_init;
@@ -385,3 +387,79 @@ void vcpu_setup_sgx_lepubkeyhash(struct kvm_vcpu *vcpu)
 	memcpy(vmx->msr_ia32_sgxlepubkeyhash, sgx_pubkey_hash,
 	       sizeof(sgx_pubkey_hash));
 }
+
+/*
+ * ECREATE must be intercepted to enforce MISCSELECT, ATTRIBUTES and XFRM
+ * restrictions if the guest's allowed-1 settings diverge from hardware.
+ */
+static bool sgx_intercept_encls_ecreate(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *guest_cpuid;
+	u32 eax, ebx, ecx, edx;
+
+	if (!vcpu->kvm->arch.sgx_provisioning_allowed)
+		return true;
+
+	guest_cpuid = kvm_find_cpuid_entry(vcpu, 0x12, 0);
+	if (!guest_cpuid)
+		return true;
+
+	cpuid_count(0x12, 0, &eax, &ebx, &ecx, &edx);
+	if (guest_cpuid->ebx != ebx || guest_cpuid->edx != edx)
+		return true;
+
+	guest_cpuid = kvm_find_cpuid_entry(vcpu, 0x12, 1);
+	if (!guest_cpuid)
+		return true;
+
+	cpuid_count(0x12, 1, &eax, &ebx, &ecx, &edx);
+	if (guest_cpuid->eax != eax || guest_cpuid->ebx != ebx ||
+	    guest_cpuid->ecx != ecx || guest_cpuid->edx != edx)
+		return true;
+
+	return false;
+}
+
+void vmx_write_encls_bitmap(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
+{
+	/*
+	 * There is no software enable bit for SGX that is virtualized by
+	 * hardware, e.g. there's no CR4.SGXE, so when SGX is disabled in the
+	 * guest (either by the host or by the guest's BIOS) but enabled in the
+	 * host, trap all ENCLS leafs and inject #UD/#GP as needed to emulate
+	 * the expected system behavior for ENCLS.
+	 */
+	u64 bitmap = -1ull;
+
+	/* Nothing to do if hardware doesn't support SGX */
+	if (!cpu_has_vmx_encls_vmexit())
+		return;
+
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SGX) &&
+	    sgx_enabled_in_guest_bios(vcpu)) {
+		if (guest_cpuid_has(vcpu, X86_FEATURE_SGX1)) {
+			bitmap &= ~GENMASK_ULL(ETRACK, ECREATE);
+			if (sgx_intercept_encls_ecreate(vcpu))
+				bitmap |= (1 << ECREATE);
+		}
+
+		if (guest_cpuid_has(vcpu, X86_FEATURE_SGX2))
+			bitmap &= ~GENMASK_ULL(EMODT, EAUG);
+
+		/*
+		 * Trap and execute EINIT if launch control is enabled in the
+		 * host using the guest's values for launch control MSRs, even
+		 * if the guest's values are fixed to hardware default values.
+		 * The MSRs are not loaded/saved on VM-Enter/VM-Exit as writing
+		 * the MSRs is extraordinarily expensive.
+		 */
+		if (boot_cpu_has(X86_FEATURE_SGX_LC))
+			bitmap |= (1 << EINIT);
+
+		if (!vmcs12 && is_guest_mode(vcpu))
+			vmcs12 = get_vmcs12(vcpu);
+		if (vmcs12 && nested_cpu_has_encls_exit(vmcs12))
+			bitmap |= vmcs12->encls_exiting_bitmap;
+	}
+	vmcs_write64(ENCLS_EXITING_BITMAP, bitmap);
+}
diff --git a/arch/x86/kvm/vmx/sgx.h b/arch/x86/kvm/vmx/sgx.h
index 6502fa52c7e9..a400888b376d 100644
--- a/arch/x86/kvm/vmx/sgx.h
+++ b/arch/x86/kvm/vmx/sgx.h
@@ -4,6 +4,9 @@
 
 #include <linux/kvm_host.h>
 
+#include "capabilities.h"
+#include "vmx_ops.h"
+
 #ifdef CONFIG_X86_SGX_KVM
 extern bool __read_mostly enable_sgx;
 
@@ -11,11 +14,21 @@ int handle_encls(struct kvm_vcpu *vcpu);
 
 void setup_default_sgx_lepubkeyhash(void);
 void vcpu_setup_sgx_lepubkeyhash(struct kvm_vcpu *vcpu);
+
+void vmx_write_encls_bitmap(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12);
 #else
 #define enable_sgx 0
 
 static inline void setup_default_sgx_lepubkeyhash(void) { }
 static inline void vcpu_setup_sgx_lepubkeyhash(struct kvm_vcpu *vcpu) { }
+
+static inline void vmx_write_encls_bitmap(struct kvm_vcpu *vcpu,
+					  struct vmcs12 *vmcs12)
+{
+	/* Nothing to do if hardware doesn't support SGX */
+	if (cpu_has_vmx_encls_vmexit())
+		vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
+}
 #endif
 
 #endif /* __KVM_X86_SGX_H */
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index c8e51c004f78..034adb6404dc 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -50,6 +50,7 @@ const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD64(VMREAD_BITMAP, vmread_bitmap),
 	FIELD64(VMWRITE_BITMAP, vmwrite_bitmap),
 	FIELD64(XSS_EXIT_BITMAP, xss_exit_bitmap),
+	FIELD64(ENCLS_EXITING_BITMAP, encls_exiting_bitmap),
 	FIELD64(GUEST_PHYSICAL_ADDRESS, guest_physical_address),
 	FIELD64(VMCS_LINK_POINTER, vmcs_link_pointer),
 	FIELD64(GUEST_IA32_DEBUGCTL, guest_ia32_debugctl),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 80232daf00ff..13494956d0e9 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -69,7 +69,8 @@ struct __packed vmcs12 {
 	u64 vm_function_control;
 	u64 eptp_list_address;
 	u64 pml_address;
-	u64 padding64[3]; /* room for future expansion */
+	u64 encls_exiting_bitmap;
+	u64 padding64[2]; /* room for future expansion */
 	/*
 	 * To allow migration of L1 (complete with its L2 guests) between
 	 * machines of different natural widths (32 or 64 bit), we cannot have
@@ -256,6 +257,7 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(vm_function_control, 296);
 	CHECK_OFFSET(eptp_list_address, 304);
 	CHECK_OFFSET(pml_address, 312);
+	CHECK_OFFSET(encls_exiting_bitmap, 320);
 	CHECK_OFFSET(cr0_guest_host_mask, 344);
 	CHECK_OFFSET(cr4_guest_host_mask, 352);
 	CHECK_OFFSET(cr0_read_shadow, 360);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d56add62b48f..e43c9f7a9e85 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2197,6 +2197,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmx->msr_ia32_feature_control = data;
 		if (msr_info->host_initiated && data == 0)
 			vmx_leave_nested(vcpu);
+
+		/* SGX may be enabled/disabled by guest's firmware */
+		vmx_write_encls_bitmap(vcpu, NULL);
 		break;
 	case MSR_IA32_SGXLEPUBKEYHASH0 ... MSR_IA32_SGXLEPUBKEYHASH3:
 		if (!msr_info->host_initiated &&
@@ -4359,6 +4362,15 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
 		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
 
+	if (cpu_has_vmx_encls_vmexit() && nested) {
+		if (guest_cpuid_has(vcpu, X86_FEATURE_SGX))
+			vmx->nested.msrs.secondary_ctls_high |=
+				SECONDARY_EXEC_ENCLS_EXITING;
+		else
+			vmx->nested.msrs.secondary_ctls_high &=
+				~SECONDARY_EXEC_ENCLS_EXITING;
+	}
+
 	vmx->secondary_exec_control = exec_control;
 }
 
@@ -4458,8 +4470,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write16(GUEST_PML_INDEX, PML_ENTITY_NUM - 1);
 	}
 
-	if (cpu_has_vmx_encls_vmexit())
-		vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
+	vmx_write_encls_bitmap(&vmx->vcpu, NULL);
 
 	if (vmx_pt_mode_is_host_guest()) {
 		memset(&vmx->pt_desc, 0, sizeof(vmx->pt_desc));
@@ -7357,6 +7368,19 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	set_cr4_guest_host_mask(vmx);
 
+	vmx_write_encls_bitmap(vcpu, NULL);
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SGX))
+		vmx->msr_ia32_feature_control_valid_bits |= FEAT_CTL_SGX_ENABLED;
+	else
+		vmx->msr_ia32_feature_control_valid_bits &= ~FEAT_CTL_SGX_ENABLED;
+
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SGX_LC))
+		vmx->msr_ia32_feature_control_valid_bits |=
+			FEAT_CTL_SGX_LC_ENABLED;
+	else
+		vmx->msr_ia32_feature_control_valid_bits &=
+			~FEAT_CTL_SGX_LC_ENABLED;
+
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 }
@@ -7377,6 +7401,13 @@ static __init void vmx_set_cpu_caps(void)
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
 
+	if (!enable_sgx) {
+		kvm_cpu_cap_clear(X86_FEATURE_SGX);
+		kvm_cpu_cap_clear(X86_FEATURE_SGX_LC);
+		kvm_cpu_cap_clear(X86_FEATURE_SGX1);
+		kvm_cpu_cap_clear(X86_FEATURE_SGX2);
+	}
+
 	if (vmx_umip_emulated())
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
-- 
2.29.2

