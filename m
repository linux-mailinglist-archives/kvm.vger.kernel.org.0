Return-Path: <kvm+bounces-18604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C9378D7D10
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 10:12:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E6171F21712
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 08:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB8254BD8;
	Mon,  3 Jun 2024 08:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eBeuk6nJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BACE4EB30
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 08:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717402334; cv=none; b=qn5F9vgO7vA6n4jAdQsH5jS4LVgQEYEXouKK2Zm8nrSE6ttaSzbKF4CjfzClfWsXwrxb2MlrBFXnLOhXtOf9s7blQNOzwoFbSw4gX0NkFCFKE6zfbHXAAlslqoTAZuARBqRCa3dklvkpg4DRM3Ofu7JBjd8ItFSbN2F9KFuMfNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717402334; c=relaxed/simple;
	bh=nmSsnf2cPmx50gh5bxIRWgi0kpC4qj4789nShQSjhrs=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=t+JSqU09RgGzT43uUi+omdABe0yiQpu9FrC6mozXiQTNh8/O4vw3vg1E+dzB8K19wOfZdVF2W/a3NPTGH446PD+SgcKhLy9chOPo9GHfrvFY+nPWhkmHwK2lO2vRA+myTKAfP/RkbFgVZrOPBBODKK2aP6WIGrM0WoKj6gARNOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eBeuk6nJ; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1f6262c0a22so21192655ad.1
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 01:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717402333; x=1718007133; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mE4bvdtFEd1mPARE0HRBNtMQyH2EkJczvWPfoKQnrlA=;
        b=eBeuk6nJtR544yjJ9qgCTptiWxhvtQlyHnXxmsjYsSgZQWatQ+8EfqzPrhl0Jnbb3Y
         FnXDbpreniDMJ3FcJT1rmcfuXsmdbnYdBH3sACGCRxxH1yHZJq+JfDczeavFbxx+bDkb
         yJWn2V+7+cqN2+aaDVknZMpvOIFhl+fLHWRZClmYZz2pPi1mOXZqWyZbFJC7Hl6xpaiu
         3eYLFFPJ38wUt3c4icSjnqgQrDeTgSpT6lyPQN2uslgeptPdZa92QVegZHGbJgTCJWCk
         5nUOnVTniMoY7jNkM3IFUZfGjegiSkbybUHsc7N5eQJHo9vU26Qr2fjAhiJOprzt1s+z
         0kQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717402333; x=1718007133;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mE4bvdtFEd1mPARE0HRBNtMQyH2EkJczvWPfoKQnrlA=;
        b=bHm4C6wybBSaAeMnq+drkZGjBzIQA+n0uqAmBp9XPyskCOOxRNGtnbXSZB5eQJ2cmj
         YZErckxL2m9Kh0ntSormGqEU6zvq3KpBvXJtCZ7aGLBMgVzt9820B44YUdu4cB7LIm6N
         1er7kTuJeX9MiOa/t/bFd0McYo+NO1rbWOy0DIJMN6h7RO71EDLGNOS9XcmGdz9p3VTg
         +bYva9PpKUaWrcDCLf1JPmvWnLtsLU3XTsrFPTUA0WhcTut1ojHpec/Ul7gpumJBiAkl
         CguQBiSTLfgzdqLWGoR+8nbe1pgiBUyurKCpUxBuRUMcdAZzj9zvNImV6wVKFPtbHI94
         cM7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUiHNvbznpJDv3/CaKYtco6+xHoSuDfYHVoYQBYXI9h3zZhwTpjwr5tgnQklu8TyaX6RS6RZTibnSerWAaLfC32sPeY
X-Gm-Message-State: AOJu0Yx8Ygec1q+vXPPaGGP2n0yys+APu2I507jPXGbQ8QyrgyUchqgV
	WeaycOMI25t3Mr4PTEB9V3g7vjyEFutWFAtG+X/u8QJUbdgYt6Jh
X-Google-Smtp-Source: AGHT+IEGoE/s/YHHagkia02E3PrBBMCjbU+55Qnq3gQ/LQJkTD3uDu8MxG19IUUgaIhAsrgQVJv/+w==
X-Received: by 2002:a17:902:d486:b0:1f6:6f2e:4a42 with SMTP id d9443c01a7336-1f66f2e4df5mr36805355ad.12.1717402332764;
        Mon, 03 Jun 2024 01:12:12 -0700 (PDT)
Received: from localhost ([1.128.200.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6323e18c7sm58822125ad.177.2024.06.03.01.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 01:12:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 03 Jun 2024 18:12:05 +1000
Message-Id: <D1Q8BCQQPHYG.29QVJF8LL6EDI@gmail.com>
Cc: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 2/4] doc: update unittests doc
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240602122559.118345-1-npiggin@gmail.com>
 <20240602122559.118345-3-npiggin@gmail.com>
 <20240603-740192cec3e3e8cdaaf69275@orel>
In-Reply-To: <20240603-740192cec3e3e8cdaaf69275@orel>

On Mon Jun 3, 2024 at 4:47 PM AEST, Andrew Jones wrote:
> On Sun, Jun 02, 2024 at 10:25:56PM GMT, Nicholas Piggin wrote:
> > Document the special groups, check path restrictions, and a small fix
> > for check option syntax.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  docs/unittests.txt | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/docs/unittests.txt b/docs/unittests.txt
> > index 6ff9872cf..509c529d7 100644
> > --- a/docs/unittests.txt
> > +++ b/docs/unittests.txt
> > @@ -69,8 +69,11 @@ groups
> >  groups =3D <group_name1> <group_name2> ...
> > =20
> >  Used to group the test cases for the `run_tests.sh -g ...` run group
> > -option. Adding a test to the nodefault group will cause it to not be
> > -run by default.
> > +option. The group name is arbitrary, except for these special groups:
> > +- Tests in the "nodefault" group are not run by default (with no -g op=
tion).
> > +- Tests in the "migration" group are run with the migration harness an=
d
> > +  expects the test to make migrate_*() calls.
>
> expect make migrate_*() calls.

Not sure if I follow you, but the grammar does sound a bit off now that
I read it back. Is this better?

"... are run with the migration harness and are expected to make
 migrate_*() calls."

or

"... are run with the migration harness, which expects them to make
 migrate_*() calls."

>
> > +- Tests in the "panic" group expect QEMU to enter the GUEST_PANICKED s=
tate.
> > =20
> >  accel
> >  -----
> > @@ -89,8 +92,10 @@ Optional timeout in seconds, after which the test wi=
ll be killed and fail.
> > =20
> >  check
> >  -----
> > -check =3D <path>=3D<<value>
> > +check =3D <path>=3D<value>
> > =20
> >  Check a file for a particular value before running a test. The check l=
ine
> >  can contain multiple files to check separated by a space, but each che=
ck
> >  parameter needs to be of the form <path>=3D<value>
> > +
> > +The path and value can not contain space, =3D, or shell wildcard chara=
cters.
>
> cannot

Huh, seems that is the more usual and formal form. I dind't know that.

Thanks,
Nick

>
> Otherwise,
>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
>
> Thanks,
> drew


