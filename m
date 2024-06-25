Return-Path: <kvm+bounces-20450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9BB6915D2C
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 05:13:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2943282FBE
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 03:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FA8847F46;
	Tue, 25 Jun 2024 03:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HOIkfbOh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A9C1BC4E;
	Tue, 25 Jun 2024 03:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719285228; cv=none; b=jqShgzbGjenLmMNKRwLVYTL2b+tjYJrHNZxu0DI7AEAIOUX6ejkRWPi5YOW19u0ZaRx9uYdjC4bj726UThsd4lEiGjuW4hP+cOISZlk9m8YRvUwkbZeCN7oqad4oe518t78d2GQ4gUrpBhtiX6KdGj6HKGLs/v5CG6q2yztpChw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719285228; c=relaxed/simple;
	bh=WDjSjDojkiErU76xJpHFzFNIRPCN3K/4f0JHQxkcQfw=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=P5RdGEXua0bYWYY8QA4rYm4p4MXzagLsZaj+ynK1vtg6291x+mO2NGjUp4XtgAmxOmovO1yOJrbGCwkk0hAdpp0X2T+XlbZP/DNYqumU2umJL33/H2btejDv6gRBp734gwiO8Va7P0zK00P9n55ybTFmdt3fWAVG2XjzI3jG73E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HOIkfbOh; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7066a4a611dso1736706b3a.3;
        Mon, 24 Jun 2024 20:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719285226; x=1719890026; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YX01MQ0PmkZNuQg/PPzur/EELEalkimrnmfVrm4BEss=;
        b=HOIkfbOhQxtS2MPxwpr7QAdrhxwL2iP856vrjQoavliwQIfHooQ+KaakY7d9DCshvd
         4BNm1ldPG9pgjKtftEHUSbXlgOXYPCA/a4nwhmSVYVFIpX4dDbxHULL2NJTrcRCiLQWw
         AFe+6WREEShKYXJC1lNwHxg8pq05lgd7A3cffDjuxufqonND8wIWvyhHnxw+aRtNaXmN
         FQnMnBt/KzQ8pC8D2OkyftbNF3uT9XW0NKFqmvqIh+8krtzs6n8yPXnuu9ZUzXd7Cawh
         inCsvm+KuUptLEUArj4qQznvpoz+JVVnB0ePT34cXlUfhrFNI9reiQ86lcwV1SKa/IIj
         CbKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719285226; x=1719890026;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YX01MQ0PmkZNuQg/PPzur/EELEalkimrnmfVrm4BEss=;
        b=tR5o75/VJyJ0J2MTf5Vy2zeAmVxcIHQPr8dd8PHCHiycXNsHgiQwgX1P+U7OqeBM71
         MSG9DPFQAAdV+MMqqcGmbPWEUhAKL4Sc2ZQ4fP/j2ToJSBPXRqGfSPGhSBeKVTiymDZj
         5Nmc5IGOeFetgr/LZMoweLeK2iFbT6K0/N/c0AbRDWjSIu9Q/cHVauF1dOMOlXp2jOvM
         ADcjytIDOfEGf2Soc9oygetkVBOJATmOZ25QZALmnsCn3xmwcyUsMvTw5xRS+C3DTNsX
         DGABuqMxfPGW1UgFvQNWl7fScB8z8SacGniEtcujOOqYweBxhw9aLi/lnNz8xAaxsfmt
         7s6g==
X-Forwarded-Encrypted: i=1; AJvYcCXtRgeg6tmInAgBB3gSNuj2M1igL435eYMzkVcIo/c55B7UzKioJHYD8J1YgCIwiE7bQQjjPl6T9dBDaYxa7udKMOCvtFRgdOUc/M3xy63wIk0VNj9VfUfWljIDfILHOg==
X-Gm-Message-State: AOJu0YwG8isLWk1ti9IkaJOmuxhpYkDa+NX7UpVRsSQLtcZCNOHAZwog
	z7m3c3kwQdTgtqJT20NrzYKTSTthiGmEIiFBN07KqWI0xTH22sR8JElgaw==
