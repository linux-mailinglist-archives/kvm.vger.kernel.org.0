Return-Path: <kvm+bounces-34117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E08879F75F3
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 08:43:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41CAF16A576
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 07:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17191217737;
	Thu, 19 Dec 2024 07:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="FvG3M106"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F6E21770F
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 07:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734594107; cv=none; b=Nn+PorZSVk5X/Hbd8bCEHqoFnHS9/3fRjsJPE8Gw5Z0hV+F5KM0yxQfNUYXm0N6uOWrTIjwgs9luncabnR0a+qwsewNMnxTu270lR+rFP5MkK/Y9o4hfGTlPjsJbiNOgl9SCJdhLrxWxJWxhq42e7bxP0Q5KKRbd10fuN5Bb5eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734594107; c=relaxed/simple;
	bh=p3APS2WYRSj7CCXXVqgW/wsCliIqS2BoeufRUX/3xng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U7Es9TuvQ6faJKnMs4JFw8p97XPrktatuqo1RRO6hCN8fKTeRUAq/BD2yiJsLjS/+IDkrLbqdXhpTGLUR0oOKoHeSBqzhSVHBPKVADNbrgq+rGhvXFsBMHee84o8Mku5dM5oEmj8u/G3AwgGFu3ageFd/oXjNlP+bYxmvcsstLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=FvG3M106; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a9628d20f0so3570515ab.2
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 23:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1734594104; x=1735198904; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CK6PFnM/cYjzOszuWhFFBsrj9dfFgVZgNhYUrThAqWc=;
        b=FvG3M106qeNCqqR07mYUAW8zCghgykO4yrntEvdqrAO5zodqJzeFTPmae1Z3QbaYDE
         DEEolWgmcPTU3LlD3yv5zsqubosgINQnoky1VSDwQr+JiDiAI6fbnRt8ubHECkUiTZDc
         KtIsEW4jOz2DpKXAWDnNU/aMV1rviYgXMOzzOA6/PakjhanZeFkzApy5bbJ459HSrY5Z
         En50oPKw9ir+8R8bsk9wmVEJC2jrR8N0wYqg58AnMLsWarbRrG6GDBjCyOS71KYavE6+
         WU4g7BPAJSKx29ZRajj0g+Ke76AmKrrTA5bbR1DkewfI+0oMvpnymMsf6hOIO6HxuCN5
         NVzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734594104; x=1735198904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CK6PFnM/cYjzOszuWhFFBsrj9dfFgVZgNhYUrThAqWc=;
        b=bfyitugmXaUYzAbKwmK3OeK0sdESJhjRxCZXS0cJfiqSbTR9CqFrdE6H5xOph2th6Y
         a9L3DJ0fcNBXhe4Hhypy6XPFli0WlPPtfRKeQgBCojnoMT97XczB/2rsRCj35H8Bajm4
         oSiPGfpcMNYhb1jmLdpzZIzVAM/h+GFJetUCN7ReAkmN//BE2j6dJV0JaaNW9TTbllMz
         SSLLFSC6hg6e5rK8vTFDqYwnMhlcNBwmErqdmWLLM8k0R1epmQPGjqlFpjsrwlEiOtvS
         YPEFKIcjeYBNQzWxVa8Km0ehsJt37ASbJefWvBjRJyLFs77qGtJTVGDyANPfF7hsttaW
         +3wQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0KFu4YNbHcfi8lmyfJcLaRPIfaRhwSA+YbptH/a3wczUMvNPO1cSMNKdYRlKk25bsVrQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsZI2WobLkndrtLgRHyP3MYZVQ34RnI90X007obtCpxkjcfeSR
	4xvfpxrf6G0sS05NXXsVVOt0CJI5lk88pV6LuEARVOdItulyPxxD6VXaxWLLsks9pwMFZeratZ9
	mXPEHdfVwztkCpG+O7EZKkKSrTNNdEI6iM1WINw==
