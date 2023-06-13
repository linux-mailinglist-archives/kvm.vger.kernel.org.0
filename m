Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F045D72E611
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241113AbjFMOnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241102AbjFMOnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:43:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA251738
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686667347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJBdM5iFqkTDpWUz6Au4hD17+lrzXhHFsk4TwJivz9s=;
        b=FTWQf0Zzv9MvhG57mum9b3wmDiymsFH0nZx8Blw/doJxi94vQ7gA3JCHnVT8bTo6+h53G1
        Ia4uShxW+HS+EGCJkIk5cDuH2TPQ1ejbNJMTGiFAeVJA8dn3Rno5ZdH6r6DggoE44PPAvR
        b3mIEHORwzOqSP8CA5jfBni+7zbrirU=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-9C__vNdpN_a6eB5ADOgx0A-1; Tue, 13 Jun 2023 10:42:22 -0400
X-MC-Unique: 9C__vNdpN_a6eB5ADOgx0A-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-77ac14e9bc5so649972639f.2
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:42:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686667340; x=1689259340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJBdM5iFqkTDpWUz6Au4hD17+lrzXhHFsk4TwJivz9s=;
        b=KIfVveqS2erbtFr8re2I9li/Gy63Jv3RH0Y7aDwicn3pZyxJJwKOUZ8sDlt0B8FK+8
         +w1p48Ytf5h0msjnW2e3xMN4QBqESQku4jHj3PSfYMB0+x7pvarHo5vlLpbMP9R79qUM
         DUPLAnslg5KqOCZzn88dlVnssdJwmKLK+gyX4w1gneyOzx9mkSJWhQUwub7A6k9PlsZb
         1lsvCX47tiBYgSfYk3TrlOp/egZ29tceTvNrFaufke7kbQUPMaNi8iY7A5apeInFwdjp
         FMQ5A2PALmWMiOXzLZH1OhBOu24hrACnnVMzFghWvRf3iR242V9fJdhG80P7tg94zziT
         ic1w==
X-Gm-Message-State: AC+VfDzrnbW6VJbJ33+L8IK2GGsuHV0a+y9F4PE98ra7GeMKTaptiWQv
        B9TaDzThAbGIh+pdOwrUa9lq7tfaF3iHzU/Re3ljYOoVC4kQRe5lRZqpU3oLarJQ9ZS7BTWLYwD
        YIx/z/n6JeJUu
X-Received: by 2002:a6b:7b45:0:b0:77a:ec0c:5907 with SMTP id m5-20020a6b7b45000000b0077aec0c5907mr8777960iop.13.1686667340576;
        Tue, 13 Jun 2023 07:42:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4rchrvAq7uL6qdxBGPgYc5Il7VncBPd83zFXMFGzPeWvh3heO7+g3e0YZao/Y4oWkkn0QpGA==
X-Received: by 2002:a6b:7b45:0:b0:77a:ec0c:5907 with SMTP id m5-20020a6b7b45000000b0077aec0c5907mr8777918iop.13.1686667340197;
        Tue, 13 Jun 2023 07:42:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e5-20020a02caa5000000b0040908cbbc5asm3525944jap.68.2023.06.13.07.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 07:42:19 -0700 (PDT)
Date:   Tue, 13 Jun 2023 08:42:18 -0600
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
Subject: Re: [PATCH v12 07/24] vfio: Block device access via device fd until
 device is opened
Message-ID: <20230613084218.169f1c4c.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529B3DB059798EA474ACB3DC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-8-yi.l.liu@intel.com>
        <20230612155210.5fd3579f.alex.williamson@redhat.com>
        <DS0PR11MB75293327BDE6D268996FFFCCC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613081647.740f5217.alex.williamson@redhat.com>
        <DS0PR11MB7529B3DB059798EA474ACB3DC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
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

