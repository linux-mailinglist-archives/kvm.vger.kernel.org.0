Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA60B5970CE
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 16:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239932AbiHQOLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 10:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240019AbiHQOLc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 10:11:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72953E769
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 07:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660745490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BkBigNaDlXGP8QLup2qk8r/1tlI8dFIAgIklvPQD/3s=;
        b=W97e/qSzC0roqAD8jFkxxZRxMNp1U3Diy2JDJHeAYPbTsqvXbnnpg7nd46ZwY6YrYG6mKq
        N/r08TFiOJBFiJOvKCR5ZkgZHey8c6Yrks/xUbw6RMgfqhBpdc2ORlpYVGHCkhjDNczFpu
        05M0PrGX3EvgOQmnoY/2BUlczC1TgoY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-599-BQeIB5UvMqScbrQ2buK5og-1; Wed, 17 Aug 2022 10:11:29 -0400
X-MC-Unique: BQeIB5UvMqScbrQ2buK5og-1
Received: by mail-wr1-f70.google.com with SMTP id v27-20020adfa1db000000b002252854ec99so376505wrv.2
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 07:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=BkBigNaDlXGP8QLup2qk8r/1tlI8dFIAgIklvPQD/3s=;
        b=aYX6ELnZQkXGliFQ9AKVmaFiXvVG2b51i5h2J+BS0fwRFJ+sHbiuWgfBe2sSy5pqvY
         8OUywbndHkopJReBBw5MA8DTW1azc/5nD7qqUhptV2wse+nOPoD9qlDK8PuytBNQhKlY
         zU9eeFVB5Jo08KZeVUZKia3ALaQzsQEyAYdf8LdnGrX9+GZ/79BWANFQ3RLROFWP/Vwj
         +mqEsWJ7j0zxVdkAoGtFYpGSIOojc4h/0Owg/zX/UonHntrUr5Mk9QTFdX0QAi3y6CEJ
         js9NUqKtpLypy5DFgKprjubXojXntK75hKQ+v2MqGHfRF20PeFfo8hvSvzQzyUDTO1kA
         MUgQ==
X-Gm-Message-State: ACgBeo1FYTia9Y5s4RPtYQVkCvRz8K2OCkGU5Vsz9xr8nEiiyvbJ0R7n
        Xxdn2VfPFcjGO2/ZyQfy9oDiXvv9ArHR/eH4dK6McpxIov/fycZTrHTHRfMavv6zfXm2q1kZOMe
        pcAc6eOBpA7Ih
X-Received: by 2002:a5d:648b:0:b0:222:cc32:c292 with SMTP id o11-20020a5d648b000000b00222cc32c292mr13905160wri.463.1660745488133;
        Wed, 17 Aug 2022 07:11:28 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4lJRlBf20Vlg8kR3ZgHCBt6Y9KmjcitB9u5B1scmYBGIiJ/FHfKW7Eu4BR6iE8qP0uR5Avrw==
X-Received: by 2002:a5d:648b:0:b0:222:cc32:c292 with SMTP id o11-20020a5d648b000000b00222cc32c292mr13905142wri.463.1660745487810;
        Wed, 17 Aug 2022 07:11:27 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id x11-20020adff0cb000000b002217e3f41f1sm13104183wro.106.2022.08.17.07.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 07:11:27 -0700 (PDT)
Message-ID: <226aca0a2cc95f57364f330793a2f13446fcf7a0.camel@redhat.com>
Subject: Re: [PATCH v2 8/9] KVM: x86: lapic does not have to process INIT if
 it is blocked
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com
Date:   Wed, 17 Aug 2022 17:11:25 +0300
In-Reply-To: <YvwxJzHC5xYnc7CJ@google.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
         <20220811210605.402337-9-pbonzini@redhat.com> <YvwxJzHC5xYnc7CJ@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-17 at 00:07 +0000, Sean Christopherson wrote:
