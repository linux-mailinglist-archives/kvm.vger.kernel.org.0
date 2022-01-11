Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A435348A71D
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 06:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbiAKFVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 00:21:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:10946 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241556AbiAKFVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 00:21:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641878475; x=1673414475;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SeBpGHW2Awj9fCFruQbs0jysOX1WgLyM8SQ0XPcSawQ=;
  b=iJxKJ5mvbHeW1mtzxeNeMR46qSAbhK+VpSzkI1QBBw78v5k3tr7o8Ii/
   TP7drDAdsGNcPLb3am1XiOCYQ9LP98xuu/f2ZHr8Bl/3s3SS6wiEwrV9N
   8g5OSy/cFr3ZNtNk+E7XRMQYdz+AW8pMgp4UL7vPfKX/wZ5kfnOlAu0Cr
   eFXhlhVaxHNjgaGN/jOEErNWTYW6QuqvXomtQDOlgwF8tCpwcEmk+dnPw
   J2luymyB2MOE4zXyiml3ZHFjrZMAYpu68qaP7gKxuhKjI6JKrN1ql5VAJ
   tHIMWohrMp2cMxaOkAUsVldwhYMLB3VbNQDhljZQtWlICN6s5mAEmqHeM
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="243201507"
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="243201507"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 21:21:14 -0800
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="690859624"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 21:21:12 -0800
Date:   Tue, 11 Jan 2022 13:32:06 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] KVM: Do compatibility checks on hotplugged CPUs
Message-ID: <20220111053205.GD2175@gao-cwp>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-7-chao.gao@intel.com>
 <YdzTfIEZ727L4g2R@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdzTfIEZ727L4g2R@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 12:46:52AM +0000, Sean Christopherson wrote:
>On Mon, Dec 27, 2021, Chao Gao wrote:
>> At init time, KVM does compatibility checks to ensure that all online
>> CPUs support hardware virtualization and a common set of features. But
>> KVM uses hotplugged CPUs without such compatibility checks. On Intel
>> CPUs, this leads to #GP if the hotplugged CPU doesn't support VMX or
>> vmentry failure if the hotplugged CPU doesn't meet minimal feature
>> requirements.
>> 
>> Do compatibility checks when onlining a CPU. If any VM is running,
>> KVM hotplug callback returns an error to abort onlining incompatible
>> CPUs.
>> 
>> But if no VM is running, onlining incompatible CPUs is allowed. Instead,
>> KVM is prohibited from creating VMs similar to the policy for init-time
>> compatibility checks.
>
>...
>
>> ---
>>  virt/kvm/kvm_main.c | 36 ++++++++++++++++++++++++++++++++++--
>>  1 file changed, 34 insertions(+), 2 deletions(-)
>> 
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index c1054604d1e8..0ff80076d48d 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -106,6 +106,8 @@ LIST_HEAD(vm_list);
>>  static cpumask_var_t cpus_hardware_enabled;
>>  static int kvm_usage_count;
>>  static atomic_t hardware_enable_failed;
>> +/* Set if hardware becomes incompatible after CPU hotplug */
>> +static bool hardware_incompatible;
>>  
>>  static struct kmem_cache *kvm_vcpu_cache;
>>  
>> @@ -4855,20 +4857,32 @@ static void hardware_enable_nolock(void *junk)
>>  
>>  static int kvm_online_cpu(unsigned int cpu)
>>  {
>> -	int ret = 0;
>> +	int ret;
>>  
>> +	ret = kvm_arch_check_processor_compat();
>>  	raw_spin_lock(&kvm_count_lock);
>>  	/*
>>  	 * Abort the CPU online process if hardware virtualization cannot
>>  	 * be enabled. Otherwise running VMs would encounter unrecoverable
>>  	 * errors when scheduled to this CPU.
>>  	 */
>> -	if (kvm_usage_count) {
>> +	if (!ret && kvm_usage_count) {
>>  		hardware_enable_nolock(NULL);
>>  		if (atomic_read(&hardware_enable_failed)) {
>>  			ret = -EIO;
>>  			pr_info("kvm: abort onlining CPU%d", cpu);
>>  		}
>> +	} else if (ret && !kvm_usage_count) {
>> +		/*
>> +		 * Continue onlining an incompatible CPU if no VM is
>> +		 * running. KVM should reject creating any VM after this
>> +		 * point. Then this CPU can be still used to run non-VM
>> +		 * workload.
>> +		 */
>> +		ret = 0;
>> +		hardware_incompatible = true;
>
>This has a fairly big flaw in that it prevents KVM from creating VMs even if the
>offending CPU is offlined.  That seems like a very reasonable thing to do, e.g.
>admin sees that hotplugging a CPU broke KVM and removes the CPU to remedy the
>problem.  And if KVM is built-in, reloading KVM to wipe hardware_incompatible
>after offlining the CPU isn't an option.

Ideally, yes, creation VMs should be allowed after offending CPUs are offlined.
But the problem is kind of foundamental: 

After kernel tries to online a CPU without VMX, boot_cpu_has(X86_FEATURE_VMX)
returns false. So, the current behavior is reloading KVM would fail if
kernel *tried* to bring up a CPU without VMX. So, it looks to me that
boot_cpu_has() doesn't do feature re-evalution either. Given that, I doubt
the value of making KVM able to create VM in this case.

>
>To make this approach work, I think kvm_offline_cpu() would have to reevaluate
>hardware_incompatible if the flag is set.
>
>And should there be a KVM module param to let the admin opt in/out of this
>behavior?  E.g. if the primary use case for a system is to run VMs, disabling
>KVM just to online a CPU isn't very helpful.
>
>That said, I'm not convinced that continuing with the hotplug in this scenario
>is ever the right thing to do.  Either the CPU being hotplugged really is a different
>CPU, or it's literally broken.  In both cases, odds are very, very good that running
>on the dodgy CPU will hose the kernel sooner or later, i.e. KVM's compatibility checks
>are just the canary in the coal mine.

Ok. Then here are two options:
1. KVM always prevents incompatible CPUs from being brought up regardless of running VMs
2. make "disabling KVM on incompatible CPUs" an opt-in feature.

Which one do you think is better?

And as said above, even with option 1, KVM reloading would fail due to
boot_cpu_has(X86_FEATURE_VMX). I suppose it isn't necessary to be fixed in this series.

>
>TDX is a different beast as (a) that's purely a security restriction and (b) anyone
>trying to run TDX guests darn well better know that TDX doesn't allow hotplug.
>In other words, if TDX gets disabled due to hotplug, either someone majorly screwed
>up and is going to be unhappy no matter what, or there's no intention of using TDX
>and it's a complete don't care.
>
>> +		pr_info("kvm: prohibit VM creation due to incompatible CPU%d",
>
>pr_info() is a bit weak, this should be at least pr_warn() and maybe even pr_err().
>
>> +			cpu);
>
>Eh, I'd omit the newline and let that poke out.

Will do.

>
>>  	}
>>  	raw_spin_unlock(&kvm_count_lock);
>>  	return ret;
>> @@ -4913,8 +4927,24 @@ static int hardware_enable_all(void)
>>  {
>>  	int r = 0;
>>  
>> +	/*
>> +	 * During onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
>> +	 * is called. on_each_cpu() between them includes the CPU. As a result,
>> +	 * hardware_enable_nolock() may get invoked before kvm_online_cpu().
>> +	 * This would enable hardware virtualization on that cpu without
>> +	 * compatibility checks, which can potentially crash system or break
>> +	 * running VMs.
>> +	 *
>> +	 * Disable CPU hotplug to prevent this case from happening.
>> +	 */
>> +	cpus_read_lock();
>>  	raw_spin_lock(&kvm_count_lock);
>>  
>> +	if (hardware_incompatible) {
>
>Another error message would likely be helpful here.  Even better would be if KVM
>could provide some way for userspace to query which CPU(s) is bad.

If option 1 is chosen, this check will be removed.

For option 2, will add an error message. And how about a debugfs tunable to provide
the list of bad CPUs?
