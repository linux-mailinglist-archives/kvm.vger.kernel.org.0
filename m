Return-Path: <kvm+bounces-15181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B24B88AA691
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:38:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D63BF1C211DB
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 01:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 605871C2D;
	Fri, 19 Apr 2024 01:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fhrpbinw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE481362;
	Fri, 19 Apr 2024 01:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713490676; cv=none; b=P9g7YY5keqIkkHT843UbJZ9zqKIiYKJrGg7Eq3XEW74L6ypn56sN+canZ6AHBrC3ergoeV074o3QTScBDZqiDsgnm8gq1ZUY8UxnRSFS6hULhp1TtBN7HfjPiNj+tdX0db6Q654AtcO8Lpk70/GInaD5fi3c2FWk7NBLU7uDihE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713490676; c=relaxed/simple;
	bh=t5rbnrB5WNEoCu3hBvWoGz+Np+VUMTEtUNw6ITpqlYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P1ndPA+BqXJimoUkEdumQQr+kOuvG1EzeXkK2wXsC6mhJ+TiFfY4A3kQBxyMXtuZfAbSSiuWkWgcQ39iqAkPC39QhOkHjMd+SNwegG4vzHvug7yfbissSXIH13MuoRfe+T1Rwmq9n4dVGuq9c5pyw7QLpxhhk06IIYww6YlHlvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fhrpbinw; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713490675; x=1745026675;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t5rbnrB5WNEoCu3hBvWoGz+Np+VUMTEtUNw6ITpqlYI=;
  b=Fhrpbinw8SVFJ4w+v7XkAtIW4WWZfltyOO09xq6resFKh+PUN9K6WC/i
   WtheAVO8I6AU8TCZkSTLtu+OcL4LaRCTWka+dVkyGzjtt6G/nx/E+NhR3
   r4LCbs4WKdBKArGDlFIhDJJNb6gP7maDEnT+2rZ5qo/S6MZaYAvo2spk3
   INiPLW8hOVlftUNgBcLFQrDG4irLNbLDeDv/PSAnjZDh3OntaSvfn+7Sc
   wDjfBweqPQZ7JIjMBjwiwG44jASaXrmoOVaCNRPGkTg47sYxxvLzNN7Xi
   UvJjwXVTRIIkTcz04D+v26aejJpccKKddAgb1jqOhrazGGhCUAMnkPQd1
   A==;
X-CSE-ConnectionGUID: lBAXm3nVTrmoFQ3u+RYeRw==
X-CSE-MsgGUID: ZCnwkZj9RTSa5FW76Jb1Fg==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="12911158"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="12911158"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 18:37:54 -0700
X-CSE-ConnectionGUID: c0w7UrwhTwiD00wh2c8rbQ==
X-CSE-MsgGUID: rL7ADMgLS1qnBFlogsI7SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="46465195"
Received: from xiongzha-mobl1.ccr.corp.intel.com (HELO [10.125.241.186]) ([10.125.241.186])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 18:37:49 -0700
Message-ID: <e3fb79b1-7fc8-4e3a-ba17-b097aabcb2c2@linux.intel.com>
Date: Fri, 19 Apr 2024 09:37:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/41] perf: Support guest enter/exit interfaces
To: Sean Christopherson <seanjc@google.com>
Cc: Kan Liang <kan.liang@linux.intel.com>, pbonzini@redhat.com,
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
 <2342a4e2-2834-48e2-8403-f0050481e59e@linux.intel.com>
 <ab2953b7-18fd-4b4c-a83b-ab243e2a21e1@linux.intel.com>
 <998fd76f-2bd9-4492-bf2e-e8cd981df67f@linux.intel.com>
 <eca7cdb9-6c8d-4d2e-8ac6-b87ea47a1bac@linux.intel.com>
 <9056f6a2-546b-41fc-a07c-7b86173887db@linux.intel.com>
 <ZiFGRFb45oZrmqnJ@google.com>
