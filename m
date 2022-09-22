Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C7C5E6A1C
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 19:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiIVR6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 13:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiIVR62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 13:58:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3736E106539
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663869505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g4NUGUXkPyLpfZsihmjyO9VtgQj5aWbqHvYtbi+s6OQ=;
        b=PiHINStj4INo+PorvK0gUGBrz9YfOchAssNeXBIBPkoy6HnDe51/zNlafrBxvSHNiNHXz8
        Eu2yopdx2wHMLGLMtURbzP2QK9207Bf8eRHO7vXekFRE1FIWTTPc89Ny/8Z3cyIJSZUgCq
        6hUDY1sXmd7tEOV77Z+J457z7RUrmGI=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-588-bgysONVsN3-YtXtk7Icjmw-1; Thu, 22 Sep 2022 13:58:23 -0400
X-MC-Unique: bgysONVsN3-YtXtk7Icjmw-1
Received: by mail-io1-f69.google.com with SMTP id b21-20020a5d8915000000b0068aaf634432so5230614ion.20
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=g4NUGUXkPyLpfZsihmjyO9VtgQj5aWbqHvYtbi+s6OQ=;
        b=nDxIRXjv2XwLfidOvHIjEgp4ZHSXbPOxNgAH/12OaAP1tDVlGaDP6EuYnW7KAvk3kR
         GEsaBY5dSUvlizkcZAzfnx38SZOzAmTsFaPX6JCWKV+//hCKR7va7GIPsBoahAvwHbCs
         F1n+ha/Digo1in07m3NbGrbQ8xrYNSbIxDtTgQOoimfKwM7EEMlwT2iR8eOoIoT32omC
         4/ZQXhu2tCvMU+6Wun4huu8T4oRvNFw/rINF3VBHu7X48dcoM4ow8FKrXjyZFWL/vXD7
         a0bcjE6OcYIuiIyulXG+oIG+bj1GRylANvIcy0HSQaqfvUI0d5SBvkGhlAXBOBuloBOg
         GprA==
X-Gm-Message-State: ACrzQf39EyNgEH798Lrz1Ly5Rs3fV6GgePHV5yTZUXhTh8FjnJnlLVwn
        BAy4xEacO5ZpeSr8XhwUG3WlSEsOLMfE30aqjuR3EOU9ADMo+5evhLwZ8fnkApFuvp/2KkGInNU
        /Y4UrkapU4RSZ
X-Received: by 2002:a05:6638:1305:b0:35a:6a4e:9e57 with SMTP id r5-20020a056638130500b0035a6a4e9e57mr2680889jad.126.1663869503062;
        Thu, 22 Sep 2022 10:58:23 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM530vCbzgK3QTaLWq3W4wuBNaUAkWaoYeBZZnU7wvG9GWi4I/K5zklV/6TeHh+w/3LQU5zx2g==
X-Received: by 2002:a05:6638:1305:b0:35a:6a4e:9e57 with SMTP id r5-20020a056638130500b0035a6a4e9e57mr2680865jad.126.1663869502854;
        Thu, 22 Sep 2022 10:58:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p5-20020a056638216500b0035a498d222asm2456730jak.35.2022.09.22.10.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 10:58:22 -0700 (PDT)
Date:   Thu, 22 Sep 2022 11:58:20 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kevin Tian <kevin.tian@intel.com>
Cc:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 00/15] Tidy up vfio_device life cycle
Message-ID: <20220922115820.5ac023ab.alex.williamson@redhat.com>
In-Reply-To: <20220921104401.38898-1-kevin.tian@intel.com>
References: <20220921104401.38898-1-kevin.tian@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 21 Sep 2022 18:43:46 +0800
Kevin Tian <kevin.tian@intel.com> wrote:

> The idea is to let vfio core manage the vfio_device life cycle instead
> of duplicating the logic cross drivers. Besides cleaner code in driver
> side this also allows adding struct device to vfio_device as the first
> step toward adding cdev uAPI in the future. Another benefit is that
> user can now look at sysfs to decide whether a device is bound to
> vfio [1], e.g.:
> 
> 	/sys/devices/pci0000\:6f/0000\:6f\:01.0/vfio-dev/vfio0
> 
> Though most drivers can fit the new model naturally:
> 
>  - vfio_alloc_device() to allocate and initialize vfio_device
>  - vfio_put_device() to release vfio_device
>  - dev_ops->init() for driver private initialization
>  - dev_ops->release() for driver private cleanup
> 
> vfio-ccw is the only exception due to a life cycle mess that its private
> structure mixes both parent and mdev info hence must be alloc/freed
> outside of the life cycle of vfio device.
> 
> Per prior discussions this won't be fixed in short term by IBM folks [2].
> 
> Instead of waiting this series introduces a few tricks to move forward:
> 
>  - vfio_init_device() to initialize a pre-allocated device structure;
> 
>  - require *EVERY* driver to implement @release and free vfio_device
>    inside. Then vfio-ccw can use a completion mechanism to delay the
>    free to css driver;
> 
> The second trick is not a real burden to other drivers because they
> all require a @release for private cleanup anyway. Later once the ccw
> mess is fixed a simple cleanup can be done by moving free from @release
> to vfio core.
> 
> Thanks
> Kevin
> 
> [1] https://listman.redhat.com/archives/libvir-list/2022-August/233482.html
> [2] https://lore.kernel.org/all/0ee29bd6583f17f0ee4ec0769fa50e8ea6703623.camel@linux.ibm.com/
> 
> v4:
>  - fix use-after-free issue in @release of mtty/mbochs and also change
>    mdpy/ap to free vfio-device as the last thing in @release (Alex)
>  - revert the rename from 'vfio' to 'vfio_group' in procfs (Alex) 

Applied to vfio next branch for v6.1.  Thanks,

Alex

