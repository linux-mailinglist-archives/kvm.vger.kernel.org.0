Return-Path: <kvm+bounces-16855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE5D8BE7B4
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:46:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73286286799
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C3B316C87F;
	Tue,  7 May 2024 15:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W2p633vc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E7F16ABFD
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715096708; cv=none; b=rv9sEr/IyWdTntSpOfujidMpLWPTCrp6ru8mmWvfmoDFZyvGpkDhh7kKLVL7NKu1vxwa5t9Kgn0rQiRoUaqHVhCBTExJYZd5FHki34KgtBorw01DMAtUE6GYCrApKzsvguYVZsBDuh/SbVHqHYshkE9RwfQxEo6ep0g+HJFedYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715096708; c=relaxed/simple;
	bh=L3kGN8uyw/Ew7Q01CNgiHp9NV1lLvt9g54vof/4wKgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EMCY9ND9E1Xmn/ob5m18qm3JfGU7lvPKfJXHVCZ/xNgaatP2Nr6mBLdu7S0uCvtEBHhfIVFKU5SjsJOjLoNYBs9sOf4Jnzx7wlEmnXAI3hkHGsDmqAHCwS8ZsfXv8r5KoMzfe7UZ5r8BFG5g7aPTx/YXJaYvtENpVPnfzEs37Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W2p633vc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715096705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DEGWSMU46Vtho/KF+via1nc+bZYocNO5WGIxzuJ1CSE=;
	b=W2p633vcurrXPzsoO4pO3KOd76oK6lj8UAtKYvKI6zGMskJiJUqo0VIVe/v8lbpTJTf50p
	by6H5HSjvnjJpPUXh2C+P2AcNpKN8WzZ4La57138MBEokZm+umXlIJGZoydSqQ5hoH8mX7
	/pFWOlJvrQs40BzPE8906wC/ipc+gFg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-F8TAFoFqM4KhUeU4rQv1Yw-1; Tue, 07 May 2024 11:45:02 -0400
X-MC-Unique: F8TAFoFqM4KhUeU4rQv1Yw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4453101A55E;
	Tue,  7 May 2024 15:45:01 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C8A67C154E5;
	Tue,  7 May 2024 15:45:01 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 7/7] KVM: VMX: Introduce test mode related to EPT violation VE
Date: Tue,  7 May 2024 11:44:59 -0400
Message-ID: <20240507154459.3950778-8-pbonzini@redhat.com>
In-Reply-To: <20240507154459.3950778-1-pbonzini@redhat.com>
References: <20240507154459.3950778-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

From: Isaku Yamahata <isaku.yamahata@intel.com>

To support TDX, KVM is enhanced to operate with #VE.  For TDX, KVM uses the
suppress #VE bit in EPT entries selectively, in order to be able to trap
non-present conditions.  However, #VE isn't used for VMX and it's a bug
if it happens.  To be defensive and test that VMX case isn't broken
introduce an option ept_violation_ve_test and when it's set, BUG the vm.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-Id: <d6db6ba836605c0412e166359ba5c46a63c22f86.1705965635.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Kconfig    | 13 ++++++++++
 arch/x86/kvm/vmx/vmcs.h |  5 ++++
 arch/x86/kvm/vmx/vmx.c  | 53 ++++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h  |  6 ++++-
 4 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 0ebdd088f28b..d64fb2b3eb69 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -95,6 +95,19 @@ config KVM_INTEL
 	  To compile this as a module, choose M here: the module
 	  will be called kvm-intel.
 
+config KVM_INTEL_PROVE_VE
+        bool "Check that guests do not receive #VE exceptions"
+        default KVM_PROVE_MMU || DEBUG_KERNEL
+        depends on KVM_INTEL
+        help
+
+          Checks that KVM's page table management code will not incorrectly
+          let guests receive a virtualization exception.  Virtualization
+          exceptions will be trapped by the hypervisor rather than injected
+          in the guest.
+
+          If unsure, say N.
+
 config X86_SGX_KVM
 	bool "Software Guard eXtensions (SGX) Virtualization"
 	depends on X86_SGX && KVM_INTEL
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 7c1996b433e2..b25625314658 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -140,6 +140,11 @@ static inline bool is_nm_fault(u32 intr_info)
 	return is_exception_n(intr_info, NM_VECTOR);
 }
 
+static inline bool is_ve_fault(u32 intr_info)
+{
+	return is_exception_n(intr_info, VE_VECTOR);
+}
+
 /* Undocumented: icebp/int1 */
 static inline bool is_icebp(u32 intr_info)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d780eee9b697..f4644f61d770 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -869,6 +869,12 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 
 	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR) | (1u << MC_VECTOR) |
 	     (1u << DB_VECTOR) | (1u << AC_VECTOR);
