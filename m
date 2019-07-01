Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA91F9CF
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 15:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfD3NU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 09:20:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24765 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfD3NU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 09:20:59 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E30473082163;
        Tue, 30 Apr 2019 13:20:57 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B75D2B3A5;
        Tue, 30 Apr 2019 13:20:52 +0000 (UTC)
Date:   Tue, 30 Apr 2019 07:20:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     Alistair Popple <alistair@popple.id.au>,
        linuxppc-dev@lists.ozlabs.org,
        Jose Ricardo Ziviani <joserz@linux.ibm.com>,
        kvm@vger.kernel.org, Sam Bobroff <sbobroff@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        kvm-ppc@vger.kernel.org,
        Piotr Jaroszynski <pjaroszynski@nvidia.com>,
        Leonardo Augusto =?UTF-8?B?R3VpbWFyw6Nlcw==?= Garcia 
        <lagarcia@br.ibm.com>, Reza Arbab <arbab@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH kernel v3] powerpc/powernv: Isolate NVLinks between
 GV100GL on Witherspoon
Message-ID: <20190430072047.7901751d@x1.home>
In-Reply-To: <cf35d5be-d0a3-aef3-d5eb-c2318ef7d92b@ozlabs.ru>
References: <20190411064844.8241-1-aik@ozlabs.ru>
        <4f7069cf-8c25-6fe1-42df-3b4af2d52172@ozlabs.ru>
        <da41cd35-32f6-043e-13ab-9a225c4e910a@ozlabs.ru>
        <5149814.2BROG1NTNO@townsend>
        <cf35d5be-d0a3-aef3-d5eb-c2318ef7d92b@ozlabs.ru>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 30 Apr 2019 13:20:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Apr 2019 16:14:35 +1000
Alexey Kardashevskiy <aik@ozlabs.ru> wrote:

