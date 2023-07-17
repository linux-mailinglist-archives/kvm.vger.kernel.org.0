Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47FE756C65
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 20:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjGQSqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 14:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjGQSqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 14:46:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3F699
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 11:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689619543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jfg0Wpnv971zzyvQMoQ8NpIJZigBrr4o+vHCTdb8p5c=;
        b=HAuUbrFh9pdyJek9LXKgSVZqEUORbzv0trlbLISSSOuuadNaBBewK4r8mnJATs4cfr6iE/
        /+SwIfaac5R4sa3KcbQNT7nYgWpEkOZVC3m3FBViJcMyAuwH7RMLulNxLUxKcAl7jq8633
        Ps/hRiPyXfeHl56cCt42sIvqbGoqt+M=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-w3V8EWYJM3a8hHvZanqi3w-1; Mon, 17 Jul 2023 14:45:42 -0400
X-MC-Unique: w3V8EWYJM3a8hHvZanqi3w-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-786596bc0a6so306915339f.3
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 11:45:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689619542; x=1692211542;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jfg0Wpnv971zzyvQMoQ8NpIJZigBrr4o+vHCTdb8p5c=;
        b=eqJP9rZKn3dX0GICuy+ih5T2x82Veew0gr95VBOXfhD2HnY6EU2p3HJ7yzE68JBvUj
         7ap800GZygiKxdwRK7RbCkAvR3t1zWfY1/+VaDwVSIlTIDe21w+maefnQywyPCGgG0PE
         Obk86VlLfVuQNeDJ/rxinx1mqyoumhWyYG1EeGC7sbWgLDfERq7KsoqwEusfn6n96Djf
         KkvPiODCs6jC5k5hij3U7CM5LFx+JE9weq+f/6i6KFDaiY301DdqeGvLvMiPtU48Y7Xi
         Xagu3y09cDRXXe/VUJUjc5HiWClL8B3SnUSCLNAe39hFyWOdor5qvW9fVDHOcMHuQOV1
         dSHg==
X-Gm-Message-State: ABy/qLa6d8vqYggq0HsqOQUNqDPRutdMWyApjzX8JuhrHSUAA8oeG/sA
        qnmhThwteCS9WDldQ8qK91ib/f2BpPFuTJsbB72/uMDKmYacFpOcMlIq5buoLooBMJT5chAp66K
        ZyNDwyP7lAmSO
X-Received: by 2002:a05:6602:25d9:b0:787:4b5f:b5ef with SMTP id d25-20020a05660225d900b007874b5fb5efmr442786iop.4.1689619541776;
        Mon, 17 Jul 2023 11:45:41 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHeVcVBTpc97DP3JYPKQ3zQZ3ixCoe+gCSksW369XRzVFX3Y/ccoIcWC+Y6ZcFL0WMFLuWyXw==
X-Received: by 2002:a05:6602:25d9:b0:787:4b5f:b5ef with SMTP id d25-20020a05660225d900b007874b5fb5efmr442770iop.4.1689619541548;
        Mon, 17 Jul 2023 11:45:41 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c2-20020a5ea902000000b00786ff73252bsm41855iod.10.2023.07.17.11.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 11:45:41 -0700 (PDT)
Date:   Mon, 17 Jul 2023 12:45:39 -0600
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
Subject: Re: [PATCH v13 21/22] vfio: Compile vfio_group infrastructure
 optionally
Message-ID: <20230717124539.743de027.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529F01B82FB659B96D15E38C33BA@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
        <20230616093946.68711-22-yi.l.liu@intel.com>
        <DS0PR11MB7529C571419F1DB629AB7E92C33BA@DS0PR11MB7529.namprd11.prod.outlook.com>
        <DS0PR11MB7529F01B82FB659B96D15E38C33BA@DS0PR11MB7529.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Jul 2023 08:08:59 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Monday, July 17, 2023 2:36 PM
