Return-Path: <kvm+bounces-70800-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mE6iHLefi2kKXQAAu9opvQ
	(envelope-from <kvm+bounces-70800-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 22:14:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB0E911F54C
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 22:14:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3DB1C300E5BB
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08B83382E5;
	Tue, 10 Feb 2026 21:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EfAiVoF0"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B25E283C93
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 21:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770758066; cv=none; b=RD9/YJLAnlgFUYAUu8sPD5I4NusiF1SjhBMzaVTa4BnzafUyf4sFxVL2ZDLKC7jfehjT0N9qMHHGPW6fsewgSqLiqtJSXlLRfBYpBnUYDkr1fPCcOiLF/swmw0MShdjBkZgETI1ZtEUJoKSwI1ACYVEp07j47V8NOA5SB/RuQtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770758066; c=relaxed/simple;
	bh=qO92ZMhArGYgyGIX4QpgjDk76nDRI10pvEdc/CMH+9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nqE6fLVCkaiy6sxc+kxd1/RUYjyuOUay2e4nAWJhOCyHBXSsVP87uYlJGw8K1fsj3yavVBtWb2iO/smmXTRnc2YNoTnNlkVr12q8CA0aq7M1a6/+CjLfwMQbjTXLP9BKh5u2L1ik/3mM6HSOSVlGOZZkqxBRljVNrlz+c+0wGDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EfAiVoF0; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 10 Feb 2026 21:14:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770758061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZD2QQlyuCd2R95LSt20FsvwjTTPGfL3ZMei1mP3UCQo=;
	b=EfAiVoF0YsIrmUMeIEQ4F23T5zYuZ3JgZsJzg7evmEIDwro+6Gt/Ek/AVgXIvNvbb+tWXq
	tcVUMs1ahbmZEVXkgXRqeV6eLO6eJ0/QgAqcClGHEUOcYCtBZvI4B+PcNjpowmp2FwPpNV
	I4FwRpo0U7SYl1+aWjZ5WIF5SR+f3JA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Josh Hilke <jrhilke@google.com>
Subject: Re: [PATCH v2] Introduce KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC
Message-ID: <cjmbfd5uexxzqzfzzwpgbehpyv7iqz6du4wfvwqnrenwlaaujs@42fhftddlgyx>
References: <20260205231537.1278753-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205231537.1278753-1-jmattson@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_FROM(0.00)[bounces-70800-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CB0E911F54C
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 03:15:26PM -0800, Jim Mattson wrote:
> Add KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC to allow L1 to set FREEZE_IN_SMM
> in vmcs12's GUEST_IA32_DEBUGCTL field, as permitted prior to
> commit 6b1dd26544d0 ("KVM: VMX: Preserve host's DEBUGCTLMSR_FREEZE_IN_SMM
> while running the guest").  The quirk is enabled by default for backwards
> compatibility; userspace can disable it via KVM_CAP_DISABLE_QUIRKS2 for
> consistency with the constraints on WRMSR(IA32_DEBUGCTL).
> 
> Note that the quirk only bypasses the consistency check. The vmcs02 bit is
> still owned by the host, and PMCs are not frozen during virtualized SMM.
> In particular, if a host administrator decides that PMCs should not be
> frozen during physical SMM, then L1 has no say in the matter.
> 
> Fixes: 095686e6fcb4 ("KVM: nVMX: Check vmcs12->guest_ia32_debugctl on nested VM-Enter")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  Documentation/virt/kvm/api.rst  | 10 ++++++++++
>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/vmx/nested.c       | 23 +++++++++++++++++++----
>  4 files changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index d04b4bdd60c1..325e565ff99e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8482,6 +8482,16 @@ KVM_X86_QUIRK_IGNORE_GUEST_PAT      By default, on Intel platforms, KVM ignores
>                                      guest software, for example if it does not
>                                      expose a bochs graphics device (which is
>                                      known to have had a buggy driver).
> +
> +KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC
> +				    By default, KVM relaxes the consistency
> +				    check for GUEST_IA32_DEBUGCTL in vmcb12

vmcs12*

> +				    to allow FREEZE_IN_SMM to be set.  When
> +				    this quirk is disabled, KVM requires
> +				    this bit to be cleared.  Note that the
> +				    vmcs02 bit is still completely
> +				    controlled by the host, regardless of
> +				    the quirk setting.
>  =================================== ============================================
>  
>  7.32 KVM_CAP_MAX_VCPU_ID
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ff07c45e3c73..1669d4797f0b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2485,7 +2485,8 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
>  	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS |	\
>  	 KVM_X86_QUIRK_SLOT_ZAP_ALL |		\
>  	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS |	\
> -	 KVM_X86_QUIRK_IGNORE_GUEST_PAT)
> +	 KVM_X86_QUIRK_IGNORE_GUEST_PAT |	\
> +	 KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC)
>  
>  #define KVM_X86_CONDITIONAL_QUIRKS		\
>  	(KVM_X86_QUIRK_CD_NW_CLEARED |		\
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 846a63215ce1..76128958bbca 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -476,6 +476,7 @@ struct kvm_sync_regs {
>  #define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
>  #define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
>  #define KVM_X86_QUIRK_IGNORE_GUEST_PAT		(1 << 9)
> +#define KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC	(1 << 10)
>  
>  #define KVM_STATE_NESTED_FORMAT_VMX	0
>  #define KVM_STATE_NESTED_FORMAT_SVM	1
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 248635da6766..9bd29b9375fb 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3300,10 +3300,25 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>  	if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_cr0 & X86_CR0_WP)))
>  		return -EINVAL;
>  
> -	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
> -	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> -	     CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl, false))))
> -		return -EINVAL;
> +	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) {
> +		u64 debugctl = vmcs12->guest_ia32_debugctl;
> +
> +		/*
> +		 * FREEZE_IN_SMM is not virtualized, but allow L1 to set it
> +		 * in VMCB12's DEBUGCTL under a quirk for backwards

VMCS12's

> +		 * compatibility.  Note that the quirk only relaxes the
> +		 * consistency check. The vmcb02 bit is still under the

vmcs02

> +		 * control of the host. In particular, if a host
> +		 * administrator decides to clear the bit, then L1 has no
> +		 * say in the matter.
> +		 */
> +		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC))
> +			debugctl &= ~DEBUGCTLMSR_FREEZE_IN_SMM;
> +
> +		if (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> +		    CC(!vmx_is_valid_debugctl(vcpu, debugctl, false)))
> +			return -EINVAL;
> +	}
>  
>  	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
>  	    CC(!kvm_pat_valid(vmcs12->guest_ia32_pat)))
> 
> base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a
> -- 
> 2.53.0.rc2.204.g2597b5adb4-goog
> 

