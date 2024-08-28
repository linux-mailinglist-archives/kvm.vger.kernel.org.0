Return-Path: <kvm+bounces-25295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A92963126
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 21:46:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6BCB1C220A9
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 19:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3357F1ABEC1;
	Wed, 28 Aug 2024 19:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a4GU+fCZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE3F19DF40
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 19:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724874359; cv=none; b=FAwd5O5zRuEXadJx5SOZlA1xHZelQlZQs2d41/YSJvxpvtAnMxJJFf+gKMqayZ2K2pFNrlw6LVebKABDuImvESACOpO7ror/fsDDkDkv18i20fY4782o4WVBG5F8Ln3mKyhAnxrVQIaodBh+qzQmroG1+BFhGRGN89V0Een/beM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724874359; c=relaxed/simple;
	bh=+tj7zQKnHjSX8eAJuKX2LgOnWpTn6P4v/qosfomGgtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pU4qFlJJqwicbQPPWflBm5ocZnNFcHvfaKeOwqS1M9wuJ3OLi9F688ahozB8IQzjeNErKffcWiCIvJdVuHWm85a0e0CwyQlEuUG9GksxIZoMV8gGg+wNL/3kJLYWRQbdY2JC7t5zKoPkVkIr48UMd3aSMIjNibBeAuED64CnPCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a4GU+fCZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724874356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L734DZ5S8LoTHmIma5i8qfoMND7Q4A1Bv0JRoAj5Nks=;
	b=a4GU+fCZXrQH23/55ZVNYkdlFPcYGr6E4iVCRyl/HIwWnWOuUgwSZScgt61m2VpPFJ8H0F
	r5kgdstVV6jbbUnN7PHu1kkSAaYmxZnd89gyoHQaUrLrzzdcaI+EGjzRX6Mm6XM7M4MzVQ
	c9op2Rnmk6JB678N6CAhX0U4kntxuNQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-PsoGC99IMm6q_i-tMIVfDg-1; Wed, 28 Aug 2024 15:45:54 -0400
X-MC-Unique: PsoGC99IMm6q_i-tMIVfDg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7a34e9c8945so917365785a.2
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 12:45:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724874354; x=1725479154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L734DZ5S8LoTHmIma5i8qfoMND7Q4A1Bv0JRoAj5Nks=;
        b=O+IZCwzERVQFnIVg7wxI7IvndDoAcn2q0D6DD1zxR2h1YYUBSZUZ3NrGk5wB7QzGAu
         YsPPubNou9+jf7fD0hHHkesrDOsSyHepdTVf0Hot4/LLrkuxsLl5FO/Th+OAsjNC40t5
         g/qqX5JoYgRFP/Q3WX/3qbjG4MT0mbPfSxvmYnwYfA5ewAKCpWBPwMZN9QtYxujjJi6A
         UxuBVz/+HdeYRmpOiHOp9FHjOo69ZG7+RCLl7kvA/N75ItlPsGbh+9Oa84JeNOKoc+jd
         K98kOiBhfxM5XFRIUNEKEVq5OzXdhuGUYbq2gUAKtA7F9wLSYsjkbjtS9L+p353JSqnr
         cVuw==
X-Forwarded-Encrypted: i=1; AJvYcCVISenbZ3+FiZJteve/9jNyFLvZHpTqIwQt0/MC82WjAuPEV8kU75TPjDNZgmbqp/nw5UI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUX81/icil7H9nuebllhDZUnq8K+ltmt5MIG6SolXreRwz8rdb
	u6OEveRiqielFqDH5p6EH47Fs9LVesp5CfOeBUYXboxyqrx/QfK5q657gsGqGunGWSLGj86kal9
	jH6yPCG0SQdd/YZFCIYGwUTqFEVLoyhO9qLQGCr1yL3m2a6e5Sw==
X-Received: by 2002:a05:620a:254e:b0:79f:e9a:5ae5 with SMTP id af79cd13be357-7a804266bb7mr54281685a.60.1724874353629;
        Wed, 28 Aug 2024 12:45:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsRkbfxaQ2v8zv5NUTlC+wRgbNKKbywOOWW7bb22SixhenOa1GYiY2jzuWWLtCsKrTEebjFg==
