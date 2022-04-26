Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E749850EE40
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 03:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241326AbiDZBv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 21:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiDZBvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 21:51:55 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C20955492;
        Mon, 25 Apr 2022 18:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650937729; x=1682473729;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5frXLUzLpupCUTHXJckrwcWUMw1yBdmMtMd/Kb/5Cb4=;
  b=F+1bfUR9dvNoGY+457d1ucYfliYw1b8/Ylw8A9Pq1qoDY5QPmgFKR8r1
   TWrbxFg77E4GoGgJ1uVi886OdoGHM/2FmSrlWS7Mh7flP/zbosPeeP3ou
   FQ96UuazVqt+3jAGyOpMH0SbkP4JL9ZRP7A4cUyAqTrYnVHma1WQ4AdUW
   zRXqD3Lka7nY9IXIXmXhYw/OuKnmb0cog89HI1HY/fRxOMbHpdN0COmE0
   ogH40nHt0Z1Vqz/fqw3zOoyGx9v+sZv6+TjZg4ORnMAxAKW4P3sVnwp+R
   QDuEEW5I/zU1chtnLAgKy0QxC63D/2+vcvg+TydhCbgnfoGto1fS39Vib
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="328358731"
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="328358731"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 18:48:49 -0700
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="538019759"
Received: from ticela-or-019.amr.corp.intel.com (HELO [10.212.229.205]) ([10.212.229.205])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 18:48:48 -0700
Message-ID: <c3619404-e1d7-6745-0ecc-a759d57d60bf@linux.intel.com>
Date:   Mon, 25 Apr 2022 18:48:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v3 06/21] x86/virt/tdx: Shut down TDX module in case of
 error
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <3f19ac995d184e52107e7117a82376cb7ecb35e7.1649219184.git.kai.huang@intel.com>
 <82d3cb0b-cebc-d1da-abc1-e802cb8f8ff8@linux.intel.com>
 <e14da6ed4520bc2362322434b1b4b336f079f3b7.camel@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <e14da6ed4520bc2362322434b1b4b336f079f3b7.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/25/22 4:41 PM, Kai Huang wrote:
> On Sat, 2022-04-23 at 08:39 -0700, Sathyanarayanan Kuppuswamy wrote:
>>
>> On 4/5/22 9:49 PM, Kai Huang wrote:
>>> TDX supports shutting down the TDX module at any time during its
>>> lifetime.  After TDX module is shut down, no further SEAMCALL can be
>>> made on any logical cpu.
>>>
>>> Shut down the TDX module in case of any error happened during the
>>> initialization process.  It's pointless to leave the TDX module in some
>>> middle state.
>>>
>>> Shutting down the TDX module requires calling TDH.SYS.LP.SHUTDOWN on all
>>
>> May be adding specification reference will help.
> 
> How about adding the reference to the code comment?  Here we just need some fact
> description.  Adding reference to the code comment also allows people to find
> the relative part in the spec easily when they are looking at the actual code
> (i.e. after the code is merged to upstream).  Otherwise people needs to do a git
> blame and find the exact commit message for that.

If it is not a hassle, you can add references both in code and at the
end of the commit log. Adding two more lines to the commit log should
not be difficult.

I think it is fine either way. Your choice.

>   
>>
>>> BIOS-enabled cpus, and the SEMACALL can run concurrently on different
>>> cpus.  Implement a mechanism to run SEAMCALL concurrently on all online
>>
>>   From TDX Module spec, sec 13.4.1 titled "Shutdown Initiated by the Host
>> VMM (as Part of Module Update)",
>>
>> TDH.SYS.LP.SHUTDOWN is designed to set state variables to block all
>> SEAMCALLs on the current LP and all SEAMCALL leaf functions except
>> TDH.SYS.LP.SHUTDOWN on the other LPs.
>>
>> As per above spec reference, executing TDH.SYS.LP.SHUTDOWN in
>> one LP prevent all SEAMCALL leaf function on all other LPs. If so,
>> why execute it on all CPUs?
> 
> Prevent all SEAMCALLs on other LPs except TDH.SYS.LP.SHUTDOWN.  The spec defnies
> shutting down the TDX module as running this SEAMCALl on all LPs, so why just
> run on a single cpu?  What's the benefit?

