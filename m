Return-Path: <kvm+bounces-20047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B52D90FEAE
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 10:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8B66287011
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 08:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC2819580F;
	Thu, 20 Jun 2024 08:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fiH2odcI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCDD17CA1B
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718871688; cv=none; b=FDEqlPZ80DwC0eXj+TjRXwEkmprxyK0FpKvTwQZlxhtmA1MV6Ki+DLFdR5QBlStexTDiifOTjGTeAzgpBYikowhXkLrxO+b5oj2aH0Yqv0LZp6f3tTpIuPYMl536Bwn3TnTRSaftgg+SXFLls++dQdnHwK6u2TE4IMipJuiPvOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718871688; c=relaxed/simple;
	bh=LR/K+J6KzpZJF93eE1SpQIRs80lV/+fTYln8iY77+Ew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AvjYERm8l4Dbv6OXzli1AqXEIV3qj7VWWhH+2mx1YGKeZ0Wc19JlVO+wuow5U4BJKldBvMjfuTOHeUs6FRio+dCl4GTIz7RfX/chwcXmnp+WBTR79vVNe2SJzluyTeSkv+KKZTChdAS75FLcKN4wM4rQEAdt+Cahln1n++LT694=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fiH2odcI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718871685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UycNLq/jPjHQqHMLXV0878YjLaKSICJpDUuvwOlKQOg=;
	b=fiH2odcIhEG1oisi3mHKGehgZI9SYxQig1QfZOVZm0qGFcH9M1uKlgGH7Cw9LZRWbwEizE
	KduMX5cVnOJsdraraspSECc2siWH07ehAJnWXIDvhRKG7Rg5Nb9qLAT+RazFxRlX9bnLzH
	YASqEKMNw4bdR+eTPs3GANOM1pzhpIc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-CDZyn2q9N_6SYcco-NZIFA-1; Thu, 20 Jun 2024 04:21:21 -0400
X-MC-Unique: CDZyn2q9N_6SYcco-NZIFA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2c7e48b9f80so581405a91.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 01:21:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718871681; x=1719476481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UycNLq/jPjHQqHMLXV0878YjLaKSICJpDUuvwOlKQOg=;
        b=uKuGId/66aKQN3xRoxFeyp5Gpu8ADsncs8VU3Z3SSKJE5jPzFt+OV67O5c/hjjj6fH
         GzjnGyCFeLTdRJYLL/B+GwRbhnO6TM+vItqxMjm3jIcJLDpD9UVKM+jRt4SdAn/YDoWT
         +jI/Thnb3HUGcVIcfz3HixMc+qmT6VV5Rah3062bkSo/Ts/ezHf4RGI4G75+q8Tocbs5
         KfSNF9mb5fagwAwyKk0LEy+nMqJNkYiLCoy7AFkpkfptbBRNL/yA7OkwzF0JWHO31PTn
         S8JU1v05gVWccQDlI1WClOZn/YVj7Fle/Q9i4d2z7ecC+v/s7jndp6eE+gMW4w6sDZbp
         +1LA==
X-Forwarded-Encrypted: i=1; AJvYcCWZJHW7OsFAHEtiLD/UU22eKCO1U7KUS+p1RbGO5vSGlhipATb7koBkTPK+e7Zv2Q+5dKMgQPS0vyz5LoXNBG67gdvl
X-Gm-Message-State: AOJu0YzL+MnbXulalQCT8Rpc6Hs4C/HuOjoOHhMFu0lV8nzttMvobnUw
	HqPuJI7vUmdVjA5+UPiOYlfrbcAZ3YQ9fYWfXAUVIYM3PLMWqyz6o789JH94zn3x/exOvzEQ/5l
	esntlA6asnRjK/EGt8PVxpNfgp4THEhEziMN0CSRSfXPdiBzmZo0lKtBn6Q+AbDkco7ZT3hSnwx
	j+17kmGbPssLCOzHyMPq53A1q6
X-Received: by 2002:a17:90a:12cf:b0:2c2:deda:8561 with SMTP id 98e67ed59e1d1-2c7b5dc9665mr4142102a91.41.1718871680847;
        Thu, 20 Jun 2024 01:21:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtYn/rf/kl6Qj5/Pavju1IvIHJQmkYLZpAJM3Hav28b/FHSe46aqQwH/hKX1cWbXvGnnxKId86W9xKimIuLO4=
X-Received: by 2002:a17:90a:12cf:b0:2c2:deda:8561 with SMTP id
 98e67ed59e1d1-2c7b5dc9665mr4142074a91.41.1718871680356; Thu, 20 Jun 2024
 01:21:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
 <20240424091533.86949-2-xuanzhuo@linux.alibaba.com> <20240620040415-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240620040415-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 20 Jun 2024 16:21:08 +0800
Message-ID: <CACGkMEuGcP1gqmNUGSXx5QLwqizL=DUYWKm5AUycx96pz0JhsA@mail.gmail.com>
Subject: Re: [PATCH vhost v9 1/6] virtio_balloon: remove the dependence where
 names[] is null
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>, virtualization@lists.linux.dev, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Hans de Goede <hdegoede@redhat.com>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, David Hildenbrand <david@redhat.com>, linux-um@lists.infradead.org, 
	platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
	linux-s390@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2024 at 4:08=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Wed, Apr 24, 2024 at 05:15:28PM +0800, Xuan Zhuo wrote:
> > Currently, the init_vqs function within the virtio_balloon driver relie=
s
> > on the condition that certain names array entries are null in order to
> > skip the initialization of some virtual queues (vqs). This behavior is
> > unique to this part of the codebase. In an upcoming commit, we plan to
> > eliminate this dependency by removing the function entirely. Therefore,
> > with this change, we are ensuring that the virtio_balloon no longer
> > depends on the aforementioned function.
> >
> > As specification 1.0-1.2, vq indexes should not be contiguous if some
> > vq does not exist. But currently the virtqueue index is contiguous for
> > all existing devices. The Linux kernel does not implement functionality
> > to allow vq indexes to be discontinuous. So the current behavior of the
> > virtio-balloon device is different for the spec. But this commit has no
> > functional changes.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Acked-by: Jason Wang <jasowang@redhat.com>
>
> I can't make heads of tails of this.
>
> David you acked so maybe you can help rewrite the commit log here?
>
> I don't understand what this says.
> What in the balloon driver is out of spec?

The problem is the spec has bug, see this:

https://www.mail-archive.com/linux-um@lists.infradead.org/msg04359.html

Thanks


> NULL in names *exactly* allows skipping init for some vqs.
> How is that "does not implement"?
>
> And so on.
>
>
> > ---
> >  drivers/virtio/virtio_balloon.c | 48 ++++++++++++++-------------------
> >  1 file changed, 20 insertions(+), 28 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_ba=
lloon.c
> > index c0a63638f95e..ccda6d08493f 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -548,49 +548,41 @@ static int init_vqs(struct virtio_balloon *vb)
> >       struct virtqueue *vqs[VIRTIO_BALLOON_VQ_MAX];
> >       vq_callback_t *callbacks[VIRTIO_BALLOON_VQ_MAX];
> >       const char *names[VIRTIO_BALLOON_VQ_MAX];
> > -     int err;
> > +     int err, idx =3D 0;
> >
> > -     /*
> > -      * Inflateq and deflateq are used unconditionally. The names[]
> > -      * will be NULL if the related feature is not enabled, which will
> > -      * cause no allocation for the corresponding virtqueue in find_vq=
s.
> > -      */
> > -     callbacks[VIRTIO_BALLOON_VQ_INFLATE] =3D balloon_ack;
> > -     names[VIRTIO_BALLOON_VQ_INFLATE] =3D "inflate";
> > -     callbacks[VIRTIO_BALLOON_VQ_DEFLATE] =3D balloon_ack;
> > -     names[VIRTIO_BALLOON_VQ_DEFLATE] =3D "deflate";
> > -     callbacks[VIRTIO_BALLOON_VQ_STATS] =3D NULL;
> > -     names[VIRTIO_BALLOON_VQ_STATS] =3D NULL;
> > -     callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] =3D NULL;
> > -     names[VIRTIO_BALLOON_VQ_FREE_PAGE] =3D NULL;
> > -     names[VIRTIO_BALLOON_VQ_REPORTING] =3D NULL;
> > +     callbacks[idx] =3D balloon_ack;
> > +     names[idx++] =3D "inflate";
> > +     callbacks[idx] =3D balloon_ack;
> > +     names[idx++] =3D "deflate";
> >
> >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> > -             names[VIRTIO_BALLOON_VQ_STATS] =3D "stats";
> > -             callbacks[VIRTIO_BALLOON_VQ_STATS] =3D stats_request;
> > +             names[idx] =3D "stats";
> > +             callbacks[idx++] =3D stats_request;
> >       }
> >
> >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT)=
) {
> > -             names[VIRTIO_BALLOON_VQ_FREE_PAGE] =3D "free_page_vq";
> > -             callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] =3D NULL;
> > +             names[idx] =3D "free_page_vq";
> > +             callbacks[idx++] =3D NULL;
> >       }
> >
> >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > -             names[VIRTIO_BALLOON_VQ_REPORTING] =3D "reporting_vq";
> > -             callbacks[VIRTIO_BALLOON_VQ_REPORTING] =3D balloon_ack;
> > +             names[idx] =3D "reporting_vq";
> > +             callbacks[idx++] =3D balloon_ack;
> >       }
> >
> > -     err =3D virtio_find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX, vqs,
> > -                           callbacks, names, NULL);
> > +     err =3D virtio_find_vqs(vb->vdev, idx, vqs, callbacks, names, NUL=
L);
> >       if (err)
> >               return err;
> >
> > -     vb->inflate_vq =3D vqs[VIRTIO_BALLOON_VQ_INFLATE];
> > -     vb->deflate_vq =3D vqs[VIRTIO_BALLOON_VQ_DEFLATE];
> > +     idx =3D 0;
> > +
> > +     vb->inflate_vq =3D vqs[idx++];
> > +     vb->deflate_vq =3D vqs[idx++];
> > +
> >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> >               struct scatterlist sg;
> >               unsigned int num_stats;
> > -             vb->stats_vq =3D vqs[VIRTIO_BALLOON_VQ_STATS];
> > +             vb->stats_vq =3D vqs[idx++];
> >
> >               /*
> >                * Prime this virtqueue with one buffer so the hypervisor=
 can
> > @@ -610,10 +602,10 @@ static int init_vqs(struct virtio_balloon *vb)
> >       }
> >
> >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT)=
)
> > -             vb->free_page_vq =3D vqs[VIRTIO_BALLOON_VQ_FREE_PAGE];
> > +             vb->free_page_vq =3D vqs[idx++];
> >
> >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> > -             vb->reporting_vq =3D vqs[VIRTIO_BALLOON_VQ_REPORTING];
> > +             vb->reporting_vq =3D vqs[idx++];
> >
> >       return 0;
> >  }
> > --
> > 2.32.0.3.g01195cf9f
>


