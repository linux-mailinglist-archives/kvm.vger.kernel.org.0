Return-Path: <kvm+bounces-36712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11BB0A20129
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 23:53:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3B5518820BD
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D34331DDA3B;
	Mon, 27 Jan 2025 22:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y0TJpbO3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6AB1DC1A7
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 22:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738018373; cv=none; b=GY6Xr6WgD/P7Bs2emSogh11493MwQTD8PJoPdEFZzAmTzZRn804YLCJvS8gTuHvszm/EzzqqwbcYwdEx6XTvL/CqSBv1mx78lorJdSeLe8hNCBYgY1cYbr1co3uSuZs4VJGl7mLHe0E8Hshz0T9Zn+DsswBhTZdnhsdbcsQvPg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738018373; c=relaxed/simple;
	bh=68yT7ctj8bEjZRs1enf6Riz6YgvO2oWyLb6AjHmiCg8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ghfvgxIlM1X74EJVECRx2wmhHiZ80o2pfLk7vTEJvdlwxPn9itUckYqG2dhf97jhTuKqh13cYYHP3/hj4jFHiSx/WsdV9aQX2+q80ObwMBR7xwMG7WSQqzDuoCoqUNGXFrp3+ZIpCnvOJ2PsDxu+chu5L8EtxclxHh9cKcLC7kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y0TJpbO3; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-21625b4f978so45765ad.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 14:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738018370; x=1738623170; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dt046zC8q+cHCBSEV8Sb8uhTY9mqKP4r1voWC0exUjg=;
        b=Y0TJpbO3biG+g4b/vJL9wfJsQaG2MMdu980k6DnglOuFtXkuCWli1Y44Dn9Qa5mXca
         /Ik7u5caS9UF9m2AiEycEwDU1aJBZBjAFhNal5oB5wvTCNWqDq/VOR7t4Qtapo7DJFAR
         c2iWvtoezqeZSgOWIoZWVLZE+sqL53Rwl14wuawYWCzAZDF1E8ApWz6an6AaLV+G82Ow
         w3mxMkK1yBTyq0GPc6jZrhPavB5ZyXTn3sh0/RJdz3twPnoVQGFfhFigLtfhex8h1wiP
         Fwn/7ZSvKu6VHgkUhpffOf7fj5ih2VM9xzwIulT+Fw+q7zgJpLDUeGnjmo8IeTTd2K8g
         kE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738018370; x=1738623170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dt046zC8q+cHCBSEV8Sb8uhTY9mqKP4r1voWC0exUjg=;
        b=YOeTS8pwFgLURX4/ukGeRfONFG+I0kCot5SYj09hxHJx35gV+QQ6EB1vRtFaUwF9/C
         IG8eEKFU3lYkMOIOSXGde+0Hh/7iybbXzXPs+2AQox/7gL02cBeKFS6Sj3wzKJA0xv/R
         +ThWicf92sAbkWh3P3f9c+Hnh91ERD+hLIl84YDYOaqvQz8X2JRER6V6Mb2BVhTHKR63
         oxUVA3+Wq6VtpDqnPJLV5wzqyBjCp8jRwBPWjRWgaIFLtrLwWze8MEVJ0FvYiQbZpSaX
         q9rdrtEmJzrybMLGFDYAi8G2o0uoJE2zv6OvFrshTt3/eDSd3WLZhtN10Sex/5dqHoDi
         f7lw==
X-Forwarded-Encrypted: i=1; AJvYcCX2a3BEmoP/6iil1AJdL/Sfh3nOYtR5jDU1nQJA3/PIVn3SFKIL6XCl4qRBo9FxPTGxesw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBpFRSrjGZkGPUfYgSzi1ybRds4D8ikN4k05dcf4e7Ekd7KMp0
	p3Cnhwn1gDw3KodgAYl1Ws5YSTAxabO6vtqKaBl301Xj5C19Jsnzr7Qp+Li6g8lDukyit1c/J2E
	+TxSzq7FG+Kpkp3qc/oyYlKeAbjimeC+0Os4f
X-Gm-Gg: ASbGncvQfSALG4z1Y7/3/rsoL2ofluoaOMgQTuqlqZR7IsbIHvKeaLxEkV8c+SAuUmK
	Q6oZM/WFpqPs3JMNY67L0NGs7TrhuPwOUw5pROLZHQOt+E7lb2AGe2ufF5MUKhTyPJsGPwOaOJp
	+vs4r2UlrBbZ25QM4EhjQZZysQkbA=
