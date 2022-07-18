Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CEC57832F
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 15:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbiGRNHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 09:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235319AbiGRNHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 09:07:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD0AADF71
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 06:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658149665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qxdzc19T5YoW4p+Nove1GGWL97P9fSacD+vIG7qHbzE=;
        b=blibAECKnsc5o+SJ0ZBgjgYFa9P2Whb6lf5Kbd+kng9qt8z6/XNH0j2rVAlY1mE4fPQ3oa
        eHl8VG7Fq4W/x4VyEbYXa1I4brwnPwIfLV9IBfwE5mHd6x+NmLPClm769LYvg+uP4qsyJ0
        PYd+LV2DNqyLx0nEAsx8dsRTFDV7hL4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-4EjZjgu7OPmCIGJ25uObUQ-1; Mon, 18 Jul 2022 09:07:41 -0400
X-MC-Unique: 4EjZjgu7OPmCIGJ25uObUQ-1
Received: by mail-qt1-f197.google.com with SMTP id a10-20020ac84d8a000000b0031ee6389b7eso3732104qtw.6
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 06:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Qxdzc19T5YoW4p+Nove1GGWL97P9fSacD+vIG7qHbzE=;
        b=J9yqraiyD3a3X+ewjiTnCaUpS0CtTIG5p33EGgW0kN04AcbJNMiQ51P5d9+Bf7WcXW
         Y7kd32jCfpW9HUb0qJ1UC/kj/Z5qkXahk5fI3T3v9jO6JcHRzSBrrpkspU/lQNK4JVwc
         FIm0Zu7uN0lWa9N6ZXhsI9ri31ngPI12xOFjWh/lENgXyOjozXzPXnZHDfH1zfA10Usd
         hXu8E0JE0PStHlmzGlQzshuyJMS4z2fVOrb2D0S40SNYZmrpU1nH1hUhRV7wbApYAxvZ
         lXUmCoNm4NRRAx8C87bnDDF0hEsTLIpDY1Cv3+PF648FSD+b3zjirzrYSG7vH0VD9BBu
         +g6A==
X-Gm-Message-State: AJIora+mTLPL82nFhwyk+Fwgn5HxDJjxOF8IDEIOG8Y+oasQb95718zO
        9P12kfE53EGvvcPnOhqCst04M/tU7mwHAfY19IOZQjcsIJE5YNuZ0Xi9Q/dElnQNE53KqGMzgaR
        djSR7GpbVSqOy
X-Received: by 2002:a37:dc46:0:b0:6af:59e6:cd72 with SMTP id v67-20020a37dc46000000b006af59e6cd72mr17050066qki.78.1658149660785;
        Mon, 18 Jul 2022 06:07:40 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tAgqBTsvo5I1yHdvfwipBoUs19y9mlhTtJHV76TsjsAIZlxHISG7kMn640zvnBgDn/rcP+sg==
X-Received: by 2002:a37:dc46:0:b0:6af:59e6:cd72 with SMTP id v67-20020a37dc46000000b006af59e6cd72mr17050032qki.78.1658149660433;
        Mon, 18 Jul 2022 06:07:40 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id bl13-20020a05620a1a8d00b006b5f8f32a8fsm285310qkb.114.2022.07.18.06.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 06:07:39 -0700 (PDT)
Message-ID: <c558310c75367530948b6cccc45cbfe6522cd552.camel@redhat.com>
Subject: Re: [PATCH v2 12/21] KVM: x86: Make kvm_queued_exception a properly
 named, visible struct
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Mon, 18 Jul 2022 16:07:36 +0300
In-Reply-To: <20220614204730.3359543-13-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-13-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Move the definition of "struct kvm_queued_exception" out of kvm_vcpu_arch
> in anticipation of adding a second instance in kvm_vcpu_arch to handle
> exceptions that occur when vectoring an injected exception and are
> morphed to VM-Exit instead of leading to #DF.
> 
> Opportunistically take advantage of the churn to rename "nr" to "vector".
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
...


