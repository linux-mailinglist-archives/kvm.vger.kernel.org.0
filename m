Return-Path: <kvm+bounces-46817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F5DBAB9E73
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 16:17:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27E99A04392
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 14:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D84F71632DF;
	Fri, 16 May 2025 14:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ijvEgMTF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC04C135A53
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747405061; cv=none; b=M7IlK5s5QgZmqA5yWRBGaxMWSepZQ5KzIDgINtx2qIpZPNarjIrK0QWOc7m9pj3h+/w5kVJSNFWQxgBW0yB/1UR8VGFfw6tJvXNRt56KMv3TsSL+v7R1xT6w4AqJLGXdHYMaiQyEgsCacPQ/cALObc8mEzYWfd4Gfg22Fs54jKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747405061; c=relaxed/simple;
	bh=1gncUBYCwuSfN3USu7RdB/12vyV0h7/KF4QgTJljmys=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=inNOcSpX8Es7HHK64DR+q4kGY9MYNelicg+Y30x0Sv16cVt+P52e9GUTGXcqJS7zrx6LUQq2ws0Jo6w8fJSWjj61EAzPInh3rADHUvC2R4kharZtfBVpNXJfWeHTzCiDiM6l7hAHqmUBJ0pL6/5V2ieJM3tBSU8L8bwQ1EV+Uyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ijvEgMTF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747405058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0h80qSfoD4MQf1+963ZWlawunbXgZmEBew3ZxMnjVA=;
	b=ijvEgMTFGa0pNtCHsnYBkW3LuQ1tweQ7LUj+YUYF2ZkM3m/yKuUdrrFMMycVIYhpGEQDhv
	0GY36+UoAWgeKcotEPZ/DRXjg35BpX5zUxSaIieQIXipeKqLsPcFyNmkohINnamAtoAVfS
	uqgdQHANCkOulrHzLoZ9PLynM9GlCwA=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-f1MlUys2OL2V0cKK4qQsQA-1; Fri, 16 May 2025 10:17:36 -0400
X-MC-Unique: f1MlUys2OL2V0cKK4qQsQA-1
X-Mimecast-MFC-AGG-ID: f1MlUys2OL2V0cKK4qQsQA_1747405056
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3dc30ae41b9so33125ab.3
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 07:17:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747405056; x=1748009856;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a0h80qSfoD4MQf1+963ZWlawunbXgZmEBew3ZxMnjVA=;
        b=s7z3Z/wN6vsZxqh/Ab7IMJ1eEndrtlVG0/kxJNRfK5stqQwp47H3g1+pE/1fFziIIm
         Pg80r7IrS/OrxiHaRYhi5UeEn8zgjO14EyxfJVre8o953WrLOtQwHN3oHFlDazWB0M4H
         r648JL0pisXc6Q+OctFL9I1yZqxblWxWUDD0xbZg+X2sWWirhIr1eiDc8afzmcGKLLUz
         aW/sBPaEtpn17D1Zb4obzx+WfwMrd9jmmn3AtjdaYWG+AirlPwh1lpTH4Glls7XrRS8h
         qI5qaoZzuf5Zn0Po76WX/LIFnJBJkrvHthcw0090RLr03SACjZs0/GALG8pV300YP5wl
         gIiA==
X-Gm-Message-State: AOJu0YyHacK0mqZKS40EH//4k9qP9fhdppIrQGRjxxEwmGdlTGyRIHvu
	5T8Zf+73rJXw+RDoHelV6EWuvnfkAW7SZ7xKV9zfmEh9RNWq1B3UU4gTHfxBJAnVTjJpSgM2e0n
	w8Oy9nyOSIiBpQhU8SN3C8W4arHZEeG2Ll/+Lp2vhbD3q02bp6OtjuA==
X-Gm-Gg: ASbGncun+nNdtZ0w+y8/cu8q0solTXL87OhiefvRQen8Y2DJDLHH2UpryW69EdlXSL7
	yWplBHjJxxrfPelbKIBShNvGkhg9dicMXALWvLxbswgLQ7moCBc5C4E88ZycHStErE03/3/5/PN
	xGAh+0VKTqEpea6c157pjZav682KEB2K++INGfyNPDNQLQtw9GqJuW0qjgkfeqT0nGpa3iPw1Zj
	8qfsq37FMmLaQDDVBRZMoltUwJp5PbTzqY3XfOhjzLjIiOh6GP2zsMjFAR+7bBkIgS+mwl6KlQ+
	rnz7+PSk8yocdKM=
X-Received: by 2002:a05:6e02:b2e:b0:3db:71e8:8630 with SMTP id e9e14a558f8ab-3db84368a14mr11357645ab.3.1747405055833;
        Fri, 16 May 2025 07:17:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPUdCId9H1s1LEogJrTgKv7lSwlk/EbBV62XdXrbd5Hld7O9fdGoDcSINOobzifFeGxoYeZg==
X-Received: by 2002:a05:6e02:b2e:b0:3db:71e8:8630 with SMTP id e9e14a558f8ab-3db84368a14mr11357505ab.3.1747405055423;
        Fri, 16 May 2025 07:17:35 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4b2f45sm409339173.126.2025.05.16.07.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 07:17:34 -0700 (PDT)
Date: Fri, 16 May 2025 08:17:32 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev, peterx@redhat.com
Subject: Re: [PATCH] vfio/type1: optimize vfio_pin_pages_remote() for
 hugetlbfs folio
