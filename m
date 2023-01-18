Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E943E672006
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 15:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjAROqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 09:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjAROqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 09:46:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1E45AA61
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674052647;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PbIu4DqthkkjQJte17eITg5XF69CKYN/ZKqJKYm7yqE=;
        b=DI4+Z/ZuxitvEAD0dxwwSpo343TFxl+NelnLGrg55s4U8y0+MFOkqJ9eSZRJcCekeOmQUf
        oJ5BnU5Ni/NQmV1tRAIJUdeagISwbb03FgXerKhLPnL+jw2JU2IaQFbIZp9TWE6+ogKXir
        yMH8lwKbx9YMfDz7tN5i38fZ+nHlbIo=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-102-32Nx-VJwOqO-cfSjl_x-uQ-1; Wed, 18 Jan 2023 09:37:26 -0500
X-MC-Unique: 32Nx-VJwOqO-cfSjl_x-uQ-1
Received: by mail-qt1-f198.google.com with SMTP id a13-20020ac8610d000000b003a8151cadebso15416611qtm.10
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:37:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PbIu4DqthkkjQJte17eITg5XF69CKYN/ZKqJKYm7yqE=;
        b=RVptUT+Es4tIKwYYTkvWgWdhAjqM49jrxxymTczhHN+cRvl/Q8JDp1ZjTY/xRc7dMX
         OovjV9VRZQTGy55XNyseGg5dp3JTECZnrz9S6h6Hlkpq9cc0iFS+xOpg1I+kyINYQovx
         l3d1fRnBvvrv8+HomKa9YzWLQdfA7i/wutA4naYRcV+DMhFIyuIVbLBTAXTRw2PSJM9q
         v8hflM0dQsiAgXdR6xsPteBshwGCQosBYKrurAJ9ZPncq9ONazeAzgm0+cLxx/l17F4F
         qk23r34KMqCikaQrV+qb2g9s6oUg+q6RN6VYINynwuegduVMVG2sWnMBqrscXIy6AtA6
         ptQA==
X-Gm-Message-State: AFqh2kqeHRS7tkDUxceI5IEWXnX5MCIZLxVUS5t4keMex1IVKuz6lO8X
        /1mReegDudv1Ra3QMF65gGXWwUZzZZ+cZSodzsO5rE/HKPjrTuJ5Vtd79WUS4dExaNs8JROdtHe
        XniTW8p0FWZHn
X-Received: by 2002:ac8:7107:0:b0:3ab:d932:6c4e with SMTP id z7-20020ac87107000000b003abd9326c4emr7683543qto.18.1674052645602;
        Wed, 18 Jan 2023 06:37:25 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtdpLsHCCtDNcXEH5HhAfiQFycFU8lisA8efXWgKBkjjNpEHdflxB9rXAWAHhh22XHSGTx4SQ==
X-Received: by 2002:ac8:7107:0:b0:3ab:d932:6c4e with SMTP id z7-20020ac87107000000b003abd9326c4emr7683520qto.18.1674052645273;
        Wed, 18 Jan 2023 06:37:25 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id b1-20020ac844c1000000b003b34650039bsm7514316qto.76.2023.01.18.06.37.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 06:37:24 -0800 (PST)
