Return-Path: <kvm+bounces-12276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DE8C880EDE
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 10:42:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1098F286F9F
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F2243BB23;
	Wed, 20 Mar 2024 09:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GdC0vE7Y"
X-Original-To: kvm@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAB43B791;
	Wed, 20 Mar 2024 09:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710927711; cv=none; b=MbfQ16VFm6vUvpmicpX6QF+mPFfn7tz9A4zlvBwGcWqU0ouDc6CvcN4/d1nxe0i9lHG3ObRFcs3T73yjg9L/ORixUUG+Hlof+3s852BqTbqVtY6u/x/i+XSXtONz2C/gI4p2NsOhTXWwuqq690Wc0FKmyFWoFyC0BoFaULuCju8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710927711; c=relaxed/simple;
	bh=t3xfbxktSFOfO7Mab4aMKKzQnq3+/1YJjpDlTZcN20E=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=Wqi3FOIvSEC9pEA1xu3I+kGxRM23+qDHjpfp2EyzTjlGnTZTiIZg12W5V1lWYwl/sUW/otfDX5e3IZiRmiC24WGedSvHQcX+7v9TpN8REbXrBXsRHnqRmMG00vW+l/rLcit+Gq5Y9bgIUk7maBcJrQxXsAFYUxyOl4CAy3wKLNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GdC0vE7Y; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710927700; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=wXKu2e8VFSQ0AuTa9FlsNWoTmcdj8Yv+4aiz4H2u7Po=;
	b=GdC0vE7Y8UGFeYixIj8gtxBpm5bzOto1GoIAKfbis7MbTtHY7xSQArsp3TGF5gMPlAwFVHECUD2O6P+MSGvUP5Jyun9bjOAN8bS2SEYOTFYLIUswos7umXgDXjKTQQ7L39miXgIn47pBQiAsXuk/ZLwBXqbw9HdDw779gRypnH4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0W2wqjEi_1710927697;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W2wqjEi_1710927697)
          by smtp.aliyun-inc.com;
          Wed, 20 Mar 2024 17:41:38 +0800
Message-ID: <1710927569.5383172-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v3 1/4] virtio: find_vqs: pass struct instead of multi parameters
Date: Wed, 20 Mar 2024 17:39:29 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
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
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>
References: <20240312021013.88656-1-xuanzhuo@linux.alibaba.com>
 <20240312021013.88656-2-xuanzhuo@linux.alibaba.com>
 <CACGkMEvVgfgAxLoKeFTgy-1GR0W07ciPYFuqs6PiWtKCnXuWTw@mail.gmail.com>
 <1710395908.7915084-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEsT2JqJ1r_kStUzW0+-f+qT0C05n2A+Yrjpc-mHMZD_mQ@mail.gmail.com>
 <1710487245.6843069-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEspzDTZP1yxkBz17MgU9meyfCUBDxG8mjm=acXHNxAxhg@mail.gmail.com>
 <1710741592.205804-1-xuanzhuo@linux.alibaba.com>
 <20240319025726-mutt-send-email-mst@kernel.org>
 <CACGkMEsO6e2=v36F=ezhHCEaXqG0+AhkCM2ZgmKAtyWncnif5Q@mail.gmail.com>
