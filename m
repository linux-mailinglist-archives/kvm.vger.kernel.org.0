Return-Path: <kvm+bounces-14580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1152D8A375D
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 22:56:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F22B61C20948
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 20:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB82B3D0B8;
	Fri, 12 Apr 2024 20:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j47p+GbM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856DE39FD5;
	Fri, 12 Apr 2024 20:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712955392; cv=none; b=LnYvnA1oWDmI86vDB/i4xM+CSLJVXskwI6K8lEm5ShvZcEGfftVlKRff8+hjvDHyPNv01q/qVZZvqLuJz5Kmipp7EEtLSu3jTh9f4p7hWnNgzEOwYFhKuf0TycxNvCPk0Tmw8pIvO1KiDgN3B66KfLJ2GwO9hGjJV04r4hNJlFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712955392; c=relaxed/simple;
	bh=qjt+UlmS4PU2i03XBd0lxd/fvqZFCH2fa11xpzLpNW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AMuUNoX88DW+8QX4URD3rHhxOvA3n8bIjcU2G79ZM0r8Bl+YhN2KGqwqCnkB1SWApGBi7byK5xMUDclXzFNODP3khqOKEi+pGq63o3v7x0qUm6VSLHh5g1cFC/Updxgt7zz2/vxOMXhAQhCF+E57fmxTQuAfJD9MNvATc34/O88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j47p+GbM; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712955391; x=1744491391;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qjt+UlmS4PU2i03XBd0lxd/fvqZFCH2fa11xpzLpNW0=;
  b=j47p+GbMT2qLXFQtQ6pUEHy47BDvai34gw6QyrQ/wRJqr/hV3ku0oxTy
   LkyaOfv6Wuumv9A0Y9uN18Wz6jDg5DuVNTFtRfaH99h/o2KNJFHCtPkcZ
   jHwsyz93HXUrJoqgBIm6caviPnh8c9qBoghpv0srYMMWBP7UpCtv8ps76
   fyVJqx5Y7/JcdwdrcvcJn0r9YZFOzcFBYLDExS1vod1V8Svzhjshfc6Y0
   N6i4Q8TngdSKiJg/4Uy9zMONmMv7rqoTDAsHqMQwFJqIojR4O0uuRCtkl
   rIdmAnZhAVsViyMXKhF1IKnFH8POGOvWoNh8hOCBWLzEnrxjO97fMfPlT
   w==;
X-CSE-ConnectionGUID: txBtxqHXS2+Cw7Pu3wKmdQ==
X-CSE-MsgGUID: Wdl4+OdrT82tMe9ko78wKQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="25889863"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="25889863"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:56:30 -0700
X-CSE-ConnectionGUID: lTEUfqkoThKnJSo0dw9GBQ==
X-CSE-MsgGUID: w847SPJHSvi/M27elaaw+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="26128998"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:56:30 -0700
Received: from [10.209.151.36] (kliang2-mobl1.ccr.corp.intel.com [10.209.151.36])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 95F3D206D88F;
	Fri, 12 Apr 2024 13:56:27 -0700 (PDT)
Message-ID: <2342a4e2-2834-48e2-8403-f0050481e59e@linux.intel.com>
Date: Fri, 12 Apr 2024 16:56:26 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/41] perf: Support guest enter/exit interfaces
To: Sean Christopherson <seanjc@google.com>
Cc: Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, mizhang@google.com, kan.liang@intel.com,
 zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, jmattson@google.com,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-3-xiong.y.zhang@linux.intel.com>
 <ZhgmrczGpccfU-cI@google.com>
 <23af8648-ca9f-41d2-8782-f2ffc3c11e9e@linux.intel.com>
 <ZhmIrQQVgblrhCZs@google.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <ZhmIrQQVgblrhCZs@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-04-12 3:17 p.m., Sean Christopherson wrote:
