Return-Path: <kvm+bounces-51170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB9DFAEF3E5
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 11:50:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BE8C17D3AE
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 09:50:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C161C26CE12;
	Tue,  1 Jul 2025 09:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="roV3kyDI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F728221281
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 09:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751363408; cv=none; b=B+AWdkJRxZP/09D4YvFwnibMtcvGJ3N8ed5cnXBy5Pzugxlx9i+BYLkbl5tzC//qVEdNRH/GWGjYy1CyECJD/wlXwGbuj/RMAyBGkcQOZmjIJmstKr66NMu+Kyrf1/qOB1/+heEBdzW8Ay0cuiobGLJq+7ypm4e45lINpaCjt48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751363408; c=relaxed/simple;
	bh=ORvhDZdeASgYBs421oKXzbRczxFZ8SqGGBDNBD16Gxo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s87Bc2k9B4FkqhWTK/aYYcey4u8KFhJlG/zXKyf2JPBhpjmlQdqt//VDx5KZBBJz4ni2+8d+8Ceuyo8/vwigoJQzDwlHeAnEDxWn6E/AfXRuRAirHX9Bij7uW0OM0L1jfr+m6H5fFXB6/9vxDB1IrlUfW/mymAC21vSelIlPsis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=roV3kyDI; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e740a09eb00so2209431276.0
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 02:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751363406; x=1751968206; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L3ead+uizm1Vc976UnfrINanFTxCKtIjchE+tw+EPsA=;
        b=roV3kyDIZBQ/rjfgAeEYw2swKto7DvMWuXT4U/Hx0scveaNhr3lamXysRleH2y+1xY
         fJBhbK49Kz+9GSQDoqIjOdcwudPfqcSR7R02AGV4B1jaSGc6ooeYfZLe7Kb0D6VPlVRd
         H32jeTNH1EPbr0xYMjho8o5Lx7QQspGYOncqpivRjHx66Lw11VONKwRSEQszp76mp8e7
         qp2X//TLDLioNEuz5vjU03v5zUbeaTdmlETga7ry5HvHeUu5Pgv9wrPLnIj6mtPy+4Lk
         lss4o7Pp2+bDMeJtcBnALywwj/P64iXpjRY9MjgSwntca0JX5VtFyow3LLctzDb2b34q
         1Gyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751363406; x=1751968206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L3ead+uizm1Vc976UnfrINanFTxCKtIjchE+tw+EPsA=;
        b=sdmd9gzXGmV0Fd5GeD3nju08jv6DySFaBzppLU1yZ5huRbNPX+YrzbeuaHjfnGXBRW
         a9dw8hVuGPXNZz8MzxSKOmHOarra9BngrBjmvvux4/o8thpa17TIUeZokGXcCP+cYtyc
         e208tPMXXcNXhZiict7X6uBRENjcIMRShEZJkuh6apSE5YFuK8Kkt5eNRiIvii9Psl14
         sbOyR9Qc1m2fYDk37qLUYivdX4MvtfamFA+2wKR2bZfSkNxw0776Bgm80Zj9K6MeKxzm
         SeGbdRfb7HeWBYVP+hTMjVuBvl7ttWSyAy08calWTpChvgoclJBwhKX8GPXkSEqFvfgL
         kbmQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/si3VaU7e14Qb/7YIGwqmlbAqkgliYvKEFqvlJWLKKU+V2lwtn1wBgBfati8RvJgE8FU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsC8WEX+OXmcWFzZ+c/+w9eoxdrVDL6izUNcGjQkrtfqEuQYJR
	fUzI/oODG5IA5KhRpwvS9D2IGyoXVwTuyFiS0H9H47wQTH/qmkL0TQc0RBK5Mxz4n3Qa1uhVkls
	qQzvNoep9/ikT1jtMb1NoZHUfebkWjH9LeWDdfRx+iQ==
X-Gm-Gg: ASbGnctL6AdUGsbz6mz/Jjqtsc3LdmocNdpEAEy98XOlJiaadcTkSe1I/qfB2kVzv0t
	siiXNHV8VZlTQx53xEyGxcm9yXz4UbgeufT/fdXJtcDZvTpJyMsMJlHX/7Sn3d1ljGJ+dXByIat
	6wn5g2azvRuHvF01r+Zkx59lS0azUgza77QBWAPuzuhKgK
X-Google-Smtp-Source: AGHT+IEgNBWX5tGLtftpO87ft/BiEpcXC82wrB1DaQaCVscRFjWWJgGUjii5r8i+5yiViziGpgeRsjHaIy59eNovzCg=
X-Received: by 2002:a05:690c:7442:b0:711:a4af:43ad with SMTP id
 00721157ae682-71517147badmr235251117b3.14.1751363406075; Tue, 01 Jul 2025
 02:50:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250623121845.7214-1-philmd@linaro.org> <20250623121845.7214-7-philmd@linaro.org>
In-Reply-To: <20250623121845.7214-7-philmd@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 1 Jul 2025 10:49:54 +0100
X-Gm-Features: Ac12FXyuBHFyZZaOxyOwWqZE-W7vNcGgM_jfizm0gIVdy-6YVWg7T5T5DEF9PnA
Message-ID: <CAFEAcA9ref1SFd2uPRBBjyg=eph+GptWxoyURxMZj8aSVD7zAg@mail.gmail.com>
Subject: Re: [PATCH v3 06/26] target/arm/hvf: Trace hv_vcpu_run() failures
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Leif Lindholm <leif.lindholm@oss.qualcomm.com>, 
	qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Roman Bolshakov <rbolshakov@ddn.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <agraf@csgraf.de>, Bernhard Beschow <shentey@gmail.com>, John Snow <jsnow@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, 
	Cameron Esfahani <dirty@apple.com>, Cleber Rosa <crosa@redhat.com>, 
	Radoslaw Biernacki <rad@semihalf.com>, Phil Dennis-Jordan <phil@philjordan.eu>, 
	Richard Henderson <richard.henderson@linaro.org>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jun 2025 at 13:19, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> Allow distinguishing HV_ILLEGAL_GUEST_STATE in trace events.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>  target/arm/hvf/hvf.c        | 10 +++++++++-
>  target/arm/hvf/trace-events |  1 +
>  2 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
> index ef76dcd28de..cc5bbc155d2 100644
> --- a/target/arm/hvf/hvf.c
> +++ b/target/arm/hvf/hvf.c
> @@ -1916,7 +1916,15 @@ int hvf_vcpu_exec(CPUState *cpu)
>      bql_unlock();
>      r =3D hv_vcpu_run(cpu->accel->fd);
>      bql_lock();
> -    assert_hvf_ok(r);
> +    switch (r) {
> +    case HV_SUCCESS:
> +        break;
> +    case HV_ILLEGAL_GUEST_STATE:
> +        trace_hvf_illegal_guest_state();
> +        /* fall through */
> +    default:
> +        g_assert_not_reached();

This seems kind of odd.

If it can happen, we shouldn't g_assert_not_reached().
If it can't happen, we shouldn't trace it.

But the hvf code already has a lot of "assert success
rather than handling possible-but-fatal errors more
gracefully", so I guess it's OK.

-- PMM

