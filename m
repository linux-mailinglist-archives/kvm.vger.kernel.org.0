Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A8D57EA0D
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 00:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiGVWud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 18:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiGVWuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 18:50:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D1AD10B6
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 15:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658530229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CK6lmXhfwHfiatVMUw8JndR4RA0GTNn0tRqyQRH49OE=;
        b=ZHylcURL5xcRNw+TYWumTJPBJEkTIYcyzIGC53iCnIVv8ydfCMYK4tSv6IcqXyt8A4+1qR
        Ni61608qygCmHvT9FbR6CNxKTxGVBenzERFZ796At47uNx/wm93QqFML5jQ9ZzKUSpWnPQ
        cSOmbVgVkrVh4euwfiE72cYtEZwBJZ0=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-JQfxnYi6MViwQBp267YoZA-1; Fri, 22 Jul 2022 18:50:28 -0400
X-MC-Unique: JQfxnYi6MViwQBp267YoZA-1
Received: by mail-io1-f69.google.com with SMTP id m9-20020a6b7b49000000b0067c0331524cso2329733iop.21
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 15:50:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=CK6lmXhfwHfiatVMUw8JndR4RA0GTNn0tRqyQRH49OE=;
        b=8AQXh6BQZ8NTygwYYygfPcwSTKZou4FWI6f8DjJvNWotP1wh8reaATMmP4l20oWVfH
         PP3C+rQ83dY3S4w0LKTlGmG2aoeQD4MBdTvBVq5Onl4nncjJmSVpPp2Od5A9QDFMnCGX
         6IUrcprFWo0dY0dBLwM1lwKAnTJKEwzDLcc3hK12aq1tE+kTKuYWj9ZMoiCbvqnuE0tT
         /ZDTWgdYuMl63d0Z1NeqtaDDDAKoekdUUDDr3XjIO559Msenimp9kk9dEnyHpgJfYtDb
         Z6N7JVINEuWjAqAPQmukAxAvNDX/uWLsqy4IV4rvcT2+1nApOVR+4M12ZiZ1aWNMHSSl
         j/lQ==
X-Gm-Message-State: AJIora8wndC1c3spcj2kjIjRhHjIh2DQtJbguX5B5RYNJp86D8C71/VC
        9qeq92X65to69F7a3xjUEw9yYOnGhjN5KONZSTIym+/1lF4nMdnEbMVNn0glxCSgfjNqarQZWFE
        00l7OIsSmXe2v
X-Received: by 2002:a05:6638:3181:b0:32a:eb54:1152 with SMTP id z1-20020a056638318100b0032aeb541152mr951290jak.120.1658530227581;
        Fri, 22 Jul 2022 15:50:27 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s5wn4lDkAQ/yj/kizLiq+//m5jdlQMu2EqfOktCU40xQgJvUisSso9AjpCLGmeYpAf31sEIQ==
X-Received: by 2002:a05:6638:3181:b0:32a:eb54:1152 with SMTP id z1-20020a056638318100b0032aeb541152mr951286jak.120.1658530227371;
        Fri, 22 Jul 2022 15:50:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f41-20020a0284ac000000b0033f3fcba96bsm2532614jai.100.2022.07.22.15.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 15:50:26 -0700 (PDT)
Date:   Fri, 22 Jul 2022 16:50:24 -0600
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
        Zhi Wang <zhi.a.wang@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v4 0/2] Remove the VFIO_IOMMU_NOTIFY_DMA_UNMAP notifier
Message-ID: <20220722165024.7a41778f.alex.williamson@redhat.com>
In-Reply-To: <0-v4-681e038e30fd+78-vfio_unmap_notif_jgg@nvidia.com>
References: <0-v4-681e038e30fd+78-vfio_unmap_notif_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jul 2022 21:02:47 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This is the last notifier toward the drivers, replace it with a simple op
> callback in the vfio_device_ops.
> 
> v4:
>  - Rebase over the CCW series
> v3: https://lore.kernel.org/r/0-v3-7593f297c43f+56ce-vfio_unmap_notif_jgg@nvidia.com
>  - Remove 'nb' doc string from ccw
>  - Rebase on extern removal patch
>  - Check that register_device/unregister_device are either both defined or
>    not
>  - Remove check of dma_unmap during vfio_register_iommu_driver() as it
>    would break the drivers that don't use pin_pages
>  - Don't change VFIO_IOMMU_NOTIFY_DMA_UNMAP to an enum since we are not
>    keeping it anyhow
> v2: https://lore.kernel.org/r/0-v2-80aa110d03ce+24b-vfio_unmap_notif_jgg@nvidia.com
>  - Declare and initialize variables in intel_vgpu_dma_unmap()
>  - Remove 'vendor' when touching comments
>  - Remove kdoc for vfio dma_unmap notifier
>  - Add WARN_ON to vfio_register_emulated_iommu_dev() since dma_unmap is
>    mandatory
>  - Move dma_unmap call loop to vfio_notify_dma_unmap()
>  - Document why the double mutex is being used and why the mutex lock is
>    dropped when calling dma_unmap
> v1: https://lore.kernel.org/r/0-v1-896844109f36+a-vfio_unmap_notif_jgg@nvidia.com
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason Gunthorpe (2):
>   vfio: Replace the DMA unmapping notifier with a callback
>   vfio: Replace the iommu notifier with a device list
> 
>  drivers/gpu/drm/i915/gvt/gvt.h        |   1 -
>  drivers/gpu/drm/i915/gvt/kvmgt.c      |  75 +++++-------------
>  drivers/s390/cio/vfio_ccw_ops.c       |  39 ++--------
>  drivers/s390/cio/vfio_ccw_private.h   |   2 -
>  drivers/s390/crypto/vfio_ap_ops.c     |  53 ++-----------
>  drivers/s390/crypto/vfio_ap_private.h |   3 -
>  drivers/vfio/vfio.c                   | 108 ++++++--------------------
>  drivers/vfio/vfio.h                   |   9 +--
>  drivers/vfio/vfio_iommu_type1.c       | 103 +++++++++++++++---------
>  include/linux/vfio.h                  |  21 +----
>  10 files changed, 132 insertions(+), 282 deletions(-)
> 
> 
> base-commit: 2a8ed7ef00b939fbcc98b948f780bd03bafed227

Applied to vfio next branch for v5.20.  Applied as posted since
Nicolin's series regressed GVT-g support.  Thanks,

Alex