X-Gm-Gg: ASbGncurImOIOVeyAI3x06Avnf8L4HRDQHVXM5CtC2kIlM4pvh7NIRpG7fkH8t9BGJ8
	jzn5hKyRjZ1MTVRlVl+KcYLeYdwWOZj2GekN/1WeN
X-Google-Smtp-Source: AGHT+IGbPuySSmr1CwdOHQeWubrx1MyyRpnBfYc/XwwbMxEmLghw7Vo34EZotbYZAeerVNV2zRCMld34Fd/Fk/tzQY0=
X-Received: by 2002:a05:6e02:158b:b0:3a7:e286:a565 with SMTP id
 e9e14a558f8ab-3c0148947f4mr29393365ab.23.1734594104509; Wed, 18 Dec 2024
 23:41:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240619153913.867263-1-cleger@rivosinc.com> <20240619153913.867263-5-cleger@rivosinc.com>
In-Reply-To: <20240619153913.867263-5-cleger@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 19 Dec 2024 13:11:32 +0530
X-Gm-Features: AbW1kvbl_nOMADXonpsf4A_tmW9qHfMUPG4EJdNLYs-eLb1hX0IfloBaKeSVqO4
Message-ID: <CAAhSdy09SnHMoX0nanLOv_7TBt3T_xX_e6a5UX_NeZdLN7touQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] RISC-V: KVM: Allow Zaamo/Zalrsc extensions for Guest/VM
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Shuah Khan <shuah@kernel.org>, 
	Atish Patra <atishp@atishpatra.org>, linux-doc@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2024 at 9:11=E2=80=AFPM Cl=C3=A9ment L=C3=A9ger <cleger@riv=
osinc.com> wrote:
>
> Extend the KVM ISA extension ONE_REG interface to allow KVM user space
> to detect and enable Zaamo/Zalrsc extensions for Guest/VM.
>
> Signed-off-by: Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/uapi/asm/kvm.h | 2 ++
>  arch/riscv/kvm/vcpu_onereg.c      | 4 ++++
>  2 files changed, 6 insertions(+)
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index a6215634df7c..f10c6e133d4d 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -174,6 +174,8 @@ enum KVM_RISCV_ISA_EXT_ID {
>         KVM_RISCV_ISA_EXT_ZCD,
>         KVM_RISCV_ISA_EXT_ZCF,
>         KVM_RISCV_ISA_EXT_ZCMOP,
> +       KVM_RISCV_ISA_EXT_ZAAMO,
> +       KVM_RISCV_ISA_EXT_ZALRSC,
>         KVM_RISCV_ISA_EXT_MAX,
>  };
>
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index fa5ee544bc69..0972a997beca 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -41,7 +41,9 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
>         KVM_ISA_EXT_ARR(SVINVAL),
>         KVM_ISA_EXT_ARR(SVNAPOT),
>         KVM_ISA_EXT_ARR(SVPBMT),
> +       KVM_ISA_EXT_ARR(ZAAMO),
>         KVM_ISA_EXT_ARR(ZACAS),
> +       KVM_ISA_EXT_ARR(ZALRSC),
>         KVM_ISA_EXT_ARR(ZBA),
>         KVM_ISA_EXT_ARR(ZBB),
>         KVM_ISA_EXT_ARR(ZBC),
> @@ -131,7 +133,9 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsign=
ed long ext)
>         case KVM_RISCV_ISA_EXT_SSTC:
>         case KVM_RISCV_ISA_EXT_SVINVAL:
>         case KVM_RISCV_ISA_EXT_SVNAPOT:
> +       case KVM_RISCV_ISA_EXT_ZAAMO:
>         case KVM_RISCV_ISA_EXT_ZACAS:
> +       case KVM_RISCV_ISA_EXT_ZALRSC:
>         case KVM_RISCV_ISA_EXT_ZBA:
>         case KVM_RISCV_ISA_EXT_ZBB:
>         case KVM_RISCV_ISA_EXT_ZBC:
> --
> 2.45.2
>

