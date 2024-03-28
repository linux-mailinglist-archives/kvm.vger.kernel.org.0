Return-Path: <kvm+bounces-12986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AFF688F9E4
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 09:16:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00556B23DAA
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 08:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4A4D17BB9;
	Thu, 28 Mar 2024 08:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KzNYek/H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566E554673
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 08:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711613771; cv=none; b=GxJf78muLMibn8eg03mvnI+TkBB54kqANKFh05NlfSyjiNi48sMLuKFvmYPAUhYmtjGlIPcaKqaUYN33A4ZH57OYDZDeDjGUptajMSsKZuSpCvUsNl+jsEuIsJm+8vzsSFIC+Im1q1p8XOWVPs7n5sJuqd1SpSp89F+JJX8nNoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711613771; c=relaxed/simple;
	bh=2rY2kpgwlcHa/PrNn/Hk/yv3jgIwe1HaM7GhtbLFQ2A=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Zo68+oNWktj1gFLAJDq1mnwVpFeLOrjo7XyHCX9tKHoHo88uHC93Z440abkSXbT8Jucy30GspxuZvHbws13hGxggdn+LrWCvsgQAzqtna8ayXoZWzfsgZZOL9SjOiYPonSeSDrR1G0arQlaE4Wl5cYFtOrQf8Owcg/fa+JzZ0Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KzNYek/H; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-36894e0aaabso2393405ab.2
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 01:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711613769; x=1712218569; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dg/mTl/gZQBBVLX4ap1mVzi903wSdDhAIBYr54tqh6E=;
        b=KzNYek/HeemMG0+38hO/DwMXtiDrekN1ObBn/BtO6KUxWK2DqAK9UIvwHhBrjPVCzb
         KUJKrGKardXij5S1zL/vK7grNE4RpiS+6cKDe0fmmxnMw3s1VqV6jtUq0gv2cD7R9+P1
         yqpWHROMYrqJdGj6GOXR0Tnka9VNrg2RgfFxwKyvytigNyzWh9KaPbPZuk2LuRMnIFD5
         x2MeSzUsNcp6jpkqB2QBdOzKwquTvDkLR1T9XzlRK5KJJ7oRn/sPPjVzDfYHuRgWK8rw
         9ZUnFNhQCCTwj9CcU0f5SR2MbtezJJVlavzkN4OB0AmXQnByvnopGZepVTHFn/nT8/Dh
         mNDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711613769; x=1712218569;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dg/mTl/gZQBBVLX4ap1mVzi903wSdDhAIBYr54tqh6E=;
        b=mAhCOPV64Elg3jdzqzKn1okZyCxsRMOaQLaHM0OHaxvPz9sYv0al6je7tleqsscgZc
         ouNUGqQ4LkbYjNjRNCDbyXx0x6H79LcX8VSmXI0/Do8zGoxEDTNEW9eWprzHf1PAStcu
         /Q6NLI1dcmqxiRNW0bT3ClVmcfiuhcLuqxdXj4PhCEX38Pj6jXEYORJ3RiHXbcuVfdyG
         rF4Gy+1/ZO187XoFrCmzPDOMitL3IrPTlTU/sj87J8X2PNKjtAIsEqSj8HUqryjv4/mx
         VD9XLgioDUktUoQnVb93tV4A2E/hchav8Vt3yqxZ/iKTs4c96DsWQt/lGghyRtezSrJq
         6p7g==
X-Forwarded-Encrypted: i=1; AJvYcCVkEcCi+h67cf/jd59v0aa5LKUReM0S2RaYnPUdmng0eK3tNNc9WNslAMKhdld47vtfla1XraVpYKiUJ1Lo7RLtmxAE
X-Gm-Message-State: AOJu0Yxp2pJO3kVM6aWZfuVYqC4pJpeMqISMfn0MNqE5rYRmKvVgKt/p
	NzQZbR8EpSL76gienhIkAXCCoeaYC59Dudnrk+2y2rCpylCLNtD/DV9ngM1nAU8=
X-Google-Smtp-Source: AGHT+IH+KaecwF3RwYZB0cv1SBJhdImRZrrY8YeVsJ1nJSXdi5yIxyolvTctIVwOl1LXGmnuj4ETdA==
X-Received: by 2002:a92:dd0f:0:b0:368:9ab5:6482 with SMTP id n15-20020a92dd0f000000b003689ab56482mr2435442ilm.13.1711613769423;
        Thu, 28 Mar 2024 01:16:09 -0700 (PDT)
