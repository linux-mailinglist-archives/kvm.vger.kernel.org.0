Return-Path: <kvm+bounces-37680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA49CA2E5FD
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 09:04:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE0483A7EA5
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 08:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85C91B414B;
	Mon, 10 Feb 2025 08:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fnr7XnbM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9EB57C93
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 08:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739174665; cv=none; b=lv68ArekixUiBoaQ7YImGzBS4dTK3L0AZMy3udVGDi+WaJr4JhLuTeTujHtTksuW/qf4pZzzCqlNyJBE1WZlBSCNXW0IRrnsyoVZGghYP1NM0xGrIr/HGaXRHS+1C/2cS4ylCxctpEPY5Hw/b7nKqozU5S7xiBjxsp9yqn2rOt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739174665; c=relaxed/simple;
	bh=bnws4m/cgsYVSJVmsCZ/sWjxAsmEtJj8WLVAn6Evxao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eiecN+60os4ul0u8PGcYRtQrSSnoil0FHn1WtSM6PCFLEFdHk4wdrt4fSUpx4LSJ+ZJGJFafID7hW24W1RiDN2DKOMzYVO+6jxq90JQt94rxLvMMQEG8dKh/LXckAo9xYuZM095IMjLp1IDsX3LOy0yaHVmFyhX6bCn0sTH6i1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fnr7XnbM; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739174663; x=1770710663;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bnws4m/cgsYVSJVmsCZ/sWjxAsmEtJj8WLVAn6Evxao=;
  b=Fnr7XnbMaBtXsVgRgo2hMzjnmSJrU5mtyYww1KLG61KlqLNCjY1VD91g
   kraQ29rdWekss144Ox0gyakmsFFvUlqceUynkwc/Uh6nswfvQp6zRxNHc
   Dsc6DvO7jIm7aPXNYrSisYFCcgCEHXlA6qkisEf6ecDKqVNUS0YiBMXwv
   QG1iEP6a7wV6QDYSYJgyntOTj9d9FAYCew4CFzDSIW2MOULlWodTUo1tP
   Bsoz3X9ukqMeOkNA7XvglXeO3Ud3Aszq5YdEZ0INZFqzJszJ9JJy/DQIt
   wXQyvkLN9pl2UzPrh8C+dpjK4D71YDZghEIvnquyJrVlZfL0HZ3FIlLgz
   A==;
X-CSE-ConnectionGUID: 1Ie4ZDEKSGiw8luGehAfEQ==
X-CSE-MsgGUID: EBO/4NSSQVy9ssBbhkD+5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11340"; a="39654243"
X-IronPort-AV: E=Sophos;i="6.13,274,1732608000"; 
   d="scan'208";a="39654243"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 00:04:08 -0800
X-CSE-ConnectionGUID: CAzXRT3sTcmw4z9x6jPYeA==
X-CSE-MsgGUID: ExSnojCPTAOWmnvW9GKjOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,274,1732608000"; 
   d="scan'208";a="112345679"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 00:04:03 -0800
Message-ID: <8618eac7-80ae-4533-9b05-17323955d1b5@linux.intel.com>
Date: Mon, 10 Feb 2025 16:04:00 +0800
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
 <f4a2f801-9f82-424e-aee4-8b18add34aa6@linux.intel.com>
 <6aefa9df-10e3-4001-a509-a4bc3850d65a@linux.intel.com>
 <bf41c97a-b5e2-4cfd-90ef-89f12f1b384a@oracle.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <bf41c97a-b5e2-4cfd-90ef-89f12f1b384a@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 2/10/2025 4:12 AM, dongli.zhang@oracle.com wrote:
