Return-Path: <kvm+bounces-29181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A03AC9A4701
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 21:31:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B098285727
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 19:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7615520493C;
	Fri, 18 Oct 2024 19:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b="e3owpdES"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF8D757F3
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 19:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729279901; cv=none; b=Mi5sqUdFYz9pWEFc6UzrkjDKT3+xfw5sSSEL0/PSDSc8IqKL4H6g3jUO3OBCwbQU7/v+O7Oma7jtGxamuuH5W6wLZ50gWW/pmw6ptaRuleV4vVpxPvIyo3Cm2qUbaTZeSqj0FZpBN5L96cXZyyzwGiT7M829M/zNXDKIVetAq0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729279901; c=relaxed/simple;
	bh=wjUS32+CQL2ugHw+l0A/U1QC/0+VpyJuqbK2xurv/3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EqlTTAqn3qLnKgnRga2dXjh+EO08GMwmAZwJu8cAxwGzLkVkLErPnoESL1yYlipyrv3bVW79lkMiaEMtPY6PEoHaMPS0hyhPOjLcpUB/LtKzryu6MryO8ZsKniXpV64i1OOZ1ZvHJk2rV2TFHSZejMIbfJaUsYUDJ61DzxVplBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org; spf=pass smtp.mailfrom=atishpatra.org; dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b=e3owpdES; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atishpatra.org
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539fb49c64aso3684291e87.0
        for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 12:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1729279896; x=1729884696; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q5+f1ndZOD1I0MZDk9+m1YrIuOy4ctmGYdn7Pfhl7j8=;
        b=e3owpdESbBGXEjBST+VYWyTafJiCBHKzgsgCrdebhfM3gtipNLjwG4tqg22AxsuMUr
         DgKxjWTtRvDN+YFaP3Z+SUTW4c0i9FZENDSuIuY7qTuVYUdydUbZbWrAt84yEJTQ8Skd
         P/c38LBUOFTqdvLJJVYo++VJUcvRa+9t6+AGc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729279896; x=1729884696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q5+f1ndZOD1I0MZDk9+m1YrIuOy4ctmGYdn7Pfhl7j8=;
        b=F7e/Sy4UEwwBJkm80HQd0+6aqvpX0YfPuNlTpTJE1aCD+KeCh8u2gQ8pYPeJi+3AVb
         wfYWtKWhotlFE4U+B/oOoMjBaST75T0swEaZwnP+suUdikEtei+Md2MFkMb/5/Gb3jC1
         zGOxJ6vh1kLjz8FCgkIQzoKoQxlYfsihjBnw9xi9NEKp1IOqV/2LFsImLdia8H6WE1Ms
         OrnLpxz71ChsDJraw+fJx5eh8wpGibCY7zwMp4i0WwCVyk6RP4mg8sbnot8cs0vps8cT
         Xzi1tI65HqRnFRHwfc1V+cEwJhdOTsFcovak90epdhlLQ7x99qPkp0zsTLVQadm0O1SR
         jYSw==
X-Forwarded-Encrypted: i=1; AJvYcCU2W6/Htvqkm7bijwL7hMWCHXhyQz33B47jYyBLcz+uSvriqaB8b1mP1sUmM8ctPviaQpY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCJK9TlopCKFR2T5foJaLEAYPDWH2hQhuHA/ULCP6YlD1NjB4B
	uovx5cAhHPnrvHMPoBiXLIX4/azMvINecZR9/jXxQR10mWgi8+G49pgnblIGHgHX2oWMq6c0g2Q
	x/4+3KcDczbUpyDYuiZqDfm2MJ/7Fl0IwsBrx
X-Google-Smtp-Source: AGHT+IETeMlzGRso815J4CTv+uxhL7fwllyynCoRPhVRlXdTD/FNhGDmVkq2YD+U5Cneko/uE8SOQJx5yxx7P3DBa6c=
X-Received: by 2002:a05:6512:b98:b0:539:959e:f0d0 with SMTP id
 2adb3069b0e04-53a15444851mr3569218e87.21.1729279896356; Fri, 18 Oct 2024
 12:31:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719160913.342027-1-apatel@ventanamicro.com> <20240719160913.342027-10-apatel@ventanamicro.com>
