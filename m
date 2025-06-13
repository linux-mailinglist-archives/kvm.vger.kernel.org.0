Return-Path: <kvm+bounces-49509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2527CAD9569
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:23:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E23A63AD6BB
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F0DD253B71;
	Fri, 13 Jun 2025 19:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jDB/Mqrf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1DA2E11A4
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 19:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749842128; cv=none; b=Pv73UUb4TN3U+A842CVvRBV/xGM5vPNxbX19CP1pg2gMIVmeGlgbf/PdiQ3lA0244Txf1wFpcC52+upnUvceD2BUL7ovq9WedpJeXEI/N/Z1aTQj6GBqlhRFjtc4no/kQWSLkYA3s1EtQeU9M3RxBFJTvLVufWNqOQ6300pgcKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749842128; c=relaxed/simple;
	bh=9SnSyYVg0kedc8JO1gYNGqXb9FJt5NkPMvIQXigRwus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dx8jZqMi9LOsyOsfbv2LTiR6xQ7Md08kirOgxLe02EY1BNzV2DMJ+lz98SuJZ6qPf5O5vhZ0guq0OAGVtylZ13z6MkVJ8zfiEJ+8GcN8GjKDqLFpwKwOsY77Kaz6XLl0o3WGj+h1+PIbEKBXqCY2b4XRpC0DICu5AXaSKCpE7kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jDB/Mqrf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749842125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VJfPFlcDvR8fJBRiXniq1f1GzMtYJTiekQUbf2DHnUc=;
	b=jDB/Mqrfw2O0iLp1WFKdfkrN7PNDFj7KoHKzOVcW03DGFJXbdVh2EgcoJSaJUOk49jRTUu
	jFze//puEyj/fIHCWkkLoWbv6nNzqKZTR9sOcFGLGqMQbXSmFPp49htCaRkbobTL3KKtpw
	iuOWp8rhPrkXWzS3iw9y07Qr0UuvUKA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-7lWFqNdYPqaTSLysbyzL0Q-1; Fri, 13 Jun 2025 15:15:24 -0400
X-MC-Unique: 7lWFqNdYPqaTSLysbyzL0Q-1
X-Mimecast-MFC-AGG-ID: 7lWFqNdYPqaTSLysbyzL0Q_1749842124
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7d2107d6b30so374140985a.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 12:15:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749842124; x=1750446924;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJfPFlcDvR8fJBRiXniq1f1GzMtYJTiekQUbf2DHnUc=;
        b=mczLh9DBoPepuHDlnu53px5M+uQNKIC80lGv62BbYT/qrBz1zqsjbnDz+jr9dsnDuc
         fgIulWkjWJsCKh5TsfcOtFKSICOEt102brMEMZz1Z1krrVjfeBVoSS52fPiSD8g37ZSx
         NDPfSb+8WwD2teARGRzMZA74tIk89H6aP0x7vEYA5RziHl+ccX/ihNA6+0992dIyGd/y
         O4iecBz+/IW98blsbEsFgU1mzcu2zqvxKwkU+aL+DbmFe99aPi8LzitxAgjHz4M3L+Es
         FZF44/XZ+lFc1ksdiwnm1QsaTp7ezthdv9n3Du+7E3yEAA4NojBwG61owoNkS3xzGsAH
         eXgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWL1HV0OTS4IvyT2HIv8rO6ETZNkYh/JmgT00wtT9fs0deqBQ1QjzScTGxgAHpno5G4azI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxklc73mRwTg+kwmDNM+daYTBxKhlR2EPh9tygiqCsC4+pweYBY
	tDoFrCxUG1pwIQVApIeuf3yRmUAU++2cqr/5zja8oI8H4GygHxnY8KgSG2yn05HgRyp4usWu/Z8
	1di7AhodN5OwBmxaTxzchk77NjipCZs8szerOGWUihA4szhwL200bOA==
X-Gm-Gg: ASbGncvOm7aozEMB1tq8tXssyZAGTF9k65FGOhtgyP/uJiZ5WZ4d0gpKCUvAH4xMHvH
	7ykBn6ls1lG2UzGddUl10ZWyhUcDkuaSo+RRFmH//D0HBTix5MVvMRpdnuZevg1sUDLp+y2W9f6
	QOxjcyl+oSdkSgi5oxrsg5Lr0OqjMsYgd6j0uVKjx9MgGU5AYSnmOiC1L5pvM3ICL0xrQDRgjJC
	4sN4i0pdBkdyuEXc+o2Zswizk0wlDXaQhMJ0hhXHI6zEmOO8m7Skw/V2wqNJjMiHQnYbMBPtxE9
	FDlWrwL3rFTIew==
X-Received: by 2002:a05:620a:4690:b0:7cd:3f01:7c83 with SMTP id af79cd13be357-7d3c6ced959mr86690085a.39.1749842123791;
        Fri, 13 Jun 2025 12:15:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHk+tLwiHsLDG8K2pZBbbo9MT0cMiJjdHUPCCmygz28zS6TQo7hCodBcEzueO0HEuES3dSRA==
X-Received: by 2002:a05:620a:4690:b0:7cd:3f01:7c83 with SMTP id af79cd13be357-7d3c6ced959mr86685785a.39.1749842123343;
        Fri, 13 Jun 2025 12:15:23 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3b8eac910sm208179585a.72.2025.06.13.12.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 12:15:22 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:15:19 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <aEx4x_tvXzgrIanl@x1.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-6-peterx@redhat.com>
 <20250613142903.GL1174925@nvidia.com>
 <aExDMO5fZ_VkSPqP@x1.local>
 <20250613160956.GN1174925@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250613160956.GN1174925@nvidia.com>

