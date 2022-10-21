Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5AF607054
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 08:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJUGro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 02:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJUGrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 02:47:42 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D0D242C9A
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 23:47:39 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id 13so4868847ejn.3
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 23:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Rz8S9MMQRt8zPpvrNpbhX5Tj2i1jjVBTVbkbjHZYyRM=;
        b=WQE6C3Cfh/sF5gQfmupWGacH2Ck1q0VF6PV83R45exfq8m59GATBQ3H7J//jcxkDNp
         G5K4CG+PbOJLrmWYhAR+g8BWQMn5Z6qYhOMx5XVIviGST2E1FHLZZWRKOfmraGsN8XHd
         krPv/COxA8nMYOyAbxPmWNNhNsaAflvIMqNuUzeOjyoFDr/zP8H5j5knuj4YC+8zSA1V
         NIgGclsyH5FaFGXoznhSAUviqAmc+BhFrn5MHPpBta5k8wmZLQKFQWzTj9/adOXgdpUv
         t5GRkqbIHJC+lsgAdGQrVAUeOZcpGxDsSPPuJgzz0mnOxsaT57QFq3vNIdDyas0tI1av
         +Rqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rz8S9MMQRt8zPpvrNpbhX5Tj2i1jjVBTVbkbjHZYyRM=;
        b=IFB5khBjuOpbpXe9CzxepO7afR3SLRegyMIe2wRhx0Da0UmnXs2hKwGuQcplnSP1uP
         Y9aAOqeMbPtLOoVvTJBHhQ6DTEEHSYPPdIphkhmh3iSUkh/zP59BnNgMtO9QeExA9tqJ
         TK3X+5kVshQLXdmlfaHc17qmCQv3Kf0uRzs+Iyrhgs1WbJu3Dmf3gniY1NI9sld2Zzct
         eqwLhBTsjQF+EUJ+jUtoVw+JEu3Th6SJIF69w159ieuB4em1W2h1dJJ0NICHErSDlyRh
         si806ZdFywPwfuUgab6rS7s+yW9UAsa8QwsDXHJVLRuKyTtopeSFoekB6gPRNcxidJ2B
         cwXA==
X-Gm-Message-State: ACrzQf3HElRGzkGImn+FANdNiimEdvki/BPh7Qm7z5lcD54ZIiB5njSH
        IyVgq3dZ9gcCzmSVAHM8bTgd78ql3Inl2gb2llSQFQ==
X-Google-Smtp-Source: AMsMyM6pQHRPA5JEM3T9CLocnalknf1b06jBC2miJcOeuA6fxx8hkV1pE7MgAVLDnlzbb1EL4XbFpDUSEcapbRUtloI=
X-Received: by 2002:a17:906:dac8:b0:741:545b:796a with SMTP id
 xi8-20020a170906dac800b00741545b796amr13903081ejb.240.1666334857669; Thu, 20
 Oct 2022 23:47:37 -0700 (PDT)
MIME-Version: 1.0
References: <20221019114535.131469-1-apatel@ventanamicro.com> <CAOnJCUJYQegEa3H+1drGAcy5ptEku9A3gtKWkOm=imC62S4UZw@mail.gmail.com>
In-Reply-To: <CAOnJCUJYQegEa3H+1drGAcy5ptEku9A3gtKWkOm=imC62S4UZw@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 21 Oct 2022 12:17:25 +0530
Message-ID: <CAAhSdy0B-4JobSVUP9-CPZiSu4UBYUrvxmyVjEE--O5Fb6V_Ew@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 21, 2022 at 11:34 AM Atish Patra <atishp@atishpatra.org> wrote:
>
> On Wed, Oct 19, 2022 at 4:45 AM Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > The kvm_riscv_vcpu_timer_pending() checks per-VCPU next_cycles
> > and per-VCPU software injected VS timer interrupt. This function
> > returns incorrect value when Sstc is available because the per-VCPU
> > next_cycles are only updated by kvm_riscv_vcpu_timer_save() called
> > from kvm_arch_vcpu_put(). As a result, when Sstc is available the
> > VCPU does not block properly upon WFI traps.
> >
> > To fix the above issue, we introduce kvm_riscv_vcpu_timer_sync()
> > which will update per-VCPU next_cycles upon every VM exit instead
> > of kvm_riscv_vcpu_timer_save().
> >
> > Fixes: 8f5cb44b1bae ("RISC-V: KVM: Support sstc extension")
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/kvm_vcpu_timer.h |  1 +
> >  arch/riscv/kvm/vcpu.c                   |  3 +++
> >  arch/riscv/kvm/vcpu_timer.c             | 17 +++++++++++++++--
> >  3 files changed, 19 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/include/asm/kvm_vcpu_timer.h
> > index 0d8fdb8ec63a..82f7260301da 100644
> > --- a/arch/riscv/include/asm/kvm_vcpu_timer.h
> > +++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
> > @@ -45,6 +45,7 @@ int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
> >  int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
> >  void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu);
> >  void kvm_riscv_guest_timer_init(struct kvm *kvm);
> > +void kvm_riscv_vcpu_timer_sync(struct kvm_vcpu *vcpu);
> >  void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu);
> >  bool kvm_riscv_vcpu_timer_pending(struct kvm_vcpu *vcpu);
> >
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index a032c4f0d600..71ebbc4821f0 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -708,6 +708,9 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
> >                                 clear_bit(IRQ_VS_SOFT, &v->irqs_pending);
> >                 }
> >         }
> > +
> > +       /* Sync-up timer CSRs */
> > +       kvm_riscv_vcpu_timer_sync(vcpu);
> >  }
> >
> >  int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
> > diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> > index 185f2386a747..ad34519c8a13 100644
> > --- a/arch/riscv/kvm/vcpu_timer.c
> > +++ b/arch/riscv/kvm/vcpu_timer.c
> > @@ -320,20 +320,33 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
> >         kvm_riscv_vcpu_timer_unblocking(vcpu);
> >  }
> >
> > -void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu)
> > +void kvm_riscv_vcpu_timer_sync(struct kvm_vcpu *vcpu)
> >  {
> >         struct kvm_vcpu_timer *t = &vcpu->arch.timer;
> >
> >         if (!t->sstc_enabled)
> >                 return;
> >
> > -       t = &vcpu->arch.timer;
> >  #if defined(CONFIG_32BIT)
> >         t->next_cycles = csr_read(CSR_VSTIMECMP);
> >         t->next_cycles |= (u64)csr_read(CSR_VSTIMECMPH) << 32;
> >  #else
> >         t->next_cycles = csr_read(CSR_VSTIMECMP);
> >  #endif
> > +}
> > +
> > +void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu)
> > +{
> > +       struct kvm_vcpu_timer *t = &vcpu->arch.timer;
> > +
> > +       if (!t->sstc_enabled)
> > +               return;
> > +
> > +       /*
> > +        * The vstimecmp CSRs are saved by kvm_riscv_vcpu_timer_sync()
> > +        * upon every VM exit so no need to save here.
> > +        */
> > +
> >         /* timer should be enabled for the remaining operations */
> >         if (unlikely(!t->init_done))
> >                 return;
> > --
> > 2.34.1
> >
>
> Ahh. That's a tricky one. Thanks for fixing it.
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>

Thanks, queued this patch for Linux-6.1-rcX

Regards,
Anup
