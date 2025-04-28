Return-Path: <kvm+bounces-44568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5131A9F072
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 14:16:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 369FB189A787
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 12:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5597267B6F;
	Mon, 28 Apr 2025 12:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="WyHeKxpc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09744C91
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 12:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745842575; cv=none; b=j5Khg7ZSvuQS8TUTSZe27AoU0Wfy6TPRTFHOtJiIY08Qovc3Tw2+odPrkEI3B29Wr27HcV3WoM/j1RHhOkzTS4rJCcXA4BDLt0Fx8sezADrTiAmQKaR3RFMi1Gftqjsgolml9yOx2o8VUaZ8+n1/7P2IuoDdpob8Cl9hc33gySs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745842575; c=relaxed/simple;
	bh=XugjmXpHuxO+QNSgqsjcJKdGTschBE4azd1/psqApxc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KEiDgogXfAH79AfMjCn5eP0r3i80ge0S9NHWkudV/xUfWQOPRuvNDGTvrovpE3IUgBAO4b2/0t2s1+D2SEYW7DuDIQr73PwJUEo9rW+xvQrAOaGC5732aX+p3oAFgg9Bd3JxsQ57OKLo4O6iXScMS3UieH5co9iG1RVfIShSpwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=WyHeKxpc; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3cda56e1dffso27045825ab.1
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 05:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1745842573; x=1746447373; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HbdzURfIe01IodktyrOcLGPasTtcLPNt+DtRHrYSImE=;
        b=WyHeKxpcdcxDke0lP+Uot42k9vjboDZXP1jDypWqh/kzoU5oDNzY5rRp/1ToaIqogD
         Oe84q1mgEaXeXkstI7CXdrfGE+SDmcT+AmliCbQoz8K5yJNmVUs7xrWq2v808Z/ExJpd
         5K5kCGb/k7VtGS3gSuxigvut7k0zt5Qle25rWOYGZTbEtLzzPOwZ52YGkN6BnBXMeS5o
         klmYcSBR1a8gj7+ZOy2lMRnzJRdFHNlHq1O04FbPSbb7seoSWmYzM3n98hfNcU6Jlee+
         lC5tXJ5BoapCOtZ7TGqOTogJ+/NJmOVJmf1+c/b7pHt4RSJpqEd4rPdA43y5PVYxtZDF
         zN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745842573; x=1746447373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HbdzURfIe01IodktyrOcLGPasTtcLPNt+DtRHrYSImE=;
        b=Me1gvoEjJn6B7b9wfuo0eYnL8QgY/619LDz4mLht+7rPRo4jPCu5RYcExraxCGFfz1
         vAxLc/ZplTG8U8jY8Paksv37bJA5mGfnNbdE+rh8FFGEIldSPXhSaKwxTpX3N9nGX4ZS
         YO1QTyg+gu8Q/RVBto3GE8z0BiBo9aEvM2kne2J4I0QbivVLW9CMlBiUjZEGFXtvlsWd
         fCUQz+tzjc+DIF3NhtNnfuK4aTt5KqBp5nSBc8pktOshq2wg5HKHGrMO5WBtzi4jKWvI
         cabgNTE69Lm2PjPE22jeq8uQN/7GCqAxT4q9CRJJyb+4bNlUhwmRLQ9vutjZ44773pgI
         Wrdw==
X-Forwarded-Encrypted: i=1; AJvYcCXpyLr7tnAr1FlpGrJ+O+eNO/7ZMhZpb3HAZsdLlUhuwmYxOeggvTUIe9v/qtO4CxVrOMc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy99HAR0ipEmK/JwRnv4irYsTiFxymcgHw/ikxK5MyaxSfEo+7q
	SVYR/1y5eGKc59Bt9Ax8B9J88SYEgT36/FeIXwOTKON6/wGRqZA7CFpyFJpVf1nV0g8yo3LgWrz
	sVzg3f4/4aWRlVovrzasSlIFQaenkLMGYAeJtbw==
X-Gm-Gg: ASbGncsSnLzaLuRaadZuKzhAacHAi20+P/kCXLOhYtnMkKCnNy/K60JdAgk+ySDVmOF
	+xq1z+2GXYc+gxA35K2jid2cUE7ZJ3Gu5edvjT3USqj6kAO0x+tgXbXfz8czi+A1Jkjwl3c+TdP
	YJyr+YyssQ9fXbX8Ul8ntXlFU=
X-Google-Smtp-Source: AGHT+IH30MgBLDTH7B/5QQiWBxHuAJfBVt1kiE+nVZHxrCP+VMW3c4Wsg77jCNIG2Tzc9EpgjUiZyK4TjBMZxF0UzPA=
X-Received: by 2002:a05:6e02:b41:b0:3d0:4e57:bbda with SMTP id
 e9e14a558f8ab-3d942d1e920mr82667775ab.1.1745842572729; Mon, 28 Apr 2025
 05:16:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com> <20250403112522.1566629-6-rkrcmar@ventanamicro.com>
