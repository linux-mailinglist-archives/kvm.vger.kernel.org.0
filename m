Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2401222EC
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 05:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfLQENk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 23:13:40 -0500
Received: from mga14.intel.com ([192.55.52.115]:45244 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfLQENk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 23:13:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 20:13:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,324,1571727600"; 
   d="scan'208";a="227349930"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.215.47]) ([10.254.215.47])
  by orsmga002.jf.intel.com with ESMTP; 16 Dec 2019 20:13:36 -0800
Subject: Re: [PATCH v3 5/6] iommu/vt-d: Flush PASID-based iotlb for iova over
 first level
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, Peter Xu <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20191211021219.8997-1-baolu.lu@linux.intel.com>
 <20191211021219.8997-6-baolu.lu@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A130C08@SHSMSX104.ccr.corp.intel.com>
 <f1e5cfea-8b11-6d72-8e57-65daea51c050@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A132C50@SHSMSX104.ccr.corp.intel.com>
 <6a5f6695-d1fd-e7d1-3ea3-f222a1ef0e54@linux.intel.com>
 <b4a879b2-a5c7-b0bf-8cd4-7397aeebc381@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A135CAB@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A135D05@SHSMSX104.ccr.corp.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <e6ba7689-92a9-e332-d364-24e324bdad38@linux.intel.com>
Date:   Tue, 17 Dec 2019 12:13:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A135D05@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2019/12/17 10:36, Liu, Yi L wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Tuesday, December 17, 2019 10:26 AM
>> To: Lu Baolu <baolu.lu@linux.intel.com>; Joerg Roedel <joro@8bytes.org>; David
>> Woodhouse <dwmw2@infradead.org>; Alex Williamson
>> <alex.williamson@redhat.com>
>> Subject: RE: [PATCH v3 5/6] iommu/vt-d: Flush PASID-based iotlb for iova over first
>> level
>>
>>> From: Lu Baolu [mailto:baolu.lu@linux.intel.com]
>>> Sent: Tuesday, December 17, 2019 9:37 AM
>>> To: Liu, Yi L <yi.l.liu@intel.com>; Joerg Roedel <joro@8bytes.org>; David
>>> Woodhouse <dwmw2@infradead.org>; Alex Williamson
>>> <alex.williamson@redhat.com>
>>> Subject: Re: [PATCH v3 5/6] iommu/vt-d: Flush PASID-based iotlb for iova over first
>>> level
>>>
>>> Hi again,
>>>
>>> On 12/17/19 9:19 AM, Lu Baolu wrote:
>>>> Hi Yi,
>>>>
>>>> On 12/15/19 5:22 PM, Liu, Yi L wrote:
>>>>> Ok, let me explain more... default pasid is meaningful only when
>>>>> the domain has been attached to a device as an aux-domain. right?
>>>> No exactly. Each domain has a specific default pasid, no matter normal
>>>> domain (RID based) or aux-domain (PASID based). The difference is for a
>>>> normal domain RID2PASID value is used, for an aux-domain the pasid is
>>>> allocated from a global pool.
>>>>
>>>> The same concept used in VT-d 3.x scalable mode. For RID based DMA
>>>> translation RID2PASID value is used when walking the tables; For PASID
>>>> based DMA translation a real pasid in the transaction is used.
>>>>
>>>>> If a domain only has one device, and it is attached to this device as
>>>>> normal domain (normal domain means non aux-domain here). Then
>>>>> you should flush cache with domain-id and RID2PASID value.
>>>>> If a domain has one device, and it is attached to this device as
>>>>> aux-domain. Then you may want to flush cache with domain-id
>>>>> and default pasid. right?
>>>> A domain's counterpart is IOMMU group. So we say attach/detach domain
>>>> to/from devices in a group. We don't allow devices with different
>>>> default pasid sitting in a same group, right?
>>>>
>>>>> Then let's come to the case I mentioned in previous email. a mdev
>>>>> and another device assigned to a single VM. In host, you will have
>>>>> a domain which has two devices, one device(deva) is attached as
>>>> No. We will have two IOMMU groups and two domains. Correct me if my
>>>> understanding is not right.
>>> Reconsidered this. Unfortunately, my understanding is not right. :-(
>>>
>>> A single domain could be attached to multiple IOMMU groups. So it
>>> comes to the issue you concerned. Do I understand it right?
>> yes. Device within the same group has no such issue since such
>> devices are not able to enabled aux-domain. Now our understanding
>> are aligned. :-)
>>
>>>>> normal domain, another one (devB) is attached as aux-domain. Then
>>>>> which pasid should be used when the mapping in IOVA page table is
>>>>> modified? RID2PASID or default pasid? I think both should be used
>>>>> since the domain means differently to the two devices. If you just
>>>>> use default pasid, then deva may still be able to use stale caches.
>>> You are right. I will change it accordingly. The logic should look
>>> like:
>>>
>>> if (domain attached to physical device)
>>> 	flush_piotlb_with_RID2PASID()
>>> else if (domain_attached_to_mdev_device)
>>> 	flush_piotlb_with_default_pasid()
>>>
>>> Does this work for you? Thanks for catching this!
>> If no else, it would work for scalable mode. ^_^ I noticed you've
>> already corrected by yourself in another reply. :-) Look forward to
>> your next version.
> BTW. The discussion in this thread may apply to other cache flush
> in your series. Please have a check. At least, there are two places which
> need to be updated in this single patch.

Sure. I will.

Best regards,

baolu
>   
> Regards,
> Yi Liu
