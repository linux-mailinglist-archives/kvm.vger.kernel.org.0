Return-Path: <kvm+bounces-53493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 071BEB126F5
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F4ED17B752
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F552472AE;
	Fri, 25 Jul 2025 22:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BezQRn7U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E973A21858A
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753483153; cv=none; b=TlTUuZe+LfF+rjedfPiHCVGy7En9mG6DknIWbuM+CjzWaEP6wdPEenMeKhlCithDXeS3b0OLE/2sXOorPWfBn1KuelG0HDtfpB3vEt/oWLIXCR6zQEaAqG82cewsSY/Ax8Mkv4ioQMTNz/UU5oh4pxe4+zJcJO49dGqWB2lZb9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753483153; c=relaxed/simple;
	bh=D7Oa2WAJGVlMSA3lhM4bJCeIiMf/9/5+L3BSd4d0QzU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bzlPTyXmxYx+KXHFCKM6sK4Jq97vNklWIOwGx07OcAv7mLbq1Ig9aKJhnG9AUO5X+jHZU+lLoKkCf28L8kNQh/190qODTOxiyM6vJWlUIt+vYS25kmmqj1SB7tCVCk7/7qviq/UapVjkA86mTUztp58u7qSTtp7I9OJhql97hQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BezQRn7U; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4561b43de62so28515e9.0
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753483150; x=1754087950; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iv5k4xFCPNa2vVbv5IcTsLR5XM99RD3akb1r63WqZv8=;
        b=BezQRn7U/69q6Is31ApptBVatd4yL7R8hPcNGKH6MRpob3mnTkviGIBaP4HW8esEMl
         URzzzKkkVES9gPmXbFTgvF1yOSmaOKxvSu0O0S8EEI3xMT6yAYX+5rSRaLqwHssAiXMH
         2Wmbgyc7DWlEnujJkpprnZFzkQmonQ89Z1C1gkLzT1J+CIQc6+WEeksK9tOXJm10ORLk
         lRwI7T+nEHkaFOo5XY89EMwIxTRaTFWWkD5Y0CL/PRvfVJKZ77JilGN++N0wXdFD1hF9
         IQWvooIbJkcDpOasPEHRoobRk/VzY3Dwp+DYN2hHlA9HIfWAEbrgaaYuFEQy/GaV4gcQ
         PG7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753483150; x=1754087950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iv5k4xFCPNa2vVbv5IcTsLR5XM99RD3akb1r63WqZv8=;
        b=hfaHfOLpzRmwJOu89WsLC/AAh2R2xuNBjjQeXVybSwGxdofP1a4/5yze1iZKUokVDZ
         hVN7AEo8kcD3wCZVeDoRXbtLZzCUL8glvwaczG7Ey0XZL+kav+kEiuOpDtaPpPzz0EGZ
         3fQR55LQpTvG4oGokkmNo81qnlGE2aOwSAQFQO+RA69IZUTFwqM4FbsmiD0Y4M8EjbhK
         gPByiD9LE7AQZAqWtkUtOE2k3ay8Zn0m5sqRGOpZR0uhYGrzaccjYBSbtZNZ+Esp3MCV
         8f4RGfi7zPJZonx7hnkoVFi43RGf0bHacn9FTMCPAzJukWmg4hDn6STDpHotMQr/GMpw
         OyJw==
X-Forwarded-Encrypted: i=1; AJvYcCUIdDmU2L4SPHuTqX1t9hSHcQo7/6U5ouk2sbi3B7cwhL1Rg4Dur1CdYrklS6pP1FfstQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxowwXmIzlfzpSbfIDjgY73sQvmXQAkdXpk9u00CqDqbuVZmGwL
	fq8vai1KrNRJlb6pvHUUAgRo8hZ9hHl9O6SLmGiziuYpcH36ttmxpuKrxaM7IivaT5WW9vMQ9rF
	EiZrDJjhoQ7vP85Vt7r11zsRz2sAwdskMCaEuuUL9
