Return-Path: <kvm+bounces-36-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0B57DB2EC
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:47:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 280671F218C5
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 05:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD29137E;
	Mon, 30 Oct 2023 05:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nPcj695a"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B8D1362
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 05:47:37 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17325BD;
	Sun, 29 Oct 2023 22:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698644856; x=1730180856;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qSQyLJ3ELQydTlzFiy93Tk9n3bfWoaN+9E4KxaUOtcU=;
  b=nPcj695a+UxLsQ+CXSrIwKaUsb7P9QqzTSvBqkuIbPHAOTouWJMroa+/
   za9fLRyR0kWytG+EMhXapFAecnvMHkfWstBX1sduygxmXkLYDtrqoWdKF
   wyg34dNWSNV3ZrhteG84GDYTQxh03W5WtMuiKgKXm6jdCRlgAPGj1EKqL
   9mOpNW+2Pg/GKYZKC2w3Gv1fIp+oWBTUabLoCFI+Zn9lGXu3F9sLhgUN6
   DmAQElsWinGipk6mOQfPnP8gIpqSzM0/Qth20JhZhYLtHj1ULpiV64L6n
   6GEOOmFV93vSiU7fHnnraK457xniGrubuKp/e68XQOkiCq9hrsKb7O3FV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10878"; a="9550062"
X-IronPort-AV: E=Sophos;i="6.03,262,1694761200"; 
   d="scan'208";a="9550062"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2023 22:47:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,262,1694761200"; 
   d="scan'208";a="7855338"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.9.145]) ([10.93.9.145])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2023 22:47:28 -0700
Message-ID: <47c9a8f1-0098-4543-ac98-e210ca6b0d34@intel.com>
Date: Mon, 30 Oct 2023 13:47:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/kvm/async_pf: Use separate percpu variable to
 track the enabling of asyncpf
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Jonathan Corbet <corbet@lwn.net>, Wanpeng Li <wanpengli@tencent.com>,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231025055914.1201792-1-xiaoyao.li@intel.com>
 <20231025055914.1201792-2-xiaoyao.li@intel.com> <87a5s73w53.fsf@redhat.com>
 <ZTkkmgs_oCnDCGvd@google.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZTkkmgs_oCnDCGvd@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/25/2023 10:22 PM, Sean Christopherson wrote:
> On Wed, Oct 25, 2023, Vitaly Kuznetsov wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>> index b8ab9ee5896c..388a3fdd3cad 100644
>>> --- a/arch/x86/kernel/kvm.c
>>> +++ b/arch/x86/kernel/kvm.c
>>> @@ -65,6 +65,7 @@ static int __init parse_no_stealacc(char *arg)
>>>   
>>>   early_param("no-steal-acc", parse_no_stealacc);
>>>   
>>> +static DEFINE_PER_CPU_READ_MOSTLY(bool, async_pf_enabled);
>>
>> Would it make a difference is we replace this with a cpumask? I realize
>> that we need to access it on all CPUs from hotpaths but this mask will
>> rarely change so maybe there's no real perfomance hit?
> 
> FWIW, I personally prefer per-CPU booleans from a readability perspective.  I
> doubt there is a meaningful performance difference for a bitmap vs. individual
> booleans, the check is already gated by a static key, i.e. kernels that are NOT
> running as KVM guests don't care.

I agree with it.

> Actually, if there's performance gains to be had, optimizing kvm_read_and_reset_apf_flags()
> to read the "enabled" flag if and only if it's necessary is a more likely candidate.
> Assuming the host isn't being malicious/stupid, then apf_reason.flags will be '0'
> if PV async #PFs are disabled.  The only question is whether or not apf_reason.flags
> is predictable enough for the CPU.
> 
> Aha!  In practice, the CPU already needs to resolve a branch based on apf_reason.flags,
> it's just "hidden" up in __kvm_handle_async_pf().
> 
> If we really want to micro-optimize, provide an __always_inline inner helper so
> that __kvm_handle_async_pf() doesn't need to make a CALL just to read the flags.
> Then in the common case where a #PF isn't due to the host swapping out a page,
> the paravirt happy path doesn't need a taken branch and never reads the enabled
> variable.  E.g. the below generates:

If this is wanted. It can be a separate patch, irrelevant with this 
series, I think.

