Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6465ADD88
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 04:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237678AbiIFCqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 22:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbiIFCqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 22:46:51 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F8F6B8FC;
        Mon,  5 Sep 2022 19:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662432410; x=1693968410;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7CdB3wigi7YuQKBSfYSGgarsGabHYEr32jS565LL5kQ=;
  b=S+iTqacc3EVQ8FDTfqpqOxbkxWfDiYtpBMcNNfW9xYfo1dg2OyUZrFHv
   zRBQ7NJTSnDMgG5m/2QZcquvAkJlq98++L++PG3RzJvYQjNFRqjFm+dEF
   EYJE+2SGyKtMG3pTWRSPPfcpWf6Jh7HYOP3ISoA/6gYPwTND6PlcS0t0z
   s799C0xrTmgOu0NtmLRvAHfdr62jNz3zwPLeGrgo7Arytz9hQN1BNCRau
   qZZ/S6JXjiFXfi3tzasfHOfv6j7KnwSBE7LErDRFu2USCEDWyJGMXgX5P
   jx6X5WoWukTCEiyIeEWLh2a4iId/trdH/vqky0kJHhIJeBCf2oaIon8YA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="279501511"
X-IronPort-AV: E=Sophos;i="5.93,292,1654585200"; 
   d="scan'208";a="279501511"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 19:46:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,292,1654585200"; 
   d="scan'208";a="675487606"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 05 Sep 2022 19:46:44 -0700
Date:   Tue, 6 Sep 2022 10:46:43 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 10/22] KVM: Drop kvm_count_lock and instead protect
 kvm_usage_count with kvm_lock
Message-ID: <20220906024643.ti66dw2y6m6jgch2@yy-desk-7060>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <20212af31729ba27e29c3856b78975c199b5365c.1662084396.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20212af31729ba27e29c3856b78975c199b5365c.1662084396.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 07:17:45PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Because kvm_count_lock unnecessarily complicates the KVM locking convention
> Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock for
> simplicity.
>
> Opportunistically add some comments on locking.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  Documentation/virt/kvm/locking.rst | 14 +++++-------
>  virt/kvm/kvm_main.c                | 34 ++++++++++++++++++++----------
>  2 files changed, 28 insertions(+), 20 deletions(-)
>
> diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
> index 845a561629f1..8957e32aa724 100644
> --- a/Documentation/virt/kvm/locking.rst
> +++ b/Documentation/virt/kvm/locking.rst
> @@ -216,15 +216,11 @@ time it will be set using the Dirty tracking mechanism described above.
>  :Type:		mutex
>  :Arch:		any
>  :Protects:	- vm_list
> -
> -``kvm_count_lock``
> -^^^^^^^^^^^^^^^^^^
> -
> -:Type:		raw_spinlock_t
> -:Arch:		any
> -:Protects:	- hardware virtualization enable/disable
> -:Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
> -		migration.
> +                - kvm_usage_count
> +                - hardware virtualization enable/disable
> +:Comment:	Use cpus_read_lock() for hardware virtualization enable/disable
> +                because hardware enabling/disabling must be atomic /wrt
> +                migration.  The lock order is cpus lock => kvm_lock.
>
>  ``kvm->mn_invalidate_lock``
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fc55447c4dba..082d5dbc8d7f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -100,7 +100,6 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
>   */
>
>  DEFINE_MUTEX(kvm_lock);
> -static DEFINE_RAW_SPINLOCK(kvm_count_lock);
>  LIST_HEAD(vm_list);
>
>  static cpumask_var_t cpus_hardware_enabled;
> @@ -4996,6 +4995,8 @@ static void hardware_enable_nolock(void *caller_name)
>  	int cpu = raw_smp_processor_id();
>  	int r;
>
> +	WARN_ON_ONCE(preemptible());

This looks incorrect, it may triggers everytime when online CPU.
Because patch 7 moved CPUHP_AP_KVM_STARTING *AFTER*
CPUHP_AP_ONLINE_IDLE as CPUHP_AP_KVM_ONLINE, then cpuhp_thread_fun()
runs the new CPUHP_AP_KVM_ONLINE in *non-atomic* context:

cpuhp_thread_fun(unsigned int cpu) {
...
	if (cpuhp_is_atomic_state(state)) {
		local_irq_disable();
		st->result = cpuhp_invoke_callback(cpu, state, bringup, st->node, &st->last);
		local_irq_enable();

		WARN_ON_ONCE(st->result);
	} else {
		st->result = cpuhp_invoke_callback(cpu, state, bringup, st->node, &st->last);
	}
...
}

