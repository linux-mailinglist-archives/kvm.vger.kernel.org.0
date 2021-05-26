Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD43239105D
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 08:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbhEZGK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 02:10:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:9834 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231573AbhEZGK5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 02:10:57 -0400
IronPort-SDR: fJ51qK/kXeUw55tJoZ5CGhQT8+bv6qdHEWxG5jJLAw2bGyvGQExlB3Pac8dqCzsFJjH8oz474s
 Bup+3HFtyw3w==
X-IronPort-AV: E=McAfee;i="6200,9189,9995"; a="202427615"
X-IronPort-AV: E=Sophos;i="5.82,330,1613462400"; 
   d="scan'208";a="202427615"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 23:09:26 -0700
IronPort-SDR: D6ePKFlh8DlgJp4lXdFPgR+RLGvecW1w7fEWB3xxqEnhw7uEZNrdy/c+cpt6uKc/h1jF0j9uSM
 bnEBWrzSLWGw==
X-IronPort-AV: E=Sophos;i="5.82,330,1613462400"; 
   d="scan'208";a="476775930"
Received: from unknown (HELO [10.238.130.158]) ([10.238.130.158])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 23:09:23 -0700
Subject: Re: [PATCH RFC 4/7] kvm: x86: Add new ioctls for XSAVE extension
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-5-jing2.liu@linux.intel.com>
 <YKwfsIT5DuE+L+4M@google.com>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <920df897-56d8-1f81-7ce2-0050fb744bd7@linux.intel.com>
Date:   Wed, 26 May 2021 14:09:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YKwfsIT5DuE+L+4M@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/25/2021 5:50 AM, Sean Christopherson wrote:
> On Sun, Feb 07, 2021, Jing Liu wrote:
>> The static xstate buffer kvm_xsave contains the extended register
>> states, but it is not enough for dynamic features with large state.
>>
>> Introduce a new capability called KVM_CAP_X86_XSAVE_EXTENSION to
>> detect if hardware has XSAVE extension (XFD). Meanwhile, add two
>> new ioctl interfaces to get/set the whole xstate using struct
>> kvm_xsave_extension buffer containing both static and dynamic
>> xfeatures. Reuse fill_xsave and load_xsave for both cases.
>>
>> Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
>> ---
>>   arch/x86/include/uapi/asm/kvm.h |  5 +++
>>   arch/x86/kvm/x86.c              | 70 +++++++++++++++++++++++++--------
>>   include/uapi/linux/kvm.h        |  8 ++++
>>   3 files changed, 66 insertions(+), 17 deletions(-)
>>
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index 89e5f3d1bba8..bf785e89a728 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -362,6 +362,11 @@ struct kvm_xsave {
>>   	__u32 region[1024];
>>   };
>>   
>> +/* for KVM_CAP_XSAVE_EXTENSION */
>> +struct kvm_xsave_extension {
>> +	__u32 region[3072];
> Fool me once, shame on you (Intel).  Fool me twice, shame on me (KVM).
>
> As amusing as kvm_xsave_really_extended would be, the required size should be
> discoverable, not hardcoded.
Thanks for reviewing the patch.
When looking at current kvm_xsave structure, I felt confusing about the 
static
hardcoding of 1024 bytes, but failed to find clue for its final decision 
in 2010[1].
So we'd prefer to changing the way right? Please correct me if I 
misunderstood.

> Nothing prevents a hardware vendor from inventing
> a newfangled feature that requires yet more space.
> As an alternative to adding a dedicated capability, can we leverage
> GET_SUPPORTED_CPUID, leaf CPUID.0xD,
Yes, this is a good way to avoid a dedicated capability. Thanks for the
suggestion.
Use 0xD.1.EBX for size of enabled xcr0|xss if supposing kvm_xsave cares 
both.
> to enumerate the minimum required size and
> state
For the state, an extreme case is using an old qemu as follows, but a
new kvm with more future_featureZ supported. If hardware vendor arranges
one by one, it's OK to use static state like X86XSaveArea(2) and
get/set between userspace and kvm because it's non-compacted. If not,
the state will not correct.
So far it is OK, so I'm wondering if this would be an issue for now?

X86XSaveArea2 {
     ...
     XSaveAVX
     ...
     AMX_XTILE;
     future_featureX;
     future_featureY;
}

>   that the new ioctl() is available if the min size is greater than 1024?
> Or is that unnecessarily convoluted...
To enable a dynamic size kvm_xsave2(Thanks Jim's name suggestion), if 
things as
follows are what we might want.
/* for xstate large than 1024 */
struct kvm_xsave2 {
     int size; // size of the whole xstate
     void *ptr; // xstate pointer
}
#define KVM_GET_XSAVE2   _IOW(KVMIO,  0xa4, struct kvm_xsave2)

Take @size together, so KVM need not fetch 0xd.1.ebx each time or a 
dedicated
variable.

For Userspace(Qemu):
struct X86XSaveArea2 {...}// new struct holding all features

if 0xd.1.ebx <= sizeof(kvm_xsave)
     env->xsave_buf = alloc(sizeof(kvm_xsave))
     ...
     ioctl(KVM_GET/SET_XSAVE, X86XSaveArea *)
else
     env->xsave_buf = alloc(0xd.1.ebx + sizeof(int))
     ...
     xsave2 = env->xsave_buf
     xsave2->size = ...
X86XSaveArea2 *area2 = xsave2->ptr
ioctl(KVM_GET/SET_XSAVE2, xsave2)
endif

[1] https://lore.kernel.org/kvm/4C10AE1D.40604@redhat.com/

Thanks,
Jing
