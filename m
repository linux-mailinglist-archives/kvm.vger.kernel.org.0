Return-Path: <kvm+bounces-11491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D3B2877A3B
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 05:01:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E96D1C21137
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 04:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C33E23AD;
	Mon, 11 Mar 2024 04:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cZFSRK0x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2773B17D2
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 04:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710129666; cv=none; b=Fw/d5VBIz3RqDSexNVbQfqhPvs0beBSAb4k1unnzkwrHM1sGtVShzHf9tJK8HfiVMLow9cqC6Br0a6zqEP/ScK7bJvYQ6h1PLOqxfvvYlx0HXawAr5nkJlfkwofQDdCP9+s7MEEO+myl3XsoYEiFvLdy52PofhahyvLGQmswgPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710129666; c=relaxed/simple;
	bh=rZi0TGzdyLW1WeqbJYHxPHjlp/Ci1sJz1HPaw88Nqks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AM8Ot9A7ny2vWfRMBQ+Ny4dFBDs4Dkf9j3B/MW9RXibyCBNGe/kRpX0iRrZ1nBbKQcC80AWVp7noEn0a8xi0LbuDL+xWVwSqRJlqFp/VDOwnvazo0ukRslBdFAt7ggfReaqGKzMvWl5lf1stl3+wyK06t4YcmSWmudZVBk0v+Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cZFSRK0x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710129663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M2U/8cLx3dve7P4IJjHpYHx0RULwN13Wx0LsSxS6gyA=;
	b=cZFSRK0xWKiZdPEUcCWtp6aCGldohi//gJIEqDvd1YNj1EB7m7fRhFXe07NKJVsrwNIQb9
	XPm5r9kF9s9FSEmKlnYnc65o1qR1H73vK7zJtm81ZvSoeC7xzVnNvJOn4scUnN7xg6y/8G
	TQjm41NMXQ8QAa4f+nErCLC5vnt619k=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-tO06AmL5O-6dFeQ0a3C7sg-1; Mon, 11 Mar 2024 00:01:00 -0400
X-MC-Unique: tO06AmL5O-6dFeQ0a3C7sg-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-29bda2d3ea3so1301721a91.3
        for <kvm@vger.kernel.org>; Sun, 10 Mar 2024 21:01:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710129660; x=1710734460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M2U/8cLx3dve7P4IJjHpYHx0RULwN13Wx0LsSxS6gyA=;
        b=kIypaxcJ2Wcp5v7I6qYsk2VCG+J3mwm8+x6vJgErUumBbLdsTR3oV6knViH/gmq8I3
         OqEZU5dprZe2tU3macgT9txeSxJ1r33UeiNHln6sPfz80O/8H0ugC0Se4mivJwQDXQdt
         lk41C3SItHaSfGqz8lX8+4b4J8/eCeklZdhw/ZKCI5nnSubZiGYzuBhvbPVHGHq8Gs4X
         +zyhqQ1eNF9IFumM1RS5wdUs4pb0mNW7K4/Bt19ZrxsPAOoXAwHHIgWFK1AZa6E1H7iw
         XPUOT3f76YBAvOSgBLOc0J12Vg8b/CDLSWyvyB1syAlDDEdZb9amymFXr8Ou5FdjPocR
         RHrg==
X-Forwarded-Encrypted: i=1; AJvYcCVGuDFJrpO+5i44uwiUVVVLl4YZ7yueenVEvrxXuvlYI9qXcKHLpudTRl5k09Oknc/GfteYauqiCF2U94u5GcyuQdTf
X-Gm-Message-State: AOJu0YwK73QikS2OLyzYp4IqMqMBx4aWNLPS6eARhO9yOW9rWgxMj9JQ
	E8nMsRL4WvNNkGh0SuuJFOYHdTz913BeOwbJyY9/rv/BI2r6UzURzthA88kT02V/eeWx7jvacIv
	g/MAebIijosqmCZTpOaa0bDiPDxWcK5iUhQOmlN+J/NyZPo36eNuv0/FroshOXfwxUxzQDOxK/3
	bN3tKULe6uw5M6lVbTS6wCJVFn
