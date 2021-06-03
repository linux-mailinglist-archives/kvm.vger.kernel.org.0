Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17559399A4C
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 07:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhFCFwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 01:52:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:49352 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229640AbhFCFwb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 01:52:31 -0400
IronPort-SDR: zTK+iSSrqgG6hK3GKN7MhKnPT3rfY/sPz1XFzBeCXykc90wgXY19sFyJtnuYMoTwuXgV+tX2nl
 mhrqK0fsZ9Xw==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="265144019"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="265144019"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 22:50:46 -0700
IronPort-SDR: HIqFoQnlwW9zRcmmcw2Vz1vlTxvHTTqq5JQyMeaA5VZWXz7UfIb649x3ydCt2HHdiRP+/Rerd3
 8oMaEjJ7xg+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="633581002"
Received: from allen-box.sh.intel.com (HELO [10.239.159.105]) ([10.239.159.105])
  by fmsmga006.fm.intel.com with ESMTP; 02 Jun 2021 22:50:41 -0700
Cc:     baolu.lu@linux.intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
 <786295f7-b154-cf28-3f4c-434426e897d3@linux.intel.com>
 <20210601172652.GK1002214@nvidia.com>
 <99c765d2-5fd3-002c-7c7a-408a17433068@linux.intel.com>
 <20210602232352.GL1002214@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <6113bf72-5419-4dc3-3b03-d11e4812a772@linux.intel.com>
Date:   Thu, 3 Jun 2021 13:49:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210602232352.GL1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/21 7:23 AM, Jason Gunthorpe wrote:
> On Wed, Jun 02, 2021 at 12:01:57PM +0800, Lu Baolu wrote:
>> On 6/2/21 1:26 AM, Jason Gunthorpe wrote:
>>> On Tue, Jun 01, 2021 at 07:09:21PM +0800, Lu Baolu wrote:
>>>
>>>> This version only covers 1) and 4). Do you think we need to support 2),
>>>> 3) and beyond?
>>>
>>> Yes aboslutely. The API should be flexable enough to specify the
>>> creation of all future page table formats we'd want to have and all HW
>>> specific details on those formats.
>>
>> OK, stay in the same line.
>>
>>>> If so, it seems that we need some in-kernel helpers and uAPIs to
>>>> support pre-installing a page table to IOASID.
>>>
>>> Not sure what this means..
>>
>> Sorry that I didn't make this clear.
>>
>> Let me bring back the page table types in my eyes.
>>
>>   1) IOMMU format page table (a.k.a. iommu_domain)
>>   2) user application CPU page table (SVA for example)
>>   3) KVM EPT (future option)
>>   4) VM guest managed page table (nesting mode)
>>
>> Each type of page table should be able to be associated with its IOASID.
>> We have BIND protocol for 4); We explicitly allocate an iommu_domain for
>> 1). But we don't have a clear definition for 2) 3) and others. I think
>> it's necessary to clearly define a time point and kAPI name between
>> IOASID_ALLOC and IOASID_ATTACH, so that other modules have the
>> opportunity to associate their page table with the allocated IOASID
>> before attaching the page table to the real IOMMU hardware.
> 
> In my mind these are all actions of creation..
> 
> #1 is ALLOC_IOASID 'to be compatible with thes devices attached to
>     this FD'
> #2 is ALLOC_IOASID_SVA
> #3 is some ALLOC_IOASID_KVM (and maybe the kvm fd has to issue this ioctl)
> #4 is ALLOC_IOASID_USER_PAGE_TABLE w/ user VA address or
>        ALLOC_IOASID_NESTED_PAGE_TABLE w/ IOVA address
> 
> Each allocation should have a set of operations that are allows
> map/unmap is only legal on #1. invalidate is only legal on #4, etc.

This sounds reasonable. The corresponding page table types and required
callbacks are also part of it.

> 
> How you want to split this up in the ioctl interface is a more
> interesting question. I generally like more calls than giant unwieldly
> multiplexer structs, but some things are naturally flags and optional
> modifications of a single ioctl.
> 
> In any event they should have a similar naming 'ALLOC_IOASID_XXX' and
> then a single 'DESTROY_IOASID' that works on all of them.
> 
>> I/O page fault handling is similar. The provider of the page table
>> should take the responsibility to handle the possible page faults.
> 
> For the faultable types, yes #3 and #4 should hook in the fault
> handler and deal with it.

Agreed.

Best regards,
baolu
