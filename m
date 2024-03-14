Return-Path: <kvm+bounces-11775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B5DDD87B64B
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 03:06:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB5B81F2230C
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 02:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4819441;
	Thu, 14 Mar 2024 02:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LOZ237Ag"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA1753A0;
	Thu, 14 Mar 2024 02:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710381944; cv=none; b=LEK1sJDuToqcXwrAj60VadsOMK21kft/QL5hQeLXZ2X6Qi40eErQi6DPD4VZi9YthDUQ8oXTNz8/Xku7MLbif6NXDaRa8Jh1OxRUQqY+NAMqK2Vk+Qru5+UmtKWEJTrvJ7G9E5ub8T6gOf98JrO2I6BzETTsY6v+JvVZJ1yZ7aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710381944; c=relaxed/simple;
	bh=cRptNJgw5yHuUq4Slch3zYQUVuz7tKOCUXa79hcLgxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jM1k1DRh0yyakW3eJx0AKLFT7lECetB8LGyx9hz/F9e1p7+uPFvhyc2LdMRvZK1id5tw7DCfLrRSx/Rzs9dhGmQWISW1Dnjp2cGG2xF31I7LzLRxReN0fqs5bjp1FBHJaSLCD01z8VN6d+EwD8XvW6h9d9mOC7zsJaxun89iD6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LOZ237Ag; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710381942; x=1741917942;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cRptNJgw5yHuUq4Slch3zYQUVuz7tKOCUXa79hcLgxs=;
  b=LOZ237Agw0QJltj4M9/yVD2eoSRyhkzsmbTv9PsMPT9gEL7cQpirbvFa
   acbxe+++7uVg0Pd1ED5WUGOrtOESByeibTT8U7UqbfzT+kYhZFENmNfAk
   2g36ZhI5mvHOdhngRIS+h4kynny/AiZ+4kHh5JGzxIAYJTL1yHcWvNJ7r
   OOOGnw9LMo4Cj2l9hVJwt4jLiLCgIcXDR8C9p/+0fsjbyt3oLjQvP+IaE
   RnMGWGWyPhJRI4GHBUymMH1OWmBBFyE03pKmuurL/+ceGrIXboqTAfagu
   2nNhkViqYKfWuZWYbc45TVAgdjtNMWAZYt1DCkKXZZAt2Jvv61FxLD/ut
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="5029642"
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="5029642"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 19:05:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="12583862"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 19:05:38 -0700
Message-ID: <f5da22e3-55fd-4e8b-8112-ccf1468012c8@linux.intel.com>
Date: Thu, 14 Mar 2024 10:05:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX requires several initialization steps for KVM to create guest TDs.
> Detect CPU feature, enable VMX (TDX is based on VMX) on all online CPUs,
> detect the TDX module availability, initialize it and disable VMX.
>
> To enable/disable VMX on all online CPUs, utilize
> vmx_hardware_enable/disable().  The method also initializes each CPU for
> TDX.  TDX requires calling a TDX initialization function per logical
> processor (LP) before the LP uses TDX.  When the CPU is becoming online,
> call the TDX LP initialization API.  If it fails to initialize TDX, refuse
> CPU online for simplicity instead of TDX avoiding the failed LP.
>
> There are several options on when to initialize the TDX module.  A.) kernel
> module loading time, B.) the first guest TD creation time.  A.) was chosen.
> With B.), a user may hit an error of the TDX initialization when trying to
> create the first guest TD.  The machine that fails to initialize the TDX
> module can't boot any guest TD further.  Such failure is undesirable and a
> surprise because the user expects that the machine can accommodate guest
> TD, but not.  So A.) is better than B.).
>
> Introduce a module parameter, kvm_intel.tdx, to explicitly enable TDX KVM
> support.  It's off by default to keep the same behavior for those who don't
> use TDX.  Implement hardware_setup method to detect TDX feature of CPU and
> initialize TDX module.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v19:
> - fixed vt_hardware_enable() to use vmx_hardware_enable()
> - renamed vmx_tdx_enabled => tdx_enabled
> - renamed vmx_tdx_on() => tdx_on()
>
> v18:
> - Added comment in vt_hardware_enable() by Binbin.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/Makefile      |  1 +
>   arch/x86/kvm/vmx/main.c    | 19 ++++++++-
>   arch/x86/kvm/vmx/tdx.c     | 84 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h |  6 +++
>   4 files changed, 109 insertions(+), 1 deletion(-)
>   create mode 100644 arch/x86/kvm/vmx/tdx.c
>
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 274df24b647f..5b85ef84b2e9 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -24,6 +24,7 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>   
>   kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
>   kvm-intel-$(CONFIG_KVM_HYPERV)	+= vmx/hyperv.o vmx/hyperv_evmcs.o
> +kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
>   
>   kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
>   			   svm/sev.o
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 18cecf12c7c8..18aef6e23aab 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -6,6 +6,22 @@
>   #include "nested.h"
>   #include "pmu.h"
>   
> +static bool enable_tdx __ro_after_init;
> +module_param_named(tdx, enable_tdx, bool, 0444);
> +
> +static __init int vt_hardware_setup(void)
> +{
> +	int ret;
> +
> +	ret = vmx_hardware_setup();
> +	if (ret)
> +		return ret;
> +
> +	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> +
> +	return 0;
> +}
> +
>   #define VMX_REQUIRED_APICV_INHIBITS				\
>   	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
>   	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
> @@ -22,6 +38,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   
>   	.hardware_unsetup = vmx_hardware_unsetup,
>   
> +	/* TDX cpu enablement is done by tdx_hardware_setup(). */