Content-Language: en-US
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <ZiFGRFb45oZrmqnJ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/19/2024 12:11 AM, Sean Christopherson wrote:
> On Wed, Apr 17, 2024, Xiong Y Zhang wrote:
>> On 4/16/2024 8:48 PM, Liang, Kan wrote:
>>>> x86_perf_get_mediated_pmu() is called at vm_create(),
>>>> x86_perf_put_mediated_pmu() is called at vm_destroy(), then system wide
>>>> perf events without exclude_guest=1 can not be created during the whole vm
>>>> life cycle (where nr_mediated_pmu_vms > 0 always), do I understand and use
>>>> the interface correctly ?
>>>
>>> Right, but it only impacts the events of PMU with the
>>> PERF_PMU_CAP_MEDIATED_VPMU.  For other PMUs, the event with exclude_guest=1
>>> can still be created.  KVM should not touch the counters of the PMU without
>>> PERF_PMU_CAP_MEDIATED_VPMU.
>>>
>>> BTW: I will also remove the prefix x86, since the functions are in the
>>> generic code.
>>>
>>> Thanks,
>>> Kan
>> After userspace VMM call VCPU SET_CPUID() ioctl, KVM knows whether vPMU is
>> enabled or not. If perf_get_mediated_pmu() is called at vm create, it is too
>> early.
> 
> Eh, if someone wants to create _only_ VMs without vPMUs, then they should load
> KVM with enable_pmu=false.  I can see people complaining about not being able to
> create VMs if they don't want to use have *any* vPMU usage, but I doubt anyone
> has a use cases where they want a mix of PMU-enabled and PMU- disabled VMs, *and*
> they are ok with VM creation failing for some VMs but not others.
enable_mediated_pmu and PMU-based nmi_watchdog are enabled by default on my ubuntu system, some ubuntu services create vm during ubuntu bootup, these ubuntu services fail after I add perf_get_mediated_pmu() in kvm_arch_init_vm(). so do this checking at vm creation may break some bootup services.
  
> 
>> it is better to let perf_get_mediated_pmu() track per cpu PMU state,
>> so perf_get_mediated_pmu() can be called by kvm after vcpu_cpuid_set(). Note
>> user space vmm may call SET_CPUID() on one vcpu multi times, then here
>> refcount maybe isn't suitable. 
> 
> Yeah, waiting until KVM_SET_CPUID2 would be unpleasant for both KVM and userspace.
> E.g. failing KVM_SET_CPUID2 because KVM can't enable mediated PMU support would
> be rather confusing for userspace.
> 
>> what's a better solution ?
> 
> If doing the checks at VM creation is a stick point for folks, then the best
> approach is probably to use KVM_CAP_PMU_CAPABILITY, i.e. require userspace to
> explicitly opt-in to enabling mediated PMU usage.  Ha!  We can even do that
> without additional uAPI, because KVM interprets cap->args[0]==0 as "enable vPMU".
> 
QEMU doesn't use KVM_CAP_PMU_CAPABILITY to enable/disable pmu. enable_cap(KVM_CAP_PMU_CAPABILITY) will be added into QEMU for mediated PMU.
With old QEMU, guest PMU will always use emulated vPMU, mediated PMU won't be enabled, if emulated vPMU is replaced later, the old QEMU guest will be broken.
> The big problem with this is that enabling mediated PMU support by default would
> break userspace.  Hmm, but that's arguably the case no matter what, as a setup
> that worked before would suddenly start failing if the host was configured to use
> the PMU-based NMI watchdog.
Based on perf_get_mediated_pmu() interface, admin need to disable all the system wide perf events before vm creation, no matter where the perf_get_mediated_pmu() is called in vm_create() or enable_cap(KVM_CAP_PMU_CAPABILITY) ioctl.
> 
> E.g. this, if we're ok commiting to never enabling mediated PMU by defau
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 47d9f03b7778..01d9ee2114c8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6664,9 +6664,21 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                         break;
>  
>                 mutex_lock(&kvm->lock);
> -               if (!kvm->created_vcpus) {
> -                       kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CAP_DISABLE);
> -                       r = 0;
> +               /*
> +                * To keep PMU configuration "simple", setting vPMU support is
> +                * disallowed if vCPUs are created, or if mediated PMU support
> +                * was already enabled for the VM.
> +                */
> +               if (!kvm->created_vcpus &&
> +                   (!enable_mediated_pmu || !kvm->arch.enable_pmu)) {
> +                       if (enable_mediated_pmu &&
> +                           !(cap->args[0] & KVM_PMU_CAP_DISABLE))
> +                               r = x86_perf_get_mediated_pmu();
> +                       else
> +                               r = 0;
> +
> +                       if (!r)
> +                               kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CAP_DISABLE);
>                 }
>                 mutex_unlock(&kvm->lock);
>                 break;
> @@ -12563,7 +12575,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  
>         kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
>         kvm->arch.guest_can_read_msr_platform_info = true;
> -       kvm->arch.enable_pmu = enable_pmu;
> +
> +       /* PMU virtualization is opt-in when mediated PMU support is enabled. */
> +       kvm->arch.enable_pmu = enable_pmu && !enable_mediated_pmu;
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
>         spin_lock_init(&kvm->arch.hv_root_tdp_lock);
> 
> 

