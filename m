Return-Path: <kvm+bounces-49953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E284AE014F
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 11:09:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E40D9176BFF
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 09:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C664275119;
	Thu, 19 Jun 2025 09:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="jVG4T8M6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6587C26563C
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 09:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750323952; cv=none; b=joUIn6EPNfgBkoaND7KS0jmRkO7YlI/r5vUuYS+K/9w+8VXpnQRJghvmm3twmfSQ1/l4qlllM6R3OXi7vItrzB5eUAk8O4OnGXjqKfL9gp3GmA6AqAOpAKidYDUgPY6PilVsXYNV43xSaZM/pCaYhVShUo507lejb47yNbzagIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750323952; c=relaxed/simple;
	bh=R2MdderHD37B5kZdDB7xmVx02o4SKXcm4hSPWmQvgGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcsPwrQ3QVgeiFHR/bI2EgJtVM86h7El8atRPRuo/9tGyarf30Ov9Dfg9gCGhUKDNiTtySsHbyGDepEuCKE4p+omWyOCaPG57bSF+jVN3LsxDHZqHq1Qs+y6YKU57ocxWM6lQ9lkO30a9nxNXfs6FECLbcQDv281ZLMiNQl3Esw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=jVG4T8M6; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2363616a1a6so4143025ad.3
        for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 02:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750323950; x=1750928750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mfEj13GmETbHleU7k23uUEwgHyxddQ3h/WE7nkRP6/w=;
        b=jVG4T8M6kF62+TC330U10vnsL46veveohz3p8s7D81TyxojPuYvFcjtaKsEkK6lFHc
         aAZo7+Ijju1Nd5BOsQYh7h+ArvBCPHfP14Vt5ExNn+ybkKF1FpOnz2//0CqBPnNHMrvE
         6q3ZSSfymtmEt/ChJR6i+Aoct4DUHaZYs5/r1quTwJIh6UUD4KRLcBnWcwpFx2OMZ+/n
         NV7tAs9fl8z7AChz9DrW2OvDNAtVCojArQ9DtvpgGSotGpJJld++sAtdpqedlj8+Pc0V
         vCnZgfr99gXQqI/jJddljOdNnEqIgw8nAhiAKpKIWEW4U5RDISAPqM4Lwk3oN6LVOaIs
         EUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750323950; x=1750928750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mfEj13GmETbHleU7k23uUEwgHyxddQ3h/WE7nkRP6/w=;
        b=Gyr9gIs640jZmJ7mLJI5SACm80W2kFzm2dLEE04Iwyo6EMuCgSRkgRvusYMMu/pqKh
         +3aChh+jMhbgi2S6w1N0SChpxsen69tS63l9LPWYNIntU0CO8Rwr9IR0paoQFT1R3X4x
         1/J8MBbTraF9ccPgwN1UBsuCMabj+MTDmhCuMnpyJxYUqiHFnCSC+Qt2sXFn3E/NZFuZ
         Ax9jJ2YGB4OwMA3q0FdD+nhjo/d94IFf8WDUwEMBa5KUtU6PxVWoTECbr5oDYVIK7By0
         Y4WNmKkJ2pFGA1hj/NiikN/ttK6IjTKU9rUbvvyQT4d3I4oVp3tJNgEGApJoMmO3nY4u
         2ykg==
X-Forwarded-Encrypted: i=1; AJvYcCVfxq//xQZeERrQzpMxWDJ9vXGHo5Z2R0Iuuv5Rhf8pm4SXZTV2228Sb5p1Be1C8I3TC9U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmCbjjtny9SrKnCCb+vk/l0iIm+LxvjLqzzqjXXIuUzPKd+dex
	CmNAVwSlRGLxKUoCK32rXVs0Cbvz3Ki5fyRyQtvnS8zoa9+iAh+YF7R0+UMyq7COWnc=
X-Gm-Gg: ASbGncsi3y/6qLiBiZC3ZR6yHaRR5F9cRqpavY/70pxvaZtvB+Uq3K5R2PdKGiudZLx
	10zI0jGIisGguxmJPdk/Q/5i7rJo4f10k6yvylfe+6Dw0T/NgCA+wKt0r0uxnC3F5vsRFU8aZl2
	tCX8ALTYSboPmUEdYhkgMd9JvMKoAwotBJMsmud06nzMCOLkaezcVGoLJlLjwvMAQhj78HaM9r8
	V+Kl/DcpVDR7e7r921BHqJl+lxJYorE33rY94NXtDSS2PVP8/XroVNT7rq0dtywx6jpNu8VnopR
	Dr6x1P5bw9N09/aVk3W6E6XMAL82ZardPnCyiPEVp0djOd6LqUW1y6eovHiNYTel4Xy1ajbvEVQ
	XBjQZE3XnKCP5/pIjKhmtmuPt
X-Google-Smtp-Source: AGHT+IGgCZ8jvC5dY+tN8FHUTD6GFnoyLq4Y6HViY2JoldX5ANX6ETUtF80xyLqeVCd4I3vsa8LojQ==
X-Received: by 2002:a17:90b:3fcd:b0:311:be51:bde8 with SMTP id 98e67ed59e1d1-313f1cb52cfmr30251738a91.20.1750323949551;
        Thu, 19 Jun 2025 02:05:49 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.13])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3158a12c32esm1647633a91.0.2025.06.19.02.05.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Jun 2025 02:05:49 -0700 (PDT)
