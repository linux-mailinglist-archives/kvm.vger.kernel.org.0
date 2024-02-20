Return-Path: <kvm+bounces-9143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BB8B85B664
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:00:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDF631F23030
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A73026350F;
	Tue, 20 Feb 2024 08:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ArNwfErr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A510633F3;
	Tue, 20 Feb 2024 08:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708419383; cv=none; b=lgj/YMAy2M2jXUWM5fMAExr8Mxv8QMabJAllCZbiRHNLrqCMuTdMw9QgP0OVsK5u5l3HsuhHMZP5R5MDEtBxuUcTX2EaX/EkoD0ttgSACy/QgUskhnEP7EAZRtL2Lm7QsiaIZp1ScDwb8PuLETsQL5EDAg32rVfePXLku7wSIBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708419383; c=relaxed/simple;
	bh=W7ULu2PbSiwXjM79NAjBueJ9JU/9Ysyic1LEtAhus+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VHSS/qY2fL/JF74Lue1acoYB4n6Y34NCIbuQHxoxbZseKc130qy0i/vH+ew+1RX7ZqY7xVNsHGJk5i753wiIHkRYnpXHVnB5xp4+rFPTaYp0HY98ZBUEeQ9puN6H0ikk9Hm/OSJkdwxuKWI1Q6Dl+2vXMhRyUCpwk0rjjgW0DkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ArNwfErr; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708419382; x=1739955382;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=W7ULu2PbSiwXjM79NAjBueJ9JU/9Ysyic1LEtAhus+E=;
  b=ArNwfErrA8W/kvXPMz90aXrrep64nNu9McjnyamnUHpR5XAYQVJSIo/2
   b/4ExO3sLfeNI+bxAtwhDfUSyNRJmLvdCQZLUBJPcH7WzOHTroIzns0FX
   43sLlx6Lv2a0zhvyJPnyNeczuhd9YpDHb3hi+7RbPcBcCMNW2iHU5O3xg
   ZmPas+8VP0Xk/jtZ6JCo8P2pyFx/vQMvwfJSWccwAuTuKePHwETnbjR1b
   FlmPeZR6YEL/IQ1lXCKGV3GmjLwJ/iHqlCFbVqWXA0NKbOtcY7EeXrH+X
   prJkimw/3bBMpGEv0rwoaQ0rLNU3NMFfRTnGpb1A1GNpaAT9Knn1Z0PJw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="24970759"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="24970759"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 00:56:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="27878939"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.1.66]) ([10.238.1.66])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 00:56:18 -0800
Message-ID: <f6214e3a-da8c-4bce-8a1f-a035b2ff909b@linux.intel.com>
Date: Tue, 20 Feb 2024 16:56:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 069/121] KVM: TDX: restore host xsave state when exit
 from the guest TD
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <bfa1994b79687709aae011ff455147cc7dd97ffb.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <bfa1994b79687709aae011ff455147cc7dd97ffb.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> On exiting from the guest TD, xsave state is clobbered.  Restore xsave
> state on TD exit.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v15 -> v16:
> - Added CET flag mask
> ---
>   arch/x86/kvm/vmx/tdx.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 903f4abb3543..fe818cfde9e7 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2,6 +2,7 @@
>   #include <linux/cpu.h>
>   #include <linux/mmu_context.h>
>   
> +#include <asm/fpu/xcr.h>
>   #include <asm/tdx.h>
>   
>   #include "capabilities.h"
> @@ -584,6 +585,23 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	 */
>   }
>   
> +static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +
> +	if (static_cpu_has(X86_FEATURE_XSAVE) &&
> +	    host_xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
> +		xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
> +	if (static_cpu_has(X86_FEATURE_XSAVES) &&
> +	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
> +	    host_xss != (kvm_tdx->xfam &
> +			 (kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET)))
> +		wrmsrl(MSR_IA32_XSS, host_xss);
> +	if (static_cpu_has(X86_FEATURE_PKU) &&
> +	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
> +		write_pkru(vcpu->arch.host_pkru);
> +}
> +

The export of host_xcr0 in patch 67 can be moved to this path.

  u64 __read_mostly host_xcr0;
+EXPORT_SYMBOL_GPL(host_xcr0);

>   static noinstr void tdx_vcpu_enter_exit(struct vcpu_tdx *tdx)
>   {
>   	struct tdx_module_args args;
> @@ -659,6 +677,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	tdx_vcpu_enter_exit(tdx);
>   
> +	tdx_restore_host_xsave_state(vcpu);
>   	tdx->host_state_need_restore = true;
>   
>   	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;


