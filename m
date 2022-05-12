Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4DA5254A0
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 20:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357556AbiELSVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 14:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357557AbiELSVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 14:21:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C77574AE3C
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652379691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VcoQlfgRlKTkG2QnFhtWwqPtuN/iCo7Oei+ZTVCbp8Q=;
        b=fAngLmbMvbX8Op4WgicQ+9O0N7BNF+u+6hywVo4Go7Qwd965E9/B718Vk4gNskA9LCjmg1
        FjRHpqwW7XS1q9HFWrEtVIBWlpK2Te1hiyDqG7HjQFbsJj57U+K6vdelkVrMrn1t1CqB5v
        xZp8HwbHVxWzNcC8a4Tdq+zGy1nduh0=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-ECaSF7fbO7CfQN2JOZmVEw-1; Thu, 12 May 2022 14:21:27 -0400
X-MC-Unique: ECaSF7fbO7CfQN2JOZmVEw-1
Received: by mail-il1-f197.google.com with SMTP id i15-20020a056e0212cf00b002cf3463ed24so3801607ilm.0
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:21:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=VcoQlfgRlKTkG2QnFhtWwqPtuN/iCo7Oei+ZTVCbp8Q=;
        b=Dmzx/Nrb6XjSNWtK/+mtv4EZRDrOLqh3X5qca27A5kcVnfcPYhwjZt+UHrFR1bnPjA
         eGWlc1hkBk8+MKMCgjAYdM2q4hvSj5oicpge44bjPhecZr3GkmCCElJ6nb06VIvyvlP9
         7C60AWl1GAKFIwWKCHnANgxG2jaMEkyw4X9RKn+NuuT5T2G3z+ThL4AlGVPDf6D9TAIQ
         7hX3sRHxm/Gaf6skJvWSlnt64P0JAJaghR122vsGBAgq5Id/3mgFG5PRhTO/UH5yZB0L
         n2GFtR9NgdUJnWg6A1/gYVd+XswKwIxk6ppaRxtrhKXgccwUuDF2OiaqlUJ5FZPDiAV7
         4JOg==
X-Gm-Message-State: AOAM533ITtxcG4WFnblCCtcSNrjhDOZUUfyAjVka6ABYeDRvGmbZXW8U
        DrX2fQy/fPcJxdzFcR0i3AqpAQIpxrFWOusAEgeH00Dmyq+f8bbOf98sLJkPFGQBK5P/KR7DxcT
        WQrqpHRrWqrre
X-Received: by 2002:a05:6638:112c:b0:32a:e187:db1c with SMTP id f12-20020a056638112c00b0032ae187db1cmr674229jar.30.1652379686425;
        Thu, 12 May 2022 11:21:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrRp6MP9ShOncs1HnxoZReB9N25AEJ1S9eav9CPEBe+VnbpmFQ2wHym+Hz1/03tFiw2rRYCw==
X-Received: by 2002:a05:6638:112c:b0:32a:e187:db1c with SMTP id f12-20020a056638112c00b0032ae187db1cmr674208jar.30.1652379686238;
        Thu, 12 May 2022 11:21:26 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t188-20020a0254c5000000b0032b3a7817d6sm53215jaa.154.2022.05.12.11.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 11:21:25 -0700 (PDT)
Date:   Thu, 12 May 2022 12:21:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@linux.ie>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
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
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
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
        Kevin Tian <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 0/7] Make the rest of the VFIO driver interface use
 vfio_device
Message-ID: <20220512122124.45943a9e.alex.williamson@redhat.com>
In-Reply-To: <0-v4-8045e76bf00b+13d-vfio_mdev_no_group_jgg@nvidia.com>
References: <0-v4-8045e76bf00b+13d-vfio_mdev_no_group_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  5 May 2022 21:08:38 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Prior series have transformed other parts of VFIO from working on struct
> device or struct vfio_group into working directly on struct
> vfio_device. Based on that work we now have vfio_device's readily
> available in all the drivers.
> 
> Update the rest of the driver facing API to use vfio_device as an input.
> 
> The following are switched from struct device to struct vfio_device:
>   vfio_register_notifier()
>   vfio_unregister_notifier()
>   vfio_pin_pages()
>   vfio_unpin_pages()
>   vfio_dma_rw()
> 
> The following group APIs are obsoleted and removed by just using struct
> vfio_device with the above:
>   vfio_group_pin_pages()
>   vfio_group_unpin_pages()
>   vfio_group_iommu_domain()
>   vfio_group_get_external_user_from_dev()
> 
> To retain the performance of the new device APIs relative to their group
> versions optimize how vfio_group_add_container_user() is used to avoid
> calling it when the driver must already guarantee the device is open and
> the container_users incrd.
> 
> The remaining exported VFIO group interfaces are only used by kvm, and are
> addressed by a parallel series.
> 
> This series is based on Christoph's gvt rework here:
> 
>  https://lore.kernel.org/all/5a8b9f48-2c32-8177-1c18-e3bd7bfde558@intel.com/
> 
> and so will need the PR merged first.
> 
> I have a followup series that needs this.
> 
> This is also part of the iommufd work - moving the driver facing interface
> to vfio_device provides a much cleaner path to integrate with iommufd.
> 
> v4:
>  - Use 'device' as the argument name for a struct vfio_device in vfio.c
> v3: https://lore.kernel.org/r/0-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com
>  - Based on VFIO's gvt/iommu merge
>  - Remove mention of mdev_legacy_get_vfio_device() from commit message
>  - Clarify commit message for vfio_dma_rw() conversion
>  - Talk about the open_count change in the commit message
>  - No code change
> v2: https://lore.kernel.org/r/0-v2-6011bde8e0a1+5f-vfio_mdev_no_group_jgg@nvidia.com
>  - Based on Christoph's series so mdev_legacy_get_vfio_device() is removed
>  - Reflow indenting
>  - Use vfio_assert_device_open() and WARN_ON_ONCE instead of open coding
>    the assertion
> v1: https://lore.kernel.org/r/0-v1-a8faf768d202+125dd-vfio_mdev_no_group_jgg@nvidia.com
> 
> Jason Gunthorpe (7):
>   vfio: Make vfio_(un)register_notifier accept a vfio_device
>   vfio/ccw: Remove mdev from struct channel_program
>   vfio/mdev: Pass in a struct vfio_device * to vfio_pin/unpin_pages()
>   vfio/mdev: Pass in a struct vfio_device * to vfio_dma_rw()
>   drm/i915/gvt: Change from vfio_group_(un)pin_pages to
>     vfio_(un)pin_pages
>   vfio: Remove dead code
>   vfio: Remove calls to vfio_group_add_container_user()
> 
>  .../driver-api/vfio-mediated-device.rst       |   4 +-
>  drivers/gpu/drm/i915/gvt/gvt.h                |   5 +-
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |  51 ++-
>  drivers/s390/cio/vfio_ccw_cp.c                |  47 +--
>  drivers/s390/cio/vfio_ccw_cp.h                |   4 +-
>  drivers/s390/cio/vfio_ccw_fsm.c               |   3 +-
>  drivers/s390/cio/vfio_ccw_ops.c               |   7 +-
>  drivers/s390/crypto/vfio_ap_ops.c             |  23 +-
>  drivers/vfio/vfio.c                           | 299 +++---------------
>  include/linux/vfio.h                          |  21 +-
>  10 files changed, 109 insertions(+), 355 deletions(-)

Applied to vfio next branch for v5.19.  Thanks,

Alex

