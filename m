Return-Path: <kvm+bounces-65233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A45CA1161
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 19:43:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6957D31A08D6
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 17:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0729234320D;
	Wed,  3 Dec 2025 17:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="qD+4N+8n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0704D342538
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 17:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764783140; cv=none; b=ALnoM4culnM43B6hIGom7S7t8qegBOWz0taIjzrqjXnr6aX40iR8JBtNm2uutALslOWx5XunCHpSkY3SdKmIIiR8W4w2G+EHt09vZtWGwcJ1d/Y6z4qGcYBsDXR4DtjQodQPkb+Y+FZMC3RNux7ZoQys2mKXJVjDiHVpW3sl/30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764783140; c=relaxed/simple;
	bh=N7OKcRPraIwwOO+e5acnIG0+6lKUBkn3zohe7EwnngU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mjgtX362i1q9QSnOis7s3sXDakIBM9ZySFNiTa4Ge0z1qDzGYHAXDu4rEBMSnnrL00TmHwmb6FvcPxCudtjUGYWYmokZZDX0s0E85bcgfu5Ql0oisq8GjOkt+aa7OBN6y4QM8epXkj1CB5HKeAhkhuIf9Qzd62ACcWTWE/AZM/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=qD+4N+8n; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ee1fca7a16so158191cf.3
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 09:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1764783136; x=1765387936; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RXfrLUBUUNxWrlXQZfRVAlemBKM14MYadMSOQJLP4KM=;
        b=qD+4N+8nu7V2osgG54omKoBtT0PTDrL9uvpxfa4ns7cVn+JrSeNaV+ozkwbACovtNc
         1WkCPyviGYgk9ZKH6M/7J9/RxBjKAhA+wSWePA/m8GBwhG41JJeWwZdeK8C9fgOmWppi
         wHQvK2NSXzreqWQcdcoG+EVEHWPQU62pj1vvWhaeMNuARDugeMyyrXizvDn2iUCwmes6
         4yjAfcwghpMBQlREVqNKZE0alADOsDZRv4qioZrJvf3UyTKA9Q0utz2Gz5Dvh68NR9Ft
         TW93iw7hE3BjeXXxk8uWtJDX7ydwiwfXPg863wyLAnM8fLYlqOTQbjX0Gs9iLB5mJt8v
         fLbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764783136; x=1765387936;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RXfrLUBUUNxWrlXQZfRVAlemBKM14MYadMSOQJLP4KM=;
        b=Qee41XyGX7kqhF0s4BDl8Z1/ZwffTPo/XWNy9u55MPvjol/4dL7GQ81XYwqCEkAdj0
         1Q4WdibEXUShZsDF28+gy/4BRQoyuVq4HzDjfomVQx374x8rnf4IcojZ51DkcMM0Jj38
         qWZpWvx30syDjWS3haYXkO7Wtt1dv22TyYN0yM+bSQawuJKlnSAWx8A+L3FkjFU/mJMu
         979YZG5bKY/Op2RU1Ig5oEHxDBf0xm0KLJT5OGZkn6C2oZShhDDl9rxQn6AbXRa8y8jP
         /NwEq6mKtY6LETxSK5lreOPgVBCxD2UxpW8mW81QgHORv1cqdxmD6ts5C6ADlhSndPXw
         vVmg==
X-Forwarded-Encrypted: i=1; AJvYcCXqmH9gnfp7M+c1hw+FVYuGeVCiqWTN9ku5WXIRypfmOjhGRrLzxWcypMH/BV2zeWBAhDo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwapYAjh8TuFE15EHCBl9CLj4RMFez47gl7HuobRV/Jm1U9FLki
	r/GY04bsW5J1W6PsC+3wVCExBNIHPRn8ObZK9Dah523XZWlhjgEM74+8egHCRIuE8pY=
