Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654F739D44D
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 07:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhFGFZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 01:25:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:19226 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhFGFZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 01:25:22 -0400
IronPort-SDR: w+iOvDCHYQcTvuxuePSYcnAiDVJDa8c0WrvWRjMIJx/ntSDuN/+TjNfUK770qJsHlaZBJKqoyc
 FOC39kVkG7sg==
X-IronPort-AV: E=McAfee;i="6200,9189,10007"; a="191891204"
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="191891204"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 22:23:31 -0700
IronPort-SDR: IthmsF4H3q5l/sZxKPvmXYrNmi+xLuCHM3lfklFbGjvDYfO2e8S3KPNZ2vuRsDkzSJGy4cMjrS
 caUVbjfvvwlg==
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="481388126"
Received: from unknown (HELO [10.238.130.222]) ([10.238.130.222])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 22:23:30 -0700
Subject: Re: [PATCH RFC 4/7] kvm: x86: Add new ioctls for XSAVE extension
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-5-jing2.liu@linux.intel.com>
 <YKwfsIT5DuE+L+4M@google.com>
 <920df897-56d8-1f81-7ce2-0050fb744bd7@linux.intel.com>
 <YK5egUs+Wl2d+wWz@google.com>
 <a65656e7-adab-dd9d-7f9d-b25a96e7accd@linux.intel.com>
Message-ID: <7cbcbcf6-770d-8ac3-e7f3-6fed3331aa00@linux.intel.com>
Date:   Mon, 7 Jun 2021 13:23:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <a65656e7-adab-dd9d-7f9d-b25a96e7accd@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/1/2021 6:24 PM, Liu, Jing2 wrote:
>
>
> On 5/26/2021 10:43 PM, Sean Christopherson wrote:
>> On Wed, May 26, 2021, Liu, Jing2 wrote:
>>> On 5/25/2021 5:50 AM, Sean Christopherson wrote:
>>>> On Sun, Feb 07, 2021, Jing Liu wrote:
>>>>> The static xstate buffer kvm_xsave contains the extended register
>>>>> states, but it is not enough for dynamic features with large state.
>>>>>
>>>>> Introduce a new capability called KVM_CAP_X86_XSAVE_EXTENSION to
>>>>> detect if hardware has XSAVE extension (XFD). Meanwhile, add two
>>>>> new ioctl interfaces to get/set the whole xstate using struct
>>>>> kvm_xsave_extension buffer containing both static and dynamic
>>>>> xfeatures. Reuse fill_xsave and load_xsave for both cases.
>>>>>
>>>>> Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
>>>>> ---
>>>>>    arch/x86/include/uapi/asm/kvm.h |  5 +++
>>>>>    arch/x86/kvm/x86.c              | 70 
>>>>> +++++++++++++++++++++++++--------
>>>>>    include/uapi/linux/kvm.h        |  8 ++++
>>>>>    3 files changed, 66 insertions(+), 17 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/include/uapi/asm/kvm.h 
>>>>> b/arch/x86/include/uapi/asm/kvm.h
>>>>> index 89e5f3d1bba8..bf785e89a728 100644
>>>>> --- a/arch/x86/include/uapi/asm/kvm.h
>>>>> +++ b/arch/x86/include/uapi/asm/kvm.h
>>>>> @@ -362,6 +362,11 @@ struct kvm_xsave {
>>>>>        __u32 region[1024];
>> Hold up a sec.  How big is the AMX data?
> AMX tileconfig size is 64B, but tiledata size is 8K.
>> The existing size is 4096 bytes, not
>> 1024 bytes.  IIRC, AMX is >4k, so we still need a new ioctl(),
> Yep, kvm_xsave can hold 4KB state. We need a new ioctl, holding all 
> the states,
> not only AMX. And once KVM supports AMX, the size will >4096 so qemu need
> use kvm_xsave2 instead, otherwise, cannot save/restore whole AMX state.
>> but we should be
>> careful to mentally adjust for the __u32 when mentioning the sizes.
>>
>>>>>    };
>>>>> +/* for KVM_CAP_XSAVE_EXTENSION */
>>>>> +struct kvm_xsave_extension {
>>>>> +    __u32 region[3072];
>>>> Fool me once, shame on you (Intel).  Fool me twice, shame on me (KVM).
>>>>
>>>> As amusing as kvm_xsave_really_extended would be, the required size 
>>>> should be
>>>> discoverable, not hardcoded.
>>> Thanks for reviewing the patch.  When looking at current kvm_xsave 
>>> structure,
>>> I felt confusing about the static hardcoding of 1024 bytes, but 
>>> failed to
>>> find clue for its final decision in 2010[1].
>> Simplicitly and lack of foresight :-)
>>
>>> So we'd prefer to changing the way right? Please correct me if I 
>>> misunderstood.
>> Sadly, we can't fix the existing ioctl() without breaking userspace.  
>> But for
>> the new ioctl(), yes, its size should not be hardcoded.
>>
>>>> Nothing prevents a hardware vendor from inventing a newfangled 
>>>> feature that
>>>> requires yet more space.  As an alternative to adding a dedicated
>>>> capability, can we leverage GET_SUPPORTED_CPUID, leaf CPUID.0xD,
>>> Yes, this is a good way to avoid a dedicated capability. Thanks for the
>>> suggestion.  Use 0xD.1.EBX for size of enabled xcr0|xss if supposing
>>> kvm_xsave cares both.
I think kvm_xsave ioctl only cares user states because supervisor states 
should
always use compacted format. When trying to think about how to get/set 
supervisor
states, I think it can not reuse current design (qemu talks with kvm via 
a buffer
and set/get to/from qemu's env->some_feature one by one according to the 
offset).
So do we need handle supervisor states and change the way?

For kvm_xsave2 which expands to >4096B, if reuse and expand current way, 
it only
detects xcr0 from 0xD.0.EBX.

[...]

Thanks,
Jing

