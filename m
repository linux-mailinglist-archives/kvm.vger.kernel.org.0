Return-Path: <kvm+bounces-24926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D5895D3B6
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 18:47:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFE531C20B2A
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 16:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5546A18BC08;
	Fri, 23 Aug 2024 16:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XpCDmHtN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2483A41C69
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724431642; cv=none; b=LGp1WzfoTNeD3awu7BLVuCoBEv0ggNAel8nwXoDErFzZLGktj30PycuXt8jYUUraPDLKf4NwpWhj4f7yVoOctjEwwZ2fQ+xCVSSV2fHa99OORspbL1cTxuU5d1YLV3hjL4TYl9ACvv+Yw/vad7ROi4xDYBKhhoZvIlohn556I3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724431642; c=relaxed/simple;
	bh=B9a2nvCk/b6jYxq3i7iYlRBJSSSlom6CcxjJsnY/1no=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E4Pyy5pdFnQdaAzotjlmhJ7I43G1S758dSzCaPFAPQKsutRGnq2yIOwAEQ+7o2Js5/Im3X2OhQ7rE9x6oyzYQtVmgb7KMt7dnAS3+k/CBgCKMpDPDc4tCt9x2dznbwU0PfqZ3mQ0RRtb9F1rMpeLrQ6xZOTYOnD/pw4J719t3Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=XpCDmHtN; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-71433096e89so2003507b3a.3
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 09:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724431640; x=1725036440; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3mv/oyOLtOBEK37rEmxAvpwCAziAwz2vzc2YGWuhlgo=;
        b=XpCDmHtNOHkTUmNSb5GEfSAoYeFTaTof6rvVdbF6uDlHDHyq8+li6+wsIhcLEqHwPr
         cib3zEiRb6re1vVlx5FpTZkQYnwC6DNe7Nlt3Na0lVE+fVpd5v5czXA2ku59oECKChxS
         NwB0YKRfUW0geMcW+DnVNatfrXUTVGpGWulTQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724431640; x=1725036440;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3mv/oyOLtOBEK37rEmxAvpwCAziAwz2vzc2YGWuhlgo=;
        b=L1VxA/o3AN5w0jWNWhLBil1+ODUKMPA2TGa1EmRjo2i40B5Mvma1w6yHrFQQ8F0TM6
         7fwCdV9loQ67aaesNbT0qofYPl1dV7VqNa5kp2NQczJ5YIHk8WJx4fnFTdTIfnX93Kgi
         zPGrE5+C8B/PH+JdIYckGrO6RsG8P1Hz2nhEM1aHKhUqtjqVSi2lxh/UmY8bUjBstTIM
         bqTDOc0Qcqlk9aIcUcQKuf8x0tHCMTUGGGXl7nSV5ppPV5fwiM1ZV4Sqf750TesxHD0j
         8oVb7MIPxPUzH2Q6HXzDXPO6OSI8bLSPCJ1/aTpEN3gZz6ImyhujrF+4Q/4jSuEAE1DY
         wpng==
X-Forwarded-Encrypted: i=1; AJvYcCWiaxUWhySyIUdo7cakLofSOm9ydkFiRruv20/vRTLqssXx9azMveE2ejGsmIOk79+qFtQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj7M3ewWD7Yf5wWaJg9H8gW93AKVJbVF2cu1oiSRoH2Q5pSBb7
	44uRjyZJ7ekoO/H7TTGGD6UDZhuS/O8DM9T2szMSLlUhGh8cVm3j13Bz4VJekg==
X-Google-Smtp-Source: AGHT+IH7zP7L6mQKYMZ9U79V104103JG2VbXyLaj6sT+aQeh63DXvNsQeerZsvjYbweGFso6yIQlKw==
X-Received: by 2002:a05:6300:42:b0:1c2:a722:92b2 with SMTP id adf61e73a8af0-1cc8a080524mr3700593637.45.1724431640327;
        Fri, 23 Aug 2024 09:47:20 -0700 (PDT)
Received: from [10.0.2.15] (c-67-182-156-18.hsd1.wa.comcast.net. [67.182.156.18])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-714343403b1sm3222603b3a.211.2024.08.23.09.47.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Aug 2024 09:47:20 -0700 (PDT)
Message-ID: <e5fe6cad-9304-479c-944a-8d8456fcdefa@chromium.org>
Date: Fri, 23 Aug 2024 16:47:17 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: x86: AMD's IBPB is not equivalent to Intel's
 IBPB