>     0xffffffff81939ed0 <+0>:	41 54              	push   %r12
>     0xffffffff81939ed2 <+2>:	31 c0              	xor    %eax,%eax
>     0xffffffff81939ed4 <+4>:	55                 	push   %rbp
>     0xffffffff81939ed5 <+5>:	53                 	push   %rbx
>     0xffffffff81939ed6 <+6>:	48 83 ec 08        	sub    $0x8,%rsp
>     0xffffffff81939eda <+10>:	65 8b 2d df 81 6f 7e	mov    %gs:0x7e6f81df(%rip),%ebp        # 0x320c0 <apf_reason>
>     0xffffffff81939ee1 <+17>:	85 ed              	test   %ebp,%ebp
>     0xffffffff81939ee3 <+19>:	75 09              	jne    0xffffffff81939eee <__kvm_handle_async_pf+30>
>     0xffffffff81939ee5 <+21>:	48 83 c4 08        	add    $0x8,%rsp
>     0xffffffff81939ee9 <+25>:	5b                 	pop    %rbx
>     0xffffffff81939eea <+26>:	5d                 	pop    %rbp
>     0xffffffff81939eeb <+27>:	41 5c              	pop    %r12
>     0xffffffff81939eed <+29>:	c3                 	ret
> 
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index b8ab9ee5896c..b24133dc0731 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -240,22 +240,29 @@ void kvm_async_pf_task_wake(u32 token)
>   }
>   EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);
>   
> -noinstr u32 kvm_read_and_reset_apf_flags(void)
> +static __always_inline u32 __kvm_read_and_reset_apf_flags(void)
>   {
> -       u32 flags = 0;
> +       u32 flags = __this_cpu_read(apf_reason.flags);
>   
> -       if (__this_cpu_read(apf_reason.enabled)) {
> -               flags = __this_cpu_read(apf_reason.flags);
> -               __this_cpu_write(apf_reason.flags, 0);
> +       if (unlikely(flags)) {
> +               if (likely(__this_cpu_read(apf_reason.enabled)))
> +                       __this_cpu_write(apf_reason.flags, 0);
> +               else
> +                       flags = 0;
>          }
>   
>          return flags;
>   }
> +
> +u32 kvm_read_and_reset_apf_flags(void)
> +{
> +       return __kvm_read_and_reset_apf_flags();
> +}
>   EXPORT_SYMBOL_GPL(kvm_read_and_reset_apf_flags);
>   
>   noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
>   {
> -       u32 flags = kvm_read_and_reset_apf_flags();
> +       u32 flags = __kvm_read_and_reset_apf_flags();
>          irqentry_state_t state;
>   
>          if (!flags)
> 
>>>   static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
>>>   DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
>>>   static int has_steal_clock = 0;
>>> @@ -244,7 +245,7 @@ noinstr u32 kvm_read_and_reset_apf_flags(void)
>>>   {
>>>   	u32 flags = 0;
>>>   
>>> -	if (__this_cpu_read(apf_reason.enabled)) {
>>> +	if (__this_cpu_read(async_pf_enabled)) {
>>>   		flags = __this_cpu_read(apf_reason.flags);
>>>   		__this_cpu_write(apf_reason.flags, 0);
>>>   	}
>>> @@ -295,7 +296,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
>>>   
>>>   	inc_irq_stat(irq_hv_callback_count);
>>>   
>>> -	if (__this_cpu_read(apf_reason.enabled)) {
>>> +	if (__this_cpu_read(async_pf_enabled)) {
>>>   		token = __this_cpu_read(apf_reason.token);
>>>   		kvm_async_pf_task_wake(token);
>>>   		__this_cpu_write(apf_reason.token, 0);
>>> @@ -362,7 +363,7 @@ static void kvm_guest_cpu_init(void)
>>>   		wrmsrl(MSR_KVM_ASYNC_PF_INT, HYPERVISOR_CALLBACK_VECTOR);
>>>   
>>>   		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
>>> -		__this_cpu_write(apf_reason.enabled, 1);
>>> +		__this_cpu_write(async_pf_enabled, 1);
>>
>> As 'async_pf_enabled' is bool, it would probably be more natural to
>> write
>>
>> 	__this_cpu_write(async_pf_enabled, true);
> 
> +1000


