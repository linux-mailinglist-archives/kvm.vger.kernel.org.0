Return-Path: <kvm+bounces-44308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6320CA9C911
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 14:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A4331BA2DA7
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D53D224C668;
	Fri, 25 Apr 2025 12:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="V2z2jc7o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBBF248896
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 12:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745584728; cv=none; b=SfFRG+baHTwIOIPgkqH0Q680JIT48kxFvlJOINN3yYFXC4n7LyRJv8pKoLCMTaR02EIGWxsrTA5GBc4jZiH3BWt93sfDHTpI8Dg7zcv87bjVUvQd32I9ep6Bq110CQth9WYm4r5L01fzf6dZth5M3G0tj4mY+XcCIGFQ47ZQkkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745584728; c=relaxed/simple;
	bh=jG0Woov0KZX/71eFaFKuHJOjEOdv2sAsWPlyXv4qKmA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=anRSINy2eG0ScB+pwluAbdIpDKEKLCQauCZbaUbRX2+4ZyO3FIt7P9pMvBg70TkxmGSOIVERVnKDRemqSQaXSVKEIdvDHRd//j8VlrRJ9Ps+o0h5QG1t7BuAAbivFRnemrKfS0IMFb20QUAAHVN34uQRlZK/plMuK4vLJJxzVyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=V2z2jc7o; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-85e73562577so221661039f.0
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 05:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1745584726; x=1746189526; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y49ecCcPZ27vKY56UjG6VNDfh5EOeWUeZzzvy6PanTw=;
        b=V2z2jc7o7Fig3LRgt42oIGvxeQ1Zja4vsoXpFl5OgLS/iyIqu9ZMMp2hFrZvdeq/Eu
         MNZmzEwLnPt1inkFQJDrbGYa/N2zXWBNCSCBGpoCCy8m0DMg3CdViUKwOnAILvtEMKc4
         3hZlJmoG7pY6pdbfy0ipkOdwymegrPQIKEL38+Tbg9m0CsOGqnrSUZHbIi82DJx8AuQc
         l45MJPWwG645SsOTDNlRX/rUeLLNaIa5VWAOGqq0lnP8pUF7pEwkKoUbb51TRbFc1DTV
         4lnhwMsuj8GKQCP2H0pJZpWTG+HROo5CxkTUD1LvHk9K/Xc09Tshb1mIUtDXDIflyqAj
         BXSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745584726; x=1746189526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y49ecCcPZ27vKY56UjG6VNDfh5EOeWUeZzzvy6PanTw=;
        b=OctHYUg0wjzNKPOQ+wWliJFDmKiMlwD7NwXljlqH0N4+xOqfDjt6BEUw0c6oW5B1kj
         k8BC3n0gdr+jzcjHQYbc16jaCy7YIsFg9VwmblAJFICMa7XfB/snRxOdPCpCKhO1J8yL
         uGn3r3We10Q5kMPTaRJd1Pz/xNYPouNJprpGnH7WpiDzZAvbsWAQarO/f7kceW1X+qAh
         V6lXlmC1vptZ6fUt2mCfOO95MjmWqSbdGqS9BJyG/XqD2xcrVTfVhSPv4eFU8tIXjWZX
         UwrFCM13T7Yy0SEvbmUIY3fgIrToYVxIWQBs+R9FOdOTziUuqWarJOSFRE2xi7IVonRW
         l0Yw==
X-Forwarded-Encrypted: i=1; AJvYcCXh62c3Ih8yBZk0rCJRjetiI7pCyXLzv8DsZbSR8sHGkqVyaUEGwHR/TMUVil646H9p3nk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyux8rTUEUVBZVdEMtRtdR+lV+vyJqrXNPF7MrQW5e8LfZd8vYb
	XUWjXyj4XLEmKX3z9vfu2uw7JxcjiL8uT3gAFC/nX55ZEEmgPTBOqP33/mXKwMo12YUmfYoQl41
	r0irbD/Dp+o1uNC19Z26H6qRmUHID+Fmk8UZs2w==
X-Gm-Gg: ASbGncvk9nNiB2tIOhx3AAMYfIpaQryEYqGiUTROcKZ4Fl9wXhpfkcKdGneLNxRTtt4
	wIiAvUrI1zl/fmWrVvSCcPnxDP4xbt5/kcBs+OoJr5IgaIqhndHhaG5Ri2CXcZnWqy9fOOLs8Lx
	fJjXQXpQeP6e4fHycCI1iOmA+EgtD1k8j39Q==
X-Google-Smtp-Source: AGHT+IHCBpc2B5Wy9lcw08NfHNFF6DJA1zf4wJ9kwK39XfuRau2F7l0ThkxP7bLnPHEwO5HGzNURDb7ye8N+KXdSdhA=
X-Received: by 2002:a05:6e02:160c:b0:3a7:88f2:cfa9 with SMTP id
 e9e14a558f8ab-3d93b46c840mr18166585ab.11.1745584725718; Fri, 25 Apr 2025
 05:38:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com> <20250403112522.1566629-8-rkrcmar@ventanamicro.com>
In-Reply-To: <20250403112522.1566629-8-rkrcmar@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 25 Apr 2025 18:08:32 +0530
X-Gm-Features: ATxdqUGBDZlnKKA6uFKMGKbX7_uvZC9RQt2w-oNtOWxKHL92YM2ym7Hd58gV9nQ
Message-ID: <CAAhSdy0+C34zZbYR3_B9x6xHihwfLxeTBOfrdRfLRjFUN=78gA@mail.gmail.com>
Subject: Re: [PATCH 5/5] KVM: RISC-V: reset smstateen CSRs
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar=
@ventanamicro.com> wrote:
>
> Not resetting smstateen is a potential security hole, because VU might
> be able to access state that VS does not properly context-switch.
>
> Fixes: 81f0f314fec9 ("RISCV: KVM: Add sstateen0 context save/restore")
> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>

This should be the first patch of the series which can
be applied independently.

I have rebased and queued it as a fix for Linux-6.15.

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 4578863a39e3..ac0fa50bc489 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -65,6 +65,7 @@ static void kvm_riscv_vcpu_context_reset(struct kvm_vcp=
u *vcpu)
>
>         memset(cntx, 0, sizeof(*cntx));
>         memset(csr, 0, sizeof(*csr));
> +       memset(&vcpu->arch.smstateen_csr, 0, sizeof(vcpu->arch.smstateen_=
csr));
>
>         /* Restore datap as it's not a part of the guest context. */
>         cntx->vector.datap =3D vector_datap;
> --
> 2.48.1
>

