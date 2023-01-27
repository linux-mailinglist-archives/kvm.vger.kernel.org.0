Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676F067E342
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbjA0L3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbjA0L3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:29:13 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9DC7D6E2
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 03:28:16 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id r10so994083ual.3
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 03:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0iqWjsVCEit1hkNQ24VDbeVqqAX3ji5FAHQReFeDUCI=;
        b=Mij0FCcT60SxZgdLEwtlO49gGbSeVHesEUDh5wBFj/SKl2skI1+LzgHrqSskJZFOb+
         jEWEHlOFEYzTYFYBIy7lQGMi4RNQukHJdmlCegCjAmppq09KWOBGho+pVKdm0QGRgMh2
         dqafK7IrZOybzvSHnOP/oJxzuuOoKzktZfB4jRCswS8/gvIt++92Nf1beLaWtrxypKcO
         n+zZdgNjqYV/4OpuHBqgquczB+6EmHVQfyz61yzKA5O6/hE6a0sXbi778Lr2YBYUHCVy
         gK8dnYFYIUnsQNXz8h9ZMyNSPTgw17PFQYL+sMLmUGvb0ZbVeTdq2zVSf5vPa7N2zic8
         16Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0iqWjsVCEit1hkNQ24VDbeVqqAX3ji5FAHQReFeDUCI=;
        b=Y1dnHXiMWpO1DzQzM0khoPtsqgFwZLEZvOjJdyZCucFXRrdZXcERFrrUAcbceUZPhg
         IIXViEfylFc0iS3Dcg8GmwpdnOlQustuO4rAQK7z1qdbyQB1hXW0Crw6FqmAMWbtcb9Z
         nNHvmIXhuGNtMGbxmgyoGfYlmy2SEDl2L+PUkwgfwhbNUPc7+sHBwI2amEF/mDmNLyRr
         KOwsNqbS27pH/if894IPt/TDpcJuG6HZUEFWo2uH9Ven1LT/+0msjafLH0+8WexDyheC
         EyfojMcO/eZdw8Cq0e1kELh6sl7LuQcdNl0XgEFvWSmeiLJGicFe+i9nhwqhcwvvNngl
         +oTg==
X-Gm-Message-State: AFqh2koSWmGCQhz58xpS/u802vlaEbMQvvimaC7w6eUuxZYLbeUgReNw
        m7PDnAVZHfE6Gf9/3vDOyytfVLj8akn+9W5ZLIcIEo7T623XfdvN
X-Google-Smtp-Source: AMrXdXs6r56u1t0igSLJBwGfhqedhNKS/Sm3DizC4NSBgBJyMjWkRloqcL0VPVz0jBBHQzzF8jfPUvJGA0xNsKExtqU=
X-Received: by 2002:ab0:6150:0:b0:5c3:740c:2786 with SMTP id
 w16-20020ab06150000000b005c3740c2786mr4675776uan.32.1674818895037; Fri, 27
 Jan 2023 03:28:15 -0800 (PST)
MIME-Version: 1.0
References: <20230125142056.18356-1-andy.chiu@sifive.com> <20230125142056.18356-19-andy.chiu@sifive.com>
In-Reply-To: <20230125142056.18356-19-andy.chiu@sifive.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Fri, 27 Jan 2023 16:58:02 +0530
Message-ID: <CAK9=C2UWJ1qDfyfsKiznfFTVDHbjJm89m_6ymM=jpvYs7-qNcQ@mail.gmail.com>
Subject: Re: [PATCH -next v13 18/19] riscv: kvm: redirect illegal instruction
 traps to guests
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 25, 2023 at 7:53 PM Andy Chiu <andy.chiu@sifive.com> wrote:
>
> Running below m-mode, an illegal instruction trap where m-mode could not
> handle would be redirected back to s-mode. However, kvm running in hs-mode
> terminates the vs-mode software when it receive such exception code.
> Instead, it should redirect the trap back to vs-mode, and let vs-mode trap
> handler decide the next step.
>
> Besides, hs-mode should run transparently to vs-mode. So terminating
> guest OS breaks assumption for the kernel running in vs-mode.
>
> We use first-use trap to enable Vector for user space processes. This
> means that the user process running in u- or vu- mode will take an
> illegal instruction trap for the first time using V. Then the s- or vs-
> mode kernel would allocate V for the process. Thus, we must redirect the
> trap back to vs-mode in order to get the first-use trap working for guest
> OSes here.

In general, it is a good strategy to always redirect illegal instruction
traps to VS-mode.

>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
>  arch/riscv/kvm/vcpu_exit.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index c9f741ab26f5..2a02cb750892 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -162,6 +162,16 @@ void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
>         vcpu->arch.guest_context.sepc = csr_read(CSR_VSTVEC);
>  }
>
> +static int vcpu_trap_redirect_vs(struct kvm_vcpu *vcpu,
> +                                struct kvm_cpu_trap *trap)
> +{
> +       /* set up trap handler and trap info when it gets back to vs */
> +       kvm_riscv_vcpu_trap_redirect(vcpu, trap);
> +       /* return to s-mode by setting vcpu's SPP */
> +       vcpu->arch.guest_context.sstatus |= SR_SPP;

Setting sstatus.SPP needs to be done in kvm_riscv_vcpu_trap_redirect()
because for guest all traps are always taken by VS-mode.

> +       return 1;
> +}
> +
>  /*
>   * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
>   * proper exit to userspace.
> @@ -179,6 +189,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>         ret = -EFAULT;
>         run->exit_reason = KVM_EXIT_UNKNOWN;
>         switch (trap->scause) {
> +       case EXC_INST_ILLEGAL:
> +               if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
> +                       ret = vcpu_trap_redirect_vs(vcpu, trap);
> +               break;
>         case EXC_VIRTUAL_INST_FAULT:
>                 if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
>                         ret = kvm_riscv_vcpu_virtual_insn(vcpu, run, trap);
> @@ -206,6 +220,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                         vcpu->arch.guest_context.hstatus);
>                 kvm_err("SCAUSE=0x%lx STVAL=0x%lx HTVAL=0x%lx HTINST=0x%lx\n",
>                         trap->scause, trap->stval, trap->htval, trap->htinst);
> +               asm volatile ("ebreak\n\t");

This is not a related change.

>         }
>
>         return ret;
> --
> 2.17.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

Overall, this patch can be accepted independent of this series due
to its usefulness.

I send a v2 of this patch separately.

Regards,
Anup
