Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FE5621F5A
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 23:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiKHWbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 17:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiKHWad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 17:30:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1742817AAA
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 14:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667946517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pAwH+5JDvufKDL3NMoeBuf7w8Ln38eP9Ts8frUc7hNk=;
        b=AP9E/YatBORnNdyZAhw4GmmzpSxMmZMGLvdbanNR2Tl7e7VAJsfP1mWTZzOVMcdDXAyFcr
        VjHXlhhjoQ4V7maq/eVxoiQN1OQY7808SlqJt3o6zCUWNEkqMRJtQdJ4uG5qXCjcwlIZkT
        1pGqGmMbGkYTfrDO3QQL+1+tQdC5f+I=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-635-AN2_CwGKMnee2GyFM20-uQ-1; Tue, 08 Nov 2022 17:28:36 -0500
X-MC-Unique: AN2_CwGKMnee2GyFM20-uQ-1
Received: by mail-io1-f72.google.com with SMTP id r197-20020a6b8fce000000b006c3fc33424dso10043469iod.5
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 14:28:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pAwH+5JDvufKDL3NMoeBuf7w8Ln38eP9Ts8frUc7hNk=;
        b=ILqpT3AVpzurk5lQJQNL3kLGNWOzf4TCXenJfbdldEX24V33dlB5EgR0GbBXs4gbD8
         BpsrYB6BwtNI5yXLXRgvoPQJuU8tKSBytYSa2teUpA8F7tdNYLygM3VPoM2zAl+llNo7
         DOu4AyEzIzkKNPauyEkK+8N0+D9pNhJFy8PtldlpcG86bBpP88RylOsjgIqYgFCF5b+M
         eXHK4ZwpqIexsfwTqs8o8fsVRQ8UdK6IK4hEoUL1cXTZf0tRejUeNfPd1llOBegXQsCu
         s0wcciHBb4tig3LT6eP3iM8YfiGBp5/R2/LivRd750ywYuou9H2erhJNMtWmorXzqH6G
         TgrQ==
X-Gm-Message-State: ACrzQf0rnI1aI3pjr1xjzvVESu5Do02cy8mDQLNYOKW2EHr8iWue+44P
        GHfvnvSrLabeThfdlh0vy7IYsz7rZesjrVs05FZOSAvlHWbHIuX5baFwfWypp375bLZX0wK2mH8
        FegTInE/CjFNC
X-Received: by 2002:a05:6638:3e1b:b0:373:9526:ff23 with SMTP id co27-20020a0566383e1b00b003739526ff23mr1059582jab.25.1667946515340;
        Tue, 08 Nov 2022 14:28:35 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7qQUvxc2/UNOHomsJy1dPTa1Nkgqu6DzA5Et+Lrzoib29h+Bm9PbubEw1u6deu68awl9vxhQ==
X-Received: by 2002:a05:6638:3e1b:b0:373:9526:ff23 with SMTP id co27-20020a0566383e1b00b003739526ff23mr1059545jab.25.1667946515058;
        Tue, 08 Nov 2022 14:28:35 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k9-20020a026609000000b003753b6452f9sm4039228jac.35.2022.11.08.14.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 14:28:34 -0800 (PST)
Date:   Tue, 8 Nov 2022 15:28:31 -0700
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
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 10/11] vfio: Make vfio_container optionally compiled
Message-ID: <20221108152831.1a2ed3df.alex.williamson@redhat.com>
In-Reply-To: <10-v2-65016290f146+33e-vfio_iommufd_jgg@nvidia.com>
References: <0-v2-65016290f146+33e-vfio_iommufd_jgg@nvidia.com>
        <10-v2-65016290f146+33e-vfio_iommufd_jgg@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  7 Nov 2022 20:52:54 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Add a kconfig CONFIG_VFIO_CONTAINER that controls compiling the container
> code. If 'n' then only iommufd will provide the container service. All the
> support for vfio iommu drivers, including type1, will not be built.
> 
> This allows a compilation check that no inappropriate dependencies between
> the device/group and container have been created.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/Kconfig  | 35 +++++++++++++++--------
>  drivers/vfio/Makefile |  4 +--
>  drivers/vfio/vfio.h   | 65 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 91 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 1118d322eec97d..286c1663bd7564 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -3,8 +3,8 @@ menuconfig VFIO
>  	tristate "VFIO Non-Privileged userspace driver framework"
>  	select IOMMU_API
>  	depends on IOMMUFD || !IOMMUFD
> -	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
>  	select INTERVAL_TREE
> +	select VFIO_CONTAINER if IOMMUFD=n
>  	help
>  	  VFIO provides a framework for secure userspace device drivers.
>  	  See Documentation/driver-api/vfio.rst for more details.
> @@ -12,6 +12,18 @@ menuconfig VFIO
>  	  If you don't know what to do here, say N.
>  
>  if VFIO
> +config VFIO_CONTAINER
> +	bool "Support for the VFIO container /dev/vfio/vfio"
> +	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> +	default y
> +	help
> +	  The VFIO container is the classic interface to VFIO for establishing
> +	  IOMMU mappings. If N is selected here then IOMMUFD must be used to
> +	  manage the mappings.
> +
> +	  Unless testing IOMMUFD say Y here.
> +
> +if VFIO_CONTAINER
>  config VFIO_IOMMU_TYPE1
>  	tristate
>  	default n
> @@ -21,16 +33,6 @@ config VFIO_IOMMU_SPAPR_TCE
>  	depends on SPAPR_TCE_IOMMU
>  	default VFIO
>  
> -config VFIO_SPAPR_EEH
> -	tristate
> -	depends on EEH && VFIO_IOMMU_SPAPR_TCE
> -	default VFIO
> -
> -config VFIO_VIRQFD
> -	tristate
> -	select EVENTFD
> -	default n
> -
>  config VFIO_NOIOMMU
>  	bool "VFIO No-IOMMU support"
>  	help


Perhaps this should have been obvious, but I'm realizing that
vfio-noiommu mode is completely missing without VFIO_CONTAINER, which
seems a barrier to deprecating VFIO_CONTAINER and perhaps makes it a
question whether IOMMUFD should really be taking over /dev/vfio/vfio.
No-iommu mode has users.  Thanks,

Alex

