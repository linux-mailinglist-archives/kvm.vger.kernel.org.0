Return-Path: <kvm+bounces-40283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B677A55A10
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:45:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9739A177E70
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 22:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B754E27CCED;
	Thu,  6 Mar 2025 22:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K8ZzQWRU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C88727CB10
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 22:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741301098; cv=none; b=Bst+5I84V66y+Re7f2xVTLyC7pswwGS70AfH7tyg8D+hDYaKrAI6HMyC8Nih7As+8+xZNWhBRuMNZyxW+HF2ZB/BfxGhiVs1s5XcBfAFY/XPme9P0bAJMSOaSnuMI/6paFtYNsm+0lyskbESz27oMKEkUJ/jSHMBHv9dJKriN1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741301098; c=relaxed/simple;
	bh=WJGCuAvULpegUxMdbOK1NHjZx/sGgwb92zX49N6RDkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IO2j6lf2uJWe0tmQiztuaS930yL3UWoFpFPwZYeSn9FDFNOpbZutYY9esvmb7dJ/i40J6Bh24zzCFdoM0TPZjPlYAt+3XmVx0ag421lQ3L4L9uQSBP76cmhH9lVdHkvMCIggtpI/o4E6Unmj/Tc2KjolebasyFsWZSFHAIhorxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K8ZzQWRU; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2240aad70f2so61765ad.0
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 14:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741301096; x=1741905896; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJGCuAvULpegUxMdbOK1NHjZx/sGgwb92zX49N6RDkA=;
        b=K8ZzQWRU9yM8+G33W+/FjAK3YagYFgaMLrT8jfIEMO3rrZrWlGTjQVPz3ZOttgq1Hq
         Ucu38tBtsjCpSByevpkzskhwdD1jk8FC2tX0x5iAQ8MHxG0QRAW2zZdz4UChA6U1UwtA
         XvHc7TWpuS9zK6hkWDiJTb+etZFfGC1zFPZm/7SNmkKR5jgjA1G2beK1prlJMkUbZET3
         UW8TaxTMqw+lkChYVoKKVRgKvZQVp0CEuDzF/J5UVmjmJfpTlGOH2V8fUIIwvQ3JsAV/
         s+KD2sExXbi4ydAaHo9trv3ZP+NCufngdas73c3uI6drQuohemNI0hUrdmP25n2VxLKJ
         7xQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741301096; x=1741905896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WJGCuAvULpegUxMdbOK1NHjZx/sGgwb92zX49N6RDkA=;
        b=ujWeSmB87Qijo0LmkD/ngA0ZVwHMbXxVYN9cwPnR4l1qnxsG+Ul1Mo9ZMUS0qCDUd8
         PNDssVTzWFOHqPgEhyEJnANhTfCDxT8mMQ6UiWNv5hXCpsetqfxnKxB4PRv3fZ59MXYy
         GE30FGnjSMFRyDtRcIT9yzLPGqC045AR5KDBne1MA/LtIJ8hAeSzxJDEbfmK9Y+lQptL
         5ck6T8KOfapYxEsyCPMvkHi92GLiGjFPjfFM+x8t6mvgWDkiaT6ePZy4UbDSmtBX5g1D
         j+cT4Uh8VwHQEXwOuzhShTj6mpmimtzLl6PCvDQSo/7R+xAR26eCpEsbQXedXC56UHox
         QVfw==
X-Forwarded-Encrypted: i=1; AJvYcCW3GqTl9+nbhpGBVtuW7vMc/o/3dNG/CwZiDJNsbCqkNIS9fX8hv3wpn8p9Xzd2Kg/oPbE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPX+kaRxsSsA59zuGNSHRKf9S0rz1tkyGsKjPK33DwZ18ubBKA
	8wnuNhik9LYneYlKw5rA8lA+/XDTmh3hqQ8ehwci/Tb8YZ8pvHBAUppsI0rb1rSa1gkI0s32+iA
	Hx/j8me8iHCGD5iX8xgKWKtFAsH4c93C5GlFi
X-Gm-Gg: ASbGncvlD/uySv9nluS7jJPYQpX0JqVYK+j74bQchz/tJIpQ+5tW+IJKt6a+n7P11+E
	7rlFg2adlsx0rnVuavL+CepcXOWdlQvoBGAhjXJTiBdCTkKPybTfuc5QOPyaNdV2DQtE/F6YNkT
	kfMKyizGFpIzYODJ3KqkCdAzQBjW/9NyKb//JkzVlqhk9f9l2Ir6Q2SA==
