Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48F419033B
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 02:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgCXBQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 21:16:43 -0400
Received: from mga05.intel.com ([192.55.52.43]:36066 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgCXBQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 21:16:43 -0400
IronPort-SDR: /aMfaVSg5FSceJkLsK3jwuo1LKKlpt+2fCsuGMYKto3RdjKZTidojnda0sC25xSzWu2fbsYNdu
 5LNXDF79thyw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 18:16:42 -0700
IronPort-SDR: +5bKU5nywE10PLwFyRSYmQnQF5yjR57dbDpKy53jD0WTBWrSZuEbYAVnXqIn3DxaQqlPo/99Cw
 Jykmq2nej6RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,298,1580803200"; 
   d="scan'208";a="270144231"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.120]) ([10.255.31.120])
  by fmsmga004.fm.intel.com with ESMTP; 23 Mar 2020 18:16:38 -0700
Subject: Re: [PATCH v5 2/9] x86/split_lock: Avoid runtime reads of the
 TEST_CTRL MSR
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com>
 <20200315050517.127446-3-xiaoyao.li@intel.com>
 <87wo7bovb7.fsf@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <ec798425-5c1e-9f00-d4ac-6f420747572c@intel.com>
Date:   Tue, 24 Mar 2020 09:16:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87wo7bovb7.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/24/2020 1:06 AM, Thomas Gleixner wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>> +/*
>> + * Soft copy of MSR_TEST_CTRL initialized when we first read the
>> + * MSR. Used at runtime to avoid using rdmsr again just to collect
>> + * the reserved bits in the MSR. We assume reserved bits are the
>> + * same on all CPUs.
>> + */
>> +static u64 test_ctrl_val;
>> +
>>   /*
>>    * Locking is not required at the moment because only bit 29 of this
>>    * MSR is implemented and locking would not prevent that the operation
>> @@ -1027,16 +1035,14 @@ static void __init split_lock_setup(void)
>>    */
>>   static void __sld_msr_set(bool on)
>>   {
>> -	u64 test_ctrl_val;
>> -
>> -	rdmsrl(MSR_TEST_CTRL, test_ctrl_val);
>> +	u64 val = test_ctrl_val;
>>   
>>   	if (on)
>> -		test_ctrl_val |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
>> +		val |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
>>   	else
>> -		test_ctrl_val &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
>> +		val &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
>>   
>> -	wrmsrl(MSR_TEST_CTRL, test_ctrl_val);
>> +	wrmsrl(MSR_TEST_CTRL, val);
>>   }
>>   
>>   /*
>> @@ -1048,11 +1054,13 @@ static void __sld_msr_set(bool on)
>>    */
>>   static void split_lock_init(struct cpuinfo_x86 *c)
>>   {
>> -	u64 test_ctrl_val;
>> +	u64 val;
>>   
>> -	if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val))
>> +	if (rdmsrl_safe(MSR_TEST_CTRL, &val))
>>   		goto msr_broken;
>>   
>> +	test_ctrl_val = val;
>> +
>>   	switch (sld_state) {
>>   	case sld_off:
>>   		if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val & ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
> 
> That's just broken. Simply because
> 
>         case sld_warn:
>         case sld_fatal:
> 
> set the split lock detect bit, but the cache variable has it cleared
> unless it was set at boot time already.

The test_ctrl_val is not to cache the value of MSR_TEST_CTRL, but cache 
the reserved/unused bits other than MSR_TEST_CTRL_SPLIT_LOCK_DETECT bit.

> Thanks,
> 
>          tglx
> 

