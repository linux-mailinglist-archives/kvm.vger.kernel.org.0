Return-Path: <kvm+bounces-32247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E584F9D4A71
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 11:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45001B21C76
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 10:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DDF1D0490;
	Thu, 21 Nov 2024 10:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gJaEDOs0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA5B1CDFD2
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732183607; cv=none; b=BI8j242XKOgxODOoXrjQY9ZG7o+DTe8fFRHjkxK228wHVhc16RQHRjo7FlUWyt0yOPB+2pXdCJhURfZ0RIdrFCd8GnJvZMtg+H6igys4lNyLROWMaGE4ssGa6cU9ZfFyhIm/aIzBrcsBc7psgdXBv3BBLq3R0mQL2bBmZPQRDJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732183607; c=relaxed/simple;
	bh=K8HZ/likPSgJ80y1w8nAet2hlf7QHqom9zLT17bwNJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ocwZKdfpz0Np0qih/COMwtnoWFftdWiNBxG5LJjtO3Iym+x1M2AMgR3IT4DOxwfX5ledDmo8WCP3rbJV33mZW2MfMYFJbL1ZE9Q4KYlTqo65PZVO3r4RmdtWdsUj7dQZFdTAKQSIZHv+XY5F2l8nTzRgMEmsKSjaQfcU3vis40w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gJaEDOs0; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732183606; x=1763719606;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K8HZ/likPSgJ80y1w8nAet2hlf7QHqom9zLT17bwNJc=;
  b=gJaEDOs0HNxpDYMkgzrd3JCT0SOuqGmO0clb2g1o/uJGfIuOy5GAeo2a
   7e08hEmvMAfrrpGIXTUZnpWVL6bsRJSsfRWm2mg1aDW1dTLEobpYjubLf
   bLJmAS8Rlc2SnbX1xgZgrgzT16eUOhJltdxsKQ7Uz56nNDRACbK0ahHXu
   ato2SEWwnsd38YXt7nz0qQ51oJJDIU8EzNeTz8a0CsA76dP/BfxbCJj3k
   CJ7rNPpL31Pn5G6LLIJU5rEm/NNwe3ZwCK/o6HBmz0SYnGlMSFe9Rix4m
   xf6ZjqEsQpJLByb2fwMKkd5TCds41rssWoe1B/LedcPEJyLdr7R5bORuH
   g==;
X-CSE-ConnectionGUID: 7+EGCy8iTM+FYsWAhg5j3Q==
X-CSE-MsgGUID: 0DMOm6GyQIePqCwrX7qsXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="42926544"
X-IronPort-AV: E=Sophos;i="6.12,172,1728975600"; 
   d="scan'208";a="42926544"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 02:06:45 -0800
X-CSE-ConnectionGUID: 9dPM6YS0RiqQzXTN4p8mcg==
X-CSE-MsgGUID: Ab9HL6J4S9WLXDw1H9RlkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,172,1728975600"; 
   d="scan'208";a="121066621"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 02:06:41 -0800
Message-ID: <f4a2f801-9f82-424e-aee4-8b18add34aa6@linux.intel.com>
Date: Thu, 21 Nov 2024 18:06:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
 KVM_PMU_CAP_DISABLE
To: dongli.zhang@oracle.com, Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
 mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
 likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
 groug@kaod.org, lyan@digitalocean.com, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
 davydov-max@yandex-team.ru, zide.chen@intel.com
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-3-dongli.zhang@oracle.com> <ZyxxygVaufOntpZJ@intel.com>
 <57b4b74d-67d2-4fcf-aa59-c788afc93619@oracle.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <57b4b74d-67d2-4fcf-aa59-c788afc93619@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 11/8/2024 7:44 AM, dongli.zhang@oracle.com wrote:
> Hi Zhao,
>
>
> On 11/6/24 11:52 PM, Zhao Liu wrote:
>> (+Dapang & Zide)
>>
>> Hi Dongli,
>>
>> On Mon, Nov 04, 2024 at 01:40:17AM -0800, Dongli Zhang wrote:
>>> Date: Mon,  4 Nov 2024 01:40:17 -0800
>>> From: Dongli Zhang <dongli.zhang@oracle.com>
>>> Subject: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
>>>  KVM_PMU_CAP_DISABLE
>>> X-Mailer: git-send-email 2.43.5
>>>
>>> The AMD PMU virtualization is not disabled when configuring
>>> "-cpu host,-pmu" in the QEMU command line on an AMD server. Neither
>>> "-cpu host,-pmu" nor "-cpu EPYC" effectively disables AMD PMU
>>> virtualization in such an environment.
>>>
>>> As a result, VM logs typically show:
>>>
>>> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>>>
>>> whereas the expected logs should be:
>>>
>>> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
>>> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>>>
>>> This discrepancy occurs because AMD PMU does not use CPUID to determine
>>> whether PMU virtualization is supported.
>> Intel platform doesn't have this issue since Linux kernel fails to check
>> the CPU family & model when "-cpu *,-pmu" option clears PMU version.
>>
>> The difference between Intel and AMD platforms, however, is that it seems
>> Intel hardly ever reaches the “...due virtualization” message, but
>> instead reports an error because it recognizes a mismatched family/model.
>>
>> This may be a drawback of the PMU driver's print message, but the result
>> is the same, it prevents the PMU driver from enabling.
>>
>> So, please mention that KVM_PMU_CAP_DISABLE doesn't change the PMU
>> behavior on Intel platform because current "pmu" property works as
>> expected.
> Sure. I will mention this in v2.
>
>>> To address this, we introduce a new property, 'pmu-cap-disabled', for KVM
>>> acceleration. This property sets KVM_PMU_CAP_DISABLE if
>>> KVM_CAP_PMU_CAPABILITY is supported. Note that this feature currently
>>> supports only x86 hosts, as KVM_CAP_PMU_CAPABILITY is used exclusively for
>>> x86 systems.
>>>
>>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>>> ---
>>> Another previous solution to re-use '-cpu host,-pmu':
>>> https://urldefense.com/v3/__https://lore.kernel.org/all/20221119122901.2469-1-dongli.zhang@oracle.com/__;!!ACWV5N9M2RV99hQ!Nm8Db-mwBoMIwKkRqzC9kgNi5uZ7SCIf43zUBn92Ar_NEbLXq-ZkrDDvpvDQ4cnS2i4VyKAp6CRVE12bRkMF$ 
>> IMO, I prefer the previous version. This VM-level KVM property is
>> difficult to integrate with the existing CPU properties. Pls refer later
>> comments for reasons.
>>
>>>  accel/kvm/kvm-all.c        |  1 +
>>>  include/sysemu/kvm_int.h   |  1 +
>>>  qemu-options.hx            |  9 ++++++-
>>>  target/i386/cpu.c          |  2 +-
>>>  target/i386/kvm/kvm.c      | 52 ++++++++++++++++++++++++++++++++++++++
>>>  target/i386/kvm/kvm_i386.h |  2 ++
>>>  6 files changed, 65 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>> index 801cff16a5..8b5ba45cf7 100644
>>> --- a/accel/kvm/kvm-all.c
>>> +++ b/accel/kvm/kvm-all.c
>>> @@ -3933,6 +3933,7 @@ static void kvm_accel_instance_init(Object *obj)
>>>      s->xen_evtchn_max_pirq = 256;
>>>      s->device = NULL;
>>>      s->msr_energy.enable = false;
>>> +    s->pmu_cap_disabled = false;
>>>  }
>> The CPU property "pmu" also defaults to "false"...but:
>>
>>  * max CPU would override this and try to enable PMU by default in
>>    max_x86_cpu_initfn().
>>
>>  * Other named CPU models keep the default setting to avoid affecting
>>    the migration.
>>
>> The pmu_cap_disabled and “pmu” property look unbound and unassociated,
>> so this can cause the conflict when they are not synchronized. For
>> example,
>>
>> -cpu host -accel kvm,pmu-cap-disabled=on
>>
>> The above options will fail to launch a VM (on Intel platform).
>>
>> Ideally, the “pmu” property and pmu-cap-disabled should be bound to each
>> other and be consistent. But it's not easy because:
>>  - There is no proper way to have pmu_cap_disabled set different default
>>    values (e.g., "false" for max CPU and "true" for named CPU models)
>>    based on different CPU models.
>>  - And, no proper place to check the consistency of pmu_cap_disabled and
>>    enable_pmu.
>>
>> Therefore, I prefer your previous approach, to reuse current CPU "pmu"
>> property.
> Thank you very much for the suggestion and reasons.
>
> I am going to follow your suggestion to switch back to the previous solution in v2.

