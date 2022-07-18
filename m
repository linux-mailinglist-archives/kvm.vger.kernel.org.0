Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A524578313
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 15:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbiGRNEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 09:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbiGRNE2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 09:04:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDE89DF71
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 06:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658149465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YzFKckXhA5GYIysBuY0PrHqaWag3B2/+v6zDfahY5Aw=;
        b=TSynr/AE4SaYvG1XbVM1gHldjUkzxTdjrPL2Qjxaqf08ZV6/V1berm1dAJw1K+nYj909OE
        2agK3QfaPCihrWboqjRg9Mof5YJzFeXFInw1+jubiKD2vZ9Thn2fZmVlXAulb7u1TrQdnk
        uxeDcMXQlDUTV/6255YKro4gg1NkF5k=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-eeohnrAYOM6hdm_DkgX3PQ-1; Mon, 18 Jul 2022 09:04:24 -0400
X-MC-Unique: eeohnrAYOM6hdm_DkgX3PQ-1
Received: by mail-qk1-f198.google.com with SMTP id bi37-20020a05620a31a500b006b5ef0afedaso1551377qkb.22
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 06:04:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=YzFKckXhA5GYIysBuY0PrHqaWag3B2/+v6zDfahY5Aw=;
        b=ABp8i7Q/rekU3qPk/wJlqcWRLZWHus8rMzXh2A/lssLohYsRKkvq5jvQ9YoMGjpXHt
         h2rmpOrdSE3UAcGihwrK9hLROM+MNhw0ob/DqEl5prNROOZaJ9UkV0UsvQiryYcOA5Ew
         Km3PXqbLqWxwcolf2Vgse4vHiuohxI6BTGBbpiZ9JirDg28VInGVWdwftvFtbte49ejK
         FaB96OeB09smamZ4od2SylT8lbq2NbuwnGE5elW9lchTcP2a6yVzw8Ui189+zDHZsINA
         TUwqLw0Xe/isGvm9Mv3VQ3tw6gxBl4ky6Y8Qut/S6619XfkjJtUgtxEmoBhPxtlgj03T
         uQ1A==
X-Gm-Message-State: AJIora9wcYgcxTlBlEBB1TzHPNNvfT6nmoqLUcX2wX5DZ/AZmrfN4hXb
        TjBP42ka169BlLVpwhuSqtj4Vmt9ynSWoemVaPBQtpjOuTRXYYtxBdlEE9Qu6wCnbI/u4X3CD1l
        VqexyGQGXjIEg
X-Received: by 2002:ac8:5d94:0:b0:31e:ed4b:2ce2 with SMTP id d20-20020ac85d94000000b0031eed4b2ce2mr3797486qtx.139.1658149463671;
        Mon, 18 Jul 2022 06:04:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s5qpfF+us6RqfNWsFyEVz8xkcgMhePhE3rJb6Bzud/4rs0pxq3zHyjHJ3k2uGpU3tXcx+Lzw==
X-Received: by 2002:ac8:5d94:0:b0:31e:ed4b:2ce2 with SMTP id d20-20020ac85d94000000b0031eed4b2ce2mr3797460qtx.139.1658149463401;
        Mon, 18 Jul 2022 06:04:23 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id ay17-20020a05620a179100b006b5d3a6f1e1sm7988913qkb.0.2022.07.18.06.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 06:04:22 -0700 (PDT)
Message-ID: <261f60dfe9813e612bfb30b6f271a68b9e877408.camel@redhat.com>
Subject: Re: [PATCH v2 09/24] KVM: nVMX: Unconditionally clear mtf_pending
 on nested VM-Exit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Mon, 18 Jul 2022 16:04:19 +0300
In-Reply-To: <20220715204226.3655170-10-seanjc@google.com>
References: <20220715204226.3655170-1-seanjc@google.com>
         <20220715204226.3655170-10-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-15 at 20:42 +0000, Sean Christopherson wrote:
> Clear mtf_pending on nested VM-Exit instead of handling the clear on a
> case-by-case basis in vmx_check_nested_events().  The pending MTF should
> never survive nested VM-Exit, as it is a property of KVM's run of the
> current L2, i.e. should never affect the next L2 run by L1.  In practice,
> this is likely a nop as getting to L1 with nested_run_pending is
> impossible, and KVM doesn't correctly handle morphing a pending exception
> that occurs on a prior injected exception (need for re-injected exception
> being the other case where MTF isn't cleared).  However, KVM will
> hopefully soon correctly deal with a pending exception on top of an
> injected exception.
> 
> Add a TODO to document that KVM has an inversion priority bug between
> SMIs and MTF (and trap-like #DBS), and that KVM also doesn't properly
> save/restore MTF across SMI/RSM.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 104f233ddd5d..a85f31cee149 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3898,16 +3898,8 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>         unsigned long exit_qual;
>         bool block_nested_events =
>             vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
> -       bool mtf_pending = vmx->nested.mtf_pending;
>         struct kvm_lapic *apic = vcpu->arch.apic;
>  
> -       /*
> -        * Clear the MTF state. If a higher priority VM-exit is delivered first,
> -        * this state is discarded.
> -        */
> -       if (!block_nested_events)
> -               vmx->nested.mtf_pending = false;
> -
>         if (lapic_in_kernel(vcpu) &&
>                 test_bit(KVM_APIC_INIT, &apic->pending_events)) {
>                 if (block_nested_events)
> @@ -3916,6 +3908,9 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>                 clear_bit(KVM_APIC_INIT, &apic->pending_events);
>                 if (vcpu->arch.mp_state != KVM_MP_STATE_INIT_RECEIVED)
>                         nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
> +
> +               /* MTF is discarded if the vCPU is in WFS. */
> +               vmx->nested.mtf_pending = false;
>                 return 0;
>         }
>  
> @@ -3938,6 +3933,11 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>          * fault-like exceptions, TSS T flag #DB (not emulated by KVM, but
>          * could theoretically come in from userspace), and ICEBP (INT1).
>          *
> +        * TODO: SMIs have higher priority than MTF and trap-like #DBs (except
> +        * for TSS T flag #DBs).  KVM also doesn't save/restore pending MTF
> +        * across SMI/RSM as it should; that needs to be addressed in order to
> +        * prioritize SMI over MTF and trap-like #DBs.

Thanks, makes sense.

Best regards,
	Maxim Levitsky
> +        *
>          * Note that only a pending nested run can block a pending exception.
>          * Otherwise an injected NMI/interrupt should either be
>          * lost or delivered to the nested hypervisor in the IDT_VECTORING_INFO,
> @@ -3953,7 +3953,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>                 return 0;
>         }
>  
> -       if (mtf_pending) {
> +       if (vmx->nested.mtf_pending) {
>                 if (block_nested_events)
>                         return -EBUSY;
>                 nested_vmx_update_pending_dbg(vcpu);
> @@ -4549,6 +4549,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
>         struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>  
> +       /* Pending MTF traps are discarded on VM-Exit. */
> +       vmx->nested.mtf_pending = false;
> +
>         /* trying to cancel vmlaunch/vmresume is a bug */
>         WARN_ON_ONCE(vmx->nested.nested_run_pending);
>  


