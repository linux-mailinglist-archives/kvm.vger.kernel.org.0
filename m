Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F57E4819DA
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 06:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbhL3Fuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 00:50:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:43824 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhL3Fub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 00:50:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640843431; x=1672379431;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=KXuOX/fIjRw6cq87x8XrWa47aC5YUw54MMrguaJwe38=;
  b=W97DfXYkkHfd0jhVfJ2MjETu4bo8TjXQ5634Wri38bjB5O9b/07WHLih
   A9sbMZXWErDAjrNQF3EHLhrAwapSwaoC6coALzhIDS0xj5KR9VQO47xb6
   1pCPbo+KgmHdAWaYwW65TQQqZpEwjYc0cmsS5BbheSUvEZJQvilnpQf4o
   doDwKFpvPYCr9BxMypWBhJUEDYDoULCjsekMHHjlt2lF83JDItxMXNbj3
   ir3whWkzZizQyihJ4m0vOOu3s+RtSSVgFv9tXBKlAiQfhLnmNsnFMvuFh
   P0ZWwAMKAwDM0COAZTjKcQF32adcf7engH/KJh9DKcwuiXpeI/NXlH8iE
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="241423149"
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="241423149"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 21:50:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="524269916"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 29 Dec 2021 21:50:24 -0800
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 04/13] PCI: portdrv: Suppress kernel DMA ownership
 auto-claiming
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20211229211626.GA1701512@bhelgaas>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <1af0f6c6-c39b-c018-3ca1-20e778cb926b@linux.intel.com>
Date:   Thu, 30 Dec 2021 13:49:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211229211626.GA1701512@bhelgaas>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bjorn,

On 12/30/21 5:16 AM, Bjorn Helgaas wrote:
> On Fri, Dec 17, 2021 at 02:36:59PM +0800, Lu Baolu wrote:
>> IOMMU grouping on PCI necessitates that if we lack isolation on a bridge
>> then all of the downstream devices will be part of the same IOMMU group
>> as the bridge. The existing vfio framework allows the portdrv driver to
>> be bound to the bridge while its downstream devices are assigned to user
>> space. The pci_dma_configure() marks the iommu_group as containing only
>> devices with kernel drivers that manage DMA. Avoid this default behavior
>> for the portdrv driver in order for compatibility with the current vfio
>> policy.
> 
> A word about the isolation would be useful.  I think you're referring
> to some specific ACS controls, probably P2P Request Redirect?
> 
> I guess this is just a wording issue, but I think it's actually the
> *lack* of some ACS controls that forces us to put several devices in
> the same IOMMU group, isn't it?  It's not that we start with "IOMMU
> grouping" and that necessitates something else.
> 
> Maybe something like this?
> 
>    If a switch lacks ACS P2P Request Redirect (and possibly other
>    controls?), a device below the switch can bypass the IOMMU and DMA
>    directly to other devices below the switch, so all the downstream
>    devices must be in the same IOMMU group as the switch itself.

Yes. That's what it means from the perspective of PCI/PCIe. I will use
this in the next version. Thanks!

> 
>> The commit 5f096b14d421b ("vfio: Whitelist PCI bridges") extended above
>> policy to all kernel drivers of bridge class. This is not always safe.
>> For example, The shpchp_core driver relies on the PCI MMIO access for the
>> controller functionality. With its downstream devices assigned to the
>> userspace, the MMIO might be changed through user initiated P2P accesses
>> without any notification. This might break the kernel driver integrity
>> and lead to some unpredictable consequences.
>>
>> For any bridge driver, in order to avoiding default kernel DMA ownership
>> claiming, we should consider:
>>
>>   1) Does the bridge driver use DMA? Calling pci_set_master() or
>>      a dma_map_* API is a sure indicate the driver is doing DMA
>>
>>   2) If the bridge driver uses MMIO, is it tolerant to hostile
>>      userspace also touching the same MMIO registers via P2P DMA
>>      attacks?
>>
>> Conservatively if the driver maps an MMIO region at all, we can say that
>> it fails the test.
> 
> I'm not sure what all this explanation is telling me.  It says
> something done by 5f096b14d421 is not always safe, but this patch
> doesn't fix any of those unsafe things.
> 
> If it doesn't explain why we need this patch or how this patch works,
> I don't think we need it in the commit log.
> 
> Maybe this is an explanation for why you didn't set
> .suppress_auto_claim_dma_owner for shpc_driver?

You are right. This doesn't explain why this is needed and how it works.
It only explains why we don't do the same thing to other pci port
drivers. I will move this out of the commit message. Perhaps put it
in the cover letter or some patches for vifo.

> 
> Minor typos above:
>    s/in order to avoiding default/before avoiding default/
>    s/relies on the PCI MMIO access/relies on PCI MMIO access/
>    s/For example, The/For example, the/
>    s/is a sure indicate the/is a sure indication the/

Thank you! I will correct these.

> 
>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>> Suggested-by: Kevin Tian <kevin.tian@intel.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/pci/pcie/portdrv_pci.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
>> index 35eca6277a96..c48a8734f9c4 100644
>> --- a/drivers/pci/pcie/portdrv_pci.c
>> +++ b/drivers/pci/pcie/portdrv_pci.c
>> @@ -202,7 +202,10 @@ static struct pci_driver pcie_portdriver = {
>>   
>>   	.err_handler	= &pcie_portdrv_err_handler,
>>   
>> -	.driver.pm	= PCIE_PORTDRV_PM_OPS,
>> +	.driver		= {
>> +		.pm = PCIE_PORTDRV_PM_OPS,
>> +		.suppress_auto_claim_dma_owner = true,
>> +	},
>>   };
>>   
>>   static int __init dmi_pcie_pme_disable_msi(const struct dmi_system_id *d)
>> -- 
>> 2.25.1
>>

Best regards,
baolu
