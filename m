Return-Path: <kvm+bounces-12661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 008CE88BB95
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 08:45:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32DB51C326DE
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 07:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A516713280F;
	Tue, 26 Mar 2024 07:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="tEGC+yMt"
X-Original-To: kvm@vger.kernel.org
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DD41804F;
	Tue, 26 Mar 2024 07:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711439121; cv=none; b=kqkhdDDIlpCFEnyYPl3AkKZqS9tousLAK3TyY4R1BDyjgRpC7L+vivbvov5daqLZTulPDV4OuAszq2m0319m8Y/cgnSwFQUCcyyQREF9hiFgd1jGGoyj8/D+wF20Zf2yVCind2FhSDvPWybj8ohlsTPITx4jHqb18exWbRzhOGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711439121; c=relaxed/simple;
	bh=qvUOTvrFfow3JtcT79klmW6KJs5WhOYeRCmam/JfN9s=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=pFAVcWn0aqswRF1I6yBmQhRtnSr2YpOYZKof6wOzhUw4mhC8wmSNZGmRp0Lp1pFQZbhmml9vWEBo+2Sq42t9xYcvOO+FQwg9rZOQHXJr+LnTKwxTEt1GdffJYhfbNNwKQihEhhK2nrvT6+3G3Pn9whXbSEDgrGZW6HogDSev+Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=tEGC+yMt; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711439116; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=Ba4I0Bd+6onGK25mYl7fzEyLNywF5unBrX0VUtEKFgw=;
	b=tEGC+yMtyx4tcKC/0UKnpLTjWuB7DybhR2j1m7rU0rgQHfGhtcCvJFEUQdIZEu2SgVfL5KK4WmT9dLcMtOJKit58XETr6XtPVgc4jzk41FSVKDeMuvoWc9QMR+LxPMunx0B/jj/t/X2AXxkFSgiUA+FS83DIW2F1Lc5HSbuAAww=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0W3KMp1M_1711439114;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W3KMp1M_1711439114)
          by smtp.aliyun-inc.com;
          Tue, 26 Mar 2024 15:45:14 +0800
Message-ID: <1711438956.7547545-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v5 2/6] virtio: remove support for names array entries being null.
Date: Tue, 26 Mar 2024 15:42:36 +0800
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
 David Hildenbrand <david@redhat.com>,
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240325090419.33677-1-xuanzhuo@linux.alibaba.com>
 <20240325090419.33677-3-xuanzhuo@linux.alibaba.com>
 <CACGkMEuuNrDkEUnnES-APDVag2=4wjyZi3aEg0+8vY+Bho=BRg@mail.gmail.com>
In-Reply-To: <CACGkMEuuNrDkEUnnES-APDVag2=4wjyZi3aEg0+8vY+Bho=BRg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Tue, 26 Mar 2024 12:28:34 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Mon, Mar 25, 2024 at 5:04=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > commit 6457f126c888 ("virtio: support reserved vqs") introduced this
> > support. Multiqueue virtio-net use 2N as ctrl vq finally, so the logic
> > doesn't apply. And not one uses this.
> >
> > On the other side, that makes some trouble for us to refactor the
> > find_vqs() params.
> >
> > So I remove this support.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  arch/um/drivers/virtio_uml.c             | 5 -----
> >  drivers/platform/mellanox/mlxbf-tmfifo.c | 4 ----
> >  drivers/remoteproc/remoteproc_virtio.c   | 5 -----
> >  drivers/s390/virtio/virtio_ccw.c         | 5 -----
> >  drivers/virtio/virtio_mmio.c             | 5 -----
> >  drivers/virtio/virtio_pci_common.c       | 9 ---------
> >  drivers/virtio/virtio_vdpa.c             | 5 -----
> >  include/linux/virtio_config.h            | 1 -
> >  8 files changed, 39 deletions(-)
> >
> > diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> > index 8adca2000e51..1d1e8654b7fc 100644
> > --- a/arch/um/drivers/virtio_uml.c
> > +++ b/arch/um/drivers/virtio_uml.c
> > @@ -1031,11 +1031,6 @@ static int vu_find_vqs(struct virtio_device *vde=
v, unsigned nvqs,
> >                 return rc;
> >
> >         for (i =3D 0; i < nvqs; ++i) {
> > -               if (!names[i]) {
> > -                       vqs[i] =3D NULL;
> > -                       continue;
> > -               }
>
> Does this mean names[i] must not be NULL? If yes, should we fail or
> not? If not, do we need to change the doc?

I think we should make sure that the names[i] must not be NULL.
We should return fail.

>
> [...]
>
> > --- a/include/linux/virtio_config.h
> > +++ b/include/linux/virtio_config.h
> > @@ -56,7 +56,6 @@ typedef void vq_callback_t(struct virtqueue *);
> >   *     callbacks: array of callbacks, for each virtqueue
> >   *             include a NULL entry for vqs that do not need a callback
> >   *     names: array of virtqueue names (mainly for debugging)
> > - *             include a NULL entry for vqs unused by driver
> >   *     Returns 0 on success or error status
> >   * @del_vqs: free virtqueues found by find_vqs().
> >   * @synchronize_cbs: synchronize with the virtqueue callbacks (optiona=
l)
>
>
> Since we had other check for names[i] like:
>
>         if (per_vq_vectors) {
>                 /* Best option: one for change interrupt, one per vq. */
>                 nvectors =3D 1;
>                 for (i =3D 0; i < nvqs; ++i)
>                         if (names[i] && callbacks[i])
>                                 ++nvectors;
>
> in vp_find_vqs_msix() and maybe other places.

names[i] should always be true. I will check this.

Thanks


>
> > --
> > 2.32.0.3.g01195cf9f
> >
>

