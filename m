Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E2F331EAC
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 06:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbhCIFcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 00:32:18 -0500
Received: from mga07.intel.com ([134.134.136.100]:19796 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhCIFb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 00:31:59 -0500
IronPort-SDR: 7pZJoSZ1F7aVM1opUOgR0xP4cRYS0OCfT5keBAlKx+JkJ4XA49FsCAh7kgfSWrpXWrnWa77PXq
 RLGACKbbauzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="252188877"
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="252188877"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 21:31:58 -0800
IronPort-SDR: uf4phKz1TYjzv4cjOC+7I5P++yGKncold3EPtLN7RuVyTA48MxO9FBa0NGlxr5VFuH0/Vp1ZRE
 INovo7saS2qQ==
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="447377192"
Received: from unknown (HELO [10.238.130.230]) ([10.238.130.230])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 21:31:54 -0800
Subject: Re: [PATCH v2] KVM: x86: Revise guest_fpu xcomp_bv field
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210225104955.3553-1-jing2.liu@linux.intel.com>
 <YD1//+O57mr2D2Ne@google.com>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <ffb71039-c77d-93d0-1e41-9f29d87d4532@linux.intel.com>
Date:   Tue, 9 Mar 2021 13:31:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YD1//+O57mr2D2Ne@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/2/2021 7:59 AM, Sean Christopherson wrote:
> On Thu, Feb 25, 2021, Jing Liu wrote:
>> XCOMP_BV[63] field indicates that the save area is in the compacted
>> format and XCOMP_BV[62:0] indicates the states that have space allocated
>> in the save area, including both XCR0 and XSS bits enabled by the host
>> kernel. Use xfeatures_mask_all for calculating xcomp_bv and reuse
>> XCOMP_BV_COMPACTED_FORMAT defined by kernel.
>>
>> Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
>> ---
>>   arch/x86/kvm/x86.c | 8 ++------
>>   1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 1b404e4d7dd8..f115493f577d 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4435,8 +4435,6 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
>>   	return 0;
>>   }
>>   
>> -#define XSTATE_COMPACTION_ENABLED (1ULL << 63)
>> -
>>   static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
>>   {
>>   	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
>> @@ -4494,7 +4492,8 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
>>   	/* Set XSTATE_BV and possibly XCOMP_BV.  */
>>   	xsave->header.xfeatures = xstate_bv;
>>   	if (boot_cpu_has(X86_FEATURE_XSAVES))
>> -		xsave->header.xcomp_bv = host_xcr0 | XSTATE_COMPACTION_ENABLED;
>> +		xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT |
>> +					 xfeatures_mask_all;
> Doesn't fill_xsave also need to be updated?  Not with xfeatures_mask_all, but
> to account for arch.ia32_xss?  I believe it's a nop with the current code, since
> supported_xss is zero, but it should be fixed, no?
Yes. For the arch.ia32_xss, I noticed CET 
(https://lkml.org/lkml/2020/7/15/1412)
has posted related change so I didn't touch xstate_bv for fill_xsave for 
now.
Finally, fill_xsave() need e.g. arch.guest_supported_xss for xstate_bv,
for xcomp_bv, xfeatures_mask_all is ok.
>
>>   
>>   	/*
>>   	 * Copy each region from the non-compacted offset to the
>> @@ -9912,9 +9911,6 @@ static void fx_init(struct kvm_vcpu *vcpu)
>>   		return;
>>   
>>   	fpstate_init(&vcpu->arch.guest_fpu->state);
>> -	if (boot_cpu_has(X86_FEATURE_XSAVES))
>> -		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
>> -			host_xcr0 | XSTATE_COMPACTION_ENABLED;
> Ugh, this _really_ needs a comment in the changelog.  It took me a while to
> realize fpstate_init() does exactly what the new fill_xave() is doing.
How about introducing that "fx_init()->fpstate_init() initializes xcomp_bv
of guest_fpu so no need to set again in later fill_xsave() and 
load_xsave()"
in commit message?
>
> And isn't the code in load_xsave() redundant and can be removed?
Oh, yes. Keep fx_init() initializing xcomp_bv for guest_fpu is enough.
Let me remove it in load_xsave later.
And for fill_xsave(), I think no need to set xcomp_bv there.

> Any code that
> uses get_xsave_addr() would be have a dependency on load_xsave() if it's not
> redundant, and I can't see how that would work.
Sorry I didn't quite understand why get_xsave_addr() has dependency on
load_xsave(), do you mean the xstate_bv instead of xcomp_bv, that 
load_xsave()
uses it to get the addr?

Thanks,
Jing
>
>>   
>>   	/*
>>   	 * Ensure guest xcr0 is valid for loading
>> -- 
>> 2.18.4
>>

