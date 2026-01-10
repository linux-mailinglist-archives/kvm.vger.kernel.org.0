Return-Path: <kvm+bounces-67649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4848AD0CA5D
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 01:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5502A3059688
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 00:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE6417A305;
	Sat, 10 Jan 2026 00:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iiQl4/8n"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E621FF1C7
	for <kvm@vger.kernel.org>; Sat, 10 Jan 2026 00:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768006131; cv=none; b=XxPJqdwV4FSJfkUEXE2GVTgvV3ic+Czu9W+gTHzho9qjQCIDa98xbZnxuZm707AcKhV+sIbrJGndPB6d8jGowHx3mTiHqaRyPwNVpw9yN/fMG9D0M769hMceAc1xbl7bBjiAX7k68WZamEJ9WRSifwubaULIggTswPgDkfKbuP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768006131; c=relaxed/simple;
	bh=sxl4tOQwVq7bCdOn0xPL5FhFkkXOjPPrP1vPytBm8XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIIbCjCP5pAPptQ4yAQg5fypBHMfc/ZMcGwtgVe8QrJHqPbyOsufh9AEVPuFffWwb+H3zm2H57l4kB6gbhXZPnDkmSeqVxfa/kuQEfFHP7QWMV7C6tUEbcTOIEiBkrxLHF2b8IagCzm7Yc0NFVry1PPVCf6Od2HQSjRMPvggurM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iiQl4/8n; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768006124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+lqVw0wIbD1WLmmNExU08eLNLq6Rr/yPst5c7dWi4LY=;
	b=iiQl4/8ndTwGi/DWEDocy+I0dVeE7NCfdpPSaTwbqCMVCme+xdoLSwahE1FADpskzMsu0k
	+EDVkV0kVN1Ihn+/fS6hJMicPHChNJcP6sScgLPlhEdHSXTxEnpcksoEEffHuy5EBWRPAx
	uepMlU3Tj6Pg9RKTDWEebnzZq7lZFd8=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 2/4] KVM: SVM: Stop toggling virtual VMSAVE/VMLOAD on intercept recalc
Date: Sat, 10 Jan 2026 00:48:19 +0000
Message-ID: <20260110004821.3411245-3-yosry.ahmed@linux.dev>
In-Reply-To: <20260110004821.3411245-1-yosry.ahmed@linux.dev>
References: <20260110004821.3411245-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Virtual VMSAVE/VMLOAD enablement (i.e.
VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK) is set/cleared by
svm_recalc_instruction_intercepts() when the intercepts are cleared/set.
This is unnecessary because the bit is meaningless when intercepts are
set and KVM emulates the instructions. Initialize the bit in vmcb01 base
on vls, and keep it unchanged.

This is similar-ish to how vGIF is handled. It is enabled in init_vmcb()
if vgif=1 and remains unchanged when the STGI intercept is enabled (e.g.
for NMI windows).

This fixes a bug in svm_recalc_instruction_intercepts(). The intercepts
for VMSAVE/VMLOAD are always toggled in vmcb01, but
VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK is toggled in the current VMCB, which
could be vmcb02 instead of vmcb01 if L2 is active.

Virtual VMSAVE/VMLOAD enablement in vmcb02 is separately controlled by
nested_vmcb02_prepare_control() based on the vCPU features and VMCB12,
and if intercepts are needed they are set by recalc_intercepts().

The bug is benign though. Not toggling the bit for vmcb01 is harmless
because it's useless anyway. For vmcb02:

- The bit could be incorrectly cleared when intercepts are set in
  vmcb01. This is harmless because VMSAVE/VMLOAD will be emulated by KVM
  anyway.

- The bit could be incorrectly set when the intercepts are cleared in
  vmcb01. However, if the bit was originally clear in vmcb02, then
  recalc_intercepts() will enable in the intercepts in vmcb02 anyway and
  VMSAVE/VMLOAD will be emulated by KVM.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4e4439a01828..f1b032114406 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1033,10 +1033,14 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 			svm_set_intercept(svm, INTERCEPT_RDTSCP);
 	}
 
+	/*
+	 * No need to toggle VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK here, it is
+	 * always set if vls is enabled. If the intercepts are set, the bit is
+	 * meaningless anyway.
+	 */
 	if (guest_cpuid_is_intel_compatible(vcpu)) {
 		svm_set_intercept(svm, INTERCEPT_VMLOAD);
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
-		svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 	} else {
 		/*
 		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
@@ -1045,7 +1049,6 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 		if (vls) {
 			svm_clr_intercept(svm, INTERCEPT_VMLOAD);
 			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
-			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
 	}
 
@@ -1198,6 +1201,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
 	}
 
+	if (vls)
+		svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+
 	if (vcpu->kvm->arch.bus_lock_detection_enabled)
 		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
 
-- 
2.52.0.457.g6b5491de43-goog


