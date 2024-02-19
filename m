Return-Path: <kvm+bounces-8996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7B42859ACB
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 03:41:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 925982814E0
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 02:41:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2E34400;
	Mon, 19 Feb 2024 02:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+OGnFGN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9722BEDD;
	Mon, 19 Feb 2024 02:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708310472; cv=none; b=s1R8H3wTOEPn9wvvlSM0FtCFBbIsFZOpNyU4lNZoRuz0urR4g6ZmcVxgZpkPEtKrz7HDOvrm+oHDTdYwFEsM//2L09UkuIY5857t6db1dP3E9HTAHWMBgEytiK0rrVq86gWtuPf4uKLQZsKNmX269egWVRd4Un49bhsLZMN6LMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708310472; c=relaxed/simple;
	bh=n/DOB7UnLd+txgeMjMhK1a3w80QrfLgIcdMDu/kmSzg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mG+EnxwE+F5rUSggWUjMZUdtnecw+I607VSAQnHQenXEeFy7lDKAItuQMyI2FDilaNygr/m/QtpZLb3gBV+I5k2BVlmW7yDwVNLtJ/mhfLlUNhtf/Cg/QEPqmBWZyuq3CU/tabP5fIKejOC7av+cJz1j9bcGCKPlQF4Vts7CKNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+OGnFGN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127CAC43394;
	Mon, 19 Feb 2024 02:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708310472;
	bh=n/DOB7UnLd+txgeMjMhK1a3w80QrfLgIcdMDu/kmSzg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=S+OGnFGNjWQfCbxi9spgZO3ZgUu3iOx4/IVtMC2fFZ1mdPkopxJNgaGV7YNl5O7X+
	 mEVDqZweuwbhJ6sX2pScf6dvDARQ4l2kEomupAXAGWFr3K+ynwdjQ2cke5DT4AkfrF
	 R/wpzatt+FZBsoo3Y6rMTePM6W8ZoD0bqdV6sqK1rSwQ6dcLVRWn1iZOi9GzTpKfiB
	 BM22TPSOuMhGC59jx0aXXcsrHyyyWw4z9duVkfuC2qlqsTlvOxEdZujISm3LdvaMFP
	 fdhZ1heA5dujJoTOaIhh4fEb5cTOZHYVmjR+FB1uzIgOCE2CIMpIjUjUMpDNOnmy2K
	 Z4U7QbFqnnZew==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-512b700c8ebso249391e87.0;
        Sun, 18 Feb 2024 18:41:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWQobqZhGdFsMc7FnEXUQ0YVSkNl7m1vRWllC/7Zgj9hLXkuJhW735sUuRpbcWnFeZLqX9gsKFwKd7iWwUolqzdPvPe4rMvZUP0CGtwUDusaGsMmayFg42QMSxFkt0BNJ2P
X-Gm-Message-State: AOJu0YxEUmW3wB8RMOcVeqHtD8zkh3uIZqQVhhCg6s6g9LTqAlkFKlyU
	IWQsvo20GZpJ62G3gPtBXBPq83mNHdjM2UuFICqtSMfOlgGdVKptlnGaxQrbs8YK2kQbsQKTVMz
	CFv0E/PDrZq7LU/NV7VlpNY1xftM=
X-Google-Smtp-Source: AGHT+IGkf86sxr3E88riN9LY+fLnYRXO7KBtdBQuStB4h/v7RHbcSd+YPmDerO6Lb24C5vHUo5MWSE1B85bs0/AHILI=
X-Received: by 2002:a05:6512:3d9e:b0:511:61b4:65c1 with SMTP id
 k30-20020a0565123d9e00b0051161b465c1mr8974984lfv.39.1708310470192; Sun, 18
 Feb 2024 18:41:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240201031950.3225626-1-maobibo@loongson.cn> <20240201031950.3225626-3-maobibo@loongson.cn>