In-Reply-To: <20240719160913.342027-10-apatel@ventanamicro.com>
From: Atish Patra <atishp@atishpatra.org>
Date: Fri, 18 Oct 2024 12:31:24 -0700
Message-ID: <CAOnJCU+a+axzHNM=caCE7h6bvZ5Z7RTd6fxZmOgTyXGZ+p9d=g@mail.gmail.com>
Subject: Re: [PATCH 09/13] RISC-V: KVM: Use nacl_csr_xyz() for accessing
 H-extension CSRs
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024 at 9:09=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> When running under some other hypervisor, prefer nacl_csr_xyz()
> for accessing H-extension CSRs in the run-loop. This makes CSR
> access faster whenever SBI nested acceleration is available.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/mmu.c        |   4 +-
>  arch/riscv/kvm/vcpu.c       | 103 +++++++++++++++++++++++++-----------
>  arch/riscv/kvm/vcpu_timer.c |  28 +++++-----
>  3 files changed, 87 insertions(+), 48 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index b63650f9b966..45ace9138947 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -15,7 +15,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/kvm_host.h>
>  #include <linux/sched/signal.h>
> -#include <asm/csr.h>
> +#include <asm/kvm_nacl.h>
>  #include <asm/page.h>
>  #include <asm/pgtable.h>
>
> @@ -732,7 +732,7 @@ void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *v=
cpu)
>         hgatp |=3D (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) & HGATP_=
VMID;
>         hgatp |=3D (k->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;
>
> -       csr_write(CSR_HGATP, hgatp);
> +       ncsr_write(CSR_HGATP, hgatp);
>
>         if (!kvm_riscv_gstage_vmid_bits())
>                 kvm_riscv_local_hfence_gvma_all();
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 957e1a5e081b..00baaf1b0136 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -17,8 +17,8 @@
>  #include <linux/sched/signal.h>
>  #include <linux/fs.h>
>  #include <linux/kvm_host.h>
> -#include <asm/csr.h>
>  #include <asm/cacheflush.h>
> +#include <asm/kvm_nacl.h>
>  #include <asm/kvm_vcpu_vector.h>
>
>  #define CREATE_TRACE_POINTS
> @@ -361,10 +361,10 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu=
 *vcpu)
