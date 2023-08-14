Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DD777BF47
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 19:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjHNRvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 13:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjHNRuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 13:50:51 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8727710F0
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:50:42 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id 71dfb90a1353d-4872f5cfffdso1216720e0c.2
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1692035441; x=1692640241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LLZ589XCwkf4jjhp9SGI7jmX+IpjbGu8OredhPvpDG4=;
        b=cfDI+oScTaafpm7QXJOik0O50amrmcmILuBuV4iJnQAtEaL2OOnHiOJ8Um2zrO74b9
         xTNpoyzc3JuYcwHN3m+UddWP3/jNbryhMFdLKsYvP3U0pp9w0AVkkW0rnVl8w/Dg/ys1
         rjqRNsSicNb9cNnTltdowdw2L6KXR05Mr/bKm7UEpwZXPmxe78d873u7Y+H0xko3se9n
         UCfgq/maRa37sI6seG7bZN1b7uqWMOZmWZc9ZKghqTQdJOXqx1jdvzh+9t2hbTA8X7vq
         4y+gejDx9FRkckjSh9M/HZBP53wzoQNEgHSYzvQr6BpzGXuTlSvDmkWtv913C0ouPbK0
         +vGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692035441; x=1692640241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LLZ589XCwkf4jjhp9SGI7jmX+IpjbGu8OredhPvpDG4=;
        b=S/nQmmKGGTMPqbcxRxGTcGtNojuGbY4KddnSYQzkuRPuAb/6FGlE6hpt/cxOXcY++e
         RILM0XEuPixEvnvK5WEqil2eTJk8UBfCbKAkYJr1XDm2rHML6jaAcxslrc035lMz4L83
         7Z8mOQmo8r2a2/W0e3hnq/gZNjv3qXS14gUlzJlwRoa1es7sjdh6K/WTaKVBBQKy+DF8
         v0tzO3ExDvw8sHngSsTU9Ar6HTdZw7ZE9vpL2QwNsxDEsoSK+qzdBzo7ArfgnXSN9+lU
         JYvsJhVTzSpKcDtmJaaUGi/d9PXo6d5VoLq9sWeXUhp88/zAUtHbnOqupoXhDKKWvgxr
         lvLg==
X-Gm-Message-State: AOJu0YztdzbBOg6D7sRbr4gcljkBTg10Pm/HdiwYQG+WbNwq6BR7Qt1J
        CVh0Cx5spIT4xiuNi8QJLsOpHA==
X-Google-Smtp-Source: AGHT+IEoeSctuk1Pw0nVc+RaQnZY+V4fEKNljRLyAyTqtAoR5S/yEFwk38vJiT+3M//xOF1Cy9nwiA==
X-Received: by 2002:a1f:c190:0:b0:487:192c:ebbe with SMTP id r138-20020a1fc190000000b00487192cebbemr8785110vkf.10.1692035441613;
        Mon, 14 Aug 2023 10:50:41 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id r6-20020a0ccc06000000b0063d4e41d9adsm3464184qvk.106.2023.08.14.10.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 10:50:41 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qVbiC-0070DY-6R;
        Mon, 14 Aug 2023 14:50:40 -0300
Date:   Mon, 14 Aug 2023 14:50:40 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 2/4] vfio: use __aligned_u64 in struct
 vfio_device_gfx_plane_info
Message-ID: <ZNppcBX3FD2GdcKc@ziepe.ca>
References: <20230809210248.2898981-1-stefanha@redhat.com>
 <20230809210248.2898981-3-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809210248.2898981-3-stefanha@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023 at 05:02:46PM -0400, Stefan Hajnoczi wrote:
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index de675d799c7d..ffab3536dc8a 100644
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
> +		minsz = min(minsz, sizeof(dmabuf));
> +

Huh?

 minsz = min(sizeof(dmabuf), dmabuf.argsz)

>  		ret = intel_vgpu_query_plane(vgpu, &dmabuf);
>  		if (ret != 0)
>  			return ret;
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index c6c6b5d26670..ee42a780041f 100644
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
> +

This one is right

Jason
