Return-Path: <kvm+bounces-12350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81933881BDB
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 05:12:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A54D51C218F2
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 04:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DFC6C2E3;
	Thu, 21 Mar 2024 04:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="eq0vEwY9"
X-Original-To: kvm@vger.kernel.org
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570D612B70;
	Thu, 21 Mar 2024 04:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710994371; cv=none; b=BACJQPIfupazsJxiuGlkkf9FcRPbstcl9sXKr4LuTBJNebpBySuIc48UC8WPw4C/q8FjTXfWixD6DEaoBx+Umrs7Nk/q2usXWjxHa4mzmpQjbTdXqUWIItJUwFbk+hAusq+3TeXK2+FmlbG0mCrlTOjjKCWu3qiVcpoeiZaC1yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710994371; c=relaxed/simple;
	bh=Vp71B4GEMTDHiQM7xMQ+BiW79aJuO9Vlm922xRazkJ0=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=PcHKYkroPcrdCK6qP4abyZAD1TuPhVoXVmGn79l8RNBEvweVf7hL/NVWFkZlblm0b+N7Uo9FdsYKtWy98NZKi5YMt7cAtxrvLEt/o4S3JDBa59WNQ8V2Ievw1GVY3XMu3IZ5NRvsJFwj6GGoTO4oxoGHWhcZjDH0O/nZiOpBk/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=eq0vEwY9; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710994363; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=req0CIF/JHvwS9l1KiNeKKb/Omqe6sSvgFAD4vx65+k=;
	b=eq0vEwY9Xi0wB9tLzAnaWUdV1+6rhGN5E44vTQvI3Js1R5UXc7Pl2Pg5NqSEiU45x1jCPGUqWc7lEAggaQ3aYGlt6ojFLIM/hPZIVYrxKkLiuYhIQlB8OoY+wqfm1wQC21nE7YimaTk2+KbUzQuYXe/tOKqOG3BSha5l+lvbUFo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0W2zLFlC_1710994361;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W2zLFlC_1710994361)
          by smtp.aliyun-inc.com;
          Thu, 21 Mar 2024 12:12:42 +0800
Message-ID: <1710994269.7745419-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v3 1/4] virtio: find_vqs: pass struct instead of multi parameters
Date: Thu, 21 Mar 2024 12:11:09 +0800
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
 <1710927569.5383172-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEuEqiLLGj-HY=gx4R1EVh_d=eYrmi=cuLzb1SiqiEHb-A@mail.gmail.com>
In-Reply-To: <CACGkMEuEqiLLGj-HY=gx4R1EVh_d=eYrmi=cuLzb1SiqiEHb-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Thu, 21 Mar 2024 12:03:36 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Wed, Mar 20, 2024 at 5:41=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > On Wed, 20 Mar 2024 17:22:50 +0800, Jason Wang <jasowang@redhat.com> wr=
ote:
> > > On Tue, Mar 19, 2024 at 2:58=E2=80=AFPM Michael S. Tsirkin <mst@redha=
t.com> wrote:
> > > >
> > > > On Mon, Mar 18, 2024 at 01:59:52PM +0800, Xuan Zhuo wrote:
> > > > > On Mon, 18 Mar 2024 12:18:23 +0800, Jason Wang <jasowang@redhat.c=
om> wrote:
> > > > > > On Fri, Mar 15, 2024 at 3:26=E2=80=AFPM Xuan Zhuo <xuanzhuo@lin=
ux.alibaba.com> wrote:
> > > > > > >
> > > > > > > On Fri, 15 Mar 2024 11:51:48 +0800, Jason Wang <jasowang@redh=
at.com> wrote:
> > > > > > > > On Thu, Mar 14, 2024 at 2:00=E2=80=AFPM Xuan Zhuo <xuanzhuo=
@linux.alibaba.com> wrote:
> > > > > > > > >
> > > > > > > > > On Thu, 14 Mar 2024 11:12:24 +0800, Jason Wang <jasowang@=
redhat.com> wrote:
> > > > > > > > > > On Tue, Mar 12, 2024 at 10:10=E2=80=AFAM Xuan Zhuo <xua=
nzhuo@linux.alibaba.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > Now, we pass multi parameters to find_vqs. These para=
meters
> > > > > > > > > > > may work for transport or work for vring.
> > > > > > > > > > >
> > > > > > > > > > > And find_vqs has multi implements in many places:
> > > > > > > > > > >
> > > > > > > > > > >  arch/um/drivers/virtio_uml.c
> > > > > > > > > > >  drivers/platform/mellanox/mlxbf-tmfifo.c
> > > > > > > > > > >  drivers/remoteproc/remoteproc_virtio.c
> > > > > > > > > > >  drivers/s390/virtio/virtio_ccw.c
> > > > > > > > > > >  drivers/virtio/virtio_mmio.c
> > > > > > > > > > >  drivers/virtio/virtio_pci_legacy.c
> > > > > > > > > > >  drivers/virtio/virtio_pci_modern.c
> > > > > > > > > > >  drivers/virtio/virtio_vdpa.c
> > > > > > > > > > >
> > > > > > > > > > > Every time, we try to add a new parameter, that is di=
fficult.
> > > > > > > > > > > We must change every find_vqs implement.
> > > > > > > > > > >
> > > > > > > > > > > One the other side, if we want to pass a parameter to=
 vring,
