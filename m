Return-Path: <kvm+bounces-34855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 274F9A06AE5
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 03:26:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11A31163308
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 02:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D3E65BAF0;
	Thu,  9 Jan 2025 02:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R8eT5Y9s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A717B677;
	Thu,  9 Jan 2025 02:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736389604; cv=none; b=lugtqp62jypPZ1vlF0SxIwp2o/s0zGYGMvOAba0qpssfpUlvWWHdTQdXftL+xH0//0x9IPSIbANA3KMzmyeB+wLEMuvTbclM8KJ6aYVVeQhj0M99h53etGCFIO5V0Bql5lJOgWjqKiFmr+cfg+VfEigDafaD9RltAV/duZI5axo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736389604; c=relaxed/simple;
	bh=rPdMQYQCaxMPd2nVym3BImTVlg7WvbiOA0q8eKvUvA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Og17xnsESZbD8rthwGWzbW9dbjiuzjNMYmJnTOcw9+XWHYBmMyv6bXso6PSSpZsQTSaChgh05lntMEjlYd+9QLUW7MNIj7CRi0y7wu/bRLxreQrsipgbPbbv7K3Oa4nva+fCl3+OEvma4aS5tqwKoQuBRQfkKAzawyLugI1iqzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R8eT5Y9s; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736389603; x=1767925603;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rPdMQYQCaxMPd2nVym3BImTVlg7WvbiOA0q8eKvUvA8=;
  b=R8eT5Y9sGF8vP31ilqPHzI/3Wwgu5QNEoV7rQXPS4Vt2qpg8v6Jb2tR6
   EPt8DOTDDeIaGVa0aWJIESvzrqVWX0Oupn2VjykQ1gYOVYWr91xhQ62nH
   MJzXpNkEiPasa+QhkWJBcOEYzDsnQ1NuAWVbudXvk5EGGVL406zQWMp72
   lfykoZ+AQeBlmb2zAWPOU27z40IibaqR/acqduBIKTKwZJG7a8u+LFJsx
   X/rZv7IVJ54MbutUbeNz4YvUOvPYfJsgmMjhEfqL9VX7jZQg/Pai8KNVC
   VV1Ksapdugv08fROtEdY6vJCM0iofXi7alT2PWu9JznrgSmLAf2VrbLz+
   Q==;
X-CSE-ConnectionGUID: ArJ1Mij7SNySiJHU4TodKw==
X-CSE-MsgGUID: 5le9cd7ARkeKdY2wF9ZVzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="47303752"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="47303752"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 18:26:42 -0800
X-CSE-ConnectionGUID: qXxJ3X+ETa+gFCo3VQEWEg==
X-CSE-MsgGUID: Cb+WgZsVSoe4nUYzeC13eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="134111982"
Received: from unknown (HELO [10.238.12.121]) ([10.238.12.121])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 18:26:38 -0800
Message-ID: <8fccaab6-fda3-489c-866d-f0463ebbad65@linux.intel.com>
Date: Thu, 9 Jan 2025 10:26:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/16] KVM: TDX: Always block INIT/SIPI
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 adrian.hunter@intel.com, reinette.chatre@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-12-binbin.wu@linux.intel.com>
 <473c1a20-11c8-4e4e-8ff1-e2e5c5d68332@intel.com>
 <904c0aa7-8aa6-4ac2-b2d3-9bac89355af1@linux.intel.com>
 <Z36OYfRW9oPjW8be@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z36OYfRW9oPjW8be@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 1/8/2025 10:40 PM, Sean Christopherson wrote:
