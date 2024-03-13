Return-Path: <kvm+bounces-11746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A489587AA67
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 16:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB4431C227AE
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 15:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB3A47A79;
	Wed, 13 Mar 2024 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XGVxzUqE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1359147A52;
	Wed, 13 Mar 2024 15:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710343819; cv=none; b=iJctAn97m99WGnZFczDsElljdVpzUkZNG/TVUq99i47fiASRCtQER4MQWIpdtANTpRKr2dQekuycoNIMVWq4+pJef1mHjARgjyaYw87xnyojvvco6KDiLGzuLG6CcQuNfI03886/gpR3fQmJAKQqtQAfvQL0ZMvNYQZCjN90Hz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710343819; c=relaxed/simple;
	bh=6YkpdduqF4HnEdxpbqFhxmHLrelbL/HBKCE3WIC3SQE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iGiMVzgr+quc+YyY4WH3P0P+PqNnY6fYHgtEXWmqaeohChPoMnl+KQIUPmE9lL68+TpGNS6WSsux4++Fnql/i18t78c4iK2i2J9Pnu0UJE+t4eU5YO1LUiF0actSaEgW2+MEd0NdXQA8PwFw7+lFNX3j920sqQXa2TTfZG7b8Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XGVxzUqE; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710343818; x=1741879818;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6YkpdduqF4HnEdxpbqFhxmHLrelbL/HBKCE3WIC3SQE=;
  b=XGVxzUqE/ZMTl+vm4Eqxr0yqDFyC2T12AmD9mCLJYdJr84TIMHMRdwZg
   wxx3B3kckp1De890W19mumDadkJVcSCiSboNUJ/juE7HuA7tjxbD5KB72
   ojv79Xm2WPzh9oaT6BdwQq/O3pQIJP8nHz9xVVMSOh8fYI4Sh3KA1dLrf
   GN/pbSC/gdgcg46+cAjUjeQTK+gutC5dZfR5rw11nFIxpOMqnzzjidYeb
   Ms7aJgBbi4R6QXKsHte6pK/o78sQHrPLlh2Vvef5wVYu0SMnLcabmooR3
   D6agQN+ML5gMKZPIkgujpWNvvZgNiFrGeXdXJNwMKQf33vX+rona0/Gri
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="27595144"
X-IronPort-AV: E=Sophos;i="6.07,122,1708416000"; 
   d="scan'208";a="27595144"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 08:30:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,122,1708416000"; 
   d="scan'208";a="12532232"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 08:30:14 -0700
Message-ID: <c6279239-fb9c-41ca-a628-c0dd1e8c08a3@linux.intel.com>
Date: Wed, 13 Mar 2024 23:30:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 021/130] KVM: x86/vmx: initialize loaded_vmcss_on_cpu
 in vmx_init()
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Yuan Yao <yuan.yao@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <c1b7f0e5c2476f9f565acda5c1e746b8d181499b.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <c1b7f0e5c2476f9f565acda5c1e746b8d181499b.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> vmx_hardware_disable() accesses loaded_vmcss_on_cpu via
> hardware_disable_all().  To allow hardware_enable/disable_all() before
> kvm_init(), initialize it in before kvm_x86_vendor_init() in vmx_init()
> so that tdx module initialization, hardware_setup method, can reference
> the variable.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Yuan Yao <yuan.yao@intel.com>

The shortlog should be this?
KVM: VMX: Initialize loaded_vmcss_on_cpu in vmx_init()

Others,
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

>
> ---
> v19:
> - Fix the subject to match the patch by Yuan
>
> v18:
> - Move the vmcss_on_cpu initialization from vmx_hardware_setup() to
>    early point of vmx_init() by Binbin
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 434f5aaef030..8af0668e4dca 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8539,6 +8539,10 @@ static int __init vmx_init(void)
>   	 */
>   	hv_init_evmcs();
>   
> +	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
> +	for_each_possible_cpu(cpu)
> +		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> +
>   	r = kvm_x86_vendor_init(&vt_init_ops);
>   	if (r)
>   		return r;
> @@ -8554,11 +8558,8 @@ static int __init vmx_init(void)
>   	if (r)
>   		goto err_l1d_flush;
>   
> -	for_each_possible_cpu(cpu) {
> -		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> -
> +	for_each_possible_cpu(cpu)
>   		pi_init_cpu(cpu);
> -	}
>   
>   	cpu_emergency_register_virt_callback(vmx_emergency_disable);
>   


