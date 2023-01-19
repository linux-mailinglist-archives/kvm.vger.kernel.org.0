Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8706E673AF9
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 15:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjASOBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 09:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjASOBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 09:01:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59417497D
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 06:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674136854;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7kQKpICO9uacre4Mt+rxGgC3o20nQoiBgAks2YWGTBY=;
        b=TuDYptkU7ZoQWP1hxq4fRNfJCtG4kxB5+3NqfXMjE1Jn7LvdGVXCpP57U3R4Std2w24Nyv
        9xVR8S54CXo38myQIpGrfY8eUbuE7bYqEw5PiucKdnf3r6gHq4ftNkj2xBcP4J3SOqlIEB
        EOZczfbI5G+Eoxbkdtq3Y4VAEvTqL9c=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-604-AOCfy-51Nya2qnvahKiPLQ-1; Thu, 19 Jan 2023 09:00:53 -0500
X-MC-Unique: AOCfy-51Nya2qnvahKiPLQ-1
Received: by mail-qt1-f199.google.com with SMTP id hf20-20020a05622a609400b003abcad051d2so961264qtb.12
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 06:00:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7kQKpICO9uacre4Mt+rxGgC3o20nQoiBgAks2YWGTBY=;
        b=xJX4oDtyAN9az0rbKd38pSmITsgLt+09PSbCmxNhFilbdL6lzQx/oJOj0Mk5z88RRb
         fW73sxf4lE58bt+beY4PiMxSMfqo1YWl0hn99AbIt+2PTKsKMKWDmFiUwUdFPtA4505d
         NeKL4bl1hePksAYEEq7Womlg196Dvgr/I1NxkYLKRkiwpSLfjF2aWHb0QUFecmVtvLsi
         cWszFHlZZeAvpl5vtncKcrWqXERoABKM6pt9cxTZazBmtWlhl0qlorvGg3OxRWXysm0+
         9HGUWksUxNZxKSlFcTOmwy5ydAa520rp2EllnqXW6FaO1S1YM1f5Ns0IviUrZ0CWjSzG
         K3ZQ==
X-Gm-Message-State: AFqh2kp0t8bpkI9xqv5A5ey4j9miDqyi4owWu+4A5/oVwpjJm1iHZ13v
        ZN0SSJepXO0eloKpixoUVjUVchTuRlgDG80GMTS6T5K6LI2UYiD5trqL+UaiIa06gK9t3pCwfFe
        fODQTkJSDM7Zz
X-Received: by 2002:a05:622a:5c8c:b0:3a9:7e3f:2646 with SMTP id ge12-20020a05622a5c8c00b003a97e3f2646mr16441511qtb.11.1674136850682;
        Thu, 19 Jan 2023 06:00:50 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt/+u/ck4UowMT8APMO8mkb8WJFW8XImSUP2ddd1AJQdrngVdq+yJt5iCVVtUbnh3bN21Uc4Q==
X-Received: by 2002:a05:622a:5c8c:b0:3a9:7e3f:2646 with SMTP id ge12-20020a05622a5c8c00b003a97e3f2646mr16441457qtb.11.1674136850013;
        Thu, 19 Jan 2023 06:00:50 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id r7-20020ac85e87000000b003b54a8fd02dsm7359442qtx.87.2023.01.19.06.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 06:00:48 -0800 (PST)
Message-ID: <17354dc1-82fe-e793-8266-73c47c1baf88@redhat.com>
Date:   Thu, 19 Jan 2023 15:00:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 08/13] vfio: Block device access via device fd until
 device is opened
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-9-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230117134942.101112-9-yi.l.liu@intel.com>
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
> Allow the vfio_device file to be in a state where the device FD is
> opened but the device cannot be used by userspace (i.e. its .open_device()
> hasn't been called). This inbetween state is not used when the device
> FD is spawned from the group FD, however when we create the device FD
> directly by opening a cdev it will be opened in the blocked state.
Please explain why this is needed in the commit message (although you
evoked the rationale in the cover letter).

Eric
>
> In the blocked state, currently only the bind operation is allowed,
> other device accesses are not allowed. Completing bind will allow user
> to further access the device.
>
> This is implemented by adding a flag in struct vfio_device_file to mark
> the blocked state and using a simple smp_load_acquire() to obtain the
> flag value and serialize all the device setup with the thread accessing
> this device.
>
> Due to this scheme it is not possible to unbind the FD, once it is bound,
> it remains bound until the FD is closed.
>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio.h      |  1 +
>  drivers/vfio/vfio_main.c | 29 +++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
>
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 3d8ba165146c..c69a9902ea84 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -20,6 +20,7 @@ struct vfio_device_file {
>  	struct vfio_device *device;
>  	struct kvm *kvm;
>  	struct iommufd_ctx *iommufd;
> +	bool access_granted;
>  };
>  
>  void vfio_device_put_registration(struct vfio_device *device);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 3df71bd9cd1e..d442ebaa4b21 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -430,6 +430,11 @@ int vfio_device_open(struct vfio_device_file *df)
>  		}
>  	}
>  
> +	/*
> +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> +	 * read/write/mmap
> +	 */
> +	smp_store_release(&df->access_granted, true);
>  	return 0;
>  }
>  
> @@ -1058,8 +1063,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  {
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
> +	bool access;
>  	int ret;
>  
> +	/* Paired with smp_store_release() in vfio_device_open() */
> +	access = smp_load_acquire(&df->access_granted);
> +	if (!access)
> +		return -EINVAL;
> +
>  	ret = vfio_device_pm_runtime_get(device);
>  	if (ret)
>  		return ret;
> @@ -1086,6 +1097,12 @@ static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
>  {
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
> +	bool access;
> +
> +	/* Paired with smp_store_release() in vfio_device_open() */
> +	access = smp_load_acquire(&df->access_granted);
> +	if (!access)
> +		return -EINVAL;
>  
>  	if (unlikely(!device->ops->read))
>  		return -EINVAL;
> @@ -1099,6 +1116,12 @@ static ssize_t vfio_device_fops_write(struct file *filep,
>  {
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
> +	bool access;
> +
> +	/* Paired with smp_store_release() in vfio_device_open() */
> +	access = smp_load_acquire(&df->access_granted);
> +	if (!access)
> +		return -EINVAL;
>  
>  	if (unlikely(!device->ops->write))
>  		return -EINVAL;
> @@ -1110,6 +1133,12 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
>  {
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
> +	bool access;
> +
> +	/* Paired with smp_store_release() in vfio_device_open() */
> +	access = smp_load_acquire(&df->access_granted);
> +	if (!access)
> +		return -EINVAL;
>  
>  	if (unlikely(!device->ops->mmap))
>  		return -EINVAL;

