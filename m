Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80744396CAE
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 07:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhFAFN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 01:13:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:10932 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230009AbhFAFN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 01:13:29 -0400
IronPort-SDR: vmffTixqHfbCYJCuDr82n1SEw8NpYHUhs9TNW3AZaoJ+hXQjSF+h8R0fySksLD7dLGSnKCnT9F
 +9YU6MZHhIFQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="200459999"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="200459999"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 22:11:48 -0700
IronPort-SDR: 2u84hOhaJd6strBWTEy1SyIBU8ZG0t9ohTKiepOBGgZdaA3rUcLdkxYaa5xaivPzcblATQnkGx
 tGSQqDI4DQEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="632747255"
Received: from allen-box.sh.intel.com (HELO [10.239.159.105]) ([10.239.159.105])
  by fmsmga006.fm.intel.com with ESMTP; 31 May 2021 22:11:42 -0700
Cc:     baolu.lu@linux.intel.com, Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Shenming Lu <lushenming@huawei.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <c9c066ae-2a25-0799-51a7-0ca47fff41a1@huawei.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <aa1624bf-e472-2b66-1d20-54ca23c19fd2@linux.intel.com>
Date:   Tue, 1 Jun 2021 13:10:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <c9c066ae-2a25-0799-51a7-0ca47fff41a1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shenming,

On 6/1/21 12:31 PM, Shenming Lu wrote:
> On 2021/5/27 15:58, Tian, Kevin wrote:
>> /dev/ioasid provides an unified interface for managing I/O page tables for
>> devices assigned to userspace. Device passthrough frameworks (VFIO, vDPA,
>> etc.) are expected to use this interface instead of creating their own logic to
>> isolate untrusted device DMAs initiated by userspace.
>>
>> This proposal describes the uAPI of /dev/ioasid and also sample sequences
>> with VFIO as example in typical usages. The driver-facing kernel API provided
>> by the iommu layer is still TBD, which can be discussed after consensus is
>> made on this uAPI.
>>
>> It's based on a lengthy discussion starting from here:
>> 	https://lore.kernel.org/linux-iommu/20210330132830.GO2356281@nvidia.com/
>>
>> It ends up to be a long writing due to many things to be summarized and
>> non-trivial effort required to connect them into a complete proposal.
>> Hope it provides a clean base to converge.
>>
> 
> [..]
> 
>>
>> /*
>>    * Page fault report and response
>>    *
>>    * This is TBD. Can be added after other parts are cleared up. Likely it
>>    * will be a ring buffer shared between user/kernel, an eventfd to notify
>>    * the user and an ioctl to complete the fault.
>>    *
>>    * The fault data is per I/O address space, i.e.: IOASID + faulting_addr
>>    */
> 
> Hi,
> 
> It seems that the ioasid has different usage in different situation, it could
> be directly used in the physical routing, or just a virtual handle that indicates
> a page table or a vPASID table (such as the GPA address space, in the simple
> passthrough case, the DMA input to IOMMU will just contain a Stream ID, no
> Substream ID), right?
> 
> And Baolu suggested that since one device might consume multiple page tables,
> it's more reasonable to have one fault handler per page table. By this, do we
> have to maintain such an ioasid info list in the IOMMU layer?

As discussed earlier, the I/O page fault and cache invalidation paths
will have "device labels" so that the information could be easily
translated and routed.

So it's likely the per-device fault handler registering API in iommu
core can be kept, but /dev/ioasid will be grown with a layer to
translate and propagate I/O page fault information to the right
consumers.

If things evolve in this way, probably the SVA I/O page fault also needs
to be ported to /dev/ioasid.

> 
> Then if we add host IOPF support (for the GPA address space) in the future
> (I have sent a series for this but it aimed for VFIO, I will convert it for
> IOASID later [1] :-)), how could we find the handler for the received fault
> event which only contains a Stream ID... Do we also have to maintain a
> dev(vPASID)->ioasid mapping in the IOMMU layer?
> 
> [1] https://lore.kernel.org/patchwork/cover/1410223/

Best regards,
baolu
