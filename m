Return-Path: <kvm+bounces-68888-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cEjtJy4acmnrbwAAu9opvQ
	(envelope-from <kvm+bounces-68888-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:38:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0532766B8E
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:38:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3CCF68C368B
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318343A6408;
	Thu, 22 Jan 2026 11:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sIW4W49t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE30333421
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 11:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769082954; cv=none; b=Y3yzcM70VCS4PBtotVqCLxG71ocezccZJj/8Mr0Ai/LWnh7JdX27ufbhc2p2qwT/A7uxTcfjo5GG6u0yLniIAAeneeYVbv2b7NIoY23LRHqNzs/QBRTFo7UJutQbWdHg7Mx/centOi8+bPbeLtjJgdvdIaD5rzO1i6m2T3HPxOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769082954; c=relaxed/simple;
	bh=vXHRHFXqPRf6bp55UeZSTWCEjt07QOLxKPITlEQHCA0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=L37oxrED7tkm93UBka3ZznsMtR6/Xwyk0avwZBof9UcCfPqrNnCAnU0/SUYpDOScvvDx6lPC3oFb46IbGV/O2qGVWx+g0AVV5r1wP2Vu36kBwOUJ3shqmm0Tm++izGcCv6JlS7RLje/VSHA0EIU2aLAvWIKTmCdyd1dPM8Ljw9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sIW4W49t; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47ee937ecf2so7765115e9.0
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 03:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1769082951; x=1769687751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A6oGl/jXKU2kaAGjfLnWtURe0DlEwbhNcb1dp4D+EUk=;
        b=sIW4W49tfmT6zdGoNSKAwcejLAbrWVUMZddnYr0ZbJWkch2szP2mYJHbDNPCfBbldC
         zC2ev4dQa/HjYeFNAQQiXA6I9RGJUGv+O5jlnGh6Hs9WxFK83vhW3ps8EptVVszj/VkV
         REYopf++P5Q/TJMeOIPf0uCawRsZbnXMLHqRIO3HzO7S1gZkZE+itpBiddq6PZoPz97e
         0XFHrFJwBklhv650NnOp/b7niosyZnCplt3SPRdH2p1xquMDJfTU374M6clqTJpHXlR4
         8+MDfi4oD2bgpXCFh6MF3qNrG6Z3K+nivl9XVXiRMjiIwm4S7t9roe6D5/axMQc96mTQ
         p8dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769082951; x=1769687751;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A6oGl/jXKU2kaAGjfLnWtURe0DlEwbhNcb1dp4D+EUk=;
        b=bqkmz+KSTlYfxQOk8wGCmP7RObO6FUJdCUufntVr8mSS9jZtkrxxrg2pPvZr764KMx
         DXrITF4E+n1TTBYblJ70sUkGClKBn6pn4nYu3gqoejrSC8zfj00IaLn7WEqmuHltERIB
         wbp+t+1mF2bzI9yUL8+Po+p9leZdh9AGZIIksC3wUKStkoMza8AOu0Cw2O6cejJ75i3+
         fQ5ob3+7REOvamAKCC2pE6sxoquItaU/O7ZtmFpPHBcDmZ64KA4lnYcNLYuq9MhmlbUs
         oNYFLuudc0wIO+aXfvd0S1UdQ+4twUJofBUn9b5AKhZIyrxKw5RQ9ZLfIU+xa4/zAQki
         L9Bw==
X-Forwarded-Encrypted: i=1; AJvYcCWjULL1wn5m5ukCz5XEFGLqFCzT31IvCDE+Kq+642u3lUTmeB4sd8k+Mdp6h7eF2q2iJHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwU8KF3ck0DueW23AflAbtSoi6WeGqFH7gE0X/rV9nKg0otQgjj
	xFCRMooxC45wliiT0QiXbPvBQQnVX3ub5ytQkvaDZFB5PYP6/BelL9fXA3GtTIHW5mg=
X-Gm-Gg: AZuq6aISPaN9tHaHt+z304zw9WPNDL11v1hsenlyblQMnqkwztxmlOjHGepdL2o+dnS
	j3QOTF9i/lnTcrDZN6r9THFT+MCtF4GiZa3npIrCF7y0Rp+ln+koMJvxUHXy9nIbILMPGRsk6jP
	SqweCgwd1ZVCPixHhhwMOwZ3HrWebyte+ziYVTtWNM6ZP152lDhfBGdNAITfMTb8s7C40ycmbGX
	EIWlYl1nil0Us+jVXuBX6axmbz0Q5w+416uugCawf6YUpN3Na3d88AyvInLTM5ZwPzOBPS2zi1M
	fdmfq2o3RdoLoctqsWOjr6dfiCaX6D4p6NAdcj9U0k43fsabng8HtCV6YnZTEydQu7FX6A3/zEx
	xufXJrVawNk8UL9nkJ3ew+97JOnA9rKfCfHmrKpSobcARhAJ1svuR0dotZWoO/xIaV2oXV7kZm0
	2Wxal15DXG+Fhc
X-Received: by 2002:a05:600c:4f4a:b0:46e:59bd:f7e2 with SMTP id 5b1f17b1804b1-48047087235mr49595895e9.11.1769082950567;
        Thu, 22 Jan 2026 03:55:50 -0800 (PST)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804704b89bsm59759895e9.9.2026.01.22.03.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 03:55:49 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 2184E5F7C3;
	Thu, 22 Jan 2026 11:55:49 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>,  Thomas Huth <thuth@redhat.com>,
  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
  qemu-devel
 <qemu-devel@nongnu.org>,  kvm <kvm@vger.kernel.org>,  Helge Deller
 <deller@gmx.de>,  Oliver Steffen <osteffen@redhat.com>,  Stefano
 Garzarella <sgarzare@redhat.com>,  Matias Ezequiel Vara Larsen
 <mvaralar@redhat.com>,  Kevin Wolf <kwolf@redhat.com>,  German Maglione
 <gmaglione@redhat.com>,  Hanna Reitz <hreitz@redhat.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,  Mark
 Cave-Ayland <mark.cave-ayland@ilande.co.uk>,  Pierrick Bouvier
 <pierrick.bouvier@linaro.org>,  John Levon <john.levon@nutanix.com>,
  Thanos Makatos <thanos.makatos@nutanix.com>,  =?utf-8?Q?C=C3=A9dric?= Le
 Goater
 <clg@redhat.com>
Subject: Re: Call for GSoC internship project ideas
In-Reply-To: <aXH4PpkC4AtccsOE@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Thu, 22 Jan 2026 10:14:09 +0000")
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
	<CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
	<CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
	<CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
	<aXH4PpkC4AtccsOE@redhat.com>
User-Agent: mu4e 1.12.15; emacs 30.1
Date: Thu, 22 Jan 2026 11:55:49 +0000
Message-ID: <87ikctoo8q.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk,nutanix.com];
	DMARC_POLICY_ALLOW(0.00)[linaro.org,none];
	TAGGED_FROM(0.00)[bounces-68888-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCPT_COUNT_TWELVE(0.00)[20];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex.bennee@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,linaro.org:dkim]
