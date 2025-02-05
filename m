Return-Path: <kvm+bounces-37398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF19A29B15
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 21:22:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4078A3A894A
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 20:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24AC7213E6A;
	Wed,  5 Feb 2025 20:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aEqR4OUj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD76320CCF4
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 20:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738786947; cv=none; b=ax3DtJyQD4NGmoEbARRvMhUT/x2BGAWsTGcnddchkGNW2Nvlp2QZSKlIXCtIpFlYdHRb9k2lt6uobVe7yR05yvuVX0mVzZ3DwxPwGeR61EqUUYfZSorfTTdTLmvV7Dlq6+licV6pe2+obzlAEQ0cWF0xHHZfpiq9TTjQt4ifB8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738786947; c=relaxed/simple;
	bh=W/BDzfS0731XNlp5uGEgPUbjHeZNHpyjqCYetUqQRxQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T2fQSl+dxNZrKzYCpeUkOoddZ2Wnw8LjwPYYZdM97ChNmwDJExK5vytTlXKIGv+h6ScJ+fWC5mXzMtaZxdYk0T1h5xzjY/Z057LehUBU/Vm/vDx/rWQ61W06IvDQmjm9YpGln0KbIaRXE1a5uvrag8NNdNK19b76KHxcTzObP0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aEqR4OUj; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21f032484d4so32295ad.0
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 12:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738786945; x=1739391745; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qkxLeSmqP0bYGjmD83E3Y/4YIZD5CnHUYSNEP7lCym8=;
        b=aEqR4OUjEXOk+Plcx0PsYOho51wcq4oRNSX2zvM5RE6Sgc079JRIortawJIyNHH5Vp
         CO3NiFzoe4fKwfJTSNFib38UdXSni6DjIpCZkcZNzFn9EmY5MiTxviY3ZjgnMitFSaVI
         b1dzui4HIIGfHIXl9v9akFiWxSC7IvI964ax1384+5jK2rjGJKiX+Es/VGFDAuAZ+ly1
         D+p3ZP6yz6AOUhVc3G/EKMM4Z1EHQCgIurhcqIxORO9D77owYm+rY/vBiZmxO61s+Zul
         eKEbCvw+iD9vZUwR6a90JJwEHkOkh/htlDbjgRjmiBAuca54U71HXMya9cTuHJF7Z88S
         CsfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738786945; x=1739391745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qkxLeSmqP0bYGjmD83E3Y/4YIZD5CnHUYSNEP7lCym8=;
        b=ZZnNP9+z0ztEkwvPYpK2JxGnAAhqI4PfYgyrPy694/RYCJPx8B/GFyDojVs+zgZ3+q
         OxGooZ38GhSNGGp6v2H1JCSq1gJVq9xuVg4DUZo/gxcfs5D9IbPY488JctKKy7fDtjiO
         YZljrwUeQcfkCPOQ5/8s/BJpzul2w9j1nnBz2isN6YLfABYMultCoGSpN7YWCadyhRjM
         zpX3810srixoQ01d8l33E17WRgk0ek7bLGJq81qs7e6kOx4hrn4UP9B7Eqq2ay+ZFbcP
         AGkh4eeGrzNSYST2dXk5rfs4NMHDs4MTJmDeS6kYpY/cH/eJnzZji6lJtJqT4tSvOxnn
         mcLA==
X-Forwarded-Encrypted: i=1; AJvYcCVIQMLUAVX2QE/G4my69DhTZLeaaRj9ypdnfqn7q1a3NHUaRuYPTHPO7T2eus6FxL7vPBw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxyobn52r5Zl3aV4a4hkTA42daREi0JuhPUjjKP1RFpvyXGg5E7
	E3a8+AcShSkixiS5174MB1jPi1HDJcqkE/mUTbOB+r5ho/DlaYgue2CpqkhGWJb+9gfl03VOqE3
	RVQVg2rbowMuwvQVIFPFbpDzmLjKmv8dbZV6R
