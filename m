Return-Path: <kvm+bounces-65242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A7CBCA1864
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 21:10:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3B810301765B
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 20:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3403830F543;
	Wed,  3 Dec 2025 20:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="QiK/MRlU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ABD30C373
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 20:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764792599; cv=none; b=mL0jhzvbUBgdk4+oTtqCQv+My5a5gdbXXNGpCCa83UwZBuvHXZYR7G10HW6u0Udjqu0oTT1h+iWEn72FH2XBMHlZnSdlh/JZkmpcSmMK+kDm5Frg6pMd4A1jSdUVBMr0764MNMV0QqpTvKMpyTCbfHNjw4117MaNAPCMH8GGfGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764792599; c=relaxed/simple;
	bh=57wWmRPUBcL0Yfd+9Ki/fopXu/DJLG+lZGJy/kPJKhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sNUD6/Yv8mS5YsGUsvXlrozzqEL7mnuEL4rBz/kTGISfVqC2XcF19BF/sirWkk6zqStCGtum0mmcLa6vNaAR5bdODdE8VWS8DI0DUN0uyscpPjcQYPhLRow1nZ1IfiPXiDeYUVUBA1pJaPYwSDkjauoHkVnueULYKBBS33DWrGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=QiK/MRlU; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ed6882991aso1609241cf.1
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 12:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764792595; x=1765397395; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dM9kmvuGcf01lAd6S+2H7PL5yiWV5TtpfoTgVCJUhlU=;
        b=QiK/MRlUd961Yn9qEd1KTgByxcH8oWQZ2WQ2oYZ4CUxHCSRin1Yh0t2k0cNAn/mUSU
         L+gq/WP2GKWUVSqj0uy0DVlM9kFAHuQQ8cgHzgA4CqLMHQA3Ct4KGagAY6MFnVeV1Km2
         K+5R8GZBB4xmdgapvQEukeMqg1h7PKiq1OZcVpJv7/tUSeSyA1wrRvxz/7gFlJACfdz2
         U2h1cFMOChYkCuLRC8f5umOeIG+eYQYguM5TdZcWxBOQH0Rrxn8KQ2GHR5/1F4D9aH0h
         4grGYp6ceCcHQCae5xh1xwbgHBioNkU551vaO5ctfmdtkKinIKmolInmd3HOJA4253fp
         o1dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764792595; x=1765397395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dM9kmvuGcf01lAd6S+2H7PL5yiWV5TtpfoTgVCJUhlU=;
        b=F+lq9pLa6i4qCcj+TtnBeI6RjcepiYn9mlrx533Pqj6qlcsruZ6jv3rvFf+L7zHvOa
         f75V4OGHqOSnfHMhvC53zaOUj9SsKvwtsihsdz8rRMpN/axwvFNcV9Dpm0Kwt6/JkSpM
         Tq8KRjUH3DLqgeqnwRMCViDYNfrGRZijWpAyJctV/G+9/6DxO6tWzuU0VXTmuCpT2eML
         ppIeJ/SanaYL6bCZ/4WrXsffjILHmxrGgEXB9Ko5bwHVmpwBtlmeJebpbfSHuquWKBq5
         XNav3EsmO7m/VkQFbVjJo9cmc1asIrM94EF9WnjVoj+f44kC4dvbh9WtGcepVbNww80m
         5Mqg==
X-Forwarded-Encrypted: i=1; AJvYcCUqzrbVIJBIs+lUxdMKi2GFvg9nflgqeBUjR9gfW6iZl5yDAZVfXCun5vhaEpIuK3o+se4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA4a5HJHjTbVQZ+GPX1OArEMYaMwRHZVoENx6j/vS9eIOQ9PVZ
	dhQ01IFDnVwEG2pF0L4lcj71vtJo4F8Eim9MoaZhK9rvmzR7sY1qu/N38jMgsLaUixo=
