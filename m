Return-Path: <kvm+bounces-26040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CFA2F96FDE4
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FAABB267C6
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 22:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5795815CD4A;
	Fri,  6 Sep 2024 22:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KsErQrJJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD4315B972
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 22:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725661123; cv=none; b=ems4ymzrWpylWLH0f6Gm4v4oc09+gnqzOotkyaXkKnfpm+nbnZWInNKLEWWYYj5ynj9afnsGrnf+XjDb0GXJPm3Ms7MaWZSMqe0/EJPkxCZ64KcLHs/yLQRR9a9FlmDvNFqLRolz3c11+N56w1O9r3/Kffmyhv7DJb7uweXO6sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725661123; c=relaxed/simple;
	bh=LKYzAL7Qw46JYLXV6OQZ5nHPGhwXzTxuyotjGo4qLxk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jb3B3u2oYFtBKKkHt7g9eNLU8Sj+LMWp56tlDM2Pz9SZflhgl7c60PuPHLtZwcaKAJSuIqZikjHk5XNsll2RbI7rgfgZD8y+IR1UTk4+8QRrkbbZ846jXR/ZVr7u4vxGMxca63Syie15Ny/8+ehoRdgpMBt8Jo5DzNNuLKLVXXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KsErQrJJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725661120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WlTA76Zvvr9b1YH2YlEkFl3waFqZMcSuTkJFJLvlLHw=;
	b=KsErQrJJRfFYXsxGJcl6UinKsZhJ6++0Ey8V2jJrgrSXK97h29olD386YVXJyE2az1G1l8
	4j8KIcC/QkkRDAxNA7ag020CW3O6BGsWSoxtc9UpBSDW1PTWSv3qj193yHAo+BD99F4/qa
	ak6Wv4YGRNDobxVhnpeIayAr0fnzBC8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-104-D0e5iR0oNLWeyAtynmJt_w-1; Fri,
 06 Sep 2024 18:18:37 -0400
X-MC-Unique: D0e5iR0oNLWeyAtynmJt_w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1942D19560AD;
	Fri,  6 Sep 2024 22:18:36 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.51])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 72DB319560AF;
	Fri,  6 Sep 2024 22:18:33 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 3/4] KVM: x86: model canonical checks more precisely
Date: Fri,  6 Sep 2024 18:18:23 -0400
Message-Id: <20240906221824.491834-4-mlevitsk@redhat.com>
In-Reply-To: <20240906221824.491834-1-mlevitsk@redhat.com>
References: <20240906221824.491834-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

As a result of a recent investigation, it was determined that x86 CPUs
which support 5-level paging, don't always respect CR4.LA57 when doing
canonical checks.

In particular:

1. MSRs which contain a linear address, allow full 57-bitcanonical address
regardless of CR4.LA57 state. For example: MSR_KERNEL_GS_BASE.

2. All hidden segment bases and GDT/IDT bases also behave like MSRs.
This means that full 57-bit canonical address can be loaded to them
regardless of CR4.LA57, both using MSRS (e.g GS_BASE) and instructions
(e.g LGDT).

3. TLB invalidation instructions also allow the user to use full 57-bit
address regardless of the CR4.LA57.

Finally, it must be noted that the CPU doesn't prevent the user from
disabling 5-level paging, even when the full 57-bit canonical address is
present in one of the registers mentioned above (e.g GDT base).

In fact, this can happen without any userspace help, when the CPU enters
SMM mode - some MSRs, for example MSR_KERNEL_GS_BASE are left to contain
a non-canonical address in regard to the new mode.

