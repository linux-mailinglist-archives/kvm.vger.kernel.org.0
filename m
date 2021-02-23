Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E8C322479
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 04:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhBWDIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 22:08:09 -0500
Received: from mga18.intel.com ([134.134.136.126]:39519 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230371AbhBWDIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 22:08:06 -0500
IronPort-SDR: I8wXa8ArozbdbxPwY53kk5faNHIMnlQrp+QCWQlkM0D78onUvC1p8l3h/a6rnRWCSvriJcCtGM
 NiAqvaiBEibw==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="172328668"
X-IronPort-AV: E=Sophos;i="5.81,199,1610438400"; 
   d="scan'208";a="172328668"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 19:06:20 -0800
IronPort-SDR: /6nIHWVZ2rpqTZY1ehs80a1kmL2cWW/xE31i8LO+JI9Cxx8taUxDi58kqjnss8+AUxM1dUD9GM
 PXRmw2W6g5eQ==
X-IronPort-AV: E=Sophos;i="5.81,199,1610438400"; 
   d="scan'208";a="402919857"
Received: from unknown (HELO [10.238.130.200]) ([10.238.130.200])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 19:06:16 -0800
Subject: Re: [PATCH v1] kvm: x86: Revise guest_fpu xcomp_bv field
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210208161659.63020-1-jing2.liu@linux.intel.com>
 <4e4b37d1-e2f8-6757-003c-d19ae8184088@intel.com>
 <YCFzztFESzcnKRqQ@google.com>
 <c33335d3-abbe-04e0-2fa1-47f57ad154ac@linux.intel.com>
 <YDPWn70DTA64psQb@google.com>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <9d23ae5b-9b85-88d7-a2d7-44fd75a068b9@linux.intel.com>
Date:   Tue, 23 Feb 2021 11:06:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YDPWn70DTA64psQb@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/23/2021 12:06 AM, Sean Christopherson wrote:
> On Mon, Feb 22, 2021, Liu, Jing2 wrote:
>> On 2/9/2021 1:24 AM, Sean Christopherson wrote:
>>> On Mon, Feb 08, 2021, Dave Hansen wrote:
>>>> On 2/8/21 8:16 AM, Jing Liu wrote:
>>>>> -#define XSTATE_COMPACTION_ENABLED (1ULL << 63)
>>>>> -
>>>>>    static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
>>>>>    {
>>>>>    	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
>>>>> @@ -4494,7 +4492,8 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
>>>>>    	/* Set XSTATE_BV and possibly XCOMP_BV.  */
>>>>>    	xsave->header.xfeatures = xstate_bv;
>>>>>    	if (boot_cpu_has(X86_FEATURE_XSAVES))
>>>>> -		xsave->header.xcomp_bv = host_xcr0 | XSTATE_COMPACTION_ENABLED;
>>>>> +		xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT |
>>>>> +					 xfeatures_mask_all;
>>> This is wrong, xfeatures_mask_all also tracks supervisor states.
>> When looking at SDM Vol2 XSAVES instruction Operation part, it says as
>> follows,
>>
>> RFBM ← (XCR0 OR IA32_XSS) AND EDX:EAX;
>> COMPMASK ← RFBM OR 80000000_00000000H;
>> ...
>>
>> XCOMP_BV field in XSAVE header ← COMPMASK;
>>
>>
>> So it seems xcomp_bv also tracks supervisor states?
> Yes, sorry, I got distracted by Dave's question and didn't read the changelog
> closely.
>
> Now that I have, I find "Since fpstate_init() has initialized xcomp_bv, let's
> just use that." confusing.  I think what you intend to say is that we can use
> the same _logic_ as fpstate_init_xstate() for calculating xcomp_bv.
Yes, that's the idea.
>
> That said, it would be helpful for the changelog to explain why it's correct to
> use xfeatures_mask_all, e.g. just a short comment stating that the variable holds
> all XCR0 and XSS bits enabled by the host kernel.  Justifying a change with
> "because other code does it" is sketchy, becuse there's no guarantee that what
> something else does is also correct for KVM, or that the existing code itself is
> even correct.
Got it, thanks for the details on this.
Then how about making the commit message like,

XCOMP_BV[63] field indicates that the save area is in the
compacted format and XCOMP_BV[62:0] indicates the states that
have space allocated in the save area, including both XCR0
and XSS bits enable by the host kernel. Use xfeatures_mask_all
for calculating xcomp_bv and reuse XCOMP_BV_COMPACTED_FORMAT
defined by kernel.

Thanks,
Jing


