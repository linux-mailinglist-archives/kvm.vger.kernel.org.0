Return-Path: <kvm+bounces-29182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEED09A470B
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 21:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C83811C21299
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 19:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B1E8205ACE;
	Fri, 18 Oct 2024 19:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b="thxLGaBH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F06205144
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 19:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729280057; cv=none; b=ixOp6zgoMwKLG5kM4+SGxDQH4uoHk15o3FWx3njHESkmKz5h12EqTBEc9HDiBccpMwmmtRT+NbZTi/txKGoxcvZtoY0DkCZSHDVLBsHc7Dk/XbaM13lg6en/nZfvcX6eE1T+g5xILNn2x4pDpH3kBxatW/4SpK0i1506Ch38tGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729280057; c=relaxed/simple;
	bh=54Z/Xu+GM77sjxtWU4gFHis9QE1ftBTxluVfk56kmZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V/wW3RUSwCAuQXmWttHg7GYxxX2HtZR5kkk3mbHe3fWoBdAm+F08UrXeytioaAoYcpBguJd65TIpFcTAGUY+kTeqmg0VvVwLjvx61T6ABC1g1ghsKhBUU5d72Jhic/NJPobOmrfGPXlBaeStTdrKwPMmZjOWV7ZD6P/uCedmT70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org; spf=pass smtp.mailfrom=atishpatra.org; dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b=thxLGaBH; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atishpatra.org
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-53a007743e7so3171025e87.1
        for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 12:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1729280053; x=1729884853; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gykfHwEhvZn9OouPG+xeH4hENJCq3IryA0U1CzVeZMw=;
        b=thxLGaBHS3BccBn1kERmZ3W7Ax3/6u3NIStw8j+fnJC6uSQLN6TqL5SErAa520KbS6
         +iHsZU0py/KtARFit3xPH8rxeOFZyoGVJH1UaqQjRtHSSpxzfQf6BzpbSfoTqW+94XQI
         OeBhQUEMCh2IR5ovr8iUTo9ePpUHN8hZiD4eU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729280053; x=1729884853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gykfHwEhvZn9OouPG+xeH4hENJCq3IryA0U1CzVeZMw=;
        b=ZHrJCUjKCbqNNGflOhm+aAM0uI6OGzjcDr6QV9tgVYzrnWi5slzZbsSrMyGaOEynkh
         X98ca2768QvOLtZwP2SbrUCTPCBxrSBepocGnK7pYFSRt7Mqci9GLXtT5Hq8A1BcA2sb
         cauvoJiYDq3cru6vSC6AJycmZ/gjTxd0/S2bT7p1jAiYfFWRtNUMwZJVhDqNZcAzpJUm
         41aXQDYoX0ozmQOrp+t7/PGhagJZ3SK/Ew7E2xxuyhfpOquFvBS6BVF23/+grX0ZOky4
         0lSDz4VPnQTHm9qYZGueKlh71eO81kxpam8MtBuGLjImUUjHAgDXiTKiTXNgzbK2pQ7t
         e7zA==
X-Forwarded-Encrypted: i=1; AJvYcCVsibxJ/Ws/i6AwjRj+xIn2uy/EhSF4HNGCzXcY1GVncHCGoewPm4Vtl4NTz2YfXXkiSK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YycEE5EE+uwbGsnFMhLdvqKF3ufVatzcs8pmM5mvjYrDBcH5pV2
	04GCyElxZxlDk9gBiRtsTtTlm+MRDUOtfLO5hWLVSzJ47jNFAzMt2IgbXFeGc3KSoiGnflHBxch
	2oRxND4UQTeSChS2mbWLBM8ISYStGF+rTkDjK
X-Google-Smtp-Source: AGHT+IFemzNnwJ2CcScOOlMoI+DNU01cHF4Dq4xF5Q1M3NP3Ac9xEwqfjEJ8BnZEk27S3/xO4XqteeQkRFdqNfK6+94=
X-Received: by 2002:a05:6512:128f:b0:539:f1ce:5fa8 with SMTP id
 2adb3069b0e04-53a1550b9e6mr2524845e87.49.1729280053088; Fri, 18 Oct 2024
 12:34:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719160913.342027-1-apatel@ventanamicro.com> <20240719160913.342027-11-apatel@ventanamicro.com>
