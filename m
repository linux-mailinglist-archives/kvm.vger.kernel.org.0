Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE0372E631
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242655AbjFMOt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242664AbjFMOtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:49:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FB1173C
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686667718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Au5yHcPaamLUTDAy1lALivyiFfLlJB/EXoLrOXOPPA=;
        b=Syey/lsA4qt5A/LcRuxx6Kdjk8q0w3hgFbFoqx99m39Mp7DTiW3tTlItmbL0RxHI+HM8oy
        JpW3BkpzYK0ZkPqpuSty49RfIIyFrOtNYIS4ZONmd6hCQ/5J98g5vhp9by0icDcZomNN6K
        JNgP0q/2NHuKWM/QI5rztkuwi6vftbM=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-61VT8a9WPKeX-sOOurg0zQ-1; Tue, 13 Jun 2023 10:48:31 -0400
X-MC-Unique: 61VT8a9WPKeX-sOOurg0zQ-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-77ac14e9bc5so650476739f.2
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:48:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686667711; x=1689259711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Au5yHcPaamLUTDAy1lALivyiFfLlJB/EXoLrOXOPPA=;
        b=hFfcpnsgAUdVGAGAUJ16iqfjZWqxxAmDUkD3eXSr/xKlSb4FjjILIsJj7dVbO+klu6
         1r8UUQsmjMYiP37lsg0xLj7S79TALN+b5jbriKM7ml/TUYtrZGL4P3kmsXUZ+c2wz9VR
         wuDypoHdF7BFgWCo77wLVAw4NrR/jv9fY4vVbuA6iBsIjP65uYH69X7FSfObi45Db7pM
         A5Ikg89VQlr1jIBhELO6jGp829wfPw0U1MpondeT67RWyVxG3f+6Pr0Cb1gnqnAPG6b4
         +CzQr1JixuSlyDsIXEU+dif20+7CvS1j+nFcCG6XeblzNMMCNqSbKBba0yMp9PlZTxva
         4MUQ==
X-Gm-Message-State: AC+VfDzsX3wNw/vGTczOsq5QShMPJ0Z7+oLo5USNHaElCieTrtoIMEF0
        2l9HGhmrK7+SGLr5rg1lR980som0mbuxpWi3NAgv40eEbgobGQxNJ5UjtZgSEk7NZ6hZSCFXmop
        J/hlklfnxuepr
X-Received: by 2002:a05:6602:224e:b0:76c:6382:8d5b with SMTP id o14-20020a056602224e00b0076c63828d5bmr11619929ioo.10.1686667710822;
        Tue, 13 Jun 2023 07:48:30 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7kDLAWaKUO1yUsXW0IekRRbMRMPnfJq0GCOYazAfEkGhrECmQ2ohZ2H0Yn3F4btXNUZoyJKQ==
X-Received: by 2002:a05:6602:224e:b0:76c:6382:8d5b with SMTP id o14-20020a056602224e00b0076c63828d5bmr11619888ioo.10.1686667710504;
        Tue, 13 Jun 2023 07:48:30 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w12-20020a02968c000000b0041d7ad74b36sm3502462jai.17.2023.06.13.07.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 07:48:30 -0700 (PDT)
Date:   Tue, 13 Jun 2023 08:48:28 -0600
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
Subject: Re: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Message-ID: <20230613084828.7af51055.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529EB2903151B3399F636F5C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-22-yi.l.liu@intel.com>
        <20230612164228.65b500e0.alex.williamson@redhat.com>
        <DS0PR11MB7529AE3701E154BF4C092E57C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613081913.279dea9e.alex.williamson@redhat.com>
        <DS0PR11MB7529EB2903151B3399F636F5C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Jun 2023 14:33:01 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, June 13, 2023 10:19 PM
> > 
> > On Tue, 13 Jun 2023 05:53:42 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Tuesday, June 13, 2023 6:42 AM
> > > >
> > > > On Fri,  2 Jun 2023 05:16:50 -0700
> > > > Yi Liu <yi.l.liu@intel.com> wrote:
> > > >  
> > > > > This moves the noiommu device determination and noiommu taint out of
> > > > > vfio_group_find_or_alloc(). noiommu device is determined in
> > > > > __vfio_register_dev() and result is stored in flag vfio_device->noiommu,
> > > > > the noiommu taint is added in the end of __vfio_register_dev().
> > > > >
> > > > > This is also a preparation for compiling out vfio_group infrastructure
> > > > > as it makes the noiommu detection and taint common between the cdev path
> > > > > and group path though cdev path does not support noiommu.  
> > > >
> > > > Does this really still make sense?  The motivation for the change is
> > > > really not clear without cdev support for noiommu.  Thanks,  
> > >
> > > I think it still makes sense. When CONFIG_VFIO_GROUP==n, the kernel
> > > only supports cdev interface. If there is noiommu device, vfio should
> > > fail the registration. So, the noiommu determination is still needed. But
> > > I'd admit the taint might still be in the group code.  
> > 
> > How is there going to be a noiommu device when VFIO_GROUP is unset?  
> 
> How about booting a kernel with iommu disabled, then all the devices
> are not protected by iommu. I suppose they are noiommu devices. If
> user wants to bound them to vfio, the kernel should have VFIO_GROUP.
> Otherwise, needs to fail.

"noiommu" is a vfio designation of a device, it must be created by
vfio.  There can certainly be devices which are not IOMMU backed, but
without vfio designating them as noiommu devices, which is only done
via the legacy and compat paths, there's no such thing as a noiommu
device.  Devices without an IOMMU are simply out of scope for cdev,
there should never be a vfio cdev entry created for them.  Thanks,

Alex

