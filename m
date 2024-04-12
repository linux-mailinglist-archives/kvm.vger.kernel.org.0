Return-Path: <kvm+bounces-14560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D15558A34E2
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 19:37:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 461091F216E8
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 17:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DBC0152161;
	Fri, 12 Apr 2024 17:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z8mQsK1D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9202714F11B
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 17:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943342; cv=none; b=RFLnwD14oUFiVlCcoe49WQYOYt16STERy5iM2Y1PWj2PA/5O/GSL3YIxru/X4QIWnjhqPWf7EiP3Dk6gOOqWhi5RvGwJ6VXMi0K2pG5gfs8bdT4jQ2Qyw2v85+Gv5bLQZsWuf8tWhy6w6sIpYcVY6TjnsZnCmwZ1FmVFigMad88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943342; c=relaxed/simple;
	bh=bPjAUZMA01b9lUF0UD8JVCw3aUt22kqfXXw3vYFxhg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LSWfRHiEgf/ANRHrRJWng0CKXRkQbxLrShacy9NkMmD8PWSsHbbf4forgYylk+D1i4nrwIakqTolnRrsEw6rfuMqD9/vJyzHxmcOwpNv2zKfkZ8Qd5bM+4vqaSJdxKZJHYZLCNPWMUI+CAMpPqqvrXTPjwu024zYDpK/rLuGsh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z8mQsK1D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712943339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=08wrH4E5iMZpPUrk1H4xeC+yRmkAmHopAddNodFzADc=;
	b=Z8mQsK1DiPNNVId8qOgpb0XhhJb1xH1+X62oCZR2S6gMViGxft/NorG8wYinAsnsUlH9ZA
	ZOqM4y9oqjjX9jEWNpLg1O9ryS4VKaL/aYPXTT80w7brcEF07AmULdXwbQUXQw4kf0e4So
	Ixd7WBtJaLnCFMvOpP5SBPzbG4SYSnE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-CrK2vUYrNbmLuiFSkaIp7Q-1; Fri,
 12 Apr 2024 13:35:36 -0400
X-MC-Unique: CrK2vUYrNbmLuiFSkaIp7Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CDF638049FC;
	Fri, 12 Apr 2024 17:35:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3FDCB492BC7;
	Fri, 12 Apr 2024 17:35:34 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 07/10] KVM: VMX: Introduce test mode related to EPT violation VE
Date: Fri, 12 Apr 2024 13:35:29 -0400
Message-ID: <20240412173532.3481264-8-pbonzini@redhat.com>
In-Reply-To: <20240412173532.3481264-1-pbonzini@redhat.com>
References: <20240412173532.3481264-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

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
 arch/x86/kvm/vmx/vmx.c  | 53 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h  |  6 ++++-
 4 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 3aaf7e86a859..7632fe6e4db9 100644
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
index 2c746318c6c3..1a5ad18a1fee 100644
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
@@ -4711,8 +4722,40 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 
 	exec_controls_set(vmx, vmx_exec_control(vmx));
 
-	if (cpu_has_secondary_exec_ctrls())
+	if (cpu_has_secondary_exec_ctrls()) {
 		secondary_exec_controls_set(vmx, vmx_secondary_exec_control(vmx));
+		if (secondary_exec_controls_get(vmx) &
+		    SECONDARY_EXEC_EPT_VIOLATION_VE) {
+			if (!vmx->ve_info) {
+				/* ve_info must be page aligned. */
+				struct page *page;
+
+				BUILD_BUG_ON(sizeof(*vmx->ve_info) > PAGE_SIZE);
+				page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+				if (page)
+					vmx->ve_info = page_to_virt(page);
+			}
+			if (vmx->ve_info) {
+				/*
+				 * Allow #VE delivery. CPU sets this field to
+				 * 0xFFFFFFFF on #VE delivery.  Another #VE can
+				 * occur only if software clears the field.
+				 */
+				vmx->ve_info->delivery = 0;
+				vmcs_write64(VE_INFORMATION_ADDRESS,
+					     __pa(vmx->ve_info));
+			} else {
+				/*
+				 * Because SECONDARY_EXEC_EPT_VIOLATION_VE is
+				 * used only for debugging, it's okay to leave
+				 * it disabled.
+				 */
+				pr_err("Failed to allocate ve_info. disabling EPT_VIOLATION_VE.\n");
+				secondary_exec_controls_clearbit(vmx,
+								 SECONDARY_EXEC_EPT_VIOLATION_VE);
+			}
+		}
+	}
 
 	if (cpu_has_tertiary_exec_ctrls())
 		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
@@ -5200,6 +5243,12 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	if (is_invalid_opcode(intr_info))
 		return handle_ud(vcpu);
 
+	/*
+	 * #VE isn't supposed to happen.  Block the VM if it does.
+	 */
+	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm))
+		return -EIO;
+
 	error_code = 0;
 	if (intr_info & INTR_INFO_DELIVER_CODE_MASK)
 		error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
@@ -7474,6 +7523,8 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
+	if (vmx->ve_info)
+		free_page((unsigned long)vmx->ve_info);
 }
 
 int vmx_vcpu_create(struct kvm_vcpu *vcpu)
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



