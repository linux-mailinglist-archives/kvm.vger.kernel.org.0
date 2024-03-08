Return-Path: <kvm+bounces-11353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBC01875DE0
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 07:04:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B8B9283566
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 06:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AD54364BA;
	Fri,  8 Mar 2024 06:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IekLX4Fz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94189364A1
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 06:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709877841; cv=none; b=cgxvSuhfIHuYIVeT+z74jNEjIkRdr96S4Tu4LcE1+Tf8Bb8/Pfp1U7hhEJMbZUcbrZ2JDLhvRwawo71MAR+obKpclBlTh7SP4OA9slkSR/F86muID2mt365RtUeTpCn+6hIYa+n2clK2clItejiFgdoRIUZgnXx1jrVLpZHrT4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709877841; c=relaxed/simple;
	bh=jgt2FmcV3Yk28s1hw88s4sNZ9AfG+QarsYVdwOdt8LQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CICxuOuAZlBQmqZm5Q90iQAe3MbxnJNo85hszr2yNuG+1Q29OF+hRhoyJxSdPIfG0TC4zGs1+sD4RvknZOp6CEvrksu1ZckNB8I+CUkmq9/5J0Ysqi0eFG1Be1RrM/PhKPZc4Tbwjyy7GRMDwbAhUd4u0on0PWd/WYIJbYoKNf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IekLX4Fz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709877838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yaMKbz1uGEbeDlqPaWY/PoRYwRKKFpuiuv79VQFM3t8=;
	b=IekLX4Fzx/YydjeeRauldPbLNXl7R34+iSfyoQv55D4W7iyo6EFRm4saWlaAwpMQnB8OlN
	LB4+1A0YCiqzIUoEiN0/CAKbcRd8lBLTljSlEVxvs/8WVQYbHUAbyfPSnWg47/u1GDbbDA
	oZpj17ePCtXeM9/JE7FlmHphvPg8Mlo=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-2wExwE1XPRuRwQ-5gXpDfA-1; Fri, 08 Mar 2024 01:03:53 -0500
X-MC-Unique: 2wExwE1XPRuRwQ-5gXpDfA-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5c17cff57f9so1318701a12.0
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 22:03:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709877832; x=1710482632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yaMKbz1uGEbeDlqPaWY/PoRYwRKKFpuiuv79VQFM3t8=;
        b=pUZ4hShPo4bRS4Otr20zsXzVrPibXOyeuKsUNnmPXuBdUYQzaxy4OSguAmJIsIdP2X
         ZVWJ+6XMS+hi0915VQV5QLuavtR3vrzBrhaBHIKqy041xRbwBv61R5cPGrOEqU661ecm
         UBzreJgwlOb0b92cMksqELadP6YXeWrG08UA3fZ+Gf3dT4DI3rfJE+1Svi3UB4fvBwHc
         80bWUJfCQQhlFHLRzvvS32EStgndmwdpdToOo5cgN3bkRIJEahzVDbCy7wca6P1/A48h
         KNrut2QVtmCtdsx0UoXeWLdT5j6nD4xlHMeLdzvR5sN91c+K5JtCNrLBBh06usMGKuOc
         BVvA==
X-Forwarded-Encrypted: i=1; AJvYcCXSf70BKX2hvRHdfxHb2qAJwqR3Lh4oEjnfmFPqrnbSSKSjskjEZOg0x4fW0ftWA4Fkp5cr2gMp8MPYjuZUJQ0VvRay
X-Gm-Message-State: AOJu0YxSd6WMnqRRxNPUIUafJMyIrbicPcMucpUFb/+E2wQzXmkz8U7c
	ff0KUyL2w3E09bHfUM8GhURxzUYEnq0QTCH+VOIcIFOXfUQMHmrVsu3ojrT9hB1VOc67pysMB0Y
	qGIhpLGrwuk0tP9+4oSxPoxiGhYgWoMCRX++1nkaRUqvlaS74I+xFdpRVlwF4oHuU/gJyTjlf3a
	ejJHrJjk4lAl+rttI7p5/vayjv
X-Received: by 2002:a05:6a20:1586:b0:1a0:ebbd:9ae7 with SMTP id h6-20020a056a20158600b001a0ebbd9ae7mr11552893pzj.4.1709877832490;
        Thu, 07 Mar 2024 22:03:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFwSy+KRC/GSn2zLsN0UNnw00pTdXTREweDEIwdkwzwwVJ8XmarEUl1eSz0tZAv2yTcVHqnwoNrrIMVt2DhM18=
X-Received: by 2002:a05:6a20:1586:b0:1a0:ebbd:9ae7 with SMTP id
 h6-20020a056a20158600b001a0ebbd9ae7mr11552863pzj.4.1709877832102; Thu, 07 Mar
 2024 22:03:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229072044.77388-1-xuanzhuo@linux.alibaba.com>
 <20240229031755-mutt-send-email-mst@kernel.org> <1709197357.626784-1-xuanzhuo@linux.alibaba.com>
 <20240229043238-mutt-send-email-mst@kernel.org> <1709718889.4420547-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEu5=DKJfXsvOoXDDH7KJ-DWt83jj=vf8GoRnq-9zUeOOg@mail.gmail.com> <1709798771.2564156-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1709798771.2564156-2-xuanzhuo@linux.alibaba.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 8 Mar 2024 14:03:41 +0800
