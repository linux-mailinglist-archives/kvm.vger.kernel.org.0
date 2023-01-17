Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B01E670D5B
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 00:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjAQX12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 18:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjAQX03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 18:26:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17C137B46
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 13:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673990584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QeSklMeMSoVeudTQC5ciHBckx9nBB5Aw6Kjov/8/jjI=;
        b=an9znu02KPO5Q32qkwvyOLKDjX3DiiAbOhPTaLMQdp/IIct/UnTAFm+A6v6zoPn5DBSSm5
        LvsUmNrUZQcBt5HOdGYq0NxjCdpHAXzuN4w0MAe9dJ0JRWUbM1Ql3TEHA5+DjXyPBQiA9x
        PHC7XRcBI7Ih97f51N7LFYmKpM9Jh2U=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-318-hZ89Aia2MuWBwkpt0Qg-3g-1; Tue, 17 Jan 2023 16:23:02 -0500
X-MC-Unique: hZ89Aia2MuWBwkpt0Qg-3g-1
Received: by mail-il1-f199.google.com with SMTP id y11-20020a056e02178b00b0030c048d64a7so23755574ilu.1
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 13:23:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QeSklMeMSoVeudTQC5ciHBckx9nBB5Aw6Kjov/8/jjI=;
        b=7hUsF+yjwV/PFrlJqQHwAlUwurvTjD9xWthOKDRKQ98ALpCoCFORCw4hercIfe1d8H
         EuslMuoslcJoexbFtqbsLGjnhrZZYGs0Xn3FOQRgbqaXX/ARAp6DNlfLwlkq6yMtVXcW
         Ljwlb5mCKK8lZrq9H6P+GcT8VzxF9N1z2nqa3myJvmSMBNhuCTpBYIza5Dueek2G5TbF
         RsxQHVlcZyVUQ9bfEl6+CMXMDgR+TquVrEtwsETsZ/7vYokamnQwb+sWYmfSjlwKk8hf
         E6rOCrlPisR+pkKwrrdcaj6EsreC4HEUhz0ThuBnn26UmbntQPR3DRi5ZFbx2/tv6Yg7
         pupA==
X-Gm-Message-State: AFqh2koAJCw3smVxVMMhv/9yJFs3csWBMXMQ1XiEsRivG5mB00Gx8W94
        t4iJXmBO4Z6XltQhyTzidQX6ouf/r/MAvzezu5M4NF4/12zFlQChxx+KHqrYcW0kANqiPij/Voa
        QrYG0SyzBs8kN
X-Received: by 2002:a05:6e02:50e:b0:30e:dcfb:6b9d with SMTP id d14-20020a056e02050e00b0030edcfb6b9dmr3964148ils.3.1673990576370;
        Tue, 17 Jan 2023 13:22:56 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuwYzJIi7PTPrlEprlQbMxxydrTJmjaOJ4Q9jFc1jIJdvjOhgIIkYyHBtR5D65vkYIl3IuCsw==
X-Received: by 2002:a05:6e02:50e:b0:30e:dcfb:6b9d with SMTP id d14-20020a056e02050e00b0030edcfb6b9dmr3964131ils.3.1673990576020;
        Tue, 17 Jan 2023 13:22:56 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f12-20020a056e020c6c00b0030c0217dde6sm9533440ilj.0.2023.01.17.13.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 13:22:55 -0800 (PST)
Date:   Tue, 17 Jan 2023 14:22:52 -0700
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
Subject: Re: [PATCH v4] vfio: fix potential deadlock on vfio group lock
Message-ID: <20230117142252.70cc85c7.alex.williamson@redhat.com>
In-Reply-To: <20230114000351.115444-1-mjrosato@linux.ibm.com>
References: <20230114000351.115444-1-mjrosato@linux.ibm.com>
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

