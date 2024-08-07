Return-Path: <kvm+bounces-23568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C93494AED6
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 19:25:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9036B28F2F
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 17:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DCCF13D8A2;
	Wed,  7 Aug 2024 17:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vojkabYJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F6813D53F
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 17:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723051353; cv=none; b=M5LCEfjhRpGBE1VPLB3C6RPcIakWLU2JLrmBEMEtQmdVDHJee0kj1i2Jt9bwXc+BkV+2gCajAMJis4PJiC5D4GGPfiSQKEIie2tdQUz+JlFowyOzoTz5+8JOBn3yLHW+lkKgAsBM3Eg0XWzK5OChBjvpFXJUcXijewYIubF2LjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723051353; c=relaxed/simple;
	bh=FB03wuWz1lVB1LR8cmxDBitcZxa89F3VugKzV/0aqDk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X8Ly3LrYTLUPs2qEucVrajBBVFKQk4LDlNOZBDmGkfqsiMaZkkb5iQqPmNGuhlv9TiEsYOyHGxzes0CqW3M3G/INPH1e5noC4K5NHW3chU+DgnlBaj6Q9ZADCJBf5n3ogUQSmBuaqhrTL2A9OKwMrmN5I5Ayes04TB/b5ix4G28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vojkabYJ; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-44fee2bfd28so15781cf.1
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 10:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723051351; x=1723656151; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWky7w5Y44GMnU5k0FIP2ItcitwGvR0+r6HDv8rR6Cs=;
        b=vojkabYJm5b5xtMZM5XX/Fz0H6CnRE/ULp268jVWvVux9LJvNo9vEjTZA47bHd9E4S
         6bEEQlIyEqAWstOysSyfyUGywIcUUFaTuXK8nCVFJ6d1HWqgOBeVsf6PoU2d08+BLArF
         CSoFkny0h3DI5LXbjgiGKVyzsGr/8u+kRTTmcy10jPeU8MOA+bWeqRLsW17tOP+Sl6BS
         MaXGToEW+IlIGpE2o6+xd5x/7buk3C4se699BZ3P5Ibm6VJBd4BdySq/z6dd38cTtgmG
         QjhF6VDlLAtVWvalQGApZaBZ6da8Qgf4/bwHIHaln5pHjAux0G5Htw0Sw++w/fSLqfY+
         Z27g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723051351; x=1723656151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LWky7w5Y44GMnU5k0FIP2ItcitwGvR0+r6HDv8rR6Cs=;
        b=OoQ8wzwlag3ALU/0p5C2jFrXqaEDz5qph0drld/2xf9JORBewEygnRruKTWNuoOAWu
         q/K/choroxALxEhZGEclAW0YMQjJHROpCLF7oZqC5DLBrZJ/pFaU6lvsYR4zAK76YeqO
         /QxvevR0zQRWOXqxvcfSwesdezmdVpZfKifIap56U0yBsIL3RbB97/CZgYAK4bzR9zoc
         yFCRGmtQpcnIMOyhbfCLRjZF1d7XgchMy4iO5+SlhTGyLrmSaAUR+qbH4VXQECesNaX3
         dxHJdD2u3OLhGOGkXW5ItHggo4pxOrzpuIl1U7g0b8a4tdEtZTtr+dAn3sMbg2rRTeGY
         naZQ==
X-Gm-Message-State: AOJu0YzGwoFzTZW/xIw4OFbCY56Z9jj6m58DAjC9MoLZsl4r/Xsog+Mf
	/cOoeu3zqJHTwJTjI/2XipOfEan+65GbDxVAKUjvLJL9Tw9rK0OvBw1Q2ULVI/7oUI/B7QH1Hkq
	D44sDHdy5o4TTcfQLuCdAmMhgS03wu1yZxLZX
X-Google-Smtp-Source: AGHT+IFd+q79tszYvqSxFu+Q65wSSLbtU/f7m9GI+TMXMbzFnzWiar7KmKanyMxfgwhNMMOTUJY8dCqJThehgXfoiac=
X-Received: by 2002:ac8:5794:0:b0:447:e0e1:2a7b with SMTP id
 d75a77b69052e-451c7825bc5mr3560471cf.23.1723051350880; Wed, 07 Aug 2024
 10:22:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801224349.25325-1-seanjc@google.com>
In-Reply-To: <20240801224349.25325-1-seanjc@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 7 Aug 2024 10:21:53 -0700
Message-ID: <CADrL8HXVNcbcuu9qF3wtkccpW6_QEnXQ1ViWEceeS9QGdQUTiw@mail.gmail.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2024.08.07 - KVM userfault
 (guest_memfd/HugeTLB postcopy)
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, Anish Moorthy <amoorthy@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 1, 2024 at 3:44=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Early warning for next week's PUCK since there's actually a topic this ti=
me.
> James is going to lead a discussion on KVM userfault[*](name subject to c=
hange).

Thanks for attending, everyone!

We seemed to arrive at the following conclusions:

1. For guest_memfd, stage 2 mapping installation will never go through
GUP / virtual addresses to do the GFN --> PFN translation, including
when it supports non-private memory.
2. Something like KVM Userfault is indeed necessary to handle
post-copy for guest_memfd VMs, especially when guest_memfd supports
non-private memory.
3. We should not hook into the overall GFN --> HVA translation, we
should only be hooking the GFN --> PFN translation steps to figure out
how to create stage 2 mappings. That is, KVM's own accesses to guest
memory should just go through mm/userfaultfd.
4. We don't need the concept of "async userfaults" (making KVM block
when attempting to access userfault memory) in KVM Userfault.

So I need to think more about what exactly the API should look like
for controlling if a page should exit to userspace before KVM is
allowed to map it into stage 2 and if this should apply to all of
guest memory or only guest_memfd.

It sounds like it may most likely be something like a per-VM bitmap
that describes which pages are allowed to be mapped into stage 2,
applying to all memory, not just guest_memfd memory. Even though it is
solving a problem for guest_memfd specifically, it is slightly cleaner
to have it apply to all memory.

If this per-VM bitmap applies to all memory, then we don't need to
wait for guest_memfd to support non-private memory before working on a
full implementation. But if not, perhaps it makes sense to wait.

There will be a 30 minute session at LPC to discuss this topic more. I
hope to see you there!

Here are the slides[2].

Thanks!

PS: I'll be away from August 9 - 25.

[2]: https://docs.google.com/presentation/d/1Al9amGumF3ZPX2Wu50mQ4nkPRZZdBJ=
itXmMH3n7j_RE/edit?usp=3Dsharing


> I Cc'd folks a few folks that I know are interested, please forward this =
on
> as needed.
>
> Early warning #2, PUCK is canceled for August 14th, as I'll be traveling,=
 though
> y'all are welcome to meet without me.
>
> [*] https://lore.kernel.org/all/20240710234222.2333120-1-jthoughton@googl=
e.com
>
> Time:     6am PDT
> Video:    https://meet.google.com/vdb-aeqo-knk
> Phone:    https://tel.meet/vdb-aeqo-knk?pin=3D3003112178656
>
> Calendar: https://calendar.google.com/calendar/u/0?cid=3DY182MWE1YjFmNjQ0=
NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGd=
yb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
> Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l98=
6SngGlhPH?resourcekey=3D0-FDy0ykM3RerZedI8R-zj4A&usp=3Ddrive_link
>
> Future Schedule:
> Augst   7th - KVM userfault
> August 14th - Canceled (Sean unavailable)
> August 21st - Available
> August 28th - Available

