Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE1F15517E
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 05:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgBGESu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 23:18:50 -0500
Received: from mga06.intel.com ([134.134.136.31]:62270 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbgBGESu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 23:18:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 20:18:49 -0800
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; 
   d="scan'208";a="225254696"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.30.164]) ([10.255.30.164])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 06 Feb 2020 20:18:46 -0800
Subject: Re: [PATCH v3 3/8] x86/split_lock: Cache the value of MSR_TEST_CTRL
 in percpu data
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com,
        peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
 <20200206070412.17400-4-xiaoyao.li@intel.com>
 <20200206202346.GA2742055@rani.riverdale.lan>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <dfd49ff5-a609-ea8b-a652-846afd0af828@intel.com>
Date:   Fri, 7 Feb 2020 12:18:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200206202346.GA2742055@rani.riverdale.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/7/2020 4:23 AM, Arvind Sankar wrote:
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
> 
> Why does this depend on HOTPLUG_CPU?
> 

Sorry, my bad,

It should be under CONFIG_CPU_SUP_INTEL
