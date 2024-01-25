Return-Path: <kvm+bounces-6971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7092083B8C3
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 05:49:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE23E1F24811
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643E78831;
	Thu, 25 Jan 2024 04:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eV7QK4TR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50CB79C7
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 04:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706158136; cv=none; b=ioN7ScqrEdEYBKLQSAeHGINN81nfEsrDyoK69vQB9F9jZKwTDM5sKvwKSrytnl3tV8Y2kK9V/OMzEvdOd440toC11BJFi0JyIYasKa0Xc8xW423tH+RADsRU3AITPgabJHhHOTGM7ZOzI5qJmeO7A7ffJK6kc+3h4MYwbgcJ0LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706158136; c=relaxed/simple;
	bh=6DdzQ2E9OeQMD4Ll7S27cDySmDqNA/T9HcWDxZD1J/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ykbnpf1xBP7VNYk+sxZakBDHzJXHFX1XDZF33ka3G7vjdjsg49HQFSPATDvP+ryOVbcxsxh2u6RhJK9ufA8R2nul3yZWDL0M23F3S3yCGNUQJ3ZthzvCwTUofnc8OV1YPHtceQgiMzRIsWNVJeDllhg8xg/fZnj7yBeFA/0oa+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eV7QK4TR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706158133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5DnZRXqjQvdY1jAfdan5L6v5dW2MXXnZETrlS+Qv9f4=;
	b=eV7QK4TRVWuynFxTEz4I0ND3zGBKGiXdSlN9dI8fIMqszPhs5piQIWqVHcuV0u/Xis7btH
	LldPe0G/XlDQH92W5cpkJ3vTlxrQKZU/3ek9M51eB7Mg+E2D62zgZwSiFXINpr7MWVDGK0
	N8hcUDbCc/FSeLJ56J9OPb0koNWR4L4=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-wdXl3rL9OM25oL1afcmGpA-1; Wed, 24 Jan 2024 23:48:51 -0500
X-MC-Unique: wdXl3rL9OM25oL1afcmGpA-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-5993598d215so5839051eaf.1
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 20:48:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706158130; x=1706762930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5DnZRXqjQvdY1jAfdan5L6v5dW2MXXnZETrlS+Qv9f4=;
        b=v8k8+xWo0TWee1noAz4nftb7nUJKBtx2C+Fm5SwfVTwLxf7aDDLOnDMHR9VSG45WR2
         yLgSbAg4Ka2QRH8qOdeBWrzNMHGEyJDTLkRwmlow2C75WFDDsN9D/7i4BsD/FmYGoYGP
         ksxO0VBDjWSfSn4T6XBK3Lqtk+sSaoqNhGPHL05jD4PHThuyCAM5uBl9joGWRLm1tzzj
         Zri4/Wmpy/k8R5z5lnpwzghK7UVsV47lDMEnhvBxg5gaWmA9bp5CU28lUk0hwu3k9cdx
         DpTuxHCSBqM2XETok7Ho5OuoawoSFwsqjVICOuDr0/V7L8+kL7cajMlzjEX25a4anB0j
         a0lg==
X-Gm-Message-State: AOJu0Yw5RSzPNKKhOxmPI0sjjZGLqQhoHZ8vrVAQ+HDGXAfe0bq9EZi0
	o4ez6DgivEsgVHBygtYFAnw8Z2itaBP1k5c1iJ+A77bNcPKISYq7BIxt9q2PUJRqsZT2xATfBJx
	5JvlzQ7AZ2hYHyhpPjdBoqUL3FB5UG/UbqYqPNrC8ITXceW5EtsawNbEJyjTdBWv1t8Y0hzXyrh
	hbyrhvJ6e1TUEIZnnG9JHWd35W
X-Received: by 2002:a05:6358:880a:b0:176:7d13:d70e with SMTP id hv10-20020a056358880a00b001767d13d70emr611993rwb.16.1706158130345;
        Wed, 24 Jan 2024 20:48:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFddJIzi0ITLTVUmZVAdoejjTy2B/LClBNQ5q3+0akCp/DD67U3ZDcor5HcvQgQAKcj2DPfjkq9KQFUSYNFNKM=
