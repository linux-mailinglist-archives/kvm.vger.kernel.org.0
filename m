Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62F66DAB14
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 11:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjDGJtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 05:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbjDGJs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 05:48:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DB049FF
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 02:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680860892;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o4iRHgbQhPwVpyJmMFVyQJvJ+/Z7zOQeM679Xa5eK6c=;
        b=iSlEb6dRvXMDop5RMYRqn5Njq7rKFqLE/qz6/OPdrW24enisci/r5c5cefC2WmekTn136F
        yMwSvBYrCh77g3Y27frbugvhQjP1YYEA55cWs2M7Aa7LlX0r1hnYbKZdj/CqqIsK3hnCI0
        BHHETUeX+C5BuGw3KBFwJYFkzHxtipA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-DpzDG5kcNnSTHF3qS6TxtA-1; Fri, 07 Apr 2023 05:48:11 -0400
X-MC-Unique: DpzDG5kcNnSTHF3qS6TxtA-1
Received: by mail-wm1-f70.google.com with SMTP id u12-20020a05600c19cc00b003f07be0e96bso320973wmq.7
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 02:48:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680860890;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o4iRHgbQhPwVpyJmMFVyQJvJ+/Z7zOQeM679Xa5eK6c=;
        b=0wStaDOw8L9vYb/L7jbeNOwvne0+rYPPfdPIcEsXlRFyckowjrycFpFUZcKk82RNK1
         4iZK+MHiysUlvGedV4U0erW88eYD4GnZ87mz/0VU6Ap2r04xf5PVuyFqYUm7a+KTaG7J
         uze2E+JRPqa6uw1spQ7fhk4KXjiSqWNYnHo6/wNq7GYrDwwRyI2qgMIAdgN/9lUle6sd
         6niX8ceNeXlua0CyZ7HBhbG56iRG1SokL2LWbMLnYbo5hZRKaj90se6sy5V80s+yiJFP
         v6PqEFlitTxm7nblUkQ6jvRVSvqtZn+xe+A11a0q7ELQRVdCXhFIkGchNx7rgKi3SKkm
         FvwQ==
X-Gm-Message-State: AAQBX9eBX5WW2r9N+o5tJ1YADxSjQiYYV277vFxieYaPLamcYzGzgSMm
        3UAeYf7oy4sGD9FC4LpthHThExCuw4qATyKdEUvVVIidAsl1cxhfSlxHq1P0hY7k4lESN5fYBMD
        ObmezyT8QUubT
X-Received: by 2002:a05:600c:204d:b0:3ea:e4f8:be09 with SMTP id p13-20020a05600c204d00b003eae4f8be09mr909008wmg.30.1680860889934;
        Fri, 07 Apr 2023 02:48:09 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZlpsPfpxKVEL2171G53vaHOkQSd6+4Svqt/X88zEcX4kRYEeQU3ue1qYmeM1kP8/bXxozatA==
X-Received: by 2002:a05:600c:204d:b0:3ea:e4f8:be09 with SMTP id p13-20020a05600c204d00b003eae4f8be09mr908998wmg.30.1680860889634;
        Fri, 07 Apr 2023 02:48:09 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a2-20020a1cf002000000b003f049a42689sm4103205wmb.25.2023.04.07.02.48.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 02:48:07 -0700 (PDT)
Message-ID: <05d59a7e-fa75-a93e-95a5-a376c00721d5@redhat.com>
Date:   Fri, 7 Apr 2023 11:48:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 10/25] vfio: Make vfio_device_open() single open for
 device cdev path
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
 <20230401151833.124749-11-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230401151833.124749-11-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
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
> VFIO group has historically allowed multi-open of the device FD. This
> was made secure because the "open" was executed via an ioctl to the
> group FD which is itself only single open.
>
> However, no known use of multiple device FDs today. It is kind of a
> strange thing to do because new device FDs can naturally be created
> via dup().
>
> When we implement the new device uAPI (only used in cdev path) there is
> no natural way to allow the device itself from being multi-opened in a
> secure manner. Without the group FD we cannot prove the security context
> of the opener.
>
> Thus, when moving to the new uAPI we block the ability of opening
> a device multiple times. Given old group path still allows it we store
> a vfio_group pointer in struct vfio_device_file to differentiate.
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c     | 2 ++
>  drivers/vfio/vfio.h      | 2 ++
>  drivers/vfio/vfio_main.c | 7 +++++++
>  3 files changed, 11 insertions(+)
>
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index d55ce3ca44b7..1af4b9e012a7 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -245,6 +245,8 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
>  		goto err_out;
>  	}
>  
> +	df->group = device->group;
> +
in previous patches df fields were protected with various locks. I refer
to vfio_device_group_open() implementation. No need here?

By the way since the group is set here, wrt [PATCH v9 06/25] kvm/vfio:
Accept vfio device file from userspace you have a way to determine if a
device was opened in the legacy way, no?
>  	ret = vfio_device_group_open(df);
>  	if (ret)
>  		goto err_free;
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index b2f20b78a707..f1a448f9d067 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -18,6 +18,8 @@ struct vfio_container;
>  
>  struct vfio_device_file {
>  	struct vfio_device *device;
> +	struct vfio_group *group;
> +
>  	bool access_granted;
>  	spinlock_t kvm_ref_lock; /* protect kvm field */
>  	struct kvm *kvm;
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 6d5d3c2180c8..c8721d5d05fa 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -477,6 +477,13 @@ int vfio_device_open(struct vfio_device_file *df)
>  
>  	lockdep_assert_held(&device->dev_set->lock);
>  
> +	/*
> +	 * Only the group path allows the device opened multiple times.
allows the device to be opened multiple times
> +	 * The device cdev path doesn't have a secure way for it.
> +	 */
> +	if (device->open_count != 0 && !df->group)
> +		return -EINVAL;
> +
>  	device->open_count++;
>  	if (device->open_count == 1) {
>  		ret = vfio_device_first_open(df);
Thanks

Eric