Received: from localhost ([118.210.97.62])
        by smtp.gmail.com with ESMTPSA id t23-20020a63f357000000b005dc4da2121fsm756659pgj.6.2024.03.28.01.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 01:16:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 28 Mar 2024 18:16:04 +1000
Message-Id: <D058FW7AZ5NH.2TFDC2YABBB05@wheely>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Paolo Bonzini" <pbonzini@redhat.com>,
 <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v7 06/35] gitlab-ci: Run migration
 selftest on s390x and powerpc
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240319075926.2422707-1-npiggin@gmail.com>
 <20240319075926.2422707-7-npiggin@gmail.com>
 <91a6724d-5247-4f43-9400-1b8c03cb6cb3@redhat.com>
In-Reply-To: <91a6724d-5247-4f43-9400-1b8c03cb6cb3@redhat.com>

On Tue Mar 26, 2024 at 2:08 AM AEST, Thomas Huth wrote:
> On 19/03/2024 08.58, Nicholas Piggin wrote:
> > The migration harness is complicated and easy to break so CI will
> > be helpful.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   .gitlab-ci.yml      | 18 +++++++++++-------
> >   s390x/unittests.cfg |  8 ++++++++
> >   2 files changed, 19 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> > index ff34b1f50..bd34da04f 100644
> > --- a/.gitlab-ci.yml
> > +++ b/.gitlab-ci.yml
> > @@ -92,26 +92,28 @@ build-arm:
> >   build-ppc64be:
> >    extends: .outoftree_template
> >    script:
> > - - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
> > + - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
> >    - mkdir build
> >    - cd build
> >    - ../configure --arch=3Dppc64 --endian=3Dbig --cross-prefix=3Dpowerp=
c64-linux-gnu-
> >    - make -j2
> >    - ACCEL=3Dtcg ./run_tests.sh
> > -     selftest-setup spapr_hcall rtas-get-time-of-day rtas-get-time-of-=
day-base
> > -     rtas-set-time-of-day emulator
> > +     selftest-setup selftest-migration selftest-migration-skip spapr_h=
call
> > +     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-d=
ay
>
> I used to squash as much as possible into one line in the past, but nowad=
ays=20
> I rather prefer one test per line (like it is done for s390x below), so t=
hat=20
> it is easier to identify the changes ...
> So if you like, I think you could also put each test on a separate line h=
ere=20
> now (since you're touching all lines with tests here anyway).

Yeah it is nicer.

>
> > +     emulator
> >        | tee results.txt
> >    - if grep -q FAIL results.txt ; then exit 1 ; fi
> >  =20
> >   build-ppc64le:
> >    extends: .intree_template
> >    script:
> > - - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
> > + - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
> >    - ./configure --arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowe=
rpc64-linux-gnu-
> >    - make -j2
> >    - ACCEL=3Dtcg ./run_tests.sh
> > -     selftest-setup spapr_hcall rtas-get-time-of-day rtas-get-time-of-=
day-base
> > -     rtas-set-time-of-day emulator
> > +     selftest-setup selftest-migration selftest-migration-skip spapr_h=
call
> > +     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-d=
ay
> > +     emulator
> >        | tee results.txt
> >    - if grep -q FAIL results.txt ; then exit 1 ; fi
> >  =20
> > @@ -135,7 +137,7 @@ build-riscv64:
> >   build-s390x:
> >    extends: .outoftree_template
> >    script:
> > - - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
> > + - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu nmap-ncat
> >    - mkdir build
> >    - cd build
> >    - ../configure --arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-
> > @@ -161,6 +163,8 @@ build-s390x:
> >         sclp-1g
> >         sclp-3g
> >         selftest-setup
> > +      selftest-migration-kvm
> > +      selftest-migration-skip
> >         sieve
> >         smp
> >         stsi
> > diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> > index 49e3e4608..b79b99416 100644
> > --- a/s390x/unittests.cfg
> > +++ b/s390x/unittests.cfg
> > @@ -31,6 +31,14 @@ groups =3D selftest migration
> >   # https://lore.kernel.org/qemu-devel/20240219061731.232570-1-npiggin@=
gmail.com/
> >   accel =3D kvm
> >  =20
> > +[selftest-migration-kvm]
> > +file =3D selftest-migration.elf
> > +groups =3D nodefault
> > +accel =3D kvm
> > +# This is a special test for gitlab-ci that can must not use TCG until=
 the
>
> "can" or "must"?

I think it must be "must not".

Thanks,
Nick

