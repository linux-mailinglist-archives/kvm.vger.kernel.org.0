Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5362F222F
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 22:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733272AbhAKVuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 16:50:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732824AbhAKVut (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 16:50:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610401763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YcHYs6OZqBWCMgb0rpCE3M6MXEuKUj2tsDDbqZh/79Q=;
        b=Hz2Y9oRlLLtMr3VK3hFnKgSjz/XHyxWZA316H6F4lON/5wdpYqWK+8ONUkDjxlnW0XTpjN
        wHflJdjBnNUr9NIoDmyp72csv5bhcRuMBP+xRfBPB5mc2pdrXSEugpmhNfTu9hiJu6jYg1
        qt2lzO7fsEFjgsevSv35ObPgMaYYJ6g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-ekx4pMUpPXWmh16-SihWQQ-1; Mon, 11 Jan 2021 16:49:19 -0500
X-MC-Unique: ekx4pMUpPXWmh16-SihWQQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B8F1107ACF7;
        Mon, 11 Jan 2021 21:49:16 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 828CE60BE2;
        Mon, 11 Jan 2021 21:49:14 +0000 (UTC)
Date:   Mon, 11 Jan 2021 14:49:13 -0700
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
Subject: Re: [PATCH 4/5] vfio/iommu_type1: Carefully use unmap_unpin_all
 during dirty tracking
Message-ID: <20210111144913.3092b1b1@omen.home.shazbot.org>
In-Reply-To: <20210107092901.19712-5-zhukeqian1@huawei.com>
References: <20210107092901.19712-1-zhukeqian1@huawei.com>
        <20210107092901.19712-5-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 Jan 2021 17:29:00 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> If we detach group during dirty page tracking, we shouldn't remove
> vfio_dma, because dirty log will lose.
> 
> But we don't prevent unmap_unpin_all in vfio_iommu_release, because
> under normal procedure, dirty tracking has been stopped.

This looks like it's creating a larger problem than it's fixing, it's
not our job to maintain the dirty bitmap regardless of what the user
does.  If the user detaches the last group in a container causing the
mappings within that container to be deconstructed before the user has
collected dirty pages, that sounds like a user error.  A container with
no groups is de-privileged and therefore loses all state.  Thanks,

Alex

> Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 26b7eb2a5cfc..9776a059904d 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2373,7 +2373,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  			if (list_empty(&iommu->external_domain->group_list)) {
>  				vfio_sanity_check_pfn_list(iommu);
>  
> -				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
> +				/*
> +				 * During dirty page tracking, we can't remove
> +				 * vfio_dma because dirty log will lose.
> +				 */
> +				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu) &&
> +				    !iommu->dirty_page_tracking)
>  					vfio_iommu_unmap_unpin_all(iommu);
>  
>  				kfree(iommu->external_domain);
> @@ -2406,10 +2411,15 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  		 * iommu and external domain doesn't exist, then all the
>  		 * mappings go away too. If it's the last domain with iommu and
>  		 * external domain exist, update accounting
> +		 *
> +		 * Note: During dirty page tracking, we can't remove vfio_dma
> +		 * because dirty log will lose. Just update accounting is a good
> +		 * choice.
>  		 */
>  		if (list_empty(&domain->group_list)) {
>  			if (list_is_singular(&iommu->domain_list)) {
> -				if (!iommu->external_domain)
> +				if (!iommu->external_domain &&
> +				    !iommu->dirty_page_tracking)
>  					vfio_iommu_unmap_unpin_all(iommu);
>  				else
>  					vfio_iommu_unmap_unpin_reaccount(iommu);

