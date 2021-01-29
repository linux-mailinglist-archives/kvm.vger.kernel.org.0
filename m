Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658813086BA
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 08:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhA2Hp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 02:45:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35707 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232342AbhA2HpX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Jan 2021 02:45:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611906237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sdvP+XB+ujK4GwLPOzeUg9idInwSrrIU7VqOTnRaTYc=;
        b=bxfgyfga4dtGPePC9G0RWUpwfK5x2a8wQMkGKLh0My9ND5MkRJfug3Y/hO9oUWLBqFyCSd
        aise6G6FJV4wqX4zelFlcxO1CmXiuu0vypVz1h57udg3FNkKwZjszLGIvjw2OKUN7pEwr4
        RCyDkVLZwnc1Kn/k0ZQ2gjWh95OKJOA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-6hE_-NqCOc6xnv-fnGRljg-1; Fri, 29 Jan 2021 02:43:52 -0500
X-MC-Unique: 6hE_-NqCOc6xnv-fnGRljg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA3DD107ACFA;
        Fri, 29 Jan 2021 07:43:50 +0000 (UTC)
Received: from [10.72.14.10] (ovpn-14-10.pek2.redhat.com [10.72.14.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C0E371C8E;
        Fri, 29 Jan 2021 07:43:41 +0000 (UTC)
Subject: Re: [PATCH RFC v2 02/10] vringh: add 'iotlb_lock' to synchronize
 iotlb accesses
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        kvm@vger.kernel.org
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-3-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <017f6e69-b2ec-aed0-5920-a389199e4cf9@redhat.com>
Date:   Fri, 29 Jan 2021 15:43:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210128144127.113245-3-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/28 下午10:41, Stefano Garzarella wrote:
> Usually iotlb accesses are synchronized with a spinlock.
> Let's request it as a new parameter in vringh_set_iotlb() and
> hold it when we navigate the iotlb in iotlb_translate() to avoid
> race conditions with any new additions/deletions of ranges from
> the ioltb.


Patch looks fine but I wonder if this is the best approach comparing to 
do locking by the caller.

Thanks


>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>   include/linux/vringh.h           | 6 +++++-
>   drivers/vdpa/vdpa_sim/vdpa_sim.c | 3 ++-
>   drivers/vhost/vringh.c           | 9 ++++++++-
>   3 files changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> index 59bd50f99291..9c077863c8f6 100644
> --- a/include/linux/vringh.h
> +++ b/include/linux/vringh.h
> @@ -46,6 +46,9 @@ struct vringh {
>   	/* IOTLB for this vring */
>   	struct vhost_iotlb *iotlb;
>   
> +	/* spinlock to synchronize IOTLB accesses */
> +	spinlock_t *iotlb_lock;
> +
>   	/* The function to call to notify the guest about added buffers */
>   	void (*notify)(struct vringh *);
>   };
> @@ -258,7 +261,8 @@ static inline __virtio64 cpu_to_vringh64(const struct vringh *vrh, u64 val)
>   
>   #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
>   
> -void vringh_set_iotlb(struct vringh *vrh, struct vhost_iotlb *iotlb);
> +void vringh_set_iotlb(struct vringh *vrh, struct vhost_iotlb *iotlb,
> +		      spinlock_t *iotlb_lock);
>   
>   int vringh_init_iotlb(struct vringh *vrh, u64 features,
>   		      unsigned int num, bool weak_barriers,
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index 2183a833fcf4..53238989713d 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -284,7 +284,8 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
>   		goto err_iommu;
>   
>   	for (i = 0; i < dev_attr->nvqs; i++)
> -		vringh_set_iotlb(&vdpasim->vqs[i].vring, vdpasim->iommu);
> +		vringh_set_iotlb(&vdpasim->vqs[i].vring, vdpasim->iommu,
> +				 &vdpasim->iommu_lock);
>   
>   	ret = iova_cache_get();
>   	if (ret)
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 85d85faba058..f68122705719 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1074,6 +1074,8 @@ static int iotlb_translate(const struct vringh *vrh,
>   	int ret = 0;
>   	u64 s = 0;
>   
> +	spin_lock(vrh->iotlb_lock);
> +
>   	while (len > s) {
>   		u64 size, pa, pfn;
>   
> @@ -1103,6 +1105,8 @@ static int iotlb_translate(const struct vringh *vrh,
>   		++ret;
>   	}
>   
> +	spin_unlock(vrh->iotlb_lock);
> +
>   	return ret;
>   }
>   
> @@ -1262,10 +1266,13 @@ EXPORT_SYMBOL(vringh_init_iotlb);
>    * vringh_set_iotlb - initialize a vringh for a ring with IOTLB.
>    * @vrh: the vring
>    * @iotlb: iotlb associated with this vring
> + * @iotlb_lock: spinlock to synchronize the iotlb accesses
>    */
> -void vringh_set_iotlb(struct vringh *vrh, struct vhost_iotlb *iotlb)
> +void vringh_set_iotlb(struct vringh *vrh, struct vhost_iotlb *iotlb,
> +		      spinlock_t *iotlb_lock)
>   {
>   	vrh->iotlb = iotlb;
> +	vrh->iotlb_lock = iotlb_lock;
>   }
>   EXPORT_SYMBOL(vringh_set_iotlb);
>   