Is this change below intentional? My memory on nested_apf_token is quite rusty, but at least
if possible, I would prefer this to be done in separate patch.


Best regards,
	Maxim Levitsky

> -               else if (svm->vcpu.arch.exception.has_payload)
> -                       vmcb->control.exit_info_2 = svm->vcpu.arch.exception.payload;
> +       if (ex->vector == PF_VECTOR) {
> +               if (ex->has_payload)
> +                       vmcb->control.exit_info_2 = ex->payload;
>                 else
> -                       vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
> -       } else if (nr == DB_VECTOR) {
> +                       vmcb->control.exit_info_2 = vcpu->arch.cr2;
> +       } else if (ex->vector == DB_VECTOR) {
>                 /* See inject_pending_event.  */
> -               kvm_deliver_exception_payload(&svm->vcpu);
> -               if (svm->vcpu.arch.dr7 & DR7_GD) {
> -                       svm->vcpu.arch.dr7 &= ~DR7_GD;
> -                       kvm_update_dr7(&svm->vcpu);
> +               kvm_deliver_exception_payload(vcpu, ex);
> +
> +               if (vcpu->arch.dr7 & DR7_GD) {
> +                       vcpu->arch.dr7 &= ~DR7_GD;
> +                       kvm_update_dr7(vcpu);
>                 }
> -       } else
> -               WARN_ON(svm->vcpu.arch.exception.has_payload);
> +       } else {
> +               WARN_ON(ex->has_payload);
> +       }
>  
>         nested_svm_vmexit(svm);
>  }
> @@ -1372,7 +1373,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
>                          return -EBUSY;
>                 if (!nested_exit_on_exception(svm))
>                         return 0;
> -               nested_svm_inject_exception_vmexit(svm);
> +               nested_svm_inject_exception_vmexit(vcpu);
>                 return 0;
>         }
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ca39f76ca44b..6b80046a014f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -432,22 +432,20 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
>  
>  static void svm_inject_exception(struct kvm_vcpu *vcpu)
>  {
> +       struct kvm_queued_exception *ex = &vcpu->arch.exception;
>         struct vcpu_svm *svm = to_svm(vcpu);
> -       unsigned nr = vcpu->arch.exception.nr;
> -       bool has_error_code = vcpu->arch.exception.has_error_code;
> -       u32 error_code = vcpu->arch.exception.error_code;
>  
> -       kvm_deliver_exception_payload(vcpu);
> +       kvm_deliver_exception_payload(vcpu, ex);
>  
> -       if (kvm_exception_is_soft(nr) &&
> +       if (kvm_exception_is_soft(ex->vector) &&
>             svm_update_soft_interrupt_rip(vcpu))
>                 return;
>  
> -       svm->vmcb->control.event_inj = nr
> +       svm->vmcb->control.event_inj = ex->vector
>                 | SVM_EVTINJ_VALID
> -               | (has_error_code ? SVM_EVTINJ_VALID_ERR : 0)
> +               | (ex->has_error_code ? SVM_EVTINJ_VALID_ERR : 0)
>                 | SVM_EVTINJ_TYPE_EXEPT;
> -       svm->vmcb->control.event_inj_err = error_code;
> +       svm->vmcb->control.event_inj_err = ex->error_code;
>  }
>  
>  static void svm_init_erratum_383(void)
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 7b644513c82b..fafdcbfeca1f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -445,29 +445,27 @@ static bool nested_vmx_is_page_fault_vmexit(struct vmcs12 *vmcs12,
>   */
>  static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit_qual)
>  {
> +       struct kvm_queued_exception *ex = &vcpu->arch.exception;
>         struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> -       unsigned int nr = vcpu->arch.exception.nr;
> -       bool has_payload = vcpu->arch.exception.has_payload;
> -       unsigned long payload = vcpu->arch.exception.payload;
>  
> -       if (nr == PF_VECTOR) {
> -               if (vcpu->arch.exception.nested_apf) {
> +       if (ex->vector == PF_VECTOR) {
> +               if (ex->nested_apf) {
>                         *exit_qual = vcpu->arch.apf.nested_apf_token;
>                         return 1;
>                 }
> -               if (nested_vmx_is_page_fault_vmexit(vmcs12,
> -                                                   vcpu->arch.exception.error_code)) {
> -                       *exit_qual = has_payload ? payload : vcpu->arch.cr2;
> +               if (nested_vmx_is_page_fault_vmexit(vmcs12, ex->error_code)) {
> +                       *exit_qual = ex->has_payload ? ex->payload : vcpu->arch.cr2;
>                         return 1;
>                 }
> -       } else if (vmcs12->exception_bitmap & (1u << nr)) {
> -               if (nr == DB_VECTOR) {
> -                       if (!has_payload) {
> -                               payload = vcpu->arch.dr6;
> -                               payload &= ~DR6_BT;
> -                               payload ^= DR6_ACTIVE_LOW;
> +       } else if (vmcs12->exception_bitmap & (1u << ex->vector)) {
> +               if (ex->vector == DB_VECTOR) {
> +                       if (ex->has_payload) {
> +                               *exit_qual = ex->payload;
> +                       } else {
> +                               *exit_qual = vcpu->arch.dr6;
> +                               *exit_qual &= ~DR6_BT;
> +                               *exit_qual ^= DR6_ACTIVE_LOW;
>                         }
> -                       *exit_qual = payload;
>                 } else
>                         *exit_qual = 0;
>                 return 1;
> @@ -3724,7 +3722,7 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
>              is_double_fault(exit_intr_info))) {
>                 vmcs12->idt_vectoring_info_field = 0;
>         } else if (vcpu->arch.exception.injected) {
> -               nr = vcpu->arch.exception.nr;
> +               nr = vcpu->arch.exception.vector;
>                 idt_vectoring = nr | VECTORING_INFO_VALID_MASK;
>  
>                 if (kvm_exception_is_soft(nr)) {
> @@ -3828,11 +3826,11 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
>  static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
>                                                unsigned long exit_qual)
>  {
> +       struct kvm_queued_exception *ex = &vcpu->arch.exception;
> +       u32 intr_info = ex->vector | INTR_INFO_VALID_MASK;
>         struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> -       unsigned int nr = vcpu->arch.exception.nr;
> -       u32 intr_info = nr | INTR_INFO_VALID_MASK;
>  
> -       if (vcpu->arch.exception.has_error_code) {
> +       if (ex->has_error_code) {
>                 /*
>                  * Intel CPUs will never generate an error code with bits 31:16
>                  * set, and more importantly VMX disallows setting bits 31:16
> @@ -3840,11 +3838,11 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
>                  * mimic hardware and avoid inducing failure on nested VM-Entry
>                  * if L1 chooses to inject the exception back to L2.
>                  */
> -               vmcs12->vm_exit_intr_error_code = (u16)vcpu->arch.exception.error_code;
> +               vmcs12->vm_exit_intr_error_code = (u16)ex->error_code;
>                 intr_info |= INTR_INFO_DELIVER_CODE_MASK;
>         }
>  
> -       if (kvm_exception_is_soft(nr))
> +       if (kvm_exception_is_soft(ex->vector))
>                 intr_info |= INTR_TYPE_SOFT_EXCEPTION;
>         else
>                 intr_info |= INTR_TYPE_HARD_EXCEPTION;
> @@ -3875,7 +3873,7 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
>  static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
>  {
>         if (!vcpu->arch.exception.pending ||
> -           vcpu->arch.exception.nr != DB_VECTOR)
> +           vcpu->arch.exception.vector != DB_VECTOR)
>                 return 0;
>  
>         /* General Detect #DBs are always fault-like. */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 26b863c78a9f..7ef5659a1bbd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1585,7 +1585,7 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
>          */
>         if (nested_cpu_has_mtf(vmcs12) &&
>             (!vcpu->arch.exception.pending ||
> -            vcpu->arch.exception.nr == DB_VECTOR))
> +            vcpu->arch.exception.vector == DB_VECTOR))
>                 vmx->nested.mtf_pending = true;
>         else
>                 vmx->nested.mtf_pending = false;
> @@ -1612,15 +1612,13 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
>  
>  static void vmx_inject_exception(struct kvm_vcpu *vcpu)
>  {
> +       struct kvm_queued_exception *ex = &vcpu->arch.exception;
> +       u32 intr_info = ex->vector | INTR_INFO_VALID_MASK;
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
> -       unsigned nr = vcpu->arch.exception.nr;
> -       bool has_error_code = vcpu->arch.exception.has_error_code;
> -       u32 error_code = vcpu->arch.exception.error_code;
> -       u32 intr_info = nr | INTR_INFO_VALID_MASK;
>  
> -       kvm_deliver_exception_payload(vcpu);
> +       kvm_deliver_exception_payload(vcpu, ex);
>  
> -       if (has_error_code) {
> +       if (ex->has_error_code) {
>                 /*
>                  * Despite the error code being architecturally defined as 32
>                  * bits, and the VMCS field being 32 bits, Intel CPUs and thus
> @@ -1630,21 +1628,21 @@ static void vmx_inject_exception(struct kvm_vcpu *vcpu)
>                  * the upper bits to avoid VM-Fail, losing information that
>                  * does't really exist is preferable to killing the VM.
>                  */
> -               vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, (u16)error_code);
> +               vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, (u16)ex->error_code);
>                 intr_info |= INTR_INFO_DELIVER_CODE_MASK;
>         }
>  
>         if (vmx->rmode.vm86_active) {
>                 int inc_eip = 0;
> -               if (kvm_exception_is_soft(nr))
> +               if (kvm_exception_is_soft(ex->vector))
>                         inc_eip = vcpu->arch.event_exit_inst_len;
> -               kvm_inject_realmode_interrupt(vcpu, nr, inc_eip);
> +               kvm_inject_realmode_interrupt(vcpu, ex->vector, inc_eip);
>                 return;
>         }
>  
>         WARN_ON_ONCE(vmx->emulation_required);
>  
> -       if (kvm_exception_is_soft(nr)) {
> +       if (kvm_exception_is_soft(ex->vector)) {
>                 vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
>                              vmx->vcpu.arch.event_exit_inst_len);
>                 intr_info |= INTR_TYPE_SOFT_EXCEPTION;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b63421d511c5..511c0c8af80e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -557,16 +557,13 @@ static int exception_type(int vector)
>         return EXCPT_FAULT;
>  }
>  
> -void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
> +void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
> +                                  struct kvm_queued_exception *ex)
>  {
> -       unsigned nr = vcpu->arch.exception.nr;
> -       bool has_payload = vcpu->arch.exception.has_payload;
> -       unsigned long payload = vcpu->arch.exception.payload;
> -
> -       if (!has_payload)
> +       if (!ex->has_payload)
>                 return;
>  
> -       switch (nr) {
> +       switch (ex->vector) {
>         case DB_VECTOR:
>                 /*
>                  * "Certain debug exceptions may clear bit 0-3.  The
> @@ -591,8 +588,8 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
>                  * So they need to be flipped for DR6.
>                  */
>                 vcpu->arch.dr6 |= DR6_ACTIVE_LOW;
> -               vcpu->arch.dr6 |= payload;
> -               vcpu->arch.dr6 ^= payload & DR6_ACTIVE_LOW;
> +               vcpu->arch.dr6 |= ex->payload;
> +               vcpu->arch.dr6 ^= ex->payload & DR6_ACTIVE_LOW;
>  
>                 /*
>                  * The #DB payload is defined as compatible with the 'pending
> @@ -603,12 +600,12 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
>                 vcpu->arch.dr6 &= ~BIT(12);
>                 break;
>         case PF_VECTOR:
> -               vcpu->arch.cr2 = payload;
> +               vcpu->arch.cr2 = ex->payload;
>                 break;
>         }
>  
> -       vcpu->arch.exception.has_payload = false;
> -       vcpu->arch.exception.payload = 0;
> +       ex->has_payload = false;
> +       ex->payload = 0;
>  }
>  EXPORT_SYMBOL_GPL(kvm_deliver_exception_payload);
>  
> @@ -647,17 +644,18 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>                         vcpu->arch.exception.injected = false;
>                 }
>                 vcpu->arch.exception.has_error_code = has_error;
> -               vcpu->arch.exception.nr = nr;
> +               vcpu->arch.exception.vector = nr;
>                 vcpu->arch.exception.error_code = error_code;
>                 vcpu->arch.exception.has_payload = has_payload;
>                 vcpu->arch.exception.payload = payload;
>                 if (!is_guest_mode(vcpu))
> -                       kvm_deliver_exception_payload(vcpu);
> +                       kvm_deliver_exception_payload(vcpu,
> +                                                     &vcpu->arch.exception);
>                 return;
>         }
>  
>         /* to check exception */
> -       prev_nr = vcpu->arch.exception.nr;
> +       prev_nr = vcpu->arch.exception.vector;
>         if (prev_nr == DF_VECTOR) {
>                 /* triple fault -> shutdown */
>                 kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> @@ -675,7 +673,7 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>                 vcpu->arch.exception.pending = true;
>                 vcpu->arch.exception.injected = false;
>                 vcpu->arch.exception.has_error_code = true;
> -               vcpu->arch.exception.nr = DF_VECTOR;
> +               vcpu->arch.exception.vector = DF_VECTOR;
>                 vcpu->arch.exception.error_code = 0;
>                 vcpu->arch.exception.has_payload = false;
>                 vcpu->arch.exception.payload = 0;
> @@ -4886,25 +4884,24 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
>  static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>                                                struct kvm_vcpu_events *events)
>  {
> +       struct kvm_queued_exception *ex = &vcpu->arch.exception;
> +
>         process_nmi(vcpu);
>  
>         if (kvm_check_request(KVM_REQ_SMI, vcpu))
>                 process_smi(vcpu);
>  
>         /*
> -        * In guest mode, payload delivery should be deferred,
> -        * so that the L1 hypervisor can intercept #PF before
> -        * CR2 is modified (or intercept #DB before DR6 is
> -        * modified under nVMX). Unless the per-VM capability,
> -        * KVM_CAP_EXCEPTION_PAYLOAD, is set, we may not defer the delivery of
> -        * an exception payload and handle after a KVM_GET_VCPU_EVENTS. Since we
> -        * opportunistically defer the exception payload, deliver it if the
> -        * capability hasn't been requested before processing a
> -        * KVM_GET_VCPU_EVENTS.
> +        * In guest mode, payload delivery should be deferred if the exception
> +        * will be intercepted by L1, e.g. KVM should not modifying CR2 if L1
> +        * intercepts #PF, ditto for DR6 and #DBs.  If the per-VM capability,
> +        * KVM_CAP_EXCEPTION_PAYLOAD, is not set, userspace may or may not
> +        * propagate the payload and so it cannot be safely deferred.  Deliver
> +        * the payload if the capability hasn't been requested.
>          */
>         if (!vcpu->kvm->arch.exception_payload_enabled &&
> -           vcpu->arch.exception.pending && vcpu->arch.exception.has_payload)
> -               kvm_deliver_exception_payload(vcpu);
> +           ex->pending && ex->has_payload)
> +               kvm_deliver_exception_payload(vcpu, ex);
>  
>         /*
>          * The API doesn't provide the instruction length for software
> @@ -4912,26 +4909,25 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>          * isn't advanced, we should expect to encounter the exception
>          * again.
>          */
> -       if (kvm_exception_is_soft(vcpu->arch.exception.nr)) {
> +       if (kvm_exception_is_soft(ex->vector)) {
>                 events->exception.injected = 0;
>                 events->exception.pending = 0;
>         } else {
> -               events->exception.injected = vcpu->arch.exception.injected;
> -               events->exception.pending = vcpu->arch.exception.pending;
> +               events->exception.injected = ex->injected;
> +               events->exception.pending = ex->pending;
>                 /*
>                  * For ABI compatibility, deliberately conflate
>                  * pending and injected exceptions when
>                  * KVM_CAP_EXCEPTION_PAYLOAD isn't enabled.
>                  */
>                 if (!vcpu->kvm->arch.exception_payload_enabled)
> -                       events->exception.injected |=
> -                               vcpu->arch.exception.pending;
> +                       events->exception.injected |= ex->pending;
>         }
> -       events->exception.nr = vcpu->arch.exception.nr;
> -       events->exception.has_error_code = vcpu->arch.exception.has_error_code;
> -       events->exception.error_code = vcpu->arch.exception.error_code;
> -       events->exception_has_payload = vcpu->arch.exception.has_payload;
> -       events->exception_payload = vcpu->arch.exception.payload;
> +       events->exception.nr = ex->vector;
> +       events->exception.has_error_code = ex->has_error_code;
> +       events->exception.error_code = ex->error_code;
> +       events->exception_has_payload = ex->has_payload;
> +       events->exception_payload = ex->payload;
>  
>         events->interrupt.injected =
>                 vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
> @@ -5003,7 +4999,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>         process_nmi(vcpu);
>         vcpu->arch.exception.injected = events->exception.injected;
>         vcpu->arch.exception.pending = events->exception.pending;
> -       vcpu->arch.exception.nr = events->exception.nr;
> +       vcpu->arch.exception.vector = events->exception.nr;
>         vcpu->arch.exception.has_error_code = events->exception.has_error_code;
>         vcpu->arch.exception.error_code = events->exception.error_code;
>         vcpu->arch.exception.has_payload = events->exception_has_payload;
> @@ -9497,7 +9493,7 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu)
>  
>  static void kvm_inject_exception(struct kvm_vcpu *vcpu)
>  {
> -       trace_kvm_inj_exception(vcpu->arch.exception.nr,
> +       trace_kvm_inj_exception(vcpu->arch.exception.vector,
>                                 vcpu->arch.exception.has_error_code,
>                                 vcpu->arch.exception.error_code,
>                                 vcpu->arch.exception.injected);
> @@ -9569,12 +9565,12 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>                  * describe the behavior of General Detect #DBs, which are
>                  * fault-like.  They do _not_ set RF, a la code breakpoints.
>                  */
> -               if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
> +               if (exception_type(vcpu->arch.exception.vector) == EXCPT_FAULT)
>                         __kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
>                                              X86_EFLAGS_RF);
>  
> -               if (vcpu->arch.exception.nr == DB_VECTOR) {
> -                       kvm_deliver_exception_payload(vcpu);
> +               if (vcpu->arch.exception.vector == DB_VECTOR) {
> +                       kvm_deliver_exception_payload(vcpu, &vcpu->arch.exception);
>                         if (vcpu->arch.dr7 & DR7_GD) {
>                                 vcpu->arch.dr7 &= ~DR7_GD;
>                                 kvm_update_dr7(vcpu);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 501b884b8cc4..dc2af0146220 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -286,7 +286,8 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu,
>  
>  int handle_ud(struct kvm_vcpu *vcpu);
>  
> -void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu);
> +void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
> +                                  struct kvm_queued_exception *ex);
>  
>  void kvm_vcpu_mtrr_init(struct kvm_vcpu *vcpu);
>  u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);


