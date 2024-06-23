Return-Path: <kvm+bounces-20331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E48AF91396F
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 12:12:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E392EB22607
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 10:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED6412D1E8;
	Sun, 23 Jun 2024 10:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bn9xMcAd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D3982C67;
	Sun, 23 Jun 2024 10:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719137512; cv=none; b=B+HDioqwRLEsOkX4eb2IJQrtllLzmmGENSdNesUGOuzFNeiyN3fpEi2tT4lqlYjRr7fDPURXxG40DX9shqS7SBT5q+zpvksAa0vsdJXWnrD0EPN6Nw7xWQJVdQejvQ3VL5sNYApaPcJ76rJsR8VmAeQodlNDHXeJO+dAyhIbRjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719137512; c=relaxed/simple;
	bh=UUY0EKFbtHDpNNMJ6x+IcJHo44grxkhEVKMk5APQydQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lwO1kpMoLZdUZ5HlXZQlbLxRR86PiJmddTLjzPFZTzE5uw1Uk/PGkpNWiz2SIymB80jiDzocp2YerKccgUByot2R80QDppPPpAvKc/4JgukDTjgVBIa4giuXnuyZJJiC8Jz2vXlrVyR7Ukk96e9ksisAjx0Ye8heGPPvTlgblyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bn9xMcAd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF1DC2BD10;
	Sun, 23 Jun 2024 10:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719137511;
	bh=UUY0EKFbtHDpNNMJ6x+IcJHo44grxkhEVKMk5APQydQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Bn9xMcAd9+CR8jZA3h4iMqY4GBAhKcV3Z47UIrueRxjpD5SJ1mbhkwQqE/uI/zPPn
	 Rx40dDn7Tb2ReolaxM9jKtbCg4oP8vRK0fGrfxF8oSZ4rr9cJVrjrARKTQckBlzcsr
	 4g5RyLiTJmlDArPnzQr4gc7ETJznxqtJe0fBNeKPuxym9inhzu6t3DBkbHDZlBZvqH
	 QJ0/mlSbvsPZ+MQxfz1ycn1vs6wY2J5VVNa1cLshGo4Z6YzreqN+YoGSwG7RJ7vb9U
	 9pK98hbRU1fIA0rohiroWqgGaq6b56k3etFNmLYQuyVKq1ccyAoKFIFrJHPFWdceci
	 YAUrvX2sDXt2w==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-57cbc66a0a6so2331910a12.1;
        Sun, 23 Jun 2024 03:11:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXTxNFTosanaOd6Y72S85dxTVLfBSediXWFcg8J1Kfz7g31I8XpECVRanoSc37Kisf/tkX1gN1eOzgEiUHHQDXv2IM+4lg1BbJCznYCt1nZo9hV5EW0H/08EG640/oDgGY9
X-Gm-Message-State: AOJu0YyhPLrKc+cJSTYZFYY0djW9A1abSUZ5QFlBZPPSVF3pfgeOFGou
	zHkCZFbL2nBInMMdHX05Xv3EtquOjx53FNiRbUFYc0oqc0EgsUc8JcSHz2YrnpNu27+D36IlLjb
	PGCd3YDRNeHFVzAW3VA3CvwkVbfU=
X-Google-Smtp-Source: AGHT+IFaWt9kWADrSXuYKdHqoR3Ju4y0R08V2mfZ8XeBiNIiqNBhAYgyJ2FEkt2rKcK6yd9mE6ne1eeWh33cQpRth3U=
X-Received: by 2002:a50:cdd5:0:b0:57c:f948:bf19 with SMTP id
 4fb4d7f45d1cf-57d44c12baemr2258546a12.7.1719137510399; Sun, 23 Jun 2024
 03:11:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240527074644.836699-1-maobibo@loongson.cn> <20240527074644.836699-2-maobibo@loongson.cn>
