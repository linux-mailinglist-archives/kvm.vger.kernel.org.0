Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D6F72E6A4
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 17:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242964AbjFMPFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 11:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242803AbjFMPEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 11:04:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00091E62
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 08:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686668651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YydBu9r/6A39lhq1fyNCaOJcqqvwoNcoQa6tVejSDeQ=;
        b=F6tFojnstFRXZSTDfaOKiFC/1oLjJFxSW29LMGRlS9TPsABnFipiNUD/FkId7zMc1E7xY5
        LK2F+mzTIFxH3la5gPQkbN9TeCwzkyOhmUwdtF5o2Pd7Kl77hPBcV2Mh4stOQLlUwM9ZJ/
        eNd2nocbNaubkomjnH+6MRqMGFMIJCo=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-hgHuFGDCNUe5zPF9w4TLWw-1; Tue, 13 Jun 2023 11:04:07 -0400
X-MC-Unique: hgHuFGDCNUe5zPF9w4TLWw-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-33b1beebbedso49450195ab.2
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 08:04:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686668646; x=1689260646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YydBu9r/6A39lhq1fyNCaOJcqqvwoNcoQa6tVejSDeQ=;
        b=D0xRVINDLwer/iZarUDnBghJLPQyBdwXTfrMzGMFxpQY1WWm48enXs0QKaFqWLyAZN
         Arnw7DXxdu1kqI9zjg4SrGdMhAEJYWLfdXwI89gtLSNG8Lok7wVnWFk+WMmgiswSByoz
         54IaKYb4VN0Zli8HFf44x47/sVcu9hohV9jrhizhA1+x49jmqT98J+Zl/3p8TVwS8Ean
         tQ1wVuEm5m7nQYnVgcH1fYvzyxCclCNZUn6Ei76N5mB6YBCSkLCVuNWxU2qJGZQiXMpn
         rn8pIudfL6HqJZRVYde2rZCS/AkevrCqxfd1gWSxRTjFDgqXFlC9MT/HhovPNANXs8BK
         OYDA==
X-Gm-Message-State: AC+VfDxIuYMRgiOfA5opnR9RF5IAj9z1LZ7POLbMnz00nBQBgmjM5pz/
        wAZUkxo3jIpiOfvO0BtxktVYfWboOU2mUz5bzd+VLJY4YDILVXYvQelK0LuM9+42FAu/dj/xT0I
        3yIS8fTW/ZJKe
X-Received: by 2002:a92:4a10:0:b0:33d:6988:c00f with SMTP id m16-20020a924a10000000b0033d6988c00fmr10759823ilf.23.1686668645664;
        Tue, 13 Jun 2023 08:04:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6hRUczWeT/vsf09o44UFWMaqisCqWHnjTGKmeIzpiXZMGJpdYNOuBusIkgotULHLq+g9dlEQ==
X-Received: by 2002:a92:4a10:0:b0:33d:6988:c00f with SMTP id m16-20020a924a10000000b0033d6988c00fmr10759765ilf.23.1686668645012;
        Tue, 13 Jun 2023 08:04:05 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m10-20020a924b0a000000b0033355fa5440sm3963186ilg.37.2023.06.13.08.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 08:04:04 -0700 (PDT)
Date:   Tue, 13 Jun 2023 09:04:03 -0600
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
Subject: Re: [PATCH v12 24/24] docs: vfio: Add vfio device cdev description
Message-ID: <20230613090403.1eecd1a3.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB75297AC071F2EF4F49D85999C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-25-yi.l.liu@intel.com>
        <20230612170628.661ab2a6.alex.williamson@redhat.com>
        <DS0PR11MB7529B0A71849EA06DA953BBCC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613082427.453748f5.alex.williamson@redhat.com>
        <DS0PR11MB75297AC071F2EF4F49D85999C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Jun 2023 14:48:02 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, June 13, 2023 10:24 PM
