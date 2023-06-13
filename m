Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4491C72E582
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbjFMORw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238753AbjFMORu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:17:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E8FA7
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686665820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NYatJhHx6nSYO+TZbVqZK7LDirziHUeBGTIfum2S5Mk=;
        b=SUOQF0USsc/6k/H9kyeTt/RuMPlNmxcMOqaq2oUruKSS5GfbTG5W+Kx7N0Q9PalFpruuja
        NQ2j9dftmaY7mJmVrJAzKeAHeOt25aKNxdlPbuj3yOrtP25aA73hVF0VgT0cwhSeHzZAPd
        Fi2ZW+8SHUMQU75oMMk6D3O50D0DJLo=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-ldPniwFxPYGR5P9CPFzPTA-1; Tue, 13 Jun 2023 10:16:58 -0400
X-MC-Unique: ldPniwFxPYGR5P9CPFzPTA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-33bdb682a1fso49707195ab.0
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:16:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686665810; x=1689257810;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NYatJhHx6nSYO+TZbVqZK7LDirziHUeBGTIfum2S5Mk=;
        b=O26w3yTxdyYTLKDD3psk8N64b+nl8FSrk3blCjh+UxD68w0p3UFoDjhXFTbvzm98oS
         /rV2l1fNxe50XkfUQEDOkb1kKO4J7IBSm5sSyfQaOkfmzdae+SjQ0fICJ0qtAmGfXAhP
         xvFSQ3nwwIS644muVDnt0tK/d0K8H4ARjw4NloIsT7bjA1Ak53F+Rw1DDoVcLZDyet+I
         XW1YflGfMyQBJgquc3vSQ+cCaLPiqVTqQPZ4XiCLsLj1GAB1ArksuotIFlbpOB9MwQiw
         pVrBLgJOMMBhhSrFQbMGRb0v+LL8iVLZI0McknvG1+0QDcAZxm57r7nq3jzFS3Evjeys
         QgEA==
X-Gm-Message-State: AC+VfDyWJ4TED6kBQmqoSA0W2afUuhpb6v8kJVZ40/pEy/0+KDLL5A0Y
        F/JlZOZ59nmpHyfZ4KWd3o4NzUXvrCqptzqDA/qFGQzsZMMdeis5ZBd7C4JrxqwLaqks5hToqxW
        OYQuJxqkS5Y3o9vHtL+mS
X-Received: by 2002:a92:d409:0:b0:338:a648:9c8 with SMTP id q9-20020a92d409000000b00338a64809c8mr9928835ilm.17.1686665809812;
        Tue, 13 Jun 2023 07:16:49 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4dvOnTcWtOwv+q2/EoekGwnRzAO73yzLn1NP0J05Lkv0h5eXb2N1tj6bmPqmEs9rHHcJOL2Q==
X-Received: by 2002:a92:d409:0:b0:338:a648:9c8 with SMTP id q9-20020a92d409000000b00338a64809c8mr9928794ilm.17.1686665809492;
        Tue, 13 Jun 2023 07:16:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g5-20020a92d7c5000000b003383276d260sm3827903ilq.40.2023.06.13.07.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 07:16:48 -0700 (PDT)
Date:   Tue, 13 Jun 2023 08:16:47 -0600
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
Message-ID: <20230613081647.740f5217.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB75293327BDE6D268996FFFCCC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-8-yi.l.liu@intel.com>
        <20230612155210.5fd3579f.alex.williamson@redhat.com>
        <DS0PR11MB75293327BDE6D268996FFFCCC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
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