X-Google-Smtp-Source: AGHT+IE1rC+0h3uwku4PL7ut0uXNEZCH9Tr3mugFaLv7ThMJqOs5VfHJcnMrzExzujNkuiG1oA80Ig==
X-Received: by 2002:aa7:8584:0:b0:706:936f:469a with SMTP id d2e1a72fcca58-706936f46ebmr1873907b3a.16.1719285225947;
        Mon, 24 Jun 2024 20:13:45 -0700 (PDT)
Received: from localhost (118-211-5-80.tpgi.com.au. [118.211.5.80])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70684eee5ffsm2662744b3a.175.2024.06.24.20.13.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jun 2024 20:13:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Jun 2024 13:13:39 +1000
Message-Id: <D28RQU9BO6L1.3OKWB7CR7RC5J@gmail.com>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, "Nina Schoetterl-Glausch"
 <nsg@linux.ibm.com>
Cc: "Thomas Huth" <thuth@redhat.com>, =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, "Janosch Frank" <frankja@linux.ibm.com>,
 <linux-s390@vger.kernel.org>, "David Hildenbrand" <david@redhat.com>,
 "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v3 5/7] s390x: Add library functions for
 exiting from snippet
X-Mailer: aerc 0.17.0
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
 <20240620141700.4124157-6-nsg@linux.ibm.com>
 <20240620185544.4f587685@p-imbrenda>
 <c5e1cccdd7619f280d58b2ef00c076d5426e764b.camel@linux.ibm.com>
 <20240620192614.08ff9c65@p-imbrenda>
In-Reply-To: <20240620192614.08ff9c65@p-imbrenda>

On Fri Jun 21, 2024 at 3:26 AM AEST, Claudio Imbrenda wrote:
> On Thu, 20 Jun 2024 19:16:05 +0200
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>
> > On Thu, 2024-06-20 at 18:55 +0200, Claudio Imbrenda wrote:
> > > On Thu, 20 Jun 2024 16:16:58 +0200
> > > Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
> > >  =20
> > > > It is useful to be able to force an exit to the host from the snipp=
et,
> > > > as well as do so while returning a value.
> > > > Add this functionality, also add helper functions for the host to c=
heck
> > > > for an exit and get or check the value.
> > > > Use diag 0x44 and 0x9c for this.
> > > > Add a guest specific snippet header file and rename snippet.h to re=
flect
> > > > that it is host specific.
> > > >=20
> > > > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com> =20
> > >=20
> > >=20
> > > [...]
> > >=20
> > >  =20
> > > > +static inline void diag44(void)
> > > > +{
> > > > +	asm volatile("diag	0,0,0x44\n");
> > > > +}
> > > > +
> > > > +static inline void diag9c(uint64_t val)
> > > > +{
> > > > +	asm volatile("diag	%[val],0,0x9c\n"
> > > > +		:
> > > > +		: [val] "d"(val)
> > > > +	);
> > > > +}
> > > > +
> > > >  #endif =20
> > >=20
> > > [...]
> > >  =20
> > > > +static inline void force_exit(void)
> > > > +{
> > > > +	diag44();
> > > > +	mb(); /* allow host to modify guest memory */
> > > > +}
> > > > +
> > > > +static inline void force_exit_value(uint64_t val)
> > > > +{
> > > > +	diag9c(val);
> > > > +	mb(); /* allow host to modify guest memory */
> > > > +} =20
> > >=20
> > > why not adding "memory" to the clobbers of the inline asm? (not a big
> > > deal, I'm just curious if there is a specific reason for an explicit
> > > mb()) =20
> >=20
> > Mostly a matter of taste I guess.
> > The diag functions are just convenience wrappers, doing nothing but
> > executing the diag.
> > force_exit is a protocol between the host and guest that uses the diags
> > and adds additional semantics on top.
> > In theory you could have other use cases where the diags are just a tim=
eslice yield.
>
> fair enough

Sorry I missed these comments. I still had a question about the
barriers (e.g., one needed before the diag()?)

>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>
> > >=20
> > >=20
> > > [...] =20
> >=20


