Return-Path: <kvm+bounces-23295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BBF19486B1
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 02:45:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97A671F23DBC
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 00:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4BD63B9;
	Tue,  6 Aug 2024 00:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DM/qPMdL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403836FBF
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 00:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722905143; cv=none; b=RrPZNiK20w5dYS9RhJt0xyzAnvDk4nqPq9I6K0dxSqjIQciPirR9E93azYUL26YWm8ItRfUtP4vroOLoe9hYcevN0P2HLIJnARjq1GpACoPVL0q49edjoQGdW+HlTfQ0g/dbPeYMiTjzRhPYI/baH3TyaVMhFJJQYWGyDQszVuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722905143; c=relaxed/simple;
	bh=xJZinW9gvbRfqGqVK8gwS78zN2XDlEhctENfqDXkpIM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gGTZs5AjSYthueXh3AIEHK3uffiFj14RRDYYpSGchpcOO+N6WGT1/+IXu8WTUHMD9+9nlB8VamTpm1uRgZXx9y9mC9XGc4F1lAq/Hyh6Bncr68Zdeo9Jj5OZk0EfpgGqh3ClJiFr8h/DFnyOtDtVLNzR35hokUL8y7SWQtwvYU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DM/qPMdL; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0bbd1ca079so39633276.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 17:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722905141; x=1723509941; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RlwWN4is+MXSZU2QpqY/Ao8/6cEmVqrwuY1O9PQnYgo=;
        b=DM/qPMdLWJ9ZO29UeGwF3vnQGM0NhXi8PQXim6WrRMkrKBieu5/W201KvBCdM1PFzu
         E7hP4j+dx7R6HKpb43h+68iZZ7tsKvghuS13Z8wAetYg7PSyJGmmYz0rIkYrovYTYgVv
         5hyTY3xFj2Our9hOzUGl9iFsws9GTaVZtI4Nc7L5JGdMH15wvoTk3JPYbNUWFTK2RYw7
         wNEztQL0o7YNsz4Enu8Odct1XXqasraD09OurmWWDZuiew/Y2HNV+mfwmLoh8y3yBuFP
         BKUvLB/HK/SF/G4GOEnUSQj/e6oi32D8e/hVcmCEF0wnCTl9kmTiETXSsLd1upD76Uni
         4Eaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722905141; x=1723509941;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RlwWN4is+MXSZU2QpqY/Ao8/6cEmVqrwuY1O9PQnYgo=;
        b=dje24eelmIFZ6kmpK6ILB3N+/O9pnwjB2pVEYrRvU4atKgTDyA9lVSWu2hjseKR+Uu
         U9NAPkWfXKeOLxL8wBp3/DQB8RKGUde69RsrP81oPRGzb1HtO0AMbjZkOXk7n12Aqjc8
         PFpkd+DSTDVHqbPp/92lhX/FXnmd7jPcstl6+wTz2H0yTAeOFfbbDzFYkEYtavOFWS9N
         p2iqYPn/+AzjlfwTrKE65PmnwTX47o/ie6wtO0+cJZfn5R/0W3DXHu5IpHsUWapKgq5m
         YFQ8ys2hT8g9CWUOmOopriFauxuOyyqX9U2qidDQ4J2eVw4nc/fXAq17LBzZtVimgKHC
         CCSQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9zaGBOcbzPCUZFJJ2/ciMfPVeK2DueFytQgkgCHD9dIxghrhuRCNofOnK/1XKiw5GKIEE4ztAACggwjXJhj2Kj/jG
X-Gm-Message-State: AOJu0Yyk38xaRdIRhLLVc/BTjl43XBvV19YFAILBjZw4CVcJG7PC6nuy
	TdJjwvA48UEoxS02Eu9MYJvVT1bp7ga+cTslQ/dF01TqgXPwCdXZxI0GDYPWsdcpw3iFBd0X5MN
	26g==
