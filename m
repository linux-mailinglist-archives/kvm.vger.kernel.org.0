Return-Path: <kvm+bounces-51104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D1CADAEE28B
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 17:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80A07189C473
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 15:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F9928F519;
	Mon, 30 Jun 2025 15:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EEV9FGk6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF7828DF57
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 15:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751297534; cv=none; b=SsVNZZlk3ai8wGhAojPhTQzD9g94fD/lHOHPEClPbT+uT/pjIffD3TAOaCfby/NsvAXTJllbymw5uB00ehChZQUcJcZdgPexVYoJ144yDSgBAu/NEBKuQXNA0zjEMXDy83upYDj5e8dNv2tncFEsIySekbIrEir/u3WwvKorKr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751297534; c=relaxed/simple;
	bh=5g+sPvZQwXMI7z4ufzp/sNUI9WPbrfof25BYbxbGChc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qJpUl2pc9CCraOFqhiojSYnO47LcRK4orMwsbjd6JjhsVD5W0eT0LYRkKHjEqbL9wX/C82s78TjYsYUpaP/YWd1n1UpvtcuttHA86druFVyYyR16N7aHhS3a7Nq/YAncDglNY1eAVyY9bADanOjnzh6obX4Au9gF3bbri6ZjHD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EEV9FGk6; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7086dcab64bso20258827b3.1
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 08:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751297531; x=1751902331; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BBv5z/VpiWqm6TUtxvPZN70k+f7CGqEYeEiw2nVISzY=;
        b=EEV9FGk6HL/Gm3vmbY1DFjAEEGz4XqDDP3NcbeyT+2bVGy3irx4H0eW4XXzI+Ibcrw
         Bk0iG+Im8xIPeYRZuRtVCgJvvRO6SgO8qxpvakdxLaUeIwg59QvbF3TQqfVMXaxK/fEz
         lSPciYyaYva0OnSlUXQLjNlERE5Fq4sV73ECPjLjgLSNTa28z8hQUL6i/P9rY4I998Iv
         NDrxYxv9bUB8TN1iYdXWxNrYXqzFPbl/xsvdxTl2JI2f1ra1cvnTa3rJ8YNHxnPAYQwQ
         bjydepFxlROqikGDKdUi5mGJDvW/qJwNT+n3Wqrh10iBo6HBmYhfWWjqxZcIoKGEQ88J
         FaqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751297531; x=1751902331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BBv5z/VpiWqm6TUtxvPZN70k+f7CGqEYeEiw2nVISzY=;
        b=S72beXsY0VOMWdqNP5p42DXaeSF/zZuzPy5VXpu6piiCPY4AwqExv+akW7+K8UcqZt
         G2Cnd1pPnQr5RN4/FfV4VcgqkjkTzC7lZRezfyTaKIVK2jnjwTtzQJlnsSiXZX0WK2Lv
         ryX0bWQGQHOcf3ksY9wegl8ga8tLqhxf75IpVh/847sHqmdFX+kc3IY0mQcO9BBOTJ7s
         KANFa/NfzhMA2MCHfIVFDMsu2oi2tsn8DIsnRhL5mzI9vBnYGM7YpPRRi39Q4KySBFkU
         QzvwlZbjznc32tVExC8kf5AtnwXNwWk54bhkvGS2oASXO2hJ3ZZhVZmqzRE2yQBwj27c
         6Atw==
X-Forwarded-Encrypted: i=1; AJvYcCVJuD893ZhgzW9CV24w9WM/pFK9SquttVLrfEr4sgfqE0TWSpAhZP4+krKst0fdICPa1yo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww6nCBxCYaMnrh7gDos438MCx1H7pw1TgzNPXE9IkDTCR16Bni
	q/VaKjlnafTHMpV2qnlaFfkYEoaU0ZTn1Eqlsx0om364T+jxI5Nl30earaXtODFW+7deYlFvnO+
	oPaJk7GasYC3+ucdyABx1GjOk8ZFlvDSiH+lf4jtIqw==
X-Gm-Gg: ASbGncs4OHNw8sC4tvUpwfyTf5EGiHB9oREFEMK80JEUDv7Z+vPu4ytB3q6BxtD6iG3
	vNSYLD2yxDQDUouVsYyVu0Ancdx1mvH4K1HpR2Qjdrb6gsp3W32vEfZehrNkh9XonwEXAmtgT4A
	Z4TfSZChz6c39Zusc6zVpBCsFD168yo7JRCYkwSpV1Kbrd
X-Google-Smtp-Source: AGHT+IHy8nnqmhTcZqN296zS/GH2AzcmKJFgjhBGMvlHCoJRvN7kCBoPACAJDbr1konLbK5VYHH+YUoYt2nSk6mM5yk=
X-Received: by 2002:a05:690c:4b8c:b0:710:edf9:d93b with SMTP id
 00721157ae682-71517158331mr260393347b3.11.1751297531250; Mon, 30 Jun 2025
 08:32:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250623121845.7214-1-philmd@linaro.org> <20250623121845.7214-11-philmd@linaro.org>
In-Reply-To: <20250623121845.7214-11-philmd@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 30 Jun 2025 16:31:59 +0100
X-Gm-Features: Ac12FXxL7r8Fqtmkx3bL2CVmkkdzP7qpLkzAMPTSCdtXWbBVYPe4zZUG2yIbwZA
Message-ID: <CAFEAcA-fe_8qZFWjTAB3EGFpR6vO=fHj-yB7cV=CYgjsVgLOcg@mail.gmail.com>
Subject: Re: [PATCH v3 10/26] accel/hvf: Model PhysTimer register
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
> Emulate PhysTimer dispatching to TCG, like we do with GIC registers.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>  target/arm/hvf/hvf.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)


> @@ -1639,16 +1640,12 @@ static int hvf_sysreg_write(CPUState *cpu, uint32=
_t reg, uint64_t val)
>      case SYSREG_OSLAR_EL1:
>          env->cp15.oslsr_el1 =3D val & 1;
>          return 0;
> -    case SYSREG_CNTP_CTL_EL0:
> -        /*
> -         * Guests should not rely on the physical counter, but macOS emi=
ts
> -         * disable writes to it. Let it do so, but ignore the requests.
> -         */
> -        qemu_log_mask(LOG_UNIMP, "Unsupported write to CNTP_CTL_EL0\n");
> -        return 0;
>      case SYSREG_OSDLR_EL1:
>          /* Dummy register */
>          return 0;
> +    case SYSREG_CNTP_CTL_EL0:
> +    case SYSREG_CNTP_CVAL_EL0:
> +    case SYSREG_CNTP_TVAL_EL0:
>      case SYSREG_ICC_AP0R0_EL1:
>      case SYSREG_ICC_AP0R1_EL1:
>      case SYSREG_ICC_AP0R2_EL1:

This adds three registers which aren't GICv3 registers to
a code path which has a comment

        /* Call the TCG sysreg handler. This is only safe for GICv3 regs. *=
/

In general the TCG sysreg implementations aren't expecting
to be called for non-TCG accelerators. I would like to see
some analysis of why this is OK for the timer, please.
(Compare commit a2260983c65 which notes the limitations under
which this works for the GIC registers and had to make some
minor changes to the GIC code both noting that it might be
called for non-TCG accelerators and adjusting things so
that would work.)

thanks
-- PMM