> > > > > > > > > > > we must change the call path from transport to vring.
> > > > > > > > > > > Too many functions need to be changed.
> > > > > > > > > > >
> > > > > > > > > > > So it is time to refactor the find_vqs. We pass a str=
ucture
> > > > > > > > > > > cfg to find_vqs(), that will be passed to vring by tr=
ansport.
> > > > > > > > > > >
> > > > > > > > > > > Because the vp_modern_create_avq() use the "const cha=
r *names[]",
> > > > > > > > > > > and the virtio_uml.c changes the name in the subseque=
nt commit, so
> > > > > > > > > > > change the "names" inside the virtio_vq_config from "=
const char *const
> > > > > > > > > > > *names" to "const char **names".
> > > > > > > > > > >
> > > > > > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > > > > > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> > > > > > > > > > > Reviewed-by: Ilpo J=3DE4rvinen <ilpo.jarvinen@linux.i=
ntel.com>
> > > > > > > > > >
> > > > > > > > > > The name seems broken here.
> > > > > > > > >
> > > > > > > > > Email APP bug.
> > > > > > > > >
> > > > > > > > > I will fix.
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > [...]
> > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > >  typedef void vq_callback_t(struct virtqueue *);
> > > > > > > > > > >
> > > > > > > > > > > +/**
> > > > > > > > > > > + * struct virtio_vq_config - configure for find_vqs()
> > > > > > > > > > > + * @cfg_idx: Used by virtio core. The drivers should=
 set this to 0.
> > > > > > > > > > > + *     During the initialization of each vq(vring se=
tup), we need to know which
> > > > > > > > > > > + *     item in the array should be used at that time=
. But since the item in
> > > > > > > > > > > + *     names can be null, which causes some item of =
array to be skipped, we
> > > > > > > > > > > + *     cannot use vq.index as the current id. So add=
 a cfg_idx to let vring
> > > > > > > > > > > + *     know how to get the current configuration fro=
m the array when
> > > > > > > > > > > + *     initializing vq.
> > > > > > > > > >
> > > > > > > > > > So this design is not good. If it is not something that=
 the driver
> > > > > > > > > > needs to care about, the core needs to hide it from the=
 API.
> > > > > > > > >
> > > > > > > > > The driver just ignore it. That will be beneficial to the=
 virtio core.
> > > > > > > > > Otherwise, we must pass one more parameter everywhere.
> > > > > > > >
> > > > > > > > I don't get here, it's an internal logic and we've already =
done that.
> > > > > > >
> > > > > > >
> > > > > > > ## Then these must add one param "cfg_idx";
> > > > > > >
> > > > > > >  struct virtqueue *vring_create_virtqueue(struct virtio_devic=
e *vdev,
> > > > > > >                                          unsigned int index,
> > > > > > >                                          struct vq_transport_=
config *tp_cfg,
> > > > > > >                                          struct virtio_vq_con=
fig *cfg,
> > > > > > > -->                                      uint cfg_idx);
> > > > > > >
> > > > > > >  struct virtqueue *vring_new_virtqueue(struct virtio_device *=
vdev,
> > > > > > >                                       unsigned int index,
> > > > > > >                                       void *pages,
> > > > > > >                                       struct vq_transport_con=
fig *tp_cfg,
> > > > > > >                                       struct virtio_vq_config=
 *cfg,
> > > > > > > -->                                      uint cfg_idx);
> > > > > > >
> > > > > > >
> > > > > > > ## The functions inside virtio_ring also need to add a new pa=
ram, such as:
> > > > > > >
> > > > > > >  static struct virtqueue *vring_create_virtqueue_split(struct=
 virtio_device *vdev,
> > > > > > >                                                       unsigne=
d int index,
> > > > > > >                                                       struct =
vq_transport_config *tp_cfg,
> > > > > > >                                                       struct =
virtio_vq_config,
> > > > > > > -->                                                   uint cf=
g_idx);
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > >
> > > > > > I guess what I'm missing is when could the index differ from cf=
g_idx?
> > > > >
> > > > >
> > > > >  @cfg_idx: Used by virtio core. The drivers should set this to 0.
> > > > >      During the initialization of each vq(vring setup), we need t=
o know which
> > > > >      item in the array should be used at that time. But since the=
 item in
> > > > >      names can be null, which causes some item of array to be ski=
pped, we
> > > > >      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^
> > > > >      cannot use vq.index as the current id. So add a cfg_idx to l=
et vring
> > > > >      know how to get the current configuration from the array when
> > > > >      initializing vq.
> > > > >
> > > > >
> > > > > static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned =
int nvqs,
> > > > >
> > > > >       ................
> > > > >
> > > > >       for (i =3D 0; i < nvqs; ++i) {
> > > > >               if (!names[i]) {
> > > > >                       vqs[i] =3D NULL;
> > > > >                       continue;
> > > > >               }
> > > > >
> > > > >               if (!callbacks[i])
> > > > >                       msix_vec =3D VIRTIO_MSI_NO_VECTOR;
> > > > >               else if (vp_dev->per_vq_vectors)
> > > > >                       msix_vec =3D allocated_vectors++;
> > > > >               else
> > > > >                       msix_vec =3D VP_MSIX_VQ_VECTOR;
> > > > >               vqs[i] =3D vp_setup_vq(vdev, queue_idx++, callbacks=
[i], names[i],
> > > > >                                    ctx ? ctx[i] : false,
> > > > >                                    msix_vec);
> > > > >
> > > > >
> > > > > Thanks.
> > > >
> > > >
> > > > Jason what do you think is the way to resolve this?
> > >
> > > I wonder which driver doesn't use a specific virtqueue in this case.
> >
> >
> > commit 6457f126c888b3481fdae6f702e616cd0c79646e
> > Author: Michael S. Tsirkin <mst@redhat.com>
> > Date:   Wed Sep 5 21:47:45 2012 +0300
> >
> >     virtio: support reserved vqs
> >
> >     virtio network device multiqueue support reserves
> >     vq 3 for future use (useful both for future extensions and to make =
it
> >     pretty - this way receive vqs have even and transmit - odd numbers).
> >     Make it possible to skip initialization for
> >     specific vq numbers by specifying NULL for name.
> >     Document this usage as well as (existing) NULL callback.
> >
> >     Drivers using this not coded up yet, so I simply tested
> >     with virtio-pci and verified that this patch does
> >     not break existing drivers.
> >
> >     Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> >
> > This patch introduced this.
> >
> > Could we remove this? Then we can use the vq.index directly. That will
> > be great.
> >
> > >
> > > And it looks to me, introducing a per-vq-config struct might be better
> > > then we have
> > >
> > > virtio_vqs_config {
> > >       unsigned int nvqs;
> > >       struct virtio_vq_config *configs;
> > > }
> >
> > YES. I prefer this. But we need to refactor every driver.
>
> Yes.
>
> >
> > >
> > > So we don't need the cfg_idx stuff.
> >
> > This still needs cfg_idx.
>
> Drive needs to pass config for each virtqueue. We can still check
> config->name so the virtqueue index could be used.

I see. If we pass the config for one queue to virtio ring,
then we do not to pass the idx.

But for now, I will remove the logic of checking name,
then we can use vq->index inside virtio ring.

Thanks.


>
> Thanks
>
> >
> > Thanks
> >
> >
> > >
> > > Thanks
> > >
> > > >
> > > > > >
> > > > > > Thanks
> > > > > >
> > > > > > > Thanks.
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > Thanks
> > > > > > > >
> > > > > > > > >
> > > > > > > > > Thanks.
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > Thanks
> > > > > > > > > >
> > > > > > > > >
> > > > > > > >
> > > > > > >
> > > > > >
> > > >
> > >
> >
>

