Return-Path: <kvm+bounces-36951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5B48A237C4
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 00:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 585EF3A5EC9
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 23:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 568A11F03DB;
	Thu, 30 Jan 2025 23:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wqZ7cJrW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55B51BEF63
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 23:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738279389; cv=none; b=JBZ0rexkYBnx3N4dcB0mFoFiauyaiPJtbdzjLV7ZDchmcKDEouLBIl7ncX8p7QWQG39BoN6+rAlTw7tTYh5yv0PmtKF1WBwKpIz9Y1UREzOPCv+Xci+T0hdimZw+R0qh1aZN2QVtjv8KiH+dEymCoPfktEZ903SSmdrGETkKSWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738279389; c=relaxed/simple;
	bh=l3pLSAMR5hyZwynYjVj0f5+5gQyw1x0yVwTtSl3x4CE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A/la2TFzL5R2FnusxbCPriZLudgibYZhlpJJVNSfzI4kW/lfIdX/4EVD3Y0IxhEwL1z6AOK2Pd5BNA/LW01FfZ8yj5gxWP6315GkXB3dQdZC5c8T6v8F+Eda7HtD1MYfBh5CgAXU8wheV8b39MgUgHH2imSCtNb549S5W36cvD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wqZ7cJrW; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21625b4f978so47355ad.0
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 15:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738279387; x=1738884187; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K4RB+Jf+i5RqaVVfCNjehyqZK5R36kdLSdheWh6HH74=;
        b=wqZ7cJrWeeOaR/VEl/1Y/Nfo68v04blrTWX5DFC87V5G2HXBFts5OIKehwft8wK7T3
         hnu3mx8DIs3jqleiUN+/8WaQzonYRPjtXf8BL3tkTR0MjfwiyPpnpUFU0Z0eZecCwqFR
         NoEgIi23r03IN2s9ul6WVuOKrVYQjC88+d2n0paldltglATbxXIuoH3zZSsmqOmOCT+l
         RP79bAla9RUMjl/c6ykyPVwOnT743KJ+wGurWWK5P8rSDXz1TvKxDSADUHK+fLbu59Nt
         FU8SPbes1kEhEPKh1dFW6haQfQdjeTJD8Uj/cRxNzgxYdCXR2sfWeQh1SKKk3l5BGPoT
         tCYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738279387; x=1738884187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K4RB+Jf+i5RqaVVfCNjehyqZK5R36kdLSdheWh6HH74=;
        b=FIYvA8uRs4LJvKSkO45xFoiceZ92Qlw9w6ny+ZMvW/kZtmCyIy5rI18TYo8hifjlg6
         bvHOhu+D5fyDJoGBgKwF05D8xDFpGxJ37D79QrUCofxGoT/+aJan9B1Pp/FTTohO1Od5
         nGNal6dNFObz+tzTx2g0ASluXBCCx45x3ztUVsqXiFPVkxCw2x6FvhvVAajtgHvY1KKq
         GGdjjyz1mzsmISy/97QobYydhDuxBbZVgQG1fjev+HvN+TM8E2IzTqxmVJaXEmJj3J7g
         XrU6XTZ2KWzYA7u5/w823Llr3q0iE9PI156NP+i8ONe4RYd7hOySOqscopUP/Oddv0Mu
         pd8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWsR8nMoAqB2aFN91C+ADaXVJo7gvbW0uIOuntoFQ1J9bMy9CKeXinv6TGRjTYmH6PYYHY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoXadhRB3aoYFn01izBr6vW+FVqxRiwxeBe/faCPf5pqbLn7Yl
	lWRkAA/uVij4pP//ph07uAmkZdxu7zQhTv1d8wXcyxwsJ5kWP6qUY5jtUEth4aLgwahaC75Pj8t
	I4G1kNk+4MHWzV5r9vFjHm1+SSxhyjQa/UV0s
X-Gm-Gg: ASbGncv3BfS7ntTHkWo5UX/QnYMmkaO7vAljiAebq2zY99i2aDhT2Nw44SAJnP6D2N5
	8uDQ5ddU7Ob4FKhP/Jw57EwwyKbekM2dpW+TqT/8ikzcY62mFKm+86285QbIV1ZyY+qvuwKoCxq
	zmM2Lk1w5+Ca3PKX3S+5Do4q6jaGY=
