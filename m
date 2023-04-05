Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F2B6D8571
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 19:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbjDER7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 13:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbjDER7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 13:59:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BAD59FC
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 10:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680717514;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bxLaegyvGXsWtWEkMuJq7mzfRVKAvjHLcyr9E0NhVqA=;
        b=E8d4ArS61+Mry+m8iWFyIHIMAF9Hy8vCOCOvmbzAhTqKq4VGC5Z/qfq0HND0IEUEX5KylC
        xXQgmZvY+rnlruRRkTU657KLAUz5B6wAF+P91aUCUBRWHY3REy8ujLRy5GYre5kAe7kWms
        czCunAUTKgl9WNBQS4ieNSvoFRfhDRM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-6FPBS5o9M0unMupOCXMueQ-1; Wed, 05 Apr 2023 13:58:33 -0400
X-MC-Unique: 6FPBS5o9M0unMupOCXMueQ-1
Received: by mail-qt1-f200.google.com with SMTP id e4-20020a05622a110400b003e4e915a164so20481201qty.4
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 10:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680717513;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bxLaegyvGXsWtWEkMuJq7mzfRVKAvjHLcyr9E0NhVqA=;
        b=P3zx9hU7Le0ke4eoUL740qhxDetUhhdZSrtVUHwIT/EaK3/A7SihIbe8oyNh9jlR1a
         tnAbyBAlmmgvPqztC7iiD5slonQhzMHTxIM9NU5zQxWS/0+nhgiG5M5BBALKsz7b6EbW
         3pnlsX7LuSO4avrmUXuUaST8Z/uUH8yQzfUv22bcmW7CAAtIhZmdzqfyEKgSrB5qdhBP
         QYQ9fGB2neRwLCKjLE//v77AtPAwx9j2ZAgolZIxLBXdFCza46i+CUCs6MK6dFs61V5l
         f8WInftE11J3BgWTLeOqki0gq5q/dDpL49/u1N3LFIAgU09BkHfJHabZ5Enavpje+Z0W
         a49w==
X-Gm-Message-State: AAQBX9flGSsajMiicyTdOuds1p5VfLIvMhKzd7T/AzTnmOhRnqPLtL00
        T+9Ql1/qodNS53ZdY17wM/ZGMHZJyMmLBrBdmNZ0sXDwdtqSabrWvJo5JoJ6PO8jmmbOLjNoZJa
        3RiMBXX+bJYMz
X-Received: by 2002:ad4:5f8b:0:b0:5bd:14f9:650d with SMTP id jp11-20020ad45f8b000000b005bd14f9650dmr53910qvb.36.1680717513009;
        Wed, 05 Apr 2023 10:58:33 -0700 (PDT)
X-Google-Smtp-Source: AKy350aVDJ5I73OXxuM402WPKU9vfhckM20c+fZ/2+Cchx+DMOvKxzeMX7mOqyBFvtiDLu67T1foqg==
X-Received: by 2002:ad4:5f8b:0:b0:5bd:14f9:650d with SMTP id jp11-20020ad45f8b000000b005bd14f9650dmr53862qvb.36.1680717512735;
        Wed, 05 Apr 2023 10:58:32 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h15-20020ac8548f000000b003e0945575dasm4184864qtq.1.2023.04.05.10.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 10:58:31 -0700 (PDT)
Message-ID: <43f6e334-f440-ea85-9e74-c0b700c07399@redhat.com>
Date:   Wed, 5 Apr 2023 19:58:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 04/25] vfio: Accept vfio device file in the KVM facing
 kAPI
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
References: <20230401151833.124749-1-yi.l.liu@intel.com>
 <20230401151833.124749-5-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230401151833.124749-5-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 4/1/23 17:18, Yi Liu wrote:
> This makes the vfio file kAPIs to accept vfio device files, also a
> preparation for vfio device cdev support.
>
> For the kvm set with vfio device file, kvm pointer is stored in struct
> vfio_device_file, and use kvm_ref_lock to protect kvm set and kvm
> pointer usage within VFIO. This kvm pointer will be set to vfio_device
> after device file is bound to iommufd in the cdev path.
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  drivers/vfio/vfio.h      |  2 ++
>  drivers/vfio/vfio_main.c | 18 ++++++++++++++++++
>  2 files changed, 20 insertions(+)
>
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 56ad127ac618..e4672d91a6f7 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -18,6 +18,8 @@ struct vfio_container;
>  
>  struct vfio_device_file {
>  	struct vfio_device *device;
> +	spinlock_t kvm_ref_lock; /* protect kvm field */
> +	struct kvm *kvm;
>  };
>  
>  void vfio_device_put_registration(struct vfio_device *device);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 748bde4d74d9..cb543791b28b 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -414,6 +414,7 @@ vfio_allocate_device_file(struct vfio_device *device)
>  		return ERR_PTR(-ENOMEM);
>  
>  	df->device = device;
> +	spin_lock_init(&df->kvm_ref_lock);
>  
>  	return df;
>  }
> @@ -1246,6 +1247,20 @@ bool vfio_file_enforced_coherent(struct file *file)
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
>  
> +static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm)
> +{
> +	struct vfio_device_file *df = file->private_data;
> +
> +	/*
> +	 * The kvm is first recorded in the vfio_device_file, and will
> +	 * be propagated to vfio_device::kvm when the file is bound to
> +	 * iommufd successfully in the vfio device cdev path.
> +	 */
> +	spin_lock(&df->kvm_ref_lock);
> +	df->kvm = kvm;
> +	spin_unlock(&df->kvm_ref_lock);
> +}
> +
>  /**
>   * vfio_file_set_kvm - Link a kvm with VFIO drivers
>   * @file: VFIO group file or VFIO device file
> @@ -1259,6 +1274,9 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>  	group = vfio_group_from_file(file);
>  	if (group)
>  		vfio_group_set_kvm(group, kvm);
> +
> +	if (vfio_device_from_file(file))
> +		vfio_device_file_set_kvm(file, kvm);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
>  

