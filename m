Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B1B7BDDA
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 12:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbfGaJ7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 05:59:55 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50437 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbfGaJ7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 05:59:55 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so60151850wml.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 02:59:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KfQ1GOxa2gwawYjZESEw8m6ZN1EOeLyab9IzRAQRkB8=;
        b=ImytIG4KswEmV1TnOUIfNZykT/3rO+64VOnAAg68I3oSgj3hSrw9aCMkatV5jVJWQV
         I5pC3Wn2I4Jv/3YpdtrXeS1NRgwfGjJp3WIvPQogbvSwP5pniMzil67JHd3WSv8tUAXM
         rZepNdPJua/+GKu99W5KkVH7MXIWeIX+LpXblet1D/fzQo7eCCROPgItcm8kOaZtrhE6
         sPvi7b60/VAueThnmznk5X4JHVBjhtRqyhp+zZeB5B0wjKqY+py5bHfCb1XqZ7O+Rq5U
         2rj7d26HlLnui1ViPr4mNzsjYNa5UIoi8oslpevGVBY72M+GV+iJxjgUEjAe7faUOj4j
         x5Pw==
X-Gm-Message-State: APjAAAUsJZNBI08W2nNFXcvQyRHGhBvUmGcfe6fGGONSvfRKPRyXzGlQ
        Qn7i4rnYDO75ympki2bWjPq+NA==
X-Google-Smtp-Source: APXvYqy7/iEU1UrL2it0Ep7+ooQdkQ6xuUDFbcpqjrWR2xbr/ulDYf5qm8/eQpzBooD00tKHJ19RcQ==
X-Received: by 2002:a05:600c:230c:: with SMTP id 12mr12821673wmo.151.1564567193839;
        Wed, 31 Jul 2019 02:59:53 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id d10sm79226236wro.18.2019.07.31.02.59.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 02:59:53 -0700 (PDT)
Date:   Wed, 31 Jul 2019 11:59:50 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jgg@ziepe.ca
Subject: Re: [PATCH V2 9/9] vhost: do not return -EAGIAN for non blocking
 invalidation too early
Message-ID: <20190731095950.d6zr472megt7rgkt@steredhat>
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-10-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731084655.7024-10-jasowang@redhat.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A little typo in the title: s/EAGIAN/EAGAIN

Thanks,
Stefano

On Wed, Jul 31, 2019 at 04:46:55AM -0400, Jason Wang wrote:
> Instead of returning -EAGAIN unconditionally, we'd better do that only
> we're sure the range is overlapped with the metadata area.
> 
> Reported-by: Jason Gunthorpe <jgg@ziepe.ca>
> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vhost.c | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index fc2da8a0c671..96c6aeb1871f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -399,16 +399,19 @@ static void inline vhost_vq_sync_access(struct vhost_virtqueue *vq)
>  	smp_mb();
>  }
>  
> -static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
> -				      int index,
> -				      unsigned long start,
> -				      unsigned long end)
> +static int vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
> +				     int index,
> +				     unsigned long start,
> +				     unsigned long end,
> +				     bool blockable)
>  {
>  	struct vhost_uaddr *uaddr = &vq->uaddrs[index];
>  	struct vhost_map *map;
>  
>  	if (!vhost_map_range_overlap(uaddr, start, end))
> -		return;
> +		return 0;
> +	else if (!blockable)
> +		return -EAGAIN;
>  
>  	spin_lock(&vq->mmu_lock);
>  	++vq->invalidate_count;
> @@ -423,6 +426,8 @@ static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
>  		vhost_set_map_dirty(vq, map, index);
>  		vhost_map_unprefetch(map);
>  	}
> +
> +	return 0;
>  }
>  
>  static void vhost_invalidate_vq_end(struct vhost_virtqueue *vq,
> @@ -443,18 +448,19 @@ static int vhost_invalidate_range_start(struct mmu_notifier *mn,
>  {
>  	struct vhost_dev *dev = container_of(mn, struct vhost_dev,
>  					     mmu_notifier);
> -	int i, j;
> -
> -	if (!mmu_notifier_range_blockable(range))
> -		return -EAGAIN;
> +	bool blockable = mmu_notifier_range_blockable(range);
> +	int i, j, ret;
>  
>  	for (i = 0; i < dev->nvqs; i++) {
>  		struct vhost_virtqueue *vq = dev->vqs[i];
>  
> -		for (j = 0; j < VHOST_NUM_ADDRS; j++)
> -			vhost_invalidate_vq_start(vq, j,
> -						  range->start,
> -						  range->end);
> +		for (j = 0; j < VHOST_NUM_ADDRS; j++) {
> +			ret = vhost_invalidate_vq_start(vq, j,
> +							range->start,
> +							range->end, blockable);
> +			if (ret)
> +				return ret;
> +		}
>  	}
>  
>  	return 0;
> -- 
> 2.18.1
> 

-- 