> On 30/04/2019 15:45, Alistair Popple wrote:
> > Alexey,
> >   
> >>>>> +void pnv_try_isolate_nvidia_v100(struct pci_dev *bridge)
> >>>>> +{
> >>>>> +	u32 mask, val;
> >>>>> +	void __iomem *bar0_0, *bar0_120000, *bar0_a00000;
> >>>>> +	struct pci_dev *pdev;
> >>>>> +	u16 cmd = 0, cmdmask = PCI_COMMAND_MEMORY;
> >>>>> +
> >>>>> +	if (!bridge->subordinate)
> >>>>> +		return;
> >>>>> +
> >>>>> +	pdev = list_first_entry_or_null(&bridge->subordinate->devices,
> >>>>> +			struct pci_dev, bus_list);
> >>>>> +	if (!pdev)
> >>>>> +		return;
> >>>>> +
> >>>>> +	if (pdev->vendor != PCI_VENDOR_ID_NVIDIA)  
> > 
> > Don't you also need to check the PCIe devid to match only [PV]100 devices as 
> > well? I doubt there's any guarantee these registers will remain the same for 
> > all future (or older) NVIDIA devices.  
> 
> 
> I do not have the complete list of IDs and I already saw 3 different
> device ids and this only works for machines with ibm,npu/gpu/nvlinks
> properties so for now it works and for the future we are hoping to
> either have an open source nvidia driver or some small minidriver (also
> from nvidia, or may be a spec allowing us to write one) to allow
> topology discovery on the host so we would not depend on the skiboot's
> powernv DT.
> 
> > IMHO this should really be done in the device driver in the guest. A malcious 
> > guest could load a modified driver that doesn't do this, but that should not 
> > compromise other guests which presumably load a non-compromised driver that 
> > disables the links on that guests GPU. However I guess in practice what you 
> > have here should work equally well.  
> 
> Doing it in the guest means a good guest needs to have an updated
> driver, we do not really want to depend on this. The idea of IOMMU
> groups is that the hypervisor provides isolation irrespective to what
> the guest does.

+1 It's not the user/guest driver's responsibility to maintain the
isolation of the device.  Thanks,

Alex

> Also vfio+qemu+slof needs to convey the nvlink topology to the guest,
> seems like an unnecessary complication.
> 
> 
> 
> > - Alistair
> >   
> >>>>> +		return;
> >>>>> +
> >>>>> +	mask = nvlinkgpu_get_disable_mask(&pdev->dev);
> >>>>> +	if (!mask)
> >>>>> +		return;
> >>>>> +
> >>>>> +	bar0_0 = pci_iomap_range(pdev, 0, 0, 0x10000);
> >>>>> +	if (!bar0_0) {
> >>>>> +		pci_err(pdev, "Error mapping BAR0 @0\n");
> >>>>> +		return;
> >>>>> +	}
> >>>>> +	bar0_120000 = pci_iomap_range(pdev, 0, 0x120000, 0x10000);
> >>>>> +	if (!bar0_120000) {
> >>>>> +		pci_err(pdev, "Error mapping BAR0 @120000\n");
> >>>>> +		goto bar0_0_unmap;
> >>>>> +	}
> >>>>> +	bar0_a00000 = pci_iomap_range(pdev, 0, 0xA00000, 0x10000);
> >>>>> +	if (!bar0_a00000) {
> >>>>> +		pci_err(pdev, "Error mapping BAR0 @A00000\n");
> >>>>> +		goto bar0_120000_unmap;
> >>>>> +	}  
> >>>>
> >>>> Is it really necessary to do three separate ioremaps vs one that would
> >>>> cover them all here?  I suspect you're just sneaking in PAGE_SIZE with
> >>>> the 0x10000 size mappings anyway.  Seems like it would simplify setup,
> >>>> error reporting, and cleanup to to ioremap to the PAGE_ALIGN'd range
> >>>> of the highest register accessed. Thanks,  
> >>>
> >>> Sure I can map it once, I just do not see the point in mapping/unmapping
> >>> all 0xa10000>>16=161 system pages for a very short period of time while
> >>> we know precisely that we need just 3 pages.
> >>>
> >>> Repost?  
> >>
> >> Ping?
> >>
> >> Can this go in as it is (i.e. should I ping Michael) or this needs
> >> another round? It would be nice to get some formal acks. Thanks,
> >>  
> >>>> Alex
> >>>>  
> >>>>> +
> >>>>> +	pci_restore_state(pdev);
> >>>>> +	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
> >>>>> +	if ((cmd & cmdmask) != cmdmask)
> >>>>> +		pci_write_config_word(pdev, PCI_COMMAND, cmd | cmdmask);
> >>>>> +
> >>>>> +	/*
> >>>>> +	 * The sequence is from "Tesla P100 and V100 SXM2 NVLink Isolation on
> >>>>> +	 * Multi-Tenant Systems".
> >>>>> +	 * The register names are not provided there either, hence raw values.
> >>>>> +	 */
> >>>>> +	iowrite32(0x4, bar0_120000 + 0x4C);
> >>>>> +	iowrite32(0x2, bar0_120000 + 0x2204);
> >>>>> +	val = ioread32(bar0_0 + 0x200);
> >>>>> +	val |= 0x02000000;
> >>>>> +	iowrite32(val, bar0_0 + 0x200);
> >>>>> +	val = ioread32(bar0_a00000 + 0x148);
> >>>>> +	val |= mask;
> >>>>> +	iowrite32(val, bar0_a00000 + 0x148);
> >>>>> +
> >>>>> +	if ((cmd | cmdmask) != cmd)
> >>>>> +		pci_write_config_word(pdev, PCI_COMMAND, cmd);
> >>>>> +
> >>>>> +	pci_iounmap(pdev, bar0_a00000);
> >>>>> +bar0_120000_unmap:
> >>>>> +	pci_iounmap(pdev, bar0_120000);
> >>>>> +bar0_0_unmap:
> >>>>> +	pci_iounmap(pdev, bar0_0);
> >>>>> +}  
> > 
> >   
> 

