Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855A4606FCE
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 08:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiJUGEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 02:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJUGEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 02:04:53 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C680D27DC6
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 23:04:47 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id f4-20020a9d0384000000b0066208c73094so1268905otf.0
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 23:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X/GRjlz3OBLLftzrQwN2BllHc/DggggRf8lVr8VG4SA=;
        b=PlbM5iStfkae1Q3fuihRV3OvtIMUFdbkjn19h/HY9jKFba1Tf4urYPX0EG/zB7yatG
         s7vi3YRFmTBcLp1LBp6rk7GZYOgD1/amQUMV/ti4hR0UXKg4gZbsYdrIwLIUYvM2zsmx
         6gTBEYHnhNuL58sglAB9TkyAsGMYRAk/2FexE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X/GRjlz3OBLLftzrQwN2BllHc/DggggRf8lVr8VG4SA=;
        b=CoAty6faqy5SWRqTOz2VmIixA9ZfMBVkKsjNJV6TGzPNEnppdCDUaB9wrE0jtYEw9o
         Yc/gwR+e15QdxsnPBHNfczRpCEUR4AH/Jxc9JMJYYIgHGRMM+/kwMW/jvZ9Hn+HUgnu/
         cKXbf7jA8aa/Du2+WnTcO00m7xkDstn+gaDK/6LbxVevK6aQqMTlGBBIRnMUPDii+igC
         SQK4q9qhEFn5j7BsWvVZaQXn40ev4oeBXjym0qwAOfw6akgcCza8cBfuRDjMhYO7npbo
         qs+aVfFC0ZmOjhYsaEkfdRj6NLGhlttxZhC5M35kV+4D+R8suhekby8+hK5fHGJ5b3Q9
         Z50g==
X-Gm-Message-State: ACrzQf27rPXdXoZX+AuLOBTPuCCXJn8CHeTi647poCXXVHQparY1nbdH
        XvW/m1JtiIUWOSZbbKJiVYwDndvw0ZyiE82jK8t8
X-Google-Smtp-Source: AMsMyM7K0WAbqwMo/2+Tsz5RDOWzcEbuFbaCbLvJ8fnArjfYzaxeNfAApLoIPWQ2DzfEEIfMA3J1eUSOnC2ZFwE0G5c=
X-Received: by 2002:a05:6830:6611:b0:662:2725:d309 with SMTP id
 cp17-20020a056830661100b006622725d309mr507738otb.293.1666332286395; Thu, 20
 Oct 2022 23:04:46 -0700 (PDT)
MIME-Version: 1.0
References: <20221019114535.131469-1-apatel@ventanamicro.com>
In-Reply-To: <20221019114535.131469-1-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Thu, 20 Oct 2022 23:04:35 -0700
Message-ID: <CAOnJCUJYQegEa3H+1drGAcy5ptEku9A3gtKWkOm=imC62S4UZw@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022 at 4:45 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The kvm_riscv_vcpu_timer_pending() checks per-VCPU next_cycles
> and per-VCPU software injected VS timer interrupt. This function
> returns incorrect value when Sstc is available because the per-VCPU
> next_cycles are only updated by kvm_riscv_vcpu_timer_save() called
> from kvm_arch_vcpu_put(). As a result, when Sstc is available the
> VCPU does not block properly upon WFI traps.
>
> To fix the above issue, we introduce kvm_riscv_vcpu_timer_sync()
> which will update per-VCPU next_cycles upon every VM exit instead
> of kvm_riscv_vcpu_timer_save().
>
> Fixes: 8f5cb44b1bae ("RISC-V: KVM: Support sstc extension")
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_timer.h |  1 +
>  arch/riscv/kvm/vcpu.c                   |  3 +++
>  arch/riscv/kvm/vcpu_timer.c             | 17 +++++++++++++++--
>  3 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/include/asm/kvm_vcpu_timer.h
> index 0d8fdb8ec63a..82f7260301da 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_timer.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
> @@ -45,6 +45,7 @@ int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
>  int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu);
>  void kvm_riscv_guest_timer_init(struct kvm *kvm);
> +void kvm_riscv_vcpu_timer_sync(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu);
>  bool kvm_riscv_vcpu_timer_pending(struct kvm_vcpu *vcpu);
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index a032c4f0d600..71ebbc4821f0 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -708,6 +708,9 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
>                                 clear_bit(IRQ_VS_SOFT, &v->irqs_pending);
>                 }
>         }
> +
> +       /* Sync-up timer CSRs */
> +       kvm_riscv_vcpu_timer_sync(vcpu);
>  }
>
>  int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> index 185f2386a747..ad34519c8a13 100644
> --- a/arch/riscv/kvm/vcpu_timer.c
> +++ b/arch/riscv/kvm/vcpu_timer.c
> @@ -320,20 +320,33 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
>         kvm_riscv_vcpu_timer_unblocking(vcpu);
>  }
>
> -void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu)
> +void kvm_riscv_vcpu_timer_sync(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_vcpu_timer *t = &vcpu->arch.timer;
>
>         if (!t->sstc_enabled)
>                 return;
>
> -       t = &vcpu->arch.timer;
>  #if defined(CONFIG_32BIT)
>         t->next_cycles = csr_read(CSR_VSTIMECMP);
>         t->next_cycles |= (u64)csr_read(CSR_VSTIMECMPH) << 32;
>  #else
>         t->next_cycles = csr_read(CSR_VSTIMECMP);
>  #endif
> +}
> +
> +void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_timer *t = &vcpu->arch.timer;
> +
> +       if (!t->sstc_enabled)
> +               return;
> +
> +       /*
> +        * The vstimecmp CSRs are saved by kvm_riscv_vcpu_timer_sync()
> +        * upon every VM exit so no need to save here.
> +        */
> +
>         /* timer should be enabled for the remaining operations */
>         if (unlikely(!t->init_done))
>                 return;
> --
> 2.34.1
>

Ahh. That's a tricky one. Thanks for fixing it.

Reviewed-by: Atish Patra <atishp@rivosinc.com>
-- 
Regards,
Atish
