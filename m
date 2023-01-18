Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDA8671EAA
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 14:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjARN6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 08:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjARN5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 08:57:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3360F4ABC3
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 05:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674048547;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jHBEUrqQX1BjXMD4sLi0vstHMvphiis+e+dt7giiBpk=;
        b=EkmWLNsOWl/pUzeKylStuNGIls7FUAZyFePl1ruxdHKi6g4m9Dkk2fQQHtknVO5VMD/Wzz
        We492NHfb0+iD+Xsy56EgYu2ZNyWaHHfl5pAlMV3yMPrI8Y2Bf9O/s6NmKF5HqbCcMT97x
        hyOWFkTqrt8I7cj79tmWJZ0sZc9pgO8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-663-CL7-uKrTPJaLhZF-ZELeRw-1; Wed, 18 Jan 2023 08:29:06 -0500
X-MC-Unique: CL7-uKrTPJaLhZF-ZELeRw-1
Received: by mail-qt1-f198.google.com with SMTP id bq19-20020a05622a1c1300b003b2685a574bso6503635qtb.1
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 05:29:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jHBEUrqQX1BjXMD4sLi0vstHMvphiis+e+dt7giiBpk=;
        b=jNpBrff4SQqE5bG2CROXUw0Phv6F2MsO7CZ4ZjzhNI7YJgKCRf3Xq6pTdC/2gYh7Zm
         lEDrSslOGcZCVyUTtLNVSJS3LfHScR7UX5+rNRb89aJjmjtzFoqLqqCAx5g7qKEAL8iw
         Tnhc5ClfmWQALbhpq+79llEcTAXbF3sV4TzapJFxLuD2rs09e7F4SPMxwglQeGzM9lLm
         p0mgLcSTvZqnyX4nIAv8bd9C7mgxYBnTaQyikBwJflRQC7675Qx1T3jACqkTO7lkctZ5
         gVAQUTl5W4CsBv6AJJgRGt8e8c6uiTXfCVGPsINLPSgIHaWplkvW0YuR/mu6SuK9Ld3F
         i4Vg==
X-Gm-Message-State: AFqh2korTJ9sum3zzKqDYRGEZpKhJ/Nj6H74l6SU5r1JEL4I5KBMrBWK
        eE6qagAFkJ7gMVnpunqqB2q97k/zMicFOyzB/uW7IZhqSJcn5b69Fb4IJUIpO9cAygsxt61KnDu
        9oBlzbJqngEkH
X-Received: by 2002:a05:622a:4306:b0:3b3:7d5:a752 with SMTP id el6-20020a05622a430600b003b307d5a752mr6588131qtb.50.1674048545605;
        Wed, 18 Jan 2023 05:29:05 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtiMK9CH4/eLCeebi8oju7ub87SXoewN2uWjHLR+N5kusTIKfuBNixFAxbt+3kNAhyp6LrrXA==
X-Received: by 2002:a05:622a:4306:b0:3b3:7d5:a752 with SMTP id el6-20020a05622a430600b003b307d5a752mr6588108qtb.50.1674048545339;
        Wed, 18 Jan 2023 05:29:05 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id z26-20020ac8711a000000b003b62dcbedb8sm5085156qto.74.2023.01.18.05.29.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 05:29:03 -0800 (PST)
