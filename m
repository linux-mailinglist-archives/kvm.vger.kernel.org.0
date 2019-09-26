Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79448BEA42
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 03:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391352AbfIZBjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 21:39:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:5786 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391342AbfIZBjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 21:39:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 18:39:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,549,1559545200"; 
   d="scan'208";a="201449048"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 25 Sep 2019 18:39:03 -0700
Cc:     baolu.lu@linux.intel.com, "Raj, Ashok" <ashok.raj@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 0/4] Use 1st-level for DMA remapping in guest
To:     Peter Xu <peterx@redhat.com>, "Tian, Kevin" <kevin.tian@intel.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122715.53de79d0@jacob-builder>
 <20190923202552.GA21816@araj-mobl1.jf.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58D1F1@SHSMSX104.ccr.corp.intel.com>
 <dfd9b7a2-5553-328a-08eb-16c8a3a2644e@linux.intel.com>
 <20190925065640.GO28074@xz-x1>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58F4A3@SHSMSX104.ccr.corp.intel.com>
 <20190925074507.GP28074@xz-x1>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58F5F5@SHSMSX104.ccr.corp.intel.com>
 <20190925085204.GR28074@xz-x1>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <b14a39f3-6aba-8fd2-757a-c244dcbe7b6b@linux.intel.com>
Date:   Thu, 26 Sep 2019 09:37:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925085204.GR28074@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 9/25/19 4:52 PM, Peter Xu wrote:
> On Wed, Sep 25, 2019 at 08:02:23AM +0000, Tian, Kevin wrote:
>>> From: Peter Xu [mailto:peterx@redhat.com]
>>> Sent: Wednesday, September 25, 2019 3:45 PM
>>>
>>> On Wed, Sep 25, 2019 at 07:21:51AM +0000, Tian, Kevin wrote:
>>>>> From: Peter Xu [mailto:peterx@redhat.com]
>>>>> Sent: Wednesday, September 25, 2019 2:57 PM
>>>>>
>>>>> On Wed, Sep 25, 2019 at 10:48:32AM +0800, Lu Baolu wrote:
>>>>>> Hi Kevin,
>>>>>>
>>>>>> On 9/24/19 3:00 PM, Tian, Kevin wrote:
>>>>>>>>>>        '-----------'
>>>>>>>>>>        '-----------'
>>>>>>>>>>
>>>>>>>>>> This patch series only aims to achieve the first goal, a.k.a using
>>>>>>> first goal? then what are other goals? I didn't spot such information.
>>>>>>>
>>>>>>
>>>>>> The overall goal is to use IOMMU nested mode to avoid shadow page
>>>>> table
>>>>>> and VMEXIT when map an gIOVA. This includes below 4 steps (maybe
>>> not
>>>>>> accurate, but you could get the point.)
>>>>>>
>>>>>> 1) GIOVA mappings over 1st-level page table;
>>>>>> 2) binding vIOMMU 1st level page table to the pIOMMU;
>>>>>> 3) using pIOMMU second level for GPA->HPA translation;
>>>>>> 4) enable nested (a.k.a. dual stage) translation in host.
>>>>>>
>>>>>> This patch set aims to achieve 1).
>>>>>
>>>>> Would it make sense to use 1st level even for bare-metal to replace
>>>>> the 2nd level?
>>>>>
>>>>> What I'm thinking is the DPDK apps - they have MMU page table already
>>>>> there for the huge pages, then if they can use 1st level as the
>>>>> default device page table then it even does not need to map, because
>>>>> it can simply bind the process root page table pointer to the 1st
>>>>> level page root pointer of the device contexts that it uses.
>>>>>
>>>>
>>>> Then you need bear with possible page faults from using CPU page
>>>> table, while most devices don't support it today.
>>>
>>> Right, I was just thinking aloud.  After all neither do we have IOMMU
>>> hardware to support 1st level (or am I wrong?)...  It's just that when
>>
>> You are right. Current VT-d supports only 2nd level.
>>
>>> the 1st level is ready it should sound doable because IIUC PRI should
>>> be always with the 1st level support no matter on IOMMU side or the
>>> device side?
>>
>> No. PRI is not tied to 1st or 2nd level. Actually from device p.o.v, it's
>> just a protocol to trigger page fault, but the device doesn't care whether
>> the page fault is on 1st or 2nd level in the IOMMU side. The only
>> relevant part is that a PRI request can have PASID tagged or cleared.
>> When it's tagged with PASID, the IOMMU will locate the translation
>> table under the given PASID (either 1st or 2nd level is fine, according
>> to PASID entry setting). When no PASID is included, the IOMMU locates
>> the translation from default entry (e.g. PASID#0 or any PASID contained
>> in RID2PASID in VT-d).
>>
>> Your knowledge happened to be correct in deprecated ECS mode. At
>> that time, there is only one 2nd level per context entry which doesn't
>> support page fault, and there is only one 1st level per PASID entry which
>> supports page fault. Then PRI could be indirectly connected to 1st level,
>> but this just changed with new scalable mode.
>>
>> Another note is that the PRI capability only indicates that a device is
>> capable of handling page faults, but not that a device can tolerate
>> page fault for any of its DMA access. If the latter is fasle, using CPU
>> page table for DPDK usage is still risky (and specific to device behavior)
>>
>>>
>>> I'm actually not sure about whether my understanding here is
>>> correct... I thought the pasid binding previously was only for some
>>> vendor kernel drivers but not a general thing to userspace.  I feel
>>> like that should be doable in the future once we've got some new
>>> syscall interface ready to deliver 1st level page table (e.g., via
>>> vfio?) then applications like DPDK seems to be able to use that too
>>> even directly via bare metal.
>>>
>>
>> using 1st level for userspace is different from supporting DMA page
>> fault in userspace. The former is purely about which structure to
>> keep the mapping. I think we may do the same thing for both bare
>> metal and guest (using 2nd level only for GPA when nested is enabled
>> on the IOMMU). But reusing CPU page table for userspace is more
>> tricky. :-)
> 
> Yes I should have mixed up the 1st level page table and PRI a bit, and
> after all my initial question should be irrelevant to this series as
> well so it's already a bit out of topic (sorry for that).

Never mind. Good discussion. :-)

Actually I have plan to use 1st level on bare metal as well. Just
looking forward to more motivation and use cases.

> 
> And, thanks for explaining these. :)
> 

Thanks for Kevin's explanation. :-)

Best regards,
Baolu
