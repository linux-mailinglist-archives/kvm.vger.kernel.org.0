Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C44A6499BA
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 08:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiLLHuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 02:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiLLHuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 02:50:52 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80559B86B;
        Sun, 11 Dec 2022 23:50:51 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B334168AA6; Mon, 12 Dec 2022 08:50:46 +0100 (CET)
Date:   Mon, 12 Dec 2022 08:50:46 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>, Lei Rao <lei.rao@intel.com>,
        kbusch@kernel.org, axboe@fb.com, kch@nvidia.com, sagi@grimberg.me,
        alex.williamson@redhat.com, cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Message-ID: <20221212075046.GB11162@lst.de>
References: <20221206165503.GA8677@lst.de> <Y4+U3VR2LeEh2S7B@ziepe.ca> <20221207075415.GB2283@lst.de> <Y5CWVu08abcOuEQH@ziepe.ca> <20221207135203.GA22803@lst.de> <Y5CsH5PqMYAWYatw@ziepe.ca> <20221207163857.GB2010@lst.de> <Y5DOAKArjyfb6Mcz@ziepe.ca> <20221207183333.GA7049@lst.de> <Y5DyorZJPdtN5WcX@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5DyorZJPdtN5WcX@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022 at 04:08:02PM -0400, Jason Gunthorpe wrote:
> However hisilicon managed to do their implementation without this, or
> rather you could say their "controlling function" is a single MMIO BAR
> page in their PCI VF and their "controlled function" is the rest of
> the PCI VF.

Eww.  So you need to carefully filter the BAR and can't actually do
any DMA at all?  I'm not sure that is actually practical, especially
not for something with a lot of state.

> If the kernel knows this information then we can find a way for the
> vfio_device to have pointers to both controlling and controlled
> objects. I have a suggestion below.

So now we need to write a vfio shim for every function even if there
is absolutely nothing special about that function?  Migrating really
is the controlling functions behavior, and writing a new vfio bit
for every controlled thing just does not scale.

> I see it differently, the VFIO driver *is* the live migration
> driver. Look at all the drivers that have come through and they are
> 99% live migration code.

Yes, and that's the problem, because they are associated with the
controlled function, and now we have a communication problem between
that vfio driver binding to the controlled function and the drive
that actually controlls live migration that is associated with the
controlling function.  In other words: you've created a giant mess.

> Excepting quirks and bugs sounds nice, except we actually can't ignore
> them.

I'm not proposing to ignore them.  But they should not be needed most
of the time.

> For instance how do I trap FLR like mlx5 must do if the
> drivers/live_migration code cannot intercept the FLR VFIO ioctl?
> 
> How do I mangle and share the BAR like hisilicon does?
> 
> Which is really why this is in VFIO in the first place. It actually is
> coupled in practice, if not in theory.

So you've created a long term userspace API around working around
around buggy and/or misdesigned early designs and now want to force
it down everyones throat?

Can we please take a step back and think about how things should work,
and only then think how to work around weirdo devices that do strange
things as a second step? 

> If we accept that drivers/vfio can be the "live migration subsystem"
> then lets go all the way and have the controlling driver to call
> vfio_device_group_register() to create the VFIO char device for the
> controlled function.

While creating the VFs from the PF driver makes a lot more sense,
remember that vfio is absolutely not the only use case for VFs.
There are plenty use cases where you want to use them with the normal
kernel driver as well.  So the interface to create VFs needs a now
to decide if it should be vfio exported, or use the normal kernel
binding.

> This solves the "sanely discover" problem because of course the
> controlling function driver knows what the controlled function is and
> it can acquire both functions before it calls
> vfio_device_group_register().

Yes.

> This is actually what I want to do anyhow for SIOV-like functions and
> VFIO. Doing it for PCI VFs (or related PFs) is very nice symmetry. I
> really dislike that our current SRIOV model in Linux forces the VF to
> instantly exist without a chance for the controlling driver to
> provision it.

For SIOV you have no other choice anyway.  But I agree that it is
the right thing to do for VFIO.  Now the next step is to control
live migration from the controlling function, so that for most sane
devices the controlled device does not need all the pointless
boilerplate of its own vfio driver.

> I'd really like to get away from VFIO having to do all this crazy
> sysfs crap to activate its driver. I think there is a lot of appeal to
> having, say, a nvmecli command that just commands the controlling
> driver to provision a function, enable live migration, configure it
> and then make it visible via VFIO. The same API regardless if the
> underlying controlled function technology is PF/VF/SIOV.

Yes.