In-Reply-To: <20240527074644.836699-2-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 23 Jun 2024 18:11:38 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6VpRzxAvVVifoXXHGK=46R4uO+Jp2aSbzsW-Gr0QPfHQ@mail.gmail.com>
Message-ID: <CAAhV-H6VpRzxAvVVifoXXHGK=46R4uO+Jp2aSbzsW-Gr0QPfHQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] LoongArch: KVM: Add HW Binary Translation
 extension support
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Mon, May 27, 2024 at 3:46=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Loongson Binary Translation (LBT) is used to accelerate binary translatio=
n,
> which contains 4 scratch registers (scr0 to scr3), x86/ARM eflags (eflags=
)
> and x87 fpu stack pointer (ftop).
>
> Like FPU extension, here late enabling method is used for LBT. LBT contex=
t
> is saved/restored on vcpu context switch path.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_host.h |  8 ++++
>  arch/loongarch/include/asm/kvm_vcpu.h | 10 +++++
>  arch/loongarch/kvm/exit.c             |  9 ++++
>  arch/loongarch/kvm/vcpu.c             | 59 ++++++++++++++++++++++++++-
>  4 files changed, 85 insertions(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index 2eb2f7572023..88023ab59486 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -133,6 +133,7 @@ enum emulation_result {
>  #define KVM_LARCH_LASX         (0x1 << 2)
>  #define KVM_LARCH_SWCSR_LATEST (0x1 << 3)
>  #define KVM_LARCH_HWCSR_USABLE (0x1 << 4)
> +#define KVM_LARCH_LBT          (0x1 << 5)
>
>  struct kvm_vcpu_arch {
>         /*
> @@ -166,6 +167,7 @@ struct kvm_vcpu_arch {
>
>         /* FPU state */
>         struct loongarch_fpu fpu FPU_ALIGN;
> +       struct loongarch_lbt lbt;
>
>         /* CSR state */
>         struct loongarch_csrs *csr;
> @@ -235,6 +237,12 @@ static inline bool kvm_guest_has_lasx(struct kvm_vcp=
u_arch *arch)
>         return arch->cpucfg[2] & CPUCFG2_LASX;
>  }
>
> +static inline bool kvm_guest_has_lbt(struct kvm_vcpu_arch *arch)
> +{
> +       return arch->cpucfg[2] & (CPUCFG2_X86BT | CPUCFG2_ARMBT
> +                                       | CPUCFG2_MIPSBT);
> +}
> +
>  /* Debug: dump vcpu state */
>  int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
>
> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/inclu=
de/asm/kvm_vcpu.h
> index d7e51300a89f..ec46009be29b 100644
> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> @@ -75,6 +75,16 @@ static inline void kvm_save_lasx(struct loongarch_fpu =
*fpu) { }
>  static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
>  #endif
>
> +#ifdef CONFIG_CPU_HAS_LBT
> +int kvm_own_lbt(struct kvm_vcpu *vcpu);
> +#else
> +static inline int kvm_own_lbt(struct kvm_vcpu *vcpu) { return -EINVAL; }
> +static inline void kvm_lose_lbt(struct kvm_vcpu *vcpu) { }
> +static inline void kvm_enable_lbt_fpu(struct kvm_vcpu *vcpu,
> +                                       unsigned long fcsr) { }
> +static inline void kvm_check_fcsr(struct kvm_vcpu *vcpu) { }
> +#endif
It is better to keep symmetry here. That means also declare
kvm_lose_lbt for CONFIG_CPU_HAS_LBT, and move the last two functions
to .c because they are static.

> +
>  void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
>  void kvm_reset_timer(struct kvm_vcpu *vcpu);
>  void kvm_save_timer(struct kvm_vcpu *vcpu);
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index e2abd97fb13f..e1bd81d27fd8 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -835,6 +835,14 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcp=
u)
>         return ret;
>  }
>
> +static int kvm_handle_lbt_disabled(struct kvm_vcpu *vcpu)
> +{
> +       if (kvm_own_lbt(vcpu))
> +               kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> +
> +       return RESUME_GUEST;
> +}
> +
>  /*
>   * LoongArch KVM callback handling for unimplemented guest exiting
>   */
> @@ -867,6 +875,7 @@ static exit_handle_fn kvm_fault_tables[EXCCODE_INT_ST=
ART] =3D {
>         [EXCCODE_LASXDIS]               =3D kvm_handle_lasx_disabled,
>         [EXCCODE_GSPR]                  =3D kvm_handle_gspr,
>         [EXCCODE_HVC]                   =3D kvm_handle_hypercall,
> +       [EXCCODE_BTDIS]                 =3D kvm_handle_lbt_disabled,
>  };
>
>  int kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 382796f1d3e6..8f80d1a2dcbb 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -6,6 +6,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/entry-kvm.h>
>  #include <asm/fpu.h>
> +#include <asm/lbt.h>
>  #include <asm/loongarch.h>
>  #include <asm/setup.h>
>  #include <asm/time.h>
> @@ -952,12 +953,64 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vc=
pu, struct kvm_fpu *fpu)
>         return 0;
>  }
>
> +#ifdef CONFIG_CPU_HAS_LBT
> +int kvm_own_lbt(struct kvm_vcpu *vcpu)
> +{
> +       if (!kvm_guest_has_lbt(&vcpu->arch))
> +               return -EINVAL;
> +
> +       preempt_disable();
> +       set_csr_euen(CSR_EUEN_LBTEN);
> +
> +       _restore_lbt(&vcpu->arch.lbt);
> +       vcpu->arch.aux_inuse |=3D KVM_LARCH_LBT;
> +       preempt_enable();
> +       return 0;
> +}
> +
> +static void kvm_lose_lbt(struct kvm_vcpu *vcpu)
> +{
> +       preempt_disable();
> +       if (vcpu->arch.aux_inuse & KVM_LARCH_LBT) {
> +               _save_lbt(&vcpu->arch.lbt);
> +               clear_csr_euen(CSR_EUEN_LBTEN);
> +               vcpu->arch.aux_inuse &=3D ~KVM_LARCH_LBT;
> +       }
> +       preempt_enable();
> +}
> +
> +static void kvm_enable_lbt_fpu(struct kvm_vcpu *vcpu, unsigned long fcsr=
)
It is better to rename it to kvm_own_lbt_tm().

