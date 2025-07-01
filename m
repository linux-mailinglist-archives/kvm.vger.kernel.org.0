Return-Path: <kvm+bounces-51168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1651EAEF386
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 11:40:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB1271BC641A
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 09:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD0C26CE10;
	Tue,  1 Jul 2025 09:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kd/4D+uD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECDC26CE09
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 09:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751362793; cv=none; b=FR+LkpJPVWGgdOZWkClq9kMA2rS8ngjJIbLcN4TN2Vpr/KnKyNa0CfUXBAamC0DhXfJW0S3MhhmDNPsGZUstoPxSA2L/QFF8CZwMUWibx3CC/WOXgdgVSd+72wumbQuemVKT8GcF+tP8L+huE7NIv4XwpZI3bHUDdq2FXbvQ9Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751362793; c=relaxed/simple;
	bh=3y3b7bhFZfSWP4Aq0SFEO4wU0GrFVtm/6TcsD9zGbW8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YinBc8tOHeyHXJ4kVccf5CgXsknSVZeQUP/T3/4wy+l1S7sCE3mz5BecTGQH286kASapJ+TXa4rIktEZKa3MA98uLaE7+DXo5QELshmtXs3ZEnZuWV2VZ15XWztLmZQTjVMjShhT4Jv6b8iaZW6z0urQNFTTbcmB9i0tBjd64rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kd/4D+uD; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e733a6ff491so2684322276.2
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 02:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751362791; x=1751967591; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yCOcQLmgdtfiHoEGzlEjIWzRramti7JO+XwYRKwRFyc=;
        b=kd/4D+uDylevUFYvCKA01n/jI3zxfJ+8HjOtiXVifzUeGsyETxB6gkD/hySMC+rsAU
         iNHE/yASwevJCFI+DMmwN/2+tKA7yIOOIa2cQi5frgiDFFUehd20klKAqZLgQdpL8ArU
         CAf5GEGiU9y20+LmfqlQ8QmrlNbQDdMdV7Rf14wvgVW3rI8uPbE+tnBF3vri+sS7vRfz
         Eha/YjyEgdjpgX+TW1Zcc1QOgghSkau6cFz5w3cqXaqPM0iw8+16F4vIJRBuQ0dBWwAn
         ID5j/OKP5dA1WB/kN2zow5iz3ctwe5Tq76D/R8+9xlCfJxKGWz8GVu6V7lx7hs9jn8rM
         rK9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751362791; x=1751967591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yCOcQLmgdtfiHoEGzlEjIWzRramti7JO+XwYRKwRFyc=;
        b=otXCH5cftM6aVVjzHztPMqDjBRSFzx05/QhnhBGyXq9Fkuwl3eaEUmLtC2bXfnxVW5
         elV+gLpbS6v8jA2N5mS7I19QdZuwG11+OK2kPiL8gDYvx4GuOODRZqm1jbIy2ZZeENcD
         TVnA5FEQhv8EPxDs3WvRVAqW7IEDcSiZqqcyiJuTmfLn5blQb9Pgt4ybSR/jwWLCPGWJ
         U9I5iIEbv7jzAxcZy82YW8gnzGodkUW7rlV432fMIO0/T6Tg1DF13CgnrIsQ/U4LmauG
         6Bveka0M7hbmj+Wl6zMTdH6kDGP4BfeGG6ncpgMiFi/RYbXMSRVIDTWSG1KgK2PDOOZJ
         AGgg==
X-Forwarded-Encrypted: i=1; AJvYcCVX7B70+vM0dYDmw5IGWkkkFARbfAcUW9fCPkIIUySNelx2hX+vZAIoOH9n1/F3givkEwc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh5VUjsr2KpvD54PgYE/gG5xK/sFHOjdlWLpCdjVfQ0VXxBEGy
	3+kWgIczTcDoIs0idjBoWbNGzx+sIGcEgxTzkUkM8DoalxM8I4L9UZltI3lOyra2SA0Ww/Tpy5T
	J7J9d4Q1qq2zr3TXL5XubXWfuwhJHniJ9tb46Gow7Bw==