X-Gm-Gg: ASbGncuYRRPZB3eOggYTv28Y5haGL1Kt6Y+U3cyP9s17rmgSm/XaB+txtyw+pCmt8J8
	ISuUj4QuHweftlCxwZCV3hMvTy0hrwSTwK4CvwAZmYD5TbLDzRTWXbCGa7c+ZVl3t8ETTnxf4O5
	JEbNv5vdnmHYMTu8nHE6kdI3+9sji+5X5Qk2PjahsuzI0pr2bdKUOpo/v3TIglaeU7qXVZnxr+2
	NdjIEMR6RzDPOxLw77LCFBNcgt2czvJADDGYjTRUufcflf25OmX3PLXQYo=
X-Google-Smtp-Source: AGHT+IFMklkHFcOXioyAx2d0bqd4nB4JNFNX2aKfodywqbYpQlwqoLGHp/pEpvS+ZJk2Fn4BDruQbU0An+mgiPGHPA0=
X-Received: by 2002:a05:600c:820b:b0:453:65f4:f4c8 with SMTP id
 5b1f17b1804b1-4587c9912dcmr147085e9.3.1753483149860; Fri, 25 Jul 2025
 15:39:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACw3F53VTDQeUbj3C75pkjz=iehbFCqbrTjYbUC3ViUbQJAhsg@mail.gmail.com>
In-Reply-To: <CACw3F53VTDQeUbj3C75pkjz=iehbFCqbrTjYbUC3ViUbQJAhsg@mail.gmail.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 25 Jul 2025 15:38:58 -0700
X-Gm-Features: Ac12FXwS4Wnk13CURRl5JaHGtZNdLdb3q8MbCL8zJr-EvUjIvukDMA9G0Jg_u2g
Message-ID: <CACw3F50O9Z=hPFNzeatzr2k+1cKX_nnqdzKJOMEdmjmfy3LoUg@mail.gmail.com>
Subject: Re: [Bug Report] external_aborts failure related to efa1368ba9f4
 ("KVM: arm64: Commit exceptions from KVM_SET_VCPU_EVENTS immediately")
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2025 at 7:00=E2=80=AFAM Jiaqi Yan <jiaqiyan@google.com> wro=
te:
>
> Hi Oliver,
>
> I was doing some SEA injection dev work and found
> tools/testing/selftests/kvm/arm64/external_aborts.c is failing at the
> head of my locally-tracked kvmarm/next, commit 811ec70dcf9cc ("Merge
> branch 'kvm-arm64/config-masks' into kvmarm/next"):
>
> vobeb33:/export/hda3/tmp/yjq# ./external_aborts
> Random seed: 0x6b8b4567
> test_mmio_abort <=3D fail
> =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
>   arm64/external_aborts.c:19: regs->pc =3D=3D expected_abort_pc
>   pid=3D25675 tid=3D25675 errno=3D4 - Interrupted system call
>   (stack trace empty)
>   0x0 !=3D 0x21ed20 (regs->pc !=3D expected_abort_pc)
> vobeb33:/export/hda3/tmp/yjq#
> vobeb33:/export/hda3/tmp/yjq#
> vobeb33:/export/hda3/tmp/yjq# ./external_aborts
> Random seed: 0x6b8b4567
> test_mmio_nisv       <=3D pass
> test_mmio_nisv_abort <=3Dfail
> =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
>   arm64/external_aborts.c:19: regs->pc =3D=3D expected_abort_pc
>   pid=3D26153 tid=3D26153 errno=3D4 - Interrupted system call
>   (stack trace empty)
>   0x0 !=3D 0x21eb18 (regs->pc !=3D expected_abort_pc)
>
> It looks like the PC in the guest register is lost / polluted. I only
> tested test_mmio_abort (fail), test_mmio_nisv (pass), and
> test_mmio_nisv_abort (fail), but from reading the code of
> test_mmio_nisv vs test_mmio_nisv_abort, I guess test failure is
> probably due to some bug in the code kvm injects SEA into guest.
>
> If I revert a single commit efa1368ba9f4 ("KVM: arm64: Commit
> exceptions from KVM_SET_VCPU_EVENTS immediately"), all tests in
> tools/testing/selftests/kvm/arm64/external_aborts.c pass. I have not
> yet figured out the bug tho. Want to report since you are the author
> maybe you can (or already) spot something.

Friendly ping ;)

>
> Thanks,
>
> Jiaqi