On Fri, Jun 13, 2025 at 01:09:56PM -0300, Jason Gunthorpe wrote:
> On Fri, Jun 13, 2025 at 11:26:40AM -0400, Peter Xu wrote:
> > On Fri, Jun 13, 2025 at 11:29:03AM -0300, Jason Gunthorpe wrote:
> > > On Fri, Jun 13, 2025 at 09:41:11AM -0400, Peter Xu wrote:
> > > 
> > > > +	/* Choose the alignment */
> > > > +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && phys_len >= PUD_SIZE) {
> > > > +		ret = mm_get_unmapped_area_aligned(file, addr, len, phys_addr,
> > > > +						   flags, PUD_SIZE, 0);
> > > > +		if (ret)
> > > > +			return ret;
> > > > +	}
> > > > +
> > > > +	if (phys_len >= PMD_SIZE) {
> > > > +		ret = mm_get_unmapped_area_aligned(file, addr, len, phys_addr,
> > > > +						   flags, PMD_SIZE, 0);
> > > > +		if (ret)
> > > > +			return ret;
> > > > +	}
> > > 
> > > Hurm, we have contiguous pages now, so PMD_SIZE is not so great, eg on
> > > 4k ARM with we can have a 16*2M=32MB contiguity, and 16k ARM uses
> > > contiguity to get a 32*16k=1GB option.
> > > 
> > > Forcing to only align to the PMD or PUD seems suboptimal..
> > 
> > Right, however the cont-pte / cont-pmd are still not supported in huge
> > pfnmaps in general?  It'll definitely be nice if someone could look at that
> > from ARM perspective, then provide support of both in one shot.
> 
> Maybe leave behind a comment about this. I've been poking around if
> somone would do the ARM PFNMAP support but can't report any commitment.

I didn't know what's the best part to take a note for the whole pfnmap
effort, but I added a note into the commit message on this patch:

        Note 2: Currently continuous pgtable entries (for example, cont-pte) is not
        yet supported for huge pfnmaps in general.  It also is not considered in
        this patch so far.  Separate work will be needed to enable continuous
        pgtable entries on archs that support it.

> 
> > > > +fallback:
> > > > +	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> > > 
> > > Why not put this into mm_get_unmapped_area_vmflags() and get rid of
> > > thp_get_unmapped_area_vmflags() too?
> > > 
> > > Is there any reason the caller should have to do a retry?
> > 
> > We would still need thp_get_unmapped_area_vmflags() because that encodes
> > PMD_SIZE for THPs; we need the flexibility of providing any size alignment
> > as a generic helper.
> 
> There is only one caller for thp_get_unmapped_area_vmflags(), just
> open code PMD_SIZE there and thin this whole thing out. It reads
> better like that anyhow:
> 
> 	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && !file
> 		   && !addr /* no hint */
> 		   && IS_ALIGNED(len, PMD_SIZE)) {
> 		/* Ensures that larger anonymous mappings are THP aligned. */
> 		addr = mm_get_unmapped_area_aligned(file, 0, len, pgoff,
> 						    flags, vm_flags, PMD_SIZE);
> 
> > That was ok, however that loses some flexibility when the caller wants to
> > try with different alignments, exactly like above: currently, it was trying
> > to do a first attempt of PUD mapping then fallback to PMD if that fails.
> 
> Oh, that's a good point, I didn't notice that subtle bit.
> 
> But then maybe that is showing the API is just wrong and the core code
> should be trying to find the best alignment not the caller. Like we
> can have those PUD/PMD size ifdefs inside the mm instead of in VFIO?
> 
> VFIO would just pass the BAR size, implying the best alignment, and
> the core implementation will try to get the largest VMA alignment that
> snaps to an arch supported page contiguity, testing each of the arches
> page size possibilities in turn.
> 
> That sounds like a much better API than pushing this into drivers??

Yes it would be nice if the core mm can evolve to make supporting such
easier.  Though the question is how to pass information over to core mm.

For example, currently a vfio device file represents the whole device, and
it's also VFIO that defines what the MMIO region offsets means. So core mm
has no simple idea which BAR VFIO is mapping if it only receives a mmap()
request.  So even if we assume the core mm provides some vma flag showing
that, it won't be per-vma, but need to be case by case of the mmap()
request at least relevant to pgoff and len being mapped.

And it's definitely the case that for one device its BAR sizes are
different, hence it asks for different alignments when mmap() even if on
the same device fd.

It's similar to many other use cases of get_unmapped_area() users.  For
example, see v4l2_m2m_get_unmapped_area() which has similar treatment on at
least knowing which part of the file was being mapped:

	if (offset < DST_QUEUE_OFF_BASE) {
		vq = v4l2_m2m_get_src_vq(fh->m2m_ctx);
	} else {
		vq = v4l2_m2m_get_dst_vq(fh->m2m_ctx);
		pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
	}

Such flexibility might still be needed for now until we know how to provide
the abstraction.

Meanwhile, there can be other constraints to existing get_unmapped_area()
users that a decision might be done with any parameter passed into it
besides the pgoff.. so even if we provide the whole pgoff info, it might
not be enough.

-- 
Peter Xu