From: lizhe.67@bytedance.com
To: jgg@ziepe.ca,
	david@redhat.com
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
Date: Thu, 19 Jun 2025 17:05:42 +0800
Message-ID: <20250619090542.29974-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250618132350.GN1376515@ziepe.ca>
References: <20250618132350.GN1376515@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 18 Jun 2025 10:23:50 -0300, jgg@ziepe.ca wrote:
 
> On Wed, Jun 18, 2025 at 08:19:28PM +0800, lizhe.67@bytedance.com wrote:
> > On Wed, 18 Jun 2025 08:56:22 -0300, jgg@ziepe.ca wrote:
> >  
> > > On Wed, Jun 18, 2025 at 01:52:37PM +0200, David Hildenbrand wrote:
> > > 
> > > > I thought we also wanted to optimize out the
> > > > is_invalid_reserved_pfn() check for each subpage of a folio.
> > 
> > Yes, that is an important aspect of our optimization.
> > 
> > > VFIO keeps a tracking structure for the ranges, you can record there
> > > if a reserved PFN was ever placed into this range and skip the check
> > > entirely.
> > > 
> > > It would be very rare for reserved PFNs and non reserved will to be
> > > mixed within the same range, userspace could cause this but nothing
> > > should.
> > 
> > Yes, but it seems we don't have a very straightforward interface to
> > obtain the reserved attribute of this large range of pfns.
> 
> vfio_unmap_unpin()  has the struct vfio_dma, you'd store the
> indication there and pass it down.
> 
> It already builds the longest run of physical contiguity here:
> 
> 		for (len = PAGE_SIZE; iova + len < end; len += PAGE_SIZE) {
> 			next = iommu_iova_to_phys(domain->domain, iova + len);
> 			if (next != phys + len)
> 				break;
> 		}
> 
> And we pass down a physically contiguous range to
> unmap_unpin_fast()/unmap_unpin_slow().
> 
> The only thing you need to do is to detect reserved in
> vfio_unmap_unpin() optimized flag in the dma, and break up the above
> loop if it crosses a reserved boundary.
> 
> If you have a reserved range then just directly call iommu_unmap and
> forget about any page pinning.
> 
> Then in the page pinning side you use the range version.
> 
> Something very approximately like the below. But again, I would
> implore you to just use iommufd that is already much better here.

Thank you for your suggestion. We are also working on this, but
it is not something that can be completed in a short time. In
the near term, we are still expected to use the type1 method.

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 1136d7ac6b597e..097b97c67e3f0d 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -738,12 +738,13 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>  	long unlocked = 0, locked = 0;
>  	long i;
>  
> +	/* The caller has already ensured the pfn range is not reserved */
> +	unpin_user_page_range_dirty_lock(pfn_to_page(pfn), npage,
> +					 dma->prot & IOMMU_WRITE);
>  	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
> -		if (put_pfn(pfn++, dma->prot)) {
>  			unlocked++;
>  			if (vfio_find_vpfn(dma, iova))
>  				locked++;
> -		}
>  	}
>  
>  	if (do_accounting)
> @@ -1082,6 +1083,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  	while (iova < end) {
>  		size_t unmapped, len;
>  		phys_addr_t phys, next;
> +		bool reserved = false;
>  
>  		phys = iommu_iova_to_phys(domain->domain, iova);
>  		if (WARN_ON(!phys)) {
> @@ -1089,6 +1091,9 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  			continue;
>  		}
>  
> +		if (dma->has_reserved)
> +			reserved = is_invalid_reserved_pfn(phys >> PAGE_SHIFT);
> +
>  		/*
>  		 * To optimize for fewer iommu_unmap() calls, each of which
>  		 * may require hardware cache flushing, try to find the
> @@ -1098,21 +1103,31 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  			next = iommu_iova_to_phys(domain->domain, iova + len);
>  			if (next != phys + len)
>  				break;
> +			if (dma->has_reserved &&
> +			    reserved != is_invalid_reserved_pfn(next >> PAGE_SHIFT))
> +				break;
>  		}
>  
>  		/*
>  		 * First, try to use fast unmap/unpin. In case of failure,
>  		 * switch to slow unmap/unpin path.
>  		 */
> -		unmapped = unmap_unpin_fast(domain, dma, &iova, len, phys,
> -					    &unlocked, &unmapped_region_list,
> -					    &unmapped_region_cnt,
> -					    &iotlb_gather);
> -		if (!unmapped) {
> -			unmapped = unmap_unpin_slow(domain, dma, &iova, len,
> -						    phys, &unlocked);
> -			if (WARN_ON(!unmapped))
> -				break;
> +		if (reserved) {
> +			unmapped = iommu_unmap(domain->domain, iova, len);
> +			*iova += unmapped;
> +		} else {
> +			unmapped = unmap_unpin_fast(domain, dma, &iova, len,
> +						    phys, &unlocked,
> +						    &unmapped_region_list,
> +						    &unmapped_region_cnt,
> +						    &iotlb_gather);
> +			if (!unmapped) {
> +				unmapped = unmap_unpin_slow(domain, dma, &iova,
> +							    len, phys,
> +							    &unlocked);
> +				if (WARN_ON(!unmapped))
> +					break;
> +			}
>  		}
>  	}

As I understand it, there seem to be some issues with this
implementation. How can we obtain the value of dma->has_reserved
(acquiring it within vfio_pin_pages_remote() might be a good option)
and ensure that this value remains unchanged from the time of
assignment until we perform the unpin operation? I've searched
through the code and it appears that there are instances where
SetPageReserved() is called outside of the initialization phase.
Please correct me if I am wrong.

Thanks,
Zhe