X-Google-Smtp-Source: AGHT+IGnMwtsrtnKydiBNAxNPRr5z5y9ziqP6BqEtfZ64TIOYQJqCWiD2gAFKLfpOjZiYf94dEFeLv3VKxqstm1f4LE=
X-Received: by 2002:a17:902:f611:b0:215:44af:313b with SMTP id
 d9443c01a7336-21dccd2833dmr925035ad.0.1738018370394; Mon, 27 Jan 2025
 14:52:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241221004236.2629280-1-almasrymina@google.com>
 <20241221004236.2629280-6-almasrymina@google.com> <Z2ZNlGCbQXMondI7@mini-arch>
 <Z22qCznFSWWyjyyq@mini-arch>
In-Reply-To: <Z22qCznFSWWyjyyq@mini-arch>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 27 Jan 2025 14:52:36 -0800
X-Gm-Features: AWEUYZnm6s4cike1pxqq6gw1uBcZE5P6ce8F2RNXnwtoS-1NKohoiPC1TO6Djb0
Message-ID: <CAHS8izNQYj4z-8vjMk8ttv85Q0HbdTrguLZewUt=4K8+5=6g_g@mail.gmail.com>
Subject: Re: [PATCH RFC net-next v1 5/5] net: devmem: Implement TX path
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

On Thu, Dec 26, 2024 at 11:10=E2=80=AFAM Stanislav Fomichev
<stfomichev@gmail.com> wrote:
>
> On 12/20, Stanislav Fomichev wrote:
> > On 12/21, Mina Almasry wrote:
> > >  void netdev_nl_sock_priv_init(struct list_head *priv)
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 815245d5c36b..eb6b41a32524 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -1882,8 +1882,10 @@ EXPORT_SYMBOL_GPL(msg_zerocopy_ubuf_ops);
> > >
> > >  int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
> > >                          struct msghdr *msg, int len,
> > > -                        struct ubuf_info *uarg)
> > > +                        struct ubuf_info *uarg,
> > > +                        struct net_devmem_dmabuf_binding *binding)
> > >  {
> > > +   struct iov_iter *from =3D binding ? &binding->tx_iter : &msg->msg=
_iter;
> >
> > For tx, I feel like this needs a copy of binding->tx_iter:
> >
> >       struct iov_iter tx_iter =3D binding->tx_iter;
> >       struct iov_iter *from =3D binding ? &tx_iter : &msg->msg_iter;
> >
> > Or something similar (rewind?). The tx_iter is advanced in
> > zerocopy_fill_skb_from_devmem but never reset back it seems (or I'm
> > missing something). In you case, if you call sendmsg twice with the sam=
e
> > offset, the second one will copy from 2*offset.
>
> Can confirm that it's broken. We should probably have a mode in ncdevmem
> to call sendmsg with the fixed sized chunks, something like this:
>

Thanks for catching. Yes, I've been able to repro and I believe I
fixed it locally and will include a fix with the next iteration.

I also agree using a binding->tx_iter here is not necessary, and it
makes the code a bit confusing as there is an iteration in msg and
another one in binding and we have to be careful which to
advance/revert etc. I've prototyped implementation without
binding->tx_iter with help from your series on github and seems to
work fine in my tests.

> @@ -912,7 +916,11 @@ static int do_client(struct memory_buffer *mem)
>                                 line_size, off);
>
>                         iov.iov_base =3D NULL;
> -                       iov.iov_len =3D line_size;
> +                       iov.iov_len =3D line_size <=3D 4096 ?: 4096;
>
>                         msg.msg_iov =3D &iov;
>                         msg.msg_iovlen =3D 1;
> @@ -933,6 +941,8 @@ static int do_client(struct memory_buffer *mem)
>                         ret =3D sendmsg(socket_fd, &msg, MSG_ZEROCOPY);
>                         if (ret < 0)
>                                 error(1, errno, "Failed sendmsg");
> +                       if (ret =3D=3D 0)
> +                               break;
>
>                         fprintf(stderr, "sendmsg_ret=3D%d\n", ret);
>
> I can put it on my todo to extend the selftests..

FWIW I've been able to repro this and extended the tests to catch
this; those changes should come with the next iteration.

--=20
Thanks,
Mina

