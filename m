Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBA17D1457
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 18:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377868AbjJTQpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 12:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjJTQpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 12:45:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100F1197
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 09:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697820271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aMAA1wMWvircrEJMOG5j/39HJSPTO4z+wh6TBaHy/FU=;
        b=fquq7d64BrBc+B9mqQ6AztXMiZsxMlSsO7HmbiJVTnzskg+eGljHxK4FHHIxtppmKFB+BE
        R1e6Le5Of+66MDeUU8v3vaBx39jMl/cXtrL+Xo2fZAxdNkkrNswhYVVWeOpNjzuHRzvafF
        bYaaA2MvbqFECvxoUHufHkFFdqw+uXE=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-3pXz9uNtP3KVzxWG0RicJA-1; Fri, 20 Oct 2023 12:44:19 -0400
X-MC-Unique: 3pXz9uNtP3KVzxWG0RicJA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-35740de180aso9502365ab.2
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 09:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697820259; x=1698425059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aMAA1wMWvircrEJMOG5j/39HJSPTO4z+wh6TBaHy/FU=;
        b=we7ydUKFkGu6NU0zT0VxCAiIECapJZKgek0shFBJVLEW4q8Gr9E+xfc4BG7oRGUMpZ
         OxI5eC6dhoGKOAUiOKYv5a7zBg+PGFMDJNvu9UghNK4xp0DQc4tPLIBEYKEntjZLyRbf
         yT1ZrDvduTR8cogVUuFmGMuH1Hr+9jRgNl+bsRbWTiKOa5/XPcY+a62vgVUL+oSIhaPp
         iqDRkYLDxzU/+44zR9Eq3G5ppi97Hcwi+hZsZybVyH7ICLQxImeWucO1F22N/M3zYxEk
         PNwHmGZ/LFarRbn4XWvoKW60M/b74PLh3F5trTttqRQb/hVPOZLuNhLSRG/ihOnbopCc
         EiWg==
X-Gm-Message-State: AOJu0YyQB3btjsXvFSULNZWHM4eBVL2TZCl4bgM6lKbEMfw+aRVEQoYr
        ET+pXIs9XG2CpR0VVUKv8aT84VF8ga0A6alZHRza53KTlBUkkkqXF+OAkTdcxo+vFpG1+q9/O/7
        gRrm+AGoyW3FO
X-Received: by 2002:a92:ce0f:0:b0:357:43f9:7cd3 with SMTP id b15-20020a92ce0f000000b0035743f97cd3mr2818984ilo.19.1697820258848;
        Fri, 20 Oct 2023 09:44:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjlAr/6whJcCAcwaHbLC1LI969MhkVBkP6O7Vf1x7JsQrJ9u+Z0KIYfnZf6F1DmPbkzHOE+w==
X-Received: by 2002:a92:ce0f:0:b0:357:43f9:7cd3 with SMTP id b15-20020a92ce0f000000b0035743f97cd3mr2818972ilo.19.1697820258596;
        Fri, 20 Oct 2023 09:44:18 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id u14-20020a056e021a4e00b0035745066abfsm684255ilv.21.2023.10.20.09.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 09:44:18 -0700 (PDT)
Date:   Fri, 20 Oct 2023 10:44:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>, kvm@vger.kernel.org,
        Brett Creeley <brett.creeley@amd.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH v4 03/18] iommufd/iova_bitmap: Move symbols to IOMMUFD
 namespace
Message-ID: <20231020104417.5849664f.alex.williamson@redhat.com>
In-Reply-To: <20231018202715.69734-4-joao.m.martins@oracle.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
        <20231018202715.69734-4-joao.m.martins@oracle.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Oct 2023 21:27:00 +0100
Joao Martins <joao.m.martins@oracle.com> wrote:

> Have the IOVA bitmap exported symbols adhere to the IOMMUFD symbol
> export convention i.e. using the IOMMUFD namespace. In doing so,
> import the namespace in the current users. This means VFIO and the
> vfio-pci drivers that use iova_bitmap_set().
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/iommufd/iova_bitmap.c | 8 ++++----
>  drivers/vfio/pci/mlx5/main.c        | 1 +
>  drivers/vfio/pci/pds/pci_drv.c      | 1 +
>  drivers/vfio/vfio_main.c            | 1 +
>  4 files changed, 7 insertions(+), 4 deletions(-)
> 

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>


> diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
> index f54b56388e00..0a92c9eeaf7f 100644
> --- a/drivers/iommu/iommufd/iova_bitmap.c
> +++ b/drivers/iommu/iommufd/iova_bitmap.c
> @@ -268,7 +268,7 @@ struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
>  	iova_bitmap_free(bitmap);
>  	return ERR_PTR(rc);
>  }
> -EXPORT_SYMBOL_GPL(iova_bitmap_alloc);
> +EXPORT_SYMBOL_NS_GPL(iova_bitmap_alloc, IOMMUFD);
>  
>  /**
>   * iova_bitmap_free() - Frees an IOVA bitmap object
> @@ -290,7 +290,7 @@ void iova_bitmap_free(struct iova_bitmap *bitmap)
>  
>  	kfree(bitmap);
>  }
> -EXPORT_SYMBOL_GPL(iova_bitmap_free);
> +EXPORT_SYMBOL_NS_GPL(iova_bitmap_free, IOMMUFD);
>  
>  /*
>   * Returns the remaining bitmap indexes from mapped_total_index to process for
> @@ -389,7 +389,7 @@ int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
>  
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(iova_bitmap_for_each);
> +EXPORT_SYMBOL_NS_GPL(iova_bitmap_for_each, IOMMUFD);
>  
>  /**
>   * iova_bitmap_set() - Records an IOVA range in bitmap
> @@ -423,4 +423,4 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
>  		cur_bit += nbits;
>  	} while (cur_bit <= last_bit);
>  }
> -EXPORT_SYMBOL_GPL(iova_bitmap_set);
> +EXPORT_SYMBOL_NS_GPL(iova_bitmap_set, IOMMUFD);
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 42ec574a8622..5cf2b491d15a 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -1376,6 +1376,7 @@ static struct pci_driver mlx5vf_pci_driver = {
>  
>  module_pci_driver(mlx5vf_pci_driver);
>  
> +MODULE_IMPORT_NS(IOMMUFD);
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Max Gurtovoy <mgurtovoy@nvidia.com>");
>  MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
> index ab4b5958e413..dd8c00c895a2 100644
> --- a/drivers/vfio/pci/pds/pci_drv.c
> +++ b/drivers/vfio/pci/pds/pci_drv.c
> @@ -204,6 +204,7 @@ static struct pci_driver pds_vfio_pci_driver = {
>  
>  module_pci_driver(pds_vfio_pci_driver);
>  
> +MODULE_IMPORT_NS(IOMMUFD);
>  MODULE_DESCRIPTION(PDS_VFIO_DRV_DESCRIPTION);
>  MODULE_AUTHOR("Brett Creeley <brett.creeley@amd.com>");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 40732e8ed4c6..a96d97da367d 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1693,6 +1693,7 @@ static void __exit vfio_cleanup(void)
>  module_init(vfio_init);
>  module_exit(vfio_cleanup);
>  
> +MODULE_IMPORT_NS(IOMMUFD);
>  MODULE_VERSION(DRIVER_VERSION);
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR(DRIVER_AUTHOR);

