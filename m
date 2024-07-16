Return-Path: <kvm+bounces-21683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36710931EC3
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 04:20:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5417D1C20E98
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 02:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68A612B72;
	Tue, 16 Jul 2024 02:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ITLv1bUN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A45C63C7
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 02:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721096430; cv=none; b=AZJhJrD7qF5JCels4oYLoqynap94KlLfwnkl7M7EZJyRFYxeARwS4Sdtfk67rHMs/Y4hA6ty1hQcQN2a8acBoUwfq72bChW3AAiWDcjbH8hXPnAzApv7yu6m3TdO+1Ydh/UngmHqacZjiFBzR8ek3el3Qrm8Wiv2V1GVMzgRQs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721096430; c=relaxed/simple;
	bh=lEXc5gjKvu5Uz/oPRl7wcXZXLWopPIfPyyJP2ZMRGKQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YU37Kr7AJiLxDDyPVTPtpnZQPoTRsTipup/oy5MybIbnLthvwXNSzokAOV4e79SFjrTTnFS0+AURevoDGUxtKdtLp3fxTDM1tAQfmug1dzzoPhpID74o7l5taZx2aSPjdI6ANBfL5UtiWW8E+jVgVPMlsGf8N+3RoLSfH4V64OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ITLv1bUN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721096427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HYyR9emAHHuiEEEQowUbS/Zw4ecGPi9a6PDcqiR3LJE=;
	b=ITLv1bUNXzutPnrCtyyxyukmFAgjnUnjTZiK2DtFV6+fwyN5YN/WxxBqyBcblo3HpkV1cR
	BodvFZVfo0NNRX6rFUmRfFhsN40AbutKyGD2wMJDI01NfCTOxV6yoNMYkKRRdlZLZhQB+U
	tKMw7USQYcz02rTdz3+nIeAJftbl624=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-316-3gXy-Tr6PkS7O6kCdc5M4w-1; Mon,
 15 Jul 2024 22:20:24 -0400
X-MC-Unique: 3gXy-Tr6PkS7O6kCdc5M4w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73A2D1955D47;
	Tue, 16 Jul 2024 02:20:22 +0000 (UTC)
Received: from starship.lan (unknown [10.22.8.61])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2103D19560B2;
	Tue, 16 Jul 2024 02:20:19 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@alien8.de>,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 2/2] KVM: VMX: disable preemption when touching segment fields
Date: Mon, 15 Jul 2024 22:20:14 -0400
Message-Id: <20240716022014.240960-3-mlevitsk@redhat.com>
In-Reply-To: <20240716022014.240960-1-mlevitsk@redhat.com>
References: <20240716022014.240960-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

VMX code uses segment cache to avoid reading guest segment fields.

The cache is reset each time a segment's field (e.g base/access rights/etc)
is written, and then a new value of this field is written.

However if the vCPU is preempted between these two events, and this
segment field is read (e.g kvm reads SS's access rights to check
if the vCPU is in kernel mode), then old field value will get
cached and never updated.

Usually a lock is required to avoid such race but since vCPU segments
are only accessed by its vCPU thread, we can avoid a lock and
only disable preemption, in places where the segment cache
is invalidated and segment fields are updated.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c |  4 +++-
 arch/x86/kvm/vmx/vmx.c    | 25 +++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.h    | 14 +++++++++++++-
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d3ca1a772ae67..b6597fe5d011d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2470,7 +2470,7 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
 			   HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2)) {
 
-		vmx_segment_cache_clear(vmx);
+		vmx_write_segment_cache_start(vmx);
 
 		vmcs_write16(GUEST_ES_SELECTOR, vmcs12->guest_es_selector);
 		vmcs_write16(GUEST_CS_SELECTOR, vmcs12->guest_cs_selector);
@@ -2508,6 +2508,8 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_writel(GUEST_TR_BASE, vmcs12->guest_tr_base);
 		vmcs_writel(GUEST_GDTR_BASE, vmcs12->guest_gdtr_base);
 		vmcs_writel(GUEST_IDTR_BASE, vmcs12->guest_idtr_base);
+
+		vmx_write_segment_cache_end(vmx);
 	}
 
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fa9f307d9b18b..26a5efd34aef7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2171,12 +2171,14 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 #ifdef CONFIG_X86_64
 	case MSR_FS_BASE:
-		vmx_segment_cache_clear(vmx);
+		vmx_write_segment_cache_start(vmx);
 		vmcs_writel(GUEST_FS_BASE, data);
+		vmx_write_segment_cache_end(vmx);
 		break;
 	case MSR_GS_BASE:
-		vmx_segment_cache_clear(vmx);
+		vmx_write_segment_cache_start(vmx);
 		vmcs_writel(GUEST_GS_BASE, data);
+		vmx_write_segment_cache_end(vmx);
 		break;
 	case MSR_KERNEL_GS_BASE:
 		vmx_write_guest_kernel_gs_base(vmx, data);
@@ -3088,7 +3090,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 
 	vmx->rmode.vm86_active = 1;
 
-	vmx_segment_cache_clear(vmx);
+	vmx_write_segment_cache_start(vmx);
 
 	vmcs_writel(GUEST_TR_BASE, kvm_vmx->tss_addr);
 	vmcs_write32(GUEST_TR_LIMIT, RMODE_TSS_SIZE - 1);
@@ -3109,6 +3111,8 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	fix_rmode_seg(VCPU_SREG_DS, &vmx->rmode.segs[VCPU_SREG_DS]);
 	fix_rmode_seg(VCPU_SREG_GS, &vmx->rmode.segs[VCPU_SREG_GS]);
 	fix_rmode_seg(VCPU_SREG_FS, &vmx->rmode.segs[VCPU_SREG_FS]);
+
+	vmx_write_segment_cache_end(vmx);
 }
 
 int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
@@ -3139,8 +3143,9 @@ int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 static void enter_lmode(struct kvm_vcpu *vcpu)
 {
 	u32 guest_tr_ar;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	vmx_segment_cache_clear(to_vmx(vcpu));
+	vmx_write_segment_cache_start(vmx);
 
 	guest_tr_ar = vmcs_read32(GUEST_TR_AR_BYTES);
 	if ((guest_tr_ar & VMX_AR_TYPE_MASK) != VMX_AR_TYPE_BUSY_64_TSS) {
@@ -3150,6 +3155,9 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
 			     (guest_tr_ar & ~VMX_AR_TYPE_MASK)
 			     | VMX_AR_TYPE_BUSY_64_TSS);
 	}
+
+	vmx_write_segment_cache_end(vmx);
+
 	vmx_set_efer(vcpu, vcpu->arch.efer | EFER_LMA);
 }
 
@@ -3571,7 +3579,7 @@ void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	const struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
 
-	vmx_segment_cache_clear(vmx);
+	vmx_write_segment_cache_start(vmx);
 
 	if (vmx->rmode.vm86_active && seg != VCPU_SREG_LDTR) {
 		vmx->rmode.segs[seg] = *var;
@@ -3601,6 +3609,8 @@ void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 		var->type |= 0x1; /* Accessed */
 
 	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(var));
+
+	vmx_write_segment_cache_end(vmx);
 }
 
 void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
@@ -4870,7 +4880,8 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
 
-	vmx_segment_cache_clear(vmx);
+	vmx_write_segment_cache_start(vmx);
+
 	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);
 
 	seg_setup(VCPU_SREG_CS);
@@ -4899,6 +4910,8 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmcs_writel(GUEST_IDTR_BASE, 0);
 	vmcs_write32(GUEST_IDTR_LIMIT, 0xffff);
 
+	vmx_write_segment_cache_end(vmx);
+
 	vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 	vmcs_write32(GUEST_INTERRUPTIBILITY_INFO, 0);
 	vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 1689f0d59f435..cba14911032cd 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -755,9 +755,21 @@ static inline bool vmx_can_use_ipiv(struct kvm_vcpu *vcpu)
 	return  lapic_in_kernel(vcpu) && enable_ipiv;
 }
 
-static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
+static inline void vmx_write_segment_cache_start(struct vcpu_vmx *vmx)
+{
+	/* VMX segment cache can be accessed during preemption.
+	 * (e.g to determine the guest's CPL)
+	 *
+	 * To avoid caching a wrong value during such access, disable
+	 * the preemption
+	 */
+	preempt_disable();
+}
+
+static inline void vmx_write_segment_cache_end(struct vcpu_vmx  *vmx)
 {
 	vmx->segment_cache.bitmask = 0;
+	preempt_enable();
 }
 
 #endif /* __KVM_X86_VMX_H */
-- 
2.26.3


