Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D662B6D0EA1
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 21:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjC3TWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 15:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjC3TWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 15:22:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F37E046
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 12:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680204107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sqnQEZxaWao68chgcCo4orFozBmRoRDCr3XacwFOlaI=;
        b=GOmAhyxayqqOngeiMH8WA3lT+7sjLhiVqwhyWsYMfxrVQ3OjWH/sULkpH4zdawmUknPvvz
        COXcHycnfSOV2iH0rz+xcMWc2DEoOK+00BPzAWw9+PFHZfTmxbl3aVN1iq8OPa0Ib1cOrU
        jk3TLM1JMHmWx/MdjGikqkRTtohQIX8=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-IZarHoX2NEulGASkCYMr6A-1; Thu, 30 Mar 2023 15:21:46 -0400
X-MC-Unique: IZarHoX2NEulGASkCYMr6A-1
Received: by mail-io1-f71.google.com with SMTP id y69-20020a6bc848000000b00758ac1b67f8so12034026iof.17
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 12:21:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680204106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sqnQEZxaWao68chgcCo4orFozBmRoRDCr3XacwFOlaI=;
        b=BwL4KjuL+sBX2qRuyMyWpJyoSPikcmJQdC0MoeHeZ5ftkc2neQ30sL+Io/3LqtVg/S
         5s0iMkQazRIEl/o8kF4zf+8TGTeb4Re/l70MIIQakVOKRZ8kl+d9xUIQ5+4Fk5budWTe
         gvwPjbYGEEt5rQAwvjN5d9FlGHJ6pQqIAIQOffNA/3e0pHhcouu5lJgohxcT2QHFclim
         d7ukbH5eta/QnRXXBzQu8RlYC6caGm/z1leFyR0olzb0aLpIwl7s5WV/amA1yoVUyRAt
         Rrs0SB7jCZ69fneOWuOFn14zk1WVlOz3VmXWLK5claKrfS9j0VXR1Fub8TvUt8xwY2GJ
         kT4A==
X-Gm-Message-State: AO0yUKVmRlG3tsGU9AFWb740EgM4SU8ln7klvzwmZ/xJPgk9rUW2a4oz
        P/uLWEFQZdlUJNfPhzI9rZxgv/P8iULvp8ap9OylLFBhoLQ384+8nj5BOZD2rklrjeihKBw06h/
        ERFW0ji1cnfQd
X-Received: by 2002:a05:6602:20da:b0:74c:aa1d:c1a1 with SMTP id 26-20020a05660220da00b0074caa1dc1a1mr17687512ioz.3.1680204105936;
        Thu, 30 Mar 2023 12:21:45 -0700 (PDT)
X-Google-Smtp-Source: AK7set+mNeudR7e8tOPV/GXrIldwy7od5clU9Br4psJl/Z0Ulm5W6yZvi903JIlNz219vg0XihaniQ==
X-Received: by 2002:a05:6602:20da:b0:74c:aa1d:c1a1 with SMTP id 26-20020a05660220da00b0074caa1dc1a1mr17687509ioz.3.1680204105715;
        Thu, 30 Mar 2023 12:21:45 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id cp7-20020a056638480700b00403089c2a1dsm104349jab.108.2023.03.30.12.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 12:21:45 -0700 (PDT)
Date:   Thu, 30 Mar 2023 13:21:43 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: Re: [PATCH v3 0/6] vfio: Make emulated devices prepared for vfio
 device cdev
Message-ID: <20230330132143.0c33f4d3.alex.williamson@redhat.com>
In-Reply-To: <ZCSV2+LbgeWD2bPa@nvidia.com>
References: <20230327093351.44505-1-yi.l.liu@intel.com>
        <ZCSV2+LbgeWD2bPa@nvidia.com>
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

On Wed, 29 Mar 2023 16:47:39 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Mar 27, 2023 at 02:33:45AM -0700, Yi Liu wrote:
> > Nicolin Chen (1):
> >   iommufd: Create access in vfio_iommufd_emulated_bind()
> > 
> > Yi Liu (5):
> >   iommu/iommufd: Pass iommufd_ctx pointer in iommufd_get_ioas()
> >   vfio-iommufd: No need to record iommufd_ctx in vfio_device
> >   vfio-iommufd: Make vfio_iommufd_emulated_bind() return iommufd_access
> >     ID
> >   vfio/mdev: Uses the vfio emulated iommufd ops set in the mdev sample
> >     drivers
> >   vfio: Check the presence for iommufd callbacks in
> >     __vfio_register_dev()
> > 
> >  drivers/iommu/iommufd/device.c          | 55 +++++++++++++++----------
> >  drivers/iommu/iommufd/ioas.c            | 14 +++----
> >  drivers/iommu/iommufd/iommufd_private.h |  4 +-
> >  drivers/iommu/iommufd/selftest.c        | 14 ++++---
> >  drivers/iommu/iommufd/vfio_compat.c     |  2 +-
> >  drivers/vfio/iommufd.c                  | 37 ++++++++---------
> >  drivers/vfio/vfio_main.c                |  5 ++-
> >  include/linux/iommufd.h                 |  5 ++-
> >  include/linux/vfio.h                    |  1 -
> >  samples/vfio-mdev/mbochs.c              |  3 ++
> >  samples/vfio-mdev/mdpy.c                |  3 ++
> >  samples/vfio-mdev/mtty.c                |  3 ++
> >  12 files changed, 85 insertions(+), 61 deletions(-)  
> 
> It looks like most of this is iommufd so I will take it - Ok Alex?
> 
> The following cdev patch needs it so I'll stick it on its own branch
> and we can sort it out after the reset series is done

Ok

Acked-by: Alex Williamson <alex.williamson@redhat.com>

