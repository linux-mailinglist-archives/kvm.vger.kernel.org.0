Return-Path: <kvm+bounces-41011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9997BA603C3
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 22:57:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC861420B4B
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057631FAC34;
	Thu, 13 Mar 2025 21:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aLhl171H"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C91E1F758F
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 21:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741902968; cv=none; b=ld79IN2cOnZxaZ2rU59rR6biCbuRnM730oBrbXDb1ugzmDgW4Jrb42LyTn6++wJopKLIqvr6IeBgS4AJ8qK11ya56yP+UMVbGb9PWN7tPvGQxhrzEDIsGgUWF2rzIRSqkl4KMOQ9UwLBIg7S3nPYAP4vqhdW2ZMsUCtYiyHXSuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741902968; c=relaxed/simple;
	bh=8wECG4JQ2fba//svmJ31tdiX1CS6jJ9gPveOAmkxM84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdnUc4DFGQqd0M/eBlkhhRQ4UDPj8qIIj8nkiMzXCbnUbwWLEs1JvwOOHFprwwvwCzfljYGKS1o463l/XpPRjS5MyO2LDAEoZngyLpQ3IwP+soWjg4/VhhbnIlcvMje+qF/XhhU/bkXoeVttnLjvOznm2vjs2Pa5h251NmazZsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aLhl171H; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741902962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SGGkSGip9KY3u6EkXyE1FS/Ys6OM8b0hhAlvTYZWAS0=;
	b=aLhl171HN7X/zTuTz2xwy45+nCXqc3zC3/b4OU/z1teoXnbh3I6bdtY/VhwwR0D5Rzaw98
	wk4GqJJlrb1/9YxDtI5IagU1MpHJ6QdSYhHAHdoZAe9gx+oSSjg/kozTFqiaa8a/N5s5LC
	KS7oR0mfIlcS0GMv4Sqs1ZwIKVfxKxQ=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 5/7] KVM: SVM: Flush the ASID when running on a new CPU
Date: Thu, 13 Mar 2025 21:55:38 +0000
Message-ID: <20250313215540.4171762-6-yosry.ahmed@linux.dev>
In-Reply-To: <20250313215540.4171762-1-yosry.ahmed@linux.dev>
References: <20250313215540.4171762-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Currently, when a vCPU is migrated to a new physical CPU, the ASID
generation is reset to trigger allocating a new ASID. In preparation for
using a static ASID per VM, just flush the ASID in this case (falling
back to flushing everything if FLUSBYASID is not available).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e5064fbefb822..b8a3fc81fc9c8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3626,12 +3626,12 @@ static int pre_svm_run(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
-	 * If the previous vmrun of the vmcb occurred on a different physical
-	 * cpu, then mark the vmcb dirty and assign a new asid.  Hardware's
-	 * vmcb clean bits are per logical CPU, as are KVM's asid assignments.
+	 * If the previous VMRUN of the VMCB occurred on a different physical
+	 * CPU, then mark the VMCB dirty and flush the ASID.  Hardware's
+	 * VMCB clean bits are per logical CPU, as are KVM's ASID assignments.
 	 */
 	if (unlikely(svm->current_vmcb->cpu != vcpu->cpu)) {
-		svm->current_vmcb->asid_generation = 0;
+		svm_vmcb_set_flush_asid(svm->vmcb);
 		vmcb_mark_all_dirty(svm->vmcb);
 		svm->current_vmcb->cpu = vcpu->cpu;
         }
-- 
2.49.0.rc1.451.g8f38331e32-goog


