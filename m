Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B771320FB5
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 04:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhBVDXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Feb 2021 22:23:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:56524 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229943AbhBVDXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Feb 2021 22:23:11 -0500
IronPort-SDR: wHIj+f7amBA0Nc7Hefpr88jW3qhxcIA5G1OccQaTPulDRaiqwBxPrUVkQb4dxELjW6xqFwwRkT
 iuL522IroxKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9902"; a="184435075"
X-IronPort-AV: E=Sophos;i="5.81,195,1610438400"; 
   d="scan'208";a="184435075"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2021 19:21:17 -0800
IronPort-SDR: JqI88i/XKbymHjhVCWhJngVe9t3aDgKCGeo3DSjkbsC3HshwVpMYpqazxIRN7vjgAFCFLjdQ0k
 YLuNXYmMtEFA==
X-IronPort-AV: E=Sophos;i="5.81,195,1610438400"; 
   d="scan'208";a="441238706"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.130.120]) ([10.238.130.120])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2021 19:21:08 -0800
Subject: Re: [PATCH v1] kvm: x86: Revise guest_fpu xcomp_bv field
To:     Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     pbonzini@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
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
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <c33335d3-abbe-04e0-2fa1-47f57ad154ac@linux.intel.com>
Date:   Mon, 22 Feb 2021 11:21:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YCFzztFESzcnKRqQ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/9/2021 1:24 AM, Sean Christopherson wrote:
> On Mon, Feb 08, 2021, Dave Hansen wrote:
>> On 2/8/21 8:16 AM, Jing Liu wrote:
>>> -#define XSTATE_COMPACTION_ENABLED (1ULL << 63)
>>> -
>>>   static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
>>>   {
>>>   	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
>>> @@ -4494,7 +4492,8 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
>>>   	/* Set XSTATE_BV and possibly XCOMP_BV.  */
>>>   	xsave->header.xfeatures = xstate_bv;
>>>   	if (boot_cpu_has(X86_FEATURE_XSAVES))
>>> -		xsave->header.xcomp_bv = host_xcr0 | XSTATE_COMPACTION_ENABLED;
>>> +		xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT |
>>> +					 xfeatures_mask_all;
> This is wrong, xfeatures_mask_all also tracks supervisor states.
When looking at SDM Vol2 XSAVES instruction Operation part, it says as 
follows,

RFBM ← (XCR0 OR IA32_XSS) AND EDX:EAX;
COMPMASK ← RFBM OR 80000000_00000000H;
...

XCOMP_BV field in XSAVE header ← COMPMASK;


So it seems xcomp_bv also tracks supervisor states?

BRs,
Jing
>
>> Are 'host_xcr0' and 'xfeatures_mask_all' really interchangeable?  If so,
>> shouldn't we just remove 'host_xcr0' everywhere?
> I think so?  But use xfeatures_mask_user().
>
> In theory, host_xss can also be replaced with the _supervisor() and _dynamic()
> variants.  That code needs a good hard look at the _dynamic() features, which is
> currently just architectural LBRs.  E.g. I wouldn't be surprised if KVM currently
> fails to save/restore arch LBRs due to the bit not being set in host_xss.