X-Received: by 2002:a05:6358:880a:b0:176:7d13:d70e with SMTP id
 hv10-20020a056358880a00b001767d13d70emr611981rwb.16.1706158129995; Wed, 24
 Jan 2024 20:48:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1706089075-16084-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1706089075-16084-1-git-send-email-wangyunjian@huawei.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 25 Jan 2024 12:48:38 +0800
Message-ID: <CACGkMEu5PaBgh37X4KysoF9YB8qy6jM5W4G6sm+8fjrnK36KXA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy support
To: Yunjian Wang <wangyunjian@huawei.com>
Cc: mst@redhat.com, willemdebruijn.kernel@gmail.com, kuba@kernel.org, 
	davem@davemloft.net, magnus.karlsson@intel.com, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, xudingke@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2024 at 5:38=E2=80=AFPM Yunjian Wang <wangyunjian@huawei.co=
m> wrote:
>
> Now the zero-copy feature of AF_XDP socket is supported by some
> drivers, which can reduce CPU utilization on the xdp program.
> This patch set allows tun to support AF_XDP Rx zero-copy feature.
>
> This patch tries to address this by:
> - Use peek_len to consume a xsk->desc and get xsk->desc length.
> - When the tun support AF_XDP Rx zero-copy, the vq's array maybe empty.
> So add a check for empty vq's array in vhost_net_buf_produce().
> - add XDP_SETUP_XSK_POOL and ndo_xsk_wakeup callback support
> - add tun_put_user_desc function to copy the Rx data to VM

Code explains themselves, let's explain why you need to do this.

1) why you want to use peek_len
2) for "vq's array", what does it mean?
3) from the view of TUN/TAP tun_put_user_desc() is the TX path, so I
guess you meant TX zerocopy instead of RX (as I don't see codes for
RX?)

A big question is how could you handle GSO packets from userspace/guests?