Message-ID: <20250516081732.06ef2230.alex.williamson@redhat.com>
In-Reply-To: <20250516081616.73039-1-lizhe.67@bytedance.com>
References: <20250515151946.1e6edf8b.alex.williamson@redhat.com>
	<20250516081616.73039-1-lizhe.67@bytedance.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 May 2025 16:16:16 +0800
lizhe.67@bytedance.com wrote:

> On Thu, 15 May 2025 15:19:46 -0600, alex.williamson@redhat.com wrote:
> 
> >> +/*
> >> + * Find a random vfio_pfn that belongs to the range
> >> + * [iova, iova + PAGE_SIZE * npage)
> >> + */
> >> +static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> >> +		dma_addr_t iova, unsigned long npage)
> >> +{
> >> +	struct vfio_pfn *vpfn;
> >> +	struct rb_node *node = dma->pfn_list.rb_node;
> >> +	dma_addr_t end_iova = iova + PAGE_SIZE * npage;
> >> +
> >> +	while (node) {
> >> +		vpfn = rb_entry(node, struct vfio_pfn, node);
> >> +
> >> +		if (end_iova <= vpfn->iova)
> >> +			node = node->rb_left;
> >> +		else if (iova > vpfn->iova)
> >> +			node = node->rb_right;
> >> +		else
> >> +			return vpfn;
> >> +	}
> >> +	return NULL;
> >> +}  
> >
> >This essentially duplicates vfio_find_vpfn(), where the existing
> >function only finds a single page.  The existing function should be
> >extended for this new use case and callers updated.  Also the vfio_pfn  
> 
> How about implementing it in this way?
> 
> static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> {
> 	return vfio_find_vpfn_range(dma, iova, 1);
> }
> 
> With this implement, the caller who calls vfio_find_vpfn() won't need to
> be modified.

Yes, that would minimize churn elsewhere.

> >is not "random", it's the first vfio_pfn overlapping the range.  
> 
> Yes you are right. I will modify the comments to "Find the first vfio_pfn
> overlapping the range [iova, iova + PAGE_SIZE * npage) in rb tree" in v2.
> 
> >> +
> >>  static void vfio_link_pfn(struct vfio_dma *dma,
> >>  			  struct vfio_pfn *new)
> >>  {
> >> @@ -670,6 +694,31 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> >>  				iova += (PAGE_SIZE * ret);
> >>  				continue;
> >>  			}
> >> +  
> >
> >Spurious new blank line.
> >  
> >> +		}  
> >
> >A new blank line here would be appreciated.  
> 
> Thank you. I will address this in v2.
> 
> >> +		/* Handle hugetlbfs page */
> >> +		if (likely(!disable_hugepages) &&  
> >
> >Isn't this already accounted for with npage = 1?  
> 
> Yes. This check is not necessary. I will remove it in v2.
> 
> >> +				folio_test_hugetlb(page_folio(batch->pages[batch->offset]))) {  
> >
> >I don't follow how this guarantees the entire batch->size is
> >contiguous.  Isn't it possible that a batch could contain multiple
> >hugetlb folios?  Is the assumption here only true if folio_nr_pages()
> >(or specifically the pages remaining) is >= batch->capacity?  What  
> 
> Yes.
> 
> >happens if we try to map the last half of one 2MB hugetlb page and
> >first half of the non-physically-contiguous next page?  Or what if the
> >hugetlb size is 64KB and the batch contains multiple folios that are
> >not physically contiguous?  
> 
> Sorry for my problematic implementation. I will fix it in v2.
> 
> >> +			if (pfn != *pfn_base + pinned)
> >> +				goto out;
> >> +
> >> +			if (!rsvd && !vfio_find_vpfn_range(dma, iova, batch->size)) {
> >> +				if (!dma->lock_cap &&
> >> +				    mm->locked_vm + lock_acct + batch->size > limit) {
> >> +					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> >> +						__func__, limit << PAGE_SHIFT);
> >> +					ret = -ENOMEM;
> >> +					goto unpin_out;
> >> +				}
> >> +				pinned += batch->size;
> >> +				npage -= batch->size;
> >> +				vaddr += PAGE_SIZE * batch->size;
> >> +				iova += PAGE_SIZE * batch->size;
> >> +				lock_acct += batch->size;
> >> +				batch->offset += batch->size;
> >> +				batch->size = 0;
> >> +				continue;
> >> +			}  
> >
> >There's a lot of duplication with the existing page-iterative loop.  I
> >think they could be consolidated if we extract the number of known
> >contiguous pages based on the folio into a variable, default 1.  
> 
> Good idea! I will try to implement this optimization based on this idea
> in v2.
> 
> >Also, while this approach is an improvement, it leaves a lot on the
> >table in scenarios where folio_nr_pages() exceeds batch->capacity.  For
> >example we're at best incrementing 1GB hugetlb pages in 2MB increments.
> >We're also wasting a lot of cycles to fill pages points we mostly don't
> >use.  Thanks,  
> 
> Yes, this is the ideal case. However, we are uncertain whether the pages
> to be pinned are hugetlbfs folio, and increasing batch->capacity would
> lead to a significant increase in memory usage. Additionally, since
> pin_user_pages_remote() currently lacks a variant that can reduce the
> overhead of "filling pages points" of hugetlbfs folio (maybe not correct).
> I suggest we proceeding with additional optimizations after further
> infrastructure improvements.

That's fair, it's a nice improvement within the existing interfaces
even if we choose to pursue something more aggressive in the future.
Please consider documenting improvements relative to 1GB hugetlb in the
next version also.  Thanks,

Alex


