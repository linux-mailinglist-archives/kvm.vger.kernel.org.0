Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A57776EF
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbfG0FwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:52:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:40960 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728383AbfG0FwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568637"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 19/21] KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC
Date:   Fri, 26 Jul 2019 22:52:12 -0700
Message-Id: <20190727055214.9282-20-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGX adds a basic support bit to CPUID(7, 0), and enumerates SGX
capabilities, e.g. EPC info, ENCLS leafs, etc..., in CPUID(0x12, *).
All SGX1 and SGX2 ENCLS leafs (supported in hardware) can be exposed
to the guest unconditionally.  All other ENCLS leafs (currently the
ENCLS_C leafs) and all ENCLV leafs currently cannot be exposed to the
guest.

Flexible Launch Control, a.k.a. SGX LC, allows software to control the
key that is used to verify the signer of an enclave.  Because SGX LC
impacts guest operation even if it's not exposed to the guest, i.e.
EINIT is affected by hardware's LE hash MSRs, SGX cannot be exposed to
the guest if the host supports LC without explicit LC support in KVM.
In other words, LC support is required to run on platforms with LC
enabled in the host, thus making exposure of SGX LC to the guest a
formality.

Access to the provision key is not supported in this patch.  Access to
the provision key is controlled via securityfs, a future patch will
plumb in the ability for the userspace hypervisor to grant a VM access
to the provision key by passing in an appropriate file descriptor.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c      |  72 +++++++++++++++++-
 arch/x86/kvm/vmx/nested.c |  19 ++++-
 arch/x86/kvm/vmx/nested.h |   5 ++
 arch/x86/kvm/vmx/sgx.h    |  11 +++
 arch/x86/kvm/vmx/vmcs12.c |   1 +
 arch/x86/kvm/vmx/vmcs12.h |   4 +-
 arch/x86/kvm/vmx/vmx.c    | 156 ++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h    |   1 +
 8 files changed, 254 insertions(+), 15 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/sgx.h

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 4c235af5318c..73a0326a1968 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -18,6 +18,7 @@
 #include <asm/processor.h>
 #include <asm/user.h>
 #include <asm/fpu/xstate.h>
+#include <asm/sgx_arch.h>
 #include "cpuid.h"
 #include "lapic.h"
 #include "mmu.h"
@@ -117,6 +118,21 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	if (best && (best->eax & (F(XSAVES) | F(XSAVEC))))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
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
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
 	 * canonical address checks; exit if it is ever changed.
@@ -393,7 +409,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
 		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
 		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
-		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
+		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt | F(SGX);
 
 	/* cpuid 0xD.1.eax */
 	const u32 kvm_cpuid_D_1_eax_x86_features =
@@ -404,7 +420,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B);
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | F(SGX_LC);
 
 	/* cpuid 7.0.edx*/
 	const u32 kvm_cpuid_7_0_edx_x86_features =
@@ -412,6 +428,23 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR);
 
