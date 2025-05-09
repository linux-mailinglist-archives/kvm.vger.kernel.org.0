Return-Path: <kvm+bounces-46011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86B5EAB0975
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 07:13:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD69E1C20A49
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 05:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE4E266EE7;
	Fri,  9 May 2025 05:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="XPC35dpV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A30D266B44
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 05:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746767623; cv=none; b=o+arsjChBaGUjX/nbfZKTkfdDX16+KoA/5dDSSszzJhnKBS+NRStGEpzxs2WCxuOUBaaIBc3jygyoGGu5FalU9fuS+eYV0UlPTmnBkXDH9LCs7MWQwNKOtRkl/Bm0v8+R7Q/jD8kdyhm9m/qvxtXoqIijVqySLJ7a97U9JOlH+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746767623; c=relaxed/simple;
	bh=1KBaudCzRIc9vFdWIdSQSRNikGSHrK+kjrd86BIaK0I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fQ6jjuHej0/2DqULIkTpIqUI7ZRIfGyAYcW+RRKeJvAEKsyi6RL8JPXNJCUZq3OxQMdzyMfJ1Ttg0xXcHY+TxmYfLw1PQ8J1nrcbchEhj56w1O+n3CMiU0ypE/jTAwQ8DMZ7K4IPuZCbyIW0+MCD6GqY9LtjyZvjhhdAOX4I3G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=XPC35dpV; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3106217268dso15569371fa.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 22:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1746767620; x=1747372420; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZDLCK0Uz19/Y7Q6HkSbcnfKNXhJp+XeOV0z584wVfeg=;
        b=XPC35dpVdK6uVZV0O0WHISiPvzWVpf5mnSjcWH/mQ/SLUBtchU759jXJy1DnxNtwLW
         WiCgj2vHhqYz6d2Tzyr6Uw2wdvpJKkNsq66fs5c/aCYU3QURZs7++YSEX0QAoYM9hoCs
         wOvjMoSdpvo6PGiNzB7BHYCm7ttc0Aq0taTmk444dyOvA440h2ERpdUT9NnVdnRWAmq9
         HHNZKIH/scWTwlPoxGTl2p1xZamwS6/0F3y/ZkS4Nng8xToYvA2/tThh/J1N1efBcO64
         JafqvrBBZ/IP0MSgY43e1+EzstSaeCuh3rx8XcY2a1MxRdj/xOTXmwtGEeRY1zgAqUTs
         XDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746767620; x=1747372420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZDLCK0Uz19/Y7Q6HkSbcnfKNXhJp+XeOV0z584wVfeg=;
        b=uiQ7EJbs3jWrMWpojEZX5zV+ZNUZkckXzwY0PY+cfVNauapfxNRh+YzbhP6L7Cryzq
         7Bm5kfS9bpRjH7SzWbZiWqrK+35HqsJrWE/LvaJA/bQ8BCwDvheg0ckxKM2FXDoo1jBX
         UWG0uIDc3oQJdh04SxZABNeSDiTlWOOmnJr1sSboLZDnZVnUbIbs7O8xN8hKcsokZOPn
         5AHGgnAEmF77jB8XqhY5EffhOQd4OOrd5udEzAh7l/8Y3+e0HdMckNfDznPpsaHVPgno
         diDVgSZXh4ihc197d4inbv0LQS5NezK3ZuyDalaJva+IjcBYO2C1mLYkemlX19FgpA3w
         FaNA==
X-Forwarded-Encrypted: i=1; AJvYcCVOu/5wb6cPL3ubxWbbP/Qn4bAAA52+aVKK3U+jo8ZoYZcMkycq1zzl8TKg0kZyaSRs8Ng=@vger.kernel.org
X-Gm-Message-State: AOJu0YyriDfFS6+2pjXSlM8sQkuMT+7BQQUuKh7m5OKFP+Zwi7hfqi5P
	oq1SuLgF1IVREoNBGP78Z00A1nEL4EYeRI90PQnN6kJaSa9H2Y317UxXFTLkqWjfrFg/uGVLnHR
	RoP0vQcfrqWBjXahghP8KI2YP1yIK3UtGQg4+7Q==
X-Gm-Gg: ASbGncs36+iBoNaPApT6f4UgnVR73bqUd/a5sj4S/o6SNrsWxZEtaRjx4DAGPjZKUc3
	xap5f8lMBAXSKhzmsHojH/c9tgeK913lMlJo/x8O5ZwwT6NzxjY3jU1mMuQr0je/FHn1Y/hsTTO
	MPoHKtJgEdu8kH9pfmr+RMz8g=
X-Google-Smtp-Source: AGHT+IH932onN3LtbuDsB2zIJMZAB7zVyXn9SdYNT5bEdTdpbtKDjtpG9xMpkEjuL1jvH3p5mBmUHA70IkrkqZGMWFs=
X-Received: by 2002:a05:651c:a11:b0:31a:466a:4746 with SMTP id
 38308e7fff4ca-326c4626122mr9560221fa.28.1746767619980; Thu, 08 May 2025
 22:13:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250508142842.1496099-2-rkrcmar@ventanamicro.com> <20250508142842.1496099-3-rkrcmar@ventanamicro.com>
In-Reply-To: <20250508142842.1496099-3-rkrcmar@ventanamicro.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Fri, 9 May 2025 10:43:28 +0530
X-Gm-Features: ATxdqUEv61ChnZUOzx7yPdXINdl80n6Z4DSE8-_2d7Qt3jd-BEsqt9upnD2bVHQ
Message-ID: <CAK9=C2XpNMmYu_MxcA390+SBm5fMSXYYJ37JeYGHa8OHjWmYqA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: RISC-V: reset smstateen in a better place
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 8, 2025 at 8:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar=
@ventanamicro.com> wrote:
>
> This got missed when the series was applied out of order.
>
> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>
> ---
> Feel free to squash this patch with 376e3c0f8aa5 ("KVM: RISC-V: remove
> unnecessary SBI reset state").

I have squashed this patch into commit 376e3c0f8aa5

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 7cc0796999eb..a78f9ec2fa0e 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -60,6 +60,7 @@ static void kvm_riscv_vcpu_context_reset(struct kvm_vcp=
u *vcpu)
>
>         memset(cntx, 0, sizeof(*cntx));
>         memset(csr, 0, sizeof(*csr));
> +       memset(&vcpu->arch.smstateen_csr, 0, sizeof(vcpu->arch.smstateen_=
csr));
>
>         /* Restore datap as it's not a part of the guest context. */
>         cntx->vector.datap =3D vector_datap;
> @@ -101,8 +102,6 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcp=
u)
>
>         kvm_riscv_vcpu_context_reset(vcpu);
>
> -       memset(&vcpu->arch.smstateen_csr, 0, sizeof(vcpu->arch.smstateen_=
csr));
> -
>         kvm_riscv_vcpu_fp_reset(vcpu);
>
>         kvm_riscv_vcpu_vector_reset(vcpu);
> --
> 2.49.0
>
>

