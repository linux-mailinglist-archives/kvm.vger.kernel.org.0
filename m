Return-Path: <kvm+bounces-23657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0B194C674
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 23:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FC7DB24757
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 21:48:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1080115B109;
	Thu,  8 Aug 2024 21:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fMmTWglI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D588827
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 21:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723153674; cv=none; b=RzjgrSWpCidLjEStuiVdknUpoY41LFdh8JV3VV2ctEtltLOjUvvp1Pibe/eDHeYIJn/ioa3Ng5pGKrAAjvCUa8rWHXFmw+rIzjPsVoMr6QnPjR0Rts48A3POqlcMXnrSOLnKmqcYYSrbzS7ugr4ECBviP6fspacnU+wz97WZcg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723153674; c=relaxed/simple;
	bh=s4XkxCp6B8NmYy2SASddwVP3Gr+y7OJEdxvm73dk1+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rNxIp4vtAsgHGiQ7n8raOFt9JFtHPh7+HgrpZQJyEqwiKBPrgnUQkuuV9imQWY+aF3ybf6LM3ATD1DwyHFYfDFksqHVUEZi+HK3JbI+0c0RdNxyoZAuz8HDTFn7OzXj4bKjHFHbuwQrv6xeNtfmNfjrpKgkiCB4+5nvM0MfDdDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fMmTWglI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723153671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y4cQ3dGvl+e98q+IJj301khv7EGPDrAUXWE89nsHh7w=;
	b=fMmTWglIu/fehKMmR18U820CqEY0EUkJ2/NAt0Rq3I1UUyCQX3DjC6NXz4jqCKjGxfn/BE
	BfkVzFAr51ei61I/Nsc7pd9FtUy5Kyop1D2vWkqYhSMXBU7xXNTgNzO9MkNJTII7Mxp6Mt
	0PNYG1doRjTCQAfFf4BQuwp4nXmpwXA=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-EbsBYCgqMA--pA1Dzav7hQ-1; Thu, 08 Aug 2024 17:47:49 -0400
X-MC-Unique: EbsBYCgqMA--pA1Dzav7hQ-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-8407b0b7b3bso68440241.0
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 14:47:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723153669; x=1723758469;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y4cQ3dGvl+e98q+IJj301khv7EGPDrAUXWE89nsHh7w=;
        b=FajQ7qFjQibcM0PM0y8w9c//DPPBLOPZDtloysW8LSAXyhdJkpbfNsdw6d6KBIIpR2
         JZ7g+ibPV2147hkBVLTA3tk89NtCYVVyf3/aQA2ziMlD58zDz8zDJ3fHeix2Cb/WSYMF
         fY1NPtqDjJbtfwfVS1WColOH0jwgZaeBRD56Hyyt/iGsnT7Dd+HIIxIw7KWcAAB25UKk
         D41PL0gPKvrXj8s055WlP4SVgdh7t8jNX4tVUOzb5awlQNRkb68yHB5u4zDtq4YTOw85
         FF1vg6u+o5VPwQSZmW1xP2l6GNLLxmSgvcC/G+WFaHwNYaNq+I68oCU2pHxTb2Vy6yqE
         VsMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWf0ThDe1kiodtlOgmNMb8h73EMFRodQIqv+gVET666l0XGip537+lBpHD4AFw3nofVlnvY4+BjJaTUzfmhPfKBYt/3
X-Gm-Message-State: AOJu0YzihdgSgbFfH5cw+SnDzo+faG5RZSLelGkZ52t6ojUGP+XTrhLs
	rTJqo8Fd1bTUYlSTLmylP62EigDyuhVLDEIt3B7IvLN5OECe04VQR7qok4OLmSw86xQGttuKd2c
	lJ6ArGU7fHA2YxWyP2B3oekujbwHkVuWU9npxKj7M6Xl8k5kMRkdlTKq8dg==
X-Received: by 2002:a05:6122:1696:b0:4f4:959b:8342 with SMTP id 71dfb90a1353d-4f9028ededfmr2281577e0c.2.1723153669036;
        Thu, 08 Aug 2024 14:47:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBUCPV/3BJaIuZdMerz+8wpoNJAPGodVbwYONTfq25mwe5QVB/HX82z8YwrBUiUNO7Dj9CXg==
X-Received: by 2002:a05:6122:1696:b0:4f4:959b:8342 with SMTP id 71dfb90a1353d-4f9028ededfmr2281559e0c.2.1723153668575;
        Thu, 08 Aug 2024 14:47:48 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a3785e13fdsm198784985a.34.2024.08.08.14.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 14:47:48 -0700 (PDT)
