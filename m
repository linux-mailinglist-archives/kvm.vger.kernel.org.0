Return-Path: <kvm+bounces-23653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D31694C63F
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 23:21:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDC54281A26
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 21:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E9F15B109;
	Thu,  8 Aug 2024 21:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eH3c45AG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6A1145B26
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 21:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723152089; cv=none; b=PbKyaJiOJ2qy78uZA27CcTW4s/Lv51xumBU7Bwori0lI/dDAWrJbeA8uR8jqYr5hS8KcMXrL39qsukVIvIpDXTys4x2SojZZDW2vpfYG5gttPA6hdneNf2bhjCA7Ja/Tg/vLnk9bYEDS9gG95EvHQGiutvX3SVlUTI2jCp2dAy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723152089; c=relaxed/simple;
	bh=5DrwhdHkCZyp2uLw4QCpKYKP9cFvcq9ve0oag0f2JoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WaiqeZ4+FCPadQIK+g5bzN5FDJG4f48OU7UMT2y7/h6x7pdZePWUpYSLKOvcW2royM565opH6uj6qmspFQ5LRcNg/HsIKCgp4QJEoxy4+rtR0XJ3lEv08HzOqGW4Hd3gv2NRUZpcPc8Ir+vXA6cxiQNdEF6C+2fBznUolXdbpLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eH3c45AG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723152086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=646kYxDCmIPDI121m97IwwsmhjY653tF83ZSDiyw6zM=;
	b=eH3c45AGdMlHVvGGkhpcdVTzzrjgW1pwJBdrhrjqJZSgr/r9lb3l9r4r4yvi97EXZCo1sG
	xNQ98uZv1gnqifnVcSDIeBbuceMkr/LDjk4lhR4qwarzAfaxJiVu7xWu1ha+8kPmqIGM5m
	YLV7oUdPR+5zNAyZTlKOniryQvwWlzk=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-LZFqXOU8OByLDgiKCLFvjg-1; Thu, 08 Aug 2024 17:21:25 -0400
X-MC-Unique: LZFqXOU8OByLDgiKCLFvjg-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6b79c5c972eso1640096d6.1
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 14:21:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723152085; x=1723756885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=646kYxDCmIPDI121m97IwwsmhjY653tF83ZSDiyw6zM=;
        b=K8qlR1oJWUHjb6DVVMrlMhqPmSvzxCMkgRMNU1v8of/l7nH/I2WgnpF8qQbpoNS4Aq
         9/EGQUkG852ttr2vbzLkEQktll4oyqgHS5iLwFDOI5aTSI1EmuwJS1WTe5OmF0B1tGIR
         iGx/QI6ET+7WCJeFOmUFLBwxr6Bm9k3/UdDPJh4dT2hp3Dqr4Atblqt+iEyhXj8LSOEs
         0Wi1YaNlq1mI3y+XwCsYglQvri7RX3XaZQr3ThztdHQ7SCW54NONPmZcDjLZ9ekfPhv/
         1aJ2AzIuLIkttv3s7mYNfCqdekR9nin9lygkuJiGFSWvmeF+DvJPaAFK1yuOqR7TFN/j
         4yDg==
X-Forwarded-Encrypted: i=1; AJvYcCXLJxU37wRmJoEcB8r6ALJaqolh/TN9DdEmvNx0IPPE0VMJSiWUFyuK/N8OQLeLAICAWATmEZAOgs6vHYl9izH8H4dZ
X-Gm-Message-State: AOJu0YxrGj6jkBDaU0kVyXyshBIUPXLVBstYkgTgIZ3hux5aRcA0evcC
	g+7hkIL97dQktEC8JQArCYksoS/0vC7h6FVoWrNTOgMJTTxVI71sVZ1wCxvETkKTj/3AbR/0jmg
	9K85eDB9zfXUIcl64aG9CkAcWrzacc8RG9NLTvG8OFkQkU7x5kdeTq4s8mw==
X-Received: by 2002:a05:6214:e48:b0:6b7:586c:2cf9 with SMTP id 6a1803df08f44-6bd6bda328fmr22227726d6.8.1723152084729;
        Thu, 08 Aug 2024 14:21:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfLm9br531QtX5McSAepTFClX/i/YyLNfV9BZkuLTVq/qPkXnmRVEyjeA/AUTE6Y8mdpCcjg==
X-Received: by 2002:a05:6214:e48:b0:6b7:586c:2cf9 with SMTP id 6a1803df08f44-6bd6bda328fmr22227426d6.8.1723152084258;
        Thu, 08 Aug 2024 14:21:24 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c797dbdsm70021666d6.52.2024.08.08.14.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 14:21:23 -0700 (PDT)
