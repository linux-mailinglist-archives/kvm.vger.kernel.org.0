Return-Path: <kvm+bounces-19659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 464A6908689
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 10:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E35C21F27DE5
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 08:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A200190463;
	Fri, 14 Jun 2024 08:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V/ULAhgo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FD518FC84;
	Fri, 14 Jun 2024 08:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718354344; cv=none; b=bbyg3FIqUIwekDpGdW7eczZGnU3aDGxwThIhxVo49nb5RY7W4AGfQidRYOSKk6uyx+kWC2Qw36zptl6Es77BlU8xkvAfeJRVLZH1H1eN7+Qa9A6w4ASaSqVJ8oUbMYfBH2JWOt2ot6IudAm/ntofjWvfBb5a+ZTiWoK8dTFF+Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718354344; c=relaxed/simple;
	bh=RVJ3HNfS/LTVgt0bhHVJerIJHiZbdVxp4/zR+A9dP3w=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=FSZ0T8v4h0hkwDg4gOU5D6NYhrntOIOtgCWwcyfccJ17R0divTQ/nzj8NAJkcf7AKIEah1/z7QTZyVFeMmsdZNxwNtkEIsOIWxkzBIQi5KbNErMf2mHeoeYIW1EPhOccr7CyvDaPbsgTCYmgUgZgNmvbNX6GSeyas7f5TGExc/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V/ULAhgo; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-705cffc5bcfso1392160b3a.3;
        Fri, 14 Jun 2024 01:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718354342; x=1718959142; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NGy8Qk7vHjHfh3JaIY/2KaWeJmy159LbqRE46FH8bXg=;
        b=V/ULAhgopLt2G9oiOgNMzmhZuoJWZIrIppBKZecQO6bH6c9YMPqVNERdgpTv3L+pkw
         OZx021tMr5KUt3uVKrTXn0Y2Ls9hzWEAhz8SAYTKGo5BTiQ75bXg+YWOg2O0OuhSoW3N
         t4hO248cd+TskEtKrO/mlArhUzKQ72IDbMR6USwiLO17cwqtsBnAkVTUY2Wi6vMvLPn+
         uKHxYpcw4OiQQTXLCumeycAT7zKwDoCKejEwCF2rz4o8364tveWGPnZjnr/+8UA0W1Gr
         UV8+i/6cQkofxPNXan9AICEVWP7l1T2cxA1+cQ/F1kEOVv8Uc4K3pmN/d7NmNqLoNg0K
         EWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718354342; x=1718959142;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NGy8Qk7vHjHfh3JaIY/2KaWeJmy159LbqRE46FH8bXg=;
        b=O3vix/XIIVGXYlJHEXTwR92EfarCgXzH8r9swJY9PFWHAEguMnFbXIuvqQlr47uvgX
         AgrEa4XUWRfFgoidNQK7owGD4gxr7NU5pAjiMftTtE4S1dWMW+vE45aRheRpmyu1UafA
         1uwih4vdxoaFKvS7D2S/GJ0XQGW2iPIgWgCGxE7lPEzAe5PSDSr3lGU5+jFO1P9/jcMK
         Hlu3zqcVTJskRAZPdHgmTpompwqvNkVqV8+QeyMNqzVcRoYCgxyVnJ+WPwCbgICV7ZGn
         4RdsHzj2GLPSweaWuFQtStwpMUt7R8+oWSwi/BJkuvC1xLjtgMdc3mZ7XOTu1Sr9/q1P
         DluA==
X-Forwarded-Encrypted: i=1; AJvYcCXg/pcP5Ql6mI0hkHs6VMX74GaxNm6OQd+jEgc5vYOLPKxTKLHLwUb6RL1UtFJ9rMqUrNk0Ixrq3N0oE1JDzPcTktwNxi0iB7uAnMZS+7kgB7s3EuYOonTjyuQOzyhsXA==
X-Gm-Message-State: AOJu0YyhxXWQhhtb9xkORGlWV0z7kqQEjLZxmHXWfe2XLNoJj00o0QBp
	n+KqcbZxiQoQbo8gI6JbxUelIPX2WXl6pB3g7arwZKKFelgqMika
