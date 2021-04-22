Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E4B368317
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 17:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237865AbhDVPMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 11:12:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40234 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236975AbhDVPMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 11:12:23 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lZaza-0004D1-SE; Thu, 22 Apr 2021 15:11:46 +0000
Subject: Re: [PATCH][next] KVM: x86: simplify zero'ing of entry->ebx
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210422141129.250525-1-colin.king@canonical.com>
 <YIGRTfMm0MfypN22@google.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <a5e1caeb-f298-e7b2-9132-17aa8f249cec@canonical.com>
Date:   Thu, 22 Apr 2021 16:11:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YIGRTfMm0MfypN22@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/2021 16:07, Sean Christopherson wrote:
> On Thu, Apr 22, 2021, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Currently entry->ebx is being zero'd by masking itself with zero.
>> Simplify this by just assigning zero, cleans up static analysis
>> warning.
>>
>> Addresses-Coverity: ("Bitwise-and with zero")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  arch/x86/kvm/cpuid.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 57744a5d1bc2..9bcc2ff4b232 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -851,7 +851,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>  		entry->eax &= SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT |
>>  			      SGX_ATTR_PROVISIONKEY | SGX_ATTR_EINITTOKENKEY |
>>  			      SGX_ATTR_KSS;
>> -		entry->ebx &= 0;
>> +		entry->ebx = 0;
> 
> I 100% understand the code is funky, but using &= is intentional.  ebx:eax holds
> a 64-bit value that is a effectively a set of feature flags.  While the upper
> 32 bits are extremely unlikely to be used any time soon, if a feature comes
> along then the correct behavior would be:
> 
> 		entry->ebx &= SGX_ATTR_FANCY_NEW_FEATURE;
> 
> While directly setting entry->ebx would be incorrect.  The idea is to set up a
> future developer for success so that they don't forget to add the "&".
> 
> TL;DR: I'd prefer to keep this as is, even though it's rather ridiculous.

OK, makes sense. Thanks for explaining.

> 
>>  		break;
>>  	/* Intel PT */
>>  	case 0x14:
>> -- 
>> 2.30.2
>>