+	/* cpuid 12.0.eax*/
+	const u32 kvm_cpuid_12_0_eax_x86_features =
+		F(SGX1) | F(SGX2) | 0 /* Reserved */ | 0 /* Reserved */ |
+		0 /* Reserved */ | 0 /* ENCLV */ | 0 /* ENCLS_C */;
+
+	/* cpuid 12.0.ebx*/
+	const u32 kvm_cpuid_12_0_ebx_sgx_features =
+		SGX_MISC_EXINFO;
+
+	/* cpuid 12.1.eax*/
+	const u32 kvm_cpuid_12_1_eax_sgx_features =
+		SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT | 0 /* PROVISIONKEY */ |
+		SGX_ATTR_EINITTOKENKEY | SGX_ATTR_KSS;
+
+	/* cpuid 12.1.ebx*/
+	const u32 kvm_cpuid_12_1_ebx_sgx_features = 0;
+
 	/*
 	 * The code below assumes index == 0, which simplifies handling leafs
 	 * with a dynamic number of sub-leafs.  The index is fully under KVM's
@@ -433,7 +466,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 
 	switch (function) {
 	case 0:
-		entry->eax = min(entry->eax, (u32)(f_intel_pt ? 0x14 : 0xd));
+		entry->eax = min(entry->eax, (u32)(f_intel_pt ? 0x14 : 0x12));
 		break;
 	case 1:
 		entry->edx &= kvm_cpuid_1_edx_x86_features;
@@ -607,6 +640,39 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		}
 		break;
 	}
+	case 0x12:
+		/* Intel SGX */
+		if (!boot_cpu_has(X86_FEATURE_SGX)) {
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			break;
+		}
+
+		/*
+		 * Index 0: Sub-features, MISCSELECT (a.k.a extended features)
+		 * and max enclave sizes.   The SGX sub-features and MISCSELECT
+		 * are restricted by KVM and x86_capabilities (like most
+		 * feature flags), while enclave size is unrestricted.
+		 */
+		entry->eax &= kvm_cpuid_12_0_eax_x86_features;
+		entry->ebx &= kvm_cpuid_12_0_ebx_sgx_features;
+		cpuid_mask(&entry->eax, CPUID_LNX_3);
+		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+
+		/*
+		 * Index 1: SECS.ATTRIBUTES.  ATTRIBUTES are restricted a la
+		 * feature flags.  Unconditionally advertise all supported
+		 * flags, even privileged attributes that require explicit
+		 * opt-in from userspace.  ATTRIBUTES.XFRM is not adjusted
+		 * as userspace is expected to derive it from supported XCR0.
+		 */
+		if (*nent >= maxnent)
+			goto out;
+		do_cpuid_1_ent(++entry, 0x12, 0x1);
+		entry->eax &= kvm_cpuid_12_1_eax_sgx_features;
+		entry->ebx &= kvm_cpuid_12_1_ebx_sgx_features;
+		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+		++*nent;
+		break;
 	/* Intel PT */
 	case 0x14: {
 		int t, times = entry->eax;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fef4fb3e1aaa..6d0e46584133 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2074,7 +2074,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 			vmcs_write64(APIC_ACCESS_ADDR, -1ull);
 
 		if (exec_control & SECONDARY_EXEC_ENCLS_EXITING)
-			vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
+			vmx_write_encls_bitmap(&vmx->vcpu, vmcs12);
 
 		vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
 	}
@@ -5014,6 +5014,20 @@ static bool nested_vmx_exit_handled_cr(struct kvm_vcpu *vcpu,
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
+	encls_leaf = vcpu->arch.regs[VCPU_REGS_RAX];
+	if (encls_leaf > 62)
+		encls_leaf = 63;
+	return (vmcs12->encls_exiting_bitmap & (1ULL << encls_leaf));
+}
+
 static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 	struct vmcs12 *vmcs12, gpa_t bitmap)
 {
@@ -5212,8 +5226,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 		/* VM functions are emulated through L2->L0 vmexits. */
 		return false;
 	case EXIT_REASON_ENCLS:
-		/* SGX is never exposed to L1 */
-		return false;
+		return nested_vmx_exit_handled_encls(vcpu, vmcs12);
 	default:
 		return true;
 	}
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index e847ff1019a2..527bab90703d 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -226,6 +226,11 @@ static inline bool nested_cpu_has_save_preemption_timer(struct vmcs12 *vmcs12)
 	    VM_EXIT_SAVE_VMX_PREEMPTION_TIMER;
 }
 