If executing it in one LP prevents SEAMCALLs on all other LPs, I am
trying to understand why spec recommends running it in all LPs?

But the following explanation answers my query. I recommend making a
note about  it in commit log or comments.

> 
> Also, the spec also mentions for runtime update, "SEAMLDR can check that
> TDH.SYS.SHUTDOWN has been executed on all LPs".  Runtime update isn't supported
> in this series, but it can leverage the existing code if we run SEAMCALL on all
> LPs to shutdown the module as spec suggested.  Why just run on a single cpu?
> 
>>
>>> cpus.  Logical-cpu scope initialization will use it too.
>>
>> Concurrent SEAMCALL support seem to be useful for other SEAMCALL
>> types as well. If you agree, I think it would be better if you move
>> it out to a separate common patch.
> 
> There are couple of problems of doing that:
> 
> - All the functions are static in this tdx.c.  Introducing them separately in
> dedicated patch would result in compile warning about those static functions are
> not used.
> - I have received comments from others I can add those functions when they are
> firstly used.  Given those functions is not large, so I prefer this way too.

Ok

> 
>>
>>>
>>> Signed-off-by: Kai Huang <kai.huang@intel.com>
>>> ---
>>>    arch/x86/virt/vmx/tdx/tdx.c | 40 ++++++++++++++++++++++++++++++++++++-
>>>    arch/x86/virt/vmx/tdx/tdx.h |  5 +++++
>>>    2 files changed, 44 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
>>> index 674867bccc14..faf8355965a5 100644
>>> --- a/arch/x86/virt/vmx/tdx/tdx.c
>>> +++ b/arch/x86/virt/vmx/tdx/tdx.c
>>> @@ -11,6 +11,8 @@
>>>    #include <linux/cpumask.h>
>>>    #include <linux/mutex.h>
>>>    #include <linux/cpu.h>
>>> +#include <linux/smp.h>
>>> +#include <linux/atomic.h>
>>>    #include <asm/msr-index.h>
>>>    #include <asm/msr.h>
>>>    #include <asm/cpufeature.h>
>>> @@ -328,6 +330,39 @@ static int seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>>>    	return 0;
>>>    }
>>>    
>>> +/* Data structure to make SEAMCALL on multiple CPUs concurrently */
>>> +struct seamcall_ctx {
>>> +	u64 fn;
>>> +	u64 rcx;
>>> +	u64 rdx;
>>> +	u64 r8;
>>> +	u64 r9;
>>> +	atomic_t err;
>>> +	u64 seamcall_ret;
>>> +	struct tdx_module_output out;
>>> +};
>>> +
>>> +static void seamcall_smp_call_function(void *data)
>>> +{
>>> +	struct seamcall_ctx *sc = data;
>>> +	int ret;
>>> +
>>> +	ret = seamcall(sc->fn, sc->rcx, sc->rdx, sc->r8, sc->r9,
>>> +			&sc->seamcall_ret, &sc->out);
>>> +	if (ret)
>>> +		atomic_set(&sc->err, ret);
>>> +}
>>> +
>>> +/*
>>> + * Call the SEAMCALL on all online cpus concurrently.
>>> + * Return error if SEAMCALL fails on any cpu.
>>> + */
>>> +static int seamcall_on_each_cpu(struct seamcall_ctx *sc)
>>> +{
>>> +	on_each_cpu(seamcall_smp_call_function, sc, true);
>>> +	return atomic_read(&sc->err);
>>> +}
>>> +
>>>    static inline bool p_seamldr_ready(void)
>>>    {
>>>    	return !!p_seamldr_info.p_seamldr_ready;
>>> @@ -437,7 +472,10 @@ static int init_tdx_module(void)
>>>    
>>>    static void shutdown_tdx_module(void)
>>>    {
>>> -	/* TODO: Shut down the TDX module */
>>> +	struct seamcall_ctx sc = { .fn = TDH_SYS_LP_SHUTDOWN };
>>> +
>>> +	seamcall_on_each_cpu(&sc);
>>
>> May be check the error and WARN_ON on failure?
> 
> When SEAMCALL fails, the error code will be printed out actually (please see
> previous patch), so I thought there's no need to WARN_ON() here (and some other
> similar places).  I am not sure the additional WARN_ON() will do any help?

OK. I missed that part.

> 

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
