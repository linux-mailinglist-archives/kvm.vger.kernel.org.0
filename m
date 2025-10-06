Return-Path: <kvm+bounces-59525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CCDABBE001
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 14:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28A0E1891ED4
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 12:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0554027E05A;
	Mon,  6 Oct 2025 12:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="glKNsKHq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683A022128D
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 12:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759752983; cv=none; b=EhkXNua6v2W9Lun+ftLbUXW3atz2mtEznoIXWbXAMpXdexco0pCYkVGufsE00vLqmdPuWKAeL2glm770880P9MCO7j8p7zJM4/+b2hKuPHe7RdO+voa6aQIldUrp3MKlSOhRSUijYas+ISLBI5aU6Dkx8VlITDR1mSS6MppnUXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759752983; c=relaxed/simple;
	bh=18r0HQkzSwcgI73ep+fZOSbWLEQuKhP4jP5h62Ds7KA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iBiBEMLIiGmCWkzAH9Y6s9M4qg9h3ob+FKizOjtQ9v7jQOVTyL1Aq0u248zKtMQvqlr4EDKDQZ+5Ctq6d3iPc8ykqZKMxChYu7lNIBAHD24Z+z8zHVF2bZCUqVHOpPizZrU4u4HIl+60AkcqPAnrSVp9efUVVRUO5fsDKT5ouGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=glKNsKHq; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4e6d9573c2aso6947711cf.3
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 05:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1759752980; x=1760357780; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2/XVK1R0UPbW39R8bw8unhnts52CGKV4hWqxUYh+h4U=;
        b=glKNsKHq0XKW7xCU72etmQGF86E7zJgwUw+5YymRllVJJe9ges+ecCzlRDav+Z0dZk
         hGOQF+avbLMQ4Vu7lMVqy5RkjHacLz/rYj4qhqAlXwjXsddN/SK248KLq6qKNYz7gPJ8
         2ZZYYt8QKIqZWtnNkGPbhT+NsnU8b3rZmBjHJ4hNfsgIHjXwTKs2T6bZ0FsKU4A4/b6k
         bXSxcVCykFZOneEvNxxNuHV74v2+NLlNfX1e8EYExg51wThyTVBcgngRUVTw2U1KhDMw
         PYfkKdNooghNkQlBxaEzMaIQBBMqYUymAbM0cc9TDdJpDUQ5JuMooceaJ1dkXu+SM5V3
         JHjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759752980; x=1760357780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2/XVK1R0UPbW39R8bw8unhnts52CGKV4hWqxUYh+h4U=;
        b=hQLrHb9BdvhmyXycL6ZTe/aceFFBViE3SX4vlIlsq5R/DukYIxDqYoB0B8yAeaMVlN
         eRtg3i+zXaEgdeRLjMKm5qhYMuWnW7MtLRCl4UkmlRMmrVDcpPGg//cBxwfC9/3f9DR7
         3qJvJ1DRK7FQiYXKWqcMSNRBEWKptloFLw2L1/E9d9zsbNTDbXQepS/9+byZOnISD8Kb
         a8SbUFH76tRZfa88iKCHIdJOhmD0LkFZcYukpcG5kdA61qNNRaXp7xmm1+fcx4jIWLWL
         hl//q5ID3vQX4qBh4qIBcB9DgnyEeWRIQ3ziBDzsi5JeuIKcZFJ2pTYMJqSixpTSZaOu
         V3Cg==
X-Forwarded-Encrypted: i=1; AJvYcCV4VpGHWfPw3BtJ2ui6FxG9FY7LcmQ6EzoYpfxYeCUTnvt8WN6TMLSBjy57E/+nTNZFP/E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBdo2jNeZNldE0CckEYsnZ03f8M/HCwZGNdoSglO3ME071lgk+
	b3loJkomcJVzsXIsHrWPTsGTejK6iSdYH9xoVf91C5gb3I8USF0qXX4GTwOigYJJVkALcaHQ9PA
	93/I2UTE=
X-Gm-Gg: ASbGncvMugaahrP58K8ENio6QLHAftkmcjHMeLbnXBsXVLlb7lU/xp9Tc99kFMiKauk
	+9oQkx2R4OcAB2JXn+7e3H/0+OO02keom0dDokQoAcLq7CMRtoeFNonK6fyjePQZG/OfQ9T5uep
	YkHIHqmzqLk9EftnH3VmjYzXL4CKw0GvfXUkYfu2h63Hu8I1Pc4qMevr+BD33/y+NCpGaLMXcap
	TcEoM0VZ4hu1lk4y1/go5UoHR/NGy88yCE4OQV0Y7dTTHHtq0CPy4CnSSIpBL46FtJjkWx9HpED
	p4K8Y0yM5BBkZCjIe8fQD2as3ApSs2IFKEVTwxy50teVNEmWy1IOBgGb/33VdzxdJ7Snt+xCNSW
	cEAqfLHngdh6AilQm+j7dqdxmfaaLSmG6eHPlcGEvkDVIek1pVdNV0ICAJimNQiwcWU/WNToAWd
	Re/2wKgaZ2CARIxMIb4Uro1JJh2Sg=
X-Google-Smtp-Source: AGHT+IHHE/cXeP5n6eP+zy1nV9e5JfVEW4+WPPt2lQBPbies4CCCoOlEMX7n35sZH/VeOrDgIO4ZYg==
X-Received: by 2002:a05:622a:83:b0:4b5:e7e4:ba74 with SMTP id d75a77b69052e-4e576b22551mr158847341cf.56.1759752980019;
        Mon, 06 Oct 2025 05:16:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e58a7f098bsm55878991cf.28.2025.10.06.05.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 05:16:19 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v5k8Y-0000000EPl0-2nb0;
	Mon, 06 Oct 2025 09:16:18 -0300
Date: Mon, 6 Oct 2025 09:16:18 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: fix VFIO_IOMMU_UNMAP_DMA when end of range would
 overflow u64
Message-ID: <20251006121618.GA3365647@ziepe.ca>
References: <20251005-fix-unmap-v1-1-6687732ed44e@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251005-fix-unmap-v1-1-6687732ed44e@fb.com>

On Sun, Oct 05, 2025 at 08:38:42PM -0700, Alex Mastro wrote:
> vfio_find_dma_first_node is called to find the first dma node to unmap
> given an unmap range of [iova..iova+size). The check at the end of the
> function intends to test if the dma result lies beyond the end of the
> unmap range. The condition is incorrectly satisfied when iova+size
> overflows to zero, causing the function to return NULL.
> 
> The same issue happens inside vfio_dma_do_unmap's while loop.
> 
> Fix by comparing to the inclusive range end, which can be expressed
> by u64.
> 
> This bug was discovered after querying for vfio_iova_range's via
> VFIO_IOMMU_GET_INFO, making a VFIO_IOMMU_MAP_DMA inside the last range,
> and then attempting to unmap the entirety of the last range i.e.
> VFIO_IOMMU_UNMAP_DMA(iova=r.start, size=r.end-r.start+1).
> 
> ---
> I don't think iommufd is susceptible to the same issue since
> iopt_unmap_iova computes the inclusive end using checked addition, and
> iopt_unmap_iova_range acts on an inclusive range.

Yeah, iommufd was careful to use inclusive ranges so that ULONG_MAX
can be a valid IOVA.

This doesn't seem complete though, if the range ends at the ULONG_MAX
then these are not working either:

		if (start < dma->iova + dma->size) {

?

And I see a few more instances like that eg in
vfio_iova_dirty_bitmap(), vfio_dma_do_unmap(), vfio_iommu_replay()

Jason

