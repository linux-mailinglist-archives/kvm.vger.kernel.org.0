Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3A26B0525
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 11:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjCHK5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 05:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjCHK5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 05:57:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCA6888AF
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 02:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678273002;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QPze2kAemoywR2y3iNTM9ywhLXz43ay/3GB+oFr89lY=;
        b=QQg8GrPP2Bu9QKqc8Hm0oMERkFPU/FWOJ+Jvx+h1KJntrQqcGmeF+C3Y9J7QVLZ7qoGqcT
        phi1xh/Oh8h75RAAqyYqN592hJhVxpvaSS46949z25772pz9fFTbH3jMwayriARxqYsb+y
        fWH/I+fPBNabaAJcxMi5YKZJZZ53uCg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-XpLEuD7pMyWZsVTjF_bbqQ-1; Wed, 08 Mar 2023 05:56:41 -0500
X-MC-Unique: XpLEuD7pMyWZsVTjF_bbqQ-1
Received: by mail-qk1-f199.google.com with SMTP id y1-20020a05620a09c100b0070630ecfd9bso9114884qky.20
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 02:56:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678273001;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QPze2kAemoywR2y3iNTM9ywhLXz43ay/3GB+oFr89lY=;
        b=CabEkRgO2wGmO1QEkXt45LGoP/tZJ5FBw9EWMRY7OpqHm6VGrDkEDOaP4TcLP5tIKY
         OXTye269FbmvOTgFzqus6m1c5UUkRGLnHfLS+Fj6M0CWzQfwFiGnmXaDrAPFu2rIXmxN
         lnT6GnhCc8CTeJVRgxwqK2gSrijETUKfcdCRw/FO44ZSoTOpLN/61BlqQfF70w3Q70bE
         wDJWq9bT17PorjbTtmoX3cD+4NkEFTrDkZZ1ySoA9O5+AbdR4HqFhe+taJTBAKIXM7bq
         8fBaPDIP1G3IPiiTuEv+SNWaCxTAaKlTBxkreuQjROmMyGkErkg2mIQK3AD4UKhOGkJ/
         0Uvg==
X-Gm-Message-State: AO0yUKXWF3OT7qHdXgqnQMhDKOLxhpZjiy6tMnzpsoU7/ynDLA/i4c7A
        DccRhzvFK+fjYeK6wBuZKHIBgTogujPnKyV0+0nudWSPwE85K8KCPq+IbysrGnc0B7iwEa7sUc/
        zKQ4auLQvkz8h
X-Received: by 2002:ac8:7f01:0:b0:3b9:bc8c:c202 with SMTP id f1-20020ac87f01000000b003b9bc8cc202mr34324783qtk.13.1678273001120;
        Wed, 08 Mar 2023 02:56:41 -0800 (PST)
X-Google-Smtp-Source: AK7set/DaqhNjL61M9iP81YBgl1w9ZdD4pbsOr9AJ5SQDLlK8CXxEkh64LlbUsAkRhKRs2olY3Orfg==
X-Received: by 2002:ac8:7f01:0:b0:3b9:bc8c:c202 with SMTP id f1-20020ac87f01000000b003b9bc8cc202mr34324761qtk.13.1678273000836;
        Wed, 08 Mar 2023 02:56:40 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d2-20020ac851c2000000b003bfd27755d7sm11325844qtn.19.2023.03.08.02.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 02:56:39 -0800 (PST)
Message-ID: <ee9afb15-5bfd-b2fd-e3d8-ae585afbe87f@redhat.com>
Date:   Wed, 8 Mar 2023 11:56:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC v3 11/18] vfio/ccw: Use vfio_[attach/detach]_device
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, eric.auger.pro@gmail.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com, alex.williamson@redhat.com,
        clg@redhat.com, qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        jjherne@linux.ibm.com, jasowang@redhat.com, kvm@vger.kernel.org,
        jgg@nvidia.com, nicolinc@nvidia.com, kevin.tian@intel.com,
        chao.p.peng@intel.com, peterx@redhat.com,
        shameerali.kolothum.thodi@huawei.com, zhangfei.gao@linaro.org,
        berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
References: <20230131205305.2726330-1-eric.auger@redhat.com>
 <20230131205305.2726330-12-eric.auger@redhat.com>
 <6e04ab8f-dc84-e9c2-deea-2b6b31678b53@linux.ibm.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <6e04ab8f-dc84-e9c2-deea-2b6b31678b53@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Matthew,

