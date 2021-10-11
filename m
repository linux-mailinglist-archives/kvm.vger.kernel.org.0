Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C79D429819
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 22:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbhJKUZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 16:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbhJKUZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 16:25:48 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3D5C06161C
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 13:23:47 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id e7so11844044pgk.2
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 13:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aIVgOWTQV2q2xytnYhzRzP72FdeAtxxAi8QL3SVoE6U=;
        b=Zps0b75rQ08NWDQbkfAWZCIZnFZZBO+a45jWg+fO604pLd1M3qZP9x1cJiPYSVyBN5
         mToMqLhFmUbzTLAUoKlbSNqH0wWtklHy4TM/4GaVmp5HrEsz6BynDPEQvp9U1bbg3PQF
         G6SWmC4krC33eKmUNXLWSBFgASzaoOEv3CKxw/wOOMnSeElhcprRjb2vrlFjN1rnCxGF
         F2kaJVNbkrC24NQe4VEGwbKwv99bpL/Gy6LVCepOprOXj+CYYfavQnpv6IFflsyZ3fFB
         VCBt7CH/gPB3pVuUp8+5ktpju91msMkrjm9Kteo1vxxVe26jRj/y9cfOkXGS4ed0dp31
         cqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aIVgOWTQV2q2xytnYhzRzP72FdeAtxxAi8QL3SVoE6U=;
        b=2WLmwtkrwZJiXHclQishqQtzXfPg2IWpRd9diR81eD3bCdf1H4Esad50x6Zl9yJrvV
         69EmMSTjKyzkWiGbnKKo3r361w1ZTvRt6AjiVML+9s6CHFOo5WL8hR7m6eviy48/JLaN
         IxCC0gfuZsfs9D3evE4ApL61e4PnW7dj7Fnd3dtrYXuZNDywvXWNftMIvNWH1B0KJtJt
         AaAPyqJ8al6YmFnD9b3p5cxOy8rkyct1sY/mS+P8df7+8gY9mSmUOk6aY14c20bmUph2
         Fi9YM9w7AJkn+y+MxMW6NpKMkdLl69e8ENm9JyVkTto/4mclmMl+5GzPj2S9H58s8MI+
         wqiA==
X-Gm-Message-State: AOAM531MOaH1kEAk4vSfDW8EeqpTNfUJPbyjK5kMflctE/z5Qjonhn+E
        HylO4azjY5GZsnJm5zJHQfJG5LhIThOKrQ==
X-Google-Smtp-Source: ABdhPJy019Z5jxKOSsaxG2mUCC6jvfqMPi6oHE53lGwfwiXjVnZkpgQo5DQKMsHc03KDgikpPndfNw==
X-Received: by 2002:a63:564a:: with SMTP id g10mr19730395pgm.199.1633983826925;
        Mon, 11 Oct 2021 13:23:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l10sm8446000pff.119.2021.10.11.13.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 13:23:46 -0700 (PDT)
Date:   Mon, 11 Oct 2021 20:23:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: Add a wrapper for reading
 INVPCID/INVEPT/INVVPID type
Message-ID: <YWSdTpkzNt3nppBc@google.com>
References: <20211011194615.2955791-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011194615.2955791-1-vipinsh@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 11, 2021, Vipin Sharma wrote:
> Add a common helper function to read invalidation type specified by a
> trapped INVPCID/INVEPT/INVVPID instruction.
> 
> Add a symbol constant for max INVPCID type.
> 
> No functional change intended.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/include/asm/invpcid.h |  1 +
>  arch/x86/kvm/vmx/nested.c      |  4 ++--
>  arch/x86/kvm/vmx/vmx.c         |  4 ++--
>  arch/x86/kvm/vmx/vmx.h         | 12 ++++++++++++
>  4 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/invpcid.h b/arch/x86/include/asm/invpcid.h
> index 734482afbf81..b5ac26784c1b 100644
> --- a/arch/x86/include/asm/invpcid.h
> +++ b/arch/x86/include/asm/invpcid.h
> @@ -21,6 +21,7 @@ static inline void __invpcid(unsigned long pcid, unsigned long addr,
>  #define INVPCID_TYPE_SINGLE_CTXT	1
>  #define INVPCID_TYPE_ALL_INCL_GLOBAL	2
>  #define INVPCID_TYPE_ALL_NON_GLOBAL	3
> +#define INVPCID_TYPE_MAX		3

...

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1c8b2b6e7ed9..77f72a41dde3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5502,9 +5502,9 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
>  	}
>  
>  	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
> -	type = kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);
> +	type = vmx_read_invalidation_type(vcpu, vmx_instruction_info);

I would prefer to keep the register read visibile in this code so that it's
obvious what exactly is being read.  With this approach, it's not clear that KVM
is reading a GPR vs. VMCS vs. simply extracting "type" from "vmx_instruction_info".

And it's not just the INV* instruction, VMREAD and VMWRITE use the same encoding.

The hardest part is coming up with a name :-)  Maybe do the usually-ill-advised
approach of following the SDM verbatim?  Reg2 is common to all flavors, so this?

	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
	type = kvm_register_read(vcpu, gpr_index);

>  
> -	if (type > 3) {
> +	if (type > INVPCID_TYPE_MAX) {

Hrm, I don't love this because it's not auto-updating in the unlikely chance that
a new type is added.  I definitely don't like open coding '3' either.  What about
going with a verbose option of

	if (type != INVPCID_TYPE_INDIV_ADDR &&
	    type != INVPCID_TYPE_SINGLE_CTXT &&
	    type != INVPCID_TYPE_ALL_INCL_GLOBAL &&
	    type != INVPCID_TYPE_ALL_NON_GLOBAL) {
		kvm_inject_gp(vcpu, 0);
		return 1;
	}

It's kind of gross, but gcc10 is smart enought to coalesce those all into a single
CMP <reg>, 3; JA <#GP>, i.e. the resulting binary is identical.

>  		kvm_inject_gp(vcpu, 0);
>  		return 1;
>  	}
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 592217fd7d92..eeafcce57df7 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -522,4 +522,16 @@ static inline bool vmx_guest_state_valid(struct kvm_vcpu *vcpu)
>  
>  void dump_vmcs(struct kvm_vcpu *vcpu);
>  
> +/*
> + * When handling a VM-exit for one of INVPCID, INVEPT or INVVPID, read the type
> + * of invalidation specified by the instruction.
> + */
> +static inline unsigned long vmx_read_invalidation_type(struct kvm_vcpu *vcpu,
> +						       u32 vmx_instr_info)
> +{
> +	u32 vmx_instr_reg2 = (vmx_instr_info >> 28) & 0xf;
> +
> +	return kvm_register_read(vcpu, vmx_instr_reg2);
> +}
> +
>  #endif /* __KVM_X86_VMX_H */
> -- 
> 2.33.0.882.g93a45727a2-goog
> 
