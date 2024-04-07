Return-Path: <kvm+bounces-13833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 81EC289B07E
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 12:53:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10DF41F21BA4
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 10:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A292033E;
	Sun,  7 Apr 2024 10:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fbAlZ7IA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F0D13AF9;
	Sun,  7 Apr 2024 10:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712487172; cv=none; b=eEXAnHRqQr5y4VpXFrYRt0xdiKfLTTwHU49mW0RGb50trEoUlB5wj733aWxkfxlromTrRX64HIZSCYVEs2xht1upGmfUYZxBXl456t/D+xVtYG/sU7699llhQvyD+mUPyxZz6gBxC3zDdJCi1+/mBOYmVqNm4MgP2pHuxrzuVSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712487172; c=relaxed/simple;
	bh=Pq+UHd+SHRkluHPtt8xhHvpK+b+CEzXi6ct9NvlPkN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WAIK5u7b4fmvDD3kIRdB6nKURUkIPsNIQPne4aYKSsHJgFahEd8mz9memJGRhNyEHD57EW7nQT1ZkevO/i4/evroTGkwbYbqolCTgLfiu24dBNzlDT9TnfkiSq/aigfvt7ZVRspGt8nRQbaal9oljHOJ1IyVut8TJHAdHlBUmwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fbAlZ7IA; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712487171; x=1744023171;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Pq+UHd+SHRkluHPtt8xhHvpK+b+CEzXi6ct9NvlPkN8=;
  b=fbAlZ7IAJQoTLOAPkm9BGXQVlSdcZnkJBKwUBDTL0TR1Zrt5Ni+D21En
   q/1RwR6C4DlUsPC2ROYWx+RV1HVpEpsuJl78EpLYdA1npqDB+0/Jr8SuC
   0sY8t4z3j1zhqkIYMohU4ngiDhEx1xuGFEhuS+TbmkSPoB8PcpByjlFq8
   5BjNbMm2Y7Hq/ZQREU2pwVC+MseseuIQ8eE0kUYAnwFLj5lZBU2F9ix3a
   ffor0qf2iu+wD43q/+8tLRmLFe/rKKjMZtaAooNFNzzyViCVQntsS/Vtt
   nFk3hAxHvrKF406nN4OwuTQvaOdOm72MbnNzYmwK/hIe1LTPsIJ6ll0sZ
   w==;
X-CSE-ConnectionGUID: SnIr/7n/TOKPt4ZBBYzu8A==
X-CSE-MsgGUID: o2J5v8clRJqCg3TQTg1ixQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11036"; a="7608897"
X-IronPort-AV: E=Sophos;i="6.07,185,1708416000"; 
   d="scan'208";a="7608897"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2024 03:52:50 -0700
X-CSE-ConnectionGUID: 5RBomvIyTDeiVWeO1Mu0iA==
X-CSE-MsgGUID: bS/moLV4RPSPZ0w8BkscmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,185,1708416000"; 
   d="scan'208";a="19726192"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2024 03:52:46 -0700
Message-ID: <aaa69c7d-7f33-44a3-b23c-82447a8452ce@linux.intel.com>
Date: Sun, 7 Apr 2024 18:52:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 088/130] KVM: x86: Add a switch_db_regs flag to handle
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
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <ca5d0399cdbbaa6c7c6528ad85b3560cec0f0752.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ca5d0399cdbbaa6c7c6528ad85b3560cec0f0752.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add a flag, KVM_DEBUGREG_AUTO_SWITCHED_GUEST, to skip saving/restoring DRs
> irrespective of any other flags.

Here "irrespective of any other flags" sounds like other flags will be 
ignored if KVM_DEBUGREG_AUTO_SWITCHED_GUEST is set.
But the code below doesn't align with it.

>    TDX-SEAM unconditionally saves and
> restores guest DRs and reset to architectural INIT state on TD exit.
> So, KVM needs to save host DRs before TD enter without restoring guest DRs
> and restore host DRs after TD exit.
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
> index 3ab85c3d86ee..a9df898c6fbd 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -610,8 +610,14 @@ struct kvm_pmu {
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
> index 7aa9188f384d..ab7403a19c5d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -586,6 +586,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   
>   	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
>   
> +	vcpu->arch.switch_db_regs = KVM_DEBUGREG_AUTO_SWITCH;
>   	vcpu->arch.cr0_guest_owned_bits = -1ul;
>   	vcpu->arch.cr4_guest_owned_bits = -1ul;
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1b189e86a1f1..fb7597c22f31 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11013,7 +11013,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	if (vcpu->arch.guest_fpu.xfd_err)
>   		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
>   
> -	if (unlikely(vcpu->arch.switch_db_regs)) {
> +	if (unlikely(vcpu->arch.switch_db_regs & ~KVM_DEBUGREG_AUTO_SWITCH)) {
>   		set_debugreg(0, 7);
>   		set_debugreg(vcpu->arch.eff_db[0], 0);
>   		set_debugreg(vcpu->arch.eff_db[1], 1);
> @@ -11059,6 +11059,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	 */
>   	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
>   		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
> +		WARN_ON(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH);
>   		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
>   		kvm_update_dr0123(vcpu);
>   		kvm_update_dr7(vcpu);
> @@ -11071,8 +11072,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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

According to TDX module 1.5 ABI spec:
DR0-3, DR6 and DR7 are set to their architectural INIT value, why is 
only DR7 restored?


I found a discussion about it in
https://lore.kernel.org/kvm/Yk4iChT2sbtzSb8h@google.com/

Sean mentioned:
"
The TDX module context switches the guest _and_ host debug registers.  
It restores
the host DRs because it needs to write _something_ to hide guest state, 
so it might
as well restore the host values.  The above was an optmization to avoid 
rewriting
all debug registers.
"

I have question on "so it might as well restore the host values".
Was it a guess/assumption or it was the fact?



> +	}
>   
>   	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
>   	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());