> On Wed, Jan 08, 2025, Binbin Wu wrote:
>> On 1/8/2025 3:21 PM, Xiaoyao Li wrote:
>>> On 12/9/2024 9:07 AM, Binbin Wu wrote:
> ...
>
>>>> ---
>>>>    arch/x86/kvm/lapic.c    |  2 +-
>>>>    arch/x86/kvm/vmx/main.c | 19 ++++++++++++++++++-
>>>>    2 files changed, 19 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>>> index 474e0a7c1069..f93c382344ee 100644
>>>> --- a/arch/x86/kvm/lapic.c
>>>> +++ b/arch/x86/kvm/lapic.c
>>>> @@ -3365,7 +3365,7 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>>>>          if (test_and_clear_bit(KVM_APIC_INIT, &apic->pending_events)) {
>>>>            kvm_vcpu_reset(vcpu, true);
>>>> -        if (kvm_vcpu_is_bsp(apic->vcpu))
>>>> +        if (kvm_vcpu_is_bsp(vcpu))
>>>>                vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>>>>            else
>>>>                vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
>>>> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>>>> index 8ec96646faec..7f933f821188 100644
>>>> --- a/arch/x86/kvm/vmx/main.c
>>>> +++ b/arch/x86/kvm/vmx/main.c
>>>> @@ -115,6 +115,11 @@ static void vt_vcpu_free(struct kvm_vcpu *vcpu)
>>>>      static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>>>    {
>>>> +    /*
>>>> +     * TDX has its own sequence to do init during TD build time (by
>>>> +     * KVM_TDX_INIT_VCPU) and it doesn't support INIT event during TD
>>>> +     * runtime.
>>>> +     */
>>> The first half is confusing. It seems to mix up init(ialization) with INIT
>>> event.
>>>
>>> And this callback is about *reset*, which can be due to INIT event or not.
>>> That's why it has a second parameter of init_event. The comment needs to
>>> clarify why reset is not needed for both cases.
>>>
>>> I think we can just say TDX doesn't support vcpu reset no matter due to
>>> INIT event or not.
> That's not entirely accurate either though.  TDX does support KVM's version of
> RESET, because KVM's RESET is "power-on", i.e. vCPU creation.  Emulation of
> runtime RESET is userspace's responsibility.
>
> The real reason why KVM doesn't do anything during KVM's RESET is that what
> little setup KVM does/can do needs to be defered until after guest CPUID is
> configured.
>
> KVM should also WARN if a TDX vCPU gets INIT, no?

There was a KVM_BUG_ON() if a TDX vCPU gets INIT in v19, and later it was
removed during the cleanup about removing WARN_ON_ONCE() and KVM_BUG_ON().

Since INIT/SIPI are always blocked for TDX guests, a delivery of INIT
event is a KVM bug and a WARN_ON_ONCE() is appropriate for this case.

>
> Side topic, the comment about x2APIC in tdx_vcpu_init() is too specific, e.g.
> calling out that x2APIC support is enumerated in CPUID.0x1.ECX isn't necessary,
> and stating that userspace must use KVM_SET_CPUID2 is flat out wrong.  Very
> technically, KVM_SET_CPUID is also a valid option, it's just not used in practice
> because it doesn't support setting non-zero indices (but in theory it could be
> used to enable x2APIC).
Indeed, it is too specific.

>
> E.g. something like this?

LGTM.
Thanks for the suggestion!

>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index d2e78e6675b9..e36fba94fa14 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -115,13 +115,10 @@ static void vt_vcpu_free(struct kvm_vcpu *vcpu)
>   
>   static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   {
> -       /*
> -        * TDX has its own sequence to do init during TD build time (by
> -        * KVM_TDX_INIT_VCPU) and it doesn't support INIT event during TD
> -        * runtime.
> -        */
> -       if (is_td_vcpu(vcpu))
> +       if (is_td_vcpu(vcpu)) {
> +               tdx_vcpu_reset(vcpu, init_event);
>                  return;
> +       }
>   
>          vmx_vcpu_reset(vcpu, init_event);
>   }
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 9e490fccf073..a587f59167a7 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2806,9 +2806,8 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
>                  return -EINVAL;
>   
>          /*
> -        * As TDX requires X2APIC, set local apic mode to X2APIC.  User space
> -        * VMM, e.g. qemu, is required to set CPUID[0x1].ecx.X2APIC=1 by
> -        * KVM_SET_CPUID2.  Otherwise kvm_apic_set_base() will fail.
> +        * TDX requires x2APIC, userspace is responsible for configuring guest
> +        * CPUID accordingly.
>           */
>          apic_base = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC |
>                  (kvm_vcpu_is_reset_bsp(vcpu) ? MSR_IA32_APICBASE_BSP : 0);
> @@ -2827,6 +2826,19 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
>          return 0;
>   }
>   
> +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +       /*
> +        * Yell on INIT, as TDX doesn't support INIT, i.e. KVM should drop all
> +        * INIT events.
> +        *
> +        * Defer initializing vCPU for RESET state until KVM_TDX_INIT_VCPU, as
> +        * userspace needs to define the vCPU model before KVM can initialize
> +        * vCPU state, e.g. to enable x2APIC.
> +        */
> +       WARN_ON_ONCE(init_event);
> +}
> +
>   struct tdx_gmem_post_populate_arg {
>          struct kvm_vcpu *vcpu;
>          __u32 flags;
>


