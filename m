Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8B01DC82D
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 10:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgEUIDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 04:03:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:28815 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgEUIDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 04:03:11 -0400
IronPort-SDR: xQeBQhK3A+gGS6Pc8JQnynuhDZqd9dkP982zUL3PgrEL36LCdzuwJzRZwJMiifMgdQw5Ic/Ptu
 C2wC17KSescg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 01:03:11 -0700
IronPort-SDR: mdzcInu+nHsVQ4gPEiQktmNc+k7tQTG45ABEezbov/pH+l/dqt+52wfsKxEk+ChpVmvmCzvpUu
 E2rh4t+IddYA==
X-IronPort-AV: E=Sophos;i="5.73,417,1583222400"; 
   d="scan'208";a="440355710"
Received: from unknown (HELO [10.239.13.122]) ([10.239.13.122])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 01:03:09 -0700
Subject: Re: [PATCH 2/2] kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL
 unconditionally
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20200520160740.6144-1-mlevitsk@redhat.com>
 <20200520160740.6144-3-mlevitsk@redhat.com>
 <874ksatvkr.fsf@vitty.brq.redhat.com>
 <0c1a0c81bbdcfaf4ae9af545f4a38439b1a56d11.camel@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <d22e9a18-14eb-8214-976a-72b76edb0dc3@intel.com>
Date:   Thu, 21 May 2020 16:03:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <0c1a0c81bbdcfaf4ae9af545f4a38439b1a56d11.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/2020 12:56 AM, Maxim Levitsky wrote:
> On Wed, 2020-05-20 at 18:33 +0200, Vitaly Kuznetsov wrote:
>> Maxim Levitsky <mlevitsk@redhat.com> writes:
>>
>>> This msr is only available when the host supports WAITPKG feature.
>>>
>>> This breaks a nested guest, if the L1 hypervisor is set to ignore
>>> unknown msrs, because the only other safety check that the
>>> kernel does is that it attempts to read the msr and
>>> rejects it if it gets an exception.
>>>
>>> Fixes: 6e3ba4abce KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
>>>
>>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>>> ---
>>>   arch/x86/kvm/x86.c | 4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index fe3a24fd6b263..9c507b32b1b77 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -5314,6 +5314,10 @@ static void kvm_init_msr_list(void)
>>>   			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
>>>   			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>>>   				continue;
>>> +			break;
>>> +		case MSR_IA32_UMWAIT_CONTROL:
>>> +			if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
>>> +				continue;
>>
>> I'm probably missing something but (if I understand correctly) the only
>> effect of dropping MSR_IA32_UMWAIT_CONTROL from msrs_to_save would be
>> that KVM userspace won't see it in e.g. KVM_GET_MSR_INDEX_LIST. But why
>> is this causing an issue? I see both vmx_get_msr()/vmx_set_msr() have
>> 'host_initiated' check:
>>
>>         case MSR_IA32_UMWAIT_CONTROL:
>>                  if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
>>                          return 1;
> 
> Here it fails like that:
> 
> 1. KVM_GET_MSR_INDEX_LIST returns this msrs, and qemu notes that
>     it is supported in 'has_msr_umwait' global var

In general, KVM_GET_MSR_INDEX_LIST won't return MSR_IA32_UMWAIT_CONTROL 
if KVM cannot read this MSR, see kvm_init_msr_list().

You hit issue because you used "ignore_msrs".



