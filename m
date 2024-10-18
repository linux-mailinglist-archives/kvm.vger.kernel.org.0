Return-Path: <kvm+bounces-29185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 039EE9A47B7
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 22:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BA7B1F250D6
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 20:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E22E205E2B;
	Fri, 18 Oct 2024 20:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b="rcFzKkhB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022361EE00E
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 20:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729282295; cv=none; b=GFalvVbC9xRdqlbGu7cElMIn6UnUBgfPhWqrRqQ894dOQraYtWeJfB5DZN+hoflh+U61u8h4AIeElegwBbG9ujb+mvz5cUopMBzWFBSgeXCut/zJs4VUA8AAZT6BKlCjI1zRhmPPTmh0vwSILHulDk+/ZYZd5MGAwig50q55BdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729282295; c=relaxed/simple;
	bh=L1zmrwMA350Pw6vNvSRdXg7wao7p9uWvjSldj4JS//Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XuJnusLTFgrWa4NX0QLEM3QxXLoEScJb3D38tWZUGPWWiysT0+JN9NV6KkAYP0rENr1bxZgojgEhL300sgQNeX2I8uhssqB4zvLfJmgarUKsac4mvMVBraJrm9Luyb2hrNQXw8D/WYklg1cuGoFuX6wpXR0qFANNzwK/9FFlZsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org; spf=pass smtp.mailfrom=atishpatra.org; dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b=rcFzKkhB; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atishpatra.org
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-539f72c913aso3236001e87.1
        for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 13:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1729282290; x=1729887090; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pjceIsWcwiJi9o8K3wuHgDeqcBFmrQpMfaaoOm2yWMc=;
        b=rcFzKkhBR2/uw92tqX6bro8El+cnw7SGXNMZZ6hUrYpJC/2erRf5iJfkGSSJZqsb6u
         XM6TjQtj/gnNC+m6+ccq7k6E0Npcipns0tYILarHsCQBQJg/2NlmsPHejHlk42J8if6L
         7J8WvLMD8kpaAwFp+3d9yjwXMcrkR1oKZRZXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729282290; x=1729887090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pjceIsWcwiJi9o8K3wuHgDeqcBFmrQpMfaaoOm2yWMc=;
        b=oU4Xf+vipQE5nyZeVGlsfpQ5eCdNDbwZIVV/FsOw0iS4v/5NQY2GCkQEm2Z/TBgE8t
         HGXkZMRPbEjLfZUaaH0vMSDsCHx/FwOqRYXt1+wfrKtTu71M2ccdCJHOERMmyVVAbLtj
         8ROr9p2RK9KPWSG0H//d0qRVVGPHD7BP3z4QzFVvJpoD6Ki1D1pAtYfR520yemV8LxQZ
         xMNx7eZrdkzD0oXHRGZ2l/v2pPsVMjsnicLAv8wSr/Q48JogkCBsIkLZE2ixcuX1lKB0
         k1NL/MkkAZDf96CjplsVHM9zVwgiNYgEw+ck7z6YPinyH2k+BOHqJ4tqo0Aq+FSXriRF
         OUIg==
X-Forwarded-Encrypted: i=1; AJvYcCWfIle1yxJQ15xiltT1iN24FQ1q1e9yaZw86oxszLeXCA1X38K+fzzkT0oLZ765GJaiK2Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKdYOmUr6nioefY+lr5JazsKCxf7zXwiTfTe/p1k/ysrRvq5+U
	scNJF7l7Lz5MLsUJjk6NjS0MxWlzFp+R1xy6jvDif+0Cn2N6Lcqswuv6KXABqMNiH4YyEkZs0oU
	nkDJjCJkTE19RDhb/N+ICJUbcV9OpG3p27tr0
X-Google-Smtp-Source: AGHT+IEdHOrSLjkzUAeYvCUQQHFAMWufe92JOuvK/VstP4tFd3/prjystEPcQ+qjzWFtQzonKenRkCQKn82nAdly+bo=
X-Received: by 2002:a05:6512:6c5:b0:530:ad7d:8957 with SMTP id
 2adb3069b0e04-53a1545dff1mr2826449e87.49.1729282290131; Fri, 18 Oct 2024
 13:11:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719160913.342027-1-apatel@ventanamicro.com> <20240719160913.342027-13-apatel@ventanamicro.com>