In-Reply-To: <CACGkMEsO6e2=v36F=ezhHCEaXqG0+AhkCM2ZgmKAtyWncnif5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Wed, 20 Mar 2024 17:22:50 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Tue, Mar 19, 2024 at 2:58=E2=80=AFPM Michael S. Tsirkin <mst@redhat.co=
m> wrote:
> >
> > On Mon, Mar 18, 2024 at 01:59:52PM +0800, Xuan Zhuo wrote:
> > > On Mon, 18 Mar 2024 12:18:23 +0800, Jason Wang <jasowang@redhat.com> =
wrote:
> > > > On Fri, Mar 15, 2024 at 3:26=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.a=
libaba.com> wrote:
> > > > >
> > > > > On Fri, 15 Mar 2024 11:51:48 +0800, Jason Wang <jasowang@redhat.c=
om> wrote:
> > > > > > On Thu, Mar 14, 2024 at 2:00=E2=80=AFPM Xuan Zhuo <xuanzhuo@lin=
ux.alibaba.com> wrote:
> > > > > > >
> > > > > > > On Thu, 14 Mar 2024 11:12:24 +0800, Jason Wang <jasowang@redh=
at.com> wrote:
> > > > > > > > On Tue, Mar 12, 2024 at 10:10=E2=80=AFAM Xuan Zhuo <xuanzhu=
o@linux.alibaba.com> wrote:
> > > > > > > > >
> > > > > > > > > Now, we pass multi parameters to find_vqs. These paramete=
rs
> > > > > > > > > may work for transport or work for vring.
> > > > > > > > >
> > > > > > > > > And find_vqs has multi implements in many places:
> > > > > > > > >
> > > > > > > > >  arch/um/drivers/virtio_uml.c
> > > > > > > > >  drivers/platform/mellanox/mlxbf-tmfifo.c
> > > > > > > > >  drivers/remoteproc/remoteproc_virtio.c
> > > > > > > > >  drivers/s390/virtio/virtio_ccw.c
> > > > > > > > >  drivers/virtio/virtio_mmio.c
> > > > > > > > >  drivers/virtio/virtio_pci_legacy.c
> > > > > > > > >  drivers/virtio/virtio_pci_modern.c
> > > > > > > > >  drivers/virtio/virtio_vdpa.c
> > > > > > > > >
> > > > > > > > > Every time, we try to add a new parameter, that is diffic=
ult.
> > > > > > > > > We must change every find_vqs implement.
> > > > > > > > >
> > > > > > > > > One the other side, if we want to pass a parameter to vri=
ng,
> > > > > > > > > we must change the call path from transport to vring.
> > > > > > > > > Too many functions need to be changed.
> > > > > > > > >
> > > > > > > > > So it is time to refactor the find_vqs. We pass a structu=
re
> > > > > > > > > cfg to find_vqs(), that will be passed to vring by transp=
ort.
> > > > > > > > >
> > > > > > > > > Because the vp_modern_create_avq() use the "const char *n=
ames[]",
> > > > > > > > > and the virtio_uml.c changes the name in the subsequent c=
ommit, so
> > > > > > > > > change the "names" inside the virtio_vq_config from "cons=
t char *const
> > > > > > > > > *names" to "const char **names".
> > > > > > > > >
> > > > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > > > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> > > > > > > > > Reviewed-by: Ilpo J=3DE4rvinen <ilpo.jarvinen@linux.intel=
.com>
> > > > > > > >
> > > > > > > > The name seems broken here.
> > > > > > >
> > > > > > > Email APP bug.
> > > > > > >
> > > > > > > I will fix.
> > > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > [...]
> > > > > > > >
> > > > > > > > >
> > > > > > > > >  typedef void vq_callback_t(struct virtqueue *);
> > > > > > > > >
> > > > > > > > > +/**
> > > > > > > > > + * struct virtio_vq_config - configure for find_vqs()
> > > > > > > > > + * @cfg_idx: Used by virtio core. The drivers should set=
 this to 0.
> > > > > > > > > + *     During the initialization of each vq(vring setup)=
, we need to know which
> > > > > > > > > + *     item in the array should be used at that time. Bu=
t since the item in
> > > > > > > > > + *     names can be null, which causes some item of arra=
y to be skipped, we
> > > > > > > > > + *     cannot use vq.index as the current id. So add a c=
fg_idx to let vring
> > > > > > > > > + *     know how to get the current configuration from th=
e array when
> > > > > > > > > + *     initializing vq.
> > > > > > > >
> > > > > > > > So this design is not good. If it is not something that the=
 driver
> > > > > > > > needs to care about, the core needs to hide it from the API.
> > > > > > >
> > > > > > > The driver just ignore it. That will be beneficial to the vir=
tio core.
> > > > > > > Otherwise, we must pass one more parameter everywhere.
> > > > > >
> > > > > > I don't get here, it's an internal logic and we've already done=
 that.
> > > > >
> > > > >
> > > > > ## Then these must add one param "cfg_idx";
> > > > >
> > > > >  struct virtqueue *vring_create_virtqueue(struct virtio_device *v=
dev,
> > > > >                                          unsigned int index,
> > > > >                                          struct vq_transport_conf=
ig *tp_cfg,
> > > > >                                          struct virtio_vq_config =
*cfg,
> > > > > -->                                      uint cfg_idx);
> > > > >
> > > > >  struct virtqueue *vring_new_virtqueue(struct virtio_device *vdev,
> > > > >                                       unsigned int index,
> > > > >                                       void *pages,
> > > > >                                       struct vq_transport_config =
*tp_cfg,
> > > > >                                       struct virtio_vq_config *cf=
g,
> > > > > -->                                      uint cfg_idx);
> > > > >
> > > > >
> > > > > ## The functions inside virtio_ring also need to add a new param,=
 such as:
> > > > >
> > > > >  static struct virtqueue *vring_create_virtqueue_split(struct vir=
tio_device *vdev,
> > > > >                                                       unsigned in=
t index,
> > > > >                                                       struct vq_t=
ransport_config *tp_cfg,
> > > > >                                                       struct virt=
io_vq_config,
> > > > > -->                                                   uint cfg_id=
x);
> > > > >
> > > > >
> > > > >
> > > >
> > > > I guess what I'm missing is when could the index differ from cfg_id=
x?
> > >
> > >
> > >  @cfg_idx: Used by virtio core. The drivers should set this to 0.
> > >      During the initialization of each vq(vring setup), we need to kn=
ow which
> > >      item in the array should be used at that time. But since the ite=
m in
> > >      names can be null, which causes some item of array to be skipped=
, we
> > >      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > >      cannot use vq.index as the current id. So add a cfg_idx to let v=
ring
> > >      know how to get the current configuration from the array when
> > >      initializing vq.
> > >
> > >
> > > static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int =
nvqs,
> > >
> > >       ................
> > >
> > >       for (i =3D 0; i < nvqs; ++i) {
> > >               if (!names[i]) {
> > >                       vqs[i] =3D NULL;
> > >                       continue;
> > >               }
> > >
> > >               if (!callbacks[i])
> > >                       msix_vec =3D VIRTIO_MSI_NO_VECTOR;
> > >               else if (vp_dev->per_vq_vectors)
> > >                       msix_vec =3D allocated_vectors++;
> > >               else
> > >                       msix_vec =3D VP_MSIX_VQ_VECTOR;
> > >               vqs[i] =3D vp_setup_vq(vdev, queue_idx++, callbacks[i],=
 names[i],
> > >                                    ctx ? ctx[i] : false,
> > >                                    msix_vec);
> > >
> > >
> > > Thanks.
> >
> >
> > Jason what do you think is the way to resolve this?
>
> I wonder which driver doesn't use a specific virtqueue in this case.


commit 6457f126c888b3481fdae6f702e616cd0c79646e
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Wed Sep 5 21:47:45 2012 +0300

    virtio: support reserved vqs

    virtio network device multiqueue support reserves
    vq 3 for future use (useful both for future extensions and to make it
    pretty - this way receive vqs have even and transmit - odd numbers).
    Make it possible to skip initialization for
    specific vq numbers by specifying NULL for name.
    Document this usage as well as (existing) NULL callback.

    Drivers using this not coded up yet, so I simply tested
    with virtio-pci and verified that this patch does
    not break existing drivers.

    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

This patch introduced this.

Could we remove this? Then we can use the vq.index directly. That will
be great.

>
> And it looks to me, introducing a per-vq-config struct might be better
> then we have
>
> virtio_vqs_config {
>       unsigned int nvqs;
>       struct virtio_vq_config *configs;
> }

YES. I prefer this. But we need to refactor every driver.

>
> So we don't need the cfg_idx stuff.

This still needs cfg_idx.

Thanks


>
> Thanks
>
> >
> > > >
> > > > Thanks
> > > >
> > > > > Thanks.
> > > > >
> > > > >
> > > > >
> > > > >
> > > > > >
> > > > > > Thanks
> > > > > >
> > > > > > >
> > > > > > > Thanks.
> > > > > > >
> > > > > > > >
> > > > > > > > Thanks
> > > > > > > >
> > > > > > >
> > > > > >
> > > > >
> > > >
> >
>