How about if there are some LPs that are offline.
In tdx_hardware_setup(), only online LPs are initialed for TDX, right?
Then when an offline LP becoming online, it doesn't have a chance to call
tdx_cpu_enable()?

>   	.hardware_enable = vmx_hardware_enable,
>   	.hardware_disable = vmx_hardware_disable,
>   	.has_emulated_msr = vmx_has_emulated_msr,
> @@ -161,7 +178,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   };
>   
>   struct kvm_x86_init_ops vt_init_ops __initdata = {
> -	.hardware_setup = vmx_hardware_setup,
> +	.hardware_setup = vt_hardware_setup,
>   	.handle_intel_pt_intr = NULL,
>   
>   	.runtime_ops = &vt_x86_ops,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> new file mode 100644
> index 000000000000..43c504fb4fed
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -0,0 +1,84 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/cpu.h>
> +
> +#include <asm/tdx.h>
> +
> +#include "capabilities.h"
> +#include "x86_ops.h"
> +#include "x86.h"
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +static int __init tdx_module_setup(void)
> +{
> +	int ret;
> +
> +	ret = tdx_enable();
> +	if (ret) {
> +		pr_info("Failed to initialize TDX module.\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +struct tdx_enabled {
> +	cpumask_var_t enabled;
> +	atomic_t err;
> +};
> +
> +static void __init tdx_on(void *_enable)
> +{
> +	struct tdx_enabled *enable = _enable;
> +	int r;
> +
> +	r = vmx_hardware_enable();
> +	if (!r) {
> +		cpumask_set_cpu(smp_processor_id(), enable->enabled);
> +		r = tdx_cpu_enable();
> +	}
> +	if (r)
> +		atomic_set(&enable->err, r);
> +}
> +
> +static void __init vmx_off(void *_enabled)
> +{
> +	cpumask_var_t *enabled = (cpumask_var_t *)_enabled;
> +
> +	if (cpumask_test_cpu(smp_processor_id(), *enabled))
> +		vmx_hardware_disable();
> +}
> +
> +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> +{
> +	struct tdx_enabled enable = {
> +		.err = ATOMIC_INIT(0),
> +	};
> +	int r = 0;
> +
> +	if (!enable_ept) {
> +		pr_warn("Cannot enable TDX with EPT disabled\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!zalloc_cpumask_var(&enable.enabled, GFP_KERNEL)) {
> +		r = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/* tdx_enable() in tdx_module_setup() requires cpus lock. */
> +	cpus_read_lock();
> +	on_each_cpu(tdx_on, &enable, true); /* TDX requires vmxon. */
> +	r = atomic_read(&enable.err);
> +	if (!r)
> +		r = tdx_module_setup();
> +	else
> +		r = -EIO;
> +	on_each_cpu(vmx_off, &enable.enabled, true);
> +	cpus_read_unlock();
> +	free_cpumask_var(enable.enabled);
> +
> +out:
> +	return r;
> +}
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index b936388853ab..346289a2a01c 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -135,4 +135,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
>   #endif
>   void vmx_setup_mce(struct kvm_vcpu *vcpu);
>   
> +#ifdef CONFIG_INTEL_TDX_HOST
> +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> +#else
> +static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
> +#endif
> +
>   #endif /* __KVM_X86_VMX_X86_OPS_H */


