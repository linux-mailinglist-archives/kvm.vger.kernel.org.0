Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD016D6F46
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 23:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbjDDVts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 17:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjDDVtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 17:49:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35423C2F
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 14:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680644941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BMOmz/hCD9hq0xa7lEyqqxxsKm/tr2tmPnHhHb56dRc=;
        b=Wl2FQKaclK3bIMwaPqw8tF0bHXkMeft5YD6XVT9SYhMVKcxhqXdgZLaSb/ineNNkG5oi9K
        52UtyOBShBrbobrzl3XLqOl4ZLieB38C3Qzq2G9ZMv+ZY+u2kIxLmMJCrkj/aDhfprGDx8
        FyspkpU3qUnrxiuJIDp44/pJJdcS9WU=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-7NyNVallPSi48MD41eRUbw-1; Tue, 04 Apr 2023 17:48:57 -0400
X-MC-Unique: 7NyNVallPSi48MD41eRUbw-1
Received: by mail-il1-f198.google.com with SMTP id d11-20020a056e020c0b00b00326156e3a8bso16631806ile.3
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 14:48:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680644937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BMOmz/hCD9hq0xa7lEyqqxxsKm/tr2tmPnHhHb56dRc=;
        b=EwmoLXt2yz1ZK0bOKiHo8biK10PiSePHnVAfu+RrgZVeyic8lTbOKFdPs4THnDwL+4
         HuXRxLfSITls/oWhngGq9y8IW7IdvYshBO5Ao7EXL66QxHq16fLL9kH6XFHCHB7obLf9
         LHVMc1gjGTpStb3NMKVCow8WZXznBfRdwwGD1Y5CehBlvjAp1WV8J3XpfQGTa4AZL3Hn
         +Wh8zUsfit5cJqZ8ZAHTwpBY+uRRZqHRIiqKiAuTIUHeEmTkA7mKWAaTtCbF3wzqtheE
         R84UsqFm5hAbMI99m370qR7MnkkLNmKJaZu8gfB5GUi/DLfZxCO01l1tieITMCHlJGu2
         U8xg==
X-Gm-Message-State: AAQBX9f6CfKLZSLFj0q7bvyk2JUPuKtCPGRa46X08YDwy7BLvzVQB5hd
        Rkyo9eceb6M7dGBQu7vTwksvAUY/DX7UxvmunTvVSLySm9Bn5n5DUVIXz35QfFi1dS0xTCSNZ5Z
        w6kdgH/jthEqS
X-Received: by 2002:a92:dac3:0:b0:325:fb39:8494 with SMTP id o3-20020a92dac3000000b00325fb398494mr3960291ilq.4.1680644937157;
        Tue, 04 Apr 2023 14:48:57 -0700 (PDT)
X-Google-Smtp-Source: AKy350b8lhguNnSPsqwDGg9DndWThvVQtcWBignwR7e7WGC5/A4W046vPbFQR7NCsx0PzkO+Dv+mIw==
X-Received: by 2002:a92:dac3:0:b0:325:fb39:8494 with SMTP id o3-20020a92dac3000000b00325fb398494mr3960288ilq.4.1680644936898;
        Tue, 04 Apr 2023 14:48:56 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c13-20020a928e0d000000b00325df6679a7sm3456502ild.26.2023.04.04.14.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:48:55 -0700 (PDT)
Date:   Tue, 4 Apr 2023 15:48:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, jgg@nvidia.com, kevin.tian@intel.com,
        joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: Re: [PATCH v3 04/12] vfio-iommufd: Add helper to retrieve
 iommufd_ctx and devid for vfio_device
Message-ID: <20230404154854.4d9a95f0.alex.williamson@redhat.com>
In-Reply-To: <702c2883-1d51-b609-1e99-337295e6e307@redhat.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-5-yi.l.liu@intel.com>
        <702c2883-1d51-b609-1e99-337295e6e307@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Apr 2023 17:28:40 +0200
Eric Auger <eric.auger@redhat.com> wrote:

