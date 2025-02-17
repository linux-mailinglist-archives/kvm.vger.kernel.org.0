Return-Path: <kvm+bounces-38364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 850FCA3810B
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 12:01:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D739D167F36
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F5221773F;
	Mon, 17 Feb 2025 10:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="iYQY7nTu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB2421771F
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 10:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739789841; cv=none; b=dbeflRZOLVhcN7ockxPXhBgWcEO/ptEym4xZXiMO+S9ZuuubCs65wsuynPYQlV99WXoM6HOO6whueAvuQhclwPnfUsSfHj7clU6DUof6C8xnPzSinftFiAkxhH+RssXbWV9+zknFihat6rAoEghG3BS8kFQZXIx+tvrJW7E9VLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739789841; c=relaxed/simple;
	bh=kDOoIRjHVfHyTXmfCni8DIKhMZzUPwGTSzjeKFPj7pU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OuT3VhprvOs7LCfGNvd67X33Ic7vAvUhxMYa7PMx4zUSk2+H37jEODW+eanz7m6Rw2wfuUV7Ch6YjnQuSPaAEj1NroB1haYxalXi8nNyLpbpz0PZvI0YiAjbG7HIIF/YQBXjjfvS5oQNYl8DU4P9tVmL9QA6QHj4Frycl9REukA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=iYQY7nTu; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3ce85545983so10996155ab.0
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 02:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1739789838; x=1740394638; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vsTtMyTsJbWMVKOlmUKSf/JarHtELa1O22QRRoXh8xk=;
        b=iYQY7nTuMdlP/CofJygSUrvl4TP8sjgmW/RCfsgvNoJjk0maNU+TeHPijjiw2kZFRC
         55diBPrClmBu5u772chLLeSzGCAbVWbNfeDkFSAxo6kInMRpX4gUGBECwZyeeLPpBqEN
         T20Ym7sIbpl4/HEMEVVa+HtV7QF0TWlKbcG4oFg4W55mtW00FNLWiJh6VXpiX8RPKEKc
         4qD9oZi8rtJgMPm/EkB+dXXm5K++cWC6ALhrenN3j7rvDDHT8ZQcTFw6gFg+TCcZqMuS
         wBmyEC4MdKwS2kOCxVrvBOaeUiS90WR7KR1xqiHvK2RunprvamM6NAPzocWsSDdB/uiN
         B3CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739789838; x=1740394638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vsTtMyTsJbWMVKOlmUKSf/JarHtELa1O22QRRoXh8xk=;
        b=JQaLP/1QRWSzM7jyhtNapAi0fCmj8tySBfp8VWPPi6EHF37Vf+Xr9XJzt+BPWievnA
         WZc0E58AYL97LzD/O7RswFdK4YDJVX5khiBvKTA8eu8VEMy6mSLRHxnjNH0hHStJLr20
         1+Vi2Kzktq5l8iNr/eItHLLiiYFfLFsb0dkD2A3AupNlXvgV7RUIM4vmscui/g/FCkrL
         1t9/GChPf8kmGcjw1PHr+CHp82l2eWJONp6/ohnFvVchMGTJOY4EQbELoTBYHcOSGUzY
         ZX0yPJu4Sc+zXOk6lBO0L2gYNGmnPzbD69YLcsKX5y+aI5v+A18jaeoMG/0MWwJQJI5p
         kOPw==
X-Gm-Message-State: AOJu0Yyx4BGfocyVBL483c4M/3XTi6cp4VUF4MbH/nnIGqV11RJzS1xJ
	O524y5sNr2afLuNqgRFVi6bHm+zSsNIqQA0Rn7vPEiUB2CjRff30YLjeQiQeedaRu8Cg9v3EgWF
	lTS8HqlcqlHzQm1cK7/JkHpr7igZ+Dtyeujnl2A==
X-Gm-Gg: ASbGnctfIpEGE5/1PajDw3nqAv73FTTRKzNLgU9gq+gsJuViZrRAS3mvazvxjtmegMV
	6m9bBmxCxokJ2eSrdirdp1ktqCBoqVVAYGLY1RAlBGcoClvEbSeQ20eusX6ih4KCw9J3FUQKhOg
	==
X-Google-Smtp-Source: AGHT+IF4wt3+bCr8smM4abSpg9jynt5wH6JghaDNkG3zGRYN1zSsdl+CZBbn8XESByuGwGBk4yMvzbUqkz5buCnYAwM=
X-Received: by 2002:a05:6e02:20cf:b0:3d1:a3d0:d064 with SMTP id
 e9e14a558f8ab-3d281755de7mr70090045ab.0.1739789837889; Mon, 17 Feb 2025
 02:57:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250217084506.18763-7-ajones@ventanamicro.com> <20250217084506.18763-12-ajones@ventanamicro.com>
In-Reply-To: <20250217084506.18763-12-ajones@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 17 Feb 2025 16:27:07 +0530
X-Gm-Features: AWEUYZlXyegh4HuBYLBwZJ9Tly4L0bQenOk0JsQZ_Py81_lO9EAqEQBtXwOwjmo
Message-ID: <CAAhSdy23nJq4Uj9amQ9T4iXtNoCSFLnOjjyp7pm6KdNbH7xkmA@mail.gmail.com>
Subject: Re: [PATCH 5/5] riscv: KVM: Fix SBI sleep_type use
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, cleger@rivosinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2025 at 2:15=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> The spec says sleep_type is 32 bits wide and "In case the data is
> defined as 32bit wide, higher privilege software must ensure that it
> only uses 32 bit data." Mask off upper bits of sleep_type before
> using it.
>
> Fixes: 023c15151fbb ("RISC-V: KVM: Add SBI system suspend support")
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_sbi_system.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_system.c b/arch/riscv/kvm/vcpu_sbi_s=
ystem.c
> index 5d55e08791fa..bc0ebba89003 100644
> --- a/arch/riscv/kvm/vcpu_sbi_system.c
> +++ b/arch/riscv/kvm/vcpu_sbi_system.c
> @@ -4,6 +4,7 @@
>   */
>
>  #include <linux/kvm_host.h>
> +#include <linux/wordpart.h>
>
>  #include <asm/kvm_vcpu_sbi.h>
>  #include <asm/sbi.h>
> @@ -19,7 +20,7 @@ static int kvm_sbi_ext_susp_handler(struct kvm_vcpu *vc=
pu, struct kvm_run *run,
>
>         switch (funcid) {
>         case SBI_EXT_SUSP_SYSTEM_SUSPEND:
> -               if (cp->a0 !=3D SBI_SUSP_SLEEP_TYPE_SUSPEND_TO_RAM) {
> +               if (lower_32_bits(cp->a0) !=3D SBI_SUSP_SLEEP_TYPE_SUSPEN=
D_TO_RAM) {
>                         retdata->err_val =3D SBI_ERR_INVALID_PARAM;
>                         return 0;
>                 }
> --
> 2.48.1
>

