Return-Path: <kvm+bounces-34335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9212C9FABA7
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 09:50:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD3551884B86
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 08:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B48B1917D4;
	Mon, 23 Dec 2024 08:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mB7D6OWd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D29938C;
	Mon, 23 Dec 2024 08:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734943839; cv=none; b=BN4u6I5y+iDYjuZSOX3MWARbH3yyhkhdGsSR4ZkxVTILLChJ5uziu8znm25dbDJ5Y/tF742sPDcrtLDwg8q3t6r/h3SNAULOtMx112OhumDn2G+evIZEJcJc2f63kkNWdMFeuX3m17FWQFXWQYiy40lqYumhpSQiDrw7UVw71Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734943839; c=relaxed/simple;
	bh=H1LC6Vy03ycP1WvARCuq4qBnqa0/T9FTLbv/EA6LOnc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cCBjqVRuw6heNrRDaqRmbJeIK1iZzyMZTVBW1J3u4tsZWBKSc5fDYHgbBFcy5xKZEhizlSHZAdv4aB+oYxrXwtxR6xIkyT9eEp/U5xsmPnVv/kzCPOIEKEzb1UVAOeBMrKXvLQmqXqTuzgq/CSoXHiSbCotusqTugDTNp9XdoWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mB7D6OWd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B462DC4CED3;
	Mon, 23 Dec 2024 08:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734943838;
	bh=H1LC6Vy03ycP1WvARCuq4qBnqa0/T9FTLbv/EA6LOnc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mB7D6OWdxJITqkl0CNouKBh9AYgqB8LSueRHRfoLr8UWj+xLDV9/GiclYB0G1TGy0
	 fTXm0VPgAGe+jY/898ayIBOBIVV6fE3ebe8KwBS41nC4WntDV4bmlvFOoK7vnxRCa9
	 ewDvmT2Sd27KUn0ToNOaAPomgOpNhTXVs9xhFGIYQ22hw2ghtSd/gRDIeIfB6E5jjY
	 /wMa6gWa/K3sxGcJhVstxkpTAfRj9g62hSNgBbfvx4nkg/L8RB5C3GuPV8r0Wud422
	 pTMndxZgn+5iUsjW2OcK9ek82B21hIg7rwTo9mBga3ktpGwkCcHbHm9pJ7cTdz28tw
	 4Npv5JcdK9k0Q==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aaec6ab57a5so147879566b.1;
        Mon, 23 Dec 2024 00:50:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV5jtqSyprwXE+6FsEjVLur4kogx16pasxHkPASgtrFLIRvJVeIGZzux5n0SUKeBUkVfUHV9Izx9Heho0jY@vger.kernel.org, AJvYcCVvosA+QMi97ptPtwgsDfGGrB6gCJYuh+IN5n2GnC/0UazX4Lfr+nbGBOR/p4lmQCNqzMY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmdYyoqCFR3nXW/Glw8y9j/L8jI1DPvlGALGBuL5QhD6XurVN7
	eeL/wKfTt6+r2GXYEm64rmeq8HQ/rFT2lD04W/gcs2g4yw8uMzE6L5WtNT7jbFbw4mzt/OJ33QF
	/ya287V3BdIA8NRQJOYQ50Hrsx7A=
X-Google-Smtp-Source: AGHT+IFLbziOXbcevVFkvT/IBRY6OchSktfVkdeOnYQ88T30iRP6JSnxFQEexgQO/8XGYAIItsDLyiiMIM23sFIhwJQ=
X-Received: by 2002:a17:907:78b:b0:aa6:7cf3:c6f5 with SMTP id
 a640c23a62f3a-aac2d447172mr976215266b.9.1734943837209; Mon, 23 Dec 2024
 00:50:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241223084212.34822-1-maobibo@loongson.cn>
In-Reply-To: <20241223084212.34822-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 23 Dec 2024 16:50:27 +0800
X-Gmail-Original-Message-ID: <CAAhV-H73CaNYFtgDfM+SOXYmwUhzr1w7JC4D+t2aASyUBxxTrA@mail.gmail.com>
Message-ID: <CAAhV-H73CaNYFtgDfM+SOXYmwUhzr1w7JC4D+t2aASyUBxxTrA@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Add hypercall service support for
 usermode VMM
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

Is this patch trying to do the same thing as "LoongArch: add hypcall
to emulate syscall in kvm" in 4.19?

Huacai

On Mon, Dec 23, 2024 at 4:42=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Some VMMs provides special hypercall service in usermode, KVM need
> not handle the usermode hypercall service and pass it to VMM and
> let VMM handle it.
>
> Here new code KVM_HCALL_CODE_USER is added for user-mode hypercall
> service, KVM loads all six registers to VMM.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_host.h      |  1 +
>  arch/loongarch/include/asm/kvm_para.h      |  2 ++
>  arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
>  arch/loongarch/kvm/exit.c                  | 22 ++++++++++++++++++++++
>  arch/loongarch/kvm/vcpu.c                  |  3 +++
>  5 files changed, 29 insertions(+)
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
> index a7893bd01e73..1a85cd4fb6a5 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -873,6 +873,28 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcp=
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
> index d18a4a270415..8c46ad1872ee 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -1735,6 +1735,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>         if (run->exit_reason =3D=3D KVM_EXIT_LOONGARCH_IOCSR) {
>                 if (!run->iocsr_io.is_write)
>                         kvm_complete_iocsr_read(vcpu, run);
> +       } else if (run->exit_reason =3D=3D KVM_EXIT_HYPERCALL) {
> +               kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hypercall.ret)=
;
> +               update_pc(&vcpu->arch);
>         }
>
>         if (!vcpu->wants_to_run)
>
> base-commit: 48f506ad0b683d3e7e794efa60c5785c4fdc86fa
> --
> 2.39.3
>