>
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>  drivers/net/tun.c   | 165 +++++++++++++++++++++++++++++++++++++++++++-
>  drivers/vhost/net.c |  18 +++--
>  2 files changed, 176 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index afa5497f7c35..248b0f8e07d1 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -77,6 +77,7 @@
>  #include <net/ax25.h>
>  #include <net/rose.h>
>  #include <net/6lowpan.h>
> +#include <net/xdp_sock_drv.h>
>
>  #include <linux/uaccess.h>
>  #include <linux/proc_fs.h>
> @@ -145,6 +146,10 @@ struct tun_file {
>         struct tun_struct *detached;
>         struct ptr_ring tx_ring;
>         struct xdp_rxq_info xdp_rxq;
> +       struct xdp_desc desc;
> +       /* protects xsk pool */
> +       spinlock_t pool_lock;
> +       struct xsk_buff_pool *pool;
>  };
>
>  struct tun_page {
> @@ -208,6 +213,8 @@ struct tun_struct {
>         struct bpf_prog __rcu *xdp_prog;
>         struct tun_prog __rcu *steering_prog;
>         struct tun_prog __rcu *filter_prog;
> +       /* tracks AF_XDP ZC enabled queues */
> +       unsigned long *af_xdp_zc_qps;
>         struct ethtool_link_ksettings link_ksettings;
>         /* init args */
>         struct file *file;
> @@ -795,6 +802,8 @@ static int tun_attach(struct tun_struct *tun, struct =
file *file,
>
>         tfile->queue_index =3D tun->numqueues;
>         tfile->socket.sk->sk_shutdown &=3D ~RCV_SHUTDOWN;
> +       tfile->desc.len =3D 0;
> +       tfile->pool =3D NULL;
>
>         if (tfile->detached) {
>                 /* Re-attach detached tfile, updating XDP queue_index */
> @@ -989,6 +998,13 @@ static int tun_net_init(struct net_device *dev)
>                 return err;
>         }
>
> +       tun->af_xdp_zc_qps =3D bitmap_zalloc(MAX_TAP_QUEUES, GFP_KERNEL);
> +       if (!tun->af_xdp_zc_qps) {
> +               security_tun_dev_free_security(tun->security);
> +               free_percpu(dev->tstats);
> +               return -ENOMEM;
> +       }
> +
>         tun_flow_init(tun);
>
>         dev->hw_features =3D NETIF_F_SG | NETIF_F_FRAGLIST |
> @@ -1009,6 +1025,7 @@ static int tun_net_init(struct net_device *dev)
>                 tun_flow_uninit(tun);
>                 security_tun_dev_free_security(tun->security);
>                 free_percpu(dev->tstats);
> +               bitmap_free(tun->af_xdp_zc_qps);
>                 return err;
>         }
>         return 0;
> @@ -1222,11 +1239,77 @@ static int tun_xdp_set(struct net_device *dev, st=
ruct bpf_prog *prog,
>         return 0;
>  }
>
> +static int tun_xsk_pool_enable(struct net_device *netdev,
> +                              struct xsk_buff_pool *pool,
> +                              u16 qid)
> +{
> +       struct tun_struct *tun =3D netdev_priv(netdev);
> +       struct tun_file *tfile;
> +       unsigned long flags;
> +
> +       rcu_read_lock();
> +       tfile =3D rtnl_dereference(tun->tfiles[qid]);
> +       if (!tfile) {
> +               rcu_read_unlock();
> +               return -ENODEV;
> +       }
> +
> +       spin_lock_irqsave(&tfile->pool_lock, flags);
> +       xsk_pool_set_rxq_info(pool, &tfile->xdp_rxq);
> +       tfile->pool =3D pool;
> +       spin_unlock_irqrestore(&tfile->pool_lock, flags);
> +
> +       rcu_read_unlock();
> +       set_bit(qid, tun->af_xdp_zc_qps);
> +
> +       return 0;
> +}
> +
> +static int tun_xsk_pool_disable(struct net_device *netdev, u16 qid)
> +{
> +       struct tun_struct *tun =3D netdev_priv(netdev);
> +       struct tun_file *tfile;
> +       unsigned long flags;
> +
> +       if (!test_bit(qid, tun->af_xdp_zc_qps))
> +               return 0;
> +
> +       clear_bit(qid, tun->af_xdp_zc_qps);
> +
> +       rcu_read_lock();
> +       tfile =3D rtnl_dereference(tun->tfiles[qid]);
> +       if (!tfile) {
> +               rcu_read_unlock();
> +               return 0;
> +       }
> +
> +       spin_lock_irqsave(&tfile->pool_lock, flags);
> +       if (tfile->desc.len) {
> +               xsk_tx_completed(tfile->pool, 1);
> +               tfile->desc.len =3D 0;
> +       }
> +       tfile->pool =3D NULL;
> +       spin_unlock_irqrestore(&tfile->pool_lock, flags);
> +
> +       rcu_read_unlock();
> +       return 0;
> +}
> +
> +int tun_xsk_pool_setup(struct net_device *dev, struct xsk_buff_pool *poo=
l,
> +                      u16 qid)
> +{
> +       return pool ? tun_xsk_pool_enable(dev, pool, qid) :
> +               tun_xsk_pool_disable(dev, qid);
> +}
> +
>  static int tun_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>  {
>         switch (xdp->command) {
>         case XDP_SETUP_PROG:
>                 return tun_xdp_set(dev, xdp->prog, xdp->extack);
> +       case XDP_SETUP_XSK_POOL:
> +               return tun_xsk_pool_setup(dev, xdp->xsk.pool,
> +                                          xdp->xsk.queue_id);
>         default:
>                 return -EINVAL;
>         }
> @@ -1331,6 +1414,19 @@ static int tun_xdp_tx(struct net_device *dev, stru=
ct xdp_buff *xdp)
>         return nxmit;
>  }
>
> +static int tun_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
> +{
> +       struct tun_struct *tun =3D netdev_priv(dev);
> +       struct tun_file *tfile;
> +
> +       rcu_read_lock();
> +       tfile =3D rcu_dereference(tun->tfiles[qid]);
> +       if (tfile)
> +               __tun_xdp_flush_tfile(tfile);
> +       rcu_read_unlock();
> +       return 0;
> +}
> +
>  static const struct net_device_ops tap_netdev_ops =3D {
>         .ndo_init               =3D tun_net_init,
>         .ndo_uninit             =3D tun_net_uninit,
> @@ -1347,6 +1443,7 @@ static const struct net_device_ops tap_netdev_ops =
=3D {
>         .ndo_get_stats64        =3D dev_get_tstats64,
>         .ndo_bpf                =3D tun_xdp,
>         .ndo_xdp_xmit           =3D tun_xdp_xmit,
> +       .ndo_xsk_wakeup         =3D tun_xsk_wakeup,
>         .ndo_change_carrier     =3D tun_net_change_carrier,
>  };
>
> @@ -1404,7 +1501,8 @@ static void tun_net_initialize(struct net_device *d=
ev)
>                 /* Currently tun does not support XDP, only tap does. */
>                 dev->xdp_features =3D NETDEV_XDP_ACT_BASIC |
>                                     NETDEV_XDP_ACT_REDIRECT |
> -                                   NETDEV_XDP_ACT_NDO_XMIT;
> +                                   NETDEV_XDP_ACT_NDO_XMIT |
> +                                   NETDEV_XDP_ACT_XSK_ZEROCOPY;
>
>                 break;
>         }
> @@ -2213,6 +2311,37 @@ static void *tun_ring_recv(struct tun_file *tfile,=
 int noblock, int *err)
>         return ptr;
>  }
>
> +static ssize_t tun_put_user_desc(struct tun_struct *tun,
> +                                struct tun_file *tfile,
> +                                struct xdp_desc *desc,
> +                                struct iov_iter *iter)
> +{
> +       size_t size =3D desc->len;
> +       int vnet_hdr_sz =3D 0;
> +       size_t ret;
> +
> +       if (tun->flags & IFF_VNET_HDR) {
> +               struct virtio_net_hdr_mrg_rxbuf gso =3D { 0 };
> +
> +               vnet_hdr_sz =3D READ_ONCE(tun->vnet_hdr_sz);
> +               if (unlikely(iov_iter_count(iter) < vnet_hdr_sz))
> +                       return -EINVAL;
> +               if (unlikely(copy_to_iter(&gso, sizeof(gso), iter) !=3D
> +                            sizeof(gso)))
> +                       return -EFAULT;
> +               iov_iter_advance(iter, vnet_hdr_sz - sizeof(gso));
> +       }
> +
> +       ret =3D copy_to_iter(xsk_buff_raw_get_data(tfile->pool, desc->add=
r),
> +                          size, iter) + vnet_hdr_sz;
> +
> +       preempt_disable();
> +       dev_sw_netstats_tx_add(tun->dev, 1, ret);
> +       preempt_enable();
> +
> +       return ret;
> +}
> +
>  static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfil=
e,
>                            struct iov_iter *to,
>                            int noblock, void *ptr)
> @@ -2226,6 +2355,22 @@ static ssize_t tun_do_read(struct tun_struct *tun,=
 struct tun_file *tfile,
>         }
>
>         if (!ptr) {
> +               /* Read frames from xsk's desc */
> +               if (test_bit(tfile->queue_index, tun->af_xdp_zc_qps)) {
> +                       spin_lock(&tfile->pool_lock);
> +                       if (tfile->pool) {
> +                               ret =3D tun_put_user_desc(tun, tfile, &tf=
ile->desc, to);
> +                               xsk_tx_completed(tfile->pool, 1);
> +                               if (xsk_uses_need_wakeup(tfile->pool))
> +                                       xsk_set_tx_need_wakeup(tfile->poo=
l);
> +                               tfile->desc.len =3D 0;
> +                       } else {
> +                               ret =3D -EBADFD;
> +                       }
> +                       spin_unlock(&tfile->pool_lock);
> +                       return ret;
> +               }
> +
>                 /* Read frames from ring */
>                 ptr =3D tun_ring_recv(tfile, noblock, &err);
>                 if (!ptr)
> @@ -2311,6 +2456,7 @@ static void tun_free_netdev(struct net_device *dev)
>
>         BUG_ON(!(list_empty(&tun->disabled)));
>
> +       bitmap_free(tun->af_xdp_zc_qps);
>         free_percpu(dev->tstats);
>         tun_flow_uninit(tun);
>         security_tun_dev_free_security(tun->security);
> @@ -2666,7 +2812,19 @@ static int tun_peek_len(struct socket *sock)
>         if (!tun)
>                 return 0;
>
> -       ret =3D PTR_RING_PEEK_CALL(&tfile->tx_ring, tun_ptr_peek_len);
> +       if (test_bit(tfile->queue_index, tun->af_xdp_zc_qps)) {
> +               spin_lock(&tfile->pool_lock);
> +               if (tfile->pool && xsk_tx_peek_desc(tfile->pool, &tfile->=
desc)) {

Does it mean if userspace doesn't peek, we can't read anything?

We need to make sure syscall read works as well as vhost_net.

> +                       xsk_tx_release(tfile->pool);
> +                       ret =3D tfile->desc.len;
> +                       /* The length of desc must be greater than 0 */
> +                       if (!ret)
> +                               xsk_tx_completed(tfile->pool, 1);
> +               }
> +               spin_unlock(&tfile->pool_lock);
> +       } else {
> +               ret =3D PTR_RING_PEEK_CALL(&tfile->tx_ring, tun_ptr_peek_=
len);
> +       }
>         tun_put(tun);
>
>         return ret;
> @@ -3469,8 +3627,11 @@ static int tun_chr_open(struct inode *inode, struc=
t file * file)
>
>         mutex_init(&tfile->napi_mutex);
>         RCU_INIT_POINTER(tfile->tun, NULL);
> +       spin_lock_init(&tfile->pool_lock);
>         tfile->flags =3D 0;
>         tfile->ifindex =3D 0;
> +       tfile->pool =3D NULL;
> +       tfile->desc.len =3D 0;
>
>         init_waitqueue_head(&tfile->socket.wq.wait);
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index f2ed7167c848..a1f143ad2341 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -169,9 +169,10 @@ static int vhost_net_buf_is_empty(struct vhost_net_b=
uf *rxq)
>
>  static void *vhost_net_buf_consume(struct vhost_net_buf *rxq)
>  {
> -       void *ret =3D vhost_net_buf_get_ptr(rxq);
> -       ++rxq->head;
> -       return ret;
> +       if (rxq->tail =3D=3D rxq->head)
> +               return NULL;
> +
> +       return rxq->queue[rxq->head++];
>  }
>
>  static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq)
> @@ -993,12 +994,19 @@ static void handle_tx(struct vhost_net *net)
>
>  static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *s=
k)
>  {
> +       struct socket *sock =3D sk->sk_socket;
>         struct sk_buff *head;
>         int len =3D 0;
>         unsigned long flags;
>
> -       if (rvq->rx_ring)
> -               return vhost_net_buf_peek(rvq);
> +       if (rvq->rx_ring) {
> +               len =3D vhost_net_buf_peek(rvq);
> +               if (likely(len))
> +                       return len;
> +       }
> +
> +       if (sock->ops->peek_len)
> +               return sock->ops->peek_len(sock);

What prevents you from reusing the ptr_ring here? Then you don't need
the above tricks.

Thanks


>
>         spin_lock_irqsave(&sk->sk_receive_queue.lock, flags);
>         head =3D skb_peek(&sk->sk_receive_queue);
> --
> 2.33.0
>


