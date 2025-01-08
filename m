Return-Path: <kvm+bounces-34748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F12A05463
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 08:21:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A2051649DC
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 07:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95E91AAA11;
	Wed,  8 Jan 2025 07:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OgJFGEBv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C511A76BC;
	Wed,  8 Jan 2025 07:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736320894; cv=none; b=QYfRqgXtu6/I5fAiEQPfjAblFIQB1P46hL0iXrgm3MQdfvFUncQry6PZNjZ994utj8UnvcBnUx3SQdo+OTnLv93Wn6g9PXFJLKB5ewQzxlYiNbUugo7MN6xXURKQlhgkLRmm4hGiPKoLkKwP9IuzD2DZTufDMRQ5xfYhRZ2boEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736320894; c=relaxed/simple;
	bh=s73QGq/iJIjYfr1pcHIVQUPsOmarwrYWDwx9ig1xiDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dRhN0jxi6iu58NxrBtq+DunHO5AN2QB9IYsA5GhAtzPpxCRBLn78kPRKATS8PlDCKDAVbyG5LO0f6fEY5n5+CyME5cWV/nHuDxhOy2jcvIpRyq1jlitNiTnWQ6GhYZ1TE278JswPRnml+6/T9WiXr9MXYEW1/zhGAbbAUEaP5S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OgJFGEBv; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736320893; x=1767856893;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s73QGq/iJIjYfr1pcHIVQUPsOmarwrYWDwx9ig1xiDQ=;
  b=OgJFGEBvuCJyqzoqmzpP+zujvDBIh/I2QFuwuiqYrHBrTcrwez999CE1
   oxd/UgJ1K6tRhwF8D0ke4iaAYadxtfyRLwCJXHy5aXx7YUZn96xbxcdJB
   JLbGxEADTe+D5a2pwW5KzyryBODvJsfoFbGCYS9GfAqkq1k8ByCDotyEX
   2jeqRDh4NZPQgDgVsW+T1U4d1Vuv8twd2pG2KLIpu8eP1YSmkHMj23/JR
   Eg5Ry/365p38EiZSo9UMHl2VuLXRJKNHdi35/TnM5eM5dUqptVP2qxFjW
   Q4ZC6Bs/0T7vP5Y7vYDgJ5S4vUlfJjk2r45DXETkPgyc/AKDb5BtLPwAX
   A==;
X-CSE-ConnectionGUID: eV89628JTuCwNlfEMarEsw==
X-CSE-MsgGUID: Vg97kFEhQrKIwHdnGlOw6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="47948791"
X-IronPort-AV: E=Sophos;i="6.12,297,1728975600"; 
   d="scan'208";a="47948791"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 23:21:32 -0800
X-CSE-ConnectionGUID: rpw4PJN7Tvyw0/JQOtnkbA==
X-CSE-MsgGUID: nOGIF0UjQoabecIPmaiOkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="108065330"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 23:21:28 -0800
Message-ID: <473c1a20-11c8-4e4e-8ff1-e2e5c5d68332@intel.com>
Date: Wed, 8 Jan 2025 15:21:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/16] KVM: TDX: Always block INIT/SIPI
To: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 linux-kernel@vger.kernel.org
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-12-binbin.wu@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241209010734.3543481-12-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/2024 9:07 AM, Binbin Wu wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Always block INIT and SIPI events for the TDX guest because the TDX module
> doesn't provide API for VMM to inject INIT IPI or SIPI.
> 
> TDX defines its own vCPU creation and initialization sequence including
> multiple seamcalls.  Also, it's only allowed during TD build time.
> 
> Given that TDX guest is para-virtualized to boot BSP/APs, normally there
> shouldn't be any INIT/SIPI event for TDX guest.  If any, three options to
> handle them:
> 1. Always block INIT/SIPI request.
> 2. (Silently) ignore INIT/SIPI request during delivery.
> 3. Return error to guest TDs somehow.
> 
> Choose option 1 for simplicity. Since INIT and SIPI are always blocked,
> INIT handling and the OP vcpu_deliver_sipi_vector() won't be called, no
> need to add new interface or helper function for INIT/SIPI delivery.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> TDX interrupts breakout:
> - Renamed from "KVM: TDX: Silently ignore INIT/SIPI" to
>    "KVM: TDX: Always block INIT/SIPI".
> - Remove KVM_BUG_ON() in tdx_vcpu_reset(). (Rick)
> - Drop tdx_vcpu_reset() and move the comment to vt_vcpu_reset().
> - Remove unnecessary interface and helpers to delivery INIT/SIPI
>    because INIT/SIPI events are always blocked for TDX. (Binbin)
> - Update changelog.
> ---
>   arch/x86/kvm/lapic.c    |  2 +-
>   arch/x86/kvm/vmx/main.c | 19 ++++++++++++++++++-
>   2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 474e0a7c1069..f93c382344ee 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -3365,7 +3365,7 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>   
>   	if (test_and_clear_bit(KVM_APIC_INIT, &apic->pending_events)) {
>   		kvm_vcpu_reset(vcpu, true);
> -		if (kvm_vcpu_is_bsp(apic->vcpu))
> +		if (kvm_vcpu_is_bsp(vcpu))
>   			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>   		else
>   			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 8ec96646faec..7f933f821188 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -115,6 +115,11 @@ static void vt_vcpu_free(struct kvm_vcpu *vcpu)
>   
>   static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   {
> +	/*
> +	 * TDX has its own sequence to do init during TD build time (by
> +	 * KVM_TDX_INIT_VCPU) and it doesn't support INIT event during TD
> +	 * runtime.
> +	 */

The first half is confusing. It seems to mix up init(ialization) with 
INIT event.

And this callback is about *reset*, which can be due to INIT event or 
not. That's why it has a second parameter of init_event. The comment 
needs to clarify why reset is not needed for both cases.

I think we can just say TDX doesn't support vcpu reset no matter due to 
INIT event or not.

>   	if (is_td_vcpu(vcpu))
>   		return;
>   
> @@ -211,6 +216,18 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
>   }
>   #endif
>   
> +static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * INIT and SIPI are always blocked for TDX, i.e., INIT handling and
> +	 * the OP vcpu_deliver_sipi_vector() won't be called.
> +	 */
> +	if (is_td_vcpu(vcpu))
> +		return true;
> +
> +	return vmx_apic_init_signal_blocked(vcpu);
> +}
> +
>   static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
>   {
>   	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
> @@ -565,7 +582,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   #endif
>   
>   	.check_emulate_instruction = vmx_check_emulate_instruction,
> -	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> +	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
>   	.migrate_timers = vmx_migrate_timers,
>   
>   	.msr_filter_changed = vmx_msr_filter_changed,


