Return-Path: <kvm+bounces-16475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16F608BA685
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 07:12:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0F9D2825C9
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 05:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D71A139586;
	Fri,  3 May 2024 05:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gal2UWz2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D92D139CE2;
	Fri,  3 May 2024 05:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714713118; cv=none; b=d4xP7V6bVaHrvjU72T3ZfeoJ8Ccokc3O314KuPqunL7c69ODZ7jFGqrblGPzx1qrgq5+hdKLqIPUP+DDSa8a2i9X0rSFxyeevJyHx1j84WYh3DRYqAc0NJH0fxGF2vt1WD5+6w/swy3pnuLT/HwKW5V+zJyZajOwOVws16fQH9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714713118; c=relaxed/simple;
	bh=2lI+5lKent2K8tEuLFRUnH6ZlkICjJQbZ5of0+WIQ6k=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=SFXb9lk3FFDCwvSPhvQGekVg/G/9qVsh1I/JYBHX4a9O/X2028FtHZ0k7xS6MUgOjoadtapdr/1Dfa1pvhG9WkhDD1Kf7YEfIykAeH5PHIwaifsmEIHqoXTDxQ2uf+HWM8mrwMsj3C3GMRsL0IQyn3qPxi4TKaMa6vD8jl2ogsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gal2UWz2; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2b43490e0e2so284557a91.2;
        Thu, 02 May 2024 22:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714713116; x=1715317916; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qVJQnrNe19hzb8iS6Qtrjnpbg6L6T8f/09LfWI/32Yk=;
        b=Gal2UWz24/cb7Sj7/jBZgVXwUkxmUA69Iy23bRd3Obs6ECI9BbB8hZISBFYkjXlVhz
         v0ax7oU6Oo312hWcdArij3ihoMBo3JBKrwQzYwkSHDt1AgrJ8JAel2ERdWssYxstjdzC
         UzXAX2Eg4RVfXDuveCfIlRb2vKweh6/tCRNA185AGZW31rmu1/vCDbPpKO4OLyLaI9uC
         ugPxTVJpFMlYUVVQBxGRX8r6Og+0N5PkAyy6A4hCq51Vp9ZKM9wpqsu2rsE5/P9PrkIs
         ltibGFzXcfHnI1sgMn1y7jmdZU5GbYZh4xS+alAQbKlyp4jhx8AU9C6jczwK8qfp9Tpc
         1Jwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714713116; x=1715317916;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qVJQnrNe19hzb8iS6Qtrjnpbg6L6T8f/09LfWI/32Yk=;
        b=T+A3TjssbTLo3qTtam28wmQyfZUK5i5WORvymtDH5AX6H8HUA8rWXl2kTD0EErQtVA
         zp8hXRklbHerM8Z9trLxbRl44nrbytqCUDfHRvLTnDYRhKpGKtlN9JreI/pe6bESvrFD
         UMVBTYJr5pYnEm+jVOBXwOE/tOdyeckj8j66UycIppy7vVLrvnrEeSd9Ag1MjZJ/1gz9
         4y3Ek47oHACXPh6//7SK/fNGRKDwAlwQVSWis6fxFea8fzcg0dQKoQk0azpVkQDhEIHg
         h+x4QWknC0SWphlXBdgBAx2fqpQE6/fKNwyS/u+lUEGjfBQ0+T8ticxsbpzmSaWiMf8j
         TT0w==
X-Forwarded-Encrypted: i=1; AJvYcCWXBcTGSqGGBvxy7jqa1ytL76F70mkdzrhEabQHaE/Sjjx2Oyr4pQQ9Hlyc5w8bm1+wmbaJ1nJKw1suDvUtwc91d9/h0JbHXvA92lEdB+7lI7wG3kR/hjro1vP/DwHVzw==
X-Gm-Message-State: AOJu0YzjzUuiTsyIsvXsVIBTRfHAFR4BfF0xc91vqkVcD7gzwvzKB1GV
	mOtAx7s6VDowOy/vusOmTH48B7Mov/agys1iXN3XCo4UgPlZDrTP
X-Google-Smtp-Source: AGHT+IHox6xrs93zfziRXboCiLK3uSx/+vq6kzUGkZmLDAOcPgXDcKKDNFmojfiV9iUbmzdN9EOATQ==
X-Received: by 2002:a17:90a:598b:b0:2b2:142d:5bba with SMTP id l11-20020a17090a598b00b002b2142d5bbamr1776837pji.17.1714713116223;
        Thu, 02 May 2024 22:11:56 -0700 (PDT)
Received: from localhost ([1.146.23.181])
        by smtp.gmail.com with ESMTPSA id q8-20020a17090a178800b002b24c3fce2esm2384255pja.33.2024.05.02.22.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 22:11:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 May 2024 15:11:44 +1000
Message-Id: <D0ZR2DC2DZ16.1TSDQF6S4AJWU@gmail.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Alexandru Elisei"
 <alexandru.elisei@arm.com>, "Eric Auger" <eric.auger@redhat.com>, "Janosch
 Frank" <frankja@linux.ibm.com>, "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 "David Hildenbrand" <david@redhat.com>, "Shaoqin Huang"
 <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>, "David
 Woodhouse" <dwmw@amazon.co.uk>, "Ricardo Koller" <ricarkol@google.com>,
 "rminmin" <renmm6@chinaunicom.cn>, "Gavin Shan" <gshan@redhat.com>, "Nina
 Schoetterl-Glausch" <nsg@linux.ibm.com>, "Sean Christopherson"
 <seanjc@google.com>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v3 0/5] add shellcheck support
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, "Thomas Huth"
 <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240501112938.931452-1-npiggin@gmail.com>
 <2be99a78-878c-4819-8c42-1b795019af2f@redhat.com>
 <20240502-d231f770256b3ed812eb4246@orel>
In-Reply-To: <20240502-d231f770256b3ed812eb4246@orel>

On Thu May 2, 2024 at 6:56 PM AEST, Andrew Jones wrote:
> On Thu, May 02, 2024 at 10:23:22AM GMT, Thomas Huth wrote:
> > On 01/05/2024 13.29, Nicholas Piggin wrote:
> > > This is based on upstream directly now, not ahead of the powerpc
> > > series.
> >=20
> > Thanks! ... maybe you could also rebase the powerpc series on this now?=
 (I
> > haven't forgotten about it, just did not find enough spare time for mor=
e
> > reviewing yet)
> >=20
> > > Since v2:
> > > - Rebased to upstream with some patches merged.
> > > - Just a few comment typos and small issues (e.g., quoting
> > >    `make shellcheck` in docs) that people picked up from the
> > >    last round.
> >=20
> > When I now run "make shellcheck", I'm still getting an error:
> >=20
> > In config.mak line 16:
> > AR=3Dar
> > ^-- SC2209 (warning): Use var=3D$(command) to assign output (or quote t=
o
> > assign string).
>
> I didn't see this one when testing. I have shellcheck version 0.9.0.
>
> >=20
> > Not sure why it's complaining about "ar" but not about the other lines =
in there?
> >=20
> > Also, it only seems to work for in-tree builds. If I run it from an
> > out-of-tree build directory, I get:
> >=20
> > */efi/run: */efi/run: openBinaryFile: does not exist (No such file or d=
irectory)
>
> I'm glad you checked this. I wish I had before merging :-/

I'll send a patch. Possibly some other targets (check-kerneldoc, ctags?)
may not work out of tree either. I'll fix this one up first though.

Thanks,
Nick

