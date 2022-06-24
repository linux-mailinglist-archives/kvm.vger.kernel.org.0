Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52806559E14
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 18:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiFXQEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 12:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiFXQEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 12:04:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 229FE49903
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 09:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656086692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ln1Z2E1M7p8doCl1L1YnM9NdRf2Z0FbPrSaV1f2IMzE=;
        b=E9V3fR12hLP99ec6uCVDDY6Qv/9q47k5/oi0uBKSbLntp45ibHXeI5NsTNeJPxnGZ1YxiQ
        ArzM1axWsXdGxMQhhiIbWh1RAY2LzcEAdu1B/Y1/bAYwvhV1aelWE35Y8U53asnHXNW0yq
        KBM/vZTDIDCWmtnHKuoktRaqR4Fkra8=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-NbuHYjn5M6muJaQF1lNI3g-1; Fri, 24 Jun 2022 12:04:51 -0400
X-MC-Unique: NbuHYjn5M6muJaQF1lNI3g-1
Received: by mail-il1-f198.google.com with SMTP id n14-20020a056e021bae00b002d92c91da8aso1647770ili.15
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 09:04:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Ln1Z2E1M7p8doCl1L1YnM9NdRf2Z0FbPrSaV1f2IMzE=;
        b=Tquzc7Db9W5ABoLDGv8oPdL+svHx08s+Vk6DyTsDryfJtDOnmb7z9eTtr7DYcq4uSo
         IGuoVrL1ZBYM990b3Ym5VonAhd575QD0Jz4TlGxLsnV2toBohxSogneyW4i5z2Fdx215
         I2oSQ6hqK7HbGj2kkUnSGHnFfqJ8LwXVYNBKtJa9gFFgkXjyRYG8wmNAxeUn/dQPAYyL
         9JPdPIuuDsW9WL2kjVMqKGSuKiExjXlW0nmfzzFfxkiyXZFz7ZojJpVdmqn9WcRA1AhT
         ANaqgo37CPNVxduuetAokNrMYjlrE1MWBEvsoovmiNxzGtwy7HVg2AljHcB+vf6uyWCa
         JeEQ==
X-Gm-Message-State: AJIora+VjQ8meNqHHJjZDFqBra7VngUmEavLTbniPPnGKHC4sXXzWp9K
        hhTRFxSy1sfyTM6PnqF4VWc/96XTTyeW+bV+4CDOfDwiG2pn+9WqPPTKEADViR5WUxwKclSSSs8
        AQaMSXbjaa5yz
X-Received: by 2002:a05:6638:300e:b0:335:c73c:3d25 with SMTP id r14-20020a056638300e00b00335c73c3d25mr8993394jak.77.1656086689942;
        Fri, 24 Jun 2022 09:04:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tkLdQdoyXEGpgj4BclSWirmWj1t+0EzYv/auBwq1GquIs3qt+6zmVH3RnW4cPTN1eyU02Q0Q==
X-Received: by 2002:a05:6638:300e:b0:335:c73c:3d25 with SMTP id r14-20020a056638300e00b00335c73c3d25mr8993376jak.77.1656086689538;
        Fri, 24 Jun 2022 09:04:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a30-20020a027a1e000000b00339c67df872sm1216387jac.129.2022.06.24.09.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 09:04:49 -0700 (PDT)
Date:   Fri, 24 Jun 2022 10:04:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, cohuck@redhat.com,
        iommu@lists.linux.dev, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vfio/type1: Simplify bus_type determination
Message-ID: <20220624100447.4ec983fb.alex.williamson@redhat.com>
In-Reply-To: <42679e49-4a04-4700-f420-f6ffe0f4b7d1@arm.com>
References: <b1d13cade281a7d8acbfd0f6a33dcd086207952c.1655898523.git.robin.murphy@arm.com>
        <20220622161721.469fc9eb.alex.williamson@redhat.com>
        <68263bd7-4528-7acb-b11f-6b1c6c8c72ef@arm.com>
        <20220623170044.1757267d.alex.williamson@redhat.com>
        <20220624015030.GJ4147@nvidia.com>
        <20220624081159.508baed3.alex.williamson@redhat.com>
        <20220624141836.GS4147@nvidia.com>
        <20220624082831.22de3d51.alex.williamson@redhat.com>
        <42679e49-4a04-4700-f420-f6ffe0f4b7d1@arm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Jun 2022 16:12:55 +0100
