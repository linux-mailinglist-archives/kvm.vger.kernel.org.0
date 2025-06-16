Return-Path: <kvm+bounces-49636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DFE8DADBC9B
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 00:06:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08F51188AD48
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 22:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6CB0221F2F;
	Mon, 16 Jun 2025 22:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PBMOyz6f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D28202F8E
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 22:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750111595; cv=none; b=TvqLOmnjrVsFmikeX8sfMUCqxaBFV3x3EulTIY1WupDQvP+J9vYLMYhR+dy0Kd7vcwq3i836PFy3RTNrUcTgA8ja1h8uapp6es97iVrlCr0En6qPwH/vQaoVeNKp4Og5RrIgGkZ4U6PxKvjLHrRM0qT+zykdyyaLevmyZPdPDiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750111595; c=relaxed/simple;
	bh=26kZrZoV8Ji9Lqy1VOqU4UKqW2YBkKONHQeTZOiQqos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l8897kXsZqYugV/aAH0VnW67IwWc0dXsgY3IucTFyAs7S6l3JvhX5TlZkk+bEwbt0rgVojWZI0VUI43BMxlrJUpmjvewBuuO+jlXBKSUzHAWbQ5rYsNAGqt2/K3eEQBieLwWyCiATbrB6MzrGZ8P6Ld7igZ3S5y2SzuM36KCgDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PBMOyz6f; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750111592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dFHYfgXcZKBPfdb0AbYsNeZbCn3z17biLchrL/Mt8bQ=;
	b=PBMOyz6fbvAh1FrjyZ7e1ICTFXtyiXJOhCM2iZe+vyYGrV+9gHn23ph7xXdrc2nCOsK4Py
	rztjbHMLme0DEcynoFPqoCKVsgr+37wDq2DrjQxPWqL16iJQblrgfk2BVzXmuU3u91t/dv
	qn0la8892b5SGkXdL9jctFwCg5ImDco=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-6i69uAG7MxW_cY42NG6omA-1; Mon, 16 Jun 2025 18:06:30 -0400
X-MC-Unique: 6i69uAG7MxW_cY42NG6omA-1
X-Mimecast-MFC-AGG-ID: 6i69uAG7MxW_cY42NG6omA_1750111590
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7d09bc05b77so826171785a.1
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 15:06:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750111590; x=1750716390;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dFHYfgXcZKBPfdb0AbYsNeZbCn3z17biLchrL/Mt8bQ=;
        b=MIk8fsjnW0JLdHNg/2xXH5xhGMsxPrto9Bp5Eygwhii0rWcnPXMht0mKsYrmeaQdeZ
         8Vn3IaT3PgfEqjun7qhS7WANW7GiSr5cwCGew6BY5UyQ1lx25+QsnNCjTsSMtF7p4S4S
         U5v1rfPU3hjbUJRO0CfI6JTGLzHa2TFGPIeFVhoM1EQ143PJn9yPzYFmLhH5DfcddCTL
         TSLGNtu0TP+tD0EvhTO7Kv7f51dHsIbeLaoEavKn9K1ojZnP1eQwx9IqCqrmRNNLndXP
         pJQfQU9reX2O8UAM/Sp1X/5VS6Im9NEeq64j3pR7/KhqQwl8/EKnJ4nqg3E92/BZvej+
         8u3w==
X-Forwarded-Encrypted: i=1; AJvYcCU1C+df5hfvNiuxleE7YAPzzQp9us2fM2tDWf1hOpiADbbb1Rh/rQ4oLQLcU3F/XMi/Mes=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAUf841dQDDqWKPepW6AfENns3x3xzhz2Sf9DlYSJIrOBYkpKu
	JsZSrtP+Y0kl/dPr5IpgagVVH6mGp+TL525uV1mdjoPTSEBlNu5U9fwR9I3dz0dwXwdfLu1o3Fx
	JpH4bDJWkLIYiRms7MqYeDdSmMu2KHK3fzHGcePZzV1NNpIvq0SEPXg==
