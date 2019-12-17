Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEF612219D
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 02:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfLQBiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 20:38:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:27444 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbfLQBiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 20:38:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 17:38:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,323,1571727600"; 
   d="scan'208";a="227319645"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 16 Dec 2019 17:38:14 -0800
Cc:     baolu.lu@linux.intel.com, "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, Peter Xu <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/6] iommu/vt-d: Flush PASID-based iotlb for iova over
 first level
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20191211021219.8997-1-baolu.lu@linux.intel.com>
 <20191211021219.8997-6-baolu.lu@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A130C08@SHSMSX104.ccr.corp.intel.com>
 <f1e5cfea-8b11-6d72-8e57-65daea51c050@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A132C50@SHSMSX104.ccr.corp.intel.com>
 <6a5f6695-d1fd-e7d1-3ea3-f222a1ef0e54@linux.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <b4a879b2-a5c7-b0bf-8cd4-7397aeebc381@linux.intel.com>
Date:   Tue, 17 Dec 2019 09:37:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <6a5f6695-d1fd-e7d1-3ea3-f222a1ef0e54@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi again,

On 12/17/19 9:19 AM, Lu Baolu wrote:
> Hi Yi,
> 
> On 12/15/19 5:22 PM, Liu, Yi L wrote:
>> Ok, let me explain more... default pasid is meaningful only when
>> the domain has been attached to a device as an aux-domain. right?
> 
> No exactly. Each domain has a specific default pasid, no matter normal
> domain (RID based) or aux-domain (PASID based). The difference is for a
> normal domain RID2PASID value is used, for an aux-domain the pasid is
> allocated from a global pool.
> 
> The same concept used in VT-d 3.x scalable mode. For RID based DMA
> translation RID2PASID value is used when walking the tables; For PASID
> based DMA translation a real pasid in the transaction is used.
> 
>> If a domain only has one device, and it is attached to this device as
>> normal domain (normal domain means non aux-domain here). Then
>> you should flush cache with domain-id and RID2PASID value.
>> If a domain has one device, and it is attached to this device as
>> aux-domain. Then you may want to flush cache with domain-id
>> and default pasid. right?
> 
> A domain's counterpart is IOMMU group. So we say attach/detach domain
> to/from devices in a group. We don't allow devices with different
> default pasid sitting in a same group, right?
> 
>> Then let's come to the case I mentioned in previous email. a mdev
>> and another device assigned to a single VM. In host, you will have
>> a domain which has two devices, one device(deva) is attached as
> 
> No. We will have two IOMMU groups and two domains. Correct me if my
> understanding is not right.

Reconsidered this. Unfortunately, my understanding is not right. :-(

A single domain could be attached to multiple IOMMU groups. So it
comes to the issue you concerned. Do I understand it right?

> 
>> normal domain, another one (devB) is attached as aux-domain. Then
>> which pasid should be used when the mapping in IOVA page table is
>> modified? RID2PASID or default pasid? I think both should be used
>> since the domain means differently to the two devices. If you just
>> use default pasid, then deva may still be able to use stale caches.

You are right. I will change it accordingly. The logic should look
like:

if (domain attached to physical device)
	flush_piotlb_with_RID2PASID()
else if (domain_attached_to_mdev_device)
	flush_piotlb_with_default_pasid()

Does this work for you? Thanks for catching this!

Best regards,
baolu