> >   
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Friday, June 16, 2023 5:40 PM
> > >
> > > vfio_group is not needed for vfio device cdev, so with vfio device cdev
> > > introduced, the vfio_group infrastructures can be compiled out if only
> > > cdev is needed.
> > >
> > > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/iommu/iommufd/Kconfig |  4 +-
> > >  drivers/vfio/Kconfig          | 15 ++++++
> > >  drivers/vfio/Makefile         |  2 +-
> > >  drivers/vfio/vfio.h           | 89 ++++++++++++++++++++++++++++++++---
> > >  include/linux/vfio.h          | 25 ++++++++--
> > >  5 files changed, 123 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
> > > index ada693ea51a7..99d4b075df49 100644
> > > --- a/drivers/iommu/iommufd/Kconfig
> > > +++ b/drivers/iommu/iommufd/Kconfig
> > > @@ -14,8 +14,8 @@ config IOMMUFD
> > >  if IOMMUFD
> > >  config IOMMUFD_VFIO_CONTAINER
> > >  	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
> > > -	depends on VFIO && !VFIO_CONTAINER
> > > -	default VFIO && !VFIO_CONTAINER
> > > +	depends on VFIO_GROUP && !VFIO_CONTAINER
> > > +	default VFIO_GROUP && !VFIO_CONTAINER  
> > 
> > Hi Alex, Jason,
> > 
> > I found a minor nit on the kconfig. The below configuration is valid.
> > But user cannot use vfio directly as there is no /dev/vfio/vfio. Although
> > user can open /dev/iommu instead. This is not good.
> > 
> > CONFIG_IOMMUFD=y
> > CONFIG_VFIO_DEVICE_CDEv=n
> > CONFIG_VFIO_GROUP=y
> > CONFIG_VFIO_CONTAINER=n
> > CONFIG_IOMMUFD_VFIO_CONTAINER=n
> > 
> > So need to have the below change. I'll incorporate this change in
> > this series after your ack.
> > 
> > diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
> > index 99d4b075df49..d675c96c2bbb 100644
> > --- a/drivers/iommu/iommufd/Kconfig
> > +++ b/drivers/iommu/iommufd/Kconfig
> > @@ -14,8 +14,8 @@ config IOMMUFD
> >  if IOMMUFD
> >  config IOMMUFD_VFIO_CONTAINER
> >  	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
> > -	depends on VFIO_GROUP && !VFIO_CONTAINER
> > -	default VFIO_GROUP && !VFIO_CONTAINER
> > +	depends on VFIO_GROUP
> > +	default n
> >  	help
> >  	  IOMMUFD will provide /dev/vfio/vfio instead of VFIO. This relies on
> >  	  IOMMUFD providing compatibility emulation to give the same ioctls.
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > index 6bda6dbb4878..ee3bbad6beb8 100644
> > --- a/drivers/vfio/Kconfig
> > +++ b/drivers/vfio/Kconfig
> > @@ -6,7 +6,7 @@ menuconfig VFIO
> >  	select INTERVAL_TREE
> >  	select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
> >  	select VFIO_DEVICE_CDEV if !VFIO_GROUP
> > -	select VFIO_CONTAINER if IOMMUFD=n
> > +	select VFIO_CONTAINER if IOMMUFD_VFIO_CONTAINER=n
> >  	help
> >  	  VFIO provides a framework for secure userspace device drivers.
> >  	  See Documentation/driver-api/vfio.rst for more details.
> >   
> 
> Just realized that it is possible to config both VFIO_CONTAINER and
> IOMMUFD_VFIO_CONTAINER to "y". Then there will be a conflict when
> registering /dev/vfio/vfio. Any suggestion?

This is only an issue with the proposed change, right?  I agree with
Jason, removing /dev/vfio/vfio entirely should be possible.  That's
actually our ultimate goal, but obviously it breaks current userspace
depending on vfio container compatibility.  It's a configuration error,
not a Kconfig error if someone finds themselves without /dev/vfio/vfio
currently.  Thanks,

Alex

