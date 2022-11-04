Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E0661A2D7
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 22:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiKDVAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 17:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiKDVAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 17:00:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE4FCE16
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 13:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667595560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9PRXocQQ9D0gf9vlyRd6zfQgGX54fsxvJSqHCf3zp+A=;
        b=RVRPMml84+xRRoZUdVlAizWInjpMz+2EQaRk028CBI8JonmNiiP84Mf9mf8eT/zhI9o2iB
        vCE/7+cK4TycHP4B/ML/0MuiEUpZjVx8Cw35cfB/2mj+LtR9P8TDpS4kQ8PdTIdugzoTTV
        gWakyXAT1JoWUo/hFKApcsCqq0kVtuc=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-523-M_o8dm-sMValYohyAD0BWg-1; Fri, 04 Nov 2022 16:59:19 -0400
X-MC-Unique: M_o8dm-sMValYohyAD0BWg-1
Received: by mail-io1-f69.google.com with SMTP id j17-20020a5d93d1000000b006bcdc6b49cbso3783773ioo.22
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 13:59:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9PRXocQQ9D0gf9vlyRd6zfQgGX54fsxvJSqHCf3zp+A=;
        b=ZFtVhNEJOlyl5DEXwn5GBdaO7nyisbG5s4ni7zh1ma3lEp9Okjw9FgwXIT4thZvzh9
         WbTW3/8hAc/exlqEg7BZVlUkEGKVlGjjgV0yPUAFTZ2ebwLwcWJKOYlckSzf9NW3+gyu
         Q5a92oJ30v2tS8kxYpZkb1nHKT6IZYFwcLM0k5f+/K80gnL2vQTURP83h0uIFDYnziHB
         xu/vr8G9cp5qNwlW7g2rq9L6T0K+j8+HC7DDnUQOViRHonjyl42tDAOGN/vc6so3lvv0
         1K47LwHKPNfVgCAaUM7h/0yiJQXsd115i7fVYSANNUkAGwLSsl+GnYKUhvyyDoOSwAMa
         AO9w==
X-Gm-Message-State: ACrzQf0M8e9WNIf0k+ZYat7N0PgX33rgWScYTIjorkigpa8dGhAQ9iPJ
        2wNAt5Hqm7BVnxu7QAoUA4ZcecPxwbRZiespNkpBOteGCfchG7uGKAiflaGDhinEV6ny5BOeJI8
        LKYu8NBkEg1YX
X-Received: by 2002:a02:c4d7:0:b0:375:780e:dbbb with SMTP id h23-20020a02c4d7000000b00375780edbbbmr11651954jaj.305.1667595558643;
        Fri, 04 Nov 2022 13:59:18 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6qzWALPD0DXDfYhWInBlUQ8tnm9C1GJ9zrBeETZQgjbyvtWW+TWjFyI2zQRM9nTKpO5a9Ehw==
X-Received: by 2002:a02:c4d7:0:b0:375:780e:dbbb with SMTP id h23-20020a02c4d7000000b00375780edbbbmr11651941jaj.305.1667595558428;
        Fri, 04 Nov 2022 13:59:18 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i65-20020a6bb844000000b0068869b84b02sm36151iof.21.2022.11.04.13.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 13:59:17 -0700 (PDT)
Date:   Fri, 4 Nov 2022 14:59:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Anthony DeRossi <ajderossi@gmail.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: Re: [PATCH v4 1/3] vfio: Fix container device registration life
 cycle
Message-ID: <20221104145915.1dcdbc93.alex.williamson@redhat.com>
In-Reply-To: <20221104195727.4629-2-ajderossi@gmail.com>
References: <20221104195727.4629-1-ajderossi@gmail.com>
        <20221104195727.4629-2-ajderossi@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  4 Nov 2022 12:57:25 -0700
Anthony DeRossi <ajderossi@gmail.com> wrote:

> In vfio_device_open(), vfio_container_device_register() is always called
> when open_count == 1. On error, vfio_device_container_unregister() is
> only called when open_count == 1 and close_device is set. This leaks a
> registration for devices without a close_device implementation.
> 
> In vfio_device_fops_release(), vfio_device_container_unregister() is
> called unconditionally. This can cause a device to be unregistered
> multiple times.
> 
> Treating container device registration/unregistration uniformly (always
> when open_count == 1) fixes both issues.

Good catch, I see that Jason does subtly fix this in "vfio: Move
vfio_device driver open/close code to a function", but I'd rather see
it more overtly fixed in a discrete patch like this.  All "real"
drivers provide a close_device callback, but mdpy and mtty do not.
Thanks,

Alex

> Fixes: ce4b4657ff18 ("vfio: Replace the DMA unmapping notifier with a callback")
> Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
> ---
>  drivers/vfio/vfio_main.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 2d168793d4e1..9a4af880e941 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -801,8 +801,9 @@ static struct file *vfio_device_open(struct vfio_device *device)
>  err_close_device:
>  	mutex_lock(&device->dev_set->lock);
>  	mutex_lock(&device->group->group_lock);
> -	if (device->open_count == 1 && device->ops->close_device) {
> -		device->ops->close_device(device);
> +	if (device->open_count == 1) {
> +		if (device->ops->close_device)
> +			device->ops->close_device(device);
>  
>  		vfio_device_container_unregister(device);
>  	}
> @@ -1017,10 +1018,12 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  	mutex_lock(&device->dev_set->lock);
>  	vfio_assert_device_open(device);
>  	mutex_lock(&device->group->group_lock);
> -	if (device->open_count == 1 && device->ops->close_device)
> -		device->ops->close_device(device);
> +	if (device->open_count == 1) {
> +		if (device->ops->close_device)
> +			device->ops->close_device(device);
>  
> -	vfio_device_container_unregister(device);
> +		vfio_device_container_unregister(device);
> +	}
>  	mutex_unlock(&device->group->group_lock);
>  	device->open_count--;
>  	if (device->open_count == 0)

