Return-Path: <kvm+bounces-32891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64E9A9E142B
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 08:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BAF9284A7A
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 07:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C861A01B9;
	Tue,  3 Dec 2024 07:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M4NJgxHT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBF8189F57;
	Tue,  3 Dec 2024 07:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733211007; cv=none; b=kA8ESvTHgLG3VuMgSIh7wry+7+T4r9nTvjZA7uCyBsHYe/6GNp18KiZEXttJwStrnHL7rSM9VsDICnjwi7kAkzMPuKqogRvhwvayYiK8cSM5tmTJLgzmU5GJtDozXWYkHwN4uY5Ycr6hoPTK2KAF7FXN3AHgAeam/fGfi6sThCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733211007; c=relaxed/simple;
	bh=AAcjS64/ySNekWNYL1T6qkiKHfRkY7zzUXpblKqVvoQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RwIgZreyDgnz1BjS0PsMjSEyA1s78wlOtc2B+YFWtwvS4UOnvqwPD15Dc7GhKGDj9/r+TJVzzbcmR5f5Df9T3KndNFegFwn0UKlm85XockoL9ph5sn9KWJAzifds+5kQpBn5FDKDjFM0CJaTEStGy/1UeW2ZmoHFWvK4T1iSpXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M4NJgxHT; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733211005; x=1764747005;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AAcjS64/ySNekWNYL1T6qkiKHfRkY7zzUXpblKqVvoQ=;
  b=M4NJgxHTFAVua/R3WjdtvwSBkodGzOrt6IrbLEJFFhBXAFpZHYtH7ekb
   Y+nnE+afwE+u/08ghUouy188pLyS+ccQ90GE9a5QG0z/3Hsvg3ugBOFu7
   J2IcmiA9e/URDrMTjBZSdGPxndDAjUdnnog5/TPM5DM+JGucv7VLyLV2m
   GD40F7xHL0/RptEGPIK02kwWJBBsLHMrmWL478DYes+0TadLeLmNyglDc
   /D0sHFAzG8i0WqOBgRWi0kNwu+Xr2HAtd8Wyx+j+cy/eLqwqf+uNtoHU2
   5qqXwakZmBrBOJAUhgauqqHjSNsgTJLXHgsGya1JlEfKdyxqYIX3y1IsF
   w==;
X-CSE-ConnectionGUID: gLpa+iBKQmCO7cW9Q4jJHw==
X-CSE-MsgGUID: fG/mTz+lQN+orLiYWZgT6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="37182422"
X-IronPort-AV: E=Sophos;i="6.12,204,1728975600"; 
   d="scan'208";a="37182422"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 23:30:05 -0800
X-CSE-ConnectionGUID: PvSlLAjiRK+Bf5ajq71OcQ==
X-CSE-MsgGUID: 7AOIw34xTg6Yatpa4jJGug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,204,1728975600"; 
   d="scan'208";a="97781954"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 23:30:02 -0800
Message-ID: <49d0669a-251b-48e2-a705-1c8c6ecea342@linux.intel.com>
Date: Tue, 3 Dec 2024 15:29:59 +0800
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
 Tom Lendacky <thomas.lendacky@amd.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-2-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
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
>
> Fixes: b5aead0064f3 ("KVM: x86: Assume a 64-bit hypercall for guests with protected state")
> Cc: stable@vger.kernel.org
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

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


