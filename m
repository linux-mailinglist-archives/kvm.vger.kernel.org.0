Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706867A279F
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 22:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236780AbjIOUGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 16:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237183AbjIOUGV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 16:06:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59287272A
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 13:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694808302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7NfUcQ09mB7dsUpfhcIFawf5HcTW8vmdNnitXI7u8bM=;
        b=PPTPLSC8u4Z9AZdKX188RcDT3DmA3lATsZ9vTxmRlpVah2hRfUGrbAZetQItbmFRT8Exlf
        ulblrfZeUU55kK6JQMsp1LMogLDGGt4ZHoglTWtkn9xzyXmDOve0Ar5+37M15/MS+iIisx
        m6U93JiQhQKkISLLK1RrwpTe1cliaQs=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-ndYxBt6aOx-p3VFlZK7urg-1; Fri, 15 Sep 2023 16:05:01 -0400
X-MC-Unique: ndYxBt6aOx-p3VFlZK7urg-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-786a6443490so239410039f.0
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 13:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694808300; x=1695413100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7NfUcQ09mB7dsUpfhcIFawf5HcTW8vmdNnitXI7u8bM=;
        b=So5Ph1771Ezlj2ClfIfTqPh5YzgbHxooY+B/j6HZT3Z7n62jMQmUYCKcpAriJtusRb
         Qo/YxncskJSRmJDbhSFHcUBPDCZF6ILk2ueILURYLE3k4p/nBX8c2+lp8Q5WM9Cheg22
         p0vVaY+5Un613UANxjltE8Iddz6Rsaj4P62q3PqIpYiUAjHiIjJX+kXxT41xw16Sc/LM
         wmVhgViWBEo7ZJN4O46ANWtwYcwZiEhUxByLJW0iQ11M30OrD09NQH9CL/bw9+7eZFcV
         r2tLbQXZYU9JSj+zzbpU3kkrW5tQ3pl81qI9ypAE5ZNhwPu8KgZbDuKkKxpTxG3ObRlD
         s4hQ==
X-Gm-Message-State: AOJu0YyF7TBMvZuMcJMeWkq2esOyehIiB+XhI429whEgfL+V8yRCtY8E
        qLkqEWzm9L3K49W5yg5WUGcnSJuyTImHIY1oaTU1LztVc+9hRcVFmT/Cx4dfpzgvg7FdM8VxgtZ
        egAPdg6jwQrcHBZj0PWJ+
X-Received: by 2002:a5e:d60f:0:b0:786:ca40:cc88 with SMTP id w15-20020a5ed60f000000b00786ca40cc88mr2412921iom.11.1694808300564;
        Fri, 15 Sep 2023 13:05:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG79Z55l7FWxwdyALDEtiQh1NRLDz1G37ohGh9uUvII18nmS6T558Af+KIpjkgLftQaXJ32DQ==
X-Received: by 2002:a5e:d60f:0:b0:786:ca40:cc88 with SMTP id w15-20020a5ed60f000000b00786ca40cc88mr2412906iom.11.1694808300220;
        Fri, 15 Sep 2023 13:05:00 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id j3-20020a02cc63000000b0042b320c13aasm1290128jaq.89.2023.09.15.13.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 13:04:59 -0700 (PDT)
Date:   Fri, 15 Sep 2023 14:04:58 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 2/3] vfio: use __aligned_u64 in struct
 vfio_device_gfx_plane_info
Message-ID: <20230915140458.392e436a.alex.williamson@redhat.com>
In-Reply-To: <20230829182720.331083-3-stefanha@redhat.com>
References: <20230829182720.331083-1-stefanha@redhat.com>
        <20230829182720.331083-3-stefanha@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Aug 2023 14:27:19 -0400
Stefan Hajnoczi <stefanha@redhat.com> wrote:

