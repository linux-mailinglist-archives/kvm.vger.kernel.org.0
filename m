Return-Path: <kvm+bounces-60527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B457BF19D6
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 15:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 162CA3E5DFE
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 13:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE55322C99;
	Mon, 20 Oct 2025 13:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utbIxzKu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1AB31283D
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 13:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760968026; cv=none; b=mRWb1212WrBhe4NTE4ETMAmWY8Vph+A+U/0D/5h6g/Q0b6W/7dpOypAK9mpPE4BKELXwHED05NB52Gt2Ku/c88EcG3fOlt7mHyNIjCdVF82Z7/OwlT5mCAuciPIfGCk7hkl9QyL8nIHepi2dVxa1w0B3A0l3f0b0Yk8gEtCi/HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760968026; c=relaxed/simple;
	bh=ANgSQSPVOIlXoVYbP+I9m5tJ0ZaaqeZGLzdTf42qYbc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JWAh81ciIZbUzFJQZnMZvfdEOAXC68HAlVB3JdwPV28DUCxYC977YhMPmBYd2PwBYAT3jur8sBRUvsH2B9B7ueyuzgGQDCBhFoBSW57qlUZTYdpetjocEVK1xhcJ3OHZCpfN/o2DHNlqo5R58ZAtQh0LV7qp+gG3dGEXCOV/lA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utbIxzKu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D77C16AAE
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 13:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760968025;
	bh=ANgSQSPVOIlXoVYbP+I9m5tJ0ZaaqeZGLzdTf42qYbc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=utbIxzKux3b0QATbi6AkVyu9dOEgO1OONInR4KT3ACgSQwAmacc+tilNBGUc7H22A
	 EOQyZSEOZ0adF+89jAcuCerzqHVodcMcWMRZez7e21WpjNfBTf9XB7izFL0HvA7Gh9
	 JyVIYa9GqKuszXWpwRoXNd/veyNP7dT/whw0gt9pcA9j2ztjlxD2D5z1dEUitSmwUG
	 +r1Oh8UxV9EuGbn1Phr/6RolewlJeI4JhVqgRT4YsiDkNlfXUCMoFzP6src5IUxJ4p
	 WiWdFeFnWbuGXGip3B5qDT3zdyHnhXdzWkWnpxfO56pox5lB6lX+Ol59MFzy7p8ctQ
	 xIZMfbQV74pdg==
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-471b80b994bso23533415e9.3
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 06:47:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXnzUd5L/MWN4IlI4pl+Gl7F4KFwjbGWtTXHS/c0y17Zc0l/7yFfzhRqQXuLVXw3CvbQ2E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw1QzWpIzo/LquZnqecbUo2ZpZFfUb6MYmAKXjNCxxp2xprq2e
	Acv3VJpESU5XCKdRvBThIrDoCEDzNEnqjdUyIw0Wn+yBouJu81G3KKjb7pGpjAL8zGK6lR0KFkR
	IstmPheRo2xajcWGUyxku3NqaaQUXlVI=
X-Google-Smtp-Source: AGHT+IGpvHBGOazwRpML7L6p+OasmV1SnRg6q1qXry12cbpNN8zhS8TFOb5uYraKUxj/eNcIvfi0sxzsmTyVox3z8JY=
X-Received: by 2002:a05:600c:3b0c:b0:471:669:ec1f with SMTP id
 5b1f17b1804b1-471178785e1mr97856905e9.8.1760968024377; Mon, 20 Oct 2025
 06:47:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251020042056.30283-1-luxu.kernel@bytedance.com> <20251020042056.30283-4-luxu.kernel@bytedance.com>
