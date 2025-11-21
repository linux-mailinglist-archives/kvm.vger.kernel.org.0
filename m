Return-Path: <kvm+bounces-64250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A9848C7BAD2
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 21:51:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9FDD335C96F
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 20:49:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 210ED3043DE;
	Fri, 21 Nov 2025 20:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L2sJfYTI"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3806C2E8B81
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 20:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763758114; cv=none; b=DcM3yUcsraXIc9TnuPE0nEGdgTF8nU/X6YcJkh2aXmBGL/D3C51hfnsJiIiJOvHBUOn4qBkPDAGhp2RYCJSkFT2zYdSgxOOo9xgl5DXMzJ9ww6xOcqMmUDxZACpNKsiEPIStTjplNJduTz5QPWwP99GGhFYV4p3Bb6p5Uz4u41o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763758114; c=relaxed/simple;
	bh=xYS8H6/0UUmouN5GVWD4Eo8hgJ12Vdry9gEsssWalO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEVVRFFRCw9WIa4d4iCnJO0uGbXlZV7lUuSRUznHXN0GLWGadwEk36/4064z5X6r8uYKstgoyGKsL+QVjVYWgv9alIAD+rqUFm+vf111Ze01rEgBdxV97hnXNS3aytEW2QL81z3+tA4FIW9sgI8M+qnLbo/GNamUNKNu2RfegNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L2sJfYTI; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763758110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yebUz1pXbjwMucTv3QtFNCAWpvy3WqTDVf0fs8bk+I0=;
	b=L2sJfYTIHBeSXNzU6gkmRnfM+cgbbkNE1MKI9xaOpHxEMpBxVGWtLcg05QDBTzkKc4oDBI
	QnxFQXXAMjWaL0rKOcpm6CXShuKgt5JrvEL9ssY6OkmFWMyB5g1h8Cj1w5a0JWoOVUF1SW
	0ZmoHfKjf9bjUC0ihET2xEZI2O0Jc7w=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 2/4] KVM: SVM: Don't set GIF when clearing EFER.SVME
Date: Fri, 21 Nov 2025 20:48:01 +0000
Message-ID: <20251121204803.991707-3-yosry.ahmed@linux.dev>
In-Reply-To: <20251121204803.991707-1-yosry.ahmed@linux.dev>
References: <20251121204803.991707-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jim Mattson <jmattson@google.com>

Clearing EFER.SVME is not architected to set GIF. Don't set GIF when
emulating a change to EFER that clears EFER.SVME.

However, keep setting GIF if clearing EFER.SVME causes force-leaving the
nested guest through svm_leave_nested(), to maintain a sane behavior of
not leaving GIF cleared after exiting the guest.  In every other path,
setting GIF is either correct/desirable, or irrelevant because the
caller immediately and unconditionally sets/clears GIF.

This is more-or-less KVM defining HW behavior, but leaving GIF cleared
would also be defining HW behavior anyway.

Note that if force-leaving the nested guest is considered a SHUTDOWN,
then this could violate the APM-specified behavior:

  If the processor enters the shutdown state (due to a triple fault for
  instance) while GIF is clear, it can only be restarted by means of a
  RESET.

However, a SHUTDOWN leaves the VMCB undefined, so there's not a lot that
KVM can do in this case. Also, if vGIF is enabled on SHUTDOWN, KVM has
no way of finding out of GIF was cleared.

The only way for KVM to handle this without making up HW behavior is to
completely terminate the VM, so settle for doing the relatively "sane"
thing of setting GIF when force-leaving nested.

Fixes: c513f484c558 ("KVM: nSVM: leave guest mode when clearing EFER.SVME")
Signed-off-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
[yosry.ahmed: stitched together jmattson's patch and seanjc's diff]
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 2 ++
 arch/x86/kvm/svm/svm.c    | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3e4bd8d69788..9f91272fb735 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1363,6 +1363,8 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
 		nested_svm_uninit_mmu_context(vcpu);
 		vmcb_mark_all_dirty(svm->vmcb);
 
+		svm_set_gif(svm, true);
+
 		if (kvm_apicv_activated(vcpu->kvm))
 			kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
 	}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f56c2d895011..f62e94b404f4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -215,7 +215,6 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
 		if (!(efer & EFER_SVME)) {
 			svm_leave_nested(vcpu);
-			svm_set_gif(svm, true);
 			/* #GP intercept is still needed for vmware backdoor */
 			if (!enable_vmware_backdoor)
 				clr_exception_intercept(svm, GP_VECTOR);
-- 
2.52.0.rc2.455.g230fcf2819-goog


