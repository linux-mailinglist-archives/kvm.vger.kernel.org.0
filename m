Return-Path: <kvm+bounces-21593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84F1C930313
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 03:40:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39D6C283376
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 01:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB75B1DFD2;
	Sat, 13 Jul 2024 01:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HtwSPO0b"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE2F1B810
	for <kvm@vger.kernel.org>; Sat, 13 Jul 2024 01:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720834754; cv=none; b=f4+fZgMKxBfnkIwDqIMPeHfTXxZPXa83gxNArfQ2Q4qubHSI/emIJXxNzlpDz4UJatFx0uGTmyl4IyRPAV/804BizSpYxdo8yzR/FmnjKlrI3Jk8k+kW/ht00EgFuTmW8oZk7yVQPmdGStGAErLg5AKD4vP6XBMC9F33lZPgqBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720834754; c=relaxed/simple;
	bh=rmmSazM9fPl9PFUkyQ3+K4LxgLQ5aHTn49s/DK2lbco=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hxg9myN5wiZA9/LQRG2PxJmzU3NireoRXtKx/kdYtJLiATBAkuKHZ4nID7Xsyjmy/5x2Lwatd2a8tp59w2jo2DXEo0mWG/8wrkj8E/aY9Zj8S6D/y9E7Y2MMTL8bfFowB0h/JpTCKgCmhzffuqVkTV0z9RxDvuhyB/FqT8qGzn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HtwSPO0b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720834751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o/U+UT0RuDMuKBmtj3QhRV12LJvbIKhCn7gYmg/6+DE=;
	b=HtwSPO0baXJn6baHKG3giTihBY3YUsUXQTAEgDz6tX+9io9vHgPS7n6nSdX/t0MMNEbEY4
	jyK/jnCaDReatF4Ss3Ggvjmb1CA2wWoi6nf/ZKd5ddmf+XqFuuGFmrMQ9ibLHSYdui5Uzh
	Lz6ylci5nBnAEZ4Me+YxKJVONpWKFT0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-RJeING3vMGCfU6MtpfovcQ-1; Fri,
 12 Jul 2024 21:39:06 -0400
X-MC-Unique: RJeING3vMGCfU6MtpfovcQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A549619560B0;
	Sat, 13 Jul 2024 01:39:04 +0000 (UTC)
Received: from starship.lan (unknown [10.22.18.76])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C78483000188;
	Sat, 13 Jul 2024 01:39:01 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/2] KVM: VMX: disable preemption when writing guest segment state
Date: Fri, 12 Jul 2024 21:38:56 -0400
Message-Id: <20240713013856.1568501-3-mlevitsk@redhat.com>
In-Reply-To: <20240713013856.1568501-1-mlevitsk@redhat.com>
References: <20240713013856.1568501-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

VMX code uses a segment cache to avoid reading guest segment fields
from the vmcs.

The cache is reset each time a field that belongs to the guest segment
state is written.

However if the vCPU is preempted after the cache is reset but before a new
field value is written, a race can happen:

If during the preemption period the same field is read,
its old value is put in the cache and the cache is never updated when
execution returns to the preempted code which finally writes the new
value to the field.

Usually a lock is required to avoid a race in such cases but since
vCPU segment state should only be accessed by its vCPU thread,
we can avoid a lock and opt to only disable preemption,
in places where the segment cache is invalidated and
segment fields are updated.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c |  4 ++++
 arch/x86/kvm/vmx/vmx.c    | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d3ca1a772ae67..62c3c12b4c41d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2470,6 +2470,8 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
 			   HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2)) {
 
+		preempt_disable();
+
 		vmx_segment_cache_clear(vmx);
 
 		vmcs_write16(GUEST_ES_SELECTOR, vmcs12->guest_es_selector);
@@ -2508,6 +2510,8 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_writel(GUEST_TR_BASE, vmcs12->guest_tr_base);
 		vmcs_writel(GUEST_GDTR_BASE, vmcs12->guest_gdtr_base);
 		vmcs_writel(GUEST_IDTR_BASE, vmcs12->guest_idtr_base);
+
+		preempt_enable();
 	}
 
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fa9f307d9b18b..7b27723f787cc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2171,12 +2171,16 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 #ifdef CONFIG_X86_64
 	case MSR_FS_BASE:
+		preempt_disable();
 		vmx_segment_cache_clear(vmx);
 		vmcs_writel(GUEST_FS_BASE, data);
+		preempt_enable();
 		break;
 	case MSR_GS_BASE:
+		preempt_disable();
 		vmx_segment_cache_clear(vmx);
 		vmcs_writel(GUEST_GS_BASE, data);
+		preempt_enable();
 		break;
 	case MSR_KERNEL_GS_BASE:
 		vmx_write_guest_kernel_gs_base(vmx, data);
@@ -3088,6 +3092,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 
 	vmx->rmode.vm86_active = 1;
 
+	preempt_disable();
 	vmx_segment_cache_clear(vmx);
 
 	vmcs_writel(GUEST_TR_BASE, kvm_vmx->tss_addr);
@@ -3109,6 +3114,8 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	fix_rmode_seg(VCPU_SREG_DS, &vmx->rmode.segs[VCPU_SREG_DS]);
 	fix_rmode_seg(VCPU_SREG_GS, &vmx->rmode.segs[VCPU_SREG_GS]);
 	fix_rmode_seg(VCPU_SREG_FS, &vmx->rmode.segs[VCPU_SREG_FS]);
+
+	preempt_enable();
 }
 
 int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
@@ -3140,6 +3147,7 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
 {
 	u32 guest_tr_ar;
 
+	preempt_disable();
 	vmx_segment_cache_clear(to_vmx(vcpu));
 
 	guest_tr_ar = vmcs_read32(GUEST_TR_AR_BYTES);
@@ -3150,6 +3158,9 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
 			     (guest_tr_ar & ~VMX_AR_TYPE_MASK)
 			     | VMX_AR_TYPE_BUSY_64_TSS);
 	}
+
+	preempt_enable();
+
 	vmx_set_efer(vcpu, vcpu->arch.efer | EFER_LMA);
 }
 
@@ -3571,6 +3582,7 @@ void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	const struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
 
+	preempt_disable();
 	vmx_segment_cache_clear(vmx);
 
 	if (vmx->rmode.vm86_active && seg != VCPU_SREG_LDTR) {
@@ -3601,6 +3613,8 @@ void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 		var->type |= 0x1; /* Accessed */
 
 	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(var));
+
+	preempt_enable();
 }
 
 void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
@@ -4870,6 +4884,8 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
 
+	preempt_disable();
+
 	vmx_segment_cache_clear(vmx);
 	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);
 
@@ -4899,6 +4915,8 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmcs_writel(GUEST_IDTR_BASE, 0);
 	vmcs_write32(GUEST_IDTR_LIMIT, 0xffff);
 
+	preempt_enable();
+
 	vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 	vmcs_write32(GUEST_INTERRUPTIBILITY_INFO, 0);
 	vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, 0);
-- 
2.26.3