Robin Murphy <robin.murphy@arm.com> wrote:

> On 2022-06-24 15:28, Alex Williamson wrote:
> > On Fri, 24 Jun 2022 11:18:36 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> >> On Fri, Jun 24, 2022 at 08:11:59AM -0600, Alex Williamson wrote:  
> >>> On Thu, 23 Jun 2022 22:50:30 -0300
> >>> Jason Gunthorpe <jgg@nvidia.com> wrote:
> >>>      
> >>>> On Thu, Jun 23, 2022 at 05:00:44PM -0600, Alex Williamson wrote:
> >>>>      
> >>>>>>>> +struct vfio_device *vfio_device_get_from_iommu(struct iommu_group *iommu_group)
> >>>>>>>> +{
> >>>>>>>> +	struct vfio_group *group = vfio_group_get_from_iommu(iommu_group);
> >>>>>>>> +	struct vfio_device *device;  
> >>>>>>>
> >>>>>>> Check group for NULL.  
> >>>>>>
> >>>>>> OK - FWIW in context this should only ever make sense to call with an
> >>>>>> iommu_group which has already been derived from a vfio_group, and I did
> >>>>>> initially consider a check with a WARN_ON(), but then decided that the
> >>>>>> unguarded dereference would be a sufficiently strong message. No problem
> >>>>>> with bringing that back to make it more defensive if that's what you prefer.  
> >>>>>
> >>>>> A while down the road, that's a bit too much implicit knowledge of the
> >>>>> intent and single purpose of this function just to simply avoid a test.  
> >>>>
> >>>> I think we should just pass the 'struct vfio_group *' into the
> >>>> attach_group op and have this API take that type in and forget the
> >>>> vfio_group_get_from_iommu().  
> >>>
> >>> That's essentially what I'm suggesting, the vfio_group is passed as an
> >>> opaque pointer which type1 can use for a
> >>> vfio_group_for_each_vfio_device() type call.  Thanks,  
> >>
> >> I don't want to add a whole vfio_group_for_each_vfio_device()
> >> machinery that isn't actually needed by anything.. This is all
> >> internal, we don't need to design more than exactly what is needed.
> >>
> >> At this point if we change the signature of the attach then we may as
> >> well just pass in the representative vfio_device, that is probably
> >> less LOC overall.  
> > 
> > That means that vfio core still needs to pick an arbitrary
> > representative device, which I find in fundamental conflict to the
> > nature of groups.  Type1 is the interface to the IOMMU API, if through
> > the IOMMU API we can make an assumption that all devices within the
> > group are equivalent for a given operation, that should be done in type1
> > code, not in vfio core.  A for-each interface is commonplace and not
> > significantly more code or design than already proposed.  Thanks,  
> 
> It also occurred to me this morning that there's another middle-ground 
> option staring out from the call-wrapping notion I mentioned yesterday - 
> while I'm not keen to provide it from the IOMMU API, there's absolutely 
> no reason that VFIO couldn't just use the building blocks by itself, and 
> in fact it works out almost absurdly simple:
> 
> static bool vfio_device_capable(struct device *dev, void *data)
> {
> 	return device_iommu_capable(dev, (enum iommu_cap)data);
> }
> 
> bool vfio_group_capable(struct iommu_group *group, enum iommu_cap cap)
> {
> 	return iommu_group_for_each_dev(group, (void *)cap, vfio_device_capable);
> }
> 
> and much the same for iommu_domain_alloc() once I get that far. The 
> locking concern neatly disappears because we're no longer holding any 
> bus or device pointer that can go stale. How does that seem as a 
> compromise for now, looking forward to Jason's longer-term view of 
> rearranging the attach_group process such that a vfio_device falls 
> naturally to hand?

Yup, that seems like another way to do it, a slight iteration on the
current bus_type flow, and also avoids any sort of arbitrary
representative device being passed around as an API.

For clarity of the principle that all devices within the group should
have the same capabilities, we could even further follow the existing
bus_type and do a sanity test here at the same time, or perhaps simply
stop after the first device to avoid the if-any-device-is-capable
semantics implied above.  Thanks,

Alex