X-Google-Smtp-Source: AGHT+IGS+g4ZXFAp2nGdJpOHDce9EEY1Ln9JHFM0oHkP+LPpqqepXFJR4Sm8vslWM6D7/epATYsYkpZ1n4ukdSKEsNY=
X-Received: by 2002:a17:902:ea0c:b0:216:21cb:2e14 with SMTP id
 d9443c01a7336-2242a62b87amr242655ad.21.1741301095087; Thu, 06 Mar 2025
 14:44:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250227041209.2031104-1-almasrymina@google.com>
 <20250227041209.2031104-2-almasrymina@google.com> <20250228163846.0a59fb40@kernel.org>
 <CAHS8izNQnTW7sad_oABtxhy3cHxGR0FWJucrHTSVX7ZAA6jT3Q@mail.gmail.com>
 <20250303162051.09ad684e@kernel.org> <CAHS8izNWt2-1bC2f0jv4Qpk_A9VpEXNvVRoXUtL43_16d-Ui-A@mail.gmail.com>
 <20250306134019.1702e609@kernel.org>
In-Reply-To: <20250306134019.1702e609@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 6 Mar 2025 14:44:41 -0800
X-Gm-Features: AQ5f1JpdzmIgb4Qp1uwhgyjnsZGuDnrddzCXLNm0isLe9E-TpLpq-VU4X-9HjRo
Message-ID: <CAHS8izM8dnFNj5p8vKiyhV9qeE+9=a=BWRnH=vCu49Tq_XTL9g@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/8] net: add get_netmem/put_netmem support
To: Jakub Kicinski <kuba@kernel.org>, Pranjal Shrivastava <praan@google.com>, 
	Shivaji Kant <shivajikant@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	Donald Hunter <donald.hunter@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	sdf@fomichev.me, asml.silence@gmail.com, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 6, 2025 at 1:40=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Tue, 4 Mar 2025 17:39:37 -0800 Mina Almasry wrote:
> > > > Yes, great idea. I don't see why it wouldn't work.
> > > >
> > > > We don't expect mixing of net_iovs and pages in the same skb, but
> > > > netdevsim could create one net_iov skb every N skbs.
> > > >
> > > > I guess I'm not totally sure something is discoverable to syzbot. I=
s a
> > > > netdevsim hack toggleable via a debugfs sufficient for syzbot? I'll
> > > > investigate and ask.
> > >
> > > Yeah, my unreliable memory is that syzbot has a mixed record discover=
ing
> > > problems with debugfs. If you could ask Dmitry for advice that'd be
> > > ideal.
> >
> > Yes, I took a look here and discussed with Willem. Long story short is
> > that syzbot support is possible but with a handful of changes. We'll
> > look into that.
> >
> > Long story long, for syzbot support I don't think netdevsim itself
> > will be useful. Its our understanding so far that syzbot doesn't do
> > anything special with netdevsim.
>
> Meaning it doesn't currently do anything special, or you can't make it
> do anything special with netdevsim?
>

Meaning it currently doesn't do anything special with netdevsim. I
imagine we may be able to create a specialized syzbot instance that
loads netdevsim and starts fuzzing its APIs. However I'm told
specialized syzbot instances are much less valuable than making the
feature discoverable to existing syzbot instances, which is why our
thoughts went to adding devmem/unreadable skb support to virtio or
tun/tap.

Do I surmise from your question you prefer a netdevsim-based approach?
(and just curious maybe, why?)
> > We'll need to add queue API/page_pool/unreadable netmem support to
> > one of the drivers qemu (syzbot) uses, and that should get syzbot
> > fuzzing the control plane.
> >
> > To get syzbot to fuzz the data plane, I think we need to set up a
> > special syzbot instance which configures udmabuf/rss/flow
>
> To be clear for Tx you don't need RSS and flow steering, Tx should
> be trivial for any device driver which managers DMAs directly (not USB).
>

Yes, we don't need queue API or page_pool support or header split
either for that matter. TX fuzzing is definitely simpler. Maybe we can
start with that.

--
Thanks,
Mina

