Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFF9454B8F
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 18:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239306AbhKQRGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 12:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239104AbhKQRGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 12:06:22 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA29C061764
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 09:03:21 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id b4so2792575pgh.10
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 09:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XdfZV+r/oUgxEOOqIpmiJHn6mxYB5pbWUnGu6nPj6Mo=;
        b=q5LxYnMvesyLf+E+JoHFScp9VslE3ZKjWxTQmEvBjCcSz7NgJkX2mYqf79QjisZsia
         VRxH/C/QSpqL3543e8PLrN6Qg/gPsm114NiEtMcgoiBYve2A49UcyCBApGChAd9PUf30
         RxVfqUMsd6oYmLhx8SiuhORbOlsk3rgdLp8d1s784V33hX3/D5r88aOD9yAIwgsfMc3E
         c4DCfXs/kMS1oIGd4pJucex2wlGY5B6HMoof4BHocK94jfwRymVH/x4v3d1L2NPDCkZM
         bp6ZQ5Q4TzEc5YOdPIArD0VLQma/JW2+AUajSxDtrPc3zWR+M9FMoh8u4v0g3bmxN2U7
         hw/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XdfZV+r/oUgxEOOqIpmiJHn6mxYB5pbWUnGu6nPj6Mo=;
        b=jpAXtX3Ly+9w0OxZf9GZN18NpnfiRok74us76rS4Rt/0cf8efud9wIc/wuYbAnJc0L
         3wHLve8UjKaqd0PJOEfmmleIlT09APqaT+freErYwOzbmnfputR4z7Be8R1y+z2p0lzT
         iPlweBPh/Cg5/it2N7NRMA7xXIj+/H33xf6w+fuu1Qhpp6JvOk/xyhQ6DHAi7snc5qen
         0iBpOkQaneRNYvbtRdrZBQIXC87+m71x4k/3M5oG+oywIT9Hrg8t6X9pRxKdBwZ6M1F2
         tVsaTJDVTfVe7Cq33TOETlwMm2Xapj3XzQG5TBLRh5x1as3dvYNXwQ0zEb4KyNXkoWFf
         gu7g==
X-Gm-Message-State: AOAM530P5zEeUyEobLqC3C19TOGN2fmoVii6BYytIfRvdfMN8aZL7wsK
        pk5yOxlTae99/5R1wMt7U+r4jw==
X-Google-Smtp-Source: ABdhPJxBRP3uXJHSo+kROu6vn23icDOvCYb25cwaR1ctuZ0H8jJH+wc3BEgCFl8NYDHgxOWTyIQpGg==
X-Received: by 2002:a63:3748:: with SMTP id g8mr6319521pgn.102.1637168600428;
        Wed, 17 Nov 2021 09:03:20 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l28sm238191pgu.45.2021.11.17.09.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 09:03:19 -0800 (PST)
Date:   Wed, 17 Nov 2021 17:03:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Hou Wenlong <houwenlong93@linux.alibaba.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Skip tlb flush if it has been done in
 zap_gfn_range()
Message-ID: <YZU10wflDOJ5S/PY@google.com>
References: <5e16546e228877a4d974f8c0e448a93d52c7a5a9.1637140154.git.houwenlong93@linux.alibaba.com>
 <d95f29e5-efef-4a58-420c-a446c3a684e9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d95f29e5-efef-4a58-420c-a446c3a684e9@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 17, 2021, Paolo Bonzini wrote:
> On 11/17/21 10:20, Hou Wenlong wrote:
> > If the parameter flush is set, zap_gfn_range() would flush remote tlb
> > when yield, then tlb flush is not needed outside. So use the return
> > value of zap_gfn_range() directly instead of OR on it in
> > kvm_unmap_gfn_range() and kvm_tdp_mmu_unmap_gfn_range().
> > 
> > Fixes: 3039bcc744980 ("KVM: Move x86's MMU notifier memslot walkers to generic code")
> > Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c     | 2 +-
> >   arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
> >   2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 354d2ca92df4..d57319e596a9 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1582,7 +1582,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> >   		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
> >   	if (is_tdp_mmu_enabled(kvm))
> > -		flush |= kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
> > +		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
> >   	return flush;
> >   }
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 7c5dd83e52de..9d03f5b127dc 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1034,8 +1034,8 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
> >   	struct kvm_mmu_page *root;
> >   	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
> > -		flush |= zap_gfn_range(kvm, root, range->start, range->end,
> > -				       range->may_block, flush, false);
> > +		flush = zap_gfn_range(kvm, root, range->start, range->end,
> > +				      range->may_block, flush, false);
> >   	return flush;
> >   }
> > 
> 
> Queued both, thanks.

