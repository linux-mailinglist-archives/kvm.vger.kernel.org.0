Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6D93923BB
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 02:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhE0AX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 20:23:59 -0400
Received: from mga12.intel.com ([192.55.52.136]:57917 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232916AbhE0AX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 20:23:58 -0400
IronPort-SDR: cjNgE5E0lSk/oyQrDIK/EK2mhvKSPpQIRcmSIPQnkLUGYEwBObWJ72qEsPKBHn3klEuOidVXbO
 60DfuDY0zslg==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="182267163"
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="182267163"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 17:22:25 -0700
IronPort-SDR: lReY4mf/OSOR576x/j9wiVXic53pGNKIMBXd9Q5X67WVlkom8Pmyt0pOkhSksaugZcWYbBl+Ua
 aRjSY6JaussA==
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="397527172"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.10.31]) ([10.212.10.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 17:22:23 -0700
Subject: Re: [PATCH v6 15/20] vfio/mdev: idxd: ims domain setup for the vdcm
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164283796.261970.11020270418798826121.stgit@djiang5-desk3.ch.intel.com>
 <20210523235023.GL1002214@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <29cec5cd-3f23-f947-4545-f507b3f70988@intel.com>
Date:   Wed, 26 May 2021 17:22:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210523235023.GL1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/23/2021 4:50 PM, Jason Gunthorpe wrote:
> On Fri, May 21, 2021 at 05:20:37PM -0700, Dave Jiang wrote:
>> @@ -77,8 +80,18 @@ int idxd_mdev_host_init(struct idxd_device *idxd, struct mdev_driver *drv)
>>   		return rc;
>>   	}
>>   
>> +	ims_info.max_slots = idxd->ims_size;
>> +	ims_info.slots = idxd->reg_base + idxd->ims_offset;
>> +	idxd->ims_domain = pci_ims_array_create_msi_irq_domain(idxd->pdev, &ims_info);
>> +	if (!idxd->ims_domain) {
>> +		dev_warn(dev, "Fail to acquire IMS domain\n");
>> +		iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
>> +		return -ENODEV;
>> +	}
> I'm quite surprised that every mdev doesn't create its own ims_domain
> in its probe function.
>
> This places a global total limit on the # of vectors which makes me
> ask what was the point of using IMS in the first place ?
>
> The entire idea for IMS was to make the whole allocation system fully
> dynamic based on demand.

Hi Jason, thank you for the review of the series.

My understanding is that the driver creates a single IMS domain for the 
device and provides the address base and IMS numbers for the domain 
based on device IMS resources. So the IMS region needs to be contiguous. 
Each mdev can call msi_domain_alloc_irqs() and acquire the number of IMS 
vectors it desires and the DEV MSI core code will keep track of which 
vectors are being used. This allows the mdev devices to dynamically 
allocate based on demand. If the driver allocates a domain per mdev, 
it'll needs to do internal accounting of the base and vector numbers for 
each of those domains that the MSI core already provides. Isn't that 
what we are trying to avoid? As mdevs come and go, that partitioning 
will become fragmented.

For example, mdev 0 allocates 1 vector, mdev 1 allocates 2 vectors, and 
mdev 3 allocates 3 vector. You have 1 vectors unallocated. When mdev 1 
goes away and a new mdev shows up wanting 3 vectors, you won't be able 
to allocate the domain because of fragmentation even though you have 
enough vectors.

If all mdevs allocate the same IMS numbers, the fragmentation issue does 
not exist. But the driver still has to keep track of which vectors are 
free and which ones are used in order to provide the appropriate base. 
And dev msi core already does this for us if we have a single domain. 
Feels like we would just be duplicating code doing the same thing?


>
>>   	rc = mdev_register_device(dev, drv);
>>   	if (rc < 0) {
>> +		irq_domain_remove(idxd->ims_domain);
>>   		iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
>>   		return rc;
>>   	}
> This really wants a goto error unwind
>
> Jason
