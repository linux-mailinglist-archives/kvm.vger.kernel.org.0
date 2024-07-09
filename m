Return-Path: <kvm+bounces-21165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA10692B3EC
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 11:33:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03F2B1C2266F
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 09:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3631F1553BB;
	Tue,  9 Jul 2024 09:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KGNwC43e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDEE153804
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 09:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720517623; cv=none; b=dZ+j0y+Z3fM0Dm2oUkqFEOO7SuWxDH+bNXP50WxRnOd47SdVSfSo8CVkgFXG6xsHFMJETgBtRdwc++Bv1L4c7sHOvuoTRRxG24vlIP4A1cfd/25kFfzgO5txX1dWSS691Sf1YvLj+KE69bLlJ2Nc6/NvUVH5krCl9WlGh6yOPs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720517623; c=relaxed/simple;
	bh=+xcr8lVk5DQWKm02mR2wuHFeFqcIGe7Zvl7Mk7cd9H8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R1rpwbwBAIiD5b77OSCIaTMCtGLKOeOrPaFd7rQ3Ru9/QKfOz7e7g5PhB1WkaC5UGWvcxPt0uh1hyJXRJW8Dps+wO7cTQ691U1poYpaF/ZEL03IWJ+ynDZrpTr5b/2PYntkisSp2263COSRYIBpi9qPeMZ/S+3loo/AfnGwWDJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KGNwC43e; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-58b0dddab8cso7244092a12.0
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 02:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720517620; x=1721122420; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bbVjctvLXXyMcZGPi8Rzn/blROwKULMdZPgFn3B+fF0=;
        b=KGNwC43e/WOTvUBXRWnuAur2jvFcFlJd0DM0uQAecAb09UiV7suaKOs8cHFWvsgSC2
         J8aXK2V1DAy1GHXjhKmx7a+uywMbpBvMl8iuq2u5bCLDmifYhI5GHbx/OxBqVIx6CrvB
         bDqFL+EV6Wnh9eZtBD5OlEyOBN9pclUOaBEwLJEIPfV+AYxHm90vUn8w7C7vHnxXu5CX
         i0jleN/OQt3++3SmXItlBuU3XbXSG+HCraPOmNKGcbV+M6Xkv1oAiwTP37+/ObYC6OcL
         HeCDN0DXbQmlfTDjpxaBg1XVjw1c3q2lBeYRq8y3ER/B1J6eNMwFOH5cS05JiXOwOfFn
         yEgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720517620; x=1721122420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bbVjctvLXXyMcZGPi8Rzn/blROwKULMdZPgFn3B+fF0=;
        b=JEdu91J6AHb0iIOHzBUutt5tyHKQeK9HJSIcekkPRn6MQimaQ45Mau6IhwQ/reW7OC
         fvCEq1P7ln/tuME8HcT0cqorlH/A4NuloUiO6FG4PG8T+tQqTX42cis6bX56/JZTnXMv
         /6306Jp19L5CJ7jaj4ljQK0JcN135k4rnv7BJBNqogPA3tGAE4393ZjQkgRXm+v1WwjJ
         RIuexj51fWmEgVtlGsVItkUX44AZv0LIY6ojCs6RXUe0EUHD58wNYopCjERdBk2wbRHf
         6Mj0g8MbU/2nT+zLhUa50AozhqAFvZsuXuwEuYHqozWtUxKHLJxH7ZYx70wif6I1y7L0
         u65w==
X-Forwarded-Encrypted: i=1; AJvYcCUMpIoMojUxI1cOoIz6xJmXSl5o0OWheByL+mZZ4tBRbewF3CHrBt6dAadEx8jA5CcGbyyqEiH0xiP2dSNnjAoQIUH4
X-Gm-Message-State: AOJu0YwzuFX37+thQ36SsLmj0yHR1n8ptdkoBIpzgtNpZ65cu/6Ue8KL
	XmUx6WtBH8jDdjP5ypFoJnldfHy4By1oCpkbSVru3rxcCRshCJLl9usBjN/gfgsUVRilluJG5g+
	kIYtnw/QTMyXJAJAAP4MAWtgxgAOhBQk0fH6QDw==
