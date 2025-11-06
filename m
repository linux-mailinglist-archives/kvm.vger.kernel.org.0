Return-Path: <kvm+bounces-62235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D18CBC3D0F9
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 19:22:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7E96A4E31A4
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 18:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53D0E350A34;
	Thu,  6 Nov 2025 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zcavtd7Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD92C350A2B
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 18:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762453312; cv=none; b=h/LTKATRsXYGWWSvYmx79+aq2tODoXxsRSTQkYXEsPVXj1Q/dYAepLD6t7b2wPvBHFFpQfBvrNYklYlmnJjGWvfBGDMx7veRNfRTyyP3OfOE+L9PVoVa1xC4iYbP/KXmQUoJvxs7bvuThGyKxgWHiVhwocN/zMnHJo7Cz/a6yR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762453312; c=relaxed/simple;
	bh=bZMDLkWBrmbdYLYFA2VFE2c6sfmRdlnRtJrZ9LvTSoA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H1yZU4guiidLmtU4F0xwOAAdB+DwDYsrHeEgbvCiPjd2Iz2QMRHj3YpfhS9mO8U7IMojHo/o8cFZroMW0qCp95Q5L9uv+9hQ4zhR6eU1167X8+clpgXaN0OzaPb3Gcnju2txyqDhihhg0f8Q+YCdP9+Er/1mrEq0kV+nOjToMno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zcavtd7Y; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-378ccb8f84aso13112031fa.3
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 10:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762453309; x=1763058109; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nwtVDVrMx/Rn+GuGE/wxX6jR74kQlxj/0QcuG/d2Bqc=;
        b=Zcavtd7Y/cZ9z52inn8JMt66hpuSIJpVF9oMeRoGh5Z6acae3J60cj2S5HG3xEsoDw
         2N4Qeqqdq3+eAid0Pq5fudDKUKZxv778w0WR0rkhnhKiZam8SFDPcJ/L5FHu9Hhb9B8x
         JknDsYbVgOprYUP9uWUufUEJ5AwRCNWOoytcBwak3/i8p/yeqxSXkEzRCjKV2ZHvCeJB
         mzJJMCew+FXJIzsfeJkDc2m6zBgTknJ8jixUJBV/U3dnWSUoQI3+Y97ZxH4sOkP7Fk+3
         /Yb0Etua50Dae/FHb8RMaVIaChia4ZxdPdGgpffeKWcXE4J1fA2UgpDJsFbPM2adgWgm
         jzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762453309; x=1763058109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nwtVDVrMx/Rn+GuGE/wxX6jR74kQlxj/0QcuG/d2Bqc=;
        b=EoGcitstczCvmrVNhoZqWJWAIQuJtrNvCMMZGr/mgyDxiBBvYI7FJsOkQYecl8qUQn
         EUDFv47o28GPzuxs88aPPJbVfNtckbsRK3u0clw2CPHTSNsc9Ql9zr6FnqMAz6IZo9aB
         So0QDnZ+bo3WUd80msNoCKDdqoKmviBqs39mAFfvx3BBvEjRR33ehkvz0pQNRn3JBwgO
         mRlw/0hxxogv+AYPZ1y38eLseEKo2kkaDEHsZNHUAfnBo3kjQxR+8eRWUePreEqY9ZBU
         k+cbusEq8k4crUwdDU0kw2nonGekNGsU28TAqsrtorqDULEGcCYFAXqU5rWQSQHvaq9s
         hLFQ==
X-Forwarded-Encrypted: i=1; AJvYcCV81FSsZKPtoW6BZsghsewlobX3RZhIrbp8IcMNNwC1cW6QfGQpeed6oq+Of8VoF0yxQFQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu8MuBA6EMDL5EGeJK8mpQHtk+6fFs2MYYQuqG4RzdSaMn3xTS
	vMcDpUY3hrXOgKBQXv8VGvoP/0vcGGU2yOANJsD0iUeYsLXDFcDaaUrwSwdtHtgn5fGJybY7YlF
	vIMVMW4/YXGX9iMAtlfx6OsUkeJwrcvQ=
X-Gm-Gg: ASbGncsHXgxHNcD9hFXDs1kZvjL4McPltAcpj3a+sfg3449kmqwJ5Ql8owbZ+xD8iDu
	paPXXCvsAPQiDZ8dJkqBKgRmFQDtGGU22AGZSvZ67MS/Mx5d1vBx2SPku3XNfwkVDdhCfMAdJVR
	XpEqbARpXpG2Tz3pknbCoeajQaBRzmhOJNIt8fS3f48vPAcaFjdiKzkUXbO0i0pAWMJeECpdIf2
	swfXvViQl4BHGzbq/Tpqh4fC0GN9mWL0X/HtGvhKOZ8L5TRg3CymhgdHyupxKMKj1tD490=
