Return-Path: <kvm+bounces-44569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D8423A9F089
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 14:22:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A001F18963C4
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 12:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2CF0268C5D;
	Mon, 28 Apr 2025 12:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="aFrnjX3S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA9C25E80F
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 12:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745842959; cv=none; b=udmO+EfevnHSsHzJEMG8lW+NtBYV8qvTgVIoexZR6P6/xX7FbFO/hSf39G661Iwm3M+d5GYn14ITZjt37WyCRTDdISPTRFjMvYR/A4OVhgfGmkBa7zBHYddF3s5PuvQYOP4mnn/0nmywPlIMg0f+v64io6+yyunUAcLFlrpZqSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745842959; c=relaxed/simple;
	bh=ZSQiAWnowhY8mQCjyvr1EFpFLPYxJqjWGlvOpID5nKw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lAONQJO8Pqx/1Owturhgk6aNZFiDuJBN/bS6LfNh3VTzKV1kZ7KmeY92QYqPxLtrY5IS7VQqFeCWSwHr6UYV1gykrKCzpLvqKjJhVXSUeVAcyPPRj/pzf9JP2RYrrESd2YT0Ccq2YloYX0gsVH3/fhk5bT9MlFw2n9cgxVy6j+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=aFrnjX3S; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-85df99da233so557354239f.3
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 05:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1745842957; x=1746447757; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qStW5ANmsB1H5VENe+DSuKYvWDp0bQwxrRHXgpkP+2A=;
        b=aFrnjX3SLw+x3zlMHkT2Smx1DACzrFE+Cb1ZaePG/d70V8kqpQRyWVZLntwTZKeaMX
         fkQrnureq6iAZEFUXO1Jr/r8rNldoPghUM1TQp6aGdhVxnLf8V8NXMUn5OkqpgHpX1TJ
         NxbQPHP+g5fQq6Eyr71Vxuki94pSsLb+9TvdBGkq2kw+DKfuYFaPxbV7Ip+tHngibL6h
         jEQDs+hJ45uOoZIq3Q8CzppA9l/bH/ZAdv1FC5pIlHzpVIwhARmnETTMoPZOduZg7/jk
         WuWiBS0PeubL0OEoJT+Ts0BfIBD7Twzk5Vp00j1jh+VtTs9ewMrMk1KQP6XJ+uUL6zr4
         hRqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745842957; x=1746447757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qStW5ANmsB1H5VENe+DSuKYvWDp0bQwxrRHXgpkP+2A=;
        b=X45LeWvhARr10EQoxdI4mmXGxpCwPLaEfuAt6KtDOk5Y7e4IEBk097etuchhVEiaRy
         Qrunp4cw/+iWKfugthvjoBMSLW1vFcCNf/L6nyHA2VFp7b3mGDpLWr0yHqgWN+vODhcE
         99E3mJEx297omWzgwVgJiAj4P1zAIdlZdsWJK27/no69sk6mT0ufat5ZDnqBtwxBjX/B
         BdZmc5uZ2u0txKlrQJkrq837EyE4aZsqX/iu7JTWfcdamd41xtE2h/hs2Iz6Z7kXgJXw
         B+Lo1ZTFWDLRqKSRjSVJiDjU8TTyHCVamqWbtZSJfLEEGRcKJtHLECz5RDDZjSfc4YJ0
         Jtew==
X-Forwarded-Encrypted: i=1; AJvYcCXirtksueRWb+za+6FTsur7E6umKRf91QWD8rYBry65AmXm0IY3oSkNzcaphR956U9t64E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGW8tFzOcxvPQ0sf2spD9e+4oxf6/4WPJC7o0XV7FcdmTbgO2t
	HXlA4VJbx8yWQYg+lbOCvmKGjCXrfL0yNYQ878boy5GpFtIa8XsJS52uwexpJ7bFNObpJoHetoq
	xQVHnKkZMMPF0H+HFqDva4kLmA0QHsPGp5mwKHmTo6QxNQEy2vCk=
