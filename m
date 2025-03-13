Return-Path: <kvm+bounces-40946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77B2AA5FA20
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:38:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCC5A16FAA1
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 15:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7E72690C8;
	Thu, 13 Mar 2025 15:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SikGgxv8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76030267738
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 15:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741880295; cv=none; b=u0iOyKVkmoNwbRRFsrQhZEJTwxMj6yrpvJJHbJNsqoO0Yrc6lHuY87UM6Pn1JPE78W7V+qMn+nCP6J7fchOZTQ1SrUroCagIG3A6E3sR9ht6vCikCGF3VqNTCWdurJf/E9sRJu8IlCpMUP8BUBCddT0ER0vPPjbRgSdxlkkzRfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741880295; c=relaxed/simple;
	bh=e0igfCTK9/hzb01DEL2PKJuifzTCiu9TjzJhL9w9tCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R+BYyPsGocSBP6pXANBQoW4E68rF5g3ohnOXiiWg7cvABMH8uTNQYUdLhk+E1q5YhXsjHKS0KHrGfE2rfS9oQjBBxGjHBKoIj8qzcopjpmvYnP4vkrSd3UD20QbI4clf3wgBtNlX48EjUYdAfUn7humuGeaK0Br3pDSJKqZKsGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SikGgxv8; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2240aad70f2so190735ad.0
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 08:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741880293; x=1742485093; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QjT6YyAXUn5VTwVWHShjFFHYQBmkQMKGYi0zBc0+AWA=;
        b=SikGgxv8AToDco7oYitkg/Z+dJ6l1BdV3H8b2AERZCO3FBaVkYoIikB3+pUPsFwrPa
         bGJWpHeS7alLdkCI4zjyPLdoYFQlEJg6c9BvDnlrnHc8NPGW+8BZT8mhFO4QE8AI8QtR
         YdLHNBSmuectid8YTk/ICeRyJmSxlw0Ia5g/7Aoir6B4+CRpZLUIT+1g6BrDXBudax2P
         YZlsL1zdY2cA6RQ4SnCe74qUU1/mxdvxmM9wAX1pjnC3mR0UtNtcUZ8TmqsorEZhVBcp
         MUZbLXY5bZ9Cbvay6e2FBDlT/lklQrCEeaVYo0ap6k/ILfC98pzL9M1fOyA+ACe66IzK
         n+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741880293; x=1742485093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QjT6YyAXUn5VTwVWHShjFFHYQBmkQMKGYi0zBc0+AWA=;
        b=fC+euf327cTLkh9KWlFHcikBZQ7QwyqQ91qP/vU0/TjmE2aC5+ufQYyX7XevQdNNOo
         Cx8bheoqyrawEtYv6gVTFT8bk7PJO6WANk6a0K/OhpBVuPyfMxHqQ8vrcZVPJfosgqTI
         nfLhPQw7kMj+eD5ti0UyX5D7ol9QzrH00EYAvDIDNIuC0kaqXqwWNSbB1nfv1w8klHhm
         ja0aj2s06QFiLeDzruO/HfZe96PmxcB0hzL8dLLiFD4NsGA2vZfiXvb3wiWRznOispw2
         9iFRh9ClKQWQbmCr5VuLPN4lmEMSHcWW2p4WsFnr4n+HCqhYZCSwfqjd4VT4FU+2+J1N
         fcJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZLaNe5C3mL1f8Vcb3djsTx+A9GrvXNhArTMljAIeDCTMoesQFjlzSvT/NlTFnwQb2sWs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhU28KoXTtDnCouW/gMZ357cp7y/pIWfc8RL602FvEMl2lAR2v
	FW1+qLxUN5q7nEQpUvVGqy9UirrarlPjzltxI8vp6HfjUqxh7pmbpWWo6HvexigSFy56NgroJfL
	lnjRphUps1Hp04AbV6MT/tXoCrqYg9AEBz79e