In-Reply-To: <20250403112522.1566629-6-rkrcmar@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 28 Apr 2025 17:46:01 +0530
X-Gm-Features: ATxdqUG-YIOYdPVFijv2uK03zGD7xJfJ15d_Z7nI7b9Y_YLSf8SYUAspqNJ5PIA
Message-ID: <CAAhSdy1RSpVCUzD+Aqbhh7aiQPmC2zdvuQfuOsmYNJrF3HxCsA@mail.gmail.com>
Subject: Re: [PATCH 3/5] KVM: RISC-V: remove unnecessary SBI reset state
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar=
@ventanamicro.com> wrote:
>
> The SBI reset state has only two variables -- pc and a1.
> The rest is known, so keep only the necessary information.
>
> The reset structures make sense if we want userspace to control the
> reset state (which we do), but I'd still remove them now and reintroduce
> with the userspace interface later -- we could probably have just a
> single reset state per VM, instead of a reset state for each VCPU.

The SBI spec does not define the reset state of CPUs. The SBI
implementations (aka KVM RISC-V or OpenSBI) or platform
firmwares are free to clear additional registers as part system
reset or CPU.

As part of resetting the VCPU, the in-kernel KVM clears all
the registers.

The setting of PC, A0, and A1 is only an entry condition defined
for CPUs brought-up using SBI HSM start or SBI System suspend.

We should not go ahead with this patch.

Regards,
Anup

