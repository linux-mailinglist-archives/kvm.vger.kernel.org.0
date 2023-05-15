Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3871A7025BE
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 09:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbjEOHMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 03:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjEOHMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 03:12:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CE310EF
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 00:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684134689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PrvftN8LTvjLNSmV4hczj5SgdxauygqUnnKWnbj/64w=;
        b=BI1pdbCpE/M6/yEjAHMJjCgGzVYJmwMFOjAvIeYlZca/W0jh7LNoowatoYJnY3GnRvgTO1
        3idgtObRnZSd8jbpD5OE9VNd5FSXtQjv65RvtRdqzHFbH4jrXSgJIkURicG7Wt+Fl5usv9
        28AFvwtAnbLqpBjtEWU0tMX6BasdpWw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-i32dbyCwPiaSoKIAMQ4WdA-1; Mon, 15 May 2023 03:11:28 -0400
X-MC-Unique: i32dbyCwPiaSoKIAMQ4WdA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f42b36733aso24197665e9.3
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 00:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684134687; x=1686726687;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PrvftN8LTvjLNSmV4hczj5SgdxauygqUnnKWnbj/64w=;
        b=jkDxN7rQvpiFWAj987nHIE7+ZQ3pegiDuG2Di1MGlagx0nn6J2jOmLAAZZs6kRYRDJ
         zhXkk7GiqHHnUK0dkEXrfF51BefuGUaMw67Cz+49+2Z6VIs+jZp8YDOBiENHjYUKBERY
         jvuZRbtMc+bPiPrt0LKQ+gLTSiyKjgWjq6/mQqeHjbBlLba0+HifHdXqF2wK24rEacD4
         KhgI2RivPhM+0uNJ/ifIXtHG8+iTlWjp34NkhO3RCaYy9IdASTKhnpJPDF5jZaxRVvlR
         MCc48FU46PqRRKUPNESoc5j5fvhlPdfXMi5HXc5pqHJm72l6odPPFseWg46T346oGBG0
         Eikg==
X-Gm-Message-State: AC+VfDzyQHlMJiGGVX/B77jC5N+NO1r6i2Ossv3tlJ1rhu4iiINWVr9K
        K4vOXG2mh0mkLSAQxFW7yUAs2dj7/uMvVpQdn4qDxDSuzCRO94ywsxHGTUM7LU2iDYdS1O1TpGo
        uafZq2BPbidN6
X-Received: by 2002:a1c:f711:0:b0:3f5:1a4:a08d with SMTP id v17-20020a1cf711000000b003f501a4a08dmr3278810wmh.7.1684134687145;
        Mon, 15 May 2023 00:11:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5qYm9mJZDymacavx2WUVx58H8QOzio8ACR10nRBchBc8miC//kNxyu+5sGW2UPuK2Nxwn/oQ==
X-Received: by 2002:a1c:f711:0:b0:3f5:1a4:a08d with SMTP id v17-20020a1cf711000000b003f501a4a08dmr3278789wmh.7.1684134686765;
        Mon, 15 May 2023 00:11:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id i7-20020a05600c290700b003f4ecf1fcbcsm11706405wmd.22.2023.05.15.00.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 00:11:26 -0700 (PDT)
Message-ID: <6f958b0b-64bd-147d-98d5-a2158b34247d@redhat.com>
Date:   Mon, 15 May 2023 09:11:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5 07/10] vfio: Add helper to search vfio_device in a
 dev_set
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com
References: <20230513132136.15021-1-yi.l.liu@intel.com>
 <20230513132136.15021-8-yi.l.liu@intel.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clegoate@redhat.com>
In-Reply-To: <20230513132136.15021-8-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/13/23 15:21, Yi Liu wrote:
> There are drivers that need to search vfio_device within a given dev_set.
> e.g. vfio-pci. So add a helper.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>   drivers/vfio/pci/vfio_pci_core.c |  8 +++-----
>   drivers/vfio/vfio_main.c         | 15 +++++++++++++++
>   include/linux/vfio.h             |  3 +++
>   3 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 39e7823088e7..4df2def35bdd 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2335,12 +2335,10 @@ static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
>   static int vfio_pci_is_device_in_set(struct pci_dev *pdev, void *data)
>   {
>   	struct vfio_device_set *dev_set = data;
> -	struct vfio_device *cur;
>   
> -	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> -		if (cur->dev == &pdev->dev)
> -			return 0;
> -	return -EBUSY;
> +	lockdep_assert_held(&dev_set->lock);

May be drop the lockdep_assert_held() above since there is one in
vfio_find_device_in_devset().

Thanks,

C.

> +
> +	return vfio_find_device_in_devset(dev_set, &pdev->dev) ? 0 : -EBUSY;
>   }
>   
>   /*
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index f0ca33b2e1df..ab4f3a794f78 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -141,6 +141,21 @@ unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set)
>   }
>   EXPORT_SYMBOL_GPL(vfio_device_set_open_count);
>   
> +struct vfio_device *
> +vfio_find_device_in_devset(struct vfio_device_set *dev_set,
> +			   struct device *dev)
> +{
> +	struct vfio_device *cur;
> +
> +	lockdep_assert_held(&dev_set->lock);
> +
> +	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> +		if (cur->dev == dev)
> +			return cur;
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(vfio_find_device_in_devset);
> +
>   /*
>    * Device objects - create, release, get, put, search
>    */
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index fcbe084b18c8..4c17395ed4d2 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -259,6 +259,9 @@ void vfio_unregister_group_dev(struct vfio_device *device);
>   
>   int vfio_assign_device_set(struct vfio_device *device, void *set_id);
>   unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
> +struct vfio_device *
> +vfio_find_device_in_devset(struct vfio_device_set *dev_set,
> +			   struct device *dev);
>   
>   int vfio_mig_get_next_state(struct vfio_device *device,
>   			    enum vfio_device_mig_state cur_fsm,

