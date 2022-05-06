Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D094051D2A0
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 09:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389743AbiEFH5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 03:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389751AbiEFH5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 03:57:21 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88FF67D1C
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 00:53:35 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id y2so11511216ybi.7
        for <kvm@vger.kernel.org>; Fri, 06 May 2022 00:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WaBl9pAWGWFlLK9nV+267TWCL6dZ06A/NoNmIhWgBMM=;
        b=Su5V0nbXIO7rEtZnbMRp6hT4/ABpQJrp77PFoY9EtWOQEiTO3IVqGoF+Aa1fmBbLE8
         sV5G5fS9H0cy10W9/iTLIJ7MbO4JOEUT53M5bbO0n4IqbE0l1jEOckYtTcTSDQ2jQi5p
         DpGRkL6dF5eI0pWynFjtyuja8/CSpi9bcOwko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WaBl9pAWGWFlLK9nV+267TWCL6dZ06A/NoNmIhWgBMM=;
        b=B5xykr3wdtbA0mawdEkRZiWmkb4dNjq6NKJDeEGmKuCvHdfdii0eKJ/Wi8qtxOiarU
         rmbjlSK4Qlt0wHi0X1ZTQCF+eK5BF+y6OAKPE/E1040vyEwLK2XYUa/u9ZNl57hK6bCN
         dL5MoVWTocWvfHocgw9SPP5Eu/O4iSTHD1y2VR5xsWTT60aqYLGYFhdlK6GlTxbcLMBG
         Sslsc6PN/pMVXlcaiZRgRIEFr9hqyDE64guhx1F+2Lv7FXcpNmV90eVPSbtVjFlo3EOO
         +t9Edybct0nTpGhnUZtZN7oX+W6sjkkJYlia6TKpnGOvNP5NVvOE1ksFD34pMIqG75tS
         xVTQ==
X-Gm-Message-State: AOAM530Fq+RQ7lTJQkutP/+QKU/DSkKItMcIVCzF/ao+GiZpU3kCABW5
        V2PVjK/Ogz/0IXysb6zCGR30DWYb88jO4431h/Bp
X-Google-Smtp-Source: ABdhPJwLmmtcS8FQJVNzNqzWudxH3m+YT2z9bUzShy4WAKlZZxjAcINcyDUphEUReozdZ5z0y0OYdz6OJW5aQIP9RRc=
X-Received: by 2002:a5b:803:0:b0:633:749f:9acd with SMTP id
 x3-20020a5b0803000000b00633749f9acdmr1437126ybp.236.1651823615080; Fri, 06
 May 2022 00:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220420112450.155624-1-apatel@ventanamicro.com> <20220420112450.155624-8-apatel@ventanamicro.com>
In-Reply-To: <20220420112450.155624-8-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Fri, 6 May 2022 00:53:24 -0700
Message-ID: <CAOnJCUKPTwjGr9Lg1XRMVTCMswg0E+4VvknBQ0p+Qo6EHL3M5A@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] RISC-V: KVM: Cleanup stale TLB entries when host
 CPU changes
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
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

On Wed, Apr 20, 2022 at 4:25 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> On RISC-V platforms with hardware VMID support, we share same
> VMID for all VCPUs of a particular Guest/VM. This means we might
> have stale G-stage TLB entries on the current Host CPU due to
> some other VCPU of the same Guest which ran previously on the
> current Host CPU.
>
> To cleanup stale TLB entries, we simply flush all G-stage TLB
> entries by VMID whenever underlying Host CPU changes for a VCPU.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_host.h |  5 +++++
>  arch/riscv/kvm/tlb.c              | 23 +++++++++++++++++++++++
>  arch/riscv/kvm/vcpu.c             | 11 +++++++++++
>  3 files changed, 39 insertions(+)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index a40e88a9481c..94349a5ffd34 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -166,6 +166,9 @@ struct kvm_vcpu_arch {
>         /* VCPU ran at least once */
>         bool ran_atleast_once;
>
> +       /* Last Host CPU on which Guest VCPU exited */
> +       int last_exit_cpu;
> +
>         /* ISA feature bits (similar to MISA) */
>         unsigned long isa;
>
> @@ -256,6 +259,8 @@ void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
>                                      unsigned long order);
>  void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
>
> +void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu);
> +
>  void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu);
>  void kvm_riscv_hfence_gvma_vmid_all_process(struct kvm_vcpu *vcpu);
>  void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu);
> diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> index c0f86d09c41d..1a76d0b1907d 100644
> --- a/arch/riscv/kvm/tlb.c
> +++ b/arch/riscv/kvm/tlb.c
> @@ -215,6 +215,29 @@ void kvm_riscv_local_hfence_vvma_all(unsigned long vmid)
>         csr_write(CSR_HGATP, hgatp);
>  }
>
> +void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
> +{
> +       unsigned long vmid;
> +
> +       if (!kvm_riscv_gstage_vmid_bits() ||
> +           vcpu->arch.last_exit_cpu == vcpu->cpu)
> +               return;
> +
> +       /*
> +        * On RISC-V platforms with hardware VMID support, we share same
> +        * VMID for all VCPUs of a particular Guest/VM. This means we might
> +        * have stale G-stage TLB entries on the current Host CPU due to
> +        * some other VCPU of the same Guest which ran previously on the
> +        * current Host CPU.
> +        *
> +        * To cleanup stale TLB entries, we simply flush all G-stage TLB
> +        * entries by VMID whenever underlying Host CPU changes for a VCPU.
> +        */
> +
> +       vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
> +       kvm_riscv_local_hfence_gvma_vmid_all(vmid);
> +}
> +
>  void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu)
>  {
>         local_flush_icache_all();
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 9cd8f6e91c98..a86710fcd2e0 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -67,6 +67,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>         if (loaded)
>                 kvm_arch_vcpu_put(vcpu);
>
> +       vcpu->arch.last_exit_cpu = -1;
> +
>         memcpy(csr, reset_csr, sizeof(*csr));
>
>         memcpy(cntx, reset_cntx, sizeof(*cntx));
> @@ -735,6 +737,7 @@ static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>  {
>         guest_state_enter_irqoff();
>         __kvm_riscv_switch_to(&vcpu->arch);
> +       vcpu->arch.last_exit_cpu = vcpu->cpu;
>         guest_state_exit_irqoff();
>  }
>
> @@ -829,6 +832,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                         continue;
>                 }
>
> +               /*
> +                * Cleanup stale TLB enteries
> +                *
> +                * Note: This should be done after G-stage VMID has been
> +                * updated using kvm_riscv_gstage_vmid_ver_changed()
> +                */
> +               kvm_riscv_local_tlb_sanitize(vcpu);
> +
>                 guest_timing_enter_irqoff();
>
>                 kvm_riscv_vcpu_enter_exit(vcpu);
> --
> 2.25.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
-- 
Regards,
Atish
