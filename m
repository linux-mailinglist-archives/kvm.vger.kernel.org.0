Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8212A6605AC
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 18:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjAFR0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 12:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235610AbjAFRZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 12:25:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26177D9C5
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 09:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673025897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uRJJdpda2LberW2Uz7MtJU0ApzokqFKrYHUptCsTqd0=;
        b=gHnoxtaTv/WX35tiQ34VNvC7VqEiwWsyKpA7DHRo8xLTKz4R56qw5Jz3dVljyilTSlh8jy
        jKKSDESj2oa8wiy0Q/DNKCKRCgaN/QW6CdNEu4N66sdGrRucV3V9dKL5arTB1V/qxs+lbV
        JaWQ52Inzh+83oodhnVDlIW5Vha3fQU=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-411-s7cGtJ-bMW-2psjpcRHj0g-1; Fri, 06 Jan 2023 12:24:55 -0500
X-MC-Unique: s7cGtJ-bMW-2psjpcRHj0g-1
Received: by mail-il1-f199.google.com with SMTP id h4-20020a056e021b8400b0030d901a84d9so520010ili.6
        for <kvm@vger.kernel.org>; Fri, 06 Jan 2023 09:24:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uRJJdpda2LberW2Uz7MtJU0ApzokqFKrYHUptCsTqd0=;
        b=YmN8CSk+Q4ulxi7vglJ3WJwnbc9eBr0Yht47MaL4mE3FpHQzi/6hliiC/yk93mr1+K
         FmFgrPDbHWrEV36ohb2P0Nj7Q31M5CjMDkVxdDeEXqI+G1TluMXu+GDPR97GuB6XgbwM
         cccCFKoGe+JfHyKn7u0qNcSYLbmKcvu4iNpKxs02BcelnJqcvK0EK4bmlYMp/OoJ33n/
         yeuGxL5y8tYbZUSL9UO1B5f0xlOXbxQbDbahJYG/2/9aWAxRR5DjJVpM5m7+CpFigz+F
         Oy3wS7Ab0LYPgCRToNbpeJSul2g8JCZI7HOfjNKf8A7/Tx/x6/hFAb8FG3ThDNgHZJSe
         tvGg==
X-Gm-Message-State: AFqh2kpgHswxGYZkK4cWgOUvsr+gZserrLfknrLG2wAl62daRaK0lEWb
        JZBDI3NQGKmJA1H6DaHrkFoX3bFG1TmKwB8K1cNP1jwGJcJi8YNLZ+tL9rge26/DDF70ejHSBBo
        9taEW5O1GW9N3
X-Received: by 2002:a05:6e02:105:b0:30c:8559:9d33 with SMTP id t5-20020a056e02010500b0030c85599d33mr8126737ilm.3.1673025894893;
        Fri, 06 Jan 2023 09:24:54 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtaheVCMJsd6UkYBpmwqPt3EuW+qeUOqMou/3T67c+kqzqmdM7Q68FRZUlmkLIekfUKA50HbA==
X-Received: by 2002:a05:6e02:105:b0:30c:8559:9d33 with SMTP id t5-20020a056e02010500b0030c85599d33mr8126722ilm.3.1673025894562;
        Fri, 06 Jan 2023 09:24:54 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a17-20020a056e020e1100b0030c186ea94fsm522963ilk.55.2023.01.06.09.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 09:24:53 -0800 (PST)
Date:   Fri, 6 Jan 2023 10:24:50 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Christian =?UTF-8?B?Qm9ybnRyw6RnZXI=?= 
        <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] vfio/type1: Respect IOMMU reserved regions in
 vfio_test_domain_fgsp()
Message-ID: <20230106102450.2e6c70bb.alex.williamson@redhat.com>
In-Reply-To: <20230104154202.1152198-2-schnelle@linux.ibm.com>
References: <20230104154202.1152198-1-schnelle@linux.ibm.com>
        <20230104154202.1152198-2-schnelle@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  4 Jan 2023 16:42:02 +0100
Niklas Schnelle <schnelle@linux.ibm.com> wrote:

