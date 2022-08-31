Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621A95A840E
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 19:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiHaRQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 13:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiHaRQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 13:16:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60272B181
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 10:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661966117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3wNDRJb+y9GkEb33I7HiMe0aeP3rl6XFj5xgf5bJFgc=;
        b=b7wsog1x/991oo6422DmCbdsN+DI1gYzVgH6IFVSYVZmv/yuUeUTX2k07JC71yPJHWS5d5
        t4qswtBS0aGeDxu9aF8uxltfixIWCfFlEz7PBM3tRHONB2Nr8NeOho4+DlmApr1wgvqwUg
        AF+Yih/bV5zQZu6kPkAeSSs0m/AI7Mc=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-29-6dgw9EKfPvO9hpshys8iWw-1; Wed, 31 Aug 2022 13:15:15 -0400
X-MC-Unique: 6dgw9EKfPvO9hpshys8iWw-1
Received: by mail-il1-f200.google.com with SMTP id h8-20020a92c268000000b002e95299cff0so11040005ild.23
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 10:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=3wNDRJb+y9GkEb33I7HiMe0aeP3rl6XFj5xgf5bJFgc=;
        b=YyhhhBCu7Skfm/+a+5Sgreb8kpTat1kOPG0QG3TTu4/wrsaUdJUGslPdPhsMo1f5SN
         22isXU4XGQamAhMcD/tmBF+VyXt7VAtwMLe/VaBa/fN1P9cMIObjZLAsKcxGb9gClSqj
         4m8KvZZgiQZDI0nI/vgwxVBNiSA4rZdjDVnXQYZ2tb3YA0qU7j/tTipJGW0EpVx54nuq
         U4pDHksJp4NEAz32A+rrbBkV2CrrkiEu2PgYwb8vEu02GsdihPS3Vy8X4U/BRNbR3Ih3
         7eaY7bAAy1iuVYBNoa9wRV+70A3PjbBTTgO5SSmRfx0LJ7cI3QkqnP9X+/lpu6SeBS1J
         RBJQ==
X-Gm-Message-State: ACgBeo0cR0fB4f1yKKp0XUoi4SFbeQQSD51860BmrHlHh6f8H8tvvs6R
        zUxof5cdJCLzD55X8xrLmojP58AUIjZJRsPtwRWAnSlnYQU5nO4oY7Ad237bnXcXnJSK7GgtJws
        CkI95zLUmTEmh
X-Received: by 2002:a05:6638:dd4:b0:349:ebfd:e705 with SMTP id m20-20020a0566380dd400b00349ebfde705mr15532675jaj.4.1661966114827;
        Wed, 31 Aug 2022 10:15:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7UqftyvxL/mEDNedrHFErMBY8p1pSeatls/DmKqtUta1ABwUYFXwUlUJQ1689Lfg3tEQsWAQ==
X-Received: by 2002:a05:6638:dd4:b0:349:ebfd:e705 with SMTP id m20-20020a0566380dd400b00349ebfde705mr15532650jaj.4.1661966114600;
        Wed, 31 Aug 2022 10:15:14 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u190-20020a0223c7000000b00343617e8368sm7084182jau.99.2022.08.31.10.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 10:15:14 -0700 (PDT)
Date:   Wed, 31 Aug 2022 11:15:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        "Peter Oberparleiter" <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        Longfang Liu <liulongfang@huawei.com>,
        "Shameer Kolothum" <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 15/15] vfio: Add struct device to vfio_device
Message-ID: <20220831111512.4924e152.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276BF3B8D65B66DB292CAE58C789@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220827171037.30297-1-kevin.tian@intel.com>
        <20220827171037.30297-16-kevin.tian@intel.com>
        <20220830161838.4aa47045.alex.williamson@redhat.com>
        <Yw6i7btDKcUDPADP@ziepe.ca>
        <BN9PR11MB5276BF3B8D65B66DB292CAE58C789@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Aug 2022 06:10:51 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > Sent: Wednesday, August 31, 2022 7:53 AM
> > 
> > On Tue, Aug 30, 2022 at 04:18:38PM -0600, Alex Williamson wrote:  
> > > On Sun, 28 Aug 2022 01:10:37 +0800
> > > Kevin Tian <kevin.tian@intel.com> wrote:
> > >  
> > > > From: Yi Liu <yi.l.liu@intel.com>
> > > >
> > > > and replace kref. With it a 'vfio-dev/vfioX' node is created under the
> > > > sysfs path of the parent, indicating the device is bound to a vfio
> > > > driver, e.g.:
> > > >
> > > > /sys/devices/pci0000\:6f/0000\:6f\:01.0/vfio-dev/vfio0
> > > >
> > > > It is also a preparatory step toward adding cdev for supporting future
> > > > device-oriented uAPI.  
> > >
> > > Shall we start Documentation/ABI/testing/vfio-dev now?  Thanks.  
> > 
> > I always thought that was something to use when adding new custom
> > sysfs attributes?
> > 
> > Here we are just creating a standard struct device with its standard
> > sysfs?
> >   
> 
> There is nothing special for vfio-dev/vfioX. But from pci device p.o.v
> this does introduce a custom node in the directory, which is probably
> what Alex referred to?

Yup, but not just for pci, we're adding a node into the device
directory for any device bound to vfio.

> Anyway if required following can be introduced:
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-vfio-dev b/Documentation/ABI/testing/sysfs-devices-vfio-dev
> new file mode 100644
> index 000000000000..dfe8baaf1ccb
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-devices-vfio-dev
> @@ -0,0 +1,8 @@
> +What:		 /sys/.../<device>/vfio-dev/vfioX/
> +Date:		 September 2022
> +Contact:	 Yi Liu <yi.l.liu@intel.com>
> +Description:
> +		 This directory is created when the device is bound to a
> +		 vfio driver. The layout under this directory matches what
> +		 exists for a standard 'struct device'. 'X' is a random
> +		 number marking this device in vfio.

It's not really random, it's a unique index.  Seems like a good
starting point.

> 
> At the start I thought it might make more sense to add it into an
> existing vfio ABI file. But looks it doesn't exist.
> 
> Curious why nobody asked for ABI doc for /dev/vfio/vfio, /sys/class/vfio, etc...

Oversight, there should probably be a sysfs-class-vfio file.  Thanks,

Alex

