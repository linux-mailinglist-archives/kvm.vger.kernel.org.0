Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF235970CD
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 16:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239882AbiHQOLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 10:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240027AbiHQOLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 10:11:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A9941980
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 07:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660745506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hhBNIOM9Y2xU0B1BDjyol1FutIC8XO8BHPDwpu5KbpE=;
        b=YUBiAHHJ039iuThLLeZaL5XHmZ405KIMWjxuhF0cpvZMqxuZ8095CnK6ez/3vGwVOCakOq
        NkGWK2zwCqrTaSusZKQK1ZAYpVf3neGrLbgkzBJY2JJt263+10jycGD7qHCCSnf0E1bQC7
        /BN9sI+ksTU+RKWX0FGt4VNQnNYCRFQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-417-dbkhOYtjPIKk4048ofMEfA-1; Wed, 17 Aug 2022 10:11:44 -0400
X-MC-Unique: dbkhOYtjPIKk4048ofMEfA-1
Received: by mail-wr1-f69.google.com with SMTP id t12-20020adfba4c000000b0021e7440666bso2504384wrg.22
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 07:11:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=hhBNIOM9Y2xU0B1BDjyol1FutIC8XO8BHPDwpu5KbpE=;
        b=Z3MkQW2XyaTYil/XKblYN6RPK3fExVsIUM10FQpRs0yZmpI8SPHbGgv7HK1w/qwmy4
         tnIk1YefdSCeheSmLVrCqBZwLaTHjwbu20TEphcuRW+A4H6JVu6LtZ9M7Wl6nB5Ztmqx
         SujecQx9WmImupb0/i65ywLjBWLkFQAufZDWaqfLXggHk3560a6OZ+UsaYjg7aVrIPEa
         eIB3Z/VoY96R+UiGKls/85iPS72X8Fx9zgGZYZUkSuZuLDbL6KdNRH87QuR2yx3j8P4a
         RnhEnGftgZEGaP6mx3afl/k1SLLIIvUS60G9P+Bx+nOP27LwHo/odDY8T6g63ASxz3Ew
         lykw==
X-Gm-Message-State: ACgBeo2qyn1QV4Aj+VNcSr2iisDAMkPbP5jK7q6AmdEZck9dfQwom3wd
        2itYOxJDG9JA88/vDHzlqoDfrJt9MnhnOEKEvW8fmka+GoQDPgMdwjxpSLKcjlOTwNh6c54DWOS
        4Nvu3vUOi5dJT
X-Received: by 2002:a5d:6789:0:b0:225:2787:d44f with SMTP id v9-20020a5d6789000000b002252787d44fmr1371307wru.343.1660745503414;
        Wed, 17 Aug 2022 07:11:43 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7FtmPbJkVUUOIDvJkFxc1DH4AMeUJRh/F634N7Z9i4Yie8G/9NRJlhgrACBIkDvhRCWVQ75Q==
X-Received: by 2002:a5d:6789:0:b0:225:2787:d44f with SMTP id v9-20020a5d6789000000b002252787d44fmr1371292wru.343.1660745503152;
        Wed, 17 Aug 2022 07:11:43 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id l4-20020adffe84000000b0021eff2ecb31sm13159139wrr.95.2022.08.17.07.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 07:11:42 -0700 (PDT)
Message-ID: <79f46ce48d71fbe6290b621cca6c1b15727b42d0.camel@redhat.com>
Subject: Re: [PATCH v2 9/9] KVM: x86: never write to memory from
 kvm_vcpu_check_block
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com
Date:   Wed, 17 Aug 2022 17:11:41 +0300
In-Reply-To: <YvwsBC2HqodxaYRJ@google.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
         <20220811210605.402337-10-pbonzini@redhat.com>
         <YvwsBC2HqodxaYRJ@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-08-16 at 23:45 +0000, Sean Christopherson wrote:
> On Thu, Aug 11, 2022, Paolo Bonzini wrote:
> > kvm_vcpu_check_block() is called while not in TASK_RUNNING, and therefore
> > it cannot sleep.  Writing to guest memory is therefore forbidden, but it
> > can happen on AMD processors if kvm_check_nested_events() causes a vmexit.
> > 
> > Fortunately, all events that are caught by kvm_check_nested_events() are
> > also recognized by kvm_vcpu_has_events() through vendor callbacks such as
> > kvm_x86_interrupt_allowed() or kvm_x86_ops.nested_ops->has_events(), so
> > remove the call and postpone the actual processing to vcpu_block().
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 5e9358ea112b..9226fd536783 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10639,6 +10639,17 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
> >                         return 1;
> >         }
> >  
> > +       if (is_guest_mode(vcpu)) {
> > +               /*
> > +                * Evaluate nested events before exiting the halted state.
> > +                * This allows the halt state to be recorded properly in
> > +                * the VMCS12's activity state field (AMD does not have
> > +                * a similar field and a vmexit always causes a spurious
> > +                * wakeup from HLT).
> > +                */

I assume that the comment refers to the fact that nested_vmx_vmexit due to event
on the HLT instruction, will trigger update of the 'vmcs12->guest_activity_state'
so it should be done before we update the 'vcpu->arch.mp_state'


> > +               kvm_check_nested_events(vcpu);
> 
> Formatting nit, I'd prefer the block comment go above the if-statement, that way
> we avoiding debating whether or not the technically-unnecessary braces align with
> kernel/KVM style, and it doesn't have to wrap as aggressively.
> 
> And s/vmexit/VM-Exit while I'm nitpicking.
> 
>         /*
>          * Evaluate nested events before exiting the halted state.  This allows
>          * the halt state to be recorded properly in the VMCS12's activity
>          * state field (AMD does not have a similar field and a VM-Exit always
>          * causes a spurious wakeup from HLT).
>          */
>         if (is_guest_mode(vcpu))
>                 kvm_check_nested_events(vcpu);
> 
> Side topic, the AMD behavior is a bug report waiting to happen.  I know of at least
> one customer failure that was root caused to a KVM bug where KVM caused a spurious
> wakeup.  To be fair, the guest workload was being stupid (execute HLT on vCPU and
> then effectively unmap its code by doing kexec), but it's still an unpleasant gap :-(

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 


