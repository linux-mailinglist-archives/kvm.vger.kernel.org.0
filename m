Return-Path: <kvm+bounces-27987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC2F29909C1
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 18:56:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 956E028279A
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 16:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 320C31CACF1;
	Fri,  4 Oct 2024 16:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LHy2aNC8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A03157492
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 16:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728060971; cv=none; b=FUvdunxRS2TJ4qgh8w7h89mOwtn+9+HczjdxpdSvR26IUsLY6cg9v0rKb3AOQJAJFGlVZFp0iYbJYj7w1hU3fVyV9aqcA3++VLttoMzqEtnLeAdpXA7VyN0zbN0NwuVOH5OCQxs3zSPaM2ec9OHef0ud8yrJAud44jmQAJqrhAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728060971; c=relaxed/simple;
	bh=jgvmqSjuDZSEf7oLnmJ2BwErtUwxfEOtJfimfBrRuz4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IKDOnUZrbuB5GqT8oy3HOPEDZ1hPJjgjC9FhfZor7QH1NYGVsUdc1MLUROsgSC5W/8+WNi8w6jHUYlDhKx5dNo4AC0XT1t9NzKcYhjf7/U5fQ7ntxjoC41VcAFnaf0R2ew9oE50rk6Yxk+htUp9BaPj8yeIwmM4zEm8UIyX20/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LHy2aNC8; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71dd55880d3so4019336b3a.0
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 09:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728060969; x=1728665769; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i8FoilMhepdViGluwM2SyzUONkf6AP+FrNcB5stAC+I=;
        b=LHy2aNC8qVB7jvlAfCs2HAEojPgOQDAUeXPoszwJiWE1G9pz27sqRlCsWcO/OMVlAr
         3gjS5dzsa7q1x2X67hiODo3idsxOIdFNrroH4JSA4r7gsJZsygYjX4EzJOuSqUywYk7C
         1bYKH0ShyzrPpwztR81KKb0rNnZQwHxcs29G6mdptIgryNkYLm0dWTwVle+Dh7Y5Gvzi
         ynUZTEAKcu8gbBEj3RxmG+WMu8DT6YmjknCXFIshhMwrjp1VQEtcwrrk8JpXgAr7XwnV
         bskfc4XM9wMHqBQkAx7MYrGxZ+OZsd9QoSWa2t7Q91nmbgB4qQJY+XzO5pK3QAWiALsj
         asCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728060969; x=1728665769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i8FoilMhepdViGluwM2SyzUONkf6AP+FrNcB5stAC+I=;
        b=Jwar09FRa1oUiWaAYVF8C2W5H4S+VAlpCv25LdEiEc8ICoccRrnSm1615dFLhdIqFz
         4MB0Tt/ZfmP5W/w0A3kpMr3K2Xs7NRGO51lpxjqA7wV+RfqTgYYrsKTehswzmc+Vp88l
         Scwoz6MaS3bS/cFdY/kKFTvm8BH6nKhtqSdULCPd3pZ9sPzDgP+RJ5g8v/7ciA/tkSzq
         Jqz2fpG3jvmwRu+0gAOqakJlpcGr04/E/1ymH6/v4Khj+gbeRgBhbMbImSBWwgu8iNQo
         yo4Akq3kM+mOqMP1BLnBw8N3noDuyaQOjU9/OaOIBO1H/XkKnFDC32+a68kA/iiodPR8
         zMPw==
X-Forwarded-Encrypted: i=1; AJvYcCWX3aFJDNa4jCKE5lHKB8l/x50+AtVYkJDYKAHNZSuJO4w8BOhQDokFh9r9sKJaMkqe7fA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQGU0VfbEAWXKuz9d6oWLZxOXhxtH19lhdCAed1d12OVQV1Gr9
	62rTOnvychR4Q5vSarrj1Vc+vaKquyYIA0cQFzUmFL/s2UtRUmybpJ5cscMVZuYUDnVlWpXYTPK
	8PA==
X-Google-Smtp-Source: AGHT+IFXImsF4DzQ4n8wPlS8gJoNT4MO+GE2yhpJHQvfD9/2nYKES/en5o2jTUAHNXfUzXRGJ5IIDPI9AvE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f52:b0:70d:19c1:c4df with SMTP id
 d2e1a72fcca58-71de239f5d6mr20823b3a.1.1728060968799; Fri, 04 Oct 2024
 09:56:08 -0700 (PDT)
