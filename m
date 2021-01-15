Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEC22F853A
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 20:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387921AbhAOTQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 14:16:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbhAOTQX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 14:16:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610738096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v4FwxeAEyXEI6CWznvqU5AtMWFcpWnT8O1IOjG3Vr1Y=;
        b=NO6McH48ardHju9sMXHupcDuh6pwTCoRH5AgZxbKyA5QFzDmGZjdr64BNKjaTfYeEKkjCY
        FdpJUeI2TuwKEG6ny/1kjluykJSZJC84Dqq6El6pHIjyCbqoKrYX2PEBOxqDlVOTT1sM5v
        IqXBLXbSXoA8aoG0c+v3+Y8tvlDYehM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-QqrpG32lOIWZOPK7xYEGTg-1; Fri, 15 Jan 2021 14:14:52 -0500
X-MC-Unique: QqrpG32lOIWZOPK7xYEGTg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93C32806662;
        Fri, 15 Jan 2021 19:14:49 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6AFB5D9C6;
        Fri, 15 Jan 2021 19:14:47 +0000 (UTC)
Date:   Fri, 15 Jan 2021 12:14:47 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: Re: [PATCH v2 2/2] vfio/iommu_type1: Sanity check pfn_list when
 remove vfio_dma
Message-ID: <20210115121447.54c96857@omen.home.shazbot.org>
In-Reply-To: <20210115092643.728-3-zhukeqian1@huawei.com>
References: <20210115092643.728-1-zhukeqian1@huawei.com>
        <20210115092643.728-3-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Jan 2021 17:26:43 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> vfio_sanity_check_pfn_list() is used to check whether pfn_list of
> vfio_dma is empty when remove the external domain, so it makes a
> wrong assumption that only external domain will add pfn to dma pfn_list.
> 
> Now we apply this check when remove a specific vfio_dma and extract
> the notifier check just for external domain.

The page pinning interface is gated by having a notifier registered for
unmaps, therefore non-external domains would also need to register a
notifier.  There's currently no other way to add entries to the
pfn_list.  So if we allow pinning for such domains, then it's wrong to
WARN_ON() when the notifier list is not-empty when removing an external
domain.  Long term we should probably extend page {un}pinning for the
caller to pass their notifier to be validated against the notifier list
rather than just allowing page pinning if *any* notifier is registered.
Thanks,

Alex
 
> Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 24 +++++-------------------
>  1 file changed, 5 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 4e82b9a3440f..a9bc15e84a4e 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -958,6 +958,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  
>  static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>  {
> +	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list);
>  	vfio_unmap_unpin(iommu, dma, true);
>  	vfio_unlink_dma(iommu, dma);
>  	put_task_struct(dma->task);
> @@ -2251,23 +2252,6 @@ static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
>  	}
>  }
>  
> -static void vfio_sanity_check_pfn_list(struct vfio_iommu *iommu)
> -{
> -	struct rb_node *n;
> -
> -	n = rb_first(&iommu->dma_list);
> -	for (; n; n = rb_next(n)) {
> -		struct vfio_dma *dma;
> -
> -		dma = rb_entry(n, struct vfio_dma, node);
> -
> -		if (WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list)))
> -			break;
> -	}
> -	/* mdev vendor driver must unregister notifier */
> -	WARN_ON(iommu->notifier.head);
> -}
> -
>  /*
>   * Called when a domain is removed in detach. It is possible that
>   * the removed domain decided the iova aperture window. Modify the
> @@ -2367,7 +2351,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  			kfree(group);
>  
>  			if (list_empty(&iommu->external_domain->group_list)) {
> -				vfio_sanity_check_pfn_list(iommu);
> +				/* mdev vendor driver must unregister notifier */
> +				WARN_ON(iommu->notifier.head);
>  
>  				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
>  					vfio_iommu_unmap_unpin_all(iommu);
> @@ -2491,7 +2476,8 @@ static void vfio_iommu_type1_release(void *iommu_data)
>  
>  	if (iommu->external_domain) {
>  		vfio_release_domain(iommu->external_domain, true);
> -		vfio_sanity_check_pfn_list(iommu);
> +		/* mdev vendor driver must unregister notifier */
> +		WARN_ON(iommu->notifier.head);
>  		kfree(iommu->external_domain);
>  	}
>  

