Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E667C8F92
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 23:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjJMVw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 17:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjJMVw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 17:52:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F06B7
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 14:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697233899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GhJ8SRDAsdQr3G0YpWQQAfHmnlmxFLHLMdnMLzMYnow=;
        b=MO6QtU+woU5EoLDCVexGghosWuGU4xanuUeVUnaQqc/Qmd+RcHCkBendSS6Z8eZjghDOrv
        5XhN0iW6QzjpShbjhrr/AAR+jnXlek7LPEwbHkGqzUdwKIhJkBF/jSjky0sF3hZWaDTtJz
        bY9Qp59BU1NbRPd5/kZjfPAAnwekhz4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-Llhv-FxtMu63eSKT9M-WXw-1; Fri, 13 Oct 2023 17:51:38 -0400
X-MC-Unique: Llhv-FxtMu63eSKT9M-WXw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-790d3e93a25so177997339f.0
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 14:51:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697233897; x=1697838697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GhJ8SRDAsdQr3G0YpWQQAfHmnlmxFLHLMdnMLzMYnow=;
        b=AxWJ3ZbELvuTsKBj4faVXiTIjxnTDZBlGYgUEipV54tTEDt3neC6BGlguBwZfIERLK
         czblmMcwAB1lAW9getq9kQoUPI3D7lPdU3Pw+Y+G5Y8BIMH57SmdnTGA9XndC0h4XLKj
         3DPgVXfsK+YYBCRmEZIuSueWHN1B84VBFdQ1Wa4Sw/8xXb+zVLL7lyp6Fte72TiLOVGQ
         dzYHMoZISCHiZI1UFFgakqQdM3rOWIh3nN82I0lixC5njwsWbTvxgrh7WMTZriA4OEqu
         /3CAir2bZvcM6Pc6AtFn8PTkNaG2mKclo7MGPAT/WjF2yoqCwEqOXQhepyuQ3fUVVVBX
         TwPg==
X-Gm-Message-State: AOJu0YyPof0E3RoJAxS1AdfFO4ckIydAWs+rvPo9c5q7rXXBldbrPA/j
        9Xkb12qQyDKTP3CnUmk9aS5yfe7yBk6cs+fRJ79435bZaGUdgLB0s23QcZAPXos28t3CqfFEpq3
        OhblZLgILj6ZTJqdbN40l
X-Received: by 2002:a6b:ec17:0:b0:791:7e14:4347 with SMTP id c23-20020a6bec17000000b007917e144347mr31488015ioh.13.1697233897229;
        Fri, 13 Oct 2023 14:51:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgJfnAc1pGwIl+LmG0Sg1nTwLSfHLN45ZG0Fc/3K8qEvLlUR3bLmHHistY/nTAfvcNsdo+uw==
X-Received: by 2002:a6b:ec17:0:b0:791:7e14:4347 with SMTP id c23-20020a6bec17000000b007917e144347mr31488003ioh.13.1697233896987;
        Fri, 13 Oct 2023 14:51:36 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id f26-20020a056602039a00b0078335414ddesm5036209iov.26.2023.10.13.14.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Oct 2023 14:51:36 -0700 (PDT)
Date:   Fri, 13 Oct 2023 15:51:34 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Message-ID: <20231013155134.6180386e.alex.williamson@redhat.com>
In-Reply-To: <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
        <20230923012511.10379-3-joao.m.martins@oracle.com>
        <20231013154821.GX3952@nvidia.com>
        <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
        <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
        <20231013171628.GI3952@nvidia.com>
        <77579409-c318-4bba-8503-637f4653c220@oracle.com>
        <20231013144116.32c2c101.alex.williamson@redhat.com>
        <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Oct 2023 22:20:31 +0100
Joao Martins <joao.m.martins@oracle.com> wrote:

> On 13/10/2023 21:41, Alex Williamson wrote:
> > On Fri, 13 Oct 2023 18:23:09 +0100
> > Joao Martins <joao.m.martins@oracle.com> wrote:
> >   
> >> On 13/10/2023 18:16, Jason Gunthorpe wrote:  
> >>> On Fri, Oct 13, 2023 at 06:10:04PM +0100, Joao Martins wrote:    
> >>>> On 13/10/2023 17:00, Joao Martins wrote:    
> >>>>> On 13/10/2023 16:48, Jason Gunthorpe wrote:    
> >>>> But if it's exists an IOMMUFD_DRIVER kconfig, then VFIO_CONTAINER can instead
> >>>> select the IOMMUFD_DRIVER alone so long as CONFIG_IOMMUFD isn't required? I am
> >>>> essentially talking about:    
> >>>
> >>> Not VFIO_CONTAINER, the dirty tracking code is in vfio_main:
> >>>
> >>> vfio_main.c:#include <linux/iova_bitmap.h>
> >>> vfio_main.c:static int vfio_device_log_read_and_clear(struct iova_bitmap *iter,
> >>> vfio_main.c:    struct iova_bitmap *iter;
> >>> vfio_main.c:    iter = iova_bitmap_alloc(report.iova, report.length,
> >>> vfio_main.c:    ret = iova_bitmap_for_each(iter, device,
> >>> vfio_main.c:    iova_bitmap_free(iter);
> >>>
> >>> And in various vfio device drivers.
> >>>
> >>> So the various drivers can select IOMMUFD_DRIVER
> >>>     
> >>
> >> It isn't so much that type1 requires IOMMUFD, but more that it is used together
> >> with the core code that allows the vfio drivers to do migration. So the concern
> >> is if we make VFIO core depend on IOMMU that we prevent
> >> VFIO_CONTAINER/VFIO_GROUP to not be selected. My kconfig read was that we either
> >> select VFIO_GROUP or VFIO_DEVICE_CDEV but not both  
> > 
> > That's not true.  We can have both.  In fact we rely on having both to
> > support a smooth transition to the cdev interface.  Thanks,  
> 
> On a triple look, mixed defaults[0] vs manual config: having IOMMUFD=y|m today
> it won't select VFIO_CONTAINER, nobody stops one from actually selecting it
> both. Unless I missed something

Oh!  I misunderstood your comment, you're referring to default
selections rather than possible selections.  So yes, if VFIO depends on
IOMMUFD then suddenly our default configs shift to IOMMUFD/CDEV rather
than legacy CONTAINER/GROUP.  So perhaps if VFIO selects IOMMUFD, that's
not exactly harmless currently.

I think Jason is describing this would eventually be in a built-in
portion of IOMMUFD, but I think currently that built-in portion is
IOMMU.  So until we have this IOMMUFD_DRIVER that enables that built-in
portion, it seems unnecessarily disruptive to make VFIO select IOMMUFD
to get this iova bitmap support.  Thanks,

Alex

> [0] Ref:
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/drivers/vfio/Kconfig
> 
> menuconfig VFIO
> 	[...]
> 	select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
> 	select VFIO_DEVICE_CDEV if !VFIO_GROUP
> 	select VFIO_CONTAINER if IOMMUFD=n
> 	[...]
> 
> if VFIO
> config VFIO_DEVICE_CDEV
> 	[...]
> 	depends on IOMMUFD && !SPAPR_TCE_IOMMU
> 	default !VFIO_GROUP
> [...]
> config VFIO_GROUP
> 	default y
> [...]
> config VFIO_CONTAINER
> 	[...]
> 	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> 	depends on VFIO_GROUP
> 	default y
> 

