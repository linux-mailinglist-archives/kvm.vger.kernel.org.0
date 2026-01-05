Return-Path: <kvm+bounces-66993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EFC9CF1CB9
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 05:32:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E1956300986A
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 04:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FCF65464F;
	Mon,  5 Jan 2026 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="wNDJ8ZGL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41EB2D23A5
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 04:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767587508; cv=none; b=UAvnrV9oLPTSb/VRVG6nIanzvHJokc2JhuNHilT2hX0XBGoKY/t1hraFZhN6El/4MEKzDgtgpsEhzFd98oF+hZh7WhLCLwASYFNMr3DFVxMx6z/xZcIetaSn+m/nihgLJNnorRV38ZMgt4FbhtThSoRQnT1/MyXGWbhN2NhbDmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767587508; c=relaxed/simple;
	bh=RENzfxQAKYMCAK154Vgl6yoZ9ZIrH+tMjtlwD078VAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mVvBZbTMqWN4vueQREhW5gYgmglES7h1EOxcLtPD+YiOwRBR4cczvgtXOtedwNNeg35irRml4aevXR7+t0KL21Pp6E9Ihq9zMxRsZRzbcbMnihhjIO5E4tdfgb4zuUSMh/HtrPnHuYRDFnlC9rKMTYQ4DfeS4+goyNctF9HA0Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=wNDJ8ZGL; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-3e3dac349easo15086699fac.2
        for <kvm@vger.kernel.org>; Sun, 04 Jan 2026 20:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1767587503; x=1768192303; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VRQ6OMDCoS/pT3RqkzNsASYNjnvWbDr+adtHT2Vjro0=;
        b=wNDJ8ZGLNaZt5agwWmkPJ3zA6PPaCI1X3BRtCaUzIZX6H4Rpzof3wa36W/DCtqH98B
         BxGbkwERx1R6mPUvLnuNBkcKJcdiSwsfOy7DLbfoBb+sCut7zPy/7o8hKeYGLHzB/i7B
         3OvjqHqlhpcBCTuBodSZdVnvURSQHngwy+wffjCds4bLvIzTAQ1HI70hhlcKJ/npRM51
         OEuh7tA0QFyaNDlVV1esX9rpLPXpnl7kHZJjhBYWskl0m5Dp5S6z617xhVhsALoH/hyp
         LaxCKGv40b7ZqE6mhIE/DyIpVwKM3GwR4N0WwTgM5+2xAKjWXxgyYRhjwzjJlCMy4AyW
         EcRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767587503; x=1768192303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VRQ6OMDCoS/pT3RqkzNsASYNjnvWbDr+adtHT2Vjro0=;
        b=oemNZXRh7zgJNYyMVPxxfrKVyvljlxsiWYspJmaiAEuIyf5j9+EI2MzdbHshiEWoVF
         56f4Naes1S3v3cDjlvADtdKMmWbblOwEFAYQ+k7p43o1K3BUKEYoeU6Jtoo3dKccynN2
         SKdU8WY6PJdJuO5zak5oE0WT7KMAW7B69xMthsKxnJGWXA90u0bbtohmmsTKvzAkOLhB
         /lw0e8Sa+qlrC/3JV3AmENLMlBlqxWlrQfUvuV5mtJhv+MiS2AYXW1OeekPB2VvR1rLX
         9WV7lUE+HYOFAGJSvLiqliX1mAbqOcpwYevqBo8CE913z5Q3C4/rfi+S+p/b2yx4bRyo
         2CTg==
X-Forwarded-Encrypted: i=1; AJvYcCUNHDYxRcCWQ5SuFrVuyC8Bf6DF/yvNP8YUBjAmWyYErKDkCCoYCn7zDh+d16srjYFcPV8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQVBBH4rt3GT/Um8nN+4OORYcEyKDzWnHWs/uBlvMQWE17JRyY
	uxMMyJexmwI43jqEYeZEiGTLBlM41zn5vb79XQs/d31LmAXr/vvhBy6T8pJIXnGl0LjjhpXPjmw
	/MQgZ0N/B+SPbR2Y0QY0BTewyOVWUWHoeYYhgGGGykg==
X-Gm-Gg: AY/fxX5YcIWYypj1YXT81R0LU5zgox2cQw2GnESSOEvVKrqqCltAlNoTPakyn/F2n/E
	hrYvbicyL7bP77FTm4OgeywFPtDg1ORk+El/RkR6qMk7wNVENu9ZhZG6lUb26zLFkd7ukGpmWow
	0B27jXMaNzkAesVQeBthVfP/bBxj4Rezv24b+NWh7lQ2j5FX0rq8mx0wpEsEXP/lF8nkyzaevuU
	1XwA42yiTJC8ZL6zxGCZ3DAMfQGBa9GZI3FsRfIHz4YqubFWvNDO0g1rsW0uBMlWSiCfOJAAo2z
	9dOlTb2fkSJUdkkEuZrEEYU77th8cCDqF7VIYgST1It2UvV1ZxQn0WddZg==
X-Google-Smtp-Source: AGHT+IHcKT2JR0dERW1P8mzF5izxKZvyKkjogtNi5lVp6Ef+d3be2ZXscFhYZUS/uEVX0ylkADDomixyPLXoChTBifY=
X-Received: by 2002:a05:6820:6e86:b0:65b:250c:70f0 with SMTP id
 006d021491bc7-65d0eb1f930mr13041234eaf.47.1767587503009; Sun, 04 Jan 2026
 20:31:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260104135938.524-1-naohiko.shimizu@gmail.com> <20260104135938.524-2-naohiko.shimizu@gmail.com>
In-Reply-To: <20260104135938.524-2-naohiko.shimizu@gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 5 Jan 2026 10:01:32 +0530
X-Gm-Features: AQt7F2rYFXOkOqEixAKm3k9vFsmCv4F946k8w_SRew9TUmb4ul4n5jrOgjW2BRc
Message-ID: <CAAhSdy2dZ0neWZMyT=-b01kwAJ5XSTiBfifuqtSJ5OzvkbVOeQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] riscv: clocksource: Fix stimecmp update hazard on RV32
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
> Fixes: 9f7a8ff6391f ("RISC-V: Prefer sstc extension if available")
> Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup


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

