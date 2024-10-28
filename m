Return-Path: <kvm+bounces-29869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 112269B36F4
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 17:44:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33F4E1C22131
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 16:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20BCD1DF253;
	Mon, 28 Oct 2024 16:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fn7tnK2v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A9F1DEFE0
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 16:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730133879; cv=none; b=mKvSxy86EsWovUvwGHedjZFiaf2aTGCzbAuHdeVtbw52wOdCtU3q6SFMpwz4kfpSZMlx+d8dKhqTpvVSA1TvteIstfe94+VRYF9DvaBh49+RkMY30c+cWLdOWouuyPQfBat7eNAY1/gjODbA+ME8SdJ5DF5xYRM1mRGbS4ItrHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730133879; c=relaxed/simple;
	bh=IRdwHS4vcuPgJBmJX90PCn2d28fWXVAkeeopEpWdAUo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hNEsLTpAZW+xpeBzTG+g6fLMopySogYegxuN7B7e2Bfgu1abbjPlrz+y/KJaRZixT+nH8q/UBaVVDJvFBn66Jkc1S9yKPovFpBSccF8LSeJBbUlG+JZS4dUCvNibS0tL1KyqL78SIWkpm2x235401acg1ZNRQYcZYigt1TPChII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fn7tnK2v; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e2971589916so7931155276.3
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 09:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730133876; x=1730738676; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CCL9TFiHYG8TKvqieIfQVOyBSmKupXLL6Zu34z4C9gI=;
        b=fn7tnK2vGxSx48q3hCKTa8z5YvUmcy/h0ExUXwVFFXXirFHai7xPhpi8KVlWznejlH
         vbVvEhNi6mxabnYuCKT/2lo8cp4yinekMlI9ofa1dI/ZVJB8db6Wp4NKQ9b+aMfljAGo
         uX2Ci3nUnUqmVVH5IwUrdgeoZZZdrJYiaqYD3IA3wK9fSjY6PoWL6P6I/XTE8LsHIOSm
         AC7OjxMYN5TKimEG0ZzdP7VNDveBtYE28LlmgmMSiaL5KB20P6BXaSuYiWX8s8HsSQvQ
         A66JNZVRA70RKy7CPepczq6UmicaOC1cZ5d1tgwPprzFHEgyoJ5AMkBWZjHamRfiIHdf
         a+mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730133876; x=1730738676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CCL9TFiHYG8TKvqieIfQVOyBSmKupXLL6Zu34z4C9gI=;
        b=i9imI8WDYluOhGEhMqQfGJqYD5muw5qCXaiaJUMd/ISboNeFOd+udMnkigqnUgayLd
         hQME4ntb8fF9HanFkOeCie6i293goIt+uPrdlsjWgsMAKDdwVA8ZEiWKVbIFkWF+PmTm
         FSrdyoEe5JuTllbuo7Oy7y8HunZHVt9rksCBs0fHHYAbhghb0C4bPJCLcGbCWU/fDRlG
         /ufXjROXEncOty3uCzRWYuGICWkRp/4acEDK2oFXrp+iNOyPAoq+kiKfonO0hh6bAptm
         31DaRNwDxnxcj5b2auQAvB3V4MIA9nCH3Hz6Gb62tTPZHAySSZU/pZGazZIJL2PTqV/8
         rBzw==
X-Gm-Message-State: AOJu0Yww3Hxtcb3/E4RcKaqDjnShyUKn+SYBG18OAL3jFpL7o+nO7+6m
	w0oCcQkMM9MwrWKUU/ViQSj6cjzeTYy1QOoMTDG/7LjNYB22z6H+VsiYwmBbVGXuZLtWnCMRJBZ
	j7A==
X-Google-Smtp-Source: AGHT+IE//TNw/PMtjJZRwHZaAUcMdT4Kdw3bcVqrAPb4Rhj9jlzDmo640iVH80uclQXL8iqL0K+/Axb42Kg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:6c57:0:b0:e28:eee0:aaa1 with SMTP id
 3f1490d57ef6-e3087a55f95mr5386276.4.1730133875860; Mon, 28 Oct 2024 09:44:35
 -0700 (PDT)
Date: Mon, 28 Oct 2024 09:44:34 -0700
In-Reply-To: <ZxoghG8+7xAHh3bu@mias.mediconcil.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241023091902.2289764-1-bk@alpico.io> <ZxmGdhwr9BlhUQ_Y@google.com>
 <ZxoghG8+7xAHh3bu@mias.mediconcil.de>
