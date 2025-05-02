Return-Path: <kvm+bounces-45250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17046AA7A26
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 21:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A70D31BA7B21
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 19:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE0741F4262;
	Fri,  2 May 2025 19:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YUiwqCcp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56531E9B1D
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 19:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746213679; cv=none; b=CwdIlPdM6s9Sn7+Gx2vBaLolY/MVq3Q7+L5fq8XHPusx3wVnSh/zY9/0Z8nw9SRzrqrKxXZR0tUlmSlbF/OyCa7r8VtUYMdFzRmfgXtoIyhodyh6vIG/xywLBBCqmkjTBz1BLqrgXZfTnfISHDnT5YpQfXShIvr46doN8AWcObU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746213679; c=relaxed/simple;
	bh=JpyIjvjS1cn2CJj81nbpYGq+okHd6d4dPd65iwowKhw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kWmufJWiXmX2+mM96pAczuAtgm8iMcgVorfnI3Zprjer+nFjUBNDnw1z+4osjfNFORBmis4Dt1jE/eBvo56dfr7oUvRF5rVGx/tLmNhX5jtvJVihU6bkzgWgvgvgdFLmnHdccLD1Mu5jx8LNpicnBfmtCpfXpqQfIxAINCulLuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YUiwqCcp; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2264c9d0295so31085ad.0
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 12:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746213676; x=1746818476; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r96Eg/1Y8AFNbPbV0Ky1wYbeZa5VKyE7dnpUkfFRCh8=;
        b=YUiwqCcp42fIvx0hXEG3ZdDVPwY6YQriFb4+pWFw48cxkygtG2tF1YyatJD32wC4Re
         TOYkYC1vvnY4/WcyqzVI5pu1K/jnX6RUL4Qof3fIE/bbIFffklwyKaNYiaVsGl5v0bSv
         Cq6Wrw1mz76OjVWs/1hU9dgl4Y/VBhaKisNg3T/pIYY2Okq9R1ZEGrZYGVczB76FskD7
         vHSpgzgXU0IBgesuzXqNAHnxqCaN1pLxxYfOW8Hy5a2A329DHaLhDrVXNtqztASONzfk
         qrpFWBxgJlvanZFZm1xvAq7IwwjZ4XDnDjo8LDGaocg0I7d24MD0YkicQ+GM1sCXuySL
         GuaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746213676; x=1746818476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r96Eg/1Y8AFNbPbV0Ky1wYbeZa5VKyE7dnpUkfFRCh8=;
        b=nNdPdDcNvzkT1jdyrBVJUABYp6U0YmFNFOfb7hKBpUVzhPzyasoVqFBzT+II+r5A/Q
         sOll3ML4LEpqpCF60g7jhVI8ttQ8UESHPzBvp2YQKjAYPY2268EqreZTamf72+ULdlGY
         iea0nWIGDHPD3iyI7KA00/hfj01K32+IkOelm98OaH82+UHJhQSbZ4LnUe9gTw+eBis5
         0jU6/4S8q704VS720D7pld8H+LkmwqUvowZOggxt+w3dK2gFrbT2SYauHMR0eaE/3ZvF
         PXJETarLriXUH7F9bohMRkldJnzzmdpD2NiJ9TX9inXAz/h4RGqWo2XTaWEB8i6XH0NW
         qFDA==
X-Forwarded-Encrypted: i=1; AJvYcCUM3aYKgM0nHS5Iof1pgjgueVhhMXxT2QCabSaAaCohoBiKWXJBw65a10ECIKIwM1pyo7M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw2IjAU/GkgBRFEP9kHLPvJmbYqN3rKnVSnf8AhJ1ZpczYJXL+
	eSDZib8izJKqA/1QZ1RYXwe8nGxlHZpmv9A4omipWpDsHGmvRkbimx0DXlfklZVjfYaBspRjX2N
	xZfbuaWTPkiVQaH34qriYPYSgP5mhe6ejnna+
X-Gm-Gg: ASbGncuMGuot1tTmm1iIznrU9wCyeB2GSBVlbicbUKGNUkdqy+hslB5oSGlbHcuS1U+
	jH+IwtcoP3dGO0kPuGmGMNbI4Y8FVvoBtHdWjWZZ7CN7smjQHvyTslU+C3wpismZBlTJV2UKbVV
	aDqmey5VYjhtTcluOQv2ZlLDc=
