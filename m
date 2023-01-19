Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A4D67438D
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjASUhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjASUgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:36:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83A19D281
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674160566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dc8KVPG4TsqLwi0e6877Q3b2ZPeteLOyGkdz48SboNA=;
        b=axOdZBVkrIN0he9MvhKhADpF6iZNkpZ2emaorBxUH39MalOEte5qZTj9dYNURKm7/k8oUG
        mASIAWawTTc6t25MLs5AqqdokfQFnqdUpMvrSgcTWqO30QVYF40O8fBskYnDz+UQ2THITG
        VvTo7WHxXrSGG4J0AnqMNa9eqm69hjE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-381-lMP_yOrZMVyPGbgYv-RrQQ-1; Thu, 19 Jan 2023 15:35:57 -0500
X-MC-Unique: lMP_yOrZMVyPGbgYv-RrQQ-1
Received: by mail-io1-f72.google.com with SMTP id b26-20020a056602331a00b00704cb50e151so1762767ioz.13
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:35:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dc8KVPG4TsqLwi0e6877Q3b2ZPeteLOyGkdz48SboNA=;
        b=JW4FW2EhzQa8eCG5v9XI/DouW7igi9jc3XseCLSMr1lEzHd2dYpfVZ20Mug6tHhTTj
         fSl5Ldjs8REJAkexHEj7x9eMR0I1AUumeUv2+uCeDPUx7Sfz4NdZmRQa4sXNoRJE2UeE
         m0b9pEOSW+1XuRmnhvXLc7msXXRMsyuyxwTfHwVulBJOJ0yhVnFvYQxEGplKKtuxDELi
         JDXhcj9kh31Aa8cI4lgKDVNOWqMSQ17+pajWAdoyG6uGmwWclaOS26/xp4bZDYSUoBbf
         IZIJrwB63F2somhFSE98Sxtb1BrYWRllOVLsG17rD/ANSRF6xoRO+878/AWhzdxiszIw
         0z7w==
X-Gm-Message-State: AFqh2kokzbMD3fWwEhvw+vQHfibIwav48TZ88t1HEG9woQNXk71nzbGL
        IVhhj9L8145c5oy1IhaTqNVFY3RdeE8RmtMqqHth9j3rP1qGrk/BnFW2iVeEPwPD2uI0esD/wmG
        zU5uGcqcT8YtS
X-Received: by 2002:a05:6e02:1aa9:b0:30b:e72e:adb5 with SMTP id l9-20020a056e021aa900b0030be72eadb5mr11287167ilv.30.1674160555892;
        Thu, 19 Jan 2023 12:35:55 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu76ZrNVeIwowYpvXFriXj73Kb4vqaDn18fCw2Al9DUXGalLEthvB4zML8xdpwTQZwPpK6FBA==
X-Received: by 2002:a05:6e02:1aa9:b0:30b:e72e:adb5 with SMTP id l9-20020a056e021aa900b0030be72eadb5mr11287154ilv.30.1674160555587;
        Thu, 19 Jan 2023 12:35:55 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v3-20020a92cd43000000b0030ee2355fc8sm415219ilq.45.2023.01.19.12.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 12:35:55 -0800 (PST)
Date:   Thu, 19 Jan 2023 13:35:54 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, jgg@nvidia.com, kevin.tian@intel.com,
        cohuck@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: Re: [PATCH 07/13] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Message-ID: <20230119133554.26691320.alex.williamson@redhat.com>
In-Reply-To: <537e68ee-6dab-97e0-4797-1ca5cec4c710@redhat.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
        <20230117134942.101112-8-yi.l.liu@intel.com>
        <537e68ee-6dab-97e0-4797-1ca5cec4c710@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Thu, 19 Jan 2023 12:01:59 +0100
Eric Auger <eric.auger@redhat.com> wrote:

> Hi Yi,
> 
> On 1/17/23 14:49, Yi Liu wrote:
> > This avoids passing struct kvm * and struct iommufd_ctx * in multiple
> > functions. vfio_device_open() becomes to be a locked helper.  
> why? because dev_set lock now protects vfio_device_file fields? worth to
> explain.
> do we need to update the comment in vfio.h related to struct
> vfio_device_set?
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/group.c     | 34 +++++++++++++++++++++++++---------
> >  drivers/vfio/vfio.h      | 10 +++++-----
> >  drivers/vfio/vfio_main.c | 40 ++++++++++++++++++++++++----------------
> >  3 files changed, 54 insertions(+), 30 deletions(-)
> >
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index d83cf069d290..7200304663e5 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -154,33 +154,49 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
> >  	return ret;
> >  }
> >  
> > -static int vfio_device_group_open(struct vfio_device *device)
> > +static int vfio_device_group_open(struct vfio_device_file *df)
> >  {
> > +	struct vfio_device *device = df->device;
> >  	int ret;
> >  
> >  	mutex_lock(&device->group->group_lock);
> >  	if (!vfio_group_has_iommu(device->group)) {
> >  		ret = -EINVAL;
> > -		goto out_unlock;
> > +		goto err_unlock_group;
> >  	}
> >  
> > +	mutex_lock(&device->dev_set->lock);  
> is there an explanation somewhere about locking order b/w group_lock,
> dev_set lock?
> >  	/*
> >  	 * Here we pass the KVM pointer with the group under the lock.  If the
> >  	 * device driver will use it, it must obtain a reference and release it
> >  	 * during close_device.
> >  	 */  
> May be the opportunity to rephrase the above comment. I am not a native
> english speaker but the time concordance seems weird + clarify a
> reference to what.
> > -	ret = vfio_device_open(device, device->group->iommufd,
> > -			       device->group->kvm);
> > +	df->kvm = device->group->kvm;
> > +	df->iommufd = device->group->iommufd;
> > +
> > +	ret = vfio_device_open(df);
> > +	if (ret)
> > +		goto err_unlock_device;
> > +	mutex_unlock(&device->dev_set->lock);
> >  
> > -out_unlock:
> > +	mutex_unlock(&device->group->group_lock);
> > +	return 0;
> > +
> > +err_unlock_device:
> > +	df->kvm = NULL;
> > +	df->iommufd = NULL;
> > +	mutex_unlock(&device->dev_set->lock);
> > +err_unlock_group:
> >  	mutex_unlock(&device->group->group_lock);
> >  	return ret;
> >  }
> >  
> > -void vfio_device_group_close(struct vfio_device *device)
> > +void vfio_device_group_close(struct vfio_device_file *df)
> >  {
> > +	struct vfio_device *device = df->device;
> > +
> >  	mutex_lock(&device->group->group_lock);
> > -	vfio_device_close(device, device->group->iommufd);
> > +	vfio_device_close(df);
> >  	mutex_unlock(&device->group->group_lock);
> >  }
> >  
> > @@ -196,7 +212,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
> >  		goto err_out;
> >  	}
> >  
> > -	ret = vfio_device_group_open(device);
> > +	ret = vfio_device_group_open(df);
> >  	if (ret)
> >  		goto err_free;
> >  
> > @@ -228,7 +244,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
> >  	return filep;
> >  
> >  err_close_device:
> > -	vfio_device_group_close(device);
> > +	vfio_device_group_close(df);
> >  err_free:
> >  	kfree(df);
> >  err_out:
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 53af6e3ea214..3d8ba165146c 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -19,14 +19,14 @@ struct vfio_container;
> >  struct vfio_device_file {
> >  	struct vfio_device *device;
> >  	struct kvm *kvm;
> > +	struct iommufd_ctx *iommufd;
> >  };
> >  
> >  void vfio_device_put_registration(struct vfio_device *device);
> >  bool vfio_device_try_get_registration(struct vfio_device *device);
> > -int vfio_device_open(struct vfio_device *device,
> > -		     struct iommufd_ctx *iommufd, struct kvm *kvm);
> > -void vfio_device_close(struct vfio_device *device,
> > -		       struct iommufd_ctx *iommufd);
> > +int vfio_device_open(struct vfio_device_file *df);
> > +void vfio_device_close(struct vfio_device_file *device);
> > +
> >  struct vfio_device_file *
> >  vfio_allocate_device_file(struct vfio_device *device);
> >  
> > @@ -90,7 +90,7 @@ void vfio_device_group_register(struct vfio_device *device);
> >  void vfio_device_group_unregister(struct vfio_device *device);
> >  int vfio_device_group_use_iommu(struct vfio_device *device);
> >  void vfio_device_group_unuse_iommu(struct vfio_device *device);
> > -void vfio_device_group_close(struct vfio_device *device);
> > +void vfio_device_group_close(struct vfio_device_file *df);
> >  struct vfio_group *vfio_group_from_file(struct file *file);
> >  bool vfio_group_enforced_coherent(struct vfio_group *group);
> >  void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index dc08d5dd62cc..3df71bd9cd1e 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -358,9 +358,11 @@ vfio_allocate_device_file(struct vfio_device *device)
> >  	return df;
> >  }
> >  
> > -static int vfio_device_first_open(struct vfio_device *device,
> > -				  struct iommufd_ctx *iommufd, struct kvm *kvm)
> > +static int vfio_device_first_open(struct vfio_device_file *df)
> >  {
> > +	struct vfio_device *device = df->device;
> > +	struct iommufd_ctx *iommufd = df->iommufd;
> > +	struct kvm *kvm = df->kvm;
> >  	int ret;
> >  
> >  	lockdep_assert_held(&device->dev_set->lock);
> > @@ -394,9 +396,11 @@ static int vfio_device_first_open(struct vfio_device *device,
> >  	return ret;
> >  }
> >  
> > -static void vfio_device_last_close(struct vfio_device *device,
> > -				   struct iommufd_ctx *iommufd)
> > +static void vfio_device_last_close(struct vfio_device_file *df)
> >  {
> > +	struct vfio_device *device = df->device;
> > +	struct iommufd_ctx *iommufd = df->iommufd;
> > +
> >  	lockdep_assert_held(&device->dev_set->lock);
> >  
> >  	if (device->ops->close_device)
> > @@ -409,30 +413,34 @@ static void vfio_device_last_close(struct vfio_device *device,
> >  	module_put(device->dev->driver->owner);
> >  }
> >  
> > -int vfio_device_open(struct vfio_device *device,
> > -		     struct iommufd_ctx *iommufd, struct kvm *kvm)
> > +int vfio_device_open(struct vfio_device_file *df)
> >  {
> > -	int ret = 0;
> > +	struct vfio_device *device = df->device;
> > +
> > +	lockdep_assert_held(&device->dev_set->lock);
> >  
> > -	mutex_lock(&device->dev_set->lock);
> >  	device->open_count++;
> >  	if (device->open_count == 1) {
> > -		ret = vfio_device_first_open(device, iommufd, kvm);
> > -		if (ret)
> > +		int ret;
> > +
> > +		ret = vfio_device_first_open(df);
> > +		if (ret) {
> >  			device->open_count--;
> > +			return ret;  
> nit: the original ret init and return was good enough, no need to change it?
> > +		}
> >  	}
> > -	mutex_unlock(&device->dev_set->lock);
> >  
> > -	return ret;
> > +	return 0;
> >  }
> >  
> > -void vfio_device_close(struct vfio_device *device,
> > -		       struct iommufd_ctx *iommufd)
> > +void vfio_device_close(struct vfio_device_file *df)
> >  {
> > +	struct vfio_device *device = df->device;
> > +
> >  	mutex_lock(&device->dev_set->lock);
> >  	vfio_assert_device_open(device);
> >  	if (device->open_count == 1)
> > -		vfio_device_last_close(device, iommufd);
> > +		vfio_device_last_close(df);
> >  	device->open_count--;
> >  	mutex_unlock(&device->dev_set->lock);
> >  }

I find it strange that the dev_set->lock has been moved to the caller
for open, but not for close.  Like Eric suggests, this seems to be
because vfio_device_file is usurping dev_set->lock to protect its own
fields, but then those fields are set on open, cleared on the open
error path, but not on close??  Thanks,

Alex

