Return-Path: <kvm+bounces-37574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29E91A2BFF2
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 10:52:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FDC41692F8
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 09:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81A7C199385;
	Fri,  7 Feb 2025 09:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YqlQP42B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1EE32C8B
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 09:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738921958; cv=none; b=Try1e5GUqiPmBoUO1L8xkIwbdILpykmbb52RiA9JzFkbFPH/Ln+FTtc9FAxwHsiZGZgI1N/rv4OahFVbv5cyUamB4//Fg6qOdxTP+QaZfqQAwpMWn/4wSWLTQP/v68D2h5WoSueBNghwP05G8qsEHIfmee/RcSSZYfWrvLGHdhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738921958; c=relaxed/simple;
	bh=QfDHwU4WFqlhad+mz/oAtaXA8YLEPdI6cC2Vf2M+4EA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=p64VDc/+5jVEyzKGSZd3nGZZErpyVy7DoSBlDhjsWV4ccXda6prTB3KBkg/ZoUt1zggNte7Ut0C5r8Wk5foDCnDCQ3s3YhULVk2ghhq1u61OA6KJz/94GxnTYUClwm14C0L95o48VBWnVTBqOw8rgq43ZX28n+MIwI2Is2xZLJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YqlQP42B; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738921957; x=1770457957;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=QfDHwU4WFqlhad+mz/oAtaXA8YLEPdI6cC2Vf2M+4EA=;
  b=YqlQP42BZ8Uh0CpxA9OAH+IIFfpMGsv02pnYff6zIHSNXHBiVrXbHYB9
   yp+HNz8XbeBT5uqcHaZhRa0UoVy8Nh27lK6Xd0UefzEO9Qk/npofO+XGw
   ItzOI0F1ra/YDEV8bvKwDf1NvPh06ruHnMkeW1CqeLswx1YAYdVtMF1fZ
   BofkpRNtKQM3BjhkOnKKrMeXTZ/t4tgqCm89n/1f8EWfMhEvFLnNhTeRJ
   r5wUuxiNIC5t0YrCK96ZvWFb7FphNFHHALl5zSUgvabjpVjN7PHkspekP
   GZnu60V/yZB7pae3xmwifpsX50QiR9boFHxOf1IJ/VyEWEMDYkXHIm6gT
   A==;
X-CSE-ConnectionGUID: hFLCU2BgTuKYtvbu+PmKyw==
X-CSE-MsgGUID: 5rgwYNP4Q9uWVVL3F3PfxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="64914864"
X-IronPort-AV: E=Sophos;i="6.13,266,1732608000"; 
   d="scan'208";a="64914864"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2025 01:52:35 -0800
X-CSE-ConnectionGUID: 8yqOncvtQxKIq/6IqQdw/Q==
X-CSE-MsgGUID: 2pAW6AyuQumiD0897jHdQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="116417443"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2025 01:52:31 -0800
Message-ID: <6aefa9df-10e3-4001-a509-a4bc3850d65a@linux.intel.com>
Date: Fri, 7 Feb 2025 17:52:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
 KVM_PMU_CAP_DISABLE
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
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
 <f4a2f801-9f82-424e-aee4-8b18add34aa6@linux.intel.com>
