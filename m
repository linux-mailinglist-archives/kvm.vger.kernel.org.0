Return-Path: <kvm+bounces-13979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A064C89D716
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 12:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 420531F2466A
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 10:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FDBA8288C;
	Tue,  9 Apr 2024 10:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TOXiL7Hp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1A61EB46;
	Tue,  9 Apr 2024 10:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712658968; cv=none; b=qHO4sHNkDLu5pYpQkObd6s9Wky/nszsS+a8JJj7jeafkSsW37XeYpJUDSdV5SWk3RmZqBaNb2+QYsJOA2eYemh8TZa6ra5075LsaL0dvxN+C26A/kX7ElS+c2gIWS1w/J/VMetDj54DNTjAnWrLO07Ahr16x1g1pwyjX+6Ke6vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712658968; c=relaxed/simple;
	bh=hI5RXPMh2A+JPxrImyxE0r+9FYfooKwhJCBDZD96weE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Im6PFl2Crm1600KNUQr2+QsahlHZN22LEGbLW2cn5A/lacR8w5aXhKRYH4NmrlGkXH7tbQ4iyk1PMtaxGoGt2OyETUwK8O/0FvJ3ohSTcLaSnKe95J1KwlevDVInSKWVlREyyAxe2PGfklSQ92/Ev2vSbIKuBi1MJ06CgVP/uoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TOXiL7Hp; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712658967; x=1744194967;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hI5RXPMh2A+JPxrImyxE0r+9FYfooKwhJCBDZD96weE=;
  b=TOXiL7Hpet1S/0L/n+nkDzVHsf2oXtd8c0VMybadyhw52j9IICqhb3kW
   CSQtHzE4XjwaYs+avYgo1FWvz4M/e/rgqAS6iv5zzlqVrr3ef7n5Sgp8m
   ykjX7mncsaYnrH1dqBIooOWWViqTrWUCm2dNulm//6VIAmEeqBIx6ePYJ
   Zurm8Fs111YT0jQdA0ZeQpDMIE6uXiMfSd5bJFZ9h/pSOCIgb//rMMwFa
   Jwk/+uZdngiIm9iZcCWIjcHtd/kb+gU1lIj9p8oN4hFk2bulHJQ9bDxyz
   okX57b+XEjH4iJ/eQkwLtRsyB4oWNFHWKmrKAIyyLNaS3iVQ9RkrnXOsx
   w==;
X-CSE-ConnectionGUID: 8f6lS2TMTRutZ4ygZ0LlYw==
X-CSE-MsgGUID: nbfWp4dSSlmbsN0W77Re2w==
X-IronPort-AV: E=McAfee;i="6600,9927,11038"; a="25409347"
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="25409347"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 03:36:06 -0700
X-CSE-ConnectionGUID: L1MurgB9QMWXYNA2vaS8Yg==
X-CSE-MsgGUID: ORj0uC2kRCSa8VD7Ibq71Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="24921705"
Received: from unknown (HELO [10.238.9.252]) ([10.238.9.252])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 03:36:03 -0700
Message-ID: <4ccb3a98-d732-421e-a013-8912b46d8107@linux.intel.com>
Date: Tue, 9 Apr 2024 18:36:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 098/130] KVM: TDX: Add a place holder to handle TDX VM
 exit
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <88920c598dcb55c15219642f27d0781af6d0c044.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <88920c598dcb55c15219642f27d0781af6d0c044.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Wire up handle_exit and handle_exit_irqoff methods

This patch also wires up get_exit_info.

>   and add a place holder
> to handle VM exit.  Add helper functions to get exit info, exit
> qualification, etc.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/main.c    |  37 ++++++++++++-
>   arch/x86/kvm/vmx/tdx.c     | 110 +++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h |  10 ++++
>   3 files changed, 154 insertions(+), 3 deletions(-)
>
[...]
> @@ -562,7 +593,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   
>   	.vcpu_pre_run = vt_vcpu_pre_run,
>   	.vcpu_run = vt_vcpu_run,
> -	.handle_exit = vmx_handle_exit,
> +	.handle_exit = vt_handle_exit,
>   	.skip_emulated_instruction = vmx_skip_emulated_instruction,
>   	.update_emulated_instruction = vmx_update_emulated_instruction,
>   	.set_interrupt_shadow = vt_set_interrupt_shadow,
> @@ -597,7 +628,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.set_identity_map_addr = vmx_set_identity_map_addr,
>   	.get_mt_mask = vt_get_mt_mask,
>   
> -	.get_exit_info = vmx_get_exit_info,
> +	.get_exit_info = vt_get_exit_info,
>   
>   	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
>   
> @@ -611,7 +642,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.load_mmu_pgd = vt_load_mmu_pgd,
>   
>   	.check_intercept = vmx_check_intercept,
> -	.handle_exit_irqoff = vmx_handle_exit_irqoff,
> +	.handle_exit_irqoff = vt_handle_exit_irqoff,
>   
>   	.request_immediate_exit = vt_request_immediate_exit,
>   
[...]
>   
> +int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> +{
> +	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
> +
> +	/* See the comment of tdh_sept_seamcall(). */

Should be tdx_seamcall_sept().

> +	if (unlikely(exit_reason.full == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)))

Can use "TDX_ERROR_SEPT_BUSY" instead.

> +		return 1;
> +
> +	/*
> +	 * TDH.VP.ENTRY

"TDH.VP.ENTRY" -> "TDH.VP.ENTER"

>   checks TD EPOCH which contend with TDH.MEM.TRACK and
> +	 * vcpu TDH.VP.ENTER.
Do you mean TDH.VP.ENTER on one vcpu can contend with TDH.MEM.TRACK and 
TDH.VP.ENTER on another vcpu?

> +	 */
>

