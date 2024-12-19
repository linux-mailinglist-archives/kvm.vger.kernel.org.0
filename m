Return-Path: <kvm+bounces-34118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AB219F75F9
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 08:44:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29201188E801
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 07:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C03217708;
	Thu, 19 Dec 2024 07:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Zyim+WEM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527C314E2CF
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 07:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734594193; cv=none; b=UHFKOLvxJyzVX9jM4INKZFI5xfBi/fS1lIJoPUhNBbrM8JHMYAs06swA25tk9/Hb53QSvSZ833xIQ5V8f4zmuEHcQZ4sSSydaSptM6XHMUeOapIOriUTkqW6pXhsCQ4iVRViKWcdZPyJdnuiav9RaeMgyEGMb8QLNtrTNl6ufb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734594193; c=relaxed/simple;
	bh=VacssBPVArSm6k/3qDdJeMgOVxZskDxHg9GeKEaHoMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oVjcRgngc0Zz5ZyiqxkXhgShe6j+tG/jTFM+8o5HDSE8P28jYh1y32AsHiAp2N0tJ7HIyfzvYeUhiJOorHTTzpox2940QlWnrCjdBHv0brE3NsUmTWapWUBPpd6TlMWPUXG8pMSu6unoomgamNA9DnSlbXk3+e+hf/N2nPeF2cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Zyim+WEM; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-844dfe4b136so16642039f.3
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 23:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1734594190; x=1735198990; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1OBSLf6ezAUOBKlVMuu5hWXIY5CF9SG01M/FkrWs7IM=;
        b=Zyim+WEMchFZGGrpuToBRvAytqNVClL3yfQTYorWO4lzImaVWSi+8UPvCCiGmbAPyf
         G16lhJJwX69bv2Tusc72pZy6CesbIHzKU8R018QIvK3fGQhKscDkUHSTBApR6qzAoW1v
         FyWqyAAyufgIbouyh5li6QqWXULL8HB4xegx8rsFlgq3MkBHBPpAH+nrQzCYHble5U+C
         e/6TEqwu5Iz2iTeOaKSI/rdsBTSD9rFjL0ZBz5zTlCGHxakOwShPfwikE+RTwa5GAebT
         xidQqdGQ/r6PFBeAOW0z/s02HZt8KmXEuv4rVcmGcjjBlFgEvR985uAaab27I335ZxQd
         Y8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734594190; x=1735198990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1OBSLf6ezAUOBKlVMuu5hWXIY5CF9SG01M/FkrWs7IM=;
        b=twO4gRUuQydrt+oxYTA2yHDZzWo2hCLUpR9RHisr5K1bE1t3i4NIJRBeu5ddvtW7cs
         4NIpqK4+YfO1Drp2i/CEcCcaBkjDGta/jwPhO4MzebELubQv6gXvBQFQi9jlU9dsJLvH
         PLYLEpRndlk4KT1bM8xBP1yrv//mjoSo81yYfxd0Phb7aFkMUnZPAHUB3Ccp4Qyw7jp3
         +GV+m1emT8CJEqooFtXGa1aeFKHTQzjEAwIx62Ex4H6zjKwEpn6nAyh0VCRPmKkw7C/7
         ZXkO48hROZC3IWiN5FdiygFUDXjSwLQaA+aJbNHGM4aG3qIDTvDyWIlqcRhjQ9rkmaVC
         C2BA==
X-Forwarded-Encrypted: i=1; AJvYcCVsQ4LzkC0CEHTDpdkEYXjziiMbjBWBaQ4qtXwdLUHt3q1Z2F1UCH8DsJvuj2kYZww7+kg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ6+qBmV8YJmbSSsEXoOteqvn5cyQTOevTPcSylSVBK60bru/W
	5p9DYbJlqBTur8TrXfoIASSlEny44T1+Pi28cA3qxzFsFnTYX06V54QBL7xSgmjfjg8N5iK8dTV
	ErRRXGGi1w7aQ20W3ZqbFgHnotR+fQjlXbtbWvA==
