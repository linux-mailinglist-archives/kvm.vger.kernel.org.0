Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFC51DC649
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 06:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgEUEdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 00:33:33 -0400
Received: from mga17.intel.com ([192.55.52.151]:50461 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgEUEdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 00:33:33 -0400
IronPort-SDR: fA+nWxifwI6RKjL7alkgoIhH/qX/51BsSmbK8r9NEQwVQZKx2PYOS7y0+Gn/uP3xKldsws8MnS
 eq+2ryjpd1oA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 21:33:32 -0700
IronPort-SDR: CT43a8HatG1xkf9qNaC/adIJD2PMhXHnATR8T0/7G9SttpLbTkKgBVtgNqgQ76EDaFCGpUwbrv
 0vSwoiNt6+Eg==
X-IronPort-AV: E=Sophos;i="5.73,416,1583222400"; 
   d="scan'208";a="440300490"
Received: from unknown (HELO [10.239.13.122]) ([10.239.13.122])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 21:33:31 -0700
Subject: Re: [PATCH 2/2] kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL
 unconditionally
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Tao Xu <tao3.xu@intel.com>
Cc:     linux-kernel@vger.kernel.org
References: <20200520160740.6144-1-mlevitsk@redhat.com>
 <20200520160740.6144-3-mlevitsk@redhat.com>
 <b8ca9ea1-2958-3ab4-2e86-2edbee1ca9d9@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <81228a0e-7797-4f34-3d6d-5b0550c10a8f@intel.com>
Date:   Thu, 21 May 2020 12:33:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <b8ca9ea1-2958-3ab4-2e86-2edbee1ca9d9@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/2020 5:05 AM, Paolo Bonzini wrote:
> On 20/05/20 18:07, Maxim Levitsky wrote:
>> This msr is only available when the host supports WAITPKG feature.
>>
>> This breaks a nested guest, if the L1 hypervisor is set to ignore
>> unknown msrs, because the only other safety check that the
>> kernel does is that it attempts to read the msr and
>> rejects it if it gets an exception.
>>
>> Fixes: 6e3ba4abce KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
>>
>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index fe3a24fd6b263..9c507b32b1b77 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -5314,6 +5314,10 @@ static void kvm_init_msr_list(void)
>>   			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
>>   			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>>   				continue;
>> +			break;
>> +		case MSR_IA32_UMWAIT_CONTROL:
>> +			if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
>> +				continue;
>>   		default:
>>   			break;
>>   		}
> 
> The patch is correct, and matches what is done for the other entries of
> msrs_to_save_all.  However, while looking at it I noticed that
> X86_FEATURE_WAITPKG is actually never added, and that is because it was
> also not added to the supported CPUID in commit e69e72faa3a0 ("KVM: x86:
> Add support for user wait instructions", 2019-09-24), which was before
> the kvm_cpu_cap mechanism was added.
> 
> So while at it you should also fix that.  The right way to do that is to
> add a
> 
>          if (vmx_waitpkg_supported())
>                  kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);

+ Tao

I remember there is certainly some reason why we don't expose WAITPKG to 
guest by default.

Tao, please help clarify it.

Thanks,
-Xiaoyao

> 
> in vmx_set_cpu_caps.
> 
> Thanks,
> 
> Paolo
> 

