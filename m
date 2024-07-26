Return-Path: <kvm+bounces-22282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F9193CD26
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 06:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9201BB21604
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 04:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A049F2745D;
	Fri, 26 Jul 2024 04:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BFN+DifJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781DB22612;
	Fri, 26 Jul 2024 04:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721967310; cv=none; b=lruKGc37QQ4ouamUnhnVoRr9x2n7vZg74mhS0kxz9EEKJSsaiQ4/4cRa1XRjiZjJwIL0cK7fZJh0m1DPy7hBTfuPEQ+3GZ3tBXRo5bq14pBHNbaFL6W8fB2FlEfffnlOwFK9fX5Jbn30SRS9QSN9HwTBuP5aXc+JTr0oSLHz134=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721967310; c=relaxed/simple;
	bh=gIKFqyMJQYAqXJDAdieEmwb8TBBzQrThuJSv7pNtuRM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=pjSgywLhGShV8YS0sy0kmnsy85qgeT4wkI7e1XJy1wYhiFnni4sUY5Ro7Wv7EVCgyK06+jS0CwTKld4qekdT1MPHfc1K1PzgkSpkG99UZNhkJ7rOXPCZ/ZhpumE3TOHznDmJ8cnqFAeYshIZxTqUCGSccPC7HOJC4FSXJEe1mwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BFN+DifJ; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-75cda3719efso388957a12.3;
        Thu, 25 Jul 2024 21:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721967309; x=1722572109; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f3jDQgJjkOPkFdNASGIQMdZJ31Vgc4apYAqzb/U5CKI=;
        b=BFN+DifJYmsRieRGKBvKfSCDaJDiMANgBD/wnZJqNgt/Fe1WKFg6udwKLg8zMAcVue
         Beded8Gz5HV9T4l0KorrDoG0VpVXHrbJiVXOa03gxRhvDptj0tD4kCNbBV287ftaxT46
         P9rs0GdAFuN4h3C2OB+CvUlUXBZyC+Po/LPQVHbm+MjDIDsipV+ULQQVNAHTn0Ng+7zz
         YieJiZpw5ZDrxEEJHKMOV4JC5PjGzbZ7cSQqSMIlCGioBIC8Dps/Toae73wKKNvb7hoC
         yk2zD0wDxM+G+EX6Z89K+0B2dPkrlK3HF6PEBUQhEyspfKivWQTbQBYAfR36i+BpVyql
         gqpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721967309; x=1722572109;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f3jDQgJjkOPkFdNASGIQMdZJ31Vgc4apYAqzb/U5CKI=;
        b=sMOhFOuJF14GHo0BZJ0C+YcZg3ToGnBir4pJq9Os6QoopFOkfYzl0yPV61hA9gAtNH
         m7hPFs+vQzXiza91b0YNbYdZNbFB8mC0UNe1bHVHr1I8F0yQn5H7uobpdsZsv9nLbGHP
         j9CTGKVGfA+sE0DBgR+lDNiwFzC2yDbb6N9dGhJ/3MsJwh1c+B9ocxsCTOtIDlZpiGyf
         yEAgXWatEd8Y2OBYLmZaNdrhk6sxH0kSnLlSy8H8D/YYs2YkkGFV68Uy7Bc9GWYzWmW8
         ZCQH/KXE5IIX7N4hLTvdnadDruElDX8xcomopoCZbbR0JJljwmOmhwTb90JHa0i92peI
         WPAA==
X-Forwarded-Encrypted: i=1; AJvYcCUAeXOnH0u6SOn779WJp7fCUWHbfJQNUuQVwPW1AulF4e16sz29XbLecFlOaVSt3r12psPuSWg/2j+uCUqZcCifWIKEdAXuHCcA7ZIK7ir47GUHkkRVTfVRCrTHfC+/Hw==
X-Gm-Message-State: AOJu0Yw5s5lUDWG0s6kCQuAb8StkJUkPrO5SIhk/MgBr3BS35ImeX/f2
	eeoiaPlqQnyGNyzfkwoXvGwoiJBODucFcxV6lTv59x9AKp6yJr5y
