Return-Path: <kvm+bounces-34556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A22A01525
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 15:07:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 743151884091
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 14:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504111B87FC;
	Sat,  4 Jan 2025 14:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ttBtpsPZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F48918A6AE;
	Sat,  4 Jan 2025 14:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735999663; cv=none; b=RakFoiujEiA6u2YrsMQLUdYlrT5fs9oYVenEKyZbWhmfIkJ57cDMsANvfK75zyl5b5PhSFy2t1rew54gl7F5VNJt6QwwKkCaOctPmL16QIyKdWHRL/jVVrvrMRj8N7fgK2Mn5turhlUSqp1O4jlWivUKmsqHcxwzK6xU+gQDGi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735999663; c=relaxed/simple;
	bh=aPbhvUc2jZxfN9fRlXiOO+T8WvyqwAcHqo7inmggA3U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mpT1RpoaXkTyPxGk4hkpRoj3+TBpps1aQxaH6k2onoCWXGTAdAGkefDKRbFHPaBCoUKjUl7WVRjfj5XbjuMIn7c2BeRc3AUnaWcKf4ouhjAhz87brH92QXj1Bns3+9LsS5d5VaVCroBzsL4ECFit15O9qTsB4b4MCTmUZqbO8hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ttBtpsPZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FB6C4CEE2;
	Sat,  4 Jan 2025 14:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735999663;
	bh=aPbhvUc2jZxfN9fRlXiOO+T8WvyqwAcHqo7inmggA3U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ttBtpsPZarqsRqV/iu+kkb6sEevqdtckU7oltJgMFS5eq6jmFqUU69tFVrmy0WvmU
	 XUgMmy2qaChxNAFy81PGJkuPcR5dfWnM3VAZ+uvn4mRT4EhSzFWRFpsGr4WZw13qak
	 JeiGBGHsw0R/ycwRPv5VTqNgdYw9gWZHHBWoJXBa90JF0mXybVUWgQEmzdtF153wMr
	 5J8zH505tHF+b+ZuCtunHxkhvNMePNHCgoL6t9MFO6zKuSm11Zfx0R83d7OPCv6FQh
	 5P4sH+6hwKrzXzvJCRPbIpvpQ1J+Q+sImJdkQV49n0FO61GayLQ4eon6HHwP9/2Cep
	 Uocig/2+3sGmA==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d3e8f64d5dso23262155a12.3;
        Sat, 04 Jan 2025 06:07:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUQFBraQ7ekoOHRhWME+IIb5FM/pLHQ20inu1eQG3nLAQeyTzHGyekUlSMgxQFkI3WpXpEFErh2UgMHVFR4@vger.kernel.org, AJvYcCV2eQiS4YE/JaxVq9p9qGHRVrW8+zcPnVO3pcVs+mn34dLtMEtAhjtCXBomBZuWVoLR3UU=@vger.kernel.org
X-Gm-Message-State: AOJu0YypSUnZPa/8vbCLXZggoFdcSAv5vEv0JLLxGudqa0WFMnCru0dc
	zeDNFzjm5ITCVzZyHJ6oH7blxGza6RDZk4eFOeSmcWja3xEg0VU8fqYljqD9bYKCtRR4qTqFDm6
	tN1GDP5ogh7+htkaUAkyxYTTOxok=
X-Google-Smtp-Source: AGHT+IEiX7sP+dE40cWyt6pfaZ7N1yCmYDxJFs5MIOQ3WoQL5hEjBfC5LBD1YQLXKvaS7nbdIpopRkVDpCAWzeS48aQ=
X-Received: by 2002:a17:906:f5aa:b0:aab:f11f:f360 with SMTP id
 a640c23a62f3a-aac2874a92cmr4625277866b.2.1735999661599; Sat, 04 Jan 2025
 06:07:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250103023053.2625226-1-maobibo@loongson.cn>
