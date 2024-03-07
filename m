Return-Path: <kvm+bounces-11272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5123874958
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 09:16:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C8372866D1
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 08:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A239964CD2;
	Thu,  7 Mar 2024 08:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="O5eaitda"
X-Original-To: kvm@vger.kernel.org
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C5E633EC;
	Thu,  7 Mar 2024 08:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709799346; cv=none; b=nxeuEbBOUtebeZTDOormmftUKT+wYsAwZ0HW12cfE7MSG1N15bU8rNMwnWE4EysUh4hvck9/1ph/KLtBg7DrWDG8Sp3YE8GAXvZJ7LiNUIguqHq7pDVRLbndUNuvlBuxMVNieRQiJnWEa4E8hVvEOa5Yw1IkVQC/tVGy1/lx7oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709799346; c=relaxed/simple;
	bh=qn4XlrCB0/U0FkhSoivYtFw9BAhWHViJJmb7sOeaNCI=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=nLI54+ClbWpIk2ubPiVJHkunGQNFBLuRVcHprfXcXFra7hBfM2x8hio1mSLVlqaaMTHZU4TJZcYxRgiWN90u4p/WoVUT5n4e71Mo9meQ1BuH1MTshQiuTzcv3okom0A59P2A5Msb2BKwvsL/vGbLnw3hk8vfQNOqex7bz+Q5JDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=O5eaitda; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1709799335; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=18OSYGa/SGkgZJEOI3rLdiQkYGsKgGpvPail2nzxpk8=;
	b=O5eaitdakZcCcTp3OC8XXthP+6TQBcnEoa8br0cX3GmDyNy9Zxr72fXvfhC6fd68lsPTxwmlxGEBBC4jm5eUWquJysSgCIlyuBHLJ80wK4bdLAxOcaiqlmYjx0JMbhWCwcHBuHRAPGB2LVEGpT0I9UpkmPbs7yZX6HJabxAURE0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0W2-19Np_1709799332;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W2-19Np_1709799332)
          by smtp.aliyun-inc.com;
          Thu, 07 Mar 2024 16:15:33 +0800
Message-ID: <1709798771.2564156-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v3 00/19] virtio: drivers maintain dma info for premapped vq
Date: Thu, 7 Mar 2024 16:06:11 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
 virtualization@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
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
 linux-um@lists.infradead.org,
 netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org,
 bpf@vger.kernel.org
References: <20240229072044.77388-1-xuanzhuo@linux.alibaba.com>
 <20240229031755-mutt-send-email-mst@kernel.org>
 <1709197357.626784-1-xuanzhuo@linux.alibaba.com>
 <20240229043238-mutt-send-email-mst@kernel.org>
 <1709718889.4420547-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEu5=DKJfXsvOoXDDH7KJ-DWt83jj=vf8GoRnq-9zUeOOg@mail.gmail.com>