Date: Thu, 8 Aug 2024 17:21:20 -0400
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
Message-ID: <ZrU20AqADICwwmCy@x1n>
References: <20240807194812.819412-1-peterx@redhat.com>
 <20240807194812.819412-3-peterx@redhat.com>
 <ZrTlZ4vZ74sK8Ydd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZrTlZ4vZ74sK8Ydd@google.com>

Hi, Sean,

On Thu, Aug 08, 2024 at 08:33:59AM -0700, Sean Christopherson wrote:
> On Wed, Aug 07, 2024, Peter Xu wrote:
> > mprotect() does mmu notifiers in PMD levels.  It's there since 2014 of
> > commit a5338093bfb4 ("mm: move mmu notifier call from change_protection to
> > change_pmd_range").
> > 
> > At that time, the issue was that NUMA balancing can be applied on a huge
> > range of VM memory, even if nothing was populated.  The notification can be
> > avoided in this case if no valid pmd detected, which includes either THP or
> > a PTE pgtable page.
> > 
> > Now to pave way for PUD handling, this isn't enough.  We need to generate
> > mmu notifications even on PUD entries properly.  mprotect() is currently
> > broken on PUD (e.g., one can easily trigger kernel error with dax 1G
> > mappings already), this is the start to fix it.
> > 
> > To fix that, this patch proposes to push such notifications to the PUD
> > layers.
> > 
> > There is risk on regressing the problem Rik wanted to resolve before, but I
> > think it shouldn't really happen, and I still chose this solution because
> > of a few reasons:
> > 
> >   1) Consider a large VM that should definitely contain more than GBs of
> >   memory, it's highly likely that PUDs are also none.  In this case there
> 
> I don't follow this.  Did you mean to say it's highly likely that PUDs are *NOT*
> none?

I did mean the original wordings.

Note that in the previous case Rik worked on, it's about a mostly empty VM
got NUMA hint applied.  So I did mean "PUDs are also none" here, with the
hope that when the numa hint applies on any part of the unpopulated guest
memory, it'll find nothing in PUDs. Here it's mostly not about a huge PUD
mapping as long as the guest memory is not backed by DAX (since only DAX
supports 1G huge pud so far, while hugetlb has its own path here in
mprotect, so it must be things like anon or shmem), but a PUD entry that
contains pmd pgtables.  For that part, I was trying to justify "no pmd
pgtable installed" with the fact that "a large VM that should definitely
contain more than GBs of memory", it means the PUD range should hopefully
never been accessed, so even the pmd pgtable entry should be missing.

With that, we should hopefully keep avoiding mmu notifications after this
patch, just like it used to be when done in pmd layers.

> 
> >   will have no regression.
> > 
> >   2) KVM has evolved a lot over the years to get rid of rmap walks, which
> >   might be the major cause of the previous soft-lockup.  At least TDP MMU
> >   already got rid of rmap as long as not nested (which should be the major
> >   use case, IIUC), then the TDP MMU pgtable walker will simply see empty VM
> >   pgtable (e.g. EPT on x86), the invalidation of a full empty region in
> >   most cases could be pretty fast now, comparing to 2014.
> 
> The TDP MMU will indeed be a-ok.  It only zaps leaf SPTEs in response to
> mmu_notifier invalidations, and checks NEED_RESCHED after processing each SPTE,
> i.e. KVM won't zap an entire PUD and get stuck processing all its children.
> 
> I doubt the shadow MMU will fair much better than it did years ago though, AFAICT
> the relevant code hasn't changed.  E.g. when zapping a large range in response to
> an mmu_notifier invalidation, KVM never yields even if blocking is allowed.  That 
> said, it is stupidly easy to fix the soft lockup problem in the shadow MMU.  KVM
> already has an rmap walk path that plays nice with NEED_RESCHED *and* zaps rmaps,
> but because of how things grew organically over the years, KVM never adopted the
> cond_resched() logic for the mmu_notifier path.
> 
> As a bonus, now the .change_pte() is gone, the only other usage of x86's
> kvm_handle_gfn_range() is for the aging mmu_notifiers, and I want to move those
> to their own flow too[*], i.e. kvm_handle_gfn_range() in its current form can
> be removed entirely.
> 
> I'll post a separate series, I don't think it needs to block this work, and I'm
> fairly certain I can get this done for 6.12 (shouldn't be a large or scary series,
> though I may tack on my lockless aging idea as an RFC).

Great, and thanks for all these information! Glad to know.

I guess it makes me feel more confident that this patch shouldn't have any
major side effect at least on KVM side.

Thanks,

> 
> https://lore.kernel.org/all/Zo137P7BFSxAutL2@google.com
> 

-- 
Peter Xu


