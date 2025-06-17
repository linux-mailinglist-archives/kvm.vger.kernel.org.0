Return-Path: <kvm+bounces-49778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94CEEADDFC3
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 01:36:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ABCB3B91FA
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 23:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7349C28EA52;
	Tue, 17 Jun 2025 23:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jbhz1kEp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66442F5329
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 23:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750203376; cv=none; b=kGtlxpj+tbMH0j1M8MVZQpUj19QlEHSONSGH4L9Bf7SsQWqRlLEsPikbMr3NLd4pfcgDodrEBS114GOh0wEg2RRfo+z6TQO3pH63YjKRmlScW3bhZk6Ke9aNrQBA4sIdho5CsKS3eOs/uTRFszsOEeaaEJChzCN8Uj+x9U9dwlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750203376; c=relaxed/simple;
	bh=VBIwT6QOQ4kvU/RSQ+F1tpm5P4QrQgCWJTwuuggqa8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jclFqj8eiwy3kpA3NoalhJuqa15JWasYIxxJjWh44gc4lP/6Q75SMh9MniAfLAKSSWVj8dOKe1WdBsVB9pOjCmKpAx2igIHJvrVACD1notY5+4CMm2gT80ZHhebD1BwAD9/to7DFKSgmfNZxDX20prqiWtcao1Cn/FShX3NAycw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jbhz1kEp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750203373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KBSv6o9j7WYY/vKWRFs7+EFKW/WKi+ZVGi0l2xZHTJg=;
	b=Jbhz1kEpmLEXC7vNXYLIlNrZRrn4g/yij80aHWywnWxBS2WoGsY7yhg4HGtqJuwNbGTlFx
	eAr/G+AxVhL2z5j5YI9sJVref7QinFE/tMFp7L+F5nAmQwZnQn4/BzXJpsUQSs4VqALOWn
	XfVpBqeCjydKML32V3GwGdfFTiAe9Uo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-S0aXADdKNaehcd2IlJr4OQ-1; Tue, 17 Jun 2025 19:36:12 -0400
X-MC-Unique: S0aXADdKNaehcd2IlJr4OQ-1
X-Mimecast-MFC-AGG-ID: S0aXADdKNaehcd2IlJr4OQ_1750203371
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6faca0f2677so160411966d6.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:36:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750203371; x=1750808171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KBSv6o9j7WYY/vKWRFs7+EFKW/WKi+ZVGi0l2xZHTJg=;
        b=xKb4ZZB7ov7oDiOHSdVZCSoJ6xJ7Xdz8xbiN+VlEDJ7VRkCbH+Ao21OJl5oOpfIsm8
         Qe5EkTAnKve4+FKZVNIH1rMFsZW+C5JIqZaJvtTzZRzYv57Lp41+U8t6SCocsDAvE/Uw
         Yo0YcxbAE+lamBJItTvZSST4LGZTCFdcKD9Ce/4xmo0+4a9WByNy6aqOrzGMchWMblee
         DtECpi01W1ThdAVGFZnegAx/ieVmaVMKnKkcMNlKqG4fwVxdvRn5+9h+IyUQFjOZM9dr
         WLZKecvLddOSOTgxGHQNJtFHXfZGEfsajLYBGcApvxt0cZitj57XtxZ0ZzrF+at2rp8M
         QgFw==
X-Forwarded-Encrypted: i=1; AJvYcCWE1RPJ0/UYG/tzd4KhYC4QcXofO7+6vxI+TnKf63Dh93+QRpMTfWkIQnCCF22U+/cNIyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhYjnjCOqTz8Q2CYPrhZkm3xzr5Tbyu1lGbafloAH/lvjSdxhi
	V41sSjsGGRCIAXnzpY+sv9uyfRqaO4tPEBeUTBBopxmCfx5DfcZG6UJU54+JFGaTQOv3/nAeeLC
	6qjXV0EFX4q2P8L+QFPxTi2DzEkJfae86uMq5GABG39w2/j7Va8jMNQ==
X-Gm-Gg: ASbGnctL14Uu77nyh4M/Y9tBImxGi1JNUK/Z8AQqLBNnMjlwOCal4NhMtoDAOvH2sy/
	vXEcH6VPFU87Zv831urIdws7SJJPs8LuWBX1oL728TUj9ITFnjElDJn+TDKw7swKDlKRukyXOnc
	+1tA2BKVNGGWqztZwPL3Xdz/1VvR5lqCF1KUvBdl5en/OpSCoAj/lDmUckRTgzjGiuNi3JYO+e3
	IhLXmCyqZbJDybttNjYNiUULmM7K/MwyyU4hIYeELMPojq9SztVmhUaVF8NOe9sGVOGQASX/edy
	7iczpmzcopk9Ww==
