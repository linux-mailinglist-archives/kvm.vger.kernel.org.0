Return-Path: <kvm+bounces-7646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BD9F3844ED6
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:48:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F09CB2A54B
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 146EE5250;
	Thu,  1 Feb 2024 01:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zuyjmic0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2DA18C2A;
	Thu,  1 Feb 2024 01:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706752052; cv=none; b=pKnGF8ZHaSoaj4wA+4lFth2METzhU/GR0kNK3AZh89EzaVo5APWE4t0fXMcMduwFUEnDFebqYlBU8QCWn0AchquRa1VGjwOEwqusmwPWnWdTaCO/ht1Xy7CoVfBOYvzj2bz1Y68mYWfYsNOsvqSlUQ4xLmeFttWX3M0vv75Xlh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706752052; c=relaxed/simple;
	bh=rbtQozH6zuIut8NwGA7WjQjBXmMyEs616B8CjRDlPes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CymP1rRNlCOOwwBoNYYcGzpQOUqS2xbsg2WdyHvnfvqD3JO2oRPKyANFNtuQy4hIXBXPNGwznIfUUZkyl+Z4xmbo8FhVCMdNNDGw7Teqey5YUjwTwOATCijM9liYrmLF6K0TvWePUk85yG4jW2HUFXLxSHaLPRKJciXL02TPx2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zuyjmic0; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706752050; x=1738288050;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rbtQozH6zuIut8NwGA7WjQjBXmMyEs616B8CjRDlPes=;
  b=Zuyjmic0V63H82P5RNA3IfE7Gm9KjDD4v/oN4XBKiddypiJQKJ8xt5l3
   QFHFssJkbPHK8UTHDgo+rgN5RjJDVYh+UaUkLnPLxs2QFgyRvJQmW5j4J
   Enm6anHRx/kyqByEAuFV28k7ezeAbPm4/f2teSfbfH9wkS6xOGNpVanjM
   zn3pnySnwlh8OVM3grS2J8hS5Xa3PGYpikdPZu2DHy/wQcIRgtNOsdlHK
   8+zRnUsq5zpk5YqQVOlTgrA3NyFvcg9zaxXmy1IJJBQ7NdOJrswHYLKpg
   UPl50aaDZrDukkd1NWlTV/tW0nWCcL39YHjr0a08fg3dcDgNz2zFQcQNi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="17166427"
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="17166427"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 17:47:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="4243836"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.33.17]) ([10.93.33.17])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 17:47:18 -0800
Message-ID: <b579d39f-d963-47cc-81e3-a6e8d888dab8@intel.com>
Date: Thu, 1 Feb 2024 09:47:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 007/121] KVM: VMX: Reorder vmx initialization with kvm
 vendor initialization
Content-Language: en-US
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <411a0b38c1a6f420a88b51cabf16ee871d6ca80d.1705965634.git.isaku.yamahata@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <411a0b38c1a6f420a88b51cabf16ee871d6ca80d.1705965634.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/2024 7:52 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> To match vmx_exit cleanup.  Now vmx_init() is before kvm_x86_vendor_init(),
> vmx_init() can initialize loaded_vmcss_on_cpu.  Oppertunistically move it
> back into vmx_init().

It sort of does a revert of Patch 05. Though I still don't get the 
reason why we need Patch 05, why not move this patch before patch 06, 
then we can drop Patch 05 and of course the revert part of this patch?

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