In-Reply-To: <20240719160913.342027-13-apatel@ventanamicro.com>
From: Atish Patra <atishp@atishpatra.org>
Date: Fri, 18 Oct 2024 13:11:18 -0700
Message-ID: <CAOnJCULYc-m_Jq-MxwGMbktmCvLPsMiA_tzxE2qYuoKgeR0BEw@mail.gmail.com>
Subject: Re: [PATCH 12/13] RISC-V: KVM: Save trap CSRs in kvm_riscv_vcpu_enter_exit()
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
> Save trap CSRs in the kvm_riscv_vcpu_enter_exit() function instead of
> the kvm_arch_vcpu_ioctl_run() function so that HTVAL and HTINST CSRs
> are accessed in more optimized manner while running under some other
> hypervisor.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu.c | 34 +++++++++++++++++++++-------------
>  1 file changed, 21 insertions(+), 13 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index fe849fb1aaab..854d98aa165e 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -757,12 +757,21 @@ static __always_inline void kvm_riscv_vcpu_swap_in_=
host_state(struct kvm_vcpu *v
>   * This must be noinstr as instrumentation may make use of RCU, and this=
 is not
>   * safe during the EQS.
>   */
> -static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
> +static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> +                                             struct kvm_cpu_trap *trap)
>  {
>         void *nsh;
>         struct kvm_cpu_context *gcntx =3D &vcpu->arch.guest_context;
>         struct kvm_cpu_context *hcntx =3D &vcpu->arch.host_context;
>
> +       /*
> +        * We save trap CSRs (such as SEPC, SCAUSE, STVAL, HTVAL, and
> +        * HTINST) here because we do local_irq_enable() after this
> +        * function in kvm_arch_vcpu_ioctl_run() which can result in
> +        * an interrupt immediately after local_irq_enable() and can
> +        * potentially change trap CSRs.
> +        */
> +
>         kvm_riscv_vcpu_swap_in_guest_state(vcpu);
>         guest_state_enter_irqoff();
>
> @@ -805,14 +814,24 @@ static void noinstr kvm_riscv_vcpu_enter_exit(struc=
t kvm_vcpu *vcpu)
>                 } else {
>                         gcntx->hstatus =3D csr_swap(CSR_HSTATUS, hcntx->h=
status);
>                 }
> +
> +               trap->htval =3D nacl_csr_read(nsh, CSR_HTVAL);
> +               trap->htinst =3D nacl_csr_read(nsh, CSR_HTINST);
>         } else {
>                 hcntx->hstatus =3D csr_swap(CSR_HSTATUS, gcntx->hstatus);
>
>                 __kvm_riscv_switch_to(&vcpu->arch);
>
>                 gcntx->hstatus =3D csr_swap(CSR_HSTATUS, hcntx->hstatus);
> +
> +               trap->htval =3D csr_read(CSR_HTVAL);
> +               trap->htinst =3D csr_read(CSR_HTINST);
>         }
>
> +       trap->sepc =3D gcntx->sepc;
> +       trap->scause =3D csr_read(CSR_SCAUSE);
> +       trap->stval =3D csr_read(CSR_STVAL);
> +
>         vcpu->arch.last_exit_cpu =3D vcpu->cpu;
>         guest_state_exit_irqoff();
>         kvm_riscv_vcpu_swap_in_host_state(vcpu);
> @@ -929,22 +948,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>
>                 guest_timing_enter_irqoff();
>
> -               kvm_riscv_vcpu_enter_exit(vcpu);
> +               kvm_riscv_vcpu_enter_exit(vcpu, &trap);
>
>                 vcpu->mode =3D OUTSIDE_GUEST_MODE;
>                 vcpu->stat.exits++;
>
> -               /*
> -                * Save SCAUSE, STVAL, HTVAL, and HTINST because we might
> -                * get an interrupt between __kvm_riscv_switch_to() and
> -                * local_irq_enable() which can potentially change CSRs.
> -                */
> -               trap.sepc =3D vcpu->arch.guest_context.sepc;
> -               trap.scause =3D csr_read(CSR_SCAUSE);
> -               trap.stval =3D csr_read(CSR_STVAL);
> -               trap.htval =3D ncsr_read(CSR_HTVAL);
> -               trap.htinst =3D ncsr_read(CSR_HTINST);
> -
>                 /* Syncup interrupts state with HW */
>                 kvm_riscv_vcpu_sync_interrupts(vcpu);
>
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
--=20
Regards,
Atish

