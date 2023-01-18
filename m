Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB5C6722CD
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 17:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjARQSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 11:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjARQRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 11:17:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A2C582AE
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674058295;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qF9mGoqYlvh/E97IrJUU11PYgCYJcUoPOjT3QFOtqt0=;
        b=E0G0fdx6CQ9Liw9VMInR4KfQJC9Mt9vbz9aVDSPkLXmg56q/O08HjTxfhcPCiLjPk4QRKV
        mJTt7OuvRh5ZnhelLg3oSpJhZC7zksvR7sccemI6voPRjYNn4rKaOWvRGFA4DYYE2XK3K/
        GCPeHwfPH/oSGZerpTAoDIzye662Mx8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-670-5PRVPzKGOkuFYkkaV-v1Ng-1; Wed, 18 Jan 2023 11:11:16 -0500
X-MC-Unique: 5PRVPzKGOkuFYkkaV-v1Ng-1
Received: by mail-qv1-f69.google.com with SMTP id y6-20020a0cec06000000b005346d388b7aso8029716qvo.6
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:11:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qF9mGoqYlvh/E97IrJUU11PYgCYJcUoPOjT3QFOtqt0=;
        b=WLh5h7INl6fTJ43C1yHSmAAqHOILcimSSIe75CvI5rYVEGazrefDSbUAQyszhS0Z6g
         iWvnhMnptdtwZgXnKBL2fLpzS/aMtLcZPomGJYES/EGEDtM2eR0B/B9WqMv70Ra/q/Ej
         waD1c5pACH1I324BQni1Ku/7uLn7oiNVqVcsjj0Kvw/xpdCPBzZDawFkLXfIsdO98UWa
         K6S2fVX6H1DEopJD9nFlV6o6JsaWmEytVzpDoI+0XgNrTWB3BjXiQg3CGIcEERzj0A1h
         OmIEHHgHWw/2GYqwDRnbl2WVR4kSL2vBlM2EIXAqYmzmhYJ3iuL0CKxCfWYxv1g2U/uQ
         CvtQ==
X-Gm-Message-State: AFqh2ko1HJevNPvmOO+TFuLcqs6HulBr7K0Z7Jp1ELaE7MvDK2rAQge2
        iHIdM664HAG4J1hpdYw7i5BOGYdqVgX41Da6oSDozYY9aJGV0pJGfM7DK2k1CA0X9kr9/YvfC2y
        F+QiQuORES8Dv
X-Received: by 2002:ac8:754d:0:b0:3ae:95c:8486 with SMTP id b13-20020ac8754d000000b003ae095c8486mr8657822qtr.64.1674058273468;
        Wed, 18 Jan 2023 08:11:13 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu3aSdBEXIezSIQ9ZmXPLjKVqlNp+4BK+CwiF3m6CQpI78yoJTDQX6lz3L6dJKWITaWb1KS+w==
X-Received: by 2002:ac8:754d:0:b0:3ae:95c:8486 with SMTP id b13-20020ac8754d000000b003ae095c8486mr8657795qtr.64.1674058273190;
        Wed, 18 Jan 2023 08:11:13 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id jr49-20020a05622a803100b003ad373d04b6sm14709065qtb.59.2023.01.18.08.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 08:11:11 -0800 (PST)
Message-ID: <6c95aefd-31f5-fc98-7a51-77f181dc6ec8@redhat.com>
Date:   Wed, 18 Jan 2023 17:11:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 03/13] vfio: Accept vfio device file in the driver facing
 kAPI
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-4-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230117134942.101112-4-yi.l.liu@intel.com>
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
> This makes the vfio file kAPIs to accepte vfio device files, also a
> preparation for vfio device cdev support.
>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio.h      |  1 +
>  drivers/vfio/vfio_main.c | 51 ++++++++++++++++++++++++++++++++++++----
>  2 files changed, 48 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index ef5de2872983..53af6e3ea214 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -18,6 +18,7 @@ struct vfio_container;
>  
>  struct vfio_device_file {
>  	struct vfio_device *device;
> +	struct kvm *kvm;
>  };
>  
>  void vfio_device_put_registration(struct vfio_device *device);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 1aedfbd15ca0..dc08d5dd62cc 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1119,13 +1119,23 @@ const struct file_operations vfio_device_fops = {
>  	.mmap		= vfio_device_fops_mmap,
>  };
>  
> +static struct vfio_device *vfio_device_from_file(struct file *file)
> +{
> +	struct vfio_device_file *df = file->private_data;
> +
> +	if (file->f_op != &vfio_device_fops)
> +		return NULL;
> +	return df->device;
> +}
> +
>  /**
>   * vfio_file_is_valid - True if the file is usable with VFIO aPIS
>   * @file: VFIO group file or VFIO device file
>   */
>  bool vfio_file_is_valid(struct file *file)
>  {
> -	return vfio_group_from_file(file);
> +	return vfio_group_from_file(file) ||
> +	       vfio_device_from_file(file);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_is_valid);
>  
> @@ -1140,15 +1150,37 @@ EXPORT_SYMBOL_GPL(vfio_file_is_valid);
>   */
>  bool vfio_file_enforced_coherent(struct file *file)
>  {
> -	struct vfio_group *group = vfio_group_from_file(file);
> +	struct vfio_group *group;
> +	struct vfio_device *device;
>  
> +	group = vfio_group_from_file(file);
>  	if (group)
>  		return vfio_group_enforced_coherent(group);
>  
> +	device = vfio_device_from_file(file);
> +	if (device)
> +		return device_iommu_capable(device->dev,
> +					    IOMMU_CAP_ENFORCE_CACHE_COHERENCY);
> +
>  	return true;
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
>  
> +static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm)
> +{
> +	struct vfio_device_file *df = file->private_data;
> +	struct vfio_device *device = df->device;
> +
> +	/*
> +	 * The kvm is first recorded in the df, and will be propagated
> +	 * to vfio_device::kvm when the file binds iommufd successfully in
> +	 * the vfio device cdev path.
> +	 */
> +	mutex_lock(&device->dev_set->lock);
it is not totally obvious to me why the

device->dev_set->lock needs to be held here and why that lock in particular. Isn't supposed to protect the vfio_device_set. The header just mentions
"the VFIO core will provide a lock that is held around open_device()/close_device() for all devices in the set."

> +	df->kvm = kvm;
> +	mutex_unlock(&device->dev_set->lock);
> +}
> +
>  /**
>   * vfio_file_set_kvm - Link a kvm with VFIO drivers
>   * @file: VFIO group file or device file
> @@ -1157,10 +1189,14 @@ EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
>   */
>  void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>  {
> -	struct vfio_group *group = vfio_group_from_file(file);
> +	struct vfio_group *group;
>  
> +	group = vfio_group_from_file(file);
>  	if (group)
>  		vfio_group_set_kvm(group, kvm);
> +
> +	if (vfio_device_from_file(file))
> +		vfio_device_file_set_kvm(file, kvm);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
>  
> @@ -1173,10 +1209,17 @@ EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
>   */
>  bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
>  {
> -	struct vfio_group *group = vfio_group_from_file(file);
> +	struct vfio_group *group;
> +	struct vfio_device *vdev;
>  
> +	group = vfio_group_from_file(file);
>  	if (group)
>  		return vfio_group_has_dev(group, device);
> +
> +	vdev = vfio_device_from_file(file);
> +	if (device)
> +		return vdev == device;
> +
>  	return false;
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_has_dev);
Thanks

Eric

