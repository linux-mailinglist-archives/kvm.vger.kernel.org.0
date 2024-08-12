Return-Path: <kvm+bounces-23825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD8094E728
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 08:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4D221F21DD5
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 06:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD19D152E17;
	Mon, 12 Aug 2024 06:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hLHwc5hQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595AE14E2C5
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 06:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723445447; cv=none; b=i96f9b9gJfUqrZJ46cSrL5DHPuQKLWCmJzBEkoMtsYzKrsnATV+bmaksbMOoTf2343kd9Dv34j6akjT/fMjte/QNcbPHde99JaBrdktcbuIjLx1TJblr2ikMXLId75xXL+OOWcrefiZy232AMSOfDIZR/MNtJ/cSJA0TwBUGmLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723445447; c=relaxed/simple;
	bh=W0eY8Xq3o3fHaz8bN7dG7yytV8UUgXdPUr5ycR0qiCc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AkVb2WXGntIQoZtKdLwEW01Ki2wwoe06C23m2QnG6fKIRHFNaiwd6b0lbXH4S+/hgw13RIty7ajcnBm9/LcXcsalyXyJWIQDIGstlrX3NCnScWm0Y/pcxgJyrJ3Ujqx3M7emlnDvEskXQ8ECCkSXW0KyVx8mr8sghLedb2ud9ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hLHwc5hQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723445444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gD7Wwk8kOu+4mm0l1d/x7a1qMGGKB1sRxp0z9/NXgwQ=;
	b=hLHwc5hQ+V9AAcMetowNy+Ug54nI6SAGFjtZ+/Dpt+nVLh355OKS2HbLMuhgRcYmk7UYci
	xFCzewO7NnAYXyb4CcOwX/F+VKvW6XCIMzQCwSsL6LDN6k/ktSDlve/Bf4LfX/z2vLWBMf
	mzTgJ6M4XDLmNCGxu0fPUk+4EfByzgQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-X_u28sSiPl2Yvt8eNUCWxw-1; Mon, 12 Aug 2024 02:50:09 -0400
X-MC-Unique: X_u28sSiPl2Yvt8eNUCWxw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2cb4bcd9671so5525156a91.1
        for <kvm@vger.kernel.org>; Sun, 11 Aug 2024 23:50:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723445408; x=1724050208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gD7Wwk8kOu+4mm0l1d/x7a1qMGGKB1sRxp0z9/NXgwQ=;
        b=Eh5zk07Z5T+bT8CSOiBiOELJUv8oWMXLHRoY+36zhgDKX9vzlxJiYR/SFOge3+XKND
         xMD73LBKgyeh36fX11ZMJHgOT5g0yGvUV21lyY58F5LbsE5fB8rrcnRCalCakDqwNcPS
         Z0omVQqXWon5RZOv1eiwkRsjUXEicEwvncYTzk8Z+8wmt5MeyvOSfjWoleRqQ760Bs7T
         UDhVZqZ369b3xFqVcoxUc8EYevMNvDD+2Hle9d90EchQgeZbOfUKD/3ni3Y1xktnzlY/
         ygcBb92Tt5gkXLsueqskDvKttRHr4oTTcizvJ5DlFc7fLJY8PVTAmoHfXYgOyXPY37TR
         GfgA==
X-Forwarded-Encrypted: i=1; AJvYcCVSXS/LkECSM4Rfjj7IHkB9krpt7H9RDRxs10RgH5VvGu228BDXHxYoqOJZNyYXOepOsu2bB5Ze7wY2fc3o+joTKFLj
X-Gm-Message-State: AOJu0Yx5rDFuG4BYFv+wN27RTfjHWkr4b/slaGCxz2/yayTF0ZZq6AnN
	bP7aNzFAke5bvUPckBi3Oo+evin8SVXLIyTnakl+gTujRAqwhxRlSCZ9pD8fFhgHL7yzVO/fiFZ
	YTGAdgZb2tIjqyGfDzaV9vmj4ZJl7oBd3R11OrBXegfugwiGoJEUwhM+Py2IxLB6875c1swyTxy
	S7EiNadsqCEo1rYNpOV/+YEXPw
X-Received: by 2002:a17:90b:207:b0:2c8:6308:ad78 with SMTP id 98e67ed59e1d1-2d1e80535d9mr10033990a91.34.1723445408333;
        Sun, 11 Aug 2024 23:50:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLGdwLYNX0VkuJKSx7I3Z1IUqAOr4ykW1cwWLQquNN9Af/9UdiPhu4hOno89xx+1HV9TCUE70bE5DOF3ax+PY=
X-Received: by 2002:a17:90b:207:b0:2c8:6308:ad78 with SMTP id
 98e67ed59e1d1-2d1e80535d9mr10033967a91.34.1723445407662; Sun, 11 Aug 2024
 23:50:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240808082044.11356-1-jasowang@redhat.com> <9da68127-23d8-48a4-b56f-a3ff54fa213c@nvidia.com>
 <CACGkMEshq0=djGQ0gJe=AinZ2EHSpgE6CykspxRgLS_Ok55FKw@mail.gmail.com>