X-Google-Smtp-Source: AGHT+IE/QPS22mFf0S15DpgJBmM4XVfL576eNpFPYru7l4fiKqYBqjQMzyyVnrRxZd0Rnz4Q8ehW/Qpmn9SwV7Q1bns=
X-Received: by 2002:a17:902:8343:b0:215:79b5:aa7e with SMTP id
 d9443c01a7336-21edf0435c0mr348145ad.13.1738279386767; Thu, 30 Jan 2025
 15:23:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250130211539.428952-1-almasrymina@google.com>
 <20250130211539.428952-2-almasrymina@google.com> <Z5wEPlsRoU6Kx9S-@mini-arch>
In-Reply-To: <Z5wEPlsRoU6Kx9S-@mini-arch>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 30 Jan 2025 15:22:53 -0800
X-Gm-Features: AWEUYZkqj5XooHiN2tyUua1n1f68bkkfjeEH2K8q451D_O0CCPBOyX4tiBp941s
Message-ID: <CAHS8izMKdcpQkWjmP9OmQFox2CFvZyJVnKG9k9YAdmLYPn6bPw@mail.gmail.com>
Subject: Re: [PATCH RFC net-next v2 1/6] net: add devmem TCP TX documentation
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Donald Hunter <donald.hunter@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, David Ahern <dsahern@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, asml.silence@gmail.com, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 30, 2025 at 2:59=E2=80=AFPM Stanislav Fomichev <stfomichev@gmai=
l.com> wrote:
>
> On 01/30, Mina Almasry wrote:
> > Add documentation outlining the usage and details of the devmem TCP TX
> > API.
> >
> > Signed-off-by: Mina Almasry <almasrymina@google.com>
> >
> > ---
> >
> > v2:
> > - Update documentation for iov_base is the dmabuf offset (Stan)
> > ---
> >  Documentation/networking/devmem.rst | 144 +++++++++++++++++++++++++++-
> >  1 file changed, 140 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/networking/devmem.rst b/Documentation/networ=
king/devmem.rst
> > index d95363645331..8166fe09da13 100644
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
> > @@ -235,6 +235,142 @@ can be less than the tokens provided by the user =
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
> > +The user should create a msghdr where,
> > +
> > +iov_base is set to the offset into the dmabuf to start sending from.
> > +iov_len is set to the number of bytes to be sent from the dmabuf.
> > +
> > +The user passes the dma-buf id to send from via the dmabuf_tx_cmsg.dma=
buf_id.
> > +
> > +The example below sends 1024 bytes from offset 100 into the dmabuf, an=
d 2048
> > +from offset 2000 into the dmabuf. The dmabuf to send from is tx_dmabuf=
_id::
> > +
> > +       char ctrl_data[CMSG_SPACE(sizeof(struct dmabuf_tx_cmsg))];
> > +       struct dmabuf_tx_cmsg ddmabuf;
> > +       struct msghdr msg =3D {};
> > +       struct cmsghdr *cmsg;
> > +       struct iovec iov[2];
> > +
> > +       iov[0].iov_base =3D (void*)100;
> > +       iov[0].iov_len =3D 1024;
> > +       iov[1].iov_base =3D (void*)2000;
> > +       iov[1].iov_len =3D 2048;
> > +
> > +       msg.msg_iov =3D iov;
> > +       msg.msg_iovlen =3D 2;
> > +
> > +       msg.msg_control =3D ctrl_data;
> > +       msg.msg_controllen =3D sizeof(ctrl_data);
> > +
> > +       cmsg =3D CMSG_FIRSTHDR(&msg);
> > +       cmsg->cmsg_level =3D SOL_SOCKET;
> > +       cmsg->cmsg_type =3D SCM_DEVMEM_DMABUF;
> > +       cmsg->cmsg_len =3D CMSG_LEN(sizeof(struct dmabuf_tx_cmsg));
> > +
> > +       ddmabuf.dmabuf_id =3D tx_dmabuf_id;
> > +
> > +       *((struct dmabuf_tx_cmsg *)CMSG_DATA(cmsg)) =3D ddmabuf;
>
> [..]
>
> > +       sendmsg(socket_fd, &msg, MSG_ZEROCOPY);
>
> Not super important, but any reason not to use MSG_SOCK_DEVMEM as a
> flag? We already use it for recvmsg, seems logical to mirror the same
> flag on the transmit side?

Only to remove redundancy, and the possible confusion that could
arise, and the extra checks needed to catch invalid input.

With this, the user tells the kernel to send from the dmabuf by
supplying the SCM_DEVMEM_DMABUF cmsg. If we add another signal like
MSG_SOCK_DEVMEM, there is room for the user to supply the cmg but not
the flag (confusion), and the kernel needs to have the code and
overhead to check that both the flag and the cmsg are provided.

--=20
Thanks,
Mina

