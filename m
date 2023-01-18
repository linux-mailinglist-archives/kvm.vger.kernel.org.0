Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B66F672794
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 19:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjARS7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 13:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjARS7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 13:59:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D3759B6F
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 10:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674068316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jwaWlIaPebdK8DNpQuuvVjS8artPxBM6nDox3pZmeN8=;
        b=G2y6QmnqywaTBo+Q9991umEGokv+ikP8RUglylr4yKs8MK0vV+vBkbbSXQBYanntVkAExN
        +C/cXlqYRM+NoJcc2Gk6hXzmDriOiTWs9XvfJDzu+N4ZgD9gDvosWJfoYq74p9Fj67Ftc9
        LX/XG8TAmaujVTva4PkyDwtKiltakkI=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-250-qcac1dtUPWO9288nq4gm8A-1; Wed, 18 Jan 2023 13:58:34 -0500
X-MC-Unique: qcac1dtUPWO9288nq4gm8A-1
Received: by mail-io1-f70.google.com with SMTP id k1-20020a6b3c01000000b006f744aee560so21374098iob.2
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 10:58:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jwaWlIaPebdK8DNpQuuvVjS8artPxBM6nDox3pZmeN8=;
        b=Iq2g9pGmMghxY3don9qfgdHn2aPZt541AKnwdbSSFk5iSfwq2iQDEZUsUsgJ4UXdgL
         3IsSOjLJd1zLhzXC4mbA99z2tNVKMqVQmDP2Djomq7eEkHzF+Z8F1ne+3QlCwo/JZUjO
         rW6DN9MyP1qg0EpEhIko45FVOQamvOjruyjBijEj9FkcdPvKgjOEVmHIYTjbnEGxZTMI
         Dzx/enbnaC4yhkmyNZhl4gbBitgcBLRiNnbQis8QDYuwVEqiz9BKYRhc1S6u3vlLj6S3
         /kgj2qDFM5p2655o0JxaW3iCyDTBAj6JF8/MJVUr+zN4KsOxvkSDoU9umKmlWqzmaS4E
         mFzg==
X-Gm-Message-State: AFqh2koieSAeHeUIjhqL/xpbzrtjsZVsw1Ukadkdc6JI0H6iVgd0GXIi
        RLLluoyksfElNZCoR8AnZEvv5ctIfsUFCUXaUBkOKc8e1SlyzoxBt5aUrV/2qeBkIacajS2+fAb
        olYYrgCATlk3x
X-Received: by 2002:a5d:9f0c:0:b0:704:b286:64c3 with SMTP id q12-20020a5d9f0c000000b00704b28664c3mr5357197iot.16.1674068313897;
        Wed, 18 Jan 2023 10:58:33 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuD3FNjIe8uZwiymfGir/K6vuU0PbE/oIAy9VURoxPULmWGDYCX5CqFDoljCfgmrCuNOhASOg==
X-Received: by 2002:a5d:9f0c:0:b0:704:b286:64c3 with SMTP id q12-20020a5d9f0c000000b00704b28664c3mr5357187iot.16.1674068313655;
        Wed, 18 Jan 2023 10:58:33 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h7-20020a05660208c700b00704a77b7b28sm3952149ioz.54.2023.01.18.10.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 10:58:33 -0800 (PST)
Date:   Wed, 18 Jan 2023 11:58:31 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v3] vfio: Support VFIO_NOIOMMU with iommufd
Message-ID: <20230118115831.3e76742d.alex.williamson@redhat.com>
In-Reply-To: <0-v3-480cd64a16f7+1ad0-iommufd_noiommu_jgg@nvidia.com>
References: <0-v3-480cd64a16f7+1ad0-iommufd_noiommu_jgg@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Wed, 18 Jan 2023 13:50:28 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index f8219a438bfbf5..9e94abcf8ee1a8 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -10,10 +10,10 @@
>  #include <linux/device.h>
>  #include <linux/cdev.h>
>  #include <linux/module.h>
> +#include <linux/vfio.h>
>  
>  struct iommufd_ctx;
>  struct iommu_group;
> -struct vfio_device;
>  struct vfio_container;
>  
>  void vfio_device_put_registration(struct vfio_device *device);
> @@ -88,6 +88,12 @@ bool vfio_device_has_container(struct vfio_device *device);
>  int __init vfio_group_init(void);
>  void vfio_group_cleanup(void);
>  
> +static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> +{
> +	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> +	       vdev->group->type == VFIO_NO_IOMMU;
> +}


What about:

static inline bool vfio_group_type_is_noiommu(struct vfio_group *group)

which would allow us to pickup the group.c use with only extending the
callers here as s/vdev/vdev->group/?  Or we could even make a
vfio_device_group_type_is_noiommu(struct vfio_device*) calling the
above if we want a device specific interface.  Thanks,

Alex

