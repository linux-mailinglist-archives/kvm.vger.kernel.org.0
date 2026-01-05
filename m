Return-Path: <kvm+bounces-66992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A433CF1CB4
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 05:31:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 86B50301C966
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 04:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFCAE31E0F0;
	Mon,  5 Jan 2026 04:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="RlTmTypw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9E39475
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 04:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767587496; cv=none; b=gUgWXBrxESQOS8G1YY/pn3Tv3MCRrAqskANZNuPMhuMdr7yH9tBUOQRLAmu9t8bIliiVC8mU1vCy5JDSdBFDMS6rz23dh8lyUVH9VIw2fUYQkSO154U5Z6FJb03Ea0Ws08O/ivqMkyrirn/jTDYM35/LCUztIBIEeQ5rkiF6p3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767587496; c=relaxed/simple;
	bh=ph9kgKoINr+xGyytnY9DWI55g7EFaU92zz1Ps7T0tfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p1K2+Ddf1bUMshsVtmcVME3bJbyVgNgtRQZRHWD8GlQ5SL3RMISLAp1CeQejbqCEE6SaetEmtV1q6dDZiFbQT4bAL8Wbt5YOMzsEg63HZP1o3dswdQbGBI1RgoenFEcX6reoRhBgDjzwiQROItviZIFHFfUS5JHmz92Hs+DKTCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=RlTmTypw; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-657464a9010so5174515eaf.3
        for <kvm@vger.kernel.org>; Sun, 04 Jan 2026 20:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1767587493; x=1768192293; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXRh45S0E1wg+SbwJvRj0sTfGM+6MbGGitqWTepWxqA=;
        b=RlTmTypwWpuebS8emgm8y0XT9qD4y05/H9c1Fvk9f3qNM7VqVQyayaAzTROZtq2UUx
         wIAiRHix/To7xaiCvYSfPFUlce/NlRQ1/tDbWY3waAJ74HqUkAbqyFs7/943wDf3cnPd
         9761JvRuPlCxaeqfCDgX8K75JBZplCKH8hpPrClqPg1YraHbmHmDidB1nBTc3BNu8YJA
         /KmhyZFy+Q0Guda7ikWdra83QfwZn0/MXqTgKFP7+M06FAC5tXhwK3/MYope85UvS2Wz
         z1Gknubzvjo5/XDgpNvlajowY/vTGdUkdcrIvgW7o/YAeajPncspKTWSgkJ+xu/Cdc6u
         cuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767587493; x=1768192293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZXRh45S0E1wg+SbwJvRj0sTfGM+6MbGGitqWTepWxqA=;
        b=lfnrIuflaaq9wmw5A6YKPjq6xBPoHQD4WaV8badrT0L5To2yQtKjD8cei8erVaAMtB
         1MTVwmvrSBE0vTqdxGCqXHn1KJV/qY/VFQSS8iIU48DUr89LX6DlxxW6lAlnqnuiXCnO
         hHPHHwBezBsKNRQlCkXxgT90l+4NtTe9DTbwIZAiRqanasqqUdcDlZBl3jXzLyVYGNVt
         dIDRS6nLau2elzQh4uTAZO1O4K8I8vLD/5JpCE3djx09PwqSu8ghdvIH8dxwbdGY6gCd
         Qeerlvl+VDAY0RW5K6csIYWlF9T/0/xZ8BTFIeL8RC+TLXST5BNjRP+Hf1LjN/Oq6Xn+
         /mcg==
X-Forwarded-Encrypted: i=1; AJvYcCWMv8TesAFg5ozFrEFS6ccR1aw2Y0hEF3y8XLjNB5mkN67JxMlKCAGhdtSsoBNjMFfnki4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5vAE3bW/f3V/8qKpBgZmkp2tTBZSxesBPz1clwaj+ese9qzOt
	va//QFzLp4O6SR2BTey8jDBYCtf4/uvf7dBowYh5XD3dzAi1JXq2cZqiIXEP6qT2Iyy40Lf3lUU
	NvvgqlawpizitN10v8Q6v7Tf81TSK2hOxPiZz30S4gg==
X-Gm-Gg: AY/fxX6EkmhWS5I7iSWOVvW2890ui+7EDCTpxmILiHFOK8dC2t0gf9YlZ4Dk+ctjHrZ
	WdHHxcnrUcGYRDZOo2tCjUgjx9d40yeOqZhvVJMpNZ45C4JcAKibQ5zoAqZQnPDuZOnJhum4uv1
	vqDkD7wJjcrJAYXL7A7GlhckuWUcZEMZJK0nV0i+nrce7FgJVXsGctUzfANkRKSr1LH7NHhKGnu
	tlLRB7JyokBS4auoLnW9qRSaqzfSLtOKorFsdUUvmd/PaKQU4OY0B0Q8FQKcVRspC/5uvABer1t
	xiQUdAC/JhVK4+1dw7dqe7KhOVRM4/7wyyP/IIxMw5KUoDQXqnz69n8Wjkkpqmg/Nl+j
X-Google-Smtp-Source: AGHT+IEwkcDRlFymm0SPcnTgEwcBBNPUXBq54o6AH1iKbZWNrVdE8TDy/EhnihwLQhHoswrfeUq7eC4nfF3TU8/lvoI=
X-Received: by 2002:a4a:dcc8:0:b0:65d:7e5:d49d with SMTP id
 006d021491bc7-65d0eade78cmr16123734eaf.72.1767587493534; Sun, 04 Jan 2026
 20:31:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260104135938.524-1-naohiko.shimizu@gmail.com> <20260104135938.524-3-naohiko.shimizu@gmail.com>
In-Reply-To: <20260104135938.524-3-naohiko.shimizu@gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 5 Jan 2026 10:01:22 +0530
X-Gm-Features: AQt7F2oifOmggNLxX3Gj-6EJLO4qsWCjAuonxgnVcRqV8UojPRmnf2HWnXWgnm4
Message-ID: <CAAhSdy2rH5Jt5t7zCRfFd5d1X7qG41QoUuWvKgwuKX=X3Wk6cA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] riscv: kvm: Fix vstimecmp update hazard on RV32
To: Naohiko Shimizu <naohiko.shimizu@gmail.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	atish.patra@linux.dev, daniel.lezcano@linaro.org, tglx@linutronix.de, 
	nick.hu@sifive.com, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 4, 2026 at 7:30=E2=80=AFPM Naohiko Shimizu
<naohiko.shimizu@gmail.com> wrote:
>
> On RV32, updating the 64-bit stimecmp (or vstimecmp) CSR requires two
> separate 32-bit writes. A race condition exists if the timer triggers
> during these two writes.
>
> The RISC-V Privileged Specification (e.g., Section 3.2.1 for mtimecmp)
> recommends a specific 3-step sequence to avoid spurious interrupts
> when updating 64-bit comparison registers on 32-bit systems:
>
> 1. Set the low-order bits (stimecmp) to all ones (ULONG_MAX).
> 2. Set the high-order bits (stimecmph) to the desired value.
> 3. Set the low-order bits (stimecmp) to the desired value.
>
> Current implementation writes the LSB first without ensuring a future
> value, which may lead to a transient state where the 64-bit comparison
> is incorrectly evaluated as "expired" by the hardware. This results in
> spurious timer interrupts.
>
> This patch adopts the spec-recommended 3-step sequence to ensure the
> intermediate 64-bit state is never smaller than the current time.
>
> Fixes: 8f5cb44b1bae ("RISC-V: KVM: Support sstc extension")
> Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this as fixes for Linux-6.19.

Thanks,
Anup

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

