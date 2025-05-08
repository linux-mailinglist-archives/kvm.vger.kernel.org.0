Return-Path: <kvm+bounces-45832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1B11AAF38E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 08:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CA50466436
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 06:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA60B1DE4EF;
	Thu,  8 May 2025 06:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="j7sQqUYp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEA410E0
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 06:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746685094; cv=none; b=SncMrBoaAkFrDyWpjUDZBmZ4pDf1cajJWFBP42lYqe0KK0cVBDYaG/HitB/RkTdgVTOSr9cRqWUznO6aWsdAsw0AnwHp3sj6gYQU3KI6q+1HKTmx+gDEGYhb1HBX8BrveYAClH0zw87kGZbLcEZMUeuoViVCfP4F+Lk5X/Re8M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746685094; c=relaxed/simple;
	bh=Bbkq/RYcxs1x98iS+sh1uTieG+gNR4+QIdZyuTIdfr8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HSw6iv2i4goONdWpHpkJtJB6X/u0QrJHd05BWewwMgOzx2pFpe15wW+02SB70bx4CLlMAurqw2bUXzDG8p8aPFX1FaEDmgMipJy17gcBZbco6vv1rcEnwoN/mzpm+7y40EISOwI2HTX53VlgQ2BmRG+VT78NOv152bWNkxzBSdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=j7sQqUYp; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-85e46f5c50fso52864339f.3
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 23:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1746685091; x=1747289891; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ss9yl8sXdOiHdkgttMG6M1WflUBd6V/PJ9963b+7AH0=;
        b=j7sQqUYp6tm5t6gJ7ptNSmWB2SFDGLhFy9p8HOy4/lE9p7cg8DXjXHYzcHTaWBppoN
         JvFvaEZTxI3H6DpKaEWRH2uhTTgm8+d6xRYrsmPl0K+mKNYEgIerLZB5rzaDSg//tKlo
         u4uMsvZmFoR0pg6meXDOi94FzE7zym/AT/x1WfZJuKvx4sw3oS7a5To95WRq7mvZIC+u
         DcyDnmg9NZeAGpyfSqwvUB3ew8aKAI7qc5xe1HDNCXGsM/yE1AYDYeeLAkM+2rG8WXN9
         c9zuS+dQJlM+4TA8BtiGvvTrkEMd4h7UkH3DnvXtVO69BK8Ol5A/IqkzRsZjcQKVPMWP
         NU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746685091; x=1747289891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ss9yl8sXdOiHdkgttMG6M1WflUBd6V/PJ9963b+7AH0=;
        b=J0xhqpf+yZZ+gXTJKmcn0CxlXhP8LAPObbLGVQcNQ76w11LfY5c3qgXLQSP4vtg6MJ
         mPITlnrzltmArBIPWlYR8wrHGF8/H8T28T7vZTtZtjsQFpiBSIkwIn9l8cYmOYIVXDNG
         kl7M/A9tGswfTW1KwyaLUkTanbAtbaXHZuv2KU2Xfrsxx5h40e02zuCDjG0FqC/kM2h2
         suNiTDEVGLiYD5TSL19znVD7qRaCDM0YCzl66pJ14nkC9tqZdHyug56D2s9PKUTrCbxF
         ohb0WLd1nSHKWyLtEt5lscPJ9spFMsvcVhPNyAUUHQBKkEKWRX/9tWFwClANUApjr5zn
         XvbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTyqm+MdOdWkqc46GJNfLx5Am6CJ/JTmuemw39jLj96l6UHfXyYDI4RR6q95bTwMGw8Fo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMvt54wmL2sjKsPY9xMJvvW9UVv3EHVG5ocI8oKL0Cqrh1JwQz
	R+1oF0KKXwNSVZNpuB+z71QhuKqUMu4FfA9NWtrjna6fbcToxrppB/UwASrJMM+IrJ9mdLDtnv7
	v/iVmEvzTAOaxWPrseGRSyxlnvXdLsuz+r61noA==
X-Gm-Gg: ASbGncvBUlzOX0dydxpGQyPEh6c1ws9XEUEWlQbIKJI2NB1x5M3QE3unhGmIDsfPNMx
	G30cnE2VahHo6dmVvyK/C8QDITqfBqaM4piAGzHQcgajTXQFtn6F2k72GcT/+nCyLTTGn15tncJ
	78q1nZpnNtAPVhBXZsRWslZyU=
X-Google-Smtp-Source: AGHT+IH2Ky4AFIJnI3fge0BtYV7Dksetv4YSLA/pbKoTobhDZ77LmyQiPq5k0ylButekku7Ka+EjOBB/t3SlisqxLk0=
X-Received: by 2002:a05:6e02:3498:b0:3d8:1cba:1854 with SMTP id
 e9e14a558f8ab-3da7854d65bmr34465065ab.1.1746685091168; Wed, 07 May 2025
 23:18:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com> <20250403112522.1566629-6-rkrcmar@ventanamicro.com>
In-Reply-To: <20250403112522.1566629-6-rkrcmar@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 8 May 2025 11:48:00 +0530
X-Gm-Features: ATxdqUFfRqun2viiJMiaaVjkyhvi75M7M8EY7NCPCcyFAS9GGQ49YwBXAaDX928
Message-ID: <CAAhSdy3y0-hz59Nrqvvhp=+cWJe1s50K7EpuZmKBqfy-XQFd1Q@mail.gmail.com>
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
>
> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>

Queued this patch for Linux-6.16

Thanks,
Anup

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