> > >  	help
> > >  	  IOMMUFD will provide /dev/vfio/vfio instead of VFIO. This relies on
> > >  	  IOMMUFD providing compatibility emulation to give the same ioctls.
> > > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > > index 1cab8e4729de..35ab8ab87688 100644
> > > --- a/drivers/vfio/Kconfig
> > > +++ b/drivers/vfio/Kconfig
> > > @@ -4,6 +4,8 @@ menuconfig VFIO
> > >  	select IOMMU_API
> > >  	depends on IOMMUFD || !IOMMUFD
> > >  	select INTERVAL_TREE
> > > +	select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
> > > +	select VFIO_DEVICE_CDEV if !VFIO_GROUP
> > >  	select VFIO_CONTAINER if IOMMUFD=n  
> > 
> > This should be " select VFIO_CONTAINER if IOMMUFD_VFIO_CONTAINER=n"
> > 
> > Regards,
> > Yi Liu
> >   
> > >  	help
> > >  	  VFIO provides a framework for secure userspace device drivers.
> > > @@ -15,6 +17,7 @@ if VFIO
> > >  config VFIO_DEVICE_CDEV
> > >  	bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
> > >  	depends on IOMMUFD
> > > +	default !VFIO_GROUP
> > >  	help
> > >  	  The VFIO device cdev is another way for userspace to get device
> > >  	  access. Userspace gets device fd by opening device cdev under
> > > @@ -24,9 +27,20 @@ config VFIO_DEVICE_CDEV
> > >
> > >  	  If you don't know what to do here, say N.
> > >
> > > +config VFIO_GROUP
> > > +	bool "Support for the VFIO group /dev/vfio/$group_id"
> > > +	default y
> > > +	help
> > > +	   VFIO group support provides the traditional model for accessing
> > > +	   devices through VFIO and is used by the majority of userspace
> > > +	   applications and drivers making use of VFIO.
> > > +
> > > +	   If you don't know what to do here, say Y.
> > > +
> > >  config VFIO_CONTAINER
> > >  	bool "Support for the VFIO container /dev/vfio/vfio"
> > >  	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> > > +	depends on VFIO_GROUP
> > >  	default y
> > >  	help
> > >  	  The VFIO container is the classic interface to VFIO for establishing
> > > @@ -48,6 +62,7 @@ endif
> > >
> > >  config VFIO_NOIOMMU
> > >  	bool "VFIO No-IOMMU support"
> > > +	depends on VFIO_GROUP
> > >  	help
> > >  	  VFIO is built on the ability to isolate devices using the IOMMU.
> > >  	  Only with an IOMMU can userspace access to DMA capable devices be
> > > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> > > index 245394aeb94b..57c3515af606 100644
> > > --- a/drivers/vfio/Makefile
> > > +++ b/drivers/vfio/Makefile
> > > @@ -2,9 +2,9 @@
> > >  obj-$(CONFIG_VFIO) += vfio.o
> > >
> > >  vfio-y += vfio_main.o \
> > > -	  group.o \
> > >  	  iova_bitmap.o
> > >  vfio-$(CONFIG_VFIO_DEVICE_CDEV) += device_cdev.o
> > > +vfio-$(CONFIG_VFIO_GROUP) += group.o
> > >  vfio-$(CONFIG_IOMMUFD) += iommufd.o
> > >  vfio-$(CONFIG_VFIO_CONTAINER) += container.o
> > >  vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
> > > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > > index e7a3fe093362..b27a3915e6c9 100644
> > > --- a/drivers/vfio/vfio.h
> > > +++ b/drivers/vfio/vfio.h
> > > @@ -36,6 +36,12 @@ vfio_allocate_device_file(struct vfio_device *device);
> > >
> > >  extern const struct file_operations vfio_device_fops;
> > >
> > > +#ifdef CONFIG_VFIO_NOIOMMU
> > > +extern bool vfio_noiommu __read_mostly;
> > > +#else
> > > +enum { vfio_noiommu = false };
> > > +#endif
> > > +
> > >  enum vfio_group_type {
> > >  	/*
> > >  	 * Physical device with IOMMU backing.
> > > @@ -60,6 +66,7 @@ enum vfio_group_type {
> > >  	VFIO_NO_IOMMU,
> > >  };
> > >
> > > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> > >  struct vfio_group {
> > >  	struct device 			dev;
> > >  	struct cdev			cdev;
> > > @@ -111,6 +118,82 @@ static inline bool vfio_device_is_noiommu(struct vfio_device
> > > *vdev)
> > >  	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > >  	       vdev->group->type == VFIO_NO_IOMMU;
> > >  }
> > > +#else
> > > +struct vfio_group;
> > > +
> > > +static inline int vfio_device_block_group(struct vfio_device *device)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > > +static inline void vfio_device_unblock_group(struct vfio_device *device)
> > > +{
> > > +}
> > > +
> > > +static inline int vfio_device_set_group(struct vfio_device *device,
> > > +					enum vfio_group_type type)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > > +static inline void vfio_device_remove_group(struct vfio_device *device)
> > > +{
> > > +}
> > > +
> > > +static inline void vfio_device_group_register(struct vfio_device *device)
> > > +{
> > > +}
> > > +
> > > +static inline void vfio_device_group_unregister(struct vfio_device *device)
> > > +{
> > > +}
> > > +
> > > +static inline int vfio_device_group_use_iommu(struct vfio_device *device)
> > > +{
> > > +	return -EOPNOTSUPP;
> > > +}
> > > +
> > > +static inline void vfio_device_group_unuse_iommu(struct vfio_device *device)
> > > +{
> > > +}
> > > +
> > > +static inline void vfio_df_group_close(struct vfio_device_file *df)
> > > +{
> > > +}
> > > +
> > > +static inline struct vfio_group *vfio_group_from_file(struct file *file)
> > > +{
> > > +	return NULL;
> > > +}
> > > +
> > > +static inline bool vfio_group_enforced_coherent(struct vfio_group *group)
> > > +{
> > > +	return true;
> > > +}
> > > +
> > > +static inline void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
> > > +{
> > > +}
> > > +
> > > +static inline bool vfio_device_has_container(struct vfio_device *device)
> > > +{
> > > +	return false;
> > > +}
> > > +
> > > +static inline int __init vfio_group_init(void)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > > +static inline void vfio_group_cleanup(void)
> > > +{
> > > +}
> > > +
> > > +static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> > > +{
> > > +	return false;
> > > +}
> > > +#endif /* CONFIG_VFIO_GROUP */
> > >
> > >  #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
> > >  /**
> > > @@ -362,12 +445,6 @@ static inline void vfio_virqfd_exit(void)
> > >  }
> > >  #endif
> > >
> > > -#ifdef CONFIG_VFIO_NOIOMMU
> > > -extern bool vfio_noiommu __read_mostly;
> > > -#else
> > > -enum { vfio_noiommu = false };
> > > -#endif
> > > -
> > >  #ifdef CONFIG_HAVE_KVM
> > >  void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm);
> > >  void vfio_device_put_kvm(struct vfio_device *device);
> > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > index d6228c839c44..5a1dee983f17 100644
> > > --- a/include/linux/vfio.h
> > > +++ b/include/linux/vfio.h
> > > @@ -43,7 +43,11 @@ struct vfio_device {
> > >  	 */
> > >  	const struct vfio_migration_ops *mig_ops;
> > >  	const struct vfio_log_ops *log_ops;
> > > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> > >  	struct vfio_group *group;
> > > +	struct list_head group_next;
> > > +	struct list_head iommu_entry;
> > > +#endif
> > >  	struct vfio_device_set *dev_set;
> > >  	struct list_head dev_set_list;
> > >  	unsigned int migration_flags;
> > > @@ -58,8 +62,6 @@ struct vfio_device {
> > >  	refcount_t refcount;	/* user count on registered device*/
> > >  	unsigned int open_count;
> > >  	struct completion comp;
> > > -	struct list_head group_next;
> > > -	struct list_head iommu_entry;
> > >  	struct iommufd_access *iommufd_access;
> > >  	void (*put_kvm)(struct kvm *kvm);
> > >  #if IS_ENABLED(CONFIG_IOMMUFD)
> > > @@ -284,12 +286,29 @@ int vfio_mig_get_next_state(struct vfio_device *device,
> > >  /*
> > >   * External user API
> > >   */
> > > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> > >  struct iommu_group *vfio_file_iommu_group(struct file *file);
> > >  bool vfio_file_is_group(struct file *file);
> > > +bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
> > > +#else
> > > +static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
> > > +{
> > > +	return NULL;
> > > +}
> > > +
> > > +static inline bool vfio_file_is_group(struct file *file)
> > > +{
> > > +	return false;
> > > +}
> > > +
> > > +static inline bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
> > > +{
> > > +	return false;
> > > +}
> > > +#endif
> > >  bool vfio_file_is_valid(struct file *file);
> > >  bool vfio_file_enforced_coherent(struct file *file);
> > >  void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
> > > -bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
> > >
> > >  #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
> > >
> > > --
> > > 2.34.1  
> 

