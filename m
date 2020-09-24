Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D357A27711B
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 14:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgIXMeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 08:34:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727815AbgIXMeX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 08:34:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600950861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XJM2zsAmjHPtnBVFf6cltcdoLV4SPiJ7BDBnMHvxMEQ=;
        b=Ht4zUUcFI8NnJDTQiaXdh/3X6CUlFV5a65Vtih95kXxjxrUXkrCsZ2YdbvB06E1ZlJ7WOp
        F6lC+Mg4PX7wjy04WC0IECqsUscQ4aOCGfgPlkKFONkYna8xJacEj1fzJgKXpBwXQktNlY
        60fbBUQSjKIAVvBPJmmkW2w3l5KgCjs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-yFCZwm6RPBWqkAKSSjQuGg-1; Thu, 24 Sep 2020 08:34:19 -0400
X-MC-Unique: yFCZwm6RPBWqkAKSSjQuGg-1
Received: by mail-ej1-f69.google.com with SMTP id r14so1246290ejb.3
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 05:34:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XJM2zsAmjHPtnBVFf6cltcdoLV4SPiJ7BDBnMHvxMEQ=;
        b=nNahWxhab8kqAi2X9TdkJ5nAUaSX4YI3jagPVlJdyi/fr8SnG72zN3V8ks7+zDNKHX
         dw3c/Gb0kBqqIXxq2+GuXzojg2wxeHPkqKLM49s/4VAoJc+9jmb0kXFFNPl6LhEBhmPp
         4ALk3DRE2qjaQZ1t74piWuDNqFfbWTaFdO8uyyQ/J4WOnT1/+yqLzSErqdGhDoXfxWQ6
         zGLZILv4QuP2pImZaIQrqoQLI0/yHluuvXa8OSy7u8PCcEVgGtLZ76T8phPGgnMaO58M
         q3ojiXguq5/iyJ/nuNdKB4ID1GY+zE31PN6VoELGS58GHo3WGR1WrUdkATkpQSZow5Zt
         89uw==
X-Gm-Message-State: AOAM530Rt83wFjDBXDu8CRU3xrC7b4vBaj58j3WrJrJ5tBKcSdHsmTwg
        AIAr3SvR7HyXGUw6RQ+qLwEqCUCDTTkNaC8zKsU9gqFa+c3WLgrWZY294WvJgznEgxTRDgIpFCN
        FvWvnF7jcwk43
X-Received: by 2002:a05:6402:1148:: with SMTP id g8mr775011edw.271.1600950857413;
        Thu, 24 Sep 2020 05:34:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9aag4YDAgIGYQ9EHrDOFNyx4QU0hniTeVNf02iQ7RJLkNK/cPK0RyizBQjwquCkPtgxllpw==
X-Received: by 2002:a05:6402:1148:: with SMTP id g8mr774981edw.271.1600950857170;
        Thu, 24 Sep 2020 05:34:17 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t3sm2383180edv.59.2020.09.24.05.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 05:34:15 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [RFC PATCH 3/3] KVM: x86: Use KVM_BUG/KVM_BUG_ON to handle bugs that are fatal to the VM
