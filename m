Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC45035A2CB
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 18:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbhDIQQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 12:16:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38619 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232796AbhDIQQM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Apr 2021 12:16:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617984958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ympzD91JBFEmUB8z07nEg3SFQfNcnSyyZ0Xyv2VW9mY=;
        b=Qc8NMIQ342X9t47ptJnVNgsdC8VDtnkx5zFUthRdTHFYo2C4C72MIk/bjiLd8zNycQJ8Ky
        NVbg8E/8OJwwTHeeocKBUBtb+ZDRVn5cZYn7GZeINXrhpLzsqu8BqH24PQw2OI4A53SBXA
        7s01pmA8b/OFSLXJXn+2Hnmx+v0ESxs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-91ew_1DGMNGBN2nAqOffqw-1; Fri, 09 Apr 2021 12:15:57 -0400
X-MC-Unique: 91ew_1DGMNGBN2nAqOffqw-1
Received: by mail-wr1-f70.google.com with SMTP id r12so1682660wrw.18
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 09:15:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ympzD91JBFEmUB8z07nEg3SFQfNcnSyyZ0Xyv2VW9mY=;
        b=Om0X/tgh8bc2Mh9Y6yFudiTqm6rkYAEwNkYabxT7ub0OgUdvjtojEXmxumBAjUp2Yo
         F3mPIHXSAbo5yX96zD+tlJsUBVs352AI1Ql6CrdDJ5getEg8GRk55rdL4cisD5sWsJTd
         Kd7AH0PrBVPjqGxjNISO3KQ5qf8I7+XZugw5nuMfjrUQfQEl44NQXd3NyI7sUw475EHO
         EZtHJUNMi/gsl485LhvfPRVwy6moUtL7AeggxB415l6s6ddlwBCKQzynp5h+IbbFe44O
         vwfHc0P8TuHrIOnc/7iyREDyGJRDnIfJhebnTomU9pf2Mj6uFslSbyqtJstWLsPNOf87
         porg==
X-Gm-Message-State: AOAM531yIfKknFFTp2yyJkCG0hnbI1HY+NkSlzXsbF/7BjbUjo/MPHic
        gF7UB80M8k4QIRdXYp8CsTyxCa991snhA51YT6+bx2WCVizv4tYPIrhFbdSwiQEXWVP9crnMzhQ
        DMLIMNbqfxZrF
X-Received: by 2002:adf:fa12:: with SMTP id m18mr18461073wrr.61.1617984956087;
        Fri, 09 Apr 2021 09:15:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7/KOvp7jfAdtHy4C2v6W8Sr5jADGDS1mDCv/rNxxuSfa3gCZY792heyfmCgnU+ZhCR5H7YQ==
X-Received: by 2002:adf:fa12:: with SMTP id m18mr18461055wrr.61.1617984955917;
        Fri, 09 Apr 2021 09:15:55 -0700 (PDT)
Received: from redhat.com ([2a10:800e:f0d3:0:b69b:9fb8:3947:5636])
        by smtp.gmail.com with ESMTPSA id 3sm5445635wma.45.2021.04.09.09.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 09:15:55 -0700 (PDT)
Date:   Fri, 9 Apr 2021 12:15:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] vhost-vdpa: protect concurrent access to vhost
 device iotlb
Message-ID: <20210409121512-mutt-send-email-mst@kernel.org>
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-4-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331080519.172-4-xieyongji@bytedance.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 31, 2021 at 04:05:12PM +0800, Xie Yongji wrote:
> Use vhost_dev->mutex to protect vhost device iotlb from
> concurrent access.
> 
> Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
> Cc: stable@vger.kernel.org
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

I could not figure out whether there's a bug there now.
If yes when is the concurrent access triggered?

> ---
>  drivers/vhost/vdpa.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 3947fbc2d1d5..63b28d3aee7c 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -725,9 +725,11 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>  	const struct vdpa_config_ops *ops = vdpa->config;
>  	int r = 0;
>  
> +	mutex_lock(&dev->mutex);
> +
>  	r = vhost_dev_check_owner(dev);
>  	if (r)
> -		return r;
> +		goto unlock;
>  
>  	switch (msg->type) {
>  	case VHOST_IOTLB_UPDATE:
> @@ -748,6 +750,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>  		r = -EINVAL;
>  		break;
>  	}
> +unlock:
> +	mutex_unlock(&dev->mutex);
>  
>  	return r;
>  }
> -- 
> 2.11.0

