Return-Path: <kvm+bounces-36710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48202A200D0
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 23:45:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 945563A2EFC
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443BE1DCB24;
	Mon, 27 Jan 2025 22:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XHZ3APX3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB461DC98C
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 22:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738017916; cv=none; b=GuokPK9ZnKjnbFKGeRsTD8VxyQn/sS6ePC2t9qLBbi8RP///fj7EVDwfGLY5KZWdTct9wm8IBtFnu62nI/2m/0aAHICLSnGGMMXQfCY2a7QInXEgRAKlFkAaPlO6oWOzAhV7jWhqWXq/8nopCf2bcCY0A/s88frRLjAv6jNj0tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738017916; c=relaxed/simple;
	bh=BwWewtzAsBYHFCOY3YZWzHQsU7jCQDKA4zr4sKiwxn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t7rGO4UUXiKAN5f4n4m70QbRxYOKCyqHuglkt0fG9GXwY39kaXSYsgrZNVsR+9WGh3vFfRGbPSMBsJfq7SzQlG2jVfk/Qfsxk05EELsAMCBWWY2t9QCgyvk9ggPuLDWLABAdS9gknaLtKKwgRnzWoeNItk3OrTChRZBuQfoXLUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XHZ3APX3; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-215740b7fb8so50785ad.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 14:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738017913; x=1738622713; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8t3pPz+1JzaiHbPQBjjwELEPY7O87ftN71YRbgZtoQU=;
        b=XHZ3APX3jA4TObuDl7MEfB44tWaRQIjFkcSSCXk20txA/6Il8y29FVreLE2KHfWfuX
         ixLN1PXXOKEel+XWdQMNy5DrRxpkcewPy2HShCTwAY45a0htfyYjoCvg4j1fNs23lfio
         KWX/Qn06nk610mECoSL9bDUnHkHe7MVk8vMGgfV1gowBWqtK7YBA6EqEqWNjOmEJ3VmD
         Xfk0hgL+EwXJX8bYixiQA2R3kIV2P6Ssse7naAqvuYLslQrFPLW9Na5nXzOTE53qFcZO
         C1tNyTPOHm7y0EoWXHdsvaAtnutiQy0kt+AmVj0B4R05LbSP5cjGe6BtqujtsS9/8Cop
         sPYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738017913; x=1738622713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8t3pPz+1JzaiHbPQBjjwELEPY7O87ftN71YRbgZtoQU=;
        b=MTkGX3NgqgiObOIGbDeDgA8dzytt/EE2nxlMZ/35mGP9EukUFf3lxnzESfLeaP4CXM
         1JqyiJqcw14MUxlxgl5yXQxkZqeR4VQy1JOujkyj5wc9mlgauvOs99iK1zJNnbMJ7WN4
         Z7Ddgv23KppFzE7pzRPMq1AmUncHr8jtfYu9Pnq+skso2lfhcjaOHIVYI1nzqTC7dB3r
         BSOrZ1J7ZtQ9jYGBosKFJyR+qSLSQeQh3xkQLfqJ9RjT3U9UzkWJcCjmFemIA2+WrRFv
         DlJvhdJj4lc+LKVMvSX5Ui1lAxUmjRWyjNyn+PgMTAQq4bLBPfWO9Y5fLbu2JsTDzqH8
         +oow==
X-Forwarded-Encrypted: i=1; AJvYcCW4gNAWHm7ga0kBROq/zUHLzs231jVjShr5FoNDKu/Y+sa8THPvBsiM0wmTqpW413k0F0k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqGx3H3PHuliNsOig6bAr7Ifnd3UIVxmRqDToVOskqsCiJW07P
	M17jb4LFVOW6vPDswG56uPld0XYsPzdMHhIpztHs6d23AjmweolhHyL/cqAhpVmBvTfdZhQgNJm
	pwErEFdrpnVEqpVtDBsNXrjqCpAJmqomyxtDQ
X-Gm-Gg: ASbGncvjfsEGRzWhPEMwsQK7/T/occkG2tJ46I0shkjcq1KB5tei1im6Q+HrnnWVVVY
	1mFY1wo7s/tjXHrfcEk3d5Ef8VlojPZ3ugRBGSEV/diW123HOyfhAnMjZu6WVgiGJMRttAGoSeU
	uaCvSq3pOW7q/pzlJw
X-Google-Smtp-Source: AGHT+IGExTjP7z3sH5xv4dUiC+Zf+Kk1XkUUyDOacm1rZ1hFNJpogpbUpdXTRa7a5h+RLDAp3SXDvxKAvw8QL//ENVE=
X-Received: by 2002:a17:903:8c6:b0:216:201e:1b4c with SMTP id
 d9443c01a7336-21dce2c7833mr240915ad.9.1738017913333; Mon, 27 Jan 2025
 14:45:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241221004236.2629280-1-almasrymina@google.com>
 <20241221004236.2629280-2-almasrymina@google.com> <Z2ZKl_t5e6rutAZ1@mini-arch>