static bool cpuhp_is_atomic_state(enum cpuhp_state state)
{
	return CPUHP_AP_IDLE_DEAD <= state && state < CPUHP_AP_ONLINE;
}

The hardware_enable_nolock() now is called in 2 cases:
1. in atomic context by on_each_cpu().
2. From non-atomic context by CPU hotplug thread.

so how about "WARN_ONCE(preemptible() && cpu_active(cpu))" ?

> +
>  	if (cpumask_test_cpu(cpu, cpus_hardware_enabled))
>  		return;
>
> @@ -5019,7 +5020,7 @@ static int kvm_online_cpu(unsigned int cpu)
>  	if (ret)
>  		return ret;
>
> -	raw_spin_lock(&kvm_count_lock);
> +	mutex_lock(&kvm_lock);
>  	/*
>  	 * Abort the CPU online process if hardware virtualization cannot
>  	 * be enabled. Otherwise running VMs would encounter unrecoverable
> @@ -5034,7 +5035,7 @@ static int kvm_online_cpu(unsigned int cpu)
>  			ret = -EIO;
>  		}
>  	}
> -	raw_spin_unlock(&kvm_count_lock);
> +	mutex_unlock(&kvm_lock);
>  	return ret;
>  }
>
> @@ -5042,6 +5043,8 @@ static void hardware_disable_nolock(void *junk)
>  {
>  	int cpu = raw_smp_processor_id();
>
> +	WARN_ON_ONCE(preemptible());

Ditto.

> +
>  	if (!cpumask_test_cpu(cpu, cpus_hardware_enabled))
>  		return;
>  	cpumask_clear_cpu(cpu, cpus_hardware_enabled);
> @@ -5050,10 +5053,10 @@ static void hardware_disable_nolock(void *junk)
>
>  static int kvm_offline_cpu(unsigned int cpu)
>  {
> -	raw_spin_lock(&kvm_count_lock);
> +	mutex_lock(&kvm_lock);
>  	if (kvm_usage_count)
>  		hardware_disable_nolock(NULL);
> -	raw_spin_unlock(&kvm_count_lock);
> +	mutex_unlock(&kvm_lock);
>  	return 0;
>  }
>
> @@ -5068,9 +5071,11 @@ static void hardware_disable_all_nolock(void)
>
>  static void hardware_disable_all(void)
>  {
> -	raw_spin_lock(&kvm_count_lock);
> +	cpus_read_lock();
> +	mutex_lock(&kvm_lock);
>  	hardware_disable_all_nolock();
> -	raw_spin_unlock(&kvm_count_lock);
> +	mutex_unlock(&kvm_lock);
> +	cpus_read_unlock();
>  }
>
>  static int hardware_enable_all(void)
> @@ -5088,7 +5093,7 @@ static int hardware_enable_all(void)
>  	 * Disable CPU hotplug to prevent this case from happening.
>  	 */
>  	cpus_read_lock();
> -	raw_spin_lock(&kvm_count_lock);
> +	mutex_lock(&kvm_lock);
>
>  	kvm_usage_count++;
>  	if (kvm_usage_count == 1) {
> @@ -5101,7 +5106,7 @@ static int hardware_enable_all(void)
>  		}
>  	}
>
> -	raw_spin_unlock(&kvm_count_lock);
> +	mutex_unlock(&kvm_lock);
>  	cpus_read_unlock();
>
>  	return r;
> @@ -5708,8 +5713,15 @@ static void kvm_init_debug(void)
>
>  static int kvm_suspend(void)
>  {
> -	if (kvm_usage_count)
> +	/*
> +	 * The caller ensures that CPU hotlug is disabled by
> +	 * cpu_hotplug_disable() and other CPUs are offlined.  No need for
> +	 * locking.
> +	 */
> +	if (kvm_usage_count) {
> +		lockdep_assert_not_held(&kvm_lock);
>  		hardware_disable_nolock(NULL);
> +	}
>  	return 0;
>  }
>
> @@ -5723,7 +5735,7 @@ static void kvm_resume(void)
>  		return; /* FIXME: disable KVM */
>
>  	if (kvm_usage_count) {
> -		lockdep_assert_not_held(&kvm_count_lock);
> +		lockdep_assert_not_held(&kvm_lock);
>  		hardware_enable_nolock((void *)__func__);
>  	}
>  }
> --
> 2.25.1
>
