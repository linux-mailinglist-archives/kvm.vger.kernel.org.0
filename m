Return-Path: <kvm+bounces-45709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 700B4AADDF6
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 14:02:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4187F3BE1C5
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 12:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703CC2594B4;
	Wed,  7 May 2025 12:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Tf1F06iL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0A52580F2
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 12:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746619307; cv=none; b=u/j+01BTN0f7GoKy0aVOOWnNYantx9p9WkNVN1oin6zb8Q1KuxQ03HgE1+zhBFJT6Of7IVJ6UHA3/qdZD2bTWZ/zXvbty30TG2dcIaUqJRthH3inZn91FDMRWSeWaVLNJ47ukW716Lzu1x/+Fn3mrpX4t1dYw6mrVs+76EX+a1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746619307; c=relaxed/simple;
	bh=6rv4ezCEsP2xR4MP5LGsgg8AteN/ZReqLsGo7bUMZuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LEoOdFdlE8Y+Vbf4DiiexGHIrrNpASs7QXIwluGt3bGeggECXbyC6b3TpVGA0mmR35IiIc5iRTmheJ065pRxnbVV6/o0AFI/7am5yamSw7ERb+dZl4M4CJ+Mw0i6SAD5oZ47ki2HSEHxgMxSz6oJ8HmYanh8GrJ8xsmC8WBrXXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Tf1F06iL; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d7f111e9e1so74206655ab.1
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 05:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1746619305; x=1747224105; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MfksTJphxL8/tqIZbEC1vmhshvxVbtCcWFaJZOmGc+c=;
        b=Tf1F06iLu5P6Ar8J3Rwwnc1jS8mZw0kXv+tUkX9vc987zsexeSdus+u4QAZyu7dQVM
         yp3+j5/UZyzAU0rQYGLCkHhrh1yxyYmbPzUDnYPuBlOnf3kvolgtTTPCfR0SVwuf2fOE
         n1K/SIIQbsXd3DwFy14uGI2u8+mCDmmilCaMztlDRHrGFl9L+OEMilceSrPYgWYdUSUj
         8fGC4b6MRrE9+z2+cJrh2X6f0GRdbIShb/JbcRaTDk2P55Js6us3MeykZJTvBNOGdFST
         DMR9jsP8qfzXWrstrlOAQ15sTcpOJOMuUyX8U2eyA9L4UTZLZuZPBlUkmrzuEklXjba8
         iszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746619305; x=1747224105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MfksTJphxL8/tqIZbEC1vmhshvxVbtCcWFaJZOmGc+c=;
        b=r/sQnDAbO1R874p8Tb1KQ1RSopYcHK5D5FTvPmBANk1GAwo6O2u9Nv8UE3AYY7tTKS
         l/ApzXAv981QF+36JO886WsMyGLSt1HaAOZzmwbu7PIkuc3KEhFUMOgiFHUFQ2Jc2kSb
         fQ9htAICPz5qKxkZILg0kpNjFoljlB+cQPM5Pd9Ey99cFq8CQm/wpJq+npZLaxC7sqg+
         DYvewl2/gDkywbOokPHapd0II+NZAIu+GqzbGCTUl8nqmYxGXuU1RgnYSKT3+NqKcGSm
         UoHCHehyhM8pevc5rELxZisaB+Uaq3PEzrDrZtEnlVOITpLP+rajReeiXj1AlycGTQLX
         3cpw==
X-Forwarded-Encrypted: i=1; AJvYcCXKeyiYlb+4pUhPvhrfqshOf7JEkvPVoGdIQhupi5GOOy4y/3tb+iMhmyn7Gibh8pu5cS4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhqAdTeS11BYZdKpvoDgyYUXkHZwqLwzIykNC/JCIlycZRA7MR
	Zs9hfqt5csULEr3ZK0FW9ivneQbJd+afipXrWO9p7ZhDTNUpHal49sQ8+M2Y+Z6tdmMMPKKUjrH
	jEwthIphLyPRQgS3qjS3vwSZGjrMJuX+T+YuNlw==
X-Gm-Gg: ASbGncvi0kZDJxcgY7EIPSVq4vyHTYfCrTByScNVDg5aQWWfrvm5Tsd4ltSCTKbN5Kc
	BjViey9/pDoXcfZn5paEqZJkZSH2eQeWMnz596yUNtg5aEs0Vvm/llAhWi05uzjxL+o0wFh04d4
	f6fdx535LBD8mMZGPtn6sHo3Y=
X-Google-Smtp-Source: AGHT+IFkZGdbLqqYtnBIxPNoB/AAAkKnYxcbV3TvXGHWR/dk3f5HpfrkqVg/svBXEFNqgSJQ1iCWCi8Uf95FPmM7zQQ=
X-Received: by 2002:a05:6e02:1c2c:b0:3d8:1d7c:e192 with SMTP id
 e9e14a558f8ab-3da738f849emr29139475ab.7.1746619304812; Wed, 07 May 2025
 05:01:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com> <20250403112522.1566629-5-rkrcmar@ventanamicro.com>
