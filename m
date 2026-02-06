Return-Path: <kvm+bounces-70484-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iBjQNK88hmnzLAQAu9opvQ
	(envelope-from <kvm+bounces-70484-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:10:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4705F102779
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:10:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E0D8F3054651
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0345A429821;
	Fri,  6 Feb 2026 19:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vaod6+qk"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFFD42E007
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770404960; cv=none; b=fDTO/y8MYujX3uv9kx+Ier2tKHOQp7i3sIzkrje4JPirkOEsxoHBm+e7xs9qt1RfqlNhZXNBFhZXAeIvwCO5mup0YJO1IafEtDxCJCLHJw3wE4yIAlIGdBHTr9vhIyS0cF9pnNxiVrdYy9iGyRT4kItEaU2xdz+yrhji/aKTc+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770404960; c=relaxed/simple;
	bh=Uul8kI2RxcPnhJaSXw4jvPJlHmrZxMybTonVAnUSJqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lW5skuZtIlK+DR6S1KdeLujPXAFEyiN9+h6/otXh6f1erYoK3oXIHgee2sQoOhqvh7OyvL1koNOMQFupZD21cIQEacojkxs7mDx1kPl4v5+JhPwSZ89ZWhK5SuxFO2ukzgRj2Lr2Ia7ZoWhB/BNOh9t7nz4ltYWvrIkHJsVcz/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vaod6+qk; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770404958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1U7vm49UR6+uOywZi/EV8GxihCiORkBtPEhghinikMI=;
	b=vaod6+qkxWj+w5+abRj1eQBn0Xg7VnhWRpl8N7URouVGC7VAD/xl2+c//pexPwNNARlaDp
	spuqnT0QmoKNj/MlM0tODQr6hXiX4kz7ma0lZEgPBtOR66lgMS7Y3gYihXv2nXklgymaws
	8E1VQiUHHywZfvEC9SbiU8iTnas5fS0=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v5 06/26] KVM: nSVM: Triple fault if mapping VMCB12 fails on nested #VMEXIT
Date: Fri,  6 Feb 2026 19:08:31 +0000
Message-ID: <20260206190851.860662-7-yosry.ahmed@linux.dev>
In-Reply-To: <20260206190851.860662-1-yosry.ahmed@linux.dev>
References: <20260206190851.860662-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70484-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.997];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 4705F102779
X-Rspamd-Action: no action

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
index fab0d3d5baa2..830341b0e1f8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1121,24 +1121,14 @@ void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
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
@@ -1146,8 +1136,16 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
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
@@ -1304,8 +1302,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_uninit_mmu_context(vcpu);
 
-	rc = nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true);
-	if (rc)
+	if (nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true))
 		return 1;
 
 	/*
@@ -1936,7 +1933,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 {
-	if (WARN_ON(!is_guest_mode(vcpu)))
+	if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
 		return true;
 
 	if (!vcpu->arch.pdptrs_from_userspace &&
-- 
2.53.0.rc2.204.g2597b5adb4-goog


