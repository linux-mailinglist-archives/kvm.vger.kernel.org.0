Return-Path: <kvm+bounces-43382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA90A8ACAF
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 02:27:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 454383B2CB1
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 00:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF48E1C7013;
	Wed, 16 Apr 2025 00:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YqNoI1dj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9F51B4145
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 00:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744763167; cv=none; b=YZJw4e1Wb+rQx+tzgwCHZz0ZBvQ/9b9hU2u9WO1gHCHdy5zhjUd/xZt9w77tn2gaUcaNcSkmPdvsNuc5dUpY947nUbS0nsMefzUXQzltAtTmbgNpZ4aKb77ldE3DfNpb6vZhuz2Axy/jDofcGolsAQ/LG6HisaMQYoPqP9lWAhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744763167; c=relaxed/simple;
	bh=Q8qF6BDf/6S5LWGmq6PR/aWYWuef18BVh7kuYS/Kj50=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DGssyrE0BP4WnqoCURTro3Ur8N5oCJioRsmbb8iU2EEa86QFAO3mUovU4ps1LGeQjL0q2V98wtSo3f/lNL4YoAwBp4iTlhofLlNsXYTKr/J+LuTrv6OWIbpOZZXUv40jvZocS+z0HnDxmpGCCSS1y/jY6bpDZwLcfbSpk0i4ayw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YqNoI1dj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744763164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Mgl6sRisXcZRgNT86fG/3NyNLX1AWDwAp5otPhtzEg=;
	b=YqNoI1djFvUr+S+9rPOK3hBVnQdLQ0g/N3Y4nEUcemKlumK0WDUbcWmQukmbEATnID9XF3
	0JjO2guzAlhhv8+tY3TT7PVkdfoikKEbelbRJA2QHjRJlGXs+4mXj9vPsBAlYoLwhmCLxB
	ZPLbNImFCzP6TVcjlXjz9puDVL9qg/o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-68-JxmHxrLFMDmsAw8fSA7c-w-1; Tue,
 15 Apr 2025 20:25:58 -0400
X-MC-Unique: JxmHxrLFMDmsAw8fSA7c-w-1
X-Mimecast-MFC-AGG-ID: JxmHxrLFMDmsAw8fSA7c-w_1744763157
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6812619560BB;
	Wed, 16 Apr 2025 00:25:57 +0000 (UTC)
Received: from starship.lan (unknown [10.22.82.37])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 469B0180B489;
	Wed, 16 Apr 2025 00:25:55 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/3] x86: KVM: VMX: preserve host's DEBUGCTLMSR_FREEZE_IN_SMM while in the guest mode
Date: Tue, 15 Apr 2025 20:25:46 -0400
Message-Id: <20250416002546.3300893-4-mlevitsk@redhat.com>
In-Reply-To: <20250416002546.3300893-1-mlevitsk@redhat.com>
References: <20250416002546.3300893-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Pass through the host's DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM to the guest
GUEST_IA32_DEBUGCTL without the guest seeing this value.

Note that in the future we might allow the guest to set this bit as well,
when we implement PMU freezing on VM own, virtual SMM entry.

Since the value of the host DEBUGCTL can in theory change between VM runs,
check if has changed, and if yes, then reload the GUEST_IA32_DEBUGCTL with
the new value of the host portion of it (currently only the
DEBUGCTLMSR_FREEZE_IN_SMM bit)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/vmx/vmx.c | 28 +++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c     |  2 --
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cc1c721ba067..fda0660236d8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4271,6 +4271,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
 	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
 
+	vcpu->arch.host_debugctl = get_debugctlmsr();
+
 	/*
 	 * Disable singlestep if we're injecting an interrupt/exception.
 	 * We don't want our modified rflags to be pushed on the stack where
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9208a4acda4..e0bc31598d60 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2194,6 +2194,17 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	return debugctl;
 }
 
+static u64 vmx_get_host_preserved_debugctl(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Bits of host's DEBUGCTL that we should preserve while the guest is
+	 * running.
+	 *
+	 * Some of those bits might still be emulated for the guest own use.
+	 */
+	return DEBUGCTLMSR_FREEZE_IN_SMM;
+}
+
 u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
 {
 	return to_vmx(vcpu)->msr_ia32_debugctl;
@@ -2202,9 +2213,11 @@ u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
 static void __vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u64 host_mask = vmx_get_host_preserved_debugctl(vcpu);
 
 	vmx->msr_ia32_debugctl = data;
-	vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+	vmcs_write64(GUEST_IA32_DEBUGCTL,
+		     (vcpu->arch.host_debugctl & host_mask) | (data & ~host_mask));
 }
 
 bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated)
@@ -2232,6 +2245,7 @@ bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated
 	return true;
 }
 
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -7349,6 +7363,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
+	u64 old_debugctl;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
@@ -7379,6 +7394,17 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 		vmcs_write32(PLE_WINDOW, vmx->ple_window);
 	}
 
+	old_debugctl = vcpu->arch.host_debugctl;
+	vcpu->arch.host_debugctl = get_debugctlmsr();
+
+	/*
+	 * In case the host DEBUGCTL had changed since the last time we
+	 * read it, update the guest's GUEST_IA32_DEBUGCTL with
+	 * the host's bits.
+	 */
+	if (old_debugctl != vcpu->arch.host_debugctl)
+		__vmx_set_guest_debugctl(vcpu, vmx->msr_ia32_debugctl);
+
 	/*
 	 * We did this in prepare_switch_to_guest, because it needs to
 	 * be within srcu_read_lock.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 844e81ee1d96..05e866ed345d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11020,8 +11020,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(0, 7);
 	}
 
-	vcpu->arch.host_debugctl = get_debugctlmsr();
-
 	guest_timing_enter_irqoff();
 
 	for (;;) {
-- 
2.26.3