In-Reply-To: <20240719160913.342027-11-apatel@ventanamicro.com>
From: Atish Patra <atishp@atishpatra.org>
Date: Fri, 18 Oct 2024 12:34:01 -0700
Message-ID: <CAOnJCUK7Bbq=X4e-z1SbVLOA_DLB+QrA7VO3dAMgdDOzEAK0jw@mail.gmail.com>
Subject: Re: [PATCH 10/13] RISC-V: KVM: Use nacl_csr_xyz() for accessing AIA CSRs
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024 at 9:10=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> When running under some other hypervisor, prefer nacl_csr_xyz()
> for accessing AIA CSRs in the run-loop. This makes CSR access
> faster whenever SBI nested acceleration is available.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/aia.c | 97 ++++++++++++++++++++++++++++----------------
>  1 file changed, 63 insertions(+), 34 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index 8ffae0330c89..dcced4db7fe8 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -16,6 +16,7 @@
>  #include <linux/percpu.h>
>  #include <linux/spinlock.h>
>  #include <asm/cpufeature.h>
> +#include <asm/kvm_nacl.h>
>
>  struct aia_hgei_control {
>         raw_spinlock_t lock;
> @@ -88,7 +89,7 @@ void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu=
 *vcpu)
>         struct kvm_vcpu_aia_csr *csr =3D &vcpu->arch.aia_context.guest_cs=
r;
>
>         if (kvm_riscv_aia_available())
> -               csr->vsieh =3D csr_read(CSR_VSIEH);
> +               csr->vsieh =3D ncsr_read(CSR_VSIEH);
>  }
>  #endif
>
> @@ -115,7 +116,7 @@ bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcp=
u *vcpu, u64 mask)
>
>         hgei =3D aia_find_hgei(vcpu);
>         if (hgei > 0)
> -               return !!(csr_read(CSR_HGEIP) & BIT(hgei));
> +               return !!(ncsr_read(CSR_HGEIP) & BIT(hgei));
>
>         return false;
>  }
> @@ -128,45 +129,73 @@ void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu=
 *vcpu)
