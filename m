Return-Path: <kvm+bounces-6031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B803E82A596
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 02:35:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC5D11C230F6
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 01:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F953EBF;
	Thu, 11 Jan 2024 01:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EH+UMHiW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ABA20E0;
	Thu, 11 Jan 2024 01:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC07C433F1;
	Thu, 11 Jan 2024 01:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704936924;
	bh=EAt50oUtdgbqbbLDWzcXAA/DZVzhKMRHwocOcJuW7KU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EH+UMHiWVgND/Td838wHuRk5d1uDIIAaiPNeC+yi1JTxvFcDH8UrhypSeWaOEZi7e
	 2WlJVcLUGIGDE+hHeanSxW6T8TwKCMi1gz5WZ4c4YmdGFozbQ+V1l+jZ+wSEn9ySO0
	 JQnLjxXclaL4Bwwou3yLrQCKDkwM4ltPdPmsRj6h56HY/jeoAs6/Vs7Ea9xjpGn5Nn
	 Mjtklrwy04xY1rqQuQCeJacS2eDr5xE5m0jUcjefiAi+wwaiFCaAv4vAJNZReZ0dcJ
	 /9aczZMYFiXrB20EvO/P+VUEtysKb4aqPnWKFnvgFs5y/puriW9XtOzMLHnPAqVqSX
	 AmTWxtxl/PWKw==
Date: Wed, 10 Jan 2024 17:35:23 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Mina Almasry <almasrymina@google.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <20240110173523.012175fd@kernel.org>
In-Reply-To: <CALvZod4xbQr0gZdfXYNTaS11d2T2hHpXxi5Lfyt=y+TcDseOhg@mail.gmail.com>
References: <20231220214505.2303297-1-almasrymina@google.com>
	<20231220214505.2303297-3-almasrymina@google.com>
	<20231221232343.qogdsoavt7z45dfc@google.com>
	<CAHS8izOp_m9SyPjNth-iYBXH2qQQpc9PuZaHbpUL=H0W=CVHgQ@mail.gmail.com>
	<20240104134424.399fee0a@kernel.org>
	<CALvZod4xbQr0gZdfXYNTaS11d2T2hHpXxi5Lfyt=y+TcDseOhg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Jan 2024 09:50:08 -0800 Shakeel Butt wrote:
> On Thu, Jan 4, 2024 at 1:44=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
> > You seem to be trying hard to make struct netmem a thing.
> > Perhaps you have a reason I'm not getting? =20
>=20
> Mina already went with your suggestion and that is fine. To me, struct
> netmem is more aesthetically aligned with the existing struct
> encoded_page approach, but I don't have a strong opinion one way or
> the other. However it seems like you have a stronger preference for
> __bitwise approach. Is there a technical reason or just aesthetic?

Yes, right above the text you quoted:

  The __bitwise annotation will make catching people trying
  to cast to struct page * trivial.

https://lore.kernel.org/all/20240104134424.399fee0a@kernel.org/

