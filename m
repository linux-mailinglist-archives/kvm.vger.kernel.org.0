Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58AA4367CD
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 18:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhJUQdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 12:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbhJUQdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 12:33:19 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6866BC061764
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 09:31:03 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id f11so1090216pfc.12
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 09:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=foB2FS4wRrN1Mm7ewC75oD/1WWlnuWRT2coycTpZ/sU=;
        b=MNmhzDWRdW2Fw3dtQvx6DkTbiBw5Auj8E4K7MRaRiaATy0T2ZngZ6LpHRt1eUcTKgk
         0JK80B/ZZsLpN9SYfcuvYFHh9oAsQfUd9xM3nXGY40CLKBEx2rR8BseaEHmdkHia04yV
         Lox7dEKr/pRdgbM7TtXF+CoLby+wYTfnSaG9fgQRBmXilQVrtm+RHQtbQfwP8Y1tVnXN
         qY1PmeBGNTjzqHlLsVGZrTiLwh0NrTtj4hGR50mYXhXm+5goWH7CP9vxT4GV/NvMk2/c
         oQvogaDG8/JqIXBTugCvmp8pZdpPWLG5mxZ6UME33VVHWXxHg6/t/9xBrV0FOZN8sqmQ
         Wssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=foB2FS4wRrN1Mm7ewC75oD/1WWlnuWRT2coycTpZ/sU=;
        b=U/xY63zKMjVHzonULiXi2JY6oewLyFqtzaB749Gy480fcUJ58jFeis0JDMXK9OdesN
         zEWwg1zWGeoYsTc4RRY40Rjv6pGxjpkLujU+mUEYSJ9jdKjTsfnYq+a4duUBUAe9kfcR
         wssGUUrl/yG7m2VXfFKsbtFGjUROZZYNiURGvMJdfFd0ca+61o/JW9uJlmanGEMU9MLZ
         SDxMLPUtFpIhl1n8a5/qpijGPfCnNXaFegjzBor4MnGP+s0E7bcSPjEeHng2LajPOooJ
         s584FFmJJM1LsAA6UX9Dz06hLjFEB1c5bAxGnI0ooSvkvDOu/zrgvwPikLg6mO8NkRkx
         sEkg==
X-Gm-Message-State: AOAM531lpgytNE9ImyCGWW8Ab3k+Z1vc5iWm67r1zsdLI49QAeh91GNg
        /umzgTKqj/ehYVIYEYjgvHytJA==
X-Google-Smtp-Source: ABdhPJzo9ykDSQV6beJAOaNw0UlBcf6UaaN6X7cqjHmsQCCN7wiHIRiTqNdue892mZ+RRHYoPeqOAw==
X-Received: by 2002:a05:6a00:1801:b0:44c:aab8:a5ba with SMTP id y1-20020a056a00180100b0044caab8a5bamr6727162pfa.32.1634833862612;
        Thu, 21 Oct 2021 09:31:02 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s30sm8440222pfg.17.2021.10.21.09.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 09:31:01 -0700 (PDT)
Date:   Thu, 21 Oct 2021 16:30:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 12/13] KVM: Optimize gfn lookup in kvm_zap_gfn_range()
Message-ID: <YXGVwlNxaibZAnmC@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <062df8ac9eb280440a5f0c11159616b1bbb1c2c4.1632171479.git.maciej.szmigiero@oracle.com>
 <YXCqo6XXIkyOb4IE@google.com>
 <d5c4c7da-676c-9889-6aaf-d423d408dd2d@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ELZjFUPXM+nEKShn"
Content-Disposition: inline
In-Reply-To: <d5c4c7da-676c-9889-6aaf-d423d408dd2d@maciej.szmigiero.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ELZjFUPXM+nEKShn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 21, 2021, Maciej S. Szmigiero wrote:
> On 21.10.2021 01:47, Sean Christopherson wrote:
> > In this case, I would honestly just drop the helper.  It's really hard to express
> > what this function does in a name that isn't absurdly long, and there's exactly
> > one user at the end of the series.
> 
> The "upper bound" is a common name for a binary search operation that
> finds the first node that has its key strictly greater than the searched key.

