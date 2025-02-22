Return-Path: <kvm+bounces-38919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A07DA40412
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:24:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E82B705D2B
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 00:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A7C4EB50;
	Sat, 22 Feb 2025 00:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2AYvz4m+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272762D057
	for <kvm@vger.kernel.org>; Sat, 22 Feb 2025 00:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740183876; cv=none; b=GyO/xe8DtFNYkLDcIujv8KTPA2cSLUz+wSMyXYf9HSf4SBCaRrfXw1UK0hLw3+0Bai8NlZdX88CJwyM2rRK0t4AoFAsnN4+jEirgDqNR/Dd6nFW+n+E1q/Igy9H5yXqGM/pA3jAo5lXULVHklBBBRxvoXRlu8RuuUtZiTc+RUS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740183876; c=relaxed/simple;
	bh=hPpnlZKOG91aAsSK3c+6EiQG/hLmCAaD3GdYrIVqp9s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qmbORhVty6YzY0Z5lBK8hFMC4peiqkAaR8c8z7JcWLL5ElzRfMn04CLjMKTZEjUBzTqhTIIvx1pL0+cuKYuYmgW4VlC3svNhPesfV7tIgjXSSFbBSb3r9GxLzHCJwqthq/IzqTKt7lXdMAVSzHLh6rqaNXpPSpMeYNZggL2yuIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2AYvz4m+; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-220e0575f5bso60995ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 16:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740183873; x=1740788673; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K/x8vAcUB/ic855YHRH64Mw9k0JCngQUmBTGGdXhTfY=;
        b=2AYvz4m+K6F8QwW5gnKX6LbPIGX20iGZuVJxycLDL9cynZQnpcczgfCUaYwVUkfsQ0
         waBnFfvlNEh7NbS7kX3XpOhNi5BxlLLG2o+Nm2JchiBNIFsjsq77YEwlJukJSxSO6Iol
         PHKFcgU986z/DMnkmHhb4n4NLVBVsDA8Wo0d5YiXny6MRInQJ5lTUtvsRmavhRGVot4r
         6n7lfBXSbySZ4BMUDBcyvK48XUdJy+kfNPOecidXxDV+IrlZWX+qSwV24+rPyrxlIbyB
         6a7SW/3iYtmDX/rme4/R69ewJIEk/5iCzV/XvuO37vZRMEbEEOOxOXZ0G5H2tj1bx2CF
         M8+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740183873; x=1740788673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K/x8vAcUB/ic855YHRH64Mw9k0JCngQUmBTGGdXhTfY=;
        b=nlNpk7oaWG1p3kozf7ASzHAB4PpJ/ex90FO/4cLbQ5l+yWcy9HWJcCFO4GhjA1vP47
         wVaCU/Ya3aasgZo8bNsDBHxP1xfWQGPn3uv3VF8ozEJ2BfYCLLmxdc1h+UURL9AEK/uZ
         iATE3HZRLjYgQ9PPboDkzaRhT6xz3DvNJO5JlsRT0bfMSdJ9pSNtyuo7oxonZC2Pfq+V
         07sRXUqSCfpD5Oo4IKSiClTcpqHqA/Hn3PgfhlK2ti+8SNAx2WwF9OxfQcFYt0ORt9hR
         CIbhOajhDHz3Wz6N9vslNa4RGtBU5GnzN4amfii4zFh1CeMNJYDYE914I9JfAQK5FOnq
         R4Ow==
X-Forwarded-Encrypted: i=1; AJvYcCXwN3mHROB8e6CeDzh1qS3avI2m32sC4c3CWcc1KT1POjg1jo/Uptxrbrglg8GDJWI6sHg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf6jVEBwzJmu5uqJEtY2fWqsskjkCevcnGu0qTlABFyzFJbAf9
	hW7gU3+C2Cj6OJHpECH6Z5/sbOu7VfHKkL4vvjJ9zlo9FmsIS7W3LKEcZ0rrt9DOUjscfD3N/Vi
	OJjOCoUkr8JoB8N3rnlLm1J91pQL795U/YVy+
X-Gm-Gg: ASbGnctAyGWxa6p269t1VeHyE9MXTcK6aLUq/LRdIxE1h5nOQ40OvtioNzWUqEmTK7J
	hG6WVZNt/HLXCzY7fN0rdR+b+PvPLoZNomsTflTrQSzUWEFxfPyWhlUU05a1groTbawqsYfeiDK
	P9AwNyke4=
