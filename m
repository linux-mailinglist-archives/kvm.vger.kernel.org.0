Return-Path: <kvm+bounces-49877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B5CFADEDBE
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 15:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD9677A3912
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15FF02E88BF;
	Wed, 18 Jun 2025 13:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ODoUUCEB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84FA27FB3C
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750253036; cv=none; b=loSOrHKGXenf7atD2oUVoJg7QntYzFs7bEUtQ5S11w33haC1BEEmlVqdLpgmqMqkjP0Go+ZOxr6gtkIkOhfjZub0l9LYE+DDQabUHFx3VJ5MvR9VU5vVXFXSO4y56AP9hsOVy4n+m+RzwMpNZkO/CFg9+DVwYF0vGGBP4dSy0dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750253036; c=relaxed/simple;
	bh=PvNMR4Bh/5U5Yys/GdOvZjrfjw6pCcuAC88NwswDtWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQuoUYw6TdwfZKJFxFH5IPLHD2vtPTkj849T5webuGZQYOQmH8g7oHPaChEU/K4DpUMTaffxLcNKpGhkU7J4gkeuHdA5mHoIgyn1/gHwoapehpj5ZYnbKOgCcD8OwOgU6J2jLJ0aLidJBdlFNWn8g43h2VR8OfStp/fkunhTTZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ODoUUCEB; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7d0a0bcd3f3so85188585a.1
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 06:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1750253033; x=1750857833; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KqEK20OUV+YC6Bkjm5qN0J00zk2Z0hjMnTZBJHjERP0=;
        b=ODoUUCEBtrq+abCrKoYac2EwlKv6l+i3XXze2+LsSwyUJZjaUi28RG6nWBVYMU6Qba
         FpR30KM18JbEhNiNfABLzeM8P271Z61ov8xWMXyVUwE6U0nnm8LLC7/ZUvHKdd02BpV+
         y26JJW0j1KYtxczgePmuWkuVJFX9JmWOUf3FtF8ADpWCugkGWfHa1sw6f3TO3iZoS4K6
         Ci19eTzQikGc4aJ/JVUPoXJIKNI2Q/hvQcuujCl/L3iEKgMpHpS19/TVa8qq8OpI4Kkq
         lBqMdZ1KtMD0BppRc2J9PNHtxgCW5OBKhlZfQ8lP6R+Ab/wmDMGoDjpwhtvmj2Uzc2D2
         g1Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750253033; x=1750857833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KqEK20OUV+YC6Bkjm5qN0J00zk2Z0hjMnTZBJHjERP0=;
        b=ZzdMGW1NtQ8uP/k62P8tZkyBsArwffjQqwK7asZYLCgCBWIY9A2keoxcFtuRlFuhxC
         ZVKvHC4Cvw9XCHf5faARmzW4QgA7rPOdzUc3nQt6tCSBhPRiI71BqvU54ZwcAJS8v77+
         TPl8/6gOzvJFoLfxAxL6lG62iCLSdLNQ+N1bA8/PuLxVfKeyBGipBoGx4C5QLKU0Cd/y
         I1wnhpQENSmf+zQf7TdW/l3o/AjEtJjuUxDxF8fRwKJQCIOOxyyAA9OY9rjaqw5SF/Ia
         KMWN59OI38MDcRw1HNDBUcoeQf+SdgtfMrY1oRT2G6mi2Tajxke4OfJyQvRAK6lN8qef
         9cZw==
X-Forwarded-Encrypted: i=1; AJvYcCXBIFgjau+hIVQOXS/4IzTWXLB3fFn/fqK+5VRPo/Y7frF7h9+QaMhhZOuWhYDXvW1Ko1c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzI4MewxJIgE7fSRtAUNZuqB/bmZyd1keyLtwIMSBwbcaf5WbBj
	Gn4x+lEEpCAM0kNa98eLOSzCow6Amofj3G0HIi6tzCOBw3V5wFZKBYhjxv3FwAbCBFo=
X-Gm-Gg: ASbGnctNV77JPYsORZWUTEEEInr+ENvTLCRcoIFQ5cl7f8lt6zR0maxGbaWVbZgX8Zv
	LEad3ErEMJgsSSioiLXXPe1WO4k+lRPrisQHvXHb+fs4+3UmoLQAljyE4Gg4mxwym9LVTCOM03u
	4PF4J/KcJI7F1XEqSUgTEYDsaBohiJESpWsAQ1k2pCwg7lpz7it0GPQL+eHlMf80ZLwW4pFdjLM
	JwiQ7id8QXO6BFrqYBgb1DNR9sluzykK7eIDEx6cNtmXQ7hTQ+5+J/tF28XuRGBPSd6JG4bVwky
	YMZEO3opROUSCMjXgxFqAgk/i+HTgS5bXnMFUogprfOBS461JkkPTR3lCZFJZGuRcEgSShEV/tD
	CGxKMYm5ffdcz9s/f0ii0ArwYjgVuwxUGFF3Lxw==