X-Gm-Gg: ASbGncsbua1BgWBSk/yQpAnFT0XV/wTgkZbTVjW9DJDRQS036k1wZhnytTFCDFp1uZb
	qzRY4WmzJn+VMLevZGv1xPjo8cGZNfYVLm7sv/qEZRD4Fh0JgJ0A3myBbHt4Y2clNLazAyVPilP
	nJPAfY89eMMCvcmTF9RW8QbbcflrIdVSMNYBT3pnZDnmnM7C8NZ0yScfBBq5f1RZ1jJtuxYuUIj
	GNXLyoIHmIIxwqqXr/AhB1jx7c0zQT0UuRheFlOWIHPVoIMRLK733rlALH5eggb99bQHd2ePzDT
	fCy8GV3bTuLmYA==
X-Received: by 2002:a05:620a:2a0f:b0:7d0:9f1e:40dc with SMTP id af79cd13be357-7d3c6d0caf4mr1880930085a.56.1750111589977;
        Mon, 16 Jun 2025 15:06:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHb2JRUDP2T8baEWYp/vOc4digV3ytuAMVFRb0HHQswTS/EU4/mjLVkZD74bYg3SYHshW7vyQ==
X-Received: by 2002:a05:620a:2a0f:b0:7d0:9f1e:40dc with SMTP id af79cd13be357-7d3c6d0caf4mr1880926685a.56.1750111589617;
        Mon, 16 Jun 2025 15:06:29 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3b8dfe347sm576951985a.36.2025.06.16.15.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 15:06:28 -0700 (PDT)
Date: Mon, 16 Jun 2025 18:06:23 -0400
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
Message-ID: <aFCVX6ubmyCxyrNF@x1.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-6-peterx@redhat.com>
 <20250613142903.GL1174925@nvidia.com>
 <aExDMO5fZ_VkSPqP@x1.local>
 <20250613160956.GN1174925@nvidia.com>
 <aEx4x_tvXzgrIanl@x1.local>
 <20250613231657.GO1174925@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250613231657.GO1174925@nvidia.com>

