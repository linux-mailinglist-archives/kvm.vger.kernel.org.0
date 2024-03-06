Return-Path: <kvm+bounces-11094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA9B872C94
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 03:12:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD3921F213A2
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 02:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E433DDA6;
	Wed,  6 Mar 2024 02:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZaCdnw+R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41B717FE
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 02:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709691136; cv=none; b=IrMJzv+Ce84tZX+vp7OUbngn5vdTKil/eotCOPNBe3V7WDf8gqluXxwapDfSc4TjcK2BYVOiFfRk2S9+uvEjnohEeilyzz5dFYGYZgIwWE9tIdUJAv+yZu/MfS1Tgj3UpEfEIuqyoMYDtt7KWRx48NpAYsMeeEbMKf1+HK58RNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709691136; c=relaxed/simple;
	bh=GlmCKD+xlQJlfcx2lNeOwkFvc6sYU8wmBbQJeeN5+yw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IeQj+6Wgq2W+I36anjFTgVu2yvPh0x2eAxzK9VZ4xldGQ8pAJVhx3nuegNTA4tBPzonIdctNiKM7yDEIjgKKcTOtGgQcuqwmvrPewgM5MHvVbLDKlkL0lqGnfXvFnqQ6kgC7VrJ3kqgw2zVxNCWlYGd8EaeUsyJyjCWww5hGlMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZaCdnw+R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709691133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9sbZgd4q8MukS3NmUkwfErLL+fIzH7IaTlMNRuUTYw8=;
	b=ZaCdnw+RpZOKhaeWxhhUwstLYC4M8hygp1ooCQKA8ZBxl/E0t+MzKqH05sI6Lq2QuKZd4S
	UzSSUMgfCUyVuulkk2+YHiIom0nJVOBP+O28Mu/iywKVR1F9spG+8XYFqiSyuYLI5WYTzt
	iwJQ2e2DH+iRWhpfwrU4WHntuurQ6vU=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-s53yD9vOO6yQhLULaW3BEA-1; Tue, 05 Mar 2024 21:12:12 -0500
X-MC-Unique: s53yD9vOO6yQhLULaW3BEA-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6e04e1ac036so7150525b3a.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 18:12:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709691131; x=1710295931;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9sbZgd4q8MukS3NmUkwfErLL+fIzH7IaTlMNRuUTYw8=;
        b=JPb24hAAhp03njXGfwoT8lvCOP+tVd2/k8XA+M792H2DtWQMo5X2KwoqTpsBoe7hWU
         iO7ymIoWTS5E6PT4yKEEfC1g5OYUfx88JQOQUvT4qmUThnik3//K+2a646hAnXObBFQu
         LB0BQs4DxVO4/ew25aRyyRQZBjG8mX0bZQcMwfMUQrsfPr1A81tQd+gzJhSN3yOXgDeb
         cIn9ucjse0gRhL6RSeJ1SNn65Gt6kSdTrYdPfReYN3ulvj1WSDlWQZt27Fc2OQT6FTMN
         BYTTxHRtMRN5+tkjqCpcOKu9LV2m8HhV+Zvl1GjaEKRWpzJsYxzj8B00D32GecQ4Da56
         ZzxA==
X-Forwarded-Encrypted: i=1; AJvYcCV8+Z0QjUDT+1PvacPHIU/vqlTZIbiKHeysBONhQyMkHtcA9GzDRfMnCbKTFGae8rMn/1/ssW19A5c7NfPE+nyhKi0Q
X-Gm-Message-State: AOJu0Yygt1Nnwc8hSiDzxGmKGg7kxdLxLULueTPfw5X2M4Iqgldu14Rd
	XMEf4bfL7DItADxrx0Ol5oaQPYnJALUY3yO5B2EalSP1moyyKDZjcYv4dg+ZS9hFEEVQgy27KQ3
	NTujOaauNnzWsZtI50Tvg89RDZRPtHylHAMTI8yq2Op6a/lMOkfWJ8wF3hsOYk/tzuGaii1l135
	hZqG+e4b+JE8qwkIM0+AXEBDHg
X-Received: by 2002:a05:6a00:2da8:b0:6e3:caa7:3038 with SMTP id fb40-20020a056a002da800b006e3caa73038mr17578688pfb.0.1709691131222;
        Tue, 05 Mar 2024 18:12:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGl4PZPuFJ0olqInVg+AqysYzbnQ+rrxJBkjbXjsp25TBKsiiNedWHv7gUSdkMnZxnspiomxPm60AAem+z7c8w=
