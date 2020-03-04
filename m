Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3E91787BA
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 02:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387452AbgCDBtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 20:49:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:61231 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387431AbgCDBtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 20:49:21 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 17:49:21 -0800
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="233852895"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.22]) ([10.255.31.22])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 03 Mar 2020 17:49:17 -0800
Subject: Re: [PATCH v3 2/8] x86/split_lock: Ensure
 X86_FEATURE_SPLIT_LOCK_DETECT means the existence of feature
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com,
        peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
 <20200206070412.17400-3-xiaoyao.li@intel.com>
 <20200303185524.GQ1439@linux.intel.com>
 <20200303194134.GW1439@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <ab2a83e1-8ae4-b471-1968-7f6baaac602e@intel.com>
Date:   Wed, 4 Mar 2020 09:49:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303194134.GW1439@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/2020 3:41 AM, Sean Christopherson wrote:
> On Tue, Mar 03, 2020 at 10:55:24AM -0800, Sean Christopherson wrote:
>> On Thu, Feb 06, 2020 at 03:04:06PM +0800, Xiaoyao Li wrote:
>>> When flag X86_FEATURE_SPLIT_LOCK_DETECT is set, it should ensure the
>>> existence of MSR_TEST_CTRL and MSR_TEST_CTRL.SPLIT_LOCK_DETECT bit.
>>
>> The changelog confused me a bit.  "When flag X86_FEATURE_SPLIT_LOCK_DETECT
>> is set" makes it sound like the logic is being applied after the feature
>> bit is set.  Maybe something like:
>>
>> ```
>> Verify MSR_TEST_CTRL.SPLIT_LOCK_DETECT can be toggled via WRMSR prior to
>> setting the SPLIT_LOCK_DETECT feature bit so that runtime consumers,
>> e.g. KVM, don't need to worry about WRMSR failure.
>> ```
>>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> ---
>>>   arch/x86/kernel/cpu/intel.c | 41 +++++++++++++++++++++----------------
>>>   1 file changed, 23 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
>>> index 2b3874a96bd4..49535ed81c22 100644
>>> --- a/arch/x86/kernel/cpu/intel.c
>>> +++ b/arch/x86/kernel/cpu/intel.c
>>> @@ -702,7 +702,8 @@ static void init_intel(struct cpuinfo_x86 *c)
>>>   	if (tsx_ctrl_state == TSX_CTRL_DISABLE)
>>>   		tsx_disable();
>>>   
>>> -	split_lock_init();
>>> +	if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
>>> +		split_lock_init();
>>>   }
>>>   
>>>   #ifdef CONFIG_X86_32
>>> @@ -986,9 +987,26 @@ static inline bool match_option(const char *arg, int arglen, const char *opt)
>>>   
>>>   static void __init split_lock_setup(void)
>>>   {
>>> +	u64 test_ctrl_val;
>>>   	char arg[20];
>>>   	int i, ret;
>>> +	/*
>>> +	 * Use the "safe" versions of rdmsr/wrmsr here to ensure MSR_TEST_CTRL
>>> +	 * and MSR_TEST_CTRL.SPLIT_LOCK_DETECT bit do exist. Because there may
>>> +	 * be glitches in virtualization that leave a guest with an incorrect
>>> +	 * view of real h/w capabilities.
>>> +	 */
>>> +	if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val))
>>> +		return;
>>> +
>>> +	if (wrmsrl_safe(MSR_TEST_CTRL,
>>> +			test_ctrl_val | MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
>>> +		return;
>>> +
>>> +	if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val))
>>> +		return;a
>>
>> Probing the MSR should be skipped if SLD is disabled in sld_options, i.e.
>> move this code (and setup_force_cpu_cap() etc...) down below the
>> match_option() logic.  The above would temporarily enable SLD even if the
>> admin has explicitly disabled it, e.g. makes the kernel param useless for
>> turning off the feature due to bugs.
> 
> Hmm, but this prevents KVM from exposing SLD to a guest when it's off in
> the kernel, which would be a useful debug/testing scenario.
> 
> Maybe add another SLD state to forcefully disable SLD?  That way the admin
> can turn of SLD in the host kernel but still allow KVM to expose it to its
> guests.  E.g.

I don't think we need do this.

IMO, this a the bug of split_lock_init(), which assume the initial value 
of MSR_TEST_CTRL is zero, at least bit SPLIT_LOCK of which is zero.
This is problem, it's possible that BIOS has set this bit.

split_lock_setup() here, is to check if the feature really exists. So 
probing MSR_TEST_CTRL and bit MSR_TEST_CTRL_SPLIT_LOCK_DETECT here. If 
there all exist, setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT) to 
indicate feature does exist.
Only when feature exists, there is a need to parse the command line 
config of split_lock_detect.

