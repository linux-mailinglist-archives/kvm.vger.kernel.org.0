Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21393DD1D9
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 10:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhHBIW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 04:22:59 -0400
Received: from mga18.intel.com ([134.134.136.126]:50020 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232562AbhHBIW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 04:22:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10063"; a="200614779"
X-IronPort-AV: E=Sophos;i="5.84,288,1620716400"; 
   d="scan'208";a="200614779"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 01:22:49 -0700
X-IronPort-AV: E=Sophos;i="5.84,288,1620716400"; 
   d="scan'208";a="509975082"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.238.0.133]) ([10.238.0.133])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 01:22:44 -0700
Subject: Re: [PATCH 1/6] x86/feat_ctl: Add new VMX feature, Tertiary
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
References: <20210716064808.14757-1-guang.zeng@intel.com>
 <20210716064808.14757-2-guang.zeng@intel.com> <YQHr6VvNOQclolfc@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
Message-ID: <ad88a2ed-536e-deae-2428-278346a43d30@intel.com>
Date:   Mon, 2 Aug 2021 16:22:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQHr6VvNOQclolfc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/2021 7:44 AM, Sean Christopherson wrote:
> On Fri, Jul 16, 2021, Zeng Guang wrote:
>> From: Robert Hoo <robert.hu@linux.intel.com>
>>
>> New VMX capability MSR IA32_VMX_PROCBASED_CTLS3 conresponse to this new
>> VM-Execution control field. And it is 64bit allow-1 semantics, not like
>> previous capability MSRs 32bit allow-0 and 32bit allow-1. So with Tertiary
>> VM-Execution control field introduced, 2 vmx_feature leaves are introduced,
>> TERTIARY_CTLS_LOW and TERTIARY_CTLS_HIGH.
> ...
>
>>   /*
>>    * Note: If the comment begins with a quoted string, that string is used
>> @@ -43,6 +43,7 @@
>>   #define VMX_FEATURE_RDTSC_EXITING	( 1*32+ 12) /* "" VM-Exit on RDTSC */
>>   #define VMX_FEATURE_CR3_LOAD_EXITING	( 1*32+ 15) /* "" VM-Exit on writes to CR3 */
>>   #define VMX_FEATURE_CR3_STORE_EXITING	( 1*32+ 16) /* "" VM-Exit on reads from CR3 */
>> +#define VMX_FEATURE_TER_CONTROLS	(1*32 + 17) /* "" Enable Tertiary VM-Execution Controls */
> Maybe spell out TERTIARY?   SEC_CONTROLS is at least somewhat guessable, I doubt
> TERTIARY is the first thing that comes to mind for most people when seeing "TER" :-)
Agree. TERTIARY could be readable without any confusion.
>>   #define VMX_FEATURE_CR8_LOAD_EXITING	( 1*32+ 19) /* "" VM-Exit on writes to CR8 */
>>   #define VMX_FEATURE_CR8_STORE_EXITING	( 1*32+ 20) /* "" VM-Exit on reads from CR8 */
>>   #define VMX_FEATURE_VIRTUAL_TPR		( 1*32+ 21) /* "vtpr" TPR virtualization, a.k.a. TPR shadow */
>> diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
>> index da696eb4821a..2e0272d127e4 100644
>> --- a/arch/x86/kernel/cpu/feat_ctl.c
>> +++ b/arch/x86/kernel/cpu/feat_ctl.c
>> @@ -15,6 +15,8 @@ enum vmx_feature_leafs {
>>   	MISC_FEATURES = 0,
>>   	PRIMARY_CTLS,
>>   	SECONDARY_CTLS,
>> +	TERTIARY_CTLS_LOW,
>> +	TERTIARY_CTLS_HIGH,
>>   	NR_VMX_FEATURE_WORDS,
>>   };
>>   
>> @@ -42,6 +44,13 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
>>   	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS2, &ign, &supported);
>>   	c->vmx_capability[SECONDARY_CTLS] = supported;
>>   
>> +	/*
>> +	 * For tertiary execution controls MSR, it's actually a 64bit allowed-1.
>> +	 */
>> +	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &ign, &supported);
>> +	c->vmx_capability[TERTIARY_CTLS_LOW] = ign;
>> +	c->vmx_capability[TERTIARY_CTLS_HIGH] = supported;
> Assuming only the lower 32 bits are going to be used for the near future (next
> few years), what about defining just TERTIARY_CTLS_LOW and then doing:
>
> 	/*
> 	 * Tertiary controls are 64-bit allowed-1, so unlikely other MSRs, the
> 	 * upper bits are ignored (because they're not used, yet...).
> 	 */
> 	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &supported, &ign);
> 	c->vmx_capability[TERTIARY_CTLS_LOW] = supported;
>
> I.e. punt the ugliness issue down the road a few years.
Prefer to keep it complete, and use new variables like low/high 
consistent with its function meaning. Ok for that ?
>> +
>>   	rdmsr(MSR_IA32_VMX_PINBASED_CTLS, ign, supported);
>>   	rdmsr_safe(MSR_IA32_VMX_VMFUNC, &ign, &funcs);
>>   
>> -- 
>> 2.25.1
>>
