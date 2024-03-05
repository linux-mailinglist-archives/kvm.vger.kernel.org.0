Return-Path: <kvm+bounces-10856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5258D8713AF
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:38:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 083FE1F236FB
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA7FD286B3;
	Tue,  5 Mar 2024 02:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bXGnTJmx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B809A24B52;
	Tue,  5 Mar 2024 02:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709606310; cv=none; b=FxnYH9sEKt0chu57LPCfWap5fZtS2gQepzaYXZwWvqYi8WAMqXoOFsBFdjy9zxEDW2nTdHWem7HadTWI+GGDty5p0ibsJUIr0RX6n5h5eNFbNuzXXX6twe/JU1YfixoO1rI3qdC3W3Wsw/+lpTPzqADXpfbjS5X6z7xIualizdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709606310; c=relaxed/simple;
	bh=gWqhsBJQ0WYTlb5EL+H8nDpSAncj1TpxGUg4gh9Mw8I=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=l2E0WaAoaz066EcPr236S2n4xMA6u8GAR2xhS73x8GYKGmhlDqn9GllUCrQTXmm+da1cahU1M/ogVFg3cdLcBzkLsbbZEFVXNYgC5QotoXREvEKbzmgE3QBaJWUViDf0pXcaeu00NqEVMKbeoxt89icqXKLjWVLJAuJlssJaZzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bXGnTJmx; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e5760eeb7aso4163446b3a.1;
        Mon, 04 Mar 2024 18:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709606308; x=1710211108; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tyy/z7rMU4Pt5i35c66uzuip5ZuV2JKh4HderjIItWU=;
        b=bXGnTJmxe/V3cLr24/bBkpmnhSrMjPLYE71xxXVV4NE9sxbwR8FDBJkI1kQIPXSF33
         rOHOwAPYyHx4M0lqzLgmdD/isl0xuFEgdNV0rTrfHtcEenf/iRckJ1FdXQrHBKFu61gk
         F8zQ+R+LR7yyGhS6XRus3mhUE5anwxLKUg/t+lSC6EePj2NZ7ZP0AcT7zHqqu2mh2WTE
         oH9o6xELQVb95uG5w0WebKfGLvmVoOz+pM6S3MsgInAorrSROjhTzGh9y7har2WCi6TE
         51Pcpra4yapp4B0K172rtRDVJXuOg7Qa40ALvYfPbPZHuH0seT0txwp5xfucnikQul74
         wvhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709606308; x=1710211108;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tyy/z7rMU4Pt5i35c66uzuip5ZuV2JKh4HderjIItWU=;
        b=XTSFqhKixqdNnDcGYJDBM14SfLvG1NTzIbb36ZBIIwufgzhn4CzvkFTVnCmk4gueNt
         UYSfeuUdc6AJx3pGVKDHigQJSN2Xov80ah+ASaispyQCsjtgKI0D92TwR/YaN/K8yDoF
         zHyhEnWsOtCMPoa3gkCVlBE68RqyiRJne/2wLsAW/7983W56MR2IVIGiIElPf30m+EuH
         dVm/KnQmAseQ+bO3LUg55PgYIJS1Q4Y3UbxN6YRbFGx0sjKmuwOQkaidQACOYOa4ovUs
         3roH07/wRTJ1aDdvG8NOpH6orkBbbivSD0OBMjv+od7z5jmISUGsPSz3sO8W8FZXW25a
         tbWw==
X-Forwarded-Encrypted: i=1; AJvYcCX7UFN3kgE7mGe6z+sw4PW/Ldwm/7H7PptBGctAHeFfliETqbne+bZZu8QKmsBqgzGUjUo1Pz1gHqFrqrsMZUdLQVfCGNPjeiRMLA==
X-Gm-Message-State: AOJu0YwZ2VcbXEEYmX3o2rUr6T6UmgYDVDsaM4Cp96aoTUx0xHz7E6z3
	CUC48LyDhBKF5yoUJI0ORzdG1YNpIehuNozjKJZ23QDoSINrjCk+
X-Google-Smtp-Source: AGHT+IEKWe065y9WsZvbuFfENkJW8uphvHaaQx9DKUXf0yz0WkmuCLdKUw5eHSp2vKXMroyA8a06BQ==
X-Received: by 2002:a05:6a00:27a0:b0:6e5:584d:e511 with SMTP id bd32-20020a056a0027a000b006e5584de511mr13144227pfb.17.1709606307957;
        Mon, 04 Mar 2024 18:38:27 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id h27-20020a056a00001b00b006e5eab773efsm4638161pfk.171.2024.03.04.18.38.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 18:38:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Mar 2024 12:38:19 +1000
Message-Id: <CZLGURIYNKHG.1JRG53746LHWI@wheely>
Subject: Re: [kvm-unit-tests PATCH 6/7] gitlab-ci: Run migration selftest on
 s390x and powerpc
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-s390@vger.kernel.org>
X-Mailer: aerc 0.15.2
References: <20240226093832.1468383-1-npiggin@gmail.com>
 <20240226093832.1468383-7-npiggin@gmail.com>
 <7783977b-69ea-4831-a8f2-55de26d7bfd4@redhat.com>
In-Reply-To: <7783977b-69ea-4831-a8f2-55de26d7bfd4@redhat.com>

On Sat Mar 2, 2024 at 12:16 AM AEST, Thomas Huth wrote:
> On 26/02/2024 10.38, Nicholas Piggin wrote:
> > The migration harness is complicated and easy to break so CI will
> > be helpful.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   .gitlab-ci.yml | 18 +++++++++++-------
> >   1 file changed, 11 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> > index 71d986e98..61f196d5d 100644
> > --- a/.gitlab-ci.yml
> > +++ b/.gitlab-ci.yml
> > @@ -64,26 +64,28 @@ build-arm:
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
> > @@ -107,7 +109,7 @@ build-riscv64:
> >   build-s390x:
> >    extends: .outoftree_template
> >    script:
> > - - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
> > + - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu nmap-ncat
> >    - mkdir build
> >    - cd build
> >    - ../configure --arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-
> > @@ -133,6 +135,8 @@ build-s390x:
> >         sclp-1g
> >         sclp-3g
> >         selftest-setup
> > +      selftest-migration
> > +      selftest-migration-skip
> >         sieve
> >         smp
> >         stsi
>
> While I can update the qemu binary for the s390x-kvm job, the build-* job=
s=20
> run in a container with a normal QEMU from the corresponding distros, so =
I=20
> think this has to wait 'til we get distros that contain your QEMU TCG=20
> migration fix.

Okay. powerpc *could* run into the TCG bug too, in practice it has not.
We could try enable it there to get migration into CI, and revert it if
it starts showing random failures?

Thanks,
Nick

