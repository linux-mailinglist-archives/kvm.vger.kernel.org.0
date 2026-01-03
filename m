Return-Path: <kvm+bounces-66968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E79F9CF0144
	for <lists+kvm@lfdr.de>; Sat, 03 Jan 2026 15:47:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1FC3A3031A02
	for <lists+kvm@lfdr.de>; Sat,  3 Jan 2026 14:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C346430DEAA;
	Sat,  3 Jan 2026 14:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Umzy7Vl2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A90023EA87
	for <kvm@vger.kernel.org>; Sat,  3 Jan 2026 14:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767451613; cv=none; b=TqnLKYUdjYOHIDP37vGa7ryFUkiqmb+0Z2lVK1rIJsamYshd4PSJr4j3QMM81zv0VEpCExJcKq/tc6VmiZXBVtzrgkimo3i/7Aexv/97SmQf0QkRW6FoFjkaDoxngd/twO0VmJU6RQIdxhWnilFq5IMdJORpbJVFmG2MAMaRjmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767451613; c=relaxed/simple;
	bh=HIKYGrE7Qg4lT7YwbMjVWNRAkLsWCv8R48QHsariJh8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RAf7EeqPJ8e41Ffzj5YQRDhLUqYM7GUbRL7MeM7RSdwBfMMPtd6mn72rxpkAPHApA4SFIEgB8zc5KiCPY1ANSvWzlcQEpge5D9yoLNmYxo3uWEfdqhElWQBYXsQMnRH3zrBrmuPQhxhzeweTJdhG25O6eG9DNVq3wVWBoKa4IsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Umzy7Vl2; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-59a10df8027so16568096e87.0
        for <kvm@vger.kernel.org>; Sat, 03 Jan 2026 06:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1767451609; x=1768056409; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cPR1JFy6rJLSFK6ErDT15A7JIu/4ipRwd7vjBAorP1A=;
        b=Umzy7Vl22NB1AvpMjHtSMnY5oLyPR7pal2InLuuqh/uqPNIbQYqqVofJytLvnfss6r
         8dJ6Mme40Hhj3sFWBDfBoTid1Oz1w4nBvHdrNIJbZ8tVdYP8gzDcGyR+8Uu2qpzc2Ec4
         jR+daKJ9o4qrDhnz0/7GnW8KLzyFDSxIJJfiNlHKJILOFd6GO04rIFa8DaC6mkZDu41h
         qtqaDw/8tym3QbPxbVw9Q6EIlva0bCW7eBvuGf1z6p6DyazsthOLdPtO6/o4vAEaw4wU
         f9C9uS72TS0/yAZO9/e1yr4CTqC4WXgr77Yh5ONKNBBQXL+3+zaL8XwIW9vAFTh6vLrZ
         mPyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767451609; x=1768056409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cPR1JFy6rJLSFK6ErDT15A7JIu/4ipRwd7vjBAorP1A=;
        b=sB1UllBpdc+14jUb392k/eQoNLrc4lr0KR8+5+sU3Qji670GKmstAYMg1ZRWwPUUaz
         bC1lH2nNo3Dp3bnmTtuHFFmsigbdv2XqAzaSUQ4gcq04FJWUovlE7MRNSw+y5oybJGNd
         o57u6exVdfDoUoX4o5IXfTr/FHpGfBgJEEAuWdxtDybVNWsIpDWqdoWYAjyU8QPruIy8
         1rA1XWkIT3qLuwljfxDKc6CQ3Rw2NTQAER0W53eSOp3aX3rLNkDPsBVw0VWFnKm9FZ/X
         EXLD49aHWji2wxbAvkcsMd5r/VS7H+zYTSD+jfKkkn0ABEYUjuAIaYcyE0HU9ylV+LgL
         wtDg==
X-Forwarded-Encrypted: i=1; AJvYcCV1EN7CoCQcGSCdbsEICp89BXIN8nqeunErudqzN/mFrfCrBn/IJHOfk29OYc4PYg6RQ5c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeycuFJlygQW4xUL3mEWrafzl3Fs2FWPQI44lVqzB814MlBu7N
	peLzdxdMo+cBdIfKhU1gcIEALTAGI7fSnO5ai2V59wHb/C5Ctsa0VE4kUXRVPCkd8OMfnGhws7z
	2IaQypWL99RiG6u6QBf7pK+NTf61fmr3YuFeB89Cixg==