In split_lock_init(), we should explicitly clear 
MSR_TEST_CTRL_SPLIT_LOCK_DETECT bit if sld_off.

> static const struct {
>          const char                      *option;
>          enum split_lock_detect_state    state;
> } sld_options[] __initconst = {
> 	{ "disable",	sld_disable },
>          { "off",        sld_off     },
>          { "warn",       sld_warn    },
>          { "fatal",      sld_fatal   },
> };
> 
> 
> Then the new setup() becomes:
> 
> static void __init split_lock_setup(void)
> {
>          u64 test_ctrl_val;
>          char arg[20];
>          int i, ret;
> 
>          sld_state = sld_warn;
> 
>          ret = cmdline_find_option(boot_command_line, "split_lock_detect",
>                                    arg, sizeof(arg));
>          if (ret >= 0) {
>                  for (i = 0; i < ARRAY_SIZE(sld_options); i++) {
>                          if (match_option(arg, ret, sld_options[i].option)) {
>                                  sld_state = sld_options[i].state;
>                                  break;
>                          }
>                  }
>          }
> 
>          if (sld_state == sld_disable)
>                  goto log_sld;
> 
>          /*
>           * Use the "safe" versions of rdmsr/wrmsr here to ensure MSR_TEST_CTRL
>           * and MSR_TEST_CTRL.SPLIT_LOCK_DETECT bit do exist. Because there may
>           * be glitches in virtualization that leave a guest with an incorrect
>           * view of real h/w capabilities.
>           */
>          if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val))
>                  goto sld_broken;
> 
>          if (wrmsrl_safe(MSR_TEST_CTRL,
>                          test_ctrl_val | MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
>                  goto sld_broken;
> 
>          if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val))
>                  goto sld_broken;
> 
>          setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
> 
> log_sld:
>          switch (sld_state) {
>          case sld_disable:
>                  pr_info("split_lock detection disabled\n");
>                  break;
>          case sld_off:
>                  pr_info("split_lock detection off in kernel\n");
>                  break;
>          case sld_warn:
>                  pr_info("warning about user-space split_locks\n");
>                  break;
>          case sld_fatal:
>                  pr_info("sending SIGBUS on user-space split_locks\n");
>                  break;
>          }
> 
>          return;
> 
> sld_broken:
>          sld_state = sld_disable;
>          pr_err("split_lock detection disabled, MSR access faulted\n");
> }
> 
>> And with that, IMO failing any of RDMSR/WRSMR here warrants a pr_err().
>> The CPU says it supports split lock and the admin hasn't explicitly turned
>> it off, so failure to enable should be logged.
>>
>>> +
>>>   	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
>>>   	sld_state = sld_warn;
>>>   
>>> @@ -1022,24 +1040,19 @@ static void __init split_lock_setup(void)
>>>    * Locking is not required at the moment because only bit 29 of this
>>>    * MSR is implemented and locking would not prevent that the operation
>>>    * of one thread is immediately undone by the sibling thread.
>>> - * Use the "safe" versions of rdmsr/wrmsr here because although code
>>> - * checks CPUID and MSR bits to make sure the TEST_CTRL MSR should
>>> - * exist, there may be glitches in virtualization that leave a guest
>>> - * with an incorrect view of real h/w capabilities.
>>>    */
>>> -static bool __sld_msr_set(bool on)
>>> +static void __sld_msr_set(bool on)
>>>   {
>>>   	u64 test_ctrl_val;
>>>   
>>> -	if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val))
>>> -		return false;
>>> +	rdmsrl(MSR_TEST_CTRL, test_ctrl_val);
>>>   
>>>   	if (on)
>>>   		test_ctrl_val |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
>>>   	else
>>>   		test_ctrl_val &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
>>>   
>>> -	return !wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val);
>>> +	wrmsrl(MSR_TEST_CTRL, test_ctrl_val);
>>>   }
>>>   
>>>   static void split_lock_init(void)
>>> @@ -1047,15 +1060,7 @@ static void split_lock_init(void)
>>>   	if (sld_state == sld_off)
>>>   		return;
>>>   
>>> -	if (__sld_msr_set(true))
>>> -		return;
>>> -
>>> -	/*
>>> -	 * If this is anything other than the boot-cpu, you've done
>>> -	 * funny things and you get to keep whatever pieces.
>>> -	 */
>>> -	pr_warn("MSR fail -- disabled\n");
>>> -	sld_state = sld_off;
>>> +	__sld_msr_set(true);
>>>   }
>>>   
>>>   bool handle_user_split_lock(unsigned long ip)
>>> -- 
>>> 2.23.0
>>>

