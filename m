Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3468968AA8F
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 15:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbjBDO0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 09:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBDO0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 09:26:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B139C2B2A9
        for <kvm@vger.kernel.org>; Sat,  4 Feb 2023 06:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675520722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BPb3zmrBo8hI1QaL+QoDXfm9YTI2O8rGNvKyRtuVNJ4=;
        b=fPUSP3ywU3YvUqzKprM7+r/+9M3e3EJNV/PJPL57Ohoz5l2WRJ39i3OxSIvaF/DAi2WxA5
        UlMHuYTKWs5f1LpLRm5quCNa3mKFPmPqexwBcymrdYCwrZkUYoWmFp+Qzu2XXNALSdNr5t
        Mq2D4RDop/SThk4fOhQdMv0+voc0FCE=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-500-MFTHDaqOOguZHwyUS3ZwIg-1; Sat, 04 Feb 2023 09:25:22 -0500
X-MC-Unique: MFTHDaqOOguZHwyUS3ZwIg-1
Received: by mail-io1-f69.google.com with SMTP id d24-20020a5d9bd8000000b006ee2ddf6d77so4636294ion.6
        for <kvm@vger.kernel.org>; Sat, 04 Feb 2023 06:25:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BPb3zmrBo8hI1QaL+QoDXfm9YTI2O8rGNvKyRtuVNJ4=;
        b=TZOrkfrTGAdKNrJjC+acTE3H39W/V9Bjs5lxB6+TLFTXNIQsMD4uaI0WSXfpj6xIcQ
         4ln/m0Vsdl7mAUCshEWP8vUMtb2w6JcSoah3pdaUK1Pdrn7u7r5XYWo9dkDvx2qUBTjY
         u8kFBmfQUwumw7ycXzaLV/Pn8dOAS2Tv5n/cFauc4dshncHLV9zUBxE6ax4NLWLQVG+a
         kuSI5njSBxR/LcgiYkWegNyZmznKu4jGMXRQv4SJh61HEHF/3LU6Q9VshmEjTFBE99rS
         sPvYYo24QKvdrzelb68OUz1YgnyzRAJUMGhUyT5qihHByKcxw+FcNQS00PINXj3xvwHo
         KTaw==
X-Gm-Message-State: AO0yUKW4UCJ9bbMEhIM/+bwulGGRoktqEwcxXMF5llsQyc8JBzeaPFCB
        2AMO5tEA8jIKI34DXv/9PU3x2y+e6Zyz2uqgltZ/hFb5rkLkXXb8Ry025hABMcui6eL9iEhrTLV
        jNXKVKi1kw+hq
X-Received: by 2002:a5d:8e0c:0:b0:729:63de:4546 with SMTP id e12-20020a5d8e0c000000b0072963de4546mr4655328iod.3.1675520721121;
        Sat, 04 Feb 2023 06:25:21 -0800 (PST)
X-Google-Smtp-Source: AK7set8hCr+StI5YhRk/qZS/3KcSos6ZFduXHTX04WfBJmgHPj/mpHyfvyuLXevwkRlA04qUDb9YPw==
X-Received: by 2002:a5d:8e0c:0:b0:729:63de:4546 with SMTP id e12-20020a5d8e0c000000b0072963de4546mr4655303iod.3.1675520720796;
        Sat, 04 Feb 2023 06:25:20 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u13-20020a02aa8d000000b003a9595b7e3asm1806920jai.46.2023.02.04.06.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 06:25:19 -0800 (PST)
Date:   Sat, 4 Feb 2023 07:25:18 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] vfio: fix deadlock between group lock and kvm
 lock
Message-ID: <20230204072518.537ab50b.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529CE3027A713D6F2EE7F68C3D49@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230203215027.151988-1-mjrosato@linux.ibm.com>
        <20230203215027.151988-2-mjrosato@linux.ibm.com>
        <DS0PR11MB7529CE3027A713D6F2EE7F68C3D49@DS0PR11MB7529.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 4 Feb 2023 06:21:48 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Matthew Rosato <mjrosato@linux.ibm.com>