X-Received: by 2002:a05:6214:5018:b0:6fa:fb25:e0f1 with SMTP id 6a1803df08f44-6fb477d99b7mr200740226d6.24.1750203371424;
        Tue, 17 Jun 2025 16:36:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKrTSuB1EI9cqt5G4JNRshFwKRQv2YtvABo07xYPeeJ2qDKgN205wNAbsTpAWIrLURyfvhgg==
X-Received: by 2002:a05:6214:5018:b0:6fa:fb25:e0f1 with SMTP id 6a1803df08f44-6fb477d99b7mr200739946d6.24.1750203371054;
        Tue, 17 Jun 2025 16:36:11 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb4e432100sm37584916d6.116.2025.06.17.16.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 16:36:10 -0700 (PDT)
Date: Tue, 17 Jun 2025 19:36:08 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <aFH76GjnWfeHI5fA@x1.local>
References: <20250613134111.469884-6-peterx@redhat.com>
 <20250613142903.GL1174925@nvidia.com>
 <aExDMO5fZ_VkSPqP@x1.local>
 <20250613160956.GN1174925@nvidia.com>
 <aEx4x_tvXzgrIanl@x1.local>
 <20250613231657.GO1174925@nvidia.com>
 <aFCVX6ubmyCxyrNF@x1.local>
 <20250616230011.GS1174925@nvidia.com>
 <aFHWbX_LTjcRveVm@x1.local>
 <20250617231807.GD1575786@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250617231807.GD1575786@nvidia.com>

On Tue, Jun 17, 2025 at 08:18:07PM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 17, 2025 at 04:56:13PM -0400, Peter Xu wrote:
> > On Mon, Jun 16, 2025 at 08:00:11PM -0300, Jason Gunthorpe wrote:
> > > On Mon, Jun 16, 2025 at 06:06:23PM -0400, Peter Xu wrote:
> > > 
> > > > Can I understand it as a suggestion to pass in a bitmask into the core mm
> > > > API (e.g. keep the name of mm_get_unmapped_area_aligned()), instead of a
> > > > constant "align", so that core mm would try to allocate from the largest
> > > > size to smaller until it finds some working VA to use?
> > > 
> > > I don't think you need a bitmask.
> > > 
> > > Split the concerns, the caller knows what is inside it's FD. It only
> > > needs to provide the highest pgoff aligned folio/pfn within the FD.
> > 
> > Ultimately I even dropped this hint.  I found that it's not really
> > get_unmapped_area()'s job to detect over-sized pgoffs.  It's mmap()'s job.
> > So I decided to avoid this parameter as of now.
> 
> Well, the point of the pgoff is only what you said earlier, to adjust
> the starting alignment so the pgoff aligned high order folios/pfns
> line up properly.

I meant "highest pgoff" that I dropped.

We definitely need the pgoff to make it work.  So here I dropped "highest
pgoff" passed from the caller because I decided to leave such check to the
mmap() hook later.

> 
> > > The mm knows what leaf page tables options exist. It should try to
> > > align to the closest leaf page table size that is <= the FD's max
> > > aligned folio.
> > 
> > So again IMHO this is also not per-FD information, but needs to be passed
> > over from the driver for each call.
> 
> It is per-FD in the sense that each FD is unique and each range of
> pgoff could have a unique maximum.
>  
> > Likely the "order" parameter appeared in other discussions to imply a
> > maximum supported size from the driver side (or, for a folio, but that is
> > definitely another user after this series can land).
> 
> Yes, it is the only information the driver can actually provide and
> comes directly from what it will install in the VMA.
> 
> > So far I didn't yet add the "order", because currently VFIO definitely
> > supports all max orders the system supports.  Maybe we can add the order
> > when there's a real need, but maybe it won't happen in the near
> > future?
> 
> The purpose of the order is to prevent over alignment and waste of
> VMA. Your technique to use the length to limit alignment instead is
> good enough for VFIO but not very general.

Yes that's also something I didn't like.  I think I'll just go ahead and
add the order parameter, then use it in previous patch too.

I'll wait for some more time though for others' input before a respin.

Thanks,

> 
> The VFIO part looks pretty good, I still don't really understand why
> you'd have CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP though. The inline
> fallback you have for it seems good enough and we don't care if things
> are overaligned for ioremap.
> 
> Jason
> 

-- 
Peter Xu