Message-ID: <CACGkMEsHTwA=9W+3QfQGxzHcgzZZ=Bi9bb4PijUJHUQmLfEQpw@mail.gmail.com>
Subject: Re: [PATCH vhost v3 00/19] virtio: drivers maintain dma info for
 premapped vq
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Hans de Goede <hdegoede@redhat.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, linux-um@lists.infradead.org, 
	netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 7, 2024 at 4:15=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.co=
m> wrote:
>
> On Thu, 7 Mar 2024 13:28:27 +0800, Jason Wang <jasowang@redhat.com> wrote=
:
> > On Wed, Mar 6, 2024 at 6:01=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibab=
a.com> wrote:
> > >
> > > On Thu, 29 Feb 2024 04:34:20 -0500, "Michael S. Tsirkin" <mst@redhat.=
com> wrote:
> > > > On Thu, Feb 29, 2024 at 05:02:37PM +0800, Xuan Zhuo wrote:
> > > > > On Thu, 29 Feb 2024 03:21:14 -0500, "Michael S. Tsirkin" <mst@red=
hat.com> wrote:
> > > > > > On Thu, Feb 29, 2024 at 03:20:25PM +0800, Xuan Zhuo wrote:
> > > > > > > As discussed:
> > > > > > > http://lore.kernel.org/all/CACGkMEvq0No8QGC46U4mGsMtuD44fD_cf=
LcPaVmJ3rHYqRZxYg@mail.gmail.com
> > > > > > >
> > > > > > > If the virtio is premapped mode, the driver should manage the=
 dma info by self.
> > > > > > > So the virtio core should not store the dma info.
> > > > > > > So we can release the memory used to store the dma info.
> > > > > > >
> > > > > > > But if the desc_extra has not dma info, we face a new questio=
n,
> > > > > > > it is hard to get the dma info of the desc with indirect flag=
.
> > > > > > > For split mode, that is easy from desc, but for the packed mo=
de,
> > > > > > > it is hard to get the dma info from the desc. And for hardeni=
ng
> > > > > > > the dma unmap is saft, we should store the dma info of indire=
ct
> > > > > > > descs.
> > > > > > >
> > > > > > > So I introduce the "structure the indirect desc table" to
> > > > > > > allocate space to store dma info with the desc table.
> > > > > > >
> > > > > > > On the other side, we mix the descs with indirect flag
> > > > > > > with other descs together to share the unmap api. That
> > > > > > > is complex. I found if we we distinguish the descs with
> > > > > > > VRING_DESC_F_INDIRECT before unmap, thing will be clearer.
> > > > > > >
> > > > > > > Because of the dma array is allocated in the find_vqs(),
> > > > > > > so I introduce a new parameter to find_vqs().
> > > > > > >
> > > > > > > Note:
> > > > > > >     this is on the top of
> > > > > > >         [PATCH vhost v1] virtio: packed: fix unmap leak for i=
ndirect desc table
> > > > > > >         http://lore.kernel.org/all/20240223071833.26095-1-xua=
nzhuo@linux.alibaba.com
> > > > > > >
> > > > > > > Please review.
> > > > > > >
> > > > > > > Thanks
> > > > > > >
> > > > > > > v3:
> > > > > > >     1. fix the conflict with the vp_modern_create_avq().
> > > > > >
> > > > > > Okay but are you going to address huge memory waste all this is=
 causing for
> > > > > > - people who never do zero copy
> > > > > > - systems where dma unmap is a nop
> > > > > >
> > > > > > ?
> > > > > >
> > > > > > You should address all comments when you post a new version, no=
t just
> > > > > > what was expedient, or alternatively tag patch as RFC and expla=
in
> > > > > > in commit log that you plan to do it later.
> > > > >
> > > > >
> > > > > Do you miss this one?
> > > > > http://lore.kernel.org/all/1708997579.5613105-1-xuanzhuo@linux.al=
ibaba.com
> > > >
> > > >
> > > > I did. The answer is that no, you don't get to regress memory usage
> > > > for lots of people then fix it up.
> > > > So the patchset is big, I guess it will take a couple of cycles to
> > > > merge gradually.
> > >
> > > Hi @Michael
> > >
> > > So, how about this patch set?
> > >
> > > I do not think they (dma maintainers) will agree the API dma_can_skip=
_unmap().
> > >
> > > If you think sq wastes too much memory using pre-mapped dma mode, how=
 about