In-Reply-To: <20240201031950.3225626-3-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 19 Feb 2024 10:41:07 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4f=m2xX7_WF3YkRbxWyVAyBLemNv3OVq-AbqtsKKtCyA@mail.gmail.com>
Message-ID: <CAAhV-H4f=m2xX7_WF3YkRbxWyVAyBLemNv3OVq-AbqtsKKtCyA@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] LoongArch: KVM: Add hypercall instruction
 emulation support
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Thu, Feb 1, 2024 at 11:19=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> On LoongArch system, hypercall instruction is supported when system
> runs on VM mode. This patch adds dummy function with hypercall
> instruction emulation, rather than inject EXCCODE_INE invalid
> instruction exception.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/Kbuild      |  1 -
>  arch/loongarch/include/asm/kvm_para.h  | 26 ++++++++++++++++++++++++++
>  arch/loongarch/include/uapi/asm/Kbuild |  2 --
>  arch/loongarch/kvm/exit.c              | 10 ++++++++++
>  4 files changed, 36 insertions(+), 3 deletions(-)
>  create mode 100644 arch/loongarch/include/asm/kvm_para.h
>  delete mode 100644 arch/loongarch/include/uapi/asm/Kbuild
>
> diff --git a/arch/loongarch/include/asm/Kbuild b/arch/loongarch/include/a=
sm/Kbuild
> index 93783fa24f6e..22991a6f0e2b 100644
> --- a/arch/loongarch/include/asm/Kbuild
> +++ b/arch/loongarch/include/asm/Kbuild
> @@ -23,4 +23,3 @@ generic-y +=3D poll.h
>  generic-y +=3D param.h
>  generic-y +=3D posix_types.h
>  generic-y +=3D resource.h
> -generic-y +=3D kvm_para.h
> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/inclu=
de/asm/kvm_para.h
> new file mode 100644
> index 000000000000..9425d3b7e486
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_para.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_LOONGARCH_KVM_PARA_H
> +#define _ASM_LOONGARCH_KVM_PARA_H
> +
> +/*
> + * LoongArch hypcall return code
Maybe using "hypercall" in comments is better.

> + */
> +#define KVM_HC_STATUS_SUCCESS          0
> +#define KVM_HC_INVALID_CODE            -1UL
> +#define KVM_HC_INVALID_PARAMETER       -2UL
Maybe KVM_HCALL_SUCCESS/KVM_HCALL_INVALID_CODE/KVM_HCALL_PARAMETER is bette=
r.

Huacai

> +
> +static inline unsigned int kvm_arch_para_features(void)
> +{
> +       return 0;
> +}
> +
> +static inline unsigned int kvm_arch_para_hints(void)
> +{
> +       return 0;
> +}
> +
> +static inline bool kvm_check_and_clear_guest_paused(void)
> +{
> +       return false;
> +}
> +#endif /* _ASM_LOONGARCH_KVM_PARA_H */
> diff --git a/arch/loongarch/include/uapi/asm/Kbuild b/arch/loongarch/incl=
ude/uapi/asm/Kbuild
> deleted file mode 100644
> index 4aa680ca2e5f..000000000000
> --- a/arch/loongarch/include/uapi/asm/Kbuild
> +++ /dev/null
> @@ -1,2 +0,0 @@
> -# SPDX-License-Identifier: GPL-2.0
> -generic-y +=3D kvm_para.h
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index ed1d89d53e2e..d15c71320a11 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -685,6 +685,15 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu =
*vcpu)
>         return RESUME_GUEST;
>  }
>
> +static int kvm_handle_hypcall(struct kvm_vcpu *vcpu)
> +{
> +       update_pc(&vcpu->arch);
> +
> +       /* Treat it as noop intruction, only set return value */
> +       vcpu->arch.gprs[LOONGARCH_GPR_A0] =3D KVM_HC_INVALID_CODE;
> +       return RESUME_GUEST;
> +}
> +
>  /*
>   * LoongArch KVM callback handling for unimplemented guest exiting
>   */
> @@ -716,6 +725,7 @@ static exit_handle_fn kvm_fault_tables[EXCCODE_INT_ST=
ART] =3D {
>         [EXCCODE_LSXDIS]                =3D kvm_handle_lsx_disabled,
>         [EXCCODE_LASXDIS]               =3D kvm_handle_lasx_disabled,
>         [EXCCODE_GSPR]                  =3D kvm_handle_gspr,
> +       [EXCCODE_HVC]                   =3D kvm_handle_hypcall,
>  };
>
>  int kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
> --
> 2.39.3
>

