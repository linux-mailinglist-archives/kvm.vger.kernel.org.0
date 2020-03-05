Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E38DD17A029
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 07:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgCEGtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 01:49:06 -0500
Received: from mga18.intel.com ([134.134.136.126]:61801 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgCEGtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 01:49:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 22:49:05 -0800
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="234320571"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.168.47]) ([10.249.168.47])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 04 Mar 2020 22:49:01 -0800
Subject: Re: [PATCH v3 3/8] x86/split_lock: Cache the value of MSR_TEST_CTRL
 in percpu data
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com,
        peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
 <20200206070412.17400-4-xiaoyao.li@intel.com>
 <20200303191833.GT1439@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <e0bd572e-2f4f-743b-1df8-4d76e13d04ba@intel.com>
Date:   Thu, 5 Mar 2020 14:48:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303191833.GT1439@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/2020 3:18 AM, Sean Christopherson wrote:
> On Thu, Feb 06, 2020 at 03:04:07PM +0800, Xiaoyao Li wrote:
>> Cache the value of MSR_TEST_CTRL in percpu data msr_test_ctrl_cache,
>> which will be used by KVM module.
>>
>> It also avoids an expensive RDMSR instruction if SLD needs to be context
>> switched.
>>
>> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/include/asm/cpu.h  |  2 ++
>>   arch/x86/kernel/cpu/intel.c | 19 ++++++++++++-------
>>   2 files changed, 14 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
>> index ff567afa6ee1..2b20829db450 100644
>> --- a/arch/x86/include/asm/cpu.h
>> +++ b/arch/x86/include/asm/cpu.h
>> @@ -27,6 +27,8 @@ struct x86_cpu {
>>   };
>>   
>>   #ifdef CONFIG_HOTPLUG_CPU
>> +DECLARE_PER_CPU(u64, msr_test_ctrl_cache);
>> +
>>   extern int arch_register_cpu(int num);
>>   extern void arch_unregister_cpu(int);
>>   extern void start_cpu0(void);
>> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
>> index 49535ed81c22..ff27d026cb4a 100644
>> --- a/arch/x86/kernel/cpu/intel.c
>> +++ b/arch/x86/kernel/cpu/intel.c
>> @@ -46,6 +46,9 @@ enum split_lock_detect_state {
>>    */
>>   static enum split_lock_detect_state sld_state = sld_off;
>>   
>> +DEFINE_PER_CPU(u64, msr_test_ctrl_cache);
>> +EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctrl_cache);
>> +
>>   /*
>>    * Processors which have self-snooping capability can handle conflicting
>>    * memory type across CPUs by snooping its own cache. However, there exists
>> @@ -1043,20 +1046,22 @@ static void __init split_lock_setup(void)
>>    */
>>   static void __sld_msr_set(bool on)
>>   {
>> -	u64 test_ctrl_val;
>> -
>> -	rdmsrl(MSR_TEST_CTRL, test_ctrl_val);
>> -
>>   	if (on)
>> -		test_ctrl_val |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
>> +		this_cpu_or(msr_test_ctrl_cache, MSR_TEST_CTRL_SPLIT_LOCK_DETECT);
>>   	else
>> -		test_ctrl_val &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
>> +		this_cpu_and(msr_test_ctrl_cache, ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT);
> 
> Updating the cache is at best unnecessary, and at worst dangerous, e.g. it
> incorrectly implies that the cached value of SPLIT_LOCK_DETECT is reliable.
> 
> Tony's patch[*] is more what I had in mind, the only question is whether the
> kernel should be paranoid about other bits in MSR_TEST_CTL.

OK, I'll use Tony's patch.

> [*] 20200206004944.GA11455@agluck-desk2.amr.corp.intel.com
> 
>> -	wrmsrl(MSR_TEST_CTRL, test_ctrl_val);
>> +	wrmsrl(MSR_TEST_CTRL, this_cpu_read(msr_test_ctrl_cache));
>>   }
>>   
>>   static void split_lock_init(void)
>>   {
>> +	u64 test_ctrl_val;
>> +
>> +	/* Cache MSR TEST_CTRL */
>> +	rdmsrl(MSR_TEST_CTRL, test_ctrl_val);
>> +	this_cpu_write(msr_test_ctrl_cache, test_ctrl_val);
>> +
>>   	if (sld_state == sld_off)
>>   		return;
>>   
>> -- 
>> 2.23.0
>>

