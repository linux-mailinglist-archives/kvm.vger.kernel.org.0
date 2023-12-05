Return-Path: <kvm+bounces-3487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA2080508E
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4B53281801
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3185F56B69;
	Tue,  5 Dec 2023 10:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VlgtQoSQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B52D1BFA
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MLJSU/4UwoM7VC9xD7TyZKUiFxpyoD4EZFFtmiK2TOc=;
	b=VlgtQoSQNeA4gx8JBagwYXWFVldnQJmZQgOw1dB4HFiDG6egPmfXGTxcf9nr7nkAWRrkQZ
	6Sb7m3nb/u4vMsEWR8s1RLPnk8oUaZGhl5xSXskcp69VvB3lqgg0u1m3SR8wXnCX9JTUmA
	3d+yfnOVDjjFOhiJw/y8KTZ/acLBbZU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-580-AeKtpomgONapvPT-BjQkHw-1; Tue,
 05 Dec 2023 05:36:41 -0500
X-MC-Unique: AeKtpomgONapvPT-BjQkHw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7E2938135E1;
	Tue,  5 Dec 2023 10:36:40 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 242A22026D66;
	Tue,  5 Dec 2023 10:36:40 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 08/16] KVM: x86: hyper-v: Split off nested_evmcs_handle_vmclear()
Date: Tue,  5 Dec 2023 11:36:22 +0100
Message-ID: <20231205103630.1391318-9-vkuznets@redhat.com>
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

To avoid overloading handle_vmclear() with Hyper-V specific details and to
prepare the code to making Hyper-V emulation optional, create a dedicated
nested_evmcs_handle_vmclear() helper.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 382c0746d069..903b6f9ea2bd 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -243,6 +243,29 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 	}
 }
 
+static bool nested_evmcs_handle_vmclear(struct kvm_vcpu *vcpu, gpa_t vmptr)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	/*
+	 * When Enlightened VMEntry is enabled on the calling CPU we treat
+	 * memory area pointer by vmptr as Enlightened VMCS (as there's no good
+	 * way to distinguish it from VMCS12) and we must not corrupt it by
+	 * writing to the non-existent 'launch_state' field. The area doesn't
+	 * have to be the currently active EVMCS on the calling CPU and there's
+	 * nothing KVM has to do to transition it from 'active' to 'non-active'
+	 * state. It is possible that the area will stay mapped as
+	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
+	 */
+	if (!guest_cpuid_has_evmcs(vcpu) ||
+	    !evmptr_is_valid(nested_get_evmptr(vcpu)))
+		return false;
+
+	if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr)
+		nested_release_evmcs(vcpu);
+
+	return true;
+}
+
 static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
 				     struct loaded_vmcs *prev)
 {
@@ -5286,18 +5309,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 	if (vmptr == vmx->nested.vmxon_ptr)
 		return nested_vmx_fail(vcpu, VMXERR_VMCLEAR_VMXON_POINTER);
 
-	/*
-	 * When Enlightened VMEntry is enabled on the calling CPU we treat
-	 * memory area pointer by vmptr as Enlightened VMCS (as there's no good
-	 * way to distinguish it from VMCS12) and we must not corrupt it by
-	 * writing to the non-existent 'launch_state' field. The area doesn't
-	 * have to be the currently active EVMCS on the calling CPU and there's
-	 * nothing KVM has to do to transition it from 'active' to 'non-active'
-	 * state. It is possible that the area will stay mapped as
-	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
-	 */
-	if (likely(!guest_cpuid_has_evmcs(vcpu) ||
-		   !evmptr_is_valid(nested_get_evmptr(vcpu)))) {
+	if (likely(!nested_evmcs_handle_vmclear(vcpu, vmptr))) {
 		if (vmptr == vmx->nested.current_vmptr)
 			nested_release_vmcs12(vcpu);
 
@@ -5314,8 +5326,6 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 					   vmptr + offsetof(struct vmcs12,
 							    launch_state),
 					   &zero, sizeof(zero));
-	} else if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr) {
-		nested_release_evmcs(vcpu);
 	}
 
 	return nested_vmx_succeed(vcpu);
-- 
2.43.0