X-Google-Smtp-Source: AGHT+IHAlcDpPkJK+Ho8bhRXhblm6X1pytNk7PD61xxKNen6ECBnp7JfJ5NAekg+iOwpjGK6T15xL1tPhyo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1892:b0:e05:aa67:2d4b with SMTP id
 3f1490d57ef6-e0bde222289mr276960276.3.1722905141251; Mon, 05 Aug 2024
 17:45:41 -0700 (PDT)
Date: Mon, 5 Aug 2024 17:45:39 -0700
In-Reply-To: <f862cefff2ed3f4211b69d785670f41667703cf3.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20220427014004.1992589-1-seanjc@google.com> <20220427014004.1992589-7-seanjc@google.com>
 <294c8c437c2e48b318b8c27eb7467430dfcba92b.camel@infradead.org> <f862cefff2ed3f4211b69d785670f41667703cf3.camel@infradead.org>
Message-ID: <ZrFyM8rJZYjfFawx@google.com>
Subject: Re: [PATCH] KVM: Move gfn_to_pfn_cache invalidation to
 invalidate_range_end hook
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Mushahid Hussain <hmushi@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 05, 2024, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The existing retry loop in hva_to_pfn_retry() is extremely pessimistic.
> If there is an invalidation running concurrently, it is effectively just
> a complex busy wait loop because its local mmu_notifier_retry_cache()
> function will always return true.
> 
> It ends up functioning as a very unfair read/write lock. If userspace is
> acting as a 'writer', performing many unrelated MM changes, then the
> hva_to_pfn_retry() function acting as the 'reader' just backs off and
> keep retrying for ever, not making any progress.
> 
> Solve this by introducing a separate 'validating' flag to the GPC, so
> that it can be marked invalid before it's even mapped. This allows the
> invalidation to be moved to the range_end hook, and the retry loop in
> hva_to_pfn_retry() can be changed to loop only if its particular uHVA
> has been affected.

I think I'm missing something.  How does allowing hva_to_pfn_retry() allow KVM
as a whole to make forward progress?  Doesn't getting past hva_to_pfn_retry()
just move the problem to kvm_gpc_check()?

kvm_gpc_refresh() can't be called with gpc->lock held, and nor does it return
with gpc->lock held, so a racing mmu_notifier invalidation can/will acquire
gpc->lock and clear gpc->active, no?

Oh, by "unrelated", you mean _completely_ unrelated?  As in, KVM happens to do a
refresh when userspace is blasting MADV_DONTNEED, and gets stuck retrying for
no good reason?

Servicing guest pages faults has the same problem, which is why
mmu_invalidate_retry_gfn() was added.  Supporting hva-only GPCs made our lives a
little harder, but not horrifically so (there are ordering differences regardless).

Woefully incomplete, but I think this is the gist of what you want:

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index f0039efb9e1e..1c4c95ab7d0a 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -28,6 +28,26 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
        struct gfn_to_pfn_cache *gpc;
 
        spin_lock(&kvm->gpc_lock);
+
+       if (likely(kvm_is_error_hva(kvm->mmu_gpc_invalidate_range_start)) {
+               kvm->mmu_gpc_invalidate_range_start = start;
+               kvm->mmu_gpc_invalidate_range_end = end;
+       } else {
+               /*
+                * Fully tracking multiple concurrent ranges has diminishing
+                * returns. Keep things simple and just find the minimal range
+                * which includes the current and new ranges. As there won't be
+                * enough information to subtract a range after its invalidate
+                * completes, any ranges invalidated concurrently will
+                * accumulate and persist until all outstanding invalidates
+                * complete.
+                */
+               kvm->mmu_gpc_invalidate_range_start =
+                       min(kvm->mmu_gpc_invalidate_range_start, start);
+               kvm->mmu_gpc_invalidate_range_end =
+                       max(kvm->mmu_gpc_invalidate_range_end, end);
+       }
+
        list_for_each_entry(gpc, &kvm->gpc_list, list) {
                read_lock_irq(&gpc->lock);
 
@@ -124,8 +144,11 @@ static void gpc_unmap(kvm_pfn_t pfn, void *khva)
 #endif
 }
 
-static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_seq)
+static inline bool mmu_notifier_retry_cache(struct gfn_to_pfn_cache *gpc,
+                                           unsigned long mmu_seq)
 {
+       struct kvm *kvm = gpc->kvm;
+
        /*
         * mn_active_invalidate_count acts for all intents and purposes
         * like mmu_invalidate_in_progress here; but the latter cannot
@@ -138,7 +161,9 @@ static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_s
         * be elevated before the mmu_notifier acquires gpc->lock, and
         * isn't dropped until after mmu_invalidate_seq is updated.
         */
-       if (kvm->mn_active_invalidate_count)
+       if (kvm->mn_active_invalidate_count &&
+           gpc->uhva >= kvm->mmu_gpc_invalidate_range_start &&
+           gpc->uhva < kvm->mmu_gpc_invalidate_range_end)
                return true;
 
        /*
@@ -224,7 +249,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
                 * attempting to refresh.
                 */
                WARN_ON_ONCE(gpc->valid);
-       } while (mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
+       } while (mmu_notifier_retry_cache(gpc, mmu_seq));
 
        gpc->valid = true;
        gpc->pfn = new_pfn;

> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> I note I'm deleting a big comment in kvm_main.c about doing the
> invalidation before acquiring mmu_lock. But we don't hold the lock
> in the range_end callback either, do we?

Correct, __kvm_handle_hva_range() acquires and releases mmu_lock.  However, the
intent of the comment was to clarify why GPCs are invalidated in
kvm_mmu_notifier_invalidate_range_start(), as opposed to kvm_mmu_invalidate_begin()
which _is_ called under mmu_lock and is also called if and only if KVM has a
relevant memslot.  E.g. that's why the comment also talks about memslot overlap
checks.

>  
>  include/linux/kvm_types.h |  1 +
>  virt/kvm/kvm_main.c       | 14 ++------
>  virt/kvm/kvm_mm.h         | 12 +++----
>  virt/kvm/pfncache.c       | 75 +++++++++++++++++++--------------------
>  4 files changed, 45 insertions(+), 57 deletions(-)
> 
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 827ecc0b7e10..30ed1019cfc6 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -69,6 +69,7 @@ struct gfn_to_pfn_cache {
>  	void *khva;
>  	kvm_pfn_t pfn;
>  	bool active;
> +	bool validating;

This is a confusing name, partly because KVM usually deals with invalidation
events, but also because it's sticky and stays set long after the act of
validating the GPC is complete.

Something like "needs_invalidation" is the best I can come up with, but I believe
this bikeshed is moot (see above and below).

>  	bool valid;
>  };
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d0788d0a72cc..ffd6ab4c2a16 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -777,18 +777,6 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>  	kvm->mn_active_invalidate_count++;
>  	spin_unlock(&kvm->mn_invalidate_lock);
>  
> -	/*
> -	 * Invalidate pfn caches _before_ invalidating the secondary MMUs, i.e.
> -	 * before acquiring mmu_lock, to avoid holding mmu_lock while acquiring
> -	 * each cache's lock.  There are relatively few caches in existence at
> -	 * any given time, and the caches themselves can check for hva overlap,
> -	 * i.e. don't need to rely on memslot overlap checks for performance.
> -	 * Because this runs without holding mmu_lock, the pfn caches must use
> -	 * mn_active_invalidate_count (see above) instead of
> -	 * mmu_invalidate_in_progress.
> -	 */
> -	gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end);
> -
>  	/*
>  	 * If one or more memslots were found and thus zapped, notify arch code
>  	 * that guest memory has been reclaimed.  This needs to be done *after*
> @@ -849,6 +837,8 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
>  	wake = !kvm->mn_active_invalidate_count;
>  	spin_unlock(&kvm->mn_invalidate_lock);
>  
> +	gfn_to_pfn_cache_invalidate(kvm, range->start, range->end);

We can't do this.  The contract with mmu_notifiers is that secondary MMUs must
unmap the hva before returning from invalidate_range_start(), and must not create
new mappings until invalidate_range_end().