X-Gm-Gg: ASbGncvX7WnN/UT0optwPn8K78LG7tdZJDcttExeLO7D6UzVyx58xrzGs3fmvjlj8rE
	+lLGNZbMoiZTL+gmQi0VdN0VAYLmVcRxzZHD7DGDNymNeDD/sAamuM4gOTrsjNvPYjTFYUmH3
X-Google-Smtp-Source: AGHT+IHe8klwDgJSKEW2jpBdb9Qr5QEYUblXIVK5qhpQjddp07M20x9TqO2J5WfJ10zWsmr9wDdoAZ9pqxtBzG8aw9E=
X-Received: by 2002:a17:902:d582:b0:215:4bdd:9919 with SMTP id
 d9443c01a7336-21f311f9d6fmr275545ad.17.1738786944775; Wed, 05 Feb 2025
 12:22:24 -0800 (PST)
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
In-Reply-To: <53192c45-df3c-4a65-9047-bbd59d4aee47@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 5 Feb 2025 12:22:10 -0800
X-Gm-Features: AWEUYZmi_S38KTdRcwjGkZKd5Xr1UKSuxDipsps1bDEi3RA74FXERhOLWF6TuhY
Message-ID: <CAHS8izMcs=3qo1jhZSM499mxHh10-oBL6Fhb2W0eKWhJGax4Bg@mail.gmail.com>
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

On Wed, Feb 5, 2025 at 4:41=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> On 1/28/25 14:49, Willem de Bruijn wrote:
> >>>> +struct net_devmem_dmabuf_binding *
> >>>> +net_devmem_get_sockc_binding(struct sock *sk, struct sockcm_cookie =
*sockc)
> >>>> +{
> >>>> +     struct net_devmem_dmabuf_binding *binding;
> >>>> +     int err =3D 0;
> >>>> +
> >>>> +     binding =3D net_devmem_lookup_dmabuf(sockc->dmabuf_id);
> >>>
> >>> This lookup is from global xarray net_devmem_dmabuf_bindings.
> >>>
> >>> Is there a check that the socket is sending out through the device
> >>> to which this dmabuf was bound with netlink? Should there be?
> >>> (e.g., SO_BINDTODEVICE).
> >>>
> >>
> >> Yes, I think it may be an issue if the user triggers a send from a
> >> different netdevice, because indeed when we bind a dmabuf we bind it
> >> to a specific netdevice.
> >>
> >> One option is as you say to require TX sockets to be bound and to
> >> check that we're bound to the correct netdev. I also wonder if I can
> >> make this work without SO_BINDTODEVICE, by querying the netdev the
> >> sock is currently trying to send out on and doing a check in the
> >> tcp_sendmsg. I'm not sure if this is possible but I'll give it a look.
> >
> > I was a bit quick on mentioning SO_BINDTODEVICE. Agreed that it is
> > vastly preferable to not require that, but infer the device from
> > the connected TCP sock.
>
> I wonder why so? I'd imagine something like SO_BINDTODEVICE is a
> better way to go. The user has to do it anyway, otherwise packets
> might go to a different device and the user would suddenly start
> getting errors with no good way to alleviate them (apart from
> likes of SO_BINDTODEVICE). It's even worse if it works for a while
> but starts to unpredictably fail as time passes. With binding at
> least it'd fail fast if the setup is not done correctly.
>

I think there may be a misunderstanding. There is nothing preventing
the user from SO_BINDTODEVICE to make sure the socket is bound to the
ifindex, and the test changes in the latest series actually do this
binding.

It's just that on TX, we check what device we happen to be going out
over, and fail if we're going out of a different device.

There are setups where the device will always be correct even without
SO_BINDTODEVICE. Like if the host has only 1 interface or if the
egress IP is only reachable over 1 interface. I don't see much reason
to require the user to SO_BINDTODEVICE in these cases.

--=20
Thanks,
Mina