X-Gm-Gg: ASbGncsgncoj4bcVeCpzsv+OondwKpLGRuK3am47WEj+OXBjOp03rGSzclWqfM3fF5F
	L3qw+RBnPsXBtO+VleMwhCkpaF+zn6CuTe6Ui4ZKjuZTalJc4xfh8P/PNRdNPtvVZQRd1uwWE43
	RSu+85SLYODXR21aCBweRDwR0wu+2OT6vlpV5HbBhsrWyTEQiUNlPqu4huWVsNdE5L8kPD8JwKG
	neY6Yw68zituHyDOv6QoJZZTBVZgfJ8BTpDf9caD6tmumk7Bme9uxSwq2bFmqjIchzsdtfLixU0
	bQAmPJ2PfAjCsOmNLae87qWbQQ/UbcKE52JRXyRCHUZzoBq6W8ea8UeePenipVfhH5i67LE5Dj5
	lriAoGDJ1fPp4fUh5DnJG8sC9aecP8jjLjVhUM1vSj9u9w6GHkz5KjiJJikojG95SASiicSVCkb
	Xv5DVj9sZ6xA==
X-Google-Smtp-Source: AGHT+IHjhRSsYojqPIH4nCotrtO7/FPORpmU3S+uq1yOdc4D+I4pkxVbp8jOs/i2z+ku8NQQIlusKQ==
X-Received: by 2002:a05:622a:1489:b0:4ed:a744:adc with SMTP id d75a77b69052e-4f01757f2e8mr38710771cf.10.1764783135284;
        Wed, 03 Dec 2025 09:32:15 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd341f2f8sm115763391cf.22.2025.12.03.09.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 09:32:14 -0800 (PST)
Date: Wed, 3 Dec 2025 12:32:09 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Gregory Price <gourry@gourry.net>
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
Message-ID: <20251203173209.GA478168@cmpxchg.org>
References: <20251203063004.185182-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203063004.185182-1-gourry@gourry.net>

On Wed, Dec 03, 2025 at 01:30:04AM -0500, Gregory Price wrote:
> We presently skip regions with hugepages entirely when trying to do
> contiguous page allocation.  This will cause otherwise-movable
> 2MB HugeTLB pages to be considered unmovable, and will make 1GB
> hugepages more difficult to allocate on systems utilizing both.
> 
> Instead, if hugepage migration is enabled, consider regions with
> hugepages smaller than the target contiguous allocation request
> as valid targets for allocation.
> 
> isolate_migrate_pages_block() has similar logic, and the hugetlb code
> does a migratable check in folio_isolate_hugetlb() during isolation.
> So the code servicing the subsequent allocaiton and migration already
> supports this exact use case (it's just unreachable).
> 
> To test, allocate a bunch of 2MB HugeTLB pages (in this case 48GB)
> and then attempt to allocate some 1G HugeTLB pages (in this case 4GB)
> (Scale to your machine's memory capacity).
> 
> echo 24576 > .../hugepages-2048kB/nr_hugepages
> echo 4 > .../hugepages-1048576kB/nr_hugepages
> 
> Prior to this patch, the 1GB page allocation can fail if no contiguous
> 1GB pages remain.  After this patch, the kernel will try to move 2MB
> pages and successfully allocate the 1GB pages (assuming overall
> sufficient memory is available).
> 
> folio_alloc_gigantic() is the primary user of alloc_contig_pages(),
> other users are debug or init-time allocations and largely unaffected.
> - ppc/memtrace is a debugfs interface
> - x86/tdx memory allocation occurs once on module-init
> - kfence/core happens once on module (late) init
> - THP uses it in debug_vm_pgtable_alloc_huge_page at __init time
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Link: https://lore.kernel.org/linux-mm/6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com/
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> Acked-by: David Rientjes <rientjes@google.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/page_alloc.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 95d8b812efd0..8ca3273f734a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7069,8 +7069,27 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>  		if (PageReserved(page))
>  			return false;
>  
> -		if (PageHuge(page))
> -			return false;
> +		/*
> +		 * Only consider ranges containing hugepages if those pages are
> +		 * smaller than the requested contiguous region.  e.g.:
> +		 *     Move 2MB pages to free up a 1GB range.

This one makes sense to me.

> +		 *     Don't move 1GB pages to free up a 2MB range.

This one I might be missing something. We don't use cma for 2M pages,
so I don't see how we can end up in this path for 2M allocations.

The reason I'm bringing this up is because this function overall looks
kind of unnecessary. Page isolation checks all of these conditions
already, and arbitrates huge pages on hugepage_migration_supported() -
which seems to be the semantics you also desire here.

Would it make sense to just remove pfn_range_valid_contig()?

