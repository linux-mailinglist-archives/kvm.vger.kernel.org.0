Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0547CF0CA
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 04:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbfJHCW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 22:22:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:42692 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbfJHCW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 22:22:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 19:22:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="192455888"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by fmsmga008.fm.intel.com with ESMTP; 07 Oct 2019 19:22:22 -0700
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kevin.tian@intel.com, Yi Sun <yi.y.sun@linux.intel.com>,
        ashok.raj@intel.com, kvm@vger.kernel.org, sanjay.k.kumar@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        yi.y.sun@intel.com
Subject: Re: [RFC PATCH 2/4] iommu/vt-d: Add first level page table interfaces
To:     Peter Xu <peterx@redhat.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
 <20190925052157.GL28074@xz-x1>
 <c9792e0b-bf42-1dbb-f060-0b1a43125f47@linux.intel.com>
 <20190926034905.GW28074@xz-x1>
 <52778812-129b-0fa7-985d-5814e9d84047@linux.intel.com>
 <20190927053449.GA9412@xz-x1>
 <66823e27-aa33-5968-b5fd-e5221fb1fffe@linux.intel.com>
 <20190929052532.GA12953@xz-x1>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <27232499-4f13-83c0-a1d3-e82e9183f3f0@linux.intel.com>
Date:   Tue, 8 Oct 2019 10:20:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190929052532.GA12953@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/29/19 1:25 PM, Peter Xu wrote:
> On Sat, Sep 28, 2019 at 04:23:16PM +0800, Lu Baolu wrote:
>> Hi Peter,
>>
>> On 9/27/19 1:34 PM, Peter Xu wrote:
>>> Hi, Baolu,
>>>
>>> On Fri, Sep 27, 2019 at 10:27:24AM +0800, Lu Baolu wrote:
>>>>>>>> +	spin_lock(&(domain)->page_table_lock);				\
>>>>>>>
>>>>>>> Is this intended to lock here instead of taking the lock during the
>>>>>>> whole page table walk?  Is it safe?
>>>>>>>
>>>>>>> Taking the example where nm==PTE: when we reach here how do we
>>>>>>> guarantee that the PMD page that has this PTE is still valid?
>>>>>>
>>>>>> We will always keep the non-leaf pages in the table,
>>>>>
>>>>> I see.  Though, could I ask why?  It seems to me that the existing 2nd
>>>>> level page table does not keep these when unmap, and it's not even use
>>>>> locking at all by leveraging cmpxchg()?
>>>>
>>>> I still need some time to understand how cmpxchg() solves the race issue
>>>> when reclaims pages. For example.
>>>>
>>>> Thread A				Thread B
>>>> -A1: check all PTE's empty		-B1: up-level PDE valid
>>>> -A2: clear the up-level PDE
>>>> -A3: reclaim the page			-B2: populate the PTEs
>>>>
>>>> Both (A1,A2) and (B1,B2) should be atomic. Otherwise, race could happen.
>>>
>>> I'm not sure of this, but IMHO it is similarly because we need to
>>> allocate the iova ranges from iova allocator first, so thread A (who's
>>> going to unmap pages) and thread B (who's going to map new pages)
>>> should never have collapsed regions if happening concurrently.  I'm
>>
>> Although they don't collapse, they might share a same pmd entry. If A
>> cleared the pmd entry and B goes ahead with populating the pte's. It
>> will crash.
> 
> My understanding is that if A was not owning all the pages on that PMD
> entry then it will never free the page that was backing that PMD
> entry.  Please refer to the code in dma_pte_clear_level() where it
> has:
> 
>          /* If range covers entire pagetable, free it */
>          if (start_pfn <= level_pfn &&
>                  last_pfn >= level_pfn + level_size(level) - 1) {
>                  ...
>          } else {
>                  ...
>          }
> 
> Note that when going into the else block, the PMD won't be freed but
> only the PTEs that upon the PMD will be cleared.

Exactly! Thanks for pointing this out.

I will do the same thing in v2.

> 
> In the case you mentioned above, IMHO it should go into that else
> block.  Say, thread A must not contain the whole range of that PMD
> otherwise thread B won't get allocated with pages within that range
> covered by the same PMD.
> 
> Thanks,
> 

Best regards,
Baolu