X-Gm-Gg: ASbGncvTnFxM3f1URFAG77dYKe6WGDdPE9zfvVZkxx/SsanfvKRZiwAJO1FdGXsqQ6m
	gerfhAwEGJHWlsbRIgqJFxOoo01f0vIYH9uIAFFnltrbdQSF+W+Ilp4bhxHqNqIS5reiCNSFI4c
	kk318rbsHPSFagRLiB8FiGFDI=
X-Google-Smtp-Source: AGHT+IGQ/obqUJMzUHjq2v4/r93/YcMTs0DDtmrS1/5vHNarenTp/ePMrAZE/eSlI+sGl3zA3In5pPRWVcKHEBSSE5Y=
X-Received: by 2002:a05:6e02:178d:b0:3d8:20f0:4006 with SMTP id
 e9e14a558f8ab-3d942d1dde3mr90682465ab.4.1745842957269; Mon, 28 Apr 2025
 05:22:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com> <20250403112522.1566629-7-rkrcmar@ventanamicro.com>
In-Reply-To: <20250403112522.1566629-7-rkrcmar@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 28 Apr 2025 17:52:25 +0530
X-Gm-Features: ATxdqUHeKkNqYIeQ_B4VvhUdFtg0sKmtTk0whJH7ks5hYu8Y7ciF14WFYLbwEqQ
Message-ID: <CAAhSdy0e3HVN6pX-hcX2N+kpwsupsCf6BqrYq=bvtwtFOuEVhA@mail.gmail.com>
Subject: Re: [PATCH 4/5] KVM: RISC-V: reset VCPU state when becoming runnable
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
> Beware, this patch is "breaking" the userspace interface, because it
> fixes a KVM/QEMU bug where the boot VCPU is not being reset by KVM.
>
> The VCPU reset paths are inconsistent right now.  KVM resets VCPUs that
> are brought up by KVM-accelerated SBI calls, but does nothing for VCPUs
> brought up through ioctls.
>
> We need to perform a KVM reset even when the VCPU is started through an
> ioctl.  This patch is one of the ways we can achieve it.
>
> Assume that userspace has no business setting the post-reset state.
> KVM is de-facto the SBI implementation, as the SBI HSM acceleration
> cannot be disabled and userspace cannot control the reset state, so KVM
> should be in full control of the post-reset state.
>
> Do not reset the pc and a1 registers, because SBI reset is expected to
> provide them and KVM has no idea what these registers should be -- only
> the userspace knows where it put the data.
>
> An important consideration is resume.  Userspace might want to start
> with non-reset state.  Check ran_atleast_once to allow this, because
> KVM-SBI HSM creates some VCPUs as STOPPED.
>
> The drawback is that userspace can still start the boot VCPU with an
> incorrect reset state, because there is no way to distinguish a freshly
> reset new VCPU on the KVM side (userspace might set some values by
> mistake) from a restored VCPU (userspace must set all values).
>
> The advantage of this solution is that it fixes current QEMU and makes
> some sense with the assumption that KVM implements SBI HSM.
> I do not like it too much, so I'd be in favor of a different solution if
> we can still afford to drop support for current userspaces.
>
> For a cleaner solution, we should add interfaces to perform the KVM-SBI
> reset request on userspace demand.  I think it would also be much better
> if userspace was in control of the post-reset state.

Apart from breaking KVM user-space, this patch is incorrect and
does not align with the:
1) SBI spec
2) OS boot protocol.

The SBI spec only defines the entry state of certain CPU registers
(namely, PC, A0, and A1) when CPU enters S-mode:
1) Upon SBI HSM start call from some other CPU
2) Upon resuming from non-retentive SBI HSM suspend or
    SBI system suspend

The S-mode entry state of the boot CPU is defined by the
OS boot protocol and not by the SBI spec. Due to this, reason
KVM RISC-V expects user-space to set up the S-mode entry
state of the boot CPU upon system reset.

Due to above, reasons we should not go ahead with this patch.

Regards,
Anup