+	/*
+	 * #VE isn't used for VMX.  To test against unexpected changes
+	 * related to #VE for VMX, intercept unexpected #VE and warn on it.
+	 */
+	if (IS_ENABLED(CONFIG_KVM_INTEL_PROVE_VE))
+		eb |= 1u << VE_VECTOR;
 	/*
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
@@ -2602,6 +2608,9 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 					&_cpu_based_2nd_exec_control))
 			return -EIO;
 	}
+	if (!IS_ENABLED(CONFIG_KVM_INTEL_PROVE_VE))
+		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
+
 #ifndef CONFIG_X86_64
 	if (!(_cpu_based_2nd_exec_control &
 				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
@@ -2626,6 +2635,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			return -EIO;
 
 		vmx_cap->ept = 0;
+		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
 	}
 	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_VPID) &&
 	    vmx_cap->vpid) {
@@ -4588,6 +4598,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_VPID;
 	if (!enable_ept) {
 		exec_control &= ~SECONDARY_EXEC_ENABLE_EPT;
+		exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
 		enable_unrestricted_guest = 0;
 	}
 	if (!enable_unrestricted_guest)
@@ -4711,8 +4722,12 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 
 	exec_controls_set(vmx, vmx_exec_control(vmx));
 
-	if (cpu_has_secondary_exec_ctrls())
+	if (cpu_has_secondary_exec_ctrls()) {
 		secondary_exec_controls_set(vmx, vmx_secondary_exec_control(vmx));
+		if (vmx->ve_info)
+			vmcs_write64(VE_INFORMATION_ADDRESS,
+				     __pa(vmx->ve_info));
+	}
 
 	if (cpu_has_tertiary_exec_ctrls())
 		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
@@ -5200,6 +5215,9 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	if (is_invalid_opcode(intr_info))
 		return handle_ud(vcpu);
 
+	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm))
+		return -EIO;
+
 	error_code = 0;
 	if (intr_info & INTR_INFO_DELIVER_CODE_MASK)
 		error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
@@ -6409,8 +6427,22 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 		pr_err("Virtual processor ID = 0x%04x\n",
 		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
 	if (secondary_exec_control & SECONDARY_EXEC_EPT_VIOLATION_VE) {
-		pr_err("VE info address = 0x%016llx\n",
-		       vmcs_read64(VE_INFORMATION_ADDRESS));
+		struct vmx_ve_information *ve_info = vmx->ve_info;
+		u64 ve_info_pa = vmcs_read64(VE_INFORMATION_ADDRESS);
+
+		/*
+		 * If KVM is dumping the VMCS, then something has gone wrong
+		 * already.  Derefencing an address from the VMCS, which could
+		 * very well be corrupted, is a terrible idea.  The virtual
+		 * address is known so use it.
+		 */
+		pr_err("VE info address = 0x%016llx%s\n", ve_info_pa,
+		       ve_info_pa == __pa(ve_info) ? "" : "(corrupted!)");
+		pr_err("ve_info: 0x%08x 0x%08x 0x%016llx 0x%016llx 0x%016llx 0x%04x\n",
+		       ve_info->exit_reason, ve_info->delivery,
+		       ve_info->exit_qualification,
+		       ve_info->guest_linear_address,
+		       ve_info->guest_physical_address, ve_info->eptp_index);
 	}
 }
 
@@ -7466,6 +7498,7 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
+	free_page((unsigned long)vmx->ve_info);
 }
 
 int vmx_vcpu_create(struct kvm_vcpu *vcpu)
@@ -7559,6 +7592,20 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 			goto free_vmcs;
 	}
 
+	err = -ENOMEM;
+	if (vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_EPT_VIOLATION_VE) {
+		struct page *page;
+
+		BUILD_BUG_ON(sizeof(*vmx->ve_info) > PAGE_SIZE);
+
+		/* ve_info must be page aligned. */
+		page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		if (!page)
+			goto free_vmcs;
+
+		vmx->ve_info = page_to_virt(page);
+	}
+
 	if (vmx_can_use_ipiv(vcpu))
 		WRITE_ONCE(to_kvm_vmx(vcpu->kvm)->pid_table[vcpu->vcpu_id],
 			   __pa(&vmx->pi_desc) | PID_TABLE_ENTRY_VALID);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 65786dbe7d60..0da79a386825 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -362,6 +362,9 @@ struct vcpu_vmx {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 	} shadow_msr_intercept;
+
+	/* ve_info must be page aligned. */
+	struct vmx_ve_information *ve_info;
 };
 
 struct kvm_vmx {
@@ -574,7 +577,8 @@ static inline u8 vmx_get_rvi(void)
 	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
 	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
 	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
-	 SECONDARY_EXEC_ENCLS_EXITING)
+	 SECONDARY_EXEC_ENCLS_EXITING |					\
+	 SECONDARY_EXEC_EPT_VIOLATION_VE)
 
 #define KVM_REQUIRED_VMX_TERTIARY_VM_EXEC_CONTROL 0
 #define KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL			\
-- 
2.43.0


