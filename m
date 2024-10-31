Return-Path: <kvm+bounces-30121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16E159B70DC
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:04:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90F011F21B7A
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16158EC2;
	Thu, 31 Oct 2024 00:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xY3ASJtA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039A51862
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 00:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730333064; cv=none; b=EscPTTtLwfd3VLALj7lzG9aVkc9C1gydFFfDMJXABZsuh2BnW4zO9SJ+vB4hHdEDGJeX/P4e3GP2f4GCBn5NmVdUJpCMgoRv+yt7hqVfhHwvQJ8a2+p38+H3EU4t8HDadEeNMMPOxfYIVgG5e/eFRD6FRt0WLnwpuedZo0eXORQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730333064; c=relaxed/simple;
	bh=B4Yu2jNshsjzf0i10OCLW75ZCQoRbrT84RJwAhLboSo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d9s3VYzZ+XL0PSvMu9uDi+7J52+lChZ4EJFzi9vnnD/GisenzJArjZRZNTWmmhuDAxA5nOxbny5RxPGLGFCLg/IaDLlOn03JYDqyth3VWlU/N38eI7DddRUd9LXkcvFenDrDrmsEH8LKPddQyav6gsR9R6LQ0rEe7Swgca1ZoDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xY3ASJtA; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e389169f92so6838277b3.0
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 17:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730333061; x=1730937861; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qGawKFPgymJQAC4quCO1QV7tkRoCZP7C9v37B8Z1MtI=;
        b=xY3ASJtAyu1GMfYo8voxGbeaFvagoidf4MYFHXsljQ8ZqFEIjM24RpTsdJ6dZ0C7SC
         s8DjSTUKecJ6V7KZ83QexClMdcIyg3CsLDDAMMsaZchGuZrtVvjnvo99j4fIaaNVioiD
         6k1xIAGocPGh3o2jE+DuT8yzL4F/3QuJlEqap/bjgBtos5/+PIeoWrE2iw7bjnXxQ6ne
         l1DtCvXKR+NerVmAUJGZ+6tpzY4x3XmHGR66SRJG4sPLwCr8c/20lGo490xX6cOFqx1p
         dYBJM860HF9AfY0Thk24izYEGNMf0uG1xPzKn4O++s/+QQ/K34KE7vEkz5VMXT6NAAH6
         DSXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730333061; x=1730937861;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qGawKFPgymJQAC4quCO1QV7tkRoCZP7C9v37B8Z1MtI=;
        b=EJhcvebQJuVpiAMPhfUAY6hdR78zCivp8YW0j+QC8MVttcJMNWCn9Syusbc1REi+74
         vjOLkx+k9I8vTy101fhRSJFkW8axZAMnrrUseaXpOZPbVY7iHNLWW1Nz+WJE9U3Bma29
         apC2xJdrg5NeQUitBN8SFs7dgSHcss9MGv91j/YKc4vjl/Gra8xbhp9zOOg9cAsGiy4N
         2EyqW+W//QAk6iamBxkCY0qWqsW01ZFoZiWrEi3ZFSnKlqgB9FHV9CpIEAi72BlQkJDN
         LccTCvdMEqOULpvzjj47fTeYwUOAL7LT3Lj1qv34xxrankx0ZoXq8uA4bXUGLOmySihD
         p9KQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgC4xRLlZIUKSx6U6SsPfsQC+EpFs9BvSB0gBk/D7CW5tT6CQgr5P+04dK6n1VkwFqG8c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1SqvdptuSbbF2bcTfLMXHbUsYrAftPtUVA3ivcMk35ego3nSh
	MULGSTiGbhjQv6Pv2paBjC9r1ZSwPuE2P3x4ZHxiz7ddXQsGQmkRl6c+8Ma+V0WWNXk5CTC7jhh
	09w==
