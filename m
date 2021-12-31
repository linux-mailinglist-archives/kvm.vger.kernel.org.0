Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6EE48212A
	for <lists+kvm@lfdr.de>; Fri, 31 Dec 2021 02:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242451AbhLaBHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 20:07:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:1292 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237396AbhLaBHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 20:07:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640912839; x=1672448839;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=FNhqRlbtz223hzG+ANsW67D6RvnITFJYKJzpbGvXUE8=;
  b=FqJ48biHch2tEfMHnUXNjzmxDgPU5MbGX/sqdWYfCdoJSHl89Zmd2RUb
   7kLHbuASSRnXG+xvB9I71Mx9OdPkeLKtCB+YDFY55YyrpC/pnfEydRvQh
   hEZZIuZ+mmOBJaOF2AAWCLGLsshjK84MlkuZg7FhlH6DXoZM22a8CJ8Lo
   TZ55+mcxlestS3yF6nZnOidXpAF8irNUzLz7HvRAvrxZnf8LnKA5e2b2N
   4TF0e5oCSPe/KxGePCX2emfAOjZ6FcS9GFOLcQVCTSInvweeCQlqV/Xcx
   mUtleEZbvsrhK9dh86lbBohKHzE9vl1PTO/yaKqACsyHQ01I1JDTySXzZ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10213"; a="266002024"
X-IronPort-AV: E=Sophos;i="5.88,248,1635231600"; 
   d="scan'208";a="266002024"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2021 17:07:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,248,1635231600"; 
   d="scan'208";a="524573035"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 30 Dec 2021 17:07:06 -0800
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
References: <20211230222414.GA1805873@bhelgaas>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <a8dacfbb-d447-cf1f-28db-cda632802952@linux.intel.com>
Date:   Fri, 31 Dec 2021 09:06:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211230222414.GA1805873@bhelgaas>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/31/21 6:24 AM, Bjorn Helgaas wrote:
> On Thu, Dec 30, 2021 at 01:34:27PM +0800, Lu Baolu wrote:
>> Hi Bjorn,
>>
>> On 12/30/21 4:42 AM, Bjorn Helgaas wrote:
>>> On Fri, Dec 17, 2021 at 02:36:58PM +0800, Lu Baolu wrote:
>>>> The pci_dma_configure() marks the iommu_group as containing only devices
>>>> with kernel drivers that manage DMA.
>>>
>>> I'm looking at pci_dma_configure(), and I don't see the connection to
>>> iommu_groups.
>>
>> The 2nd patch "driver core: Set DMA ownership during driver bind/unbind"
>> sets all drivers' DMA to be kernel-managed by default except a few ones
>> which has a driver flag set. So by default, all iommu groups contains
>> only devices with kernel drivers managing DMA.
> 
> It looks like that happens in device_dma_configure(), not
> pci_dma_configure().
> 
>>>> Avoid this default behavior for the
>>>> pci_stub because it does not program any DMA itself.  This allows the
>>>> pci_stub still able to be used by the admin to block driver binding after
>>>> applying the DMA ownership to vfio.
>>>
>>>>
>>>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>>>> ---
>>>>    drivers/pci/pci-stub.c | 3 +++
>>>>    1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
>>>> index e408099fea52..6324c68602b4 100644
>>>> --- a/drivers/pci/pci-stub.c
>>>> +++ b/drivers/pci/pci-stub.c
>>>> @@ -36,6 +36,9 @@ static struct pci_driver stub_driver = {
>>>>    	.name		= "pci-stub",
>>>>    	.id_table	= NULL,	/* only dynamic id's */
>>>>    	.probe		= pci_stub_probe,
>>>> +	.driver		= {
>>>> +		.suppress_auto_claim_dma_owner = true,
>>>
>>> The new .suppress_auto_claim_dma_owner controls whether we call
>>> iommu_device_set_dma_owner().  I guess you added
>>> .suppress_auto_claim_dma_owner because iommu_device_set_dma_owner()
>>> must be done *before* we call the driver's .probe() method?
>>
>> As explained above, all drivers are set to kernel-managed dma by
>> default. For those vfio and vfio-approved drivers,
>> suppress_auto_claim_dma_owner is used to tell the driver core that "this
>> driver is attached to device for userspace assignment purpose, do not
>> claim it for kernel-management dma".
>>
>>> Otherwise, we could call some new interface from .probe() instead of
>>> adding the flag to struct device_driver.
>>
>> Most device drivers are of the kernel-managed DMA type. Only a few vfio
>> and vfio-approved drivers need to use this flag. That's the reason why
>> we claim kernel-managed DMA by default.
> 
> Yes.  But you didn't answer the question of whether this must be done
> by a new flag in struct device_driver, or whether it could be done by
> having these few VFIO and "VFIO-approved" (whatever that means)
> drivers call a new interface.
> 
> I was speculating that maybe the DMA ownership claiming must be done
> *before* the driver's .probe() method?  If so, that would require a
> new flag.  But I don't know whether that's the case.  If DMA
> ownership could be claimed by the .probe() method, we wouldn't need
> the new flag in struct device_driver.

Yes. It's feasible. Hence we can remove the suppress flag which is only
for some special drivers. I will come up with a new version so that you
can further comment with the real code. Thank you!

> 
> Bjorn
> 

Best regards,
baolu