In-Reply-To: <20250103023053.2625226-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 4 Jan 2025 22:07:04 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5mJTZgGNHoxbH0TNLg5iQ0fHmOHBqFY=Tk_s0A1GeqWg@mail.gmail.com>
X-Gm-Features: AbW1kvb6KJiyjv23Pr9dpIogc6fk3fr2QBxnbCViWdGonxTIewVUf9-r-G590gg
Message-ID: <CAAhV-H5mJTZgGNHoxbH0TNLg5iQ0fHmOHBqFY=Tk_s0A1GeqWg@mail.gmail.com>
Subject: Re: [PATCH v2] LoongArch: KVM: Add hypercall service support for
 usermode VMM
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 3, 2025 at 10:31=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Some VMMs provides special hypercall service in usermode, KVM need
> not handle the usermode hypercall service and pass it to VMM and
> let VMM handle it.
>
> Here new code KVM_HCALL_CODE_USER is added for user-mode hypercall
> service, KVM lets all six registers visiable to VMM.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   v1 ... v2:
>   1. Add function kvm_complete_user_service() when finish hypercall
>      in user-mode VMM and continue to run.
>   2. Add hypercall_exits stat information.
> ---
>  arch/loongarch/include/asm/kvm_host.h      |  1 +
>  arch/loongarch/include/asm/kvm_para.h      |  2 ++
>  arch/loongarch/include/asm/kvm_vcpu.h      |  1 +
>  arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
>  arch/loongarch/kvm/exit.c                  | 30 ++++++++++++++++++++++
>  arch/loongarch/kvm/vcpu.c                  |  3 ++-
>  6 files changed, 37 insertions(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index 7b8367c39da8..590982cd986e 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -162,6 +162,7 @@ enum emulation_result {
>  #define LOONGARCH_PV_FEAT_UPDATED      BIT_ULL(63)
>  #define LOONGARCH_PV_FEAT_MASK         (BIT(KVM_FEATURE_IPI) |         \
>                                          BIT(KVM_FEATURE_STEAL_TIME) |  \
> +                                        BIT(KVM_FEATURE_USER_HCALL) |  \
>                                          BIT(KVM_FEATURE_VIRT_EXTIOI))
>
>  struct kvm_vcpu_arch {
> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/inclu=
de/asm/kvm_para.h
> index c4e84227280d..d3c00de484f6 100644
> --- a/arch/loongarch/include/asm/kvm_para.h
> +++ b/arch/loongarch/include/asm/kvm_para.h
> @@ -13,12 +13,14 @@
>
>  #define KVM_HCALL_CODE_SERVICE         0
>  #define KVM_HCALL_CODE_SWDBG           1
> +#define KVM_HCALL_CODE_USER            2
Queued but rename KVM_HCALL_CODE_USER to KVM_HCALL_CODE_USER_SERVICE
to keep consistency, thanks.

Huacai

>
>  #define KVM_HCALL_SERVICE              HYPERCALL_ENCODE(HYPERVISOR_KVM, =
KVM_HCALL_CODE_SERVICE)
>  #define  KVM_HCALL_FUNC_IPI            1
>  #define  KVM_HCALL_FUNC_NOTIFY         2
>
>  #define KVM_HCALL_SWDBG                        HYPERCALL_ENCODE(HYPERVIS=
OR_KVM, KVM_HCALL_CODE_SWDBG)
> +#define KVM_HCALL_USER_SERVICE         HYPERCALL_ENCODE(HYPERVISOR_KVM, =
KVM_HCALL_CODE_USER)
>
>  /*
>   * LoongArch hypercall return code
> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/inclu=
de/asm/kvm_vcpu.h
> index d7e8f7d50ee0..2c349f961bfb 100644
> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> @@ -43,6 +43,7 @@ int  kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_ins=
t inst);
>  int  kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst);
>  int  kvm_complete_mmio_read(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int  kvm_complete_iocsr_read(struct kvm_vcpu *vcpu, struct kvm_run *run)=
;
> +int  kvm_complete_user_service(struct kvm_vcpu *vcpu, struct kvm_run *ru=
n);
>  int  kvm_emu_idle(struct kvm_vcpu *vcpu);
>  int  kvm_pending_timer(struct kvm_vcpu *vcpu);
>  int  kvm_handle_fault(struct kvm_vcpu *vcpu, int fault);
> diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loongarch/=
include/uapi/asm/kvm_para.h
> index b0604aa9b4bb..76d802ef01ce 100644
> --- a/arch/loongarch/include/uapi/asm/kvm_para.h
> +++ b/arch/loongarch/include/uapi/asm/kvm_para.h
> @@ -17,5 +17,6 @@
>  #define  KVM_FEATURE_STEAL_TIME                2
>  /* BIT 24 - 31 are features configurable by user space vmm */
>  #define  KVM_FEATURE_VIRT_EXTIOI       24
> +#define  KVM_FEATURE_USER_HCALL                25
>
>  #endif /* _UAPI_ASM_KVM_PARA_H */
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index a7893bd01e73..70b5ed1241c4 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -538,6 +538,13 @@ int kvm_complete_mmio_read(struct kvm_vcpu *vcpu, st=
ruct kvm_run *run)
>         return er;
>  }
>
> +int kvm_complete_user_service(struct kvm_vcpu *vcpu, struct kvm_run *run=
)
> +{
> +       update_pc(&vcpu->arch);
> +       kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hypercall.ret);
> +       return 0;
> +}
> +
>  int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
>  {
>         int idx, ret;
> @@ -873,6 +880,29 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcp=
u)
>                 vcpu->stat.hypercall_exits++;
>                 kvm_handle_service(vcpu);
>                 break;
> +       case KVM_HCALL_USER_SERVICE:
> +               if (!kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_USER_HCAL=
L)) {
> +                       kvm_write_reg(vcpu, LOONGARCH_GPR_A0, KVM_HCALL_I=
NVALID_CODE);
> +                       break;
> +               }
> +
> +               vcpu->stat.hypercall_exits++;
> +               vcpu->run->exit_reason =3D KVM_EXIT_HYPERCALL;
> +               vcpu->run->hypercall.nr =3D KVM_HCALL_USER_SERVICE;
> +               vcpu->run->hypercall.args[0] =3D kvm_read_reg(vcpu, LOONG=
ARCH_GPR_A0);
> +               vcpu->run->hypercall.args[1] =3D kvm_read_reg(vcpu, LOONG=
ARCH_GPR_A1);
> +               vcpu->run->hypercall.args[2] =3D kvm_read_reg(vcpu, LOONG=
ARCH_GPR_A2);
> +               vcpu->run->hypercall.args[3] =3D kvm_read_reg(vcpu, LOONG=
ARCH_GPR_A3);
> +               vcpu->run->hypercall.args[4] =3D kvm_read_reg(vcpu, LOONG=
ARCH_GPR_A4);
> +               vcpu->run->hypercall.args[5] =3D kvm_read_reg(vcpu, LOONG=
ARCH_GPR_A5);
> +               vcpu->run->hypercall.flags =3D 0;
> +               /*
> +                * Set invalid return value by default
> +                * Need user-mode VMM modify it
> +                */
> +               vcpu->run->hypercall.ret =3D KVM_HCALL_INVALID_CODE;
> +               ret =3D RESUME_HOST;
> +               break;
>         case KVM_HCALL_SWDBG:
>                 /* KVM_HCALL_SWDBG only in effective when SW_BP is enable=
d */
>                 if (vcpu->guest_debug & KVM_GUESTDBG_SW_BP_MASK) {
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index d18a4a270415..888480a5bc25 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -1735,7 +1735,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>         if (run->exit_reason =3D=3D KVM_EXIT_LOONGARCH_IOCSR) {
>                 if (!run->iocsr_io.is_write)
>                         kvm_complete_iocsr_read(vcpu, run);
> -       }
> +       } else if (run->exit_reason =3D=3D KVM_EXIT_HYPERCALL)
> +               kvm_complete_user_service(vcpu, run);
>
>         if (!vcpu->wants_to_run)
>                 return r;
>
> base-commit: fc033cf25e612e840e545f8d5ad2edd6ba613ed5
> --
> 2.39.3
>

