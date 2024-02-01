Return-Path: <kvm+bounces-7687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E796845425
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 10:37:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B061B1C240AA
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D9215DBBE;
	Thu,  1 Feb 2024 09:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DewoGTbu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB24615B11E;
	Thu,  1 Feb 2024 09:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706780093; cv=none; b=W0wB/dXG85nNL9DYPh7l/y8kGi7ihgH0mt9zPJFmJLXZUj1yhVwFSzqCNRrApuymrirrIV3iS2WMAlqtyX668gKeP13Djus2rVZ8VjHzQK+eQslHf2s5s2S0eTuwGuFcVLEL+cTxO8t6c1K3e0lxRfvB6jOuTPLmRehE/lSS4PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706780093; c=relaxed/simple;
	bh=+P6w0YvtzKMvUIUz9U/twvIpgQmJXyPxrQLHzAu4hmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cv/wYe98unILzdosYBmykEA0Unrrc0qpl+6xChp4ZDwEHyD1B9BUm3z9E8yxtDvQF8jAMZuL9B7qYnD/lAKcePM56U7tjWG/DRa07534tiLncWqsY9Gib91rAs4m7q6QUJvrfABr4GsMDwaTMgR9BI88CFAS0u7nPWQWgQtYoxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DewoGTbu; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706780091; x=1738316091;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+P6w0YvtzKMvUIUz9U/twvIpgQmJXyPxrQLHzAu4hmA=;
  b=DewoGTbuRhyIBJ/OIsvvbndhavy8m8Ir8Sh36ygNtY+JFneHAtXY0dwQ
   6cNIf0gyIMDKf1omP/N96eRe0SULbCNhyiieQVJbZdPQbcjo3pyFbPd8f
   8i3xaxvdHcE53+s9HsgXdn2dVX0EzUPRoacLr9WuJSPyzl7WZXsgXaWtr
   V1c7tbtfBGllGGVsE5bkf0ap/g2AYZEy1xRnyqNTZhK0do35Ccwvap0QV
   j9sSRsEG+Zws23em/5XUQwtLzVcxqkvPutOsohIeLkpQGIrrrcgKQGMnn
   svtZF3mhmsSUriqcD3u2T/9SN2AMEdrZl5TwQ5NLHfhvxgaMp/hgY1vM7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="3717225"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="3717225"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 01:34:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="30824100"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.33.17]) ([10.93.33.17])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 01:34:47 -0800
Message-ID: <413fd812-a6e6-4aff-860a-fd8cf4654157@intel.com>
Date: Thu, 1 Feb 2024 17:34:44 +0800
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

we cannot simply change the calling order of vmx_init() and 
kvm_x86_vendor_init(). There is dependency between them.

e.g.,

kvm_x86_vendor_init()
   -> ops->hardware_setup()
	-> vmx_hardware_setup()

will update 'enable_ept' based on hardware capability (e.g., if the 
hardware support EPT or not), while 'enable_ept' is used in vmx_init().



