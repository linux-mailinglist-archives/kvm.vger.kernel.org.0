Return-Path: <kvm+bounces-65234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E78FCA0C76
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 19:08:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C02643007E77
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 18:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E10DB33469A;
	Wed,  3 Dec 2025 17:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="FRy1DhTP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721863321AB
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 17:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764784402; cv=none; b=PrL5lL0GYU4pzcTw0PaT4c2ff1qMow8aPsBu3boeosmTemcdLW9hyW+tEtyBvjutnlDzZf88WbBwxdT+uzUYNpSJXWTxwJ4ps4zON/a0+Fh+nmeCGcORQ6IlgccQqgFNFUgktpt4ag8VpSXdtr9MnaXvaCQSGpmS6NESSaCRoWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764784402; c=relaxed/simple;
	bh=69foOxwTqjTIJ5Q+eAFS5+Lr5Mwxq7uRbCD4aAWJzIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T8Zd+71ji6dBo8UVYq75GXgRi+uFBLbMbAUaf3WSrlHDLAPXqgzDTXM/MNn+wXCQIaZB0yX+w43pMajYg+hrrX+atxV9PtO+ZWb2x7x655NNSRPM5EGipSsirqcWwPdOoi3tK1vjQHiFHo1Lf7l08VuaDvylPDNkef0CXSdb7Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=FRy1DhTP; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b2dcdde65bso184485a.0
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 09:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764784394; x=1765389194; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lVJlOc8ND/Iyf2S5FSwKg8rOfnG5RDtAsn0WPd8mpfs=;
        b=FRy1DhTPtFj8Yq/RWnZ3ZAweUUmtydxH4rPj7ZkUGsDXdUL6tVaJociC6gymdqEs0j
         SYNjwF7dyovCE9kTxyNfiWjnGhyH7YzySpMO+Jryt4DHiFo5NB4K3nFdyWBs6DozWuk/
         VsLtKzNnZwyXsNPMFj7cwOy4pmHSFDYYHZsHrVpl1uLg78kvx475Ey2gK2vdh1nAXmKP
         nymmSXIFph7fenA14RGOIftsklHjke5eVigQYl9O0bE4zi3Hp+RM/BqpgqNDGvNREdeD
         cnjU0yw+Jal52CIwgRT7FFnUy+vcCWbDzl9q72df9GKilANLpxyPtLAFXZ4JSo79Lrss
         2/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764784394; x=1765389194;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lVJlOc8ND/Iyf2S5FSwKg8rOfnG5RDtAsn0WPd8mpfs=;
        b=oBNxS+m+4n/drdKmrrY3BtiwDY/m0muvgTh1F3CnMvAqu1025EQPsOHwJ9AZrIac5/
         t1b+ishcI+pQrtsq948HXYjwC46pYYBRSXB3G2GW/tF2BDtzIspwI/SRT8Fci3zal3lH
         LTEE9S4ykRPXhK0Bx/EM+R6MsiuEZMsFdMhZsS2FnXJV3ZOxKreRtiKdQfCFvVlBDv3K
         L0GaORt/RLlskRX/3gJ4lJb66qRsSTd2XxqPr1CiWVuWA9DZFIVGxOw7LuFR3OJN/Xs4
         iyvemc2zsi3DjfHMhorC8tbomjuOTAWa7oDsdVkEZdfqfHASkFyYiY2m2GT7cBR1euDn
         rYKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFLJrgVD4p7vW1mUjOci3B7Ip306PN0xn7cwbvlX7o9gwmkH2XK9OMwv7ismeggGqVofo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL9Y4oUROoESaCMOhcS0l6olHDNOmwRI2j1DRNteyeoW2L7EWw
	S8j8AFjI4/Uy8m8jedvACGa9p1HTX2uFphUAzgX1t/N/KqtvcV4zyaP3VsCp/rCDC6A=
