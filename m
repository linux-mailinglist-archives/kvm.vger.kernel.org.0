Return-Path: <kvm+bounces-7775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A63DF846534
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 02:02:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B3931F25E47
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 01:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7DE26130;
	Fri,  2 Feb 2024 01:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YrXFGgoe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE92353BA;
	Fri,  2 Feb 2024 01:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706835757; cv=none; b=aesriCBhk/6TOufXr66rzy0L5ZBJrZLB4igff4iv8HNZeTi/c08uZ4qn/L+D/eJLHUZnLoADvZwrhjUhVzJUk14SdxxQVESsyn+LgmG+l5DHrx7Sw7e9j93A5YpPY60mkpNZtRNEPoRvZt6mvY7iFDLiNw/TWL7k7LmCmPFtl54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706835757; c=relaxed/simple;
	bh=zes1QjIgFX8iTfNqPGsOdXG8Tg4Fxj/wCEPnLquZkdQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jxkf17uZhTYOchVlC7uf93poTfqNN7g2IruUrpzkgJXFf4dK4r/GixpAJSmBol6r/LQ55wMODgvAYwah1czYeU4e3mFKA7BDSlSdbEEyfGzTh5KX9PgtzqNquTk26KZF8iBtRc2D2MnSZpkl/Gqv+xb45FM8p64xFJ27ILaxxIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YrXFGgoe; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706835756; x=1738371756;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zes1QjIgFX8iTfNqPGsOdXG8Tg4Fxj/wCEPnLquZkdQ=;
  b=YrXFGgoeQFmSy65mfLhYxndweRQIPK2Ujqv7PraM2yx3HKS22cY+ezZL
   /NjLBe2k/fG1mc76y6VBaUm9wq3489FGzFjf3GMsZnSs7ItEXwo1zAEkP
   B2ZBDpSI9QdQjgOhwG5Ed+ZZIgUKujbLCfUN8ltbCNHg8TSGN5XFgnBiK
   Px26BN/u6KM5aN+8MU9m1oZ6Vf5wGLYA81eRVeVpCt83PmB2EI7FnXHid
   q/FFs2JOVPG29yxDIz//HIUI5kbmHSaTGoxNkNW6TLgW8QXeumQQ3yZA8
   iinnqx/kPXHK1qzkGaLML2IhN9mq0whilp6q2w4QNL+ruCwPCPlFBSQpK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="2980024"
X-IronPort-AV: E=Sophos;i="6.05,236,1701158400"; 
   d="scan'208";a="2980024"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 17:02:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,236,1701158400"; 
   d="scan'208";a="30759782"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.33.17]) ([10.93.33.17])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 17:02:31 -0800
Message-ID: <e5387c7c-9df8-4e39-bbe9-23e8bb09e527@intel.com>
Date: Fri, 2 Feb 2024 09:02:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 012/121] KVM: TDX: Define TDX architectural
 definitions
Content-Language: en-US
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <958dfa60e2570a38b4c4e997be2a72b294e6d91b.1705965634.git.isaku.yamahata@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <958dfa60e2570a38b4c4e997be2a72b294e6d91b.1705965634.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/2024 7:52 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Define architectural definitions for KVM to issue the TDX SEAMCALLs.
> 
> Structures and values that are architecturally defined in the TDX module
> specifications the chapter of ABI Reference.
> 
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> v18:
> - Add metadata field id
> ---
>   arch/x86/kvm/vmx/tdx_arch.h | 269 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 269 insertions(+)
>   create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
> 
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> new file mode 100644
> index 000000000000..569d59c55229
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -0,0 +1,269 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* architectural constants/data definitions for TDX SEAMCALLs */
> +
> +#ifndef __KVM_X86_TDX_ARCH_H
> +#define __KVM_X86_TDX_ARCH_H
> +
> +#include <linux/types.h>
> +
> +/*
> + * TDX SEAMCALL API function leaves
> + */
> +#define TDH_VP_ENTER			0
> +#define TDH_MNG_ADDCX			1
> +#define TDH_MEM_PAGE_ADD		2
> +#define TDH_MEM_SEPT_ADD		3
> +#define TDH_VP_ADDCX			4
> +#define TDH_MEM_PAGE_RELOCATE		5
> +#define TDH_MEM_PAGE_AUG		6
> +#define TDH_MEM_RANGE_BLOCK		7
> +#define TDH_MNG_KEY_CONFIG		8
> +#define TDH_MNG_CREATE			9
> +#define TDH_VP_CREATE			10
> +#define TDH_MNG_RD			11
> +#define TDH_MR_EXTEND			16
> +#define TDH_MR_FINALIZE			17
> +#define TDH_VP_FLUSH			18
> +#define TDH_MNG_VPFLUSHDONE		19
> +#define TDH_MNG_KEY_FREEID		20
> +#define TDH_MNG_INIT			21
> +#define TDH_VP_INIT			22
> +#define TDH_MEM_SEPT_RD			25
> +#define TDH_VP_RD			26
> +#define TDH_MNG_KEY_RECLAIMID		27
> +#define TDH_PHYMEM_PAGE_RECLAIM		28
> +#define TDH_MEM_PAGE_REMOVE		29
> +#define TDH_MEM_SEPT_REMOVE		30
> +#define TDH_SYS_RD			34
> +#define TDH_MEM_TRACK			38
> +#define TDH_MEM_RANGE_UNBLOCK		39
> +#define TDH_PHYMEM_CACHE_WB		40
> +#define TDH_PHYMEM_PAGE_WBINVD		41
> +#define TDH_VP_WR			43
> +#define TDH_SYS_LP_SHUTDOWN		44
> +
> +#define TDG_VP_VMCALL_GET_TD_VM_CALL_INFO		0x10000
> +#define TDG_VP_VMCALL_MAP_GPA				0x10001
> +#define TDG_VP_VMCALL_GET_QUOTE				0x10002
> +#define TDG_VP_VMCALL_REPORT_FATAL_ERROR		0x10003
> +#define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT	0x10004
> +

these are definitions shared with TDX guest codes, and already defined 
in arch/x86/include/asm/shared/tdx.h. Please drop it.

Other than above,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


