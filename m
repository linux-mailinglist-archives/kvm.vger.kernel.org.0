Return-Path: <kvm+bounces-29664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 842D19AF28C
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 21:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A862C1C2415E
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 19:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05411216A35;
	Thu, 24 Oct 2024 19:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="lA5AKoUJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF3C1FC7FE
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 19:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729797427; cv=none; b=XvCwNLGfZpKBoyeVpV2kpNKOdGpoUghlhSO90y7LqOxnTkY2WIeJfTjCNK0/cXadMq0J3qYG3KHyTzqmGm3KiH/O2E+wOx6zNj8AJIBwwqQaHfdVwW089vWSt+kM7xUccLSMU/D5Rr0c1bXfqWX8bcdA7tEINrU1GFtcc+heru0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729797427; c=relaxed/simple;
	bh=r2894LsRaL5cMjTp9c/aiq8WNR9qa3a0tHFbx9n/VDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LuPI64S6zmo2TMITYMqXTJ1Ynt0LEJtJJwKp+WSjg7P9uZQGYWSmd2TXIEE45yIBuE1AiIo/EHr0JwjTToKuKdxEYi0fV2gIoa57fmN1lwnUFWqNacUcBbr4QSb5pYaOermppzhp++M2NOzkAkblBl7vEEI2zjNnpo2cusNQrIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=lA5AKoUJ; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-83aba237c03so48696039f.3
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 12:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1729797423; x=1730402223; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aMVuNP7DptisRZKMAE62XcZxOQ0ITSLxzIbBe9rphWg=;
        b=lA5AKoUJX5NIwwmgwcPO0LlAnXNw+nDr5zN62GyzVprCGtCgDWXcbL3wbZKSmd/cKV
         q2tkl2+WVcFz036R8T2JRNiF0UTJJy+n5Mvbe9+HwpJCpIogtQuHGpNUcl17ct5wRC+b
         q78WEjVrXTskIjfLoqRXO6mn+aGGaQRckOft+v7EXhfs4hO7youWj1ySdz7r0bMyQ1x6
         3aHrdfL7wgFFuc6ng37zi9seTtXpUdckqOCFGHjDe5kbErGaXluSWILmwojRuMN2z18E
         N9GcNvBFxFa7W6lczd6JavYcSyxkBkKEK8GzFWAgXzfb4O28HsugSwfaH0XnL74SxTEU
         LNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729797423; x=1730402223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aMVuNP7DptisRZKMAE62XcZxOQ0ITSLxzIbBe9rphWg=;
        b=g7WpvK2rfjcR2JTQezwi5QjyvYUEHlxE+HLMndcM6usDIgnEOpP3azpUmZ8qZrL+C4
         DzS3hOZ5dJw+0asy6e72y/46X65IaTzZ4fACxZlHfwccc0GBZEkhLnzr3+PEMI0lsLnx
         uEyiF7JsApa7+1v6n2UpX/Y8ctVR5vOWO6gxxwvAf1pzFQZwmgkF+zevwVOfTKkRODnZ
         SpuKXlYFG5g8CCqNKJSNXhC9FHroN6+zQrft/U96C0WJubrS+YO2PY6D7yGF13lMIJha
         0SLX34FOJDG79ivXJqbbPrCk+rPH0HL5qdjk6lHSCIgoGz8jGZMxYnrc02XSj8cZMVgR
         xBWg==
X-Forwarded-Encrypted: i=1; AJvYcCVwxSc78DwhPFrP/YY3Qn7xxhK329rjNtVjfmCyXLOo0upgrqY1EZgbh6R8pnWqa8aI3R0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8I8PyRCj6kpAat9c/Qb8GCNZDt8tecfcT8y9SSvQxP+F8BrOn
	EmWAaCXhN5C0yXzu6j3P+VwM0ZT2ZPKd2WIqpPdkOeA/GtXtPd0xjWazCXyUmUn8SiclWXJ6HEE
	CxDIsCgOs3IGvhgE6lVagE0TUk7MRMTInX1TKCg==
X-Google-Smtp-Source: AGHT+IFZzEb2zN7h96lApR8DYauv53XlH5oPpoX1QtB4zj0x/HOggQdCeZlKWS+cP9VVlhcXp5Qae/4W4hrCmVnyZps=
X-Received: by 2002:a05:6e02:1564:b0:3a0:c15f:7577 with SMTP id
 e9e14a558f8ab-3a4d5945f99mr81465345ab.9.1729797423093; Thu, 24 Oct 2024
 12:17:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240927-dev-maxh-svukte-rebase-2-v2-0-9afe57c33aee@sifive.com> <20240927-dev-maxh-svukte-rebase-2-v2-3-9afe57c33aee@sifive.com>
In-Reply-To: <20240927-dev-maxh-svukte-rebase-2-v2-3-9afe57c33aee@sifive.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 25 Oct 2024 00:46:51 +0530
Message-ID: <CAAhSdy0ncLTAjEE1s-GWL95sscxwQFsKn1rXyA1_VVfk1bQBiw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/3] riscv: KVM: Add Svukte extension support for Guest/VM
To: Max Hsu <max.hsu@sifive.com>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Atish Patra <atishp@atishpatra.org>, Palmer Dabbelt <palmer@sifive.com>, 
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, Samuel Holland <samuel.holland@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2024 at 7:12=E2=80=AFPM Max Hsu <max.hsu@sifive.com> wrote:
>
> Add KVM ISA extension ONE_REG interface to allow VMM tools to
> detect and enable Svukte extension for Guest/VM.
>
> Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
> Signed-off-by: Max Hsu <max.hsu@sifive.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu_onereg.c      | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index e97db3296456e19f79ca02e4c4f70ae1b4abb48b..41b466b7ffaec421e8389d3f5=
b178580091a2c98 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -175,6 +175,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>         KVM_RISCV_ISA_EXT_ZCF,
>         KVM_RISCV_ISA_EXT_ZCMOP,
>         KVM_RISCV_ISA_EXT_ZAWRS,
> +       KVM_RISCV_ISA_EXT_SVUKTE,
>         KVM_RISCV_ISA_EXT_MAX,
>  };
>
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index b319c4c13c54ce22d2a7552f4c9f256a0c50780e..67237d6e53882a9fcd2cf265a=
a1704f25cc4a701 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -41,6 +41,7 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
>         KVM_ISA_EXT_ARR(SVINVAL),
>         KVM_ISA_EXT_ARR(SVNAPOT),
>         KVM_ISA_EXT_ARR(SVPBMT),
> +       KVM_ISA_EXT_ARR(SVUKTE),
>         KVM_ISA_EXT_ARR(ZACAS),
>         KVM_ISA_EXT_ARR(ZAWRS),
>         KVM_ISA_EXT_ARR(ZBA),

The KVM_RISCV_ISA_EXT_SVUKTE should be added to the
switch-case in kvm_riscv_vcpu_isa_disable_allowed() because
hypervisor seems to have no way to disable Svukte for the Guest
when it's available on the Host.

Regards,
Anup

