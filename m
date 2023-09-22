Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7FA7AB088
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 13:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbjIVLY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 07:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjIVLY0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 07:24:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3778F
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 04:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695381815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JVAoseet3AOqAGeef+zNpGtmDE6kNFQXHwi00L96/hM=;
        b=C1a3bs5pEigktwAIPDN/FFuRlIKCnLsztNhuaxsqPc+tXhO6b1Xo/oIMEkNBH8kMWE6k3u
        DqzuKb1z1FCq4/BZyB9twHEyEKpQvvluKh/yGDWEeyfRY8YKX7x1Tzv7c8b1d+WQ0RW3WE
        jYsqKOaFt5RWBY8swJql+6vQe7ZeNJU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-ahuKtvRTOsGFBTV_Zk_D-w-1; Fri, 22 Sep 2023 07:23:34 -0400
X-MC-Unique: ahuKtvRTOsGFBTV_Zk_D-w-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9ae12311183so160136366b.2
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 04:23:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695381813; x=1695986613;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JVAoseet3AOqAGeef+zNpGtmDE6kNFQXHwi00L96/hM=;
        b=qMrhGCv5YYsMgJItF/slRahgW7Cs0axL+dKxSWOpkJNLTNYjTx4cfMKXEpvlNI1Sb7
         oZj5xJ/BlLRSHyCFG7RyniV19rPM/LCvVBYpoVrPtIhE69dYTwFtkqVa5tNzKQTc/GB+
         nM+TqcNqvXOEGPLDTB1UguvpfcOtr8YGomA5hO1hVjmU8JZpjxZfbSZLJ9POsucnAs/Q
         MFAfY2jX2or2sVFobvUBhqNMfKFvmWaizFmuj7wto2EnP7WqnyXK0Vvr64FrBkPqqCrC
         T5hvQjbj2tfD1UAb2XcBtB2+esp9NRH/G5JlR3roUTPJ8HRtmu3TQhFpyI9Y1pkQbrOw
         /AbQ==
X-Gm-Message-State: AOJu0Yyg4jSzPIibXnDGcnmo8EXVxXNvkjRjc2957qMk706ww+1JrrrR
        ktY+w+8ClJnUXUdUaKV/6NUrE67xTspTEn5Wu3/UGI2nymvKPrjJHRXlp7JMWj8uIrCX5t/mImC
        DCUoZvt4942pw
X-Received: by 2002:a17:906:cc:b0:9ae:6ad0:f6cd with SMTP id 12-20020a17090600cc00b009ae6ad0f6cdmr2803699eji.24.1695381813341;
        Fri, 22 Sep 2023 04:23:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFnlzjtlZL5Pyn2UrVjxRnnxkpoy5t/qU9mxSKBZinwSUOqHTcJUWBux+71zBO1jVhNsfwIQ==
X-Received: by 2002:a17:906:cc:b0:9ae:6ad0:f6cd with SMTP id 12-20020a17090600cc00b009ae6ad0f6cdmr2803687eji.24.1695381812983;
        Fri, 22 Sep 2023 04:23:32 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id m5-20020a1709062b8500b009928b4e3b9fsm2544958ejg.114.2023.09.22.04.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 04:23:32 -0700 (PDT)
Date:   Fri, 22 Sep 2023 07:23:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922064957-mutt-send-email-mst@kernel.org>
References: <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com>
 <20230921163421-mutt-send-email-mst@kernel.org>
 <20230921225526.GE13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921225526.GE13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 07:55:26PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2023 at 04:45:45PM -0400, Michael S. Tsirkin wrote:
> > On Thu, Sep 21, 2023 at 04:49:46PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Sep 21, 2023 at 03:13:10PM -0400, Michael S. Tsirkin wrote:
> > > > On Thu, Sep 21, 2023 at 03:39:26PM -0300, Jason Gunthorpe wrote:
> > > > > On Thu, Sep 21, 2023 at 12:53:04PM -0400, Michael S. Tsirkin wrote:
> > > > > > > vdpa is not vfio, I don't know how you can suggest vdpa is a
> > > > > > > replacement for a vfio driver. They are completely different
> > > > > > > things.
> > > > > > > Each side has its own strengths, and vfio especially is accelerating
> > > > > > > in its capability in way that vpda is not. eg if an iommufd conversion
> > > > > > > had been done by now for vdpa I might be more sympathetic.
> > > > > > 
> > > > > > Yea, I agree iommufd is a big problem with vdpa right now. Cindy was
> > > > > > sick and I didn't know and kept assuming she's working on this. I don't
> > > > > > think it's a huge amount of work though.  I'll take a look.
> > > > > > Is there anything else though? Do tell.
> > > > > 
> > > > > Confidential compute will never work with VDPA's approach.
> > > > 
> > > > I don't see how what this patchset is doing is different
> > > > wrt to Confidential compute - you trap IO accesses and emulate.
> > > > Care to elaborate?
> > > 
> > > This patch series isn't about confidential compute, you asked about
> > > the future. VFIO will support confidential compute in the future, VDPA
> > > will not.
> > 
> > Nonsense it already works.
> 
> That isn't what I'm talking about. With a real PCI function and TDISP
> we can actually DMA directly from the guest's memory without needing
> the ugly bounce buffer hack. Then you can get decent performance.

Aha, TDISP.  But that one clearly does not need and can not use
this kind of hack?

> > But I did not ask about the future since I do not believe it
> > can be confidently predicted. I asked what is missing in VDPA
> > now for you to add this feature there and not in VFIO.
> 
> I don't see that VDPA needs this, VDPA should process the IO BAR on
> its own with its own logic, just like everything else it does.

First there's some logic here such as translating legacy IO
offsets to modern ones that could be reused.

But also, this is not just IO BAR, that indeed can be easily done in
software.  When a device operates in legacy mode there are subtle
differences with modern mode such as a different header size for the net
device.

> This is specifically about avoiding mediation by relaying directly the
> IO BAR operations to the device itself.
> 
> That is the entire irony, this whole scheme was designed and
> standardized *specifically* to avoid complex mediation and here you
> are saying we should just use mediation.
> 
> Jason

Not exactly. What I had in mind is just having the logic in
the vdpa module so users don't need to know what does the device
support and what it doesn't. If we can we bypass mediation
(to simplify the software stack) if we can not we do not.

Looking at it from user's POV, it is just super confusing that
card ABC would need to be used with VDPA to drive legacy while
card DEF needs to be used with VFIO. And both VFIO and VDPA
will happily bind, too. Oh man ...


-- 
MST

