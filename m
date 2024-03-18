Return-Path: <kvm+bounces-11974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A16F887E39B
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 07:08:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30AA01F20F73
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 06:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEBD124B2A;
	Mon, 18 Mar 2024 06:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dZ1tR1FT"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494BD25753;
	Mon, 18 Mar 2024 06:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710742029; cv=none; b=oiBMcOCcPLmMjh96gm5KPgWF6Y2sq4bEmbCciuhtWYLq5jtckyPCQKYAxfp9CDmF51GhOT3VP3Ea5yZCosZV5SkuIZqgdbpEwnwiSnTI0rRk5/ySJbdh/Q9v4PHTPi7ryhWnd/Ef3gbxaoOgGMh8HjdQzhwW4ey474mRgXbCeIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710742029; c=relaxed/simple;
	bh=+csfDrZ3Yr9Z7rzlWExh7gMUsS0V8YkAx/69hE2Lkgo=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=SOWyLna4Gp2hShICz7vt+zwWQcRa2ucguKR9lCvQvbjxibT0t5pda+jZYtXMnmaW/lLkm9R/q1gCLlmJQuIQqK1udJXTMaufB7q/Fy4aFmhXgBTc6F4hPINCaNNkeom24kx3onU2DB39LcHSbaGXEHzbYn/dVnpPkpeZFxNIz0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dZ1tR1FT; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710742023; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=niI6nW2SCTi+Htrg/PArs3WUpjXkqv+GrYUsJh67k4o=;
	b=dZ1tR1FTXc2gWj8qCek8mlIGJOXr+ElRAt4obFJvFgE8XXJuQXjMCNVVFeBAc0cUO+qEK/NrdUwPXUt6PHVqwK6RGYWOR/N+KjoJ0qCHXl+k3MhegHIUgspiV98EfCsyiZIxOHvwhB1JHwiE3bPotE11wv4CTOV61OwCDziKqPQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0W2gHt5J_1710741698;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W2gHt5J_1710741698)
          by smtp.aliyun-inc.com;
          Mon, 18 Mar 2024 14:01:39 +0800
Message-ID: <1710741592.205804-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v3 1/4] virtio: find_vqs: pass struct instead of multi parameters
Date: Mon, 18 Mar 2024 13:59:52 +0800
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
 "Michael S. Tsirkin" <mst@redhat.com>,
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240312021013.88656-1-xuanzhuo@linux.alibaba.com>
 <20240312021013.88656-2-xuanzhuo@linux.alibaba.com>
 <CACGkMEvVgfgAxLoKeFTgy-1GR0W07ciPYFuqs6PiWtKCnXuWTw@mail.gmail.com>
 <1710395908.7915084-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEsT2JqJ1r_kStUzW0+-f+qT0C05n2A+Yrjpc-mHMZD_mQ@mail.gmail.com>
 <1710487245.6843069-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEspzDTZP1yxkBz17MgU9meyfCUBDxG8mjm=acXHNxAxhg@mail.gmail.com>
In-Reply-To: <CACGkMEspzDTZP1yxkBz17MgU9meyfCUBDxG8mjm=acXHNxAxhg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Mon, 18 Mar 2024 12:18:23 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Fri, Mar 15, 2024 at 3:26=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > On Fri, 15 Mar 2024 11:51:48 +0800, Jason Wang <jasowang@redhat.com> wr=
ote:
> > > On Thu, Mar 14, 2024 at 2:00=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.ali=
baba.com> wrote:
> > > >
> > > > On Thu, 14 Mar 2024 11:12:24 +0800, Jason Wang <jasowang@redhat.com=
> wrote:
> > > > > On Tue, Mar 12, 2024 at 10:10=E2=80=AFAM Xuan Zhuo <xuanzhuo@linu=
x.alibaba.com> wrote:
> > > > > >
> > > > > > Now, we pass multi parameters to find_vqs. These parameters
> > > > > > may work for transport or work for vring.
> > > > > >
> > > > > > And find_vqs has multi implements in many places:
> > > > > >
> > > > > >  arch/um/drivers/virtio_uml.c
> > > > > >  drivers/platform/mellanox/mlxbf-tmfifo.c
> > > > > >  drivers/remoteproc/remoteproc_virtio.c
> > > > > >  drivers/s390/virtio/virtio_ccw.c
> > > > > >  drivers/virtio/virtio_mmio.c
> > > > > >  drivers/virtio/virtio_pci_legacy.c
> > > > > >  drivers/virtio/virtio_pci_modern.c
> > > > > >  drivers/virtio/virtio_vdpa.c
> > > > > >
> > > > > > Every time, we try to add a new parameter, that is difficult.
> > > > > > We must change every find_vqs implement.
> > > > > >
> > > > > > One the other side, if we want to pass a parameter to vring,
> > > > > > we must change the call path from transport to vring.
> > > > > > Too many functions need to be changed.
> > > > > >
> > > > > > So it is time to refactor the find_vqs. We pass a structure
> > > > > > cfg to find_vqs(), that will be passed to vring by transport.
> > > > > >
> > > > > > Because the vp_modern_create_avq() use the "const char *names[]=
",
> > > > > > and the virtio_uml.c changes the name in the subsequent commit,=
 so
