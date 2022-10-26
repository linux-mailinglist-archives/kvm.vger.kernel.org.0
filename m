Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC58D60EAC8
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 23:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbiJZVZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 17:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbiJZVZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 17:25:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529671A38F
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 14:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666819499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ys5yrKnSWNrdXyOIt/+2hibuD6RgZdYjr5anEvm87I=;
        b=LtqFzzp14WfeSnWvKxREB7Rx+aDjPwYGyCOQ+8appuHvB/PXNY6YJmRmxpYrV9xazC7dny
        lWIwFbZCM+bsz3/wfVN3CN36m/idrbseiz9c8JYwmovAUCYlPIwSTao6euShzbgLoUk+Ct
        9ah2CYoTRHUHcmlyPL09O0zfaf5oGIg=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-134-ftF2-W6tO3ipOyOFIR3KZw-1; Wed, 26 Oct 2022 17:24:58 -0400
X-MC-Unique: ftF2-W6tO3ipOyOFIR3KZw-1
Received: by mail-il1-f197.google.com with SMTP id h20-20020a056e021d9400b00300581edaa5so4160761ila.12
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 14:24:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ys5yrKnSWNrdXyOIt/+2hibuD6RgZdYjr5anEvm87I=;
        b=Q2BH36EqI494x+VHZEsp+OEjpl9jI1HYFMn747YAjH+AXCMEhb7WtwGG0OIdR3urlD
         F0tIMjyOe15Z9SnbECSBrp95tDS3H2AdN6G4ndXB4+YqhUdSmyfFGgrOcV0V/pU9FY3M
         nizr/Wh+q4ReseCugCzObDlV9I+7zG6ESjQ/YNb+OefnLC6XJKE/l2ST6z1DeDC6njy7
         D+NMldJTuCnFctlngJpoAA9rXcFf32zXKLOyllvFZc8r53m1aLCLBP7W6bbzQSFfAgOg
         w0XwVNchRuQ9Bcdy2z/MDoz4BB/WXnJoW02VYDpKbDar0bqlid823ul1UPPyrxUdvLnp
         oqKA==
X-Gm-Message-State: ACrzQf1E/Z33Fy82wGUf0T36nRYMaCUIenLnlbwshbxQGZihrNCoTgl7
        NCeXV7WbKVrgffaQCyWEZGiyojVgOcUxJoEXDjFJsYj0vpsQVT6zfJxJ2fIomgybp8YqBngSpl6
        RyMN748WBqh/o
X-Received: by 2002:a05:6e02:1d14:b0:300:ec5:6c0e with SMTP id i20-20020a056e021d1400b003000ec56c0emr8760515ila.164.1666819497277;
        Wed, 26 Oct 2022 14:24:57 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM78B1N1rhquL7I27LvLWaJii8bhooCw6yJ0rMTPt8axTAAIzjlyMmOikhzath1gqGNuTiEASg==
X-Received: by 2002:a05:6e02:1b08:b0:2fc:4df6:e468 with SMTP id i8-20020a056e021b0800b002fc4df6e468mr27916129ilv.148.1666819486067;
        Wed, 26 Oct 2022 14:24:46 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x13-20020a02948d000000b0036c8a246f54sm2409348jah.142.2022.10.26.14.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 14:24:45 -0700 (PDT)
Date:   Wed, 26 Oct 2022 15:24:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@gmail.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, iommu@lists.linux.dev,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Longfang Liu <liulongfang@huawei.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 04/10] vfio: Move storage of allow_unsafe_interrupts to
 vfio_main.c
Message-ID: <20221026152442.4855c5de.alex.williamson@redhat.com>
In-Reply-To: <4-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
References: <0-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
        <4-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Oct 2022 15:17:10 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This legacy module knob has become uAPI, when set on the vfio_iommu_type1
> it disables some security protections in the iommu drivers. Move the
> storage for this knob to vfio_main.c so that iommufd can access it too.

I don't really understand this, we're changing the behavior of the
iommufd_device_attach() operation based on the modules options of
vfio_iommu_type1, which may not be loaded or even compiled into the
kernel.  Our compatibility story falls apart when VFIO_CONTAINER is not
set, iommufd sneaks in to usurp /dev/vfio/vfio, and the user's module
options for type1 go unprocessed.

I hate to suggest that type1 becomes a module that does nothing more
than maintain consistency of this variable when the full type1 isn't
available, but is that what we need to do?  Thanks,

Alex

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.h             | 2 ++
>  drivers/vfio/vfio_iommu_type1.c | 5 ++---
>  drivers/vfio/vfio_main.c        | 3 +++
>  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index f95f4925b83bbd..54e5a8e0834ccb 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -130,4 +130,6 @@ extern bool vfio_noiommu __read_mostly;
>  enum { vfio_noiommu = false };
>  #endif
>  
> +extern bool vfio_allow_unsafe_interrupts;
> +
>  #endif
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 23c24fe98c00d4..186e33a006d314 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -44,9 +44,8 @@
>  #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
>  #define DRIVER_DESC     "Type1 IOMMU driver for VFIO"
>  
> -static bool allow_unsafe_interrupts;
>  module_param_named(allow_unsafe_interrupts,
> -		   allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
> +		   vfio_allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(allow_unsafe_interrupts,
>  		 "Enable VFIO IOMMU support for on platforms without interrupt remapping support.");
>  
> @@ -2282,7 +2281,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  		    iommu_group_for_each_dev(iommu_group, (void *)IOMMU_CAP_INTR_REMAP,
>  					     vfio_iommu_device_capable);
>  
> -	if (!allow_unsafe_interrupts && !msi_remap) {
> +	if (!vfio_allow_unsafe_interrupts && !msi_remap) {
>  		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
>  		       __func__);
>  		ret = -EPERM;
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 8d809ecd982b39..1e414b2c48a511 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -51,6 +51,9 @@ static struct vfio {
>  	struct ida			device_ida;
>  } vfio;
>  
> +bool vfio_allow_unsafe_interrupts;
> +EXPORT_SYMBOL_GPL(vfio_allow_unsafe_interrupts);
> +
>  static DEFINE_XARRAY(vfio_device_set_xa);
>  static const struct file_operations vfio_group_fops;
>  

