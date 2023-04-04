Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAE16D6750
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbjDDPaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbjDDPaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:30:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E95C6
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680622153;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2+Wv7W8fsHHIewyLSZIiChbsaRykHPVOAna76qbG3Ps=;
        b=gwsM782AofTiRdC5EEzZqvDmbeMoXKlMKKFNX/A4/XeCYI1HDHm+vN4t9Q+MPG2U+Jjqaz
        HBXpnr6E5Pc7joQRt4N91b88ANF5gZkKJrv2XVj3WnbuG0ikr3NHSXOuR8W4k+BHRGuxqb
        hC+7qfUXKTvCKtNx2KgdDDDAYNJvb4o=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-EZVY672cON2RNUEV_C11nQ-1; Tue, 04 Apr 2023 11:29:09 -0400
X-MC-Unique: EZVY672cON2RNUEV_C11nQ-1
Received: by mail-qv1-f72.google.com with SMTP id a10-20020a0ccdca000000b005d70160fbb0so14716173qvn.21
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 08:29:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680622149;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2+Wv7W8fsHHIewyLSZIiChbsaRykHPVOAna76qbG3Ps=;
        b=c5sh7VBiYxyr8xwf/5Jqt+/xXFnLdUx7/K73BoqLkKtqgbhEl9qfNUnQQkigjEu+7b
         qjgLLZ00vRutULb/0ued1hQPaSiwAm3WuKJtN3ME46S9vN1MKXuoC8EMuWjpcc2/qi81
         3nWV3EESjQFx1+4Z55Tp1r/GWEmGX8VoGdTvSxLzYrQNdqIt/UpLXjuFmAgi2nKjlu5u
         ZqI2yxBcrYLAgd/Wsa7DPY6xBPy6SU80j2FAzkGK8iRBufJIyVtuNG7QAn0Ry7ncB6md
         EUFf6ndZ6SMNkCzHbQyuoZnAA2yVqgk33pCHQ69eUz1UL+jAj4CmXOg3OhZ9ZF0opG7X
         5xYg==
X-Gm-Message-State: AAQBX9c5tpjBs0QYezMT5I9dGprL4DgS7VU9Zyl9+g/KxdLmdH+KKMsY
        dqJ1mePhZvk+eo04x0jtdhwoEUJsPlm3g0578GWbtf6XISnCKdYuBUeTOyM+Vw5uJinoGSo/u8n
        Saduy77oKJ+Wc
X-Received: by 2002:ad4:5d68:0:b0:5d1:acb8:f126 with SMTP id fn8-20020ad45d68000000b005d1acb8f126mr4995798qvb.38.1680622149455;
        Tue, 04 Apr 2023 08:29:09 -0700 (PDT)
X-Google-Smtp-Source: AKy350YML0mMqHUHs1k3HMJkmmzOZKlEQzKI6fPsfnsSdnmZ4ori6n+2YUk0zwT+gzhWL3EpVBiXSg==
X-Received: by 2002:ad4:5d68:0:b0:5d1:acb8:f126 with SMTP id fn8-20020ad45d68000000b005d1acb8f126mr4995753qvb.38.1680622149123;
        Tue, 04 Apr 2023 08:29:09 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id cv2-20020ad44d82000000b005dd8b9345f3sm3450439qvb.139.2023.04.04.08.28.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 08:29:00 -0700 (PDT)
Message-ID: <702c2883-1d51-b609-1e99-337295e6e307@redhat.com>
Date:   Tue, 4 Apr 2023 17:28:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 04/12] vfio-iommufd: Add helper to retrieve iommufd_ctx
 and devid for vfio_device
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-5-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230401144429.88673-5-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 4/1/23 16:44, Yi Liu wrote:
> This is needed by the vfio-pci driver to report affected devices in the
> hot reset for a given device.
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/device.c | 12 ++++++++++++
>  drivers/vfio/iommufd.c         | 14 ++++++++++++++
>  include/linux/iommufd.h        |  3 +++
>  include/linux/vfio.h           | 13 +++++++++++++
>  4 files changed, 42 insertions(+)
>
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index 25115d401d8f..04a57aa1ae2c 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -131,6 +131,18 @@ void iommufd_device_unbind(struct iommufd_device *idev)
>  }
>  EXPORT_SYMBOL_NS_GPL(iommufd_device_unbind, IOMMUFD);
>  
> +struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev)
> +{
> +	return idev->ictx;
> +}
> +EXPORT_SYMBOL_NS_GPL(iommufd_device_to_ictx, IOMMUFD);
> +
> +u32 iommufd_device_to_id(struct iommufd_device *idev)
> +{
> +	return idev->obj.id;
> +}
> +EXPORT_SYMBOL_NS_GPL(iommufd_device_to_id, IOMMUFD);
> +
>  static int iommufd_device_setup_msi(struct iommufd_device *idev,
>  				    struct iommufd_hw_pagetable *hwpt,
>  				    phys_addr_t sw_msi_start)
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index 88b00c501015..809f2dd73b9e 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -66,6 +66,20 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
>  		vdev->ops->unbind_iommufd(vdev);
>  }
>  
> +struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev)
> +{
> +	if (!vdev->iommufd_device)
> +		return NULL;
> +	return iommufd_device_to_ictx(vdev->iommufd_device);
> +}
> +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_ictx);
> +
> +void vfio_iommufd_physical_devid(struct vfio_device *vdev, u32 *id)
> +{
> +	if (vdev->iommufd_device)
> +		*id = iommufd_device_to_id(vdev->iommufd_device);
since there is no return value, may be worth to add at least a WARN_ON
in case of !vdev->iommufd_device
> +}
> +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_devid);
>  /*
>   * The physical standard ops mean that the iommufd_device is bound to the
>   * physical device vdev->dev that was provided to vfio_init_group_dev(). Drivers
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> index 1129a36a74c4..ac96df406833 100644
> --- a/include/linux/iommufd.h
> +++ b/include/linux/iommufd.h
> @@ -24,6 +24,9 @@ void iommufd_device_unbind(struct iommufd_device *idev);
>  int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id);
>  void iommufd_device_detach(struct iommufd_device *idev);
>  
> +struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev);
> +u32 iommufd_device_to_id(struct iommufd_device *idev);
> +
>  struct iommufd_access_ops {
>  	u8 needs_pin_pages : 1;
>  	void (*unmap)(void *data, unsigned long iova, unsigned long length);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 3188d8a374bd..97a1174b922f 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -113,6 +113,8 @@ struct vfio_device_ops {
>  };
>  
>  #if IS_ENABLED(CONFIG_IOMMUFD)
> +struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev);
> +void vfio_iommufd_physical_devid(struct vfio_device *vdev, u32 *id);
>  int vfio_iommufd_physical_bind(struct vfio_device *vdev,
>  			       struct iommufd_ctx *ictx, u32 *out_device_id);
>  void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
> @@ -122,6 +124,17 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
>  void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
>  int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
>  #else
> +static inline struct iommufd_ctx *
> +vfio_iommufd_physical_ictx(struct vfio_device *vdev)
> +{
> +	return NULL;
> +}
> +
> +static inline void
> +vfio_iommufd_physical_devid(struct vfio_device *vdev, u32 *id)
> +{
> +}
> +
>  #define vfio_iommufd_physical_bind                                      \
>  	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
>  		  u32 *out_device_id)) NULL)
besides

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

