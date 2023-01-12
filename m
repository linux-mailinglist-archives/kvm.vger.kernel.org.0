Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A1766854B
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 22:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240785AbjALV0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 16:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbjALV0O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 16:26:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31E682F59
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 13:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673557521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h6f/xkDFcthJcSJTvgCInVgMfaXKqM0yPFFK06gOaJY=;
        b=PycuaJQbxERzObE4747hpGlSSt/IhF3CIX2INuu5ZT5AsCEYJhwR8egmVsnpAqdYBChtj3
        TVYaTbI6F1/qZRkBbq28YKdvDHPVIVFH7jdYgN0bPP37A7iZ9i2nxfC664j+dQVNjUQfhT
        Fg2BYoNiIKtfCevRuthmmhz0Y4QCoDU=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-226-I2FJIH0_NTmGrwegLxnTAQ-1; Thu, 12 Jan 2023 16:05:20 -0500
X-MC-Unique: I2FJIH0_NTmGrwegLxnTAQ-1
Received: by mail-il1-f197.google.com with SMTP id l13-20020a056e021c0d00b003034e24b866so14593038ilh.22
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 13:05:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6f/xkDFcthJcSJTvgCInVgMfaXKqM0yPFFK06gOaJY=;
        b=LB5h33CcvHwTl4jTBjen7tuxMqWRz+l6hncJlWRDH16gA6bcVOmDJsTsY+SyyXmJBL
         zdMLuw+nhLjy6NXUXJpT4E3FPt2J3qKy93mFXpETPVheUit4/KLnZyY6b5CXeEqdKZZD
         dWGyJB0vygPeEIUVeMf4CXI0awoj2jtSCyDGmG9TM0Itw/3WWhuuh0myVuCQ7juzWmuD
         KVAN4Swo9fxmf7VLzmsG80cn8LN6kd/mHyVm7lPFuRriamefB+eiBWvg4jLkJy6eVXxc
         KyXEmeY8vF4q04QJFd8wgRHJb3ux/jGsSrSyLIcQP9PGbUFsGGjbmlpexD7OTCGOMl89
         qTbw==
X-Gm-Message-State: AFqh2kpe37v9chfRFv4Mio6QXzisPtwsxL/PdwOPcj1EpyT0g7mGQDIU
        LYWK7IgT+SwK/klQ+28JTFFORvt19vsz00h+mPSLrMdpz9hbBaeo9VKWdgPr2id/JRwQaBOoj/F
        +JZVOBrZetJl2
X-Received: by 2002:a05:6e02:1d88:b0:30d:7cf4:5d5c with SMTP id h8-20020a056e021d8800b0030d7cf45d5cmr31649886ila.31.1673557519898;
        Thu, 12 Jan 2023 13:05:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvrH5SQuIa+SM0JX2id5B1E3t2j9jN9JvjT6ILFvMMJfCCKm4aTtrr6JdMNkSQtGVDDL9mJbQ==
X-Received: by 2002:a05:6e02:1d88:b0:30d:7cf4:5d5c with SMTP id h8-20020a056e021d8800b0030d7cf45d5cmr31649859ila.31.1673557519587;
        Thu, 12 Jan 2023 13:05:19 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a17-20020a92d591000000b0030be6c79645sm5428334iln.68.2023.01.12.13.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 13:05:19 -0800 (PST)