>
> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_aia.h  |  3 --
>  arch/riscv/include/asm/kvm_host.h | 12 ++++---
>  arch/riscv/kvm/aia_device.c       |  4 +--
>  arch/riscv/kvm/vcpu.c             | 58 +++++++++++++++++--------------
>  arch/riscv/kvm/vcpu_sbi.c         |  9 +++--
>  5 files changed, 44 insertions(+), 42 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kv=
m_aia.h
> index 1f37b600ca47..3b643b9efc07 100644
> --- a/arch/riscv/include/asm/kvm_aia.h
> +++ b/arch/riscv/include/asm/kvm_aia.h
> @@ -63,9 +63,6 @@ struct kvm_vcpu_aia {
>         /* CPU AIA CSR context of Guest VCPU */
>         struct kvm_vcpu_aia_csr guest_csr;
>
> -       /* CPU AIA CSR context upon Guest VCPU reset */
> -       struct kvm_vcpu_aia_csr guest_reset_csr;
> -
>         /* Guest physical address of IMSIC for this VCPU */
>         gpa_t           imsic_addr;
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index 0e9c2fab6378..0c8c9c05af91 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -193,6 +193,12 @@ struct kvm_vcpu_smstateen_csr {
>         unsigned long sstateen0;
>  };
>
> +struct kvm_vcpu_reset_state {
> +       spinlock_t lock;
> +       unsigned long pc;
> +       unsigned long a1;
> +};
> +
>  struct kvm_vcpu_arch {
>         /* VCPU ran at least once */
>         bool ran_atleast_once;
> @@ -227,12 +233,8 @@ struct kvm_vcpu_arch {
>         /* CPU Smstateen CSR context of Guest VCPU */
>         struct kvm_vcpu_smstateen_csr smstateen_csr;
>
> -       /* CPU context upon Guest VCPU reset */
> -       struct kvm_cpu_context guest_reset_context;
> -       spinlock_t reset_cntx_lock;
> +       struct kvm_vcpu_reset_state reset_state;
>
> -       /* CPU CSR context upon Guest VCPU reset */
> -       struct kvm_vcpu_csr guest_reset_csr;
>
>         /*
>          * VCPU interrupts
> diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
> index 39cd26af5a69..43e472ff3e1a 100644
> --- a/arch/riscv/kvm/aia_device.c
> +++ b/arch/riscv/kvm/aia_device.c
> @@ -526,12 +526,10 @@ int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu=
)
>  void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_vcpu_aia_csr *csr =3D &vcpu->arch.aia_context.guest_cs=
r;
> -       struct kvm_vcpu_aia_csr *reset_csr =3D
> -                               &vcpu->arch.aia_context.guest_reset_csr;
>
>         if (!kvm_riscv_aia_available())
>                 return;
> -       memcpy(csr, reset_csr, sizeof(*csr));
> +       memset(csr, 0, sizeof(*csr));
>
>         /* Proceed only if AIA was initialized successfully */
>         if (!kvm_riscv_aia_initialized(vcpu->kvm))
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 2fb75288ecfe..b8485c1c1ce4 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -51,13 +51,40 @@ const struct kvm_stats_header kvm_vcpu_stats_header =
=3D {
>                        sizeof(kvm_vcpu_stats_desc),
>  };
>
> -static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
> +static void kvm_riscv_vcpu_context_reset(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> -       struct kvm_vcpu_csr *reset_csr =3D &vcpu->arch.guest_reset_csr;
>         struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
> -       struct kvm_cpu_context *reset_cntx =3D &vcpu->arch.guest_reset_co=
ntext;
> +       struct kvm_vcpu_reset_state *reset_state =3D &vcpu->arch.reset_st=
ate;
>         void *vector_datap =3D cntx->vector.datap;
> +
> +       memset(cntx, 0, sizeof(*cntx));
> +       memset(csr, 0, sizeof(*csr));
> +
> +       /* Restore datap as it's not a part of the guest context. */
> +       cntx->vector.datap =3D vector_datap;
> +
> +       /* Load SBI reset values */
> +       cntx->a0 =3D vcpu->vcpu_id;
> +
> +       spin_lock(&reset_state->lock);
> +       cntx->sepc =3D reset_state->pc;
> +       cntx->a1 =3D reset_state->a1;
> +       spin_unlock(&reset_state->lock);
> +
> +       /* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
> +       cntx->sstatus =3D SR_SPP | SR_SPIE;
> +
> +       cntx->hstatus |=3D HSTATUS_VTW;
> +       cntx->hstatus |=3D HSTATUS_SPVP;
> +       cntx->hstatus |=3D HSTATUS_SPV;
> +
> +       /* By default, make CY, TM, and IR counters accessible in VU mode=
 */
> +       csr->scounteren =3D 0x7;
> +}
> +
> +static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
> +{
>         bool loaded;
>
>         /**
> @@ -72,16 +99,10 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcp=
u)
>
>         vcpu->arch.last_exit_cpu =3D -1;
>
> -       memcpy(csr, reset_csr, sizeof(*csr));
> -
> -       spin_lock(&vcpu->arch.reset_cntx_lock);
> -       memcpy(cntx, reset_cntx, sizeof(*cntx));
> -       spin_unlock(&vcpu->arch.reset_cntx_lock);
> +       kvm_riscv_vcpu_context_reset(vcpu);
>
>         kvm_riscv_vcpu_fp_reset(vcpu);
>
> -       /* Restore datap as it's not a part of the guest context. */
> -       cntx->vector.datap =3D vector_datap;
>         kvm_riscv_vcpu_vector_reset(vcpu);
>
>         kvm_riscv_vcpu_timer_reset(vcpu);
> @@ -113,8 +134,6 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned=
 int id)
>  int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  {
>         int rc;
> -       struct kvm_cpu_context *cntx;
> -       struct kvm_vcpu_csr *reset_csr =3D &vcpu->arch.guest_reset_csr;
>
>         spin_lock_init(&vcpu->arch.mp_state_lock);
>
> @@ -134,24 +153,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         /* Setup VCPU hfence queue */
>         spin_lock_init(&vcpu->arch.hfence_lock);
>
> -       /* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
> -       spin_lock_init(&vcpu->arch.reset_cntx_lock);
> -
> -       spin_lock(&vcpu->arch.reset_cntx_lock);
> -       cntx =3D &vcpu->arch.guest_reset_context;
> -       cntx->sstatus =3D SR_SPP | SR_SPIE;
> -       cntx->hstatus =3D 0;
> -       cntx->hstatus |=3D HSTATUS_VTW;
> -       cntx->hstatus |=3D HSTATUS_SPVP;
> -       cntx->hstatus |=3D HSTATUS_SPV;
> -       spin_unlock(&vcpu->arch.reset_cntx_lock);
> +       spin_lock_init(&vcpu->arch.reset_state.lock);
>
>         if (kvm_riscv_vcpu_alloc_vector_context(vcpu))
>                 return -ENOMEM;
>
> -       /* By default, make CY, TM, and IR counters accessible in VU mode=
 */
> -       reset_csr->scounteren =3D 0x7;
> -
>         /* Setup VCPU timer */
>         kvm_riscv_vcpu_timer_init(vcpu);
>
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index f58368f7df1d..3d7955e05cc3 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -159,11 +159,10 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcp=
u *vcpu,
>  void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
>                                        unsigned long pc, unsigned long a1=
)
>  {
> -       spin_lock(&vcpu->arch.reset_cntx_lock);
> -       vcpu->arch.guest_reset_context.sepc =3D pc;
> -       vcpu->arch.guest_reset_context.a0 =3D vcpu->vcpu_id;
> -       vcpu->arch.guest_reset_context.a1 =3D a1;
> -       spin_unlock(&vcpu->arch.reset_cntx_lock);
> +       spin_lock(&vcpu->arch.reset_state.lock);
> +       vcpu->arch.reset_state.pc =3D pc;
> +       vcpu->arch.reset_state.a1 =3D a1;
> +       spin_unlock(&vcpu->arch.reset_state.lock);
>
>         kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
>  }
> --
> 2.48.1
>

