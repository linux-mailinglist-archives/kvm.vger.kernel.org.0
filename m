Return-Path: <kvm+bounces-21203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE42A92BC71
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 16:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FB702814A0
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 14:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C6A19B5AA;
	Tue,  9 Jul 2024 14:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ksp42NW6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72712154BF0
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 14:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720533912; cv=none; b=BhNBTy6q138neBffKtJcfEyQ9DGR/KRqM94cwat0QtVLxylpVfqm/04mVov3fDGg0jVhAxUViXGUz0Dooq417lCXqjqPeKEHSo5/2Ei+l2xbk/HtQSQLwq1/rnxY+UFk5qxG+If+v56Qt32bHK59bNIRnb3ZFDw+BXdQZ43Z1vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720533912; c=relaxed/simple;
	bh=V8w+WduDjYMbi0xF1AXf4foyhxK/Tys6Ftz1gy0oyc0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KEwy4Xyyl8E68Zr39xfViZeNdm12NDK7OZr0vIRf2DwJAo4Dm/Fsac3TZyVxbAxiOOThv9ZUSS9eKY8dvlKO3W4u61r2nou2mYGD23iTUMuUPB7z2tAUuuVfOyRqpTn5S/JRTcrsn9pR6O+CIMYZDYwDja6zog39wvL0+ejZ5Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ksp42NW6; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-58b447c519eso6404491a12.3
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 07:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720533909; x=1721138709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LFnTUzpKhBIUCroDn1g1yjbNPSRiA5x35lp/BspUfsQ=;
        b=ksp42NW69OQcAQ188BxIBGutORQin+WlOP4AUzQ6EKPmYN7wPl0wzCKhVdz2PdAMU3
         0eCKIBWxPOvomtmKkGqfO77GNzIzqMHmBxbMdqIuDFiTSi3DjIrp0M4NyWFFcUTIa3rY
         aLSdz9i2VB/fU4A6IgJyMT4MZEC8Wvl83jKJIBNHQzhWMXDMYM6gX0CxEkuxSs/OZfe8
         J0RwON4CmOzz8LQ+ij87pHZRAo5v8s6oxil/XQkPc0+i2UBVYNlry/xzbIUqrwRR9XU+
         HWlCDMFSdiw7qZqEP2Cel/5QJeS6GKdwtVYsCOkNdzs9PCGA/mZRZbvkVZfziDxWrlUx
         Sr9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720533909; x=1721138709;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LFnTUzpKhBIUCroDn1g1yjbNPSRiA5x35lp/BspUfsQ=;
        b=D50g5fogk4/ULjAKGsUqgKxI/z9ElUvlbsj9mZf/MgDPytMjFUkrhNBivkmNvW4JLv
         0/wa81voLwehjqo5U17AajWf9TrpDAvTHTGx4Liq0c9OVyeVGQBSM6lufSb1f/9N+qz3
         mvhRLMzXxFbnn0xLM23NLQcPIRVqiRtfnzM4T30Qfr/lskacKbCzKacd1SZ5aBXuyowl
         /uulOfEBvwqsm/2AOVRkXCruPHAmlsr/hDWS2ScCJ4aLMx0AX2oGlaejO8xbvY392SAi
         oMrBOAjzb96BNTy2m/XCPKv4cgzBynLFwoad0MYzCGNSDpxRKH2LtHFkHhD/8mY7CRQa
         cJ1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXsmWdjaPH27iOdXOoCs1fspF3Zc4osZF8smCwVBW0OvNbwwpo/5wXtTLoVoTjxR5XULpVaiLEMwdtf5WQ1UDKrXyjn
X-Gm-Message-State: AOJu0Ywo+UC4FFKy+dFBmjP96xxGh1EZ70Pl4p12az6NABfxNYrL816T
	SHx4JDTg5GMCUVPJkbprUxpbL3MrqmjrsqqmJhHQfu9gglh6n08PsuGH8Ee4ZWI=
X-Google-Smtp-Source: AGHT+IE+Zmggc07hsVlPoxEDJ5GRtNGB1wyrmyRK/TXjRJdHi8hOElRGk0h0SF/eAxRWxky1RxL6mQ==
X-Received: by 2002:aa7:c45a:0:b0:58b:12bd:69c8 with SMTP id 4fb4d7f45d1cf-594bbe2ba49mr1526124a12.36.1720533908642;
        Tue, 09 Jul 2024 07:05:08 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-594bda308d7sm1088890a12.91.2024.07.09.07.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 07:05:08 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 4247C5F8D7;
	Tue,  9 Jul 2024 15:05:07 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,  pbonzini@redhat.com,
  drjones@redhat.com,  thuth@redhat.com,  kvm@vger.kernel.org,
  qemu-arm@nongnu.org,  linux-arm-kernel@lists.infradead.org,
  kvmarm@lists.cs.columbia.edu,  christoffer.dall@arm.com,  maz@kernel.org,
  Anders Roxell <anders.roxell@linaro.org>,  Andrew Jones
 <andrew.jones@linux.dev>,  Eric Auger <eric.auger@redhat.com>,  "open
 list:ARM" <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] arm/pmu: skip the PMU
 introspection test if missing