X-Google-Smtp-Source: AGHT+IHF5RwYH8gt4GCJWiK/G06LNrMY3PdiIXrG7Ku8svSMWflEzeTj+ENwRoyrfUM+AuNPJJIs1vHSqi6JoGj5Ysk=
X-Received: by 2002:a2e:a607:0:b0:37a:4e47:915b with SMTP id
 38308e7fff4ca-37a7334412emr667921fa.48.1762453308554; Thu, 06 Nov 2025
 10:21:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251106011330.75571-1-seanjc@google.com>
In-Reply-To: <20251106011330.75571-1-seanjc@google.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Thu, 6 Nov 2025 19:21:35 +0100
X-Gm-Features: AWmQ_bnyEkW1gPb2ZC8cWbijU12uJDKPE2JAIp1UJKq9oVwCIxM8w0lBgehtRY0
Message-ID: <CAFULd4Z=PKeyzaER51CE7Zm4a-yeiru=HcBFx8E4J5hx3io=Tw@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Ensure SPEC_CTRL[63:32] is context switched
 between guest and host
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 2:13=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> From: Uros Bizjak <ubizjak@gmail.com>
>
> SPEC_CTRL is an MSR, i.e. a 64-bit value, but the VMRUN assembly code
> assumes bits 63:32 are always zero.  The bug is _currently_ benign becaus=
e
> neither KVM nor the kernel support setting any of bits 63:32, but it's
> still a bug that needs to be fixed.
>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/vmenter.S | 44 +++++++++++++++++++++++++++++++-------
>  1 file changed, 36 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
> index 235c4af6b692..53f45f5b611f 100644
> --- a/arch/x86/kvm/svm/vmenter.S
> +++ b/arch/x86/kvm/svm/vmenter.S
> @@ -52,11 +52,23 @@
>          * there must not be any returns or indirect branches between thi=
s code
>          * and vmentry.
>          */
> -       movl SVM_spec_ctrl(%_ASM_DI), %eax
> -       cmp PER_CPU_VAR(x86_spec_ctrl_current), %eax
> +#ifdef CONFIG_X86_64
> +       mov SVM_spec_ctrl(%rdi), %rdx
> +       cmp PER_CPU_VAR(x86_spec_ctrl_current), %rdx
>         je 801b
> +       movl %edx, %eax
> +       shr $32, %rdx
> +#else
> +       mov SVM_spec_ctrl(%edi), %eax
> +       mov PER_CPU_VAR(x86_spec_ctrl_current), %ecx
> +       xor %eax, %ecx
> +       mov SVM_spec_ctrl + 4(%edi), %edx
> +       mov PER_CPU_VAR(x86_spec_ctrl_current + 4), %esi
> +       xor %edx, %esi
> +       or %esi, %ecx
> +       je 801b
> +#endif
>         mov $MSR_IA32_SPEC_CTRL, %ecx
> -       xor %edx, %edx
>         wrmsr
>         jmp 801b
>  .endm
> @@ -81,13 +93,26 @@
>         jnz 998f
>         rdmsr
>         movl %eax, SVM_spec_ctrl(%_ASM_DI)
> +       movl %edx, SVM_spec_ctrl + 4(%_ASM_DI)
>  998:
> -
>         /* Now restore the host value of the MSR if different from the gu=
est's.  */
> -       movl PER_CPU_VAR(x86_spec_ctrl_current), %eax
> -       cmp SVM_spec_ctrl(%_ASM_DI), %eax
> +#ifdef CONFIG_X86_64
> +       mov SVM_spec_ctrl(%rdi), %rdx
> +       cmp PER_CPU_VAR(x86_spec_ctrl_current), %rdx
>         je 901b
> -       xor %edx, %edx
> +       mov PER_CPU_VAR(x86_spec_ctrl_current), %rdx
> +       movl %edx, %eax
> +       shr $32, %rdx

The above code can be written as:

mov PER_CPU_VAR(x86_spec_ctrl_current), %rdx
cmp SVM_spec_ctrl(%rdi), %rdx
je 901b
movl %edx, %eax
shr $32, %rdx

The improved code will save a memory read from x86_spec_ctrl_current.

> +#else
> +       mov SVM_spec_ctrl(%edi), %esi
> +       mov PER_CPU_VAR(x86_spec_ctrl_current), %eax

Can the above two instructions be swapped, just to be consistent with
x86_64 code?

> +       xor %eax, %esi

> +       mov SVM_spec_ctrl + 4(%edi), %edi
> +       mov PER_CPU_VAR(x86_spec_ctrl_current + 4), %edx

... and the above two insns.

Uros.