X-Received: by 2002:a05:6a00:2da8:b0:6e3:caa7:3038 with SMTP id
 fb40-20020a056a002da800b006e3caa73038mr17578657pfb.0.1709691130621; Tue, 05
 Mar 2024 18:12:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1709118356-133960-1-git-send-email-wangyunjian@huawei.com>
 <CACGkMEv+=k+RvbN2kWp85f9NWPYOPQtqkThdjvOrf5mWonBqvw@mail.gmail.com> <b263a27344ec4566b7b70e3165d3d918@huawei.com>
In-Reply-To: <b263a27344ec4566b7b70e3165d3d918@huawei.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 6 Mar 2024 10:11:59 +0800
Message-ID: <CACGkMEud8Q7fOn85GHGB0D7vcaTQihMYYhSaL=uGh=g1WHZ=HA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
To: wangyunjian <wangyunjian@huawei.com>
Cc: "mst@redhat.com" <mst@redhat.com>, 
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

On Mon, Mar 4, 2024 at 7:24=E2=80=AFPM wangyunjian <wangyunjian@huawei.com>=
 wrote:
>
>
>
> > -----Original Message-----
> > From: Jason Wang [mailto:jasowang@redhat.com]
> > Sent: Monday, March 4, 2024 2:56 PM
> > To: wangyunjian <wangyunjian@huawei.com>
> > Cc: mst@redhat.com; willemdebruijn.kernel@gmail.com; kuba@kernel.org;
> > bjorn@kernel.org; magnus.karlsson@intel.com; maciej.fijalkowski@intel.c=
om;
> > jonathan.lemon@gmail.com; davem@davemloft.net; bpf@vger.kernel.org;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.o=
rg;
> > virtualization@lists.linux.dev; xudingke <xudingke@huawei.com>; liwei (=
DT)
> > <liwei395@huawei.com>
> > Subject: Re: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
> >
> > On Wed, Feb 28, 2024 at 7:06=E2=80=AFPM Yunjian Wang <wangyunjian@huawe=
i.com>
> > wrote:
> > >
> > > This patch set allows TUN to support the AF_XDP Tx zero-copy feature,
> > > which can significantly reduce CPU utilization for XDP programs.
> > >
> > > Since commit fc72d1d54dd9 ("tuntap: XDP transmission"), the pointer
> > > ring has been utilized to queue different types of pointers by
> > > encoding the type into the lower bits. Therefore, we introduce a new
> > > flag, TUN_XDP_DESC_FLAG(0x2UL), which allows us to enqueue XDP
> > > descriptors and differentiate them from XDP buffers and sk_buffs.
> > > Additionally, a spin lock is added for enabling and disabling operati=
ons on the
> > xsk pool.
> > >
> > > The performance testing was performed on a Intel E5-2620 2.40GHz
> > machine.
> > > Traffic were generated/send through TUN(testpmd txonly with AF_XDP) t=
o
> > > VM (testpmd rxonly in guest).
> > >
> > > +------+---------+---------+---------+
> > > |      |   copy  |zero-copy| speedup |
> > > +------+---------+---------+---------+
> > > | UDP  |   Mpps  |   Mpps  |    %    |
> > > | 64   |   2.5   |   4.0   |   60%   |
> > > | 512  |   2.1   |   3.6   |   71%   |
> > > | 1024 |   1.9   |   3.3   |   73%   |
> > > +------+---------+---------+---------+
> > >
> > > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> > > ---
> > >  drivers/net/tun.c      | 177
> > +++++++++++++++++++++++++++++++++++++++--
> > >  drivers/vhost/net.c    |   4 +
> > >  include/linux/if_tun.h |  32 ++++++++
> > >  3 files changed, 208 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/net/tun.c b/drivers/net/tun.c index
> > > bc80fc1d576e..7f4ff50b532c 100644
> > > --- a/drivers/net/tun.c
> > > +++ b/drivers/net/tun.c
> > > @@ -63,6 +63,7 @@
> > >  #include <net/rtnetlink.h>
> > >  #include <net/sock.h>
> > >  #include <net/xdp.h>
> > > +#include <net/xdp_sock_drv.h>
> > >  #include <net/ip_tunnels.h>
> > >  #include <linux/seq_file.h>
> > >  #include <linux/uio.h>
> > > @@ -86,6 +87,7 @@ static void tun_default_link_ksettings(struct
> > net_device *dev,
> > >                                        struct
> > ethtool_link_ksettings
> > > *cmd);
> > >
> > >  #define TUN_RX_PAD (NET_IP_ALIGN + NET_SKB_PAD)
> > > +#define TUN_XDP_BATCH 64
> > >
> > >  /* TUN device flags */
> > >
> > > @@ -146,6 +148,9 @@ struct tun_file {
> > >         struct tun_struct *detached;
> > >         struct ptr_ring tx_ring;
> > >         struct xdp_rxq_info xdp_rxq;
> > > +       struct xsk_buff_pool *xsk_pool;
> > > +       spinlock_t pool_lock;   /* Protects xsk pool enable/disable *=
/
> > > +       u32 nb_descs;
> > >  };
> > >
> > >  struct tun_page {
> > > @@ -614,6 +619,8 @@ void tun_ptr_free(void *ptr)
> > >                 struct xdp_frame *xdpf =3D tun_ptr_to_xdp(ptr);
> > >
> > >                 xdp_return_frame(xdpf);
> > > +       } else if (tun_is_xdp_desc_frame(ptr)) {
> > > +               return;
> > >         } else {
> > >                 __skb_array_destroy_skb(ptr);
> > >         }
> > > @@ -631,6 +638,37 @@ static void tun_queue_purge(struct tun_file *tfi=
le)
> > >         skb_queue_purge(&tfile->sk.sk_error_queue);
> > >  }
> > >
> > > +static void tun_set_xsk_pool(struct tun_file *tfile, struct
> > > +xsk_buff_pool *pool) {
> > > +       if (!pool)
> > > +               return;
> > > +
> > > +       spin_lock(&tfile->pool_lock);
> > > +       xsk_pool_set_rxq_info(pool, &tfile->xdp_rxq);
> > > +       tfile->xsk_pool =3D pool;
> > > +       spin_unlock(&tfile->pool_lock); }
> > > +
> > > +static void tun_clean_xsk_pool(struct tun_file *tfile) {
> > > +       spin_lock(&tfile->pool_lock);
> > > +       if (tfile->xsk_pool) {
> > > +               void *ptr;
> > > +
> > > +               while ((ptr =3D ptr_ring_consume(&tfile->tx_ring)) !=
=3D NULL)
> > > +                       tun_ptr_free(ptr);
> > > +
> > > +               if (tfile->nb_descs) {
> > > +                       xsk_tx_completed(tfile->xsk_pool,
> > tfile->nb_descs);
> > > +                       if (xsk_uses_need_wakeup(tfile->xsk_pool))
> > > +
> > xsk_set_tx_need_wakeup(tfile->xsk_pool);
> > > +                       tfile->nb_descs =3D 0;
> > > +               }
> > > +               tfile->xsk_pool =3D NULL;
> > > +       }
> > > +       spin_unlock(&tfile->pool_lock); }
> > > +
> > >  static void __tun_detach(struct tun_file *tfile, bool clean)  {
> > >         struct tun_file *ntfile;
> > > @@ -648,6 +686,11 @@ static void __tun_detach(struct tun_file *tfile,=
 bool
> > clean)
> > >                 u16 index =3D tfile->queue_index;
> > >                 BUG_ON(index >=3D tun->numqueues);
> > >
> > > +               ntfile =3D rtnl_dereference(tun->tfiles[tun->numqueue=
s -
> > 1]);
> > > +               /* Stop xsk zc xmit */
> > > +               tun_clean_xsk_pool(tfile);
> > > +               tun_clean_xsk_pool(ntfile);
> > > +
> > >                 rcu_assign_pointer(tun->tfiles[index],
> > >                                    tun->tfiles[tun->numqueues - 1]);
> > >                 ntfile =3D rtnl_dereference(tun->tfiles[index]);
> > > @@ -668,6 +711,7 @@ static void __tun_detach(struct tun_file *tfile, =
bool
> > clean)
> > >                 tun_flow_delete_by_queue(tun, tun->numqueues + 1);
> > >                 /* Drop read queue */
> > >                 tun_queue_purge(tfile);
> > > +               tun_set_xsk_pool(ntfile,
> > > + xsk_get_pool_from_qid(tun->dev, index));
> > >                 tun_set_real_num_queues(tun);
> > >         } else if (tfile->detached && clean) {
> > >                 tun =3D tun_enable_queue(tfile); @@ -801,6 +845,7 @@
> > > static int tun_attach(struct tun_struct *tun, struct file *file,
> > >
> > >                 if (tfile->xdp_rxq.queue_index    !=3D tfile->queue_i=
ndex)
> > >                         tfile->xdp_rxq.queue_index =3D
> > > tfile->queue_index;
> > > +               tun_set_xsk_pool(tfile, xsk_get_pool_from_qid(dev,
> > > + tfile->queue_index));
> > >         } else {
> > >                 /* Setup XDP RX-queue info, for new tfile getting
> > attached */
> > >                 err =3D xdp_rxq_info_reg(&tfile->xdp_rxq, @@ -1221,11
> > > +1266,50 @@ static int tun_xdp_set(struct net_device *dev, struct bpf=
_prog
> > *prog,
> > >         return 0;
> > >  }
> > >
> > > +static int tun_xsk_pool_enable(struct net_device *netdev,
> > > +                              struct xsk_buff_pool *pool,
> > > +                              u16 qid) {
> > > +       struct tun_struct *tun =3D netdev_priv(netdev);
> > > +       struct tun_file *tfile;
> > > +
> > > +       if (qid >=3D tun->numqueues)
> > > +               return -EINVAL;
> > > +
> > > +       tfile =3D rtnl_dereference(tun->tfiles[qid]);
> > > +       tun_set_xsk_pool(tfile, pool);
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static int tun_xsk_pool_disable(struct net_device *netdev, u16 qid) =
{
> > > +       struct tun_struct *tun =3D netdev_priv(netdev);
> > > +       struct tun_file *tfile;
> > > +
> > > +       if (qid >=3D MAX_TAP_QUEUES)
> > > +               return -EINVAL;
> > > +
> > > +       tfile =3D rtnl_dereference(tun->tfiles[qid]);
> > > +       if (tfile)
> > > +               tun_clean_xsk_pool(tfile);
> > > +       return 0;
> > > +}
> > > +
> > > +static int tun_xsk_pool_setup(struct net_device *dev, struct xsk_buf=
f_pool
> > *pool,
> > > +                             u16 qid) {
> > > +       return pool ? tun_xsk_pool_enable(dev, pool, qid) :
> > > +               tun_xsk_pool_disable(dev, qid); }
> > > +
> > >  static int tun_xdp(struct net_device *dev, struct netdev_bpf *xdp)  =
{
> > >         switch (xdp->command) {
> > >         case XDP_SETUP_PROG:
> > >                 return tun_xdp_set(dev, xdp->prog, xdp->extack);
> > > +       case XDP_SETUP_XSK_POOL:
> > > +               return tun_xsk_pool_setup(dev, xdp->xsk.pool,
> > > + xdp->xsk.queue_id);
> > >         default:
> > >                 return -EINVAL;
> > >         }
> > > @@ -1330,6 +1414,19 @@ static int tun_xdp_tx(struct net_device *dev,
> > struct xdp_buff *xdp)
> > >         return nxmit;
> > >  }
> > >
> > > +static int tun_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags=
)
> > > +{
> > > +       struct tun_struct *tun =3D netdev_priv(dev);
> > > +       struct tun_file *tfile;
> > > +
> > > +       rcu_read_lock();
> > > +       tfile =3D rcu_dereference(tun->tfiles[qid]);
> > > +       if (tfile)
> > > +               __tun_xdp_flush_tfile(tfile);
> > > +       rcu_read_unlock();
> > > +       return 0;
> > > +}
> >
> > I may miss something but why not simply queue xdp frames into ptr ring =
then
> > we don't need tricks for peek?
>
> The current implementation is implemented with reference to other NIC's d=
rivers
> (ixgbe, ice, dpaa2, mlx5), which use XDP descriptors directly.

Well, they all do the same thing which is translate XDP descriptors to
the vendor specific descriptor format.

For TUN, the ptr_ring is the "vendor specific" format.

> Converting XDP
> descriptors to XDP frames does not seem to be very beneficial.

Get rid of the trick for peek like what is done in this patch?

Thanks

>
> Thanks
> >
> > Thanks
>


