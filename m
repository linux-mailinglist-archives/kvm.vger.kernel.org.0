Return-Path: <kvm+bounces-16603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF898BC5A5
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 03:54:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2186A1F212CA
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 01:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4FE73FB89;
	Mon,  6 May 2024 01:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnMXzKI3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6233CF6A;
	Mon,  6 May 2024 01:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714960450; cv=none; b=ihZUoKm97rknt6KohqgaBw90ZCv+2kG+DnOgzyE5c1fpIBWLgot8xaIgGfdIPYmtPhRHyiUua6BV8Y2KggZend1Xs2NQIxWeUUjB0JPANva3lzkictCsVeY/zudBz/HqrfIGItJ+wzEQLEkELp91jVKsgncYyd3by342wQFOwAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714960450; c=relaxed/simple;
	bh=wqvbSfqASjdhRGU64oFAqCxbJFGguD68ptR8QuLtpCk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=McrNAdBb01KgDKmJOZjIW3c/6XMxypzd7k0CSysFvVUozvfDmRNAATyLrEMCGGOriRiITdVDqwcbdgY8ikECl7d4qPSPf8Cils5kjvzMp+ce1sXwltop5bnIUqlUiFAcdAr1hXUSiA2tRXF7Ztbe7hNMWA8a/0M4W/+UAj4pJRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnMXzKI3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814F9C4AF18;
	Mon,  6 May 2024 01:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714960450;
	bh=wqvbSfqASjdhRGU64oFAqCxbJFGguD68ptR8QuLtpCk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gnMXzKI3/znktUJO5b9hEOYOimxzH7iXvIV/nub/dKy7rd51TaYiBkqBioMlAPTXW
	 JcZ1hO0+7CsLQnUlJG/ROm2Wokvgb/B/MOzBCPqR3FqEwSsXyNqFWR/ExSx/yiv3wx
	 2U6p5YKezEaRYo58VNsUGDKH1j69ftdHh5qQKlu6enVAL5lJtzDvo9z6wY5SvQFdml
	 5Cd2oe4uw0FoPHk9jY8tcSJfSRxARtUDAV3XcvGh3zAod0jcPuO9sWLulkIumTlRbY
	 cTGD+Q2op3CHIOZ1i95sIXDK/hIfSuJKYph77PfPxcr57SZ1x7+5BO95za+IWEOuiY
	 nPkat7Ww+0KeA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a59a64db066so308368766b.3;
        Sun, 05 May 2024 18:54:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWhjaDg6wyrBV3AX+xkXlEJ1hdakwx1pL2qewJWwxIfYoCRofWzbbEfCqjvlj/gQiET3vIzGAhVEDVLMFh3c4wFmdvVZLRulaO+ZtGXeeSTeTevKH+WYZh2SEhmwE+Mb93a
X-Gm-Message-State: AOJu0YzYKS7HigHFZylTInQD/Va4Nl97uYPIjX+ZCt8f0vxSI/hHRUyr
	dp+icUJsYIamLk/yb9JU4RfAvNnaJ1LdMw2flDGjnAhw/y5xZArleOseFTuxF3QiRXmr1gX5czx
	00RXxdPkQXkbcGPz8qM9oWlMz0xM=
X-Google-Smtp-Source: AGHT+IFyne0PGmrxsuBA29OKXPc0/1FcyKrT3Pe5n8Q8atPGd7E+2GHxN5AUFeKJKIrZx26inDqLyRR9IUNJVlS0fis=
X-Received: by 2002:a17:906:1951:b0:a59:aa0d:60 with SMTP id
 b17-20020a170906195100b00a59aa0d0060mr2991394eje.6.1714960449129; Sun, 05 May
 2024 18:54:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240428100518.1642324-1-maobibo@loongson.cn> <20240428100518.1642324-3-maobibo@loongson.cn>
In-Reply-To: <20240428100518.1642324-3-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 6 May 2024 09:54:00 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5xVP0+aUyq2+_XHW0=25zxuG53o=+vUV4MfKn=4tiwxA@mail.gmail.com>
Message-ID: <CAAhV-H5xVP0+aUyq2+_XHW0=25zxuG53o=+vUV4MfKn=4tiwxA@mail.gmail.com>
Subject: Re: [PATCH v8 2/6] LoongArch: KVM: Add hypercall instruction
 emulation support
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Sun, Apr 28, 2024 at 6:05=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> On LoongArch system, there is hypercall instruction special for
> virtualization. When system executes this instruction on host side,
> there is illegal instruction exception reported, however it will
> trap into host when it is executed in VM mode.
>
> When hypercall is emulated, A0 register is set with value
> KVM_HCALL_INVALID_CODE, rather than inject EXCCODE_INE invalid
> instruction exception. So VM can continue to executing the next code.
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
> index 2dbec7853ae8..c862672ed953 100644
> --- a/arch/loongarch/include/asm/Kbuild
> +++ b/arch/loongarch/include/asm/Kbuild
> @@ -26,4 +26,3 @@ generic-y +=3D poll.h
>  generic-y +=3D param.h
>  generic-y +=3D posix_types.h
>  generic-y +=3D resource.h
> -generic-y +=3D kvm_para.h
> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/inclu=
de/asm/kvm_para.h
> new file mode 100644
> index 000000000000..d48f993ae206
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_para.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_LOONGARCH_KVM_PARA_H
> +#define _ASM_LOONGARCH_KVM_PARA_H
> +
> +/*
> + * LoongArch hypercall return code
> + */
> +#define KVM_HCALL_STATUS_SUCCESS       0
> +#define KVM_HCALL_INVALID_CODE         -1UL
> +#define KVM_HCALL_INVALID_PARAMETER    -2UL
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
This file shouldn't be removed.

Huacai

> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index ed1d89d53e2e..923bbca9bd22 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -685,6 +685,15 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu =
*vcpu)
>         return RESUME_GUEST;
>  }
>
> +static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
> +{
> +       update_pc(&vcpu->arch);
> +
> +       /* Treat it as noop intruction, only set return value */
> +       vcpu->arch.gprs[LOONGARCH_GPR_A0] =3D KVM_HCALL_INVALID_CODE;
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
> +       [EXCCODE_HVC]                   =3D kvm_handle_hypercall,
>  };
>
>  int kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
> --
> 2.39.3
>
>

