Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900B151040A
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 18:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353124AbiDZQsr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 12:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353188AbiDZQs2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 12:48:28 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2231B194B0E;
        Tue, 26 Apr 2022 09:44:50 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9527923A;
        Tue, 26 Apr 2022 09:44:50 -0700 (PDT)
Received: from lpieralisi (unknown [10.57.12.182])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 657163F73B;
        Tue, 26 Apr 2022 09:44:48 -0700 (PDT)
Date:   Tue, 26 Apr 2022 17:44:42 +0100
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Jake Oshins <jakeo@microsoft.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
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
Message-ID: <YmgheiPOApuiLcK6@lpieralisi>
References: <BYAPR21MB12705103ED8F2B7024A22438BFF49@BYAPR21MB1270.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR21MB12705103ED8F2B7024A22438BFF49@BYAPR21MB1270.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 21, 2022 at 06:26:36PM +0000, Dexuan Cui wrote:
> > From: Jake Oshins <jakeo@microsoft.com>
> > Sent: Wednesday, April 20, 2022 9:01 AM
> > To: Bjorn Helgaas <helgaas@kernel.org>; Dexuan Cui <decui@microsoft.com>
> > Cc: wei.liu@kernel.org; KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> > lorenzo.pieralisi@arm.com; bhelgaas@google.com;
> > linux-hyperv@vger.kernel.org; linux-pci@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Michael Kelley (LINUX)
> > <mikelley@microsoft.com>; robh@kernel.org; kw@linux.com; Alex Williamson
> > <alex.williamson@redhat.com>; .kvm@vger.kernel.org
> > Subject: RE: [EXTERNAL] Re: [PATCH] PCI: hv: Do not set
> > PCI_COMMAND_MEMORY to reduce VM boot time
> 
> I removed the "[EXTERNAL]" tag as it looks like that prevents the email from being
> archived properly. See this link for the archived email thread:
> https://lwn.net/ml/linux-kernel/20220419220007.26550-1-decui%40microsoft.com/
> 
> > > -----Original Message-----
> > > From: Bjorn Helgaas <helgaas@kernel.org>
> > > Sent: Wednesday, April 20, 2022 8:36 AM
> > > To: Dexuan Cui <decui@microsoft.com>
> > > Cc: wei.liu@kernel.org; KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > > <haiyangz@microsoft.com>; Stephen Hemminger
> > <sthemmin@microsoft.com>;
> > > lorenzo.pieralisi@arm.com; bhelgaas@google.com; linux-
> > > hyperv@vger.kernel.org; linux-pci@vger.kernel.org; linux-
> > > kernel@vger.kernel.org; Michael Kelley (LINUX) <mikelley@microsoft.com>;
> > > robh@kernel.org; kw@linux.com; Jake Oshins <jakeo@microsoft.com>; Alex
> > > Williamson <alex.williamson@redhat.com>; .kvm@vger.kernel.org
> 
> I removed the period from ".kvm@" so the KVM list is correctly Cc'd.
> 
> > > Subject: [EXTERNAL] Re: [PATCH] PCI: hv: Do not set
> > PCI_COMMAND_MEMORY
> > > to reduce VM boot time
> > >
> > > [+cc Alex, kvm in case this idea is applicable for more than just Hyper-V]
> 
> Alex, your comments are welcome!
> 
> > > On Tue, Apr 19, 2022 at 03:00:07PM -0700, Dexuan Cui wrote:
> > > > A VM on Azure can have 14 GPUs, and each GPU may have a huge MMIO
> > > BAR,
> > > > e.g. 128 GB. Currently the boot time of such a VM can be 4+ minutes,
> > > > and most of the time is used by the host to unmap/map the vBAR from/to
> > > > pBAR when the VM clears and sets the PCI_COMMAND_MEMORY bit: each
> > > > unmap/map operation for a 128GB BAR needs about 1.8 seconds, and the
> > > > pci-hyperv driver and the Linux PCI subsystem flip the
> > > > PCI_COMMAND_MEMORY bit eight times (see pci_setup_device() ->
> > > > pci_read_bases() and pci_std_update_resource()), increasing the boot
> > > > time by 1.8 * 8 = 14.4 seconds per GPU, i.e. 14.4 * 14 = 201.6 seconds in
> > total.
> > > >
> > > > Fix the slowness by not turning on the PCI_COMMAND_MEMORY in
> > > > pci-hyperv.c, so the bit stays in the off state before the PCI device
> > > > driver calls
> > > > pci_enable_device(): when the bit is off, pci_read_bases() and
> > > > pci_std_update_resource() don't cause Hyper-V to unmap/map the vBARs.
> > > > With this change, the boot time of such a VM is reduced by
> > > > 1.8 * (8-1) * 14 = 176.4 seconds.
> > > >
> > > > Tested-by: Boqun Feng (Microsoft) <boqun.feng@gmail.com>
> > > > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > > > Cc: Jake Oshins <jakeo@microsoft.com>
> > > > ---
> > > >  drivers/pci/controller/pci-hyperv.c | 17 +++++++++++------
> > > >  1 file changed, 11 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/drivers/pci/controller/pci-hyperv.c
> > > > b/drivers/pci/controller/pci-hyperv.c
> > > > index d270a204324e..f9fbbd8d94db 100644
> > > > --- a/drivers/pci/controller/pci-hyperv.c
> > > > +++ b/drivers/pci/controller/pci-hyperv.c
> > > > @@ -2082,12 +2082,17 @@ static void prepopulate_bars(struct
> > > hv_pcibus_device *hbus)
> > > >  				}
> > > >  			}
> > > >  			if (high_size <= 1 && low_size <= 1) {
> > > > -				/* Set the memory enable bit. */
> > > > -				_hv_pcifront_read_config(hpdev,
> > > PCI_COMMAND, 2,
> > > > -							 &command);
> > > > -				command |= PCI_COMMAND_MEMORY;
> > > > -				_hv_pcifront_write_config(hpdev,
> > > PCI_COMMAND, 2,
> > > > -							  command);
> > > > +				/*
> > > > +				 * No need to set the
> > > PCI_COMMAND_MEMORY bit as
> > > > +				 * the core PCI driver doesn't require the bit
> > > > +				 * to be pre-set. Actually here we intentionally
> > > > +				 * keep the bit off so that the PCI BAR probing
> > > > +				 * in the core PCI driver doesn't cause Hyper-V
> > > > +				 * to unnecessarily unmap/map the virtual
> > > BARs
> > > > +				 * from/to the physical BARs multiple times.
> > > > +				 * This reduces the VM boot time significantly
> > > > +				 * if the BAR sizes are huge.
> > > > +				 */
> > > >  				break;
> > > >  			}
> > > >  		}
> > > > --
> > > > 2.17.1
> > > >
> > 
> > My question about this, directed at the people who know a lot more about the
> > PCI subsystem in Linux than I do (Bjorn, Alex, etc.), is whether this change can
> > create a problem.
> 
> Bjorn, Lorenzo, Alex, it would be nice to have your insights!
> 
> > In a physical computer, you might sometimes want to move
> > a device from one part of address space to another, typically when another
> > device is being hot-added to the system.  Imagine a scenario where you have,
> > in this case a VM, and there are perhaps 15 NVMe SSDs passed through to the
> > VM.  One of them dies and so it is removed.  The replacement SSD has a
> > larger BAR than the one that was removed (because it's a different SKU) and
> > now it doesn't fit neatly into the hole that was vacated by the previous SSD.
> > 
> > In this case, will the kernel ever attempt to move some of the existing SSDs to
> > make room for the new one?  And if so, does this come with the requirement
> > that they actually get mapped out of the address space while they are being
> > moved?  (This was the scenario that prompted me to write the code above as
> > it was, originally.)
> > 
> > Thanks,
> > Jake Oshins
> 
> Sorry I don't quite follow. pci-hyperv allocates MMIO for the bridge
> window in hv_pci_allocate_bridge_windows() and registers the MMIO
> ranges to the core PCI driver via pci_add_resource(), and later the
> core PCI driver probes the bus/device(s), validates the BAR sizes and
> the pre-initialized BAR values, and uses the BAR configuration. IMO
> the whole process doesn't require the bit PCI_COMMAND_MEMORY to be
> pre-set, and there should be no issue to delay setting the bit to a
> PCI device device's .probe() -> pci_enable_device().

IIUC you want to bootstrap devices with PCI_COMMAND_MEMORY clear
(otherwise PCI core would toggle it on and off for eg BAR sizing).

Is that correct ?

If I read PCI core correctly PCI_COMMAND_MEMORY is obviously cleared
only if it is set in the first place and that's what your patch is
changing, namely you boostrap your devices with PCI_COMMAND_MEMORY
clear so that PCI core does not touch it.

I am not familiar with Hyper-V code so forgive me the question.

Thanks,
Lorenzo

> 
> When a device is removed, hv_eject_device_work() -> 
> pci_stop_and_remove_bus_device() triggers the PCI device driver's .remove(),
> which calls pci_disable_device(), which instructs the hypervisor to unmap
> the vBAR from the pBAR, so there should not be any issue when a new device
> is added later. 
> 
> With the patch, if no PCI device driver is loaded, the PCI_COMMAND_MEMORY
> bit stays in the off state, and the hypervisor doesn't map the vBAR to the pBAR.
> I don't see any issue with this.
> 
> hv_pci_allocate_bridge_windows() -> vmbus_allocate_mmio() makes sure
> that there is enough MMIO space for the devices on the bus, so the core
> PCI driver doesn't have to worry about any MMIO conflict issue.
> 
> Please let me know if I understood and answered the questions.
> 
> Thanks,
> -- Dexuan
> 
