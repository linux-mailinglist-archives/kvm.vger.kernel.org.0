Return-Path: <kvm+bounces-67954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D6F5D1A30E
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:21:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F2B1307894F
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 16:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA92F263F5E;
	Tue, 13 Jan 2026 16:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EsE4TMRD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB992EED8
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 16:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768321002; cv=none; b=LjgOACbUszeBBT+N6HKRgJuIOsO5sLLVJrdeegw1Oa+bu7pu49UuPde1Q7M1qw9mw3Zg8QLt6TCDm7BZWoaHJdfcJ7IEg5Sy0sWMMVOlLIanydnckyIIy0tzM23UU8L8K2GHijydOk+YNew8ZN/anGvouku/HEBuKcbJU/3k3Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768321002; c=relaxed/simple;
	bh=shrcPEzb4aNV5JwEnXnE47Uz3LqyRg3MH/PLatgNdbc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RzqucgMfvaK791hDD3/Lo7ZmNsZEbRwVtuODLeYT9vsJcMoHA3CAH0Z/7cDK92meKMrtz3X8Juf7VdFZ6//uNIHTWuEznUZief86Pr75TQOXoWXR1rXToIxtTx8PmORQgfNR4yVa71oIWNC32YCUlMpg8bnY48m17wrgUGb5ctc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EsE4TMRD; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64d1ef53cf3so11332750a12.0
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 08:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768320999; x=1768925799; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=shrcPEzb4aNV5JwEnXnE47Uz3LqyRg3MH/PLatgNdbc=;
        b=EsE4TMRDEMaEwNO2MZ3V4Qhsintrq5Ail25d/gavKwqrlnO1Ql6tlqqroLvKLzsChD
         sfKHBWWuBdPwLP3X9Sg8AxhIJtP1LW0pJpuZ+aJ0DvedriiMUg1gYjDFyFJbG1McDroY
         Z3u3YZ/6sFldqp3cgpQDaZPEcd04uSGY8RIp2OQBZU9Jz1dOIBXTwQeFlUKs1p8vKesb
         t01S44jRM/ZCt49GlyBTUT3dWkhs58edo/TrClWyAta5QaQvBYKSu/1p4aPkpCDluS39
         s1PqetojURgicZStEHWjJ/gKTyBHAg5pVJAttF8Oyc2d3iZB+9k0lHu1Cg6ZFXEoBsyD
         dM4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768320999; x=1768925799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=shrcPEzb4aNV5JwEnXnE47Uz3LqyRg3MH/PLatgNdbc=;
        b=Zbdl3BodD3l/Nk6thNzwO6hS0UChD5XSBuZZnjDJbrs8epCvbAzjkHDtQhI5+i5Uu0
         E+ilowgEcdnRykWyu0NiQ0wTid5I++Rt5+92T3plgKDrY3jvuxg0u1xD11dcYlzRQhnj
         6+0vrfy04Q/I8b2sPUCzUbId/CcXDH8mgxBrd+zGmEbooYzhhrvvJRddyPbEjVXEBjiW
         NK0c7vF8EWhiuFoNiY3YZN+4n/VjhXajaEDb2A1PkgEYOhcZ6sX/ZrvXRoUF6OegKIwu
         uiAS7ZR+4Ce/Tty45UvNy49suvjh8DPVurcL1MCZUOcisQzVEDBid867kPav+ONU6zSW
         doeA==
X-Forwarded-Encrypted: i=1; AJvYcCXf46dHq6og6j4eKX+HnbaqPBsm++IB8CCue41zbRhqlS10F8wgOWjFd7nnIPCN1Z8np5w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4zaHp9QOkAOGsSU4h3JtBMW0K+zGg9Vr4nx0hABC3O2s9y36f
	5a7Cck2N7OUnRlGYh8c4fs5tU2Y7ZJ5/cU6IsfwC4S16ISB0iyXXvoQBs6uEk06OaEU7IXFZV3R
	qawGVPRZjyVE5Ll2yGhe5vIIOZ9MlIVI=
X-Gm-Gg: AY/fxX6G85B3s3/tepXthREe49fucg74EeoSj4nkM7exWbwa9tHdnT/YXvF2QU4g/hL
	sVjcD0m5BZgUBYwzGvGmTvDn67NNKMd6BFWK+QCOS4qkbqvsXHltB1ps5zky2Weezjj6eTshE3M
	rJ1sQkS5msUOhP1+Cu9SF+OtO+Nl7tF08v5WeZk6hL+WeDhpVKPiAYUxhnz4nvCCfVmFGbCjKnO
	yrXSL/gQS/ppE8ENR7nfNo93ERBVNqjn8BuwtmkyRbdwnOm/nPiK9Omrpqy09Orc7HG3A==
X-Google-Smtp-Source: AGHT+IHeiXZQnvw1K14LiD9+GLZGNYRdbytBLKoxdu0+Xta2Qk1o+/1j7ZzV9FMnMVXfT7V6vhkF3XPB6LaigPsCOM4=
X-Received: by 2002:a05:6402:3546:b0:64b:4720:1c23 with SMTP id
 4fb4d7f45d1cf-65097df5b56mr19145568a12.13.1768320999063; Tue, 13 Jan 2026
 08:16:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <aWZk7udMufaXPw-E@x1.local>
In-Reply-To: <aWZk7udMufaXPw-E@x1.local>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 13 Jan 2026 11:16:27 -0500
X-Gm-Features: AZwV_Qi7DHm95fI2JQgQGGuriK_wavPbXFOd_YVGKOoEvhXOSPvwsJvXr_ZtxEQ
Message-ID: <CAJSP0QVm41jSCma73sef7uzgEnqESRfqrxRstNTY_pd4Dk-JXA@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: Peter Xu <peterx@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Matias Ezequiel Vara Larsen <mvaralar@redhat.com>, Kevin Wolf <kwolf@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, danpb@redhat.com, 
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Alex Bennee <alex.bennee@linaro.org>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, Marco Cavenati <Marco.Cavenati@eurecom.fr>, 
	Fabiano Rosas <farosas@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 10:30=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote=
:
>
> On Mon, Jan 05, 2026 at 04:47:22PM -0500, Stefan Hajnoczi wrote:
> > Dear QEMU and KVM communities,
> > QEMU will apply for the Google Summer of Code internship
> > program again this year. Regular contributors can submit project
> > ideas that they'd like to mentor by replying to this email by
> > January 30th.
>
> There's one idea from migration side that should be self-contained, pleas=
e
> evaluate if this suites for the application.
>
> I copied Marco who might be interested on such project too at least from =
an
> user perspective on fuzzing [1].
>
> [1] https://lore.kernel.org/all/193e5a-681dfa80-3af-701c0f80@227192887/
>
> Thanks,

I have edited the project description to make it easier for newcomers
to understand and added a link to mapped-ram.rst:
https://wiki.qemu.org/Google_Summer_of_Code_2026#Fast_Snapshot_Load

Feel free to edit the project idea on the wiki.

Thanks,
Stefan

