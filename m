Return-Path: <kvm+bounces-30453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADB99BADFA
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:23:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3ED431C2146F
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1146E1AB505;
	Mon,  4 Nov 2024 08:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N29o0ux2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6920618BC0E;
	Mon,  4 Nov 2024 08:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730708605; cv=none; b=h5riMuwFDtsaWuB0hk0U3JNnx5ywMOraLjqmARvwfXrj3U5VxQZZ+G1YJSOZgjt5KdbVMFZd/1CftYwlM0U+3V5C2m/4TJ5wLTz3iryfArwNBac60bUaXpc6h6qI5Eg+gCv+9d3sR4Okl+kIM96lHVGAC+Kwp6/lf0j/lUznDvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730708605; c=relaxed/simple;
	bh=2EXNNiwtoQ6nf5tB5KTCBIc1YohxLwQ/VVy3SQ+EZ38=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ABGms0MULFvS8Xvh2hlo8MQIFs3cr3YSIL1VJpiarLVpjcRnmhti4OXrKIQBFXADLhaYPWVNJQ9OhEMRTEZ6blxG1FBdefAGCV1k1D3lZlerxCCt6Ac45bcz0L4DllItpscNoj+4A1l6HDTYd3xcFVy1Mlyj3K0HGDljoATpGKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N29o0ux2; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730708604; x=1762244604;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2EXNNiwtoQ6nf5tB5KTCBIc1YohxLwQ/VVy3SQ+EZ38=;
  b=N29o0ux2/U6xOH8whrL4ztbclixw1/q8X7VYtxZglTMFDZTXU6jdRSkA
   vjQ9+zhPk65kOy57BLl3vlfdd8293miZZ970nwDyohMX0MxszxWXveUQW
   hUchDYR9X1b4aRlMo8g9EmD2FRuWKXH0NUylPqPWeiH+W6+T9rn8VxmAk
   Kmw1V9nm3p3sJX8Rn1K2X88a93h/SqSFYVrL7w83vlqr8eXSYPu8gD7Ir
   W8wLlm5TROTKdj0BtEIFn8x1akjMR36T/6zNbozxqdUDoD9qZcu2J422g
   YIiB39piO8wh6EQ+lp2B7cxX68jT+dwKCTKvL8/wxdurYT+oOSX5vzZ6H
   w==;
X-CSE-ConnectionGUID: Ah4y+sv8SNGmkeZPlXwQcA==
X-CSE-MsgGUID: ZyM2c2GaSSOhHFl7VQZCfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="40940981"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="40940981"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 00:23:23 -0800
X-CSE-ConnectionGUID: bXOkro8zQuu/JjDDFzEymg==
X-CSE-MsgGUID: vX0P50diRiiq0X9nUK/H8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="83924235"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.16.81])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 00:23:21 -0800
Message-ID: <448c8367-9f54-4ab1-80c3-bb13c9ac4664@intel.com>
Date: Mon, 4 Nov 2024 10:23:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: VMX: Bury Intel PT virtualization (guest/host
 mode) behind CONFIG_BROKEN
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241101185031.1799556-1-seanjc@google.com>
 <20241101185031.1799556-2-seanjc@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20241101185031.1799556-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/11/24 20:50, Sean Christopherson wrote:
> Hide KVM's pt_mode module param behind CONFIG_BROKEN, i.e. disable support
> for virtualizing Intel PT via guest/host mode unless BROKEN=y.  There are
> myriad bugs in the implementation, some of which are fatal to the guest,
> and others which put the stability and health of the host at risk.
> 
> For guest fatalities, the most glaring issue is that KVM fails to ensure
> tracing is disabled, and *stays* disabled prior to VM-Enter, which is
> necessary as hardware disallows loading (the guest's) RTIT_CTL if tracing
> is enabled (enforced via a VMX consistency check).  Per the SDM:
> 
>   If the logical processor is operating with Intel PT enabled (if
>   IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the "load
>   IA32_RTIT_CTL" VM-entry control must be 0.
> 
> On the host side, KVM doesn't validate the guest CPUID configuration
> provided by userspace, and even worse, uses the guest configuration to
> decide what MSRs to save/load at VM-Enter and VM-Exit.  E.g. configuring
> guest CPUID to enumerate more address ranges than are supported in hardware
> will result in KVM trying to passthrough, save, and load non-existent MSRs,
> which generates a variety of WARNs, ToPA ERRORs in the host, a potential
> deadlock, etc.
> 
> Fixes: f99e3daf94ff ("KVM: x86: Add Intel PT virtualization work mode")
> Cc: stable@vger.kernel.org
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6ed801ffe33f..087504fb1589 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -217,9 +217,11 @@ module_param(ple_window_shrink, uint, 0444);
>  static unsigned int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
>  module_param(ple_window_max, uint, 0444);
>  
> -/* Default is SYSTEM mode, 1 for host-guest mode */
> +/* Default is SYSTEM mode, 1 for host-guest mode (which is BROKEN) */
>  int __read_mostly pt_mode = PT_MODE_SYSTEM;
> +#ifdef CONFIG_BROKEN
>  module_param(pt_mode, int, S_IRUGO);
> +#endif

Side effects are:
1. If pt_mode is passed via modprobe, there will be a warning in kernel messages:
	kvm_intel: unknown parameter 'pt_mode' ignored
2. The sysfs module parameter file pt_mode will be gone:
	# cat /sys/module/kvm_intel/parameters/pt_mode
	cat: /sys/module/kvm_intel/parameters/pt_mode: No such file or directory

Nevertheless:

Tested-by: Adrian Hunter <adrian.hunter@intel.com>

>  
>  struct x86_pmu_lbr __ro_after_init vmx_lbr_caps;
>  