> +{
> +       /*
> +        * if TM is enabled, top register save/restore will
> +        * cause lbt exception, here enable lbt in advance
> +        */
> +       if (fcsr & FPU_CSR_TM)
> +               kvm_own_lbt(vcpu);
> +}
> +
> +static void kvm_check_fcsr(struct kvm_vcpu *vcpu)
> +{
> +       unsigned long fcsr;
> +
> +       if (vcpu->arch.aux_inuse & KVM_LARCH_FPU)
> +               if (!(vcpu->arch.aux_inuse & KVM_LARCH_LBT)) {
The condition can be simplified " if (vcpu->arch.aux_inuse &
(KVM_LARCH_FPU|KVM_LARCH_LBT) =3D=3D KVM_LARCH_FPU)"

> +                       fcsr =3D read_fcsr(LOONGARCH_FCSR0);
> +                       kvm_enable_lbt_fpu(vcpu, fcsr);
> +               }
> +}
> +#endif
> +
>  /* Enable FPU and restore context */
>  void kvm_own_fpu(struct kvm_vcpu *vcpu)
>  {
>         preempt_disable();
>
> -       /* Enable FPU */
> +       /*
> +        * Enable FPU for guest
> +        * We set FR and FRE according to guest context
> +        */
> +       kvm_enable_lbt_fpu(vcpu, vcpu->arch.fpu.fcsr);
>         set_csr_euen(CSR_EUEN_FPEN);
>
>         kvm_restore_fpu(&vcpu->arch.fpu);
> @@ -977,6 +1030,7 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
>         preempt_disable();
>
>         /* Enable LSX for guest */
> +       kvm_enable_lbt_fpu(vcpu, vcpu->arch.fpu.fcsr);
>         set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
>         switch (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
>         case KVM_LARCH_FPU:
> @@ -1011,6 +1065,7 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
>
>         preempt_disable();
>
> +       kvm_enable_lbt_fpu(vcpu, vcpu->arch.fpu.fcsr);
>         set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN);
>         switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_LSX)) {
>         case KVM_LARCH_LSX:
> @@ -1042,6 +1097,7 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
>  {
>         preempt_disable();
>
> +       kvm_check_fcsr(vcpu);
>         if (vcpu->arch.aux_inuse & KVM_LARCH_LASX) {
>                 kvm_save_lasx(&vcpu->arch.fpu);
>                 vcpu->arch.aux_inuse &=3D ~(KVM_LARCH_LSX | KVM_LARCH_FPU=
 | KVM_LARCH_LASX);
> @@ -1064,6 +1120,7 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
>                 /* Disable FPU */
>                 clear_csr_euen(CSR_EUEN_FPEN);
>         }
> +       kvm_lose_lbt(vcpu);
>
>         preempt_enable();
>  }
> --
> 2.39.3
>

