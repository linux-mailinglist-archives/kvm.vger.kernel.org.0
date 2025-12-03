Return-Path: <kvm+bounces-65237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D5E0CA0E49
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 19:19:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8B0853002B36
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 18:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD57031158A;
	Wed,  3 Dec 2025 18:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="L6M7uRQb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C86E27603F
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 18:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764785982; cv=none; b=urYWt9MUxnyEs/9AX+MsTyWQcR3DywfBS9eCZ2Aa/EparnXbkObBBF0fWi2UwElJgjQK7IdAdx4ummjPTmDWA7j+e9M+XSM/7cWjA61gAlTCBEjizHnEOIU1lmSl7KkBzQh4caKYzxLRmkuF3NUrZjBV3KgUUtPud2ciSYlpw3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764785982; c=relaxed/simple;
	bh=YHEQjDaNAyN/sLTlveLQN+NwtzxBummzcQvo1oG/bS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdD2LAp3iibCaUvt+A9MwzPDBMl4BmPLCo+UV7ucyL9VcHQlZA9Q6uEAiL6XJi2CqtEq10wsDBVMr2pQWwL7yVsMU2bk35NFLb4JgrZ1LeK2o+lt+atNmDUC+99ejGeNbK+BNo3kaJ7BesH2drJNA52/3zA3WNOjBONfyd0yNnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=L6M7uRQb; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b2da83f721so11359985a.1
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 10:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1764785980; x=1765390780; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cvxsSNOGWdrE9akcNg/jRgoHeSCakoDs4XiZtxVygNw=;
        b=L6M7uRQbzP/qQYabyTnLMLB/JNXBK0ld4KG3hYa5KCbtNRrbioseylNLSuZ6obwiui
         44mpLCMrQZM8UIUKjRGd6i+CRwEMYfYqNB3Uu1wdgL+xsO5X3Cs+g/XzdPpuyLCo8+T5
         WN62EHK3fsT0BB/8EKJsmvXsD2bbkQsnt1oqecRnzImDxu/fzWu+M45ivK/D/N7A2LuZ
         h+TWFQhdurdCqTMhbO7gjd0y888bGVrPY2yilk2p9mi/hcGoNb7XqXhA9kTadHodYKnh
         LJTvx3UxVy+Sbp62AP+EZvG9xUG1ZEh0/Sus0dWB88wfUw/f+1oWAu5Q7dGLxda0v3dc
         BSnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764785980; x=1765390780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cvxsSNOGWdrE9akcNg/jRgoHeSCakoDs4XiZtxVygNw=;
        b=hZO1eM+nzqWSAIIhB5zoL97BNvxAc3MeHUDdVjKjqK6v+wnql/L17eAosndExBGDxf
         /LuGReg8EIyHTDQ52JfOqibWX4p60FtQZGmRP7o1OQse2Qzt0Bsq2uTUbuijtHk0KuNS
         AlTrZgL5DRWHJm/Tx1g7SGdDvneVpKCtnhYOSA+Pzrvy+wC7LNUWOlZ2RyfIvaUneTcF
         W+OkUNtgmddKlKTJHf88KG6hnidN7YYFmRBni2jKumVF/37SJHMtw2LIdxi/bLckl1xo
         xqADXkJBeRSSLJA3Rp1qN2IRIdSeXZnN9kQG/Ggp833kUmW8YWEXqk0e2VtFbBrDaHDP
         W8GA==
X-Forwarded-Encrypted: i=1; AJvYcCVnKNrxngklrzJhwb3dBPU49YItwTLBJ1GZ/0W7gjwAMY/58xxKUtbhd51VSzUswt5fSY8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYRmHQJHseVlySyy7HXI1fm65TqaqeAZ6RytZw7cW69wftU+zT
	kdfMXV07srmVbdrRI8pO5e3tidfYqXmDHa5YOjsOKq4c2j69I0ddq2qkPr+0BNOZ9ac=
