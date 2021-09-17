Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469EA40FD9C
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 18:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243486AbhIQQM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 12:12:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:23788 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235075AbhIQQM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 12:12:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="220942979"
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="220942979"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 09:11:33 -0700
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="546477445"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.208.219]) ([10.254.208.219])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 09:11:28 -0700
Subject: Re: [PATCH v4 1/6] x86/feat_ctl: Add new VMX feature, Tertiary
 VM-Execution control
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
References: <20210809032925.3548-1-guang.zeng@intel.com>
 <20210809032925.3548-2-guang.zeng@intel.com> <YTvNLd0PwX+PijH7@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
Message-ID: <a7b67f08-e4c9-8f03-f193-b442b454c241@intel.com>
Date:   Sat, 18 Sep 2021 00:10:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YTvNLd0PwX+PijH7@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/2021 5:25 AM, Sean Christopherson wrote:
> x86/cpu: is probaby more appropriate, this touches more than just feat_ctl.
>
> On Mon, Aug 09, 2021, Zeng Guang wrote:
>> From: Robert Hoo <robert.hu@linux.intel.com>
>>
>> New VMX capability MSR IA32_VMX_PROCBASED_CTLS3 conresponse to this new
>> VM-Execution control field. And it is 64bit allow-1 semantics, not like
>> previous capability MSRs 32bit allow-0 and 32bit allow-1. So with Tertiary
>> VM-Execution control field introduced, 2 vmx_feature leaves are introduced,
>> TERTIARY_CTLS_LOW and TERTIARY_CTLS_HIGH.
>>
>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> ---
> Nits aside,
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>
>> @@ -22,7 +24,7 @@ enum vmx_feature_leafs {
>>   
>>   static void init_vmx_capabilities(struct cpuinfo_x86 *c)
>>   {
>> -	u32 supported, funcs, ept, vpid, ign;
>> +	u32 supported, funcs, ept, vpid, ign, low, high;
>>   
>>   	BUILD_BUG_ON(NVMXINTS != NR_VMX_FEATURE_WORDS);
>>   
>> @@ -42,6 +44,13 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
>>   	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS2, &ign, &supported);
>>   	c->vmx_capability[SECONDARY_CTLS] = supported;
>>   
>> +	/*
>> +	 * For tertiary execution controls MSR, it's actually a 64bit allowed-1.
>> +	 */
> Maybe something like this to better fit on one line?
>
> 	/* All 64 bits of tertiary controls MSR are allowed-1 settings. */
>
>> +	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &low, &high);
>> +	c->vmx_capability[TERTIARY_CTLS_LOW] = low;
>> +	c->vmx_capability[TERTIARY_CTLS_HIGH] = high;
>> +
>>   	rdmsr(MSR_IA32_VMX_PINBASED_CTLS, ign, supported);
>>   	rdmsr_safe(MSR_IA32_VMX_VMFUNC, &ign, &funcs);
>>   
>> -- 
>> 2.25.1
Thanks for reviewed-by.