On Fri, Jun 13, 2025 at 08:16:57PM -0300, Jason Gunthorpe wrote:
> On Fri, Jun 13, 2025 at 03:15:19PM -0400, Peter Xu wrote:
> > > > > > +	if (phys_len >= PMD_SIZE) {
> > > > > > +		ret = mm_get_unmapped_area_aligned(file, addr, len, phys_addr,
> > > > > > +						   flags, PMD_SIZE, 0);
> > > > > > +		if (ret)
> > > > > > +			return ret;
> > > > > > +	}
> > > > > 
> > > > > Hurm, we have contiguous pages now, so PMD_SIZE is not so great, eg on
> > > > > 4k ARM with we can have a 16*2M=32MB contiguity, and 16k ARM uses
> > > > > contiguity to get a 32*16k=1GB option.
> > > > > 
> > > > > Forcing to only align to the PMD or PUD seems suboptimal..
> > > > 
> > > > Right, however the cont-pte / cont-pmd are still not supported in huge
> > > > pfnmaps in general?  It'll definitely be nice if someone could look at that
> > > > from ARM perspective, then provide support of both in one shot.
> > > 
> > > Maybe leave behind a comment about this. I've been poking around if
> > > somone would do the ARM PFNMAP support but can't report any commitment.
> > 
> > I didn't know what's the best part to take a note for the whole pfnmap
> > effort, but I added a note into the commit message on this patch:
> > 
> >         Note 2: Currently continuous pgtable entries (for example, cont-pte) is not
> >         yet supported for huge pfnmaps in general.  It also is not considered in
> >         this patch so far.  Separate work will be needed to enable continuous
> >         pgtable entries on archs that support it.
> > 
> > > 
> > > > > > +fallback:
> > > > > > +	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> > > > > 
> > > > > Why not put this into mm_get_unmapped_area_vmflags() and get rid of
> > > > > thp_get_unmapped_area_vmflags() too?
> > > > > 
> > > > > Is there any reason the caller should have to do a retry?
> > > > 
> > > > We would still need thp_get_unmapped_area_vmflags() because that encodes
> > > > PMD_SIZE for THPs; we need the flexibility of providing any size alignment
> > > > as a generic helper.
> > > 
> > > There is only one caller for thp_get_unmapped_area_vmflags(), just
> > > open code PMD_SIZE there and thin this whole thing out. It reads
> > > better like that anyhow:
> > > 
> > > 	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && !file
> > > 		   && !addr /* no hint */
> > > 		   && IS_ALIGNED(len, PMD_SIZE)) {
> > > 		/* Ensures that larger anonymous mappings are THP aligned. */
> > > 		addr = mm_get_unmapped_area_aligned(file, 0, len, pgoff,
> > > 						    flags, vm_flags, PMD_SIZE);
> > > 
> > > > That was ok, however that loses some flexibility when the caller wants to
> > > > try with different alignments, exactly like above: currently, it was trying
> > > > to do a first attempt of PUD mapping then fallback to PMD if that fails.
> > > 
> > > Oh, that's a good point, I didn't notice that subtle bit.
> > > 
> > > But then maybe that is showing the API is just wrong and the core code
> > > should be trying to find the best alignment not the caller. Like we
> > > can have those PUD/PMD size ifdefs inside the mm instead of in VFIO?
> > > 
> > > VFIO would just pass the BAR size, implying the best alignment, and
> > > the core implementation will try to get the largest VMA alignment that
> > > snaps to an arch supported page contiguity, testing each of the arches
> > > page size possibilities in turn.
> > > 
> > > That sounds like a much better API than pushing this into drivers??
> > 
> > Yes it would be nice if the core mm can evolve to make supporting such
> > easier.  Though the question is how to pass information over to core mm.
> 
> I was just thinking something simple, change how your new 
> mm_get_unmapped_area_aligned() works so that the caller is expected to
> pass in the size of the biggest folio/pfn page in as
> align.
> 
> The mm_get_unmapped_area_aligned() returns a vm address that
> will result in large mappings.
> 
> pgoff works the same way, the assumption is the biggest folio is at
> pgoff 0 and followed by another biggest folio so the pgoff logic tries
> to make the second folio map fully.
> 
> ie what a hugetlb fd or thp memfd would like.
> 
> Then you still hook the file operations and still figure out what BAR
> and so on to call mm_get_unmapped_area_aligned() with the correct
> aligned parameter.
> 
> mm_get_unmapped_area_aligned() goes through the supported page sizes
> of the arch and selects the best one for the indicated biggest folio
> 
> If we were happy writing this in vfio then it can work just as well in
> the core mm side.

So far, the new vfio_pci_core_get_unmapped_area() almost does VFIO's own
stuff, except that it does retry with different sizes.

Can I understand it as a suggestion to pass in a bitmask into the core mm
API (e.g. keep the name of mm_get_unmapped_area_aligned()), instead of a
constant "align", so that core mm would try to allocate from the largest
size to smaller until it finds some working VA to use?

> 
> > It's similar to many other use cases of get_unmapped_area() users.  For
> > example, see v4l2_m2m_get_unmapped_area() which has similar treatment on at
> > least knowing which part of the file was being mapped:
> > 
> > 	if (offset < DST_QUEUE_OFF_BASE) {
> > 		vq = v4l2_m2m_get_src_vq(fh->m2m_ctx);
> > 	} else {
> > 		vq = v4l2_m2m_get_dst_vq(fh->m2m_ctx);
> > 		pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
> > 	}
> 
> Careful thats only use for nommu :)

My fault, please ignore it.. :)

I'm also surprised it is even available for !MMU.. but I decided to not dig
anymore today on that.

Thanks,

-- 
Peter Xu


