Return-Path: <kvm+bounces-44300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D43AFA9C896
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 14:09:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E39CF4C41A0
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2AB124A046;
	Fri, 25 Apr 2025 12:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="zUi4Sgjl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4E222126C
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 12:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745582985; cv=none; b=r36T9W/uR7RVh0UwGKZxKr6PF1Ovn6DaMG9SGIN0/8ATsDe+s+3kGstkk3sUf4kCUxBuvYyxR1INZ834Ns6QExgTMY1SrMf/TtiUx1Lbl67MmQF51gmeLbXd+CqE+jiCklFud//UawkcwnH9mwKyMD6D+7RDT3+cMNqOAogMuVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745582985; c=relaxed/simple;
	bh=Zxm4WulE6nllv3dcY5iH7gFi33gUsbG3+YxtX1wnINQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ucwaWpsVUixyTsW6zWO0lU60koNKFm7Nx1zMvR013n54t5Dsqot0tdNcfpFKksQDuTLD79QFXhlUGOHupU3SU/oS/UqOejOkdGocjAN/2xV+Rt6aUX/ZzUM06MiaDqUHFlzIH6hOP9lNpJHsQ4ZzhHrIB3QIXj6igXWz6wvZDgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=zUi4Sgjl; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3d57143ee39so19635285ab.1
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 05:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1745582982; x=1746187782; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=viCw2qA4ejmDM4IL1wv9giS7D3cMPoAepDm5Vm/i2EM=;
        b=zUi4SgjlJBzSh0xtjOn+Pcl21QkhhCwXgqVxRQr6287ChU/x8U1gPxDjcJ5JJd/a4W
         8N+L9iyjGMqlDH13lwiilFCJQhTa+N9PiDHmp4XTg2SjgwwKcu3Rd7y2lr1aUuM+7Qou
         QPndFx4ppyK5aK/Rh6OoxozSdZ07hXE8EKA3yOEAHPlzr6+IjVA+FgQdlHXC0AMjEyLt
         s1YBbYN8ExY1Y/S02GgrlaUQz5Sr4GKaLMlGlq2hSVKds0uy6WiJWx2EDEtZ0QuCoXjI
         RRA+MNKUFtYBC6JsnDcO1odi1doIoKbE3Nsvdk6MwKiEkUdBYVMBg68u4ay1NAMXRvoE
         tBvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745582982; x=1746187782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=viCw2qA4ejmDM4IL1wv9giS7D3cMPoAepDm5Vm/i2EM=;
        b=TMjid/qXCznHyOzlTZSJSqHoE0aa15dOG7TnsGGy3NOF6mlFJdBIQNiX17kA6lAQKW
         tOFmkdNHJatUm59EbDgqgkqdVvFXCen0/fqqp2ASk7idsSV7x+7aDFNEfwDmhQ819zkV
         7RisGly8E1HHKRSFFOgCZH9CM9UgAMjW65XsyGlkbYI1k/eCpRRKw1cmBMXVij58GVEI
         aoyvJV1dNGDpBuewNBEV+XD93kKklgCDF9+psIEH5zmbgu0xvzw0TT9qYpRYn5qMuE92
         1dyNb0E/9gwfBGdDqT8pJ2WAenyKoKXsYIdhbR9N7wtRbnwQ8YM1goCGs7ckx2qEwwi1
         3R/A==
X-Forwarded-Encrypted: i=1; AJvYcCUCyvwMXxkI98akZLb/jOavotJxnBxGugj+KZSPBTcLG085rFBT0wai8xlZIDanMWXSpU8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwB7116rcN9NB19jMcQdH/B+o8GwEbsnmtz/z90YAlulObPDi4T
	z8C1KIxqpYWsWqoOpyAmen+HmhVLPINV/zSfNeYVRkbuVB1FD01JnlfWzipwgcVUhxnvrT+uWKX
	Jr5+btzZTznFqJ51r3eX0Lih1psA4HlWik1e0OA==
X-Gm-Gg: ASbGncuJWcGnVqt8rgpQu/DlUs0tMWvwlkX7bm7YUMKElPfdW4P8ovHgWdyK9I+Acq4
	i5f9wW7/eI46dn/vJ9+3PKK6IEAEvvYkyhh6fGSM69EwaND03d0snk6wnh/v5DUD+KlR6nXaZfH
	6MLCmFzA+BEXsjhR9D8p2orTrrXH1KuTbDgw==
X-Google-Smtp-Source: AGHT+IGoEJG5zH/Wr0uFePVEm/5CuSYxVySEAKvHuO5qDV3z6MJIg+y3hhgx9qY6URyzTt8T0jY2qH9X8K2GpPqyw1A=
X-Received: by 2002:a05:6e02:174a:b0:3d4:2409:ce6 with SMTP id
 e9e14a558f8ab-3d93b3aad74mr19265945ab.5.1745582981830; Fri, 25 Apr 2025
 05:09:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250324-kvm_selftest_improve-v1-0-583620219d4f@rivosinc.com> <20250324-kvm_selftest_improve-v1-1-583620219d4f@rivosinc.com>
In-Reply-To: <20250324-kvm_selftest_improve-v1-1-583620219d4f@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 25 Apr 2025 17:39:30 +0530
X-Gm-Features: ATxdqUFstmpMiz2VW1TbmZRJAZ7pd1khz3F8RMk9AGfAqqDs4TxHZFyQgyus6fM
Message-ID: <CAAhSdy11BqtEV+RoFmnpizxCTiKaWexMQGKvP15BF-AkDZUDJQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: riscv: selftests: Add stval to exception handling
To: Atish Patra <atishp@rivosinc.com>
Cc: Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2025 at 6:10=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> Save stval during exception handling so that it can be decoded to
> figure out the details of exception type.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  tools/testing/selftests/kvm/include/riscv/processor.h | 1 +
>  tools/testing/selftests/kvm/lib/riscv/handlers.S      | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tool=
s/testing/selftests/kvm/include/riscv/processor.h
> index 5f389166338c..f4a7d64fbe9a 100644
> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> @@ -95,6 +95,7 @@ struct ex_regs {
>         unsigned long epc;
>         unsigned long status;
>         unsigned long cause;
> +       unsigned long stval;
>  };
>
>  #define NR_VECTORS  2
> diff --git a/tools/testing/selftests/kvm/lib/riscv/handlers.S b/tools/tes=
ting/selftests/kvm/lib/riscv/handlers.S
> index aa0abd3f35bb..2884c1e8939b 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/handlers.S
> +++ b/tools/testing/selftests/kvm/lib/riscv/handlers.S
> @@ -45,9 +45,11 @@
>         csrr  s0, CSR_SEPC
>         csrr  s1, CSR_SSTATUS
>         csrr  s2, CSR_SCAUSE
> +       csrr  s3, CSR_STVAL
>         sd    s0, 248(sp)
>         sd    s1, 256(sp)
>         sd    s2, 264(sp)
> +       sd    s3, 272(sp)
>  .endm
>
>  .macro restore_context
>
> --
> 2.43.0
>

