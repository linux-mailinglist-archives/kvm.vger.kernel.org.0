Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55844486F9D
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 02:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345167AbiAGBUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 20:20:00 -0500
Received: from mga07.intel.com ([134.134.136.100]:29381 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344352AbiAGBT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 20:19:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641518398; x=1673054398;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Qmk7jfZS/XwH1zpKmsOoRjz7KHDFbSx87A5bcGdXK78=;
  b=bEqS3AFxrJFUAEhfFuf0Amo1I4W71sotUuMEejJ3h2yKidA971Q58aTJ
   68Gl4zUePRcVG8BznsZKq+OgWUVbyPwFaUhb7R+vBVyfTGg1uEbjwNLFD
   v14SZ/Org+W5iLikM8Gj6/prHkJ6PKp0Le3R4sFl+rBY14FNZKOg8DNnM
   7S+POt7JTLme5xDtNVNQRfKXHc+fCrYnPj2Y2+8Esjif3OWAp/O/G3qwJ
   4oOgF8tYdJ36Dx5HywZSNy2yU53GtRXtPsOP+bYNxf9vS+SlqbRArjzho
   J5XPgF6OK37A7StgtHSnmu3ZvteCwbEEmJjWlpFEXMMCiIh6cYCQ8V6GS
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="306150380"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="306150380"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 17:19:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="527201423"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 06 Jan 2022 17:19:50 -0800
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v1 6/8] gpu/host1x: Use iommu_attach/detach_device()
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-7-baolu.lu@linux.intel.com>
 <20220106153543.GD2328285@nvidia.com>
 <2befad17-05fe-3768-6fbb-67440a5befa3@linux.intel.com>
 <20220107004825.GP2328285@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <0c80f52e-0529-b299-6f13-105f873be3a0@linux.intel.com>
Date:   Fri, 7 Jan 2022 09:19:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220107004825.GP2328285@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/22 8:48 AM, Jason Gunthorpe wrote:
> On Fri, Jan 07, 2022 at 08:35:34AM +0800, Lu Baolu wrote:
>> On 1/6/22 11:35 PM, Jason Gunthorpe wrote:
>>> On Thu, Jan 06, 2022 at 10:20:51AM +0800, Lu Baolu wrote:
>>>> Ordinary drivers should use iommu_attach/detach_device() for domain
>>>> attaching and detaching.
>>>>
>>>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>>>>    drivers/gpu/host1x/dev.c | 4 ++--
>>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
>>>> index fbb6447b8659..6e08cb6202cc 100644
>>>> +++ b/drivers/gpu/host1x/dev.c
>>>> @@ -265,7 +265,7 @@ static struct iommu_domain *host1x_iommu_attach(struct host1x *host)
>>>>    			goto put_cache;
>>>>    		}
>>>> -		err = iommu_attach_group(host->domain, host->group);
>>>> +		err = iommu_attach_device(host->domain, host->dev);
>>>>    		if (err) {
>>>>    			if (err == -ENODEV)
>>>>    				err = 0;
>>>> @@ -335,7 +335,7 @@ static void host1x_iommu_exit(struct host1x *host)
>>>>    {
>>>>    	if (host->domain) {
>>>>    		put_iova_domain(&host->iova);
>>>> -		iommu_detach_group(host->domain, host->group);
>>>> +		iommu_detach_device(host->domain, host->dev);
>>>>    		iommu_domain_free(host->domain);
>>>>    		host->domain = NULL;
>>>
>>> Shouldn't this add the flag to tegra_host1x_driver ?
>>
>> This is called for a single driver. The call trace looks like below:
>>
>> static struct platform_driver tegra_host1x_driver = {
>>          .driver = {
>>                  .name = "tegra-host1x",
>>                  .of_match_table = host1x_of_match,
>>          },
>>          .probe = host1x_probe,
>>          .remove = host1x_remove,
>> };
>>
>> host1x_probe(dev)
>> ->host1x_iommu_init(host)	//host is a wrapper of dev
>>       iommu_domain_alloc(&platform_bus_type)
>>       iommu_attach_group(domain, group);
> 
> The main question is if the iommu group is being shared with other
> drivers, not the call chain for this function.
> 
> For tegra you have to go look in each entry of the of_match_table:
> 
>          { .compatible = "nvidia,tegra114-host1x", .data = &host1x02_info, },
> 
> And find the DTS block:
> 
>          host1x@50000000 {
>                  compatible = "nvidia,tegra114-host1x";
>                  reg = <0x50000000 0x00028000>;
>                  interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>, /* syncpt */
>                               <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>; /* general */
>                  interrupt-names = "syncpt", "host1x";
>                  clocks = <&tegra_car TEGRA114_CLK_HOST1X>;
>                  clock-names = "host1x";
>                  resets = <&tegra_car 28>;
>                  reset-names = "host1x";
>                  iommus = <&mc TEGRA_SWGROUP_HC>;
> 
> Then check if any other devices in the DTS use the same 'iommus' which
> is how the groups are setup.

Yes, exactly.

> 
> I checked everything and it does look like this is a single device
> group.

Okay, thanks!

> 
> Jason
> 

Best regards,
baolu
