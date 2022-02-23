Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE604C05B1
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 01:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbiBWACO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 19:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbiBWACN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 19:02:13 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8BC2CCB3
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 16:01:46 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2d6923bca1aso184441207b3.9
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 16:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GPhptd3Q62fbtOfa6cWbtPIF6RubFM1loZL2igvMdmE=;
        b=LqUSjl3rYV0YuRKLtFlY7VsZmTkbAFokUMymncGcEAxRSr2CTO08CjzG7Jd/homUWI
         H58m47zB2tyrKExo9jSe7/a31KeV2f2nrqAJ76PdCUz0139fOYzv6f/WWxzY7pIp2JQO
         VHMGaT6C9kp8Ry/qazQ3ThDrH4nfaT+Aikl30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GPhptd3Q62fbtOfa6cWbtPIF6RubFM1loZL2igvMdmE=;
        b=Y3vUT1EkzPXdAuHFvb/oO4SUzMxhzCyWZBnwffxBce0pX+CMX27Xc2JzpARzxn0VA3
         HnA80Eeafkt7o0jcH4nnlAmj2eZ6geajxelg/Y8RadW7OKCiv/kwZl9qz+u+Qqg4/MMa
         OZkxHsPKg76t0nZ44wBJ3ZiJbzbIAUInEp486iNYpgCTBCVh5RJRtGz3seG4388xRfKz
         LVz18RYhZjveR+SF03OX6OTdVy80sW9R19oqnt+5AISVuYksoTO7I/piOu83fFpjFexh
         kTGrwoYLaK4VF+jM2EfoK2YgQb7q4MuVOFhezOoo7iUDicoMOsYKvm+0A5OX8x/1Pft2
         zENQ==
X-Gm-Message-State: AOAM533KYvi2gLiH6eIcDsb7f7NIZF4eOtdYRB5kHxB0dMg3SfINVZ7l
        YS/JmrQFj1ITlXZbOgeB5cEM6rU5QoN5fHNQ9Umr
X-Google-Smtp-Source: ABdhPJxTCHh8uquJeYeoe50oLeU6Bdpto7tc4MgAb7JncyAK/4PlHxHbP8Krj0AfySlfD5bvHZGz4ZDB66Qy3/SERSk=
X-Received: by 2002:a0d:d512:0:b0:2d1:51a:5616 with SMTP id
 x18-20020a0dd512000000b002d1051a5616mr26739511ywd.62.1645574505487; Tue, 22
 Feb 2022 16:01:45 -0800 (PST)
MIME-Version: 1.0
References: <20220201082227.361967-1-apatel@ventanamicro.com> <20220201082227.361967-6-apatel@ventanamicro.com>
In-Reply-To: <20220201082227.361967-6-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 22 Feb 2022 16:01:34 -0800
Message-ID: <CAOnJCUJE_FqmvTXrwRafGtDEKomm0idSPjSRsnVYr3-HzuCh9A@mail.gmail.com>
Subject: Re: [PATCH 5/6] RISC-V: KVM: Add common kvm_riscv_vcpu_wfi() function
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 1, 2022 at 12:24 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The wait for interrupt (WFI) instruction emulation can share the VCPU
> halt logic with SBI HSM suspend emulation so this patch adds a common
> kvm_riscv_vcpu_wfi() function for this purpose.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_host.h |  1 +
>  arch/riscv/kvm/vcpu_exit.c        | 22 ++++++++++++++++------
>  2 files changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 99ef6a120617..78da839657e5 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -228,6 +228,7 @@ void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu);
>
>  void __kvm_riscv_unpriv_trap(void);
>
> +void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu);
>  unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
>                                          bool read_insn,
>                                          unsigned long guest_addr,
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index 571f319e995a..aa8af129e4bb 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -144,12 +144,7 @@ static int system_opcode_insn(struct kvm_vcpu *vcpu,
>  {
>         if ((insn & INSN_MASK_WFI) == INSN_MATCH_WFI) {
>                 vcpu->stat.wfi_exit_stat++;
> -               if (!kvm_arch_vcpu_runnable(vcpu)) {
> -                       srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
> -                       kvm_vcpu_halt(vcpu);
> -                       vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> -                       kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> -               }
> +               kvm_riscv_vcpu_wfi(vcpu);
>                 vcpu->arch.guest_context.sepc += INSN_LEN(insn);
>                 return 1;
>         }
> @@ -453,6 +448,21 @@ static int stage2_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
>         return 1;
>  }
>
> +/**
> + * kvm_riscv_vcpu_wfi -- Emulate wait for interrupt (WFI) behaviour
> + *
> + * @vcpu: The VCPU pointer
> + */
> +void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu)
> +{
> +       if (!kvm_arch_vcpu_runnable(vcpu)) {
> +               srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
> +               kvm_vcpu_halt(vcpu);
> +               vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> +               kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> +       }
> +}
> +
>  /**
>   * kvm_riscv_vcpu_unpriv_read -- Read machine word from Guest memory
>   *
> --
> 2.25.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>

--
Regards,
Atish
