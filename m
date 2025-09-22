Return-Path: <kvm+bounces-58370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CAAFB8F902
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 10:37:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 301A53B3537
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 08:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A236287510;
	Mon, 22 Sep 2025 08:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S6HbwwDH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EBC26AC3;
	Mon, 22 Sep 2025 08:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758530055; cv=none; b=dmnLlqLCt924DcV3bwI9kpaOQkWP7fOLtIDCxtDUTgde5Wu10T5AS8oODIFFg0WZyrFexugWAOsKMdwrOdvyE/pCv1W30Qj3drznqvYFbQj35BlepKDSd1Gk0HaBthHDgYnD3x1v6vuJ17WSyitWsAfNMVwOY5zIa87ySFHih5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758530055; c=relaxed/simple;
	bh=Od3RD8Gh4wYu96pWzZ3+mrMZSwXPf7xgBK6OoQlUGxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ohy8OUvxRdOSPGFVkq1hK/GpVocx7hfiaNeXieGPaHzJwCDfUPXAM11CdlRtwYOUkpDrol6ux4EdvJfWE8MGYee9nKl1R5iR+LV+3K89KaimGmcBgWQ/R+821mdGGVKVThC6UlzCUfmodFN+6p/K/Z7TTgLiqgsplDIS5s0Cq8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S6HbwwDH; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758530053; x=1790066053;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Od3RD8Gh4wYu96pWzZ3+mrMZSwXPf7xgBK6OoQlUGxY=;
  b=S6HbwwDHKWgglfo/OPyC1WHEMW6CfWBUAXIEEJ6eY0KG80AhcB1Lzif5
   NEk8cUPZ5mXXFGeG4W9fzRqUpL1R58BWcluL+0Kp3L17MDVOnLK7xG+CR
   OKZYH6E+E82EYhI6HcsrC2x/WyEy7bbgGMSXNn/EcDslqiZ1XF6LD3wbF
   TgnicwzYF1gr/Dl+5AaEIMNilEBRl4AruV6ntO/GoUw8ibn4OsmqLvujO
   gv4du5Z6TjqhSNrxk99j4NVEG5jdUWPFUS1y32nnQXWuuJ8eWKvU3KP99
   2iQX6mSr5YM588ZFyGaMCzxv2Dwd7xWChoLTMYV1VsEIOq1QRdvSYZgEy
   w==;
X-CSE-ConnectionGUID: GecoBdLjQeesv3nmY8ZQAA==
X-CSE-MsgGUID: RW/JA/3ZRNqrhRmBVCPp8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="71463936"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="71463936"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:34:12 -0700
X-CSE-ConnectionGUID: LfMMMhUsTheh1x+KnubAiQ==
X-CSE-MsgGUID: 3Bl2GaJ/SFaHZoOJZl6j9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="207381697"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:34:09 -0700
Message-ID: <67e4425d-e8a4-4102-81e4-0aa7e393d364@linux.intel.com>
Date: Mon, 22 Sep 2025 16:34:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 51/51] KVM: VMX: Make CR4.CET a guest owned bit
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-52-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-52-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> From: Mathias Krause <minipli@grsecurity.net>
>
> Make CR4.CET a guest-owned bit under VMX by extending
> KVM_POSSIBLE_CR4_GUEST_BITS accordingly.
>
> There's no need to intercept changes to CR4.CET, as it's neither
> included in KVM's MMU role bits, nor does KVM specifically care about
> the actual value of a (nested) guest's CR4.CET value, beside for
> enforcing architectural constraints, i.e. make sure that CR0.WP=1 if
> CR4.CET=1.
>
> Intercepting writes to CR4.CET is particularly bad for grsecurity
> kernels with KERNEXEC or, even worse, KERNSEAL enabled. These features
> heavily make use of read-only kernel objects and use a cpu-local CR0.WP
> toggle to override it, when needed. Under a CET-enabled kernel, this
> also requires toggling CR4.CET, hence the motivation to make it
> guest-owned.
>
> Using the old test from [1] gives the following runtime numbers (perf
> stat -r 5 ssdd 10 50000):
>
> * grsec guest on linux-6.16-rc5 + cet patches:
>    2.4647 +- 0.0706 seconds time elapsed  ( +-  2.86% )
>
> * grsec guest on linux-6.16-rc5 + cet patches + CR4.CET guest-owned:
>    1.5648 +- 0.0240 seconds time elapsed  ( +-  1.53% )
>
> Not only does not intercepting CR4.CET make the test run ~35% faster,
> it's also more stable with less fluctuation due to fewer VMEXITs.
>
> Therefore, make CR4.CET a guest-owned bit where possible.
>
> This change is VMX-specific, as SVM has no such fine-grained control
> register intercept control.
>
> If KVM's assumptions regarding MMU role handling wrt. a guest's CR4.CET
> value ever change, the BUILD_BUG_ON()s related to KVM_MMU_CR4_ROLE_BITS
> and KVM_POSSIBLE_CR4_GUEST_BITS will catch that early.
>
> Link: https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/ [1]
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/kvm_cache_regs.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 36a8786db291..8ddb01191d6f 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -7,7 +7,8 @@
>   #define KVM_POSSIBLE_CR0_GUEST_BITS	(X86_CR0_TS | X86_CR0_WP)
>   #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
>   	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
> -	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
> +	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE \
> +	 | X86_CR4_CET)
>   
>   #define X86_CR0_PDPTR_BITS    (X86_CR0_CD | X86_CR0_NW | X86_CR0_PG)
>   #define X86_CR4_TLBFLUSH_BITS (X86_CR4_PGE | X86_CR4_PCIDE | X86_CR4_PAE | X86_CR4_SMEP)


