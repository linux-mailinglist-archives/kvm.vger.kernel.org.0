Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0803B4310F0
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 09:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhJRHD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 03:03:27 -0400
Received: from mga18.intel.com ([134.134.136.126]:15296 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhJRHD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 03:03:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10140"; a="215112526"
X-IronPort-AV: E=Sophos;i="5.85,381,1624345200"; 
   d="scan'208";a="215112526"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 00:01:15 -0700
X-IronPort-AV: E=Sophos;i="5.85,381,1624345200"; 
   d="scan'208";a="493466998"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 00:01:13 -0700
Message-ID: <e202f238-2a9f-7196-5323-8b0f77073e4a@intel.com>
Date:   Mon, 18 Oct 2021 15:01:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.2.0
Subject: Re: [PATCH v2 6/7] KVM: VMX: Check Intel PT related CPUID leaves
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
 <20210827070249.924633-7-xiaoyao.li@intel.com> <YTp/oGmiin19q4sQ@google.com>
 <a7988439-5a4c-3d5a-ea4a-0fad181ad733@intel.com>
In-Reply-To: <a7988439-5a4c-3d5a-ea4a-0fad181ad733@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/10/2021 9:59 AM, Xiaoyao Li wrote:
> On 9/10/2021 5:41 AM, Sean Christopherson wrote:
>> On Fri, Aug 27, 2021, Xiaoyao Li wrote:
>>> CPUID 0xD leaves reports the capabilities of Intel PT, e.g. it decides
>>> which bits are valid to be set in MSR_IA32_RTIT_CTL, and reports the
>>> number of PT ADDR ranges.
>>>
>>> KVM needs to check that guest CPUID values set by userspace doesn't
>>> enable any bit which is not supported by bare metal. Otherwise,
>>> 1. it will trigger vm-entry failure if hardware unsupported bit is
>>>     exposed to guest and set by guest.
>>> 2. it triggers #GP when context switch PT MSRs if exposing more
>>>     RTIT_ADDR* MSRs than hardware capacity.
>>>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
..
> 
>>> +     * pt_desc.ctl_bitmask in later update_intel_pt_cfg().
>>> +     *
>>> +     * pt_desc.ctl_bitmask decides the legal value for guest
>>> +     * MSR_IA32_RTIT_CTL. KVM cannot support PT capabilities beyond 
>>> native,
>>> +     * otherwise it will trigger vm-entry failure if guest sets native
>>> +     * unsupported bits in MSR_IA32_RTIT_CTL.
>>> +     */
>>> +    best = cpuid_entry2_find(entries, nent, 0xD, 0);
>>> +    if (best) {
>>> +        cpuid_count(0xD, 0, &eax, &ebx, &ecx, &edx);
>>> +        if (best->ebx & ~ebx || best->ecx & ~ecx)
>>> +            return -EINVAL;
>>> +    }
>>> +    best = cpuid_entry2_find(entries, nent, 0xD, 1);
>>> +    if (best) {
>>> +        cpuid_count(0xD, 0, &eax, &ebx, &ecx, &edx);
>>> +        if (((best->eax & 0x7) > (eax & 0x7)) ||
>>
>> Ugh, looking at the rest of the code, even this isn't sufficient because
>> pt_desc.guest.addr_{a,b} are hardcoded at 4 entries, i.e. running KVM 
>> on hardware
>> with >4 entries will lead to buffer overflows.
> 
> it's hardcoded to 4 because there is a note of "no processors support 
> more than 4 address ranges" in SDM vol.3 Chapter 31.3.1, table 31-11
> 
>> One option would be to bump that to the theoretical max of 15, which 
>> doesn't seem
>> too horrible, especially if pt_desc as a whole is allocated on-demand, 
>> which it
>> probably should be since it isn't exactly tiny (nor ubiquitous)
>>
>> A different option would be to let userspace define whatever it wants 
>> for guest
>> CPUID, and instead cap nr_addr_ranges at min(host.cpuid, guest.cpuid, 
>> RTIT_ADDR_RANGE).
>>
>> Letting userspace generate a bad MSR_IA32_RTIT_CTL is not problematic, 
>> there are
>> plenty of ways userspace can deliberately trigger VM-Entry failure due 
>> to invalid
>> guest state (even if this is a VM-Fail condition, it's not a danger to 
>> KVM).
> 
> I'm fine to only safe guard the nr_addr_range if VM-Entry failure 
> doesn't matter.

Hi Sean.

It seems I misread your comment. All above you were talking about the 
check on nr_addr_range. Did you want to say the check is not necessary 
if it's to avoid VM-entry failure?

The problem is 1) the check on nr_addr_range is to avoid MSR read #GP, 
thought kernel will fix the #GP. It still prints the warning message.

2) Other check of this Patch on guest CPUID 0x14 is to avoid VM-entry 
failure.

So I want to ask that do you think both 1) and 2) are unnecessary, or 
only 2) ?

