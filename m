Return-Path: <kvm+bounces-34652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AC39A035D8
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 04:29:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 984683A4C3D
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 03:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 150DC18A6C0;
	Tue,  7 Jan 2025 03:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N9EYy+vO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AD93596C;
	Tue,  7 Jan 2025 03:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736220531; cv=none; b=Cyt2c5r4q+m4zFDzaSv5KZNe1nuUWA96yjjucNALvZVmo7DE6AfU1d9f2dNauAtt1IoOxLhxOmgpq4zEk7C59UEjZAcTrQqQ9M9LgWT++UOYizrlJPJ6U+mbE7ZVgNQCTp+6lvZ+VvlmKI/qgHx9LVXAnPO6QhuXlBQtMdOtoBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736220531; c=relaxed/simple;
	bh=zmX26/Qlkcvk9h0aXmSNvA9uWEZeL/EvfQax0+q5hms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mCyOCYS9CrUPMv5WnhC4pr7t5m/fY+tTCJ5sUGwIpPKbN2vL5L6dmU5Bev3WpYcJvHhHDdZ4h/r1HbOhKWtyjJ1lDBJouSyIIoDd4THwsIvFt1YJXTYEH+kmd40rMT5lD0ksVSAxc1Y48SDgNzkRLMGzu2Lu03Hb4M2RNO4ZJC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N9EYy+vO; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4361dc6322fso100088835e9.3;
        Mon, 06 Jan 2025 19:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736220526; x=1736825326; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XfeJ0Lqr2Fv2aRpLh8hAwOkSjsGmGaPxw0MQXGL1VbE=;
        b=N9EYy+vOmlHmGYVwArScXoz0RnQQe0LpCdl6tVCDX9VG7T3dDj+ryMupVkcTdTeX1V
         SFDuFvZNryKcM6TdgJCJxdVFwbBpwVCUPRL0taHACCkxogghewkPXBMu/aJcoMJFy08A
         3OPDkxi6dlmPaFPMvXnHJSQbILrIs8WuC13YHOCDybhyO9aHr/VruIObdckcaSOMOBq2
         YF0Y06vef6GLkg6P35jsXUwzr03E8nUT/+IdT5YbEg41l8rGpD9pYrixHZ8YCQxezZP2
         ncslRbzCfl6xckNRMuuW4glq/6HQNWAinkzn0PDJZ2jc1SHkCDYhBNi49osa2HSTxx/5
         L1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736220526; x=1736825326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XfeJ0Lqr2Fv2aRpLh8hAwOkSjsGmGaPxw0MQXGL1VbE=;
        b=omTnBAGqI8qKW9Sh48+qAC0xzr405v5nrkiWy//o5TmgxuIg3sLnIG3IXWuH5Vrugz
         K+2a+yoVmvpgb3AM1RvSd2xfEygFSZRbvsDWLxZ6WezUfBYIHGW0TscM5+U2ILjcI5uu
         GeHKMgsYxaG6bDx6x6YeSz+5ZuXDWGaRytimXG6Ttp9KTGwOIm5vUqqu3+7hiItZ9VrF
         GzoxIYoFL3d9/FQ8VXNJ73lQz0EOIdvTgQju8qLTs5QEu0CE0BslEEwwR3+rP/SH8MJb
         jdhyduZORdCYZrZG/e8jiYV76H/uYCyWmgH4VGWofCi16mAeA+sApWwQeT96Rp1/+z/G
         wTTA==
X-Forwarded-Encrypted: i=1; AJvYcCUx8EJUisvGT4nBv4LTIpsfYnYxKcsAiF8kYLSIFMZAmnwweQQgoKWNnTDkLQGWwa5DD1c=@vger.kernel.org, AJvYcCXQsHXrmg2/LkI3NLYrUsEqNUkrPJiomPfYA65PYOvd5rA52qm7zEyjo1AcvMySD3DqS8dKl/USwPW/zDeT@vger.kernel.org
X-Gm-Message-State: AOJu0YylhmVEpBo4Qhgq2z15eH9yCyLxjQBG3ULYIiSvGK70QK2u/dGv
	r+HfRURlUCqNlctNpL0xogyCUfkI44c69RYujm1wgt19NPp94hdpmFN3NzYmXxUI7JDFSbM8OZu
	5IG/c/AMqvXwAhEZiVyB84MkHyMs=
X-Gm-Gg: ASbGncvpv2QKDZ/DkOii3ehelNgzSXVfckz2iZYIxbBiWgFjU7ryVQIV4gRQrStauGW
	BaL5Km6st51E/pOaqNhErf7IZE7EWWm5ziZHggw==
X-Google-Smtp-Source: AGHT+IHCmu9uNgDKwC4g/tNae1I7mHrkxA9+po8I303+NYt0svTCTVLUEa6fCsX75L13M3PQ40F+H3+HgY/K8ZCX9l4=
X-Received: by 2002:a05:600c:4f51:b0:436:51bb:7a52 with SMTP id
 5b1f17b1804b1-4366854888fmr438209085e9.7.1736220526436; Mon, 06 Jan 2025
 19:28:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250106154847.1100344-1-cleger@rivosinc.com> <20250106154847.1100344-3-cleger@rivosinc.com>
