Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D80E64621C
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 21:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiLGUII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 15:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiLGUIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 15:08:06 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4E663B95
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 12:08:04 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id q10so13425296qvt.10
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 12:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vr5WiCvTh3UIK/ZVLkYO3CxfyfQu9sqezzU1lem3qSI=;
        b=YCUg4PpbC8tWQcP/j2pX6xtXhkhIANkGRKqwa0o8UMps3pEfjeu5/R4N/tGf3nha2v
         CHvipOOXOXX3KqsLbyV5E6K4gQ1fvj6f2baLUE9My4QvRrN+EzRAoztf8iO0QBdU++QW
         VcALPMS+0FXsZdgsBC2tnHCZpqz0RoA6J145my+5ci8rOi8MjU05ML5Koaw30WwbnhtF
         dW1tx0K1qE5Z9Ae+uOAW7t0dpfckaNDalca944KTZRmEnnZwC6yASRPqvrNrYQBk9KCb
         9vXtSy1YbzDIzj608LLFV97I8x+9AMWk3g5re44m9SF1nGl4OLuf+n6KYOJDa+cjD28u
         Ll1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vr5WiCvTh3UIK/ZVLkYO3CxfyfQu9sqezzU1lem3qSI=;
        b=YqkO5xDeAJX+iqUMJ/lL4q0IWg1us6KN7E4klX0VVJh4tI+vp9USDv3rH0L8p+3/2q
         4FCfgYp8hBvfzBMNvt+gWzyE46epRV+RCbnJtNPrcAH6HAKkjZC+dRhfv7qpG5Lgpq5k
         TAAxDqGdM3Oh1t6olffJu0vonJNGKvGkh886xpU88XdEu6c4rY99D0KevFl8T1icn9d9
         zFtJtD7/dZl11iAMl2R1m/5uLtZ1dzjTvjeCBDc13y7me3QJffqRv3/Uyv3+wKhJrwP/
         H2z2gRuQQ5EeCwBz7RTvh7PX1nyCZrSte2dyoBWtXfJWC37maE0vgYx997mvZzOo0rLk
         R6PA==
X-Gm-Message-State: ANoB5pkCJwY2PeSn/5Xqwpq8klkEauRZcGGaQiUwcF8du/u6oC8AnAVu
        TmxFqsPpi9kU2Hsi5Nbf2lJNug==
X-Google-Smtp-Source: AA0mqf5w89FO6T+zn7AhtSpDQo0RQb6vBJBRzeDWVezZlB+35JGB8LIDTcRdxHgklWspWMK3KABlxg==
X-Received: by 2002:a0c:f94e:0:b0:4c7:5d3a:69bf with SMTP id i14-20020a0cf94e000000b004c75d3a69bfmr16196245qvo.9.1670443683420;
        Wed, 07 Dec 2022 12:08:03 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id bl12-20020a05620a1a8c00b006fbb4b98a25sm17638764qkb.109.2022.12.07.12.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 12:08:02 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p30i2-005Luz-2M;
        Wed, 07 Dec 2022 16:08:02 -0400
Date:   Wed, 7 Dec 2022 16:08:02 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Lei Rao <lei.rao@intel.com>, kbusch@kernel.org, axboe@fb.com,
        kch@nvidia.com, sagi@grimberg.me, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Message-ID: <Y5DyorZJPdtN5WcX@ziepe.ca>
References: <Y49k++D3i8DfLOLL@ziepe.ca>
 <20221206165503.GA8677@lst.de>
 <Y4+U3VR2LeEh2S7B@ziepe.ca>
 <20221207075415.GB2283@lst.de>
 <Y5CWVu08abcOuEQH@ziepe.ca>
 <20221207135203.GA22803@lst.de>
 <Y5CsH5PqMYAWYatw@ziepe.ca>
 <20221207163857.GB2010@lst.de>
 <Y5DOAKArjyfb6Mcz@ziepe.ca>
 <20221207183333.GA7049@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207183333.GA7049@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022 at 07:33:33PM +0100, Christoph Hellwig wrote:
> On Wed, Dec 07, 2022 at 01:31:44PM -0400, Jason Gunthorpe wrote:
> > > Sorry, I meant VF.  Your continued using of SR-IOV teminology now keeps
> > > confusing my mind so much that I start mistyping things.
> > 
> > Well, what words do you want to use?
> 
> The same I've used through this whole thread:  controlling and
> controlled function.
> 
> > So I don't think I've learned anything more about your objection.
> > 
> > "fundamentally broken" doesn't help
> 
> The objection is that:
> 
>  - in hardware fundamentally only the controlling funtion can
>    control live migration features on the controlled function,
>    because the controlled function is assigned to a VM which has
>    control over it.

Yes

However hisilicon managed to do their implementation without this, or
rather you could say their "controlling function" is a single MMIO BAR
page in their PCI VF and their "controlled function" is the rest of
the PCI VF.

>  - for the same reason there is no portable way to even find
>    the controlling function from a controlled function, unless
>    you want to equate PF = controlling and VF = controlled,
>    and even that breaks down in some corner cases

As you say, the kernel must know the relationship between
controlling->controlled. Nothing else is sane.

If the kernel knows this information then we can find a way for the
vfio_device to have pointers to both controlling and controlled
objects. I have a suggestion below.

>  - if you want to control live migration from the controlled
>    VM you need a new vfio subdriver for a function that has
>    absolutely no new functionality itself related to live
>    migration (quirks for bugs excepted).

I see it differently, the VFIO driver *is* the live migration
driver. Look at all the drivers that have come through and they are
99% live migration code. They have, IMHO, properly split the live
migration concern out of their controlling/PF driver and placed it in
the "VFIO live migration driver".

We've done a pretty good job of allowing the VFIO live migration
driver to pretty much just focus on live migration stuff and delegate
the VFIO part to library code.

Excepting quirks and bugs sounds nice, except we actually can't ignore
them. Having all the VFIO capabilities is exactly how we are fixing
the quirks and bugs in the first place, and I don't see your vision
how we can continue to do that if we split all the live migration code
into yet another subsystem.

For instance how do I trap FLR like mlx5 must do if the
drivers/live_migration code cannot intercept the FLR VFIO ioctl?

How do I mangle and share the BAR like hisilicon does?

Which is really why this is in VFIO in the first place. It actually is
coupled in practice, if not in theory.

> So by this architecture you build a convoluted mess where you need
> tons of vfio subdrivers that mostly just talk to the driver for the
> controlling function, which they can't even sanely discover.  That's
> what I keep calling fundamentally broken.

The VFIO live migration drivers will look basically the same if you
put them under drivers/live_migration. This cannot be considered a
"convoluted mess" as splitting things by subsystem is best-practice,
AFAIK.

If we accept that drivers/vfio can be the "live migration subsystem"
then lets go all the way and have the controlling driver to call
vfio_device_group_register() to create the VFIO char device for the
controlled function.

This solves the "sanely discover" problem because of course the
controlling function driver knows what the controlled function is and
it can acquire both functions before it calls
vfio_device_group_register().

This is actually what I want to do anyhow for SIOV-like functions and
VFIO. Doing it for PCI VFs (or related PFs) is very nice symmetry. I
really dislike that our current SRIOV model in Linux forces the VF to
instantly exist without a chance for the controlling driver to
provision it.

We have some challenges on how to do this in the kernel, but I think
we can overcome them. VFIO is ready for this thanks to all the
restructuring work we already did.

I'd really like to get away from VFIO having to do all this crazy
sysfs crap to activate its driver. I think there is a lot of appeal to
having, say, a nvmecli command that just commands the controlling
driver to provision a function, enable live migration, configure it
and then make it visible via VFIO. The same API regardless if the
underlying controlled function technology is PF/VF/SIOV.

At least we have been very interested in doing that for networking
devices.

Jason
