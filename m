Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2728030C7A4
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237351AbhBBR0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:26:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237479AbhBBRXm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:23:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612286535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v8AW8CWpPRGN6h/TLWk0eq/dJGWHJhavvo25Kj/LjC0=;
        b=c5Dt5ce+iBgYCeZeMBdKBeFRkScDPzhjMCmYJ6+JfL7+smtBFeXbsVBEmKtfdwwF+GJKyS
        zR4GedC3vehye4lfO7bAU8kWC0ZaHaE3KOgg0SmKUsqkG5RPM2M4F9+EhZB4gD7SrokTvC
        TVmqNzR2XP0JLl1MFSFGwZMwQKjTsfo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-wJu9rhZPPUuyhHrv_Ue05A-1; Tue, 02 Feb 2021 12:22:11 -0500
X-MC-Unique: wJu9rhZPPUuyhHrv_Ue05A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FBCC193410F;
        Tue,  2 Feb 2021 17:22:08 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B920560862;
        Tue,  2 Feb 2021 17:22:05 +0000 (UTC)
Date:   Tue, 2 Feb 2021 10:22:05 -0700
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
Subject: Re: [PATCH] vfio/iommu_type1: Mantainance a counter for
 non_pinned_groups
Message-ID: <20210202102205.54737110@omen.home.shazbot.org>
In-Reply-To: <20210125024642.14604-1-zhukeqian1@huawei.com>
References: <20210125024642.14604-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Jan 2021 10:46:42 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> With this counter, we never need to traverse all groups to update
> pinned_scope of vfio_iommu.
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 40 +++++----------------------------
>  1 file changed, 5 insertions(+), 35 deletions(-)

Applied to vfio next branch for v5.12.  Thanks,

Alex

> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0b4dedaa9128..bb4bbcc79101 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -73,7 +73,7 @@ struct vfio_iommu {
>  	bool			v2;
>  	bool			nesting;
>  	bool			dirty_page_tracking;
> -	bool			pinned_page_dirty_scope;
> +	uint64_t		num_non_pinned_groups;
>  };
>  
>  struct vfio_domain {
> @@ -148,7 +148,6 @@ static int put_pfn(unsigned long pfn, int prot);
>  static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>  					       struct iommu_group *iommu_group);
>  
> -static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu);
>  /*
>   * This code handles mapping and unmapping of user data buffers
>   * into DMA'ble space using the IOMMU
> @@ -714,7 +713,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  	group = vfio_iommu_find_iommu_group(iommu, iommu_group);
>  	if (!group->pinned_page_dirty_scope) {
>  		group->pinned_page_dirty_scope = true;
> -		update_pinned_page_dirty_scope(iommu);
> +		iommu->num_non_pinned_groups--;
>  	}
>  
>  	goto pin_done;
> @@ -991,7 +990,7 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>  	 * mark all pages dirty if any IOMMU capable device is not able
>  	 * to report dirty pages and all pages are pinned and mapped.
>  	 */
> -	if (!iommu->pinned_page_dirty_scope && dma->iommu_mapped)
> +	if (iommu->num_non_pinned_groups && dma->iommu_mapped)
>  		bitmap_set(dma->bitmap, 0, nbits);
>  
>  	if (shift) {
> @@ -1622,33 +1621,6 @@ static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>  	return group;
>  }
>  
> -static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu)
> -{
> -	struct vfio_domain *domain;
> -	struct vfio_group *group;
> -
> -	list_for_each_entry(domain, &iommu->domain_list, next) {
> -		list_for_each_entry(group, &domain->group_list, next) {
> -			if (!group->pinned_page_dirty_scope) {
> -				iommu->pinned_page_dirty_scope = false;
> -				return;
> -			}
> -		}
> -	}
> -
> -	if (iommu->external_domain) {
> -		domain = iommu->external_domain;
> -		list_for_each_entry(group, &domain->group_list, next) {
> -			if (!group->pinned_page_dirty_scope) {
> -				iommu->pinned_page_dirty_scope = false;
> -				return;
> -			}
> -		}
> -	}
> -
> -	iommu->pinned_page_dirty_scope = true;
> -}
> -
>  static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
>  				  phys_addr_t *base)
>  {
> @@ -2057,8 +2029,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  			 * addition of a dirty tracking group.
>  			 */
>  			group->pinned_page_dirty_scope = true;
> -			if (!iommu->pinned_page_dirty_scope)
> -				update_pinned_page_dirty_scope(iommu);
>  			mutex_unlock(&iommu->lock);
>  
>  			return 0;
> @@ -2188,7 +2158,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	 * demotes the iommu scope until it declares itself dirty tracking
>  	 * capable via the page pinning interface.
>  	 */
> -	iommu->pinned_page_dirty_scope = false;
> +	iommu->num_non_pinned_groups++;
>  	mutex_unlock(&iommu->lock);
>  	vfio_iommu_resv_free(&group_resv_regions);
>  
> @@ -2416,7 +2386,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  	 * to be promoted.
>  	 */
>  	if (update_dirty_scope)
> -		update_pinned_page_dirty_scope(iommu);
> +		iommu->num_non_pinned_groups--;
>  	mutex_unlock(&iommu->lock);
>  }
>  