X-Gm-Gg: ASbGncvCUI3qSbKwgUv3QG9EifWNJwqW2xOnEJW4ExubZUrLanghGhaTIcKTBz3BMI+
	eEYIhseUvVZINEQXM3q+Nbgg+/3xh8cYatLZ74fU+UK9kLA45kTRe96ZSbu1ia3Ub/ZYmaXB3Uo
	oBNbj0kknKFT9HjnadoNkZcFZCksuKnTxFKHFC5jYWT4N+dtiP7DOij2z1e55dq91izqmB7Pw7E
	6+xs2xRNYWdiyRkjlzpFNdy2kkD7ALOITaKI+u+4tZbOk+Z1sf60+C5GdqXNlOcnjCcyEnQZChT
	3uT075J05+TwhUFiq+n/KDgf0X4GDThyTtYCXE8TEQSStBGypmMwCBQBXeolS4tls34phED2v8J
	f53WYqJUa7fTtR0pHZUkaNxWYdhjFY2QiLVZApu8v/iv1tg2ICrz2JvUN4co9RkXAsx+sow57v8
	QBq0CUhgDDBsWRA/39EVJU4Nbm4Evw/lKrGLlfUMpxZWYvCZk7ca/EBBKC+XORjDBVv0SnYw==
X-Google-Smtp-Source: AGHT+IFswzoLbYyAnTaGWHaVOhoPJRdayisLZnLjNLq2Lu7DRCXUfj9vN9FAKPL4xYFJA51ycMkLVg==
X-Received: by 2002:ac8:574c:0:b0:4e6:df3e:2abe with SMTP id d75a77b69052e-4f023085a27mr12255981cf.9.1764792595536;
        Wed, 03 Dec 2025 12:09:55 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b8fcbesm133694426d6.54.2025.12.03.12.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 12:09:54 -0800 (PST)
Date: Wed, 3 Dec 2025 15:09:53 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	kas@kernel.org, dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com, muchun.song@linux.dev,
	osalvador@suse.de, x86@kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aTCZEcJqcgGv8Zir@gourry-fedora-PF4VCD3F>
References: <20251203063004.185182-1-gourry@gourry.net>
 <20251203173209.GA478168@cmpxchg.org>
 <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
 <CAPTztWar1KqLyUOknkf0XVnO9JOBbMxov6pHZjEm4Ou0wtSJTA@mail.gmail.com>
 <b5a925c5-523e-41e1-a3ce-0bb51ce0e995@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5a925c5-523e-41e1-a3ce-0bb51ce0e995@kernel.org>

On Wed, Dec 03, 2025 at 08:43:29PM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/3/25 19:01, Frank van der Linden wrote:
> > 
> > The PageHuge() check seems a bit out of place there, if you just
> > removed it altogether you'd get the same results, right? The isolation
> > code will deal with it. But sure, it does potentially avoid doing some
> > unnecessary work.
> 
> commit 4d73ba5fa710fe7d432e0b271e6fecd252aef66e
> Author: Mel Gorman <mgorman@techsingularity.net>
> Date:   Fri Apr 14 15:14:29 2023 +0100
> 
>     mm: page_alloc: skip regions with hugetlbfs pages when allocating 1G pages
>     A bug was reported by Yuanxi Liu where allocating 1G pages at runtime is
>     taking an excessive amount of time for large amounts of memory.  Further
>     testing allocating huge pages that the cost is linear i.e.  if allocating
>     1G pages in batches of 10 then the time to allocate nr_hugepages from
>     10->20->30->etc increases linearly even though 10 pages are allocated at
>     each step.  Profiles indicated that much of the time is spent checking the
>     validity within already existing huge pages and then attempting a
>     migration that fails after isolating the range, draining pages and a whole
>     lot of other useless work.
>     Commit eb14d4eefdc4 ("mm,page_alloc: drop unnecessary checks from
>     pfn_range_valid_contig") removed two checks, one which ignored huge pages
>     for contiguous allocations as huge pages can sometimes migrate.  While
>     there may be value on migrating a 2M page to satisfy a 1G allocation, it's
>     potentially expensive if the 1G allocation fails and it's pointless to try
>     moving a 1G page for a new 1G allocation or scan the tail pages for valid
>     PFNs.
>     Reintroduce the PageHuge check and assume any contiguous region with
>     hugetlbfs pages is unsuitable for a new 1G allocation.
> 

Worth noting that because this check really only applies to gigantic
page *reservation* (not faulting), this isn't necessarily incurred in a
time critical path.  So, maybe i'm biased here, the reliability increase
feels like a win even if the operation can take a very long time under
memory pressure scenarios (which seems like an outliar anyway).

~Gregory