X-Rspamd-Queue-Id: 0532766B8E
X-Rspamd-Action: no action

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Tue, Jan 20, 2026 at 04:42:38PM -0500, Stefan Hajnoczi wrote:
>> Hi Marc-Andr=C3=A9,
>> I haven't seen discussion about the project ideas you posted, so I'll
>> try to kick it off here for the mkosi idea here.
>>=20
>> Thomas: Would you like to co-mentor the following project with
>> Marc-Andr=C3=A9? Also, do you have any concerns about the project idea f=
rom
>> the maintainer perspective?
>>=20
>> =3D=3D=3D Reproducible Test Image Building with mkosi =3D=3D=3D
>
>> This project proposes using mkosi to build minimal, reproducible test
>> images directly from distribution packages. mkosi is a tool for
>> building clean OS images from distribution packages, with excellent
>> support for Fedora and other distributions. It should be able to
>> produces deterministic outputs.
>
> Aside from what I mentioned already, the other issue I anticipate
> with mkosi is the mismatch between what hardware QEMU needs to be
> able to cover, vs what hardware the distros actually support.
>
> Fedora in particular is pretty narrow in its coverage. Debian is
> considerably broader.
>
> Neither will support all the QEMU targets, let alone all the
> machine types within the target.
>
>
> While there is value in testing a full blown OS image, IMHO,
> for most of what we need it is considerable overkill, and
> thus makes functional tests slower than they would otherwise
> need to be.
>
> IMHO, our baseline for functional testing images ought to be
> a Linux Kconfig recipe used to build a dedicate kernel, plus
> a busybox build for the target.
>
> This would let us create either a self contained initrd, or
> a tiny root disk, both of which would reliably boot in a
> barely more than a second or two, even under TCG.

This is why I've been building my iamges with buildroot. It provides for
a lean user-space with exactly what you want and it can create a
software BOM for the whole thing.

But it also allows me to bring in more complex things if I need to like
the vkmark tests for example.

> This would have a number of other benefits
>
>  * Not dependent on distros supporting the given QEMU
>    target and machine type. As long as a Linux port
>    exists and busybox compiles, we can test it
>=20=20
>  * Identical test image functionality for every single
>    target and machine type. No hodge-podge of different
>    3rd party guest OS.
>
>  * Stable forever, with all changes entirely under
>    our own control. No distro changes that arbitrarily
>    break our CI.
>
>  * Easier to debug when it breaks, since there would
>    be a small well defined set of logic running in
>    the guest userspace
>
>  * Fairly easy for QEMU to provide the complete and
>    corresponding source for any binary images, since
>    we've built it all from scratch
>
>  * Tiny & fast downloads of pre-built images.
>
>
> This would not eliminate the need for testing real OS images,
> but would significantly downgrade their importance.
>
> Functional tests could be in three groups - 'quick', as today,
> 'slow' the smoke tests with our miny kernel+busybox, 'thorough'
> the full OS images.
>
>
> With regards,
> Daniel

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

