Return-Path: <kvm+bounces-17636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 151098C892C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:18:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0A721F276B1
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 15:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B31B12DD8C;
	Fri, 17 May 2024 15:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="GWSAlyKD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4925512D743
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 15:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715959087; cv=none; b=nmifweDc66cpGcQWvo4I7j9bXlEnCREDlgMnxyltQzIAsmio33o5s1W7P5iAI51g+mYMsZpmBTCYY3v2nGMgZx3ff3FC2nJFF+PoIOJ7mRT5uGswrueX6Q9EEtmUMMBgsmA5iPo4mpwb8RpMEYr4gFzPUZAICY6pu8CNIPk377Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715959087; c=relaxed/simple;
	bh=VJJtaa3CR6YMvRWAqyg1KE5Ku5S+20oB3+0+lzQy9oI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WcOO8IGARSn2hPLcC1h4Lskbe3atqY03cnYkKZVCRF4hARszyQP1++6gqh9UL4FjnIBSOH5wLkkGUSro+lf9iJ52q8kaol+6qCD4eadVBr/SRk9+EuWovibz0E7VptHw2oYam1Bkn2Sdo1YEH2C0r/kUhrqZgZYhk1LZ1+bMaF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=GWSAlyKD; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-36c791e9faaso8179955ab.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 08:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1715959084; x=1716563884; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ef3MF8Rs0G3jit24HO3OWy+0DrrgzGDkN37Y+6PEB9I=;
        b=GWSAlyKDzSG/8Lva7AJJemLNxl1/rCKHYRbWzGVGo9u7VdJpzWumg1j6poS3CiCY+h
         Q/vYwL571bEeuIVHMbZUi7rZgeanWwpDfcNQqZWTvE8BU9jQA47+CZoZS3a6she498eT
         mmziej6OAzT0RMLi1XR6sWSe5ECSxo3POPkaFGDb0VkDutbZAxpa98GZ9dfmCG+oyGWA
         acVgxrrCmxIfOMfBd4ua52CwZ2R/XdZHnv+WOrH1xtKuXIIfUXWdR7Zc7tK13EwuXW28
         cEX4iyzGoB4JpcpEa2YQ2E1/cW9e/xsWDm0ki1JlmtvkF3n3j5rYpahRiKWC+usOR2HB
         OXeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715959084; x=1716563884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ef3MF8Rs0G3jit24HO3OWy+0DrrgzGDkN37Y+6PEB9I=;
        b=EDU2YOMW60Pge8zvYTzNYUMRIEqRntFxv9Wv0pOYdh6yvJ0c5mmVuuDhGSooHyryIj
         mhMpmJO/VPnvzNMgzQsxUW5pAHeEFz3O94KbI3keL7jDN+hLAPqY0Ism59ZYHVq3tRE6
         s4JODnW5zyxKnREEjawyAx9e/NrOEzr5IAsnLUvLOiZj+yY5H5tgq/oDdeK4aq97H/0O
         u5+n0eJJxBqphHYck6vgT3v8TG7Q9yS52xhnkVvBNbO/9V7lm3LbyQNdQ9zuWRUxATn5
         Sjc0JvIpQVawazuy2U9gwzjoa4Ut8h8isXQvQCvERvAUld2kfTakcAaoDXp8ofG6wpax
         Mz/A==
X-Forwarded-Encrypted: i=1; AJvYcCURWlN4Z5/luhmp0avTyDraH0GQraAhslnLocrSaw2e50cAHW+j0C9PGiBNkMQlx9GiqUalAQml4EPK1xIJ2kYZMWNa
X-Gm-Message-State: AOJu0Yxtr0g86roZZoZ9FXhrzNUhKQ9MaW0qlWzUmfl6tOi+GEeXwZfm
	EPgN82taMhBtAKzFrkvydKepqI3cSHc+aDdt/SC91f152IcGxSFGQLmvfYtkQanoW30KVzG/XX3
	JXs+4IzO5+n8ReICjQIpfcKzgolDG+XePAfJa2A==
X-Google-Smtp-Source: AGHT+IHuY13zH4hhNjNUU8E5CU5OnLiqg38O1otrjb+/eoZzOjdRjWwMMh69eiDOSrh7CQUbUVho6c8rmZEAihhoEvk=
X-Received: by 2002:a05:6e02:1886:b0:36a:1725:e123 with SMTP id
 e9e14a558f8ab-36cc14913bfmr268024205ab.14.1715959084494; Fri, 17 May 2024
 08:18:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240517145302.971019-1-cleger@rivosinc.com> <20240517145302.971019-5-cleger@rivosinc.com>
In-Reply-To: <20240517145302.971019-5-cleger@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 17 May 2024 20:47:51 +0530
Message-ID: <CAAhSdy0Ft5KV5ABBPNjxhy71jY0ypF7S6vhrb7gfq892WQkv1w@mail.gmail.com>
Subject: Re: [PATCH v5 04/16] RISC-V: KVM: Allow Zimop extension for Guest/VM
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

On Fri, May 17, 2024 at 8:23=E2=80=AFPM Cl=C3=A9ment L=C3=A9ger <cleger@riv=
osinc.com> wrote:
>
> Extend the KVM ISA extension ONE_REG interface to allow KVM user space
> to detect and enable Zimop extension for Guest/VM.
>
> Signed-off-by: Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu_onereg.c      | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index b1c503c2959c..35a12aa1953e 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -167,6 +167,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>         KVM_RISCV_ISA_EXT_ZFA,
>         KVM_RISCV_ISA_EXT_ZTSO,
>         KVM_RISCV_ISA_EXT_ZACAS,
> +       KVM_RISCV_ISA_EXT_ZIMOP,
>         KVM_RISCV_ISA_EXT_MAX,
>  };
>
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index f4a6124d25c9..c6ee763422f2 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -60,6 +60,7 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
>         KVM_ISA_EXT_ARR(ZIHINTNTL),
>         KVM_ISA_EXT_ARR(ZIHINTPAUSE),
>         KVM_ISA_EXT_ARR(ZIHPM),
> +       KVM_ISA_EXT_ARR(ZIMOP),
>         KVM_ISA_EXT_ARR(ZKND),
>         KVM_ISA_EXT_ARR(ZKNE),
>         KVM_ISA_EXT_ARR(ZKNH),
> @@ -137,6 +138,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsign=
ed long ext)
>         case KVM_RISCV_ISA_EXT_ZIHINTNTL:
>         case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
>         case KVM_RISCV_ISA_EXT_ZIHPM:
> +       case KVM_RISCV_ISA_EXT_ZIMOP:
>         case KVM_RISCV_ISA_EXT_ZKND:
>         case KVM_RISCV_ISA_EXT_ZKNE:
>         case KVM_RISCV_ISA_EXT_ZKNH:
> --
> 2.43.0
>