> Hi,
> 
> On 4/1/23 16:44, Yi Liu wrote:
> > This is needed by the vfio-pci driver to report affected devices in the
> > hot reset for a given device.
> >
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/iommu/iommufd/device.c | 12 ++++++++++++
> >  drivers/vfio/iommufd.c         | 14 ++++++++++++++
> >  include/linux/iommufd.h        |  3 +++
> >  include/linux/vfio.h           | 13 +++++++++++++
> >  4 files changed, 42 insertions(+)
> >
> > diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> > index 25115d401d8f..04a57aa1ae2c 100644
> > --- a/drivers/iommu/iommufd/device.c
> > +++ b/drivers/iommu/iommufd/device.c
> > @@ -131,6 +131,18 @@ void iommufd_device_unbind(struct iommufd_device *idev)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(iommufd_device_unbind, IOMMUFD);
> >  
> > +struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev)
> > +{
> > +	return idev->ictx;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(iommufd_device_to_ictx, IOMMUFD);
> > +
> > +u32 iommufd_device_to_id(struct iommufd_device *idev)
> > +{
> > +	return idev->obj.id;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(iommufd_device_to_id, IOMMUFD);
> > +
> >  static int iommufd_device_setup_msi(struct iommufd_device *idev,
> >  				    struct iommufd_hw_pagetable *hwpt,
> >  				    phys_addr_t sw_msi_start)
> > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > index 88b00c501015..809f2dd73b9e 100644
> > --- a/drivers/vfio/iommufd.c
> > +++ b/drivers/vfio/iommufd.c
> > @@ -66,6 +66,20 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
> >  		vdev->ops->unbind_iommufd(vdev);
> >  }
> >  
> > +struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev)
> > +{
> > +	if (!vdev->iommufd_device)
> > +		return NULL;
> > +	return iommufd_device_to_ictx(vdev->iommufd_device);
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_ictx);
> > +
> > +void vfio_iommufd_physical_devid(struct vfio_device *vdev, u32 *id)
> > +{
> > +	if (vdev->iommufd_device)
> > +		*id = iommufd_device_to_id(vdev->iommufd_device);  
> since there is no return value, may be worth to add at least a WARN_ON
> in case of !vdev->iommufd_device

Yeah, this is bizarre and makes the one caller of this interface very
awkward.  We later go on to define IOMMUFD_INVALID_ID, so this should
simply return that in the case of no iommufd_device and skip this
unnecessary pointer passing.  Thanks,

Alex

> > +}
> > +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_devid);
> >  /*
> >   * The physical standard ops mean that the iommufd_device is bound to the
> >   * physical device vdev->dev that was provided to vfio_init_group_dev(). Drivers
> > diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> > index 1129a36a74c4..ac96df406833 100644
> > --- a/include/linux/iommufd.h
> > +++ b/include/linux/iommufd.h
> > @@ -24,6 +24,9 @@ void iommufd_device_unbind(struct iommufd_device *idev);
> >  int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id);
> >  void iommufd_device_detach(struct iommufd_device *idev);
> >  
> > +struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev);
> > +u32 iommufd_device_to_id(struct iommufd_device *idev);
> > +
> >  struct iommufd_access_ops {
> >  	u8 needs_pin_pages : 1;
> >  	void (*unmap)(void *data, unsigned long iova, unsigned long length);
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 3188d8a374bd..97a1174b922f 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -113,6 +113,8 @@ struct vfio_device_ops {
> >  };
> >  
> >  #if IS_ENABLED(CONFIG_IOMMUFD)
> > +struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev);
> > +void vfio_iommufd_physical_devid(struct vfio_device *vdev, u32 *id);
> >  int vfio_iommufd_physical_bind(struct vfio_device *vdev,
> >  			       struct iommufd_ctx *ictx, u32 *out_device_id);
> >  void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
> > @@ -122,6 +124,17 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
> >  void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
> >  int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
> >  #else
> > +static inline struct iommufd_ctx *
> > +vfio_iommufd_physical_ictx(struct vfio_device *vdev)
> > +{
> > +	return NULL;
> > +}
> > +
> > +static inline void
> > +vfio_iommufd_physical_devid(struct vfio_device *vdev, u32 *id)
> > +{
> > +}
> > +
> >  #define vfio_iommufd_physical_bind                                      \
> >  	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
> >  		  u32 *out_device_id)) NULL)  
> besides
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> 
> Eric
> 