X-Google-Smtp-Source: AGHT+IE6pXW+ie68+vtXwkMfCghwPmHr4/AQacJLhgnTEyIreahfjP48hPsxIsT9zufhQ8cyfHE9eg==
X-Received: by 2002:a05:6a21:81a9:b0:1b5:69cd:87c with SMTP id adf61e73a8af0-1bae7e88366mr2104777637.27.1718354341640;
        Fri, 14 Jun 2024 01:39:01 -0700 (PDT)
Received: from localhost (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a769beb8sm5500935a91.41.2024.06.14.01.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 01:39:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Jun 2024 18:38:54 +1000
Message-Id: <D1ZLRVNGPWTV.5H76A3E8DJCV@gmail.com>
Cc: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>,
 <linux-s390@vger.kernel.org>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <kvm-riscv@lists.infradead.org>,
 <kvmarm@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [kvm-unit-tests PATCH] build: retain intermediate .aux.o
 targets
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Segher Boessenkool" <segher@kernel.crashing.org>
X-Mailer: aerc 0.17.0
References: <20240612044234.212156-1-npiggin@gmail.com>
 <20240612082847.GG19790@gate.crashing.org>
 <D1ZBO021MLHV.3C7E4V3WOHO8V@gmail.com>
 <20240614010856.GK19790@gate.crashing.org>
In-Reply-To: <20240614010856.GK19790@gate.crashing.org>

On Fri Jun 14, 2024 at 11:08 AM AEST, Segher Boessenkool wrote:
> On Fri, Jun 14, 2024 at 10:43:39AM +1000, Nicholas Piggin wrote:
> > On Wed Jun 12, 2024 at 6:28 PM AEST, Segher Boessenkool wrote:
> > > On Wed, Jun 12, 2024 at 02:42:32PM +1000, Nicholas Piggin wrote:
> > > > arm, powerpc, riscv, build .aux.o targets with implicit pattern rul=
es
> > > > in dependency chains that cause them to be made as intermediate fil=
es,
> > > > which get removed when make finishes. This results in unnecessary
> > > > partial rebuilds. If make is run again, this time the .aux.o target=
s
> > > > are not intermediate, possibly due to being made via different
> > > > dependencies.
> > > >=20
> > > > Adding .aux.o files to .PRECIOUS prevents them being removed and so=
lves
> > > > the rebuild problem.
> > > >=20
> > > > s390x does not have the problem because .SECONDARY prevents dependa=
ncies
> > > > from being built as intermediate. However the same change is made f=
or
> > > > s390x, for consistency.
> > >
> > > This is exactly what .SECONDARY is for, as its documentation says,
> > > even.  Wouldn't it be better to just add a .SECONDARY to the other
> > > targets as well?
> >=20
> > Yeah we were debating that and agreed .PRECIOUS may not be the
> > cleanest fix but since we already use that it's okay for a
> > minimal fix.
>
> But why add it to s390x then?  It is not a fix there at all!

Eh, not a big deal. I mentioned that in the changelog it doesn't seem to
pracicaly fix something. And I rather the makefiles converge as much as
possible rather than diverge more.

.SECONDARY was added independently and not to fix this problem in
s390x. And s390x has .SECONDARY slightly wrong AFAIKS. It mentions
.SECONDARY: twice in a way that looks like it was meant to depend on
specific targets, it actually gives it no dependencies and the
resulting semantics are that all intermediate files in the build are
treated as secondary. So somethig there should be cleaned up. If the
.SECONDARY was changed to only depend on the .gobj and .hdr.obj then
suddenly that would break .aux.o if I don't make the change.

So I'm meaning to work out what to do with all that, i.e., whether to
add blanket .SECONDARY for all and trim or remove the .PRECIOUS files,
or remove s390x's secondary, or make it more specific, or something
else. But it takes a while for me to do makefile work.

Thanks,
Nick

