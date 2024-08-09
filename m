Return-Path: <kvm+bounces-23734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FCA294D517
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:54:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF6361F25081
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A418538F83;
	Fri,  9 Aug 2024 16:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="esjlC2F0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A8C1CF96
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723222450; cv=none; b=mLInHY7h7vPw0IyPtHqb8sPigXres1+eGRlMdoz03k5073Vc8pYiULLnfn21lmOSnpjDww9FPyCgQDWVCbP7fOfYlul7Urx9WOIAsuCuKJfXv4Lb2hju5ULR0JD0poztiIQj5y1wobh7NJ32etJA0szEt/pCNbZ+pV+z1lveIjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723222450; c=relaxed/simple;
	bh=DUGaX4dOaBc1SKm+QpUZxIx4yUNvGBVKHqKpcVtH7b0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FN+HryWNCu241h0IVnY3P2P6hFdvLUW2nkcWs9teWc6Rg5G6NaCdQmK7HJ5+C/XYZOLafznYsSbQWjPjDBhbJu3V0Db1fowFRpQB8wR7rmddmHc2jgmmCO8v+MhMHjF49Dcv+Yc1PvZR3XIx1qB0go9yayzCJiHkQt0t2qTtWY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=esjlC2F0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723222447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=86nPCx79W6PGHL+fSL/w3sszGXq3z8SJRXsfiXl5Py8=;
	b=esjlC2F0ixlRaFTxM3+Ftx1g6MPUSEw0Pl869eJr7nQBQC9ZQ+ztvhIQe8ZGezazLk1m1h
	Z9Umcge1E44XIIFOFC6pZvy+5DZtRF/pY9/IhEdVHZFGwnQ1DS3OcC6/l9o4AS5+AUUDX/
	6wiO5M6wutZaTGBL9xDIVQqLIF01lCU=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-8O09PKj7OVaGYgCRhMu6jw-1; Fri, 09 Aug 2024 12:54:06 -0400
X-MC-Unique: 8O09PKj7OVaGYgCRhMu6jw-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-70954de6142so565374a34.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:54:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723222446; x=1723827246;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=86nPCx79W6PGHL+fSL/w3sszGXq3z8SJRXsfiXl5Py8=;
        b=X/G3qn3MCgjzG3b21SxKoAyngXtV1qU1Z4LTG7a+WVpxhMaXD+Eqg8Yl1SruSz3J1k
         C4WvLfE8FlXGJAgZDKpIPHbOUT1zAWKBe2tNi1XjivMiscdJTVOZv7GUT7rqx6eclUNB
         bBI7LD9SXZiAf9yDcc0Nk+40TWGORusYS0EjfFe9K9hDMyvoyfIoEhk6VY7/YiqZ1dV3
         NdCKnD08WDkFJQygDx3bgdRqvZx2nwbM0mlnThEMHpwZbQE5fntqJWWat71fMUiVTwZt
         1zzvBn/xsKyN2x5s0ByRiRQBvExp3C5brHPRDq8Iuxh+f0aMG64UOD6+o8CiwRuPDC96
         7Ntw==
X-Forwarded-Encrypted: i=1; AJvYcCWqaBt02aFdAgJcDQp/dDHtIMBIIFhoa49p7+y0XB/yR6i9Gv2582PJKV/8QPT3D+AKZhs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAtfXFMhv4boMZgguT7eTHwyCZ4G2Xa1SKRKLw5O8vaP7ocNVK
	Q4doV5EOwR+CMCrhJgNa78rV0J0iHZTD3IcFgdk7ujiclgfyWo5mbVWLf6PfmAlkFpRAEixI9WE
	FHTUoyzugBoL3oAU5Ks8GJblbnP3+BmHR/+JSdYqUB7TJ8GM/bw==
X-Received: by 2002:a05:6830:2b25:b0:703:5c54:ddac with SMTP id 46e09a7af769-70b7470a670mr1628373a34.2.1723222445790;
        Fri, 09 Aug 2024 09:54:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpuMCJfrpcp3WHIjMj9LLfZZ/K5MFK4Lv5p2xqcXiI3Eo7cosoDQu8/NAx31jVVYmRJIlX7w==
X-Received: by 2002:a05:6830:2b25:b0:703:5c54:ddac with SMTP id 46e09a7af769-70b7470a670mr1628345a34.2.1723222445418;
        Fri, 09 Aug 2024 09:54:05 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a3786cce67sm279215085a.116.2024.08.09.09.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:54:04 -0700 (PDT)
Date: Fri, 9 Aug 2024 12:54:01 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 06/19] mm/pagewalk: Check pfnmap early for
 folio_walk_start()
Message-ID: <ZrZJqd8FBLU_GqFH@x1n>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-7-peterx@redhat.com>
 <b103edb7-c41b-4a5b-9d9f-9690c5b25eb7@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b103edb7-c41b-4a5b-9d9f-9690c5b25eb7@redhat.com>

On Fri, Aug 09, 2024 at 06:20:06PM +0200, David Hildenbrand wrote:
> On 09.08.24 18:08, Peter Xu wrote:
> > Pfnmaps can always be identified with special bits in the ptes/pmds/puds.
> > However that's unnecessary if the vma is stable, and when it's mapped under
> > VM_PFNMAP | VM_IO.
> > 
> > Instead of adding similar checks in all the levels for huge pfnmaps, let
> > folio_walk_start() fail even earlier for these mappings.  It's also
> > something gup-slow already does, so make them match.
> > 
> > Cc: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >   mm/pagewalk.c | 5 +++++
> >   1 file changed, 5 insertions(+)
> > 
> > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > index cd79fb3b89e5..fd3965efe773 100644
> > --- a/mm/pagewalk.c
> > +++ b/mm/pagewalk.c
> > @@ -727,6 +727,11 @@ struct folio *folio_walk_start(struct folio_walk *fw,
> >   	p4d_t *p4dp;
> >   	mmap_assert_locked(vma->vm_mm);
> > +
> > +	/* It has no folio backing the mappings at all.. */
> > +	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
> > +		return NULL;
> > +
> 
> That is in general not what we want, and we still have some places that
> wrongly hard-code that behavior.
> 
> In a MAP_PRIVATE mapping you might have anon pages that we can happily walk.
> 
> vm_normal_page() / vm_normal_page_pmd() [and as commented as a TODO,
> vm_normal_page_pud()] should be able to identify PFN maps and reject them,
> no?

Yep, I think we can also rely on special bit.

When I was working on this whole series I must confess I am already
confused on the real users of MAP_PRIVATE pfnmaps.  E.g. we probably don't
need either PFNMAP for either mprotect/fork/... at least for our use case,
then VM_PRIVATE is even one step further.

Here I chose to follow gup-slow, and I suppose you meant that's also wrong?
If so, would it make sense we keep them aligned as of now, and change them
altogether?  Or do you think we should just rely on the special bits?

And, just curious: is there any use case you're aware of that can benefit
from caring PRIVATE pfnmaps yet so far, especially in this path?

As far as I read, none of folio_walk_start() users so far should even
stumble on top of a pfnmap, share or private.  But that's a fairly quick
glimps only.  IOW, I was wondering whether I'm just over cautious here.

Thanks,

-- 
Peter Xu


