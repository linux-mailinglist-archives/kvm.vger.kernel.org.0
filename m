Return-Path: <kvm+bounces-18992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C49558FDD9B
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 05:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20397B22C5E
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 03:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C3C1F5FD;
	Thu,  6 Jun 2024 03:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FekyR+LG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A6919D8B9
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 03:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717645792; cv=none; b=D9Pe0V5SncWZuNXQwI8G2BT6QkrQCwFNYdIK9JdC+rh5Hc/7jpR56+p6gopX8GpnJ7bnMiIGM0znlZTi5SzJU04TxdxU/U9On2cjyMgnPBb8IIrHmlm0PCBlSLql88MPvvvRvbcaL7iMZeXFiAL+d+W9rBTowRHcaoETI1LWcTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717645792; c=relaxed/simple;
	bh=eQrVtSU5ryKAGZRzUBo0Z6LNmzW8AOMhvvqZ02pqxFg=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=M7J9hs5Tfzs8XoZ9bijnr12vbiJahFVTaN/XrRU+A0nROicSTYYucJ/SovrDjPcI+AIHDyrMYCCbY5mtrHyg+atqZw7xfHVFTCVl99TSM46LC1c8aU/xofoDGV/tR+dScV6aJB79HA2fmsOnXWWbmVsXeehqHNvixqxCb7e94m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FekyR+LG; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1f68834bfdfso4365815ad.3
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 20:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717645790; x=1718250590; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0tGFScf2cwiIhWRkROqAz5X+j4q0tabpsBqfzdW3klA=;
        b=FekyR+LGXtTayoJvQLs2DfTAFN5meMZqbiSawjogHg7x4dUBe6XQadEHNt8TWKeToT
         7u+RMvf5HTuWlYhTBCBvDuVnyKc990BKwZUqUEOfe3bbE8K+IHhG/RAxXON3ixPirrlY
         OPSPzHAvfzV9UHNepbnKb2w6zCoxMucgopqoPTvR4Ml3KQ1K6Q+7QlYLC/lm2fe4KaVY
         WMllawikSAR1/D8pUA/6Vy/qoThMvpegNzcI7lVnUjY1LxpXTr85IUR0hlilEJ3oJkhw
         jwz3M2+YXsxh36mKQ4OY6zKVVddwbkik00CNEJ7Gp6ieGq5qc3ENDMJGvAf6zIwrixBu
         1orw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717645790; x=1718250590;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0tGFScf2cwiIhWRkROqAz5X+j4q0tabpsBqfzdW3klA=;
        b=S57gP7ZcpkLId12JWZH+Uyam3ZmOTuKzeGbT/KstGi1S7SRz7awZeB32FdAVc26HHY
         LYLEHenqddUYqqYhCGWgz8OsBxIUcfQx1e53+ZX815p20p/gPP12wxJhoMjaUOQfz/y1
         xIM1MvrBZPpqLW7II2qwnwixGvFyycZwynASb8tAc+jVox4CmzfCnbfOFRpoTnAKv/E9
         WK5fqpdkucP82PVSX43w9dYt1tDGed8jyYRqnDUb00YZjmfWYiBzVVn2qZ80S6/t1P1U
         mlINv/VKksc0pj6goMq/M1Ez61rKMhaqVJ2rjzTey8+X8uWDvyp5vu2HF/CFQN0jsV85
         /Xig==
X-Forwarded-Encrypted: i=1; AJvYcCUG8vHNiZSke/kL8VliCST4jDFpcjpGhr9D2cXwls6q8K+T/pfjMqwGA1GlqEC9i9lVssQUbaF7NN/SnHC5wpguGEKM
X-Gm-Message-State: AOJu0YyPsM0pklBEyYqNrnCV5LFSAnH3CusQEv5p/gkkKKneYRQ4sCM1
	hpufPKvSy+jCXClJQtTof9egHTrrSzFM8big/ReQPG0AlquryKXq
X-Google-Smtp-Source: AGHT+IEP64jMV2ibbj2W3K0gXbLMslzt3UktxgnyRGigRGfPydEgx3F7Ggpd8CPYH+zKVCppqraSHw==
X-Received: by 2002:a17:903:40c1:b0:1f6:8235:dba7 with SMTP id d9443c01a7336-1f6a5a900a0mr55110505ad.69.1717645789861;
        Wed, 05 Jun 2024 20:49:49 -0700 (PDT)
