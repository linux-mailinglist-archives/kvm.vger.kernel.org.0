Return-Path: <kvm+bounces-49476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D794AD94BA
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:46:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE6E51E5014
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22CD233737;
	Fri, 13 Jun 2025 18:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CVKxuDdT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7CF20DD40
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 18:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749840342; cv=none; b=kZaOHNV2q/QvLsRMpu0Ftq2eKWk07U4nAKyj2HlwrREbORmpWdsVzkL1nTbMy665us19e9cvFye20MBxgw71onedoRXe2N0nuys6aUZrjo1p51Qxb39JMGT5BPacJQ8K8cHeRmP0duqQHnAZrZzkGSi1wmm9wD0q/o00eGHTOEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749840342; c=relaxed/simple;
	bh=tkxEEQqCnXWYqSLdU2GqmuB8hosbzsWWGVdjof65Hic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rTqYzAC70zMQ8K00Asl/87qu7ySeTivuNsiINcy9OjUSttY1dQgQHOHnORBgHL8ZjNploaOcsevMh/0PCHNMpY79O8N2Fqdj7EiGY8RKS/9FdMhA5V48bRS+ZYLlJe4oWbEDf0B5ltqSPULYAOq65xvn2iE56Fbz3xNuDaTC2kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CVKxuDdT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749840339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dleQCoAtSSBdBCiR900BFEh9O2XlUfclwDFjT5jtdZ0=;
	b=CVKxuDdTbUqC9dgUDuYLxf94b+pG7W360X9TtB7d5luvTAGWDK84KWJH94jR2YbwcTwGV/
	QQ0plEYpjAATB+yMtsCKIP945aBb7UeEOFeNzjxefT7l1hMXLlTwuZCzbS3Et155C/Y676
	8rcvvuypuE7srtoacrjjGBQCqVR2BS4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-LMKSUhpkOXKrFUhb0JClxw-1; Fri, 13 Jun 2025 14:45:36 -0400
X-MC-Unique: LMKSUhpkOXKrFUhb0JClxw-1
X-Mimecast-MFC-AGG-ID: LMKSUhpkOXKrFUhb0JClxw_1749840336
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7d3901ff832so467348685a.3
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 11:45:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749840336; x=1750445136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dleQCoAtSSBdBCiR900BFEh9O2XlUfclwDFjT5jtdZ0=;
        b=jDfDgu6+jC+6rfVtK00sf5FZ+7tsRbjw0QX+mcmpdB+EBGNpJ223aBHF8C3LkvAIWA
         XHM6MSqLT95gzg4Tf1pZR8uas5LuXl1MRy63EM/dDYyugRgHkSwPuXOdnvrCuSTgc1jz
         qIE+frGXFyE4fP28jF9dTIxmoozwGxevo3EtPDoILWU6ktMKzaFJis7fYoiogPVfm6lf
         u+vmgP81nCZr36cRTQpesXe9IE7ta4H18IysBhqMDFVBYXPT6uj0CHJZ2d8s9IyB9emR
         wtR4m/k4fshfw1qxkIyej2YEyEC+2sNPYhJZqN3V8qD/TG4TZN5dv3v+e2pemC23JZKl
         Rqyw==
X-Forwarded-Encrypted: i=1; AJvYcCXYZLVTChvXTS2+v/yPUb5zJDetq9EJwfnKVLjZHlmu+EoSk24NHLGq+kI+iPmS39BuQHI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy74KMWR5WepbWe3Ik2he1JTIbyW7XK1w4mwrQiRtph7WEqeVch
	qvMvlTMzof2XjcU4VN+9ZB26qKbSsKfUnt53fQxTiaUGSnoI8stUE6SJCCGcYo6Ov2qLlm2UupQ
	JFaa7YTftma0HpjDRvs7pP5hHtAmIyOUEyH2QPj8EwxZOmwPI7YRvyw==