X-Gm-Gg: AY/fxX7uKhzK9lWFBgZZZn5L3Y0Ld6PZ+F2BOHgxvKmGnOXD4ifs9lYZzaBOdiDFDlE
	VnWwiLZRS2z4F9uBjBRQNUkFRqg8naJuiSCcItSfCEz+bE/41ecioJYhaVc4s0z+m9W3S/ORIpc
	RqctzDhYPBTyEH8DbESLj6VWR+hzmcDjE1U1ieG2jfU0AXBfF6tAHmXC4tLUuy2aKSH2dpeimVL
	hlYjZ2Xs3IEYFABKLrZ5Zh73VmffLM6F6rLibnGPqJRr/n8oFz9H6nXe1dfiHmNov1HUJue29A7
	Wg1fL2ZXSTOckn22Jrp0x9K9vYaQ
X-Google-Smtp-Source: AGHT+IGMVOVy3fb16NF/t3Rx4QrgWh5PG3Ed2r+o5dL2tjLnynT35YOg3OR5Ql/tytxu2rM4aj6GLMysIWnr5/ve5DQ=
X-Received: by 2002:a05:6512:3d07:b0:598:8f92:c33e with SMTP id
 2adb3069b0e04-59a17d77049mr15771880e87.50.1767451609186; Sat, 03 Jan 2026
 06:46:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260103094501.5625-1-naohiko.shimizu@gmail.com> <20260103094501.5625-3-naohiko.shimizu@gmail.com>
In-Reply-To: <20260103094501.5625-3-naohiko.shimizu@gmail.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Sat, 3 Jan 2026 20:16:38 +0530
X-Gm-Features: AQt7F2rx82roS9PAEhnFjR0SBvLaBemu4TZnUnoLSnWvhVuSqA0SpQ_ILKXY2g8
Message-ID: <CAK9=C2VbMmwTULpybAz+kSLCzBOQgFrUB74o8d6onp6enaUBCg@mail.gmail.com>
Subject: Re: [PATCH 2/3] riscv: kvm: Fix vstimecmp update hazard on RV32
To: Naohiko Shimizu <naohiko.shimizu@gmail.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	anup@brainfault.org, atish.patra@linux.dev, daniel.lezcano@linaro.org, 
	tglx@linutronix.de, nick.hu@sifive.com, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 3, 2026 at 3:16=E2=80=AFPM Naohiko Shimizu
<naohiko.shimizu@gmail.com> wrote:

Same comment as PATCH1.

>
> Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>
> ---
>  arch/riscv/kvm/vcpu_timer.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> index 85a7262115e1..f36247e4c783 100644
> --- a/arch/riscv/kvm/vcpu_timer.c
> +++ b/arch/riscv/kvm/vcpu_timer.c
> @@ -72,8 +72,9 @@ static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcpu_=
timer *t)
>  static int kvm_riscv_vcpu_update_vstimecmp(struct kvm_vcpu *vcpu, u64 nc=
ycles)
>  {
>  #if defined(CONFIG_32BIT)
> -       ncsr_write(CSR_VSTIMECMP, ncycles & 0xFFFFFFFF);
> +       ncsr_write(CSR_VSTIMECMP,  ULONG_MAX);
>         ncsr_write(CSR_VSTIMECMPH, ncycles >> 32);
> +       ncsr_write(CSR_VSTIMECMP, (u32)ncycles);
>  #else
>         ncsr_write(CSR_VSTIMECMP, ncycles);
>  #endif
> @@ -307,8 +308,9 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vc=
pu)
>                 return;
>
>  #if defined(CONFIG_32BIT)
> -       ncsr_write(CSR_VSTIMECMP, (u32)t->next_cycles);
> +       ncsr_write(CSR_VSTIMECMP, ULONG_MAX);
>         ncsr_write(CSR_VSTIMECMPH, (u32)(t->next_cycles >> 32));
> +       ncsr_write(CSR_VSTIMECMP, (u32)(t->next_cycles));
>  #else
>         ncsr_write(CSR_VSTIMECMP, t->next_cycles);
>  #endif
> --
> 2.39.5
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

Regards,
Anup

