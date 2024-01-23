Return-Path: <kvm+bounces-6717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AED0583861E
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 04:42:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 673A1288710
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 03:42:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1369F20E4;
	Tue, 23 Jan 2024 03:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MS8/nlpL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607581FA5;
	Tue, 23 Jan 2024 03:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705981329; cv=none; b=lloYq0+GbNV9V4pga0qdEvKI1mT87eFgdem2Z387uJh9w0ks6X9fmn+wvPQ2pzbSjcDcoeKyY4gWYdWgusGre89lLOhfP2BJlJL/9GZhZ4852RJ0R2Drpm2vQhrkf1v6P8C49OQJChl3eTecnyJ+ZswBq5He404XhwqwBDb4PZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705981329; c=relaxed/simple;
	bh=ZbYyPQ250XMcheI3heCNihkEYTt2USTXTqIHzWrYJQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BxZmfKc90ra4quTv8xA10EyIomN5O65Q4i516mlLLsrhtQE6d0JVwtDH+Cqjl5cDFuJf+fgojZ25l5rEPg74H+CjUYIq1s6E9YkdeUQIaOmSIV+GlK4it/4syTkxvSzVWwQR76pQCaeEhAjx+MRa7Xl60LdrM3suLa5GRY36clM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MS8/nlpL; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705981327; x=1737517327;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZbYyPQ250XMcheI3heCNihkEYTt2USTXTqIHzWrYJQA=;
  b=MS8/nlpLTqE1n6AZTK/lI2Ff6untbU3JnkBsq6vN/Ptd7/c4p9AMDZPR
   nqGNdAoxAmsU7HWdYPBSF2w+wxaBo2LX5Id319QgOoaPwRmk7GLWlXLX0
   jheLQYlPlVGsO3kmOcE3yqDTVlhfrJJL4ap3U6Wll/RHoKRdyKthFso1Z
   YU2bO6pFQdvPNPTg5h40VFE4ja+7IUm24Y4iprBSfthiCWWzNlpGseqph
   aD0kBtVnzcU5vckeiWqaboDla1LaWQ1sPe989c95XqizqwWlRC8yMNjPR
   KsJFSO7ECLrDbskii75SYXcNUio1P/pDFq7oslQlH8uujvgY3oh+ML2rk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="14920032"
X-IronPort-AV: E=Sophos;i="6.05,213,1701158400"; 
   d="scan'208";a="14920032"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 19:42:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,213,1701158400"; 
   d="scan'208";a="1404792"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.8.92]) ([10.93.8.92])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 19:42:03 -0800
Message-ID: <e2a27fa7-8458-4bb7-8d67-de82c1b2503b@linux.intel.com>
Date: Tue, 23 Jan 2024 11:42:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 007/121] KVM: VMX: Reorder vmx initialization with kvm
 vendor initialization
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <411a0b38c1a6f420a88b51cabf16ee871d6ca80d.1705965634.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <411a0b38c1a6f420a88b51cabf16ee871d6ca80d.1705965634.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:52 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> To match vmx_exit cleanup.
Do you mean vt_exit()?
Shouldn't vt_init() and vt_exit() be symmetric right from the beginning in
the refactor patch (006/121)?

And also, since the reorder of kvm_x86_vendor_init() and vmx_init() is going
to happen, can we just skip moving around the init of loaded_vmcss_on_cpu?


> Now vmx_init() is before kvm_x86_vendor_init(),
> vmx_init() can initialize loaded_vmcss_on_cpu.  Oppertunistically move it
> back into vmx_init().
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v18:
> - move the loaded_vmcss_on_cpu initialization to vmx_init().
> - fix error path of vt_init(). by Chao and Binbin
> ---
>   arch/x86/kvm/vmx/main.c    | 17 +++++++----------
>   arch/x86/kvm/vmx/vmx.c     |  6 ++++--
>   arch/x86/kvm/vmx/x86_ops.h |  2 --
>   3 files changed, 11 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 18cecf12c7c8..443db8ec5cd5 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -171,7 +171,7 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
>   static int __init vt_init(void)
>   {
>   	unsigned int vcpu_size, vcpu_align;
> -	int cpu, r;
> +	int r;
>   
>   	if (!kvm_is_vmx_supported())
>   		return -EOPNOTSUPP;
> @@ -182,18 +182,14 @@ static int __init vt_init(void)
>   	 */
>   	hv_init_evmcs();
>   
> -	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
> -	for_each_possible_cpu(cpu)
> -		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> -
> -	r = kvm_x86_vendor_init(&vt_init_ops);
> -	if (r)
> -		return r;
> -
>   	r = vmx_init();
>   	if (r)
>   		goto err_vmx_init;
>   
> +	r = kvm_x86_vendor_init(&vt_init_ops);
> +	if (r)
> +		goto err_vendor_init;
> +
>   	/*
>   	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
>   	 * exposed to userspace!
> @@ -207,9 +203,10 @@ static int __init vt_init(void)
>   	return 0;
>   
>   err_kvm_init:
> +	kvm_x86_vendor_exit();
> +err_vendor_init:
>   	vmx_exit();
>   err_vmx_init:
> -	kvm_x86_vendor_exit();
>   	return r;
>   }
>   module_init(vt_init);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8efb956591d5..3f4dad3acb13 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -477,7 +477,7 @@ DEFINE_PER_CPU(struct vmcs *, current_vmcs);
>    * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
>    * when a CPU is brought down, and we need to VMCLEAR all VMCSs loaded on it.
>    */
> -DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
> +static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
>   
>   static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
>   static DEFINE_SPINLOCK(vmx_vpid_lock);
> @@ -8528,8 +8528,10 @@ int __init vmx_init(void)
>   	if (r)
>   		return r;
>   
> -	for_each_possible_cpu(cpu)
> +	for_each_possible_cpu(cpu) {
> +		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
>   		pi_init_cpu(cpu);
> +	}
>   
>   	cpu_emergency_register_virt_callback(vmx_emergency_disable);
>   
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index b936388853ab..bca2d27b3dfd 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -14,8 +14,6 @@ static inline __init void hv_init_evmcs(void) {}
>   static inline void hv_reset_evmcs(void) {}
>   #endif /* IS_ENABLED(CONFIG_HYPERV) */
>   
> -DECLARE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
> -
>   bool kvm_is_vmx_supported(void);
>   int __init vmx_init(void);
>   void vmx_exit(void);


