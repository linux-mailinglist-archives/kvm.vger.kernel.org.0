Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6437F2F8960
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 00:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbhAOXZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 18:25:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726172AbhAOXZf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 18:25:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610753049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hi1wWTTxsSrh2eZC6d26sBLUQWgqiaGuZmJlj3AaGNk=;
        b=dHg6MsaJOSBv9I+8I1bGWt8NdeC/VHQTWk7wvLOEa9kEeDSau4rj61DqamjfX7wBp0Tur6
        5AcZ/e4QmUvH/5KDFGbWZJJyzzOTwlxLaVVPZ3GyDoip/qCi+z8o8O5ITHaYPaNsgG0Mtn
        hKne0mdKfR27r4O55zB9cqGdvqe+3Io=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-uCbG_PrpNRm72u80Zfo6-w-1; Fri, 15 Jan 2021 18:24:05 -0500
X-MC-Unique: uCbG_PrpNRm72u80Zfo6-w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D174802B40;
        Fri, 15 Jan 2021 23:24:02 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFC505D763;
        Fri, 15 Jan 2021 23:24:00 +0000 (UTC)
Date:   Fri, 15 Jan 2021 16:23:59 -0700
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
Subject: Re: [PATCH 2/6] vfio/iommu_type1: Ignore external domain when
 promote pinned_scope
Message-ID: <20210115162359.749e8d0d@omen.home.shazbot.org>
In-Reply-To: <20210107044401.19828-3-zhukeqian1@huawei.com>
References: <20210107044401.19828-1-zhukeqian1@huawei.com>
        <20210107044401.19828-3-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 Jan 2021 12:43:57 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> The pinned_scope of external domain's groups are always true, that's
> to say we can safely ignore external domain when promote pinned_scope
> status of vfio_iommu.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 334a8240e1da..110ada24ee91 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1637,14 +1637,7 @@ static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu)
>  		}
>  	}
>  
> -	if (iommu->external_domain) {
> -		domain = iommu->external_domain;
> -		list_for_each_entry(group, &domain->group_list, next) {
> -			if (!group->pinned_page_dirty_scope)
> -				return;
> -		}
> -	}
> -
> +	/* The external domain always passes check */
>  	iommu->pinned_page_dirty_scope = true;
>  }
>  
> @@ -2347,7 +2340,6 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  	if (iommu->external_domain) {
>  		group = find_iommu_group(iommu->external_domain, iommu_group);
>  		if (group) {
> -			promote_dirty_scope = !group->pinned_page_dirty_scope;


With this, vfio_group.pinned_page_dirty_scope is effectively a dead
field on the struct for groups on the external_domain group list and
handled specially.  That's not great.

If you actually want to make more than a trivial improvement to scope
tracking, what about making a counter on our struct vfio_iommu for all
the non-pinned-page (ie. all-dma) scope groups attached to the
container.  Groups on the external domain would still set their group
dirty scope to pinned pages, groups making use of an iommu domain would
have an all-dma scope initially and increment that counter when
attached.  Groups that still have an all-dma scope on detach would
decrement the counter.  If a group changes from all-dma to pinned-page
scope, the counter is also decremented.  We'd never need to search
across group lists.  Thanks,

Alex

>  			list_del(&group->next);
>  			kfree(group);
>  
> @@ -2360,7 +2352,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  				kfree(iommu->external_domain);
>  				iommu->external_domain = NULL;
>  			}
> -			goto detach_group_done;
> +			mutex_unlock(&iommu->lock);
> +			return;
>  		}
>  	}
>  
> @@ -2408,7 +2401,6 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  	else
>  		vfio_iommu_iova_free(&iova_copy);
>  
> -detach_group_done:
>  	/*
>  	 * Removal of a group without dirty tracking may allow the iommu scope
>  	 * to be promoted.

