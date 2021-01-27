Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29667306847
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 00:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhA0XsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 18:48:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25061 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229494AbhA0XsS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 18:48:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611791210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xJ/gs4iMushfcp0d07qS8uhcoreW6Bo1+Q0lKFHyKMM=;
        b=iXdRkR74QvE9jz0oihEwsF3aN5VvGOCK9YTVORvRawKbYWiqJ73QYN35ti1/0+t/X4B3vm
        SATDBqC62nAXuYgd78ncB4ytMPYPZuWz3VnMh/ArpM25hw65vaDi5hHrhinif5oqHdyXPv
        EXBa9ADaaPfwaA1jxSLqSZyoFK0c1IY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-WQ5wUpHQOfu8sZ2HJIUVTg-1; Wed, 27 Jan 2021 18:46:47 -0500
X-MC-Unique: WQ5wUpHQOfu8sZ2HJIUVTg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C137E8030A0;
        Wed, 27 Jan 2021 23:46:43 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E50C25C1BB;
        Wed, 27 Jan 2021 23:46:41 +0000 (UTC)
Date:   Wed, 27 Jan 2021 16:46:41 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Cornelia Huck" <cohuck@redhat.com>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "James Morse" <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: Re: [PATCH v3 2/2] vfio/iommu_type1: Fix some sanity checks in
 detach group
Message-ID: <20210127164641.36e17bf5@omen.home.shazbot.org>
In-Reply-To: <20210122092635.19900-3-zhukeqian1@huawei.com>
References: <20210122092635.19900-1-zhukeqian1@huawei.com>
        <20210122092635.19900-3-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Jan 2021 17:26:35 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> vfio_sanity_check_pfn_list() is used to check whether pfn_list and
> notifier are empty when remove the external domain, so it makes a
> wrong assumption that only external domain will use the pinning
> interface.
> 
> Now we apply the pfn_list check when a vfio_dma is removed and apply
> the notifier check when all domains are removed.
> 
> Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 33 ++++++++++-----------------------
>  1 file changed, 10 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 161725395f2f..d8c10f508321 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -957,6 +957,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  
>  static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>  {
> +	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
>  	vfio_unmap_unpin(iommu, dma, true);
>  	vfio_unlink_dma(iommu, dma);
>  	put_task_struct(dma->task);
> @@ -2250,23 +2251,6 @@ static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
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
> @@ -2366,10 +2350,10 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  			kfree(group);
>  
>  			if (list_empty(&iommu->external_domain->group_list)) {
> -				vfio_sanity_check_pfn_list(iommu);
> -
> -				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
> +				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +					WARN_ON(iommu->notifier.head);
>  					vfio_iommu_unmap_unpin_all(iommu);
> +				}
>  
>  				kfree(iommu->external_domain);
>  				iommu->external_domain = NULL;
> @@ -2403,10 +2387,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  		 */
>  		if (list_empty(&domain->group_list)) {
>  			if (list_is_singular(&iommu->domain_list)) {
> -				if (!iommu->external_domain)
> +				if (!iommu->external_domain) {
> +					WARN_ON(iommu->notifier.head);
>  					vfio_iommu_unmap_unpin_all(iommu);
> -				else
> +				} else {
>  					vfio_iommu_unmap_unpin_reaccount(iommu);
> +				}
>  			}
>  			iommu_domain_free(domain->domain);
>  			list_del(&domain->next);
> @@ -2488,9 +2474,10 @@ static void vfio_iommu_type1_release(void *iommu_data)
>  	struct vfio_iommu *iommu = iommu_data;
>  	struct vfio_domain *domain, *domain_tmp;
>  
> +	WARN_ON(iommu->notifier.head);

I don't see that this does any harm, but isn't it actually redundant?
It seems vfio-core only calls the iommu backend release function after
removing all the groups, so the tests in _detach_group should catch all
cases.  We're expecting the vfio bus/mdev driver to remove the notifier
when a device is closed, which necessarily occurs before detaching the
group.  Thanks,

Alex

> +
>  	if (iommu->external_domain) {
>  		vfio_release_domain(iommu->external_domain, true);
> -		vfio_sanity_check_pfn_list(iommu);
>  		kfree(iommu->external_domain);
>  	}
>  