X-Gm-Gg: ASbGncsarhUKgdsjBhWwJvjVD3PDnFMAhFrT+IzIk2vl+5/FmsDxRulc4OYDDRqJrKX
	Fq1l5o+ErGovqQFn2mEeNX8eFndBHzhiw86mGZ7YE9LEg9xoI81k8dD+ikpavqz7UmsZNfzhJjs
	ihy0w1FTS8x7uBwcaryqaVaQw7rUQ=
X-Google-Smtp-Source: AGHT+IGJAXZPJwYtCYE1bwu7PfpLXhz2HdoG/Tco2Xx2kSrvJEpgKAwhhVDmJx6nzuZRXrJN0XJtv6Oed3xhRIh49X0=
X-Received: by 2002:a17:902:f549:b0:21f:631c:7fc9 with SMTP id
 d9443c01a7336-225c4cc8b48mr3034115ad.0.1741880292423; Thu, 13 Mar 2025
 08:38:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250308214045.1160445-1-almasrymina@google.com>
 <20250308214045.1160445-3-almasrymina@google.com> <87e8bde7-b05e-4a1b-bcef-f6bb3a12315a@redhat.com>
In-Reply-To: <87e8bde7-b05e-4a1b-bcef-f6bb3a12315a@redhat.com>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 13 Mar 2025 08:37:59 -0700
X-Gm-Features: AQ5f1Jph-1jzVMznweflaH2GTTsjHi97dpZrZmSTIYAsEqCVMDjRyvtUSvvjsmI
Message-ID: <CAHS8izPbWVXS9gPBbuR4EisT806+3woqD=njDHj8hNJLcDU4DA@mail.gmail.com>
Subject: Re: [PATCH net-next v7 2/9] net: add get_netmem/put_netmem support
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, asml.silence@gmail.com, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2025 at 3:47=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 3/8/25 10:40 PM, Mina Almasry wrote:
> > Currently net_iovs support only pp ref counts, and do not support a
> > page ref equivalent.
> >
> > This is fine for the RX path as net_iovs are used exclusively with the
> > pp and only pp refcounting is needed there. The TX path however does no=
t
> > use pp ref counts, thus, support for get_page/put_page equivalent is
> > needed for netmem.
> >
> > Support get_netmem/put_netmem. Check the type of the netmem before
> > passing it to page or net_iov specific code to obtain a page ref
> > equivalent.
> >
> > For dmabuf net_iovs, we obtain a ref on the underlying binding. This
> > ensures the entire binding doesn't disappear until all the net_iovs hav=
e
> > been put_netmem'ed. We do not need to track the refcount of individual
> > dmabuf net_iovs as we don't allocate/free them from a pool similar to
> > what the buddy allocator does for pages.
> >
> > This code is written to be extensible by other net_iov implementers.
> > get_netmem/put_netmem will check the type of the netmem and route it to
> > the correct helper:
> >
> > pages -> [get|put]_page()
> > dmabuf net_iovs -> net_devmem_[get|put]_net_iov()
> > new net_iovs ->       new helpers
> >
> > Signed-off-by: Mina Almasry <almasrymina@google.com>
> > Acked-by: Stanislav Fomichev <sdf@fomichev.me>
> >
> > ---
> >
> > v5: https://lore.kernel.org/netdev/20250227041209.2031104-2-almasrymina=
@google.com/
> >
> > - Updated to check that the net_iov is devmem before calling
> >   net_devmem_put_net_iov().
> >
> > - Jakub requested that callers of __skb_frag_ref()/skb_page_unref be
> >   inspected to make sure that they generate / anticipate skbs with the
> >   correct pp_recycle and unreadable setting:
> >
> > skb_page_unref
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > - callers that are unreachable for unreadable skbs:
> >
> > gro_pull_from_frag0, skb_copy_ubufs, __pskb_pull_tail
>
> Why `__pskb_pull_tail` is not reachable? it's called by __pskb_trim(),
> via skb_condense().
>

I meant to say "the skb_page_unref call from __skb_pull_tail is not
reachable for unreadable skbs". This is because __skb_pull_tail early
returns on unreadable skbs.

--=20
Thanks,
Mina

