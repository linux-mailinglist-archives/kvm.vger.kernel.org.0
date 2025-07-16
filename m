Return-Path: <kvm+bounces-52634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97172B07584
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 14:25:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EAA5188AE19
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 12:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55EED2F4A1D;
	Wed, 16 Jul 2025 12:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="t+0ZoszS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E6C3C33
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 12:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752668697; cv=none; b=PtzA5yHLEQqdeWqvmSQ0xtYTT95K/MrrS02YHImROWocXUxIx+r1tHi9dCvS7S76n4eLwzwqj6rkkRlOcSq1JHXoSu1Wu15kNmyFkcnr03t+EOlQqZWZ0Ba4KVe5m7DH+Vxcmy9tLa+s77rOYKab+j9vj8vLgJhXwD1+BoeIByY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752668697; c=relaxed/simple;
	bh=QBmGc04qrGG+YLJBXEt+7DTVkRFbk8EiP5rSyfHg2qQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J1E4NjuOedPhFOSMBR3oOW4f7sR66dm5KIVqoi186QaDveB+Zgw9AqWHbd2JvU7fpT1Mq8b9WsSZJdjFgzpd1M1zFVWYnLMQp1iDxgxXzvkN6eA9PC1QQ3nHrmDivqGuL8fBXA5y4BpQgb4X/7Cn4ZJCEOCW2WoKQLY5fb+MheQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=t+0ZoszS; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-879399faac9so496480939f.3
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 05:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752668695; x=1753273495; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ufN3hObMca4GLsjT1dwHltCBaXf3kFOYG4s7v4Jw4M=;
        b=t+0ZoszSkPCglWi3xR/+KVV2Q4nWSFRSgVGCdv4s61JY+4Jl7AgYdpElBSES/d7L3W
         ktf4RKfp+3CF4tL2SfsgKScP0fa/npV55VhbzBetOvZT/6aCSsh0dVxb4ypO38jz3UKE
         QSLM32xmEEDd63CiahXXEXi0lOwD9cbD3qbOXCwbt8YAAg8zHEfvFO18zOc6qet5JfZd
         B0F/y7GZB8EF/zkAvzqmvFO7qI8d0sRqqzmNzq0VqiLhqEsnndFOGfW2tuCbI/HzgMeX
         z6H8TgGMKsC3vc+48+Sd8wos2992eklo7GQgSzuSiuHrFb1BoQY5e+2rihfTZRKHPL95
         xPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752668695; x=1753273495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ufN3hObMca4GLsjT1dwHltCBaXf3kFOYG4s7v4Jw4M=;
        b=tlv0xmlY38bPqHVfGzZKiPMxNxMA2jk8jGZS5fDAJnvYUS8urVm0FzJG/sFSUKLdiE
         FlGE2bivfmtYcJEGJR6RHKrV4TnMMiXQZF+2X9FALo3mC97o+EZoWoYS5XwNnv7uFx5G
         IzJ/eklikmYcHXilr/1W0KywVLK8pnjtC0/fU4CcPOf/TTsM93o/ItoALFIFqNz1JU38
         qgp8Ckces4+HkO+B1IxrY+YSSR8CqyN1bT4qHzaZfRBmvRUSV786rQGMRr40yRlzF34p
         x1hPPK8WcfDPS8Pe/xCDFX4sL5+RYCtMwdWrN/pkZVolsIzHfAhQjLLCH/QwSXrdFXx+
         d5uw==
X-Forwarded-Encrypted: i=1; AJvYcCUwdPGVlfU1+qEbigMkO0NG8Ehg8rABgQnYRzMfq6j/QU6nOEyMLsg6wEWTpiopQehb/wo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyALX1Ddt/YsiAhWaN7lF0bHOMjbUTjgWXw8WR4C+Pbbrr3clyQ
	WL9cSo0hyuv60klkBmjzTOlrStrvVucrjFtM6nJJaZ3v+0QT3J25bX0ppO3zYdkszoQrUaZM+wa
	M5XsBd8LW0x4YDxmDN/Y0V7eV15Ia6EpVxAYifedKhw==
X-Gm-Gg: ASbGncuykiv3r7DgeybzC3ZgdRbS7BFNAko010makqfJ5Uynl7xeqyM1NhiJvfLIpte
	wcwH3V7mp3le5+lO0IwUyJL4/A7Ytdvo0rzZDQMKSb1erYUOCEiYEzePDG8mOlahMnp9Lhy3CZE
	Wh4eUcUhpjMdY+0Sp9gZpr2BrBO3131eyR1KJmQtPUTdlU+30mt3sgvdxUbnyf8NeWv4u5konzT
	ebbgao=
X-Google-Smtp-Source: AGHT+IHcBKm14IqMY2zZCku6eJ3aL9uOlgyeZlrEeJEsEb6pBAtDYAiLwB4M4psg96+hNqoIYo09iBakwOdp9w74hpw=
X-Received: by 2002:a05:6602:154d:b0:879:572e:238c with SMTP id
 ca18e2360f4ac-879c091cc40mr370204539f.9.1752668695035; Wed, 16 Jul 2025
 05:24:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250111004702.2813013-1-samuel.holland@sifive.com>
In-Reply-To: <20250111004702.2813013-1-samuel.holland@sifive.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 16 Jul 2025 17:54:43 +0530
X-Gm-Features: Ac12FXw5fRuKRk9Gh9hKxwhWqS2DR3ZACynLX0_VX_3TVKCKPIkjC2p2q_9ELUM
Message-ID: <CAAhSdy2x+bskK2Du-ys7TCeih=QEFRkkydg2VYGZniEt3zW3=Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] RISC-V: KVM: Pointer Masking Support
To: Samuel Holland <samuel.holland@sifive.com>
Cc: Atish Patra <atishp@atishpatra.org>, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, Albert Ou <aou@eecs.berkeley.edu>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 11, 2025 at 6:17=E2=80=AFAM Samuel Holland
<samuel.holland@sifive.com> wrote:
>
> This series adds support for pointer masking in VS-mode inside KVM
> guests using the SBI FWFT extension. This series applies on top of
> Cl=C3=A9ment's "riscv: add SBI FWFT misaligned exception delegation suppo=
rt"
> series[1], which adds the necessary infrastructure.
>
> [1]: https://lore.kernel.org/linux-riscv/20250106154847.1100344-1-cleger@=
rivosinc.com/
>
>
> Samuel Holland (2):
>   RISC-V: KVM: Fix inclusion of Smnpm in the guest ISA bitmap
>   RISC-V: KVM: Add support for SBI_FWFT_POINTER_MASKING_PMLEN

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Rebased and queued it for Linux-6.17

Thanks,
Anup