In-Reply-To: <CACGkMEshq0=djGQ0gJe=AinZ2EHSpgE6CykspxRgLS_Ok55FKw@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 12 Aug 2024 14:49:56 +0800
Message-ID: <CACGkMEvAVM+KLpq7=+m8q1Wajs_FSSfftRGE+HN16OrFhqX=ow@mail.gmail.com>
Subject: Re: [RFC PATCH] vhost_vdpa: assign irq bypass producer token correctly
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: mst@redhat.com, lingshan.zhu@intel.com, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2024 at 1:47=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Fri, Aug 9, 2024 at 2:04=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.co=
m> wrote:
> >
> >
> >
> > On 08.08.24 10:20, Jason Wang wrote:
> > > We used to call irq_bypass_unregister_producer() in
> > > vhost_vdpa_setup_vq_irq() which is problematic as we don't know if th=
e
> > > token pointer is still valid or not.
> > >
> > > Actually, we use the eventfd_ctx as the token so the life cycle of th=
e
> > > token should be bound to the VHOST_SET_VRING_CALL instead of
> > > vhost_vdpa_setup_vq_irq() which could be called by set_status().
> > >
> > > Fixing this by setting up  irq bypass producer's token when handling
> > > VHOST_SET_VRING_CALL and un-registering the producer before calling
> > > vhost_vring_ioctl() to prevent a possible use after free as eventfd
> > > could have been released in vhost_vring_ioctl().
> > >
> > > Fixes: 2cf1ba9a4d15 ("vhost_vdpa: implement IRQ offloading in vhost_v=
dpa")
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > > Note for Dragos: Please check whether this fixes your issue. I
> > > slightly test it with vp_vdpa in L2.
> > > ---
> > >  drivers/vhost/vdpa.c | 12 +++++++++---
> > >  1 file changed, 9 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > index e31ec9ebc4ce..388226a48bcc 100644
> > > --- a/drivers/vhost/vdpa.c
> > > +++ b/drivers/vhost/vdpa.c
> > > @@ -209,11 +209,9 @@ static void vhost_vdpa_setup_vq_irq(struct vhost=
_vdpa *v, u16 qid)
> > >       if (irq < 0)
> > >               return;
> > >
> > > -     irq_bypass_unregister_producer(&vq->call_ctx.producer);
> > >       if (!vq->call_ctx.ctx)
> > >               return;
> > >
> > > -     vq->call_ctx.producer.token =3D vq->call_ctx.ctx;
> > >       vq->call_ctx.producer.irq =3D irq;
> > >       ret =3D irq_bypass_register_producer(&vq->call_ctx.producer);
> > >       if (unlikely(ret))
> > > @@ -709,6 +707,12 @@ static long vhost_vdpa_vring_ioctl(struct vhost_=
vdpa *v, unsigned int cmd,
> > >                       vq->last_avail_idx =3D vq_state.split.avail_ind=
ex;
> > >               }
> > >               break;
> > > +     case VHOST_SET_VRING_CALL:
> > > +             if (vq->call_ctx.ctx) {
> > > +                     vhost_vdpa_unsetup_vq_irq(v, idx);
> > > +                     vq->call_ctx.producer.token =3D NULL;
> > > +             }
> > > +             break;
> > >       }
> > >
> > >       r =3D vhost_vring_ioctl(&v->vdev, cmd, argp);
> > > @@ -747,13 +751,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost=
_vdpa *v, unsigned int cmd,
> > >                       cb.callback =3D vhost_vdpa_virtqueue_cb;
> > >                       cb.private =3D vq;
> > >                       cb.trigger =3D vq->call_ctx.ctx;
> > > +                     vq->call_ctx.producer.token =3D vq->call_ctx.ct=
x;
> > > +                     vhost_vdpa_setup_vq_irq(v, idx);
> > >               } else {
> > >                       cb.callback =3D NULL;
> > >                       cb.private =3D NULL;
> > >                       cb.trigger =3D NULL;
> > >               }
> > >               ops->set_vq_cb(vdpa, idx, &cb);
> > > -             vhost_vdpa_setup_vq_irq(v, idx);
> > >               break;
> > >
> > >       case VHOST_SET_VRING_NUM:
> > > @@ -1419,6 +1424,7 @@ static int vhost_vdpa_open(struct inode *inode,=
 struct file *filep)
> > >       for (i =3D 0; i < nvqs; i++) {
> > >               vqs[i] =3D &v->vqs[i];
> > >               vqs[i]->handle_kick =3D handle_vq_kick;
> > > +             vqs[i]->call_ctx.ctx =3D NULL;
> > >       }
> > >       vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
> > >                      vhost_vdpa_process_iotlb_msg);
> >
> > No more crashes, but now getting a lot of:
> >  vhost-vdpa-X: vq Y, irq bypass producer (token 00000000a66e28ab) regis=
tration fails, ret =3D  -16
> >
> > ... seems like the irq_bypass_unregister_producer() that was removed
> > might still be needed somewhere?
>
> Probably, but I didn't see this when testing vp_vdpa.
>
> When did you meet those warnings? Is it during the boot or migration?

Btw, it would be helpful to check if mlx5_get_vq_irq() works
correctly. I believe it should return an error if the virtqueue
interrupt is not allocated. After a glance at the code, it seems not
straightforward to me.

Thanks

>
> Thanks
>
> >
> > Thanks,
> > Dragos
> >
> >


