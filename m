Return-Path: <kvm+bounces-11920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D31587D2B5
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 18:25:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E9881C2229D
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 17:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 258F8482C6;
	Fri, 15 Mar 2024 17:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qAWJM8QR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D4145C1C
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 17:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710523546; cv=none; b=Y5bd3eMtl8lyGzWwbRbhTokAIvwTLwuNYrabNRWUwefSNhv4TU6+cEfkT15nCg5Y9+E606By9eeICnSl580Czj1vqKFqK+PbPYh+Re0nxwjjOh+8pH9L+Vz/39YuMBlry1rq595d7GFm/zS/gLVwlnQFrU2BfthAp4m3nZ2YWzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710523546; c=relaxed/simple;
	bh=eeKd4spMf+Uy0PlUDK9x/iwKFMO+wzelF5PbI7I8mVU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NnQO4xb9i3iLrkRnIZWgef7F1OjAi+j9pTN14mjFUpf6xKxCTt1un3UAyS9cP9ITp1VAwuxRej6Y6S9ohvZD2nBHvwjRWZMC5fesc8If4tHUl7WPKG/1rEIQCOFZpUIl4MAbGtBS2THPvT18R7JVn6o5sUKw1/hMP9LJgtvaWMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qAWJM8QR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-29c751d57ddso1903856a91.1
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 10:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710523544; x=1711128344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m4Vnl5HwZiL6Q7VrzAb9hY7moF6rWo1bsM5QKtkdFQc=;
        b=qAWJM8QRFAGVl3hkmzrErZA9TYurBHlqHcI3BRF5VpMXiy4hSsG8DJCBay1ChBiniM
         6AUZMeOlKc+0CLt+h5C+2rwtGbbp+zjQVhs5098V2Cg3QkdrIB5uoiFLGXg6WB0CQijt
         hAf4/weYd0Cuv6lkuay4YL2vRcXRQHhgL5PeNNwHhQmlKblpL2UcqkU2dgNEm14nuvV2
         zLIDhg+MA+nD2YD1JfoDZ6K3ZFSieBe2ss+EBKOVO0pK04RooHF9dWdl2+2fkzqA9hrZ
         LfRuuGYAdJzPh6fDPUvLj4OS6dDzIWbv7JTL9tliqnuKzmFV+2DDAL10pOXtm3dd+Djv
         H06w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710523544; x=1711128344;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m4Vnl5HwZiL6Q7VrzAb9hY7moF6rWo1bsM5QKtkdFQc=;
        b=xLfFU+kcE56OaqY85hB27KDuQzdY6No/LjcuZosdDarauhJWRuxUIRZHngt58Hbysp
         Oh4Y1UsEUQxB1FhLfu/JoG76Ho00sLHNlyIj+THneXlvskLjP8mUnUTl9xL2RlJ/oWVC
         9bNF5ybE+nIF7iRwjLHEdOWkh88sNLluMiCZ2fEugv24r8HXKB5s0jnFByG3iCSge1++
         2ps4KKp0ioTD0lXpD/qixkG/zyXvR7HXZ/C8RsflISSQXlm7IVScO5dqG6KnIDvshltR
         Z0h8BRc6DvxjlGGNmjbEqUzt+SWlOiTt3k3sbXrZgIbN1GNW/yTxflH8/eJruhexM7xM
         21Cw==
X-Forwarded-Encrypted: i=1; AJvYcCULs5qq44uFisgfJ3/5EV2kU2KY7dpawvuO8Dg6djBiDYpro2PM/K1jxC9U1vMEpSTXFgXjXjwvMxDevmR00JJD6/fH
X-Gm-Message-State: AOJu0YyUkPr4Qvkzyu0uMific006vqflgAFeOlF8Iezx13lHW4JXzFIH
	rhZSj+IOzspxGBo0ENrqtCjwtMp9c5o1dEfTdpJ6QDieVOwT4Oghl5mP8AvKpDYvLMvu+kN+19I
	pBg==
X-Google-Smtp-Source: AGHT+IGuoVEOZmu57ryf7R42ne0RICfXK9gAAm5NOxVmQTDuhjeqpmM1Ct6M33yYLk2lfD2kd9rRxNMam2g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c582:b0:29b:f557:3ebb with SMTP id
 l2-20020a17090ac58200b0029bf5573ebbmr13428pjt.9.1710523544230; Fri, 15 Mar
 2024 10:25:44 -0700 (PDT)
Date: Fri, 15 Mar 2024 10:25:42 -0700
In-Reply-To: <CALzav=cLRJOtCyY+DVRWBxBMaV5S8Cy9bBKxmfdUhGLwS0+_6A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240307194255.1367442-1-dmatlack@google.com> <ZepBlYLPSuhISTTc@google.com>
 <ZepNYLTPghJPYCtA@google.com> <CALzav=cSzbZXhasD7iAtB4u0xO-iQ+vMPiDeXXz5mYMfjOfwaw@mail.gmail.com>
 <ZfG41PbWqXXf6CF-@google.com> <CALzav=fGUnYHiEc40Ym2Yh-H6wMRdw6biYj4+e1vZ0xmBDAnsg@mail.gmail.com>
 <ZfOEzMxn73M0kZk_@google.com> <CALzav=cLRJOtCyY+DVRWBxBMaV5S8Cy9bBKxmfdUhGLwS0+_6A@mail.gmail.com>
Message-ID: <ZfSEliJnY5u7y5uT@google.com>
Subject: Re: [PATCH] KVM: selftests: Create memslot 0 at GPA 0x100000000 on x86_64
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Michael Roth <michael.roth@amd.com>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	nrb@linux.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 15, 2024, David Matlack wrote:
> On Thu, Mar 14, 2024 at 4:14=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > >   5. Use separate memslots for CODE, DATA, and PT by default.  This=
 will allow
> > > >      for more precise sizing of the CODE and DATA slots.
> > >
> > > What do you mean by "[separate memslots] will allow for more precise =
sizing"?
> >
> > I suspect there is a _lot_ of slop in the arbitrary 512 pages that are =
tacked on
> > by vm_nr_pages_required().  Those 2MiBs probably don't matter, I just d=
on't like
> > completely magical numbers.
>=20
> That makes sense, we can probably tighten up those heuristics and
> maybe even get rid of the magic numbers. But I wasn't following what
> _separate memslots_ has to do with it?

Ah, don't dwell on that too much, it was somewhat of a passing thought.

My thinking was that the gorilla math for the page tables makes it hard to =
determine
how much of those 512 pages is actually for DATA, versus how much is actual=
ly a
weird recursive calculation for the page tables themselves.  I.e. it's hard=
 to
trim down @nr_pages, because it might no be easy to tell if DATA shrank too=
 much,
or if it actually caused to PT to shrink too much, and so no one touches th=
at mess.