On Tue, 13 Jun 2023 05:46:32 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, June 13, 2023 5:52 AM
> > 
> > On Fri,  2 Jun 2023 05:16:36 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >   
> > > Allow the vfio_device file to be in a state where the device FD is
> > > opened but the device cannot be used by userspace (i.e. its .open_device()
> > > hasn't been called). This inbetween state is not used when the device
> > > FD is spawned from the group FD, however when we create the device FD
> > > directly by opening a cdev it will be opened in the blocked state.
> > >
> > > The reason for the inbetween state is that userspace only gets a FD but
> > > doesn't gain access permission until binding the FD to an iommufd. So in
> > > the blocked state, only the bind operation is allowed. Completing bind
> > > will allow user to further access the device.
> > >
> > > This is implemented by adding a flag in struct vfio_device_file to mark
> > > the blocked state and using a simple smp_load_acquire() to obtain the
> > > flag value and serialize all the device setup with the thread accessing
> > > this device.
> > >
> > > Following this lockless scheme, it can safely handle the device FD
> > > unbound->bound but it cannot handle bound->unbound. To allow this we'd
> > > need to add a lock on all the vfio ioctls which seems costly. So once
> > > device FD is bound, it remains bound until the FD is closed.
> > >
> > > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/vfio/group.c     | 11 ++++++++++-
> > >  drivers/vfio/vfio.h      |  1 +
> > >  drivers/vfio/vfio_main.c | 16 ++++++++++++++++
> > >  3 files changed, 27 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > > index caf53716ddb2..088dd34c8931 100644
> > > --- a/drivers/vfio/group.c
> > > +++ b/drivers/vfio/group.c
> > > @@ -194,9 +194,18 @@ static int vfio_df_group_open(struct vfio_device_file *df)
> > >  	df->iommufd = device->group->iommufd;
> > >
> > >  	ret = vfio_df_open(df);
> > > -	if (ret)
> > > +	if (ret) {
> > >  		df->iommufd = NULL;
> > > +		goto out_put_kvm;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> > > +	 * read/write/mmap and vfio_file_has_device_access()
> > > +	 */
> > > +	smp_store_release(&df->access_granted, true);
> > >
> > > +out_put_kvm:
> > >  	if (device->open_count == 0)
> > >  		vfio_device_put_kvm(device);
> > >
> > > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > > index f9eb52eb9ed7..fdf2fc73f880 100644
> > > --- a/drivers/vfio/vfio.h
> > > +++ b/drivers/vfio/vfio.h
> > > @@ -18,6 +18,7 @@ struct vfio_container;
> > >
> > >  struct vfio_device_file {
> > >  	struct vfio_device *device;
> > > +	bool access_granted;  
> > 
> > Should we make this a more strongly defined data type and later move
> > devid (u32) here to partially fill the hole created?  
> 
> Before your question, let me describe how I place the fields
> of this structure to see if it is common practice. The first two
> fields are static, so they are in the beginning. The access_granted
> is lockless and other fields are protected by locks. So I tried to
> put the lock and the fields it protects closely. So this is why I put
> devid behind iommufd as both are protected by the same lock.

I think the primary considerations are locality and compactness.  Hot
paths data should be within the first cache line of the structure,
related data should share a cache line, and we should use the space
efficiently.  What you describe seems largely an aesthetic concern,
which was not evident to me by the segmentation alone.
 
> struct vfio_device_file {
>         struct vfio_device *device;
>         struct vfio_group *group;
> 
>         bool access_granted;
>         spinlock_t kvm_ref_lock; /* protect kvm field */
>         struct kvm *kvm;
>         struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
>         u32 devid; /* only valid when iommufd is valid */
> };
> 
> > 
> > I think this is being placed towards the front of the data structure
> > for cache line locality given this is a hot path for file operations.
> > But bool types have an implementation dependent size, making them
> > difficult to pack.  Also there will be a tendency to want to make this
> > a bit field, which is probably not compatible with the smp lockless
> > operations being used here.  We might get in front of these issues if
> > we just define it as a u8 now.  Thanks,  
> 
> Not quite get why bit field is going to be incompatible with smp
> lockless operations. Could you elaborate a bit? And should I define
> the access_granted as u8 or "u8:1"?

Perhaps FUD on my part, but load-acquire type operations have specific
semantics and it's not clear to me that they interest with compiler
generated bit operations.  Thanks,

Alex

> > >  	spinlock_t kvm_ref_lock; /* protect kvm field */
> > >  	struct kvm *kvm;
> > >  	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
> > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > index a3c5817fc545..4c8b7713dc3d 100644
> > > --- a/drivers/vfio/vfio_main.c
> > > +++ b/drivers/vfio/vfio_main.c
> > > @@ -1129,6 +1129,10 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
> > >  	struct vfio_device *device = df->device;
> > >  	int ret;
> > >
> > > +	/* Paired with smp_store_release() following vfio_df_open() */
> > > +	if (!smp_load_acquire(&df->access_granted))
> > > +		return -EINVAL;
> > > +
> > >  	ret = vfio_device_pm_runtime_get(device);
> > >  	if (ret)
> > >  		return ret;
> > > @@ -1156,6 +1160,10 @@ static ssize_t vfio_device_fops_read(struct file *filep, char  
> > __user *buf,  
> > >  	struct vfio_device_file *df = filep->private_data;
> > >  	struct vfio_device *device = df->device;
> > >
> > > +	/* Paired with smp_store_release() following vfio_df_open() */
> > > +	if (!smp_load_acquire(&df->access_granted))
> > > +		return -EINVAL;
> > > +
> > >  	if (unlikely(!device->ops->read))
> > >  		return -EINVAL;
> > >
> > > @@ -1169,6 +1177,10 @@ static ssize_t vfio_device_fops_write(struct file *filep,
> > >  	struct vfio_device_file *df = filep->private_data;
> > >  	struct vfio_device *device = df->device;
> > >
> > > +	/* Paired with smp_store_release() following vfio_df_open() */
> > > +	if (!smp_load_acquire(&df->access_granted))
> > > +		return -EINVAL;
> > > +
> > >  	if (unlikely(!device->ops->write))
> > >  		return -EINVAL;
> > >
> > > @@ -1180,6 +1192,10 @@ static int vfio_device_fops_mmap(struct file *filep, struct  
> > vm_area_struct *vma)  
> > >  	struct vfio_device_file *df = filep->private_data;
> > >  	struct vfio_device *device = df->device;
> > >
> > > +	/* Paired with smp_store_release() following vfio_df_open() */
> > > +	if (!smp_load_acquire(&df->access_granted))
> > > +		return -EINVAL;
> > > +
> > >  	if (unlikely(!device->ops->mmap))
> > >  		return -EINVAL;
> > >  
> 

