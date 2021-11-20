Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36969457D3C
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 12:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbhKTLXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Nov 2021 06:23:53 -0500
Received: from mga07.intel.com ([134.134.136.100]:55992 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231161AbhKTLXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Nov 2021 06:23:53 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10173"; a="297974069"
X-IronPort-AV: E=Sophos;i="5.87,250,1631602800"; 
   d="scan'208";a="297974069"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2021 03:20:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,250,1631602800"; 
   d="scan'208";a="496214393"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga007.jf.intel.com with ESMTP; 20 Nov 2021 03:20:44 -0800
Cc:     baolu.lu@linux.intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>
Subject: Re: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
To:     =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-2-baolu.lu@linux.intel.com>
 <YZJdJH4AS+vm0j06@infradead.org>
 <cc7ce6f4-b1ec-49ef-e245-ab6c330154c2@linux.intel.com>
 <20211116134603.GA2105516@nvidia.com>
 <BN9PR11MB5433639E43C37C5D2462BD718C9B9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211118133325.GO2105516@nvidia.com>
 <BN9PR11MB5433E5B63E575E2232DFBBE48C9C9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <75100dfd-9cfe-9f3d-531d-b4d30de03e76@linux.intel.com>
 <20211119150612.jhsvsbzisvux2lga@8bytes.org>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <48cf6b2b-28ee-178d-6471-460e781e7b20@linux.intel.com>
Date:   Sat, 20 Nov 2021 19:16:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211119150612.jhsvsbzisvux2lga@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joerg,

On 11/19/21 11:06 PM, Jörg Rödel wrote:
> On Fri, Nov 19, 2021 at 07:14:10PM +0800, Lu Baolu wrote:
>> The singleton group requirement for iommu_attach/detach_device() was
>> added by below commit:
>>
>> commit 426a273834eae65abcfc7132a21a85b3151e0bce
>> Author: Joerg Roedel <jroedel@suse.de>
>> Date:   Thu May 28 18:41:30 2015 +0200
>>
>>      iommu: Limit iommu_attach/detach_device to devices with their own group
>>
>>      This patch changes the behavior of the iommu_attach_device
>>      and iommu_detach_device functions. With this change these
>>      functions only work on devices that have their own group.
>>      For all other devices the iommu_group_attach/detach
>>      functions must be used.
>>
>>      Signed-off-by: Joerg Roedel <jroedel@suse.de>
>>
>> Joerg,can you please shed some light on the background of this
>> requirement? Does above idea of transition from singleton group
>> to group with single driver bound make sense to you?
> 
> This change came to be because the iommu_attach/detach_device()
> interface doesn't fit well into a world with iommu-groups. Devices
> within a group are by definition not isolated between each other, so
> they must all be in the same address space (== iommu_domain). So it
> doesn't make sense to allow attaching a single device within a group to
> a different iommu_domain.

Thanks for the explanation. It's very helpful. There seems to be a lot
of discussions around this, but I didn't see any meaningful reasons to
break the assumption of "all devices in a group being in a same address
space".

Best regards,
baolu

> 
> I know that in theory it is safe to allow devices within a group to be
> in different domains because there iommu-groups catch multiple
> non-isolation cases:
> 
> 	1) Devices behind a non-ACS capable bridge or multiple functions
> 	   of a PCI device. Here it is safe to put the devices into
> 	   different iommu-domains as long as all affected devices are
> 	   controlled by the same owner.
> 
> 	2) Devices which share a single request-id and can't be
> 	   differentiated by the IOMMU hardware. These always need to be
> 	   in the same iommu_domain.
> 
> To lift the single-domain-per-group requirement the iommu core code
> needs to learn the difference between the two cases above.
> 
> Regards,
> 
> 	Joerg
> 
