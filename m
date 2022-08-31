Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28375A726B
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiHaAcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiHaAcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:32:22 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61687A4073
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:32:20 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id m5so9756514qkk.1
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=m6BZChVtTK+UGAguzCWejrDqoYzu+Sz7AkPqPhtFZKg=;
        b=iRMue+inDDgzPoZBlSffki7JldZ/QlafC20b2i0ZBxo0i3xmlsOecDLDz13B79wjHh
         YEqSPlUr39wUHw15ThhAyQe0of7R+dKWzTdu1xNlS3TiVFOn+NfLXbx8Wkfh29W6llrh
         GUKFoVha4k8UolCu0Qb7L1iRcHJhU1OO6LNaNHXYWUSzPLrozA8qos7jYpevZTik4ec6
         a4iRBoVvaxIubgBwOPBYQwxPA/E38lv8ZMq0sRPiL9s/AadEYdv6JBPMYeTQ3INnnskK
         o6KK5+uE2BWdRtlw9EQ7pSU5E+DgjqdH4Kvm+Ney032znbwhndoDhNQjxequU4tQ4Voh
         OP6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=m6BZChVtTK+UGAguzCWejrDqoYzu+Sz7AkPqPhtFZKg=;
        b=OC17FfMArh6mF4mdNxB9BjPQdH5DURrOTVV3cqGNO3Ti5m82MJPsXGWmr/3tQBmdkV
         F+i4uZMxqB2bROBVQcgackcUwj+1SY4FwkehzJRLI0mKgKKmn88RsHUg9AFyKWJlUl2W
         YCCwb8/NOU6wQ41gHl3FTdx+Ndv7hY4EEmG7fI9hDuDNZK1yHbqEFxFGsaQ4mSq88GUr
         /8LZtCxO7uqF1u2UoWhBzKVU2Fr7Rytudkv3fk4dHvGiowmTv0Zf4XeMIsi1+nNh9t5b
         GLdQDeAxwf66Kimtww19rEGMvH0pVau2dh4cVlb5E+YafeOn9+aA/+ZNKGNIfQnejXp/
         CQJA==
X-Gm-Message-State: ACgBeo3ZwxhdMJJ6GoMdMaO58dzAgpqt4zDIyXl/VlwyXcp7I4ZEPTeY
        w4zB/XCH/42ijL7Ffo0ueTdgCw==
X-Google-Smtp-Source: AA6agR7vPL2Z8ouhUC6TUJw5X2BMyKkEw7SV4WNLjx6dmi1X+sQu+SSVO1IcqNlbchQb5t1I458yLA==
X-Received: by 2002:a05:620a:24d4:b0:6bb:760:4b8f with SMTP id m20-20020a05620a24d400b006bb07604b8fmr13906896qkn.83.1661905939523;
        Tue, 30 Aug 2022 17:32:19 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id i1-20020a05620a248100b006b5e296452csm9508750qkn.54.2022.08.30.17.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 17:32:18 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oTBeU-00417Z-2C;
        Tue, 30 Aug 2022 21:32:18 -0300
Date:   Tue, 30 Aug 2022 21:32:18 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
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
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 15/15] vfio: Add struct device to vfio_device
Message-ID: <Yw6sEghuAm6OAXWE@ziepe.ca>
References: <20220827171037.30297-1-kevin.tian@intel.com>
 <20220827171037.30297-16-kevin.tian@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220827171037.30297-16-kevin.tian@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 28, 2022 at 01:10:37AM +0800, Kevin Tian wrote:
> From: Yi Liu <yi.l.liu@intel.com>
> 
> and replace kref. With it a 'vfio-dev/vfioX' node is created under the
> sysfs path of the parent, indicating the device is bound to a vfio
> driver, e.g.:
> 
> /sys/devices/pci0000\:6f/0000\:6f\:01.0/vfio-dev/vfio0
> 
> It is also a preparatory step toward adding cdev for supporting future
> device-oriented uAPI.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/vfio_main.c | 70 +++++++++++++++++++++++++++++++++-------
>  include/linux/vfio.h     |  6 ++--
>  2 files changed, 61 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 0c5d120aeced..9ad0cbb83f1c 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -46,6 +46,8 @@ static struct vfio {
>  	struct mutex			group_lock; /* locks group_list */
>  	struct ida			group_ida;
>  	dev_t				group_devt;
> +	struct class			*device_class;
> +	struct ida			device_ida;
>  } vfio;
>  
>  struct vfio_iommu_driver {
> @@ -524,11 +526,19 @@ EXPORT_SYMBOL_GPL(_vfio_alloc_device);
>   *
>   * Only vfio-ccw driver should call this interface.
>   */
> +static void vfio_device_release(struct device *dev);

Since you added this new function in patch 1, it would be nice to
place it in a way that avoids this forward reference in this patch

>  	ret = alloc_chrdev_region(&vfio.group_devt, 0, MINORMASK + 1, "vfio");

I think we should change this "vfio" string at this point, it is
really the group fd, so "vfio_group" ?

It only shows in procfs.

Jason
