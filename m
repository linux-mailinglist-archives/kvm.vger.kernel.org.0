Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC99513C09
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 21:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351373AbiD1TPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 15:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238779AbiD1TPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 15:15:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE269B3C75;
        Thu, 28 Apr 2022 12:12:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CA64B82F6E;
        Thu, 28 Apr 2022 19:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EE0C385A0;
        Thu, 28 Apr 2022 19:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651173137;
        bh=Z5QrtyPoKtr4EXTz5f8XYaD44MEJLtU/UpYiIT1zJhQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=InTqMwimwY/xTFEieuVIfeswQ0EoYsWCrDONLYTJLJQe3xAd7iMGaEPYN1qBRZS7q
         i1b7F7wFSFfr5pW+k1pHsP2+K1rGEWUXsgiifuLmsk1Z/yLnZ/NIWHfYlEznZCBqwd
         GYgkjGQ9NTzNa2yswmEWoaqy5eX5LBMFHMxw//ePSz5Ip0HfgGYJhaC6VM5d7e8Xk7
         eb/K72NLbZkTquWmEGRMzYUfcwgDQJS5dj4EzMDo41mYbbOyRHjE7KLxKTWj3KPhMb
         rXXg2VEMGBY97I+7LzkyhwJwMk/6/ysxPAJE8cx/YfUwG9mmLZ0itIViS62avreQDf
         75qKdG9k7Dz4w==
Date:   Thu, 28 Apr 2022 14:12:13 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jake Oshins <jakeo@microsoft.com>
Cc:     Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce VM boot
 time
Message-ID: <20220428191213.GA36573@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR2101MB0878E466880C047D3A0D0C92ABFB9@SN4PR2101MB0878.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 07:25:43PM +0000, Jake Oshins wrote:
> > -----Original Message-----
> > From: Dexuan Cui <decui@microsoft.com>
> > Sent: Tuesday, April 26, 2022 11:32 AM
> > To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Cc: Jake Oshins <jakeo@microsoft.com>; Bjorn Helgaas <helgaas@kernel.org>;
> > bhelgaas@google.com; Alex Williamson <alex.williamson@redhat.com>;
> > wei.liu@kernel.org; KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> > linux-hyperv@vger.kernel.org; linux-pci@vger.kernel.org; linux-
> > kernel@vger.kernel.org; Michael Kelley (LINUX) <mikelley@microsoft.com>;
> > robh@kernel.org; kw@linux.com; kvm@vger.kernel.org
> > Subject: RE: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce
> > VM boot time
> > 
> > > From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > > Sent: Tuesday, April 26, 2022 9:45 AM
> > > > ...
> > > > Sorry I don't quite follow. pci-hyperv allocates MMIO for the bridge
> > > > window in hv_pci_allocate_bridge_windows() and registers the MMIO
> > > > ranges to the core PCI driver via pci_add_resource(), and later the
> > > > core PCI driver probes the bus/device(s), validates the BAR sizes
> > > > and the pre-initialized BAR values, and uses the BAR configuration.
> > > > IMO the whole process doesn't require the bit PCI_COMMAND_MEMORY to
> > > > be pre-set, and there should be no issue to delay setting the bit to
> > > > a PCI device device's .probe() -> pci_enable_device().
> > >
> > > IIUC you want to bootstrap devices with PCI_COMMAND_MEMORY clear
> > > (otherwise PCI core would toggle it on and off for eg BAR sizing).
> > >
> > > Is that correct ?
> > 
> > Yes, that's the exact purpose of this patch.
> > 
> > Do you see any potential architectural issue with the patch?
> > From my reading of the core PCI code, it looks like this should be safe.

I don't know much about Hyper-V, but in general I don't think the PCI
core should turn on PCI_COMMAND_MEMORY at all unless a driver requests
it.  I assume that if a guest OS depends on PCI_COMMAND_MEMORY being
set, guest firmware would take care of setting it.

> > Jake has some concerns that I don't quite follow.
> > @Jake, could you please explain the concerns with more details?
> 
> First, let me say that I really don't know whether this is an issue.
> I know it's an issue with other operating system kernels.  I'm
> curious whether the Linux kernel / Linux PCI driver would behave in
> a way that has an issue here.
> 
> The VM has a window of address space into which it chooses to put
> PCI device's BARs.  The guest OS will generally pick the value that
> is within the BAR, by default, but it can theoretically place the
> device in any free address space.  The subset of the VM's memory
> address space which can be populated by devices' BARs is finite, and
> generally not particularly large.
> 
> Imagine a VM that is configured with 25 NVMe controllers, each of
> which requires 64KiB of address space.  (This is just an example.)
> At first boot, all of these NVMe controllers are packed into address
> space, one after the other.
> 
> While that VM is running, one of the 25 NVMe controllers fails and
> is replaced with an NVMe controller from a separate manufacturer,
> but this one requires 128KiB of memory, for some reason.  Perhaps it
> implements the "controller buffer" feature of NVMe.  It doesn't fit
> in the hole that was vacated by the failed NVMe controller, so it
> needs to be placed somewhere else in address space.  This process
> continues over months, with several more failures and replacements.
> Eventually, the address space is very fragmented.
> 
> At some point, there is an attempt to place an NVMe controller into
> the VM but there is no contiguous block of address space free which
> would allow that NVMe controller to operate.  There is, however,
> enough total address space if the other, currently functioning, NVMe
> controllers are moved from the address space that they are using to
> other ranges, consolidating their usage and reducing fragmentation.
> Let's call this a rebalancing of memory resources.
> 
> When the NVMe controllers are moved, a new value is written into
> their BAR.  In general, the PCI spec would require that you clear
> the memory enable bit in the command register (PCI_COMMAND_MEMORY)
> during this move operation, both so that there's never a moment when
> two devices are occupying the same address space and because writing
> a 64-bit BAR atomically isn't possible.  This is the reason that I
> originally wrote the code in this driver to unmap the device from
> the VM's address space when the memory enable bit is cleared.
> 
> What I don't know is whether this sequence of operations can ever
> happen in Linux, or perhaps in a VM running Linux.  Will it
> rebalance resources in order to consolidate address space?  If it
> will, will this involve clearing the memory enable bit to ensure
> that two devices never overlap?

This sequence definitely can occur in Linux, but it hasn't yet become
a real priority.  But we do already have issues with assigning space
for hot-added devices in general, especially if firmware hasn't
assigned large windows to things like Thunderbolt controllers.  I
suspect that we have or will soon have issues where resource
assignment starts failing after a few hotplugs, e.g., dock/undock
events.

There have been patches posted to rebalance resources (quiesce
drivers, reassign, restart drivers), but they haven't gone anywhere
yet for lack of interest and momentum.  I do feel like we're the
tracks and the train is coming, though ;)

Bjorn