X-Received: by 2002:a17:90a:fd92:b0:29b:bd2c:7238 with SMTP id cx18-20020a17090afd9200b0029bbd2c7238mr3908733pjb.7.1710129659789;
        Sun, 10 Mar 2024 21:00:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlzVpYifmiq3kPP1nBEaLaTDBKlwZXFbqzpZKku1ileIZWpeswDU4nOMch5iZXL/GpxbvnXQOshFnSjHN0OS4=
X-Received: by 2002:a17:90a:fd92:b0:29b:bd2c:7238 with SMTP id
 cx18-20020a17090afd9200b0029bbd2c7238mr3908714pjb.7.1710129659509; Sun, 10
 Mar 2024 21:00:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1709118356-133960-1-git-send-email-wangyunjian@huawei.com>
 <7d478cb842e28094f4d6102e593e3de25ab27dfe.camel@redhat.com>
 <223aeca6435342ec8a4d57c959c23303@huawei.com> <20240301065141-mutt-send-email-mst@kernel.org>
 <ffbe60c2732842a3b81e6ae0f58d2556@huawei.com>
In-Reply-To: <ffbe60c2732842a3b81e6ae0f58d2556@huawei.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 11 Mar 2024 12:00:47 +0800
Message-ID: <CACGkMEsFtJTMFVHt8pJ39Ge8nTJcsX=R_dYghz_93+_Yn--ZDQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
To: wangyunjian <wangyunjian@huawei.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Paolo Abeni <pabeni@redhat.com>, 
	"willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>, "kuba@kernel.org" <kuba@kernel.org>, 
	"bjorn@kernel.org" <bjorn@kernel.org>, "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>, 
	"maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>, 
	"jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, xudingke <xudingke@huawei.com>, 
	"liwei (DT)" <liwei395@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 4, 2024 at 9:45=E2=80=AFPM wangyunjian <wangyunjian@huawei.com>=
 wrote:
>
>
>
> > -----Original Message-----
> > From: Michael S. Tsirkin [mailto:mst@redhat.com]
> > Sent: Friday, March 1, 2024 7:53 PM
> > To: wangyunjian <wangyunjian@huawei.com>
> > Cc: Paolo Abeni <pabeni@redhat.com>; willemdebruijn.kernel@gmail.com;
> > jasowang@redhat.com; kuba@kernel.org; bjorn@kernel.org;
> > magnus.karlsson@intel.com; maciej.fijalkowski@intel.com;
> > jonathan.lemon@gmail.com; davem@davemloft.net; bpf@vger.kernel.org;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.o=
rg;
> > virtualization@lists.linux.dev; xudingke <xudingke@huawei.com>; liwei (=
DT)
> > <liwei395@huawei.com>
> > Subject: Re: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
> >
> > On Fri, Mar 01, 2024 at 11:45:52AM +0000, wangyunjian wrote:
> > > > -----Original Message-----
> > > > From: Paolo Abeni [mailto:pabeni@redhat.com]
> > > > Sent: Thursday, February 29, 2024 7:13 PM
> > > > To: wangyunjian <wangyunjian@huawei.com>; mst@redhat.com;
> > > > willemdebruijn.kernel@gmail.com; jasowang@redhat.com;
> > > > kuba@kernel.org; bjorn@kernel.org; magnus.karlsson@intel.com;
> > > > maciej.fijalkowski@intel.com; jonathan.lemon@gmail.com;
> > > > davem@davemloft.net
> > > > Cc: bpf@vger.kernel.org; netdev@vger.kernel.org;
> > > > linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> > > > virtualization@lists.linux.dev; xudingke <xudingke@huawei.com>;
> > > > liwei (DT) <liwei395@huawei.com>
> > > > Subject: Re: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy
> > > > support
> > > >
> > > > On Wed, 2024-02-28 at 19:05 +0800, Yunjian Wang wrote:
> > > > > @@ -2661,6 +2776,54 @@ static int tun_ptr_peek_len(void *ptr)
> > > > >         }
> > > > >  }
> > > > >
> > > > > +static void tun_peek_xsk(struct tun_file *tfile) {
> > > > > +       struct xsk_buff_pool *pool;
> > > > > +       u32 i, batch, budget;
> > > > > +       void *frame;
> > > > > +
> > > > > +       if (!ptr_ring_empty(&tfile->tx_ring))
> > > > > +               return;
> > > > > +
> > > > > +       spin_lock(&tfile->pool_lock);
> > > > > +       pool =3D tfile->xsk_pool;
> > > > > +       if (!pool) {
> > > > > +               spin_unlock(&tfile->pool_lock);
> > > > > +               return;
> > > > > +       }
> > > > > +
> > > > > +       if (tfile->nb_descs) {
> > > > > +               xsk_tx_completed(pool, tfile->nb_descs);
> > > > > +               if (xsk_uses_need_wakeup(pool))
> > > > > +                       xsk_set_tx_need_wakeup(pool);
> > > > > +       }
> > > > > +
> > > > > +       spin_lock(&tfile->tx_ring.producer_lock);
> > > > > +       budget =3D min_t(u32, tfile->tx_ring.size, TUN_XDP_BATCH)=
;
> > > > > +
> > > > > +       batch =3D xsk_tx_peek_release_desc_batch(pool, budget);
> > > > > +       if (!batch) {
> > > >
> > > > This branch looks like an unneeded "optimization". The generic loop
> > > > below should have the same effect with no measurable perf delta - a=
nd
> > smaller code.
> > > > Just remove this.
> > > >
> > > > > +               tfile->nb_descs =3D 0;
> > > > > +               spin_unlock(&tfile->tx_ring.producer_lock);
> > > > > +               spin_unlock(&tfile->pool_lock);
> > > > > +               return;
> > > > > +       }
> > > > > +
> > > > > +       tfile->nb_descs =3D batch;
> > > > > +       for (i =3D 0; i < batch; i++) {
> > > > > +               /* Encode the XDP DESC flag into lowest bit for c=
onsumer to
> > differ
> > > > > +                * XDP desc from XDP buffer and sk_buff.
> > > > > +                */
> > > > > +               frame =3D tun_xdp_desc_to_ptr(&pool->tx_descs[i])=
;
> > > > > +               /* The budget must be less than or equal to tx_ri=
ng.size,
> > > > > +                * so enqueuing will not fail.
> > > > > +                */
> > > > > +               __ptr_ring_produce(&tfile->tx_ring, frame);
> > > > > +       }
> > > > > +       spin_unlock(&tfile->tx_ring.producer_lock);
> > > > > +       spin_unlock(&tfile->pool_lock);
> > > >
> > > > More related to the general design: it looks wrong. What if
> > > > get_rx_bufs() will fail (ENOBUF) after successful peeking? With no
> > > > more incoming packets, later peek will return 0 and it looks like
> > > > that the half-processed packets will stay in the ring forever???
> > > >
> > > > I think the 'ring produce' part should be moved into tun_do_read().
> > >
> > > Currently, the vhost-net obtains a batch descriptors/sk_buffs from th=
e
> > > ptr_ring and enqueue the batch descriptors/sk_buffs to the
> > > virtqueue'queue, and then consumes the descriptors/sk_buffs from the
> > > virtqueue'queue in sequence. As a result, TUN does not know whether
> > > the batch descriptors have been used up, and thus does not know when =
to
> > return the batch descriptors.
> > >
> > > So, I think it's reasonable that when vhost-net checks ptr_ring is
> > > empty, it calls peek_len to get new xsk's descs and return the descri=
ptors.
> > >
> > > Thanks
> >
> > What you need to think about is that if you peek, another call in paral=
lel can get
> > the same value at the same time.
>
> Thank you. I have identified a problem. The tx_descs array was created wi=
thin xsk's pool.
> When xsk is freed, the pool and tx_descs are also freed. Howerver, some d=
escs may
> remain in the virtqueue'queue, which could lead to a use-after-free scena=
rio.

This can probably solving by when xsk pool is disabled, signal the
vhost_net to drop those descriptors.

Thanks

> Currently,
> I do not have an idea to solve this concurrency problem and believe this =
scenario may
> not be appropriate for reusing the ptr_ring.
>
> Thanks
>
> >
> >
> > > >
> > > > Cheers,
> > > >
> > > > Paolo
> > >
>