Message-ID: <97a22ba3-72d4-7e3a-1b6d-469d5816860d@redhat.com>
Date:   Wed, 18 Jan 2023 15:37:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 02/13] vfio: Refine vfio file kAPIs
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-3-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230117134942.101112-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 1/17/23 14:49, Yi Liu wrote:
> This prepares for making the below kAPIs to accept both group file
> and device file instead of only vfio group file.
>   bool vfio_file_enforced_coherent(struct file *file);
>   void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
>   bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
>
> Besides above change, vfio_file_is_group() is renamed to be
> vfio_file_is_valid().
>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c             | 74 ++++++++------------------------
>  drivers/vfio/pci/vfio_pci_core.c |  4 +-
>  drivers/vfio/vfio.h              |  4 ++
>  drivers/vfio/vfio_main.c         | 62 ++++++++++++++++++++++++++
>  include/linux/vfio.h             |  2 +-
>  virt/kvm/vfio.c                  | 10 ++---
>  6 files changed, 92 insertions(+), 64 deletions(-)
>
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 8fdb7e35b0a6..d83cf069d290 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -721,6 +721,15 @@ bool vfio_device_has_container(struct vfio_device *device)
>  	return device->group->container;
>  }
>  
> +struct vfio_group *vfio_group_from_file(struct file *file)
> +{
> +	struct vfio_group *group = file->private_data;
> +
> +	if (file->f_op != &vfio_group_fops)
> +		return NULL;
> +	return group;
> +}
> +
>  /**
>   * vfio_file_iommu_group - Return the struct iommu_group for the vfio group file
>   * @file: VFIO group file
> @@ -731,13 +740,13 @@ bool vfio_device_has_container(struct vfio_device *device)
>   */
>  struct iommu_group *vfio_file_iommu_group(struct file *file)
>  {
> -	struct vfio_group *group = file->private_data;
> +	struct vfio_group *group = vfio_group_from_file(file);
>  	struct iommu_group *iommu_group = NULL;
>  
>  	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
>  		return NULL;
>  
> -	if (!vfio_file_is_group(file))
> +	if (!group)
>  		return NULL;
>  
>  	mutex_lock(&group->group_lock);
> @@ -750,34 +759,11 @@ struct iommu_group *vfio_file_iommu_group(struct file *file)
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
>  
> -/**
> - * vfio_file_is_group - True if the file is usable with VFIO aPIS
> - * @file: VFIO group file
> - */
> -bool vfio_file_is_group(struct file *file)
> -{
> -	return file->f_op == &vfio_group_fops;
> -}
> -EXPORT_SYMBOL_GPL(vfio_file_is_group);
> -
> -/**
> - * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
> - *        is always CPU cache coherent
> - * @file: VFIO group file
> - *
> - * Enforced coherency means that the IOMMU ignores things like the PCIe no-snoop
> - * bit in DMA transactions. A return of false indicates that the user has
> - * rights to access additional instructions such as wbinvd on x86.
> - */
> -bool vfio_file_enforced_coherent(struct file *file)
> +bool vfio_group_enforced_coherent(struct vfio_group *group)
>  {
> -	struct vfio_group *group = file->private_data;
>  	struct vfio_device *device;
>  	bool ret = true;
>  
> -	if (!vfio_file_is_group(file))
> -		return true;
> -
>  	/*
>  	 * If the device does not have IOMMU_CAP_ENFORCE_CACHE_COHERENCY then
>  	 * any domain later attached to it will also not support it. If the cap
> @@ -795,46 +781,22 @@ bool vfio_file_enforced_coherent(struct file *file)
>  	mutex_unlock(&group->device_lock);
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
>  
> -/**
> - * vfio_file_set_kvm - Link a kvm with VFIO drivers
> - * @file: VFIO group file
> - * @kvm: KVM to link
> - *
> - * When a VFIO device is first opened the KVM will be available in
> - * device->kvm if one was associated with the group.
> - */
> -void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
> +void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
>  {
> -	struct vfio_group *group = file->private_data;
> -
> -	if (!vfio_file_is_group(file))
> -		return;
> -
> +	/*
> +	 * When a VFIO device is first opened the KVM will be available in
> +	 * device->kvm if one was associated with the group.
> +	 */
>  	mutex_lock(&group->group_lock);
>  	group->kvm = kvm;
>  	mutex_unlock(&group->group_lock);
>  }
> -EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
>  
> -/**
> - * vfio_file_has_dev - True if the VFIO file is a handle for device
> - * @file: VFIO file to check
> - * @device: Device that must be part of the file
> - *
> - * Returns true if given file has permission to manipulate the given device.
> - */
> -bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
> +bool vfio_group_has_dev(struct vfio_group *group, struct vfio_device *device)
>  {
> -	struct vfio_group *group = file->private_data;
> -
> -	if (!vfio_file_is_group(file))
> -		return false;
> -
>  	return group == device->group;
>  }
> -EXPORT_SYMBOL_GPL(vfio_file_has_dev);
>  
>  static char *vfio_devnode(const struct device *dev, umode_t *mode)
>  {
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 26a541cc64d1..985c6184a587 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1319,8 +1319,8 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>  			break;
>  		}
>  
> -		/* Ensure the FD is a vfio group FD.*/
> -		if (!vfio_file_is_group(file)) {
> +		/* Ensure the FD is a vfio FD.*/
> +		if (!vfio_file_is_valid(file)) {
>  			fput(file);
>  			ret = -EINVAL;
>  			break;
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 1091806bc89d..ef5de2872983 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -90,6 +90,10 @@ void vfio_device_group_unregister(struct vfio_device *device);
>  int vfio_device_group_use_iommu(struct vfio_device *device);
>  void vfio_device_group_unuse_iommu(struct vfio_device *device);
>  void vfio_device_group_close(struct vfio_device *device);
> +struct vfio_group *vfio_group_from_file(struct file *file);
> +bool vfio_group_enforced_coherent(struct vfio_group *group);
> +void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
> +bool vfio_group_has_dev(struct vfio_group *group, struct vfio_device *device);
>  bool vfio_device_has_container(struct vfio_device *device);
>  int __init vfio_group_init(void);
>  void vfio_group_cleanup(void);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index ee54c9ae0af4..1aedfbd15ca0 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1119,6 +1119,68 @@ const struct file_operations vfio_device_fops = {
>  	.mmap		= vfio_device_fops_mmap,
>  };
>  
> +/**
> + * vfio_file_is_valid - True if the file is usable with VFIO aPIS
> + * @file: VFIO group file or VFIO device file
> + */
> +bool vfio_file_is_valid(struct file *file)
> +{
> +	return vfio_group_from_file(file);
is this implicit conversion from ptr to bool always safe?
> +}
> +EXPORT_SYMBOL_GPL(vfio_file_is_valid);
> +
> +/**
> + * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
> + *        is always CPU cache coherent
> + * @file: VFIO group or device file
> + *
> + * Enforced coherency means that the IOMMU ignores things like the PCIe no-snoop
> + * bit in DMA transactions. A return of false indicates that the user has
> + * rights to access additional instructions such as wbinvd on x86.
> + */
> +bool vfio_file_enforced_coherent(struct file *file)
> +{
> +	struct vfio_group *group = vfio_group_from_file(file);
> +
> +	if (group)
> +		return vfio_group_enforced_coherent(group);
> +
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
> +
> +/**
> + * vfio_file_set_kvm - Link a kvm with VFIO drivers
> + * @file: VFIO group file or device file
> + * @kvm: KVM to link
> + *
> + */
> +void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
> +{
> +	struct vfio_group *group = vfio_group_from_file(file);
> +
> +	if (group)
> +		vfio_group_set_kvm(group, kvm);
> +}
> +EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
> +
> +/**
> + * vfio_file_has_dev - True if the VFIO file is a handle for device
This original description sounds weird because originally it aimed
at figuring whether the device belonged to that vfio group fd, no?
And since it will handle both group fd and device fd it still sounds
weird to me.
> + * @file: VFIO file to check
> + * @device: Device that must be part of the file
> + *
> + * Returns true if given file has permission to manipulate the given device.
> + */
> +bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
> +{
> +	struct vfio_group *group = vfio_group_from_file(file);
> +
> +	if (group)
> +		return vfio_group_has_dev(group, device);
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(vfio_file_has_dev);
> +
>  /*
>   * Sub-module support
>   */
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 35be78e9ae57..46edd6e6c0ba 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -241,7 +241,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
>   * External user API
>   */
>  struct iommu_group *vfio_file_iommu_group(struct file *file);
> -bool vfio_file_is_group(struct file *file);
> +bool vfio_file_is_valid(struct file *file);
>  bool vfio_file_enforced_coherent(struct file *file);
>  void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
>  bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 495ceabffe88..868930c7a59b 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -64,18 +64,18 @@ static bool kvm_vfio_file_enforced_coherent(struct file *file)
>  	return ret;
>  }
>  
> -static bool kvm_vfio_file_is_group(struct file *file)
> +static bool kvm_vfio_file_is_valid(struct file *file)
>  {
>  	bool (*fn)(struct file *file);
>  	bool ret;
>  
> -	fn = symbol_get(vfio_file_is_group);
> +	fn = symbol_get(vfio_file_is_valid);
>  	if (!fn)
>  		return false;
>  
>  	ret = fn(file);
>  
> -	symbol_put(vfio_file_is_group);
> +	symbol_put(vfio_file_is_valid);
>  
>  	return ret;
>  }
> @@ -154,8 +154,8 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
>  	if (!filp)
>  		return -EBADF;
>  
> -	/* Ensure the FD is a vfio group FD.*/
> -	if (!kvm_vfio_file_is_group(filp)) {
> +	/* Ensure the FD is a vfio FD.*/
> +	if (!kvm_vfio_file_is_valid(filp)) {
>  		ret = -EINVAL;
>  		goto err_fput;
>  	}
Besides

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

