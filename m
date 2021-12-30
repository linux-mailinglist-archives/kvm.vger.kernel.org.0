Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0434819D4
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 06:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbhL3FfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 00:35:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:60427 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhL3FfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 00:35:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640842511; x=1672378511;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=JyIRfdKyDD8fBL5wItWhLvIY7ErrRHB7nNqaDZhNdD0=;
  b=SR3WXpGcrQZrwp0PcH21sjGaItIhmLbpIw4RIYD9IC8yOL3SvN9C8/qm
   5bu7ffZli5rgBMtSDEmx+lI6MjMUCZUKdJuF1k2seMTYZByQvRvjSgp9e
   Z2rnPV8CE0KOKtsbV0QXjohepwiOmy8qSQxqmBF1kRjax4JHQ3Xcp+Q+w
   NQQ479BQmP+VlCraaRosy00kgdVfW0JAIale7HCnkJcPE9ZRZVm6lBDHO
   Ot6yhT5TpnfnsChBZmEF/z1Fuk72wgY0gHfOHvfryu4aph1vMG6HYm21k
   H6PQP147PFqkkFF6M5IiZIqKGMdiwVJQLVvnmy+1SKu6wmmekdOYJ28md
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="228929801"
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="228929801"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 21:35:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="524266151"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 29 Dec 2021 21:34:58 -0800
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
Subject: Re: [PATCH v4 03/13] PCI: pci_stub: Suppress kernel DMA ownership
 auto-claiming
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20211229204202.GA1700874@bhelgaas>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <568b6d1d-69df-98ad-a864-dd031bedd081@linux.intel.com>
Date:   Thu, 30 Dec 2021 13:34:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211229204202.GA1700874@bhelgaas>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bjorn,

On 12/30/21 4:42 AM, Bjorn Helgaas wrote:
> On Fri, Dec 17, 2021 at 02:36:58PM +0800, Lu Baolu wrote:
>> The pci_dma_configure() marks the iommu_group as containing only devices
>> with kernel drivers that manage DMA.
> 
> I'm looking at pci_dma_configure(), and I don't see the connection to
> iommu_groups.

The 2nd patch "driver core: Set DMA ownership during driver bind/unbind"
sets all drivers' DMA to be kernel-managed by default except a few ones
which has a driver flag set. So by default, all iommu groups contains
only devices with kernel drivers managing DMA.

> 
>> Avoid this default behavior for the
>> pci_stub because it does not program any DMA itself.  This allows the
>> pci_stub still able to be used by the admin to block driver binding after
>> applying the DMA ownership to vfio.
> 
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/pci/pci-stub.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
>> index e408099fea52..6324c68602b4 100644
>> --- a/drivers/pci/pci-stub.c
>> +++ b/drivers/pci/pci-stub.c
>> @@ -36,6 +36,9 @@ static struct pci_driver stub_driver = {
>>   	.name		= "pci-stub",
>>   	.id_table	= NULL,	/* only dynamic id's */
>>   	.probe		= pci_stub_probe,
>> +	.driver		= {
>> +		.suppress_auto_claim_dma_owner = true,
> 
> The new .suppress_auto_claim_dma_owner controls whether we call
> iommu_device_set_dma_owner().  I guess you added
> .suppress_auto_claim_dma_owner because iommu_device_set_dma_owner()
> must be done *before* we call the driver's .probe() method?

As explained above, all drivers are set to kernel-managed dma by
default. For those vfio and vfio-approved drivers,
suppress_auto_claim_dma_owner is used to tell the driver core that "this
driver is attached to device for userspace assignment purpose, do not
claim it for kernel-management dma".

> 
> Otherwise, we could call some new interface from .probe() instead of
> adding the flag to struct device_driver.

Most device drivers are of the kernel-managed DMA type. Only a few vfio
and vfio-approved drivers need to use this flag. That's the reason why
we claim kernel-managed DMA by default.

> 
>> +	},
>>   };
>>   
>>   static int __init pci_stub_init(void)
>> -- 
>> 2.25.1
>>

Best regards,
baolu
