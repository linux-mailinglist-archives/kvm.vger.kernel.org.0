Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55356A4D98
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjB0Vyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjB0Vym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:54:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2B020560
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 13:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677534840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NH1zCP7fchiReMFqu555SwmXjnCrBh0XjRIbNOlyPW8=;
        b=iJyi0S45rNUfqGcbzQOs93fhrJfj2NQwY89GE8TG6avazsxutiBXVAEy5AJ4NoBLPIZBpi
        W+/fcoUhqzF4yKVt5lgL06MJ50kAdviSgi2N2GuAfqvsfC3Nd6OBa3s+Irnbediw9YV/HS
        us/clbyPsUaktJipsbmCu+yofl3d+sE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-426-WmxUVh-oNTC0BsGVwla43A-1; Mon, 27 Feb 2023 16:53:59 -0500
X-MC-Unique: WmxUVh-oNTC0BsGVwla43A-1
Received: by mail-ed1-f71.google.com with SMTP id dm14-20020a05640222ce00b0046790cd9082so10647151edb.21
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 13:53:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NH1zCP7fchiReMFqu555SwmXjnCrBh0XjRIbNOlyPW8=;
        b=7kaovSMTcdP4W7V4VWGnY31jUMyvMUowmPNAh+seMvZYKyoz3fpamIc0SfHJQ0fr1r
         3SIAbek4VCFH1YICQRxN90m7DiWBqFMFjbP63lgKDTJ2c/JbAPLdyBqXXkKFzCNZTg0Z
         K4uSre2WkIMJzHFLhETEIQHd8wvp1z+/KKIwnUSERq5n3xtg/8t6PpyiMI+/USBCPnM5
         XugSBWOKwwT4o8qAaSMU9Bj8Jm6qtejju/ZirXbltlre96nTKr1mTnPGxu5W84XHkfx3
         U1vElvy7Kvz9SsmfIyG/wNQiTiLI+2x9n2LMn/NPY7fgz05gGrcXbdrr5RjsL2GQ/cX4
         QR2w==
X-Gm-Message-State: AO0yUKVgaaifRetfU6XQKGho/tVZiC7+5zhmfyRUQorj0/aKfI7N+yDT
        EQaPeWpDTa3igyh4sI1DNcOq8pgcqnNGCGfL8z2nA9mIW9OveA9OS9DoBj+5mLcEf1Oij/OvhEa
        Q3TZlAORbo/FX
X-Received: by 2002:a17:907:20ca:b0:87b:d2b3:67ca with SMTP id qq10-20020a17090720ca00b0087bd2b367camr159468ejb.75.1677534838091;
        Mon, 27 Feb 2023 13:53:58 -0800 (PST)
X-Google-Smtp-Source: AK7set9ogYP9qlfEFY1lD8iKUQGWG7h/CDs1XyL2Fcs+3FtFVG3WfF+4nQOz3bzdoERPheVvemFjnQ==
X-Received: by 2002:a17:907:20ca:b0:87b:d2b3:67ca with SMTP id qq10-20020a17090720ca00b0087bd2b367camr159448ejb.75.1677534837776;
        Mon, 27 Feb 2023 13:53:57 -0800 (PST)
Received: from redhat.com ([2.52.141.194])
        by smtp.gmail.com with ESMTPSA id o15-20020a1709064f8f00b008b17662e1f7sm3721063eju.53.2023.02.27.13.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 13:53:57 -0800 (PST)
Date:   Mon, 27 Feb 2023 16:53:53 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     kvm@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] vhost: use struct_size and size_add to compute flex
 array sizes
Message-ID: <20230227165340-mutt-send-email-mst@kernel.org>
References: <20230227214127.3678392-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227214127.3678392-1-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 01:41:27PM -0800, Jacob Keller wrote:
> The vhost_get_avail_size and vhost_get_used_size functions compute the size
> of structures with flexible array members with an additional 2 bytes if the
> VIRTIO_RING_F_EVENT_IDX feature flag is set. Convert these functions to use
> struct_size() and size_add() instead of coding the calculation by hand.
> 
> This ensures that the calculations will saturate at SIZE_MAX rather than
> overflowing.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Cc: kvm@vger.kernel.org


Acked-by: Michael S. Tsirkin <mst@redhat.com>

Will merge, thanks!
> ---
> 
> I found this using a coccinelle patch I developed and submitted at [1].
> 
> [1]: https://lore.kernel.org/all/20230227202428.3657443-1-jacob.e.keller@intel.com/
> 
>  drivers/vhost/vhost.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index f11bdbe4c2c5..43fa626d4e44 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -436,8 +436,7 @@ static size_t vhost_get_avail_size(struct vhost_virtqueue *vq,
>  	size_t event __maybe_unused =
>  	       vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX) ? 2 : 0;
>  
> -	return sizeof(*vq->avail) +
> -	       sizeof(*vq->avail->ring) * num + event;
> +	return size_add(struct_size(vq->avail, ring, num), event);
>  }
>  
>  static size_t vhost_get_used_size(struct vhost_virtqueue *vq,
> @@ -446,8 +445,7 @@ static size_t vhost_get_used_size(struct vhost_virtqueue *vq,
>  	size_t event __maybe_unused =
>  	       vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX) ? 2 : 0;
>  
> -	return sizeof(*vq->used) +
> -	       sizeof(*vq->used->ring) * num + event;
> +	return size_add(struct_size(vq->used, ring, num), event);
>  }
>  
>  static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
> -- 
> 2.39.1.405.gd4c25cc71f83

