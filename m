Return-Path: <kvm+bounces-5688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF384824AC6
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 23:16:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F24321C2173C
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 22:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12DA42CCBA;
	Thu,  4 Jan 2024 22:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OKRFvuxe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80972C855
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 22:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5572a9b3420so39159a12.1
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 14:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704406567; x=1705011367; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YmEwJraJ4e4jT15EacqQbPjlb9M9wODOsTgFHucU8Ww=;
        b=OKRFvuxev/B8KH1SB0zFaMgZfxNpZdN83YqCV2JkSxdjxUbmr8443yl7d7lRNFvjSc
         j0GrX/9tA7q74I/Ht5Ad/W8r/TXXxFYhdZ9FL0AVMTqs+owieKHrE2eG8YtU3DTzsjnA
         wnfz+A/TMO5VCICM3HOH+iABixwj7hJxSRhSiodVAjqaqpZbdUOrAx/p6oLasfgTGKnt
         cj7xb0nSmvrQ5624XeJLWBZ1wkLXXPPKXPMkvjYzxdmQ/l2PB6IBNYsyy0595+Y49h7R
         iQXGMy5UAlWaztYy3svd4r3TLGGFkORiN6JZBL1X7mwVwWJjil1dJkPoPEjRKAMgMGdV
         glCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704406567; x=1705011367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YmEwJraJ4e4jT15EacqQbPjlb9M9wODOsTgFHucU8Ww=;
        b=WjIbFgOlWtneuH1qxbXRUC2pXqZWuSKjIn+VUv9WBmBK/GecdU/Q9I+OJwJSYpXqCj
         2Z+e+koUg4yTFPXlVPwDTTf+zX2zKCVxkWcCfnVQcgtt5T89mEpvFX9pTCJFhr6s7o1g
         7KFWUnVzGYgZ4YMeU//2QQcsE55egnKhNHBCrPR+B0yX6G0oIKFYsVINqlhvKHUv9NxU
         3+LKHCDdEoIQkyeLOdCwrKECUAA2TERM+1O6rW37O42JTfYKOfR8KnAMlGDsmDl2kSEI
         fiSGlShGKZvNRMF0XpIhWXZjmalhHTm+ByiExLMWRK4JXQ7C7SIIy5w7uHUDN9bFtg4W
         MDzQ==
X-Gm-Message-State: AOJu0YzGqElaHVynsietJog91QfkhptNiibpjEr00pFzjGreJlH1wjTW
	6jr5Tx2FdRKR/6HcCh5V+eJzL7DvGqj6E4DkZOi1ar/iIyoE
X-Google-Smtp-Source: AGHT+IFfrgRIWtZ9HrhyGAn143escpZpbafix8BFd16G8Qgpz+Ecbc714kdUSCPtt9+phrmGkm20SOlyqPkHmz1c25U=
X-Received: by 2002:a17:906:d154:b0:a28:6621:5801 with SMTP id
 br20-20020a170906d15400b00a2866215801mr1226462ejb.19.1704406566797; Thu, 04
 Jan 2024 14:16:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231220214505.2303297-1-almasrymina@google.com>
 <20231220214505.2303297-3-almasrymina@google.com> <20231221232343.qogdsoavt7z45dfc@google.com>
 <CAHS8izOp_m9SyPjNth-iYBXH2qQQpc9PuZaHbpUL=H0W=CVHgQ@mail.gmail.com> <20240104134424.399fee0a@kernel.org>
In-Reply-To: <20240104134424.399fee0a@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 4 Jan 2024 14:15:52 -0800
Message-ID: <CAHS8izPMCNxnk7wnq6-T8e4GHmkgQbZTSEowU5Vw5fB+8y7amg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] net: introduce abstraction for network memory
To: Jakub Kicinski <kuba@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, David Howells <dhowells@redhat.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 4, 2024 at 1:44=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Thu, 21 Dec 2023 15:44:22 -0800 Mina Almasry wrote:
> > The warning is like so:
> >
> > ./include/net/page_pool/helpers.h: In function =E2=80=98page_pool_alloc=
=E2=80=99:
> > ./include/linux/stddef.h:8:14: warning: returning =E2=80=98void *=E2=80=
=99 from a
> > function with return type =E2=80=98netmem_ref=E2=80=99 {aka =E2=80=98lo=
ng unsigned int=E2=80=99} makes
> > integer from pointer without a cast [-Wint-conversion]
> >     8 | #define NULL ((void *)0)
> >       |              ^
> > ./include/net/page_pool/helpers.h:132:24: note: in expansion of macro
> > =E2=80=98NULL=E2=80=99
> >   132 |                 return NULL;
> >       |                        ^~~~
> >
> > And happens in all the code where:
> >
> > netmem_ref func()
> > {
> >     return NULL;
> > }
> >
> > It's fixable by changing the return to `return (netmem_ref NULL);` or
> > `return 0;`, but I feel like netmem_ref should be some type which
> > allows a cast from NULL implicitly.
>
> Why do you think we should be able to cast NULL implicitly?
> netmem_ref is a handle, it could possibly be some form of
> an ID in the future, rather than a pointer. Or have more low
> bits stolen for specific use cases.
>
> unsigned long, and returning 0 as "no handle" makes perfect sense to me.
>
> Note that 0 is a special case, bitwise types are allowed to convert
> to 0/bool and 0 is implicitly allowed to become a bitwise type.
> This will pass without a warning:
>
> typedef unsigned long __bitwise netmem_ref;
>
> netmem_ref some_code(netmem_ref ref)
> {
>         // direct test is fine
>         if (!ref)
>                 // 0 "upgrades" without casts
>                 return 0;
>         // 1 does not, we need __force
>         return (__force netmem_ref)1 | ref;
> }
>
> The __bitwise annotation will make catching people trying
> to cast to struct page * trivial.
>
> You seem to be trying hard to make struct netmem a thing.
> Perhaps you have a reason I'm not getting?

There are a number of functions that return struct page* today that I
convert to return struct netmem* later in the child devmem series, one
example is something like:

struct page *page_pool_alloc(...); // returns NULL on failure.

becomes:

struct netmem *page_pool_alloc(...); // also returns NULL on failure.

rather than,

netmem_ref page_pool_alloc(...); // returns 0 on failure.

I guess in my mind having NULL be castable to the new type makes it so
that I can avoid the additional code churn of converting a bunch of
`return NULL;` to `return 0;`, and maybe the transition from page
pointers to netmem pointers can be more easily done if they're both
compatible pointer types.

But that is not any huge blocker or critical point in my mind, I just
thought this approach is preferred. If conversion to unsigned long
makes more sense to you, I'll respin this like that and do the `NULL
-> 0` conversion everywhere as needed.

--=20
Thanks,
Mina