In-Reply-To: <20200923224530.17735-4-sean.j.christopherson@intel.com>
References: <20200923224530.17735-1-sean.j.christopherson@intel.com> <20200923224530.17735-4-sean.j.christopherson@intel.com>
Date:   Thu, 24 Sep 2020 14:34:14 +0200
Message-ID: <878scze4l5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Add support for KVM_REQ_VM_BUGG in x86, and replace a variety of WARNs
> with KVM_BUG() and KVM_BUG_ON().  Return -EIO if a KVM_BUG is hit to
> align with the common KVM behavior of rejecting iocts() with -EIO if the
> VM is bugged.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/svm/svm.c |  2 +-
>  arch/x86/kvm/vmx/vmx.c | 23 ++++++++++++++---------
>  arch/x86/kvm/x86.c     |  4 ++++
>  3 files changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3da5b2f1b4a1..e684794c6249 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1380,7 +1380,7 @@ static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>  		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
>  		break;
>  	default:
> -		WARN_ON_ONCE(1);
> +		KVM_BUG_ON(1, vcpu->kvm);
>  	}
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6f9a0c6d5dc5..810d46ab0a47 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2250,7 +2250,7 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>  		vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & guest_owned_bits;
>  		break;
>  	default:
> -		WARN_ON_ONCE(1);
> +		KVM_BUG_ON(1, vcpu->kvm);
>  		break;
>  	}
>  }
> @@ -4960,6 +4960,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
>  			return kvm_complete_insn_gp(vcpu, err);
>  		case 3:
>  			WARN_ON_ONCE(enable_unrestricted_guest);
> +
>  			err = kvm_set_cr3(vcpu, val);
>  			return kvm_complete_insn_gp(vcpu, err);
>  		case 4:
> @@ -4985,14 +4986,13 @@ static int handle_cr(struct kvm_vcpu *vcpu)
>  		}
>  		break;
>  	case 2: /* clts */
> -		WARN_ONCE(1, "Guest should always own CR0.TS");
> -		vmx_set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~X86_CR0_TS));
> -		trace_kvm_cr_write(0, kvm_read_cr0(vcpu));
> -		return kvm_skip_emulated_instruction(vcpu);
> +		KVM_BUG(1, vcpu->kvm, "Guest always owns CR0.TS");
> +		return -EIO;
>  	case 1: /*mov from cr*/
>  		switch (cr) {
>  		case 3:
>  			WARN_ON_ONCE(enable_unrestricted_guest);
> +

Here, were you intended to replace WARN_ON_ONCE() with KVM_BUG_ON() or
this is just a stray newline added?

>  			val = kvm_read_cr3(vcpu);
>  			kvm_register_write(vcpu, reg, val);
>  			trace_kvm_cr_read(cr, val);
> @@ -5330,7 +5330,9 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
>  
>  static int handle_nmi_window(struct kvm_vcpu *vcpu)
>  {
> -	WARN_ON_ONCE(!enable_vnmi);
> +	if (KVM_BUG_ON(!enable_vnmi, vcpu->kvm))
> +		return -EIO;
> +
>  	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);
>  	++vcpu->stat.nmi_window_exits;
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
> @@ -5908,7 +5910,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	 * below) should never happen as that means we incorrectly allowed a
>  	 * nested VM-Enter with an invalid vmcs12.
>  	 */
> -	WARN_ON_ONCE(vmx->nested.nested_run_pending);
> +	if (KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm))
> +		return -EIO;
>  
>  	/* If guest state is invalid, start emulating */
>  	if (vmx->emulation_required)
> @@ -6258,7 +6261,9 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
>  	int max_irr;
>  	bool max_irr_updated;
>  
> -	WARN_ON(!vcpu->arch.apicv_active);
> +	if (KVM_BUG_ON(!vcpu->arch.apicv_active, vcpu->kvm))
> +		return -EIO;
> +
>  	if (pi_test_on(&vmx->pi_desc)) {
>  		pi_clear_on(&vmx->pi_desc);
>  		/*
> @@ -6345,7 +6350,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  	gate_desc *desc;
>  	u32 intr_info = vmx_get_intr_info(vcpu);
>  
> -	if (WARN_ONCE(!is_external_intr(intr_info),
> +	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
>  	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
>  		return;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 17f4995e80a7..672eb5142b34 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8363,6 +8363,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	bool req_immediate_exit = false;
>  
>  	if (kvm_request_pending(vcpu)) {
> +		if (kvm_check_request(KVM_REQ_VM_BUGGED, vcpu)) {

Do we want to allow userspace to continue executing the guest or should
we make KVM_REQ_VM_BUGGED permanent by replacing kvm_check_request()
with kvm_test_request()?

> +			r = -EIO;
> +			goto out;
> +		}
>  		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
>  			if (unlikely(!kvm_x86_ops.nested_ops->get_vmcs12_pages(vcpu))) {
>  				r = 0;

-- 
Vitaly

