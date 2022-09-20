Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F2B5BD8CE
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 02:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiITAcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 20:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiITAcx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 20:32:53 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C39D52453
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 17:32:52 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q9-20020a17090a178900b0020265d92ae3so9076071pja.5
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 17:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=lzSlCQ5sS4qil99odoJMLVUL5/2+gqYaJrux/DqPc6U=;
        b=qGjH6NMOKBTCVBUGx+d/w8SQADzCr9jQk7AgXKAM7xJQENzeqOm7GWXyUt4R1s8jJZ
         TISK+ck/YNm7d3Dr3tY9Vq2gK1hM3/k9RnyW2D0s/B5Layx8IjnkwRjt3CJd14RwQEQ7
         yLdLjEj3pGjkAAlhzzgazIhpr9iboyHn92CgXI3F0tfCU9ouBmoVfEgh55Y6H7z4u3MC
         1Tgmf++FpZtIoJc4eT2tJcn98n1XEOEd7duDv2ux5GjOb0BsmWl2svvMY6FoCKadgxHW
         S8KUawuBuZ4Dlu46m31statcPB3rj1d4v1WpqAJvdTqQOLYYuGl4ixLRfwVENl8flZLQ
         t/yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=lzSlCQ5sS4qil99odoJMLVUL5/2+gqYaJrux/DqPc6U=;
        b=hyo1Onu6wCwD3Kp7UfCPRafCVkwGjs5m/dkJPDdSpYNasalMAoiMAgOtF7B08pbN3g
         dtLdKq/GzNm9CRl0nNGgCfqDGY+/iqo4LLwB+EyHgJkGmyqJRU1dLUACV9BlxoST+xFX
         TOgxHC9Gn33qmDM/XmmXQD9UAWylvqF4GOB3zCMkXGq9D8R6HCvA3f4hDSUFP1k7oxcs
         yaCAjpXoC76kL/y3o2g4mmuqxCGzejvC5X4Q5O3WV0qJAQbylrgKNOvrZaHljIIA6o4G
         tWVOk8QOhastFE25baEiTy5IdPwp45gR5uyuY/gSAh3K1ncpPDNahFFkW5OeadNwhuTL
         Irew==
X-Gm-Message-State: ACrzQf1pK+0lcSFGf3EOslGszqWAhRZZVJhZS60AHQVH3cgoP4KRPXUH
        ahYwp2BhW+vqkx4XMfIwtd7E4fcZi+YOew==
X-Google-Smtp-Source: AMsMyM7AfhhUtmouHolPvCpJICIKqFteZ5daTBEaqzUS+NqDW7767dXqE7ulVe+y9lII9n9LWIqYvA==
X-Received: by 2002:a17:90a:4688:b0:1ef:a94:7048 with SMTP id z8-20020a17090a468800b001ef0a947048mr925310pjf.244.1663633971355;
        Mon, 19 Sep 2022 17:32:51 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y1-20020aa79421000000b00537daf64e8esm21008612pfo.188.2022.09.19.17.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 17:32:50 -0700 (PDT)
Date:   Tue, 20 Sep 2022 00:32:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH v2 9/9] KVM: x86: never write to memory from
 kvm_vcpu_check_block
Message-ID: <YykKLx+EMufA+uuZ@google.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
 <20220811210605.402337-10-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811210605.402337-10-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022, Paolo Bonzini wrote:
> kvm_vcpu_check_block() is called while not in TASK_RUNNING, and therefore
> it cannot sleep.  Writing to guest memory is therefore forbidden, but it
> can happen on AMD processors if kvm_check_nested_events() causes a vmexit.
> 
> Fortunately, all events that are caught by kvm_check_nested_events() are
> also recognized by kvm_vcpu_has_events() through vendor callbacks such as
> kvm_x86_interrupt_allowed() or kvm_x86_ops.nested_ops->has_events(), so
> remove the call and postpone the actual processing to vcpu_block().
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5e9358ea112b..9226fd536783 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10639,6 +10639,17 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
>  			return 1;
>  	}
>  
> +	if (is_guest_mode(vcpu)) {
> +		/*
> +		 * Evaluate nested events before exiting the halted state.
> +		 * This allows the halt state to be recorded properly in
> +		 * the VMCS12's activity state field (AMD does not have
> +		 * a similar field and a vmexit always causes a spurious
> +		 * wakeup from HLT).
> +		 */
> +		kvm_check_nested_events(vcpu);
> +	}
> +
>  	if (kvm_apic_accept_events(vcpu) < 0)
>  		return 0;

Oof, this ends up yielding a really confusing code sequence.  kvm_apic_accept_events()
has its own kvm_check_nested_events(), but has code to snapshot pending INITs/SIPIs
_before_ the call.  Unpacked, KVM ends up with:

	if (is_guest_mode(vcpu))
		kvm_check_nested_events(vcpu);

	/*
	 * Read pending events before calling the check_events
	 * callback.
	 */
	pe = smp_load_acquire(&apic->pending_events);
	if (!pe)
		return 0;

	if (is_guest_mode(vcpu)) {
		r = kvm_check_nested_events(vcpu);
		if (r < 0)
			return r == -EBUSY ? 0 : r;
	}

	if (kvm_vcpu_latch_init(vcpu)) {
		WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
		if (test_bit(KVM_APIC_SIPI, &pe))
			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
		return 0;
	}

	if (test_bit(KVM_APIC_INIT, &pe)) {
		clear_bit(KVM_APIC_INIT, &apic->pending_events);
		kvm_vcpu_reset(vcpu, true);
		if (kvm_vcpu_is_bsp(apic->vcpu))
			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
		else
			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
	}
	if (test_bit(KVM_APIC_SIPI, &pe)) {
		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
			/* evaluate pending_events before reading the vector */
			smp_rmb();
			sipi_vector = apic->sipi_vector;
			static_call(kvm_x86_vcpu_deliver_sipi_vector)(vcpu, sipi_vector);
			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
		}
	}

which on the surface makes this code look broken, e.g. if kvm_check_nested_events()
_needs_ to be after the pending_events snapshot is taken, why is it safe to add a
kvm_check_nested_events() call immediately before the snapshot?

In reality, it's just a bunch of noise because the pending events snapshot is
completely unnecessary and subtly relies on INIT+SIPI being blocked after VM-Exit
on VMX (and SVM, but it's more important for VMX).

In particular, testing "pe" after VM-Exit is nonsensical.  On VMX, events are consumed
if they trigger VM-Exit, i.e. processing INIT/SIPI is flat out wrong if the INIT/SIPI
was the direct cause of VM-Exit.  On SVM, events are left pending, so if any pending
INIT/SIPI will still be there.

The VMX code works because kvm_vcpu_latch_init(), a.k.a. "is INIT blocked", is
always true after VM-Exit since INIT is always blocked in VMX root mode.  Ditto for
the conditional clearing of SIPI; the CPU can't be in wait-for-SIPI immediately
after VM-Exit and so dropping SIPIs ends up being architecturally ok.

I'll add a patch to drop the snapshot code, assuming I'm not missing something even
more subtle...
