Return-Path: <kvm+bounces-4517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4622B813597
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 17:02:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 696BC1C20E94
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 16:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C0805F1CA;
	Thu, 14 Dec 2023 16:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="VCjgo3GZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CE9115
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 08:02:37 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-5c66988c2eeso595026a12.1
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 08:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1702569757; x=1703174557; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IUD6uTp4X8Im/Ut4KcB1wfCy3Zhc1GmMSrEZshSdY3E=;
        b=VCjgo3GZ4HhdC/TL+iRVk8VpUbWn+R5/jBTDcMvLJMZYCZsNqMk1qYFwGD671FfDkd
         Gv05HQM4o6oS70Dc89jmrmAWxHtqHI8ohIPo8/bKe+LuFUwZA1DcJaTNDl/w21ZINYj+
         DaO+sudJuXfh+kfVGI+pk3x7+ttiWmEp+AG6l/HKuIEZLIKCRyTuVqqTlNGKw+wJarul
         YA6dymv7dtyckbcu6MVzF2QuV/Yb5fcqZDWX69edzNageruiMpcoo/9UicaYEODAsm2M
         GEY3N4ctNdGAtekbQ8Szu7R6fPyBIACBEfYRWc03VFTDaNnsN2tgdAQYfealG8iTEfzI
         Cf5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702569757; x=1703174557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IUD6uTp4X8Im/Ut4KcB1wfCy3Zhc1GmMSrEZshSdY3E=;
        b=w5R4TVCFwqq0V//g0l5OPHceCWpqaayOgjns5IVLH80eWWZK+bwTDSb4ZWrAqse9UF
         9VmHfl53WQhRVjxlhdB3PhwPGxWrxLYJF9h1Rp04L/irioi2JZcFuyCjDcuVqeBw1Aja
         2O6GCxZ4dgcHfdU2Pws8F+l4uPvFpAiPrwuXJ9xJsYFnKhP39VcG6cVOcsJZ5MCcRwPr
         9Z0qAG6mS8MfEnUTYtuu5yuckx5RKd4F+WFiIyGV3bIzCwyefMuQrM7vQF+29u875OZk
         hyySUGUvAg7/SZl8IdYrw7nQZbP33Z0Whmd4yP1+kZ7r07SdmGy5S3eMgmC3UgBoe5ON
         7Wgg==
X-Gm-Message-State: AOJu0YwCGylcUQADhWy3n1R7Z8EqEUHGyATRFPyMozpVde4BzGA9wRQS
	P+hmF1FzaFF2tUtYvqwzoiSqAK4cO6Q3XF8cAjC7Hw==
X-Google-Smtp-Source: AGHT+IF7FhGUWyOSM0oB6VYH4kQTFuKPvGHlqZoZGZnrcFHw1hYdKDWPZ8tp+Atu9sT4+CBT39si//XZm4BfjrYB1LA=
X-Received: by 2002:a17:90b:3e8e:b0:286:576a:74d4 with SMTP id
 rj14-20020a17090b3e8e00b00286576a74d4mr13535045pjb.17.1702569756502; Thu, 14
 Dec 2023 08:02:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205024310.1593100-1-atishp@rivosinc.com> <20231205024310.1593100-9-atishp@rivosinc.com>
In-Reply-To: <20231205024310.1593100-9-atishp@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 14 Dec 2023 21:32:24 +0530
Message-ID: <CAAhSdy3SL4HhXkQ4BVNLgNodfRVGCHb8xxJ7YTs-ANJH5kgXPA@mail.gmail.com>
Subject: Re: [RFC 8/9] RISC-V: KVM: Add perf sampling support for guests
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Guo Ren <guoren@kernel.org>, 
	Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 8:13=E2=80=AFAM Atish Patra <atishp@rivosinc.com> wr=
ote:
>
> KVM enables perf for guest via counter virtualization. However, the
> sampling can not be supported as there is no mechanism to enabled
> trap/emulate scountovf in ISA yet. Rely on the SBI PMU snapshot
> to provide the counter overflow data via the shared memory.
>
> In case of sampling event, the host first guest the LCOFI interrupt
> and injects to the guest via irq filtering mechanism defined in AIA
> specification. Thus, ssaia must be enabled in the host in order to
> use perf sampling in the guest. No other AIA dpeendancy w.r.t kernel

s/dpeendancy/dependency/