X-Google-Smtp-Source: AGHT+IEpaa5htqLto48AQ3j0q6RDv+FU2fHWlkUqvshVTG9XUzEz67imkut+HIw9Vpb3TnVspyrAhp9OCcg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1d1:b0:e2e:3031:3f0c with SMTP id
 3f1490d57ef6-e30e5b0ee45mr848276.7.1730333060795; Wed, 30 Oct 2024 17:04:20
 -0700 (PDT)
Date: Wed, 30 Oct 2024 17:04:19 -0700
In-Reply-To: <20240823235648.3236880-4-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com> <20240823235648.3236880-4-dmatlack@google.com>
Message-ID: <ZyLJg2gaPqVrIn7Y@google.com>
Subject: Re: [PATCH v2 3/6] KVM: x86/mmu: Refactor TDP MMU iter need resched check
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 23, 2024, David Matlack wrote:
> Refactor the TDP MMU iterator "need resched" checks into a helper
> function so they can be called from a different code path in a
> subsequent commit.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 27adbb3ecb02..9b8299ee4abb 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -646,6 +646,16 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>  #define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
>  	for_each_tdp_pte(_iter, root_to_sp(_mmu->root.hpa), _start, _end)
>  
> +static inline bool __must_check tdp_mmu_iter_need_resched(struct kvm *kvm,
> +							  struct tdp_iter *iter)
> +{
> +	/* Ensure forward progress has been made before yielding. */
> +	if (iter->next_last_level_gfn == iter->yielded_gfn)
> +		return false;
> +
> +	return need_resched() || rwlock_needbreak(&kvm->mmu_lock);
> +}
> +
>  /*
>   * Yield if the MMU lock is contended or this thread needs to return control
>   * to the scheduler.
> @@ -666,11 +676,7 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
>  {
>  	WARN_ON_ONCE(iter->yielded);
>  
> -	/* Ensure forward progress has been made before yielding. */
> -	if (iter->next_last_level_gfn == iter->yielded_gfn)
> -		return false;
> -
> -	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
> +	if (tdp_mmu_iter_need_resched(kvm, iter)) {

Huh.  There's a subtle behavioral change here, that I would not have noticed had
I not _just_ looked at this code[*].  Falling through means the "don't yield to
ensure forward progress case" would return iter->yielded, not %false.  Per the
WARN above, iter->yielded _should_ be false, but if KVM had a bug that caused it
to get stuck, then that bug would escalate into an even worse bug of putting KVM
into a potentially unbreakable infinite loop.

Which is extremely unlikely, but it's a good excuse to clean this up :-)  I'll
test and post the below, and plan on slotting it in before this patch (you might
even see it show up in kvm-x86 before it gets posted).

[*] https://lore.kernel.org/all/Zx-_cmV8ps7Y2fTe@google.com


From: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Oct 2024 16:28:31 -0700
Subject: [PATCH] KVM: x86/mmu: Check yielded_gfn for forward progress iff
 resched is needed

Swap the order of the checks in tdp_mmu_iter_cond_resched() so that KVM
checks to see if a resched is needed _before_ checking to see if yielding
must be disallowed to guarantee forward progress.  Iterating over TDP MMU
SPTEs is a hot path, e.g. tearing down a root can touch millions of SPTEs,
and not needing to reschedule is by far the common case.  On the other
handle, disallowing yielding because forward progress has not been made is
a very rare case.

Returning early for the common case (no resched), effectively reduces the
number of checks from 2 to 1 for the common case, and should make the code
slightly more predictable for the CPU.

To resolve a weird conundrum where the forward progress check currently
returns false, but the need resched check subtly returns iter->yielded,
which _should_ be false (enforced by a WARN), return false unconditionally
(which might also help make the sequence more predicatble).  If KVM has a
bug where iter->yielded is left danging, continuing to yield is neither
right nor wrong, it was simply an artifact of how the original code was
written.

Unconditionally returning false when yielding is unnecessary or unwanted
will also allow extracting the "should resched" logic to a separate helper
in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 076343c3c8a7..8170b16b91c3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -658,29 +658,29 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
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

base-commit: 35ef80eb29ab5f7b7c7264c7f21a64b3aa046921
-- 