X-Google-Smtp-Source: AGHT+IHuBk7ykClXDaGo7QqylvIZQfO9tpRwiOHUQADkSCKVxiVlZuZmPaSSKezybUCfRFfNE2CLttc2KEnzLSTOJbw=
X-Received: by 2002:a17:902:c40e:b0:21d:dba1:dd72 with SMTP id
 d9443c01a7336-22e18ba5736mr325995ad.15.1746213675572; Fri, 02 May 2025
 12:21:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250429032645.363766-1-almasrymina@google.com>
 <20250429032645.363766-5-almasrymina@google.com> <53433089-7beb-46cf-ae8a-6c58cd909e31@redhat.com>
In-Reply-To: <53433089-7beb-46cf-ae8a-6c58cd909e31@redhat.com>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 2 May 2025 12:20:59 -0700
X-Gm-Features: ATxdqUHudlFmLidqUMJh8A79G--WfvmY635UeHyjV1LrmdBcJP8-JhtODX9YkNk
Message-ID: <CAHS8izMefrkHf9WXerrOY4Wo8U2KmxSVkgY+4JB+6iDuoCZ3WQ@mail.gmail.com>
Subject: Re: [PATCH net-next v13 4/9] net: devmem: Implement TX path
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	Donald Hunter <donald.hunter@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, Jeroen de Borst <jeroendb@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>, 
	Victor Nogueira <victor@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Kaiyuan Zhang <kaiyuanz@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 2, 2025 at 4:47=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> Hi,
>
> On 4/29/25 5:26 AM, Mina Almasry wrote:
> > Augment dmabuf binding to be able to handle TX. Additional to all the R=
X
> > binding, we also create tx_vec needed for the TX path.
> >
> > Provide API for sendmsg to be able to send dmabufs bound to this device=
:
> >
> > - Provide a new dmabuf_tx_cmsg which includes the dmabuf to send from.
> > - MSG_ZEROCOPY with SCM_DEVMEM_DMABUF cmsg indicates send from dma-buf.
> >
> > Devmem is uncopyable, so piggyback off the existing MSG_ZEROCOPY
> > implementation, while disabling instances where MSG_ZEROCOPY falls back
> > to copying.
> >
> > We additionally pipe the binding down to the new
> > zerocopy_fill_skb_from_devmem which fills a TX skb with net_iov netmems
> > instead of the traditional page netmems.
> >
> > We also special case skb_frag_dma_map to return the dma-address of thes=
e
> > dmabuf net_iovs instead of attempting to map pages.
> >
> > The TX path may release the dmabuf in a context where we cannot wait.
> > This happens when the user unbinds a TX dmabuf while there are still
> > references to its netmems in the TX path. In that case, the netmems wil=
l
> > be put_netmem'd from a context where we can't unmap the dmabuf, Resolve
> > this by making __net_devmem_dmabuf_binding_free schedule_work'd.
> >
> > Based on work by Stanislav Fomichev <sdf@fomichev.me>. A lot of the mea=
t
> > of the implementation came from devmem TCP RFC v1[1], which included th=
e
> > TX path, but Stan did all the rebasing on top of netmem/net_iov.
> >
> > Cc: Stanislav Fomichev <sdf@fomichev.me>
> > Signed-off-by: Kaiyuan Zhang <kaiyuanz@google.com>
> > Signed-off-by: Mina Almasry <almasrymina@google.com>
> > Acked-by: Stanislav Fomichev <sdf@fomichev.me>
>
> I'm sorry for the late feedback. A bunch of things I did not notice
> before...
>
> > @@ -701,6 +743,8 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, str=
uct sock *sk,
> >
> >       if (msg && msg->msg_ubuf && msg->sg_from_iter)
> >               ret =3D msg->sg_from_iter(skb, from, length);
> > +     else if (unlikely(binding))
>
> I'm unsure if the unlikely() here (and in similar tests below) it's
> worthy: depending on the actual workload this condition could be very
> likely.
>

Right, for now I'm guessing the MSG_ZEROCOPY use case in the else is
more common workload, and putting the devmem use case in the unlikely
path so I don't regress other use cases. We could revisit this in the
future. In my tests, the devmem workload doesn't seem affected by this
unlikely.