To: Sean Christopherson <seanjc@google.com>, Jim Mattson <jmattson@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Daniel Sneddon <daniel.sneddon@linux.intel.com>,
 Kai Huang <kai.huang@intel.com>, Sandipan Das <sandipan.das@amd.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240816182533.2478415-1-jmattson@google.com>
 <20240816182533.2478415-2-jmattson@google.com> <ZseOvjOSfvTwmr-6@google.com>
Content-Language: en-US
From: Venkatesh Srinivas <venkateshs@chromium.org>
In-Reply-To: <ZseOvjOSfvTwmr-6@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/22/24 19:17, Sean Christopherson wrote:
> On Fri, Aug 16, 2024, Jim Mattson wrote:
>> >From Intel's documention [1], "CPUID.(EAX=07H,ECX=0):EDX[26]
>> enumerates support for indirect branch restricted speculation (IBRS)
>> and the indirect branch predictor barrier (IBPB)." Further, from [2],
>> "Software that executed before the IBPB command cannot control the
>> predicted targets of indirect branches (4) executed after the command
>> on the same logical processor," where footnote 4 reads, "Note that
>> indirect branches include near call indirect, near jump indirect and
>> near return instructions. Because it includes near returns, it follows
>> that **RSB entries created before an IBPB command cannot control the
>> predicted targets of returns executed after the command on the same
>> logical processor.**" [emphasis mine]
>>
>> On the other hand, AMD's IBPB "may not prevent return branch
>> predictions from being specified by pre-IBPB branch targets" [3].
>>
>> However, some AMD processors have an "enhanced IBPB" [terminology
>> mine] which does clear the return address predictor. This feature is
>> enumerated by CPUID.80000008:EDX.IBPB_RET[bit 30] [4].
>>
>> Adjust the cross-vendor features enumerated by KVM_GET_SUPPORTED_CPUID
>> accordingly.
>>
>> [1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/cpuid-enumeration-and-architectural-msrs.html
>> [2] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/speculative-execution-side-channel-mitigations.html#Footnotes
>> [3] https://www.amd.com/en/resources/product-security/bulletin/amd-sb-1040.html
>> [4] https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/24594.pdf
>>
>> Fixes: 0c54914d0c52 ("KVM: x86: use Intel speculation bugs and features as derived in generic x86 code")
>> Suggested-by: Venkatesh Srinivas <venkateshs@chromium.org>
>> Signed-off-by: Jim Mattson <jmattson@google.com>
> 
> Venkatesh, can I grab a review from you on this?   You know this way better than
> I do, and I honestly don't feel like reading mitigation disclosures right now :-)

Got lost in my mailbox!

Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>

> 
>> ---
>>   v2: Use IBPB_RET to identify semantic equality (Venkatesh)
>>
>>   arch/x86/kvm/cpuid.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 2617be544480..044bdc9e938b 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -690,7 +690,9 @@ void kvm_set_cpu_caps(void)
>>   	kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
>>   	kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
>>   
>> -	if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
>> +	if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
>> +	    boot_cpu_has(X86_FEATURE_AMD_IBPB) &&
>> +	    boot_cpu_has(X86_FEATURE_AMD_IBRS))
>>   		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
>>   	if (boot_cpu_has(X86_FEATURE_STIBP))
>>   		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
>> @@ -759,8 +761,10 @@ void kvm_set_cpu_caps(void)
>>   	 * arch/x86/kernel/cpu/bugs.c is kind enough to
>>   	 * record that in cpufeatures so use them.
>>   	 */
>> -	if (boot_cpu_has(X86_FEATURE_IBPB))
>> +	if (boot_cpu_has(X86_FEATURE_IBPB)) {
>>   		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
>> +		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
>> +	}
>>   	if (boot_cpu_has(X86_FEATURE_IBRS))
>>   		kvm_cpu_cap_set(X86_FEATURE_AMD_IBRS);
>>   	if (boot_cpu_has(X86_FEATURE_STIBP))
>> -- 
>> 2.46.0.184.g6999bdac58-goog
>>