In-Reply-To: <CACGkMEu5=DKJfXsvOoXDDH7KJ-DWt83jj=vf8GoRnq-9zUeOOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Thu, 7 Mar 2024 13:28:27 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Wed, Mar 6, 2024 at 6:01=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.=
com> wrote:
> >
> > On Thu, 29 Feb 2024 04:34:20 -0500, "Michael S. Tsirkin" <mst@redhat.co=
m> wrote:
> > > On Thu, Feb 29, 2024 at 05:02:37PM +0800, Xuan Zhuo wrote:
> > > > On Thu, 29 Feb 2024 03:21:14 -0500, "Michael S. Tsirkin" <mst@redha=
t.com> wrote:
> > > > > On Thu, Feb 29, 2024 at 03:20:25PM +0800, Xuan Zhuo wrote:
> > > > > > As discussed:
> > > > > > http://lore.kernel.org/all/CACGkMEvq0No8QGC46U4mGsMtuD44fD_cfLc=
PaVmJ3rHYqRZxYg@mail.gmail.com
> > > > > >
> > > > > > If the virtio is premapped mode, the driver should manage the d=
ma info by self.
> > > > > > So the virtio core should not store the dma info.
> > > > > > So we can release the memory used to store the dma info.
> > > > > >
> > > > > > But if the desc_extra has not dma info, we face a new question,
> > > > > > it is hard to get the dma info of the desc with indirect flag.
> > > > > > For split mode, that is easy from desc, but for the packed mode,
> > > > > > it is hard to get the dma info from the desc. And for hardening
> > > > > > the dma unmap is saft, we should store the dma info of indirect
> > > > > > descs.
> > > > > >
> > > > > > So I introduce the "structure the indirect desc table" to
> > > > > > allocate space to store dma info with the desc table.
> > > > > >
> > > > > > On the other side, we mix the descs with indirect flag
> > > > > > with other descs together to share the unmap api. That
> > > > > > is complex. I found if we we distinguish the descs with
> > > > > > VRING_DESC_F_INDIRECT before unmap, thing will be clearer.
> > > > > >
> > > > > > Because of the dma array is allocated in the find_vqs(),
> > > > > > so I introduce a new parameter to find_vqs().
> > > > > >
> > > > > > Note:
> > > > > >     this is on the top of
> > > > > >         [PATCH vhost v1] virtio: packed: fix unmap leak for ind=
irect desc table
> > > > > >         http://lore.kernel.org/all/20240223071833.26095-1-xuanz=
huo@linux.alibaba.com
> > > > > >
> > > > > > Please review.
> > > > > >
> > > > > > Thanks
> > > > > >
> > > > > > v3:
> > > > > >     1. fix the conflict with the vp_modern_create_avq().
> > > > >
> > > > > Okay but are you going to address huge memory waste all this is c=
ausing for
> > > > > - people who never do zero copy
> > > > > - systems where dma unmap is a nop
> > > > >
> > > > > ?
> > > > >
> > > > > You should address all comments when you post a new version, not =
just
> > > > > what was expedient, or alternatively tag patch as RFC and explain
> > > > > in commit log that you plan to do it later.
> > > >
> > > >
> > > > Do you miss this one?
> > > > http://lore.kernel.org/all/1708997579.5613105-1-xuanzhuo@linux.alib=
aba.com
> > >
> > >
> > > I did. The answer is that no, you don't get to regress memory usage
> > > for lots of people then fix it up.
> > > So the patchset is big, I guess it will take a couple of cycles to
> > > merge gradually.
> >
> > Hi @Michael
> >
> > So, how about this patch set?
> >
> > I do not think they (dma maintainers) will agree the API dma_can_skip_u=
nmap().
> >
> > If you think sq wastes too much memory using pre-mapped dma mode, how a=
bout
> > we only enable it when xsk is bond?
> >
> > Could you give me some advice?
>
> I think we have some discussion, one possible solution is:
>
> when pre mapping is enabled, virtio core won't store dma metadatas.
>
> Then it makes virtio-net align with other NIC.


YES.

This patch set works as this.

But the virtio-net must allocate too much memory to store dma and len.

num =3D queue size * 19

Michael thinks that waste too much memory.
	http://lore.kernel.org/all/20240225032330-mutt-send-email-mst@kernel.org

So we try this:
	http://lore.kernel.org/all/20240301071918.64631-1-xuanzhuo@linux.alibaba.c=
om

But I think that is difficult to be accepted by the  DMA maintainers.

So I have two advices:

1. virtio-net sq works without indirect.
	- that more like other NIC
	- the num of the memory to store the dma info is queue_size

2. The default mode of virtio-net sq is no-premapped
	- we just switch the mode when binding xsk

Thanks.