On 3/3/23 18:30, Matthew Rosato wrote:
> On 1/31/23 3:52 PM, Eric Auger wrote:
>> Let the vfio-ccw device use vfio_attach_device() and
>> vfio_detach_device(), hence hiding the details of the used
>> IOMMU backend.
>>
>> Also now all the devices have been migrated to use the new
>> vfio_attach_device/vfio_detach_device API, let's turn the
>> legacy functions into static functions, local to container.c.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Hi Eric,
>
> While testing the cdev series on s390 I ran into a couple of issues with this patch, see below.
>
>> ---
>>  include/hw/vfio/vfio-common.h |   4 --
>>  hw/vfio/ccw.c                 | 118 ++++++++--------------------------
>>  hw/vfio/container.c           |   8 +--
>>  3 files changed, 32 insertions(+), 98 deletions(-)
>>
>> diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
>> index 9465c4b021..1580f9617c 100644
>> --- a/include/hw/vfio/vfio-common.h
>> +++ b/include/hw/vfio/vfio-common.h
>> @@ -176,10 +176,6 @@ void vfio_region_unmap(VFIORegion *region);
>>  void vfio_region_exit(VFIORegion *region);
>>  void vfio_region_finalize(VFIORegion *region);
>>  void vfio_reset_handler(void *opaque);
>> -VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp);
>> -void vfio_put_group(VFIOGroup *group);
>> -int vfio_get_device(VFIOGroup *group, const char *name,
>> -                    VFIODevice *vbasedev, Error **errp);
>>  int vfio_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp);
>>  void vfio_detach_device(VFIODevice *vbasedev);
>>  
>> diff --git a/hw/vfio/ccw.c b/hw/vfio/ccw.c
>> index 0354737666..6fde7849cc 100644
>> --- a/hw/vfio/ccw.c
>> +++ b/hw/vfio/ccw.c
>> @@ -579,27 +579,32 @@ static void vfio_ccw_put_region(VFIOCCWDevice *vcdev)
>>      g_free(vcdev->io_region);
>>  }
>>  
>> -static void vfio_ccw_put_device(VFIOCCWDevice *vcdev)
>> -{
>> -    g_free(vcdev->vdev.name);
>> -    vfio_put_base_device(&vcdev->vdev);
>> -}
>> -
>> -static void vfio_ccw_get_device(VFIOGroup *group, VFIOCCWDevice *vcdev,
>> -                                Error **errp)
>> +static void vfio_ccw_realize(DeviceState *dev, Error **errp)
>>  {
>> +    CcwDevice *ccw_dev = DO_UPCAST(CcwDevice, parent_obj, dev);
>> +    S390CCWDevice *cdev = DO_UPCAST(S390CCWDevice, parent_obj, ccw_dev);
>> +    VFIOCCWDevice *vcdev = DO_UPCAST(VFIOCCWDevice, cdev, cdev);
>> +    S390CCWDeviceClass *cdc = S390_CCW_DEVICE_GET_CLASS(cdev);
>> +    VFIODevice *vbasedev = &vcdev->vdev;
>> +    Error *err = NULL;
>>      char *name = g_strdup_printf("%x.%x.%04x", vcdev->cdev.hostid.cssid,
>>                                   vcdev->cdev.hostid.ssid,
>>                                   vcdev->cdev.hostid.devid);
>
> We can't get these cssid, ssid, devid values quite yet, they are currently 0s.  That has to happen after cdc->realize()
>
>
>> -    VFIODevice *vbasedev;
>> +    int ret;
>>  
>> -    QLIST_FOREACH(vbasedev, &group->device_list, next) {
>> -        if (strcmp(vbasedev->name, name) == 0) {
>> -            error_setg(errp, "vfio: subchannel %s has already been attached",
>> -                       name);
>> -            goto out_err;
>> +    /* Call the class init function for subchannel. */
>> +    if (cdc->realize) {
>> +        cdc->realize(cdev, vcdev->vdev.sysfsdev, &err);
>> +        if (err) {
>> +            goto out_err_propagate;
>>          }
>>      }
>> +    vbasedev->sysfsdev = g_strdup_printf("/sys/bus/css/devices/%s/%s",
>> +                                         name, cdev->mdevid);
>> +    vbasedev->ops = &vfio_ccw_ops;
>> +    vbasedev->type = VFIO_DEVICE_TYPE_CCW;
>> +    vbasedev->name = name;
> vbasedev->name is being set to the wrong value here, it needs to be the uuid.
>
> See below for a suggested diff on top of this patch that solves the issue for me.
>
> Thanks,
> Matt
>
> diff --git a/hw/vfio/ccw.c b/hw/vfio/ccw.c
> index 6fde7849cc..394b73358f 100644
> --- a/hw/vfio/ccw.c
> +++ b/hw/vfio/ccw.c
> @@ -587,9 +587,6 @@ static void vfio_ccw_realize(DeviceState *dev, Error **errp)
>      S390CCWDeviceClass *cdc = S390_CCW_DEVICE_GET_CLASS(cdev);
>      VFIODevice *vbasedev = &vcdev->vdev;
>      Error *err = NULL;
> -    char *name = g_strdup_printf("%x.%x.%04x", vcdev->cdev.hostid.cssid,
> -                                 vcdev->cdev.hostid.ssid,
> -                                 vcdev->cdev.hostid.devid);
>      int ret;
>  
>      /* Call the class init function for subchannel. */
> @@ -599,11 +596,14 @@ static void vfio_ccw_realize(DeviceState *dev, Error **errp)
>              goto out_err_propagate;
>          }
>      }
> -    vbasedev->sysfsdev = g_strdup_printf("/sys/bus/css/devices/%s/%s",
> -                                         name, cdev->mdevid);
> +    vbasedev->sysfsdev = g_strdup_printf("/sys/bus/css/devices/%x.%x.%04x/%s",
> +                                         vcdev->cdev.hostid.cssid,
> +                                         vcdev->cdev.hostid.ssid,
> +                                         vcdev->cdev.hostid.devid,
> +                                         cdev->mdevid);
>      vbasedev->ops = &vfio_ccw_ops;
>      vbasedev->type = VFIO_DEVICE_TYPE_CCW;
> -    vbasedev->name = name;
> +    vbasedev->name = g_strdup(cdev->mdevid);
>      vbasedev->dev = &vcdev->cdev.parent_obj.parent_obj;
>  
>      /*
>
>
Thank you very much for your report.

This will be handled in the next version.

Eric

