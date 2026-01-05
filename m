Return-Path: <kvm+bounces-66994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C704CF1CC8
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 05:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 086FA3032723
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 04:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D76F1DFDB8;
	Mon,  5 Jan 2026 04:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="g8t/agiN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0223203AB
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 04:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767587554; cv=none; b=Btmmndg/saIj8EMlqYrjn2vuGnqUIfuXg88HWallNMjJK++19bM/AoU8AkJkUG13e9F/ThBk6jjNIKBVCO8UjM3tj/ffOGxZp8sPQYb3MqM587S1DLehwcN9rk876tzvEEeWXUYR+Kp5IV4NC/cBGl1nq/BNufhhZE4ZnwImJ5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767587554; c=relaxed/simple;
	bh=QmllJ27JDIUKLWu3jmzNEtX+A9fpSa6Qd7hV233iTFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tn6Ejj2CURn2Xzk8bdaobB6qKGlDU+n8kBSmCgW8U0/U7+XIOhvno49Agdx/w66iGcLv4tFk5oElIyWXAg1Kvmw/Yz/whDCY0cW72O5hdiCpuZ/+SsZp8tKvIcCO41qhv5/IhPqeGATs85twgUH+HtL5jQc5qbIZ4bjJ9tYAZdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=g8t/agiN; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-3fa139e5d90so4613991fac.3
        for <kvm@vger.kernel.org>; Sun, 04 Jan 2026 20:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1767587524; x=1768192324; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hHkaBZ4KK18wS8f7Porp98nIhGzHcidozMr5EBFYJqU=;
        b=g8t/agiNzMTlQxb23Uf1cqXL31nYr7GSfbR3bDvxsxX4OQHz1lX/F2Av0gSpb9Z5sP
         iyVXCyVlbjVkJZ63dOlRWwnJMVJg0q1IO/wC2xbL2TJso5l8qpWhFe2ZH9NLpABT/cX4
         7J1BTOFiNooPyqfsgZZy2Jx1YP513KbzF1E3bchXNTGTR+v1WOfhSq3ehHJiaLoV1I+9
         qKvBJRtDf5XiR5vXLsw9aSmafnJ7ITwBTMO4W2jAB9hUCtlEC+7aV2rsnRJBSgZAcGd1
         RALjjWwsVkY3ypPsX62rQ5DgBBm/SElweLQR2ve6+X16RMVy90alYbqnMvIwlacsYMP7
         bkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767587524; x=1768192324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hHkaBZ4KK18wS8f7Porp98nIhGzHcidozMr5EBFYJqU=;
        b=VpYGx1KwnwbAUmJSe5zXRq7hxqs+JlDSWlwGvv8oflZCUKeV+WYPxQSInF7FfILZL2
         Sj26I3GniwiPbt/eIae3vqOXzALbpmvUdFgdDpEO86xriZ9pYnu4HcSa8IHSFHwCzMxW
         ghKzTX1XM3FSJXrSZ1xoGiE+cojIlF6N9krOkVTtuYWtuIoMFw/24lriHPQgXbhCqJjj
         /xOlHvD0TCqk5eE2fIIO3yw4eWg3H/G2ulJnn4G4YLMbbyU+xuViyCDWc+L3GMF1+no4
         V0WFfrCapIuxYFmh9cF1oHimfm3zltGE4c55Z/HaOgR6nDOceqOFvTfrFCN80kr4s2fA
         ubBg==
X-Forwarded-Encrypted: i=1; AJvYcCWy526f0z3FowiiFiZ4NsPSYRkh7ywcnrHe0F45meJVlolCob1vdpQRqyFJHwIYRWuxf/4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0Wvv6icKx+b6R+Tt8DbTkzh/GkFnJM/2gzVLejSiyKCEI5Ekf
	PIsRRwMDstnuegWn5umhGNVSAdsGuU1PUaPD5CwhKkamBUus4/s0vp1fOUE4rNBaHux75d28bOW
	CYC6DO5UwkEZdMxx9YE9YiICrcdUOeDcNDw9wYc0bgQ==
X-Gm-Gg: AY/fxX4wkeP5/lCo4RG9Xs81v1J/Mdc4YbSfJ7LBZvSPGpPK2nDlqFNAuqpg3J8OH/c
	zrUMa70T7G3LtSlYRDKXWDzIauawAE671VtQMVifpsOj0o+9y5JAPfqpCutUXBjlJrFPIschiOX
	+BoSc/kh6or7PCV0WG9v3dLxZL7HWkyyFe/z20nb+iBPxkt4bSk3+pR5JV+YWDNggVcddidsL1v
	1TA8qesMsGGuZo4A0J7YLRgyeHWMIYL0q4jXiaEKny1JnxY50NRxCFSH0GSijw7AMEsYnvULMgp
	j19vwZcwzGs8UFjH9pKoGzTN2Zc+H7FgBLAU9YpA9fscwCLBz2WG4JjiwA==
X-Google-Smtp-Source: AGHT+IFTgEGwXPx6BKmlWZVg0kN84C+S2+KENgMMgK/TV+vTypAKt4mWKTS5e1BqvI7y/qNPjWol9HS75PcMvY2Cyfg=
X-Received: by 2002:a05:6820:1517:b0:65f:1038:1312 with SMTP id
 006d021491bc7-65f103814a5mr6928745eaf.24.1767587523833; Sun, 04 Jan 2026
 20:32:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260104135938.524-1-naohiko.shimizu@gmail.com> <20260104135938.524-4-naohiko.shimizu@gmail.com>
In-Reply-To: <20260104135938.524-4-naohiko.shimizu@gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 5 Jan 2026 10:01:52 +0530
X-Gm-Features: AQt7F2q2sNhEFpoD1aMpeC7h9p1U_y0qvSfsQ2UQSOqUFOrIw4g5EvmP552X2Mw
Message-ID: <CAAhSdy0sLTudTUc9fXMXkjoyZkiiGk=HS_Ybgz_LT0E8-i5RJg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] riscv: suspend: Fix stimecmp update hazard on RV32
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
> Fixes: ffef54ad4110 ("riscv: Add stimecmp save and restore")
> Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup


> ---
>  arch/riscv/kernel/suspend.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kernel/suspend.c b/arch/riscv/kernel/suspend.c
> index 24b3f57d467f..aff93090c4ef 100644
> --- a/arch/riscv/kernel/suspend.c
> +++ b/arch/riscv/kernel/suspend.c
> @@ -51,10 +51,11 @@ void suspend_restore_csrs(struct suspend_context *con=
text)
>
>  #ifdef CONFIG_MMU
>         if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SSTC)) {
> -               csr_write(CSR_STIMECMP, context->stimecmp);
>  #if __riscv_xlen < 64
> +               csr_write(CSR_STIMECMP, ULONG_MAX);
>                 csr_write(CSR_STIMECMPH, context->stimecmph);
>  #endif
> +               csr_write(CSR_STIMECMP, context->stimecmp);
>         }
>
>         csr_write(CSR_SATP, context->satp);
> --
> 2.39.5
>

