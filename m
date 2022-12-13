Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E31464BB61
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 18:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235828AbiLMRuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 12:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbiLMRuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 12:50:21 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AA6240BF
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 09:49:47 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id k185so15403880vsc.2
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 09:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DqUM+ax68zeF7mzrZWkiSzr04RQkjlAcu7L4ga5z5vQ=;
        b=ktRYLWBpOGbOKfZVS/0xpk76+a38y7Wpzto5CjLdt4788k8Y3bOGbtipl342O/g0hx
         TLD/pNbgM0dgC/LHlCcbCMdKiBf/0M/+7n/zflkBlTrk+PCKRbrrFsBaFrD6DOYVxiHp
         ZdqPaz4LeOpmfoaXf5jhCNuFZ8na5t8kNMpeb+3h152Y5XDbDPY6qXLG0O56LboT+A4w
         2NJ9WerWsjMmSMTT0Hco/TFw7geDjMFD/D9YaymwvI2cXBwTPGgcxWmOU/wmm2mn1Bdf
         uorQetiunr2GozfXGjySFaCH0Pq7DwrcePInpAqq3lv/O4ouZNj1X7BxmnlOFD9s8vJv
         b+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DqUM+ax68zeF7mzrZWkiSzr04RQkjlAcu7L4ga5z5vQ=;
        b=JBZZ/PVb0oV77yIawpcSyCF0iLVMfbgXTinDRAe9pu6mStwS6UCfq+f9UuH68WEcTz
         RV9+C1p997XEAjjYG0uXVA6CfZWaLwSabJeRsCQbhza6uN8s2zEkbbdD0P5gzm3UYDj0
         HiXpuaypjkJJ69jRZIgAMtqVsu9o7uaZR6aUhpMuK8KjcYTY65umk7Y0DVgpw7w/jLVb
         sLCMjX+Rf2E73mH8GRa6vdwRqgU8TipUM/mBBPuZ4Hwn5d5nOcUPZpYeecuWjO2nl/TS
         jApKSgn91qoMgNemwNKpL12jZ4jmausKMj1R/H0eMDRbCE7/7406VLRzREvJ82EvVq6I
         pUNQ==
X-Gm-Message-State: ANoB5plrHLb7+DQWhJdz+0frUXhgbpDy0mlqtOg6B8Em1r0SY5qj31WU
        6/fJqxnjtCIDAZIEg4G/a7ArsA==
X-Google-Smtp-Source: AA0mqf7YIh3+smLA9KO0wwiAj3WR2RyFhWmCYelRuDl0ZOT9GaC17ZkDDK5gZFzR7Sju/EDkQ3Lv4g==
X-Received: by 2002:a05:6102:94c:b0:3b0:78cc:bfaf with SMTP id a12-20020a056102094c00b003b078ccbfafmr14776004vsi.15.1670953786450;
        Tue, 13 Dec 2022 09:49:46 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-50-193.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.50.193])
        by smtp.gmail.com with ESMTPSA id bm25-20020a05620a199900b006fa4cac54a5sm8288324qkb.72.2022.12.13.09.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:49:45 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p59PV-00AKeD-1G;
        Tue, 13 Dec 2022 13:49:45 -0400
Date:   Tue, 13 Dec 2022 13:49:45 -0400
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
Message-ID: <Y5i7OWihTNCKXGEJ@ziepe.ca>
References: <Y5CWVu08abcOuEQH@ziepe.ca>
 <20221207135203.GA22803@lst.de>
 <Y5CsH5PqMYAWYatw@ziepe.ca>
 <20221207163857.GB2010@lst.de>
 <Y5DOAKArjyfb6Mcz@ziepe.ca>
 <20221207183333.GA7049@lst.de>
 <Y5DyorZJPdtN5WcX@ziepe.ca>
 <20221212075046.GB11162@lst.de>
 <Y5iFnw5i3vI9iMFY@ziepe.ca>
 <20221213160807.GA626@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213160807.GA626@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 13, 2022 at 05:08:07PM +0100, Christoph Hellwig wrote:
> On Tue, Dec 13, 2022 at 10:01:03AM -0400, Jason Gunthorpe wrote:
> > > So now we need to write a vfio shim for every function even if there
> > > is absolutely nothing special about that function?  Migrating really
> > > is the controlling functions behavior, and writing a new vfio bit
> > > for every controlled thing just does not scale.
> > 
> > Huh? "does not scale?" We are looking at boilerplates of around 20-30
> > lines to make a VFIO driver for a real PCI device. Why is that even
> > something we should worry about optimizing?
> 
> But we need a new driver for every controlled function now, which
> is very different from the classic VFIO model where we had one
> vfio_pci.

