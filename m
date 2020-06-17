Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61531FCCD8
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 13:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgFQL4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 07:56:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35757 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726558AbgFQL4N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 07:56:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592394970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DrKJT2s3bUdWnzLFBfBTky/5kjFEtfKokxByL0U1MXc=;
        b=aPuhsoH3GQw1GUeStbYukvb2eBy4vJG7h8VXXiEfpVjZ+Rc3DxoSaxyeunA/hlDaH0injs
        lqYi4w2BsScm2ejqr0mWxlvA7mJosG+if/2yy61JUq90AftMx6M7WVLZlSMJg86HbAdzE6
        ASQxTrefIUVe/GK5YVZPf9EjobICmfI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473--VVnrQiCNbeFZgKYPiBvew-1; Wed, 17 Jun 2020 07:56:09 -0400
X-MC-Unique: -VVnrQiCNbeFZgKYPiBvew-1
Received: by mail-ej1-f72.google.com with SMTP id op14so915272ejb.15
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 04:56:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DrKJT2s3bUdWnzLFBfBTky/5kjFEtfKokxByL0U1MXc=;
        b=tzck93131Z7Zcg6m/mBPFebaQK7JIkuYud84kBXacXu/2GMxnhvzVVI9SyXHjnEVrm
         50yAXCbbcNFKhx4aMF/kyKzjaNxKV7gR7JBJXTnvquMKgQ/vQUbBLI9kEOYb1KYqMmyM
         FpiJbc/mu5VQSkNpQPeNIY2otxPwkgsQ23MgF35xXRUJ/SbZesowLZ5HtuAqvuHTWEup
         XRTKYuk2F7VsgzZXQVMTYVJc9EEgfiF+DHX7Go2erokTZbjUgHGwtoGPaNAJFG3DyKER
         lfyMllChhGpEh0W0EaMgoIPq3/BemHgYawhypnyREFXCu5U1yaPsBO5hu+qfaxaI+vhn
         P5sw==
X-Gm-Message-State: AOAM532QeK4MRKcGjf11MJgV3alLlKRHGlzA4dliLzfs48UB2yREYnci
        XdVf9CUF6a6hlZe6ETLswY/gSWm0qCmh0I66R6j1hi95LfVZMI0HQ7AF+bFrtcKmFps3Cn5Pqet
        MHlDIvyXXD9Dm
X-Received: by 2002:a17:906:b80d:: with SMTP id dv13mr1922654ejb.428.1592394967831;
        Wed, 17 Jun 2020 04:56:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwU9N1pAmlWVvFA0KdYaO5rBhYhPzQIV23EoUU4jIE2FcmubZoVpk0UiLcFkXzYWBwqXzVlhg==
X-Received: by 2002:a17:906:b80d:: with SMTP id dv13mr1922623ejb.428.1592394967579;
        Wed, 17 Jun 2020 04:56:07 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b11sm13205979eju.91.2020.06.17.04.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 04:56:06 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wanpengli@tencent.com, joro@8bytes.org, x86@kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, tglx@linutronix.de,
        jmattson@google.com
Subject: Re: [PATCH v2 1/3] KVM: X86: Move handling of INVPCID types to x86
In-Reply-To: <159234501692.6230.5105866433978454983.stgit@bmoger-ubuntu>
References: <159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu> <159234501692.6230.5105866433978454983.stgit@bmoger-ubuntu>
Date:   Wed, 17 Jun 2020 13:56:05 +0200
Message-ID: <87tuz9hpnu.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Babu Moger <babu.moger@amd.com> writes:

> INVPCID instruction handling is mostly same across both VMX and
> SVM. So, move the code to common x86.c.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/kvm/vmx/vmx.c |   68 +----------------------------------------
>  arch/x86/kvm/x86.c     |   79 ++++++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.h     |    3 +-
>  3 files changed, 82 insertions(+), 68 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 170cc76a581f..b4140cfd15fd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5477,11 +5477,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
>  {
>  	u32 vmx_instruction_info;
>  	unsigned long type;
> -	bool pcid_enabled;
>  	gva_t gva;
> -	struct x86_exception e;
> -	unsigned i;
> -	unsigned long roots_to_free = 0;
>  	struct {
>  		u64 pcid;
>  		u64 gla;
> @@ -5508,69 +5504,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
>  				sizeof(operand), &gva))
>  		return 1;
>  
> -	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
> -		kvm_inject_emulated_page_fault(vcpu, &e);
> -		return 1;
> -	}
> -
> -	if (operand.pcid >> 12 != 0) {
> -		kvm_inject_gp(vcpu, 0);
> -		return 1;
> -	}
> -
> -	pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> -
> -	switch (type) {
> -	case INVPCID_TYPE_INDIV_ADDR:
> -		if ((!pcid_enabled && (operand.pcid != 0)) ||
> -		    is_noncanonical_address(operand.gla, vcpu)) {
> -			kvm_inject_gp(vcpu, 0);
> -			return 1;
> -		}
> -		kvm_mmu_invpcid_gva(vcpu, operand.gla, operand.pcid);
> -		return kvm_skip_emulated_instruction(vcpu);
> -
> -	case INVPCID_TYPE_SINGLE_CTXT:
> -		if (!pcid_enabled && (operand.pcid != 0)) {
> -			kvm_inject_gp(vcpu, 0);
> -			return 1;
> -		}
> -
> -		if (kvm_get_active_pcid(vcpu) == operand.pcid) {
> -			kvm_mmu_sync_roots(vcpu);
> -			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> -		}
> -
> -		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> -			if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].pgd)
> -			    == operand.pcid)
> -				roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
> -
> -		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
> -		/*
> -		 * If neither the current cr3 nor any of the prev_roots use the
> -		 * given PCID, then nothing needs to be done here because a
> -		 * resync will happen anyway before switching to any other CR3.
> -		 */
> -
> -		return kvm_skip_emulated_instruction(vcpu);
> -
> -	case INVPCID_TYPE_ALL_NON_GLOBAL:
> -		/*
> -		 * Currently, KVM doesn't mark global entries in the shadow
> -		 * page tables, so a non-global flush just degenerates to a
> -		 * global flush. If needed, we could optimize this later by
> -		 * keeping track of global entries in shadow page tables.
> -		 */
> -
> -		/* fall-through */
> -	case INVPCID_TYPE_ALL_INCL_GLOBAL:
> -		kvm_mmu_unload(vcpu);
> -		return kvm_skip_emulated_instruction(vcpu);
> -
> -	default:
> -		BUG(); /* We have already checked above that type <= 3 */
> -	}
> +	return kvm_handle_invpcid_types(vcpu,  gva, type);