Ah, that I did not know (obviously).  But I suspect that detail will be lost on
other readers as well, even if they are familiar with the terminology.

> It can be integrated into its caller but I would leave a comment there
> describing what kind of operation that block of code does to aid in
> understanding the code.

Yeah, completely agree a comment would be wonderful.

> Although, to be honest, I don't quite get the reason for doing this
> considering that you want to put a single "rb_next()" call into its own
> helper for clarity below.

The goal is to make the macro itself easy to understand, even if the reader may
not understand the underlying details.  The bare rb_next() forces the reader to
pause to think about exactly what "node" is, and perhaps even dive into the code
for the other helpers.

With something like this, a reader that doesn't know the memslots details can
get a good idea of the basic gist of the macro without having to even know the
type of "node".  Obviously someone writing code will need to know the type, but
for readers bouncing around code it's a detail they don't need to know.

#define kvm_for_each_memslot_in_gfn_range(node, slots, start, end)	\
	for (node = kvm_get_first_node(slots, start);			\
	     !kvm_is_valid_node(slots, node, end);			\
	     node = kvm_get_next_node(node))

Hmm, on that point, having the caller do

	memslot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);

is more than a bit odd, and as is the case with the bare rb_next(), bleeds
implementation details into code that really doesn't care about implementation
details.  Eww, and looking closer, the caller also needs to grab slots->node_idx.

So while I would love to avoid an opaque iterator, adding one would be a net
positive in this case.  E.g.

/* Iterator used for walking memslots that overlap a gfn range. */
struct kvm_memslot_iterator iter {
        struct rb_node *node;
        struct kvm_memory_slot *memslot;
        struct kvm_memory_slots *slots;
	gfn_t start;
	gfn_t end;
} 

static inline void kvm_memslot_iter_start(struct kvm_memslot_iter *iter,
					  struct kvm_memslots *slots,
					  gfn_t start, gfn_t end)
{
	...
}

static inline bool kvm_memslot_iter_is_valid(struct kvm_memslot_iter *iter)
{
	/*
	 * If this slot starts beyond or at the end of the range so does
	 * every next one
	 */
	return iter->node && iter->memslot->base_gfn < end;
}

static inline void kvm_memslot_iter_next(struct kvm_memslot_iter *iter)
{
	iter->node = rb_next(iter->node);

	if (!iter->node)
		return;

	iter->memslot = container_of(iter->node, struct kvm_memory_slot,
				     gfn_node[iter->slots->node_idx]);
}

/* Iterate over each memslot *possibly* intersecting [start, end) range */
#define kvm_for_each_memslot_in_gfn_range(iter, node, slots, start, end) \
	for (kvm_memslot_iter_start(iter, node, slots, start, end);	 \
	     kvm_memslot_iter_is_valid(iter);				 \
	     kvm_memslot_iter_next(node))				 \


Ugh, this got me looking at kvm_zap_gfn_range(), and that thing is trainwreck.
There are three calls kvm_flush_remote_tlbs_with_address(), two of which should
be unnecessary, but become necessary because the last one is broken.  *sigh*

That'd also be a good excuse to extract the rmap loop to a separate helper.  Then
you don't need to constantly juggle the 80 char limit and variable collisions
while you're modifying this mess.  I'll post the attached patches separately
since the first one (two?) should go into 5.15.  They're compile tested only
at this point, but hopefully I've had enough coffee and they're safe to base
this series on top (note, they're based on kvm/queue, commit 73f122c4f06f ("KVM:
cleanup allocation of rmaps and page tracking data").

> > The kvm_for_each_in_gfn prefix is _really_ confusing.  I get that these are all
> > helpers for "kvm_for_each_memslot...", but it's hard not to think these are all
> > iterators on their own.  I would gladly sacrifice namespacing for readability in
> > this case.
> 
> "kvm_for_each_memslot_in_gfn_range" was your proposed name here:
> https://lore.kernel.org/kvm/YK6GWUP107i5KAJo@google.com/
> 
> But no problem renaming it.

Oh, I was commenting on the inner helpers.  The macro name itself is great. ;-)

