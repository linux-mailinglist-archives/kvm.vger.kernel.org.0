Return-Path: <kvm+bounces-7691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED4ED84549E
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 10:58:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 674251F2B44B
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9817715B0F5;
	Thu,  1 Feb 2024 09:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yCHRXKIz"
X-Original-To: kvm@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F77B4D9E9;
	Thu,  1 Feb 2024 09:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706781476; cv=none; b=JbuY1pjt1Zb14Da2aNt8JkA1GbmAtpmtAflxy+We8KTwIsy7p2Zjms4W69BcBGcVDS4uz02Ga+LfsgQ6Djdrz9r/2kdqszEHjbX/unQXstn4lUTCfTVE3MRhKN3FLnUMgxbLCWdPBIP1X+wkVhViFV7ociAKXweI0Cma7UD9nzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706781476; c=relaxed/simple;
	bh=wXHv1FvFttD+/4Ykt/AOCzKeEg28Zvwn1bnpohIfpYQ=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=ay9nXfZkrGlxjz0fZ7sZbgMDCOf6PoMNr5TyXEmqSUJTfKolqzB8ez8rya1EUTXU2l6XKLnuqnta4db1A5SYIDfW0vhnborJBeYZVAsWQDODqnGp6pn19aR5vpXSgIXyU8mKJR4ka3x/sQeTgTLO21ZErxRNU2/Kn/fltAFQA/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yCHRXKIz; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706781471; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=90to8cwBJMQb8442ZR8q4xiN29UaF6MDG11lxdXfYpM=;
	b=yCHRXKIzH2vyssrt6aC07nP9lBW+5Swf9CNg2qdnlaBRV5llBTS4flRkIFlemcMG7eEAIA03dtPZQVlLZaBM97K1CKQoJKEEY4i8cJScDPsHCw1mTdeDaJ+bayuuceZGtfQteswLCuglrZ4ELoo/kiZILwe9/fkacawB3CRk8kU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0W.tM-xH_1706781468;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.tM-xH_1706781468)
          by smtp.aliyun-inc.com;
          Thu, 01 Feb 2024 17:57:49 +0800
Message-ID: <1706781420.4036775-6-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 00/17] virtio: drivers maintain dma info for premapped vq
Date: Thu, 1 Feb 2024 17:57:00 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Hans de Goede <hdegoede@redhat.com>,
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Vadim Pasternak <vadimp@nvidia.com>,
 Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Benjamin Berg <benjamin.berg@intel.com>,
 Yang Li <yang.lee@linux.alibaba.com>,
 linux-um@lists.infradead.org,
 netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org,
 bpf@vger.kernel.org,
 virtualization@lists.linux.dev
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
 <fdc2da16-5680-44cf-bc18-b3e8c0f565fa@linux.dev>
In-Reply-To: <fdc2da16-5680-44cf-bc18-b3e8c0f565fa@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Thu, 1 Feb 2024 15:43:51 +0800, Zhu Yanjun <yanjun.zhu@linux.dev> wrote:
> =E5=9C=A8 2024/1/30 19:42, Xuan Zhuo =E5=86=99=E9=81=93:
> > As discussed:
> > http://lore.kernel.org/all/CACGkMEvq0No8QGC46U4mGsMtuD44fD_cfLcPaVmJ3rH=
YqRZxYg@mail.gmail.com
> >
> > If the virtio is premapped mode, the driver should manage the dma info =
by self.
> > So the virtio core should not store the dma info.
> > So we can release the memory used to store the dma info.
> >
> > But if the desc_extra has not dma info, we face a new question,
> > it is hard to get the dma info of the desc with indirect flag.
> > For split mode, that is easy from desc, but for the packed mode,
> > it is hard to get the dma info from the desc. And for hardening
> > the dma unmap is saft, we should store the dma info of indirect
> > descs.
> >
> > So I introduce the "structure the indirect desc table" to
> > allocate space to store dma info with the desc table.
> >
> > On the other side, we mix the descs with indirect flag
> > with other descs together to share the unmap api. That
> > is complex. I found if we we distinguish the descs with
> > VRING_DESC_F_INDIRECT before unmap, thing will be clearer.
> >
> > Because of the dma array is allocated in the find_vqs(),
> > so I introduce a new parameter to find_vqs().
> >
> > Please review.
> >
> > Thanks
> >
> > Xuan Zhuo (17):
> >    virtio_ring: introduce vring_need_unmap_buffer
> >    virtio_ring: packed: remove double check of the unmap ops
> >    virtio_ring: packed: structure the indirect desc table
> >    virtio_ring: split: remove double check of the unmap ops
> >    virtio_ring: split: structure the indirect desc table
> >    virtio_ring: no store dma info when unmap is not needed
> >    virtio: find_vqs: pass struct instead of multi parameters
> >    virtio: vring_new_virtqueue(): pass struct instead of multi paramete=
rs
> >    virtio_ring: reuse the parameter struct of find_vqs()
> >    virtio: find_vqs: add new parameter premapped
> >    virtio_ring: export premapped to driver by struct virtqueue
> >    virtio_net: set premapped mode by find_vqs()
> >    virtio_ring: remove api of setting vq premapped
> >    virtio_ring: introduce dma map api for page
> >    virtio_net: unify the code for recycling the xmit ptr
> >    virtio_net: rename free_old_xmit_skbs to free_old_xmit
> >    virtio_net: sq support premapped mode
>
> The above can not be cleanly merged into kernel 6.8-rc2.
>
> Perhaps a base-commit is needed. About base-commit, please see the link
> https://people.kernel.org/monsieuricon/all-patches-must-include-base-comm=
it-info

The target branch is Michael's vhost.

https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=3Dlinu=
x-next

Thanks.

>
> Zhu Yanjun
>
> >
> >   arch/um/drivers/virtio_uml.c             |  29 +-
> >   drivers/net/virtio_net.c                 | 298 +++++++---
> >   drivers/platform/mellanox/mlxbf-tmfifo.c |  24 +-
> >   drivers/remoteproc/remoteproc_virtio.c   |  31 +-
> >   drivers/s390/virtio/virtio_ccw.c         |  33 +-
> >   drivers/virtio/virtio_mmio.c             |  30 +-
> >   drivers/virtio/virtio_pci_common.c       |  59 +-
> >   drivers/virtio/virtio_pci_common.h       |   9 +-
> >   drivers/virtio/virtio_pci_legacy.c       |  16 +-
> >   drivers/virtio/virtio_pci_modern.c       |  24 +-
> >   drivers/virtio/virtio_ring.c             | 660 ++++++++++++-----------
> >   drivers/virtio/virtio_vdpa.c             |  33 +-
> >   include/linux/virtio.h                   |  10 +-
> >   include/linux/virtio_config.h            |  48 +-
> >   include/linux/virtio_ring.h              |  82 +--
> >   tools/virtio/virtio_test.c               |   4 +-
> >   tools/virtio/vringh_test.c               |  32 +-
> >   17 files changed, 812 insertions(+), 610 deletions(-)
> >
> > --
> > 2.32.0.3.g01195cf9f
> >
>

