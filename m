Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7899714D5
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 11:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388899AbfGWJRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 05:17:16 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42351 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388882AbfGWJRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 05:17:12 -0400
Received: by mail-qt1-f196.google.com with SMTP id h18so41189639qtm.9
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2019 02:17:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rE+i8EqXzyB8DBEUYxSjl+5SA8mCW5PhVrX+Xp6Yjvw=;
        b=rK0hXwPwN4d3Efu5T9yeV+6uY2hEIo60rNtJ2CCO27NBs3452tYy05HiRhZ89JbVYw
         icAWwy/RDKdd/bBGAtUNe3FnydmU7wCL/OQvSd4eKLzbqb+ftAdjpPKRRXcJ0sctrqAS
         Nmn0oRuhQ3Oh6vBGm306ymn0GmjVXRV091BlNL2dQZhlQjV9tAwttm6UkSbqqsuiWNRG
         unHHPtD5GnTwIvMHNOY35f5IH0CPQ/QeJXtVA4a3eSO2J+5JBLOjIIOekgWlDAv41xCW
         ls9LJF8cYeP0Jl21Nxow1vAdbxJisdOj97vRbpKEmeb0Ev1AY8PsTQVRa5gW87ABzwTv
         /iWA==
X-Gm-Message-State: APjAAAUHCfVz6PnemoLAgInw4qj2gWKchpBjJlqHPCMRR8jQKiQbLtYe
        /RsiWr2Wn8eynfqcgQXw6rTyUg==
X-Google-Smtp-Source: APXvYqyAykM6yZ3eL7Nuv5ZAEtiWnBxoluP42MON3e5EZBOP/lJkeMVDrPe0RbgXHwPtl0InvF1Ang==
X-Received: by 2002:ac8:39a3:: with SMTP id v32mr53485150qte.262.1563873430754;
        Tue, 23 Jul 2019 02:17:10 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id 42sm22937793qtm.27.2019.07.23.02.17.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 02:17:10 -0700 (PDT)
Date:   Tue, 23 Jul 2019 05:17:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] vhost: mark dirty pages during map uninit
Message-ID: <20190723041702-mutt-send-email-mst@kernel.org>
References: <20190723075718.6275-1-jasowang@redhat.com>
 <20190723075718.6275-6-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723075718.6275-6-jasowang@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 23, 2019 at 03:57:17AM -0400, Jason Wang wrote:
> We don't mark dirty pages if the map was teared down outside MMU
> notifier. This will lead untracked dirty pages. Fixing by marking
> dirty pages during map uninit.
> 
> Reported-by: Michael S. Tsirkin <mst@redhat.com>
> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vhost.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 89c9f08b5146..5b8821d00fe4 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -306,6 +306,18 @@ static void vhost_map_unprefetch(struct vhost_map *map)
>  	kfree(map);
>  }
>  
> +static void vhost_set_map_dirty(struct vhost_virtqueue *vq,
> +				struct vhost_map *map, int index)
> +{
> +	struct vhost_uaddr *uaddr = &vq->uaddrs[index];
> +	int i;
> +
> +	if (uaddr->write) {
> +		for (i = 0; i < map->npages; i++)
> +			set_page_dirty(map->pages[i]);
> +	}
> +}
> +
>  static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
>  {
>  	struct vhost_map *map[VHOST_NUM_ADDRS];
> @@ -315,8 +327,10 @@ static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
>  	for (i = 0; i < VHOST_NUM_ADDRS; i++) {
>  		map[i] = rcu_dereference_protected(vq->maps[i],
>  				  lockdep_is_held(&vq->mmu_lock));
> -		if (map[i])
> +		if (map[i]) {
> +			vhost_set_map_dirty(vq, map[i], i);
>  			rcu_assign_pointer(vq->maps[i], NULL);
> +		}
>  	}
>  	spin_unlock(&vq->mmu_lock);
>  
> @@ -354,7 +368,6 @@ static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
>  {
>  	struct vhost_uaddr *uaddr = &vq->uaddrs[index];
>  	struct vhost_map *map;
> -	int i;
>  
>  	if (!vhost_map_range_overlap(uaddr, start, end))
>  		return;
> @@ -365,10 +378,7 @@ static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
>  	map = rcu_dereference_protected(vq->maps[index],
>  					lockdep_is_held(&vq->mmu_lock));
>  	if (map) {
> -		if (uaddr->write) {
> -			for (i = 0; i < map->npages; i++)
> -				set_page_dirty(map->pages[i]);
> -		}
> +		vhost_set_map_dirty(vq, map, index);
>  		rcu_assign_pointer(vq->maps[index], NULL);
>  	}
>  	spin_unlock(&vq->mmu_lock);

OK and the reason it's safe is because the invalidate counter
got incremented so we know page will not get mapped again.

But we *do* need to wait for page not to be mapped.
And if that means waiting for VQ processing to finish,
then I worry that is a very log time.


> -- 
> 2.18.1