On Tue, 13 Jun 2023 14:36:14 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, June 13, 2023 10:17 PM
> > 
> > On Tue, 13 Jun 2023 05:46:32 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Tuesday, June 13, 2023 5:52 AM
> > > >
> > > > On Fri,  2 Jun 2023 05:16:36 -0700
> > > > Yi Liu <yi.l.liu@intel.com> wrote:
> > > >  
> > > > > Allow the vfio_device file to be in a state where the device FD is
> > > > > opened but the device cannot be used by userspace (i.e. its .open_device()
> > > > > hasn't been called). This inbetween state is not used when the device
> > > > > FD is spawned from the group FD, however when we create the device FD
> > > > > directly by opening a cdev it will be opened in the blocked state.
> > > > >
> > > > > The reason for the inbetween state is that userspace only gets a FD but
> > > > > doesn't gain access permission until binding the FD to an iommufd. So in
> > > > > the blocked state, only the bind operation is allowed. Completing bind
> > > > > will allow user to further access the device.
> > > > >
> > > > > This is implemented by adding a flag in struct vfio_device_file to mark
> > > > > the blocked state and using a simple smp_load_acquire() to obtain the
> > > > > flag value and serialize all the device setup with the thread accessing
> > > > > this device.
> > > > >
> > > > > Following this lockless scheme, it can safely handle the device FD
> > > > > unbound->bound but it cannot handle bound->unbound. To allow this we'd
> > > > > need to add a lock on all the vfio ioctls which seems costly. So once
> > > > > device FD is bound, it remains bound until the FD is closed.
> > > > >
> > > > > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > > > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > > > > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > > > > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > > > > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > > > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > > > > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > > > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > > > ---
> > > > >  drivers/vfio/group.c     | 11 ++++++++++-
> > > > >  drivers/vfio/vfio.h      |  1 +
> > > > >  drivers/vfio/vfio_main.c | 16 ++++++++++++++++
> > > > >  3 files changed, 27 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > > > > index caf53716ddb2..088dd34c8931 100644
> > > > > --- a/drivers/vfio/group.c
> > > > > +++ b/drivers/vfio/group.c
> > > > > @@ -194,9 +194,18 @@ static int vfio_df_group_open(struct vfio_device_file *df)
> > > > >  	df->iommufd = device->group->iommufd;
> > > > >
> > > > >  	ret = vfio_df_open(df);
> > > > > -	if (ret)
> > > > > +	if (ret) {
> > > > >  		df->iommufd = NULL;
> > > > > +		goto out_put_kvm;
> > > > > +	}
> > > > > +
> > > > > +	/*
> > > > > +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> > > > > +	 * read/write/mmap and vfio_file_has_device_access()
> > > > > +	 */
> > > > > +	smp_store_release(&df->access_granted, true);
> > > > >
> > > > > +out_put_kvm:
> > > > >  	if (device->open_count == 0)
> > > > >  		vfio_device_put_kvm(device);
> > > > >
> > > > > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > > > > index f9eb52eb9ed7..fdf2fc73f880 100644
> > > > > --- a/drivers/vfio/vfio.h
> > > > > +++ b/drivers/vfio/vfio.h
> > > > > @@ -18,6 +18,7 @@ struct vfio_container;
> > > > >
> > > > >  struct vfio_device_file {
> > > > >  	struct vfio_device *device;
> > > > > +	bool access_granted;  
> > > >
> > > > Should we make this a more strongly defined data type and later move
> > > > devid (u32) here to partially fill the hole created?  
> > >
> > > Before your question, let me describe how I place the fields
> > > of this structure to see if it is common practice. The first two
> > > fields are static, so they are in the beginning. The access_granted
> > > is lockless and other fields are protected by locks. So I tried to
> > > put the lock and the fields it protects closely. So this is why I put
> > > devid behind iommufd as both are protected by the same lock.  
> > 
> > I think the primary considerations are locality and compactness.  Hot
> > paths data should be within the first cache line of the structure,
> > related data should share a cache line, and we should use the space
> > efficiently.  What you describe seems largely an aesthetic concern,
> > which was not evident to me by the segmentation alone.  
> 
> Sure.
> 
> >   
> > > struct vfio_device_file {
> > >         struct vfio_device *device;
> > >         struct vfio_group *group;
> > >
> > >         bool access_granted;
> > >         spinlock_t kvm_ref_lock; /* protect kvm field */
> > >         struct kvm *kvm;
> > >         struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
> > >         u32 devid; /* only valid when iommufd is valid */
> > > };
> > >  
> > > >
> > > > I think this is being placed towards the front of the data structure
> > > > for cache line locality given this is a hot path for file operations.
> > > > But bool types have an implementation dependent size, making them
> > > > difficult to pack.  Also there will be a tendency to want to make this
> > > > a bit field, which is probably not compatible with the smp lockless
> > > > operations being used here.  We might get in front of these issues if
> > > > we just define it as a u8 now.  Thanks,  
> > >
> > > Not quite get why bit field is going to be incompatible with smp
> > > lockless operations. Could you elaborate a bit? And should I define
> > > the access_granted as u8 or "u8:1"?  
> > 
> > Perhaps FUD on my part, but load-acquire type operations have specific
> > semantics and it's not clear to me that they interest with compiler
> > generated bit operations.  Thanks,  
> 
> I see. How about below? 
> 
> struct vfio_device_file {
>         struct vfio_device *device;
>         struct vfio_group *group;
>         u8 access_granted;
>         u32 devid; /* only valid when iommufd is valid */
>         spinlock_t kvm_ref_lock; /* protect kvm field */
>         struct kvm *kvm;
>         struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
> };

Yep, that's essentially what I was suggesting.  Thanks,

Alex