> is required.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/csr.h      |  3 +-
>  arch/riscv/include/uapi/asm/kvm.h |  1 +
>  arch/riscv/kvm/main.c             |  1 +
>  arch/riscv/kvm/vcpu.c             |  8 ++--
>  arch/riscv/kvm/vcpu_onereg.c      |  1 +
>  arch/riscv/kvm/vcpu_pmu.c         | 69 ++++++++++++++++++++++++++++---
>  6 files changed, 73 insertions(+), 10 deletions(-)
>
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 88cdc8a3e654..bec09b33e2f0 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -168,7 +168,8 @@
>  #define VSIP_TO_HVIP_SHIFT     (IRQ_VS_SOFT - IRQ_S_SOFT)
>  #define VSIP_VALID_MASK                ((_AC(1, UL) << IRQ_S_SOFT) | \
>                                  (_AC(1, UL) << IRQ_S_TIMER) | \
> -                                (_AC(1, UL) << IRQ_S_EXT))
> +                                (_AC(1, UL) << IRQ_S_EXT) | \
> +                                (_AC(1, UL) << IRQ_PMU_OVF))
>
>  /* AIA CSR bits */
>  #define TOPI_IID_SHIFT         16
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index 60d3b21dead7..741c16f4518e 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -139,6 +139,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>         KVM_RISCV_ISA_EXT_ZIHPM,
>         KVM_RISCV_ISA_EXT_SMSTATEEN,
>         KVM_RISCV_ISA_EXT_ZICOND,
> +       KVM_RISCV_ISA_EXT_SSCOFPMF,
>         KVM_RISCV_ISA_EXT_MAX,
>  };
>
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 225a435d9c9a..5a3a4cee0e3d 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -43,6 +43,7 @@ int kvm_arch_hardware_enable(void)
>         csr_write(CSR_HCOUNTEREN, 0x02);
>
>         csr_write(CSR_HVIP, 0);
> +       csr_write(CSR_HVIEN, 1UL << IRQ_PMU_OVF);
>
>         kvm_riscv_aia_enable();
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index e087c809073c..2d9f252356c3 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -380,7 +380,8 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcp=
u, unsigned int irq)
>         if (irq < IRQ_LOCAL_MAX &&
>             irq !=3D IRQ_VS_SOFT &&
>             irq !=3D IRQ_VS_TIMER &&
> -           irq !=3D IRQ_VS_EXT)
> +           irq !=3D IRQ_VS_EXT &&
> +           irq !=3D IRQ_PMU_OVF)
>                 return -EINVAL;
>
>         set_bit(irq, vcpu->arch.irqs_pending);
> @@ -395,14 +396,15 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *v=
cpu, unsigned int irq)
>  int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int i=
rq)
>  {
>         /*
> -        * We only allow VS-mode software, timer, and external
> +        * We only allow VS-mode software, timer, counter overflow and ex=
ternal
>          * interrupts when irq is one of the local interrupts
>          * defined by RISC-V privilege specification.
>          */
>         if (irq < IRQ_LOCAL_MAX &&
>             irq !=3D IRQ_VS_SOFT &&
>             irq !=3D IRQ_VS_TIMER &&
> -           irq !=3D IRQ_VS_EXT)
> +           irq !=3D IRQ_VS_EXT &&
> +           irq !=3D IRQ_PMU_OVF)
>                 return -EINVAL;
>
>         clear_bit(irq, vcpu->arch.irqs_pending);
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index f8c9fa0c03c5..19a0e4eaf0df 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -36,6 +36,7 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
>         /* Multi letter extensions (alphabetically sorted) */
>         KVM_ISA_EXT_ARR(SMSTATEEN),
>         KVM_ISA_EXT_ARR(SSAIA),
> +       KVM_ISA_EXT_ARR(SSCOFPMF),

Sscofpmf can't be disabled for guest so we should add it to
kvm_riscv_vcpu_isa_disable_allowed(), no ?