> On Thu, Aug 11, 2022, Paolo Bonzini wrote:
> > Do not return true from kvm_apic_has_events, and consequently from
> > kvm_vcpu_has_events, if the vCPU is not going to process an INIT.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 1 +
> >  arch/x86/kvm/i8259.c            | 2 +-
> >  arch/x86/kvm/lapic.h            | 2 +-
> >  arch/x86/kvm/x86.c              | 5 +++++
> >  arch/x86/kvm/x86.h              | 5 -----
> >  5 files changed, 8 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 293ff678fff5..1ce4ebc41118 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2042,6 +2042,7 @@ void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
> >                                      u32 size);
> >  bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu);
> >  bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu);
> > +bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu);
> >  
> >  bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
> >                              struct kvm_vcpu **dest_vcpu);
> > diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> > index e1bb6218bb96..177555eea54e 100644
> > --- a/arch/x86/kvm/i8259.c
> > +++ b/arch/x86/kvm/i8259.c
> > @@ -29,9 +29,9 @@
> >  #include <linux/mm.h>
> >  #include <linux/slab.h>
> >  #include <linux/bitops.h>
> > -#include "irq.h"
> > +#include <linux/kvm_host.h>
> >  
> > -#include <linux/kvm_host.h>
> > +#include "irq.h"
> >  #include "trace.h"
> >  
> >  #define pr_pic_unimpl(fmt, ...)        \
> > diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> > index 117a46df5cc1..12577ddccdfc 100644
> > --- a/arch/x86/kvm/lapic.h
> > +++ b/arch/x86/kvm/lapic.h
> > @@ -225,7 +225,7 @@ static inline bool kvm_vcpu_apicv_active(struct kvm_vcpu *vcpu)
> >  
> >  static inline bool kvm_apic_has_events(struct kvm_vcpu *vcpu)
> >  {
> > -       return lapic_in_kernel(vcpu) && vcpu->arch.apic->pending_events;
> > +       return lapic_in_kernel(vcpu) && vcpu->arch.apic->pending_events && !kvm_vcpu_latch_init(vcpu);
> 
> Blech, the kvm_apic_has_events() name is awful (as is pending_events), e.g. it
> really should be kvm_apic_has_pending_sipi_or_init().

110% agree.
> 
> To avoid the odd kvm_vcpu_latch_init() declaration and the long line above, what
> if we open code this in kvm_vcpu_has_events() like we do for NMI, SMI, etc...?
> 
> And as follow-up, I would love to rename kvm_vcpu_latch_init() => kvm_vcpu_init_blocked(),
> kvm_apic_has_events(), and pending_events.
> 
> E.g. for this patch just do:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9f11b505cbee..559900736a71 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12533,7 +12533,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>         if (!list_empty_careful(&vcpu->async_pf.done))
>                 return true;
> 
> -       if (kvm_apic_has_events(vcpu))
> +       /* comment explaning that SIPIs are dropped in this case. */
> +       if (kvm_apic_has_events(vcpu) && !kvm_vcpu_latch_init(vcpu))
>                 return true;

I personally don't know if I prefer this or the original patch.



> 
>         if (vcpu->arch.pv.pv_unhalted)
> 


While reviwing this, I noticed that we have this code:


static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
{
 struct vcpu_svm *svm = to_svm(vcpu);

 /*
 * TODO: Last condition latch INIT signals on vCPU when
 * vCPU is in guest-mode and vmcb12 defines intercept on INIT.
 * To properly emulate the INIT intercept,
 * svm_check_nested_events() should call nested_svm_vmexit()
 * if an INIT signal is pending.
 */
 return !gif_set(svm) ||
 (vmcb_is_intercept(&svm->vmcb->control, INTERCEPT_INIT));
}

Is this workaround still needed? svm_check_nested_events does check the apic's INIT/SIPI status.

Currently the '.apic_init_signal_blocked' is called from kvm_vcpu_latch_init which itself is
currently called from kvm_vcpu_latch_init which happens after we would vmexit if INIT is intercepted by nested
hypervisor.

Best regards,
	Maxim Levitsky

