Return-Path: <kvm+bounces-38181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53BEFA3643A
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 18:17:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B69C16BBA9
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 17:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D21267729;
	Fri, 14 Feb 2025 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dsJq+BYM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B768E17555
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739553463; cv=none; b=I0Lad+wJimx0F80RttllOgp8l3QMN5dREPFhETrBAsXwSmsRszS4qV6Uq0eAYuV9Jp1R0mYzFP9EysEFBl42PGl76mWd1DQa+w3Fmw323MvjjYvm70eebN+WUH4VbrQmBEfXYLWUDoPkCQcqmdtPtvdo90bmNX9D5ifky+svWwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739553463; c=relaxed/simple;
	bh=hSKHANdhOa4GbGIBCUy5VHKi/BUtKMbSGMapb2R/3v4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=soXiefviaNHeDfcjSKs8NDXkwdNRqFR7X1KwH8W+evf58aqpHEHBQBocxB6jh9zNJnDz0qphVvTZES1SiPh3odks/rj9rxSivtH/wGJh1AsoMmCtZSzgTXtZaJtc/vudOQKjSXAyu2jvg/W+OBjlN8pijuy6jpAzcj2LlAd4gx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dsJq+BYM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739553460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vPfsF1K7YUp9R9mQX+7RKyz57Btz7H8JUY3WuYwgCK4=;
	b=dsJq+BYM1op0k9I5u8G9noHCO6/bwTSyLtEUAFVzhV6ZjCOuzWj1a8yzT9LK13KNHW5nDs
	HfdIJHDUe5GgajbhCz0a83D+ezzBdRCEkRYcKYgAKLR5Qfhl/1n1XUILMRFdcRLxqQ/ioY
	CObZwuDgcWAVFpPvHSh27POAU3Zbm1E=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-iylGFjZJOXOe-gvtWHyYMQ-1; Fri, 14 Feb 2025 12:17:39 -0500
X-MC-Unique: iylGFjZJOXOe-gvtWHyYMQ-1
X-Mimecast-MFC-AGG-ID: iylGFjZJOXOe-gvtWHyYMQ_1739553458
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8556de861d4so2909139f.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 09:17:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739553458; x=1740158258;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vPfsF1K7YUp9R9mQX+7RKyz57Btz7H8JUY3WuYwgCK4=;
        b=us+S7c02gRBBOi4xaeiFNB17ur1FZWDg+e219T4y5h79F1bOU9oAoqil/OoMj5nTjv
         lEWT2KsM7LEv3bHYxJde8aqeXOqi/6bUBq0tFvJUFEvo6wfo1GArihL9XpwDuV3/Uvjo
         PQXuNjanoZTZxMuOy4CtDtyzIscavRbVYAJIptDiFU0iNlJwC19L3SxPWkntsToBOYCS
         OC/6ptArjH47AY0gMvgf2tI8ecR+FxuU0ptBTs9ZD+6p0cLe4+O9v5VDQU+Am5Uh8Ov7
         1WYi7TF+U0HEGC4U8/Zfol5MeBk9QFffJCMLrQ6le0MhAV92nPwYLO4VMKSQ+Xa1y/Ss
         77LQ==
X-Gm-Message-State: AOJu0Yyg509066Rj25uSCQ+y03lnYMcdxT36FbqP6lc4VjdgyUzdNSxO
	khMwuHQ+R0aPv7DWcBd2/L222HG9jG9C9hUDzo9kh+PWoZ1mvuNap0AaBfECT+OxMB9ldYZv68B
	FtYT4k8ckL0twiNSxoDi0v8Xvvguxx7M1j+w8gdnyGx8HaOw/iQ==
X-Gm-Gg: ASbGncshV9pVc4o/Lc9tpTzTym7GoFlaJwKfQMdM+doGCQyWd+VRow4vqEPye0UOqAg
	KDRtCWMigWrWgM9ASctY38zda6EDFautfsWCGQ1E6SmLLGynwTpq5ppc56fl0V7jvb0GygPgBVy
	AI3NQ64XR30Dgh85d9sDxHJ/qjKvlCWLTbBBKbeZjzeAMy9blV5xGY4OIDC11MHJBpQ01xMBiTN
	C3WQJ6Mg/GsVv3nDnQO3oeisP2Y3N7qjZQD5ndc73n3yRgCUCoIUZylES00W2d9GUWgEywLGGHh
	qiUaiJNs