Message-ID: <Zx-_cmV8ps7Y2fTe@google.com>
Subject: Re: [PATCH] KVM: x86: Fast forward the iterator when zapping the TDP MMU
From: Sean Christopherson <seanjc@google.com>
To: Bernhard Kauer <bk@alpico.io>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 24, 2024, Bernhard Kauer wrote:
> On Wed, Oct 23, 2024 at 04:27:50PM -0700, Sean Christopherson wrote:
> > On Wed, Oct 23, 2024, Bernhard Kauer wrote:
> > > Zapping a root means scanning for present entries in a page-table
> > > hierarchy. This process is relatively slow since it needs to be
> > > preemtible as millions of entries might be processed.
> > > 
> > > Furthermore the root-page is traversed multiple times as zapping
> > > is done with increasing page-sizes.
> > > 
> > > Optimizing for the not-present case speeds up the hello microbenchmark
> > > by 115 microseconds.
> > 
> > What is the "hello" microbenchmark?  Do we actually care if it's faster?
> 
> Hello is a tiny kernel that just outputs "Hello world!" over a virtual
> serial port and then shuts the VM down.  It is the minimal test-case that
> reveals performance bottlenecks hard to see in the noise of a big system.
> 
> Does it matter?

Yes.  Knowing the behavior and use case helps guide jugdment calls, e.g. for
balancing complexity and maintenance burden versus performance, and it also helps
readers understand what types of behaviors/workloads will benefit from the change.

> The case I optimized might be only relevant for short-running virtual
> machines.  However, you found more users of the iterator that might benefit
> from it.
>  
> > Are you able to determine exactly what makes iteration slow? 
> 
> I've counted the loop and the number of entries removed:
> 
> 	[24661.896626] zap root(0, 1) loops 3584 entries 2
> 	[24661.896655] zap root(0, 2) loops 2048 entries 3
> 	[24661.896709] zap root(0, 3) loops 1024 entries 2
> 	[24661.896750] zap root(0, 4) loops 512 entries 1
> 	[24661.896812] zap root(1, 1) loops 512 entries 0
> 	[24661.896856] zap root(1, 2) loops 512 entries 0
> 	[24661.896895] zap root(1, 3) loops 512 entries 0
> 	[24661.896938] zap root(1, 4) loops 512 entries 0
> 
> 
> So for this simple case one needs 9216 iterations to go through 18 pagetables
> with 512 entries each. My patch reduces this to 303 iterations.
> 
> 	[24110.032368] zap root(0, 1) loops 118 entries 2
> 	[24110.032374] zap root(0, 2) loops 69 entries 3
> 	[24110.032419] zap root(0, 3) loops 35 entries 2
> 	[24110.032421] zap root(0, 4) loops 17 entries 1
> 	[24110.032434] zap root(1, 1) loops 16 entries 0
> 	[24110.032435] zap root(1, 2) loops 16 entries 0
> 	[24110.032437] zap root(1, 3) loops 16 entries 0
> 	[24110.032438] zap root(1, 4) loops 16 entries 0
> 
> 
> Given the 115 microseconds one loop iteration is roughly 13 nanoseconds. 
> With the updates to the iterator and the various checks this sounds
> reasonable to me.  Simplifying the inner loop should help here.

Yeah, I was essentialy wondering if we could optimize some of the checks at each
step.  E.g. untested, but I suspect that checking yielded_gfn to ensure forward
progress if and only if a resched is needed would improve overall throughput by
short circuiting on the common case (no resched needed), and by making that path
more predictable (returning false instead of iter->yielded).

---
 arch/x86/kvm/mmu/tdp_mmu.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 25a75db83ca3..15be07fcc5f9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -706,31 +706,31 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 							  struct tdp_iter *iter,
 							  bool flush, bool shared)
 {
-	WARN_ON_ONCE(iter->yielded);
+	KVM_MMU_WARN_ON(iter->yielded);
+
+	if (!need_resched() && !rwlock_needbreak(&kvm->mmu_lock))
+		return false;
 
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
+	KVM_MMU_WARN_ON(iter->gfn > iter->next_last_level_gfn);
 
-		iter->yielded = true;
-	}
-
-	return iter->yielded;
+	iter->yielded = true;
+	return true;
 }
 
 static inline gfn_t tdp_mmu_max_gfn_exclusive(void)

base-commit: 80fef183d5a6283e50a50c2aff20dfb415366305
-- 

> > partly because maybe there's a more elegant solution.
> 
> Scanning can be avoided if one keeps track of the used entries.

Yeah, which is partly why I asked about the details of the benchmark.  Tracking
used entries outside of the page tables themselves adds complexity and likely
increases the latency of insertion operations.

> > Regardless of why iteration is slow, I would much prefer to solve this for all
> > users of the iterator.  E.g. very lightly tested, and not 100% optimized (though
> > should be on par with the below).
> 
> Makes sense. I tried it out and it is a bit slower. One can optimize
> the while loop in try_side_step() a bit further.

