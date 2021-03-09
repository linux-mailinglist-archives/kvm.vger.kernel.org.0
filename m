Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C80B331C87
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhCIBls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:41:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:22228 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231384AbhCIBlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:41:17 -0500
IronPort-SDR: tk1/hU+GAiccXSzEXZDaTKw/Ta7khBKQOA6/i0TgoMI3eFTTw49IyvK6O30sNnw/06deytf83A
 ZYnIuAuaDfkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="175249120"
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="175249120"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:41:16 -0800
IronPort-SDR: dIxMsD7gAerKFHMkK85r4GtlANaCWLiWaj+eQ8sXPdonvi3Tj/DDS9A2vVoHxKuX68qrUlmd9d
 3avcB0/WR7cg==
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="447327739"
Received: from kzliu-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.128.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:41:10 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 21/25] KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
Date:   Tue,  9 Mar 2021 14:40:28 +1300
Message-Id: <47375cd4dd56aa1c0ad19819d6bcc4a5ff04bcc0.1615250634.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615250634.git.kai.huang@intel.com>
References: <cover.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add an ECREATE handler that will be used to intercept ECREATE for the
purpose of enforcing and enclave's MISCSELECT, ATTRIBUTES and XFRM, i.e.
to allow userspace to restrict SGX features via CPUID.  ECREATE will be
intercepted when any of the aforementioned masks diverges from hardware
in order to enforce the desired CPUID model, i.e. inject #GP if the
guest attempts to set a bit that hasn't been enumerated as allowed-1 in
CPUID.

Note, access to the PROVISIONKEY is not yet supported.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v1-v2:

 - Fixed 'contents' leak problem pointed out by Sean.

