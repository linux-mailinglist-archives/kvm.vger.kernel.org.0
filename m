Return-Path: <kvm+bounces-48715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61E2BAD1811
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 06:43:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CEF516A62A
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 04:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F9827FB1F;
	Mon,  9 Jun 2025 04:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="nKkpmMrB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A8412CDAE
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 04:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749444218; cv=none; b=qNmPO6wd4xZzAeRB23+fVmxg+iAx2/J+79AhnHy2KHdli18otrC6vR+KfMHQYis4doq3k5g6k0nzU7xzSUy4ZHGWm/0xu1m8GXrUskitl3AsZNzpzQO9WhfJbIqeCv+ZcKdYJ1NlZBg1Uiv5aYXEd+wiRZxYOvGlGM+Qn36M6ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749444218; c=relaxed/simple;
	bh=KVfo8G06p5LMkd2xNdl1EKUUib93vSUo9xJvPueK79s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G49KK33fyfFEHfkY6a4GSG3D4mPHyqQz8s86yDm1oSgsbkpyQMLxhPsvj7PizSdL76ooqNwa4yTgn42XgxHtCqJIbKr+kgmeMIPsKnMsLFgoNQXGtMPZh/ABAxVJaBtROu+4k4zLZmXoHIuEYKonrYZxw6lJu5A0sofMqk5qS+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=nKkpmMrB; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3dddc17e4e4so2928965ab.0
        for <kvm@vger.kernel.org>; Sun, 08 Jun 2025 21:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1749444216; x=1750049016; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AQQ7TbohytoS1WSMjMWeTE196VOLo8ZyRtVEZ0jt55Q=;
        b=nKkpmMrBgqqsAVnjd3apAyzGNsA+rlwiPh9WWDSW4UTgvddWgM2axVtU8k52TF0d45
         h6K+pS0v13lOafIdyPZnOHcCUDTN42D3/zJrAH4+mteM8gqu0dNnZDK2Em6SrLqQR1jL
         Oe5qIzFjIzpMEfFC20N7m4X35cCeRDj13MPPnNvuDIgXpNBu9Pf/ib6J9DBOUeYGRioe
         wpAndpv3lJxiDNewr29gT1St7Nvldooy9k6cTMoDbttO1cW5xdV0aWb63v7VtVEWzPu3
         3CRl6jeGetTq6BcZ1qR//tBZOCRyGu7zuQTO8ozoQ3cNXZliCjvbENzlNFWheYD3wtPY
         jKdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749444216; x=1750049016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AQQ7TbohytoS1WSMjMWeTE196VOLo8ZyRtVEZ0jt55Q=;
        b=hfKH01rLE//YlWvsPFo4JAw5ATQ9kXUZMWZCJDJj626RS7QL1bK/q5KXcXyVoCag3l
         EONnIggFTT91DFzh+XOaPgfbRFq5rEpxMRlaFlNqeixvmTVcyowYPehXALJlMfnGR0BA
         L5lsMT3GKdhhIIeR0p5xIgdpZTx9iqyyTUKsWSaQXFePz2XCLvzwa+x00DmwfjK3uAZq
         wvVJfL5tCPpbm0OtVrmQM48PNLon0zyeAQkQixl74irVzTB5ZgpAOCW35b2aEVCz2O8z
         hWgtqHT4CQmAW3OI1vWp1dV/M0T/Fb7wDaKd86t3RmSZY6Z1Ev+LGQcit7V8brkZ8AIu
         UeMw==
X-Forwarded-Encrypted: i=1; AJvYcCVg53vM98Tj9GN9nhaNIDoti3IB8vB9cWTt8kTi7rzsrhZGeHfqqETkAcstfT0E3fRa4eM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBpo1FbnmYkd9PDoLljWRamU8ylRNBHvhi6M08NnbJZFYLAbtv
	I3CHsbU5fdRn3jiajL8cArygy69yznlsUKpS3163tGuTVtmX3AnMbmFN6AJ1JiBTY9YOJGZ3U03
	WhOB7FRC7Nm42eBkojZru4Hgd2kCPk0Up1B2vBgThjQ==
X-Gm-Gg: ASbGncsW9l0EIWsC5kXM/s4Ytm3Oq6u2TL56ry3T87ypO+MYn1b37bbVNOOWdAgg5Q7
	kyTlkH1JkBU9p61O1pvGoFr28A2uG1tIwI+e+gnFiMSSP/KJNZ8BPA8GtWiaJOp0aVcIuqHyFOG
	kdobGoTLCJhViTDI8ekA/gAOYLo2Jg0v1ri83QpJuGCy/c8W3OKkbk180qUb/LfdR2yK00H7TgO
	zEyUoCo2BEtg2s=
X-Google-Smtp-Source: AGHT+IEiT5Sw29VzR06/mvnFI1yGklPp8h7VXnxBQ4Lmq6+VmwASCk+pP5VvhvXXqY9B0VYHEp/vir28r/BOWJ/SLPw=
X-Received: by 2002:a05:6e02:16c8:b0:3dd:b726:cc52 with SMTP id
 e9e14a558f8ab-3ddce3cd206mr114422245ab.5.1749444216566; Sun, 08 Jun 2025
 21:43:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605061458.196003-1-apatel@ventanamicro.com> <20250605061458.196003-3-apatel@ventanamicro.com>
In-Reply-To: <20250605061458.196003-3-apatel@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 9 Jun 2025 10:13:24 +0530
X-Gm-Features: AX0GCFt1fzaaBq3Mt6tIzl8UPp0uXSKLfg_c9BLRPnyCkszfqY1Fzs_Sfg2tTEM
Message-ID: <CAAhSdy1kRHEBoKMSd2OYWj6fHZHU1HQq+68-H3=cJGNTF=5WLg@mail.gmail.com>
Subject: Re: [PATCH 02/13] RISC-V: KVM: Don't treat SBI HFENCE calls as NOPs
To: Anup Patel <apatel@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 11:45=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> The SBI specification clearly states that SBI HFENCE calls should
> return SBI_ERR_NOT_SUPPORTED when one of the target hart doesn=E2=80=99t
> support hypervisor extension (aka nested virtualization in-case
> of KVM RISC-V).
>
> Fixes: c7fa3c48de86 ("RISC-V: KVM: Treat SBI HFENCE calls as NOPs")
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>

Queued as a fix for Linux-6.16

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_sbi_replace.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_=
replace.c
> index 9752d2ffff68..b17fad091bab 100644
> --- a/arch/riscv/kvm/vcpu_sbi_replace.c
> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> @@ -127,9 +127,9 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu=
 *vcpu, struct kvm_run *run
>         case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID:
>                 /*
>                  * Until nested virtualization is implemented, the
> -                * SBI HFENCE calls should be treated as NOPs
> +                * SBI HFENCE calls should return not supported
> +                * hence fallthrough.
>                  */
> -               break;
>         default:
>                 retdata->err_val =3D SBI_ERR_NOT_SUPPORTED;
>         }
> --
> 2.43.0
>

