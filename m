Return-Path: <kvm+bounces-68116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C9E3D21F4D
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:14:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B34BF302AF8F
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13D8525A2C6;
	Thu, 15 Jan 2026 01:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N2DwNffe"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF0B23185D
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439625; cv=none; b=h8NWuLkdt1y2gs47C7+vddPVs959J903Oa1SjvuYLgI8FTqZRhkNeGzU5R/2bXoDcwQ8L4ZfbazC8jt4Z+Zk/MOPBcXv9N72KYVI6N5ADCOvwsnyJlKjmSTwyn4byrXf4fm9cI7UxyhqzXCJ/yqMRg3x+hjs0Qty8F9Z3Tqosyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439625; c=relaxed/simple;
	bh=kPBEhtet7msW97U1UtkWQGIvip99lcuempTwCIzWZFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFXH92sTVnKVDIebg48PAqKen2K9mQuTbEnyANQYhU9qMbVy7aA6BJ69MC6R84cQf7mbGojZGkb4g/GuT2T4juazqGxWOjVtc820cOLrVgXuKr+sir7ilIT/HO3KRqn4exejhLQp6ApMnXsN62VDabmP+DUw11aN8fZQUFVZVPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N2DwNffe; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mt6kDFRpZShd33pI8JsOKS60v65HU+EMybZ/DpWM4YU=;
	b=N2DwNffeDX8lNt2584gxr5RQ79K63tB9QilojzNKYGwzioxI0GJigiS6aDCvCYJQTkcVyw
	Q9bESgh338IFnK5aokx2z8wOQ+x3FSEDg/h9BANRwGEOGQAlThbiWzalzwMQVY5+Ekkk6y
	077Daxj+aswBnkH/7zplP79LkAlRm5Y=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v4 05/26] KVM: nSVM: Triple fault if mapping VMCB12 fails on nested #VMEXIT
Date: Thu, 15 Jan 2026 01:12:51 +0000
Message-ID: <20260115011312.3675857-6-yosry.ahmed@linux.dev>
In-Reply-To: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM currently injects a #GP and hopes for the best if mapping VMCB12
fails on nested #VMEXIT, and only if the failure mode is -EINVAL.
Mapping the VMCB12 could also fail if creating host mappings fails.

After the #GP is injected, nested_svm_vmexit() bails early, without
cleaning up (e.g. KVM_REQ_GET_NESTED_STATE_PAGES is set, is_guest_mode()
is true, etc). Move mapping VMCB12 a bit later, after leaving guest mode
and clearing KVM_REQ_GET_NESTED_STATE_PAGES, right before the VMCB12 is
actually used.

Instead of optionally injecting a #GP, triple fault the guest if mapping
VMCB12 fails since KVM cannot make a sane recovery. The APM states that
a #VMEXIT will triple fault if host state is illegal or an exception
occurs while loading host state, so the behavior is not entirely made
up.

Also update the WARN_ON() in svm_get_nested_state_pages() to
WARN_ON_ONCE() to avoid future user-triggeable bugs spamming kernel logs
and potentially causing issues.

Fixes: cf74a78b229d ("KVM: SVM: Add VMEXIT handler and intercepts")
CC: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5f9c5ccc4783..593f7005cdc7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1127,24 +1127,14 @@ void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
 int nested_svm_vmexit(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
+	gpa_t vmcb12_gpa = svm->nested.vmcb12_gpa;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
 	struct vmcb *vmcb12;
 	struct kvm_host_map map;
-	int rc;
-
-	rc = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
-	if (rc) {
-		if (rc == -EINVAL)
-			kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-
-	vmcb12 = map.hva;
 
 	/* Exit Guest-Mode */
 	leave_guest_mode(vcpu);
-	svm->nested.vmcb12_gpa = 0;
 	WARN_ON_ONCE(svm->nested.nested_run_pending);
 
 	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
@@ -1152,8 +1142,16 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	/* in case we halted in L2 */
 	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 
+	svm->nested.vmcb12_gpa = 0;
+
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return 1;
+	}
+
 	/* Give the current vmcb to the guest */
 
+	vmcb12 = map.hva;
 	vmcb12->save.es     = vmcb02->save.es;
 	vmcb12->save.cs     = vmcb02->save.cs;
 	vmcb12->save.ss     = vmcb02->save.ss;
@@ -1311,8 +1309,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_uninit_mmu_context(vcpu);
 
-	rc = nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true);
-	if (rc)
+	if (nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true))
 		return 1;
 
 	/*
@@ -1947,7 +1944,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 {
-	if (WARN_ON(!is_guest_mode(vcpu)))
+	if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
 		return true;
 
 	if (!vcpu->arch.pdptrs_from_userspace &&
-- 
2.52.0.457.g6b5491de43-goog