X-Gm-Gg: ASbGncswK3PBJgS+fB7ek7lRY/y5tv/hRloiiDpVyRTCTidBrk/5m9mlaH6QV6nYYmJ
	g/d/Zm8nTZyUhhI3PpFCbv2E34LoEG2GKPplDfD+AU0FW+MC2s2hRGT1AtyWYIF03UnXTvZAWDZ
	j6ZrVc3Iv8jlVg3ZwOSkXY96nljOm26XKjRKKyEc7ZEoNMCwWHAl0GVEokP+IVeMhMD98eoSVNH
	njmexOzP2Uq3hTIjAru1MCTaf+y2KT4pbt91RRmls1WT8VYznwLhzAg6iySwGeJuW0Jxb4KuDaU
	7KowXxu7Y/DXJA==
X-Received: by 2002:a05:620a:319b:b0:7d3:8566:e9ad with SMTP id af79cd13be357-7d3c6cda22amr73140785a.34.1749840335926;
        Fri, 13 Jun 2025 11:45:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKzDCn4nojCIkAe3r6d+k+rYFyD6aXK6Jgcdcld1OPnByWZTDIhVjfVBp6BIIZpji/HLnesg==
X-Received: by 2002:a05:620a:319b:b0:7d3:8566:e9ad with SMTP id af79cd13be357-7d3c6cda22amr73135785a.34.1749840335471;
        Fri, 13 Jun 2025 11:45:35 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3b8dc92e8sm206411085a.5.2025.06.13.11.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 11:45:34 -0700 (PDT)
Date: Fri, 13 Jun 2025 14:45:31 -0400
From: Peter Xu <peterx@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to
 mm_get_unmapped_area_aligned
Message-ID: <aExxy3WUp6gZx24f@x1.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-4-peterx@redhat.com>
 <08193194-3217-4c43-923e-c72cdbbd82e7@lucifer.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <08193194-3217-4c43-923e-c72cdbbd82e7@lucifer.local>

On Fri, Jun 13, 2025 at 04:36:57PM +0100, Lorenzo Stoakes wrote:
> On Fri, Jun 13, 2025 at 09:41:09AM -0400, Peter Xu wrote:
> > This function is pretty handy for any type of VMA to provide a size-aligned
> > VMA address when mmap().  Rename the function and export it.
> 
> This isn't a great commit message, 'to provide a size-aligned VMA address when
> mmap()' is super unclear - do you mean 'to provide an unmapped address that is
> also aligned to the specified size'?

I sincerely don't know the difference, not a native speaker here..
Suggestions welcomed, I can update to whatever both of us agree on.

> 
> I think you should also specify your motive, renaming and exporting something
> because it seems handy isn't sufficient justifiation.
> 
> Also why would we need to export this? What modules might want to use this? I'm
> generally not a huge fan of exporting things unless we strictly have to.

It's one of the major reasons why I sent this together with the VFIO
patches.  It'll be used in VFIO patches that is in the same series.  I will
mention it in the commit message when repost.

> 
> >
> > About the rename:
> >
> >   - Dropping "THP" because it doesn't really have much to do with THP
> >     internally.
> 
> Well the function seems specifically tailored to the THP use. I think you'll
> need to further adjust this.

Actually.. it is almost exactly what I need so far.  I can justify it below.

> 
> >
> >   - The suffix "_aligned" imply it is a helper to generate aligned virtual
> >     address based on what is specified (which can be not PMD_SIZE).
> 
> Ack this is sensible!
> 
> >
> > Cc: Zi Yan <ziy@nvidia.com>
> > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Dev Jain <dev.jain@arm.com>
> > Cc: Barry Song <baohua@kernel.org>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  include/linux/huge_mm.h | 14 +++++++++++++-
> >  mm/huge_memory.c        |  6 ++++--
> >  2 files changed, 17 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 2f190c90192d..706488d92bb6 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> 
> Why are we keeping everything in huge_mm.h, huge_memory.c if this is being made
> generic?
> 
> Surely this should be moved out into mm/mmap.c no?

No objections, but I suggest a separate discussion and patch submission
when the original function resides in huge_memory.c.  Hope it's ok for you.

