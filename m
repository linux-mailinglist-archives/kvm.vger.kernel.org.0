Return-Path: <kvm+bounces-4964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9126781A88F
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 22:45:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DBBF289E68
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 21:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5C9549F8F;
	Wed, 20 Dec 2023 21:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ylE54Etx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B3148CD0
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 21:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-db410931c23so192931276.2
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 13:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703108709; x=1703713509; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o2KyAbQGeXRxX9Kez0BA+ghL8Ur6r9y2yNTe+BsOa4w=;
        b=ylE54Etx8BXE5psiF7ctW3HBPCDMW0D+N4DEmZIBtD22CfaIgfh/K0DdxlJ/frTm+R
         JKoeTuSC54FgencyVysRW1MVNLlGAqpuF3XpuNgMeykX6Fi5tQsigpikWx02zCKv8Abf
         Ql8G5HDWnICRZPU1/pFrt1Pw6D+QpyUzYCMvDWXIOGvy1En6LHyK7FCffZQIeUFyCnY+
         07c5B6AgEgot/4nQ5NmDFs4NfwdMYPB79AZMecP6Y2y0F4aZvXGUfw0qsMY6FsDgUhz8
         krxmiTHqqwWjrm8bFaSwRru0Kisnmbd/Ofy0SM1ISA1+ye3oFXcFb7/GmS0MEuzyFYnL
         QTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703108709; x=1703713509;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o2KyAbQGeXRxX9Kez0BA+ghL8Ur6r9y2yNTe+BsOa4w=;
        b=BwnOXQpo8ptMeJbVz8RLb2H4mQtJMCak2HJ5jrXdjvQBKLMl/4eloDJmXyRBRJnV27
         w/5krWHR9EnatBNBPbllfcZt0Dapp0/zjN/sLC8p9DlgNDR8uI9E/nMEs+fWfXZCnctN
         NjgSV1dToA6biCSiYNaL3OpNXxtgzZ98V7WSovYhKuLlJzr6qkOVvM4vvS0eWGU9xFH+
         IHYdrkZ7oaoL0U8ZN2ZgkuCZOeSC3fbwo/0rt14IzYdLOIG4Y+NqT9ohHSuSU/VMdw0Q
         wx3ZsvWhgn02BDHY0Vfj2Vw8x413FvURaGHjjGuwo/S/6OSLxMjiJpatVmpbdiARv59M
         ylLQ==
X-Gm-Message-State: AOJu0YwxHH1mLJjb1jHIsoeOpYS4B37h4m4jC+mfrnVc2VCAsCaDTTY3
	ZxQ5E0SHUs0NInIz0iJa19B4zzTM9HaXzpCe+Q==
X-Google-Smtp-Source: AGHT+IE7ilKkOrmL46A3RgdxBVn3MVyI3yL7d5zpBM8duX8cRIhEiIVPqPMQ8eT8oJpLJ5c6kFU+WvEOFOrBl7hI6Q==
X-Received: from almasrymina.svl.corp.google.com ([2620:15c:2c4:200:13cc:a33:a435:3fe9])
 (user=almasrymina job=sendgmr) by 2002:a25:8701:0:b0:dbd:bce2:82f9 with SMTP
 id a1-20020a258701000000b00dbdbce282f9mr157856ybl.10.1703108708803; Wed, 20
 Dec 2023 13:45:08 -0800 (PST)
Date: Wed, 20 Dec 2023 13:44:59 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231220214505.2303297-1-almasrymina@google.com>
Subject: [PATCH net-next v3 0/3] Abstract page from net stack
From: Mina Almasry <almasrymina@google.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	David Howells <dhowells@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	"=?UTF-8?q?Christian=20K=C3=B6nig?=" <christian.koenig@amd.com>, Shakeel Butt <shakeelb@google.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Changes in v3:

- Replaced the struct netmem union with an opaque netmem_ref type.
- Added func docs to the netmem helpers and type.
- Renamed the skb_frag_t fields since it's no longer a bio_vec

-----------

Changes in v2:
- Reverted changes to the page_pool. The page pool now retains the same
  API, so that we don't have to touch many existing drivers. The devmem
  TCP series will include the changes to the page pool.

- Addressed comments.

This series is a prerequisite to the devmem TCP series. For a full
snapshot of the code which includes these changes, feel free to check:

https://github.com/mina/linux/commits/tcpdevmem-rfcv5/

-----------

Currently these components in the net stack use the struct page
directly:

1. Drivers.
2. Page pool.
3. skb_frag_t.

To add support for new (non struct page) memory types to the net stack, we
must first abstract the current memory type.

Originally the plan was to reuse struct page* for the new memory types,
and to set the LSB on the page* to indicate it's not really a page.
However, for safe compiler type checking we need to introduce a new type.

struct netmem is introduced to abstract the underlying memory type.
Currently it's a no-op abstraction that is always a struct page underneath.
In parallel there is an undergoing effort to add support for devmem to the
net stack:

https://lore.kernel.org/netdev/20231208005250.2910004-1-almasrymina@google.=
com/

Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>

Mina Almasry (3):
  vsock/virtio: use skb_frag_*() helpers
  net: introduce abstraction for network memory
  net: add netmem_ref to skb_frag_t

 include/linux/skbuff.h           | 92 ++++++++++++++++++++++----------
 include/net/netmem.h             | 41 ++++++++++++++
 net/core/skbuff.c                | 22 +++++---
 net/kcm/kcmsock.c                | 10 +++-
 net/vmw_vsock/virtio_transport.c |  6 +--
 5 files changed, 133 insertions(+), 38 deletions(-)
 create mode 100644 include/net/netmem.h

--=20
2.43.0.472.g3155946c3a-goog