Date: Thu, 8 Aug 2024 17:47:44 -0400
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Oscar Salvador <osalvador@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	James Houghton <jthoughton@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Rik van Riel <riel@surriel.com>, Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Rick P Edgecombe <rick.p.edgecombe@intel.com>,
	"Kirill A . Shutemov" <kirill@shutemov.name>,
	linuxppc-dev@lists.ozlabs.org,
	Mel Gorman <mgorman@techsingularity.net>,
	Hugh Dickins <hughd@google.com>, Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v4 2/7] mm/mprotect: Push mmu notifier to PUDs
Message-ID: <ZrU9AJi7-pHT_UWS@x1n>
References: <20240807194812.819412-1-peterx@redhat.com>
 <20240807194812.819412-3-peterx@redhat.com>
 <ZrTlZ4vZ74sK8Ydd@google.com>
 <ZrU20AqADICwwmCy@x1n>
 <ZrU5JyjIa1CwZ_KD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZrU5JyjIa1CwZ_KD@google.com>

On Thu, Aug 08, 2024 at 02:31:19PM -0700, Sean Christopherson wrote:
> On Thu, Aug 08, 2024, Peter Xu wrote:
> > Hi, Sean,
> > 
> > On Thu, Aug 08, 2024 at 08:33:59AM -0700, Sean Christopherson wrote:
> > > On Wed, Aug 07, 2024, Peter Xu wrote:
> > > > mprotect() does mmu notifiers in PMD levels.  It's there since 2014 of
> > > > commit a5338093bfb4 ("mm: move mmu notifier call from change_protection to
> > > > change_pmd_range").
> > > > 
> > > > At that time, the issue was that NUMA balancing can be applied on a huge
> > > > range of VM memory, even if nothing was populated.  The notification can be
> > > > avoided in this case if no valid pmd detected, which includes either THP or
> > > > a PTE pgtable page.
> > > > 
> > > > Now to pave way for PUD handling, this isn't enough.  We need to generate
> > > > mmu notifications even on PUD entries properly.  mprotect() is currently
> > > > broken on PUD (e.g., one can easily trigger kernel error with dax 1G
> > > > mappings already), this is the start to fix it.
> > > > 
> > > > To fix that, this patch proposes to push such notifications to the PUD
> > > > layers.
> > > > 
> > > > There is risk on regressing the problem Rik wanted to resolve before, but I
> > > > think it shouldn't really happen, and I still chose this solution because
> > > > of a few reasons:
> > > > 
> > > >   1) Consider a large VM that should definitely contain more than GBs of
> > > >   memory, it's highly likely that PUDs are also none.  In this case there
> > > 
> > > I don't follow this.  Did you mean to say it's highly likely that PUDs are *NOT*
> > > none?
> > 
> > I did mean the original wordings.
> > 
> > Note that in the previous case Rik worked on, it's about a mostly empty VM
> > got NUMA hint applied.  So I did mean "PUDs are also none" here, with the
> > hope that when the numa hint applies on any part of the unpopulated guest
> > memory, it'll find nothing in PUDs. Here it's mostly not about a huge PUD
> > mapping as long as the guest memory is not backed by DAX (since only DAX
> > supports 1G huge pud so far, while hugetlb has its own path here in
> > mprotect, so it must be things like anon or shmem), but a PUD entry that
> > contains pmd pgtables.  For that part, I was trying to justify "no pmd
> > pgtable installed" with the fact that "a large VM that should definitely
> > contain more than GBs of memory", it means the PUD range should hopefully
> > never been accessed, so even the pmd pgtable entry should be missing.
> 
> Ah, now I get what you were saying.
> 
> Problem is, walking the rmaps for the shadow MMU doesn't benefit (much) from
> empty PUDs, because KVM needs to blindly walk the rmaps for every gfn covered by
> the PUD to see if there are any SPTEs in any shadow MMUs mapping that gfn.  And
> that walk is done without ever yielding, which I suspect is the source of the
> soft lockups of yore.
> 
> And there's no way around that conundrum (walking rmaps), at least not without a
> major rewrite in KVM.  In a nested TDP scenario, KVM's stage-2 page tables (for
> L2) key off of L2 gfns, not L1 gfns, and so the only way to find mappings is
> through the rmaps.

I think the hope here is when the whole PUDs being hinted are empty without
pgtable installed, there'll be no mmu notifier to be kicked off at all.

To be explicit, I meant after this patch applied, the pud loop for numa
hints look like this:

        FOR_EACH_PUD() {
                ...
                if (pud_none(pud))
                        continue;

                if (!range.start) {
                        mmu_notifier_range_init(&range,
                                                MMU_NOTIFY_PROTECTION_VMA, 0,
                                                vma->vm_mm, addr, end);
                        mmu_notifier_invalidate_range_start(&range);
                }
                ...
        }

So the hope is that pud_none() is always true for the hinted area (just
like it used to be when pmd_none() can be hopefully true always), then we
skip the mmu notifier as a whole (including KVM's)!

Thanks,

-- 
Peter Xu