> The memory layout of struct vfio_device_gfx_plane_info is
> architecture-dependent due to a u64 field and a struct size that is not
> a multiple of 8 bytes:
> - On x86_64 the struct size is padded to a multiple of 8 bytes.
> - On x32 the struct size is only a multiple of 4 bytes, not 8.
> - Other architectures may vary.
> 
> Use __aligned_u64 to make memory layout consistent. This reduces the
> chance of 32-bit userspace on a 64-bit kernel breakage.
> 
> This patch increases the struct size on x32 but this is safe because of
> the struct's argsz field. The kernel may grow the struct as long as it
> still supports smaller argsz values from userspace (e.g. applications
> compiled against older kernel headers).
> 
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  include/uapi/linux/vfio.h        | 3 ++-
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 4 +++-
>  samples/vfio-mdev/mbochs.c       | 6 ++++--
>  samples/vfio-mdev/mdpy.c         | 4 +++-
>  4 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 94007ca348ed..777374dd7725 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -816,7 +816,7 @@ struct vfio_device_gfx_plane_info {
>  	__u32 drm_plane_type;	/* type of plane: DRM_PLANE_TYPE_* */
>  	/* out */
>  	__u32 drm_format;	/* drm format of plane */
> -	__u64 drm_format_mod;   /* tiled mode */
> +	__aligned_u64 drm_format_mod;   /* tiled mode */
>  	__u32 width;	/* width of plane */
>  	__u32 height;	/* height of plane */
>  	__u32 stride;	/* stride of plane */
> @@ -829,6 +829,7 @@ struct vfio_device_gfx_plane_info {
>  		__u32 region_index;	/* region index */
>  		__u32 dmabuf_id;	/* dma-buf id */
>  	};
> +	__u32 reserved;
>  };
>  
>  #define VFIO_DEVICE_QUERY_GFX_PLANE _IO(VFIO_TYPE, VFIO_BASE + 14)
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 9cd9e9da60dd..813cfef23453 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1382,7 +1382,7 @@ static long intel_vgpu_ioctl(struct vfio_device *vfio_dev, unsigned int cmd,
>  		intel_gvt_reset_vgpu(vgpu);
>  		return 0;
>  	} else if (cmd == VFIO_DEVICE_QUERY_GFX_PLANE) {
> -		struct vfio_device_gfx_plane_info dmabuf;
> +		struct vfio_device_gfx_plane_info dmabuf = {};
>  		int ret = 0;
>  
>  		minsz = offsetofend(struct vfio_device_gfx_plane_info,
> @@ -1392,6 +1392,8 @@ static long intel_vgpu_ioctl(struct vfio_device *vfio_dev, unsigned int cmd,
>  		if (dmabuf.argsz < minsz)
>  			return -EINVAL;
>  
> +		minsz = min(dmabuf.argsz, sizeof(dmabuf));
> +
>  		ret = intel_vgpu_query_plane(vgpu, &dmabuf);
>  		if (ret != 0)
>  			return ret;
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 3764d1911b51..78aa977ae597 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -1262,7 +1262,7 @@ static long mbochs_ioctl(struct vfio_device *vdev, unsigned int cmd,
>  
>  	case VFIO_DEVICE_QUERY_GFX_PLANE:
>  	{
> -		struct vfio_device_gfx_plane_info plane;
> +		struct vfio_device_gfx_plane_info plane = {};
>  
>  		minsz = offsetofend(struct vfio_device_gfx_plane_info,
>  				    region_index);
> @@ -1273,11 +1273,13 @@ static long mbochs_ioctl(struct vfio_device *vdev, unsigned int cmd,
>  		if (plane.argsz < minsz)
>  			return -EINVAL;
>  
> +		outsz = min_t(unsigned long, plane.argsz, sizeof(plane));

Sorry, I'm struggling with why these two sample drivers use min_t()
when passed the exact same args as kvmgt above which just uses min().

But more importantly I'm also confused why we need this at all.  The
buffer we're copying to is provided by the user, so what's wrong with
leaving the user provided reserved data?  Are we just trying to return
a zero'd reserved field if argsz allows for it?

Any use of the reserved field other than as undefined data would need
to be associated with a flags bit, so I don't think it's buying us
anything to return it zero'd.  What am I missing?  Thanks,

Alex

> +
>  		ret = mbochs_query_gfx_plane(mdev_state, &plane);
>  		if (ret)
>  			return ret;
>  
> -		if (copy_to_user((void __user *)arg, &plane, minsz))
> +		if (copy_to_user((void __user *)arg, &plane, outsz))
>  			return -EFAULT;
>  
>  		return 0;
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 064e1c0a7aa8..f5c2effc1cec 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -591,7 +591,7 @@ static long mdpy_ioctl(struct vfio_device *vdev, unsigned int cmd,
>  
>  	case VFIO_DEVICE_QUERY_GFX_PLANE:
>  	{
> -		struct vfio_device_gfx_plane_info plane;
> +		struct vfio_device_gfx_plane_info plane = {};
>  
>  		minsz = offsetofend(struct vfio_device_gfx_plane_info,
>  				    region_index);
> @@ -602,6 +602,8 @@ static long mdpy_ioctl(struct vfio_device *vdev, unsigned int cmd,
>  		if (plane.argsz < minsz)
>  			return -EINVAL;
>  
> +		minsz = min_t(unsigned long, plane.argsz, sizeof(plane));
> +
>  		ret = mdpy_query_gfx_plane(mdev_state, &plane);
>  		if (ret)
>  			return ret;

