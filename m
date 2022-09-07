Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD03D5AFC0E
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 07:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiIGF5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 01:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIGF5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 01:57:05 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9623F5AA;
        Tue,  6 Sep 2022 22:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662530224; x=1694066224;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FQwr62FuVekKIlqBYg9De+gonUS/CJ7o29zGWn8LlDY=;
  b=UzMQxKpIsdYgl8Y5Ink4u6fAM850/V7vD3o8tJdMQnb623HV1Cudalq0
   nlO9o19JmjuYH12MRBGtma28MVjBGItTHO58rwER+3sZFUnyquubfxydJ
   +HCvQV+/VIZyfrWL1OMNO/m4PrXTKSqsUrRvIuBKqk5qtRF1PaANXyUqM
   Sngl4mRDHAp2oztv93jfmOFova0my/GHQOJA/JA6XNsE4Pcx4zDqAWhl2
   DfwxvsslJJC3Dg2BUWS5Q2INjs2oR6Vcq439gw1JBG+77hwuGR2pE5yLt
   p6TDppT9Jr1dnNe5G2X/+BwG2vp46+4MnfdFdMtwHOm3sXq9jzct+FsSv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="322970320"
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="scan'208";a="322970320"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 22:57:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="scan'208";a="644474482"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga008.jf.intel.com with ESMTP; 06 Sep 2022 22:56:58 -0700
Date:   Wed, 7 Sep 2022 13:56:57 +0800
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
Subject: Re: [PATCH v3 16/22] KVM: kvm_arch.c: Remove a global variable,
 hardware_enable_failed
Message-ID: <20220907055657.y7dcseig2qvjue6t@yy-desk-7060>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <91715ddc16f001bf2b76f68b57ebd59092b40591.1662084396.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91715ddc16f001bf2b76f68b57ebd59092b40591.1662084396.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 07:17:51PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> A global variable hardware_enable_failed in kvm_arch.c is used only by
> kvm_arch_add_vm() and hardware_enable().  It doesn't have to be a global
> variable.  Make it function local.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  virt/kvm/kvm_arch.c | 49 +++++++++++++++++++++------------------------
>  1 file changed, 23 insertions(+), 26 deletions(-)
>
> diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
> index de39d0127584..f7dcde842eb5 100644
> --- a/virt/kvm/kvm_arch.c
> +++ b/virt/kvm/kvm_arch.c
> @@ -13,14 +13,13 @@
>  #include <linux/kvm_host.h>
>
>  static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
> -static atomic_t hardware_enable_failed;
>
>  __weak int kvm_arch_post_init_vm(struct kvm *kvm)
>  {
>  	return 0;
>  }
>
> -static void hardware_enable(void *caller_name)
> +static int __hardware_enable(void *caller_name)
>  {
>  	int cpu = raw_smp_processor_id();
>  	int r;
> @@ -28,18 +27,22 @@ static void hardware_enable(void *caller_name)
>  	WARN_ON_ONCE(preemptible());
>
>  	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
> -		return;
> -
> -	cpumask_set_cpu(cpu, &cpus_hardware_enabled);
> -
> +		return 0;
>  	r = kvm_arch_hardware_enable();
> -
> -	if (r) {
> -		cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
> -		atomic_inc(&hardware_enable_failed);
> +	if (r)
>  		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
>  			cpu, (const char *)caller_name);
> -	}
> +	else
> +		cpumask_set_cpu(cpu, &cpus_hardware_enabled);
> +	return r;
> +}
> +
> +static void hardware_enable(void *arg)
> +{
> +	atomic_t *failed = arg;
> +
> +	if (__hardware_enable((void *)__func__))
> +		atomic_inc(failed);
>  }

A side effect: The actual caller_name information introduced in Patch
3 for hardware_enable() is lost. I tend to keep the information, but
depends on you and other guys. :-)

>
>  static void hardware_disable(void *junk)
> @@ -65,15 +68,16 @@ __weak void kvm_arch_pre_hardware_unsetup(void)
>   */
>  __weak int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
>  {
> +	atomic_t failed;
>  	int r = 0;
>
>  	if (usage_count != 1)
>  		return 0;
>
> -	atomic_set(&hardware_enable_failed, 0);
> -	on_each_cpu(hardware_enable, (void *)__func__, 1);
> +	atomic_set(&failed, 0);
> +	on_each_cpu(hardware_enable, &failed, 1);
>
> -	if (atomic_read(&hardware_enable_failed)) {
> +	if (atomic_read(&failed)) {
>  		r = -EBUSY;
>  		goto err;
>  	}
> @@ -96,27 +100,20 @@ __weak int kvm_arch_del_vm(int usage_count)
>
>  __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
>  {
> -	int ret = 0;
> +	int ret;
>
>  	ret = kvm_arch_check_processor_compat();
>  	if (ret)
>  		return ret;
>
> +	if (!usage_count)
> +		return 0;
>  	/*
>  	 * Abort the CPU online process if hardware virtualization cannot
>  	 * be enabled. Otherwise running VMs would encounter unrecoverable
>  	 * errors when scheduled to this CPU.
>  	 */
> -	if (usage_count) {
> -		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
> -
> -		hardware_enable((void *)__func__);
> -		if (atomic_read(&hardware_enable_failed)) {
> -			atomic_set(&hardware_enable_failed, 0);
> -			ret = -EIO;
> -		}
> -	}
> -	return ret;
> +	return __hardware_enable((void *)__func__);
>  }
>
>  __weak int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
> @@ -149,5 +146,5 @@ __weak void kvm_arch_resume(int usage_count)
>  		return; /* FIXME: disable KVM */
>
>  	if (usage_count)
> -		hardware_enable((void *)__func__);
> +		(void)__hardware_enable((void *)__func__);
>  }
> --
> 2.25.1
>
