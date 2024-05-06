Return-Path: <kvm+bounces-16610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBDCB8BC637
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:31:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8431E281A6C
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 03:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E13743ABC;
	Mon,  6 May 2024 03:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mSiVSy0A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CEE3B18D;
	Mon,  6 May 2024 03:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714966260; cv=none; b=gerG+rUQZKPUROikEOAYMDmMf6eYz0A0BOU6XJWiimZD+Wa7clpywzy7Fl6LavKVNgjS5nUhZMJOVQSDC2jtwZGt/o3VTwP7CedqLQZ9raE7zg4qj4MDjWOSlEnDa9baQG41oXH+YUsoSqPGvPuLAcn/e2NcPkigMfukUFhxxBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714966260; c=relaxed/simple;
	bh=m1jDuqZjVQJd5mp35z+dJbfBfD7b+J3HvypbQqd6YiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X62SevfG2TQYg0cKPhlyjmCdlffrzu40eCRQSbt6Dkz82ZxSCJAbbFrwbhl7A+4V4yKTNysNdzqnOKeBA0DE2t2Ms1IVSrCIcikyx81zqmcqvE1/+N33etPGj5S9WtL7iVhS49iTQzJWOvO3FQl6dFLu2FLkujb6jEBStLhdl0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mSiVSy0A; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714966259; x=1746502259;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m1jDuqZjVQJd5mp35z+dJbfBfD7b+J3HvypbQqd6YiQ=;
  b=mSiVSy0AcrZjc0PScf+o5JoGVCpnnQf/HNP7R2ImPJnQsomqGEMfXMph
   Q8auig0wk90Ox4PRlVHXj06aaWnsY8oUufv3DOZR/D+0P1x1PltauPwwI
   bApPvvshME0f7E+8e4XNsOxbwxYaOYd5FM4qvZWxuvE346D7pJyRtIaEb
   i4FDTda9IVHHtdpFzdcVQkjUxzHro394XU/bZ1gTOJBobm56GA2udrZy4
   poH5dI6aJu+uDyOiEmdCF05YqLpdKzh2dKcoOePuQQDusuYAQIzR6xFdV
   SwYYczct7RQC3KLUIR7EJnHHYDpIBR5Z8seoF6yVdTQie+gAsapXFsA53
   A==;
X-CSE-ConnectionGUID: 04cegmPATPmsy/mYtnmoHA==
X-CSE-MsgGUID: XwfNP4OwTR24xE1Y6P91BA==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="22102955"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="22102955"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2024 20:30:58 -0700
X-CSE-ConnectionGUID: +BBlXY+7RX+F09dTG1qV3Q==
X-CSE-MsgGUID: QMXkq63ASNuLEaYk+AU5MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="32537492"
Received: from unknown (HELO [10.238.0.220]) ([10.238.0.220])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2024 20:30:54 -0700
Message-ID: <fdf2d5fa-64dc-4429-8529-66106632a95b@linux.intel.com>
Date: Mon, 6 May 2024 11:30:52 +0800
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
 Chao Gao <chao.gao@intel.com>, Reinette Chatre <reinette.chatre@intel.com>
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
> irrespective of any other flags.  TDX-SEAM unconditionally saves and
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

As pointed by Paolo in 
https://lore.kernel.org/lkml/ea136ac6-53cf-cdc5-a741-acfb437819b1@redhat.com/
KVM_DEBUGREG_BP_ENABLED could be set in vcpu->arch.switch_db_regs,  by 
userspace
kvm_vcpu_ioctl_x86_set_debugregs()  --> kvm_update_dr7()

So it should be fixed as:

-       if (unlikely(vcpu->arch.switch_db_regs)) {
+       if (unlikely(vcpu->arch.switch_db_regs &&
+                    !(vcpu->arch.switch_db_regs & 
KVM_DEBUGREG_AUTO_SWITCH))) {


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
> +	}
>   
>   	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
>   	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());


