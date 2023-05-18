Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B867088A3
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 21:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjERTv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 15:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjERTvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 15:51:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FBD10C1
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 12:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684439434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jh5OmsoiniNzfPxTh2q8i8zD0yrfR3xzpW1VvlO4Lwg=;
        b=HrTxNmgHVIWW4hqCvm1IlTjND79sa4xFdnzTVyMo5leW9UxqV1nYvSjg2ur0SWz4LFQ4zm
        n6GNBHwMOfZJBQDNiFypk6aVDHfNKJYkDjyiZmKONOuVxNs819jm7N7UbcT9gQjo8Fowxh
        Vf6WQSDk/duKTtazmU2YDijIMv6nhOc=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-orP0WAhNMDiFi-hpzQxBDg-1; Thu, 18 May 2023 15:50:33 -0400
X-MC-Unique: orP0WAhNMDiFi-hpzQxBDg-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-33539445684so422095ab.1
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 12:50:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684439432; x=1687031432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jh5OmsoiniNzfPxTh2q8i8zD0yrfR3xzpW1VvlO4Lwg=;
        b=I0kW6JgJf33d7OaxjwP7locF9vOHl5EMV5/yJi3vQU7O7CPaGbUe5LZvKMGPEITe0z
         LoRwE9HM43vIkVY0WH3kqNwg0rjd8A52e6xGHGwSEaSlcPWwD5uEVzw2EG3z4bSkV4WY
         uH1dZBbV4S+1dLQK2V5Naqyy8A0zjmO1aLCAXk9zLPuDRXo6WSIwaCy8wt+oGLG1xdmk
         Cn+yUXaEIJ/lxIQgW1GJVYPKyENjtOsRXrq7bRD0xNPTIiJyOVsk8MoukkuOcLeA3kcA
         vrPd43HLuPurOg6hm5PLljlcx51vNgbi4v4Zd1a4QrWxinj5GDox4eKec6eiOn8vRpJl
         cQfg==
X-Gm-Message-State: AC+VfDzdOcaf5amhgZFxiTwZ9SQf6tXS4P8YSqf3kGCzTlWKiViJOYzb
        1zdqlpfELVz6vdY2RoYJoYZ3tHLI5VODHA0su2EdEU8gMxtxpA5Cik4+o+GrShV9cu80XV49jz+
        8S7Dmk9xeTfXc08N6S3XA
X-Received: by 2002:a05:6e02:1aa3:b0:333:49f9:a5f3 with SMTP id l3-20020a056e021aa300b0033349f9a5f3mr4588875ilv.2.1684439431996;
        Thu, 18 May 2023 12:50:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5FxhxTBMgm7TCu3seuae29eNjQqi+QvYLiW+iwyYL0QmMjButMon7ajVdlh0YbG0jeo2m46g==
X-Received: by 2002:a05:6e02:1aa3:b0:333:49f9:a5f3 with SMTP id l3-20020a056e021aa300b0033349f9a5f3mr4588864ilv.2.1684439431737;
        Thu, 18 May 2023 12:50:31 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f16-20020a02cad0000000b0041643b78cbesm664248jap.120.2023.05.18.12.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 12:50:31 -0700 (PDT)
Date:   Thu, 18 May 2023 13:50:29 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v5 06/10] vfio-iommufd: Add helper to retrieve
 iommufd_ctx and devid for vfio_device
Message-ID: <20230518135029.26abe519.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB752963E14A652AEE1A1C2699C37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
        <20230513132136.15021-7-yi.l.liu@intel.com>
        <20230517121517.4b7ceb52.alex.williamson@redhat.com>
        <DS0PR11MB752963E14A652AEE1A1C2699C37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 May 2023 13:25:59 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, May 18, 2023 2:15 AM
