Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7676E6C43
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 20:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjDRSkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 14:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbjDRSkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 14:40:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8DE86A1
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 11:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681843165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RlhdInMDglDOKE7GpswpOzxWQD/BSn3H/Bb/VhIcGlQ=;
        b=ULqQ3clwDqe8jmnrs3eY5pRZnN36ucu0e5RGHGF6h6Mi2Aasurt5usT+0qdHK1ByrkoOGB
        ePzS87+GWBwyRKhcZJG2S75+QGerI8BXBdqC+8pDp2XRTzj/tiua68ViEVlOUZD31mmAaS
        QUwh4XCvfQ/MrjHth6bnTq3NS7LHpDI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-x1mO9xj8PUOuAzK480V4ZQ-1; Tue, 18 Apr 2023 14:39:24 -0400
X-MC-Unique: x1mO9xj8PUOuAzK480V4ZQ-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-760da06b86aso173555439f.0
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 11:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681843163; x=1684435163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RlhdInMDglDOKE7GpswpOzxWQD/BSn3H/Bb/VhIcGlQ=;
        b=bOvGlSDngO5jxJrgObdy0ApA2j+X/uuRWK6Dwk+aO3XHHIfu7vKOCMQeQHqp0n6d8X
         bsCWMRbzyE2z9EBRYp85039ogOTIzP37YLKnblVfbq4epgwiZ/j1SBoMNpCN8uTzhKM6
         zwwb10ORQqTUbKe0tNrHhzmdboNhbqyBWd40EDxT3qBb5dQNYrv2gj4msIYCymufvWcS
         nePZVBkAoqPKFGo77QXg2qY+34pDYFAzPsJkZoQaHVbwFNy0tCZ2UK1POHbwgme89HeF
         Qx9Zd4sd2dJnvmbD56YUh8Odro8Nf9QnIx3QxrXdg1oopvSALrxtzXaAfGUYiCgVj9CR
         TVUg==
X-Gm-Message-State: AAQBX9eFJsPM3q0XAl0kBE1tdgRQcp1fUfWGmmRr189HS10YkgPP2pGa
        UUdzp2HcIxRpRx9GHtB6IBVyApEaT1kU3sbxER18bBvux+4sGQyYRTtoAnKWeS1+KWQT2N6Ovwr
        MFjo42tOY5HPO
X-Received: by 2002:a6b:ee0f:0:b0:760:eabc:e709 with SMTP id i15-20020a6bee0f000000b00760eabce709mr2809081ioh.5.1681843163022;
        Tue, 18 Apr 2023 11:39:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZBMu2Ku+EgL+xrfqBT3olO/h3dlhwVXO3eygNQx8PsQ3dE3awxUujY3TvdRou00sMSiGZD3A==
X-Received: by 2002:a6b:ee0f:0:b0:760:eabc:e709 with SMTP id i15-20020a6bee0f000000b00760eabce709mr2809046ioh.5.1681843162606;
        Tue, 18 Apr 2023 11:39:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c12-20020a6bfd0c000000b00763601c4bfesm618585ioi.55.2023.04.18.11.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 11:39:22 -0700 (PDT)
Date:   Tue, 18 Apr 2023 12:39:20 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <20230418123920.5d92f402.alex.williamson@redhat.com>
In-Reply-To: <ZD6TvA+9oI0v4vC2@nvidia.com>
References: <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZDfslVwqk6JtPpyD@nvidia.com>
        <20230413120712.3b9bf42d.alex.williamson@redhat.com>
        <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230414111043.40c15dde.alex.williamson@redhat.com>
        <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230417130140.1b68082e.alex.williamson@redhat.com>
        <ZD2erN3nKbnyqei9@nvidia.com>
        <20230417140642.650fc165.alex.williamson@redhat.com>
        <ZD6TvA+9oI0v4vC2@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Apr 2023 09:57:32 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Apr 17, 2023 at 02:06:42PM -0600, Alex Williamson wrote:
> > On Mon, 17 Apr 2023 16:31:56 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Apr 17, 2023 at 01:01:40PM -0600, Alex Williamson wrote:  
> > > > Yes, it's not trivial, but Jason is now proposing that we consider
> > > > mixing groups, cdevs, and multiple iommufd_ctxs as invalid.  I think
> > > > this means that regardless of which device calls INFO, there's only one
> > > > answer (assuming same set of devices opened, all cdev, all within same
> > > > iommufd_ctx).  Based on what I explained about my understanding of INFO2
> > > > and Jason agreed to, I think the output would be:
> > > > 
> > > > flags: NOT_RESETABLE | DEV_ID
> > > > {
> > > >   { valid devA-id,  devA-BDF },
> > > >   { valid devC-id,  devC-BDF },
> > > >   { valid devD-id,  devD-BDF },
> > > >   { invalid dev-id, devE-BDF },
> > > > }
> > > > 
> > > > Here devB gets dropped because the kernel understands that devB is
> > > > unopened, affected, and owned.  It's therefore not a blocker for
> > > > hot-reset.    
> > > 
> > > I don't think we want to drop anything because it makes the API
> > > ill suited for the debugging purpose.
> > > 
> > > devb should be returned with an invalid dev_id if I understand your
> > > example. Maybe it should return with -1 as the dev_id instead of 0, to
> > > make the debugging a bit better.
> > > 
> > > Userspace should look at only NOT_RESETTABLE to determine if it
> > > proceeds or not, and it should use the valid dev_id list to iterate
> > > over the devices it has open to do the config stuff.  
> > 
> > If an affected device is owned, not opened, and not interfering with
> > the reset, what is it adding to the API to report it for debugging
> > purposes?  
> 
> It lets it print the entire group of devices, this is the only way
> something can learn the actual list of all BDFs affected.

If we do so, userspace must be able to differentiate which devices are
blocking, which necessitates at least a bi-modal invalid dev-id.

> dev_id can just return 0, we don't need a complex bitmap. Userspace
> looks at the flag, if !NOT_RESETABLE then it ignores dev_id=0.

I'm having trouble with a succinct definition of dev-id == 0, is it "A
device affected by the hot-reset reset, which does not directly
contribute to the availability of the hot-reset, ex. an unopened device
within the same IOMMU group as an opened device (ie. this is not the
device responsible if hot-reset is unavailable).  Whereas dev-id < 0
(== -1) is an affected device which prevents hot-reset, ex. an un-owned
device, device configured within a different iommufd_ctx, or device
opened outside of the vfio cdev API."  Is that about right?  Thanks,

Alex

