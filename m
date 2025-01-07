Return-Path: <kvm+bounces-34654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19081A035E0
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 04:35:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7F9D163D17
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 03:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BAD914F121;
	Tue,  7 Jan 2025 03:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mKWZEUEo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E66B55887;
	Tue,  7 Jan 2025 03:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736220894; cv=none; b=eWqQwpWy0RZWEmz5B78nIw5Ioo0JxDsODyPDWQdD+Kfj7zIPf4GCKNi3pWJffkAsxJ3SHbgwwLab2Idl/2ujOIVFAK72lWEFd9fRnCIIOG7LOgreei5wBx2pw3B3h2gZDN6a/oZpyK+UWvOvMJbZe3RK7YIcejTFiPYwThEcI4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736220894; c=relaxed/simple;
	bh=Napy/+WHiG5K0lxtWQVwXUJtJQIgB/9VoY7PI+7YIrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gm1SajOwKr0skzeZ4EGTQ4yxvtTRe1NdmK3Wbqz/+Ur/3HxX/irtX8jL0Ce8GVIDq1/peCm5YlDlsGIB33t95lWisphppbjOOwGiVBBjhLi8ZLkh7rh3Tyc0ytTMVB++E4luQpxco06FhPbhYlhV01tDmHT5b2pKHzjIx1nsZLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mKWZEUEo; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3862d6d5765so8818469f8f.3;
        Mon, 06 Jan 2025 19:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736220890; x=1736825690; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FahbewDvVeR/TbxJ1eC2PQBUvvqltZZ3+sZ1e97cI7M=;
        b=mKWZEUEo6vJWiLv0Kis15DgxRqURdPfI1ZFdCvcNFlibZ9DARTUhcLAs6P+KApUdnN
         arliedFEobBwB52ETikjsCzMV0p38J4MvWeDsqSh7ZwMQZJu4gyetOw4XmVRjXff/0bb
         dGuxEMtqMnL2PyUMLBJOzvNNQgylQG+pVrnBLCIxqKHbqrZw/Z413EM3rStekrXqB1Ea
         EA540acgL/nLS+8VC1OYLiVhLPF2Wg1mkwvoVtbsdfQ6AfUIIdJoV+bCZHCyYl5XYhIA
         WdqOnLQ1D0sReE9mtLzJYME3zf6V4Mv+tce61+/0XWB8Znxbe/sgoNyggIEJAZ/Hv/Sk
         ukzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736220890; x=1736825690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FahbewDvVeR/TbxJ1eC2PQBUvvqltZZ3+sZ1e97cI7M=;
        b=QtcQ2UdJCgd87p9g0sBgJH5Old8EMaNU4GS0PS1QXaV/LC0DTHzWfNpb+l/JoI/9r5
         t4YCOrgrlJxjHkiBK0Q5njwkVLTyKAPKUudXbIfRtppz2mDhfFpqd+955kq2lfznH/IY
         PCqiDnHDDJW0w0gpUvJjmQ/XqjPz4c2IrvQw+TpxLWJE7D2NgBeggvh9Yvu08pGeEKDF
         jtb0e8HEYgZYhX1Ws6CP1el6xlicCdHDK8yJ3AByPgBWxwKnU60mGtI1VrgL3zGyKJu8
         56ct+xS7K7hCSYyrM2S8WLhfPWpHi67QervlFC1Xs9p1Ch0AI2E5+j4PuP67WVX2sEo6
         bIwg==
X-Forwarded-Encrypted: i=1; AJvYcCVWICyvj8VG5wUszMJDGRLycKyzJnJ5MmfuGjJgM4WqlBoGZx4CvF3p0IrdeOGMFD3sD5A=@vger.kernel.org, AJvYcCXeJMVdezH37tQA8TEbtFd8zY1rkZO0VF8nQoVpSc9plEtenVk5vfGbBVQBTQcGAYpmlPrCnKpVEW/tRPdz@vger.kernel.org
X-Gm-Message-State: AOJu0YyQO9v19VGVFVefwCloUhn5lWvdv0O0CfFWgOmgXfgzhmwFeWWQ
	qb3TYAogU6EiMMCJKIUL/H9O9Wk8O3OPJoDcEW1pxnpG/I8bVvQ2/qRpTZT67lZGI/NdDGgJGcT
	jk6AEID40PAHpCd4nzzdEVyFZ8IQ=
X-Gm-Gg: ASbGncv649H1dACCllB8920fUR4OPQYSzN8WywxYc8fanuXePw6NttOLufsvDlOveFa
	YIHf05tt7zvlIW4LaBJkUW0FMwEu1+gFtuvJX6A==
X-Google-Smtp-Source: AGHT+IEjgFMsqmwMnBKlRV84pLX9SGYuU1vz9iegSbKPWh1KSUj66MxOowLXK8zaESZz4nWlyoo0up8QbNmKSijALkY=
X-Received: by 2002:a5d:6da4:0:b0:385:f5c4:b30d with SMTP id
 ffacd0b85a97d-38a223ffac3mr50598935f8f.39.1736220889773; Mon, 06 Jan 2025
 19:34:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250106154847.1100344-1-cleger@rivosinc.com> <20250106154847.1100344-6-cleger@rivosinc.com>
In-Reply-To: <20250106154847.1100344-6-cleger@rivosinc.com>
From: Jesse T <mr.bossman075@gmail.com>
Date: Mon, 6 Jan 2025 22:34:13 -0500
X-Gm-Features: AbW1kvb44Ft_Fk0OEu5NPcMRBNdKrUUoqUqMtgbBqh5bUl2FZVNAVukNHQY7sXA
Message-ID: <CAJFTR8QyphR6sWdnri1uvw0Nwmg=4G_Xb02+CvH4LhpO3=-GhQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] riscv: export unaligned_ctl_available() as a GPL symbol
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 6, 2025 at 10:51=E2=80=AFAM Cl=C3=A9ment L=C3=A9ger <cleger@riv=
osinc.com> wrote:
>
> This symbol will be used by the KVM SBI firmware feature extension
> implementation. Since KVM can be built as a module, this needs to be
> exported. Export it using EXPORT_SYMBOL_GPL().
>
> Signed-off-by: Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>
Reviewed-by: Jesse Taube <mr.bossman075@gmail.com>

> ---
>  arch/riscv/kernel/traps_misaligned.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/tra=
ps_misaligned.c
> index 4aca600527e9..7118d74673ee 100644
> --- a/arch/riscv/kernel/traps_misaligned.c
> +++ b/arch/riscv/kernel/traps_misaligned.c
> @@ -684,6 +684,8 @@ bool unaligned_ctl_available(void)
>  {
>         return unaligned_ctl;
>  }
> +EXPORT_SYMBOL_GPL(unaligned_ctl_available);
> +
>  #else
>  bool check_unaligned_access_emulated_all_cpus(void)
>  {
> --
> 2.47.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