Received: from localhost (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd76075bsm3282105ad.40.2024.06.05.20.49.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 20:49:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 06 Jun 2024 13:49:45 +1000
Message-Id: <D1SMM4C3H27B.2VWTDLUIB7RU3@gmail.com>
To: "Marc Hartmayer" <mhartmay@linux.ibm.com>, "Thomas Huth"
 <thuth@redhat.com>
Cc: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>
Subject: Re: [RFC kvm-unit-tests PATCH] build: fix .aux.o target building
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.17.0
References: <20240605081623.8765-1-npiggin@gmail.com>
 <87cyovekmh.fsf@linux.ibm.com> <D1S0ZSXXGJFC.2IE9N2O8K9ETJ@gmail.com>
 <87frtrh1ho.fsf@linux.ibm.com>
In-Reply-To: <87frtrh1ho.fsf@linux.ibm.com>

On Thu Jun 6, 2024 at 1:07 AM AEST, Marc Hartmayer wrote:
> On Wed, Jun 05, 2024 at 08:53 PM +1000, "Nicholas Piggin" <npiggin@gmail.=
com> wrote:
> > On Wed Jun 5, 2024 at 8:42 PM AEST, Marc Hartmayer wrote:
> >> On Wed, Jun 05, 2024 at 06:16 PM +1000, Nicholas Piggin <npiggin@gmail=
.com> wrote:
> >> > Here's another oddity I ran into with the build system. Try run make
> >> > twice. With arm64 and ppc64, the first time it removes some intermed=
iate
> >> > files and the second causes another rebuild of several files. After
> >> > that it's fine. s390x seems to follow a similar pattern but does not
> >> > suffer from the problem. Also, the .PRECIOUS directive is not preven=
ting
> >> > them from being deleted inthe first place. So... that probably means=
 I
> >> > haven't understood it properly and the fix may not be correct, but i=
t
> >> > does appear to DTRT... Anybody with some good Makefile knowledge mig=
ht
> >> > have a better idea.
> >> >
> >>
> >> $ make clean -j &>/dev/null && make -d
> >> =E2=80=A6
> >> Successfully remade target file 'all'.
> >> Removing intermediate files...
> >> rm powerpc/emulator.aux.o powerpc/tm.aux.o powerpc/spapr_hcall.aux.o p=
owerpc/interrupts.aux.o powerpc/selftest.aux.o powerpc/smp.aux.o powerpc/se=
lftest-migration.aux.o powerpc/spapr_vpa.aux.o powerpc/sprs.aux.o powerpc/r=
tas.aux.o powerpc/memory-verify.aux.o
> >>
> >> So an easier fix would be to add %.aux.o to .PRECIOUS (but that=E2=80=
=99s probably still not clean).
> >>
> >> .PRECIOUS: %.o %.aux.o
> >
> > Ah, so %.o does not match %.aux.o. That answers that. Did you see
> > why s390x is immune? Maybe it defines the target explicitly somewhere.
>
> Not yet :/

Strange. Both unpatched powerpc and s390x have these lines.

   Looking for a rule with intermediate file 'powerpc/emulator.aux.o'.

I think that's why it's considered intermediate at least for powerpc,
but I can't see why s390x is different... oh, taking out the .SECONDARY
lines makes s390x delete the aux intermediates. I guess those targets
transitively depend on the aux files which prevents the aux from being
deleted.

Is that fragile? I'm not sure. The patch that introduced them was not
solving this problem (that came before your %.aux.o target patch).
s390x does not need any .PRECIOUS targets at all at the moment.

I guess that mostly explains things.


> But what was also interesting is that if I=E2=80=99m using multiple
> jobs I don=E2=80=99t see the issue.
>
> make clean -j; make -j; make -j # <- the last make has nothing to do
>
> if I=E2=80=99m using:
>
> make clean -j; make; make -j # <- the last make has something to do=E2=80=
=A6
>                                   that something that irritates me

This is with s390x? Maybe with parallel make, the target is getting
rebuilt via a different prerequisite that is not a .SECONDARY target?
Adding %.aux.o in PRECIOUS there should help in that case.

> >
> > Is it better to define explicit targets if we want to keep them, or
> > add to .PRECIOUS? Your patch would be simpler.
>
> Normally, I would say without .PRECIOUS it=E2=80=99s cleaner, but there i=
s
> already a .PRECIOUS for %.so=E2=80=A6 So as Andrew has already written
>
> .PRECIOUS: %.so %.aux.o
>
> should also be fine.

Okay, for a minimal fix I will do that.

Thanks,
Nick