In-Reply-To: <20251020042056.30283-4-luxu.kernel@bytedance.com>
From: Guo Ren <guoren@kernel.org>
Date: Mon, 20 Oct 2025 21:46:51 +0800
X-Gmail-Original-Message-ID: <CAJF2gTREY07Eo0EgB9ew1sd6FkMtoFSTgyC5ny2SQKKd83xEtw@mail.gmail.com>
X-Gm-Features: AS18NWDSEQv09h9pIrv_Q1ibVOSy0wdkcUShHmZExEFgCajrR16Dgx95ctdgozI
Message-ID: <CAJF2gTREY07Eo0EgB9ew1sd6FkMtoFSTgyC5ny2SQKKd83xEtw@mail.gmail.com>
Subject: Re: [PATCH v4 03/10] riscv: hwprobe: Export Zalasr extension
To: Xu Lu <luxu.kernel@bytedance.com>
Cc: corbet@lwn.net, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, robh@kernel.org, krzk+dt@kernel.org, 
	conor+dt@kernel.org, will@kernel.org, peterz@infradead.org, 
	boqun.feng@gmail.com, mark.rutland@arm.com, anup@brainfault.org, 
	atish.patra@linux.dev, pbonzini@redhat.com, shuah@kernel.org, 
	parri.andrea@gmail.com, ajones@ventanamicro.com, brs@rivosinc.com, 
	linux-doc@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	apw@canonical.com, joe@perches.com, lukas.bulwahn@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2025 at 12:21=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com> =
wrote:
>
> Export the Zalasr extension to userspace using hwprobe.
>
> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> ---
>  Documentation/arch/riscv/hwprobe.rst  | 5 ++++-
>  arch/riscv/include/uapi/asm/hwprobe.h | 1 +
>  arch/riscv/kernel/sys_hwprobe.c       | 1 +
>  3 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/arch/riscv/hwprobe.rst b/Documentation/arch/ri=
scv/hwprobe.rst
> index 2aa9be272d5de..067a3595fb9d5 100644
> --- a/Documentation/arch/riscv/hwprobe.rst
> +++ b/Documentation/arch/riscv/hwprobe.rst
> @@ -249,6 +249,9 @@ The following keys are defined:
>         defined in the in the RISC-V ISA manual starting from commit e874=
12e621f1
>         ("integrate Zaamo and Zalrsc text (#1304)").
>
> +  * :c:macro:`RISCV_HWPROBE_EXT_ZALASR`: The Zalasr extension is support=
ed as
> +       frozen at commit 194f0094 ("Version 0.9 for freeze") of riscv-zal=
asr.
"Frozen Version 0.9" might not be proper; it denotes the current
temporary state, not the goal of the patch.

> +
>    * :c:macro:`RISCV_HWPROBE_EXT_ZALRSC`: The Zalrsc extension is support=
ed as
>         defined in the in the RISC-V ISA manual starting from commit e874=
12e621f1
>         ("integrate Zaamo and Zalrsc text (#1304)").
> @@ -360,4 +363,4 @@ The following keys are defined:
>
>      * :c:macro:`RISCV_HWPROBE_VENDOR_EXT_XSFVFWMACCQQQ`: The Xsfvfwmaccq=
qq
>          vendor extension is supported in version 1.0 of Matrix Multiply =
Accumulate
> -       Instruction Extensions Specification.
> \ No newline at end of file
> +       Instruction Extensions Specification.
> diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/u=
api/asm/hwprobe.h
> index aaf6ad9704993..d3a65f8ff7da4 100644
> --- a/arch/riscv/include/uapi/asm/hwprobe.h
> +++ b/arch/riscv/include/uapi/asm/hwprobe.h
> @@ -82,6 +82,7 @@ struct riscv_hwprobe {
>  #define                RISCV_HWPROBE_EXT_ZAAMO         (1ULL << 56)
>  #define                RISCV_HWPROBE_EXT_ZALRSC        (1ULL << 57)
>  #define                RISCV_HWPROBE_EXT_ZABHA         (1ULL << 58)
> +#define                RISCV_HWPROBE_EXT_ZALASR        (1ULL << 59)
>  #define RISCV_HWPROBE_KEY_CPUPERF_0    5
>  #define                RISCV_HWPROBE_MISALIGNED_UNKNOWN        (0 << 0)
>  #define                RISCV_HWPROBE_MISALIGNED_EMULATED       (1 << 0)
> diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwpr=
obe.c
> index 0b170e18a2beb..0529e692b1173 100644
> --- a/arch/riscv/kernel/sys_hwprobe.c
> +++ b/arch/riscv/kernel/sys_hwprobe.c
> @@ -99,6 +99,7 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair=
,
>                 EXT_KEY(ZAAMO);
>                 EXT_KEY(ZABHA);
>                 EXT_KEY(ZACAS);
> +               EXT_KEY(ZALASR);
>                 EXT_KEY(ZALRSC);
>                 EXT_KEY(ZAWRS);
>                 EXT_KEY(ZBA);
> --
> 2.20.1
>


--=20
Best Regards
 Guo Ren

