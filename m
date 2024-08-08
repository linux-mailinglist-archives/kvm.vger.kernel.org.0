Return-Path: <kvm+bounces-23661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F93094C714
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 00:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A288C1C2215C
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 22:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0615715ECE9;
	Thu,  8 Aug 2024 22:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="csGvELGG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A474A1E
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 22:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723157153; cv=none; b=EVuxs0licO+cbKcjcFJGVHcfgqzpTrrg5f4ZUJByujt9KHER5vCm4J3W33IxWXFJ5I/l+CDiA7+dr05F49FXvzGufDhchG7SpZkgAZtYN7ulbE0DGOiEElTO1zCAns7eVSietwiVdtcyTXq1QZ6tj98T7IVgqUyVgijfFWAAhyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723157153; c=relaxed/simple;
	bh=NuRvK7tHeF/VaYkrRFz1WItqpmKnBbpdbZIjayxYJC4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=szYOHz1BnGxvgpQxPZqL9x+S8SIADnHh3G4o5ota1rO2XT/i+MtjetrKJp4+sXQp9ErX60lh8jGDCs6jbE2rp1+nXtkX0uKzXErgBv1Nf1WzXPTjfKf3XJG8Me86cXQ/FBwlvpxvk14zNFQasOSDUoY/tSM+L+ZBTsjZL6ONTYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=csGvELGG; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a994e332a8so1308184a12.3
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 15:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723157151; x=1723761951; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zNoZqlzt9ZBl78Ypw3YUgXOuKREj1jjRu4BYW9vQ8bI=;
        b=csGvELGGfDXSAuUsOgrCrrv3EchPNfXAoLuyjsUczCTD4yrGdcG5h+mOcI17JINe6R
         Uj6naOIySRaR7YkU5dVMwAXOtBf1yOj3Xh70naNLsNgXv3NBKl7MP2oXP4ZwrkxIVbP5
         /VXoU5E8APZo58MRH88V0EXZjKBA1nOiM1RjF7l6PK9cXhGyRUpPfbomIMIB+/4d3A9h
         Ln2AvnepxF5ehcJSAp/5CBCmDQRl/Q7uPRa1xkCOK1BkoXnvHNKJQmiEHDV9/R8IGS+Q
         4iV7vddG279BED+E4AA7fpsuWIOnPUw3oO1rv/ukCjfjTeztlMH0NHl/GrBHIDHJiveS
         Bs6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723157151; x=1723761951;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zNoZqlzt9ZBl78Ypw3YUgXOuKREj1jjRu4BYW9vQ8bI=;
        b=OghRnO80TBgRlqPf8MgYp6pLQNOMbAGHJU/7FQJxvaw9fvpU1RXjhKJuf6NzqWvYDH
         L4dtmzZlJRnAFUJJPJlJNNBg5F7QCwy0Xg4GOVSaVwY5kU9SJC4Cnabo7aF46en46PWF
         rBvyYqHoH0FDOeVyBaP8kEl/67zJ0jzZelIjDQImI9B3svUI9HUbEUdDbyDu3OMkNADh
         Nyh3p3OguEcrW9BrB06N1eN0Zv8pAj74+ZGYuw7vux0BWrheE7qwgFVuDyW6A8yOCEy/
         /6tdgp9Zm8wJV6+ttarZeSAmLUaLchdGPeDnT2LaaWNid0hIflvWA0Yn8WP6WQe8EjMn
         b0Aw==
X-Forwarded-Encrypted: i=1; AJvYcCW2k5/WFDlHRDbc7483XmbGoJM8yLxvSm8Poz2/Q0dIWcmn/wluZuNEvfNz3/zAV+IM2kPNkye1ZvqwfpI+KJiBJy1Z
X-Gm-Message-State: AOJu0YxggVJzuFGHSUFr7oS4nsGSPjRTpdSJ7WoOLeZCSyFM6+bLaXOK
	kGbbEjrHFKukloi8L7lNr/k5vDATs0WidUuTjFgI9bftP1bg/OPbzlPyGQqv4LRX3u9MNPasNfC
	zcg==
X-Google-Smtp-Source: AGHT+IEPJ08ELA+TzWWFCZw07FCvVi/TuALPCbLFSyKyDr+wDhcDE59d0hzyaFMhbl9jQNfxVlpU+d7vYMQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:b242:0:b0:6e7:95d3:b35c with SMTP id
 41be03b00d2f7-7c2684072femr6690a12.5.1723157150809; Thu, 08 Aug 2024 15:45:50
 -0700 (PDT)
Date: Thu, 8 Aug 2024 15:45:49 -0700
In-Reply-To: <ZrU9AJi7-pHT_UWS@x1n>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240807194812.819412-1-peterx@redhat.com> <20240807194812.819412-3-peterx@redhat.com>
 <ZrTlZ4vZ74sK8Ydd@google.com> <ZrU20AqADICwwmCy@x1n> <ZrU5JyjIa1CwZ_KD@google.com>
 <ZrU9AJi7-pHT_UWS@x1n>
