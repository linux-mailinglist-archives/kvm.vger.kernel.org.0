Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D516452B88
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 08:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhKPH2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 02:28:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:2876 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229965AbhKPH1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 02:27:36 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="231097161"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="231097161"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 23:24:38 -0800
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="454348387"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.215.107]) ([10.254.215.107])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 23:24:32 -0800
Message-ID: <4f95bea7-3c1c-4f12-aed5-a3fcdcd3fee3@linux.intel.com>
Date:   Tue, 16 Nov 2021 15:24:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        rafael@kernel.org, Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20211115204459.GA1585166@bhelgaas>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH 04/11] PCI: portdrv: Suppress kernel DMA ownership
 auto-claiming
In-Reply-To: <20211115204459.GA1585166@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bjorn,

On 2021/11/16 4:44, Bjorn Helgaas wrote:
> On Mon, Nov 15, 2021 at 10:05:45AM +0800, Lu Baolu wrote:
>> IOMMU grouping on PCI necessitates that if we lack isolation on a bridge
>> then all of the downstream devices will be part of the same IOMMU group
>> as the bridge.
> 
> I think this means something like: "If a PCIe Switch Downstream Port
> lacks <a specific set of ACS capabilities>, all downstream devices
> will be part of the same IOMMU group as the switch," right?

For this patch, yes.

> 
> If so, can you fill in the details to make it specific and concrete?

The existing vfio implementation allows a kernel driver to bind with a
PCI bridge while its downstream devices are assigned to the user space
though there lacks ACS-like isolation in bridge.

drivers/vfio/vfio.c:
  540 static bool vfio_dev_driver_allowed(struct device *dev,
  541                                     struct device_driver *drv)
  542 {
  543         if (dev_is_pci(dev)) {
  544                 struct pci_dev *pdev = to_pci_dev(dev);
  545
  546                 if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
  547                         return true;
  548         }

We are moving the group viability check to IOMMU core, and trying to
make it compatible with the current vfio policy. We saw three types of
bridges:

#1) PCIe/PCI-to-PCI bridges
     These bridges are configured in the PCI framework, there's no
     dedicated driver for such devices.

#2) Generic PCIe switch downstream port
     The port driver doesn't map and access any MMIO in the PCI BAR.
     The iommu group is viable to user even this driver is bound.

#3) Hot Plug Controller
     The controller driver maps and access the device MMIO. The iommu
     group is not viable to user with this driver bound to its device.

>> As long as the bridge kernel driver doesn't map and
>> access any PCI mmio bar, it's safe to bind it to the device in a USER-
>> owned group. Hence, safe to suppress the kernel DMA ownership auto-
>> claiming.
> 
> s/mmio/MMIO/ (also below)
> s/bar/BAR/ (also below)

Sure.

> 
> I don't understand what "kernel DMA ownership auto-claiming" means.
> Presumably that's explained in previous patches and a code comment
> near "suppress_auto_claim_dma_owner".

When a device driver is about to bind with a device, the driver core
will claim the kernel DMA ownership automatically for the driver.

This implies that
- if success, the kernel driver is controlling the device for DMA. Any
   devices sitting in the same iommu group shouldn't be assigned to user.
- if failure, some devices sitting in the same iommu group have already
   been assigned to user space. The driver binding process should abort.

But there are some exceptions where suppress_auto_claim_dma_owner comes
to play.

#1) vfio-like drivers which will assign the devices to user space after
     driver binding;
#2) (compatible with exiting vfio policy) some drivers are allowed to be
     bound with a device while its siblings in the iommu group are
     assigned to user space. Typically, these drivers include
     - pci_stub driver
     - pci bridge drivers

For above drivers, we use driver.suppress_auto_claim_dma_owner as a hint
to tell the driver core to ignore the kernel dma ownership claiming.

> 
>> The commit 5f096b14d421b ("vfio: Whitelist PCI bridges") permitted a
>> class of kernel drivers.
> 
> Permitted them to do what?

As I explained above.

> 
>> This is not always safe. For example, the SHPC
>> system design requires that it must be integrated into a PCI-to-PCI
>> bridge or a host bridge.
> 
> If this SHPC example is important, it would be nice to have a citation
> to the spec section that requires this.

I just used it as an example to show that allowing any driver to be
bound to a PCI bridge device in a USER-viable iommu group is too loose.

> 
>> The shpchp_core driver relies on the PCI mmio
>> bar access for the controller functionality. Binding it to the device
>> belonging to a USER-owned group will allow the user to change the
>> controller via p2p transactions which is unknown to the hot-plug driver
>> and could lead to some unpredictable consequences.
>>
>> Now that we have driver self-declaration of safety we should rely on that.
> 
> Can you spell out what drivers are self-declaring?  Are they declaring
> that they don't program their devices to do DMA?

Sure. Set driver.suppress_auto_claim_dma_owner = true.

> 
>> This change may cause regression on some platforms, since all bridges were
>> exempted before, but now they have to be manually audited before doing so.
>> This is actually the desired outcome anyway.
> 
> Please spell out what regression this may cause and how users would
> recognize it.  Also, please give a hint about why that is desirable.

Sure.

Before this series, bridge drivers are always allowed to be bound with
PCI/PCIe bridge which is sitting in an iommu group assigned to user
space. After this, only those drivers which have
suppress_auto_claim_dma_owner set could be done so. Otherwise, the
driver binding or group user assignment will fail.

The criteria of what kind of drivers could have this hint set is "driver
doesn't map and access the MMIO define in the PCI BARs".

> 
>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>> Suggested-by: Kevin Tian <kevin.tian@intel.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/pci/pcie/portdrv_pci.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
>> index 35eca6277a96..1285862a9aa8 100644
>> --- a/drivers/pci/pcie/portdrv_pci.c
>> +++ b/drivers/pci/pcie/portdrv_pci.c
>> @@ -203,6 +203,8 @@ static struct pci_driver pcie_portdriver = {
>>   	.err_handler	= &pcie_portdrv_err_handler,
>>   
>>   	.driver.pm	= PCIE_PORTDRV_PM_OPS,
>> +
>> +	.driver.suppress_auto_claim_dma_owner = true,
>>   };
>>   
>>   static int __init dmi_pcie_pme_disable_msi(const struct dmi_system_id *d)
>> -- 
>> 2.25.1
>>

Best regards,
baolu
