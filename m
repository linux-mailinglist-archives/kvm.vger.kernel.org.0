Return-Path: <kvm+bounces-39883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B29A1A4C2CB
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 15:06:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C8F13A6B78
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 14:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6368B2135B1;
	Mon,  3 Mar 2025 14:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FtSE7Woo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A02D212B17;
	Mon,  3 Mar 2025 14:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741010780; cv=none; b=gn48Q68aNI/KXPOjUKBjbtCdWnfoGJ72WxSgkg3vo9V2P4DQnom+SRrm25IHSdBcL6p+q3mr27LB+YOSRdy6MOqtmdrUS0fuiCHS30FdTVZ/mpQRkVBuPqGAcMzRL2/P/MCLH60MtvY6YH57Eu3jugcOklqg2gB+qOQPFH6gaqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741010780; c=relaxed/simple;
	bh=q0PFX0losjl7aEQ9QntoNI7MQUmCLuFCqPgx2ZqXDkc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S8z2y1OeR9PwVjuNnEqVqCdE5kGnzHpPeB84UbhNr0KFD3b/fpWfa82gPl7/36DfoQ3uzC+yadSCilReg9T0PjHn1CU83EKkQqbxP5zWamdrMsv1CDTKASed8s1OgQLGjaBzrETqyUpNiebrOnG5kWgkjPdFSdzP3kyKih6hG3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FtSE7Woo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21269C4CEE9;
	Mon,  3 Mar 2025 14:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741010780;
	bh=q0PFX0losjl7aEQ9QntoNI7MQUmCLuFCqPgx2ZqXDkc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FtSE7WooCjPaRLQ1dPVHp20xQM4Emprv9A7D8WFP03CqD7Vi7Fze47a8CHeKnd96P
	 QoLufSlz+xZUQ2NqBrbX8wz8qG8ZRBRX8DFW7/ZJonujrKseWchU8K4N3RRhPfT0gx
	 g/VPLfRxdNtzJeRfHQB3RUrGwdGIs6zjYrZ+S03ikCPKdcHrE0BWvok9RWbRdpcJxG
	 KkyWb/MWKdU3dYNvzGulb0l8DkubBra7DaIUwkPnhzbQuLzMLFig3ItYO2HS6NWq2X
	 BMj8a21d9wS+P5uY5amsHcP+HosSDEoDf2Q0W5FiY3dOhc6eemN8TovMdhjTt095S5
	 6uw2tvqYnobOg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ab78e6edb99so618370566b.2;
        Mon, 03 Mar 2025 06:06:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUEmNvuYswQlCIIi4877McYP07UuObiuTfvjL2U9vIIhdxMa4Wq1uIwLmJQ1XDPGTrRda0=@vger.kernel.org, AJvYcCVXgkwgVCkad2C+lF2K9MH9Pg9cKCQGJTWRMrqFfpXU6/HBu5V85FDBpkw/7LvMBc3KY8fiuLTffVK7f8k3@vger.kernel.org
X-Gm-Message-State: AOJu0YxJkXqe1z1vCdu3jWAhwX4gMWSJW1568vUfLtsIgoqauCj+1I4m
	AiWi/MQ37iLgnK7Eh25NO6PaffaSATRLODMqVkrzClMNSXHTYFaq7uTZ17sgiDW5LGUvjo2RJRN
	IQDPzUDQWCT/48mxFaaYxSSqoOcA=
X-Google-Smtp-Source: AGHT+IFbo6UTER7oWJT4suLe+ZnOgUXlzIOvfTHpwO4C/rsdVw9zS1CzULb5wSIxDxuEVyiDS3AT3ogGngoYA59T6B8=
X-Received: by 2002:a17:907:3e1d:b0:ac1:e00c:a566 with SMTP id
 a640c23a62f3a-ac1e00ca7d9mr239206166b.45.1741010778545; Mon, 03 Mar 2025
 06:06:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303091114.1511496-1-maobibo@loongson.cn>
In-Reply-To: <20250303091114.1511496-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 3 Mar 2025 22:06:05 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7VGkmRhu+bV0ueLdbaaxuY7W9tLu3yyYeK75FLSvRaug@mail.gmail.com>
X-Gm-Features: AQ5f1JrCtx0nYKWpwM7Pfr3sn0Fv787-dpipRIE-vOx4dA8LJPfZn_NUHJTqZ5c
Message-ID: <CAAhV-H7VGkmRhu+bV0ueLdbaaxuY7W9tLu3yyYeK75FLSvRaug@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Reload guest CSR registers after S4
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Xianglai Li <lixianglai@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Mon, Mar 3, 2025 at 5:11=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrote=
:
>
> On host HW guest CSR registers are lost after suspend and resume
> operation. Since last_vcpu of boot CPU still records latest vCPU pointer
> so that guest CSR register skips to reload when boot CPU resumes and
> vCPU is scheduled.
>
> Here last_vcpu is cleared so that guest CSR register will reload from
> scheduled vCPU context after suspend and resume.
>
> Also there is another small fix for Loongson AVEC support, bit 14 is adde=
d
> in CSR ESTAT register. Macro CSR_ESTAT_IS is replaced with hardcoded valu=
e
> 0x1fff and AVEC interrupt status bit 14 is supported with macro
> CSR_ESTAT_IS.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/main.c | 8 ++++++++
>  arch/loongarch/kvm/vcpu.c | 2 +-
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index f6d3242b9234..b177773f38f6 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -284,6 +284,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  int kvm_arch_enable_virtualization_cpu(void)
>  {
>         unsigned long env, gcfg =3D 0;
> +       struct kvm_context *context;
>
>         env =3D read_csr_gcfg();
>
> @@ -317,6 +318,13 @@ int kvm_arch_enable_virtualization_cpu(void)
>         kvm_debug("GCFG:%lx GSTAT:%lx GINTC:%lx GTLBC:%lx",
>                   read_csr_gcfg(), read_csr_gstat(), read_csr_gintc(), re=
ad_csr_gtlbc());
>
> +       /*
> +        * HW Guest CSR registers are lost after CPU suspend and resume
> +        * Clear last_vcpu so that Guest CSR register forced to reload
> +        * from vCPU SW state
> +        */
> +       context =3D this_cpu_ptr(vmcs);
> +       context->last_vcpu =3D NULL;
This can be simplified as this_cpu_ptr(vmcs)->last_vcpu =3D NULL;

>         return 0;
>  }
>
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 20f941af3e9e..9e1a9b4aa4c6 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -311,7 +311,7 @@ static int kvm_handle_exit(struct kvm_run *run, struc=
t kvm_vcpu *vcpu)
>  {
>         int ret =3D RESUME_GUEST;
>         unsigned long estat =3D vcpu->arch.host_estat;
> -       u32 intr =3D estat & 0x1fff; /* Ignore NMI */
> +       u32 intr =3D estat & CSR_ESTAT_IS;
This part has nothing to do with S4, please split to another patch.

Huacai

>         u32 ecode =3D (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
>
>         vcpu->mode =3D OUTSIDE_GUEST_MODE;
>
> base-commit: 1e15510b71c99c6e49134d756df91069f7d18141
> --
> 2.39.3
>
>

