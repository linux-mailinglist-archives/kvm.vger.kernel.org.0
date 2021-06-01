Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A47C39715A
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 12:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhFAK01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 06:26:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:52378 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233237AbhFAK0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 06:26:25 -0400
IronPort-SDR: PaLB3wxELZMPFCJ9IqARPyAWB0C17hvPNgjonhEokj+3xSTG/hWHEdbaAjvFmaivo7Z3kBkFvq
 UJDBmrGLTYbA==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267394383"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267394383"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 03:24:39 -0700
IronPort-SDR: l6ts3JXUttWZArQyQcYLDP37RmNoYkQTQcxEfj3z5zQFvY/xK94BWjEiyAV81QTrBIjw++QuTv
 5Fx+Grb3y1bQ==
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="479226991"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.130.133]) ([10.238.130.133])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 03:24:36 -0700
Subject: Re: [PATCH RFC 4/7] kvm: x86: Add new ioctls for XSAVE extension
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-5-jing2.liu@linux.intel.com>
 <YKwfsIT5DuE+L+4M@google.com>
 <920df897-56d8-1f81-7ce2-0050fb744bd7@linux.intel.com>
 <YK5egUs+Wl2d+wWz@google.com>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <a65656e7-adab-dd9d-7f9d-b25a96e7accd@linux.intel.com>
Date:   Tue, 1 Jun 2021 18:24:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YK5egUs+Wl2d+wWz@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/26/2021 10:43 PM, Sean Christopherson wrote:
> On Wed, May 26, 2021, Liu, Jing2 wrote:
>> On 5/25/2021 5:50 AM, Sean Christopherson wrote:
>>> On Sun, Feb 07, 2021, Jing Liu wrote:
>>>> The static xstate buffer kvm_xsave contains the extended register
>>>> states, but it is not enough for dynamic features with large state.
>>>>
>>>> Introduce a new capability called KVM_CAP_X86_XSAVE_EXTENSION to
>>>> detect if hardware has XSAVE extension (XFD). Meanwhile, add two
>>>> new ioctl interfaces to get/set the whole xstate using struct
>>>> kvm_xsave_extension buffer containing both static and dynamic
>>>> xfeatures. Reuse fill_xsave and load_xsave for both cases.
>>>>
>>>> Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
>>>> ---
>>>>    arch/x86/include/uapi/asm/kvm.h |  5 +++
>>>>    arch/x86/kvm/x86.c              | 70 +++++++++++++++++++++++++--------
>>>>    include/uapi/linux/kvm.h        |  8 ++++
>>>>    3 files changed, 66 insertions(+), 17 deletions(-)
>>>>
>>>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>>>> index 89e5f3d1bba8..bf785e89a728 100644
>>>> --- a/arch/x86/include/uapi/asm/kvm.h
>>>> +++ b/arch/x86/include/uapi/asm/kvm.h
>>>> @@ -362,6 +362,11 @@ struct kvm_xsave {
>>>>    	__u32 region[1024];
> Hold up a sec.  How big is the AMX data?
AMX tileconfig size is 64B, but tiledata size is 8K.
> The existing size is 4096 bytes, not
> 1024 bytes.  IIRC, AMX is >4k, so we still need a new ioctl(),
Yep, kvm_xsave can hold 4KB state. We need a new ioctl, holding all the 
states,
not only AMX. And once KVM supports AMX, the size will >4096 so qemu need
use kvm_xsave2 instead, otherwise, cannot save/restore whole AMX state.
> but we should be
> careful to mentally adjust for the __u32 when mentioning the sizes.
>
>>>>    };
>>>> +/* for KVM_CAP_XSAVE_EXTENSION */
>>>> +struct kvm_xsave_extension {
>>>> +	__u32 region[3072];
>>> Fool me once, shame on you (Intel).  Fool me twice, shame on me (KVM).
>>>
>>> As amusing as kvm_xsave_really_extended would be, the required size should be
>>> discoverable, not hardcoded.
>> Thanks for reviewing the patch.  When looking at current kvm_xsave structure,
>> I felt confusing about the static hardcoding of 1024 bytes, but failed to
>> find clue for its final decision in 2010[1].
> Simplicitly and lack of foresight :-)
>
>> So we'd prefer to changing the way right? Please correct me if I misunderstood.
> Sadly, we can't fix the existing ioctl() without breaking userspace.  But for
> the new ioctl(), yes, its size should not be hardcoded.
>
>>> Nothing prevents a hardware vendor from inventing a newfangled feature that
>>> requires yet more space.  As an alternative to adding a dedicated
>>> capability, can we leverage GET_SUPPORTED_CPUID, leaf CPUID.0xD,
>> Yes, this is a good way to avoid a dedicated capability. Thanks for the
>> suggestion.  Use 0xD.1.EBX for size of enabled xcr0|xss if supposing
>> kvm_xsave cares both.
>>> to enumerate the minimum required size and state
>> For the state, an extreme case is using an old qemu as follows, but a
>> new kvm with more future_featureZ supported. If hardware vendor arranges
>> one by one, it's OK to use static state like X86XSaveArea(2) and
>> get/set between userspace and kvm because it's non-compacted. If not,
>> the state will not correct.
>> So far it is OK, so I'm wondering if this would be an issue for now?
> Oh, you're saying that, because kvm_xsave is non-compacted, future features may
> overflow kvm_xsave simply because the architectural offset overflows 4096 bytes.
>
> That should be a non-issue for old KVM/kernels, since the new features shouldn't
> be enabled.  For new KVM, I think the right approach is to reject KVM_GET_XSAVE
> and KVM_SET_XSAVE if the required size is greater than sizeof(struct kvm_xsave).
> I.e. force userspace to either hide the features from the guest, or use
> KVM_{G,S}ET_XSAVE2.
I was considering if the order/offset of future features will impact the 
compatibility
if it is not designed one by one. But I realized it's not an issue 
because there uses
non-compacted format so each offset strictly refers to spec.

>> X86XSaveArea2 {
>>      ...
>>      XSaveAVX
>>      ...
>>      AMX_XTILE;
>>      future_featureX;
>>      future_featureY;
>> }
>>
>>>    that the new ioctl() is available if the min size is greater than 1024?
>>> Or is that unnecessarily convoluted...
>> To enable a dynamic size kvm_xsave2(Thanks Jim's name suggestion), if things
>> as follows are what we might want.
>> /* for xstate large than 1024 */
>> struct kvm_xsave2 {
>>      int size; // size of the whole xstate
>>      void *ptr; // xstate pointer
>> }
>> #define KVM_GET_XSAVE2   _IOW(KVMIO,  0xa4, struct kvm_xsave2)
>>
>> Take @size together, so KVM need not fetch 0xd.1.ebx each time or a dedicated
>> variable.
> Yes, userspace needs to provide the size so that KVM doesn't unintentionally
> overflow the buffer provided by userspace.  We might also want to hedge by adding
> a flags?  Can't think of a use for it at the moment, though.
>
>    struct kvm_xsave2 {
>    	__u32 flags;
> 	__u32 size;
> 	__u8  state[0];
>    };
u8 makes things simple that kvm doesn't need compute size to u32.


Thanks,
Jing

