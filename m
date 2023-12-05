Return-Path: <kvm+bounces-3488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FF5780508F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:38:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 299061F214EE
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F9194F20A;
	Tue,  5 Dec 2023 10:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJD/298r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CF9D69
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c/klRJP4rLh0x9sZLq/wGduGykKl7B0scuGA5LFO6zo=;
	b=EJD/298rl9TmrNNAV+56CpFGmh3NJFzBqbGAmiDhatdwSpk3tEdL1xU7smGtoYCzqXKEN+
	525I4AmqvpPPVRyCFTtFBOsxHoRgJAb7VZhGTGVBZmhavjZ/nA4lEP36P76p9qf/TY/WSj
	Q/NtcmryHYUJOi9l71RI2diWP9UCI3I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-YiUUe7vIOPqFTGK2Wfh53A-1; Tue, 05 Dec 2023 05:36:40 -0500
X-MC-Unique: YiUUe7vIOPqFTGK2Wfh53A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E416D101A555;
	Tue,  5 Dec 2023 10:36:39 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 20BAC2026D66;
	Tue,  5 Dec 2023 10:36:39 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 07/16] KVM: x86: hyper-v: Introduce kvm_hv_nested_transtion_tlb_flush() helper
Date: Tue,  5 Dec 2023 11:36:21 +0100
Message-ID: <20231205103630.1391318-8-vkuznets@redhat.com>
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

As a preparation to making Hyper-V emulation optional, introduce a helper
to handle pending KVM_REQ_HV_TLB_FLUSH requests.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.h     | 12 ++++++++++++
 arch/x86/kvm/svm/nested.c | 10 ++--------
 arch/x86/kvm/vmx/nested.c | 10 ++--------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index ddb1d0b019e6..75dcbe598fbc 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -246,6 +246,18 @@ static inline int kvm_hv_verify_vp_assist(struct kvm_vcpu *vcpu)
 	return kvm_hv_get_assist_page(vcpu);
 }
 
+static inline void kvm_hv_nested_transtion_tlb_flush(struct kvm_vcpu *vcpu, bool tdp_enabled)
+{
+	/*
+	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
+	 * L2's VP_ID upon request from the guest. Make sure we check for
+	 * pending entries in the right FIFO upon L1/L2 transition as these
+	 * requests are put by other vCPUs asynchronously.
+	 */
+	if (to_hv_vcpu(vcpu) && tdp_enabled)
+		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+}
+
 int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3fea8c47679e..74c04102ef01 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -487,14 +487,8 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
 
 static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
 {
-	/*
-	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
-	 * L2's VP_ID upon request from the guest. Make sure we check for
-	 * pending entries in the right FIFO upon L1/L2 transition as these
-	 * requests are put by other vCPUs asynchronously.
-	 */
-	if (to_hv_vcpu(vcpu) && npt_enabled)
-		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+	/* Handle pending Hyper-V TLB flush requests */
+	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
 
 	/*
 	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c5ec0ef51ff7..382c0746d069 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1139,14 +1139,8 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	/*
-	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
-	 * L2's VP_ID upon request from the guest. Make sure we check for
-	 * pending entries in the right FIFO upon L1/L2 transition as these
-	 * requests are put by other vCPUs asynchronously.
-	 */
-	if (to_hv_vcpu(vcpu) && enable_ept)
-		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+	/* Handle pending Hyper-V TLB flush requests */
+	kvm_hv_nested_transtion_tlb_flush(vcpu, enable_ept);
 
 	/*
 	 * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
-- 
2.43.0


