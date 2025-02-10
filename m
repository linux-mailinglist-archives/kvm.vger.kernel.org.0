Return-Path: <kvm+bounces-37733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64261A2FBBF
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:16:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7A43162302
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 21:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0841B254AF8;
	Mon, 10 Feb 2025 21:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2RoTxPWN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C242512D2
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 21:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739222060; cv=none; b=HEQH5WR2NLO/eehJmZuc4dLGZLC8HwKMQypzHAmlHPLjr/i7JlmddDOH36i3PbDEC1DnNh5xK1CVs896wCBlt/dbvnpXCs1c7qgRux41RgoB8ThZccnpbJ3CIZBrUMqvoO7PxDTFPJj8gba+AVGkmNJ2Rl9+33OE2JS9gpShOeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739222060; c=relaxed/simple;
	bh=lPg3tqb88jy0q9UOH0ZLHtCVvNfjk7eV/0hOKFilJYg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sN5nvCLLkBW5Rb/zgrrXwxmKnXLKnEEQDkoF4BRgIZzF4/MFUGW2u8VSobQQzv04via/3Mr+yM1rDw9nvAxz4WPHPxSulK3lgjT24aZUthZpRSeq4LfSs+hzA1U5n0Pza/T0ymRfvOQmp7DzmKdWoNLQeJcZkJ9/+rdneS+jUwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2RoTxPWN; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21f8c280472so5525ad.1
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 13:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739222057; x=1739826857; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wk+yKAB70dHdM9WvXzr48S2ryIv6QJDQR/hvDz+009A=;
        b=2RoTxPWNnFmX+KCA0YjKIQeFnnuE85zpdNQhF8lkKYYC0X6t8tmNajjX33mDof77XL
         38q2jd7gHD4Dh0qpwCnzUg+RFUvc7w9WbpfXAqzS+ThP+yVpgxCfGIMQOj0XfS8tcTZH
         JWLxiiXw8mb/2P2cqCmm5LTrfXpPjDxlD7xOBUBk5GmHjaM4Uq6SrSJZMbEULz1vDW0l
         0zEYp7w61V1yHsG1X9Nb9PD5C/5KwLBXQLFGT7KtisVhsa/aH0iqeMB+WSRR9H6cDlM/
         24XlH3P4GFYw4n/Edk0ESq959ZYYYjD5R/YXDy7ql7pC6TFsJWsPbjeuj5mSezmbsJpj
         n/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739222057; x=1739826857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wk+yKAB70dHdM9WvXzr48S2ryIv6QJDQR/hvDz+009A=;
        b=FLQ+P+hjyErzd/BjKVUfAtCRMRyJ3yrPk36ju/smEPVzaVOPiaUZsAMXkcTpZ9eCWE
         nHK3qo2Ledqsbxf6Z4GfLKtx918s5+9JGH19Oi9vAIRl6ApqlZydQNcTYHoo9GXHb43h
         ApMzWSBm23X5PPTuKhFTqnR8gB+zU7MPtQZ5XD9kAJaz6g01bWI0l/qY5Oay1B/Jh2EB
         QUAENRg8HRNSP62gQ3qeW0MdebU1stG3gRXoN7vnLLmFAmk8TRF0aDzDMTv5SBxKAmEd
         ZM9ezgiLV0BRH8wah8ZbpYo/ZYTn81GCLaTq2hUUI9Yh4RrQSqHJXgJSHhYl9SJoeMei
         5ECA==
X-Forwarded-Encrypted: i=1; AJvYcCVvCQys1PHBEWGTec5BrTWlMuuonD91exq8EcaFlfwNRwiTFjKyF8IJbQvaV6owZTedE0I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHYT0iSYyd8YB8VopiFfzXWaLKGU0LmXaq0ZgMoUXLXUcFFvMt
	AKNR6srCii6v55cHiE12hH1SD7rirIHduORBLSg8F7utKaD6KE1xTt9gd/XlUaPVaTGzgEqc4Pi
	dZF8f5zE7vh/HvdUAF7p1oxBiD7iiaQK6ONTc
X-Gm-Gg: ASbGncsd2tvfE1rSKsvZIlWcTHPMH3lv7KCMcA9JMht4APfQPaN+6KVjOwIPH8wW85C
	jzXRHZYFHKiRaUkWFage0kShsKG7AH8f7CioHPZwMNUhxVQehBG2Q5CT23Hu295g0ezP6DeAp
X-Google-Smtp-Source: AGHT+IF1WYnqozcgShH+cAdTAUVegrpgYKlHnlRFXfz0EsjMsZ2jx7mNZKxlhW1ua62ull5dlivMfZWGXb7YIuP5lNs=
X-Received: by 2002:a17:902:cccf:b0:21f:3e29:9cd4 with SMTP id
 d9443c01a7336-21fb8df6b9amr480645ad.20.1739222056825; Mon, 10 Feb 2025
 13:14:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241221004236.2629280-1-almasrymina@google.com>
 <20241221004236.2629280-6-almasrymina@google.com> <676dd022d1388_1d346b2947@willemb.c.googlers.com.notmuch>
 <CAHS8izNzbEi_Dn+hDohF9Go=et7kts-BnmEpq=Znpot7o7B5wA@mail.gmail.com>
 <6798ee97c73e1_987d9294d6@willemb.c.googlers.com.notmuch> <53192c45-df3c-4a65-9047-bbd59d4aee47@gmail.com>
 <CAHS8izMcs=3qo1jhZSM499mxHh10-oBL6Fhb2W0eKWhJGax4Bg@mail.gmail.com>
 <88cb8f03-7976-4846-a74d-e2d234c5cf8d@gmail.com> <76880ee8-d5ce-458d-b165-c11ce1a23c76@gmail.com>
