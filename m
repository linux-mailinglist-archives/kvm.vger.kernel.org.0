Return-Path: <kvm+bounces-52689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6415DB08313
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 04:46:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 875B27AC3AB
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 02:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260E41DF248;
	Thu, 17 Jul 2025 02:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fyOyJrtE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E35DDAB;
	Thu, 17 Jul 2025 02:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752720362; cv=none; b=MJBFpRxOH+0XTup70QQRZcPHSEWPgv8xZs21sajXExKwC9Owhwv22BHhAMZQ4Me8fVO7TeMTiMxX7BVQEHOYN8+wVSmEf3n17au1OwF7QzhOMpnANTvYg669MVmUU9lbcqviV7yKR60DbM+d3lrh6Q4MZSMY+XuwMrEL1RgtoNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752720362; c=relaxed/simple;
	bh=BB0wtY+2Fl6PBYzke5TpgUfTLuSYSHc4BrZfxz9+gtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u6Up8FzcvJzRONcw+tVpszF0ZAIFhMUnrYCWGY2yYEsNQp17ngGqZC41D9s4R0vFRDLlecvxphuV/++z34bOH2VKaTDrCRvjVLp9zTm09gG/DbLzTFtkBXH4FPXbZz2Y3k6OQY3H1RlLbg2YpCe0wiC27mSqag9j7/IWriJiR4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fyOyJrtE; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752720361; x=1784256361;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BB0wtY+2Fl6PBYzke5TpgUfTLuSYSHc4BrZfxz9+gtU=;
  b=fyOyJrtEQr2w6hrknz1E19GgAJqxbkLoI9Bt/mJxQTODKONNdfzV+EjO
   iJGL6rzn1P6P0lbzv/lJBLVWW0xkYaOJJOm34KpEeezIfzqFHU1K88IiN
   Dxw/od1qTaYtTwh0YKXyyJ881DG/0xua8ut9sDRU6mr+EwoBhf3ucmZom
   nomiOml9C2JWcgVjOnY993cFTvxxQaYkBd24bg54xwCECmysX1FJ8jAI4
   4oHQrlKNxY9GYY3iTPoRKZ+Rxw64YEl3X5BY95rtVmwI7aCGp2yKP8s6b
   aPN2V8z6y8Tc0KDTtEFdtgQNukvhlfgCOnrjGaXVfQaxKWhZV1IXgV578
   Q==;
X-CSE-ConnectionGUID: j4OzByQ4ReeLLvxPxp0f6g==
X-CSE-MsgGUID: 8UZ9YMxATKmlbHbPNmENmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="72550003"
X-IronPort-AV: E=Sophos;i="6.16,317,1744095600"; 
   d="scan'208";a="72550003"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 19:46:00 -0700
X-CSE-ConnectionGUID: gYy8mbBHTeWU7+saMzP5Lg==
X-CSE-MsgGUID: rxPAxCcFTY6XkR7QxbYSgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,317,1744095600"; 
   d="scan'208";a="157743433"
Received: from unknown (HELO [10.238.3.238]) ([10.238.3.238])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 19:45:58 -0700
Message-ID: <f0281c2f-4ddf-4a0c-81a2-b6de51a4fe82@linux.intel.com>
Date: Thu, 17 Jul 2025 10:45:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: TDX: Don't report base TDVMCALLs
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250717022010.677645-1-xiaoyao.li@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250717022010.677645-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 7/17/2025 10:20 AM, Xiaoyao Li wrote:
> Remove TDVMCALLINFO_GET_QUOTE from user_tdvmcallinfo_1_r11 reported to
> userspace to align with the direction of the GHCI spec.
>
> Recently, concern was raised about a gap in the GHCI spec that left
> ambiguity in how to expose to the guest that only a subset of GHCI
> TDVMCalls were supported. During the back and forth on the spec details[0],
> <GetQuote> was moved from an individually enumerable TDVMCall, to one that
> is part of the 'base spec', meaning it doesn't have a specific bit in the

'GHCI base API' is more appropriate instead of 'base spec'

> <GetTDVMCallInfo> return values. Although the spec[1] is still in draft
> form, the GetQoute part has been agreed by the major TDX VMMs.
GetQoute  ->  <GetQuote>

typo and use <> to align with others.

>
> Unfortunately the commits that were upstreamed still treat <GetQuote> as
> individually enumerable. They set bit 0 in the user_tdvmcallinfo_1_r11
> which is reported to userspace to tell supported optional TDVMCalls,
> intending to say that <GetQuote> is supported.
>
> So stop reporting <GetQute> in user_tdvmcallinfo_1_r11 to align with

GetQute -> GetQuote

> the direction of the spec, and allow some future TDVMCall to use that bit.
>
> [0] https://lore.kernel.org/all/aEmuKII8FGU4eQZz@google.com/
> [1] https://cdrdv2.intel.com/v1/dl/getContent/858626
>
> Fixes: 28224ef02b56 ("KVM: TDX: Report supported optional TDVMCALLs in TDX capabilities")
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Nits: typos and wording suggested above.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/tdx.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f31ccdeb905b..ea1261ca805f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -173,7 +173,6 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char i
>   	tdx_clear_unsupported_cpuid(entry);
>   }
>   
> -#define TDVMCALLINFO_GET_QUOTE				BIT(0)
>   #define TDVMCALLINFO_SETUP_EVENT_NOTIFY_INTERRUPT	BIT(1)
>   
>   static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
> @@ -192,7 +191,6 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
>   	caps->cpuid.nent = td_conf->num_cpuid_config;
>   
>   	caps->user_tdvmcallinfo_1_r11 =
> -		TDVMCALLINFO_GET_QUOTE |
>   		TDVMCALLINFO_SETUP_EVENT_NOTIFY_INTERRUPT;
>   
>   	for (i = 0; i < td_conf->num_cpuid_config; i++)