X-Google-Smtp-Source: AGHT+IEqljXx2JIG3odC0TZPvGH0S1XjoUQIcTmvsx8pPi2YJJHZXULcFmWZ4T2QD5eT6hnsCNvPIpRKmpFQApbwFJc=
X-Received: by 2002:a05:6402:b19:b0:58d:842:6272 with SMTP id
 4fb4d7f45d1cf-594bb67e9demr1055765a12.25.1720517620131; Tue, 09 Jul 2024
 02:33:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
 <20240702163515.1964784-2-alex.bennee@linaro.org> <Zoz7sQNoC9ePXH7w@arm.com>
In-Reply-To: <Zoz7sQNoC9ePXH7w@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 9 Jul 2024 10:33:28 +0100
Message-ID: <CAFEAcA-LFtAi0DkFGc0Q3TYR_+X3TUWQru8crhbKun4EHctcdQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] arm/pmu: skip the PMU introspection
 test if missing
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, pbonzini@redhat.com, 
	drjones@redhat.com, thuth@redhat.com, kvm@vger.kernel.org, 
	qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com, maz@kernel.org, 
	Anders Roxell <anders.roxell@linaro.org>, Andrew Jones <andrew.jones@linux.dev>, 
	Eric Auger <eric.auger@redhat.com>, "open list:ARM" <kvmarm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Jul 2024 at 09:58, Alexandru Elisei <alexandru.elisei@arm.com> wr=
ote:
>
> Hi,
>
> On Tue, Jul 02, 2024 at 05:35:14PM +0100, Alex Benn=C3=A9e wrote:
> > The test for number of events is not a substitute for properly
> > checking the feature register. Fix the define and skip if PMUv3 is not
> > available on the system. This includes emulator such as QEMU which
> > don't implement PMU counters as a matter of policy.
> >
> > Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> > Cc: Anders Roxell <anders.roxell@linaro.org>
> > ---
> >  arm/pmu.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 9ff7a301..66163a40 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -200,7 +200,7 @@ static void test_overflow_interrupt(bool overflow_a=
t_64bits) {}
> >  #define ID_AA64DFR0_PERFMON_MASK  0xf
> >
> >  #define ID_DFR0_PMU_NOTIMPL  0b0000
> > -#define ID_DFR0_PMU_V3               0b0001
> > +#define ID_DFR0_PMU_V3               0b0011
> >  #define ID_DFR0_PMU_V3_8_1   0b0100
> >  #define ID_DFR0_PMU_V3_8_4   0b0101
> >  #define ID_DFR0_PMU_V3_8_5   0b0110
> > @@ -286,6 +286,11 @@ static void test_event_introspection(void)
> >               return;
> >       }
> >
> > +     if (pmu.version < ID_DFR0_PMU_V3) {
> > +             report_skip("PMUv3 extensions not supported, skip ...");
> > +             return;
> > +     }
> > +
>
> I don't get this patch - test_event_introspection() is only run on 64bit.=
 On
> arm64, if there is a PMU present, that PMU is a PMUv3.  A prerequisite to
> running any PMU tests is for pmu_probe() to succeed, and pmu_probe() fail=
s if
> there is no PMU implemented (PMUVer is either 0, or 0b1111). As a result,=
 if
> test_event_introspection() is executed, then a PMUv3 is present.
>
> When does QEMU advertise FEAT_PMUv3*, but no event counters (other than t=
he cycle
> counter)?

When we're using TCG but not icount mode we present only the SW_INCR,
CPU_CYCLES, STALL_FRONTEND, STALL_BACKEND and STALL events.
If we aren't counting instructions we can't present an INST_RETIRED
event, because we don't have the information. (The STALL events
always return a zero count.)

thanks
-- PMM