In-Reply-To: <20250106154847.1100344-3-cleger@rivosinc.com>
From: Jesse T <mr.bossman075@gmail.com>
Date: Mon, 6 Jan 2025 22:28:10 -0500
X-Gm-Features: AbW1kvbwwslv4p0Lj_Dk9xCXleaAwtRwEzRrBg540rhMGSBAhQpt4X-nTWUxshU
Message-ID: <CAJFTR8RzGNhM6okugY-CSYqXEmMOxGa9EzcLvwE4u3XePY1ASA@mail.gmail.com>
Subject: Re: [PATCH 2/6] riscv: request misaligned exception delegation from SBI
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 6, 2025 at 10:52=E2=80=AFAM Cl=C3=A9ment L=C3=A9ger <cleger@riv=
osinc.com> wrote:
>
> Now that the kernel can handle misaligned accesses in S-mode, request
> misaligned access exception delegation from SBI. This uses the FWFT SBI
> extension defined in SBI version 3.0.
>
> Signed-off-by: Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>
Reviewed-by: Jesse Taube <mr.bossman075@gmail.com>

> ---
>  arch/riscv/include/asm/cpufeature.h        |  1 +
>  arch/riscv/kernel/traps_misaligned.c       | 59 ++++++++++++++++++++++
>  arch/riscv/kernel/unaligned_access_speed.c |  2 +
>  3 files changed, 62 insertions(+)
>
> diff --git a/arch/riscv/include/asm/cpufeature.h b/arch/riscv/include/asm=
/cpufeature.h
> index 4bd054c54c21..cd406fe37df8 100644
> --- a/arch/riscv/include/asm/cpufeature.h
> +++ b/arch/riscv/include/asm/cpufeature.h
> @@ -62,6 +62,7 @@ void __init riscv_user_isa_enable(void);
>         _RISCV_ISA_EXT_DATA(_name, _id, _sub_exts, ARRAY_SIZE(_sub_exts),=
 _validate)
>
>  bool check_unaligned_access_emulated_all_cpus(void);
> +void unaligned_access_init(void);
>  #if defined(CONFIG_RISCV_SCALAR_MISALIGNED)
>  void check_unaligned_access_emulated(struct work_struct *work __always_u=
nused);
>  void unaligned_emulation_finish(void);
> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/tra=
ps_misaligned.c
> index 7cc108aed74e..4aca600527e9 100644
> --- a/arch/riscv/kernel/traps_misaligned.c
> +++ b/arch/riscv/kernel/traps_misaligned.c
> @@ -16,6 +16,7 @@
>  #include <asm/entry-common.h>
>  #include <asm/hwprobe.h>
>  #include <asm/cpufeature.h>
> +#include <asm/sbi.h>
>  #include <asm/vector.h>
>
>  #define INSN_MATCH_LB                  0x3
> @@ -689,3 +690,61 @@ bool check_unaligned_access_emulated_all_cpus(void)
>         return false;
>  }
>  #endif
> +
> +#ifdef CONFIG_RISCV_SBI
> +
> +struct misaligned_deleg_req {
> +       bool enable;
> +       int error;
> +};
> +
> +static void
> +cpu_unaligned_sbi_request_delegation(void *arg)
> +{
> +       struct misaligned_deleg_req *req =3D arg;
> +       struct sbiret ret;
> +
> +       ret =3D sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
> +                       SBI_FWFT_MISALIGNED_EXC_DELEG, req->enable, 0, 0,=
 0, 0);
> +       if (ret.error)
> +               req->error =3D 1;
> +}
> +
> +static void unaligned_sbi_request_delegation(void)
> +{
> +       struct misaligned_deleg_req req =3D {true, 0};
> +
> +       on_each_cpu(cpu_unaligned_sbi_request_delegation, &req, 1);
> +       if (!req.error) {
> +               pr_info("SBI misaligned access exception delegation ok\n"=
);
> +               /*
> +                * Note that we don't have to take any specific action he=
re, if
> +                * the delegation is successful, then
> +                * check_unaligned_access_emulated() will verify that ind=
eed the
> +                * platform traps on misaligned accesses.
> +                */
> +               return;
> +       }
> +
> +       /*
> +        * If at least delegation request failed on one hart, revert misa=
ligned
> +        * delegation for all harts, if we don't do that, we'll panic at
> +        * misaligned delegation check time (see
> +        * check_unaligned_access_emulated()).
> +        */
> +       req.enable =3D false;
> +       req.error =3D 0;
> +       on_each_cpu(cpu_unaligned_sbi_request_delegation, &req, 1);
> +       if (req.error)
> +               panic("Failed to disable misaligned delegation for all CP=
Us\n");
> +
> +}
> +
> +void unaligned_access_init(void)
> +{
> +       if (sbi_probe_extension(SBI_EXT_FWFT) > 0)
> +               unaligned_sbi_request_delegation();
> +}
> +#else
> +void unaligned_access_init(void) {}
> +#endif
> diff --git a/arch/riscv/kernel/unaligned_access_speed.c b/arch/riscv/kern=
el/unaligned_access_speed.c
> index 91f189cf1611..1e3166100837 100644
> --- a/arch/riscv/kernel/unaligned_access_speed.c
> +++ b/arch/riscv/kernel/unaligned_access_speed.c
> @@ -403,6 +403,8 @@ static int check_unaligned_access_all_cpus(void)
>  {
>         bool all_cpus_emulated, all_cpus_vec_unsupported;
>
> +       unaligned_access_init();
> +
>         all_cpus_emulated =3D check_unaligned_access_emulated_all_cpus();
>         all_cpus_vec_unsupported =3D check_vector_unaligned_access_emulat=
ed_all_cpus();
>
> --
> 2.47.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

