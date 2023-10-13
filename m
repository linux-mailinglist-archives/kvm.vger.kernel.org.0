Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE337C8E66
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 22:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjJMUmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 16:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjJMUmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 16:42:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03F583
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 13:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697229681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c2UsGP+2r+wUz9aRVRBXwzrgYrcf9wBBri+aYMN3oKI=;
        b=f3f6wnx6P5rp+0vCgRyNG4em7/145xI4+/PI75ywOXEeAzTCtL093XqL7RDm1mUOEhfrjq
        T+qOWR9qJnyfWkd2ZoeD66L8nTpDOK7D5UpH6V3RI2yE8EUWqpU8ZRdyWXzfJRUD0UHKyk
        ALfHBc3QBWKMRQB3P1j1Byr/ftEdiMA=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-7wp_5A38Nu2T-_8KDsHqUg-1; Fri, 13 Oct 2023 16:41:19 -0400
X-MC-Unique: 7wp_5A38Nu2T-_8KDsHqUg-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7a5b1c9ec7aso182396339f.3
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 13:41:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697229679; x=1697834479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c2UsGP+2r+wUz9aRVRBXwzrgYrcf9wBBri+aYMN3oKI=;
        b=uIy3TplAMMjx5ygsKiJ5UzLoTORFkbTq7IvwT6Fr39zRjYkxv1sgYGMSZRj50nQDsY
         WGepXRpSj/r1ucBViFvdhMLhzPMabfEXXi4hkNZLqyVkdXE/Z20JxuUGAEo8DI+/v1O0
         TJXXV+waKlQhZKlSqsIMS2AYNGA4MVs4h/oFER5M45EdyN7D8jlHbBFgKqLitqTm8gVB
         1i4ZxXHBYSyo+AX8FDUXyxcK32U7SjFjcnnOreCMezbSOr9xt67tHw1S4bcPKuf+LNY7
         f9fSRArgW86ef/cbCgS+9C2iiw4AOq0G9SCZosdngaCMgYhKaB0q+TXf6wya9q4DJCSp
         p3Pg==
X-Gm-Message-State: AOJu0YyRrZelr7uKPB7Fx66frxnIRHNXTU5zbZQB5p/9CmD5r1po9xCg
        Akno+CudL087RJZ6DzTe4Uers/f1vniQ0Zs6f5O8Ou9UwfFlemuv3rMzxfvKGxCKBVkZT437u7/
        LuhggiMLCIsxA
X-Received: by 2002:a05:6e02:20c9:b0:34f:2cb0:5d0 with SMTP id 9-20020a056e0220c900b0034f2cb005d0mr33087687ilq.30.1697229679104;
        Fri, 13 Oct 2023 13:41:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGL7SNq4xbR7of9PPMpdOxuh2DbQmS6vXHW980fEbgTmkgWtFwSm/OB9haHVE4xFL7B953KPg==
X-Received: by 2002:a05:6e02:20c9:b0:34f:2cb0:5d0 with SMTP id 9-20020a056e0220c900b0034f2cb005d0mr33087670ilq.30.1697229678831;
        Fri, 13 Oct 2023 13:41:18 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id q4-20020a92c004000000b0035142f4a6b7sm1619010ild.48.2023.10.13.13.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Oct 2023 13:41:18 -0700 (PDT)
Date:   Fri, 13 Oct 2023 14:41:16 -0600
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
Message-ID: <20231013144116.32c2c101.alex.williamson@redhat.com>
In-Reply-To: <77579409-c318-4bba-8503-637f4653c220@oracle.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
        <20230923012511.10379-3-joao.m.martins@oracle.com>
        <20231013154821.GX3952@nvidia.com>
        <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
        <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
        <20231013171628.GI3952@nvidia.com>
        <77579409-c318-4bba-8503-637f4653c220@oracle.com>
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

On Fri, 13 Oct 2023 18:23:09 +0100
Joao Martins <joao.m.martins@oracle.com> wrote:

> On 13/10/2023 18:16, Jason Gunthorpe wrote:
> > On Fri, Oct 13, 2023 at 06:10:04PM +0100, Joao Martins wrote:  
> >> On 13/10/2023 17:00, Joao Martins wrote:  
> >>> On 13/10/2023 16:48, Jason Gunthorpe wrote:  
> >>>> On Sat, Sep 23, 2023 at 02:24:54AM +0100, Joao Martins wrote:  
> >>>>> Both VFIO and IOMMUFD will need iova bitmap for storing dirties and walking
> >>>>> the user bitmaps, so move to the common dependency into IOMMU core. IOMMUFD
> >>>>> can't exactly host it given that VFIO dirty tracking can be used without
> >>>>> IOMMUFD.  
> >>>>
> >>>> Hum, this seems strange. Why not just make those VFIO drivers depends
> >>>> on iommufd? That seems harmless to me.
> >>>>  
> >>>
> >>> IF you and Alex are OK with it then I can move to IOMMUFD.

It's only strange in that we don't actually have a hard dependency on
IOMMUFD currently and won't until we remove container support, which is
some ways down the road.  Ultimately we expect to get to the same
place, so I don't have a particular issue with it.

> >>>> However, I think the real issue is that iommu drivers need to use this
> >>>> API too for their part?
> >>>>  
> >>>
> >>> Exactly.
> >>>  
> >>
> >> My other concern into moving to IOMMUFD instead of core was VFIO_IOMMU_TYPE1,
> >> and if we always make it depend on IOMMUFD then we can't have what is today
> >> something supported because of VFIO_IOMMU_TYPE1 stuff with migration drivers
> >> (i.e. vfio-iommu-type1 with the live migration stuff).  
> > 
> > I plan to remove the live migration stuff from vfio-iommu-type1, it is
> > all dead code now.
> >   
> 
> I wasn't referring to the type1 dirty tracking stuff -- I was referring the
> stuff related to vfio devices, used *together* with type1 (for DMA map/unmap).
> 
> >> But if it's exists an IOMMUFD_DRIVER kconfig, then VFIO_CONTAINER can instead
> >> select the IOMMUFD_DRIVER alone so long as CONFIG_IOMMUFD isn't required? I am
> >> essentially talking about:  
> > 
> > Not VFIO_CONTAINER, the dirty tracking code is in vfio_main:
> > 
> > vfio_main.c:#include <linux/iova_bitmap.h>
> > vfio_main.c:static int vfio_device_log_read_and_clear(struct iova_bitmap *iter,
> > vfio_main.c:    struct iova_bitmap *iter;
> > vfio_main.c:    iter = iova_bitmap_alloc(report.iova, report.length,
> > vfio_main.c:    ret = iova_bitmap_for_each(iter, device,
> > vfio_main.c:    iova_bitmap_free(iter);
> > 
> > And in various vfio device drivers.
> > 
> > So the various drivers can select IOMMUFD_DRIVER
> >   
> 
> It isn't so much that type1 requires IOMMUFD, but more that it is used together
> with the core code that allows the vfio drivers to do migration. So the concern
> is if we make VFIO core depend on IOMMU that we prevent
> VFIO_CONTAINER/VFIO_GROUP to not be selected. My kconfig read was that we either
> select VFIO_GROUP or VFIO_DEVICE_CDEV but not both

That's not true.  We can have both.  In fact we rely on having both to
support a smooth transition to the cdev interface.  Thanks,

Alex