---
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/vmx/sgx.c          | 263 ++++++++++++++++++++++++++++++++
 2 files changed, 266 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 79b56eccb28f..5709a8a65c90 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1038,6 +1038,9 @@ struct kvm_arch {
 
 	bool bus_lock_detection_enabled;
 
+	/* Guest can access the SGX PROVISIONKEY. */
+	bool sgx_provisioning_allowed;
+
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
 
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index f68adbe38750..cb7cc6174a84 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -11,6 +11,267 @@
 
 bool __read_mostly enable_sgx;
 
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
+	/* Skip vmcs.GUEST_DS retrieval for 64-bit mode to avoid VMREADs. */
+	*gva = offset;
+	if (!is_long_mode(vcpu)) {
+		vmx_get_segment(vcpu, &s, VCPU_SREG_DS);
+		*gva += s.base;
+	}
+
+	if (!IS_ALIGNED(*gva, alignment)) {
+		fault = true;
+	} else if (likely(is_long_mode(vcpu))) {
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
+static void sgx_handle_emulation_failure(struct kvm_vcpu *vcpu, u64 addr,
+					 unsigned int size)
+{
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+	vcpu->run->internal.ndata = 2;
+	vcpu->run->internal.data[0] = addr;
+	vcpu->run->internal.data[1] = size;
+}
+
+static int sgx_read_hva(struct kvm_vcpu *vcpu, unsigned long hva, void *data,
+			unsigned int size)
+{
+	if (__copy_from_user(data, (void __user *)hva, size)) {
+		sgx_handle_emulation_failure(vcpu, hva, size);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int sgx_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t gva, bool write,
+			  gpa_t *gpa)
+{
+	struct x86_exception ex;
+
+	if (write)
+		*gpa = kvm_mmu_gva_to_gpa_write(vcpu, gva, &ex);
+	else
+		*gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, &ex);
+
+	if (*gpa == UNMAPPED_GVA) {
+		kvm_inject_emulated_page_fault(vcpu, &ex);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int sgx_gpa_to_hva(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long *hva)
+{
+	*hva = kvm_vcpu_gfn_to_hva(vcpu, PFN_DOWN(gpa));
+	if (kvm_is_error_hva(*hva)) {
+		sgx_handle_emulation_failure(vcpu, gpa, 1);
+		return -EFAULT;
+	}
+
+	*hva |= gpa & ~PAGE_MASK;
+
+	return 0;
+}
+
+static int sgx_inject_fault(struct kvm_vcpu *vcpu, gva_t gva, int trapnr)
+{
+	struct x86_exception ex;
+
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
+		memset(&ex, 0, sizeof(ex));
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
+static int __handle_encls_ecreate(struct kvm_vcpu *vcpu,
+				  struct sgx_pageinfo *pageinfo,
+				  unsigned long secs_hva,
+				  gva_t secs_gva)
+{
+	struct sgx_secs *contents = (struct sgx_secs *)pageinfo->contents;
+	struct kvm_cpuid_entry2 *sgx_12_0, *sgx_12_1;
+	u64 attributes, xfrm, size;
+	u32 miscselect;
+	u8 max_size_log2;
+	int trapnr;
+
+	sgx_12_0 = kvm_find_cpuid_entry(vcpu, 0x12, 0);
+	sgx_12_1 = kvm_find_cpuid_entry(vcpu, 0x12, 1);
+	if (!sgx_12_0 || !sgx_12_1) {
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+		vcpu->run->internal.ndata = 0;
+		return 0;
+	}
+
+	miscselect = contents->miscselect;
+	attributes = contents->attributes;
+	xfrm = contents->xfrm;
+	size = contents->size;
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
+	/* Enforce CPUID restriction on max enclave size. */
+	max_size_log2 = (attributes & SGX_ATTR_MODE64BIT) ? sgx_12_0->edx >> 8 :
+							    sgx_12_0->edx;
+	if (size >= BIT_ULL(max_size_log2))
+		kvm_inject_gp(vcpu, 0);
+
+	if (sgx_virt_ecreate(pageinfo, (void __user *)secs_hva, &trapnr))
+		return sgx_inject_fault(vcpu, secs_gva, trapnr);
+
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
+static int handle_encls_ecreate(struct kvm_vcpu *vcpu)
+{
+	gva_t pageinfo_gva, secs_gva;
+	gva_t metadata_gva, contents_gva;
+	gpa_t metadata_gpa, contents_gpa, secs_gpa;
+	unsigned long metadata_hva, contents_hva, secs_hva;
+	struct sgx_pageinfo pageinfo;
+	struct sgx_secs *contents;
+	struct x86_exception ex;
+	int r;
+
+	if (sgx_get_encls_gva(vcpu, kvm_rbx_read(vcpu), 32, 32, &pageinfo_gva) ||
+	    sgx_get_encls_gva(vcpu, kvm_rcx_read(vcpu), 4096, 4096, &secs_gva))
+		return 1;
+
+	/*
+	 * Copy the PAGEINFO to local memory, its pointers need to be
+	 * translated, i.e. we need to do a deep copy/translate.
+	 */
+	r = kvm_read_guest_virt(vcpu, pageinfo_gva, &pageinfo,
+				sizeof(pageinfo), &ex);
+	if (r == X86EMUL_PROPAGATE_FAULT) {
+		kvm_inject_emulated_page_fault(vcpu, &ex);
+		return 1;
+	} else if (r != X86EMUL_CONTINUE) {
+		sgx_handle_emulation_failure(vcpu, pageinfo_gva,
+					     sizeof(pageinfo));
+		return 0;
+	}
+
+	if (sgx_get_encls_gva(vcpu, pageinfo.metadata, 64, 64, &metadata_gva) ||
+	    sgx_get_encls_gva(vcpu, pageinfo.contents, 4096, 4096,
+			      &contents_gva))
+		return 1;
+
+	/*
+	 * Translate the SECINFO, SOURCE and SECS pointers from GVA to GPA.
+	 * Resume the guest on failure to inject a #PF.
+	 */
+	if (sgx_gva_to_gpa(vcpu, metadata_gva, false, &metadata_gpa) ||
+	    sgx_gva_to_gpa(vcpu, contents_gva, false, &contents_gpa) ||
+	    sgx_gva_to_gpa(vcpu, secs_gva, true, &secs_gpa))
+		return 1;
+
+	/*
+	 * ...and then to HVA.  The order of accesses isn't architectural, i.e.
+	 * KVM doesn't have to fully process one address at a time.  Exit to
+	 * userspace if a GPA is invalid.
+	 */
+	if (sgx_gpa_to_hva(vcpu, metadata_gpa, &metadata_hva) ||
+	    sgx_gpa_to_hva(vcpu, contents_gpa, &contents_hva) ||
+	    sgx_gpa_to_hva(vcpu, secs_gpa, &secs_hva))
+		return 0;
+
+	/*
+	 * Copy contents into kernel memory to prevent TOCTOU attack. E.g. the
+	 * guest could do ECREATE w/ SECS.SGX_ATTR_PROVISIONKEY=0, and
+	 * simultaneously set SGX_ATTR_PROVISIONKEY to bypass the check to
+	 * enforce restriction of access to the PROVISIONKEY.
+	 */
+	contents = (struct sgx_secs *)__get_free_page(GFP_KERNEL);
+	if (!contents)
+		return -ENOMEM;
+
+	/* Exit to userspace if copying from a host userspace address fails. */
+	if (sgx_read_hva(vcpu, contents_hva, (void *)contents, PAGE_SIZE)) {
+		free_page((unsigned long)contents);
+		return 0;
+	}
+
+	pageinfo.metadata = metadata_hva;
+	pageinfo.contents = (u64)contents;
+
+	r = __handle_encls_ecreate(vcpu, &pageinfo, secs_hva, secs_gva);
+
+	free_page((unsigned long)contents);
+
+	return r;
+}
+
 static inline bool encls_leaf_enabled_in_guest(struct kvm_vcpu *vcpu, u32 leaf)
 {
 	if (!enable_sgx || !guest_cpuid_has(vcpu, X86_FEATURE_SGX))
@@ -41,6 +302,8 @@ int handle_encls(struct kvm_vcpu *vcpu)
 	} else if (!sgx_enabled_in_guest_bios(vcpu)) {
 		kvm_inject_gp(vcpu, 0);
 	} else {
+		if (leaf == ECREATE)
+			return handle_encls_ecreate(vcpu);
 		WARN(1, "KVM: unexpected exit on ENCLS[%u]", leaf);
 		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
 		vcpu->run->hw.hardware_exit_reason = EXIT_REASON_ENCLS;
-- 
2.29.2