> [...]
> > @@ -1066,11 +1067,24 @@ int tcp_sendmsg_locked(struct sock *sk, struct =
msghdr *msg, size_t size)
> >       int flags, err, copied =3D 0;
> >       int mss_now =3D 0, size_goal, copied_syn =3D 0;
> >       int process_backlog =3D 0;
> > +     bool sockc_valid =3D true;
> >       int zc =3D 0;
> >       long timeo;
> >
> >       flags =3D msg->msg_flags;
> >
> > +     sockc =3D (struct sockcm_cookie){ .tsflags =3D READ_ONCE(sk->sk_t=
sflags),
> > +                                     .dmabuf_id =3D 0 };
>
> the '.dmabuf_id =3D 0' part is not needed, and possibly the code is
> clearer without it.
>
> > +     if (msg->msg_controllen) {
> > +             err =3D sock_cmsg_send(sk, msg, &sockc);
> > +             if (unlikely(err))
> > +                     /* Don't return error until MSG_FASTOPEN has been
> > +                      * processed; that may succeed even if the cmsg i=
s
> > +                      * invalid.
> > +                      */
> > +                     sockc_valid =3D false;
> > +     }
> > +
> >       if ((flags & MSG_ZEROCOPY) && size) {
> >               if (msg->msg_ubuf) {
> >                       uarg =3D msg->msg_ubuf;
> > @@ -1078,7 +1092,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct ms=
ghdr *msg, size_t size)
> >                               zc =3D MSG_ZEROCOPY;
> >               } else if (sock_flag(sk, SOCK_ZEROCOPY)) {
> >                       skb =3D tcp_write_queue_tail(sk);
> > -                     uarg =3D msg_zerocopy_realloc(sk, size, skb_zcopy=
(skb));
> > +                     uarg =3D msg_zerocopy_realloc(sk, size, skb_zcopy=
(skb),
> > +                                                 sockc_valid && !!sock=
c.dmabuf_id);
>
> If sock_cmsg_send() failed and the user did not provide a dmabuf_id,
> memory accounting will be incorrect.
>

Forgive me but I don't see it. sockc_valid will be false, so
msg_zerocopy_realloc will do the normal MSG_ZEROCOPY accounting. Then
below whech check sockc_valid in place of where we did the
sock_cmsg_send before, and goto err. I assume the goto err should undo
the memory accounting in the new code as in the old code. Can you
elaborate on the bug you see?

> >                       if (!uarg) {
> >                               err =3D -ENOBUFS;
> >                               goto out_err;
> > @@ -1087,12 +1102,27 @@ int tcp_sendmsg_locked(struct sock *sk, struct =
msghdr *msg, size_t size)
> >                               zc =3D MSG_ZEROCOPY;
> >                       else
> >                               uarg_to_msgzc(uarg)->zerocopy =3D 0;
> > +
> > +                     if (sockc_valid && sockc.dmabuf_id) {
> > +                             binding =3D net_devmem_get_binding(sk, so=
ckc.dmabuf_id);
> > +                             if (IS_ERR(binding)) {
> > +                                     err =3D PTR_ERR(binding);
> > +                                     binding =3D NULL;
> > +                                     goto out_err;
> > +                             }
> > +                     }
> >               }
> >       } else if (unlikely(msg->msg_flags & MSG_SPLICE_PAGES) && size) {
> >               if (sk->sk_route_caps & NETIF_F_SG)
> >                       zc =3D MSG_SPLICE_PAGES;
> >       }
> >
> > +     if (sockc_valid && sockc.dmabuf_id &&
> > +         (!(flags & MSG_ZEROCOPY) || !sock_flag(sk, SOCK_ZEROCOPY))) {
> > +             err =3D -EINVAL;
> > +             goto out_err;
> > +     }
> > +
> >       if (unlikely(flags & MSG_FASTOPEN ||
> >                    inet_test_bit(DEFER_CONNECT, sk)) &&
> >           !tp->repair) {
> > @@ -1131,14 +1161,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct m=
sghdr *msg, size_t size)
> >               /* 'common' sending to sendq */
> >       }
> >
> > -     sockc =3D (struct sockcm_cookie) { .tsflags =3D READ_ONCE(sk->sk_=
tsflags)};
> > -     if (msg->msg_controllen) {
> > -             err =3D sock_cmsg_send(sk, msg, &sockc);
> > -             if (unlikely(err)) {
> > -                     err =3D -EINVAL;
> > -                     goto out_err;
> > -             }
> > -     }
> > +     if (!sockc_valid)
> > +             goto out_err;
>
> Here 'err' could have been zeroed by tcp_sendmsg_fastopen(), and out_err
> could emit a wrong return value.
>

Good point indeed.

> Possibly it's better to keep the 'dmabuf_id' initialization out of
> sock_cmsg_send() in a separate helper could simplify the handling here?
>

This should be possible as well.

--=20
Thanks,
Mina

