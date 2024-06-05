Return-Path: <kvm+bounces-18840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D3928FC130
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 03:16:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E431D283603
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82EBE4C85;
	Wed,  5 Jun 2024 01:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m6ReyxZ1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381EB2107
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 01:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717550189; cv=none; b=Kmo6lAPyxGMW/LRxWpckZMYtr3bvVWbCYV33gQYdUq3r1h42pWMEXvUIQ8BNDJZ95OJ9GxLyJvT9R8OujAl3vfH0YlftMQnuD8rbv6Udw0c1ggQq1uKlRSK764WJszhsvBF032O6D+7vYo9BlgEO2ylMM6+hacYM833YEiuBn6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717550189; c=relaxed/simple;
	bh=OW2TPddUpDJX2RrEj6YgLVAz6kedKyz7DVr1925dp+M=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=Z06Vg6fmQPRpLpkrKSS56pFBPNrJ8SFaNVtCazL7fAHTGAapv/C3wZGs8WWnWS5faE2rBkvPIBnEvVvg4nTeKNQYleFbORjHsIJylYdkEqdtW0dz/99WmK7NFBJYtjjfvznkHpFa2oKOt5ES0ZgNr+lz5xwe0RJZi650P4CexBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m6ReyxZ1; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2c25251d40cso1585892a91.0
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 18:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717550187; x=1718154987; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IdsDymqr+3tVKqaKI+1uZOgEEaMXUJLvcR4B2Q3VkCU=;
        b=m6ReyxZ1yY+5QqhkCHi7l1Em9z/kW7TNTtjlkRtCy7xyX4D3+Cr46VzuO+ivUhaUCu
         XnMi9ieBaRWNhFxzXiQgNgJzL/+7Ek/AWRuAJHt031KlLuhYnJT6ZxUYN1iJGWzKWN0e
         ki/TW3JFQXZcY23y5UW6YXkJUchpHQ9UvbSLU/jDtHUX3D3aHt9qpZEjlNNka3JmxxZK
         WZfbGOK40rT+XMJLpDHHrYUcYFaXEO/F14fDi7YpIv2QfJuT8cTpj/o4FAuxpRUl0d3S
         SWboG53J69S/84C1hdcK3DtYoJ4WtrfIr2LRj4pmyHaCwP1rwugXh9CN/u0xiKL5muQl
         uVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717550187; x=1718154987;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IdsDymqr+3tVKqaKI+1uZOgEEaMXUJLvcR4B2Q3VkCU=;
        b=EttBMjiYKHj4truc+ybCdDK5qE3QIJkalhuoxKfrH//rsnLn4HFvz50BrjnWNiJ8p6
         /fV9XmCSbjL381JnkFXcBe+Cf3Uy7aABBdxA9LUeSe59zykgNjxUtMTu759kWNVB3ySW
         LW7mJCiXxlA8G14n1Z8lRaShf2rkXaOrj/68bdahRBo9MQp65BbDw6KFct73nc+c5l+b
         M3Rk9Ls39E7PsDBIOh1zvhohkHE87mZp6kR7t86yKIPJr0RF0WcmI7w0EDhlsKqdCXYb
         E0OlzGyrKgsSxnSKAgHVrxfESNveEpHdoPAsvOey5HQOsXwu0aCHybMm/tpJNrpKdM4A
         ayyw==
X-Forwarded-Encrypted: i=1; AJvYcCWPNwPd0e3JS4AAlpXQrw1V7k0lFnctR6tnKapZ+MZsbYu2TwRHv2Ga/Jf8N5VVlY10OrTLEp30tLKSx5czOuNn0/Nj
X-Gm-Message-State: AOJu0YxNNiikaioq76GQk/ZN7kKTrfOjLplGmgKJhlhx2yPnAXlIAQ0y
	NLByI/YYX7AUNTF75dhKXwKHJAHPRsaR58B3UhL89WO8EfMkZ0Rg
X-Google-Smtp-Source: AGHT+IH8Sv75++VA8PbYWnegfSmdGko+hMvmAqwMpTzax7EoEy2nAnH+fYHJUmF3kQlIx4W5xI/PJQ==
X-Received: by 2002:a17:90a:6f84:b0:2bd:d6c7:1bbe with SMTP id 98e67ed59e1d1-2c27db02b33mr1087148a91.6.1717550187285;
        Tue, 04 Jun 2024 18:16:27 -0700 (PDT)
Received: from localhost (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c2806d18e1sm164734a91.50.2024.06.04.18.16.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 18:16:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Jun 2024 11:16:21 +1000
Message-Id: <D1ROQ4JDBIJM.3UXVUGU4LR3RF@gmail.com>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v9 31/31] powerpc: gitlab CI update
X-Mailer: aerc 0.17.0
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-32-npiggin@gmail.com>
 <54623658-23c8-4a51-8365-a983b230740a@redhat.com>
