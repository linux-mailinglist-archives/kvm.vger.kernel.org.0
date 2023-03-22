Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914136C531C
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 18:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjCVR5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 13:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjCVR5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 13:57:36 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4E46151F
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 10:57:33 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s9-20020a634509000000b004fc1c14c9daso4940287pga.23
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 10:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679507852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t4lediYx3DEhSpQl3gzYKlvCEJbXygtbU3i/RKlqt30=;
        b=F5MCLmCiFBqbxNooctPDGa04IamkeYF3GV25R7x0cqsL1P35Zg4g6P22KPaCQrOh6b
         pq3HX7mg+vDYT5sinhzj7NwNtCG0yvrpgPC7zR6C34i/ao1bJwjVLqjhF6GlA9vm+4DL
         AbNAT4jBkpMalcOuzlXq6/Gd6QuBLL8TSSAFP9aBUtfapPNaJ1MmFAtRoK5QVCmmEjI5
         A6WXymDdd4FWmdnr/y2PBt4UUHkbXId21E3i7Lme9EiJfjQ5hf77xoq2riR4jf0swPHu
         hQkvTFP5bEOPe9dAvdMznIA5B7rG9p03QnMc8YKTgXKjSR81baj3NZVBBIYcL/gsg9it
         kbCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679507852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t4lediYx3DEhSpQl3gzYKlvCEJbXygtbU3i/RKlqt30=;
        b=1fWg8WbcG3oHtvm1CGFuLaMSDD0skHM1/hzeTFnU+nMSeoNxu2vKkaymkcrWuzM0Fd
         IyoOfnaZ+tm3c+A9m8U3o1otZDDOix+VJlm8sIKZHJSCUpy2wY22/o0dltoSbg4l0Bxa
         APSXksttCRpHBy7YpKxZ9REvl6ADKx/4sIedgVQDme81cncAhPOG96hTt6UVUSNby4kp
         CzXOGgoaLYsQhOHr3EbgEm7fb1uDsJMko0Pp0+9S8ZC/fNh5pDkBoWfvTReK1oOBoanE
         jG4nzuhqI+XHJvMbuyxfanc0EUXrkxmv+43DxsGvlKp/bVtA4HUf33XZkPUby9r+iqhG
         KJ7w==
X-Gm-Message-State: AO0yUKW4QqdpdFyUl/YOcwW01jB3uyLFHkafLodnOrIjgg6+NbkzPEdL
        hymkU2/Ui6q5jIKWKT63ru9f+3yKArQ=
X-Google-Smtp-Source: AK7set9aBAH+U8K5EnQZmw/YKPlxH4leMMWRicdjeO4dtOsambf6PkNJpKhCNrbi3NDodtaR1odQjAiroOk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c408:b0:19f:1c79:8b24 with SMTP id
 k8-20020a170902c40800b0019f1c798b24mr1457989plk.7.1679507852624; Wed, 22 Mar
 2023 10:57:32 -0700 (PDT)
Date:   Wed, 22 Mar 2023 10:57:31 -0700
In-Reply-To: <20230307023946.14516-34-xin3.li@intel.com>
Mime-Version: 1.0
References: <20230307023946.14516-1-xin3.li@intel.com> <20230307023946.14516-34-xin3.li@intel.com>
Message-ID: <ZBtBizw+IuUKwztN@google.com>
Subject: Re: [PATCH v5 33/34] KVM: x86/vmx: call external_interrupt() to
 handle IRQ in IRQ caused VM exits
From:   Sean Christopherson <seanjc@google.com>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023, Xin Li wrote:
> @@ -6923,7 +6924,26 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  		return;
>  
>  	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
> -	vmx_do_interrupt_irqoff(gate_offset(desc));
> +	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
> +		struct vcpu_vmx *vmx = to_vmx(vcpu);
> +		struct pt_regs regs = {};
> +
> +		/*
> +		 * Create an event return stack frame with the
> +		 * host context immediately after a VM exit.

Why snapshot the context immediately after VM-Exit?  It diverges from what is
done in the non-FRED path, and it seems quite misleading and maybe even dangerous.
The RSP and RIP values are long since gone, e.g. if something explodes, the stack
trace will be outright wrong.

> +		 *
> +		 * All other fields of the pt_regs structure are
> +		 * cleared to 0.
> +		 */
> +		regs.ss		= __KERNEL_DS;
> +		regs.sp		= vmx->loaded_vmcs->host_state.rsp;
> +		regs.flags	= X86_EFLAGS_FIXED;
> +		regs.cs		= __KERNEL_CS;
> +		regs.ip		= (unsigned long)vmx_vmexit;
> +
> +		external_interrupt(&regs, vector);

I assume FRED still uses the stack, so why not do something similar to
vmx_do_interrupt_irqoff() and build @regs after an explicit CALL?  Might even
be possible to share some/all of VMX_DO_EVENT_IRQOFF.

> +	} else

Curly braces needed since the first half has 'em.

> +		vmx_do_interrupt_irqoff(gate_offset(desc));
>  	kvm_after_interrupt(vcpu);
>  
>  	vcpu->arch.at_instruction_boundary = true;
> -- 
> 2.34.1
> 