> Since commit cbf7827bc5dc ("iommu/s390: Fix potential s390_domain
> aperture shrinking") the s390 IOMMU driver uses reserved regions for the

Are you asking for this in v6.2?  Seems like the above was introduced
in v6.2 and I can't tell if this is sufficiently prevalent that we need
a fix in the same release.

> system provided DMA ranges of PCI devices. Previously it reduced the
> size of the IOMMU aperture and checked it on each mapping operation.
> On current machines the system denies use of DMA addresses below 2^32 for
> all PCI devices.
> 
> Usually mapping IOVAs in a reserved regions is harmless until a DMA
> actually tries to utilize the mapping. However on s390 there is
> a virtual PCI device called ISM which is implemented in firmware and
> used for cross LPAR communication. Unlike real PCI devices this device
> does not use the hardware IOMMU but inspects IOMMU translation tables
> directly on IOTLB flush (s390 RPCIT instruction). If it detects IOVA
> mappings outside the allowed ranges it goes into an error state. This
> error state then causes the device to be unavailable to the KVM guest.
> 
> Analysing this we found that vfio_test_domain_fgsp() maps 2 pages at DMA
> address 0 irrespective of the IOMMUs reserved regions. Even if usually
> harmless this seems wrong in the general case so instead go through the
> freshly updated IOVA list and try to find a range that isn't reserved,
> and fits 2 pages, is PAGE_SIZE * 2 aligned. If found use that for
> testing for fine grained super pages.
> 
> Fixes: 6fe1010d6d9c ("vfio/type1: DMA unmap chunking")

Nit, the above patch pre-dates any notion of reserved regions, so isn't
this actually fixing the implementation of reserved regions in type1 to
include this test?  ie.

Fixes: af029169b8fd ("vfio/type1: Check reserved region conflict and update iovalist")

> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
> v1 -> v2:
> - Reworded commit message to hopefully explain things a bit better and
>   highlight that usually just mapping but not issuing DMAs for IOVAs in
>   a resverved region is harmless but still breaks things with ISM devices.
> - Added a check for PAGE_SIZE * 2 alignment (Jason)
> 
>  drivers/vfio/vfio_iommu_type1.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 23c24fe98c00..87b27ffb93d0 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1856,24 +1856,32 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>   * significantly boosts non-hugetlbfs mappings and doesn't seem to hurt when
>   * hugetlbfs is in use.
>   */
> -static void vfio_test_domain_fgsp(struct vfio_domain *domain)
> +static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *regions)
>  {
> -	struct page *pages;
>  	int ret, order = get_order(PAGE_SIZE * 2);
> +	struct vfio_iova *region;
> +	struct page *pages;
>  
>  	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
>  	if (!pages)
>  		return;
>  
> -	ret = iommu_map(domain->domain, 0, page_to_phys(pages), PAGE_SIZE * 2,
> -			IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
> -	if (!ret) {
> -		size_t unmapped = iommu_unmap(domain->domain, 0, PAGE_SIZE);
> +	list_for_each_entry(region, regions, list) {
> +		if (region->end - region->start < PAGE_SIZE * 2 ||
> +				region->start % (PAGE_SIZE*2))

Maybe this falls into the noise, but we don't care if region->start is
aligned to a double page, so long as we can map an aligned double page
within the region.  Maybe something like:

	dma_addr_t start = ALIGN(region->start, PAGE_SIZE * 2);

	if (start >= region->end || (region->end - start < PAGE_SIZE * 2))
		continue;


s/region->// for below if so.  Thanks,

Alex

> +			continue;
>  
> -		if (unmapped == PAGE_SIZE)
> -			iommu_unmap(domain->domain, PAGE_SIZE, PAGE_SIZE);
> -		else
> -			domain->fgsp = true;
> +		ret = iommu_map(domain->domain, region->start, page_to_phys(pages), PAGE_SIZE * 2,
> +				IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
> +		if (!ret) {
> +			size_t unmapped = iommu_unmap(domain->domain, region->start, PAGE_SIZE);
> +
> +			if (unmapped == PAGE_SIZE)
> +				iommu_unmap(domain->domain, region->start + PAGE_SIZE, PAGE_SIZE);
> +			else
> +				domain->fgsp = true;
> +		}
> +		break;
>  	}
>  
>  	__free_pages(pages, order);
> @@ -2326,7 +2334,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  		}
>  	}
>  
> -	vfio_test_domain_fgsp(domain);
> +	vfio_test_domain_fgsp(domain, &iova_copy);
>  
>  	/* replay mappings on new domains */
>  	ret = vfio_iommu_replay(iommu, domain);

