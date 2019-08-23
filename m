Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975B39AF6C
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 14:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392653AbfHWM1m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 08:27:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387738AbfHWM1m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 08:27:42 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 66F51C05683F
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 12:27:41 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id c11so2927318wml.6
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 05:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7h0x9rgASWk8qPjUOaS/mZJRiG6RBmB84OOVjwHTOWM=;
        b=dDBcJpHUlt2GWQCVcEjpWWDrBa6C2G2rVBSVdMXjG4k8w18MmMjXunAWxlHQkWqC3s
         mjvJYD7gqsmw5uqjp8S6P7xM8PuaceiMAi/gpX3P4ruWkr11IP60PzjqwSCDFYqjzeYP
         ef+vCsvMsx+Ehq/kI5kXZ64EjYmoDQc+IZRja5nMjBVo+EDlHCxs3F6nrCUulmxGo1sd
         yvWnTQEPg4jvhldlKlErNCzOn0zY8uy1v26Ub0jzbVLV+cVskY7AkFc/Hs12h6ESmuz7
         V/NMlrsz5OUXIbxpI8zg1rLUxAHdfxUCegN8GUeMCj2hhoy3iVb+O74rw0SlkORcfKSY
         EhsQ==
X-Gm-Message-State: APjAAAUNcktwPFsbKYbNdGhRfqhtvVBluHI0B9+3xmdywZusxQzopMMK
        1AEiuM5XlwZcOxhx4fNNQt9HOpUhyzXjjYBQoNceQNMn+YIPOvtNKPuT9DmC0nFpuvYtwR+QXRN
        bFzkSr+c04I4u
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr5108337wml.175.1566563260070;
        Fri, 23 Aug 2019 05:27:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwm7PSBjTdOngOg1paE0LxSJSXRFPKcTRzm90yeu4pMk3McP3Wrxfg4UUz+GWbSSVRnQX4R9A==
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr5108313wml.175.1566563259845;
        Fri, 23 Aug 2019 05:27:39 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id r11sm2186226wrt.84.2019.08.23.05.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 05:27:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 06/13] KVM: x86: Move #GP injection for VMware into x86_emulate_instruction()
In-Reply-To: <20190823010709.24879-7-sean.j.christopherson@intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com> <20190823010709.24879-7-sean.j.christopherson@intel.com>
Date:   Fri, 23 Aug 2019 14:27:38 +0200
Message-ID: <87sgpsnk1x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Immediately inject a #GP when VMware emulation fails and return
> EMULATE_DONE instead of propagating EMULATE_FAIL up the stack.  This
> helps pave the way for removing EMULATE_FAIL altogether.
>
> Rename EMULTYPE_VMWARE to EMULTYPE_VMWARE_GP to help document why a #GP
> is injected on emulation failure.

Hm, maybe it's just me but I would've assumed _GP suffix means 'called
from #GP intercept' and not '#GP is injected on failure'. This is no
different here because we only do #GP intercepts for vmware backdoor
emulation and this emulation only happens on #GP.

>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/svm.c              |  9 ++-------
>  arch/x86/kvm/vmx/vmx.c          |  9 ++-------
>  arch/x86/kvm/x86.c              | 14 +++++++++-----
>  4 files changed, 14 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index dd6bd9ed0839..d1d5b5ca1195 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1318,7 +1318,7 @@ enum emulation_result {
>  #define EMULTYPE_TRAP_UD	    (1 << 1)
>  #define EMULTYPE_SKIP		    (1 << 2)
>  #define EMULTYPE_ALLOW_RETRY	    (1 << 3)
> -#define EMULTYPE_VMWARE		    (1 << 5)
> +#define EMULTYPE_VMWARE_GP	    (1 << 5)
>  int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
>  int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
>  					void *insn, int insn_len);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index b96a119690f4..97562c2c8b7b 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2768,7 +2768,6 @@ static int gp_interception(struct vcpu_svm *svm)
>  {
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
>  	u32 error_code = svm->vmcb->control.exit_info_1;
> -	int er;
>  
>  	WARN_ON_ONCE(!enable_vmware_backdoor);
>  
> @@ -2776,12 +2775,8 @@ static int gp_interception(struct vcpu_svm *svm)
>  		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
>  		return 1;
>  	}
> -	er = kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
> -	if (er == EMULATE_USER_EXIT)
> -		return 0;
> -	else if (er != EMULATE_DONE)
> -		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> -	return 1;
> +	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP) !=
> +						EMULATE_USER_EXIT;
>  }
>  
>  static bool is_erratum_383(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3ee0dd304bc7..25410c58c758 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4492,7 +4492,6 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  	u32 intr_info, ex_no, error_code;
>  	unsigned long cr2, rip, dr6;
>  	u32 vect_info;
> -	enum emulation_result er;
>  
>  	vect_info = vmx->idt_vectoring_info;
>  	intr_info = vmx->exit_intr_info;
> @@ -4514,12 +4513,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
>  			return 1;
>  		}
> -		er = kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
> -		if (er == EMULATE_USER_EXIT)
> -			return 0;
> -		else if (er != EMULATE_DONE)
> -			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> -		return 1;
> +		return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP) !=
> +							EMULATE_USER_EXIT;
>  	}
>  
>  	/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0f0e14d8fac..228ca71d5b01 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6210,8 +6210,10 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  	++vcpu->stat.insn_emulation_fail;
>  	trace_kvm_emulate_insn_failed(vcpu);
>  
> -	if (emulation_type & EMULTYPE_VMWARE)
> -		return EMULATE_FAIL;
> +	if (emulation_type & EMULTYPE_VMWARE_GP) {
> +		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> +		return EMULATE_DONE;
> +	}
>  
>  	kvm_queue_exception(vcpu, UD_VECTOR);
>  
> @@ -6543,9 +6545,11 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
>  		}
>  	}
>  
> -	if ((emulation_type & EMULTYPE_VMWARE) &&
> -	    !is_vmware_backdoor_opcode(ctxt))
> -		return EMULATE_FAIL;
> +	if ((emulation_type & EMULTYPE_VMWARE_GP) &&
> +	    !is_vmware_backdoor_opcode(ctxt)) {
> +		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> +		return EMULATE_DONE;
> +	}
>  
>  	if (emulation_type & EMULTYPE_SKIP) {
>  		kvm_rip_write(vcpu, ctxt->_eip);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