Since most of the affected MSRs and all segment bases can be read and
written freely by the guest without any KVM intervention, this patch makes
the emulator closely follow hardware behavior, which means that the
emulator doesn't take in the account the guest CPUID support for 5-level
paging, and only takes in the account the host CPU support.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c       |  2 +-
 arch/x86/kvm/mmu/mmu.c       |  2 +-
 arch/x86/kvm/vmx/nested.c    | 22 ++++++++--------
 arch/x86/kvm/vmx/pmu_intel.c |  2 +-
 arch/x86/kvm/vmx/sgx.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c       |  4 +--
 arch/x86/kvm/x86.c           |  8 +++---
 arch/x86/kvm/x86.h           | 49 ++++++++++++++++++++++++++++++++++--
 8 files changed, 68 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8c8061884a019..60986f67c35a8 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -654,7 +654,7 @@ static inline bool emul_is_noncanonical_address(u64 la,
 						struct x86_emulate_ctxt *ctxt,
 						unsigned int flags)
 {
-	return !ctxt->ops->is_canonical_addr(ctxt, la, 0);
+	return !ctxt->ops->is_canonical_addr(ctxt, la, flags);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f107ec2557c1e..b9fe85ccdc095 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6113,7 +6113,7 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	/* It's actually a GPA for vcpu->arch.guest_mmu.  */
 	if (mmu != &vcpu->arch.guest_mmu) {
 		/* INVLPG on a non-canonical address is a NOP according to the SDM.  */
-		if (is_noncanonical_address(addr, vcpu))
+		if (is_noncanonical_invlpg_address(addr, vcpu))
 			return;
 
 		kvm_x86_call(flush_tlb_gva)(vcpu, addr);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3d64c14d4fd76..a7b0674094473 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2979,8 +2979,8 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    CC(!kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
 		return -EINVAL;
 
-	if (CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
-	    CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_eip, vcpu)))
+	if (CC(is_noncanonical_msr_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
+	    CC(is_noncanonical_msr_address(vmcs12->host_ia32_sysenter_eip, vcpu)))
 		return -EINVAL;
 
 	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) &&
@@ -3014,12 +3014,12 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    CC(vmcs12->host_ss_selector == 0 && !ia32e))
 		return -EINVAL;
 
-	if (CC(is_noncanonical_address(vmcs12->host_fs_base, vcpu)) ||
-	    CC(is_noncanonical_address(vmcs12->host_gs_base, vcpu)) ||
-	    CC(is_noncanonical_address(vmcs12->host_gdtr_base, vcpu)) ||
-	    CC(is_noncanonical_address(vmcs12->host_idtr_base, vcpu)) ||
-	    CC(is_noncanonical_address(vmcs12->host_tr_base, vcpu)) ||
-	    CC(is_noncanonical_address(vmcs12->host_rip, vcpu)))
+	if (CC(is_noncanonical_base_address(vmcs12->host_fs_base, vcpu)) ||
+	    CC(is_noncanonical_base_address(vmcs12->host_gs_base, vcpu)) ||
+	    CC(is_noncanonical_base_address(vmcs12->host_gdtr_base, vcpu)) ||
+	    CC(is_noncanonical_base_address(vmcs12->host_idtr_base, vcpu)) ||
+	    CC(is_noncanonical_base_address(vmcs12->host_tr_base, vcpu)) ||
+	    CC(is_noncanonical_address(vmcs12->host_rip, vcpu, 0)))
 		return -EINVAL;
 
 	/*
@@ -3137,7 +3137,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	}
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS) &&
-	    (CC(is_noncanonical_address(vmcs12->guest_bndcfgs & PAGE_MASK, vcpu)) ||
+	    (CC(is_noncanonical_msr_address(vmcs12->guest_bndcfgs & PAGE_MASK, vcpu)) ||
 	     CC((vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD))))
 		return -EINVAL;
 
@@ -5093,7 +5093,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		 * non-canonical form. This is the only check on the memory
 		 * destination for long mode!
 		 */