Date: Fri, 4 Oct 2024 09:56:07 -0700
In-Reply-To: <20241003230105.226476-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241003230105.226476-1-pbonzini@redhat.com>
Message-ID: <ZwAeJ1RtReFiRiNd@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: fix KVM_X86_QUIRK_SLOT_ZAP_ALL for shadow MMU
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 03, 2024, Paolo Bonzini wrote:
> As was tried in commit 4e103134b862 ("KVM: x86/mmu: Zap only the relevant
> pages when removing a memslot"), all shadow pages, i.e. non-leaf SPTEs,
> need to be zapped.  All of the accounting for a shadow page is tied to the
> memslot, i.e. the shadow page holds a reference to the memslot, for all
> intents and purposes.  Deleting the memslot without removing all relevant
> shadow pages, as is done when KVM_X86_QUIRK_SLOT_ZAP_ALL is disabled,
> results in NULL pointer derefs when tearing down the VM.
> 
> Reintroduce from that commit the code that walks the whole memslot when
> there are active shadow MMU pages.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	In the end I did opt for zapping all the pages.  I don't see a
> 	reason to let them linger forever in the hash table.
> 
> 	A small optimization would be to only check each bucket once,
> 	which would require a bitmap sized according to the number of
> 	buckets.  I'm not going to bother though, at least for now.
> 
>  arch/x86/kvm/mmu/mmu.c | 60 ++++++++++++++++++++++++++++++++----------
>  1 file changed, 46 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e081f785fb23..912bad4fa88c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1884,10 +1884,14 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
>  		if (is_obsolete_sp((_kvm), (_sp))) {			\
>  		} else
>  
> -#define for_each_gfn_valid_sp_with_gptes(_kvm, _sp, _gfn)		\
> +#define for_each_gfn_valid_sp(_kvm, _sp, _gfn)				\
>  	for_each_valid_sp(_kvm, _sp,					\
>  	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
> -		if ((_sp)->gfn != (_gfn) || !sp_has_gptes(_sp)) {} else
> +		if ((_sp)->gfn != (_gfn)) {} else

I don't think we should provide this iterator, because it won't do what most people
would it expect it to do.  Specifically, the "round gfn for level" adjustment that
is done for direct SPs means that the exact gfn comparison will not get a match,
even when a SP does "cover" a gfn, or was even created specifically for a gfn.

For this usage specifically, KVM's behavior will vary signficantly based on the
size and alignment of a memslot, and in weird ways.  E.g. For a 4KiB memslot,
KVM will zap more SPs if the slot is 1GiB aligned than if it's only 4KiB aligned.
And as described below, zapping SPs in the aligned case would overzap for direct
MMUs, as odds are good the upper-level SPs are serving other memslots.

To iterate over all potentially-relevant gfns, KVM would need to make a pass over
the hash table for each level, with the gfn used for lookup rounded for said level.
And then check that the SP is of the correct level, too, e.g. to avoid over-zapping.

But even then, KVM would massively overzap, as processing every level is all but
guaranteed to zap SPs that serve other memslots, especially if the memslot being
removed is relatively small.  We could mitigate that by processing only levels
that can be possible guest huge pages, but while somewhat logical, that's quite
arbitrary and would be a bit of a mess to implement.

So, despite my initial reservations about zapping only SPs with gPTEs, I feel
quite strongly that that's the best approach.  It's easy to describe, is predictable,
and is explicitly minimal, i.e. KVM only zaps SPs that absolutely must be zapped.

> +#define for_each_gfn_valid_sp_with_gptes(_kvm, _sp, _gfn)		\
> +	for_each_gfn_valid_sp(_kvm, _sp, _gfn)				\
> +		if (!sp_has_gptes(_sp)) {} else
>  
>  static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  {
> @@ -7049,14 +7053,42 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  	kvm_mmu_zap_all(kvm);
>  }
>  
> -/*
> - * Zapping leaf SPTEs with memslot range when a memslot is moved/deleted.
> - *
> - * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
> - * case scenario we'll have unused shadow pages lying around until they
> - * are recycled due to age or when the VM is destroyed.
> - */
> -static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *slot)
> +static void kvm_mmu_zap_memslot_pages_and_flush(struct kvm *kvm,
> +						struct kvm_memory_slot *slot,
> +						bool flush)
> +{
> +	LIST_HEAD(invalid_list);
> +	unsigned long i;
> +
> +	if (list_empty(&kvm->arch.active_mmu_pages))
> +		goto out_flush;
> +
> +	/*
> +	 * Since accounting information is stored in struct kvm_arch_memory_slot,
> +	 * shadow pages deletion (e.g. unaccount_shadowed()) requires that all
> +	 * gfns with a shadow page have a corresponding memslot.  Do so before
> +	 * the memslot goes away.
> +	 */
> +	for (i = 0; i < slot->npages; i++) {
> +		struct kvm_mmu_page *sp;
> +		gfn_t gfn = slot->base_gfn + i;
> +
> +		for_each_gfn_valid_sp(kvm, sp, gfn)
> +			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
> +
> +		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
> +			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
> +			flush = false;
> +			cond_resched_rwlock_write(&kvm->mmu_lock);
> +		}
> +	}
> +
> +out_flush:
> +	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
> +}
> +
> +static void kvm_mmu_zap_memslot(struct kvm *kvm,
> +				struct kvm_memory_slot *slot)
>  {
>  	struct kvm_gfn_range range = {
>  		.slot = slot,
> @@ -7064,11 +7096,11 @@ static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *s
>  		.end = slot->base_gfn + slot->npages,
>  		.may_block = true,
>  	};
> +	bool flush;
>  
>  	write_lock(&kvm->mmu_lock);
> -	if (kvm_unmap_gfn_range(kvm, &range))
> -		kvm_flush_remote_tlbs_memslot(kvm, slot);
> -
> +	flush = kvm_unmap_gfn_range(kvm, &range);

Aha!  Finally figured out why this was bugging me.  Using kvm_unmap_gfn_range()
is subject to a race that would lead to UAF.  Huh.  And that could explain the
old VFIO bug, though it seems unlikely that the race was being hit.

  KVM_SET_USER_MEMORY_REGION             vCPU
                                         __kvm_faultin_pfn() /* resolve fault->pfn */
  kvm_swap_active_memslots();
  kvm_zap_gfn_range(APIC);
  kvm_mmu_zap_memslot();
                                        {read,write}_lock(&kvm->mmu_lock);
                                        <install SPTE>

KVM's existing memslot deletion relies on the mmu_valid_gen check in is_obsolete_sp()
to detect an obsolete root (and the KVM_REQ_MMU_FREE_OBSOLETE_ROOTS check to handle
roots without a SP).

With this approach, roots aren't invalidated, and so a vCPU could install a SPTE
using the to-be-delete memslot.  To fix, KVM needs to use bump the invalidation
sequence count and set in-progress until the zap completes.  At that point, it's
probably worth expanding kvm_zap_gfn_range(), as SPs with gPTEs need to be zapped
under that protection too, e.g. to prevent creating an intermediate SP, which
would result in account_shadowed() hitting a NULL pointer (memslot deletion is
100% complete) or accounting to an invalid memslot (race described above).

And it's probably worth adding a sanity check in kvm_unmap_gfn_range() to guard
against similar bugs in the future.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e081f785fb23..471b5056f8e6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1556,6 +1556,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
        bool flush = false;
 
+       KVM_BUG_ON(!kvm->mmu_invalidate_in_progress, kvm);
+
        if (kvm_memslots_have_rmaps(kvm))
                flush = __kvm_rmap_zap_gfn_range(kvm, range->slot,
                                                 range->start, range->end,


> +	kvm_mmu_zap_memslot_pages_and_flush(kvm, slot, flush);

I would prefer to call open code kvm_mmu_zap_memslot_pages_and_flush() in
kvm_mmu_zap_memslot() (or wherever the primary logic ends up residing).  I can't
think of a single scenario where zapping SPs without zapping leaf SPTEs would be
desirable or correct.  There's already a goto, so open coding doesn't raise the
ugly factor all that much.

Lightly tested at this point, but assuming nothing pops in broader testing, I'll
post the below as a mini-series.

---
 arch/x86/kvm/mmu/mmu.c | 74 +++++++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e081f785fb23..c5a6573c40e1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1556,6 +1556,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool flush = false;
 
+	KVM_BUG_ON(!kvm->mmu_invalidate_in_progress, kvm);
+
 	if (kvm_memslots_have_rmaps(kvm))
 		flush = __kvm_rmap_zap_gfn_range(kvm, range->slot,
 						 range->start, range->end,
@@ -6589,13 +6591,12 @@ static bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_e
 	return flush;
 }
 
-/*
- * Invalidate (zap) SPTEs that cover GFNs from gfn_start and up to gfn_end
- * (not including it)
- */
-void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
+static void __kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end,
+				bool is_memslot_deletion)
 {
+	LIST_HEAD(invalid_list);
 	bool flush;
+	gfn_t gfn;
 
 	if (WARN_ON_ONCE(gfn_end <= gfn_start))
 		return;
@@ -6611,7 +6612,32 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	if (tdp_mmu_enabled)
 		flush = kvm_tdp_mmu_zap_leafs(kvm, gfn_start, gfn_end, flush);
 
-	if (flush)
+	if (!is_memslot_deletion || list_empty(&kvm->arch.active_mmu_pages))
+		goto out;
+
+	/*
+	 * Since accounting information is stored in struct kvm_arch_memory_slot,
+	 * all MMU pages that are shadowing guest PTEs must be zapped before the
+	 * memslot is deleted, as freeing such pages after the memslot is freed
+	 * will result in use-after-free, e.g. in unaccount_shadowed().
+	 */
+	for (gfn = gfn_start; gfn < gfn_end; gfn++) {
+		struct kvm_mmu_page *sp;
+
+		for_each_gfn_valid_sp_with_gptes(kvm, sp, gfn)
+			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+
+		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
+			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
+			flush = false;
+			cond_resched_rwlock_write(&kvm->mmu_lock);
+		}
+	}
+
+out:
+	if (!list_empty(&invalid_list))
+		kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
+	else if (flush)
 		kvm_flush_remote_tlbs_range(kvm, gfn_start, gfn_end - gfn_start);
 
 	kvm_mmu_invalidate_end(kvm);
@@ -6619,6 +6645,16 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	write_unlock(&kvm->mmu_lock);
 }
 