> On Thu, Apr 11, 2024, Kan Liang wrote:
>>>> +/*
>>>> + * When a guest enters, force all active events of the PMU, which supports
>>>> + * the VPMU_PASSTHROUGH feature, to be scheduled out. The events of other
>>>> + * PMUs, such as uncore PMU, should not be impacted. The guest can
>>>> + * temporarily own all counters of the PMU.
>>>> + * During the period, all the creation of the new event of the PMU with
>>>> + * !exclude_guest are error out.
>>>> + */
>>>> +void perf_guest_enter(void)
>>>> +{
>>>> +	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
>>>> +
>>>> +	lockdep_assert_irqs_disabled();
>>>> +
>>>> +	if (__this_cpu_read(__perf_force_exclude_guest))
>>>
>>> This should be a WARN_ON_ONCE, no?
>>
>> To debug the improper behavior of KVM?
> 
> Not so much "debug" as ensure that the platform owner noticies that KVM is buggy.
> 
>>>> +static inline int perf_force_exclude_guest_check(struct perf_event *event,
>>>> +						 int cpu, struct task_struct *task)
>>>> +{
>>>> +	bool *force_exclude_guest = NULL;
>>>> +
>>>> +	if (!has_vpmu_passthrough_cap(event->pmu))
>>>> +		return 0;
>>>> +
>>>> +	if (event->attr.exclude_guest)
>>>> +		return 0;
>>>> +
>>>> +	if (cpu != -1) {
>>>> +		force_exclude_guest = per_cpu_ptr(&__perf_force_exclude_guest, cpu);
>>>> +	} else if (task && (task->flags & PF_VCPU)) {
>>>> +		/*
>>>> +		 * Just need to check the running CPU in the event creation. If the
>>>> +		 * task is moved to another CPU which supports the force_exclude_guest.
>>>> +		 * The event will filtered out and be moved to the error stage. See
>>>> +		 * merge_sched_in().
>>>> +		 */
>>>> +		force_exclude_guest = per_cpu_ptr(&__perf_force_exclude_guest, task_cpu(task));
>>>> +	}
>>>
>>> These checks are extremely racy, I don't see how this can possibly do the
>>> right thing.  PF_VCPU isn't a "this is a vCPU task", it's a "this task is about
>>> to do VM-Enter, or just took a VM-Exit" (the "I'm a virtual CPU" comment in
>>> include/linux/sched.h is wildly misleading, as it's _only_ valid when accounting
>>> time slices).
>>>
>>
>> This is to reject an !exclude_guest event creation for a running
>> "passthrough" guest from host perf tool.
>> Could you please suggest a way to detect it via the struct task_struct?
>>
>>> Digging deeper, I think __perf_force_exclude_guest has similar problems, e.g.
>>> perf_event_create_kernel_counter() calls perf_event_alloc() before acquiring the
>>> per-CPU context mutex.
>>
>> Do you mean that the perf_guest_enter() check could be happened right
>> after the perf_force_exclude_guest_check()?
>> It's possible. For this case, the event can still be created. It will be
>> treated as an existing event and handled in merge_sched_in(). It will
>> never be scheduled when a guest is running.
>>
>> The perf_force_exclude_guest_check() is to make sure most of the cases
>> can be rejected at the creation place. For the corner cases, they will
>> be rejected in the schedule stage.
> 
> Ah, the "rejected in the schedule stage" is what I'm missing.  But that creates
> a gross ABI, because IIUC, event creation will "randomly" succeed based on whether
> or not a CPU happens to be running in a KVM guest.  I.e. it's not just the kernel
> code that has races, the entire event creation is one big race.
> 
> What if perf had a global knob to enable/disable mediate PMU support?  Then when
> KVM is loaded with enable_mediated_true, call into perf to (a) check that there
> are no existing !exclude_guest events (this part could be optional), and (b) set
> the global knob to reject all new !exclude_guest events (for the core PMU?).
> 
> Hmm, or probably better, do it at VM creation.  That has the advantage of playing
> nice with CONFIG_KVM=y (perf could reject the enabling without completely breaking
> KVM), and not causing problems if KVM is auto-probed but the user doesn't actually
> want to run VMs.

I think it should be doable, and may simplify the perf implementation.
(The check in the schedule stage should not be necessary anymore.)

With this, something like NMI watchdog should fail the VM creation. The
user should either disable the NMI watchdog or use a replacement.

Thanks,
Kan
> 
> E.g. (very roughly)
> 
> int x86_perf_get_mediated_pmu(void)
> {
> 	if (refcount_inc_not_zero(...))
> 		return 0;
> 
> 	if (<system wide events>)
> 		return -EBUSY;
> 
> 	<slow path with locking>
> }
> 
> void x86_perf_put_mediated_pmu(void)
> {
> 	if (!refcount_dec_and_test(...))
> 		return;
> 
> 	<slow path with locking>
> }
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1bbf312cbd73..f2994377ef44 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12467,6 +12467,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>         if (type)
>                 return -EINVAL;
>  
> +       if (enable_mediated_pmu)
> +               ret = x86_perf_get_mediated_pmu();
> +               if (ret)
> +                       return ret;
> +       }
> +
>         ret = kvm_page_track_init(kvm);
>         if (ret)
>                 goto out;
> @@ -12518,6 +12524,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>         kvm_mmu_uninit_vm(kvm);
>         kvm_page_track_cleanup(kvm);
>  out:
> +       x86_perf_put_mediated_pmu();
>         return ret;
>  }
>  
> @@ -12659,6 +12666,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>         kvm_page_track_cleanup(kvm);
>         kvm_xen_destroy_vm(kvm);
>         kvm_hv_destroy_vm(kvm);
> +       x86_perf_put_mediated_pmu();
>  }
>  
>  static void memslot_rmap_free(struct kvm_memory_slot *slot)
> 
> 