X-Received: by 2002:a05:620a:254e:b0:79f:e9a:5ae5 with SMTP id af79cd13be357-7a804266bb7mr54276185a.60.1724874352847;
        Wed, 28 Aug 2024 12:45:52 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a7ff07fee3sm39710985a.91.2024.08.28.12.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 12:45:52 -0700 (PDT)
Date: Wed, 28 Aug 2024 15:45:49 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 06/19] mm/pagewalk: Check pfnmap for folio_walk_start()
Message-ID: <Zs9-beA-eTuXTfN6@x1n>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-7-peterx@redhat.com>
 <9f9d7e96-b135-4830-b528-37418ae7bbfd@redhat.com>
 <Zs8zBT1aDh1v9Eje@x1n>
 <c1d8220c-e292-48af-bbab-21f4bb9c7dc5@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c1d8220c-e292-48af-bbab-21f4bb9c7dc5@redhat.com>

On Wed, Aug 28, 2024 at 05:30:43PM +0200, David Hildenbrand wrote:
> > This one is correct; I overlooked this comment which can be obsolete.  I
> > can either refine this patch or add one patch on top to refine the comment
> > at least.
> 
> Probably best if you use what you consider reasonable in your patch.
> 
> > 
> > > +       if (IS_ENABLED(CONFIG_ARCH_HAS_PMD_SPECIAL)) {
> > 
> > We don't yet have CONFIG_ARCH_HAS_PMD_SPECIAL, but I get your point.
> > 
> > > +               if (likely(!pmd_special(pmd)))
> > > +                       goto check_pfn;
> > > +               if (vma->vm_ops && vma->vm_ops->find_special_page)
> > > +                       return vma->vm_ops->find_special_page(vma, addr);
> > 
> > Why do we ever need this?  This is so far destined to be totally a waste of
> > cycles.  I think it's better we leave that until either xen/gntdev.c or any
> > new driver start to use it, rather than keeping dead code around.
> 
> I just copy-pasted what we had in vm_normal_page() to showcase. If not
> required, good, we can add a comment we this is not required.
> 
> > 
> > > +               if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
> > > +                       return NULL;
> > > +               if (is_huge_zero_pmd(pmd))
> > > +                       return NULL;
> > 
> > This is meaningless too until we make huge zero pmd apply special bit
> > first, which does sound like to be outside the scope of this series.
> 
> Again, copy-paste, but ...
> 
> > 
> > > +               if (pmd_devmap(pmd))
> > > +                       /* See vm_normal_page() */
> > > +                       return NULL;
> > 
> > When will it be pmd_devmap() if it's already pmd_special()?
> > 
> > > +               return NULL;
> > 
> > And see this one.. it's after:
> > 
> >    if (xxx)
> >        return NULL;
> >    if (yyy)
> >        return NULL;
> >    if (zzz)
> >        return NULL;
> >    return NULL;
> > 
> > Hmm??  If so, what's the difference if we simply check pmd_special and
> > return NULL..
> 
> Yes, they all return NULL. The compiler likely optimizes it all out. Maybe
> we have it like that for pure documentation purposes. But yeah, we should
> simply return NULL and think about cleaning up vm_normal_page() as well, it
> does look strange.
> 
> > 
> > > +       }
> > > +
> > > +       /* !CONFIG_ARCH_HAS_PMD_SPECIAL case follows: */
> > > +
> > >          if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
> > >                  if (vma->vm_flags & VM_MIXEDMAP) {
> > >                          if (!pfn_valid(pfn))
> > >                                  return NULL;
> > > +                       if (is_huge_zero_pmd(pmd))
> > > +                               return NULL;
> > 
> > I'd rather not touch here as this series doesn't change anything for
> > MIXEDMAP yet..
> 
> Yes, that can be a separate change.
> 
> > 
> > >                          goto out;
> > >                  } else {
> > >                          unsigned long off;
> > > @@ -692,6 +706,11 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
> > >                  }
> > >          }
> > > +       /*
> > > +        * For historical reasons, these might not have pmd_special() set,
> > > +        * so we'll check them manually, in contrast to vm_normal_page().
> > > +        */
> > > +check_pfn:
> > >          if (pmd_devmap(pmd))
> > >                  return NULL;
> > >          if (is_huge_zero_pmd(pmd))
> > > 
> > > 
> > > 
> > > We should then look into mapping huge zeropages also with pmd_special.
> > > pmd_devmap we'll leave alone until removed. But that's indeoendent of your series.
> > 
> > This does look reasonable to match what we do with pte zeropage.  Could you
> > remind me what might be the benefit when we switch to using special bit for
> > pmd zero pages?
> 
> See below. It's the way to tell the VM that a page is special, so you can
> avoid a separate check at relevant places, like GUP-fast or in vm_normal_*.
> 
> > 
> > > 
> > > I wonder if CONFIG_ARCH_HAS_PTE_SPECIAL is sufficient and we don't need additional
> > > CONFIG_ARCH_HAS_PMD_SPECIAL.
> > 
> > The hope is we can always reuse the bit in the pte to work the same for
> > pmd/pud.
> > 
> > Now we require arch to select ARCH_SUPPORTS_HUGE_PFNMAP to say "pmd/pud has
> > the same special bit defined".
> 
> Note that pte_special() is the way to signalize to the VM that a PTE does
> not reference a refcounted page, or is similarly special and shall mostly be
> ignored. It doesn't imply that it is a PFNAMP pte, not at all.

