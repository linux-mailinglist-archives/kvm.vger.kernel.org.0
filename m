Return-Path: <kvm+bounces-16783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 376538BD9F0
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 05:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E684228372D
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 03:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7BC542AAE;
	Tue,  7 May 2024 03:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WO9K1vfN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E6E4F887
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 03:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715054254; cv=none; b=I3atTnpnwck78EFcihdPazhEBAXdmCEKkt/EVgS1hH7TLS6BvFNiwQbaPk0vkALPio11zyavkt0A6WMtlg9yy74PlcAv6FJCGUVl0/MOvRabD6C9N+fKsxOTzQy9e6p0bYAvI/YXByWnSJm/LtQke5cSGwIVwtxD2eGVW+RDCmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715054254; c=relaxed/simple;
	bh=RojTkLusmGcZDHDtaX+9TdgHwGLkfgVlIH0VupUNFKY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Y4rGjEv2l/EAgvgc4ie3WfN6sBiP7VRZgXYJEIxOZ8FxTXLYJCE69vDuwAodHHeAsCJDDOzzt+6cxFXAkeajXs/OPRSjBzH5UNstM9bh5GvitNhmsflt5lz/NdS7zu3qu59bOLN/cSz0l4Ia5KfT3Ho3ZR/eQn4BcYc8FpQUFE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WO9K1vfN; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1ec92e355bfso25273745ad.3
        for <kvm@vger.kernel.org>; Mon, 06 May 2024 20:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715054252; x=1715659052; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2cs0fpmc057SmgZuvUqhV6BRJkkXjYOTVxjCTsqmYg=;
        b=WO9K1vfN8teP98amKSovFpG22WdnWSgSGiXEKoNzzeHXd/C2ZcmohNwvA5hAqB9ZMx
         wV+518dWILIAu8zr1dXFvTxkMu7QGOi+tyyw1aG01Ro+Gp/LpEf0rnDeQ4mjGF5GLBdP
         GvhanF8P6Z/7ZN/c9yH5tvXp2Myh/Z5zUftxeDNSo5epsXemvrKdICbM7iputMlHirBo
         CdBgvLmq4kDXyZZ6UeYccDzT0E6a5vzVSAos9xqNp/ToV5WWZsqUsBkrHiNxDJQ3Gnvl
         hQJCGNxGC3d6Gu//W2DSTmOXrNmrL79e7s/tMZQNfCLq37YpTOIkIET6h5SxAoQ0yAfi
         t8Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715054252; x=1715659052;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=R2cs0fpmc057SmgZuvUqhV6BRJkkXjYOTVxjCTsqmYg=;
        b=K5ck1PgOWr5dXzP4QWv4aNqZgzOkHbWD4pe/RBP9+FifihwzCvjTm/5LwNlZxB6Otz
         cJwlnQjFoUng4xog4TeLeCWk7XbsY5m+RkyLd7lSGFJa7tx5vBXPjVh98EMSYXoUzCrZ
         7Kdurtpmlwvt8TnK7XveJNCXq2MIsHxtirmDpKIpSvQaJBiK7PCW/wIhx9CIHRDtTair
         PnIRYnW56nlpKz5wut9NS6rOggkYw1zv03hB4iKlQglHavQmD9D0n8wvU7+bnLR+4EeE
         QpGFVvMqDFIXzVQCdyBRDMLs3teeE5cmKTzIZk/Wy1EbBYqMhkRF7uaVvpAzzYdKMnFp
         8TaA==
X-Forwarded-Encrypted: i=1; AJvYcCXNMjK7YpgPmry5G9iJcsrzOaSDm+VuhZjl8Wts9HaCrj3PsXuaksgiU+BGoTUvj9WZ6T2X9CDIu0WRNRCuqnLxTcbh
X-Gm-Message-State: AOJu0YwHid4htRinYOwBahrRIN2gPjyqHtfLMdvbgEhE4huATVkv9+dW
	VCmg30fX9A3hXQ1fEF7fLt8n9r5jkkIqBhF3snb4E7sRzKJ1e0Ic
X-Google-Smtp-Source: AGHT+IFnsSAWAlTgWGgEMXfTnsR6Yjv2EsMgnVAbQPN7Mf2KfnP5wxrcw/efQSk4vLwCeVuNMhmAyQ==
X-Received: by 2002:a17:902:d486:b0:1eb:4c47:3454 with SMTP id c6-20020a170902d48600b001eb4c473454mr18442927plg.0.1715054251926;
        Mon, 06 May 2024 20:57:31 -0700 (PDT)
Received: from localhost (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id n15-20020a170902e54f00b001e4d22f828fsm9052639plf.33.2024.05.06.20.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 May 2024 20:57:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 May 2024 13:57:26 +1000
Message-Id: <D133ZNVZZZM6.24D8Z032EFSRO@gmail.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v9 01/31] doc: update unittests doc
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-2-npiggin@gmail.com>
 <5cde6ee7-eabc-414b-a409-24a6ed141b39@redhat.com>
In-Reply-To: <5cde6ee7-eabc-414b-a409-24a6ed141b39@redhat.com>

On Mon May 6, 2024 at 5:03 PM AEST, Thomas Huth wrote:
> On 04/05/2024 14.28, Nicholas Piggin wrote:
> > This adds a few minor fixes.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   docs/unittests.txt | 12 +++++++-----
> >   1 file changed, 7 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/docs/unittests.txt b/docs/unittests.txt
> > index 3192a60ec..7cf2c55ad 100644
> > --- a/docs/unittests.txt
> > +++ b/docs/unittests.txt
> > @@ -15,8 +15,8 @@ unittests.cfg format
> >  =20
> >   # is the comment symbol, all following contents of the line is ignore=
d.
> >  =20
> > -Each unit test is defined with a [unit-test-name] line, followed by
> > -a set of parameters that control how the test case is run. The name is
> > +Each unit test is defined with a [unit-test-name] line, followed by a
> > +set of parameters that control how the test case is run. The name is
> >   arbitrary and appears in the status reporting output.
> >  =20
> >   Parameters appear on their own lines under the test name, and have a
> > @@ -62,8 +62,8 @@ groups
> >   groups =3D <group_name1> <group_name2> ...
> >  =20
> >   Used to group the test cases for the `run_tests.sh -g ...` run group
> > -option. Adding a test to the nodefault group will cause it to not be
> > -run by default.
> > +option. The group name is arbitrary, aside from the nodefault group
> > +which makes the test to not be run by default.
> >  =20
> >   accel
> >   -----
> > @@ -82,8 +82,10 @@ Optional timeout in seconds, after which the test wi=
ll be killed and fail.
> >  =20
> >   check
> >   -----
> > -check =3D <path>=3D<<value>
> > +check =3D <path>=3D<value>
> >  =20
> >   Check a file for a particular value before running a test. The check =
line
> >   can contain multiple files to check separated by a space, but each ch=
eck
> >   parameter needs to be of the form <path>=3D<value>
> > +
> > +The path and value can not contain space, =3D, or shell wildcard chara=
cters.
>
> Could you comment on my feedback here, please:
>
>   https://lore.kernel.org/kvm/951ccd88-0e39-4379-8d86-718e72594dd9@redhat=
.com/

Sorry, missed that. I didn't mean to re-send this one.

Thanks,
Nick