Please replace patch 02 with the below.  Hou's patch isn't wrong, but it's nowhere
near agressive enough in purging the unecessary flush.  I was too slow in writing
a changelog for this patch in my local repo.

From 001a1b9f5f71c0d8115875b26dbac7694431c3dd Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 17 Nov 2021 08:53:57 -0800
Subject: [PATCH] KVM: x86/mmu: Remove spurious TLB flushes in TDP MMU zap
 collapsible path

Drop the "flush" param and return values to/from the TDP MMU's helper for
zapping collapsible SPTEs.  Because the helper runs with mmu_lock held
for read, not write, it uses tdp_mmu_zap_spte_atomic(), and the atomic
zap handles the necessary remote TLB flush.

Similarly, because mmu_lock is dropped and re-acquired between zapping
legacy MMUs and zapping TDP MMUs, kvm_mmu_zap_collapsible_sptes() must
handle remote TLB flushes from the legacy MMU before calling into the TDP
MMU.

Opportunistically drop the local "flush" variable in the common helper.

Fixes: e2209710ccc5d ("KVM: x86/mmu: Skip rmap operations if rmaps not allocated")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  9 ++-------
 arch/x86/kvm/mmu/tdp_mmu.c | 22 +++++++---------------
 arch/x86/kvm/mmu/tdp_mmu.h |  5 ++---
 3 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d57319e596a9..b659787b7398 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5853,8 +5853,6 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *slot)
 {
-	bool flush = false;
-
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		/*
@@ -5862,17 +5860,14 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		 * logging at a 4k granularity and never creates collapsible
 		 * 2m SPTEs during dirty logging.
 		 */
-		flush = slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
-		if (flush)
+		if (slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true))
 			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 		write_unlock(&kvm->mmu_lock);
 	}

 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
-		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
-		if (flush)
-			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
 		read_unlock(&kvm->mmu_lock);
 	}
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7ac0c4f29c8e..b7ace8b9c019 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1364,10 +1364,9 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
  * Clear leaf entries which could be replaced by large mappings, for
  * GFNs within the slot.
  */
-static bool zap_collapsible_spte_range(struct kvm *kvm,
+static void zap_collapsible_spte_range(struct kvm *kvm,
 				       struct kvm_mmu_page *root,
-				       const struct kvm_memory_slot *slot,
-				       bool flush)
+				       const struct kvm_memory_slot *slot)
 {
 	gfn_t start = slot->base_gfn;
 	gfn_t end = start + slot->npages;
@@ -1378,10 +1377,8 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,

 	tdp_root_for_each_pte(iter, root, start, end) {
 retry:
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true)) {
-			flush = false;
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
-		}

 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
@@ -1393,6 +1390,7 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 							    pfn, PG_LEVEL_NUM))
 			continue;

+		/* Note, a successful atomic zap also does a remote TLB flush. */
 		if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
 			/*
 			 * The iter must explicitly re-read the SPTE because
@@ -1401,30 +1399,24 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
 			goto retry;
 		}
-		flush = true;
 	}

 	rcu_read_unlock();
-
-	return flush;
 }

 /*
  * Clear non-leaf entries (and free associated page tables) which could
  * be replaced by large mappings, for GFNs within the slot.
  */
-bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       bool flush)
+void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot)
 {
 	struct kvm_mmu_page *root;

 	lockdep_assert_held_read(&kvm->mmu_lock);

 	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
-		flush = zap_collapsible_spte_range(kvm, root, slot, flush);
-
-	return flush;
+		zap_collapsible_spte_range(kvm, root, slot);
 }

 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 476b133544dd..3899004a5d91 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -64,9 +64,8 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       struct kvm_memory_slot *slot,
 				       gfn_t gfn, unsigned long mask,
 				       bool wrprot);
-bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       bool flush);
+void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot);

 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
--
2.34.0.rc1.387.gb447b232ab-goog
