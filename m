Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7CB486EED
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 01:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344251AbiAGAgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 19:36:22 -0500
Received: from mga04.intel.com ([192.55.52.120]:21290 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343881AbiAGAgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 19:36:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641515781; x=1673051781;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=EkfKPQpb+SxTuleKwyjV6r0f1bhBPsTCAoGe8AyQC4w=;
  b=D0TCen4FESg0wVQFELmL3mFqto4PjM0A7f2vOtjUcdWZ09PkPPtoAjHl
   yJ8xUjos2fMJmWH7CiRcaIZvVcNorQJQmyvyU0qKwlvJfnlVgXvWqjq/m
   6Z+BlkK4gdao49XJZE7nkGhTiioET2DP+nQ+iJ9V/qSsKezSal8nI3xbY
   rKjymDk2KhlKROoLQ9E47o5AieUGu4m6qv8pV9eZgURJBPgnSdIICUCgp
   QA6WL3EXVJSCgkUxbBNUvyvsCLTz4KTExKjfdIsHVOZtzh5O8hzNFXWqh
   LnFkZIRAfMBTTokUfnQLlSSOO4zN+kSo6b07R6FPwUp4S/5kEBIxK3Yzu
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="241586420"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="241586420"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:36:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="527184334"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 06 Jan 2022 16:36:14 -0800
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
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <2befad17-05fe-3768-6fbb-67440a5befa3@linux.intel.com>
Date:   Fri, 7 Jan 2022 08:35:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220106153543.GD2328285@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/22 11:35 PM, Jason Gunthorpe wrote:
> On Thu, Jan 06, 2022 at 10:20:51AM +0800, Lu Baolu wrote:
>> Ordinary drivers should use iommu_attach/detach_device() for domain
>> attaching and detaching.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>>   drivers/gpu/host1x/dev.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
>> index fbb6447b8659..6e08cb6202cc 100644
>> +++ b/drivers/gpu/host1x/dev.c
>> @@ -265,7 +265,7 @@ static struct iommu_domain *host1x_iommu_attach(struct host1x *host)
>>   			goto put_cache;
>>   		}
>>   
>> -		err = iommu_attach_group(host->domain, host->group);
>> +		err = iommu_attach_device(host->domain, host->dev);
>>   		if (err) {
>>   			if (err == -ENODEV)
>>   				err = 0;
>> @@ -335,7 +335,7 @@ static void host1x_iommu_exit(struct host1x *host)
>>   {
>>   	if (host->domain) {
>>   		put_iova_domain(&host->iova);
>> -		iommu_detach_group(host->domain, host->group);
>> +		iommu_detach_device(host->domain, host->dev);
>>   
>>   		iommu_domain_free(host->domain);
>>   		host->domain = NULL;
> 
> Shouldn't this add the flag to tegra_host1x_driver ?

This is called for a single driver. The call trace looks like below:

static struct platform_driver tegra_host1x_driver = {
         .driver = {
                 .name = "tegra-host1x",
                 .of_match_table = host1x_of_match,
         },
         .probe = host1x_probe,
         .remove = host1x_remove,
};

host1x_probe(dev)
->host1x_iommu_init(host)	//host is a wrapper of dev
-->host1x_iommu_attach(host)
---->iommu_group_get(host->dev)
      iommu_domain_alloc(&platform_bus_type)
      iommu_attach_group(domain, group);

It seems that the existing code only works for singleton group.

> 
> And do like we did in the other tegra stuff and switch to the dma api
> when !host1x_wants_iommu() ?
> 
> Jason
> 

Best regards,
baolu