In-Reply-To: <54623658-23c8-4a51-8365-a983b230740a@redhat.com>

On Tue Jun 4, 2024 at 9:01 PM AEST, Thomas Huth wrote:
> On 04/05/2024 14.28, Nicholas Piggin wrote:
> > This adds testing for the powernv machine, and adds a gitlab-ci test
> > group instead of specifying all tests in .gitlab-ci.yml, and adds a
> > few new tests (smp, atomics) that are known to work in CI.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   .gitlab-ci.yml        | 30 ++++++++----------------------
> >   powerpc/unittests.cfg | 32 ++++++++++++++++++++++++++------
> >   2 files changed, 34 insertions(+), 28 deletions(-)
> >=20
> > diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> > index 23bb69e24..31a2a4e34 100644
> > --- a/.gitlab-ci.yml
> > +++ b/.gitlab-ci.yml
> > @@ -97,17 +97,10 @@ build-ppc64be:
> >    - cd build
> >    - ../configure --arch=3Dppc64 --endian=3Dbig --cross-prefix=3Dpowerp=
c64-linux-gnu-
> >    - make -j2
> > - - ACCEL=3Dtcg ./run_tests.sh
> > -      selftest-setup
> > -      selftest-migration
> > -      selftest-migration-skip
> > -      spapr_hcall
> > -      rtas-get-time-of-day
> > -      rtas-get-time-of-day-base
> > -      rtas-set-time-of-day
> > -      emulator
> > -      | tee results.txt
> > - - if grep -q FAIL results.txt ; then exit 1 ; fi
> > + - ACCEL=3Dtcg MAX_SMP=3D8 ./run_tests.sh -g gitlab-ci | tee results.t=
xt
> > + - grep -q PASS results.txt && ! grep -q FAIL results.txt
> > + - ACCEL=3Dtcg MAX_SMP=3D8 MACHINE=3Dpowernv ./run_tests.sh -g gitlab-=
ci | tee results.txt
> > + - grep -q PASS results.txt && ! grep -q FAIL results.txt
> >  =20
> >   build-ppc64le:
> >    extends: .intree_template
> > @@ -115,17 +108,10 @@ build-ppc64le:
> >    - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
> >    - ./configure --arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowe=
rpc64-linux-gnu-
> >    - make -j2
> > - - ACCEL=3Dtcg ./run_tests.sh
> > -      selftest-setup
> > -      selftest-migration
> > -      selftest-migration-skip
> > -      spapr_hcall
> > -      rtas-get-time-of-day
> > -      rtas-get-time-of-day-base
> > -      rtas-set-time-of-day
> > -      emulator
> > -      | tee results.txt
> > - - if grep -q FAIL results.txt ; then exit 1 ; fi
> > + - ACCEL=3Dtcg MAX_SMP=3D8 ./run_tests.sh -g gitlab-ci | tee results.t=
xt
> > + - grep -q PASS results.txt && ! grep -q FAIL results.txt
> > + - ACCEL=3Dtcg MAX_SMP=3D8 MACHINE=3Dpowernv ./run_tests.sh -g gitlab-=
ci | tee results.txt
> > + - grep -q PASS results.txt && ! grep -q FAIL results.txt
> >  =20
> >   # build-riscv32:
> >   # Fedora doesn't package a riscv32 compiler for QEMU. Oh, well.
> > diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
> > index d767f5d68..6fae688a8 100644
> > --- a/powerpc/unittests.cfg
> > +++ b/powerpc/unittests.cfg
> > @@ -16,17 +16,25 @@
> >   file =3D selftest.elf
> >   smp =3D 2
> >   extra_params =3D -m 1g -append 'setup smp=3D2 mem=3D1024'
> > -groups =3D selftest
> > +groups =3D selftest gitlab-ci
> >  =20
> >   [selftest-migration]
> >   file =3D selftest-migration.elf
> >   machine =3D pseries
> >   groups =3D selftest migration
> >  =20
> > +# QEMU 7.0 (Fedora 37) in gitlab CI has known migration bugs in TCG, s=
o
> > +# make a kvm-only version for CI
> > +[selftest-migration-ci]
> > +file =3D selftest-migration.elf
> > +machine =3D pseries
> > +groups =3D nodefault selftest migration gitlab-ci
> > +accel =3D kvm
> > +
> >   [selftest-migration-skip]
> >   file =3D selftest-migration.elf
> >   machine =3D pseries
> > -groups =3D selftest migration
> > +groups =3D selftest migration gitlab-ci
> >   extra_params =3D -append "skip"
> >  =20
> >   [migration-memory]
> > @@ -37,6 +45,7 @@ groups =3D migration
> >   [spapr_hcall]
> >   file =3D spapr_hcall.elf
> >   machine =3D pseries
> > +groups =3D gitlab-ci
> >  =20
> >   [spapr_vpa]
> >   file =3D spapr_vpa.elf
> > @@ -47,38 +56,43 @@ file =3D rtas.elf
> >   machine =3D pseries
> >   timeout =3D 5
> >   extra_params =3D -append "get-time-of-day date=3D$(date +%s)"
> > -groups =3D rtas
> > +groups =3D rtas gitlab-ci
> >  =20
> >   [rtas-get-time-of-day-base]
> >   file =3D rtas.elf
> >   machine =3D pseries
> >   timeout =3D 5
> >   extra_params =3D -rtc base=3D"2006-06-17" -append "get-time-of-day da=
te=3D$(date --date=3D"2006-06-17 UTC" +%s)"
> > -groups =3D rtas
> > +groups =3D rtas gitlab-ci
> >  =20
> >   [rtas-set-time-of-day]
> >   file =3D rtas.elf
> >   machine =3D pseries
> >   extra_params =3D -append "set-time-of-day"
> >   timeout =3D 5
> > -groups =3D rtas
> > +groups =3D rtas gitlab-ci
> >  =20
> >   [emulator]
> >   file =3D emulator.elf
> > +groups =3D gitlab-ci
> >  =20
> > +# QEMU 7.0 (Fedora 37) in gitlab CI fails this
> >   [interrupts]
> >   file =3D interrupts.elf
> >  =20
> > +# QEMU 7.0 (Fedora 37) in gitlab CI fails this
> >   [mmu]
> >   file =3D mmu.elf
> >   smp =3D $MAX_SMP
> >  =20
> > +# QEMU 7.0 (Fedora 37) in gitlab CI fails this
> >   [pmu]
> >   file =3D pmu.elf
> >  =20
> >   [smp]
> >   file =3D smp.elf
> >   smp =3D 2
> > +groups =3D gitlab-ci
> >  =20
> >   [smp-smt]
> >   file =3D smp.elf
> > @@ -92,16 +106,19 @@ accel =3D tcg,thread=3Dsingle
> >  =20
> >   [atomics]
> >   file =3D atomics.elf
> > +groups =3D gitlab-ci
> >  =20
> >   [atomics-migration]
> >   file =3D atomics.elf
> >   machine =3D pseries
> >   extra_params =3D -append "migration -m"
> > -groups =3D migration
> > +groups =3D migration gitlab-ci
> >  =20
> > +# QEMU 7.0 (Fedora 37) in gitlab CI fails this
> >   [timebase]
> >   file =3D timebase.elf
> >  =20
> > +# QEMU 7.0 (Fedora 37) in gitlab CI fails this
> >   [timebase-icount]
> >   file =3D timebase.elf
> >   accel =3D tcg
> > @@ -115,14 +132,17 @@ smp =3D 2,threads=3D2
> >   extra_params =3D -machine cap-htm=3Don -append "h_cede_tm"
> >   groups =3D h_cede_tm
> >  =20
> > +# QEMU 7.0 (Fedora 37) in gitlab CI fails this
> >   [sprs]
> >   file =3D sprs.elf
> >  =20
> > +# QEMU 7.0 (Fedora 37) in gitlab CI fails this
> >   [sprs-migration]
> >   file =3D sprs.elf
> >   machine =3D pseries
> >   extra_params =3D -append '-w'
> >   groups =3D migration
>
> Have any of the failures been fixed in newer versions of QEMU?

Yes, I think all (maybe with the exception of the migration dirty
bitmap bug) are fixed in 40. I did try that but x86 got some new
failures. Doing f40 for ppc specific would be another option but
if you have fixes for the x86 fails we could update it all at
once?

> If so, you could also update the ppc jobs to fedora:40:

Good idea, I'll add an optional patch at the end to just update
ppc, if the other patches aren't polished yet.

Thanks,
Nick

>
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -91,6 +91,7 @@ build-arm:
>  =20
>   build-ppc64be:
>    extends: .outoftree_template
> + image: fedora:40
>    script:
>    - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
>    - mkdir build
> @@ -111,6 +112,7 @@ build-ppc64be:
>  =20
>   build-ppc64le:
>    extends: .intree_template
> + image: fedora:40
>    script:
>    - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
>    - ./configure --arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowerp=
c64-linux-gnu-
>
> I also had a patch somewhere that updates all jobs, it just needs some
> polishing to get finished ...  maybe a good point in time to do this now.
>
>   Thomas


