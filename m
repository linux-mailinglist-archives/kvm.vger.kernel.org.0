Return-Path: <kvm+bounces-58355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA97FB8F2E8
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 08:41:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7012E3B362E
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 06:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF522ED842;
	Mon, 22 Sep 2025 06:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LYvJt2/M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CDB3208;
	Mon, 22 Sep 2025 06:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758523298; cv=none; b=JxCWSVN0vX8IKpfPwjMN1g3z8RN7Odq/H/hHNik577JP9Krz0e53jqXjRQZET1rhXAdHjze53yppceIT4LWHfju2ScIPQFgR6gLamLn0oCu0O79j28ssU4+v/PE5oTJXMKY6mjFB/aUh5IH1uepGIqtfsH9AT/98wEq+KbAGFBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758523298; c=relaxed/simple;
	bh=/1mBcuHbE2jw/RoGLulYID0i8648nuLW1Xsf+g4of08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HZuOe+hoegpWSNecbQUgg48cRoz/Pf/yPuWCtu6uiGzRP5RlFD0gcWaHO6ifzJpog85cZ7g5IboBlQI8M+z7daZOHcrP2jX843dsZdT6Hi8+oACAjC8TSECJ8bNYLmxZkIoA05uskGDrUOzRG9f/R8IlKbJxavLUwZxE51p/MfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LYvJt2/M; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758523295; x=1790059295;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/1mBcuHbE2jw/RoGLulYID0i8648nuLW1Xsf+g4of08=;
  b=LYvJt2/M5bnBLZtdDJ4tdxAguECK82vVGF9EuCaVwuRD4mtbuwiY5kFV
   mvFZTTLJC8V858VbD4Vv3l5nh6sYG+Zaxhm6Tuu2aid+a6JZh17i9+vvk
   gM4y0VUMdn9qKs6kg1Ih5i42SkPP1BlKW/70Xt7eZJxchW5KE0SSMa2MX
   fM+OXX2+RdoRbaEjyO4XBhhc7CF3vUUGXmhpqAzU0h+X/PwYd5yRYCXnB
   qJG9JzNxUnPuqJ0N+7VMIEhUl36kqoRLRrkeX1H+DCBO5sZv4MeTeoAsx
   lj6lbMcktjzTXQRtOizSqnJ6y0UC3ulf0Tyo6v+Yd0Jn/eDGV6CHEUyDF
   w==;
X-CSE-ConnectionGUID: P1K3ZZjoTGaPay7o1rpCpA==
X-CSE-MsgGUID: 184MosPXRgOqRBeTJ0SpqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="72142751"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="72142751"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 23:41:35 -0700
X-CSE-ConnectionGUID: O12RcnlBTSKVS6Q/gtIJcQ==
X-CSE-MsgGUID: mly9smksTKSBxXD5kuj1QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="177189397"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 23:41:32 -0700
Message-ID: <b89600a2-c3ae-4bb6-8c91-ea9a1dd507fb@linux.intel.com>
Date: Mon, 22 Sep 2025 14:41:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 19/51] KVM: x86: Don't emulate task switches when IBT
 or SHSTK is enabled
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-20-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-20-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Exit to userspace with KVM_INTERNAL_ERROR_EMULATION if the guest triggers
> task switch emulation with Indirect Branch Tracking or Shadow Stacks
> enabled,

The code just does it when shadow stack is enabled.

> as attempting to do the right thing would require non-trivial
> effort and complexity, KVM doesn't support emulating CET generally, and
> it's extremely unlikely that any guest will do task switches while also
> utilizing CET.  Defer taking on the complexity until someone cares enough
> to put in the time and effort to add support.
>
> Per the SDM:
>
>    If shadow stack is enabled, then the SSP of the task is located at the
>    4 bytes at offset 104 in the 32-bit TSS and is used by the processor to
>    establish the SSP when a task switch occurs from a task associated with
>    this TSS. Note that the processor does not write the SSP of the task
>    initiating the task switch to the TSS of that task, and instead the SSP
>    of the previous task is pushed onto the shadow stack of the new task.
>
> Note, per the SDM's pseudocode on TASK SWITCHING, IBT state for the new
> privilege level is updated.  To keep things simple, check both S_CET and
> U_CET (again, anyone that wants more precise checking can have the honor
> of implementing support).
>
> Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
> Closes: https://lore.kernel.org/all/819bd98b-2a60-4107-8e13-41f1e4c706b1@linux.intel.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 35 ++++++++++++++++++++++++++++-------
>   1 file changed, 28 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d2cccc7594d4..0c060e506f9d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12178,6 +12178,25 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
>   	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>   	int ret;
>   
> +	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_CET)) {
> +		u64 u_cet, s_cet;
> +
> +		/*
> +		 * Check both User and Supervisor on task switches as inter-
> +		 * privilege level task switches are impacted by CET at both
> +		 * the current privilege level and the new privilege level, and
> +		 * that information is not known at this time.  The expectation
> +		 * is that the guest won't require emulation of task switches
> +		 * while using IBT or Shadow Stacks.
> +		 */
> +		if (__kvm_emulate_msr_read(vcpu, MSR_IA32_U_CET, &u_cet) ||
> +		    __kvm_emulate_msr_read(vcpu, MSR_IA32_S_CET, &s_cet))
> +			return EMULATION_FAILED;
> +
> +		if ((u_cet | s_cet) & CET_SHSTK_EN)
> +			goto unhandled_task_switch;
> +	}
> +
>   	init_emulate_ctxt(vcpu);
>   
>   	ret = emulator_task_switch(ctxt, tss_selector, idt_index, reason,
> @@ -12187,17 +12206,19 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
>   	 * Report an error userspace if MMIO is needed, as KVM doesn't support
>   	 * MMIO during a task switch (or any other complex operation).
>   	 */
> -	if (ret || vcpu->mmio_needed) {
> -		vcpu->mmio_needed = false;
> -		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> -		vcpu->run->internal.ndata = 0;
> -		return 0;
> -	}
> +	if (ret || vcpu->mmio_needed)
> +		goto unhandled_task_switch;
>   
>   	kvm_rip_write(vcpu, ctxt->eip);
>   	kvm_set_rflags(vcpu, ctxt->eflags);
>   	return 1;
> +
> +unhandled_task_switch:
> +	vcpu->mmio_needed = false;
> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> +	vcpu->run->internal.ndata = 0;
> +	return 0;
>   }
>   EXPORT_SYMBOL_GPL(kvm_task_switch);
>   


