Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7FC399949
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 06:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhFCErh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 00:47:37 -0400
Received: from mga12.intel.com ([192.55.52.136]:46186 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhFCErg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 00:47:36 -0400
IronPort-SDR: a7FirUorfyESjHpnMySjF9+6GB5gpH+8KBWd1NioYhQVBccdRw/rxfVpormyoBQSHm1E5LGkL5
 cncb6XHowd2w==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="183642855"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="183642855"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 21:45:52 -0700
IronPort-SDR: QkmUXKjZNGN4p0iLIEClnuOw9FSNsKVXIa7CUSxsPNjQv4UKKD4DTUtHAdO6fHaETL8klEXhT3
 y6+cGbztBV9A==
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="447702699"
Received: from unknown (HELO [10.238.130.169]) ([10.238.130.169])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 21:45:50 -0700
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Subject: Re: [PATCH RFC 5/7] kvm: x86: Revise CPUID.D.1.EBX for alignment rule
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-6-jing2.liu@linux.intel.com>
 <YKwagHvhqiY1rrAI@google.com>
Message-ID: <edb5ae3f-3c7f-0647-d586-98a9e3e15249@linux.intel.com>
Date:   Thu, 3 Jun 2021 12:45:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YKwagHvhqiY1rrAI@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/25/2021 5:28 AM, Sean Christopherson wrote:
> On Sun, Feb 07, 2021, Jing Liu wrote:
>> CPUID.0xD.1.EBX[1] is set if, when the compacted format of an XSAVE
>> area is used, this extended state component located on the next
>> 64-byte boundary following the preceding state component (otherwise,
>> it is located immediately following the preceding state component).
>>
>> AMX tileconfig and tiledata are the first to use 64B alignment.
>> Revise the runtime cpuid modification for this rule.
>>
>> Signed-off-by: Jing Liu<jing2.liu@linux.intel.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 04a73c395c71..ee1fac0a865e 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -35,12 +35,17 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
>>   {
>>   	int feature_bit = 0;
>>   	u32 ret = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
>> +	bool is_aligned = false;
>>   
>>   	xstate_bv &= XFEATURE_MASK_EXTEND;
>>   	while (xstate_bv) {
>>   		if (xstate_bv & 0x1) {
>>   		        u32 eax, ebx, ecx, edx, offset;
>>   		        cpuid_count(0xD, feature_bit, &eax, &ebx, &ecx, &edx);
>> +			/* ECX[2]: 64B alignment in compacted form */
>> +			is_aligned = !!(ecx & 2);
>> +			if (is_aligned && compacted)
> I'd forego the local is_aligned, and also check "compacted" first so that the
> uncompacted variant isn't required to evaluated ecx.
Non-compacted only works for XCR0 (user states), do we need add a check 
or simply do
'state_bv &= XFEATURE_MASK_USER_ENABLED'?

         xstate_bv &= XFEATURE_MASK_EXTEND;
+       /* Only user states use non-compacted format. */
+       if (!compacted)
+               xstate_bv &= XFEATURE_MASK_USER_SUPPORTED;
+
         while (xstate_bv) {
                 if (xstate_bv & 0x1) {
                         u32 eax, ebx, ecx, edx, offset;
                         cpuid_count(0xD, feature_bit, &eax, &ebx, &ecx, 
&edx);
-                       offset = compacted ? ret : ebx;
+                       offset = compacted ? ((ecx & 0x2) ? ALIGN(ret, 
64) : ret) : ebx;
                         ret = max(ret, offset + eax);
                 }

>
> And the real reason I am responding... can you post this as a standalone patch?
Sure. Let me separate it.
> I stumbled across the "aligned" flag when reading through the SDM for a completely
> unrelated reason, and also discovered that the flag has been documented since
> 2016.  While AMX may be the first to "officially" utilize the alignment flag,
> the flag itself is architectural and not strictly limited to AMX.
Yes, this is not a new feature, but seems no one use it before.

Thanks,
Jing
>> +				ret = ALIGN(ret, 64);
>>   			offset = compacted ? ret : ebx;
>>   			ret = max(ret, offset + eax);
>>   		}
>> -- 
>> 2.18.4
>>