> 
> > @@ -339,7 +339,10 @@ unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
> >  unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> >  		unsigned long len, unsigned long pgoff, unsigned long flags,
> >  		vm_flags_t vm_flags);
> > -
> > +unsigned long mm_get_unmapped_area_aligned(struct file *filp,
> > +		unsigned long addr, unsigned long len,
> > +		loff_t off, unsigned long flags, unsigned long size,
> > +		vm_flags_t vm_flags);
> 
> I echo Jason's comments about a kdoc and explanation of what this function does.
> 
> >  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
> >  int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
> >  		unsigned int new_order);
> > @@ -543,6 +546,15 @@ thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> >  	return 0;
> >  }
> >
> > +static inline unsigned long
> > +mm_get_unmapped_area_aligned(struct file *filp,
> > +			     unsigned long addr, unsigned long len,
> > +			     loff_t off, unsigned long flags, unsigned long size,
> > +			     vm_flags_t vm_flags)
> > +{
> > +	return 0;
> > +}
> > +
> >  static inline bool
> >  can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
> >  {
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 4734de1dc0ae..52f13a70562f 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -1088,7 +1088,7 @@ static inline bool is_transparent_hugepage(const struct folio *folio)
> >  		folio_test_large_rmappable(folio);
> >  }
> >
> > -static unsigned long __thp_get_unmapped_area(struct file *filp,
> > +unsigned long mm_get_unmapped_area_aligned(struct file *filp,
> >  		unsigned long addr, unsigned long len,
> >  		loff_t off, unsigned long flags, unsigned long size,
> >  		vm_flags_t vm_flags)
> > @@ -1132,6 +1132,7 @@ static unsigned long __thp_get_unmapped_area(struct file *filp,
> >  	ret += off_sub;
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL_GPL(mm_get_unmapped_area_aligned);
> 
> I'm not convinced about exporting this... shouldn't be export only if we
> explicitly have a user?
> 
> I'd rather we didn't unless we needed to.
> 
> >
> >  unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> >  		unsigned long len, unsigned long pgoff, unsigned long flags,
> > @@ -1140,7 +1141,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
> >  	unsigned long ret;
> >  	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
> >
> > -	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
> > +	ret = mm_get_unmapped_area_aligned(filp, addr, len, off, flags,
> > +					   PMD_SIZE, vm_flags);
> >  	if (ret)
> >  		return ret;
> >
> > --
> > 2.49.0
> >
> 
> So, you don't touch the original function but there's stuff there I think we
> need to think about if this is generalised.
> 
> E.g.:
> 
> 	if (!IS_ENABLED(CONFIG_64BIT) || in_compat_syscall())
> 		return 0;
> 
> This still valid?

Yes.  I want this feature (for VFIO) to not be enabled on 32bits, and not
enabled with compat syscals.

> 
> 	/*
> 	 * The failure might be due to length padding. The caller will retry
> 	 * without the padding.
> 	 */
> 	if (IS_ERR_VALUE(ret))
> 		return 0;
> 
> This is assuming things the (currently single) caller will do, that is no longer
> an assumption you can make, especially if exported.

It's part of core function we want from a generic helper.  We want to know
when the va allocation, after padded, would fail due to the padding. Then
the caller can decide what to do next.  It needs to fail here properly.

> 
> Actually you maybe want to abstract the whole of thp_get_unmapped_area_vmflags()
> no? As this has a fallback mode?
> 
> 	/*
> 	 * Do not try to align to THP boundary if allocation at the address
> 	 * hint succeeds.
> 	 */
> 	if (ret == addr)
> 		return addr;

This is not a fallback. This is when user specified a hint address (no
matter with / without MAP_FIXED), if that address works then we should
reuse that address, ignoring the alignment requirement from the driver.
This is exactly the behavior VFIO needs, and this should also be the
suggested behavior for whatever new drivers that would like to start using
this generic helper.

> 
> What was that about this no longer being relevant to THP? :>)
> 
> Are all of these 'return 0' cases expected by any sensible caller? It seems like
> it's a way for thp_get_unmapped_area_vmflags() to recognise when to fall back to
> non-aligned?

Hope above justfies everything.  It's my intention to reuse everything
here.  If you have any concern on any of the "return 0" cases in the
function being exported, please shoot, we can discuss.

Thanks,

-- 
Peter Xu


