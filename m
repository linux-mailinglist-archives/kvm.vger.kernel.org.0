Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709BA5ADCDE
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 03:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbiIFBZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 21:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIFBZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 21:25:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE55C29CAF;
        Mon,  5 Sep 2022 18:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662427509; x=1693963509;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cVHRxaL1mvSavkgkLzGDu9tM6+eok01CLNUxC7qyXT4=;
  b=J5MByojh4JpPLmfZYIQVgv64ryfbBCaLlIFeRUgdRn9ORsyaIMBhVn/D
   v2LUo80X+IGyQyZi19FryN+fkejp+meCoGYmiQcqL+g2W7JnIWYkWAqnv
   1u+WKq+iz7NUYcxPRQD2MJ2Lp6wE8+FDZ9wT8MATupulhSCkEldhO3A8Q
   u6S6Og/y5MKtqkM/DBpW2qJimWwOxKn3aRjdu2d6OAEjQkEqByyhyW4AB
   NWX5I2Y6gVOxhK1rKVryFpppKa7nfN4/Lu4GC2m9vYBn3DGzNz5QXl+ds
   gjrapfnw5HhAf4Es4U5ml5reZOd/JzbDv6szRtL2YuzTOurUbBtK/jgZB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="295211035"
X-IronPort-AV: E=Sophos;i="5.93,292,1654585200"; 
   d="scan'208";a="295211035"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 18:25:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,292,1654585200"; 
   d="scan'208";a="591073184"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga006.jf.intel.com with ESMTP; 05 Sep 2022 18:25:01 -0700
Date:   Tue, 6 Sep 2022 09:25:00 +0800
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
Subject: Re: [PATCH v3 08/22] KVM: Do compatibility checks on hotplugged CPUs
Message-ID: <20220906012500.4uah2cmyeghry7wv@yy-desk-7060>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <6b710c8b8e53845653ce012d5d2e15ada767a8fa.1662084396.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b710c8b8e53845653ce012d5d2e15ada767a8fa.1662084396.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 07:17:43PM -0700, isaku.yamahata@intel.com wrote:
> From: Chao Gao <chao.gao@intel.com>
>
> At init time, KVM does compatibility checks to ensure that all online
> CPUs support hardware virtualization and a common set of features. But
> KVM uses hotplugged CPUs without such compatibility checks. On Intel
> CPUs, this leads to #GP if the hotplugged CPU doesn't support VMX or
> vmentry failure if the hotplugged CPU doesn't meet minimal feature
> requirements.
>
> Do compatibility checks when onlining a CPU and abort the online process
> if the hotplugged CPU is incompatible with online CPUs.
>
> CPU hotplug is disabled during hardware_enable_all() to prevent the corner
> case as shown below. A hotplugged CPU marks itself online in
> cpu_online_mask (1) and enables interrupt (2) before invoking callbacks
> registered in ONLINE section (3). So, if hardware_enable_all() is invoked
> on another CPU right after (2), then on_each_cpu() in hardware_enable_all()
> invokes hardware_enable_nolock() on the hotplugged CPU before
> kvm_online_cpu() is called. This makes the CPU escape from compatibility
> checks, which is risky.
>
> 	start_secondary { ...
> 		set_cpu_online(smp_processor_id(), true); <- 1
> 		...
> 		local_irq_enable();  <- 2
> 		...
> 		cpu_startup_entry(CPUHP_AP_ONLINE_IDLE); <- 3
> 	}
>
> Keep compatibility checks at KVM init time. It can help to find
> incompatibility issues earlier and refuse to load arch KVM module
> (e.g., kvm-intel).
>
> Loosen the WARN_ON in kvm_arch_check_processor_compat so that it
> can be invoked from KVM's CPU hotplug callback (i.e., kvm_online_cpu).
>
> Opportunistically, add a pr_err() for setup_vmcs_config() path in
> vmx_check_processor_compatibility() so that each possible error path has
> its own error message. Convert printk(KERN_ERR ... to pr_err to please
> checkpatch.pl
>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Link: https://lore.kernel.org/r/20220216031528.92558-7-chao.gao@intel.com
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

>  arch/x86/kvm/vmx/vmx.c | 10 ++++++----
>  arch/x86/kvm/x86.c     | 11 +++++++++--
>  virt/kvm/kvm_main.c    | 18 +++++++++++++++++-
>  3 files changed, 32 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3cf7f18a4115..2a1ab6495299 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7421,20 +7421,22 @@ static int vmx_check_processor_compatibility(void)
>  {
>  	struct vmcs_config vmcs_conf;
>  	struct vmx_capability vmx_cap;
> +	int cpu = smp_processor_id();
>
>  	if (!this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
>  	    !this_cpu_has(X86_FEATURE_VMX)) {
> -		pr_err("kvm: VMX is disabled on CPU %d\n", smp_processor_id());
> +		pr_err("kvm: VMX is disabled on CPU %d\n", cpu);
>  		return -EIO;
>  	}
>
> -	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
> +	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0) {
> +		pr_err("kvm: failed to setup vmcs config on CPU %d\n", cpu);
>  		return -EIO;
> +	}
>  	if (nested)
>  		nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept);
>  	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
> -		printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
> -				smp_processor_id());
> +		pr_err("kvm: CPU %d feature inconsistency!\n", cpu);
>  		return -EIO;
>  	}
>  	return 0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 53c8ee677f16..68def7ca224a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12000,9 +12000,16 @@ void kvm_arch_hardware_unsetup(void)
>
>  int kvm_arch_check_processor_compat(void)
>  {
> -	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> +	int cpu = smp_processor_id();
> +	struct cpuinfo_x86 *c = &cpu_data(cpu);
>
> -	WARN_ON(!irqs_disabled());
> +	/*
> +	 * Compatibility checks are done when loading KVM or in KVM's CPU
> +	 * hotplug callback. It ensures all online CPUs are compatible to run
> +	 * vCPUs. For other cases, compatibility checks are unnecessary or
> +	 * even problematic. Try to detect improper usages here.
> +	 */
> +	WARN_ON(!irqs_disabled() && cpu_active(cpu));
>
>  	if (__cr4_reserved_bits(cpu_has, c) !=
>  	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index db1303e2abc9..0ac00c711384 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5013,7 +5013,11 @@ static void hardware_enable_nolock(void *caller_name)
>
>  static int kvm_online_cpu(unsigned int cpu)
>  {
> -	int ret = 0;
> +	int ret;
> +
> +	ret = kvm_arch_check_processor_compat();
> +	if (ret)
> +		return ret;
>
>  	raw_spin_lock(&kvm_count_lock);
>  	/*
> @@ -5073,6 +5077,17 @@ static int hardware_enable_all(void)
>  {
>  	int r = 0;
>
> +	/*
> +	 * During onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
> +	 * is called. on_each_cpu() between them includes the CPU. As a result,
> +	 * hardware_enable_nolock() may get invoked before kvm_online_cpu().
> +	 * This would enable hardware virtualization on that cpu without
> +	 * compatibility checks, which can potentially crash system or break
> +	 * running VMs.
> +	 *
> +	 * Disable CPU hotplug to prevent this case from happening.
> +	 */
> +	cpus_read_lock();
>  	raw_spin_lock(&kvm_count_lock);
>
>  	kvm_usage_count++;
> @@ -5087,6 +5102,7 @@ static int hardware_enable_all(void)
>  	}
>
>  	raw_spin_unlock(&kvm_count_lock);
> +	cpus_read_unlock();
>
>  	return r;
>  }
> --
> 2.25.1
>