> > > > > > change the "names" inside the virtio_vq_config from "const char=
 *const
> > > > > > *names" to "const char **names".
> > > > > >
> > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> > > > > > Reviewed-by: Ilpo J=3DE4rvinen <ilpo.jarvinen@linux.intel.com>
> > > > >
> > > > > The name seems broken here.
> > > >
> > > > Email APP bug.
> > > >
> > > > I will fix.
> > > >
> > > >
> > > > >
> > > > > [...]
> > > > >
> > > > > >
> > > > > >  typedef void vq_callback_t(struct virtqueue *);
> > > > > >
> > > > > > +/**
> > > > > > + * struct virtio_vq_config - configure for find_vqs()
> > > > > > + * @cfg_idx: Used by virtio core. The drivers should set this =
to 0.
> > > > > > + *     During the initialization of each vq(vring setup), we n=
eed to know which
> > > > > > + *     item in the array should be used at that time. But sinc=
e the item in
> > > > > > + *     names can be null, which causes some item of array to b=
e skipped, we
> > > > > > + *     cannot use vq.index as the current id. So add a cfg_idx=
 to let vring
> > > > > > + *     know how to get the current configuration from the arra=
y when
> > > > > > + *     initializing vq.
> > > > >
> > > > > So this design is not good. If it is not something that the driver
> > > > > needs to care about, the core needs to hide it from the API.
> > > >
> > > > The driver just ignore it. That will be beneficial to the virtio co=
re.
> > > > Otherwise, we must pass one more parameter everywhere.
> > >
> > > I don't get here, it's an internal logic and we've already done that.
> >
> >
> > ## Then these must add one param "cfg_idx";
> >
> >  struct virtqueue *vring_create_virtqueue(struct virtio_device *vdev,
> >                                          unsigned int index,
> >                                          struct vq_transport_config *tp=
_cfg,
> >                                          struct virtio_vq_config *cfg,
> > -->                                      uint cfg_idx);
> >
> >  struct virtqueue *vring_new_virtqueue(struct virtio_device *vdev,
> >                                       unsigned int index,
> >                                       void *pages,
> >                                       struct vq_transport_config *tp_cf=
g,
> >                                       struct virtio_vq_config *cfg,
> > -->                                      uint cfg_idx);
> >
> >
> > ## The functions inside virtio_ring also need to add a new param, such =
as:
> >
> >  static struct virtqueue *vring_create_virtqueue_split(struct virtio_de=
vice *vdev,
> >                                                       unsigned int inde=
x,
> >                                                       struct vq_transpo=
rt_config *tp_cfg,
> >                                                       struct virtio_vq_=
config,
> > -->                                                   uint cfg_idx);
> >
> >
> >
>
> I guess what I'm missing is when could the index differ from cfg_idx?


 @cfg_idx: Used by virtio core. The drivers should set this to 0.
     During the initialization of each vq(vring setup), we need to know whi=
ch
     item in the array should be used at that time. But since the item in
     names can be null, which causes some item of array to be skipped, we
     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
     cannot use vq.index as the current id. So add a cfg_idx to let vring
     know how to get the current configuration from the array when
     initializing vq.


static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,

	................

	for (i =3D 0; i < nvqs; ++i) {
		if (!names[i]) {
			vqs[i] =3D NULL;
			continue;
		}

		if (!callbacks[i])
			msix_vec =3D VIRTIO_MSI_NO_VECTOR;
		else if (vp_dev->per_vq_vectors)
			msix_vec =3D allocated_vectors++;
		else
			msix_vec =3D VP_MSIX_VQ_VECTOR;
		vqs[i] =3D vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
				     ctx ? ctx[i] : false,
				     msix_vec);


Thanks.

>
> Thanks
>
> > Thanks.
> >
> >
> >
> >
> > >
> > > Thanks
> > >
> > > >
> > > > Thanks.
> > > >
> > > > >
> > > > > Thanks
> > > > >
> > > >
> > >
> >
>