On Fri, 13 Jan 2023 19:03:51 -0500
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
> the first time a device is opened and hold that reference until right
> after the group lock is released after the last device is closed.
> 
> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
> Changes from v3:
> * Can't check for open_count after the group lock has been dropped because
>   it would be possible for the count to change again once the group lock
>   is dropped (Jason)
>   Solve this by stashing a copy of the kvm and put_kvm while the group
>   lock is held, nullifying the device copies of these in device_close()
>   as soon as the open_count reaches 0, and then checking to see if the
>   device->kvm changed before dropping the group lock.  If it changed
>   during close, we can drop the reference using the stashed kvm and put
>   function after dropping the group lock.
> 
> Changes from v2:
> * Re-arrange vfio_kvm_set_kvm_safe error path to still trigger
>   device_open with device->kvm=NULL (Alex)
> * get device->dev_set->lock when checking device->open_count (Alex)
> * but don't hold it over the kvm_put_kvm (Jason)
> * get kvm_put symbol upfront and stash it in device until close (Jason)
> * check CONFIG_HAVE_KVM to avoid build errors on architectures without
>   KVM support
> 
> Changes from v1:
> * Re-write using symbol get logic to get kvm ref during first device
>   open, release the ref during device fd close after group lock is
>   released
> * Drop kvm get/put changes to drivers; now that vfio core holds a
>   kvm ref until sometime after the device_close op is called, it
>   should be fine for drivers to get and put their own references to it.
> ---
>  drivers/vfio/group.c     | 23 +++++++++++++--
>  drivers/vfio/vfio.h      |  9 ++++++
>  drivers/vfio/vfio_main.c | 61 +++++++++++++++++++++++++++++++++++++---
>  include/linux/vfio.h     |  2 +-
>  4 files changed, 87 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index bb24b2f0271e..b396c17d7390 100644
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
> +	 * will be held until the open_count reaches 0.
>  	 */
>  	ret = vfio_device_open(device, device->group->iommufd,
>  			       device->group->kvm);
> @@ -179,9 +179,26 @@ static int vfio_device_group_open(struct vfio_device *device)
>  
>  void vfio_device_group_close(struct vfio_device *device)
>  {
> +	void (*put_kvm)(struct kvm *kvm);
> +	struct kvm *kvm;
> +
>  	mutex_lock(&device->group->group_lock);
> +	kvm = device->kvm;
> +	put_kvm = device->put_kvm;
>  	vfio_device_close(device, device->group->iommufd);
> +	if (kvm == device->kvm)
> +		kvm = NULL;

Hmm, so we're using whether the device->kvm pointer gets cleared in
last_close to detect whether we should put the kvm reference.  That's a
bit obscure.  Our get and put is also asymmetric.

Did we decide that we couldn't do this via a schedule_work() from the
last_close function, ie. implementing our own version of an async put?
It seems like that potentially has a cleaner implementation, symmetric
call points, handling all the storing and clearing of kvm related
pointers within the get/put wrappers, passing only a vfio_device to the
put wrapper, using the "vfio_device_" prefix for both.  Potentially
we'd just want an unconditional flush outside of lock here for
deterministic release.

What's the downside?  Thanks,

Alex

>  	mutex_unlock(&device->group->group_lock);
> +
> +	/*
> +	 * The last kvm reference will trigger kvm_destroy_vm, which
> can in
> +	 * turn re-enter vfio and attempt to acquire the group lock.
>  Therefore
> +	 * we get a copy of the kvm pointer and the put function
> under the
> +	 * group lock but wait to put that reference until after
> releasing the
> +	 * lock.
> +	 */
> +	if (kvm)
> +		vfio_kvm_put_kvm(put_kvm, kvm);
>  }
>  
>  static struct file *vfio_device_open_file(struct vfio_device *device)
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index f8219a438bfb..08a5a23d6fef 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -251,4 +251,13 @@ extern bool vfio_noiommu __read_mostly;
>  enum { vfio_noiommu = false };
>  #endif
>  
> +#ifdef CONFIG_HAVE_KVM
> +void vfio_kvm_put_kvm(void (*put)(struct kvm *kvm), struct kvm *kvm);
> +#else
> +static inline void vfio_kvm_put_kvm(void (*put)(struct kvm *kvm),
> +				    struct kvm *kvm)
> +{
> +}
> +#endif
> +
>  #endif
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 5177bb061b17..c6bb07af46b8 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -16,6 +16,9 @@
>  #include <linux/fs.h>
>  #include <linux/idr.h>
>  #include <linux/iommu.h>
> +#ifdef CONFIG_HAVE_KVM
> +#include <linux/kvm_host.h>
> +#endif
>  #include <linux/list.h>
>  #include <linux/miscdevice.h>
>  #include <linux/module.h>
> @@ -344,6 +347,49 @@ static bool vfio_assert_device_open(struct
> vfio_device *device) return
> !WARN_ON_ONCE(!READ_ONCE(device->open_count)); }
>  
> +#ifdef CONFIG_HAVE_KVM
> +static bool vfio_kvm_get_kvm_safe(struct vfio_device *device, struct
> kvm *kvm) +{
> +	void (*pfn)(struct kvm *kvm);
> +	bool (*fn)(struct kvm *kvm);
> +	bool ret;
> +
> +	pfn = symbol_get(kvm_put_kvm);
> +	if (WARN_ON(!pfn))
> +		return false;
> +
> +	fn = symbol_get(kvm_get_kvm_safe);
> +	if (WARN_ON(!fn)) {
> +		symbol_put(kvm_put_kvm);
> +		return false;
> +	}
> +
> +	ret = fn(kvm);
> +	if (ret)
> +		device->put_kvm = pfn;
> +	else
> +		symbol_put(kvm_put_kvm);
> +
> +	symbol_put(kvm_get_kvm_safe);
> +
> +	return ret;
> +}
> +
> +void vfio_kvm_put_kvm(void (*put)(struct kvm *kvm), struct kvm *kvm)
> +{
> +	if (WARN_ON(!put))
> +		return;
> +
> +	put(kvm);
> +	symbol_put(kvm_put_kvm);
> +}
> +#else
> +static bool vfio_kvm_get_kvm_safe(struct vfio_device *device, struct
> kvm *kvm) +{
> +	return false;
> +}
> +#endif
> +
>  static int vfio_device_first_open(struct vfio_device *device,
>  				  struct iommufd_ctx *iommufd,
> struct kvm *kvm) {
> @@ -361,16 +407,22 @@ static int vfio_device_first_open(struct
> vfio_device *device, if (ret)
>  		goto err_module_put;
>  
> -	device->kvm = kvm;
> +	if (kvm && vfio_kvm_get_kvm_safe(device, kvm))
> +		device->kvm = kvm;
> +
>  	if (device->ops->open_device) {
>  		ret = device->ops->open_device(device);
>  		if (ret)
> -			goto err_unuse_iommu;
> +			goto err_put_kvm;
>  	}
>  	return 0;
>  
> -err_unuse_iommu:
> -	device->kvm = NULL;
> +err_put_kvm:
> +	if (device->kvm) {
> +		vfio_kvm_put_kvm(device->put_kvm, device->kvm);
> +		device->put_kvm = NULL;
> +		device->kvm = NULL;
> +	}
>  	if (iommufd)
>  		vfio_iommufd_unbind(device);
>  	else
> @@ -388,6 +440,7 @@ static void vfio_device_last_close(struct
> vfio_device *device, if (device->ops->close_device)
>  		device->ops->close_device(device);
>  	device->kvm = NULL;
> +	device->put_kvm = NULL;
>  	if (iommufd)
>  		vfio_iommufd_unbind(device);
>  	else
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 35be78e9ae57..87ff862ff555 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -46,7 +46,6 @@ struct vfio_device {
>  	struct vfio_device_set *dev_set;
>  	struct list_head dev_set_list;
>  	unsigned int migration_flags;
> -	/* Driver must reference the kvm during open_device or never
> touch it */ struct kvm *kvm;
>  
>  	/* Members below here are private, not for driver use */
> @@ -58,6 +57,7 @@ struct vfio_device {
>  	struct list_head group_next;
>  	struct list_head iommu_entry;
>  	struct iommufd_access *iommufd_access;
> +	void (*put_kvm)(struct kvm *kvm);
>  #if IS_ENABLED(CONFIG_IOMMUFD)
>  	struct iommufd_device *iommufd_device;
>  	struct iommufd_ctx *iommufd_ictx;