>         KVM_ISA_EXT_ARR(SSTC),
>         KVM_ISA_EXT_ARR(SVINVAL),
>         KVM_ISA_EXT_ARR(SVNAPOT),
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 622c4ee89e7b..86c8e92f92d3 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -229,6 +229,47 @@ static int kvm_pmu_validate_counter_mask(struct kvm_=
pmu *kvpmu, unsigned long ct
>         return 0;
>  }
>
> +static void kvm_riscv_pmu_overflow(struct perf_event *perf_event,
> +                                 struct perf_sample_data *data,
> +                                 struct pt_regs *regs)
> +{
> +       struct kvm_pmc *pmc =3D perf_event->overflow_handler_context;
> +       struct kvm_vcpu *vcpu =3D pmc->vcpu;

Ahh, the "vcpu" field is used here. Move that change from
patch7 to this patch.

> +       struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
> +       struct riscv_pmu *rpmu =3D to_riscv_pmu(perf_event->pmu);
> +       u64 period;
> +
> +       /*
> +        * Stop the event counting by directly accessing the perf_event.
> +        * Otherwise, this needs to deferred via a workqueue.
> +        * That will introduce skew in the counter value because the actu=
al
> +        * physical counter would start after returning from this functio=
n.
> +        * It will be stopped again once the workqueue is scheduled
> +        */
> +       rpmu->pmu.stop(perf_event, PERF_EF_UPDATE);
> +
> +       /*
> +        * The hw counter would start automatically when this function re=
turns.
> +        * Thus, the host may continue to interrupts and inject it to the=
 guest
> +        * even without guest configuring the next event. Depending on th=
e hardware
> +        * the host may some sluggishness only if privilege mode filterin=
g is not
> +        * available. In an ideal world, where qemu is not the only capab=
le hardware,
> +        * this can be removed.
> +        * FYI: ARM64 does this way while x86 doesn't do anything as such=
.
> +        * TODO: Should we keep it for RISC-V ?
> +        */
> +       period =3D -(local64_read(&perf_event->count));
> +
> +       local64_set(&perf_event->hw.period_left, 0);
> +       perf_event->attr.sample_period =3D period;
> +       perf_event->hw.sample_period =3D period;
> +
> +       set_bit(pmc->idx, kvpmu->pmc_overflown);
> +       kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_PMU_OVF);
> +
> +       rpmu->pmu.start(perf_event, PERF_EF_RELOAD);
> +}
> +
>  static int kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_ev=
ent_attr *attr,
>                                      unsigned long flags, unsigned long e=
idx, unsigned long evtdata)
>  {
> @@ -247,7 +288,7 @@ static int kvm_pmu_create_perf_event(struct kvm_pmc *=
pmc, struct perf_event_attr
>          */
>         attr->sample_period =3D kvm_pmu_get_sample_period(pmc);
>
> -       event =3D perf_event_create_kernel_counter(attr, -1, current, NUL=
L, pmc);
> +       event =3D perf_event_create_kernel_counter(attr, -1, current, kvm=
_riscv_pmu_overflow, pmc);
>         if (IS_ERR(event)) {
>                 pr_err("kvm pmu event creation failed for eidx %lx: %ld\n=
", eidx, PTR_ERR(event));
>                 return PTR_ERR(event);
> @@ -466,6 +507,12 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vc=
pu, unsigned long ctr_base,
>                 }
>         }
>
> +       /* The guest have serviced the interrupt and starting the counter=
 again */
> +       if (test_bit(IRQ_PMU_OVF, vcpu->arch.irqs_pending)) {
> +               clear_bit(pmc_index, kvpmu->pmc_overflown);
> +               kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_PMU_OVF);
> +       }
> +
>  out:
>         retdata->err_val =3D sbiret;
>
> @@ -537,7 +584,12 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcp=
u, unsigned long ctr_base,
>                 }
>
>                 if (bSnapshot && !sbiret) {
> -                       //TODO: Add counter overflow support when sscofpm=
f support is added
> +                       /* The counter and overflow indicies in the snaps=
hot region are w.r.to
> +                        * cbase. Modify the set bit in the counter mask =
instead of the pmc_index
> +                        * which indicates the absolute counter index.
> +                        */

Use a double winged comment block here.

> +                       if (test_bit(pmc_index, kvpmu->pmc_overflown))
> +                               kvpmu->sdata->ctr_overflow_mask |=3D (1UL=
 << i);
>                         kvpmu->sdata->ctr_values[i] =3D pmc->counter_val;
>                         kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr, =
kvpmu->sdata,
>                                              sizeof(struct riscv_pmu_snap=
shot_data));
> @@ -546,15 +598,19 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vc=
pu, unsigned long ctr_base,
>                 if (flags & SBI_PMU_STOP_FLAG_RESET) {
>                         pmc->event_idx =3D SBI_PMU_EVENT_IDX_INVALID;
>                         clear_bit(pmc_index, kvpmu->pmc_in_use);
> +                       clear_bit(pmc_index, kvpmu->pmc_overflown);
>                         if (bSnapshot) {
>                                 /* Clear the snapshot area for the upcomi=
ng deletion event */
>                                 kvpmu->sdata->ctr_values[i] =3D 0;
> +                               /* Only clear the given counter as the ca=
ller is responsible to
> +                                * validate both the overflow mask and co=
nfigured counters.
> +                                */

Use a double winged comment block here.

> +                               kvpmu->sdata->ctr_overflow_mask &=3D ~(1U=
L << i);
>                                 kvm_vcpu_write_guest(vcpu, kvpmu->snapsho=
t_addr, kvpmu->sdata,
>                                                      sizeof(struct riscv_=
pmu_snapshot_data));
>                         }
>                 }
>         }
> -
>  out:
>         retdata->err_val =3D sbiret;
>
> @@ -729,15 +785,16 @@ void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcp=
u)
>         if (!kvpmu)
>                 return;
>
> -       for_each_set_bit(i, kvpmu->pmc_in_use, RISCV_MAX_COUNTERS) {
> +       for_each_set_bit(i, kvpmu->pmc_in_use, RISCV_KVM_MAX_COUNTERS) {
>                 pmc =3D &kvpmu->pmc[i];
>                 pmc->counter_val =3D 0;
>                 kvm_pmu_release_perf_event(pmc);
>                 pmc->event_idx =3D SBI_PMU_EVENT_IDX_INVALID;
>         }
> -       bitmap_zero(kvpmu->pmc_in_use, RISCV_MAX_COUNTERS);
> +       bitmap_zero(kvpmu->pmc_in_use, RISCV_KVM_MAX_COUNTERS);
> +       bitmap_zero(kvpmu->pmc_overflown, RISCV_KVM_MAX_COUNTERS);
>         memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw=
_event));
> -       kvpmu->snapshot_addr =3D INVALID_GPA;
> +       kvm_pmu_clear_snapshot_area(vcpu);
>  }
>
>  void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> --
> 2.34.1
>

Regards,
Anup