> > 
> > On Tue, 13 Jun 2023 12:01:51 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Tuesday, June 13, 2023 7:06 AM
> > > >
> > > > On Fri,  2 Jun 2023 05:16:53 -0700
> > > > Yi Liu <yi.l.liu@intel.com> wrote:
> > > >  
> > > > > This gives notes for userspace applications on device cdev usage.
> > > > >
> > > > > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > > > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > > > ---
> > > > >  Documentation/driver-api/vfio.rst | 132 ++++++++++++++++++++++++++++++
> > > > >  1 file changed, 132 insertions(+)
> > > > >
> > > > > diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> > > > > index 363e12c90b87..f00c9b86bda0 100644
> > > > > --- a/Documentation/driver-api/vfio.rst
> > > > > +++ b/Documentation/driver-api/vfio.rst
> > > > > @@ -239,6 +239,130 @@ group and can access them as follows::
> > > > >  	/* Gratuitous device reset and go... */
> > > > >  	ioctl(device, VFIO_DEVICE_RESET);
> > > > >
> > > > > +IOMMUFD and vfio_iommu_type1
> > > > > +----------------------------
> > > > > +
> > > > > +IOMMUFD is the new user API to manage I/O page tables from userspace.
> > > > > +It intends to be the portal of delivering advanced userspace DMA
> > > > > +features (nested translation [5]_, PASID [6]_, etc.) while also providing
> > > > > +a backwards compatibility interface for existing VFIO_TYPE1v2_IOMMU use
> > > > > +cases.  Eventually the vfio_iommu_type1 driver, as well as the legacy
> > > > > +vfio container and group model is intended to be deprecated.
> > > > > +
> > > > > +The IOMMUFD backwards compatibility interface can be enabled two ways.
> > > > > +In the first method, the kernel can be configured with
> > > > > +CONFIG_IOMMUFD_VFIO_CONTAINER, in which case the IOMMUFD subsystem
> > > > > +transparently provides the entire infrastructure for the VFIO
> > > > > +container and IOMMU backend interfaces.  The compatibility mode can
> > > > > +also be accessed if the VFIO container interface, ie. /dev/vfio/vfio is
> > > > > +simply symlink'd to /dev/iommu.  Note that at the time of writing, the
> > > > > +compatibility mode is not entirely feature complete relative to
> > > > > +VFIO_TYPE1v2_IOMMU (ex. DMA mapping MMIO) and does not attempt to
> > > > > +provide compatibility to the VFIO_SPAPR_TCE_IOMMU interface.  Therefore
> > > > > +it is not generally advisable at this time to switch from native VFIO
> > > > > +implementations to the IOMMUFD compatibility interfaces.
> > > > > +
> > > > > +Long term, VFIO users should migrate to device access through the cdev
> > > > > +interface described below, and native access through the IOMMUFD
> > > > > +provided interfaces.
> > > > > +
> > > > > +VFIO Device cdev
> > > > > +----------------
> > > > > +
> > > > > +Traditionally user acquires a device fd via VFIO_GROUP_GET_DEVICE_FD
> > > > > +in a VFIO group.
> > > > > +
> > > > > +With CONFIG_VFIO_DEVICE_CDEV=y the user can now acquire a device fd
> > > > > +by directly opening a character device /dev/vfio/devices/vfioX where
> > > > > +"X" is the number allocated uniquely by VFIO for registered devices.
> > > > > +cdev interface does not support noiommu, so user should use the legacy
> > > > > +group interface if noiommu is needed.
> > > > > +
> > > > > +The cdev only works with IOMMUFD.  Both VFIO drivers and applications
> > > > > +must adapt to the new cdev security model which requires using
> > > > > +VFIO_DEVICE_BIND_IOMMUFD to claim DMA ownership before starting to
> > > > > +actually use the device.  Once BIND succeeds then a VFIO device can
> > > > > +be fully accessed by the user.
> > > > > +
> > > > > +VFIO device cdev doesn't rely on VFIO group/container/iommu drivers.
> > > > > +Hence those modules can be fully compiled out in an environment
> > > > > +where no legacy VFIO application exists.
> > > > > +
> > > > > +So far SPAPR does not support IOMMUFD yet.  So it cannot support device
> > > > > +cdev neither.  
> > > >
> > > > s/neither/either/  
> > >
> > > Got it.
> > >  
> > > >
> > > > Unless I missed it, we've not described that vfio device cdev access is
> > > > still bound by IOMMU group semantics, ie. there can be one DMA owner
> > > > for the group.  That's a pretty common failure point for multi-function
> > > > consumer device use cases, so the why, where, and how it fails should
> > > > be well covered.  
> > >
> > > Yes. this needs to be documented. How about below words:
> > >
> > > vfio device cdev access is still bound by IOMMU group semantics, ie. there
> > > can be only one DMA owner for the group.  Devices belonging to the same
> > > group can not be bound to multiple iommufd_ctx.  
> > 
> > ... or shared between native kernel and vfio drivers.  
> 
> I suppose you mean the devices in one group are bound to different
> drivers. right?

Essentially, but we need to be careful that we're developing multiple
vfio drivers for a given bus now, which is why I try to distinguish
between the two sets of drivers.  Thanks,

Alex
 
> > >  The users that try to bind
> > > such device to different iommufd shall be failed in VFIO_DEVICE_BIND_IOMMUFD
> > > which is the start point to get full access for the device.  
> > 
> > "A violation of this ownership requirement will fail at the
> > VFIO_DEVICE_BIND_IOMMUFD ioctl, which gates full device access."  
> 
> Got it.
> 
> Regards,
> Yi Liu
> 