X-Gm-Gg: ASbGnctSm1ef5gpmel/sT4Ic4rchyr4acmb7ol1dlWg7ClYiOYoJIQm+kGcMH9ICkvR
	3ZmzqAMytBt8/SxdfQlTofQRZEshCp3HxLTm7M2LWSgXYQVtggzRAruYTgrjxXHUaZg2keZa+pc
	RL19viiKLMn/I247wcjpI88yLLxSmWtjX/JGIACs3M9mIpuYJPSmJ6CuUZH+wd42/Bs9Ef+TGsz
	WklBBe8pb69HOftRIpycot01qyIdn4R06bxZy9J26ME7tk1fyMiuudkebh0QSNbjxkDWJ0DhiSz
	kW7LDl8KdTowSVHM9foeAPQgou8TkGMMvqOmswAvSjQ4TE5Tbv2hDrhS35kpEN4leeNvcvx1KcH
	kTMOb5uv41gf3a48cluY2pGjxBHepVPJ0J2JQRBQbayElKIH83rR9RniEmypFJuBssZIQvN+yTq
	EBrVJxfqObVg==
X-Google-Smtp-Source: AGHT+IExlNX5MNBC3OYudvJIv4VEFspzEKTWEJsupXZUlcjDYuuJpB+YCUht9jfc5WZuK1q3vHl8NA==
X-Received: by 2002:a05:620a:c4e:b0:8b2:ed3b:e642 with SMTP id af79cd13be357-8b615f82cbcmr63003185a.34.1764785979729;
        Wed, 03 Dec 2025 10:19:39 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b5299a5377sm1334780185a.14.2025.12.03.10.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 10:19:39 -0800 (PST)
Date: Wed, 3 Dec 2025 13:19:34 -0500
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
Message-ID: <20251203181934.GB478168@cmpxchg.org>
References: <20251203063004.185182-1-gourry@gourry.net>
 <20251203173209.GA478168@cmpxchg.org>
 <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>

On Wed, Dec 03, 2025 at 12:53:12PM -0500, Gregory Price wrote:
> On Wed, Dec 03, 2025 at 12:32:09PM -0500, Johannes Weiner wrote:
> > The reason I'm bringing this up is because this function overall looks
> > kind of unnecessary. Page isolation checks all of these conditions
> > already, and arbitrates huge pages on hugepage_migration_supported() -
> > which seems to be the semantics you also desire here.
> > 
> > Would it make sense to just remove pfn_range_valid_contig()?
> 
> This seems like a pretty clear optimization that was added at some point
> to prevent incurring the cost of starting to isolate 512MB of pages and
> then having to go undo it because it ran into a single huge page.
> 
>         for_each_zone_zonelist_nodemask(zone, z, zonelist,
>                                         gfp_zone(gfp_mask), nodemask) {
> 
>                 spin_lock_irqsave(&zone->lock, flags);
>                 pfn = ALIGN(zone->zone_start_pfn, nr_pages);
>                 while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
>                         if (pfn_range_valid_contig(zone, pfn, nr_pages)) {
> 
>                                 spin_unlock_irqrestore(&zone->lock, flags);
>                                 ret = __alloc_contig_pages(pfn, nr_pages,
>                                                         gfp_mask);
>                                 spin_lock_irqsave(&zone->lock, flags);
> 
>                         }
>                         pfn += nr_pages;
>                 }
>                 spin_unlock_irqrestore(&zone->lock, flags);
>         }
> 
> and then
> 
> __alloc_contig_pages
> 	ret = start_isolate_page_range(start, end, mode);
> 
> This is called without pre-checking the range for unmovable pages.
> 
> Seems dangerous to remove without significant data.

Fair enough. It just caught my eye that the page allocator is running
all the same checks as page isolation itself.

I agree that a quick up front check is useful before updating hundreds
of page blocks, then failing and unrolling on the last one. Arguably
that should just be part of the isolation code, though, not a random
callsite. But that move is better done in a separate patch.