X-Gm-Gg: ASbGnct4dAUGzkXreCPsdpwGjkw9U480SWoM52XQCJuA3UQriebrhT+fPnV8m29w0FR
	whx8cOJUM2LQ49hquHGnCtZjxnsrkF64c3bIeMyE92eV6xlO/Jy/DgrWeCgjePfPHxLthQWKY0L
	G5bMdOeErORFDA9XgqtVYfPWo71frIfour0TK+eQaE4Uu6
X-Google-Smtp-Source: AGHT+IHDlq2gURbFKW5g1kNI0w9591f5lYZ70IA6CEkE0lSHka0P6ZqUiCTl2McDGmbd1GXnJnECbd53cRCfMH2DS9I=
X-Received: by 2002:a05:690c:7443:b0:70f:8883:ce60 with SMTP id
 00721157ae682-715171aacdamr245762197b3.26.1751362790962; Tue, 01 Jul 2025
 02:39:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250623121845.7214-1-philmd@linaro.org> <20250623121845.7214-5-philmd@linaro.org>
In-Reply-To: <20250623121845.7214-5-philmd@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 1 Jul 2025 10:39:39 +0100
X-Gm-Features: Ac12FXxpYnulxisO6QVKFIKPO-zv9Pwl_r62oxyX2ZYzOaAwSavLKRmqxWTN_Jo
Message-ID: <CAFEAcA8+9TPps4NkRwRTZXq-nkR=zJ1SsFLnMzzNf7MioU-qsw@mail.gmail.com>
Subject: Re: [PATCH v3 04/26] target/arm/hvf: Simplify GIC hvf_arch_init_vcpu()
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
> Only update the ID_AA64PFR0_EL1 register when a GIC is provided.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>  target/arm/hvf/hvf.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
> index 42258cc2d88..c1ed8b510db 100644
> --- a/target/arm/hvf/hvf.c
> +++ b/target/arm/hvf/hvf.c
> @@ -1057,11 +1057,15 @@ int hvf_arch_init_vcpu(CPUState *cpu)
>                                arm_cpu->mp_affinity);
>      assert_hvf_ok(ret);
>
> -    ret =3D hv_vcpu_get_sys_reg(cpu->accel->fd, HV_SYS_REG_ID_AA64PFR0_E=
L1, &pfr);
> -    assert_hvf_ok(ret);
> -    pfr |=3D env->gicv3state ? (1 << 24) : 0;
> -    ret =3D hv_vcpu_set_sys_reg(cpu->accel->fd, HV_SYS_REG_ID_AA64PFR0_E=
L1, pfr);
> -    assert_hvf_ok(ret);
> +    if (env->gicv3state) {
> +        ret =3D hv_vcpu_get_sys_reg(cpu->accel->fd,
> +                                  HV_SYS_REG_ID_AA64PFR0_EL1, &pfr);
> +        assert_hvf_ok(ret);
> +        pfr =3D FIELD_DP64(pfr, ID_AA64PFR0, GIC, 1);
> +        ret =3D hv_vcpu_set_sys_reg(cpu->accel->fd,
> +                                  HV_SYS_REG_ID_AA64PFR0_EL1, pfr);
> +        assert_hvf_ok(ret);
> +    }

This doesn't seem like a simplification to me...

Looking at the code, I suspect what we should really be doing
is setting the GIC field to either 0 or 1 depending on whether
env->gicv3state. Currently if hvf hands us an initial value with
the GIC field set to 1 but we don't have a gicv3state we won't
correctly clear it to 0. i.e. we should change the current
  pfr |=3D env->gicv3state ? (1 << 24) : 0;
to
  pfr =3D FIELD_DP64(pfr, ID_AA64PFR0, GIC, env->gicv3state ? 1 : 0);

thanks
-- PMM

