Return-Path: <kvm+bounces-10351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D440B86BFAC
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 04:56:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F5B92841F6
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 03:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D0B376EB;
	Thu, 29 Feb 2024 03:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JfeMyR+2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AE12E622
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 03:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709178961; cv=none; b=HlE9+it1EbLdRObV+49cfd/YRFXHQtXT8pfJxLdECqrIwmOMlNLvRtgq6nSV94NfcmZPEk+XyBvMyE90A1Ll1CG+LBM5yKL2aOsNpbH4l8yEsSEPWm3u/sorWM4E/t1yOwIkT2aw3gKYNaUwyufmhJvDCNoZX5H0LoxpPnRciug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709178961; c=relaxed/simple;
	bh=7+tCSRcyaUV9cp7u0n3lHgnxUimH77Cvv7Gl05T0pMQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=Lkb5+D4/lOyhNuPzv5yTrcLysoqWJGHqpivQ5LUi1Aiy+5uprteTso41EmQ/fsPHwwQisOFPR7YE1CmsTznUXeTdFeO5qHpA37s9oy+d3D3tjI7GJJBu1nk4Lv7C41m6P4N0uLPZ11h0JMCsRoUMcgON2W0e6ZdoUgjCPphrsEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JfeMyR+2; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5c229dabbb6so251624a12.0
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 19:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709178959; x=1709783759; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JWcLujHHv8i/TCX/eV0Cq8RaT7/itl/bFzVITNyWgHU=;
        b=JfeMyR+2bvtzIEWqt6M74QTkBGA+JP143dkpcGuuxlEVdVPGahd0ejbiyTLSQGYjYp
         T2vF1jEJYOrXQKWU07St4tPRsnjCP9tO0bOElGtbBdAZq4fdK04Lg7iC/D5+c9orbzEX
         sNzH/g+J2XRFnBGho8RftMI9pYNg0v9RjNUlr3/MzTXt00bS8tb/yKMXMPgPWGmf9Q4H
         QtM9Ei7mTCy7qS0W/OAXUDNJ5qSCzH4OENbjUZQE0y2BvPle4HhQmQJyPgutVW2uk9Ex
         j+fHKSThSYx+cGypzjUP4h0UoWtiVWAOHw+Uj0jFPLkGCr3B7hFFZ+y4UBlyiepNKNFj
         eKig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709178959; x=1709783759;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JWcLujHHv8i/TCX/eV0Cq8RaT7/itl/bFzVITNyWgHU=;
        b=XXU0V/TYM5F7nXjsEFBvqKxkCkdbPYVF9t2UWq/Y+ALvpWSrcIQsMcZvO9BzPZoucf
         pus9+erJrqtGkZ5s/yG7/av91Q2MVrNJJn1JcbGXcqlR799YGxpe9n4Zh1lfZiOphhwE
         15bIkCPykXGf89wnMWn1r7Voe8jxEJpTwNGTUp/wSfgP3wyrGz/ekmOE5VvC6xQY/cJv
         hBSm7LUcwk+Mb2L/60EG5lwrjSpYNEZFQF+6VtJNr9S3JRRAnMiP117zEnXTcixeN8PK
         Ro3Bzzhu1ZE4nxOWSujSl34LuXBBS4oBsi6kVgbD/Wkvp+AsHRx41hFFg5kgfDAZQRH+
         EOBw==
X-Forwarded-Encrypted: i=1; AJvYcCXJMm1uf8Yfjt36MplO+Awm7fONWXNe0voIcHxRlrI0e83+RUWLTSOZKK316hrTU96m9abN0RqZYxzco95XAzEOZ6PY
X-Gm-Message-State: AOJu0YyNI8MzUxH4PFWWQs29JT3JHO6nZwjnJ0QV8Kpzkb0+BC2hCeoF
	VSGwWLEghZ6aa4wq5Cmutf5Kb8pquErJNpR4XM48iJL4/IrD85MZRSDmoHLu
