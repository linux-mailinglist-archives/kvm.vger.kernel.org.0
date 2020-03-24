Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 727E7190330
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 02:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgCXBLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 21:11:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:60333 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgCXBLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 21:11:01 -0400
IronPort-SDR: UUQjEMkv2MVRDqv/jbl1FwycOuzR4+Ovaxk/OgJ1BAuDVxgNLcwI+JNrx0PCADUx//ZTTdqIqY
 2AQl4GX4Q/ew==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 18:11:00 -0700
IronPort-SDR: 8tLM9J2Q3IUwdV0gZYXX7kP1ZmmczZjkU7tq2D/ofV+To5kEIHbZFnDZUcUK4F4DQwC+gtblpK
 7520VZ8FJltQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,298,1580803200"; 
   d="scan'208";a="270109560"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.120]) ([10.255.31.120])
  by fmsmga004.fm.intel.com with ESMTP; 23 Mar 2020 18:10:56 -0700
Subject: Re: [PATCH v5 1/9] x86/split_lock: Rework the initialization flow of
 split lock detection
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
 <20200315050517.127446-2-xiaoyao.li@intel.com>
 <87zhc7ovhj.fsf@nanos.tec.linutronix.de>
 <87lfnqq0oo.fsf@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <beb9ab5c-a50d-2ec6-1c23-e426508cdf4e@intel.com>
Date:   Tue, 24 Mar 2020 09:10:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87lfnqq0oo.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/24/2020 4:24 AM, Thomas Gleixner wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>
>>> Current initialization flow of split lock detection has following issues:
>>> 1. It assumes the initial value of MSR_TEST_CTRL.SPLIT_LOCK_DETECT to be
>>>     zero. However, it's possible that BIOS/firmware has set it.
>>
>> Ok.
>>
>>> 2. X86_FEATURE_SPLIT_LOCK_DETECT flag is unconditionally set even if
>>>     there is a virtualization flaw that FMS indicates the existence while
>>>     it's actually not supported.
>>>
>>> 3. Because of #2, KVM cannot rely on X86_FEATURE_SPLIT_LOCK_DETECT flag
>>>     to check verify if feature does exist, so cannot expose it to
>>>     guest.
>>
>> Sorry this does not make anny sense. KVM is the hypervisor, so it better
>> can rely on the detect flag. Unless you talk about nested virt and a
>> broken L1 hypervisor.
>>
>>> To solve these issues, introducing a new sld_state, "sld_not_exist",
>>> as
>>
>> The usual naming convention is sld_not_supported.
> 
> But this extra state is not needed at all, it already exists:
> 
>      X86_FEATURE_SPLIT_LOCK_DETECT
> 
> You just need to make split_lock_setup() a bit smarter. Soemthing like
> the below. It just wants to be split into separate patches.
> 
> Thanks,
> 
>          tglx
> ---
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -45,6 +45,7 @@ enum split_lock_detect_state {
>    * split lock detect, unless there is a command line override.
>    */
>   static enum split_lock_detect_state sld_state = sld_off;
> +static DEFINE_PER_CPU(u64, msr_test_ctrl_cache);

I used percpu cache in v3, but people prefer Tony's cache for reserved 
bits[1].

If you prefer percpu cache, I'll use it in next version.

[1]: https://lore.kernel.org/lkml/20200303192242.GU1439@linux.intel.com/

>   /*
>    * Processors which have self-snooping capability can handle conflicting
> @@ -984,11 +985,32 @@ static inline bool match_option(const ch
>   	return len == arglen && !strncmp(arg, opt, len);
>   }
>   
> +static bool __init split_lock_verify_msr(bool on)
> +{
> +	u64 ctrl, tmp;
> +
> +	if (rdmsrl_safe(MSR_TEST_CTRL, &ctrl))
> +		return false;
> +	if (on)
> +		ctrl |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
> +	else
> +		ctrl &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
> +	if (wrmsrl_safe(MSR_TEST_CTRL, ctrl))
> +		return false;
> +	rdmsrl(MSR_TEST_CTRL, tmp);
> +	return ctrl == tmp;
> +}
> +
>   static void __init split_lock_setup(void)
>   {
>   	char arg[20];
>   	int i, ret;
>   
> +	if (!split_lock_verify_msr(true) || !split_lock_verify_msr(false)) {
> +		pr_info("MSR access failed: Disabled\n");
> +		return;
> +	}
> +

I did similar thing like this in my v3, however Sean raised concern that 
toggling MSR bit before parsing kernel param is bad behavior. [2]

[2]: https://lore.kernel.org/kvm/20200305162311.GG11500@linux.intel.com/

