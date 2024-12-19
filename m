Return-Path: <kvm+bounces-34119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D7739F760D
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 08:47:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B25216A40B
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 07:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF10421771B;
	Thu, 19 Dec 2024 07:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="fNtPrkBx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604882163AF
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 07:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734594391; cv=none; b=u41VGUNw/lx9QbhdUp7/dxaxignwUqyt8iM9VU+Kn3kGwYDTVnQWv896j+hVa92PHyXWRto2rOjmJyDM0+wrlNxExfuf4vh7fw0u5nQ+Xx3U0nl4iesHpkCoTlXA2lfusAjJeE1PXnCurqZLXl3fNh5yndxNN5ChY1L/EWh6W4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734594391; c=relaxed/simple;
	bh=7somDA3en/hJolBi8kdko15hS7Vg45ntK/V1RkSgs4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t9VSmF9ptg1lnsFr+jdZSuDOTZbyZLdbfvsVdZJyQ9obk12QrmlG4R7bDTMAtdj+Vc00bX/C273ab5ACKDnwHCHOM6fHtWQre5Gdg9Vn7Uip2OE7z/rNbYzG1Yi7XguqMbA8l8hejpzG9PczxC5cxJCfUMmbmilIX1qWhWrwOMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=fNtPrkBx; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-844e161a8b4so15131039f.0
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 23:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1734594388; x=1735199188; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FzlfxWAFyTOjTnsD6DMp9PLLcJQhroXi6XJ0Ja4jKS8=;
        b=fNtPrkBxghH49xHCTr69cdcSqidEDMMiFD52lk9xL/LNFTzR3ktQUnJ60kqHpy8+Jl
         88LTjAK//boS0ZHZ1yYHhxvFM9WN3powY0nkj9n+V3tHS2QeSn2lFxbKdS99IiDAH4jr
         0R7AxQihNjiXO3Pw7sW4p4dcFj4LjXaRyfHRhAzDRBm8tinH9ExzvbtG0rAAVRXeZzHc
         SlhjviBBZkgps+t+bVlWKBrR6t8MHSq9zYBhEg/v/PibsdGjgvvT/f7T3C58xblGqWG1
         d2kfFp+BDqlcgkEJfHFrMBWs9hqAQsNvZ59l+abZlb+ToicjWe8zYOM6fjxdIN5j8NlD
         BlHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734594388; x=1735199188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FzlfxWAFyTOjTnsD6DMp9PLLcJQhroXi6XJ0Ja4jKS8=;
        b=KcLIZaxFooqtlXjXjBjB0T/rGECL6gk2EypRAPlwB4b2hhJ1BJwo/hnYkpeskGz+En
         R1coqiVtVtjKSrop3LzrOi94QnTjK5w5JtE77xCz+QkdGKQktaPgOdAJEdNAR1zGjQIE
         1yenMuTOGV+tFw98Z7SwldA/EqHhqOh2LaOqfphh3d9sMYwMtekmsPPaKlhgSWPHlQAE
         h+U5g1YRSeO1k9+WF3GoNj8Maqrk1xb2bhrsnS6ZWNYB2t1jpriYW3zTf5VqAoQQWc+9
         x768tWc95PfboposklWlFIC5S5SgWieo18SSozecJq90ZR4kBYYFYoqGkcyWSelmPsQN
         J82w==
X-Forwarded-Encrypted: i=1; AJvYcCUI188pVjpUH8b3MOzmRcrJMhcvBV62cy3AUYtMJLMQvVReTu2QuC00f6y7jlj5qORgLJQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YytJ9vlDR9H2crEXyVM1tJpkavEDpPL6iCqBtsocyQcas/mFtpV
	/9dujRR/wII8nwvZ9t9n97vvEcLZe0p8KxxW7rs3bzA7OonOr3i837eSa01Dmn225COBzWIt3ew
	uaye7vcs4cSPYQfIiPHtcJ5ZMu3t4gziA7fS4DA==
X-Gm-Gg: ASbGncsiyHZpqO+Sw+jO7NmWkBF/42jKGQqPFaN4AVZdV7a7WTVc2My8NPwTr4JUNL3
	Spb3iHILKim6B2aKJ0DB1mrr2s+27Q9AjJrvbs4OG
X-Google-Smtp-Source: AGHT+IEl2VHIINWWOqX/TIjrPphy37QQEWpY//lPf2cQsAGp5Fr2UzQ2zg1QergkXg+gvTvXBtQ46kjIk7rWXXu2I5s=
X-Received: by 2002:a05:6e02:164e:b0:3a7:8208:b847 with SMTP id
 e9e14a558f8ab-3c014994c32mr17541505ab.22.1734594388418; Wed, 18 Dec 2024
 23:46:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240619153913.867263-1-cleger@rivosinc.com>
In-Reply-To: <20240619153913.867263-1-cleger@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 19 Dec 2024 13:16:16 +0530
X-Gm-Features: AbW1kvZvVibTIPOmSKzCzxVje5Rw-BrkbRTFTVX8TQ75LxnNOw1pz_vbOq-3DA4
Message-ID: <CAAhSdy0NkNgZraqnrTGtGYn-aM+tJ8hhGF4n3U+JP+VOF2BJfw@mail.gmail.com>
Subject: Re: [PATCH 0/5] riscv: add support for Zaamo and Zalrsc extensions
To: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Shuah Khan <shuah@kernel.org>, 
	Atish Patra <atishp@atishpatra.org>, =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	linux-doc@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Palmer,

On Wed, Jun 19, 2024 at 9:11=E2=80=AFPM Cl=C3=A9ment L=C3=A9ger <cleger@riv=
osinc.com> wrote:
>
> Since commit e87412e621f1 ("integrate Zaamo and Zalrsc text (#1304)"),
> the A extension has been described as a set of instructions provided by
> Zaamo and Zalrsc. Add these two extensions.
>
> This series is based on the Zc one [1].
>
> Link: https://lore.kernel.org/linux-riscv/20240619113529.676940-1-cleger@=
rivosinc.com/
>
> ---
>
> Cl=C3=A9ment L=C3=A9ger (5):
>   dt-bindings: riscv: add Zaamo and Zalrsc ISA extension description
>   riscv: add parsing for Zaamo and Zalrsc extensions
>   riscv: hwprobe: export Zaamo and Zalrsc extensions
>   RISC-V: KVM: Allow Zaamo/Zalrsc extensions for Guest/VM
>   KVM: riscv: selftests: Add Zaamo/Zalrsc extensions to get-reg-list
>     test

These patches conflict with some of the KVM patches which
I have queued for Linux-6.14.

If you can ACK these patches then I can take it through the
KVM RISC-V tree.

Regards,
Anup

>
>  Documentation/arch/riscv/hwprobe.rst          |  8 ++++++++
>  .../devicetree/bindings/riscv/extensions.yaml | 19 +++++++++++++++++++
>  arch/riscv/include/asm/hwcap.h                |  2 ++
>  arch/riscv/include/uapi/asm/hwprobe.h         |  2 ++
>  arch/riscv/include/uapi/asm/kvm.h             |  2 ++
>  arch/riscv/kernel/cpufeature.c                |  9 ++++++++-
>  arch/riscv/kernel/sys_hwprobe.c               |  2 ++
>  arch/riscv/kvm/vcpu_onereg.c                  |  4 ++++
>  .../selftests/kvm/riscv/get-reg-list.c        |  8 ++++++++
>  9 files changed, 55 insertions(+), 1 deletion(-)
>
> --
> 2.45.2
>

