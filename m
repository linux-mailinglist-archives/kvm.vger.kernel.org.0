Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F4E6D76D1
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbjDEI2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236914AbjDEI2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:28:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F95026B0
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 01:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680683271;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GcpHYqJlmxv1qwKFnI+wK9HJlFafvS4mogND4ZGsn60=;
        b=HhXc00w/XABqlsKTsGj/SKLIXOpBGat3vaG8v5MJnL86ZVHdea0Diifj3a7mbhn31acoGj
        SJclEzqp63NBPnPLznQ1vYQ3nAM6FqzBq2h+RGGQEUv1MDh8waqHrT0Fi+UDoh2EPfw5Ko
        xdE5lWDYJOsS3pvi8WM325vS9Jp8RrA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-ExjpJv1PPmaalEvuTceymQ-1; Wed, 05 Apr 2023 04:27:50 -0400
X-MC-Unique: ExjpJv1PPmaalEvuTceymQ-1
Received: by mail-qv1-f70.google.com with SMTP id w2-20020a0cc242000000b00583d8e55181so15871837qvh.23
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 01:27:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680683270;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GcpHYqJlmxv1qwKFnI+wK9HJlFafvS4mogND4ZGsn60=;
        b=B3bdLSI3oDuBhMYG8KoXpK9vlDcHKlCDUxe4J6P4qGQnvZqLt6JVlW+arN1QsbbF2j
         PAFEsnXS4HWE2XApRUdVyjP1FHA86nLqJXsPUhIfDoI0Em7Bh251QMHYSdeLjXMky7M+
         NxtlbWNaq7mK9Ari2spfIzAjHZ8nGMGsY5txV/1QtK6P67bwskaIrJEBCV0Cu7JDTzjZ
         cqEAyCdabmdnhQCCaetkT8Ett7Us5TbEXdtFhIQBsc581WvDDEiQIuBUelqnMUQ6WhSa
         DmdaXDtpo+v3ARYRFhVngC4YcmCZBjpNxjrvZt9+9EWi0i2dM+UlwsHREQT8dgPhUCh6
         X44w==
X-Gm-Message-State: AAQBX9ebzYbwOj60bf+LID9ORAlNDYBVNXkueWj4EmBN7M81QT5u9K+N
        VxBgkpsLGSXDQl1G8e3NIRKSsDed3tZwIY78M8JRJZIggFNXGmcfdRKnALlNjnki+qMvz0j1/s3
        c1jvGhc+2ENZ3
X-Received: by 2002:a05:6214:19e9:b0:5ad:a15b:3e6c with SMTP id q9-20020a05621419e900b005ada15b3e6cmr8687294qvc.48.1680683269653;
        Wed, 05 Apr 2023 01:27:49 -0700 (PDT)
X-Google-Smtp-Source: AKy350bbobGfqCwHhoJjnu7RrVhZQap4CeV96CdvBZ8/RqwstJ/htqfWUzacWQApBoEi2broKENu4Q==
X-Received: by 2002:a05:6214:19e9:b0:5ad:a15b:3e6c with SMTP id q9-20020a05621419e900b005ada15b3e6cmr8687275qvc.48.1680683269247;
        Wed, 05 Apr 2023 01:27:49 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id el7-20020ad459c7000000b005e1e999edcasm3872745qvb.42.2023.04.05.01.27.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 01:27:47 -0700 (PDT)
