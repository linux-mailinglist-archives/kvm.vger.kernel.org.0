Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F9964B946
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 17:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbiLMQIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 11:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235081AbiLMQIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 11:08:13 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD9C282;
        Tue, 13 Dec 2022 08:08:12 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C5A8867373; Tue, 13 Dec 2022 17:08:07 +0100 (CET)
Date:   Tue, 13 Dec 2022 17:08:07 +0100
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
Message-ID: <20221213160807.GA626@lst.de>
References: <20221207075415.GB2283@lst.de> <Y5CWVu08abcOuEQH@ziepe.ca> <20221207135203.GA22803@lst.de> <Y5CsH5PqMYAWYatw@ziepe.ca> <20221207163857.GB2010@lst.de> <Y5DOAKArjyfb6Mcz@ziepe.ca> <20221207183333.GA7049@lst.de> <Y5DyorZJPdtN5WcX@ziepe.ca> <20221212075046.GB11162@lst.de> <Y5iFnw5i3vI9iMFY@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5iFnw5i3vI9iMFY@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 13, 2022 at 10:01:03AM -0400, Jason Gunthorpe wrote:
> > So now we need to write a vfio shim for every function even if there
> > is absolutely nothing special about that function?  Migrating really
> > is the controlling functions behavior, and writing a new vfio bit
> > for every controlled thing just does not scale.
> 
> Huh? "does not scale?" We are looking at boilerplates of around 20-30
> lines to make a VFIO driver for a real PCI device. Why is that even
> something we should worry about optimizing?

But we need a new driver for every controlled function now, which
is very different from the classic VFIO model where we had one
vfio_pci.

> And when you get into exciting future devices like SIOV you already
> need to make a special VFIO driver anyhow.

You need to special support for it.  It's probably not another
Linux driver but part of the parent one, though.

> So far 100% of the drivers that have been presented, including the two
> RFC ones, have entanglements between live migration and vfio. Shifting
> things to dev/live_migration doesn't make the "communication problem"
> away, it just shifted it into another subsystem.

The main entanglement seems to be that it needs to support a vfio
interface for live migration while the actual commands go to the
parent device.

> This is my point, I've yet to even see a driver that meets your
> theoretical standard that it can exist without vfio entanglement.

It can't right now due to the VFIO design.

> > While creating the VFs from the PF driver makes a lot more sense,
> > remember that vfio is absolutely not the only use case for VFs.
> > There are plenty use cases where you want to use them with the normal
> > kernel driver as well.  So the interface to create VFs needs a now
> > to decide if it should be vfio exported, or use the normal kernel
> > binding.
> 
> Yes, that is why this problem has been open for so long. Fixing it
> well requires some reconsideration of how the driver core works :(
> 
> It is worse than just VFIO vs one kernel driver, like mlx5 could spawn
> a controlled function that is NVMe, VDPA, mlx5, virtio-net, VFIO,
> etc.

This seems to violate the PCIe spec, which says:

"All VFs associated with a PF must be the same device type as the PF,
(e.g., the same network device type or the same storage device type.)",

which is also enforced by not allowing to read vendor/device/class
fields from VFs.

(not that I'm arguing that this is a good limit, but that's how
PCIe does it).

> When we create the function we really want to tell the device what
> kind of function it is, and that also tells the kernel what driver
> should be bound to it.

I'd rather have different ways to probe by passing a "kind" or "type"
argument along the device IDs during probing.  E.g. "driver"
and "vfio", and then only match for the kind the creator of the device
added them to the device model for. 

> mlx5 even has weird limitations, like a controlled function that is
> live migration capable has fewer features than a function that is
> not. So the user must specify what parameters it wants the controlled
> function to have..

I don't think that is weird.  If you want to live migrate, you need to

 a) make sure the feature set is compatible with the other side
 b) there is only state that actually is migratable

so I'd expect that for any other sufficiently complex device.  NVMe
for sure will have limits like this.
