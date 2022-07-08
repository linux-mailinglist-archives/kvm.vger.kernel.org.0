Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C58D56BF44
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 20:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238794AbiGHQt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 12:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238650AbiGHQt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 12:49:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 73AC51E3FB
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 09:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657298966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MXdSVBidbMpMzS1rCTcLXDUZBptLZ/DAXk7Nw972YV8=;
        b=U3DNT1xoFNAanbqCVoP/KlbBTVnfii2D5PjRiGDGGDmRUU9YIModarzqMtpC2npsHvVBeB
        h4PMs0ojQbDcPfdA/k8bzzTxZhCNVhDdOt2wsaptEIdfKbEyCW5IxmfQBdyfV2wHiItKE5
        zoqzlTbnoYktHOhLt3vSnv5CvK6f5Ug=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-vq3oN3YwOQqgMbSjj6SXlA-1; Fri, 08 Jul 2022 12:49:25 -0400
X-MC-Unique: vq3oN3YwOQqgMbSjj6SXlA-1
Received: by mail-il1-f197.google.com with SMTP id n16-20020a056e02141000b002dabb875f0aso11310504ilo.10
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 09:49:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MXdSVBidbMpMzS1rCTcLXDUZBptLZ/DAXk7Nw972YV8=;
        b=rAZgXc2RO2KHTriq7jMki6Wcvo00POj8nXCgLh/tZDCoDhKAGVBOyOs/9lEPL/+8Lv
         puLNHgswuANXb0cwJedZB+eEEh8sdoaHwsbB4AVNLIqQICcGcgu7sVm+XQWvt596lyUp
         zOEPXblE3KzTA9pmKIU6RmQE7cU2UxCONJkb+d0XXq7V1YhKKj7zAKpmYzlHTM2384Mb
         oct7Ofe3Ay7NTcnh8x7T7Jth3fGUnH0Z9+Dud90LbZCdTL1aYHC0SYjio7GOb8rb+LBx
         uR0MBcBpEuLwGnm1MkEn6d2JyCZt50V9BjCcnPf8ZMhOf6Kw9FUu2MRjjjq3pmElkv2x
         4X7w==
X-Gm-Message-State: AJIora81wBPx8FvcQexqYk4BwiDXUVUp2y9QzcBh9WsVQCmPEH2n9tpb
        DBZQ7gJAJZzOrzEXzuy6eA7nDJ/RXNSP+HpsThu6g3+yCcGBXtufaqwEeQKIwBv/yq4MlfjJ9ur
        /xcAm+u5pcw7T
X-Received: by 2002:a92:c26d:0:b0:2dc:3f21:28fc with SMTP id h13-20020a92c26d000000b002dc3f2128fcmr2604942ild.242.1657298964673;
        Fri, 08 Jul 2022 09:49:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uS6H6Li4tWgDd7BtY0/IOmJRn2qf6PDT+ecBYl4qPbI9EMIbJHJK356anTA6ev91NnCZxKXw==
X-Received: by 2002:a92:c26d:0:b0:2dc:3f21:28fc with SMTP id h13-20020a92c26d000000b002dc3f2128fcmr2604930ild.242.1657298964407;
        Fri, 08 Jul 2022 09:49:24 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g42-20020a02852d000000b0033f1e23ab20sm1794025jai.125.2022.07.08.09.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 09:49:24 -0700 (PDT)
Date:   Fri, 8 Jul 2022 10:49:00 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v4 3/6] vfio: Increment the runtime PM usage count
 during IOCTL call
Message-ID: <20220708104900.1780b8d7.alex.williamson@redhat.com>
In-Reply-To: <47aa6b7d-e529-b79a-54eb-5f5a7fe639d6@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
        <20220701110814.7310-4-abhsahu@nvidia.com>
        <20220706094007.12c33d63.alex.williamson@redhat.com>
        <47aa6b7d-e529-b79a-54eb-5f5a7fe639d6@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Jul 2022 15:13:16 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> On 7/6/2022 9:10 PM, Alex Williamson wrote:
> > On Fri, 1 Jul 2022 16:38:11 +0530
> > Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >   
> >> The vfio-pci based driver will have runtime power management
> >> support where the user can put the device into the low power state
> >> and then PCI devices can go into the D3cold state. If the device is
> >> in the low power state and the user issues any IOCTL, then the
> >> device should be moved out of the low power state first. Once
> >> the IOCTL is serviced, then it can go into the low power state again.
> >> The runtime PM framework manages this with help of usage count.
> >>
> >> One option was to add the runtime PM related API's inside vfio-pci
> >> driver but some IOCTL (like VFIO_DEVICE_FEATURE) can follow a
> >> different path and more IOCTL can be added in the future. Also, the
> >> runtime PM will be added for vfio-pci based drivers variant currently,
> >> but the other VFIO based drivers can use the same in the
> >> future. So, this patch adds the runtime calls runtime-related API in
> >> the top-level IOCTL function itself.
> >>
> >> For the VFIO drivers which do not have runtime power management
> >> support currently, the runtime PM API's won't be invoked. Only for
> >> vfio-pci based drivers currently, the runtime PM API's will be invoked
> >> to increment and decrement the usage count.  
> > 
> > Variant drivers can easily opt-out of runtime pm support by performing
> > a gratuitous pm-get in their device-open function.
> >    
> 
>  Do I need to add this line in the commit message?

Maybe I misinterpreted, but my initial read was that there was some
sort of opt-in, which there is by providing pm-runtime support in the
driver, which vfio-pci-core does for all vfio-pci variant drivers.  But
there's also an opt-out, where a vfio-pci variant driver might not want
to support pm-runtime support and could accomplish that by bumping the
pm reference count on device-open such that the user cannot trigger a
pm-suspend.

> >> Taking this usage count incremented while servicing IOCTL will make
> >> sure that the user won't put the device into low power state when any
> >> other IOCTL is being serviced in parallel. Let's consider the
> >> following scenario:
> >>
> >>  1. Some other IOCTL is called.
> >>  2. The user has opened another device instance and called the power
> >>     management IOCTL for the low power entry.
> >>  3. The power management IOCTL moves the device into the low power state.
> >>  4. The other IOCTL finishes.
> >>
> >> If we don't keep the usage count incremented then the device
> >> access will happen between step 3 and 4 while the device has already
> >> gone into the low power state.
> >>
> >> The runtime PM API's should not be invoked for
> >> VFIO_DEVICE_FEATURE_POWER_MANAGEMENT since this IOCTL itself performs
> >> the runtime power management entry and exit for the VFIO device.  
> > 
> > I think the one-shot interface I proposed in the previous patch avoids
> > the need for special handling for these feature ioctls.  Thanks,
> >   
> 
>  Okay. So, for low power exit case (means feature GET ioctl in the
>  updated case) also, we will trigger eventfd. Correct?

If all ioctls are wrapped in pm-get/put, then the pm feature exit ioctl
would wakeup and signal the eventfd via the pm-get.  I'm not sure if
it's worthwhile to try to surprise this eventfd.  Do you foresee any
issues?  Thanks,

Alex