> Hi Dapeng,
>
> On 2/7/25 1:52 AM, Mi, Dapeng wrote:
>> On 11/21/2024 6:06 PM, Mi, Dapeng wrote:
>>> On 11/8/2024 7:44 AM, dongli.zhang@oracle.com wrote:
>>>> Hi Zhao,
>>>>
>>>>
>>>> On 11/6/24 11:52 PM, Zhao Liu wrote:
>>>>> (+Dapang & Zide)
>>>>>
>>>>> Hi Dongli,
>>>>>
>>>>> On Mon, Nov 04, 2024 at 01:40:17AM -0800, Dongli Zhang wrote:
>>>>>> Date: Mon,  4 Nov 2024 01:40:17 -0800
>>>>>> From: Dongli Zhang <dongli.zhang@oracle.com>
>>>>>> Subject: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
>>>>>>  KVM_PMU_CAP_DISABLE
>>>>>> X-Mailer: git-send-email 2.43.5
>>>>>>
>>>>>> The AMD PMU virtualization is not disabled when configuring
>>>>>> "-cpu host,-pmu" in the QEMU command line on an AMD server. Neither
>>>>>> "-cpu host,-pmu" nor "-cpu EPYC" effectively disables AMD PMU
>>>>>> virtualization in such an environment.
>>>>>>
>>>>>> As a result, VM logs typically show:
>>>>>>
>>>>>> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>>>>>>
>>>>>> whereas the expected logs should be:
>>>>>>
>>>>>> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
>>>>>> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>>>>>>
>>>>>> This discrepancy occurs because AMD PMU does not use CPUID to determine
>>>>>> whether PMU virtualization is supported.
>>>>> Intel platform doesn't have this issue since Linux kernel fails to check
>>>>> the CPU family & model when "-cpu *,-pmu" option clears PMU version.
>>>>>
>>>>> The difference between Intel and AMD platforms, however, is that it seems
>>>>> Intel hardly ever reaches the “...due virtualization” message, but
>>>>> instead reports an error because it recognizes a mismatched family/model.
>>>>>
>>>>> This may be a drawback of the PMU driver's print message, but the result
>>>>> is the same, it prevents the PMU driver from enabling.
>>>>>
>>>>> So, please mention that KVM_PMU_CAP_DISABLE doesn't change the PMU
>>>>> behavior on Intel platform because current "pmu" property works as
>>>>> expected.
>>>> Sure. I will mention this in v2.
>>>>
>>>>>> To address this, we introduce a new property, 'pmu-cap-disabled', for KVM
>>>>>> acceleration. This property sets KVM_PMU_CAP_DISABLE if
>>>>>> KVM_CAP_PMU_CAPABILITY is supported. Note that this feature currently
>>>>>> supports only x86 hosts, as KVM_CAP_PMU_CAPABILITY is used exclusively for
>>>>>> x86 systems.
>>>>>>
>>>>>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>>>>>> ---
>>>>>> Another previous solution to re-use '-cpu host,-pmu':
>>>>>> https://urldefense.com/v3/__https://lore.kernel.org/all/20221119122901.2469-1-dongli.zhang@oracle.com/__;!!ACWV5N9M2RV99hQ!Nm8Db-mwBoMIwKkRqzC9kgNi5uZ7SCIf43zUBn92Ar_NEbLXq-ZkrDDvpvDQ4cnS2i4VyKAp6CRVE12bRkMF$ 
>>>>> IMO, I prefer the previous version. This VM-level KVM property is
>>>>> difficult to integrate with the existing CPU properties. Pls refer later
>>>>> comments for reasons.
>>>>>
>>>>>>  accel/kvm/kvm-all.c        |  1 +
>>>>>>  include/sysemu/kvm_int.h   |  1 +
>>>>>>  qemu-options.hx            |  9 ++++++-
>>>>>>  target/i386/cpu.c          |  2 +-
>>>>>>  target/i386/kvm/kvm.c      | 52 ++++++++++++++++++++++++++++++++++++++
>>>>>>  target/i386/kvm/kvm_i386.h |  2 ++
>>>>>>  6 files changed, 65 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>>>>> index 801cff16a5..8b5ba45cf7 100644
>>>>>> --- a/accel/kvm/kvm-all.c
>>>>>> +++ b/accel/kvm/kvm-all.c
>>>>>> @@ -3933,6 +3933,7 @@ static void kvm_accel_instance_init(Object *obj)
>>>>>>      s->xen_evtchn_max_pirq = 256;
>>>>>>      s->device = NULL;
>>>>>>      s->msr_energy.enable = false;
>>>>>> +    s->pmu_cap_disabled = false;
>>>>>>  }
>>>>> The CPU property "pmu" also defaults to "false"...but:
>>>>>
>>>>>  * max CPU would override this and try to enable PMU by default in
>>>>>    max_x86_cpu_initfn().
>>>>>
>>>>>  * Other named CPU models keep the default setting to avoid affecting
>>>>>    the migration.
>>>>>
>>>>> The pmu_cap_disabled and “pmu” property look unbound and unassociated,
>>>>> so this can cause the conflict when they are not synchronized. For
>>>>> example,
>>>>>
>>>>> -cpu host -accel kvm,pmu-cap-disabled=on
>>>>>
>>>>> The above options will fail to launch a VM (on Intel platform).
>>>>>
>>>>> Ideally, the “pmu” property and pmu-cap-disabled should be bound to each
>>>>> other and be consistent. But it's not easy because:
>>>>>  - There is no proper way to have pmu_cap_disabled set different default
>>>>>    values (e.g., "false" for max CPU and "true" for named CPU models)
>>>>>    based on different CPU models.
>>>>>  - And, no proper place to check the consistency of pmu_cap_disabled and
>>>>>    enable_pmu.
>>>>>
>>>>> Therefore, I prefer your previous approach, to reuse current CPU "pmu"
>>>>> property.
>>>> Thank you very much for the suggestion and reasons.
>>>>
>>>> I am going to follow your suggestion to switch back to the previous solution in v2.
>>> +1.
>>>
>>>  I also prefer to leverage current exist "+/-pmu" option instead of adding
>>> a new option. More options, more complexity. When they are not
>>> inconsistent, which has higher priority? all these are issues.
>>>
>>> Although KVM_CAP_PMU_CAPABILITY is a VM-level PMU capability, but all CPUs
>>> in a same VM should always share same PMU configuration (Don't consider
>>> hybrid platforms which have many issues need to be handled specifically).
>>>
>>>
>>>>> Further, considering that this is currently the only case that needs to
>>>>> to set the VM level's capability in the CPU context, there is no need to
>>>>> introduce a new kvm interface (in your previous patch), which can instead
>>>>> be set in kvm_cpu_realizefn(), like:
>>>>>
>>>>>
>>>>> diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
>>>>> index 99d1941cf51c..05e9c9a1a0cf 100644
>>>>> --- a/target/i386/kvm/kvm-cpu.c
>>>>> +++ b/target/i386/kvm/kvm-cpu.c
>>>>> @@ -42,6 +42,8 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>>>>>  {
>>>>>      X86CPU *cpu = X86_CPU(cs);
>>>>>      CPUX86State *env = &cpu->env;
>>>>> +    KVMState *s = kvm_state;
>>>>> +    static bool first = true;
>>>>>      bool ret;
>>>>>
>>>>>      /*
>>>>> @@ -63,6 +65,29 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>>>>>       *   check/update ucode_rev, phys_bits, guest_phys_bits, mwait
>>>>>       *   cpu_common_realizefn() (via xcc->parent_realize)
>>>>>       */
>>>>> +
>>>>> +    if (first) {
>>>>> +        first = false;
>>>>> +
>>>>> +        /*
>>>>> +         * Since Linux v5.18, KVM provides a VM-level capability to easily
>>>>> +         * disable PMUs; however, QEMU has been providing PMU property per
>>>>> +         * CPU since v1.6. In order to accommodate both, have to configure
>>>>> +         * the VM-level capability here.
>>>>> +         */
>>>>> +        if (!cpu->enable_pmu &&
>>>>> +            kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY)) {
>>>>> +            int r = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
>>>>> +                                      KVM_PMU_CAP_DISABLE);
>>>>> +
>>>>> +            if (r < 0) {
>>>>> +                error_setg(errp, "kvm: Failed to disable pmu cap: %s",
>>>>> +                           strerror(-r));
>>>>> +                return false;
>>>>> +            }
>>>>> +        }
>>> It seems KVM_CAP_PMU_CAPABILITY is called to only disable PMU here. From
>>> point view of logic completeness,  KVM_CAP_PMU_CAPABILITY should be called
>>> to enabled PMU as well when user wants to enable PMU.
>>>
>>> I know currently we only need to disable PMU, but we may need to enable PMU
>>> via KVM_CAP_PMU_CAPABILITY soon.
>>>
>>> We are working on the new KVM mediated vPMU framework, Sean suggest to
>>> leverage KVM_CAP_PMU_CAPABILITY to enable mediated vPMU dynamically
>>> (https://urldefense.com/v3/__https://lore.kernel.org/all/Zz4uhmuPcZl9vJVr@google.com/__;!!ACWV5N9M2RV99hQ!JQx8CdjEI-J6WbzbvB7vHcZ0nJPkzUhvl6TvWvDorAal1XAC17dwpRa6b6Xlva--pK-4ej3Ota0k9SJl3BUWXKTew70$ ). So It would be
>>> better if the enable logic can be added here as well.
>>>
>>> Thanks.
>> Hi Dongli,
>>
>> May I know if you have plan to continue to update this patch recently? As
>> previous comment said, our KVM mediated vPMU solution needs qemu to
>> explicitly call KVM_CAP_PMU_CAPABILITY to enable mediated vPMU as well. If
>> you have no plan to update this patch recently, would you mind me to pick
>> up this patch
>> (https://urldefense.com/v3/__https://lore.kernel.org/all/20221119122901.2469-2-dongli.zhang@oracle.com/__;!!ACWV5N9M2RV99hQ!JQx8CdjEI-J6WbzbvB7vHcZ0nJPkzUhvl6TvWvDorAal1XAC17dwpRa6b6Xlva--pK-4ej3Ota0k9SJl3BUWzQmZ_yA$ )
>> and post with other our mediated vPMU related patches to enable mediated vPMU?
>>
>> Thanks!
>>
>> Dapeng Mi
>
> Sorry for the delay — it took some effort to learn about mediated vPMU (as
> you suggested) to adapt this patch accordingly.
>
> Yes, feel free to pick up this patch for mediated vPMU, as I don’t want to
> block your work, although, I do plan to continue updating it.
>
> I am continuing working on it, but my primary objective is to reset the AMD
> PMU during QEMU reset, which depends on KVM_PMU_CAP_DISABLE.
>
> [PATCH 5/7] target/i386/kvm: Reset AMD PMU registers during VM reset
> [PATCH 6/7] target/i386/kvm: Support perfmon-v2 for reset
>
> Would you mind keeping me updated on any changes/discussions you make to
> QEMU on KVM_PMU_CAP_DISABLE for mediated vPMU? That way, I can adjust my
> code accordingly once your QEMU patch for KVM_PMU_CAP_DISABLE is finalized.
>
> In the meantime, I am continuing working on the entire patchset and I can
> change the code when you post the relevant QEMU changes on
> KVM_PMU_CAP_DISABLE soon.
>
> Would that work for you?

Dongli,

Thanks for your feedback. Sure, I would add you into the mail loop when
sending the qemu mediated vPMU patches.

BTW, I found Xiaoyao ever sent a quite familiar patch
(https://lore.kernel.org/qemu-devel/20220317135913.2166202-10-xiaoyao.li@intel.com/)
and he has updated the patch to latest qemu code base, I would pick up his
patch directly.

Thanks,

Dapeng Mi


>
> Thank you very much!
>
> Dongli Zhang