X-Google-Smtp-Source: AGHT+IFmN17I4J5GSEbfLIh57WYix6Z4DqY06Of+f+JtOC/7oBUIVl0iyJ5AherVGcrUqk8gycWzzw==
X-Received: by 2002:a17:90b:3e8b:b0:2c8:538d:95b7 with SMTP id 98e67ed59e1d1-2cf238ccb87mr5415523a91.32.1721967308684;
        Thu, 25 Jul 2024 21:15:08 -0700 (PDT)
Received: from localhost ([1.146.16.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cf28c9cef7sm2365286a91.29.2024.07.25.21.15.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 21:15:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jul 2024 14:15:00 +1000
Message-Id: <D2Z6GP2VFOJ8.2KU7OB25CUXTC@gmail.com>
Subject: Re: [kvm-unit-tests PATCH] build: retain intermediate .aux.o
 targets
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Nicholas Piggin" <npiggin@gmail.com>, "Segher Boessenkool"
 <segher@kernel.crashing.org>
Cc: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>,
 <linux-s390@vger.kernel.org>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <kvm-riscv@lists.infradead.org>,
 <kvmarm@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>
X-Mailer: aerc 0.18.0
References: <20240612044234.212156-1-npiggin@gmail.com>
 <20240612082847.GG19790@gate.crashing.org>
 <D1ZBO021MLHV.3C7E4V3WOHO8V@gmail.com>
 <20240614010856.GK19790@gate.crashing.org>
 <D1ZLRVNGPWTV.5H76A3E8DJCV@gmail.com>
In-Reply-To: <D1ZLRVNGPWTV.5H76A3E8DJCV@gmail.com>

On Fri Jun 14, 2024 at 6:38 PM AEST, Nicholas Piggin wrote:
> On Fri Jun 14, 2024 at 11:08 AM AEST, Segher Boessenkool wrote:
> > On Fri, Jun 14, 2024 at 10:43:39AM +1000, Nicholas Piggin wrote:
> > > On Wed Jun 12, 2024 at 6:28 PM AEST, Segher Boessenkool wrote:
> > > > On Wed, Jun 12, 2024 at 02:42:32PM +1000, Nicholas Piggin wrote:
> > > > > arm, powerpc, riscv, build .aux.o targets with implicit pattern r=
ules
> > > > > in dependency chains that cause them to be made as intermediate f=
iles,
> > > > > which get removed when make finishes. This results in unnecessary
> > > > > partial rebuilds. If make is run again, this time the .aux.o targ=
ets
> > > > > are not intermediate, possibly due to being made via different
> > > > > dependencies.
> > > > >=20
> > > > > Adding .aux.o files to .PRECIOUS prevents them being removed and =
solves
> > > > > the rebuild problem.
> > > > >=20
> > > > > s390x does not have the problem because .SECONDARY prevents depen=
dancies
> > > > > from being built as intermediate. However the same change is made=
 for
> > > > > s390x, for consistency.
> > > >
> > > > This is exactly what .SECONDARY is for, as its documentation says,
> > > > even.  Wouldn't it be better to just add a .SECONDARY to the other
> > > > targets as well?
> > >=20
> > > Yeah we were debating that and agreed .PRECIOUS may not be the
> > > cleanest fix but since we already use that it's okay for a
> > > minimal fix.
> >
> > But why add it to s390x then?  It is not a fix there at all!
>
> Eh, not a big deal. I mentioned that in the changelog it doesn't seem to
> pracicaly fix something. And I rather the makefiles converge as much as
> possible rather than diverge more.
>
> .SECONDARY was added independently and not to fix this problem in
> s390x. And s390x has .SECONDARY slightly wrong AFAIKS. It mentions
> .SECONDARY: twice in a way that looks like it was meant to depend on
> specific targets, it actually gives it no dependencies and the
> resulting semantics are that all intermediate files in the build are
> treated as secondary. So somethig there should be cleaned up. If the
> .SECONDARY was changed to only depend on the .gobj and .hdr.obj then
> suddenly that would break .aux.o if I don't make the change.
>
> So I'm meaning to work out what to do with all that, i.e., whether to
> add blanket .SECONDARY for all and trim or remove the .PRECIOUS files,
> or remove s390x's secondary, or make it more specific, or something
> else. But it takes a while for me to do makefile work.

Hi Thomas,

Ping on this patch?

Thanks,
Nick