Right, it's just that this patch started with having pmd/pud special bit
sololy used for pfnmaps only so far.  I'd agree, again, that I think it
makes sense to keep it consistent with pte's in a longer run, but that'll
need to be done step by step, and tested properly on each of the goals
(e.g. when extend that to zeropage pmd).

> 
> The shared zeropage is usually not refcounted (except during GUP FOLL_GET
> ... but not FOLL_PIN) and the huge zeropage is usually also not refcounted
> (but FOLL_PIN still does it). Both are special.
> 
> 
> If you take a look at the history pte_special(), it was introduced for
> VM_MIXEDMAP handling on s390x, because pfn_valid() to identify "special"
> pages did not work:
> 
> commit 7e675137a8e1a4d45822746456dd389b65745bf6
> Author: Nicholas Piggin <npiggin@gmail.com>
> Date:   Mon Apr 28 02:13:00 2008 -0700
> 
>     mm: introduce pte_special pte bit
> 
> 
> In the meantime, it's required for architectures that wants to support
> GUP-fast I think, to make GUP-fast bail out and fallback to the slow path
> where we do a vm_normal_page() -- or fail right at the VMA check for now
> (VM_PFNMAP).

I wonder whether pfn_valid() would work for the archs that do not support
pte_special but to enable gup-fast.

Meanwhile I'm actually not 100% sure pte_special is only needed in
gup-fast.  See vm_normal_page() and for VM_PFNMAP when pte_special bit is
not defined:

		} else {
			unsigned long off;
			off = (addr - vma->vm_start) >> PAGE_SHIFT;
			if (pfn == vma->vm_pgoff + off) <------------------ [1]
				return NULL;
			if (!is_cow_mapping(vma->vm_flags))
				return NULL;
		}

I suspect things can go wrong when there's assumption on vm_pgoff [1].  At
least vfio-pci isn't storing vm_pgoff for the base PFN, so this check will
go wrong when pte_special is not supported on any arch but when vfio-pci is
present.  I suspect more drivers can break it.

So I wonder if it's really the case in real life that only gup-fast would
need the special bit.  It could be that we thought it like that, but nobody
really seriously tried run it without special bit yet to see things broke.

This series so far limit huge pfnmap with special bits; that make me feel
safer to do as a start point.

> 
> An architecture that doesn't implement pte_special() can support pfnmaps but
> not GUP-fast. Similarly, an architecture that doesn't implement
> pmd_special() can support huge pfnmaps, but not GUP-fast.
> 
> If you take a closer look, really the only two code paths that look at
> pte_special() are GUP-fast and vm_normal_page().
> 
> If we use pmd_special/pud_special in other code than that, we are diverging
> from the pte_special() model, and are likely doing something wrong.
> 
> I see how you arrived at the current approach, focusing exclusively on x86.
> But I think this just adds inconsistency.

