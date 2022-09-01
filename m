Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2045A8B32
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 04:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbiIACGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 22:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIACF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 22:05:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948727962A
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 19:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661997957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Uc9eSniapYBlyChWU+AZI0xqtO1iDX5hC1kW3YMyLk=;
        b=hIsGtrnsSUPnPskoXOk+xXH12hhdTVUEWcM09lotc8eVqGCjHCmIjal937YbdiPXn3FQ/b
        GXFk41btq54jFxCidyNq3Zcd3Ic/7+FJ1LlXswwDB4HlxuM0ue60+ddMUDOWv+uD0oLjI/
        xuXsn3OxVrjkjMIFORpis9QKjdELRac=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-383-pPvGncVHMeu2af4xJy3PEQ-1; Wed, 31 Aug 2022 22:05:56 -0400
X-MC-Unique: pPvGncVHMeu2af4xJy3PEQ-1
Received: by mail-il1-f200.google.com with SMTP id a4-20020a056e0208a400b002e4621942dfso11801828ilt.0
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 19:05:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=/Uc9eSniapYBlyChWU+AZI0xqtO1iDX5hC1kW3YMyLk=;
        b=hSoNZPB29HI9hTBqYydK1grixdnqyTzO2lSQIg4ynvPlRzci4hxiYiyj5si6mQz0Dy
         PcPYKsNXUnbxX+2rdI8VtXMc5wRSDpq1WeGebupZFslOb8GmcH4QAc11essxJtpUJSTh
         nG5zy7vtddeGuY06R/Y4N2cC1fGddPR1EKEtLJ1bFz8CB7yif2GZCpo+YA+UP1Kom0zr
         cx2/0ZaUSgeSdqNSiZ1wNm3t1urlSyGoJiDgjSJU4nwG9hqMy1q6h6vkOt3V4hXJk1NP
         Wuu1glwvF6TFWzUJ+1H/PsC2zKcn61ov0JemNSjQYqzS2E/mwwaFnjV1kFDhYxgVmm+J
         rlDQ==
X-Gm-Message-State: ACgBeo0C4SepUfVts7NNTF0hImEwRpg441MatkePW3YTl1QxtzAgypM7
        PqogyzJc7cxKs9erReUjeiPW/HwYP6OLbBHnk4oDM7LTNgz1Vc7mIioCW+yCUOZQ4tCxTDfeFdb
        B/z/K8uqA7c06
X-Received: by 2002:a02:caa6:0:b0:349:bbca:9a90 with SMTP id e6-20020a02caa6000000b00349bbca9a90mr16413104jap.203.1661997955678;
        Wed, 31 Aug 2022 19:05:55 -0700 (PDT)
X-Google-Smtp-Source: AA6agR69HUeX58FMkYxODUyoKw5kYP6agdJ53j1pRzyBTmGQRYpiiEtOoSguPX68IkBTLGR0Abgyow==
X-Received: by 2002:a02:caa6:0:b0:349:bbca:9a90 with SMTP id e6-20020a02caa6000000b00349bbca9a90mr16413094jap.203.1661997955449;
        Wed, 31 Aug 2022 19:05:55 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u7-20020a02b1c7000000b0034293459b44sm7434106jah.142.2022.08.31.19.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 19:05:55 -0700 (PDT)
Date:   Wed, 31 Aug 2022 20:05:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
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
Message-ID: <20220831200552.12169ae3.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB527652B0557897BDA08B5FE38C7B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220827171037.30297-1-kevin.tian@intel.com>
        <20220827171037.30297-16-kevin.tian@intel.com>
        <20220830161838.4aa47045.alex.williamson@redhat.com>
        <Yw6i7btDKcUDPADP@ziepe.ca>
        <BN9PR11MB5276BF3B8D65B66DB292CAE58C789@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220831111512.4924e152.alex.williamson@redhat.com>
        <BN9PR11MB527652B0557897BDA08B5FE38C7B9@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On Thu, 1 Sep 2022 00:46:51 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, September 1, 2022 1:15 AM
> > 
> > On Wed, 31 Aug 2022 06:10:51 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >   
> > > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > > Sent: Wednesday, August 31, 2022 7:53 AM
> > > >
> > > > On Tue, Aug 30, 2022 at 04:18:38PM -0600, Alex Williamson wrote:  
> > > > > On Sun, 28 Aug 2022 01:10:37 +0800
> > > > > Kevin Tian <kevin.tian@intel.com> wrote:
> > > > >  
> > > > > > From: Yi Liu <yi.l.liu@intel.com>
> > > > > >
> > > > > > and replace kref. With it a 'vfio-dev/vfioX' node is created under the
> > > > > > sysfs path of the parent, indicating the device is bound to a vfio
> > > > > > driver, e.g.:
> > > > > >
> > > > > > /sys/devices/pci0000\:6f/0000\:6f\:01.0/vfio-dev/vfio0
> > > > > >
> > > > > > It is also a preparatory step toward adding cdev for supporting future
> > > > > > device-oriented uAPI.  
> > > > >
> > > > > Shall we start Documentation/ABI/testing/vfio-dev now?  Thanks.  
> > > >
> > > > I always thought that was something to use when adding new custom
> > > > sysfs attributes?
> > > >
> > > > Here we are just creating a standard struct device with its standard
> > > > sysfs?
> > > >  
> > >
> > > There is nothing special for vfio-dev/vfioX. But from pci device p.o.v
> > > this does introduce a custom node in the directory, which is probably
> > > what Alex referred to?  
> > 
> > Yup, but not just for pci, we're adding a node into the device
> > directory for any device bound to vfio.
> >   
> > > Anyway if required following can be introduced:
> > >
> > > diff --git a/Documentation/ABI/testing/sysfs-devices-vfio-dev  
> > b/Documentation/ABI/testing/sysfs-devices-vfio-dev  
> > > new file mode 100644
> > > index 000000000000..dfe8baaf1ccb
> > > --- /dev/null
> > > +++ b/Documentation/ABI/testing/sysfs-devices-vfio-dev
> > > @@ -0,0 +1,8 @@
> > > +What:		 /sys/.../<device>/vfio-dev/vfioX/
> > > +Date:		 September 2022
> > > +Contact:	 Yi Liu <yi.l.liu@intel.com>
> > > +Description:
> > > +		 This directory is created when the device is bound to a
> > > +		 vfio driver. The layout under this directory matches what
> > > +		 exists for a standard 'struct device'. 'X' is a random
> > > +		 number marking this device in vfio.  
> > 
> > It's not really random, it's a unique index.  Seems like a good
> > starting point.
> >   
> > >
> > > At the start I thought it might make more sense to add it into an
> > > existing vfio ABI file. But looks it doesn't exist.
> > >
> > > Curious why nobody asked for ABI doc for /dev/vfio/vfio, /sys/class/vfio,  
> > etc...
> > 
> > Oversight, there should probably be a sysfs-class-vfio file.  Thanks,
> >   
> 
> I can help add one.
> 
> btw I plan to respin v2 tomorrow. Regarding to this ABI thing there are
> three options:
> 
> 1) Just add sysfs-devices-vfio-dev in this series. Later merge to
>    sysfs-class-vfio once the latter is introduced in a separate patch.

This.  Thanks,

Alex

> 
> 2) Do sysfs-class-vfio in this series, including both existing vfio ABIs and
>    the new vfio-dev.
> 
> 3) No ABI file in this series. Handle it in a separate patch with
>    sysfs-class-vfio.
> 
> Which one do  you prefer to?
> 
> Thanks
> Kevin
> 