Message-ID: <ZrVKndceu5gZT-j5@google.com>
Subject: Re: [PATCH v4 2/7] mm/mprotect: Push mmu notifier to PUDs
From: Sean Christopherson <seanjc@google.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Oscar Salvador <osalvador@suse.de>, Dan Williams <dan.j.williams@intel.com>, 
	James Houghton <jthoughton@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Nicholas Piggin <npiggin@gmail.com>, Rik van Riel <riel@surriel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "Kirill A . Shutemov" <kirill@shutemov.name>, 
	linuxppc-dev@lists.ozlabs.org, Mel Gorman <mgorman@techsingularity.net>, 
	Hugh Dickins <hughd@google.com>, Borislav Petkov <bp@alien8.de>, David Hildenbrand <david@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 08, 2024, Peter Xu wrote:
> On Thu, Aug 08, 2024 at 02:31:19PM -0700, Sean Christopherson wrote:
> > On Thu, Aug 08, 2024, Peter Xu wrote:
> > > Hi, Sean,
> > > 
> > > On Thu, Aug 08, 2024 at 08:33:59AM -0700, Sean Christopherson wrote:
> > > > On Wed, Aug 07, 2024, Peter Xu wrote:
> > > > > mprotect() does mmu notifiers in PMD levels.  It's there since 2014 of
> > > > > commit a5338093bfb4 ("mm: move mmu notifier call from change_protection to
> > > > > change_pmd_range").
> > > > > 
> > > > > At that time, the issue was that NUMA balancing can be applied on a huge
> > > > > range of VM memory, even if nothing was populated.  The notification can be
> > > > > avoided in this case if no valid pmd detected, which includes either THP or
> > > > > a PTE pgtable page.
> > > > > 
> > > > > Now to pave way for PUD handling, this isn't enough.  We need to generate
> > > > > mmu notifications even on PUD entries properly.  mprotect() is currently
> > > > > broken on PUD (e.g., one can easily trigger kernel error with dax 1G
> > > > > mappings already), this is the start to fix it.
> > > > > 
> > > > > To fix that, this patch proposes to push such notifications to the PUD
> > > > > layers.
> > > > > 
> > > > > There is risk on regressing the problem Rik wanted to resolve before, but I
> > > > > think it shouldn't really happen, and I still chose this solution because
> > > > > of a few reasons:
> > > > > 
> > > > >   1) Consider a large VM that should definitely contain more than GBs of
> > > > >   memory, it's highly likely that PUDs are also none.  In this case there
> > > > 
> > > > I don't follow this.  Did you mean to say it's highly likely that PUDs are *NOT*
> > > > none?
> > > 
> > > I did mean the original wordings.
> > > 
> > > Note that in the previous case Rik worked on, it's about a mostly empty VM
> > > got NUMA hint applied.  So I did mean "PUDs are also none" here, with the
> > > hope that when the numa hint applies on any part of the unpopulated guest
> > > memory, it'll find nothing in PUDs. Here it's mostly not about a huge PUD
> > > mapping as long as the guest memory is not backed by DAX (since only DAX
> > > supports 1G huge pud so far, while hugetlb has its own path here in
> > > mprotect, so it must be things like anon or shmem), but a PUD entry that
> > > contains pmd pgtables.  For that part, I was trying to justify "no pmd
> > > pgtable installed" with the fact that "a large VM that should definitely
> > > contain more than GBs of memory", it means the PUD range should hopefully
> > > never been accessed, so even the pmd pgtable entry should be missing.
> > 
> > Ah, now I get what you were saying.
> > 
> > Problem is, walking the rmaps for the shadow MMU doesn't benefit (much) from
> > empty PUDs, because KVM needs to blindly walk the rmaps for every gfn covered by
> > the PUD to see if there are any SPTEs in any shadow MMUs mapping that gfn.  And
> > that walk is done without ever yielding, which I suspect is the source of the
> > soft lockups of yore.
> > 
> > And there's no way around that conundrum (walking rmaps), at least not without a
> > major rewrite in KVM.  In a nested TDP scenario, KVM's stage-2 page tables (for
> > L2) key off of L2 gfns, not L1 gfns, and so the only way to find mappings is
> > through the rmaps.
> 
> I think the hope here is when the whole PUDs being hinted are empty without
> pgtable installed, there'll be no mmu notifier to be kicked off at all.
> 
> To be explicit, I meant after this patch applied, the pud loop for numa
> hints look like this:
> 
>         FOR_EACH_PUD() {
>                 ...
>                 if (pud_none(pud))
>                         continue;
> 
>                 if (!range.start) {
>                         mmu_notifier_range_init(&range,
>                                                 MMU_NOTIFY_PROTECTION_VMA, 0,
>                                                 vma->vm_mm, addr, end);
>                         mmu_notifier_invalidate_range_start(&range);
>                 }
>                 ...
>         }
> 
> So the hope is that pud_none() is always true for the hinted area (just
> like it used to be when pmd_none() can be hopefully true always), then we
> skip the mmu notifier as a whole (including KVM's)!

Gotcha, that makes sense.  Too many page tables flying around :-)