In-Reply-To: <20250403112522.1566629-5-rkrcmar@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 7 May 2025 17:31:33 +0530
X-Gm-Features: ATxdqUEfXOKoC0fyIHGD5l9Qjl_U-GZBULEO3hLfdZKgXeyi62xCroqXS1Rt6jw
Message-ID: <CAAhSdy0v7Cw+aGF8DDWh1gjTBXA23=H01KRK8R2LTQHLRHo5Kw@mail.gmail.com>
Subject: Re: [PATCH 2/5] KVM: RISC-V: refactor sbi reset request
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
> The same code is used twice and SBI reset sets only two variables.
>
> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  2 ++
>  arch/riscv/kvm/vcpu_sbi.c             | 12 ++++++++++++
>  arch/riscv/kvm/vcpu_sbi_hsm.c         | 13 +------------
>  arch/riscv/kvm/vcpu_sbi_system.c      | 10 +---------
>  4 files changed, 16 insertions(+), 21 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/a=
sm/kvm_vcpu_sbi.h
> index 4ed6203cdd30..aaaa81355276 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -55,6 +55,8 @@ void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, =
struct kvm_run *run);
>  void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
>                                      struct kvm_run *run,
>                                      u32 type, u64 flags);
> +void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
> +                                      unsigned long pc, unsigned long a1=
);

Use tabs for alignment instead of spaces.

>  int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run=
);
>  int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
>                                    const struct kvm_one_reg *reg);
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index d1c83a77735e..f58368f7df1d 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -156,6 +156,18 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu=
 *vcpu,
>         run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
>  }
>
> +void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
> +                                      unsigned long pc, unsigned long a1=
)
> +{
> +       spin_lock(&vcpu->arch.reset_cntx_lock);
> +       vcpu->arch.guest_reset_context.sepc =3D pc;
> +       vcpu->arch.guest_reset_context.a0 =3D vcpu->vcpu_id;
> +       vcpu->arch.guest_reset_context.a1 =3D a1;
> +       spin_unlock(&vcpu->arch.reset_cntx_lock);
> +
> +       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> +}
> +
>  int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run=
)
>  {
>         struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
> diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.=
c
> index 3070bb31745d..f26207f84bab 100644
> --- a/arch/riscv/kvm/vcpu_sbi_hsm.c
> +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> @@ -15,7 +15,6 @@
>
>  static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
>  {
> -       struct kvm_cpu_context *reset_cntx;
>         struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
>         struct kvm_vcpu *target_vcpu;
>         unsigned long target_vcpuid =3D cp->a0;
> @@ -32,17 +31,7 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcp=
u)
>                 goto out;
>         }
>
> -       spin_lock(&target_vcpu->arch.reset_cntx_lock);
> -       reset_cntx =3D &target_vcpu->arch.guest_reset_context;
> -       /* start address */
> -       reset_cntx->sepc =3D cp->a1;
> -       /* target vcpu id to start */
> -       reset_cntx->a0 =3D target_vcpuid;
> -       /* private data passed from kernel */
> -       reset_cntx->a1 =3D cp->a2;
> -       spin_unlock(&target_vcpu->arch.reset_cntx_lock);
> -
> -       kvm_make_request(KVM_REQ_VCPU_RESET, target_vcpu);
> +       kvm_riscv_vcpu_sbi_request_reset(target_vcpu, cp->a1, cp->a2);
>
>         __kvm_riscv_vcpu_power_on(target_vcpu);
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_system.c b/arch/riscv/kvm/vcpu_sbi_s=
ystem.c
> index bc0ebba89003..359be90b0fc5 100644
> --- a/arch/riscv/kvm/vcpu_sbi_system.c
> +++ b/arch/riscv/kvm/vcpu_sbi_system.c
> @@ -13,7 +13,6 @@ static int kvm_sbi_ext_susp_handler(struct kvm_vcpu *vc=
pu, struct kvm_run *run,
>                                     struct kvm_vcpu_sbi_return *retdata)
>  {
>         struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
> -       struct kvm_cpu_context *reset_cntx;
>         unsigned long funcid =3D cp->a6;
>         unsigned long hva, i;
>         struct kvm_vcpu *tmp;
> @@ -45,14 +44,7 @@ static int kvm_sbi_ext_susp_handler(struct kvm_vcpu *v=
cpu, struct kvm_run *run,
>                         }
>                 }
>
> -               spin_lock(&vcpu->arch.reset_cntx_lock);
> -               reset_cntx =3D &vcpu->arch.guest_reset_context;
> -               reset_cntx->sepc =3D cp->a1;
> -               reset_cntx->a0 =3D vcpu->vcpu_id;
> -               reset_cntx->a1 =3D cp->a2;
> -               spin_unlock(&vcpu->arch.reset_cntx_lock);
> -
> -               kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> +               kvm_riscv_vcpu_sbi_request_reset(vcpu, cp->a1, cp->a2);
>
>                 /* userspace provides the suspend implementation */
>                 kvm_riscv_vcpu_sbi_forward(vcpu, run);
> --
> 2.48.1
>

Otherwise, it looks good to me.
I have taken care of the above comment at the time
of merging this patch.

Queued this patch for Linux-6.16

Thanks,
Anup