>
> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_host.h     |  1 +
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  3 +++
>  arch/riscv/kvm/vcpu.c                 |  9 +++++++++
>  arch/riscv/kvm/vcpu_sbi.c             | 21 +++++++++++++++++++--
>  4 files changed, 32 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index 0c8c9c05af91..9bbf8c4a286b 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -195,6 +195,7 @@ struct kvm_vcpu_smstateen_csr {
>
>  struct kvm_vcpu_reset_state {
>         spinlock_t lock;
> +       bool active;
>         unsigned long pc;
>         unsigned long a1;
>  };
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/a=
sm/kvm_vcpu_sbi.h
> index aaaa81355276..2c334a87e02a 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -57,6 +57,9 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *v=
cpu,
>                                      u32 type, u64 flags);
>  void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
>                                        unsigned long pc, unsigned long a1=
);
> +void __kvm_riscv_vcpu_set_reset_state(struct kvm_vcpu *vcpu,
> +                                      unsigned long pc, unsigned long a1=
);
> +void kvm_riscv_vcpu_sbi_request_reset_from_userspace(struct kvm_vcpu *vc=
pu);
>  int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run=
);
>  int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
>                                    const struct kvm_one_reg *reg);
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index b8485c1c1ce4..4578863a39e3 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -58,6 +58,11 @@ static void kvm_riscv_vcpu_context_reset(struct kvm_vc=
pu *vcpu)
>         struct kvm_vcpu_reset_state *reset_state =3D &vcpu->arch.reset_st=
ate;
>         void *vector_datap =3D cntx->vector.datap;
>
> +       spin_lock(&reset_state->lock);
> +       if (!reset_state->active)
> +               __kvm_riscv_vcpu_set_reset_state(vcpu, cntx->sepc, cntx->=
a1);
> +       spin_unlock(&reset_state->lock);
> +
>         memset(cntx, 0, sizeof(*cntx));
>         memset(csr, 0, sizeof(*csr));
>
> @@ -520,6 +525,10 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu =
*vcpu,
>
>         switch (mp_state->mp_state) {
>         case KVM_MP_STATE_RUNNABLE:
> +               if (riscv_vcpu_supports_sbi_ext(vcpu, KVM_RISCV_SBI_EXT_H=
SM) &&
> +                               vcpu->arch.ran_atleast_once &&
> +                               kvm_riscv_vcpu_stopped(vcpu))
> +                       kvm_riscv_vcpu_sbi_request_reset_from_userspace(v=
cpu);
>                 WRITE_ONCE(vcpu->arch.mp_state, *mp_state);
>                 break;
>         case KVM_MP_STATE_STOPPED:
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 3d7955e05cc3..77f9f0bd3842 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -156,12 +156,29 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcp=
u *vcpu,
>         run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
>  }
>
> +/* must be called with held vcpu->arch.reset_state.lock */
> +void __kvm_riscv_vcpu_set_reset_state(struct kvm_vcpu *vcpu,
> +                                      unsigned long pc, unsigned long a1=
)
> +{
> +       vcpu->arch.reset_state.active =3D true;
> +       vcpu->arch.reset_state.pc =3D pc;
> +       vcpu->arch.reset_state.a1 =3D a1;
> +}
> +
>  void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
>                                        unsigned long pc, unsigned long a1=
)
>  {
>         spin_lock(&vcpu->arch.reset_state.lock);
> -       vcpu->arch.reset_state.pc =3D pc;
> -       vcpu->arch.reset_state.a1 =3D a1;
> +       __kvm_riscv_vcpu_set_reset_state(vcpu, pc, a1);
> +       spin_unlock(&vcpu->arch.reset_state.lock);
> +
> +       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> +}
> +
> +void kvm_riscv_vcpu_sbi_request_reset_from_userspace(struct kvm_vcpu *vc=
pu)
> +{
> +       spin_lock(&vcpu->arch.reset_state.lock);
> +       vcpu->arch.reset_state.active =3D false;
>         spin_unlock(&vcpu->arch.reset_state.lock);
>
>         kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> --
> 2.48.1
>

