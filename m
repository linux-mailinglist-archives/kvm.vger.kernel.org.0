Return-Path: <kvm+bounces-71844-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AL5vBHIen2lcZAQAu9opvQ
	(envelope-from <kvm+bounces-71844-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:08:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A42BA19A42C
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:08:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 625EB3048D83
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 16:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 614923D6674;
	Wed, 25 Feb 2026 16:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dPPZTnFz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="R1DeGTkS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAC13AEF34
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772035382; cv=none; b=poicNFx0DUHutTrXTZWXIVoP6brlB8yYWiD4F7QlPsJ5VPafespu9MKsuDB+YVy9h5l9pxOHmpnH9rKsSysGnmjGu3uX1iKd0YUaVrEBKJNELVGp/OC2yybZU0kQwqIwIhUBvZxTJQStiddYndBJsMNkJPibJTr3X9ZiDzDfng0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772035382; c=relaxed/simple;
	bh=vOBdgb/4xxnB0k/8i8XLjCm3yLM1L1uiiQslDhNAEqc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MnIaKkPDM2hh9bX7/JZK+KZPOgepSGqCMIvAF3KqapBsNmIVe1BF26YxuPvieKots3mWzg4w8zhjyUMWGOVpagPRn5LmtKgJJYhyc18YTOPbVoFxuc62V+CXlE1Uu5L1XAlYIjeBD54045NgJnmdZYZ7NCnFmgATFNBzTlOGt10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dPPZTnFz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=R1DeGTkS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772035380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KqzyfjoTd3ugvhhWlO5qZVx+bIqCO3FPWUdRI3E3aZ4=;
	b=dPPZTnFzI5am86WgdXRqSg0W7L10sKDYC6pXutWrdUzWddGky0Pebc7TMdHUibyzL1VePZ
	fQ2rce1mFKOvAkHrtw+15opmXh/Ucob2dgdMHTOVioXj7l/7Vn1R3M1b+DpYd71QpfdA31
	MMmy9q/w05MRVp3liZCpKTBH9CI7iPo=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-HTs-KeULOW2T_UhCnsLNJQ-1; Wed, 25 Feb 2026 11:02:51 -0500
X-MC-Unique: HTs-KeULOW2T_UhCnsLNJQ-1
X-Mimecast-MFC-AGG-ID: HTs-KeULOW2T_UhCnsLNJQ_1772035370
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-567677cdb20so72380216e0c.3
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 08:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772035370; x=1772640170; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KqzyfjoTd3ugvhhWlO5qZVx+bIqCO3FPWUdRI3E3aZ4=;
        b=R1DeGTkScCIr8PtfK+5d0K0d6VAI39ygeDOmwc4fj44ChXJ99qoafn3zufwRQ4kxJk
         UgRQ1qOZBrl+r+jylE9/V3I8wup/U+jSUpO3etfXQ6A4uugh+bp7nBBSrMZOSmS31rPr
         ZEioYKBgJjpcesjcZHM6Qgqa6kGV0v/J/oLoJRp+W9qYS8yEQ8vqENehSBASN9QjNWR5
         cPG6iyo5qndhnZqGfm43kq8FVtE1Fv7fPssrKxdzRc6e0mFaXqHA6G67f/VzVjVsCccH
         9yUTjdYFje6v4+OUPIe6vDFCEmuOYLmJSqPdEpMJBScL5s+fX0GxOmmDZNjVmDFN7amM
         qTXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772035370; x=1772640170;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KqzyfjoTd3ugvhhWlO5qZVx+bIqCO3FPWUdRI3E3aZ4=;
        b=npKqCxo2zA6E6Jthzu+QLHGBpgjltYqJxkTh7a8vpoqvye2k+aI56SV4xNXSTfeYPn
         ZRainOARgDU0WPls+L5hcQNykVLZhJ4Wfb+M7cuHi86X4NuuMluSWeRDBzgnPT4GMbOJ
         j1K4uFA+QtKgbIj7h35RareLwPRXuaT+zGL/wkBbOUOPH0X8xnHe69leAFoUYYtckmQT
         3CzHvL/0k1n+ZKzH1zLMNUyZCUv94yllJSpAbWkuGhogRCnK2toklCIU7J4cCPdDblcv
         CZ1KA5umNl9IS9uVK/JYtpdHAvk1X022i8R9gjN5MzzJn8+7eUP7Z0C2IStkvAqMKNo4
         johQ==
X-Gm-Message-State: AOJu0Yx2xZeS0kjCMBwMej8R4RjlpsGYi6NC0gyiqKFr0TMjk8kD1iAz
	Yaqhm8WlAcC7Lva5aVf6kCzH1XZrgMBx2379TBaLr4J8PAjzD1e6rAqRidcn8QvytPc4QPr7E1W
	8BnUcm6JAsba6ZXzWolWjMda2oxBse0Arfb9F3KulfbvnRBkUTaef1/1C7vRiBw==
X-Gm-Gg: ATEYQzxhpVX3EhhZ2OaX/Nh3hcz/ewSZb3r6TXLmhI+V4mXjo0c/5a69DoOyBzSA7sc
	VEzDQ1w0Bboxvh8JU3K9KJ4nR6eN/V15NoNbtBaI/SFZqf1fblak0pg3k7KFYMF4/m54CipFllq
	gy5GFKdB1APmkstOK4fNWvF+ump9RfdON3D+QLGPq6u37Hoy258veMogF0EI7/WRYbP9KoiJz/1
	5VemmZhTqhGmvmGp8gXm+ln24Y3HOgZI49ivPiMOJnZsShrDk28CPA7BrVNXUiCWsIm9LUEDNLh
	ivkiT0uuK+rQ5K+pu3XAfOSw7Vohg7Vq86PYXxJHB4G5LQo9K6BqeGSRkK9Y1FCSoWQazIG32CV
	XNhGJIC8i//lXtdyqiWOHKv5irqBY
X-Received: by 2002:a05:6122:4701:b0:566:4689:46eb with SMTP id 71dfb90a1353d-568e455a597mr6239412e0c.0.1772035370361;
        Wed, 25 Feb 2026 08:02:50 -0800 (PST)
X-Received: by 2002:a05:6122:4701:b0:566:4689:46eb with SMTP id 71dfb90a1353d-568e455a597mr6239371e0c.0.1772035369893;
        Wed, 25 Feb 2026 08:02:49 -0800 (PST)
Received: from intellaptop.lan ([2607:fea8:fc01:88aa:f1de:f35:7935:804f])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb8d04400asm1314919285a.10.2026.02.25.08.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 08:02:49 -0800 (PST)
Message-ID: <46a82c25ef7781a5887f7d7722901611605380c0.camel@redhat.com>
Subject: Re: Question: 'pmu' kvm unit test fails when run nested with NMI
 watchdog on the host
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Date: Wed, 25 Feb 2026 11:02:47 -0500
In-Reply-To: <aZ5LaBCiG2PFFXyG@google.com>
References: <10d3f95717b7072e30576b7e3931ea277399fdf8.camel@redhat.com>
	 <aZ5LaBCiG2PFFXyG@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71844-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mlevitsk@redhat.com,kvm@vger.kernel.org];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[redhat.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NO_DN(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A42BA19A42C
X-Rspamd-Action: no action

On Tue, 2026-02-24 at 17:07 -0800, Sean Christopherson wrote:
> On Wed, Nov 05, 2025, mlevitsk@redhat.com=C2=A0wrote:
> > Hi,
> >=20
> > I have a small, a bit philosophical question about the pmu kvm unit tes=
t:
>=20
> The problem with philosophical questions is that they're never small :-)
>=20
> > One of the subtests of this test, tests all GP counters at once, and it
> > depends on the NMI watchdog being disabled, because it occupies one GP
> > counter.
> >=20
> > This works fine, except when this test is run nested. In this case, ass=
uming
> > that the host has the NMI watchdog enabled, the L1 still can=E2=80=99t =
use all
> > counters and has no way of working this around.
> >=20
> > Since AFAIK the current long term direction is vPMU, which is especiall=
y
> > designed to address those kinds of issues, I am not sure it is worthy t=
o
> > attempt to fix this at L0 level (by reducing the number of counters tha=
t the
> > guest can see for example, which also won=E2=80=99t always fix the issu=
e, since there
> > could be more perf users on the host, and NMI watchdog can also get
> > dynamically enabled and disabled).
>=20
> Agreed.=C2=A0 For the emulated PMU, I think the only reasonable answer is=
 that the
> admin needs to understand the ramifications of exposing a PMU to the gues=
t.
>=20
> > My question is: Since the test fails and since it interferes with CI, d=
oes it
> > make sense to add a workaround to the test, by making it use 1 counter =
less
> > if run nested?
>=20
> Hrm.=C2=A0 I'd prefer not to?=C2=A0 Mainly because reducing the number of=
 used counters
> seems fragile as it relies heavily on implementation details of pieces of=
 the
> stack beyond the current environment (the VM).
OK, then I'll leave it as is.

>=20
> I don't suppose there's any way to configure your CI pipeline to disable =
the
> host NMI watchdog?
It is probably possible, I'll ask the CI people.


>=20
> > As a bonus the test can also check the NMI watchdog state and also redu=
ce the
> > number of tested counters instead of being skipped, improving coverage.
>=20
> I don't think I followed this part.=C2=A0 How would a test that runs nest=
ed be able
> to query the host's NMI watchdog state?
>=20
> Oh, you're saying in a non-nested scenario to reduce the number of counte=
rs.
> For me personally, I prefer the SKIP, because it's noisier, i.e. tells me=
 pretty
> loudly that I forgot to turn off the watchdog.=C2=A0 It's saved me from d=
ebugging
> false failures at least once when running tests in a VM on the same host.
Yes, I am talking here about non nested scenario.


>=20
> > Does all this make sense? If not, what about making the =E2=80=98all_co=
unters=E2=80=99
> > testcase optional (only print a warning) in case the test is run nested=
?
>=20
> Printing a warning would definitely be my least favorite option.=C2=A0 Te=
sts that
> print warns on failure inevitably get ignored. :-/
>=20

OK, let it be as it is now.


Thanks,
Best regards,
	Maxim Levitsky