+static inline bool nested_cpu_has_encls_exit(struct vmcs12 *vmcs12)
+{
+	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING);
+}
+
 /*
  * In nested virtualization, check if L1 asked to exit on external interrupts.
  * For most existing hypervisors, this will always return true.
diff --git a/arch/x86/kvm/vmx/sgx.h b/arch/x86/kvm/vmx/sgx.h
new file mode 100644
index 000000000000..2087d5f70883
--- /dev/null
+++ b/arch/x86/kvm/vmx/sgx.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_SGX_H
+#define __KVM_X86_SGX_H
+
+#ifdef CONFIG_INTEL_SGX_VIRTUALIZATION
+int handle_encls_ecreate(struct kvm_vcpu *vcpu);
+int handle_encls_einit(struct kvm_vcpu *vcpu);
+#endif
+
+#endif /* __KVM_X86_SGX_H */
+
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 53dfb401316d..355020944f6c 100644
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
index 337718fc8a36..82a6ccd91ce5 100644
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
@@ -259,6 +260,7 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(vm_function_control, 296);
 	CHECK_OFFSET(eptp_list_address, 304);
 	CHECK_OFFSET(pml_address, 312);
+	CHECK_OFFSET(encls_exiting_bitmap, 320);
 	CHECK_OFFSET(cr0_guest_host_mask, 344);
 	CHECK_OFFSET(cr4_guest_host_mask, 352);
 	CHECK_OFFSET(cr0_read_shadow, 360);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 819c47fee157..ed0366641587 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -41,6 +41,7 @@
 #include <asm/mce.h>
 #include <asm/mmu_context.h>
 #include <asm/mshyperv.h>
+#include <asm/sgx_arch.h>
 #include <asm/spec-ctrl.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
@@ -55,6 +56,7 @@
 #include "nested.h"
 #include "ops.h"
 #include "pmu.h"
+#include "sgx.h"
 #include "trace.h"
 #include "vmcs.h"
 #include "vmcs12.h"
@@ -1961,6 +1963,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmx->msr_ia32_feature_control = data;
 		if (msr_info->host_initiated && data == 0)
 			vmx_leave_nested(vcpu);
+
+		/* SGX may be enabled/disabled by guest's firmware */
+		vmx_write_encls_bitmap(vcpu, NULL);
 		break;
 	case MSR_IA32_SGXLEPUBKEYHASH0 ... MSR_IA32_SGXLEPUBKEYHASH3:
 		if (!msr_info->host_initiated &&
@@ -4030,6 +4035,15 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 		}
 	}
 
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
 
@@ -4145,8 +4159,7 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		vmcs_write16(GUEST_PML_INDEX, PML_ENTITY_NUM - 1);
 	}
 
-	if (cpu_has_vmx_encls_vmexit())
-		vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
+	vmx_write_encls_bitmap(&vmx->vcpu, NULL);
 
 	if (pt_mode == PT_MODE_HOST_GUEST) {
 		memset(&vmx->pt_desc, 0, sizeof(vmx->pt_desc));
@@ -5501,14 +5514,48 @@ static int handle_vmx_instruction(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static inline bool sgx_enabled_in_guest_bios(struct kvm_vcpu *vcpu)
+{
+	const u64 bits = FEATURE_CONTROL_SGX_ENABLE | FEATURE_CONTROL_LOCKED;
+
+	return (to_vmx(vcpu)->msr_ia32_feature_control & bits) == bits;
+}
+
+static inline bool encls_leaf_enabled_in_guest(struct kvm_vcpu *vcpu, u32 leaf)
+{
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_SGX))
+		return false;
+
+	if (leaf >= SGX_ECREATE && leaf <= SGX_ETRACK)
+		return guest_cpuid_has(vcpu, X86_FEATURE_SGX1);
+
+	if (leaf >= SGX_EAUG && leaf <= SGX_EMODT)
+		return guest_cpuid_has(vcpu, X86_FEATURE_SGX2);
+
+	return false;
+}
+
 static int handle_encls(struct kvm_vcpu *vcpu)
 {
-	/*
-	 * SGX virtualization is not yet supported.  There is no software
-	 * enable bit for SGX, so we have to trap ENCLS and inject a #UD
-	 * to prevent the guest from executing ENCLS.
-	 */
-	kvm_queue_exception(vcpu, UD_VECTOR);
+	u32 leaf = (u32)vcpu->arch.regs[VCPU_REGS_RAX];
+
+	if (!encls_leaf_enabled_in_guest(vcpu, leaf) ||
+	    !IS_ENABLED(CONFIG_INTEL_SGX_VIRTUALIZATION))
+		kvm_queue_exception(vcpu, UD_VECTOR);
+	else if (!sgx_enabled_in_guest_bios(vcpu))
+		kvm_inject_gp(vcpu, 0);
+	else {
+#ifdef CONFIG_INTEL_SGX_VIRTUALIZATION
+		if (leaf == SGX_ECREATE)
+			return handle_encls_ecreate(vcpu);
+		if (leaf == SGX_EINIT)
+			return handle_encls_einit(vcpu);
+#endif
+		WARN(1, "KVM: unexpected exit on ENCLS[%u]", leaf);
+		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
+		vcpu->run->hw.hardware_exit_reason = EXIT_REASON_ENCLS;
+		return 0;
+	}
 	return 1;
 }
 
