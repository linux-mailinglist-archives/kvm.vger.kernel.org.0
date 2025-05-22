Return-Path: <kvm+bounces-47333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B75CBAC019D
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 02:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA7DC1B64B04
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 00:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3EC81917ED;
	Thu, 22 May 2025 00:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QevyXZt/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CE013774D
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 00:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747875379; cv=none; b=XkEAvDh2uRg0jDfxc/ovKrcPkda1A6U0SvhW/Efpx+iLsDPNEMZvc/gLhbfBvxOhhIdRsC0pM3hmtRny4C7UQPLvdDnlmf69uLTlK1pxxMaMV0y1gkPzKlQpqqxAtQ23AUWgJaI/enQ6byMx8gfOPhR01pZgzydP7BRPjYYqL04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747875379; c=relaxed/simple;
	bh=Zp1RHEXT2hWrz/iBxuTQFP+sktEBXlp7S0w6GkPVWuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sj6EAZURvXnIGoPrAZhiEtqBY8BM1xfVMS33Nhz9RiXa8ba/xzBTuVNIq/usJpz2kl1aSRg3j6LYCR0gMbE5TYJXRr+Ar8UJbxLVgEezFujqtTtl9cw+99H7+wn5Ce9itAr3pfWCay1DQA5KWhsHnqP2KHJK6reA5/BIcXuO0Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QevyXZt/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747875373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=egiQaKlG882xHvnXxJOJohJhG2/tS80sDRkBw5n8Lpc=;
	b=QevyXZt/+nNS6vVFWOIoPm3Kg8AjW+tDbO7rAcJm12ooFUjcWQSmu1cChkk5WTCYpjonap
	P3cVVur9E6ljP9/AvCnSfiiS1kwjI+dPaBx37gHybRhHwrQrKIfe0/ssldFaWp2lPIL2lO
	CM6Bfjk7ZQ1HxfAazMyPieFF7iTGQPA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-77-Yp-XUYY1PC-KWUK0HyPfWQ-1; Wed,
 21 May 2025 20:56:10 -0400
X-MC-Unique: Yp-XUYY1PC-KWUK0HyPfWQ-1
X-Mimecast-MFC-AGG-ID: Yp-XUYY1PC-KWUK0HyPfWQ_1747875369
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1DF4519560AA;
	Thu, 22 May 2025 00:56:09 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.22.80.5])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E10AF1956066;
	Thu, 22 May 2025 00:56:06 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v5 4/5] KVM: VMX: wrap guest access to IA32_DEBUGCTL with wrappers
Date: Wed, 21 May 2025 20:55:54 -0400
Message-ID: <20250522005555.55705-5-mlevitsk@redhat.com>
In-Reply-To: <20250522005555.55705-1-mlevitsk@redhat.com>
References: <20250522005555.55705-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Introduce two wrappers vmx_guest_debugctl_read and vmx_guest_debugctl_write
which read/write the GUEST_IA32_DEBUGCTL vmcs field.

In the next patch these wrappers will be used to hide the
DEBUGCTLMSR_FREEZE_IN_SMM bit from the guest.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c    |  4 ++--
 arch/x86/kvm/vmx/pmu_intel.c |  8 ++++----
 arch/x86/kvm/vmx/vmx.c       | 18 +++++++++++++++---
 arch/x86/kvm/vmx/vmx.h       |  2 ++
 4 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 00f2b762710c..b505f3f7e9ab 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2653,7 +2653,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (vmx->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
 		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
-		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl);
+		vmx_guest_debugctl_write(vcpu, vmcs12->guest_ia32_debugctl);
 	} else {
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
 		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugctl);
@@ -4789,7 +4789,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	__vmx_set_segment(vcpu, &seg, VCPU_SREG_LDTR);
 
 	kvm_set_dr(vcpu, 7, 0x400);
-	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
+	vmx_guest_debugctl_write(vcpu, 0);
 
 	if (nested_vmx_load_msr(vcpu, vmcs12->vm_exit_msr_load_addr,
 				vmcs12->vm_exit_msr_load_count))
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8a94b52c5731..578b4ef58260 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -652,11 +652,11 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
  */
 static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
 {
-	u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+	u64 data = vmx_guest_debugctl_read();
 
 	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
 		data &= ~DEBUGCTLMSR_LBR;
-		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		vmx_guest_debugctl_write(vcpu, data);
 	}
 }
 
@@ -729,7 +729,7 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 
 	if (!lbr_desc->event) {
 		vmx_disable_lbr_msrs_passthrough(vcpu);
-		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
+		if (vmx_guest_debugctl_read() & DEBUGCTLMSR_LBR)
 			goto warn;
 		if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
 			goto warn;
@@ -751,7 +751,7 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 
 static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
-	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
+	if (!(vmx_guest_debugctl_read() & DEBUGCTLMSR_LBR))
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9046ee2e9a04..cfab76b40780 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2154,7 +2154,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
-		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		msr_info->data = vmx_guest_debugctl_read();
 		break;
 	default:
 	find_uret_msr:
@@ -2194,6 +2194,16 @@ u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
 	return debugctl;
 }
 
+void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu, u64 val)
+{
+	vmcs_write64(GUEST_IA32_DEBUGCTL, val);
+}
+
+u64 vmx_guest_debugctl_read(void)
+{
+	return vmcs_read64(GUEST_IA32_DEBUGCTL);
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -2279,7 +2289,8 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 						VM_EXIT_SAVE_DEBUG_CONTROLS)
 			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
 
-		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		vmx_guest_debugctl_write(vcpu, data);
+
 		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
 		    (data & DEBUGCTLMSR_LBR))
 			intel_pmu_create_guest_lbr_event(vcpu);
@@ -4795,7 +4806,8 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	vmcs_write32(GUEST_SYSENTER_CS, 0);
 	vmcs_writel(GUEST_SYSENTER_ESP, 0);
 	vmcs_writel(GUEST_SYSENTER_EIP, 0);
-	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
+
+	vmx_guest_debugctl_write(&vmx->vcpu, 0);
 
 	if (cpu_has_vmx_tpr_shadow()) {
 		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index eb924c2acfd0..dffc0e18e5f7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -415,6 +415,8 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated);
+void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu, u64 val);
+u64 vmx_guest_debugctl_read(void);
 
 /*
  * Note, early Intel manuals have the write-low and read-high bitmap offsets
-- 
2.46.0