X-Google-Smtp-Source: AGHT+IGVsr7xcN9MCd6339oiPC71YpQrUXMaUKu2w5DQntfyomcz0s1pc+sIqfRcq3uFYKJynoApH5QECxwHh6kTReI=
X-Received: by 2002:a17:903:228c:b0:21f:44eb:80f4 with SMTP id
 d9443c01a7336-221b9cfbfbamr1012175ad.4.1740183873140; Fri, 21 Feb 2025
 16:24:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250220020914.895431-1-almasrymina@google.com>
 <20250220020914.895431-10-almasrymina@google.com> <Z7eKHlA0rCF2Wgxb@mini-arch>
 <CAHS8izPA2eQ251-whnsT7ghG01c0e=tERL4Cwg1tBr+ZfVNHpA@mail.gmail.com> <Z7kYYXixRws7Kk-q@mini-arch>
In-Reply-To: <Z7kYYXixRws7Kk-q@mini-arch>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 21 Feb 2025 16:24:20 -0800
X-Gm-Features: AWEUYZlIN4OsigwtyTsPVx6XPhcjksTX5jYAgeD4mnU6jpvOBA8xEU409eVhNLw
Message-ID: <CAHS8izNF=wAhT29zHzUTtNMnm43NFGYOEeyHc+Gf_S3EDTd+-w@mail.gmail.com>
Subject: Re: [PATCH net-next v4 9/9] selftests: ncdevmem: Implement devmem TCP TX
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Donald Hunter <donald.hunter@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, Jeroen de Borst <jeroendb@google.com>, 
	Praveen Kaligineedi <pkaligineedi@google.com>, Shailend Chand <shailend@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	sdf@fomichev.me, asml.silence@gmail.com, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2025 at 4:20=E2=80=AFPM Stanislav Fomichev <stfomichev@gmai=
l.com> wrote:
>
> On 02/21, Mina Almasry wrote:
> > Hi Stan,
> >
> > Thank you very much for testing. I was wondering/worried that there
> > will be some churn in getting the test working on both our setups.
> > It's not unheard of I think because your ncdevmem changes had to go
> > through a couple of iterations to work for our slightly different
> > setups, but do bear with me. Thanks!
> >
> > On Thu, Feb 20, 2025 at 12:01=E2=80=AFPM Stanislav Fomichev
> > <stfomichev@gmail.com> wrote:
> > > > @@ -25,18 +25,36 @@ def check_rx(cfg) -> None:
> > > >      require_devmem(cfg)
> > > >
> > > >      port =3D rand_port()
> > > > -    listen_cmd =3D f"./ncdevmem -l -f {cfg.ifname} -s {cfg.v6} -p =
{port}"
> > > > +    listen_cmd =3D f"{cfg.bin_local} -l -f {cfg.ifname} -s {cfg.v6=
} -p {port}"
> > > >
> > > >      with bkg(listen_cmd) as socat:
> > > >          wait_port_listen(port)
> > > > -        cmd(f"echo -e \"hello\\nworld\"| socat -u - TCP6:[{cfg.v6}=
]:{port}", host=3Dcfg.remote, shell=3DTrue)
> > > > +        cmd(f"echo -e \"hello\\nworld\"| socat -u - TCP6:{cfg.v6}:=
{port},bind=3D{cfg.remote_v6}:{port}", host=3Dcfg.remote, shell=3DTrue)
> > >
> > > IPv6 address need to be wrapped into [], so has to be at least:
> > >         socat -u - TCP6:[{cfg.v6}]:{port},bind=3D[{cfg.remote_v6}]:{p=
ort}
> > >
> >
> > Yeah, I will need to propagate the ncdevmem ipv4 support to devmem.py
> > in the future, but unnecessary for this series. Will do.
> >
> > > But not sure why we care here about bind address here, let the kernel
> > > figure out the routing.
> > >
> >
> > I will need to add this in the future to support my 5-tuple flow
> > steering setup in the future, but it is indeed unnecessary for this
> > series. Additionally the bind in the check_tx test is unnecessary,
> > removed there as well. Lets see if it works for you.
>
> Hmm, true that it's not needed in check_tx as well. Let's drop from
> check_tx and introduce when you need it? (but up to you really,
> was just wondering why change rx side..)

Yes, that's what I meant. The next iteration will not change the rx side.

A follow up series will add ipv4 and 5-tuple flow steering support to
devmem.py, but that's unrelated. We can discuss when I send it.

--=20
Thanks,
Mina