X-Gm-Gg: ASbGncs29vrGKRrxR2+j7H9MWsorTnQ2N+QCyLDLskXxNZMmmgLowsCpt+LLdR6IcbY
	W/xz9d07RkDlPsBgZr82pZWRlr8bGALHDvyQZsEYW/CvJ/3QGisMywNKvigUglhgW5wS1frt2El
	RLi1jgr6jqTlXGd3otvY1HI36Ajhvx+4xa7svdDInUCgao6zehHSKUUQhWuzpvUFyHczzHlxCpC
	VR7aepP9QQe6gr4bfRk+acnedIYqb9vSdKEPKp4Qfe2NsbuabjmK5GDuPL8hB1NOBpYdC1pr9E5
	vVQ+2UvMWk2C5VERrGWLg0e1GuDQSv/AiKLvq7wxhYpoElz+2JtDFw0hMY77WGeSXCMqAgQB7PZ
	mCRgYI+2Rt1c4jIDyXOGcwTfHR36RZMuURfBJ7vOtxp8QFzMDCAaHgkvDdoWjnoS9IvRhBZquRu
	RwhoHbPrAdjkKrQy7TY3hpEetSznBwx+OP/s7fKQUvgCUbPyKPaAU+AQVWll3g/ZqPhZoocA==
X-Google-Smtp-Source: AGHT+IHHD5+Jl7GtUH8NhBzm6kCviK25Go8YNEW6lOEadSIHifkHTfsNCnR07LpsAcRGWeAu1C3aGA==
X-Received: by 2002:ac8:7f4a:0:b0:4ed:b6aa:ee26 with SMTP id d75a77b69052e-4f023ae1140mr209871cf.55.1764784394367;
        Wed, 03 Dec 2025 09:53:14 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd3444557sm118131171cf.30.2025.12.03.09.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 09:53:13 -0800 (PST)
Date: Wed, 3 Dec 2025 12:53:12 -0500
From: Gregory Price <gourry@gourry.net>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	kas@kernel.org, dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com, muchun.song@linux.dev,
	osalvador@suse.de, david@redhat.com, x86@kernel.org,
	linux-coco@lists.linux.dev, kvm@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
References: <20251203063004.185182-1-gourry@gourry.net>
 <20251203173209.GA478168@cmpxchg.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203173209.GA478168@cmpxchg.org>

On Wed, Dec 03, 2025 at 12:32:09PM -0500, Johannes Weiner wrote:
> On Wed, Dec 03, 2025 at 01:30:04AM -0500, Gregory Price wrote:
> > -		if (PageHuge(page))
> > -			return false;
> > +		/*
> > +		 * Only consider ranges containing hugepages if those pages are
> > +		 * smaller than the requested contiguous region.  e.g.:
> > +		 *     Move 2MB pages to free up a 1GB range.
> 
> This one makes sense to me.
> 
> > +		 *     Don't move 1GB pages to free up a 2MB range.
> 
> This one I might be missing something. We don't use cma for 2M pages,
> so I don't see how we can end up in this path for 2M allocations.
> 

I used 2MB as an example, but the other users (listed in the changelog)
would run into these as well.  The contiguous order size seemed
different between each of the 4 users (memtrace, tx, kfence, thp debug).

> The reason I'm bringing this up is because this function overall looks
> kind of unnecessary. Page isolation checks all of these conditions
> already, and arbitrates huge pages on hugepage_migration_supported() -
> which seems to be the semantics you also desire here.
> 
> Would it make sense to just remove pfn_range_valid_contig()?

This seems like a pretty clear optimization that was added at some point
to prevent incurring the cost of starting to isolate 512MB of pages and
then having to go undo it because it ran into a single huge page.

        for_each_zone_zonelist_nodemask(zone, z, zonelist,
                                        gfp_zone(gfp_mask), nodemask) {

                spin_lock_irqsave(&zone->lock, flags);
                pfn = ALIGN(zone->zone_start_pfn, nr_pages);
                while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
                        if (pfn_range_valid_contig(zone, pfn, nr_pages)) {

                                spin_unlock_irqrestore(&zone->lock, flags);
                                ret = __alloc_contig_pages(pfn, nr_pages,
                                                        gfp_mask);
                                spin_lock_irqsave(&zone->lock, flags);

                        }
                        pfn += nr_pages;
                }
                spin_unlock_irqrestore(&zone->lock, flags);
        }

and then

__alloc_contig_pages
	ret = start_isolate_page_range(start, end, mode);

This is called without pre-checking the range for unmovable pages.

Seems dangerous to remove without significant data.

~Gregory