X-Received: by 2002:a05:6e02:1d13:b0:3d1:8bf1:46f9 with SMTP id e9e14a558f8ab-3d280987dcdmr318255ab.7.1739553458417;
        Fri, 14 Feb 2025 09:17:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG0Qz9VO3Ey/mEXhAHSN+HIg08dAc+H18Eqqwc7ITCwAustrikXMJraW28xXpxtim+2NFB8yg==
X-Received: by 2002:a05:6e02:1d13:b0:3d1:8bf1:46f9 with SMTP id e9e14a558f8ab-3d280987dcdmr318125ab.7.1739553458021;
        Fri, 14 Feb 2025 09:17:38 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed282d7b4bsm902182173.115.2025.02.14.09.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 09:17:37 -0800 (PST)
Date: Fri, 14 Feb 2025 10:17:35 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
 mitchell.augustin@canonical.com, clg@redhat.com, akpm@linux-foundation.org,
 linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 4/5] mm: Provide page mask in struct follow_pfnmap_args
Message-ID: <20250214101735.4b180123.alex.williamson@redhat.com>
In-Reply-To: <20250205231728.2527186-5-alex.williamson@redhat.com>
References: <20250205231728.2527186-1-alex.williamson@redhat.com>
	<20250205231728.2527186-5-alex.williamson@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Nudge.  Peter Xu provided an R-b for the series.  Would any other mm
folks like to chime in here to provide objection or approval for this
change and merging it through the vfio tree?  Series[1].  Thanks!

Alex

[1]https://lore.kernel.org/all/20250205231728.2527186-1-alex.williamson@redhat.com/

On Wed,  5 Feb 2025 16:17:20 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> follow_pfnmap_start() walks the page table for a given address and
> fills out the struct follow_pfnmap_args in pfnmap_args_setup().
> The page mask of the page table level is already provided to this
> latter function for calculating the pfn.  This page mask can also be
> useful for the caller to determine the extent of the contiguous
> mapping.
> 
> For example, vfio-pci now supports huge_fault for pfnmaps and is able
> to insert pud and pmd mappings.  When we DMA map these pfnmaps, ex.
> PCI MMIO BARs, we iterate follow_pfnmap_start() to get each pfn to test
> for a contiguous pfn range.  Providing the mapping page mask allows us
> to skip the extent of the mapping level.  Assuming a 1GB pud level and
> 4KB page size, iterations are reduced by a factor of 256K.  In wall
> clock time, mapping a 32GB PCI BAR is reduced from ~1s to <1ms.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  include/linux/mm.h | 2 ++
>  mm/memory.c        | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b1c3db9cf355..0ef7e7a0b4eb 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2416,11 +2416,13 @@ struct follow_pfnmap_args {
>  	 * Outputs:
>  	 *
>  	 * @pfn: the PFN of the address
> +	 * @pgmask: page mask covering pfn
>  	 * @pgprot: the pgprot_t of the mapping
>  	 * @writable: whether the mapping is writable
>  	 * @special: whether the mapping is a special mapping (real PFN maps)
>  	 */
>  	unsigned long pfn;
> +	unsigned long pgmask;
>  	pgprot_t pgprot;
>  	bool writable;
>  	bool special;
> diff --git a/mm/memory.c b/mm/memory.c
> index 398c031be9ba..97ccd43761b2 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6388,6 +6388,7 @@ static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
>  	args->lock = lock;
>  	args->ptep = ptep;
>  	args->pfn = pfn_base + ((args->address & ~addr_mask) >> PAGE_SHIFT);
> +	args->pgmask = addr_mask;
>  	args->pgprot = pgprot;
>  	args->writable = writable;
>  	args->special = special;


