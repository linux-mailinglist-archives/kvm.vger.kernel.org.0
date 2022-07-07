Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF4556ADCB
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 23:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbiGGVhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 17:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236758AbiGGVhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 17:37:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F6E4564CD
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 14:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657229840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xSEXwFPAyvrhENqvrLwIjRSY51Sdjq2lfUdnz+vUg/A=;
        b=M0QzzRVetuZa5CfrlWbXtG9PlULDbEtjNsUblJirO+UKIJE37iR+Tm48k5Sqm50wp1GWpG
        cHACwY5BjDC5eIpZ/wAWm+/290zYBVFIyuZdYOdUQd4LIQHo4+Jf8nUsllhHbg4vc6st2D
        QGX8qZ+GMFS9NCq/6DXfLkp0yQQNNBI=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-PMQqN0m2OuOs7zgp5Vbikw-1; Thu, 07 Jul 2022 17:37:19 -0400
X-MC-Unique: PMQqN0m2OuOs7zgp5Vbikw-1
Received: by mail-il1-f199.google.com with SMTP id l4-20020a056e021aa400b002dab8f7402dso9990302ilv.18
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 14:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xSEXwFPAyvrhENqvrLwIjRSY51Sdjq2lfUdnz+vUg/A=;
        b=6wYcldbrWhYDp3KgcfgIGb5/Q6ASWHJQ35mQmdly25jOOi6bHD6DzQ1Zv43BrxSU7L
         u7tceQnsMzsy+78AYV70/7+WDkAPEj4P0txalPwE4GeTQZ4KqRE+Mx64HkJBFQl0PEd1
         PWh1Z1NjdL8FSo8cVEJeFXoKgxUc+QXG0eK94Xea3XsO9YvDiXi7uzKQf1wxurCh7j1I
         nEiUXpl/glv+LlqXmvrIExB7HYRhkup4Go3BrU6QgE1QEP9O6/S/E+Mjv5jHV7lpIFGC
         IvDcPV+siJpMqtJPkKzrbLXUK7gBkdlqVJ/e2BtUNiJBD1jFme50QJ0Hz5U1tHAcebR1
         Gfhw==
X-Gm-Message-State: AJIora+UfiYTk0jduFGxClRfUPs9AfV8RyHN3sW6RFduYcA4eLEzWtR5
        kjn52KyYX2qv5dhvLiK+fp4uNoLSEb+rn4vk0w3/4e0xdGueMx+m8O65h9Fzre81shRZw7Dpc1n
        /XbCOhe5POV2P
X-Received: by 2002:a05:6e02:928:b0:2dc:759:7817 with SMTP id o8-20020a056e02092800b002dc07597817mr113879ilt.84.1657229838429;
        Thu, 07 Jul 2022 14:37:18 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s70GZAk3YrQZOFfNpy3nkoHR4IJbk/AIEya6UVHis8OCEYOJsN20yij7l5PEEyvprcYnTFbw==
X-Received: by 2002:a05:6e02:928:b0:2dc:759:7817 with SMTP id o8-20020a056e02092800b002dc07597817mr113848ilt.84.1657229838191;
        Thu, 07 Jul 2022 14:37:18 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id j62-20020a026341000000b0033ed7ef1b5csm5136571jac.41.2022.07.07.14.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 14:37:17 -0700 (PDT)
Date:   Thu, 7 Jul 2022 15:37:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@linux.ie>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v3 1/2] vfio: Replace the DMA unmapping notifier with a
 callback
Message-ID: <20220707153716.70f755ab.alex.williamson@redhat.com>
In-Reply-To: <1-v3-7593f297c43f+56ce-vfio_unmap_notif_jgg@nvidia.com>
References: <0-v3-7593f297c43f+56ce-vfio_unmap_notif_jgg@nvidia.com>
        <1-v3-7593f297c43f+56ce-vfio_unmap_notif_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  4 Jul 2022 21:59:03 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index b49e2e9db2dc6f..09e0ce7b72324c 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -44,31 +44,19 @@ static int vfio_ccw_mdev_reset(struct vfio_ccw_private *private)
>  	return ret;
>  }
>  
> -static int vfio_ccw_mdev_notifier(struct notifier_block *nb,
> -				  unsigned long action,
> -				  void *data)
> +static void vfio_ccw_dma_unmap(struct vfio_device *vdev, u64 iova, u64 length)
>  {
>  	struct vfio_ccw_private *private =
> -		container_of(nb, struct vfio_ccw_private, nb);
> -
> -	/*
> -	 * Vendor drivers MUST unpin pages in response to an
> -	 * invalidation.
> -	 */
> -	if (action == VFIO_IOMMU_NOTIFY_DMA_UNMAP) {
> -		struct vfio_iommu_type1_dma_unmap *unmap = data;
> -
> -		if (!cp_iova_pinned(&private->cp, unmap->iova))
> -			return NOTIFY_OK;
> +		container_of(vdev, struct vfio_ccw_private, vdev);
>  
> -		if (vfio_ccw_mdev_reset(private))
> -			return NOTIFY_BAD;
> +	/* Drivers MUST unpin pages in response to an invalidation. */
> +	if (!cp_iova_pinned(&private->cp, iova))
> +		return;
>  
> -		cp_free(&private->cp);
> -		return NOTIFY_OK;
> -	}
> +	if (vfio_ccw_mdev_reset(private))
> +		return;
>  
> -	return NOTIFY_DONE;
> +	cp_free(&private->cp);
>  }


The cp_free() call is gone here with [1], so I think this function now
just ends with:

	...
	vfio_ccw_mdev_reset(private);
}

There are also minor contextual differences elsewhere from that series,
so a quick respin to record the changes on list would be appreciated.

However the above kind of highlights that NOTIFY_BAD that silently gets
dropped here.  I realize we weren't testing the return value of the
notifier call chain and really we didn't intend that notifiers could
return a failure here, but does this warrant some logging or suggest
future work to allow a device to go offline here?  Thanks.

Alex

[1]https://lore.kernel.org/all/20220707135737.720765-1-farman@linux.ibm.com/

