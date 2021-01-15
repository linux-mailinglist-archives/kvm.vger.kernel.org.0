Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C2A2F8968
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 00:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbhAOXcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 18:32:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726172AbhAOXcQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 18:32:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610753450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZcqGdAWvT6/fidF7kC53r5O0Fwn58WR7GKMoHqohBAc=;
        b=PqNGSO1apcingLTq1MDr1/754xN/XwuYsVDohHh62tmO7QPDJhEYeeUfDc9uCwAPukpB7U
        bErHXuegRujGaNNLYobdjnKJpIiBmfqiA7HU1JR3n4oNgNQ0mmkJo9oLwL1B0dxNp7Xq6J
        1ZRCZJJWR++T4+7JKKjkdcpG75mKEgI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-MbQGIl4pMwCRKRrqXq0k5Q-1; Fri, 15 Jan 2021 18:30:46 -0500
X-MC-Unique: MbQGIl4pMwCRKRrqXq0k5Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 290C2180A092;
        Fri, 15 Jan 2021 23:30:43 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E3D66F7EF;
        Fri, 15 Jan 2021 23:30:41 +0000 (UTC)
Date:   Fri, 15 Jan 2021 16:30:41 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, "Marc Zyngier" <maz@kernel.org>,
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
Subject: Re: [PATCH 3/6] vfio/iommu_type1: Initially set the
 pinned_page_dirty_scope
Message-ID: <20210115163041.704a4e9d@omen.home.shazbot.org>
In-Reply-To: <20210107044401.19828-4-zhukeqian1@huawei.com>
References: <20210107044401.19828-1-zhukeqian1@huawei.com>
        <20210107044401.19828-4-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 Jan 2021 12:43:58 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> For now there are 3 ways to promote the pinned_page_dirty_scope
> status of vfio_iommu:
> 
> 1. Through vfio pin interface.
> 2. Detach a group without pinned_dirty_scope.
> 3. Attach a group with pinned_dirty_scope.
> 
> For point 3, the only chance to promote the pinned_page_dirty_scope
> status is when vfio_iommu is newly created. As we can safely set
> empty vfio_iommu to be at pinned status, then the point 3 can be
> removed to reduce operations.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 110ada24ee91..b596c482487b 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2045,11 +2045,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  			 * Non-iommu backed group cannot dirty memory directly,
>  			 * it can only use interfaces that provide dirty
>  			 * tracking.
> -			 * The iommu scope can only be promoted with the
> -			 * addition of a dirty tracking group.
>  			 */
>  			group->pinned_page_dirty_scope = true;
> -			promote_pinned_page_dirty_scope(iommu);
>  			mutex_unlock(&iommu->lock);
>  
>  			return 0;
> @@ -2436,6 +2433,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>  	INIT_LIST_HEAD(&iommu->iova_list);
>  	iommu->dma_list = RB_ROOT;
>  	iommu->dma_avail = dma_entry_limit;
> +	iommu->pinned_page_dirty_scope = true;
>  	mutex_init(&iommu->lock);
>  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
>  

This would be resolved automatically if we used the counter approach I
mentioned on the previous patch, adding a pinned-page scope group simply
wouldn't increment the iommu counter, which would initially be zero
indicating no "all-dma" groups.  Thanks,

Alex