>         struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
>
>         /* Read current HVIP and VSIE CSRs */
> -       csr->vsie =3D csr_read(CSR_VSIE);
> +       csr->vsie =3D ncsr_read(CSR_VSIE);
>
>         /* Sync-up HVIP.VSSIP bit changes does by Guest */
> -       hvip =3D csr_read(CSR_HVIP);
> +       hvip =3D ncsr_read(CSR_HVIP);
>         if ((csr->hvip ^ hvip) & (1UL << IRQ_VS_SOFT)) {
>                 if (hvip & (1UL << IRQ_VS_SOFT)) {
>                         if (!test_and_set_bit(IRQ_VS_SOFT,
> @@ -561,26 +561,49 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_=
vcpu *vcpu)
>
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
> +       void *nsh;
>         struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
>         struct kvm_vcpu_config *cfg =3D &vcpu->arch.cfg;
>
> -       csr_write(CSR_VSSTATUS, csr->vsstatus);
> -       csr_write(CSR_VSIE, csr->vsie);
> -       csr_write(CSR_VSTVEC, csr->vstvec);
> -       csr_write(CSR_VSSCRATCH, csr->vsscratch);
> -       csr_write(CSR_VSEPC, csr->vsepc);
> -       csr_write(CSR_VSCAUSE, csr->vscause);
> -       csr_write(CSR_VSTVAL, csr->vstval);
> -       csr_write(CSR_HEDELEG, cfg->hedeleg);
> -       csr_write(CSR_HVIP, csr->hvip);
> -       csr_write(CSR_VSATP, csr->vsatp);
> -       csr_write(CSR_HENVCFG, cfg->henvcfg);
> -       if (IS_ENABLED(CONFIG_32BIT))
> -               csr_write(CSR_HENVCFGH, cfg->henvcfg >> 32);
> -       if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN)) {
> -               csr_write(CSR_HSTATEEN0, cfg->hstateen0);
> +       if (kvm_riscv_nacl_sync_csr_available()) {
> +               nsh =3D nacl_shmem();
> +               nacl_csr_write(nsh, CSR_VSSTATUS, csr->vsstatus);
> +               nacl_csr_write(nsh, CSR_VSIE, csr->vsie);
> +               nacl_csr_write(nsh, CSR_VSTVEC, csr->vstvec);
> +               nacl_csr_write(nsh, CSR_VSSCRATCH, csr->vsscratch);
> +               nacl_csr_write(nsh, CSR_VSEPC, csr->vsepc);
> +               nacl_csr_write(nsh, CSR_VSCAUSE, csr->vscause);
> +               nacl_csr_write(nsh, CSR_VSTVAL, csr->vstval);
> +               nacl_csr_write(nsh, CSR_HEDELEG, cfg->hedeleg);
> +               nacl_csr_write(nsh, CSR_HVIP, csr->hvip);
> +               nacl_csr_write(nsh, CSR_VSATP, csr->vsatp);
> +               nacl_csr_write(nsh, CSR_HENVCFG, cfg->henvcfg);
> +               if (IS_ENABLED(CONFIG_32BIT))
> +                       nacl_csr_write(nsh, CSR_HENVCFGH, cfg->henvcfg >>=
 32);
> +               if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN)=
) {
> +                       nacl_csr_write(nsh, CSR_HSTATEEN0, cfg->hstateen0=
);
> +                       if (IS_ENABLED(CONFIG_32BIT))
> +                               nacl_csr_write(nsh, CSR_HSTATEEN0H, cfg->=
hstateen0 >> 32);
> +               }
> +       } else {
> +               csr_write(CSR_VSSTATUS, csr->vsstatus);
> +               csr_write(CSR_VSIE, csr->vsie);
> +               csr_write(CSR_VSTVEC, csr->vstvec);
> +               csr_write(CSR_VSSCRATCH, csr->vsscratch);
> +               csr_write(CSR_VSEPC, csr->vsepc);
> +               csr_write(CSR_VSCAUSE, csr->vscause);
> +               csr_write(CSR_VSTVAL, csr->vstval);
> +               csr_write(CSR_HEDELEG, cfg->hedeleg);
> +               csr_write(CSR_HVIP, csr->hvip);
> +               csr_write(CSR_VSATP, csr->vsatp);
> +               csr_write(CSR_HENVCFG, cfg->henvcfg);
>                 if (IS_ENABLED(CONFIG_32BIT))
> -                       csr_write(CSR_HSTATEEN0H, cfg->hstateen0 >> 32);
> +                       csr_write(CSR_HENVCFGH, cfg->henvcfg >> 32);
> +               if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN)=
) {
> +                       csr_write(CSR_HSTATEEN0, cfg->hstateen0);
> +                       if (IS_ENABLED(CONFIG_32BIT))
> +                               csr_write(CSR_HSTATEEN0H, cfg->hstateen0 =
>> 32);
> +               }
>         }
>
>         kvm_riscv_gstage_update_hgatp(vcpu);
> @@ -603,6 +626,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cp=
u)
>
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
> +       void *nsh;
>         struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
>
>         vcpu->cpu =3D -1;
> @@ -618,15 +642,28 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>                                          vcpu->arch.isa);
>         kvm_riscv_vcpu_host_vector_restore(&vcpu->arch.host_context);
>
> -       csr->vsstatus =3D csr_read(CSR_VSSTATUS);
> -       csr->vsie =3D csr_read(CSR_VSIE);
> -       csr->vstvec =3D csr_read(CSR_VSTVEC);
> -       csr->vsscratch =3D csr_read(CSR_VSSCRATCH);
> -       csr->vsepc =3D csr_read(CSR_VSEPC);
> -       csr->vscause =3D csr_read(CSR_VSCAUSE);
> -       csr->vstval =3D csr_read(CSR_VSTVAL);
> -       csr->hvip =3D csr_read(CSR_HVIP);
> -       csr->vsatp =3D csr_read(CSR_VSATP);
> +       if (kvm_riscv_nacl_available()) {

Should we leave a comment here why ncsr_read is not efficient here
i.e. due to block access ?

> +               nsh =3D nacl_shmem();
> +               csr->vsstatus =3D nacl_csr_read(nsh, CSR_VSSTATUS);
> +               csr->vsie =3D nacl_csr_read(nsh, CSR_VSIE);
> +               csr->vstvec =3D nacl_csr_read(nsh, CSR_VSTVEC);
> +               csr->vsscratch =3D nacl_csr_read(nsh, CSR_VSSCRATCH);
> +               csr->vsepc =3D nacl_csr_read(nsh, CSR_VSEPC);
> +               csr->vscause =3D nacl_csr_read(nsh, CSR_VSCAUSE);
> +               csr->vstval =3D nacl_csr_read(nsh, CSR_VSTVAL);
> +               csr->hvip =3D nacl_csr_read(nsh, CSR_HVIP);
> +               csr->vsatp =3D nacl_csr_read(nsh, CSR_VSATP);
> +       } else {
> +               csr->vsstatus =3D csr_read(CSR_VSSTATUS);
> +               csr->vsie =3D csr_read(CSR_VSIE);
> +               csr->vstvec =3D csr_read(CSR_VSTVEC);
> +               csr->vsscratch =3D csr_read(CSR_VSSCRATCH);
> +               csr->vsepc =3D csr_read(CSR_VSEPC);
> +               csr->vscause =3D csr_read(CSR_VSCAUSE);
> +               csr->vstval =3D csr_read(CSR_VSTVAL);
> +               csr->hvip =3D csr_read(CSR_HVIP);
> +               csr->vsatp =3D csr_read(CSR_VSATP);
> +       }
>  }
>
>  static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
> @@ -681,7 +718,7 @@ static void kvm_riscv_update_hvip(struct kvm_vcpu *vc=
pu)
>  {
>         struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
>
> -       csr_write(CSR_HVIP, csr->hvip);
> +       ncsr_write(CSR_HVIP, csr->hvip);
>         kvm_riscv_vcpu_aia_update_hvip(vcpu);
>  }
>
> @@ -728,7 +765,9 @@ static void noinstr kvm_riscv_vcpu_enter_exit(struct =
kvm_vcpu *vcpu)
>         kvm_riscv_vcpu_swap_in_guest_state(vcpu);
>         guest_state_enter_irqoff();
>
> -       hcntx->hstatus =3D csr_swap(CSR_HSTATUS, gcntx->hstatus);
> +       hcntx->hstatus =3D ncsr_swap(CSR_HSTATUS, gcntx->hstatus);
> +
> +       nsync_csr(-1UL);
>
>         __kvm_riscv_switch_to(&vcpu->arch);
>
> @@ -863,8 +902,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                 trap.sepc =3D vcpu->arch.guest_context.sepc;
>                 trap.scause =3D csr_read(CSR_SCAUSE);
>                 trap.stval =3D csr_read(CSR_STVAL);
> -               trap.htval =3D csr_read(CSR_HTVAL);
> -               trap.htinst =3D csr_read(CSR_HTINST);
> +               trap.htval =3D ncsr_read(CSR_HTVAL);
> +               trap.htinst =3D ncsr_read(CSR_HTINST);
>
>                 /* Syncup interrupts state with HW */
>                 kvm_riscv_vcpu_sync_interrupts(vcpu);
> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> index 75486b25ac45..96e7a4e463f7 100644
> --- a/arch/riscv/kvm/vcpu_timer.c
> +++ b/arch/riscv/kvm/vcpu_timer.c
> @@ -11,8 +11,8 @@
>  #include <linux/kvm_host.h>
>  #include <linux/uaccess.h>
>  #include <clocksource/timer-riscv.h>
> -#include <asm/csr.h>
>  #include <asm/delay.h>
> +#include <asm/kvm_nacl.h>
>  #include <asm/kvm_vcpu_timer.h>
>
>  static u64 kvm_riscv_current_cycles(struct kvm_guest_timer *gt)
> @@ -72,12 +72,12 @@ static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcp=
u_timer *t)
>  static int kvm_riscv_vcpu_update_vstimecmp(struct kvm_vcpu *vcpu, u64 nc=
ycles)
>  {
>  #if defined(CONFIG_32BIT)
> -               csr_write(CSR_VSTIMECMP, ncycles & 0xFFFFFFFF);
> -               csr_write(CSR_VSTIMECMPH, ncycles >> 32);
> +       ncsr_write(CSR_VSTIMECMP, ncycles & 0xFFFFFFFF);
> +       ncsr_write(CSR_VSTIMECMPH, ncycles >> 32);
>  #else
> -               csr_write(CSR_VSTIMECMP, ncycles);
> +       ncsr_write(CSR_VSTIMECMP, ncycles);
>  #endif
> -               return 0;
> +       return 0;
>  }
>
>  static int kvm_riscv_vcpu_update_hrtimer(struct kvm_vcpu *vcpu, u64 ncyc=
les)
> @@ -289,10 +289,10 @@ static void kvm_riscv_vcpu_update_timedelta(struct =
kvm_vcpu *vcpu)
>         struct kvm_guest_timer *gt =3D &vcpu->kvm->arch.timer;
>
>  #if defined(CONFIG_32BIT)
> -       csr_write(CSR_HTIMEDELTA, (u32)(gt->time_delta));
> -       csr_write(CSR_HTIMEDELTAH, (u32)(gt->time_delta >> 32));
> +       ncsr_write(CSR_HTIMEDELTA, (u32)(gt->time_delta));
> +       ncsr_write(CSR_HTIMEDELTAH, (u32)(gt->time_delta >> 32));
>  #else
> -       csr_write(CSR_HTIMEDELTA, gt->time_delta);
> +       ncsr_write(CSR_HTIMEDELTA, gt->time_delta);
>  #endif
>  }
>
> @@ -306,10 +306,10 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *=
vcpu)
>                 return;
>
>  #if defined(CONFIG_32BIT)
> -       csr_write(CSR_VSTIMECMP, (u32)t->next_cycles);
> -       csr_write(CSR_VSTIMECMPH, (u32)(t->next_cycles >> 32));
> +       ncsr_write(CSR_VSTIMECMP, (u32)t->next_cycles);
> +       ncsr_write(CSR_VSTIMECMPH, (u32)(t->next_cycles >> 32));
>  #else
> -       csr_write(CSR_VSTIMECMP, t->next_cycles);
> +       ncsr_write(CSR_VSTIMECMP, t->next_cycles);
>  #endif
>
>         /* timer should be enabled for the remaining operations */
> @@ -327,10 +327,10 @@ void kvm_riscv_vcpu_timer_sync(struct kvm_vcpu *vcp=
u)
>                 return;
>
>  #if defined(CONFIG_32BIT)
> -       t->next_cycles =3D csr_read(CSR_VSTIMECMP);
> -       t->next_cycles |=3D (u64)csr_read(CSR_VSTIMECMPH) << 32;
> +       t->next_cycles =3D ncsr_read(CSR_VSTIMECMP);
> +       t->next_cycles |=3D (u64)ncsr_read(CSR_VSTIMECMPH) << 32;
>  #else
> -       t->next_cycles =3D csr_read(CSR_VSTIMECMP);
> +       t->next_cycles =3D ncsr_read(CSR_VSTIMECMP);
>  #endif
>  }
>
> --
> 2.34.1
>

Otherwise, LGTM.

Reviewed-by: Atish Patra <atishp@rivosinc.com>

--=20
Regards,
Atish

