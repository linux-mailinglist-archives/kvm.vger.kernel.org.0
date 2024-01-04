Return-Path: <kvm+bounces-5687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E3FD824A70
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 22:44:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 293EC286213
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 21:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441422C861;
	Thu,  4 Jan 2024 21:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZxkXNWKV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677022C6BE;
	Thu,  4 Jan 2024 21:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D01C433C7;
	Thu,  4 Jan 2024 21:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704404666;
	bh=qmkVGkFZ7N/03sFNMtroJyKLYvamcso6OXSxZb6lC8o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZxkXNWKVaf1lvZwh2WEDFAzLx5sRzxdwJSIS6we8WgA/IV/VGdWMA7gKEEbxsZwEk
	 Pam+FQeekr4Xe+b6AcmjAsWHCJupmtYEyiWCl+v9YqWij7Wec0E2afxccf8W81SW7w
	 c73k9L3Lg0D+QKrsn29t7IdYNN5oP6qae6yHBVbWwuAPRreXxhLqrdXE9hXDZOngjH
	 JHEEKvvyc5uqjb3PZDUlDiGUwcLH7tv+PsFoaS9XOWvz5GSfEChjftQ01Qc+eXH97N
	 fV93XcT2xwytJ+hiFWJPIc71q8my7LYNElLbbAL7V2BbPGYbvCM51eVoWUcwkWLYqW
	 2J7JJjt4/WOHw==
Date: Thu, 4 Jan 2024 13:44:24 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Stefan
 Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>,
 David Howells <dhowells@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, Yunsheng Lin
 <linyunsheng@huawei.com>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next v3 2/3] net: introduce abstraction for network
 memory
Message-ID: <20240104134424.399fee0a@kernel.org>
In-Reply-To: <CAHS8izOp_m9SyPjNth-iYBXH2qQQpc9PuZaHbpUL=H0W=CVHgQ@mail.gmail.com>
References: <20231220214505.2303297-1-almasrymina@google.com>
	<20231220214505.2303297-3-almasrymina@google.com>
	<20231221232343.qogdsoavt7z45dfc@google.com>
	<CAHS8izOp_m9SyPjNth-iYBXH2qQQpc9PuZaHbpUL=H0W=CVHgQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 21 Dec 2023 15:44:22 -0800 Mina Almasry wrote:
> The warning is like so:
>=20
> ./include/net/page_pool/helpers.h: In function =E2=80=98page_pool_alloc=
=E2=80=99:
> ./include/linux/stddef.h:8:14: warning: returning =E2=80=98void *=E2=80=
=99 from a
> function with return type =E2=80=98netmem_ref=E2=80=99 {aka =E2=80=98long=
 unsigned int=E2=80=99} makes
> integer from pointer without a cast [-Wint-conversion]
>     8 | #define NULL ((void *)0)
>       |              ^
> ./include/net/page_pool/helpers.h:132:24: note: in expansion of macro
> =E2=80=98NULL=E2=80=99
>   132 |                 return NULL;
>       |                        ^~~~
>=20
> And happens in all the code where:
>=20
> netmem_ref func()
> {
>     return NULL;
> }
>=20
> It's fixable by changing the return to `return (netmem_ref NULL);` or
> `return 0;`, but I feel like netmem_ref should be some type which
> allows a cast from NULL implicitly.

Why do you think we should be able to cast NULL implicitly?
netmem_ref is a handle, it could possibly be some form of=20
an ID in the future, rather than a pointer. Or have more low
bits stolen for specific use cases.

unsigned long, and returning 0 as "no handle" makes perfect sense to me.

Note that 0 is a special case, bitwise types are allowed to convert
to 0/bool and 0 is implicitly allowed to become a bitwise type.
This will pass without a warning:

typedef unsigned long __bitwise netmem_ref;

netmem_ref some_code(netmem_ref ref)
{
	// direct test is fine
	if (!ref)
		// 0 "upgrades" without casts
		return 0;
	// 1 does not, we need __force
	return (__force netmem_ref)1 | ref;
}

The __bitwise annotation will make catching people trying
to cast to struct page * trivial.

You seem to be trying hard to make struct netmem a thing.
Perhaps you have a reason I'm not getting?