To be fair, mainly vfio_pci had that model. Other uses of VFIO have
device specific drivers already. We have the reset drivers in vfio
platform, and the mdevs already. SIOV drivers are coming and they will
not be general either. I know a few coming non-migration VFIO PCI
variant drivers as well to deal with HW issues.

Remember, we did a bunch of work to make this reasonable. Userspace
can properly probe the correct VFIO driver for the HW it wants to use,
just like normal devices. If we spawn the VFIO from the controlling
function then it obviously will bring the correct driver along too.

The mental model I have for VFIO is that every vfio_device has a
driver, and we have three "universal" drivers that wildcard match to
many devices (pci, fsl, and platform acpi reset). Otherwise VFIO is
like every other driver subsystem out there, with physical devices and
matching drivers that support them.

Creating drivers for HW is not a problem, that is what a driver
subsystem is for. We already invested effort in VFIO to make this
scalable.

> > And when you get into exciting future devices like SIOV you already
> > need to make a special VFIO driver anyhow.
> 
> You need to special support for it.  It's probably not another
> Linux driver but part of the parent one, though.

The designs we have done in mlx5 are split. The "parent" has just
enough shim to describe what the SIOV is in terms of a 'slice of the
parents resources' and then we layer another driver, located in the
proper subsystem, to operate that slice. VDPA makes a
/dev/virtio-whatever, VFIO would make a fake PCI function, mlx5 makes
a netdev, etc.

It is not so different from how a PF/VF relationship works, just that
the SIOV is described by a struct auxillary_device not a struct
pci_dev.

I don't really like implementing VFIO drivers outside drivers/vfio, I
think that has historically had bad outcomes in other subsystems.

> > So far 100% of the drivers that have been presented, including the two
> > RFC ones, have entanglements between live migration and vfio. Shifting
> > things to dev/live_migration doesn't make the "communication problem"
> > away, it just shifted it into another subsystem.
> 
> The main entanglement seems to be that it needs to support a vfio
> interface for live migration while the actual commands go to the
> parent device.

Not at all, that is only a couple function calls in 4 of the drivers
so far.

The entanglement is that the live migration FSM and the VFIO device
operation are not isolated. I keep repeating this - mlx5 and the two
RFC drivers must trap VFIO operations and relay them to their
migration logic. hns has to mangle its BARs. These are things that
only exist on the VFIO side.

So, you are viewing live migration as orthogonal and separable to
VFIO, and I don't agree with this because I haven't yet seen any proof
in implementations.

Let's go through the nvme spec process and see how it works out. If
NVMe can address things which are tripping up other implemenations,
like FLR of the controlled function. Then we may have the first
example. If not, then it is just how things are.

FLR is trickey, it not obvious to me that you want a definition of
migration that isolates controlled function FLR from the migration
FSM..

There are advantages to having a reliable, universal, way to bring a
function back to a clean slate, including restoring it to full
operation (ie canceling any migration operation). The current
definition of FLR provides this.

> > It is worse than just VFIO vs one kernel driver, like mlx5 could spawn
> > a controlled function that is NVMe, VDPA, mlx5, virtio-net, VFIO,
> > etc.
> 
> This seems to violate the PCIe spec, which says:
> 
> "All VFs associated with a PF must be the same device type as the PF,
> (e.g., the same network device type or the same storage device type.)",

For VFs there are multiple PFs to follow the above, and for SIOV this
language doesn't apply.

It seems the PDS RFC driver does violate this spec requirement though..

> > When we create the function we really want to tell the device what
> > kind of function it is, and that also tells the kernel what driver
> > should be bound to it.
> 
> I'd rather have different ways to probe by passing a "kind" or "type"
> argument along the device IDs during probing.  E.g. "driver"
> and "vfio", and then only match for the kind the creator of the device
> added them to the device model for. 

Not everything can be done during driver probing. There are certainly
steps at SIOV instantiation time or VF provisioning that impact what
exactly is available on the controlled function. Eg on mlx5 when we
create a VDPA device it actually is different from a full-function
mlx5 device and that customization was done before any driver was
probed.

In fact, not only is it done before driver binding, but it can be
enforced as a security property from the DPU side when the DPU is the
thing creating the function.

I like the general idea of type to help specify the driver to probe,
we tried to work on something like that once and it didn't go far, but
I did like the concept of it.

> > mlx5 even has weird limitations, like a controlled function that is
> > live migration capable has fewer features than a function that is
> > not. So the user must specify what parameters it wants the controlled
> > function to have..
> 
> I don't think that is weird.  If you want to live migrate, you need to
> 
>  a) make sure the feature set is compatible with the other side
>  b) there is only state that actually is migratable
> 
> so I'd expect that for any other sufficiently complex device.  NVMe
> for sure will have limits like this.

Oy, this has been pretty hard to define in mlx5 already :( Hopefully
nvme-cli can sort it out for NVMe configurables.

Jason