X-Google-Smtp-Source: AGHT+IGwE0WC6jn7KJKFPT27e1lEa2s+c9G7mMkwH4tcRT8KLb2sX/mDeX7697E6K+RQ8nsfd60WpA==
X-Received: by 2002:a17:90b:342:b0:29a:a3e1:7ab4 with SMTP id fh2-20020a17090b034200b0029aa3e17ab4mr1196565pjb.20.1709178959242;
        Wed, 28 Feb 2024 19:55:59 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id d23-20020a17090ac25700b0029ae07f56b3sm325887pjx.5.2024.02.28.19.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 19:55:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 Feb 2024 13:55:53 +1000
Message-Id: <CZH9DFOIK83X.3M1VP48W32393@wheely>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
Cc: "Thomas Huth" <thuth@redhat.com>, "Laurent Vivier" <lvivier@redhat.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, "Joel Stanley" <joel@jms.id.au>,
 <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 32/32] powerpc: gitlab CI update
X-Mailer: aerc 0.15.2
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-33-npiggin@gmail.com>
 <20240228-86aa66c910b91dfebb8afee8@orel>
In-Reply-To: <20240228-86aa66c910b91dfebb8afee8@orel>

On Wed Feb 28, 2024 at 10:16 PM AEST, Andrew Jones wrote:
> On Mon, Feb 26, 2024 at 08:12:18PM +1000, Nicholas Piggin wrote:
> > This adds testing for the powernv machine, and adds a gitlab-ci test
> > group instead of specifying all tests in .gitlab-ci.yml.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  .gitlab-ci.yml        | 16 ++++++----------
> >  powerpc/unittests.cfg | 15 ++++++++-------
> >  2 files changed, 14 insertions(+), 17 deletions(-)
> >=20
> > diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> > index 61f196d5d..51a593021 100644
> > --- a/.gitlab-ci.yml
> > +++ b/.gitlab-ci.yml
> > @@ -69,11 +69,9 @@ build-ppc64be:
> >   - cd build
> >   - ../configure --arch=3Dppc64 --endian=3Dbig --cross-prefix=3Dpowerpc=
64-linux-gnu-
> >   - make -j2
> > - - ACCEL=3Dtcg ./run_tests.sh
> > -     selftest-setup selftest-migration selftest-migration-skip spapr_h=
call
> > -     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-d=
ay
> > -     emulator
> > -     | tee results.txt
> > + - ACCEL=3Dtcg MAX_SMP=3D8 ./run_tests.sh -g gitlab-ci | tee results.t=
xt
> > + - if grep -q FAIL results.txt ; then exit 1 ; fi
> > + - ACCEL=3Dtcg MAX_SMP=3D8 MACHINE=3Dpowernv ./run_tests.sh -g gitlab-=
ci | tee results.txt
> >   - if grep -q FAIL results.txt ; then exit 1 ; fi
> > =20
> >  build-ppc64le:
> > @@ -82,11 +80,9 @@ build-ppc64le:
> >   - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
> >   - ./configure --arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpower=
pc64-linux-gnu-
> >   - make -j2
> > - - ACCEL=3Dtcg ./run_tests.sh
> > -     selftest-setup selftest-migration selftest-migration-skip spapr_h=
call
> > -     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-d=
ay
> > -     emulator
> > -     | tee results.txt
> > + - ACCEL=3Dtcg MAX_SMP=3D8 ./run_tests.sh -g gitlab-ci | tee results.t=
xt
> > + - if grep -q FAIL results.txt ; then exit 1 ; fi
> > + - ACCEL=3Dtcg MAX_SMP=3D8 MACHINE=3Dpowernv ./run_tests.sh -g gitlab-=
ci | tee results.txt
> >   - if grep -q FAIL results.txt ; then exit 1 ; fi
> > =20
>
> We're slowly migrating all tests like these to
>
>  grep -q PASS results.txt && ! grep -q FAIL results.txt
>
> Here's a good opportunity to change ppc's.

Sure, I'll do that.

Thanks,
Nick

