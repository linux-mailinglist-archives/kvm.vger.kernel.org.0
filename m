Return-Path: <kvm+bounces-7313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3698B83FF3D
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 08:50:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2374282346
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 07:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D793051C4A;
	Mon, 29 Jan 2024 07:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O/TQ23FN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4404251C2C;
	Mon, 29 Jan 2024 07:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706514614; cv=none; b=Aw/FTvrhw4z3UnqmVATzKsqQF02GUPuy0yFsHKA049y0iqLu7ZIVFYZ9PjsPxjM1elhSt8EwcV75LmSoGr55EAi4g3XZZCgaeIftCC2ugD7odRi3qAlnnl0XQ4KQOzeMzt40coD3I7snEBKq36MgMjicA32vHfiMK/5nXLmr/cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706514614; c=relaxed/simple;
	bh=8E9fzWhF/4hAclcZkGyOSv5khN2S6oOJKz86E4S1Cx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tiuZLI1q+mQ8G5lR5z7DXVUv85NllOiM8e3wHocEKzLoW1ug3ym7ja4dOgMs/VtkXioEWt+Pn579lyL4GnXeuIkVXpfGivsrC4QOAC6PQmeABNvl1QpqQy+t9t8nWwGQzXhrKFYoRyW97bDJhayg+Wu8iokG6OutHmNfIZTuF7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O/TQ23FN; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706514612; x=1738050612;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8E9fzWhF/4hAclcZkGyOSv5khN2S6oOJKz86E4S1Cx4=;
  b=O/TQ23FNFbNY57d6ag2HJixL50p1b+ZQ+UDLotiCYtz1wqS+9jqiwAD1
   PE1JtGj75wYbTl6a/QXXxrieWunLKoukNSYGRo5mV3TtHtletwwfnQk/Z
   RjreExzUFxZO26DMJ64ihs7Y5rl82MuXOUigxXCwnAQS+xXnAj6MU8WIj
   derLTIJAyhHBcG58EJfOOPaPcOM9gxCu3TyqdMY6sPZ145OBQbeDcb8tP
   sqWLws38jdW7DwiBmLyp8Db9YRg8wC8MJmcoJb2g4XAY3P1suI40l6sXP
   mcr9EHoqNcS1JNdoYIVupwjYs+x0St9KVpUlBCG47UijZlSwonjaKrOoK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="21406802"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="21406802"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 23:50:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="910971389"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="910971389"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga004.jf.intel.com with ESMTP; 28 Jan 2024 23:50:08 -0800
Date: Mon, 29 Jan 2024 15:50:07 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v18 005/121] KVM: x86/vmx: initialize loaded_vmcss_on_cpu
 in vmx_hardware_setup()
Message-ID: <20240129075007.kvlj6gykk6aom75s@yy-desk-7060>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <51c5466c541e1eddad928af602bd889721524d34.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51c5466c541e1eddad928af602bd889721524d34.1705965634.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Jan 22, 2024 at 03:52:41PM -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> vmx_hardware_disable() accesses loaded_vmcss_on_cpu via
> hardware_disable_all().  To allow hardware_enable/disable_all() before
> kvm_init(), initialize it in before kvm_x86_vendor_init() in vmx_init()
> so that tdx module initialization, hardware_setup method, can reference
> the variable.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v18:
> - Move the vmcss_on_cpu initialization from vmx_hardware_setup() to
>   early point of vmx_init() by Binbin
> ---
>  arch/x86/kvm/vmx/vmx.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 55597b3bdc55..77011799b1f4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8539,6 +8539,10 @@ static int __init vmx_init(void)
>  	 */
>  	hv_init_evmcs();
>
> +	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
> +	for_each_possible_cpu(cpu)
> +		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> +

The subject "KVM: x86/vmx: initialize loaded_vmcss_on_cpu in vmx_hardware_setup()"
should match the change here.

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

>  	r = kvm_x86_vendor_init(&vt_init_ops);
>  	if (r)
>  		return r;
> @@ -8554,11 +8558,8 @@ static int __init vmx_init(void)
>  	if (r)
>  		goto err_l1d_flush;
>
> -	for_each_possible_cpu(cpu) {
> -		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> -
> +	for_each_possible_cpu(cpu)
>  		pi_init_cpu(cpu);
> -	}
>
>  	cpu_emergency_register_virt_callback(vmx_emergency_disable);
>
> --
> 2.25.1
>
>

