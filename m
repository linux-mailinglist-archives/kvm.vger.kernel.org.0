Return-Path: <kvm+bounces-16785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C31C8BD9F5
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 06:00:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BAB52837DD
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 04:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B675C42AB4;
	Tue,  7 May 2024 04:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eO+vdG6U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AF53FBA2
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 04:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715054425; cv=none; b=lR4EUwVDqVRGEniF/GfAMKI5sbKhqeHL3DnRtFny9gV35fko1TLLIrq8SSSfbJ7jPY9qJz7u35ArpfGy5mT8GjwWRkMuSEy1fhhSPrRI6lfuk4tZEjua1JgMr1iFMZuDxsX0st81WPsd3AwlcdrtOxAC34wlrLoulqOUwasSrBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715054425; c=relaxed/simple;
	bh=JyYM8AYyZeZdjUxx3m1QEpotm/EdHsR+L51ysqqBf7s=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=l9sFhw7TNdfBWmz9ItGDXcLIKyIdT6Uuqia/0f1LEYmokdK5kRalETJAmis8yFJmEuRIbUCXywBb4etIJtt4nKTaJqc30wLo+SQxjrrd6TKzKGTNJ66JVrzJIj9Bybab3keOcqj0NS7xNFGP1inYuHoCwGiV3oQ/MEDJIuRZ1pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eO+vdG6U; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6ed9fc77bbfso1879313b3a.1
        for <kvm@vger.kernel.org>; Mon, 06 May 2024 21:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715054423; x=1715659223; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4p+EsdbMQKXODN/wr5hE6jaGMNA0+1C45+1wE3DDFis=;
        b=eO+vdG6UeBF0nwMnmGwnLr4ugm0XZ2EgA2y6yQeV+3B0Q/8DVk7LHbD94TPrcTUCXI
         66fJvyFVxmCpvro3t5NojrD/0hD2tijVLukGDdX/xn650RkF42Bo64ekKEe4RsGMebp8
         /TFOouEw3jG7PdaAymh3EiRbV8N1Wl9CiG+6WhUqpoA70LNzvfGrnEb7rF0uFiMJiN1N
         3g4pUkIcE/PDbAe788Gdlcn3fZm9pYiH10cfMW4hHuCbqz7Tm0qtXvrP63DHLQV8AU5H
         2dd9iWpHNLdQteYotwYQQ4YeHnVuMAg+5dSYW+l4Mot65+TM3UEFGAsmRyQLb/brYcFl
         R54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715054423; x=1715659223;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4p+EsdbMQKXODN/wr5hE6jaGMNA0+1C45+1wE3DDFis=;
        b=YSAjEkZWmkGh7MzWwsLs50JgTvbf/GcoYbZD8Mb/HI11w+KsOFQSYQUqdchWBZnvIR
         ADNClX2JwhHYY0nDnWewf7cKvoZX1RF/aMAU3lpKH0kbOt4YEmapNVRElcAa8OlModMW
         6SdLShSbjRn79PzccqvWtXuc/nQwlHewIm7OZiXLj+e3jzS9mUfBEwUig7zSahN5wWdA
         0mOwA7NXM+fXZdj0PJgb5YtXKYvOHqwuPc23ijGu+5CiuSIPAB65DH7FTpAB6HGuUhQu
         pmxLNcwXBpFl9QyQKUVPIPCR+U87sArAnsy4//meeztAqP/bfBmTE1/8zP9yXIcwj7EB
         tQDQ==
X-Gm-Message-State: AOJu0YwLidSZXmLw3wt30dUrV2sXPE8N0XKBjh13lwNX7oEmBV579YA2
	5sGYqRHks1h9nNAEkG23zAlq3YFSOBpnAagKfLu2GxSrJaB124bc
X-Google-Smtp-Source: AGHT+IG4LsbYt7x7sn2V61PCbkmGa9NuwE1O/cH6YDTR9eIIN65bXt4UsVIfYXF6KJMwI4rlolJPvg==
X-Received: by 2002:a05:6a00:1397:b0:6f3:ebb3:6bc6 with SMTP id t23-20020a056a00139700b006f3ebb36bc6mr14684499pfg.10.1715054422785;
        Mon, 06 May 2024 21:00:22 -0700 (PDT)
Received: from localhost (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id s15-20020a62e70f000000b006ecf1922df7sm4899655pfh.36.2024.05.06.21.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 May 2024 21:00:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 May 2024 14:00:17 +1000
Message-Id: <D1341UP541ZT.1OG1CVK7234@gmail.com>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>
Cc: <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] doc: update unittests doc
X-Mailer: aerc 0.17.0
References: <20240503060039.978863-1-npiggin@gmail.com>
 <951ccd88-0e39-4379-8d86-718e72594dd9@redhat.com>
In-Reply-To: <951ccd88-0e39-4379-8d86-718e72594dd9@redhat.com>

On Fri May 3, 2024 at 4:56 PM AEST, Thomas Huth wrote:
> On 03/05/2024 08.00, Nicholas Piggin wrote:
> > Some cleanups and a comment about the check parameter restrictions.
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
>
> This looks like it's only moving the "a" from one line to the other? I'd=
=20
> suggest to drop this hunk.

Sure. Might have just re-wrapped it but it's not a big deal.

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
>
> Actually, there are some other "magic" groups that have been introduced i=
n=20
> the course of time:
>
> - The "migration" group is required for migration tests.

Ah yes good point.

> - The "panic" group is required for tests where success means that the
>    guest crashed (but it's currently only used on s390x).

I actually didn't pay much attention to the crashing tests before but
I should have. Maybe we should add this to a common harness selftest
too.

> We might want to document those groups here, too?

Yeah, hold off merging this for now.

Thanks,
Nick

