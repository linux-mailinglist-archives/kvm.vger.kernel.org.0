Return-Path: <kvm+bounces-3497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 766708050A5
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:39:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20C021F21548
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3385811E;
	Tue,  5 Dec 2023 10:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cglEG5i/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820602128
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=htiGHbeyXNiYCkR8OHujWzzeL+6avUzi5oQYbcmjURw=;
	b=cglEG5i/4DzojNIh/DGC+CvhoDH3XuVqqxzcNvDnGhVEV25+WzgcxzZ3YgHygi7qGyxbjT
	gXlGEeU6tOFYfcgDciCdvSUWOrkVrE6wNmXvotbzrBPLlNIONSbXJUb1Av2NhQFAgYsC+Q
	SgEkTaQ1V8KY8gn7x2I07+wgLCa5cv4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-uHZy1bAoOKex9KOJ56gxPQ-1; Tue,
 05 Dec 2023 05:36:49 -0500
X-MC-Unique: uHZy1bAoOKex9KOJ56gxPQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12DB71C0690F;
	Tue,  5 Dec 2023 10:36:49 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 440182026F95;
	Tue,  5 Dec 2023 10:36:48 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 16/16] KVM: nSVM: hyper-v: Hide more stuff under CONFIG_KVM_HYPERV/CONFIG_HYPERV
Date: Tue,  5 Dec 2023 11:36:30 +0100
Message-ID: <20231205103630.1391318-17-vkuznets@redhat.com>
In-Reply-To: <20231205103630.1391318-1-vkuznets@redhat.com>
References: <20231205103630.1391318-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

'struct hv_vmcb_enlightenments' in VMCB only make sense when either
CONFIG_KVM_HYPERV or CONFIG_HYPERV is enabled.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 20 ++++++++++++++------
 arch/x86/kvm/svm/svm.h    |  2 ++
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 74c04102ef01..20212aac050b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -187,7 +187,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
  */
 static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
-	struct hv_vmcb_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
 	int i;
 
 	/*
@@ -198,11 +197,16 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	 * - Nested hypervisor (L1) is using Hyper-V emulation interface and
 	 * tells KVM (L0) there were no changes in MSR bitmap for L2.
 	 */
-	if (!svm->nested.force_msr_bitmap_recalc &&
-	    kvm_hv_hypercall_enabled(&svm->vcpu) &&
-	    hve->hv_enlightenments_control.msr_bitmap &&
-	    (svm->nested.ctl.clean & BIT(HV_VMCB_NESTED_ENLIGHTENMENTS)))
-		goto set_msrpm_base_pa;
+#ifdef CONFIG_KVM_HYPERV
+	if (!svm->nested.force_msr_bitmap_recalc) {
+		struct hv_vmcb_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
+
+		if (kvm_hv_hypercall_enabled(&svm->vcpu) &&
+		    hve->hv_enlightenments_control.msr_bitmap &&
+		    (svm->nested.ctl.clean & BIT(HV_VMCB_NESTED_ENLIGHTENMENTS)))
+			goto set_msrpm_base_pa;
+	}
+#endif
 
 	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
 		return true;
@@ -230,7 +234,9 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 
 	svm->nested.force_msr_bitmap_recalc = false;
 
+#ifdef CONFIG_KVM_HYPERV
 set_msrpm_base_pa:
+#endif
 	svm->vmcb->control.msrpm_base_pa = __sme_set(__pa(svm->nested.msrpm));
 
 	return true;
@@ -378,12 +384,14 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->msrpm_base_pa &= ~0x0fffULL;
 	to->iopm_base_pa  &= ~0x0fffULL;
 
+#ifdef CONFIG_KVM_HYPERV
 	/* Hyper-V extensions (Enlightened VMCB) */
 	if (kvm_hv_hypercall_enabled(vcpu)) {
 		to->clean = from->clean;
 		memcpy(&to->hv_enlightenments, &from->hv_enlightenments,
 		       sizeof(to->hv_enlightenments));
 	}
+#endif
 }
 
 void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index be67ab7fdd10..59adff7bbf55 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -148,7 +148,9 @@ struct vmcb_ctrl_area_cached {
 	u64 virt_ext;
 	u32 clean;
 	union {
+#if IS_ENABLED(CONFIG_HYPERV) || IS_ENABLED(CONFIG_KVM_HYPERV)
 		struct hv_vmcb_enlightenments hv_enlightenments;
+#endif
 		u8 reserved_sw[32];
 	};
 };
-- 
2.43.0