In-Reply-To: <76880ee8-d5ce-458d-b165-c11ce1a23c76@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 10 Feb 2025 13:14:03 -0800
X-Gm-Features: AWEUYZlX5w8QIFidv2Qufd8SmBdGuCif8BHYDc7F1yiUCQxcbYVMPVE_0I7jd2o
Message-ID: <CAHS8izPYiS_1BthEN7CzDYf-qn+WR5EPQnpkTkXizef5QjwN4g@mail.gmail.com>
Subject: Re: [PATCH RFC net-next v1 5/5] net: devmem: Implement TX path
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, David Ahern <dsahern@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Kaiyuan Zhang <kaiyuanz@google.com>, Willem de Bruijn <willemb@google.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Stanislav Fomichev <sdf@fomichev.me>, Joe Damato <jdamato@fastly.com>, 
	dw@davidwei.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 5, 2025 at 2:22=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> On 2/5/25 22:16, Pavel Begunkov wrote:
> > On 2/5/25 20:22, Mina Almasry wrote:
> >> On Wed, Feb 5, 2025 at 4:41=E2=80=AFAM Pavel Begunkov <asml.silence@gm=
ail.com> wrote:
> >>>
> >>> On 1/28/25 14:49, Willem de Bruijn wrote:
> >>>>>>> +struct net_devmem_dmabuf_binding *
> >>>>>>> +net_devmem_get_sockc_binding(struct sock *sk, struct sockcm_cook=
ie *sockc)
> >>>>>>> +{
> >>>>>>> +     struct net_devmem_dmabuf_binding *binding;
> >>>>>>> +     int err =3D 0;
> >>>>>>> +
> >>>>>>> +     binding =3D net_devmem_lookup_dmabuf(sockc->dmabuf_id);
> >>>>>>
> >>>>>> This lookup is from global xarray net_devmem_dmabuf_bindings.
> >>>>>>
> >>>>>> Is there a check that the socket is sending out through the device
> >>>>>> to which this dmabuf was bound with netlink? Should there be?
> >>>>>> (e.g., SO_BINDTODEVICE).
> >>>>>>
> >>>>>
> >>>>> Yes, I think it may be an issue if the user triggers a send from a
> >>>>> different netdevice, because indeed when we bind a dmabuf we bind i=
t
> >>>>> to a specific netdevice.
> >>>>>
> >>>>> One option is as you say to require TX sockets to be bound and to
> >>>>> check that we're bound to the correct netdev. I also wonder if I ca=
n
> >>>>> make this work without SO_BINDTODEVICE, by querying the netdev the
> >>>>> sock is currently trying to send out on and doing a check in the
> >>>>> tcp_sendmsg. I'm not sure if this is possible but I'll give it a lo=
ok.
> >>>>
> >>>> I was a bit quick on mentioning SO_BINDTODEVICE. Agreed that it is
> >>>> vastly preferable to not require that, but infer the device from
> >>>> the connected TCP sock.
> >>>
> >>> I wonder why so? I'd imagine something like SO_BINDTODEVICE is a
> >>> better way to go. The user has to do it anyway, otherwise packets
> >>> might go to a different device and the user would suddenly start
> >>> getting errors with no good way to alleviate them (apart from
> >>> likes of SO_BINDTODEVICE). It's even worse if it works for a while
> >>> but starts to unpredictably fail as time passes. With binding at
> >>> least it'd fail fast if the setup is not done correctly.
> >>>
> >>
> >> I think there may be a misunderstanding. There is nothing preventing
> >> the user from SO_BINDTODEVICE to make sure the socket is bound to the
> >
> > Right, not arguing otherwise
> >
> >> ifindex, and the test changes in the latest series actually do this
> >> binding.
> >>
> >> It's just that on TX, we check what device we happen to be going out
> >> over, and fail if we're going out of a different device.
> >>
> >> There are setups where the device will always be correct even without
> >> SO_BINDTODEVICE. Like if the host has only 1 interface or if the
> >> egress IP is only reachable over 1 interface. I don't see much reason
> >> to require the user to SO_BINDTODEVICE in these cases.
> >

For my taste it's slightly too defensive for the kernel to fail a
perfectly valid operation because it detects that the user is not
"doing things properly". I can't think of a precedent for this in the
kernel.

Additionally there may be tricky implementation details. I think
sk->sk_bound_dev_if which SO_BINDTODEVICE set can be changed
concurrently.

FWIW I can add a line to the documentation saying it's recommended to
SO_BINDTODEVICE, and the selftest (that is demonstrator code) does
this anway.

--=20
Thanks,
Mina