> > > we only enable it when xsk is bond?
> > >
> > > Could you give me some advice?
> >
> > I think we have some discussion, one possible solution is:
> >
> > when pre mapping is enabled, virtio core won't store dma metadatas.
> >
> > Then it makes virtio-net align with other NIC.
>
>
> YES.
>
> This patch set works as this.
>
> But the virtio-net must allocate too much memory to store dma and len.
>
> num =3D queue size * 19
>
> Michael thinks that waste too much memory.
>         http://lore.kernel.org/all/20240225032330-mutt-send-email-mst@ker=
nel.org
>
> So we try this:
>         http://lore.kernel.org/all/20240301071918.64631-1-xuanzhuo@linux.=
alibaba.com
>
> But I think that is difficult to be accepted by the  DMA maintainers.
>
> So I have two advices:
>
> 1. virtio-net sq works without indirect.
>         - that more like other NIC
>         - the num of the memory to store the dma info is queue_size

This requires benchmarks.

>
> 2. The default mode of virtio-net sq is no-premapped
>         - we just switch the mode when binding xsk

This could be one step.

We can hear from Michael.

Thanks

>
> Thanks.
>
>
> >
> > Thanks
> >
> > >
> > > Thanks.
> > >
> > >
> > > >
> > > > > I asked you. But I didnot recv your answer.
> > > > >
> > > > > Thanks.
> > > > >
> > > > >
> > > > > >
> > > > > > > v2:
> > > > > > >     1. change the dma item of virtio-net, every item have MAX=
_SKB_FRAGS + 2
> > > > > > >         addr + len pairs.
> > > > > > >     2. introduce virtnet_sq_free_stats for __free_old_xmit
> > > > > > >
> > > > > > > v1:
> > > > > > >     1. rename transport_vq_config to vq_transport_config
> > > > > > >     2. virtio-net set dma meta number to (ring-size + 1)(MAX_=
SKB_FRGAS +2)
> > > > > > >     3. introduce virtqueue_dma_map_sg_attrs
> > > > > > >     4. separate vring_create_virtqueue to an independent comm=
it
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > Xuan Zhuo (19):
> > > > > > >   virtio_ring: introduce vring_need_unmap_buffer
> > > > > > >   virtio_ring: packed: remove double check of the unmap ops
> > > > > > >   virtio_ring: packed: structure the indirect desc table
> > > > > > >   virtio_ring: split: remove double check of the unmap ops
> > > > > > >   virtio_ring: split: structure the indirect desc table
> > > > > > >   virtio_ring: no store dma info when unmap is not needed
> > > > > > >   virtio: find_vqs: pass struct instead of multi parameters
> > > > > > >   virtio: vring_create_virtqueue: pass struct instead of mult=
i
> > > > > > >     parameters
> > > > > > >   virtio: vring_new_virtqueue(): pass struct instead of multi=
 parameters
> > > > > > >   virtio_ring: simplify the parameters of the funcs related t=
o
> > > > > > >     vring_create/new_virtqueue()
> > > > > > >   virtio: find_vqs: add new parameter premapped
> > > > > > >   virtio_ring: export premapped to driver by struct virtqueue
> > > > > > >   virtio_net: set premapped mode by find_vqs()
> > > > > > >   virtio_ring: remove api of setting vq premapped
> > > > > > >   virtio_ring: introduce dma map api for page
> > > > > > >   virtio_ring: introduce virtqueue_dma_map_sg_attrs
> > > > > > >   virtio_net: unify the code for recycling the xmit ptr
> > > > > > >   virtio_net: rename free_old_xmit_skbs to free_old_xmit
> > > > > > >   virtio_net: sq support premapped mode
> > > > > > >
> > > > > > >  arch/um/drivers/virtio_uml.c             |  31 +-
> > > > > > >  drivers/net/virtio_net.c                 | 283 ++++++---
> > > > > > >  drivers/platform/mellanox/mlxbf-tmfifo.c |  24 +-
> > > > > > >  drivers/remoteproc/remoteproc_virtio.c   |  31 +-
> > > > > > >  drivers/s390/virtio/virtio_ccw.c         |  33 +-
> > > > > > >  drivers/virtio/virtio_mmio.c             |  30 +-
> > > > > > >  drivers/virtio/virtio_pci_common.c       |  59 +-
> > > > > > >  drivers/virtio/virtio_pci_common.h       |   9 +-
> > > > > > >  drivers/virtio/virtio_pci_legacy.c       |  16 +-
> > > > > > >  drivers/virtio/virtio_pci_modern.c       |  38 +-
> > > > > > >  drivers/virtio/virtio_ring.c             | 698 ++++++++++++-=
----------
> > > > > > >  drivers/virtio/virtio_vdpa.c             |  45 +-
> > > > > > >  include/linux/virtio.h                   |  13 +-
> > > > > > >  include/linux/virtio_config.h            |  48 +-
> > > > > > >  include/linux/virtio_ring.h              |  82 +--
> > > > > > >  tools/virtio/virtio_test.c               |   4 +-
> > > > > > >  tools/virtio/vringh_test.c               |  28 +-
> > > > > > >  17 files changed, 847 insertions(+), 625 deletions(-)
> > > > > > >
> > > > > > > --
> > > > > > > 2.32.0.3.g01195cf9f
> > > > > >
> > > >
> > >
> >
>