Message-ID: <b2053afd-bf94-7b43-8ca9-8adba29af3da@redhat.com>
Date:   Wed, 18 Jan 2023 14:28:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 01/13] vfio: Allocate per device file structure
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-2-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230117134942.101112-2-yi.l.liu@intel.com>
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
> This is preparation for adding vfio device cdev support. vfio device
> cdev requires:
> 1) a per device file memory to store the kvm pointer set by KVM. It will
>    be propagated to vfio_device:kvm after the device cdev file is bound
>    to an iommufd
> 2) a mechanism to block device access through device cdev fd before it
>    is bound to an iommufd
>
> To address above requirements, this adds a per device file structure
> named vfio_device_file. For now, it's only a wrapper of struct vfio_device
> pointer. Other fields will be added to this per file structure in future
> commits.
>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c     | 13 +++++++++++--
>  drivers/vfio/vfio.h      |  6 ++++++
>  drivers/vfio/vfio_main.c | 31 ++++++++++++++++++++++++++-----
>  3 files changed, 43 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index bb24b2f0271e..8fdb7e35b0a6 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -186,19 +186,26 @@ void vfio_device_group_close(struct vfio_device *device)
>  
>  static struct file *vfio_device_open_file(struct vfio_device *device)
>  {
> +	struct vfio_device_file *df;
>  	struct file *filep;
>  	int ret;
>  
> +	df = vfio_allocate_device_file(device);
> +	if (IS_ERR(df)) {
> +		ret = PTR_ERR(df);
> +		goto err_out;
> +	}
> +
>  	ret = vfio_device_group_open(device);
>  	if (ret)
> -		goto err_out;
> +		goto err_free;
>  
>  	/*
>  	 * We can't use anon_inode_getfd() because we need to modify
>  	 * the f_mode flags directly to allow more than just ioctls
>  	 */
>  	filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
> -				   device, O_RDWR);
> +				   df, O_RDWR);
>  	if (IS_ERR(filep)) {
>  		ret = PTR_ERR(filep);
>  		goto err_close_device;
> @@ -222,6 +229,8 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
>  
>  err_close_device:
>  	vfio_device_group_close(device);
> +err_free:
> +	kfree(df);
>  err_out:
>  	return ERR_PTR(ret);
>  }
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index f8219a438bfb..1091806bc89d 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -16,12 +16,18 @@ struct iommu_group;
>  struct vfio_device;
>  struct vfio_container;
>  
> +struct vfio_device_file {
> +	struct vfio_device *device;
> +};
> +
>  void vfio_device_put_registration(struct vfio_device *device);
>  bool vfio_device_try_get_registration(struct vfio_device *device);
>  int vfio_device_open(struct vfio_device *device,
>  		     struct iommufd_ctx *iommufd, struct kvm *kvm);
>  void vfio_device_close(struct vfio_device *device,
>  		       struct iommufd_ctx *iommufd);
> +struct vfio_device_file *
> +vfio_allocate_device_file(struct vfio_device *device);
>  
>  extern const struct file_operations vfio_device_fops;
>  
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 5177bb061b17..ee54c9ae0af4 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -344,6 +344,20 @@ static bool vfio_assert_device_open(struct vfio_device *device)
>  	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
>  }
>  
> +struct vfio_device_file *
> +vfio_allocate_device_file(struct vfio_device *device)
> +{
> +	struct vfio_device_file *df;
> +
> +	df = kzalloc(sizeof(*df), GFP_KERNEL_ACCOUNT);
> +	if (!df)
> +		return ERR_PTR(-ENOMEM);
> +
> +	df->device = device;
> +
> +	return df;
> +}
> +
>  static int vfio_device_first_open(struct vfio_device *device,
>  				  struct iommufd_ctx *iommufd, struct kvm *kvm)
>  {
> @@ -461,12 +475,15 @@ static inline void vfio_device_pm_runtime_put(struct vfio_device *device)
>   */
>  static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  {
> -	struct vfio_device *device = filep->private_data;
> +	struct vfio_device_file *df = filep->private_data;
> +	struct vfio_device *device = df->device;
>  
>  	vfio_device_group_close(device);
>  
>  	vfio_device_put_registration(device);
>  
> +	kfree(df);
> +
>  	return 0;
>  }
>  
> @@ -1031,7 +1048,8 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>  static long vfio_device_fops_unl_ioctl(struct file *filep,
>  				       unsigned int cmd, unsigned long arg)
>  {
> -	struct vfio_device *device = filep->private_data;
> +	struct vfio_device_file *df = filep->private_data;
> +	struct vfio_device *device = df->device;
>  	int ret;
>  
>  	ret = vfio_device_pm_runtime_get(device);
> @@ -1058,7 +1076,8 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
>  				     size_t count, loff_t *ppos)
>  {
> -	struct vfio_device *device = filep->private_data;
> +	struct vfio_device_file *df = filep->private_data;
> +	struct vfio_device *device = df->device;
>  
>  	if (unlikely(!device->ops->read))
>  		return -EINVAL;
> @@ -1070,7 +1089,8 @@ static ssize_t vfio_device_fops_write(struct file *filep,
>  				      const char __user *buf,
>  				      size_t count, loff_t *ppos)
>  {
> -	struct vfio_device *device = filep->private_data;
> +	struct vfio_device_file *df = filep->private_data;
> +	struct vfio_device *device = df->device;
>  
>  	if (unlikely(!device->ops->write))
>  		return -EINVAL;
> @@ -1080,7 +1100,8 @@ static ssize_t vfio_device_fops_write(struct file *filep,
>  
>  static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
>  {
> -	struct vfio_device *device = filep->private_data;
> +	struct vfio_device_file *df = filep->private_data;
> +	struct vfio_device *device = df->device;
>  
>  	if (unlikely(!device->ops->mmap))
>  		return -EINVAL;
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

