Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E1F46ECFB
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 17:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241137AbhLIQZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 11:25:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235727AbhLIQZo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 11:25:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639066930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iwmZYCGbP/jADm04FR44Y9XD4KIBUOm4ZHFvPZTR7F4=;
        b=B/MOUGc7psPgkXLJ9yfckP/Dx3rLDlluHWXxPm1P7UOLbQJiUD2uvtlq93UY3vH+LiiiXb
        io1dlo+JGKTuqWC5vGIotQxEQBWZczhUU4OUOHY+CbU9ue9BZj6oQbn4VL4CYOUQksLt6p
        fTeHrOJ7o6Hv6Ud4bpTOjQoWggY4yUA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-m5AGQdacOhusyb5juK3XEQ-1; Thu, 09 Dec 2021 11:22:06 -0500
X-MC-Unique: m5AGQdacOhusyb5juK3XEQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 174F9760D5;
        Thu,  9 Dec 2021 16:22:01 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA1077A227;
        Thu,  9 Dec 2021 16:21:34 +0000 (UTC)
Message-ID: <b112cb0271fe8eada64639eb1d634effc34f87de.camel@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: Always set kvm_run->if_flag
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Marc Orr <marcorr@google.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, thomas.lendacky@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 09 Dec 2021 18:21:33 +0200
In-Reply-To: <20211209155257.128747-1-marcorr@google.com>
References: <20211209155257.128747-1-marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-09 at 07:52 -0800, Marc Orr wrote:
> The kvm_run struct's if_flag is a part of the userspace/kernel API. The
> SEV-ES patches failed to set this flag because it's no longer needed by
> QEMU (according to the comment in the source code). However, other
> hypervisors may make use of this flag. Therefore, set the flag for
> guests with encrypted registers (i.e., with guest_state_protected set).
> 
> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
> v1 -> v2
> - fix typos in commit message
> - fix `svm_get_if_flag()` to work for non-SEV
> - remove !! in return for both [svm|vmx]_get_if_flag()
> - refactor `svm_interrupt_blocked()` to use `svm_get_if_flag()` arch/x86/include/asm/kvm-x86-ops.h |  1 +
> 
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/svm/svm.c             | 21 ++++++++++++---------
>  arch/x86/kvm/vmx/vmx.c             |  6 ++++++
>  arch/x86/kvm/x86.c                 |  9 +--------
>  5 files changed, 21 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index cefe1d81e2e8..9e50da3ed01a 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -47,6 +47,7 @@ KVM_X86_OP(set_dr7)
>  KVM_X86_OP(cache_reg)
>  KVM_X86_OP(get_rflags)
>  KVM_X86_OP(set_rflags)
> +KVM_X86_OP(get_if_flag)
>  KVM_X86_OP(tlb_flush_all)
>  KVM_X86_OP(tlb_flush_current)
>  KVM_X86_OP_NULL(tlb_remote_flush)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 860ed500580c..a7f868ff23e7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1349,6 +1349,7 @@ struct kvm_x86_ops {
>  	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
>  	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
>  	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
> +	bool (*get_if_flag)(struct kvm_vcpu *vcpu);
>  
>  	void (*tlb_flush_all)(struct kvm_vcpu *vcpu);
>  	void (*tlb_flush_current)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d0f68d11ec70..5151efa424ac 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1585,6 +1585,15 @@ static void svm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>  	to_svm(vcpu)->vmcb->save.rflags = rflags;
>  }
>  
> +static bool svm_get_if_flag(struct kvm_vcpu *vcpu)
> +{
> +	struct vmcb *vmcb = to_svm(vcpu)->vmcb;
> +
> +	return sev_es_guest(vcpu->kvm)
> +		? vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK
> +		: kvm_get_rflags(vcpu) & X86_EFLAGS_IF;
> +}
> +
>  static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>  {
>  	switch (reg) {
> @@ -3568,14 +3577,7 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>  	if (!gif_set(svm))
>  		return true;
>  
> -	if (sev_es_guest(vcpu->kvm)) {
> -		/*
> -		 * SEV-ES guests to not expose RFLAGS. Use the VMCB interrupt mask
> -		 * bit to determine the state of the IF flag.
> -		 */
> -		if (!(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK))
> -			return true;
> -	} else if (is_guest_mode(vcpu)) {
> +	if (is_guest_mode(vcpu)) {
>  		/* As long as interrupts are being delivered...  */
>  		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
>  		    ? !(svm->vmcb01.ptr->save.rflags & X86_EFLAGS_IF)
> @@ -3586,7 +3588,7 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>  		if (nested_exit_on_intr(svm))
>  			return false;
>  	} else {
> -		if (!(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
> +		if (!svm_get_if_flag(vcpu))
>  			return true;
>  	}
>  
> @@ -4621,6 +4623,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.cache_reg = svm_cache_reg,
>  	.get_rflags = svm_get_rflags,
>  	.set_rflags = svm_set_rflags,
> +	.get_if_flag = svm_get_if_flag,
>  
>  	.tlb_flush_all = svm_flush_tlb,
>  	.tlb_flush_current = svm_flush_tlb,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9453743ce0c4..269de5bb98d7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1363,6 +1363,11 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>  		vmx->emulation_required = vmx_emulation_required(vcpu);
>  }
>  
> +static bool vmx_get_if_flag(struct kvm_vcpu *vcpu)
> +{
> +	return vmx_get_rflags(vcpu) & X86_EFLAGS_IF;
> +}
> +
>  u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)
>  {
>  	u32 interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
> @@ -7575,6 +7580,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.cache_reg = vmx_cache_reg,
>  	.get_rflags = vmx_get_rflags,
>  	.set_rflags = vmx_set_rflags,
> +	.get_if_flag = vmx_get_if_flag,
>  
>  	.tlb_flush_all = vmx_flush_tlb_all,
>  	.tlb_flush_current = vmx_flush_tlb_current,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0aa4dd53c7f..45e836db5bcd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8995,14 +8995,7 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_run *kvm_run = vcpu->run;
>  
> -	/*
> -	 * if_flag is obsolete and useless, so do not bother
> -	 * setting it for SEV-ES guests.  Userspace can just
> -	 * use kvm_run->ready_for_interrupt_injection.
> -	 */
> -	kvm_run->if_flag = !vcpu->arch.guest_state_protected
> -		&& (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
> -
> +	kvm_run->if_flag = static_call(kvm_x86_get_if_flag)(vcpu);
>  	kvm_run->cr8 = kvm_get_cr8(vcpu);
>  	kvm_run->apic_base = kvm_get_apic_base(vcpu);
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