Nit: redundant space.

>  }
>  
>  static int handle_pml_full(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9e41b5135340..9c858ca0e592 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -70,6 +70,7 @@
>  #include <asm/irq_remapping.h>
>  #include <asm/mshyperv.h>
>  #include <asm/hypervisor.h>
> +#include <asm/tlbflush.h>
>  #include <asm/intel_pt.h>
>  #include <asm/emulate_prefix.h>
>  #include <clocksource/hyperv_timer.h>
> @@ -10714,6 +10715,84 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
>  
> +int kvm_handle_invpcid_types(struct kvm_vcpu *vcpu, gva_t gva,
> +			     unsigned long type)

(sorry if this was discussed before) do we really need '_types' suffix?

> +{
> +	unsigned long roots_to_free = 0;
> +	struct x86_exception e;
> +	bool pcid_enabled;
> +	unsigned int i;
> +	struct {
> +		u64 pcid;
> +		u64 gla;
> +	} operand;
> +
> +	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
> +		kvm_inject_emulated_page_fault(vcpu, &e);
> +		return 1;
> +	}
> +
> +	if (operand.pcid >> 12 != 0) {
> +		kvm_inject_gp(vcpu, 0);
> +		return 1;
> +	}
> +
> +	pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> +
> +	switch (type) {
> +	case INVPCID_TYPE_INDIV_ADDR:
> +		if ((!pcid_enabled && (operand.pcid != 0)) ||
> +		    is_noncanonical_address(operand.gla, vcpu)) {
> +			kvm_inject_gp(vcpu, 0);
> +			return 1;
> +		}
> +		kvm_mmu_invpcid_gva(vcpu, operand.gla, operand.pcid);
> +		return kvm_skip_emulated_instruction(vcpu);
> +
> +	case INVPCID_TYPE_SINGLE_CTXT:
> +		if (!pcid_enabled && (operand.pcid != 0)) {
> +			kvm_inject_gp(vcpu, 0);
> +			return 1;
> +		}
> +
> +		if (kvm_get_active_pcid(vcpu) == operand.pcid) {
> +			kvm_mmu_sync_roots(vcpu);
> +			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> +		}
> +
> +		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> +			if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].pgd)
> +			    == operand.pcid)
> +				roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
> +
> +		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
> +		/*
> +		 * If neither the current cr3 nor any of the prev_roots use the
> +		 * given PCID, then nothing needs to be done here because a
> +		 * resync will happen anyway before switching to any other CR3.
> +		 */
> +
> +		return kvm_skip_emulated_instruction(vcpu);
> +
> +	case INVPCID_TYPE_ALL_NON_GLOBAL:
> +		/*
> +		 * Currently, KVM doesn't mark global entries in the shadow
> +		 * page tables, so a non-global flush just degenerates to a
> +		 * global flush. If needed, we could optimize this later by
> +		 * keeping track of global entries in shadow page tables.
> +		 */
> +
> +		/* fall-through */
> +	case INVPCID_TYPE_ALL_INCL_GLOBAL:
> +		kvm_mmu_unload(vcpu);
> +		return kvm_skip_emulated_instruction(vcpu);
> +
> +	default:
> +		BUG(); /* We have already checked above that type <= 3 */

The check was left in VMX' handle_invpcid() so we either need to update
the comment to something like "the caller was supposed to check that
type <= 3" or move the check to kvm_handle_invpcid_types().

> +	}
> +}
> +EXPORT_SYMBOL_GPL(kvm_handle_invpcid_types);
> +
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 6eb62e97e59f..f706f6f7196d 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -365,5 +365,6 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
>  void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
>  u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
>  bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
> -
> +int kvm_handle_invpcid_types(struct kvm_vcpu *vcpu, gva_t gva,
> +			     unsigned long type);
>  #endif
>

-- 
Vitaly