Hmm, that's definitely not what I wanted to express..

IMHO it's about our current code base has very limited use of larger
mappings, especialy pud, so even if I try to create the so-called
vm_normal_page_pud() to match pte, it'll mostly only contain the pud
special bit test.

We could add some pfn_valid() checks (even if I know no arch that I can
support !special but rely on pfn_valid.. nowhere I can test at all),
process vm_ops->find_special_page() even if I know nobody is using it, and
so on (obviously pud zeropage is missing so nothing to copy over
there).. just trying to match vm_normal_page().

But so far they're all redundant, and I prefer not adding redundant or dead
codes; as simple as that..  It makes more sense to me sticking with what we
know that will work, and then go from there, then we can add things by
justifying them properly step by step later.

We indeed already have vm_normal_page_pmd(), please see below.

> 
> So my point is that we use the same model, where we limit
> 
> * pmd_special() to GUP-fast and vm_normal_page_pmd()
> * pud_special() to GUP-fast and vm_normal_page_pud()
> 
> And simply do the exact same thing as we do for pte_special().
> 
> If an arch supports pmd_special() and pud_special() we can support both
> types of hugepfn mappings. If not, an architecture *might* support it,
> depending on support for GUP-fast and maybe depending on MIXEDMAP support
> (again, just like pte_special()). Not your task to worry about, you will
> only "unlock" x86.

And arm64 2M.  Yes I think I'd better leave the rest to others if I have
totally no idea how to even test them..  Even with the current Alex was
helping or I don't really have hardwares on hand.

> 
> So maybe we do want CONFIG_ARCH_HAS_PMD_SPECIAL as well, maybe it can be
> glued to CONFIG_ARCH_HAS_PTE_SPECIAL (but I'm afraid it can't unless all
> archs support both). I'll leave that up to you.
> 
> > 
> > > 
> > > As I said, if you need someone to add vm_normal_page_pud(), I can handle that.
> > 
> > I'm pretty confused why we need that for this series alone.
> 
> See above.
> 
> > 
> > If you prefer vm_normal_page_pud() to be defined and check pud_special()
> > there, I can do that.  But again, I don't yet see how that can make a
> > functional difference considering the so far very limited usage of the
> > special bit, and wonder whether we can do that on top when it became
> > necessary (and when we start to have functional requirement of such).
> 
> I hope my explanation why pte_special() even exists and how it is used makes
> it clearer.
> 
> It's not that much code to handle it like pte_special(), really. I don't
> expect you to teach GUP-slow about vm_normal_page() etc.

One thing I can do here is I move the pmd_special() check into the existing
vm_normal_page_pmd(), then it'll be a fixup on top of this patch:

===8<===
diff --git a/mm/memory.c b/mm/memory.c
index 288f81a8698e..42674c0748cb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -672,11 +672,10 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 {
 	unsigned long pfn = pmd_pfn(pmd);
 
-	/*
-	 * There is no pmd_special() but there may be special pmds, e.g.
-	 * in a direct-access (dax) mapping, so let's just replicate the
-	 * !CONFIG_ARCH_HAS_PTE_SPECIAL case from vm_normal_page() here.
-	 */
+	/* Currently it's only used for huge pfnmaps */
+	if (unlikely(pmd_special(pmd)))
+		return NULL;
+
 	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
 		if (vma->vm_flags & VM_MIXEDMAP) {
 			if (!pfn_valid(pfn))
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 12be5222d70e..461ea3bbd8d9 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -783,7 +783,7 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 		fw->pmdp = pmdp;
 		fw->pmd = pmd;
 
-		if (pmd_none(pmd) || pmd_special(pmd)) {
+		if (pmd_none(pmd)) {
 			spin_unlock(ptl);
 			goto not_found;
 		} else if (!pmd_leaf(pmd)) {
-- 
2.45.0
===8<===

Would that look better to you?

> 
> If you want me to just takeover some stuff, let me know.

Do you mean sending something on top of this?  I suppose any of us is free
to do so, so please go ahead if it's the case.

Thanks,

-- 
Peter Xu


