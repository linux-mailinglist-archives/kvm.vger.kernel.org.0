Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5463F623144
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 18:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiKIRTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 12:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiKIRTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 12:19:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C5E20BD9
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 09:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668014294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xnXgn16clICsmrV6UyAUvoxroMB/57yAi6UKnX9zn/8=;
        b=WndcJS31A/P1ODA6rTNvkj8ScMzPivQmeCG6ltyPMuPO1g1swQy+xgmfyc8m8Zz2ZYqiMY
        ZamY13c6wvzFLt/XVdu232RdK3iv4UdrxV8m2NXNjELaIAabZonkYufPMCv/CH1/k39iXz
        2JcrNuO1py88L9Pyi31Gxyu1TY8uSY0=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-237-JZg4tAd8M1qBHU4aWQm-UQ-1; Wed, 09 Nov 2022 12:18:13 -0500
X-MC-Unique: JZg4tAd8M1qBHU4aWQm-UQ-1
Received: by mail-io1-f72.google.com with SMTP id c23-20020a6b4e17000000b006db1063fc9aso6249124iob.14
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 09:18:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xnXgn16clICsmrV6UyAUvoxroMB/57yAi6UKnX9zn/8=;
        b=U/L4Ecw22q5t5nTUTIK/CSbigUHQ2yauiBtezzy5ePIqqDcjwPKqAr6lH1LR8eC7+0
         zlDJ7H+4tnVtLvf2XYk3NbkO7OxD9iQ1/7M8+jS/AaqWAWXzv5XcrrzK7k4pdj6DPJ13
         J0qGtVwm6bDiqrwk9w0pNYhOkpNrOqX71LV3LdljvBGdQ2Pus7WE5X4xcR1oZO7xhAWb
         /E2eyhCgQDfmf3bPNWT6+jfWanH0lBj3l2lM9euj2KiBfartp6s14v4YrZF2ikweBfJo
         GPdVleY5DO+pmaFgz04Y10MhLcMaoZ1WNe135s0rQA5wVKCZT1nmV30dTYpJkAg6nsNc
         TspQ==
X-Gm-Message-State: ACrzQf2iRlCy81oqEe+x4wVHONL6udqp3QLpRjN6Jn8JRZzw3Bl01lTs
        ImYA01K3gV11Sv+vaNe/n5M2UgEU66IHqyNTWyx0oFNnwo/hpekI0RhG48YwaP9KTZ00uOEoA+F
        e2kJq5D6KGs9u
X-Received: by 2002:a6b:e208:0:b0:6d7:b1a7:c220 with SMTP id z8-20020a6be208000000b006d7b1a7c220mr1771061ioc.7.1668014292520;
        Wed, 09 Nov 2022 09:18:12 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6F677E3Z9Fik/IZx4pkrsVOrB6N7Pz805qwA6pjiuY0YCpqNr/AQzfBn6PMq3gQd7YTPJ/wA==
X-Received: by 2002:a6b:e208:0:b0:6d7:b1a7:c220 with SMTP id z8-20020a6be208000000b006d7b1a7c220mr1771033ioc.7.1668014292281;
        Wed, 09 Nov 2022 09:18:12 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i12-20020a056e02152c00b00300e6efca96sm5020565ilu.55.2022.11.09.09.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 09:18:11 -0800 (PST)
Date:   Wed, 9 Nov 2022 10:18:09 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@gmail.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, iommu@lists.linux.dev,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Longfang Liu <liulongfang@huawei.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 10/11] vfio: Make vfio_container optionally compiled
Message-ID: <20221109101809.2ff08303.alex.williamson@redhat.com>
In-Reply-To: <Y2r6YnhuR3SxslL6@nvidia.com>
References: <0-v2-65016290f146+33e-vfio_iommufd_jgg@nvidia.com>
        <10-v2-65016290f146+33e-vfio_iommufd_jgg@nvidia.com>
        <20221108152831.1a2ed3df.alex.williamson@redhat.com>
        <Y2r6YnhuR3SxslL6@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Nov 2022 20:54:58 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Nov 08, 2022 at 03:28:31PM -0700, Alex Williamson wrote:
> 
> > Perhaps this should have been obvious, but I'm realizing that
> > vfio-noiommu mode is completely missing without VFIO_CONTAINER, which
> > seems a barrier to deprecating VFIO_CONTAINER and perhaps makes it a  
> 
> Yes, it is the same as the allow_unsafe_interrupts - it is something
> that currently goes missing if you turn off VFIO_CONTAINER.
> 
> This seems straightforward enough to resolve in a followup, we mostly
> just need someone with an existing no-iommu application to test
> compatability against. Keeping it working with the device cdev will
> also be a bit interesting. If you have or know about some application
> I can try to make a patch.

DPDK supports no-iommu mode.

> > question whether IOMMUFD should really be taking over /dev/vfio/vfio.
> > No-iommu mode has users.    
> 
> I view VFIO_CONTAINER=n as a process. An aspiration we can work
> toward.
> 
> At this point there are few places that might want to use it. Android
> perhaps, for example. It is also useful for testing. One of the main
> values is you can switch the options and feed the kernel into an
> existing test environment and see what happens. This is how we are
> able to quickly get s390 mdev testing, for instance.
> 
> We are not going to get to a widely useful VFIO_CONTAINER=n if we
> don't have a target that people can test against and evaluate what
> compatability gaps may exist.
> 
> So, everytime we find something like this - let's think about how can
> we make iommufd compatibility handle it and not jump straight to
> giving up :)
> 
> I'm kind of thinking v6.4 might be a reasonable kernel target when we
> might have closed off enough things.

I agree that it's very useful for testing, I'm certainly not suggesting
to give up, but I'm not sure where no-iommu lives when iommufd owns
/dev/vfio/vfio.  Given the unsafe interrupts discussion, it doesn't
seem like the type of thing that would be a priority for iommufd.

We're on a path where vfio accepts an iommufd as a container, and
ultimately iommufd becomes the container provider, supplanting the
IOMMU driver registration aspect of vfio.  I absolutely want type1 and
spapr backends to get replaced by iommufd, but reluctance to support
aspects of vfio "legacy" behavior doesn't give me warm fuzzies about a
wholesale hand-off of the container to a different subsystem, for
example vs an iommufd shim spoofing type1 support.

Unfortunately we no longer have a CONFIG_EXPERIMENTAL option to hide
behind for disabling VFIO_CONTAINER, so regardless of our intentions
that a transition is some time off, it may become an issue sooner than
we expect.  Thanks,

Alex