> > Sent: Saturday, February 4, 2023 5:50 AM
> > To: alex.williamson@redhat.com; pbonzini@redhat.com; Liu, Yi L
> > 
> > After 51cdc8bc120e, we have another deadlock scenario between the
> > kvm->lock and the vfio group_lock with two different codepaths acquiring
> > the locks in different order.  Specifically in vfio_open_device, vfio
> > holds the vfio group_lock when issuing device->ops->open_device but
> > some
> > drivers (like vfio-ap) need to acquire kvm->lock during their open_device
> > routine;  Meanwhile, kvm_vfio_release will acquire the kvm->lock first
> > before calling vfio_file_set_kvm which will acquire the vfio group_lock.
> > 
> > To resolve this, let's remove the need for the vfio group_lock from the
> > kvm_vfio_release codepath.  This is done by introducing a new spinlock to
> > protect modifications to the vfio group kvm pointer, and acquiring a kvm
> > ref from within vfio while holding this spinlock, with the reference held
> > until the last close for the device in question.
> > 
> > Fixes: 51cdc8bc120e ("kvm/vfio: Fix potential deadlock on vfio group_lock")
> > Reported-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > ---
> >  drivers/vfio/group.c     | 44 +++++++++++++++++++++++-----
> >  drivers/vfio/vfio.h      | 15 ++++++++++
> >  drivers/vfio/vfio_main.c | 63
> > +++++++++++++++++++++++++++++++++++-----
> >  include/linux/vfio.h     |  2 +-
> >  4 files changed, 109 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index bb24b2f0271e..98621ac082f0 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -154,6 +154,18 @@ static int vfio_group_ioctl_set_container(struct
> > vfio_group *group,
> >  	return ret;
> >  }
> > 
> > +static void vfio_device_group_get_kvm_safe(struct vfio_device *device)
> > +{
> > +	spin_lock(&device->group->kvm_ref_lock);
> > +	if (!device->group->kvm)
> > +		goto unlock;
> > +
> > +	_vfio_device_get_kvm_safe(device, device->group->kvm);
> > +
> > +unlock:
> > +	spin_unlock(&device->group->kvm_ref_lock);
> > +}
> > +
> >  static int vfio_device_group_open(struct vfio_device *device)
> >  {
> >  	int ret;
> > @@ -164,13 +176,23 @@ static int vfio_device_group_open(struct
> > vfio_device *device)
> >  		goto out_unlock;
> >  	}
> > 
> > +	mutex_lock(&device->dev_set->lock);
> > +
> >  	/*
> > -	 * Here we pass the KVM pointer with the group under the lock.  If
> > the
> > -	 * device driver will use it, it must obtain a reference and release it
> > -	 * during close_device.
> > +	 * Before the first device open, get the KVM pointer currently
> > +	 * associated with the group (if there is one) and obtain a reference
> > +	 * now that will be held until the open_count reaches 0 again.  Save  
> 
> Nit: a redundant space before "Save". Other part looks good to me.

Two spaces between sentences is a common standard.  Not everyone
prefers this, but I do.  Thanks,

Alex

> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
> 
> Regards,
> Yi Liu
> 
> > +	 * the pointer in the device for use by drivers.
> >  	 */
> > -	ret = vfio_device_open(device, device->group->iommufd,
> > -			       device->group->kvm);
> > +	if (device->open_count == 0)
> > +		vfio_device_group_get_kvm_safe(device);
> > +
> > +	ret = vfio_device_open(device, device->group->iommufd, device->kvm);
> > +
> > +	if (device->open_count == 0)
> > +		vfio_device_put_kvm(device);
> > +
> > +	mutex_unlock(&device->dev_set->lock);
> > 
> >  out_unlock:
> >  	mutex_unlock(&device->group->group_lock);
> > @@ -180,7 +202,14 @@ static int vfio_device_group_open(struct
> > vfio_device *device)
> >  void vfio_device_group_close(struct vfio_device *device)
> >  {
> >  	mutex_lock(&device->group->group_lock);
> > +	mutex_lock(&device->dev_set->lock);
> > +
> >  	vfio_device_close(device, device->group->iommufd);
> > +
> > +	if (device->open_count == 0)
> > +		vfio_device_put_kvm(device);
> > +
> > +	mutex_unlock(&device->dev_set->lock);
> >  	mutex_unlock(&device->group->group_lock);
> >  }
> > 
> > @@ -450,6 +479,7 @@ static struct vfio_group *vfio_group_alloc(struct
> > iommu_group *iommu_group,
> > 
> >  	refcount_set(&group->drivers, 1);
> >  	mutex_init(&group->group_lock);
> > +	spin_lock_init(&group->kvm_ref_lock);
> >  	INIT_LIST_HEAD(&group->device_list);
> >  	mutex_init(&group->device_lock);
> >  	group->iommu_group = iommu_group;
> > @@ -803,9 +833,9 @@ void vfio_file_set_kvm(struct file *file, struct kvm
> > *kvm)
> >  	if (!vfio_file_is_group(file))
> >  		return;
> > 
> > -	mutex_lock(&group->group_lock);
> > +	spin_lock(&group->kvm_ref_lock);
> >  	group->kvm = kvm;
> > -	mutex_unlock(&group->group_lock);
> > +	spin_unlock(&group->kvm_ref_lock);
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
> > 
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index f8219a438bfb..24d6cd285945 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -74,6 +74,7 @@ struct vfio_group {
> >  	struct file			*opened_file;
> >  	struct blocking_notifier_head	notifier;
> >  	struct iommufd_ctx		*iommufd;
> > +	spinlock_t			kvm_ref_lock;
> >  };
> > 
> >  int vfio_device_set_group(struct vfio_device *device,
> > @@ -251,4 +252,18 @@ extern bool vfio_noiommu __read_mostly;
> >  enum { vfio_noiommu = false };
> >  #endif
> > 
> > +#ifdef CONFIG_HAVE_KVM
> > +void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm
> > *kvm);
> > +void vfio_device_put_kvm(struct vfio_device *device);
> > +#else
> > +static inline void _vfio_device_get_kvm_safe(struct vfio_device *device,
> > +					     struct kvm *kvm)
> > +{
> > +}
> > +
> > +static inline void vfio_device_put_kvm(struct vfio_device *device)
> > +{
> > +}
> > +#endif
> > +
> >  #endif
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index 5177bb061b17..28c47cd6a6b5 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -16,6 +16,9 @@
> >  #include <linux/fs.h>
> >  #include <linux/idr.h>
> >  #include <linux/iommu.h>
> > +#ifdef CONFIG_HAVE_KVM
> > +#include <linux/kvm_host.h>
> > +#endif
> >  #include <linux/list.h>
> >  #include <linux/miscdevice.h>
> >  #include <linux/module.h>
> > @@ -338,6 +341,55 @@ void vfio_unregister_group_dev(struct vfio_device
> > *device)
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
> > 
> > +#ifdef CONFIG_HAVE_KVM
> > +void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm
> > *kvm)
> > +{
> > +	void (*pfn)(struct kvm *kvm);
> > +	bool (*fn)(struct kvm *kvm);
> > +	bool ret;
> > +
> > +	lockdep_assert_held(&device->dev_set->lock);
> > +
> > +	pfn = symbol_get(kvm_put_kvm);
> > +	if (WARN_ON(!pfn))
> > +		return;
> > +
> > +	fn = symbol_get(kvm_get_kvm_safe);
> > +	if (WARN_ON(!fn)) {
> > +		symbol_put(kvm_put_kvm);
> > +		return;
> > +	}
> > +
> > +	ret = fn(kvm);
> > +	symbol_put(kvm_get_kvm_safe);
> > +	if (!ret) {
> > +		symbol_put(kvm_put_kvm);
> > +		return;
> > +	}
> > +
> > +	device->put_kvm = pfn;
> > +	device->kvm = kvm;
> > +}
> > +
> > +void vfio_device_put_kvm(struct vfio_device *device)
> > +{
> > +	lockdep_assert_held(&device->dev_set->lock);
> > +
> > +	if (!device->kvm)
> > +		return;
> > +
> > +	if (WARN_ON(!device->put_kvm))
> > +		goto clear;
> > +
> > +	device->put_kvm(device->kvm);
> > +	device->put_kvm = NULL;
> > +	symbol_put(kvm_put_kvm);
> > +
> > +clear:
> > +	device->kvm = NULL;
> > +}
> > +#endif
> > +
> >  /* true if the vfio_device has open_device() called but not close_device()
> > */
> >  static bool vfio_assert_device_open(struct vfio_device *device)
> >  {
> > @@ -361,7 +413,6 @@ static int vfio_device_first_open(struct vfio_device
> > *device,
> >  	if (ret)
> >  		goto err_module_put;
> > 
> > -	device->kvm = kvm;
> >  	if (device->ops->open_device) {
> >  		ret = device->ops->open_device(device);
> >  		if (ret)
> > @@ -370,7 +421,6 @@ static int vfio_device_first_open(struct vfio_device
> > *device,
> >  	return 0;
> > 
> >  err_unuse_iommu:
> > -	device->kvm = NULL;
> >  	if (iommufd)
> >  		vfio_iommufd_unbind(device);
> >  	else
> > @@ -387,7 +437,6 @@ static void vfio_device_last_close(struct vfio_device
> > *device,
> > 
> >  	if (device->ops->close_device)
> >  		device->ops->close_device(device);
> > -	device->kvm = NULL;
> >  	if (iommufd)
> >  		vfio_iommufd_unbind(device);
> >  	else
> > @@ -400,14 +449,14 @@ int vfio_device_open(struct vfio_device *device,
> >  {
> >  	int ret = 0;
> > 
> > -	mutex_lock(&device->dev_set->lock);
> > +	lockdep_assert_held(&device->dev_set->lock);
> > +
> >  	device->open_count++;
> >  	if (device->open_count == 1) {
> >  		ret = vfio_device_first_open(device, iommufd, kvm);
> >  		if (ret)
> >  			device->open_count--;
> >  	}
> > -	mutex_unlock(&device->dev_set->lock);
> > 
> >  	return ret;
> >  }
> > @@ -415,12 +464,12 @@ int vfio_device_open(struct vfio_device *device,
> >  void vfio_device_close(struct vfio_device *device,
> >  		       struct iommufd_ctx *iommufd)
> >  {
> > -	mutex_lock(&device->dev_set->lock);
> > +	lockdep_assert_held(&device->dev_set->lock);
> > +
> >  	vfio_assert_device_open(device);
> >  	if (device->open_count == 1)
> >  		vfio_device_last_close(device, iommufd);
> >  	device->open_count--;
> > -	mutex_unlock(&device->dev_set->lock);
> >  }
> > 
> >  /*
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 35be78e9ae57..87ff862ff555 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -46,7 +46,6 @@ struct vfio_device {
> >  	struct vfio_device_set *dev_set;
> >  	struct list_head dev_set_list;
> >  	unsigned int migration_flags;
> > -	/* Driver must reference the kvm during open_device or never
> > touch it */
> >  	struct kvm *kvm;
> > 
> >  	/* Members below here are private, not for driver use */
> > @@ -58,6 +57,7 @@ struct vfio_device {
> >  	struct list_head group_next;
> >  	struct list_head iommu_entry;
> >  	struct iommufd_access *iommufd_access;
> > +	void (*put_kvm)(struct kvm *kvm);
> >  #if IS_ENABLED(CONFIG_IOMMUFD)
> >  	struct iommufd_device *iommufd_device;
> >  	struct iommufd_ctx *iommufd_ictx;
> > --
> > 2.39.1  
> 