X-Gm-Gg: ASbGnct50vrGrX05zCKyQd4V6A9gZFpJ1iuYj7/kDM32egMQBANDD1aO8WOJqGb6WMk
	VjU/MWlr2wY0YIjd8jDTf33eGhilyg8OM+j1+spYZ
X-Google-Smtp-Source: AGHT+IEYkbHFgP7rWEbUL4gJw6AmdAq+2B/xjkc5BL4zM4osboITpF6FofLzy/cYgFT9HyU3ZxpxXw1GxTtEEJ9scZ0=
X-Received: by 2002:a05:6e02:160a:b0:3a7:e86a:e80f with SMTP id
 e9e14a558f8ab-3bdc003ea26mr62053815ab.3.1734594190381; Wed, 18 Dec 2024
 23:43:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240619153913.867263-1-cleger@rivosinc.com> <20240619153913.867263-6-cleger@rivosinc.com>
In-Reply-To: <20240619153913.867263-6-cleger@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 19 Dec 2024 13:12:58 +0530
X-Gm-Features: AbW1kvZ_WXwEDbsqmAKgoCiT1ZSWNjyowoJciFKcgfWXJoYFYtMyuYjF6-4g-mE
Message-ID: <CAAhSdy3gYPa82zj+fAXtkDvJuKXoWBNj5Mx+XjHXkn=a2c__ig@mail.gmail.com>
Subject: Re: [PATCH 5/5] KVM: riscv: selftests: Add Zaamo/Zalrsc extensions to
 get-reg-list test
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
> The KVM RISC-V allows Zaamo/Zalrsc extensions for Guest/VM so add these
> extensions to get-reg-list test.
>
> Signed-off-by: Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/tes=
ting/selftests/kvm/riscv/get-reg-list.c
> index 1a5637a6ea1e..70216a1760c3 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -48,7 +48,9 @@ bool filter_reg(__u64 reg)
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_SVINVAL:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_SVNAPOT:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_SVPBMT:
> +       case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZAAMO:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZACAS:
> +       case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZALRSC:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZBA:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZBB:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZBC:
> @@ -420,7 +422,9 @@ static const char *isa_ext_single_id_to_str(__u64 reg=
_off)
>                 KVM_ISA_EXT_ARR(SVINVAL),
>                 KVM_ISA_EXT_ARR(SVNAPOT),
>                 KVM_ISA_EXT_ARR(SVPBMT),
> +               KVM_ISA_EXT_ARR(ZAAMO),
>                 KVM_ISA_EXT_ARR(ZACAS),
> +               KVM_ISA_EXT_ARR(ZALRSC),
>                 KVM_ISA_EXT_ARR(ZBA),
>                 KVM_ISA_EXT_ARR(ZBB),
>                 KVM_ISA_EXT_ARR(ZBC),
> @@ -950,7 +954,9 @@ KVM_ISA_EXT_SIMPLE_CONFIG(sstc, SSTC);
>  KVM_ISA_EXT_SIMPLE_CONFIG(svinval, SVINVAL);
>  KVM_ISA_EXT_SIMPLE_CONFIG(svnapot, SVNAPOT);
>  KVM_ISA_EXT_SIMPLE_CONFIG(svpbmt, SVPBMT);
> +KVM_ISA_EXT_SIMPLE_CONFIG(zaamo, ZAAMO);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zacas, ZACAS);
> +KVM_ISA_EXT_SIMPLE_CONFIG(zalrsc, ZALRSC);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zba, ZBA);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zbb, ZBB);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zbc, ZBC);
> @@ -1012,7 +1018,9 @@ struct vcpu_reg_list *vcpu_configs[] =3D {
>         &config_svinval,
>         &config_svnapot,
>         &config_svpbmt,
> +       &config_zaamo,
>         &config_zacas,
> +       &config_zalrsc,
>         &config_zba,
>         &config_zbb,
>         &config_zbc,
> --
> 2.45.2
>

