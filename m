Return-Path: <kvm+bounces-66985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6FF7CF0F6F
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 14:10:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A72FB300FE02
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 13:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E0B2FB612;
	Sun,  4 Jan 2026 13:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="q+xAiuL1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1462F9D85
	for <kvm@vger.kernel.org>; Sun,  4 Jan 2026 13:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767532213; cv=none; b=ZNNw3sBf7U6AwZjAPUnak47+YZLIxixKr3SYmYzmKvfe5irE/YQiz5+Gc71cp2ovGy2pxNc6E7CeecfudOlWuPk63Hh0YzEixnGdG0oU06EqPtP0PoBXimxE6HMvCsphIBHklthMN077etS+WvyYduQMFnTMkcmD2quZR0zB6wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767532213; c=relaxed/simple;
	bh=9BAW6lMeEOigOFKyVgurvnbLX42WNUcLBh+ab07ln1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gSNeq4NKI2VCLWd1IGI5w4CyzyuBsrr+Kpeaa+Kd5dJdOv/DpmywiBHL3VRRoAvzvHtBeh8ShvhblnPadbxTuy8of2ftAWFMXZG94wzYki7Xo6ez9zkoqnu/B1gHbDx5q9yYHOJKdBEf+Hb/H2b2n3Yx0U6wKS82Shbo2YprIDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=q+xAiuL1; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-3f0ec55ce57so9373911fac.2
        for <kvm@vger.kernel.org>; Sun, 04 Jan 2026 05:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1767532211; x=1768137011; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTI7TMS20QjRHAXZJ9bbtMAI7NpsUCUKEERUcBbxFDM=;
        b=q+xAiuL1uajVgdR+hGB7EFp5Ou6syWqowH3HQ5agOgItMIe3YUl9SQsU6L1aCBlWe3
         ASTs/rHRJyOUlePvw7SvFDpZXhz/JxRUJkq9YY9alBwGb5l2cY7VMZbxTerPKa+PCc7Q
         r3Fr/tIhdIgV7dm6oCBu1qXKz1a54GI5Ceex1Q3+EZWf3Z2sM+9ZAXKGBgqLe6WaPFYH
         nw7BL5HvxQ6v8jpVddg7hzK243oinEsaVkWrRMAFpuPZMFTG2/x32gRKt5dsMcFmjZB7
         N29U9N/nEL7BUJn/xCd0HyXjiSV9/raA1BZi5Q1reObx2LqlW6nKy935ZxOX7QQYdc+S
         A9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767532211; x=1768137011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LTI7TMS20QjRHAXZJ9bbtMAI7NpsUCUKEERUcBbxFDM=;
        b=tdNWyj0SKnDVgRxFsKKrnTava63N0lVuAx9SWxVaIhfWCl4Y7SZyPBRrtP3m1K6K1G
         X+msu5M66orFP+ivPX5wrErjTtOB79On0Yx3kFYe27+2mqeu2llax6yoH7183xKgE/Qr
         stYV3ctvgI0+xG19mEOMrsF6P3LazUjOoN/64bK5jmhhcOb0R4pMiSKOkc++qYWS9Z+F
         6KRN4Y9mdEtCez6JDmnuDwK/lfLJ1woOx5xydKHBCMiWISL/DdPdwzz9w61O424IA3mk
         DEP2NReitFRFLwefffxRie9wYrizvuFjEpP8APqJjqGT2QOF3mPIkmTNMVtyx25AUPWi
         CqKw==
X-Forwarded-Encrypted: i=1; AJvYcCUZRZok0NvSgLO+iV8080fIXVT7MOxld8cTZ7gX2gV5QDPWUIdutY3ETic2xXK0qYia6aw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5HyGde3bBvHXDOBEKDddVbaKHSadEsE6JY4bA7Bj+yfh/4+Sy
	idjx9kozmwIkXxYkTXvkVWkbOBLK24zsLe0TBPZpkd4Mg5xQgjXRn18jS0grpJNc7QDkoqFOhPj
	xOB8DQIQtOR+IbO0iiOEntlDzU0BRPKQbtu4NhNcJzg==
X-Gm-Gg: AY/fxX4hpH/Cg0H7ATx5+cUxumdAX0XWVc6yKBuHDzCV+O+lp69CfDOVKhxida4NCT9
	vfM1hE5ZX1V2WmLKzBgdCaQpWvzTyw/ZEZTIBDMJ/4B+HZPdN9LP6qToS9pk3eCy5grnns+ivO5
	iAO45Y/fXf/mXVytEInNzUwKBPRndJYnvll62wLoOXGIGLePrPy4H5Tm6E+3vuCNq+Gi5JU2Amv
	Ry4Ey9fvyQw+QVygIZkC1oyBZ/rdu37NIGkuhp/kJw719OVxeBAHMCM4+zUcn80Mgd8aGk0KncP
	Fm71H/EvwbFsd0ckR674BhtT1dXtA9Fhqq/XL3kHhhWBd4o6T41FqtX6Sg==
X-Google-Smtp-Source: AGHT+IE3xDi6i40mJyQzdIdSqb0qTJtsVm5MzXMVUO8Fr9GrH5N6OhzSxOH6UG8kwIyyXxEmLzYaQhs3RjFu22Jg0rU=
X-Received: by 2002:a05:6820:c004:b0:659:9a49:8f9c with SMTP id
 006d021491bc7-65d0ea4762emr13042068eaf.21.1767532210832; Sun, 04 Jan 2026
 05:10:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260103152400.552-1-naohiko.shimizu@gmail.com> <20260103152400.552-2-naohiko.shimizu@gmail.com>
In-Reply-To: <20260103152400.552-2-naohiko.shimizu@gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Sun, 4 Jan 2026 18:39:59 +0530
X-Gm-Features: AQt7F2pSg9HuUMgDzNHCV2MnkSXVSFXAakgKYkF8cMM6-UVu47ouVvHzBZEBtZE
Message-ID: <CAAhSdy1soLCbDW43otanoiXRSpx25eVSORXjaWk-oDKC7Bejsw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] riscv: clocksource: Fix stimecmp update hazard on RV32
To: Naohiko Shimizu <naohiko.shimizu@gmail.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	atish.patra@linux.dev, daniel.lezcano@linaro.org, tglx@linutronix.de, 
	nick.hu@sifive.com, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 3, 2026 at 8:54=E2=80=AFPM Naohiko Shimizu
<naohiko.shimizu@gmail.com> wrote:
>
> Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>
>
> riscv: fix timer register update hazard on RV32

Drop this line since it look similar to patch subject.

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

Need Signed-off-by and Fixes tag over here in all three patches.

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

