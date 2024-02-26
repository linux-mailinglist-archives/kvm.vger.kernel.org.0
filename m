Return-Path: <kvm+bounces-9606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B297186677F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 02:27:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 364B22812E9
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 01:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5166BD52E;
	Mon, 26 Feb 2024 01:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f7bevqkS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9CE2CA7;
	Mon, 26 Feb 2024 01:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708910833; cv=none; b=oThx1ff6NzGTrF+WtpLq5Zyzp7qwlXLL5rERPHS1tImltobTUri8YVX7ALzl4F1952k0d7dLSagZ5hLEqcuH0Jx8oiUz3H0kdQVJ1H4EKcWEG6c5atCJT39zSvfhgWlnVNau4FT7ARSFN+chz9OURkz10iEgIrNetkuEA16D804=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708910833; c=relaxed/simple;
	bh=VQRLURp3N2fLV45lnFehSEVGx7kADUvzibC1ROwWOyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iNTYRZfm7i1qOTRRBV3dNooE3c3M6K/UrMbiRHREMI2JJBPnexZQXrRyh/8MHZpkB8Rum6WK9Y1QBc7Oco28w0Wx1qaEW9Hqb+vUP7biZA813/+TAW66qJkL0EBiKjpQ+kVdt0n+m1Qe/FyAu642aP/Setog4roXzzNji4G5BU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f7bevqkS; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708910832; x=1740446832;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VQRLURp3N2fLV45lnFehSEVGx7kADUvzibC1ROwWOyY=;
  b=f7bevqkSSuP/mN2JgeRLaemA+fzCHRS+8yxRTqLcEhnGrc2k8ctSToum
   BX2pFqIyyRdRt9U/jYJuPGJvARp3LDTHg4a1krV9NHpJuNbSi8kBTmeBW
   UJj4yax9uFO42aCWZWu/7twc+c5kLQzQ6SbCg2ETQ960r2mZvfiXvHwUK
   rucvJEwhJsfDRalrNDf7b2AQH6UZoKwkcTg/UhlOe52tTOvC5ZLjFaw5U
   hLtidfmfEUAtLsTSy35e3L9StQt1qsBpEvwu6WQRlDDrwvpvzr7G5MpBf
   MMi04P1729fcj7+mjVqO/UbQiroPZoDvp14944pau4capIgeszVNJIhyr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="14308989"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="14308989"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2024 17:27:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6421205"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.85]) ([10.238.9.85])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2024 17:27:07 -0800
Message-ID: <a8a8f6de-60de-4fca-bf59-a6d42d6c9ff2@linux.intel.com>
Date: Mon, 26 Feb 2024 09:27:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 077/121] KVM: x86: Add a switch_db_regs flag to handle
 TDX's auto-switched behavior
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Chao Gao <chao.gao@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <6ae14d4e3a2f248879dcfc2990816f6341458c40.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <6ae14d4e3a2f248879dcfc2990816f6341458c40.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add a flag, KVM_DEBUGREG_AUTO_SWITCHED_GUEST, to skip saving/restoring DRs
> irrespective of any other flags.  TDX-SEAM unconditionally saves and
> restores guest DRs and reset to architectural INIT state on TD exit.
> So, KVM needs to save host DRs before TD enter without restoring guest DRs
> and restore host DRs after TD exit.

The description here is different from the implementation.
The changelog needs to be updated?

>
> Opportunistically convert the KVM_DEBUGREG_* definitions to use BIT().
>
> Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 10 ++++++++--
>   arch/x86/kvm/vmx/tdx.c          |  1 +
>   arch/x86/kvm/x86.c              | 11 ++++++++---
>   3 files changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5cb25e1f83ce..a7782a6f995a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -626,8 +626,14 @@ struct kvm_pmu {
>   struct kvm_pmu_ops;
>   
>   enum {
> -	KVM_DEBUGREG_BP_ENABLED = 1,
> -	KVM_DEBUGREG_WONT_EXIT = 2,
> +	KVM_DEBUGREG_BP_ENABLED		= BIT(0),
> +	KVM_DEBUGREG_WONT_EXIT		= BIT(1),
> +	/*
> +	 * Guest debug registers (DR0-3 and DR6) are saved/restored by hardware
> +	 * on exit from or enter to guest. KVM needn't switch them. Because DR7
> +	 * is cleared on exit from guest, DR7 need to be saved/restored.
> +	 */
> +	KVM_DEBUGREG_AUTO_SWITCH	= BIT(2),
>   };
>   
>   struct kvm_mtrr_range {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 58583f0ab131..db01162de136 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -636,6 +636,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   
>   	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
>   
> +	vcpu->arch.switch_db_regs = KVM_DEBUGREG_AUTO_SWITCH;
>   	vcpu->arch.cr0_guest_owned_bits = -1ul;
>   	vcpu->arch.cr4_guest_owned_bits = -1ul;
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f14e3e888842..e252372bb633 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10973,7 +10973,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	if (vcpu->arch.guest_fpu.xfd_err)
>   		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
>   
> -	if (unlikely(vcpu->arch.switch_db_regs)) {
> +	if (unlikely(vcpu->arch.switch_db_regs & ~KVM_DEBUGREG_AUTO_SWITCH)) {
>   		set_debugreg(0, 7);
>   		set_debugreg(vcpu->arch.eff_db[0], 0);
>   		set_debugreg(vcpu->arch.eff_db[1], 1);
> @@ -11019,6 +11019,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	 */
>   	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
>   		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
> +		WARN_ON(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH);
>   		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
>   		kvm_update_dr0123(vcpu);
>   		kvm_update_dr7(vcpu);
> @@ -11031,8 +11032,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	 * care about the messed up debug address registers. But if
>   	 * we have some of them active, restore the old state.
>   	 */
> -	if (hw_breakpoint_active())
> -		hw_breakpoint_restore();
> +	if (hw_breakpoint_active()) {
> +		if (!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))
> +			hw_breakpoint_restore();
> +		else
> +			set_debugreg(__this_cpu_read(cpu_dr7), 7);
> +	}
>   
>   	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
>   	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());