In-Reply-To: <CAFEAcA-LFtAi0DkFGc0Q3TYR_+X3TUWQru8crhbKun4EHctcdQ@mail.gmail.com>
	(Peter Maydell's message of "Tue, 9 Jul 2024 10:33:28 +0100")
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
	<20240702163515.1964784-2-alex.bennee@linaro.org>
	<Zoz7sQNoC9ePXH7w@arm.com>
	<CAFEAcA-LFtAi0DkFGc0Q3TYR_+X3TUWQru8crhbKun4EHctcdQ@mail.gmail.com>
Date: Tue, 09 Jul 2024 15:05:07 +0100
Message-ID: <87ed82slt8.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Peter Maydell <peter.maydell@linaro.org> writes:

> On Tue, 9 Jul 2024 at 09:58, Alexandru Elisei <alexandru.elisei@arm.com> =
wrote:
>>
>> Hi,
>>
>> On Tue, Jul 02, 2024 at 05:35:14PM +0100, Alex Benn=C3=A9e wrote:
>> > The test for number of events is not a substitute for properly
>> > checking the feature register. Fix the define and skip if PMUv3 is not
>> > available on the system. This includes emulator such as QEMU which
>> > don't implement PMU counters as a matter of policy.
>> >
>> > Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> > Cc: Anders Roxell <anders.roxell@linaro.org>
>> > ---
>> >  arm/pmu.c | 7 ++++++-
>> >  1 file changed, 6 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/arm/pmu.c b/arm/pmu.c
>> > index 9ff7a301..66163a40 100644
>> > --- a/arm/pmu.c
>> > +++ b/arm/pmu.c
>> > @@ -200,7 +200,7 @@ static void test_overflow_interrupt(bool overflow_=
at_64bits) {}
>> >  #define ID_AA64DFR0_PERFMON_MASK  0xf
>> >
>> >  #define ID_DFR0_PMU_NOTIMPL  0b0000
>> > -#define ID_DFR0_PMU_V3               0b0001
>> > +#define ID_DFR0_PMU_V3               0b0011
>> >  #define ID_DFR0_PMU_V3_8_1   0b0100
>> >  #define ID_DFR0_PMU_V3_8_4   0b0101
>> >  #define ID_DFR0_PMU_V3_8_5   0b0110
>> > @@ -286,6 +286,11 @@ static void test_event_introspection(void)
>> >               return;
>> >       }
>> >
>> > +     if (pmu.version < ID_DFR0_PMU_V3) {
>> > +             report_skip("PMUv3 extensions not supported, skip ...");
>> > +             return;
>> > +     }
>> > +
>>
>> I don't get this patch - test_event_introspection() is only run on 64bit=
. On
>> arm64, if there is a PMU present, that PMU is a PMUv3.  A prerequisite to
>> running any PMU tests is for pmu_probe() to succeed, and pmu_probe() fai=
ls if
>> there is no PMU implemented (PMUVer is either 0, or 0b1111). As a result=
, if
>> test_event_introspection() is executed, then a PMUv3 is present.
>>
>> When does QEMU advertise FEAT_PMUv3*, but no event counters (other than =
the cycle
>> counter)?

The other option I have is this:

--8<---------------cut here---------------start------------->8---
arm/pmu: event-introspection needs icount for TCG

The TCG accelerator will report a PMU (unless explicitly disabled with
-cpu foo,pmu=3Doff) however not all events are available unless you run
under icount. Fix this by splitting the test into a kvm and tcg
version.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

1 file changed, 8 insertions(+)
arm/unittests.cfg | 8 ++++++++

modified   arm/unittests.cfg
@@ -52,8 +52,16 @@ extra_params =3D -append 'cycle-counter 0'
 file =3D pmu.flat
 groups =3D pmu
 arch =3D arm64
+accel =3D kvm
 extra_params =3D -append 'pmu-event-introspection'
=20
+[pmu-event-introspection-icount]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+accel =3D tcg
+extra_params =3D -icount shift=3D1 -append 'pmu-event-introspection'
+
 [pmu-event-counter-config]
 file =3D pmu.flat
 groups =3D pmu
--8<---------------cut here---------------end--------------->8---

which just punts icount on TCG to its own test (note there are commented
out versions further down the unitests.cfg file)

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

