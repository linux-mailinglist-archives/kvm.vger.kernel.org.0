Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2910C624B94
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 21:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiKJUSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 15:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiKJURy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 15:17:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CD94E430
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 12:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668111412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uVnV2DDw0Jhdp1QeqoFk0F1Z/gE4Ln1RaOhIXeyW3wU=;
        b=eb7m06FVuj56TbnRfCdCA0z5gmAE6iMC25Tma95NHHqVm8hmx1Y4+0bC3PDF6YiqXZnPZN
        zkwVDIOLxVYTjcq0WXAH/i4Xtlb00KM2pEAUzQXSo95hbs57JKFPY2K6GxKkFeDaZBv++y
        tZwWb13a7N1cZJ1gFBScv6x4W+dytmE=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-365-NTZORkUkMIeYhKlBgL0o2w-1; Thu, 10 Nov 2022 15:16:51 -0500
X-MC-Unique: NTZORkUkMIeYhKlBgL0o2w-1
Received: by mail-io1-f71.google.com with SMTP id i6-20020a5d88c6000000b006d088a0e518so1776532iol.19
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 12:16:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uVnV2DDw0Jhdp1QeqoFk0F1Z/gE4Ln1RaOhIXeyW3wU=;
        b=e0qC4TaIxTJ0PJ93kXdPIrGB+nTVadi29ByOgqI6jIuvNwyoT7Ya5DX5xgN4pgtXvl
         hBpmbp+R13/p9sQ0UKEh8T+MdtkHZ7pfAP2XX1fdfgcDEm+5GR4AhGQWvHuYv2lUVQKe
         JCSuURaNlf5LxMlBLiPYJWKz2+YcxrZMHTjJZ5y+nv7EIh4tL3ynpzCqIUr1scyT61cz
         f+3Qzr3AjBb9ffe3oOhWLkALHwt475i58v9ILO0Z53rjKvzGzfQsSQ/ra886UqWBxbrM
         WW7jd4aD33AQsSjaC5BJ49IL/ixyN/uwt6O283Ym5Lmbc7yEcAkPn1rYozPDTmx5caJJ
         QAcA==
X-Gm-Message-State: ACrzQf2xphy/amJv3gFpVEKiNYgbQPbRT9NmHOuGjL/qRTaxfPYZA+ah
        XMPac+kgkl3vNQpRWEDfSKv6Wt1Lm8uc9ZSxgedh5t9iCnjmPbz/VbKRcl/OQ643RtMPTYCybBQ
        /93a5LE3x6Qzy
X-Received: by 2002:a92:d70b:0:b0:2f9:516b:25f3 with SMTP id m11-20020a92d70b000000b002f9516b25f3mr3482759iln.156.1668111410911;
        Thu, 10 Nov 2022 12:16:50 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7kmGLkxawxZSF0r3BGM7XEMkdaMXz0cdBNGYH99+jL5O4ssCKnWMKVWwzHqb43uql1tb9xRA==
X-Received: by 2002:a92:d70b:0:b0:2f9:516b:25f3 with SMTP id m11-20020a92d70b000000b002f9516b25f3mr3482749iln.156.1668111410617;
        Thu, 10 Nov 2022 12:16:50 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i7-20020a0566022c8700b006bbea9f45cesm25981iow.38.2022.11.10.12.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 12:16:49 -0800 (PST)
Date:   Thu, 10 Nov 2022 13:16:32 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/7] vfio-ccw parent rework
Message-ID: <20221110131632.4e00f87d.alex.williamson@redhat.com>
In-Reply-To: <20221104142007.1314999-1-farman@linux.ibm.com>
References: <20221104142007.1314999-1-farman@linux.ibm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  4 Nov 2022 15:20:00 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> Hi Alex,
> 
> Here's the (last?) update to the vfio-ccw lifecycle changes that I've sent
> recently, and were previously discussed at various points [1][2].
> 
> Patches 1-5 rework the behavior of the vfio-ccw driver's private struct.
> In summary, the mdev pieces are split out of vfio_ccw_private and into a
> new vfio_ccw_parent struct that will continue to follow today's lifecycle.
> The remainder (bulk) of the private struct moves to follow the mdev
> probe/remove pair. There's opportunity for further separation of the
> things in the private struct, which would simplify some of the vfio-ccw
> code, but it got too hairy as I started that. Once vfio-ccw is no longer
> considered unique, those cleanups can happen at our leisure. 
> 
> Patch 6 removes the trickery where vfio-ccw uses vfio_init_device instead of
> vfio_alloc_device, and thus removes vfio_init_device from the outside world.
> 
> Patch 7 removes vfio_free_device from vfio-ccw and the other drivers (hello,
> CC list!), letting it be handled by vfio_device_release directly.
> 
> I believe this covers everything in this space; let me know if not!
> 
> Thanks,
> Eric
> 
> [1] https://lore.kernel.org/kvm/0-v3-57c1502c62fd+2190-ccw_mdev_jgg@nvidia.com/
> [2] https://lore.kernel.org/kvm/20220602171948.2790690-1-farman@linux.ibm.com/
> 
> v2->v3:
>  - [MR] Added r-b to remaining patches (Thank you!)
>  - Patch 1:
>    [gfx checkpatch] Whitespace
>    [EF] Remove put_device(&parent->dev)
>    [MR] Fix error exit when alloc of parent fails
>    [MR] Check for !private on sch_probe error path
>  - Patch 3:
>    [EF] Fix error exit when alloc of private fails
>  - Patch 6:
>    [AW] Added ack (Thank you!)
>  - Patch 7:
>    [CH, AK] Added r-b (Thank you!)
>    [AW] Added ack (Thank you!)
> v2: https://lore.kernel.org/kvm/20221102150152.2521475-1-farman@linux.ibm.com/
> v1: https://lore.kernel.org/kvm/20221019162135.798901-1-farman@linux.ibm.com/
> 
> Eric Farman (7):
>   vfio/ccw: create a parent struct
>   vfio/ccw: remove private->sch
>   vfio/ccw: move private initialization to callback
>   vfio/ccw: move private to mdev lifecycle
>   vfio/ccw: remove release completion
>   vfio/ccw: replace vfio_init_device with _alloc_
>   vfio: Remove vfio_free_device
> 
>  drivers/gpu/drm/i915/gvt/kvmgt.c      |   1 -
>  drivers/s390/cio/vfio_ccw_chp.c       |   5 +-
>  drivers/s390/cio/vfio_ccw_drv.c       | 173 +++++++++++---------------
>  drivers/s390/cio/vfio_ccw_fsm.c       |  27 ++--
>  drivers/s390/cio/vfio_ccw_ops.c       | 107 +++++++++++-----
>  drivers/s390/cio/vfio_ccw_private.h   |  37 ++++--
>  drivers/s390/crypto/vfio_ap_ops.c     |   6 -
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c     |   1 -
>  drivers/vfio/pci/vfio_pci_core.c      |   1 -
>  drivers/vfio/platform/vfio_amba.c     |   1 -
>  drivers/vfio/platform/vfio_platform.c |   1 -
>  drivers/vfio/vfio_main.c              |  32 ++---
>  include/linux/vfio.h                  |   3 -
>  samples/vfio-mdev/mbochs.c            |   1 -
>  samples/vfio-mdev/mdpy.c              |   1 -
>  samples/vfio-mdev/mtty.c              |   1 -
>  16 files changed, 196 insertions(+), 202 deletions(-)
> 

Applied to vfio next branch for v6.2.  Thanks,

Alex