@@ -7005,6 +7052,85 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
+/*
+ * ECREATE must be intercepted to enforce MISCSELECT, ATTRIBUTES and XFRM
+ * restrictions if the guest's allowed-1 settings diverge from hardware.
+ */
+static inline bool vmx_intercept_encls_ecreate(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_INTEL_SGX_VIRTUALIZATION
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
+	if (guest_cpuid->ebx != ebx)
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
+#endif
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
+#ifdef CONFIG_INTEL_SGX_VIRTUALIZATION
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SGX) &&
+	    sgx_enabled_in_guest_bios(vcpu)) {
+		if (guest_cpuid_has(vcpu, X86_FEATURE_SGX1)) {
+			bitmap &= ~GENMASK_ULL(SGX_ETRACK, SGX_ECREATE);
+			if (vmx_intercept_encls_ecreate(vcpu))
+				bitmap |= (1 << SGX_ECREATE);
+		}
+
+		if (guest_cpuid_has(vcpu, X86_FEATURE_SGX2))
+			bitmap &= ~GENMASK_ULL(SGX_EMODT, SGX_EAUG);
+
+		/*
+		 * Trap and execute EINIT if launch control is enabled in the
+		 * host using the guest's values for launch control MSRs, even
+		 * if the guest's values are fixed to hardware default values.
+		 * The MSRs are not loaded/saved on VM-Enter/VM-Exit as writing
+		 * the MSRs is extraordinarily expensive.
+		 */
+		if (boot_cpu_has(X86_FEATURE_SGX_LC))
+			bitmap |= (1 << SGX_EINIT);
+
+		if (!vmcs12 && nested && is_guest_mode(vcpu))
+			vmcs12 = get_vmcs12(vcpu);
+		if (vmcs12 && nested_cpu_has_encls_exit(vmcs12))
+			bitmap |= vmcs12->encls_exiting_bitmap;
+	}
+#endif
+	vmcs_write64(ENCLS_EXITING_BITMAP, bitmap);
+}
+
 static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7029,6 +7155,20 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
 			guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
 		update_intel_pt_cfg(vcpu);
+
+	vmx_write_encls_bitmap(vcpu, NULL);
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SGX))
+		vmx->msr_ia32_feature_control_valid_bits |=
+			FEATURE_CONTROL_SGX_ENABLE;
+	else
+		vmx->msr_ia32_feature_control_valid_bits &=
+			~FEATURE_CONTROL_SGX_ENABLE;
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SGX_LC))
+		vmx->msr_ia32_feature_control_valid_bits |=
+			FEATURE_CONTROL_SGX_LE_WR;
+	else
+		vmx->msr_ia32_feature_control_valid_bits &=
+			~FEATURE_CONTROL_SGX_LE_WR;
 }
 
 static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 1519c6918190..78c81efe43ba 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -325,6 +325,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
+void vmx_write_encls_bitmap(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12);
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
-- 
2.22.0