In-Reply-To: <Z2ZKl_t5e6rutAZ1@mini-arch>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 27 Jan 2025 14:45:00 -0800
X-Gm-Features: AWEUYZkWf-jlkKJU2y8g8OGRPiPeNCocxqRGzqd-lq7m0uBB6GUIWI0vZLU-iA0
Message-ID: <CAHS8izOcQRjYYGwA_rx-zvX8dMV=40rzVJvEugY78jzCBHCq=A@mail.gmail.com>
Subject: Re: [PATCH RFC net-next v1 1/5] net: add devmem TCP TX documentation
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Donald Hunter <donald.hunter@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, David Ahern <dsahern@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Kaiyuan Zhang <kaiyuanz@google.com>, Pavel Begunkov <asml.silence@gmail.com>, 
	Willem de Bruijn <willemb@google.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, Joe Damato <jdamato@fastly.com>, dw@davidwei.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 20, 2024 at 8:56=E2=80=AFPM Stanislav Fomichev <stfomichev@gmai=
l.com> wrote:
>
> On 12/21, Mina Almasry wrote:
> > Add documentation outlining the usage and details of the devmem TCP TX
> > API.
> >
> > Signed-off-by: Mina Almasry <almasrymina@google.com>
> > ---
> >  Documentation/networking/devmem.rst | 140 +++++++++++++++++++++++++++-
> >  1 file changed, 136 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/networking/devmem.rst b/Documentation/networ=
king/devmem.rst
> > index d95363645331..9be01cd96ee2 100644
> > --- a/Documentation/networking/devmem.rst
> > +++ b/Documentation/networking/devmem.rst
> > @@ -62,15 +62,15 @@ More Info
> >      https://lore.kernel.org/netdev/20240831004313.3713467-1-almasrymin=
a@google.com/
> >
> >
> > -Interface
> > -=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +RX Interface
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >
> >  Example
> >  -------
> >
> > -tools/testing/selftests/net/ncdevmem.c:do_server shows an example of s=
etting up
> > -the RX path of this API.
> > +./tools/testing/selftests/drivers/net/hw/ncdevmem:do_server shows an e=
xample of
> > +setting up the RX path of this API.
> >
> >
> >  NIC Setup
> > @@ -235,6 +235,138 @@ can be less than the tokens provided by the user =
in case of:
> >  (a) an internal kernel leak bug.
> >  (b) the user passed more than 1024 frags.
> >
> > +TX Interface
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +
> > +Example
> > +-------
> > +
> > +./tools/testing/selftests/drivers/net/hw/ncdevmem:do_client shows an e=
xample of
> > +setting up the TX path of this API.
> > +
> > +
> > +NIC Setup
> > +---------
> > +
> > +The user must bind a TX dmabuf to a given NIC using the netlink API::
> > +
> > +        struct netdev_bind_tx_req *req =3D NULL;
> > +        struct netdev_bind_tx_rsp *rsp =3D NULL;
> > +        struct ynl_error yerr;
> > +
> > +        *ys =3D ynl_sock_create(&ynl_netdev_family, &yerr);
> > +
> > +        req =3D netdev_bind_tx_req_alloc();
> > +        netdev_bind_tx_req_set_ifindex(req, ifindex);
> > +        netdev_bind_tx_req_set_fd(req, dmabuf_fd);
> > +
> > +        rsp =3D netdev_bind_tx(*ys, req);
> > +
> > +        tx_dmabuf_id =3D rsp->id;
> > +
> > +
> > +The netlink API returns a dmabuf_id: a unique ID that refers to this d=
mabuf
> > +that has been bound.
> > +
> > +The user can unbind the dmabuf from the netdevice by closing the netli=
nk socket
> > +that established the binding. We do this so that the binding is automa=
tically
> > +unbound even if the userspace process crashes.
> > +
> > +Note that any reasonably well-behaved dmabuf from any exporter should =
work with
> > +devmem TCP, even if the dmabuf is not actually backed by devmem. An ex=
ample of
> > +this is udmabuf, which wraps user memory (non-devmem) in a dmabuf.
> > +
> > +Socket Setup
> > +------------
> > +
> > +The user application must use MSG_ZEROCOPY flag when sending devmem TC=
P. Devmem
> > +cannot be copied by the kernel, so the semantics of the devmem TX are =
similar
> > +to the semantics of MSG_ZEROCOPY.
> > +
> > +     ret =3D setsockopt(socket_fd, SOL_SOCKET, SO_ZEROCOPY, &opt, size=
of(opt));
> > +
> > +Sending data
> > +--------------
> > +
> > +Devmem data is sent using the SCM_DEVMEM_DMABUF cmsg.
> > +
>
> [...]
>
> > +The user should create a msghdr with iov_base set to NULL and iov_len =
set to the
> > +number of bytes to be sent from the dmabuf.
>
> Should we verify that iov_base is NULL in the kernel?
>
> But also, alternatively, why not go with iov_base =3D=3D offset? This way=
 we
> can support several offsets in a single message, just like regular
> sendmsg with host memory. Any reason to not do that?
>

Sorry for the late reply. Some of these suggestions took a bit to
investigate and other priorities pulled me a bit from this.

I've prototyped using iov_base as offset with some help from your
published branch, and it works fine. It seems to me a big improvement
to the UAPI. Will reupload RFC v2 while the tree is closed with this
change.

--=20
Thanks,
Mina

