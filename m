Return-Path: <kvm+bounces-30209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 631B99B80D8
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 18:07:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6CFDB22441
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 17:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F221C2456;
	Thu, 31 Oct 2024 17:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E7+Phsm4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69421BD034
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 17:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730394401; cv=none; b=DSHR7G/8dWIeUTxdUGBwPT09x+ikUrfyV6Fp9FyeT6Cc+KS953OHcfM4NqbhElAi6TzcCJi0PuwIKMvkU9QArxbvvHGc6qLmv1BmTf18nBwm0FP4ghzsPuFCdpBFzYKkOqGDORdRLmGt0dpd1o/bKmAbYYE19/h3LH+cjmOKv+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730394401; c=relaxed/simple;
	bh=TmFubaHpoCAggLPaGKoJJzqPvhVGJlp46tYw+F5ne78=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KxTMqXb8vaKbigfuYOROaUPdQJbxt3qOmm0bktFeGVPaVctWvSUfVowcEWgWqlmt7WzkexjJvGcUJc43sod0i2EM2EI4mFx8UVOr1LSzTE+BV8Y+TuR+UJqiiGZeVZgrddK1Abj9rehW1ZtJ50Axyncpdj81cS4zrDq2wgYhij4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E7+Phsm4; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e36cfed818so17053027b3.3
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 10:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730394399; x=1730999199; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aPh8/kX/bvDxkNAaOErpld4gvqOrWlO93evgZwqYlRo=;
        b=E7+Phsm4OeSWrbJ5rJ7BojMhbGT0fpZIZbNIwuiF80O04Nnmuc47fCS0tRl+ZWLgEv
         dGe9nB5mnoIFTCprLKbr8SIfugcuwSxyl1fR4bo6MJsRf1jn9DVSAI0TMU/I6cq11EmR
         iaoPwlSMWwAcTQ7KjbZWhxsmOBTp0tBBFMKPfh0EPlFEfZGg8XFpbe7kJPIt7az6qh+7
         9Qy2O4X++TL4FK+XlTGr3+Iu9Mq6RQ6ZWig+rM4rwJeocY3KW3HasbmXveHmjUVy3GQs
         GvbkWfM3ZkDK/CJVt/3zD/bUD9HJDQtP/qYNwDP+9NO3Pv75sCZ5EJCFU4DiYBtbFTye
         EcaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730394399; x=1730999199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aPh8/kX/bvDxkNAaOErpld4gvqOrWlO93evgZwqYlRo=;
        b=N35XqvLbdVK2woRCrwV++ssuf1ZmP+PXm4WP0km4KHlw5dicK8h2QlfF+Ehe59Y7LK
         YfzwK7quUdwyPL9pN+st45OG5LcE0hzeIqjcapx3H+n9OhImXF864oVGpepkc/hUaMK6
         Wp1sbabDfm5EgLNMRC9MndSsGL3wWVrDHlzwhy+dTuMSPoCP2xTJrL93TqLCfaCBSA6S
         KRGlVFCOdpIEMyHn5rzNjW/vRQHVEU1kwlUGT/Bg/e/7MecKwHhxOnumaQMXw6WjAE3e
         7qp47huELcWNulvtXsyMBpOv2mWYU2yqiuZ4c7/43DU9CZp7APMP6b4FovWcXLaT8oLR
         YQuQ==
X-Gm-Message-State: AOJu0YxnCLNwu18BcMvvtMQgwABhLUVVWFLAMtT8xXBaQjQC9pAW95mr
	LexBubp+iSeeYVHWPdOY4YRL4y566VzyFtexe/JtOMb8j3jRMReE68fant9/qRcFswguu2cywkW
	huQ==
X-Google-Smtp-Source: AGHT+IGiTrpfLC5rBMx47TY3FTKwPiTPo+GH6RHeAuK/D3+uMT5K0Tm4GGSSfwK2VRsPn0K+jhIU4mRjfi4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6811:b0:6e3:14c3:379a with SMTP id
 00721157ae682-6ea6479f2f6mr87277b3.0.1730394398970; Thu, 31 Oct 2024 10:06:38
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 31 Oct 2024 10:06:32 -0700
In-Reply-To: <20241031170633.1502783-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241031170633.1502783-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241031170633.1502783-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86/mmu: Check yielded_gfn for forward progress iff
 resched is needed
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Swap the order of the checks in tdp_mmu_iter_cond_resched() so that KVM
checks to see if a resched is needed _before_ checking to see if yielding
must be disallowed to guarantee forward progress.  Iterating over TDP MMU
SPTEs is a hot path, e.g. tearing down a root can touch millions of SPTEs,
and not needing to reschedule is by far the common case.  On the other
hand, disallowing yielding because forward progress has not been made is a
very rare case.

Returning early for the common case (no resched), effectively reduces the
number of checks from 2 to 1 for the common case, and should make the code
slightly more predictable for the CPU.

To resolve a weird conundrum where the forward progress check currently
returns false, but the need resched check subtly returns iter->yielded,
which _should_ be false (enforced by a WARN), return false unconditionally
(which might also help make the sequence more predictable).  If KVM has a
bug where iter->yielded is left danging, continuing to yield is neither
right nor wrong, it was simply an artifact of how the original code was
written.

Unconditionally returning false when yielding is unnecessary or unwanted
will also allow extracting the "should resched" logic to a separate helper
in a future patch.

Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 91caa73a905b..a06f3d5cb651 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -700,29 +700,29 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 {
 	WARN_ON_ONCE(iter->yielded);
 
+	if (!need_resched() && !rwlock_needbreak(&kvm->mmu_lock))
+		return false;
+
 	/* Ensure forward progress has been made before yielding. */
 	if (iter->next_last_level_gfn == iter->yielded_gfn)
 		return false;
 
-	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
-		if (flush)
-			kvm_flush_remote_tlbs(kvm);
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
 
-		rcu_read_unlock();
+	rcu_read_unlock();
 
-		if (shared)
-			cond_resched_rwlock_read(&kvm->mmu_lock);
-		else
-			cond_resched_rwlock_write(&kvm->mmu_lock);
+	if (shared)
+		cond_resched_rwlock_read(&kvm->mmu_lock);
+	else
+		cond_resched_rwlock_write(&kvm->mmu_lock);
 
-		rcu_read_lock();
+	rcu_read_lock();
 
-		WARN_ON_ONCE(iter->gfn > iter->next_last_level_gfn);
+	WARN_ON_ONCE(iter->gfn > iter->next_last_level_gfn);
 
-		iter->yielded = true;
-	}
-
-	return iter->yielded;
+	iter->yielded = true;
+	return true;
 }
 
 static inline gfn_t tdp_mmu_max_gfn_exclusive(void)
-- 
2.47.0.163.g1226f6d8fa-goog