+
+/*
+ * Invalidate (zap) SPTEs that cover GFNs from gfn_start and up to gfn_end
+ * (not including it)
+ */
+void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
+{
+	__kvm_zap_gfn_range(kvm, gfn_start, gfn_end, false);
+}
+
 static bool slot_rmap_write_protect(struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head,
 				    const struct kvm_memory_slot *slot)
@@ -7049,29 +7085,6 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	kvm_mmu_zap_all(kvm);
 }
 
-/*
- * Zapping leaf SPTEs with memslot range when a memslot is moved/deleted.
- *
- * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
- * case scenario we'll have unused shadow pages lying around until they
- * are recycled due to age or when the VM is destroyed.
- */
-static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *slot)
-{
-	struct kvm_gfn_range range = {
-		.slot = slot,
-		.start = slot->base_gfn,
-		.end = slot->base_gfn + slot->npages,
-		.may_block = true,
-	};
-
-	write_lock(&kvm->mmu_lock);
-	if (kvm_unmap_gfn_range(kvm, &range))
-		kvm_flush_remote_tlbs_memslot(kvm, slot);
-
-	write_unlock(&kvm->mmu_lock);
-}
-
 static inline bool kvm_memslot_flush_zap_all(struct kvm *kvm)
 {
 	return kvm->arch.vm_type == KVM_X86_DEFAULT_VM &&
@@ -7084,7 +7097,8 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	if (kvm_memslot_flush_zap_all(kvm))
 		kvm_mmu_zap_all_fast(kvm);
 	else
-		kvm_mmu_zap_memslot_leafs(kvm, slot);
+		__kvm_zap_gfn_range(kvm, slot->base_gfn,
+				    slot->base_gfn + slot->npages, true);
 }
 
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)

base-commit: efbc6bd090f48ccf64f7a8dd5daea775821d57ec
--