Content-Language: en-US
In-Reply-To: <f4a2f801-9f82-424e-aee4-8b18add34aa6@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 11/21/2024 6:06 PM, Mi, Dapeng wrote:
> On 11/8/2024 7:44 AM, dongli.zhang@oracle.com wrote:
>> Hi Zhao,
>>
>>
>> On 11/6/24 11:52 PM, Zhao Liu wrote:
>>> (+Dapang & Zide)
>>>
>>> Hi Dongli,
>>>
>>> On Mon, Nov 04, 2024 at 01:40:17AM -0800, Dongli Zhang wrote:
>>>> Date: Mon,  4 Nov 2024 01:40:17 -0800
>>>> From: Dongli Zhang <dongli.zhang@oracle.com>
>>>> Subject: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
>>>>  KVM_PMU_CAP_DISABLE
>>>> X-Mailer: git-send-email 2.43.5
>>>>
>>>> The AMD PMU virtualization is not disabled when configuring
>>>> "-cpu host,-pmu" in the QEMU command line on an AMD server. Neither
>>>> "-cpu host,-pmu" nor "-cpu EPYC" effectively disables AMD PMU
>>>> virtualization in such an environment.
>>>>
>>>> As a result, VM logs typically show:
>>>>
>>>> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>>>>
>>>> whereas the expected logs should be:
>>>>
>>>> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
>>>> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>>>>
>>>> This discrepancy occurs because AMD PMU does not use CPUID to determine
>>>> whether PMU virtualization is supported.
>>> Intel platform doesn't have this issue since Linux kernel fails to check
>>> the CPU family & model when "-cpu *,-pmu" option clears PMU version.
>>>
>>> The difference between Intel and AMD platforms, however, is that it seems
>>> Intel hardly ever reaches the “...due virtualization” message, but
>>> instead reports an error because it recognizes a mismatched family/model.
>>>
>>> This may be a drawback of the PMU driver's print message, but the result
>>> is the same, it prevents the PMU driver from enabling.
>>>
>>> So, please mention that KVM_PMU_CAP_DISABLE doesn't change the PMU
>>> behavior on Intel platform because current "pmu" property works as
>>> expected.
>> Sure. I will mention this in v2.
>>
>>>> To address this, we introduce a new property, 'pmu-cap-disabled', for KVM
>>>> acceleration. This property sets KVM_PMU_CAP_DISABLE if
>>>> KVM_CAP_PMU_CAPABILITY is supported. Note that this feature currently
>>>> supports only x86 hosts, as KVM_CAP_PMU_CAPABILITY is used exclusively for
>>>> x86 systems.
>>>>
>>>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>>>> ---
>>>> Another previous solution to re-use '-cpu host,-pmu':
>>>> https://urldefense.com/v3/__https://lore.kernel.org/all/20221119122901.2469-1-dongli.zhang@oracle.com/__;!!ACWV5N9M2RV99hQ!Nm8Db-mwBoMIwKkRqzC9kgNi5uZ7SCIf43zUBn92Ar_NEbLXq-ZkrDDvpvDQ4cnS2i4VyKAp6CRVE12bRkMF$ 
>>> IMO, I prefer the previous version. This VM-level KVM property is
>>> difficult to integrate with the existing CPU properties. Pls refer later
>>> comments for reasons.
>>>
>>>>  accel/kvm/kvm-all.c        |  1 +
>>>>  include/sysemu/kvm_int.h   |  1 +
>>>>  qemu-options.hx            |  9 ++++++-
>>>>  target/i386/cpu.c          |  2 +-
>>>>  target/i386/kvm/kvm.c      | 52 ++++++++++++++++++++++++++++++++++++++
>>>>  target/i386/kvm/kvm_i386.h |  2 ++
>>>>  6 files changed, 65 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>>> index 801cff16a5..8b5ba45cf7 100644
>>>> --- a/accel/kvm/kvm-all.c
>>>> +++ b/accel/kvm/kvm-all.c
>>>> @@ -3933,6 +3933,7 @@ static void kvm_accel_instance_init(Object *obj)
>>>>      s->xen_evtchn_max_pirq = 256;
>>>>      s->device = NULL;
>>>>      s->msr_energy.enable = false;
>>>> +    s->pmu_cap_disabled = false;
>>>>  }
>>> The CPU property "pmu" also defaults to "false"...but:
>>>
>>>  * max CPU would override this and try to enable PMU by default in
>>>    max_x86_cpu_initfn().
>>>
>>>  * Other named CPU models keep the default setting to avoid affecting
>>>    the migration.
>>>
>>> The pmu_cap_disabled and “pmu” property look unbound and unassociated,
>>> so this can cause the conflict when they are not synchronized. For
>>> example,
>>>
>>> -cpu host -accel kvm,pmu-cap-disabled=on
>>>
>>> The above options will fail to launch a VM (on Intel platform).
>>>
>>> Ideally, the “pmu” property and pmu-cap-disabled should be bound to each
>>> other and be consistent. But it's not easy because:
>>>  - There is no proper way to have pmu_cap_disabled set different default
>>>    values (e.g., "false" for max CPU and "true" for named CPU models)
>>>    based on different CPU models.
>>>  - And, no proper place to check the consistency of pmu_cap_disabled and
>>>    enable_pmu.
>>>
>>> Therefore, I prefer your previous approach, to reuse current CPU "pmu"
>>> property.
>> Thank you very much for the suggestion and reasons.
>>
>> I am going to follow your suggestion to switch back to the previous solution in v2.
> +1.
>
>  I also prefer to leverage current exist "+/-pmu" option instead of adding
> a new option. More options, more complexity. When they are not
> inconsistent, which has higher priority? all these are issues.
>
> Although KVM_CAP_PMU_CAPABILITY is a VM-level PMU capability, but all CPUs
> in a same VM should always share same PMU configuration (Don't consider
> hybrid platforms which have many issues need to be handled specifically).
>
>
>>> Further, considering that this is currently the only case that needs to
>>> to set the VM level's capability in the CPU context, there is no need to
>>> introduce a new kvm interface (in your previous patch), which can instead
>>> be set in kvm_cpu_realizefn(), like:
>>>
>>>
>>> diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
>>> index 99d1941cf51c..05e9c9a1a0cf 100644
>>> --- a/target/i386/kvm/kvm-cpu.c
>>> +++ b/target/i386/kvm/kvm-cpu.c
>>> @@ -42,6 +42,8 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>>>  {
>>>      X86CPU *cpu = X86_CPU(cs);
>>>      CPUX86State *env = &cpu->env;
>>> +    KVMState *s = kvm_state;
>>> +    static bool first = true;
>>>      bool ret;
>>>
>>>      /*
>>> @@ -63,6 +65,29 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>>>       *   check/update ucode_rev, phys_bits, guest_phys_bits, mwait
>>>       *   cpu_common_realizefn() (via xcc->parent_realize)
>>>       */
>>> +
>>> +    if (first) {
>>> +        first = false;
>>> +
>>> +        /*
>>> +         * Since Linux v5.18, KVM provides a VM-level capability to easily
>>> +         * disable PMUs; however, QEMU has been providing PMU property per
>>> +         * CPU since v1.6. In order to accommodate both, have to configure
>>> +         * the VM-level capability here.
>>> +         */
>>> +        if (!cpu->enable_pmu &&
>>> +            kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY)) {
>>> +            int r = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
>>> +                                      KVM_PMU_CAP_DISABLE);
>>> +
>>> +            if (r < 0) {
>>> +                error_setg(errp, "kvm: Failed to disable pmu cap: %s",
>>> +                           strerror(-r));
>>> +                return false;
>>> +            }
>>> +        }
> It seems KVM_CAP_PMU_CAPABILITY is called to only disable PMU here. From
> point view of logic completeness,  KVM_CAP_PMU_CAPABILITY should be called
> to enabled PMU as well when user wants to enable PMU.
>
> I know currently we only need to disable PMU, but we may need to enable PMU
> via KVM_CAP_PMU_CAPABILITY soon.
>
> We are working on the new KVM mediated vPMU framework, Sean suggest to
> leverage KVM_CAP_PMU_CAPABILITY to enable mediated vPMU dynamically
> (https://lore.kernel.org/all/Zz4uhmuPcZl9vJVr@google.com/). So It would be
> better if the enable logic can be added here as well.
>
> Thanks.

Hi Dongli,

May I know if you have plan to continue to update this patch recently? As
previous comment said, our KVM mediated vPMU solution needs qemu to
explicitly call KVM_CAP_PMU_CAPABILITY to enable mediated vPMU as well. If
you have no plan to update this patch recently, would you mind me to pick
up this patch
(https://lore.kernel.org/all/20221119122901.2469-2-dongli.zhang@oracle.com/)
and post with other our mediated vPMU related patches to enable mediated vPMU?

Thanks!

Dapeng Mi

>
>
>>> +    }
>>> +
>>>      if (cpu->max_features) {
>>>          if (enable_cpu_pm) {
>>>              if (kvm_has_waitpkg()) {
>>> ---
>> Sure. I will limit the change within only x86 + KVM.
>>
>>> In addition, if PMU is disabled, why not mask the perf related bits in
>>> 8000_0001_ECX? :)
>>>
>> My fault. I have masked only 0x80000022, and I forgot 0x80000001 for AMD.
>>
>> Thank you very much for the reminder.
>>
>>
>> I will wait for a day or maybe the weekend. I am going to switch to the previous
>> solution in v2 if there isn't any further objection with a more valid reason.
>>
>> Thank you very much for the feedback!
>>
>> Dongli Zhang
>>
>>