Message-ID: <ca119bbd-f4b8-a0c7-5fae-0bea66542908@redhat.com>
Date:   Wed, 5 Apr 2023 10:27:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 06/12] vfio: Refine vfio file kAPIs for vfio PCI hot
 reset
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-7-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230401144429.88673-7-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,
On 4/1/23 16:44, Yi Liu wrote:
> This prepares vfio core to accept vfio device file from the vfio PCI
> hot reset path. vfio_file_is_group() is still kept for KVM usage.
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c             | 32 ++++++++++++++------------------
>  drivers/vfio/pci/vfio_pci_core.c |  4 ++--
>  drivers/vfio/vfio.h              |  2 ++
>  drivers/vfio/vfio_main.c         | 29 +++++++++++++++++++++++++++++
>  include/linux/vfio.h             |  1 +
>  5 files changed, 48 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 27d5ba7cf9dc..d0c95d033605 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -745,6 +745,15 @@ bool vfio_device_has_container(struct vfio_device *device)
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
> @@ -755,13 +764,13 @@ bool vfio_device_has_container(struct vfio_device *device)
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
> @@ -775,12 +784,12 @@ struct iommu_group *vfio_file_iommu_group(struct file *file)
>  EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
>  
>  /**
> - * vfio_file_is_group - True if the file is usable with VFIO aPIS
> + * vfio_file_is_group - True if the file is a vfio group file
>   * @file: VFIO group file
>   */
>  bool vfio_file_is_group(struct file *file)
>  {
> -	return file->f_op == &vfio_group_fops;
> +	return vfio_group_from_file(file);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_is_group);
>  
> @@ -842,23 +851,10 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
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
> index b68fcba67a4b..2a510b71edcb 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1308,8 +1308,8 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
>  			break;
>  		}
>  
> -		/* Ensure the FD is a vfio group FD.*/
> -		if (!vfio_file_is_group(file)) {
> +		/* Ensure the FD is a vfio FD. vfio group or vfio device */
it is a bit strange to update the comment here and in the other places
in this patch whereas file_is_valid still sticks to group file check
By the way I would simply remove the comment which does not bring much
> +		if (!vfio_file_is_valid(file)) {
>  			fput(file);
>  			ret = -EINVAL;
>  			break;
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 7b19c621e0e6..c0aeea24fbd6 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -84,6 +84,8 @@ void vfio_device_group_unregister(struct vfio_device *device);
>  int vfio_device_group_use_iommu(struct vfio_device *device);
>  void vfio_device_group_unuse_iommu(struct vfio_device *device);
>  void vfio_device_group_close(struct vfio_device *device);
> +struct vfio_group *vfio_group_from_file(struct file *file);
> +bool vfio_group_has_dev(struct vfio_group *group, struct vfio_device *device);
>  bool vfio_device_has_container(struct vfio_device *device);
>  int __init vfio_group_init(void);
>  void vfio_group_cleanup(void);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 89497c933490..fe7446805afd 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1154,6 +1154,35 @@ const struct file_operations vfio_device_fops = {
>  	.mmap		= vfio_device_fops_mmap,
>  };
>  
> +/**
> + * vfio_file_is_valid - True if the file is valid vfio file
> + * @file: VFIO group file or VFIO device file
I wonder if you shouldn't squash with next patch tbh.
> + */
> +bool vfio_file_is_valid(struct file *file)
> +{
> +	return vfio_group_from_file(file);
> +}
> +EXPORT_SYMBOL_GPL(vfio_file_is_valid);
> +
> +/**
> + * vfio_file_has_dev - True if the VFIO file is a handle for device
> + * @file: VFIO file to check
> + * @device: Device that must be part of the file
> + *
> + * Returns true if given file has permission to manipulate the given device.
> + */
> +bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
> +{
> +	struct vfio_group *group;
> +
> +	group = vfio_group_from_file(file);
> +	if (!group)
> +		return false;
> +
> +	return vfio_group_has_dev(group, device);
> +}
> +EXPORT_SYMBOL_GPL(vfio_file_has_dev);
> +
>  /*
>   * Sub-module support
>   */
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 97a1174b922f..f8fb9ab25188 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -258,6 +258,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
>   */
>  struct iommu_group *vfio_file_iommu_group(struct file *file);
>  bool vfio_file_is_group(struct file *file);
> +bool vfio_file_is_valid(struct file *file);
>  bool vfio_file_enforced_coherent(struct file *file);
>  void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
>  bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
Eric

