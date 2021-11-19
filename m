Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B0A456E10
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 12:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhKSLRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 06:17:20 -0500
Received: from mga05.intel.com ([192.55.52.43]:33847 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhKSLRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 06:17:19 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="320612641"
X-IronPort-AV: E=Sophos;i="5.87,247,1631602800"; 
   d="scan'208";a="320612641"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 03:14:17 -0800
X-IronPort-AV: E=Sophos;i="5.87,247,1631602800"; 
   d="scan'208";a="507861408"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.208.131]) ([10.254.208.131])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 03:14:13 -0800
Message-ID: <75100dfd-9cfe-9f3d-531d-b4d30de03e76@linux.intel.com>
Date:   Fri, 19 Nov 2021 19:14:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Cc:     baolu.lu@linux.intel.com, Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Will Deacon <will@kernel.org>
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-2-baolu.lu@linux.intel.com>
 <YZJdJH4AS+vm0j06@infradead.org>
 <cc7ce6f4-b1ec-49ef-e245-ab6c330154c2@linux.intel.com>
 <20211116134603.GA2105516@nvidia.com>
 <BN9PR11MB5433639E43C37C5D2462BD718C9B9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211118133325.GO2105516@nvidia.com>
 <BN9PR11MB5433E5B63E575E2232DFBBE48C9C9@BN9PR11MB5433.namprd11.prod.outlook.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
In-Reply-To: <BN9PR11MB5433E5B63E575E2232DFBBE48C9C9@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/11/19 13:44, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Thursday, November 18, 2021 9:33 PM
>>
>>> In concept a singleton group is different from a
>>> multi-devices group which has only one device bound to driver...
>>
>> Really? Why? I don't see it that way..
>>
>> A singleton group is just a multi-device group that hasn't been
>> hotplugged yet.
>>
>> We don't seem to have the concept of a "true" singleton group which is
>> permanently single due to HW features.
>>
>>> This series aims to avoid conflict having both user and kernel drivers
>>> mixed in a multi-devices group.
> 
> Well, the difference is just in literal. I don't know the background
> why the existing iommu_attach_device() users want to do it this
> way. But given the condition in iommu_attach_device() it could
> in theory imply some unknown hardware-level side effect which
> may break the desired functionality once the group size grows
> beyond singleton. Is it a real case? I don't know...
> 
> You are now redefining that condition from singleton group to
> multi-devices group with single driver bound. As long as no object
> from existing driver users, I'm fine with it. But still want to raise
> awareness as it does change the existing semantics (though might
> be considered as an imperfect way).

The singleton group requirement for iommu_attach/detach_device() was
added by below commit:

commit 426a273834eae65abcfc7132a21a85b3151e0bce
Author: Joerg Roedel <jroedel@suse.de>
Date:   Thu May 28 18:41:30 2015 +0200

     iommu: Limit iommu_attach/detach_device to devices with their own group

     This patch changes the behavior of the iommu_attach_device
     and iommu_detach_device functions. With this change these
     functions only work on devices that have their own group.
     For all other devices the iommu_group_attach/detach
     functions must be used.

     Signed-off-by: Joerg Roedel <jroedel@suse.de>

Joerg,can you please shed some light on the background of this
requirement? Does above idea of transition from singleton group
to group with single driver bound make sense to you?

Best regards,
baolu
