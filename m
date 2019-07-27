Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A17776F9
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfG0FxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:53:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:40958 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728343AbfG0FwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568624"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:15 -0700
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
Subject: [RFC PATCH 15/21] KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
Date:   Fri, 26 Jul 2019 22:52:08 -0700
Message-Id: <20190727055214.9282-16-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace can restrict what bits can be set in MISCSELECT, ATTRIBUTES
and XFRM via CPUID.  Intercept ECREATE when any of the aforementioned
masks diverges from hardware in order to enforce the desired CPUID
model, i.e. inject #GP if the guest attempts to set a bit that hasn't
been enumerated as allowed-1 in CPUID.

Add the handler in a dedicated SGX file under the VMX sub-directory so
as to confine the ugliness of the SGX specific code (re-executing ENCLS
leafs is messy due to the need to follow pointers from structs, get EPC
pages, etc...) and to save compilation cycles when SGX functionality is
disabled in the kernel.  The ENCLS handlers will soon grow to ~300 lines
of code when Launch Control support is added, and in the distant future
could balloon significantly if/when EPC oversubscription is supported.

Actual usage of the handler will be added in a future patch, i.e. when
SGX virtualization is fully enabled.

Note, access to the PROVISIONKEY is not yet supported.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/include/asm/sgx_arch.h |   1 +
 arch/x86/kvm/Makefile           |   2 +
 arch/x86/kvm/vmx/sgx.c          | 223 ++++++++++++++++++++++++++++++++
 4 files changed, 229 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/sgx.c

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 103df8cbdd24..27841a5d7851 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -928,6 +928,9 @@ struct kvm_arch {
 
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
+
+	/* Guest can access the SGX PROVISIONKEY. */
+	bool sgx_provisioning_allowed;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
index 39f731580ea8..e06f3ff717b4 100644
--- a/arch/x86/include/asm/sgx_arch.h
+++ b/arch/x86/include/asm/sgx_arch.h
@@ -8,6 +8,7 @@
 #ifndef _ASM_X86_SGX_ARCH_H
 #define _ASM_X86_SGX_ARCH_H
 
+#include <linux/bits.h>
 #include <linux/types.h>
 
 #define SGX_CPUID				0x12
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 31ecf7a76d5a..f919c3e6abd7 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -13,6 +13,8 @@ kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
 			   hyperv.o page_track.o debugfs.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
+kvm-intel-$(CONFIG_INTEL_SGX_VIRTUALIZATION) += vmx/sgx.o
+
 kvm-amd-y		+= svm.o pmu_amd.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
new file mode 100644
index 000000000000..5b08e7dcc3a3
--- /dev/null
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <asm/sgx.h>
+#include <asm/sgx_arch.h>
+
+#include "cpuid.h"
+#include "kvm_cache_regs.h"
+#include "vmx.h"
+#include "x86.h"
+
+/*
+ * ENCLS's memory operands use a fixed segment (DS) and a fixed
+ * address size based on the mode.  Related prefixes are ignored.
+ */
+static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
+			     int size, int alignment, gva_t *gva)
+{
+	struct kvm_segment s;
+	bool fault;
+
+	vmx_get_segment(vcpu, &s, VCPU_SREG_DS);
+
+	*gva = s.base + offset;
+
+	if (!IS_ALIGNED(*gva, alignment)) {
+		fault = true;
+	} else if (is_long_mode(vcpu)) {
+		fault = is_noncanonical_address(*gva, vcpu);
+	} else {
+		*gva &= 0xffffffff;
+		fault = (s.unusable) ||
+			(s.type != 2 && s.type != 3) ||
+			(*gva > s.limit) ||
+			((s.base != 0 || s.limit != 0xffffffff) &&
+			(((u64)*gva + size - 1) > s.limit + 1));
+	}
+	if (fault)
+		kvm_inject_gp(vcpu, 0);
+	return fault ? -EINVAL : 0;
+}
+
+static int sgx_read_gva(struct kvm_vcpu *vcpu, gva_t gva, void *data,
+			 unsigned int size)
+{
+	struct x86_exception ex;
+
+	if (kvm_read_guest_virt(vcpu, gva, data, size, &ex)) {
+		kvm_propagate_page_fault(vcpu, &ex);
+		return -EFAULT;
+	}
+	return 0;
+}
+
+static int sgx_read_hva(struct kvm_vcpu *vcpu, unsigned long hva, void *data,
+			unsigned int size)
+{
+	if (__copy_from_user(data, (void __user *)hva, size)) {
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+		vcpu->run->internal.ndata = 2;
+		vcpu->run->internal.data[0] = hva;
+		vcpu->run->internal.data[1] = size;
+		return -EFAULT;
+	}
+	return 0;
+}
+
+static int sgx_gva_to_hva(struct kvm_vcpu *vcpu, gva_t gva, bool write,
+			  unsigned long *hva)
+{
+	struct x86_exception ex;
+	gpa_t gpa;
+
+	if (write)
+		gpa = kvm_mmu_gva_to_gpa_write(vcpu, gva, &ex);
+	else
+		gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, &ex);
+
+	if (gpa == UNMAPPED_GVA) {
+		kvm_propagate_page_fault(vcpu, &ex);
+		return -EFAULT;
+	}
+
+	*hva = kvm_vcpu_gfn_to_hva(vcpu, PFN_DOWN(gpa));
+	if (kvm_is_error_hva(*hva)) {
+		ex.vector = PF_VECTOR;
+		ex.error_code = PFERR_PRESENT_MASK;
+		if (write)
+			ex.error_code |= PFERR_WRITE_MASK;
+		ex.address = gva;
+		ex.error_code_valid = true;
+		ex.nested_page_fault = false;
+		kvm_propagate_page_fault(vcpu, &ex);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int sgx_encls_postamble(struct kvm_vcpu *vcpu, int ret, int trapnr,
+			       gva_t gva)
+{
+	struct x86_exception ex;
+	unsigned long rflags;
+
+	if (ret == -EFAULT)
+		goto handle_fault;
+
+	rflags = vmx_get_rflags(vcpu) & ~(X86_EFLAGS_CF | X86_EFLAGS_PF |
+					  X86_EFLAGS_AF | X86_EFLAGS_SF |
+					  X86_EFLAGS_OF);
+	if (ret)
+		rflags |= X86_EFLAGS_ZF;
+	else
+		rflags &= ~X86_EFLAGS_ZF;
+	vmx_set_rflags(vcpu, rflags);
+
+	kvm_rax_write(vcpu, ret);
+	return kvm_skip_emulated_instruction(vcpu);
+
+handle_fault:
+	/*
+	 * A non-EPCM #PF indicates a bad userspace HVA.  This *should* check
+	 * for PFEC.SGX and not assume any #PF on SGX2 originated in the EPC,
+	 * but the error code isn't (yet) plumbed through the ENCLS helpers.
+	 */
+	if (trapnr == PF_VECTOR && !boot_cpu_has(X86_FEATURE_SGX2)) {
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+		vcpu->run->internal.ndata = 0;
+		return 0;
+	}
+
+	/*
+	 * If the guest thinks it's running on SGX2 hardware, inject an SGX
+	 * #PF if the fault matches an EPCM fault signature (#GP on SGX1,
+	 * #PF on SGX2).  The assumption is that EPCM faults are much more
+	 * likely than a bad userspace address.
+	 */
+	if ((trapnr == PF_VECTOR || !boot_cpu_has(X86_FEATURE_SGX2)) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_SGX2)) {
+		ex.vector = PF_VECTOR;
+		ex.error_code = PFERR_PRESENT_MASK | PFERR_WRITE_MASK |
+				PFERR_SGX_MASK;
+		ex.address = gva;
+		ex.error_code_valid = true;
+		ex.nested_page_fault = false;
+		kvm_inject_page_fault(vcpu, &ex);
+	} else {
+		kvm_inject_gp(vcpu, 0);
+	}
+	return 1;
+}
+
+int handle_encls_ecreate(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *sgx_12_0, *sgx_12_1;
+	unsigned long a_hva, m_hva, x_hva, secs_hva;
+	struct sgx_pageinfo pageinfo;
+	gva_t pageinfo_gva, secs_gva;
+	u64 attributes, xfrm;
+	int ret, trapnr;
+	u32 miscselect;
+
+	sgx_12_0 = kvm_find_cpuid_entry(vcpu, 0x12, 0);
+	sgx_12_1 = kvm_find_cpuid_entry(vcpu, 0x12, 1);
+	if (!sgx_12_0 || !sgx_12_1) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	if (sgx_get_encls_gva(vcpu, kvm_rbx_read(vcpu), 32, 32, &pageinfo_gva) ||
+	    sgx_get_encls_gva(vcpu, kvm_rcx_read(vcpu), 4096, 4096, &secs_gva))
+		return 1;
+
+	/*
+	 * Copy the PAGEINFO to local memory, its pointers need to be
+	 * translated, i.e. we need to do a deep copy/translate.
+	 */
+	if (sgx_read_gva(vcpu, pageinfo_gva, &pageinfo, sizeof(pageinfo)))
+		return 1;
+
+	/* Translate the SECINFO, SOURCE and SECS pointers from GVA to HVA. */
+	if (sgx_gva_to_hva(vcpu, pageinfo.metadata, false,
+			   (unsigned long *)&pageinfo.metadata) ||
+	    sgx_gva_to_hva(vcpu, pageinfo.contents, false,
+			   (unsigned long *)&pageinfo.contents) ||
+	    sgx_gva_to_hva(vcpu, secs_gva, true, &secs_hva))
+		return 1;
+
+	m_hva = pageinfo.contents + offsetof(struct sgx_secs, miscselect);
+	a_hva = pageinfo.contents + offsetof(struct sgx_secs, attributes);
+	x_hva = pageinfo.contents + offsetof(struct sgx_secs, xfrm);
+
+	/* Exit to userspace if copying from a host userspace address fails. */
+	if (sgx_read_hva(vcpu, m_hva, &miscselect, sizeof(miscselect)) ||
+	    sgx_read_hva(vcpu, a_hva, &attributes, sizeof(attributes)) ||
+	    sgx_read_hva(vcpu, x_hva, &xfrm, sizeof(xfrm)))
+		return 0;
+
+	/* Enforce restriction of access to the PROVISIONKEY. */
+	if (!vcpu->kvm->arch.sgx_provisioning_allowed &&
+	    (attributes & SGX_ATTR_PROVISIONKEY)) {
+		if (sgx_12_1->eax & SGX_ATTR_PROVISIONKEY)
+			pr_warn_once("KVM: SGX PROVISIONKEY advertised but not allowed\n");
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	/* Enforce CPUID restrictions on MISCSELECT, ATTRIBUTES and XFRM. */
+	if ((u32)miscselect & ~sgx_12_0->ebx ||
+	    (u32)attributes & ~sgx_12_1->eax ||
+	    (u32)(attributes >> 32) & ~sgx_12_1->ebx ||
+	    (u32)xfrm & ~sgx_12_1->ecx ||
+	    (u32)(xfrm >> 32) & ~sgx_12_1->edx) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	ret = sgx_ecreate(&pageinfo, (void __user *)secs_hva, &trapnr);
+
+	return sgx_encls_postamble(vcpu, ret, trapnr, secs_gva);
+}
-- 
2.22.0

