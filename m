Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C2740FDB6
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 18:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243832AbhIQQRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 12:17:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:26386 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242090AbhIQQRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 12:17:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="210059600"
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="210059600"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 09:15:57 -0700
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="546478915"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.208.219]) ([10.254.208.219])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 09:15:52 -0700
Subject: Re: [PATCH v4 3/6] KVM: VMX: Detect Tertiary VM-Execution control
 when setup VMCS config
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
 <20210809032925.3548-4-guang.zeng@intel.com> <YTvPu0REr+Wg3/s3@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
Message-ID: <60d6f343-058a-5fbe-5265-ccb38689bb93@intel.com>
Date:   Sat, 18 Sep 2021 00:15:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YTvPu0REr+Wg3/s3@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/2021 5:35 AM, Sean Christopherson wrote:
> On Mon, Aug 09, 2021, Zeng Guang wrote:
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 927a552393b9..ee8c5664dc95 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2391,6 +2391,23 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
>>   	return 0;
>>   }
>>   
>> +static __init int adjust_vmx_controls_64(u64 ctl_min, u64 ctl_opt,
>> +					 u32 msr, u64 *result)
>> +{
>> +	u64 vmx_msr;
>> +	u64 ctl = ctl_min | ctl_opt;
>> +
>> +	rdmsrl(msr, vmx_msr);
>> +	ctl &= vmx_msr; /* bit == 1 means it can be set */
>> +
>> +	/* Ensure minimum (required) set of control bits are supported. */
>> +	if (ctl_min & ~ctl)
>> +		return -EIO;
>> +
>> +	*result = ctl;
>> +	return 0;
>> +}
> More succinctly, since we don't need to force-set bits in the final value:
>
> 	u64 allowed1;
>
> 	rdmsrl(msr, allowed1);
>
> 	/* Ensure minimum (required) set of control bits are supported. */
> 	if (ctl_min & ~allowed1)
> 		return -EIO;
>
> 	*result = (ctl_min | ctl_opt) & allowed1;
> 	return 0;
Yes, it becomes more concise. I will change it . Thanks.
>>   static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>   				    struct vmx_capability *vmx_cap)
>>   {