>                 return;
>
>  #ifdef CONFIG_32BIT
> -       csr_write(CSR_HVIPH, vcpu->arch.aia_context.guest_csr.hviph);
> +       ncsr_write(CSR_HVIPH, vcpu->arch.aia_context.guest_csr.hviph);
>  #endif
> -       csr_write(CSR_HVICTL, aia_hvictl_value(!!(csr->hvip & BIT(IRQ_VS_=
EXT))));
> +       ncsr_write(CSR_HVICTL, aia_hvictl_value(!!(csr->hvip & BIT(IRQ_VS=
_EXT))));
>  }
>
>  void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>         struct kvm_vcpu_aia_csr *csr =3D &vcpu->arch.aia_context.guest_cs=
r;
> +       void *nsh;
>
>         if (!kvm_riscv_aia_available())
>                 return;
>
> -       csr_write(CSR_VSISELECT, csr->vsiselect);
> -       csr_write(CSR_HVIPRIO1, csr->hviprio1);
> -       csr_write(CSR_HVIPRIO2, csr->hviprio2);
> +       if (kvm_riscv_nacl_sync_csr_available()) {
> +               nsh =3D nacl_shmem();
> +               nacl_csr_write(nsh, CSR_VSISELECT, csr->vsiselect);
> +               nacl_csr_write(nsh, CSR_HVIPRIO1, csr->hviprio1);
> +               nacl_csr_write(nsh, CSR_HVIPRIO2, csr->hviprio2);
> +#ifdef CONFIG_32BIT
> +               nacl_csr_write(nsh, CSR_VSIEH, csr->vsieh);
> +               nacl_csr_write(nsh, CSR_HVIPH, csr->hviph);
> +               nacl_csr_write(nsh, CSR_HVIPRIO1H, csr->hviprio1h);
> +               nacl_csr_write(nsh, CSR_HVIPRIO2H, csr->hviprio2h);
> +#endif
> +       } else {
> +               csr_write(CSR_VSISELECT, csr->vsiselect);
> +               csr_write(CSR_HVIPRIO1, csr->hviprio1);
> +               csr_write(CSR_HVIPRIO2, csr->hviprio2);
>  #ifdef CONFIG_32BIT
> -       csr_write(CSR_VSIEH, csr->vsieh);
> -       csr_write(CSR_HVIPH, csr->hviph);
> -       csr_write(CSR_HVIPRIO1H, csr->hviprio1h);
> -       csr_write(CSR_HVIPRIO2H, csr->hviprio2h);
> +               csr_write(CSR_VSIEH, csr->vsieh);
> +               csr_write(CSR_HVIPH, csr->hviph);
> +               csr_write(CSR_HVIPRIO1H, csr->hviprio1h);
> +               csr_write(CSR_HVIPRIO2H, csr->hviprio2h);
>  #endif
> +       }
>  }
>
>  void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_vcpu_aia_csr *csr =3D &vcpu->arch.aia_context.guest_cs=
r;
> +       void *nsh;
>
>         if (!kvm_riscv_aia_available())
>                 return;
>
> -       csr->vsiselect =3D csr_read(CSR_VSISELECT);
> -       csr->hviprio1 =3D csr_read(CSR_HVIPRIO1);
> -       csr->hviprio2 =3D csr_read(CSR_HVIPRIO2);
> +       if (kvm_riscv_nacl_available()) {
> +               nsh =3D nacl_shmem();
> +               csr->vsiselect =3D nacl_csr_read(nsh, CSR_VSISELECT);
> +               csr->hviprio1 =3D nacl_csr_read(nsh, CSR_HVIPRIO1);
> +               csr->hviprio2 =3D nacl_csr_read(nsh, CSR_HVIPRIO2);
>  #ifdef CONFIG_32BIT
> -       csr->vsieh =3D csr_read(CSR_VSIEH);
> -       csr->hviph =3D csr_read(CSR_HVIPH);
> -       csr->hviprio1h =3D csr_read(CSR_HVIPRIO1H);
> -       csr->hviprio2h =3D csr_read(CSR_HVIPRIO2H);
> +               csr->vsieh =3D nacl_csr_read(nsh, CSR_VSIEH);
> +               csr->hviph =3D nacl_csr_read(nsh, CSR_HVIPH);
> +               csr->hviprio1h =3D nacl_csr_read(nsh, CSR_HVIPRIO1H);
> +               csr->hviprio2h =3D nacl_csr_read(nsh, CSR_HVIPRIO2H);
>  #endif
> +       } else {
> +               csr->vsiselect =3D csr_read(CSR_VSISELECT);
> +               csr->hviprio1 =3D csr_read(CSR_HVIPRIO1);
> +               csr->hviprio2 =3D csr_read(CSR_HVIPRIO2);
> +#ifdef CONFIG_32BIT
> +               csr->vsieh =3D csr_read(CSR_VSIEH);
> +               csr->hviph =3D csr_read(CSR_HVIPH);
> +               csr->hviprio1h =3D csr_read(CSR_HVIPRIO1H);
> +               csr->hviprio2h =3D csr_read(CSR_HVIPRIO2H);
> +#endif
> +       }
>  }
>
>  int kvm_riscv_vcpu_aia_get_csr(struct kvm_vcpu *vcpu,
> @@ -250,20 +279,20 @@ static u8 aia_get_iprio8(struct kvm_vcpu *vcpu, uns=
igned int irq)
>
>         switch (bitpos / BITS_PER_LONG) {
>         case 0:
> -               hviprio =3D csr_read(CSR_HVIPRIO1);
> +               hviprio =3D ncsr_read(CSR_HVIPRIO1);
>                 break;
>         case 1:
>  #ifndef CONFIG_32BIT
> -               hviprio =3D csr_read(CSR_HVIPRIO2);
> +               hviprio =3D ncsr_read(CSR_HVIPRIO2);
>                 break;
>  #else
> -               hviprio =3D csr_read(CSR_HVIPRIO1H);
> +               hviprio =3D ncsr_read(CSR_HVIPRIO1H);
>                 break;
>         case 2:
> -               hviprio =3D csr_read(CSR_HVIPRIO2);
> +               hviprio =3D ncsr_read(CSR_HVIPRIO2);
>                 break;
>         case 3:
> -               hviprio =3D csr_read(CSR_HVIPRIO2H);
> +               hviprio =3D ncsr_read(CSR_HVIPRIO2H);
>                 break;
>  #endif
>         default:
> @@ -283,20 +312,20 @@ static void aia_set_iprio8(struct kvm_vcpu *vcpu, u=
nsigned int irq, u8 prio)
>
>         switch (bitpos / BITS_PER_LONG) {
>         case 0:
> -               hviprio =3D csr_read(CSR_HVIPRIO1);
> +               hviprio =3D ncsr_read(CSR_HVIPRIO1);
>                 break;
>         case 1:
>  #ifndef CONFIG_32BIT
> -               hviprio =3D csr_read(CSR_HVIPRIO2);
> +               hviprio =3D ncsr_read(CSR_HVIPRIO2);
>                 break;
>  #else
> -               hviprio =3D csr_read(CSR_HVIPRIO1H);
> +               hviprio =3D ncsr_read(CSR_HVIPRIO1H);
>                 break;
>         case 2:
> -               hviprio =3D csr_read(CSR_HVIPRIO2);
> +               hviprio =3D ncsr_read(CSR_HVIPRIO2);
>                 break;
>         case 3:
> -               hviprio =3D csr_read(CSR_HVIPRIO2H);
> +               hviprio =3D ncsr_read(CSR_HVIPRIO2H);
>                 break;
>  #endif
>         default:
> @@ -308,20 +337,20 @@ static void aia_set_iprio8(struct kvm_vcpu *vcpu, u=
nsigned int irq, u8 prio)
>
>         switch (bitpos / BITS_PER_LONG) {
>         case 0:
> -               csr_write(CSR_HVIPRIO1, hviprio);
> +               ncsr_write(CSR_HVIPRIO1, hviprio);
>                 break;
>         case 1:
>  #ifndef CONFIG_32BIT
> -               csr_write(CSR_HVIPRIO2, hviprio);
> +               ncsr_write(CSR_HVIPRIO2, hviprio);
>                 break;
>  #else
> -               csr_write(CSR_HVIPRIO1H, hviprio);
> +               ncsr_write(CSR_HVIPRIO1H, hviprio);
>                 break;
>         case 2:
> -               csr_write(CSR_HVIPRIO2, hviprio);
> +               ncsr_write(CSR_HVIPRIO2, hviprio);
>                 break;
>         case 3:
> -               csr_write(CSR_HVIPRIO2H, hviprio);
> +               ncsr_write(CSR_HVIPRIO2H, hviprio);
>                 break;
>  #endif
>         default:
> @@ -377,7 +406,7 @@ int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu=
, unsigned int csr_num,
>                 return KVM_INSN_ILLEGAL_TRAP;
>
>         /* First try to emulate in kernel space */
> -       isel =3D csr_read(CSR_VSISELECT) & ISELECT_MASK;
> +       isel =3D ncsr_read(CSR_VSISELECT) & ISELECT_MASK;
>         if (isel >=3D ISELECT_IPRIO0 && isel <=3D ISELECT_IPRIO15)
>                 return aia_rmw_iprio(vcpu, isel, val, new_val, wr_mask);
>         else if (isel >=3D IMSIC_FIRST && isel <=3D IMSIC_LAST &&
> --
> 2.34.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

--=20
Regards,
Atish