-		exn = is_noncanonical_address(*ret, vcpu);
+		exn = is_noncanonical_address(*ret, vcpu, 0);
 	} else {
 		/*
 		 * When not in long mode, the virtual/linear address is
@@ -5898,7 +5898,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		 * invalidation.
 		 */
 		if (!operand.vpid ||
-		    is_noncanonical_address(operand.gla, vcpu))
+		    is_noncanonical_invlpg_address(operand.gla, vcpu))
 			return nested_vmx_fail(vcpu,
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 		vpid_sync_vcpu_addr(vpid02, operand.gla);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 83382a4d1d66f..9c9d4a3361664 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -365,7 +365,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_DS_AREA:
-		if (is_noncanonical_address(data, vcpu))
+		if (is_noncanonical_msr_address(data, vcpu))
 			return 1;
 
 		pmu->ds_area = data;
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 016db12631d66..8fd1ca9f8dbb5 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -37,7 +37,7 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
 		fault = true;
 	} else if (likely(is_64_bit_mode(vcpu))) {
 		*gva = vmx_get_untagged_addr(vcpu, *gva, 0);
-		fault = is_noncanonical_address(*gva, vcpu);
+		fault = is_noncanonical_address(*gva, vcpu, 0);
 	} else {
 		*gva &= 0xffffffff;
 		fault = (s.unusable) ||
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 89682832dded7..2628c899c94fc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2287,7 +2287,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    (!msr_info->host_initiated &&
 		     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
 			return 1;
-		if (is_noncanonical_address(data & PAGE_MASK, vcpu) ||
+		if (is_noncanonical_msr_address(data & PAGE_MASK, vcpu) ||
 		    (data & MSR_IA32_BNDCFGS_RSVD))
 			return 1;
 
@@ -2452,7 +2452,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
 		if (index >= 2 * vmx->pt_desc.num_address_ranges)
 			return 1;
-		if (is_noncanonical_address(data, vcpu))
+		if (is_noncanonical_msr_address(data, vcpu))
 			return 1;
 		if (index % 2)
 			vmx->pt_desc.guest.addr_b[index / 2] = data;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f496830445355..f378e4ff03505 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1829,7 +1829,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	case MSR_KERNEL_GS_BASE:
 	case MSR_CSTAR:
 	case MSR_LSTAR:
-		if (is_noncanonical_address(data, vcpu))
+		if (is_noncanonical_msr_address(data, vcpu))
 			return 1;
 		break;
 	case MSR_IA32_SYSENTER_EIP:
@@ -1846,7 +1846,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		 * value, and that something deterministic happens if the guest
 		 * invokes 64-bit SYSENTER.
 		 */
-		data = __canonical_address(data, vcpu_virt_addr_bits(vcpu));
+		data = __canonical_address(data, max_host_virt_addr_bits());
 		break;
 	case MSR_TSC_AUX:
 		if (!kvm_is_supported_user_return_msr(MSR_TSC_AUX))
@@ -8620,7 +8620,7 @@ static gva_t emulator_get_untagged_addr(struct x86_emulate_ctxt *ctxt,
 static bool emulator_is_canonical_addr(struct x86_emulate_ctxt *ctxt,
 				       gva_t addr, unsigned int flags)
 {
-	return !is_noncanonical_address(addr, emul_to_vcpu(ctxt));
+	return !is_noncanonical_address(addr, emul_to_vcpu(ctxt), flags);
 }
 
 static const struct x86_emulate_ops emulate_ops = {
@@ -13781,7 +13781,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 		 * invalidation.
 		 */
 		if ((!pcid_enabled && (operand.pcid != 0)) ||
-		    is_noncanonical_address(operand.gla, vcpu)) {
+		    is_noncanonical_invlpg_address(operand.gla, vcpu)) {
 			kvm_inject_gp(vcpu, 0);
 			return 1;
 		}
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 50596f6f83208..5cd67477214fa 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -8,6 +8,7 @@
 #include <asm/pvclock.h>
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
+#include "cpuid.h"
 
 struct kvm_caps {
 	/* control of guest tsc rate supported? */
@@ -226,9 +227,53 @@ static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
 	return kvm_is_cr4_bit_set(vcpu, X86_CR4_LA57) ? 57 : 48;
 }
 
-static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
+static inline u8 max_host_virt_addr_bits(void)
 {
-	return !__is_canonical_address(la, vcpu_virt_addr_bits(vcpu));
+	return kvm_cpu_cap_has(X86_FEATURE_LA57) ? 57 : 48;
+}
+
+/*
+ * X86 MSRs which contain linear addresses, x86 hidden segment bases, and
+ * IDT/GDT bases have static canonicality checks, size of which depends only on
+ * CPU's support for  5-level paging, rather than on the state of CR4.LA57.
+ * This applies to both WRMSR and to other instructions that set their values,
+ * e.g. SGDT.
+ *
+ * KVM passes through most of these MSRS and also doesn't intercept the
+ * instructions that set the hidden segment bases.
+ *
+ * Because of this, for consistency with ucode, even if the guest doesn't
+ * have LA57 enabled in its CPUID, it is better to base the check on the *host*
+ * support for 5 level paging.
+ *
+ * Finally, instructions which are related to MMU invalidation of a given
+ * linear address, also have a similar static canonical check on address,
+ * (this allows for example to invalidate 5-level addresses of a guest from a
+ * host which uses 4-level paging).
+ */
+
+static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu,
+		unsigned int flags)
+{
+	if (flags & (X86EMUL_F_INVLPG | X86EMUL_F_MSR | X86EMUL_F_DT_LOAD))
+		return !__is_canonical_address(la, max_host_virt_addr_bits());
+	else
+		return !__is_canonical_address(la, vcpu_virt_addr_bits(vcpu));
+}
+
+static inline bool is_noncanonical_msr_address(u64 la, struct kvm_vcpu *vcpu)
+{
+	return is_noncanonical_address(la, vcpu, X86EMUL_F_MSR);
+}
+
+static inline bool is_noncanonical_base_address(u64 la, struct kvm_vcpu *vcpu)
+{
+	return is_noncanonical_address(la, vcpu, X86EMUL_F_DT_LOAD);
+}
+
+static inline bool is_noncanonical_invlpg_address(u64 la, struct kvm_vcpu *vcpu)
+{
+	return is_noncanonical_address(la, vcpu, X86EMUL_F_INVLPG);
 }
 
 static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
-- 
2.26.3