>
> Thanks
>
> >
> > Thanks.
> >
> >
> > >
> > > > I asked you. But I didnot recv your answer.
> > > >
> > > > Thanks.
> > > >
> > > >
> > > > >
> > > > > > v2:
> > > > > >     1. change the dma item of virtio-net, every item have MAX_S=
KB_FRAGS + 2
> > > > > >         addr + len pairs.
> > > > > >     2. introduce virtnet_sq_free_stats for __free_old_xmit
> > > > > >
> > > > > > v1:
> > > > > >     1. rename transport_vq_config to vq_transport_config
> > > > > >     2. virtio-net set dma meta number to (ring-size + 1)(MAX_SK=
B_FRGAS +2)
> > > > > >     3. introduce virtqueue_dma_map_sg_attrs
> > > > > >     4. separate vring_create_virtqueue to an independent commit
> > > > > >
> > > > > >
> > > > > >
> > > > > > Xuan Zhuo (19):
> > > > > >   virtio_ring: introduce vring_need_unmap_buffer
> > > > > >   virtio_ring: packed: remove double check of the unmap ops
> > > > > >   virtio_ring: packed: structure the indirect desc table
> > > > > >   virtio_ring: split: remove double check of the unmap ops
> > > > > >   virtio_ring: split: structure the indirect desc table
> > > > > >   virtio_ring: no store dma info when unmap is not needed
> > > > > >   virtio: find_vqs: pass struct instead of multi parameters
> > > > > >   virtio: vring_create_virtqueue: pass struct instead of multi
> > > > > >     parameters
> > > > > >   virtio: vring_new_virtqueue(): pass struct instead of multi p=
arameters
> > > > > >   virtio_ring: simplify the parameters of the funcs related to
> > > > > >     vring_create/new_virtqueue()
> > > > > >   virtio: find_vqs: add new parameter premapped
> > > > > >   virtio_ring: export premapped to driver by struct virtqueue
> > > > > >   virtio_net: set premapped mode by find_vqs()
> > > > > >   virtio_ring: remove api of setting vq premapped
> > > > > >   virtio_ring: introduce dma map api for page
> > > > > >   virtio_ring: introduce virtqueue_dma_map_sg_attrs
> > > > > >   virtio_net: unify the code for recycling the xmit ptr
> > > > > >   virtio_net: rename free_old_xmit_skbs to free_old_xmit
> > > > > >   virtio_net: sq support premapped mode
> > > > > >
> > > > > >  arch/um/drivers/virtio_uml.c             |  31 +-
> > > > > >  drivers/net/virtio_net.c                 | 283 ++++++---
> > > > > >  drivers/platform/mellanox/mlxbf-tmfifo.c |  24 +-
> > > > > >  drivers/remoteproc/remoteproc_virtio.c   |  31 +-
> > > > > >  drivers/s390/virtio/virtio_ccw.c         |  33 +-
> > > > > >  drivers/virtio/virtio_mmio.c             |  30 +-
> > > > > >  drivers/virtio/virtio_pci_common.c       |  59 +-
> > > > > >  drivers/virtio/virtio_pci_common.h       |   9 +-
> > > > > >  drivers/virtio/virtio_pci_legacy.c       |  16 +-
> > > > > >  drivers/virtio/virtio_pci_modern.c       |  38 +-
> > > > > >  drivers/virtio/virtio_ring.c             | 698 ++++++++++++---=
--------
> > > > > >  drivers/virtio/virtio_vdpa.c             |  45 +-
> > > > > >  include/linux/virtio.h                   |  13 +-
> > > > > >  include/linux/virtio_config.h            |  48 +-
> > > > > >  include/linux/virtio_ring.h              |  82 +--
> > > > > >  tools/virtio/virtio_test.c               |   4 +-
> > > > > >  tools/virtio/vringh_test.c               |  28 +-
> > > > > >  17 files changed, 847 insertions(+), 625 deletions(-)
> > > > > >
> > > > > > --
> > > > > > 2.32.0.3.g01195cf9f
> > > > >
> > >
> >
>

