Return-Path: <kvm+bounces-66967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 14554CF013E
	for <lists+kvm@lfdr.de>; Sat, 03 Jan 2026 15:46:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 402CE301AE3C
	for <lists+kvm@lfdr.de>; Sat,  3 Jan 2026 14:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FA730DEA2;
	Sat,  3 Jan 2026 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="NnrV8OQn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE0D3FF1
	for <kvm@vger.kernel.org>; Sat,  3 Jan 2026 14:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767451576; cv=none; b=FQVDnF2ZJQlqaJTVMb27QcP81WsTbWJ7CBdcJKORM3Ia9v8AcghJ1pfZom46tOYFgFJOXQqjaDXsi7GaTRJrhbhGBjXfxyzjJ3dp+T1cAnygmq0PZRoTKAiSURYxfydJqgSMUEVXJtco3KJsgJPyeDgZNU61Elw50eKSWx0ARjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767451576; c=relaxed/simple;
	bh=DKhRg7gKRzdyLuTKZF8AQFRPyuh91CLjAA3UK/sfqcQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ADQSC0R7/20p1muiag6v945MgvrtjPbpcaYPC4vgyeq0XqbLqVYh3sVTZgI5G3FPusP8XfyGbOSK8rDA+6s3V0lRD5mUZiFdVFQjmdu8ssjbR10/Y40/mba7njU+/r5m4hpOuA7S1Imvz6J4jSMFZBvuH0AHA3bjvkNbwI/seHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=NnrV8OQn; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-37b9728a353so154975381fa.0
        for <kvm@vger.kernel.org>; Sat, 03 Jan 2026 06:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1767451572; x=1768056372; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1rNP0amHfQZI+Bt5JBFPQlAXbRaSEgN4u2DbQlN2RHg=;
        b=NnrV8OQnuGjWy1Dydbu6b11zSZQl1g277zctiHFuk+iYe6qBBjezbjqwKNQiBk/Iwh
         kxNJrTCaMieLSc/bZCrDqHywNkR3tOa6LnpCXYGYJSqmfsl1ylbKseaGdUhNzS5UkXj0
         dss1DgQSbUPyN6RK4lUQIOPXSkM4Zd9tbl+WRR3pIkuG/WAI4lEa8TovjOuXAIHN+9SP
         VJkco+kxzcs9CsfRQD92pVN8jhQbIo2EuXxqpqHQhSKht/YFR5kBWG2dsLmJfZMpPFrc
         BNYlBWJlJx5iJV3VwfXoOCZ9cQ+/3LAvknWWDizAFg963HtWt9wMi1LNKqsohjgoGKQz
         mYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767451572; x=1768056372;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1rNP0amHfQZI+Bt5JBFPQlAXbRaSEgN4u2DbQlN2RHg=;
        b=IFDZDJ1/cqAlhJfQXUlsC0nHci1ZPxMA/VxWz/a60snG31zX2OFAxJkBQ8U06WQwE8
         7KlkAbgP5O/QfMltF+XxokEBxJA6mTswxPepQ2z72v2xcb2BaKG4DhpSPtWx2fFqStsc
         vpMMdrodXeKvSX9wnnSBUHpqoHwe/gzNt1mvUStif7H0KqbrEuvFsr/jA/jDBJ0dnlZZ
         RtJg3YbcR+JCA8c6m8rmR2d8Q5uEfeYaVJtAGDQd1K8lTT9EStZm9OYwb6xUR0XKDVst
         v92ImTajR8cYSMl4JNZ0TqMkQt3N5ItamzQSzqEq7j2QpBNExrOllAdjBu2gWSfNbjgu
         NvLA==
X-Forwarded-Encrypted: i=1; AJvYcCVWqGHHA0FSdEyuNMo+dL4u3w68Z/32oxNODIRLDkumQ7MF1i22Z1Dtwein5pgrkiQjvrw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3SMSOvaaCTWfx4TfKmy2VqLSimJpyGs6FYBq0lVPcvOB8ffVv
	+6kKsqjuNw9P7zC+3IUU92uWz7yrG4Hg5Vme2qOv0B+qjyjCu6v5V7CsFUOHBaOINN+S4zmCVkp
	SbnRgoH01IrihtDkjkf3sKoYTkr7emd4I8bDn2npJ0g==
X-Gm-Gg: AY/fxX77sAnXNl5U9MWfjh+piG1d1cozd/cAsVdFSL1sQQ7aR/jAPZCbYWokGmLPtlB
	xDI1Mh0Fysfvlpl04hNHL818AaaeIKZvCGdw6KMUnzMAfK+/vWvBiYswFlVjaEsVVRsf9r1GMQi
	72BJmLJsp8erHbq1qEDesspHauQDIt9teDRjvue9XE9CPWeCab8kKn5qdtzOBVPf5dpeY0zrN3s
	htOd/uqxo/kEWSfga+PmM2NC10tsELbAdWNNCuw3gEUed7qKCuxs3lOpnyHRL09Y5XwJnZN8NGr
	HuA3aWAL0x5PjczbxGFQUP0nDM0j
X-Google-Smtp-Source: AGHT+IF7eF6cn+HX5XYXj+oXYPZdeoxSmdOgiJeCygugV4mMTsAnlrOB1uBjUgSKh5J2mzU4hEupTp4yBLk/voocWR4=
X-Received: by 2002:a2e:a883:0:b0:37b:8d78:e4bf with SMTP id
 38308e7fff4ca-381216747bemr111199151fa.43.1767451571724; Sat, 03 Jan 2026
 06:46:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260103094501.5625-1-naohiko.shimizu@gmail.com> <20260103094501.5625-2-naohiko.shimizu@gmail.com>
In-Reply-To: <20260103094501.5625-2-naohiko.shimizu@gmail.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Sat, 3 Jan 2026 20:16:01 +0530
X-Gm-Features: AQt7F2r6vAqM7C6IoN6U2-LtJjI5r5Bvxkcv5JqaaOeR5ZkwLpMsZJFGBVlH8g0
Message-ID: <CAK9=C2XTi9Gjy0oJExGyaVvPbh2+cJzmeea5JnMR4d3kbvDJDA@mail.gmail.com>
Subject: Re: [PATCH 1/3] riscv: clocksource: Fix stimecmp update hazard on RV32
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

Please add a detailed commit description about why the
new way of programming stimecmp is better. Also, explain
what the current Priv spec says in this context.

>
> Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>
> ---
>  drivers/clocksource/timer-riscv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/time=
r-riscv.c
> index 4d7cf338824a..cfc4d83c42c0 100644
> --- a/drivers/clocksource/timer-riscv.c
> +++ b/drivers/clocksource/timer-riscv.c
> @@ -50,8 +50,9 @@ static int riscv_clock_next_event(unsigned long delta,
>
>         if (static_branch_likely(&riscv_sstc_available)) {
>  #if defined(CONFIG_32BIT)
> -               csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
> +               csr_write(CSR_STIMECMP, ULONG_MAX);
>                 csr_write(CSR_STIMECMPH, next_tval >> 32);
> +               csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
>  #else
>                 csr_write(CSR_STIMECMP, next_tval);
>  #endif
> --
> 2.39.5
>
>

Regards,
Anup