X-Google-Smtp-Source: AGHT+IF9NkUjCA8uk6HKiAeyvH8TKX/0/ivDtPkHXPD3WCNV0m99YeZSjC4tka6Wctd9mMDXm8kpLA==
X-Received: by 2002:a05:620a:2621:b0:7cf:5cdb:7b68 with SMTP id af79cd13be357-7d3e9219d0bmr390160385a.0.1750253032707;
        Wed, 18 Jun 2025 06:23:52 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3b8eac910sm769806485a.72.2025.06.18.06.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 06:23:51 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uRsla-00000006mvn-29y8;
	Wed, 18 Jun 2025 10:23:50 -0300
Date: Wed, 18 Jun 2025 10:23:50 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: lizhe.67@bytedance.com
Cc: david@redhat.com, akpm@linux-foundation.org, alex.williamson@redhat.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, peterx@redhat.com
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
Message-ID: <20250618132350.GN1376515@ziepe.ca>
References: <20250618115622.GM1376515@ziepe.ca>
 <20250618121928.36287-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618121928.36287-1-lizhe.67@bytedance.com>

On Wed, Jun 18, 2025 at 08:19:28PM +0800, lizhe.67@bytedance.com wrote:
> On Wed, 18 Jun 2025 08:56:22 -0300, jgg@ziepe.ca wrote:
>  
> > On Wed, Jun 18, 2025 at 01:52:37PM +0200, David Hildenbrand wrote:
> > 
> > > I thought we also wanted to optimize out the
> > > is_invalid_reserved_pfn() check for each subpage of a folio.
> 
> Yes, that is an important aspect of our optimization.
> 
> > VFIO keeps a tracking structure for the ranges, you can record there
> > if a reserved PFN was ever placed into this range and skip the check
> > entirely.
> > 
> > It would be very rare for reserved PFNs and non reserved will to be
> > mixed within the same range, userspace could cause this but nothing
> > should.
> 
> Yes, but it seems we don't have a very straightforward interface to
> obtain the reserved attribute of this large range of pfns.

vfio_unmap_unpin()  has the struct vfio_dma, you'd store the
indication there and pass it down.

It already builds the longest run of physical contiguity here:

		for (len = PAGE_SIZE; iova + len < end; len += PAGE_SIZE) {
			next = iommu_iova_to_phys(domain->domain, iova + len);
			if (next != phys + len)
				break;
		}

And we pass down a physically contiguous range to
unmap_unpin_fast()/unmap_unpin_slow().

The only thing you need to do is to detect reserved in
vfio_unmap_unpin() optimized flag in the dma, and break up the above
loop if it crosses a reserved boundary.

If you have a reserved range then just directly call iommu_unmap and
forget about any page pinning.

Then in the page pinning side you use the range version.

Something very approximately like the below. But again, I would
implore you to just use iommufd that is already much better here.

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 1136d7ac6b597e..097b97c67e3f0d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -738,12 +738,13 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 	long unlocked = 0, locked = 0;
 	long i;
 
+	/* The caller has already ensured the pfn range is not reserved */
+	unpin_user_page_range_dirty_lock(pfn_to_page(pfn), npage,
+					 dma->prot & IOMMU_WRITE);
 	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
-		if (put_pfn(pfn++, dma->prot)) {
 			unlocked++;
 			if (vfio_find_vpfn(dma, iova))
 				locked++;
-		}
 	}
 
 	if (do_accounting)
@@ -1082,6 +1083,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	while (iova < end) {
 		size_t unmapped, len;
 		phys_addr_t phys, next;
+		bool reserved = false;
 
 		phys = iommu_iova_to_phys(domain->domain, iova);
 		if (WARN_ON(!phys)) {
@@ -1089,6 +1091,9 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 			continue;
 		}
 
+		if (dma->has_reserved)
+			reserved = is_invalid_reserved_pfn(phys >> PAGE_SHIFT);
+
 		/*
 		 * To optimize for fewer iommu_unmap() calls, each of which
 		 * may require hardware cache flushing, try to find the
@@ -1098,21 +1103,31 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 			next = iommu_iova_to_phys(domain->domain, iova + len);
 			if (next != phys + len)
 				break;
+			if (dma->has_reserved &&
+			    reserved != is_invalid_reserved_pfn(next >> PAGE_SHIFT))
+				break;
 		}
 
 		/*
 		 * First, try to use fast unmap/unpin. In case of failure,
 		 * switch to slow unmap/unpin path.
 		 */
-		unmapped = unmap_unpin_fast(domain, dma, &iova, len, phys,
-					    &unlocked, &unmapped_region_list,
-					    &unmapped_region_cnt,
-					    &iotlb_gather);
-		if (!unmapped) {
-			unmapped = unmap_unpin_slow(domain, dma, &iova, len,
-						    phys, &unlocked);
-			if (WARN_ON(!unmapped))
-				break;
+		if (reserved) {
+			unmapped = iommu_unmap(domain->domain, iova, len);
+			*iova += unmapped;
+		} else {
+			unmapped = unmap_unpin_fast(domain, dma, &iova, len,
+						    phys, &unlocked,
+						    &unmapped_region_list,
+						    &unmapped_region_cnt,
+						    &iotlb_gather);
+			if (!unmapped) {
+				unmapped = unmap_unpin_slow(domain, dma, &iova,
+							    len, phys,
+							    &unlocked);
+				if (WARN_ON(!unmapped))
+					break;
+			}
 		}
 	}
 

