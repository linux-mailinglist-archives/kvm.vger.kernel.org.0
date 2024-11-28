Return-Path: <kvm+bounces-32713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DDF99DB1D1
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 04:23:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0644816736E
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 03:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C6612F399;
	Thu, 28 Nov 2024 03:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fb8bjrYw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5D3433B1;
	Thu, 28 Nov 2024 03:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732764186; cv=none; b=ZntChIVAblpGb8avzqrYQvX0/0KzU9awHrEVwWHKjeOV6xWbARzOTc8CqewI2FojMy7tX2Bxx1au3YpM+ECRjrweSMKS8noANHB6OHQ4cdMJWDt1sjKO6B93o+N2n3jy9uQUPQKhYiCWB+cWyV6VLy4YOOICmAkZVa958LS64fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732764186; c=relaxed/simple;
	bh=fSHT19oGrWGL3EJD3BfhBB9vjecsxVX7dC/h5Hx7i8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iMbQO+0I9FSwqU2ZVLsMbu6TM/a9khqj3dZV7Xnplu+6gX6+e7EzJjVa7X2LM4mAywy0wj+jKRgqpG/sS0tsLqqhXZl3BU1c4csIzAtkSffoWitd/B56vqBNCmy4Cr2pmeMIC5UX1ZatzDpapAii8gJY4Mc+A8xcfWfOUeC91BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fb8bjrYw; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732764184; x=1764300184;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fSHT19oGrWGL3EJD3BfhBB9vjecsxVX7dC/h5Hx7i8A=;
  b=Fb8bjrYwIgUh605yrE8id1wDf3aLJy+wusbBKIDnP8dbwdhfQTdOhemS
   vIEQTinfno+UblBIQKpb/t03Bz//LyzTaMiLLVLWRfuQeiXKTV4rosAt4
   2m3TLLy3OttBGYKArrvaNenMc4P/BrICbE0X98lNhPdJ0aw0dB1tMHvfG
   rfSkWCV1+snJ5/XScMcgTyigjcbZBay9mcWmjs2OvADa9wtC3kXpczVr7
   Vj1K65kLl/kmkrkmWEHNDeCU4V4paepYV+MU3mtog7Rpjk9TFBuy3eK0q
   i2Azi4dw9NBuKkH89TjtHdiPZ95uqWcNfSbk/oPLUWMSgIqe3piP6lkn1
   g==;
X-CSE-ConnectionGUID: iEwZELPxQwqSv8NIXa4gXw==
X-CSE-MsgGUID: VxfJiSATTQqEk+9XbxTJ3w==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="43651723"
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="43651723"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 19:23:03 -0800
X-CSE-ConnectionGUID: eJ2JsRbwQx+H5Ke9VNTu5A==
X-CSE-MsgGUID: CxGZbfTRRQ+NI/GLR60NCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="97069239"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 19:23:01 -0800
Message-ID: <2eaca3cd-ab33-412e-9603-ce7a5b09f5f2@intel.com>
Date: Thu, 28 Nov 2024 11:22:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] KVM: x86: Play nice with protected guests in
 complete_hypercall_exit()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu
 <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 Kai Huang <kai.huang@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-2-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241128004344.4072099-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/28/2024 8:43 AM, Sean Christopherson wrote:
> Use is_64_bit_hypercall() instead of is_64_bit_mode() to detect a 64-bit
> hypercall when completing said hypercall.  For guests with protected state,
> e.g. SEV-ES and SEV-SNP, KVM must assume the hypercall was made in 64-bit
> mode as the vCPU state needed to detect 64-bit mode is unavailable.
> 
> Hacking the sev_smoke_test selftest to generate a KVM_HC_MAP_GPA_RANGE
> hypercall via VMGEXIT trips the WARN:
> 
>    ------------[ cut here ]------------
>    WARNING: CPU: 273 PID: 326626 at arch/x86/kvm/x86.h:180 complete_hypercall_exit+0x44/0xe0 [kvm]
>    Modules linked in: kvm_amd kvm ... [last unloaded: kvm]
>    CPU: 273 UID: 0 PID: 326626 Comm: sev_smoke_test Not tainted 6.12.0-smp--392e932fa0f3-feat #470
>    Hardware name: Google Astoria/astoria, BIOS 0.20240617.0-0 06/17/2024
>    RIP: 0010:complete_hypercall_exit+0x44/0xe0 [kvm]
>    Call Trace:
>     <TASK>
>     kvm_arch_vcpu_ioctl_run+0x2400/0x2720 [kvm]
>     kvm_vcpu_ioctl+0x54f/0x630 [kvm]
>     __se_sys_ioctl+0x6b/0xc0
>     do_syscall_64+0x83/0x160
>     entry_SYSCALL_64_after_hwframe+0x76/0x7e
>     </TASK>
>    ---[ end trace 0000000000000000 ]---

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Fixes: b5aead0064f3 ("KVM: x86: Assume a 64-bit hypercall for guests with protected state")
> Cc: stable@vger.kernel.org
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2e713480933a..0b2fe4aa04a2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9976,7 +9976,7 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>   {
>   	u64 ret = vcpu->run->hypercall.ret;
>   
> -	if (!is_64_bit_mode(vcpu))
> +	if (!is_64_bit_hypercall(vcpu))
>   		ret = (u32)ret;
>   	kvm_rax_write(vcpu, ret);
>   	++vcpu->stat.hypercalls;