Date:   Thu, 12 Jan 2023 14:05:17 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     pbonzini@redhat.com, jgg@nvidia.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, seanjc@google.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio: fix potential deadlock on vfio group lock
Message-ID: <20230112140517.6db5b346.alex.williamson@redhat.com>
In-Reply-To: <20230112203844.41179-1-mjrosato@linux.ibm.com>
References: <20230112203844.41179-1-mjrosato@linux.ibm.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 15:38:44 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Currently it is possible that the final put of a KVM reference comes from
> vfio during its device close operation.  This occurs while the vfio group
> lock is held; however, if the vfio device is still in the kvm device list,
> then the following call chain could result in a deadlock:
> 
> kvm_put_kvm
>  -> kvm_destroy_vm
>   -> kvm_destroy_devices
>    -> kvm_vfio_destroy
>     -> kvm_vfio_file_set_kvm
>      -> vfio_file_set_kvm
>       -> group->group_lock/group_rwsem  
> 
> Avoid this scenario by having vfio core code acquire a KVM reference
> the first time a device is opened and hold that reference until the
> device fd is closed, at a point after the group lock has been released.
> 
> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
> Changes from v1:
> * Re-write using symbol get logic to get kvm ref during first device
>   open, release the ref during device fd close after group lock is
>   released
> * Drop kvm get/put changes to drivers; now that vfio core holds a
>   kvm ref until sometime after the device_close op is called, it
>   should be fine for drivers to get and put their own references to it.
> ---
>  drivers/vfio/group.c     |  6 ++---
>  drivers/vfio/vfio_main.c | 48 +++++++++++++++++++++++++++++++++++++---
>  include/linux/vfio.h     |  1 -
>  3 files changed, 48 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index bb24b2f0271e..2b0da82f82f4 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -165,9 +165,9 @@ static int vfio_device_group_open(struct vfio_device *device)
>  	}
>  
>  	/*
> -	 * Here we pass the KVM pointer with the group under the lock.  If the
> -	 * device driver will use it, it must obtain a reference and release it
> -	 * during close_device.
> +	 * Here we pass the KVM pointer with the group under the lock.  A
> +	 * reference will be obtained the first time the device is opened and
> +	 * will be held until the device fd is closed.
>  	 */
>  	ret = vfio_device_open(device, device->group->iommufd,
>  			       device->group->kvm);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 5177bb061b17..c969e2a0ecd3 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -16,6 +16,7 @@
>  #include <linux/fs.h>
>  #include <linux/idr.h>
>  #include <linux/iommu.h>
> +#include <linux/kvm_host.h>
>  #include <linux/list.h>
>  #include <linux/miscdevice.h>
>  #include <linux/module.h>
> @@ -344,6 +345,35 @@ static bool vfio_assert_device_open(struct vfio_device *device)
>  	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
>  }
>  
> +static bool vfio_kvm_get_kvm_safe(struct kvm *kvm)
> +{
> +	bool (*fn)(struct kvm *kvm);
> +	bool ret;
> +
> +	fn = symbol_get(kvm_get_kvm_safe);
> +	if (WARN_ON(!fn))
> +		return false;
> +
> +	ret = fn(kvm);
> +
> +	symbol_put(kvm_get_kvm_safe);
> +
> +	return ret;
> +}
> +
> +static void vfio_kvm_put_kvm(struct kvm *kvm)
> +{
> +	void (*fn)(struct kvm *kvm);
> +
> +	fn = symbol_get(kvm_put_kvm);
> +	if (WARN_ON(!fn))
> +		return;
> +
> +	fn(kvm);
> +
> +	symbol_put(kvm_put_kvm);
> +}
> +
>  static int vfio_device_first_open(struct vfio_device *device,
>  				  struct iommufd_ctx *iommufd, struct kvm *kvm)
>  {
> @@ -361,16 +391,24 @@ static int vfio_device_first_open(struct vfio_device *device,
>  	if (ret)
>  		goto err_module_put;
>  
> +	if (kvm && !vfio_kvm_get_kvm_safe(kvm)) {
> +		ret = -ENOENT;
> +		goto err_unuse_iommu;
> +	}
>  	device->kvm = kvm;

This could just as easily be:

	if (kvm && vfio_kvm_get_kvm_safe(kvm))
		device->kvm = kvm;

Right?  The error path would test device->kvm and we already use
device->kvm in the release path.

Otherwise, in the off chance userspace hits this error, what's the
value in generating a failure here for a device that may or may not
have a kvm dependency.  A driver with a dependency should fail if
device->kvm is NULL.

>  	if (device->ops->open_device) {
>  		ret = device->ops->open_device(device);
>  		if (ret)
> -			goto err_unuse_iommu;
> +			goto err_put_kvm;
>  	}
>  	return 0;
>  
> +err_put_kvm:
> +	if (kvm) {
> +		vfio_kvm_put_kvm(kvm);
> +		device->kvm = NULL;
> +	}
>  err_unuse_iommu:
> -	device->kvm = NULL;
>  	if (iommufd)
>  		vfio_iommufd_unbind(device);
>  	else
> @@ -387,7 +425,6 @@ static void vfio_device_last_close(struct vfio_device *device,
>  
>  	if (device->ops->close_device)
>  		device->ops->close_device(device);
> -	device->kvm = NULL;
>  	if (iommufd)
>  		vfio_iommufd_unbind(device);
>  	else
> @@ -465,6 +502,11 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  
>  	vfio_device_group_close(device);
>  
> +	if (device->open_count == 0 && device->kvm) {
> +		vfio_kvm_put_kvm(device->kvm);
> +		device->kvm = NULL;
> +	}

IIUC, device->open_count is protected by device->dev_set->lock.  Thanks,

Alex

> +
>  	vfio_device_put_registration(device);
>  
>  	return 0;
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 35be78e9ae57..3ff7e9302cc1 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -46,7 +46,6 @@ struct vfio_device {
>  	struct vfio_device_set *dev_set;
>  	struct list_head dev_set_list;
>  	unsigned int migration_flags;
> -	/* Driver must reference the kvm during open_device or never touch it */
>  	struct kvm *kvm;
>  
>  	/* Members below here are private, not for driver use */