> > 
> > On Sat, 13 May 2023 06:21:32 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >   
> > > This is needed by the vfio-pci driver to report affected devices in the
> > > hot reset for a given device.
> > >
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/iommu/iommufd/device.c | 24 ++++++++++++++++++++++++
> > >  drivers/vfio/iommufd.c         | 20 ++++++++++++++++++++
> > >  include/linux/iommufd.h        |  6 ++++++
> > >  include/linux/vfio.h           | 14 ++++++++++++++
> > >  4 files changed, 64 insertions(+)
> > >
> > > diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> > > index 4f9b2142274c..81466b97023f 100644
> > > --- a/drivers/iommu/iommufd/device.c
> > > +++ b/drivers/iommu/iommufd/device.c
> > > @@ -116,6 +116,18 @@ void iommufd_device_unbind(struct iommufd_device *idev)
> > >  }
> > >  EXPORT_SYMBOL_NS_GPL(iommufd_device_unbind, IOMMUFD);
> > >
> > > +struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev)
> > > +{
> > > +	return idev->ictx;
> > > +}
> > > +EXPORT_SYMBOL_NS_GPL(iommufd_device_to_ictx, IOMMUFD);
> > > +
> > > +u32 iommufd_device_to_id(struct iommufd_device *idev)
> > > +{
> > > +	return idev->obj.id;
> > > +}
> > > +EXPORT_SYMBOL_NS_GPL(iommufd_device_to_id, IOMMUFD);
> > > +
> > >  static int iommufd_device_setup_msi(struct iommufd_device *idev,
> > >  				    struct iommufd_hw_pagetable *hwpt,
> > >  				    phys_addr_t sw_msi_start)
> > > @@ -463,6 +475,18 @@ void iommufd_access_destroy(struct iommufd_access  
> > *access)  
> > >  }
> > >  EXPORT_SYMBOL_NS_GPL(iommufd_access_destroy, IOMMUFD);
> > >
> > > +struct iommufd_ctx *iommufd_access_to_ictx(struct iommufd_access *access)
> > > +{
> > > +	return access->ictx;
> > > +}
> > > +EXPORT_SYMBOL_NS_GPL(iommufd_access_to_ictx, IOMMUFD);
> > > +
> > > +u32 iommufd_access_to_id(struct iommufd_access *access)
> > > +{
> > > +	return access->obj.id;
> > > +}
> > > +EXPORT_SYMBOL_NS_GPL(iommufd_access_to_id, IOMMUFD);
> > > +
> > >  int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id)
> > >  {
> > >  	struct iommufd_ioas *new_ioas;
> > > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > > index c1379e826052..a18e920be164 100644
> > > --- a/drivers/vfio/iommufd.c
> > > +++ b/drivers/vfio/iommufd.c
> > > @@ -105,6 +105,26 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
> > >  		vdev->ops->unbind_iommufd(vdev);
> > >  }
> > >
> > > +struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev)
> > > +{
> > > +	if (vdev->iommufd_device)
> > > +		return iommufd_device_to_ictx(vdev->iommufd_device);
> > > +	if (vdev->noiommu_access)
> > > +		return iommufd_access_to_ictx(vdev->noiommu_access);
> > > +	return NULL;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_ictx);
> > > +
> > > +int vfio_iommufd_physical_devid(struct vfio_device *vdev)
> > > +{
> > > +	if (vdev->iommufd_device)
> > > +		return iommufd_device_to_id(vdev->iommufd_device);
> > > +	if (vdev->noiommu_access)
> > > +		return iommufd_access_to_id(vdev->noiommu_access);
> > > +	return -EINVAL;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_devid);  
> > 
> > I think these exemplify that it would be better if both emulated and
> > noiommu use the same iommufd_access pointer.  Thanks,  
> 
> Sure. Then I shall rename this helper. vfio_iommufd_device_devid()
> What about your opinion?

Yes, it really didn't even occur to me that "physical" in the name was
meant to suggest this shouldn't be used for emulated mdev devices.  It
should work for all devices and using a shared iommufd access pointer
between noiommu and emulated should simplify that somewhat.  Thanks,

Alex