+1.

 I also prefer to leverage current exist "+/-pmu" option instead of adding
a new option. More options, more complexity. When they are not
inconsistent, which has higher priority? all these are issues.

Although KVM_CAP_PMU_CAPABILITY is a VM-level PMU capability, but all CPUs
in a same VM should always share same PMU configuration (Don't consider
hybrid platforms which have many issues need to be handled specifically).


>
>> Further, considering that this is currently the only case that needs to
>> to set the VM level's capability in the CPU context, there is no need to
>> introduce a new kvm interface (in your previous patch), which can instead
>> be set in kvm_cpu_realizefn(), like:
>>
>>
>> diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
>> index 99d1941cf51c..05e9c9a1a0cf 100644
>> --- a/target/i386/kvm/kvm-cpu.c
>> +++ b/target/i386/kvm/kvm-cpu.c
>> @@ -42,6 +42,8 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>>  {
>>      X86CPU *cpu = X86_CPU(cs);
>>      CPUX86State *env = &cpu->env;
>> +    KVMState *s = kvm_state;
>> +    static bool first = true;
>>      bool ret;
>>
>>      /*
>> @@ -63,6 +65,29 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>>       *   check/update ucode_rev, phys_bits, guest_phys_bits, mwait
>>       *   cpu_common_realizefn() (via xcc->parent_realize)
>>       */
>> +
>> +    if (first) {
>> +        first = false;
>> +
>> +        /*
>> +         * Since Linux v5.18, KVM provides a VM-level capability to easily
>> +         * disable PMUs; however, QEMU has been providing PMU property per
>> +         * CPU since v1.6. In order to accommodate both, have to configure
>> +         * the VM-level capability here.
>> +         */
>> +        if (!cpu->enable_pmu &&
>> +            kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY)) {
>> +            int r = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
>> +                                      KVM_PMU_CAP_DISABLE);
>> +
>> +            if (r < 0) {
>> +                error_setg(errp, "kvm: Failed to disable pmu cap: %s",
>> +                           strerror(-r));
>> +                return false;
>> +            }
>> +        }

It seems KVM_CAP_PMU_CAPABILITY is called to only disable PMU here. From
point view of logic completeness,  KVM_CAP_PMU_CAPABILITY should be called
to enabled PMU as well when user wants to enable PMU.

I know currently we only need to disable PMU, but we may need to enable PMU
via KVM_CAP_PMU_CAPABILITY soon.

We are working on the new KVM mediated vPMU framework, Sean suggest to
leverage KVM_CAP_PMU_CAPABILITY to enable mediated vPMU dynamically
(https://lore.kernel.org/all/Zz4uhmuPcZl9vJVr@google.com/). So It would be
better if the enable logic can be added here as well.

Thanks.


>> +    }
>> +
>>      if (cpu->max_features) {
>>          if (enable_cpu_pm) {
>>              if (kvm_has_waitpkg()) {
>> ---
> Sure. I will limit the change within only x86 + KVM.
>
>> In addition, if PMU is disabled, why not mask the perf related bits in
>> 8000_0001_ECX? :)
>>
> My fault. I have masked only 0x80000022, and I forgot 0x80000001 for AMD.
>
> Thank you very much for the reminder.
>
>
> I will wait for a day or maybe the weekend. I am going to switch to the previous
> solution in v2 if there isn't any further objection with a more valid reason.
>
> Thank you very much for the feedback!
>
> Dongli Zhang
>
>