> > @@ -882,12 +875,16 @@ struct rb_node *kvm_for_each_in_gfn_first(struct kvm_memslots *slots, gfn_t star
> >   	return node;
> >   }
> > 
> > -static inline
> > -bool kvm_for_each_in_gfn_no_more(struct kvm_memslots *slots, struct rb_node *node, gfn_t end)
> > +static inline bool kvm_is_last_node(struct kvm_memslots *slots,
> > +				    struct rb_node *node, gfn_t end)
> 
> kvm_is_last_node() is a bit misleading since this function is supposed
> to return true even on the last node, only returning false one node past
> the last one (or when the tree runs out of nodes).

Good point.  I didn't love the name when I suggested either.  What about
kvm_is_valid_node()?

> >   {
> >   	struct kvm_memory_slot *memslot;
> > 
> > -	memslot = container_of(node, struct kvm_memory_slot, gfn_node[slots->node_idx]);
> > +	if (!node)
> > +		return true;
> > +
> > +	memslot = container_of(node, struct kvm_memory_slot,
> > +			       gfn_node[slots->node_idx]);
> 
> You previously un-wrapped such lines, like for example in
> https://lore.kernel.org/kvm/YK2GjzkWvjBcCFxn@google.com/ :

Heh, yes, the balance between "too long" and "hard to read" is subjective.  The
ones I usually let run over are cases where it's a short word on the end, the
overrun is only a couple chars, the statement is the sole line of an if/else
statement, there's a null/validity check immediately following etc...

All that said, I don't have a strong opinion on this one, I'm a-ok if you want to
let it run over.

> > > +		slot = container_of(node, struct kvm_memory_slot,
> > > +				    gfn_node[idxactive]);
> > 
> > With 'idx', this can go on a single line.  It runs over by two chars, but the 80
> > char limit is a soft limit, and IMO avoiding line breaks for things like this
> > improves readability.
> 
> 
> > 
> >   	/*
> >   	 * If this slot starts beyond or at the end of the range so does
> > @@ -896,11 +893,16 @@ bool kvm_for_each_in_gfn_no_more(struct kvm_memslots *slots, struct rb_node *nod
> >   	return memslot->base_gfn >= end;
> >   }
> > 
> > +static inline bool kvm_get_next_node(struct rb_node *node)
> > +{
> > +	return rb_next(node)
> > +}
> > +
> >   /* Iterate over each memslot *possibly* intersecting [start, end) range */
> >   #define kvm_for_each_memslot_in_gfn_range(node, slots, start, end)	\
> > -	for (node = kvm_for_each_in_gfn_first(slots, start);		\
> > -	     node && !kvm_for_each_in_gfn_no_more(slots, node, end);	\
> > -	     node = rb_next(node))					\
> > +	for (node = kvm_get_first_node(slots, start);			\
> > +	     !kvm_is_last_node(slots, node, end);			\
> > +	     node = kvm_get_next_node(node))				\
> > 
> >   /*
> >    * KVM_SET_USER_MEMORY_REGION ioctl allows the following operations:
> > --
> > 
> 
> Thanks,
> Maciej

--ELZjFUPXM+nEKShn
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-mmu-Drop-a-redundant-broken-remote-TLB-flush.patch"

From f321eeeb9f217a82bfa51cc92c571cba9606642b Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Oct 2021 08:59:15 -0700
Subject: [PATCH 1/3] KVM: x86/mmu: Drop a redundant, broken remote TLB flush

A recent commit to fix the calls to kvm_flush_remote_tlbs_with_address()
in kvm_zap_gfn_range() inadvertantly added yet another flush instead of
fixing the existing flush.  Drop the redundant flush, and fix the params
for the existing flush.

Fixes: 2822da446640 ("KVM: x86/mmu: fix parameters to kvm_flush_remote_tlbs_with_address")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c6ddb042b281..f82b192bba0b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5709,13 +5709,11 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
 							  gfn_end, flush);
-		if (flush)
-			kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
-							   gfn_end - gfn_start);
 	}
 
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
+		kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
+						   gfn_end - gfn_start);
 
 	kvm_dec_notifier_count(kvm, gfn_start, gfn_end);
 
-- 
2.33.0.1079.g6e70778dc9-goog


--ELZjFUPXM+nEKShn
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-x86-mmu-Drop-a-redundant-remote-TLB-flush-in-kvm.patch"

From d20977faa4b6ded18fcf7d83bb85ffb1f32eecdb Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Oct 2021 09:05:49 -0700
Subject: [PATCH 2/3] KVM: x86/mmu: Drop a redundant remote TLB flush in
 kvm_zap_gfn_range()

Remove an unnecessary remote TLB flush in kvm_zap_gfn_range() now that
said function holds mmu_lock for write for its entire duration.  The
flush added by the now-reverted commit to allow TDP MMU to flush while
holding mmu_lock for read, as the transition from write=>read required
dropping the lock and thus a pending flush needed to be serviced.

Fixes: 5a324c24b638 ("Revert "KVM: x86/mmu: Allow zap gfn range to operate under the mmu read lock"")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f82b192bba0b..e8b8a665e2e9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5700,9 +5700,6 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 						end - 1, true, flush);
 			}
 		}
-		if (flush)
-			kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
-							   gfn_end - gfn_start);
 	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
-- 
2.33.0.1079.g6e70778dc9-goog


--ELZjFUPXM+nEKShn
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-KVM-x86-mmu-Extract-zapping-of-rmaps-for-gfn-range-t.patch"

From 6c7e31b22a9240af9e15a369f7a4d3a1b10c7d89 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Oct 2021 09:20:57 -0700
Subject: [PATCH 3/3] KVM: x86/mmu: Extract zapping of rmaps for gfn range to
 separate helper

Extract the zapping of rmaps, a.k.a. legacy MMU, for a gfn range to a
separate helper to clean up the unholy mess that kvm_zap_gfn_range() has
become.  In addition to deep nesting, the rmaps zapping spreads out the
declaration of several variables and is generally a mess.  Clean up the
mess now so that future work to improve the memslots implementation
doesn't need to deal with it.

Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 52 ++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e8b8a665e2e9..182d35a216d4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5667,40 +5667,48 @@ void kvm_mmu_uninit_vm(struct kvm *kvm)
 	kvm_mmu_uninit_tdp_mmu(kvm);
 }
 
+static bool __kvm_zap_rmaps(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
+{
+	const struct kvm_memory_slot *memslot;
+	struct kvm_memslots *slots;
+	bool flush = false;
+	gfn_t start, end;
+	int i;
+
+	if (!kvm_memslots_have_rmaps(kvm))
+		return flush;
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(memslot, slots) {
+			start = max(gfn_start, memslot->base_gfn);
+			end = min(gfn_end, memslot->base_gfn + memslot->npages);
+			if (start >= end)
+				continue;
+
+			flush = slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
+							PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
+							start, end - 1, true, flush);
+		}
+	}
+
+	return flush;
+}
+
 /*
  * Invalidate (zap) SPTEs that cover GFNs from gfn_start and up to gfn_end
  * (not including it)
  */
 void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 {
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
+	bool flush;
 	int i;
-	bool flush = false;
 
 	write_lock(&kvm->mmu_lock);
 
 	kvm_inc_notifier_count(kvm, gfn_start, gfn_end);
 
-	if (kvm_memslots_have_rmaps(kvm)) {
-		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-			slots = __kvm_memslots(kvm, i);
-			kvm_for_each_memslot(memslot, slots) {
-				gfn_t start, end;
-
-				start = max(gfn_start, memslot->base_gfn);
-				end = min(gfn_end, memslot->base_gfn + memslot->npages);
-				if (start >= end)
-					continue;
-
-				flush = slot_handle_level_range(kvm,
-						(const struct kvm_memory_slot *) memslot,
-						kvm_zap_rmapp, PG_LEVEL_4K,
-						KVM_MAX_HUGEPAGE_LEVEL, start,
-						end - 1, true, flush);
-			}
-		}
-	}
+	flush = __kvm_zap_rmaps(kvm, gfn_start, gfn_end);
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-- 
2.33.0.1079.g6e70778dc9-goog


--ELZjFUPXM+nEKShn--
