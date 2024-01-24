Return-Path: <kvm+bounces-6860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A792F83B1C3
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:05:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38C0E1F2A79E
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 19:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45205131E53;
	Wed, 24 Jan 2024 19:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kiTqqK62"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50797CF33;
	Wed, 24 Jan 2024 19:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706123119; cv=none; b=uHSPVKsLugQBn5YsmYF9hZrzZN8p9BU/we6m9W5e4DuSo7kdrFjcREJ0ur+y02qI7Uyl7BQSEyCmZ/EdeH4FDfcwbdu1sHW4i9TTc0m0/EqQ6ls20ttPRzvPbBbTyh2Qxaj/cESlFbXUEIf7jEJgIFndpTkuH0maaEbgvK7rP6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706123119; c=relaxed/simple;
	bh=v6YSFITKmvJ0+rJXpChjdmUNxpGNnGTTQjx/b4yO0FI=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=TTMf5JUPn7SMLGdlCse4I5yGWSPzk8Az9nCr74vSXoMwF2+e2oOc+/noe7zHpesHI+0kBbl8ceidUA+ycRUSFTcborvH8czDONm+xgC12UE8wz4HGw5FF4W/xfTGtAL4QRYaM3iRG41N6nJntDgS4a9HhI9ih7IN+O8iOo6g/Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kiTqqK62; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-78315243c11so375325185a.3;
        Wed, 24 Jan 2024 11:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706123116; x=1706727916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/B0a3zbMPF0CnohxRwvbz7D602GG4kXx873m0Wa6LMM=;
        b=kiTqqK62F74BuVkR+aGNaD+m0ynbyjESznLIvxA0bHvCgXyx14y4iTQy/XuBafBf9S
         Snmv1Fh5qNG0k442M/4j+H2Z0NoQHNvnxgCVZuuF5ptePDbslUijU1D9KzFzc959sP6P
         A01Gm28pvsnH7NqwkKlia0wo2l+ZCzDZrjJo4MZ2I8sAQCplxAXMwUil5e4XciRg7uEw
         bNO2uQ1cHaULmYxbfD1UYC7n8UfLkDPsosuWCT9/8dTbgIAGqgtHGrsPTGdb3p2PEvk7
         EMKcPzWt/pAgsjmLXpEmSlhcYX56OG9nw3SM5GMRwdNhtduVQLygA1CUn8xVgdRmNJ0X
         N4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706123116; x=1706727916;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/B0a3zbMPF0CnohxRwvbz7D602GG4kXx873m0Wa6LMM=;
        b=IW3X6YCqWbpOU/Gy5g7NVoslW3fn7Fy3JFHapXdo2VTDLk5C6CDJBOfoakimL+jfO5
         RuG9RfwXe2RsfpIIkrs24KxrqGn6j+JAS0M+zwBm+J5bh5AbI3wTYHr84RtvYQxhfxeW
         BlND0/0YIJCufMv6jZPYXMsmsjbBbsv+5SKuW+eA136dpHSGoTkOq2ESHty8/ZvLaqpZ
         tiF4fBJnYfbuwc7z3/7e5+GcUIz8KFCV47/uB7DfUAJUktf7L+H5madAf1zWUoonFSwx
         6RoJtjT+yQl6rPku9MgBGJ1Oh856wgz+v1imo9jITHcT6FSzk+Yx+G/jKsqaprVsJkai
         Qteg==
X-Gm-Message-State: AOJu0YzKJHX3IXBOOvns8v/fGaBuCy0hF5WhiYZznaf0t88ca1urzBoz
	IZ8cNcVeRxv5G5+FBPx0rnVwhb7kV9oBqJhgiJGLqkhhKHQr/7dI
X-Google-Smtp-Source: AGHT+IETxSQn7gX9g9/tI9Jc5LmlFsDB7D9ShiMj66QWY+FyNgPsac6XOuBMnHLkAiPklUOSjbc7bg==
X-Received: by 2002:ae9:f805:0:b0:783:80e6:1c00 with SMTP id x5-20020ae9f805000000b0078380e61c00mr8287668qkh.123.1706123116342;
        Wed, 24 Jan 2024 11:05:16 -0800 (PST)
Received: from localhost (131.65.194.35.bc.googleusercontent.com. [35.194.65.131])
        by smtp.gmail.com with ESMTPSA id r1-20020a05620a03c100b007815c45cdc5sm4291907qkm.95.2024.01.24.11.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 11:05:15 -0800 (PST)
Date: Wed, 24 Jan 2024 14:05:15 -0500
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Yunjian Wang <wangyunjian@huawei.com>, 
 mst@redhat.com, 
 willemdebruijn.kernel@gmail.com, 
 jasowang@redhat.com, 
 kuba@kernel.org, 
 davem@davemloft.net, 
 magnus.karlsson@intel.com
Cc: netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, 
 virtualization@lists.linux.dev, 
 xudingke@huawei.com, 
 Yunjian Wang <wangyunjian@huawei.com>
Message-ID: <65b15f6ba776f_22a8cb29487@willemb.c.googlers.com.notmuch>
In-Reply-To: <1706089075-16084-1-git-send-email-wangyunjian@huawei.com>
References: <1706089075-16084-1-git-send-email-wangyunjian@huawei.com>
Subject: Re: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy support
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Yunjian Wang wrote:
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
> 
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

I don't fully understand the higher level design of this feature yet.

But some initial comments at the code level.

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
>  	struct tun_struct *detached;
>  	struct ptr_ring tx_ring;
>  	struct xdp_rxq_info xdp_rxq;
> +	struct xdp_desc desc;
> +	/* protects xsk pool */
> +	spinlock_t pool_lock;
> +	struct xsk_buff_pool *pool;
>  };
>  
>  struct tun_page {
> @@ -208,6 +213,8 @@ struct tun_struct {
>  	struct bpf_prog __rcu *xdp_prog;
>  	struct tun_prog __rcu *steering_prog;
>  	struct tun_prog __rcu *filter_prog;
> +	/* tracks AF_XDP ZC enabled queues */
> +	unsigned long *af_xdp_zc_qps;
>  	struct ethtool_link_ksettings link_ksettings;
>  	/* init args */
>  	struct file *file;
> @@ -795,6 +802,8 @@ static int tun_attach(struct tun_struct *tun, struct file *file,
>  
>  	tfile->queue_index = tun->numqueues;
>  	tfile->socket.sk->sk_shutdown &= ~RCV_SHUTDOWN;
> +	tfile->desc.len = 0;
> +	tfile->pool = NULL;
>  
>  	if (tfile->detached) {
>  		/* Re-attach detached tfile, updating XDP queue_index */
> @@ -989,6 +998,13 @@ static int tun_net_init(struct net_device *dev)
>  		return err;
>  	}
>  
> +	tun->af_xdp_zc_qps = bitmap_zalloc(MAX_TAP_QUEUES, GFP_KERNEL);
> +	if (!tun->af_xdp_zc_qps) {
> +		security_tun_dev_free_security(tun->security);
> +		free_percpu(dev->tstats);
> +		return -ENOMEM;
> +	}
> +
>  	tun_flow_init(tun);
>  
>  	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
> @@ -1009,6 +1025,7 @@ static int tun_net_init(struct net_device *dev)
>  		tun_flow_uninit(tun);
>  		security_tun_dev_free_security(tun->security);
>  		free_percpu(dev->tstats);
> +		bitmap_free(tun->af_xdp_zc_qps);

Please release state in inverse order of acquire.

>  		return err;
>  	}
>  	return 0;
> @@ -1222,11 +1239,77 @@ static int tun_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>  	return 0;
>  }
>  
> +static int tun_xsk_pool_enable(struct net_device *netdev,
> +			       struct xsk_buff_pool *pool,
> +			       u16 qid)
> +{
> +	struct tun_struct *tun = netdev_priv(netdev);
> +	struct tun_file *tfile;
> +	unsigned long flags;
> +
> +	rcu_read_lock();
> +	tfile = rtnl_dereference(tun->tfiles[qid]);
> +	if (!tfile) {
> +		rcu_read_unlock();
> +		return -ENODEV;
> +	}

No need for rcu_read_lock with rtnl_dereference.

Consider ASSERT_RTNL() if unsure whether this patch could be reached
without the rtnl held.

> +
> +	spin_lock_irqsave(&tfile->pool_lock, flags);
> +	xsk_pool_set_rxq_info(pool, &tfile->xdp_rxq);
> +	tfile->pool = pool;
> +	spin_unlock_irqrestore(&tfile->pool_lock, flags);
> +
> +	rcu_read_unlock();
> +	set_bit(qid, tun->af_xdp_zc_qps);

What are the concurrency semantics: there's a spinlock to make
the update to xdp_rxq and pool a critical section, but the bitmap
is not part of this? Please also then document why the irqsave.

> +
> +	return 0;
> +}
> +
> +static int tun_xsk_pool_disable(struct net_device *netdev, u16 qid)
> +{
> +	struct tun_struct *tun = netdev_priv(netdev);
> +	struct tun_file *tfile;
> +	unsigned long flags;
> +
> +	if (!test_bit(qid, tun->af_xdp_zc_qps))
> +		return 0;
> +
> +	clear_bit(qid, tun->af_xdp_zc_qps);

Time of check to time of use race between test and clear? Or is
there no race because anything that clears will hold the RTNL? If so,
please add a comment.

> +
> +	rcu_read_lock();
> +	tfile = rtnl_dereference(tun->tfiles[qid]);
> +	if (!tfile) {
> +		rcu_read_unlock();
> +		return 0;
> +	}
> +
> +	spin_lock_irqsave(&tfile->pool_lock, flags);
> +	if (tfile->desc.len) {
> +		xsk_tx_completed(tfile->pool, 1);
> +		tfile->desc.len = 0;
> +	}
> +	tfile->pool = NULL;
> +	spin_unlock_irqrestore(&tfile->pool_lock, flags);
> +
> +	rcu_read_unlock();
> +	return 0;
> +}
> +
> +int tun_xsk_pool_setup(struct net_device *dev, struct xsk_buff_pool *pool,
> +		       u16 qid)
> +{
> +	return pool ? tun_xsk_pool_enable(dev, pool, qid) :
> +		tun_xsk_pool_disable(dev, qid);
> +}
> +
>  static int tun_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>  {
>  	switch (xdp->command) {
>  	case XDP_SETUP_PROG:
>  		return tun_xdp_set(dev, xdp->prog, xdp->extack);
> +	case XDP_SETUP_XSK_POOL:
> +		return tun_xsk_pool_setup(dev, xdp->xsk.pool,
> +					   xdp->xsk.queue_id);
>  	default:
>  		return -EINVAL;
>  	}
> @@ -1331,6 +1414,19 @@ static int tun_xdp_tx(struct net_device *dev, struct xdp_buff *xdp)
>  	return nxmit;
>  }
>  
> +static int tun_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
> +{
> +	struct tun_struct *tun = netdev_priv(dev);
> +	struct tun_file *tfile;
> +
> +	rcu_read_lock();
> +	tfile = rcu_dereference(tun->tfiles[qid]);
> +	if (tfile)
> +		__tun_xdp_flush_tfile(tfile);
> +	rcu_read_unlock();
> +	return 0;
> +}
> +
>  static const struct net_device_ops tap_netdev_ops = {
>  	.ndo_init		= tun_net_init,
>  	.ndo_uninit		= tun_net_uninit,
> @@ -1347,6 +1443,7 @@ static const struct net_device_ops tap_netdev_ops = {
>  	.ndo_get_stats64	= dev_get_tstats64,
>  	.ndo_bpf		= tun_xdp,
>  	.ndo_xdp_xmit		= tun_xdp_xmit,
> +	.ndo_xsk_wakeup		= tun_xsk_wakeup,
>  	.ndo_change_carrier	= tun_net_change_carrier,
>  };
>  
> @@ -1404,7 +1501,8 @@ static void tun_net_initialize(struct net_device *dev)
>  		/* Currently tun does not support XDP, only tap does. */
>  		dev->xdp_features = NETDEV_XDP_ACT_BASIC |
>  				    NETDEV_XDP_ACT_REDIRECT |
> -				    NETDEV_XDP_ACT_NDO_XMIT;
> +				    NETDEV_XDP_ACT_NDO_XMIT |
> +				    NETDEV_XDP_ACT_XSK_ZEROCOPY;
>  
>  		break;
>  	}
> @@ -2213,6 +2311,37 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>  	return ptr;
>  }
>  
> +static ssize_t tun_put_user_desc(struct tun_struct *tun,
> +				 struct tun_file *tfile,
> +				 struct xdp_desc *desc,
> +				 struct iov_iter *iter)
> +{
> +	size_t size = desc->len;
> +	int vnet_hdr_sz = 0;
> +	size_t ret;
> +
> +	if (tun->flags & IFF_VNET_HDR) {
> +		struct virtio_net_hdr_mrg_rxbuf gso = { 0 };
> +
> +		vnet_hdr_sz = READ_ONCE(tun->vnet_hdr_sz);
> +		if (unlikely(iov_iter_count(iter) < vnet_hdr_sz))
> +			return -EINVAL;
> +		if (unlikely(copy_to_iter(&gso, sizeof(gso), iter) !=
> +			     sizeof(gso)))
> +			return -EFAULT;
> +		iov_iter_advance(iter, vnet_hdr_sz - sizeof(gso));
> +	}
> +
> +	ret = copy_to_iter(xsk_buff_raw_get_data(tfile->pool, desc->addr),
> +			   size, iter) + vnet_hdr_sz;
> +
> +	preempt_disable();
> +	dev_sw_netstats_tx_add(tun->dev, 1, ret);
> +	preempt_enable();
> +
> +	return ret;
> +}
> +

This is almost a copy of tun_put_user_xdp. Can we refactor to avoid
duplicating code (here and elsewhere this may apply).

>  static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
>  			   struct iov_iter *to,
>  			   int noblock, void *ptr)
> @@ -2226,6 +2355,22 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
>  	}
>  
>  	if (!ptr) {
> +		/* Read frames from xsk's desc */
> +		if (test_bit(tfile->queue_index, tun->af_xdp_zc_qps)) {
> +			spin_lock(&tfile->pool_lock);
> +			if (tfile->pool) {
> +				ret = tun_put_user_desc(tun, tfile, &tfile->desc, to);
> +				xsk_tx_completed(tfile->pool, 1);
> +				if (xsk_uses_need_wakeup(tfile->pool))
> +					xsk_set_tx_need_wakeup(tfile->pool);

For the xsk maintainers if they're reading along: this two line
pattern is seen quite often. Deserves a helper in a header file?

> +				tfile->desc.len = 0;
> +			} else {
> +				ret = -EBADFD;
> +			}
> +			spin_unlock(&tfile->pool_lock);
> +			return ret;
> +		}
> +
>  		/* Read frames from ring */
>  		ptr = tun_ring_recv(tfile, noblock, &err);
>  		if (!ptr)
> @@ -2311,6 +2456,7 @@ static void tun_free_netdev(struct net_device *dev)
>  
>  	BUG_ON(!(list_empty(&tun->disabled)));
>  
> +	bitmap_free(tun->af_xdp_zc_qps);
>  	free_percpu(dev->tstats);
>  	tun_flow_uninit(tun);
>  	security_tun_dev_free_security(tun->security);
> @@ -2666,7 +2812,19 @@ static int tun_peek_len(struct socket *sock)
>  	if (!tun)
>  		return 0;
>  
> -	ret = PTR_RING_PEEK_CALL(&tfile->tx_ring, tun_ptr_peek_len);
> +	if (test_bit(tfile->queue_index, tun->af_xdp_zc_qps)) {
> +		spin_lock(&tfile->pool_lock);
> +		if (tfile->pool && xsk_tx_peek_desc(tfile->pool, &tfile->desc)) {
> +			xsk_tx_release(tfile->pool);
> +			ret = tfile->desc.len;
> +			/* The length of desc must be greater than 0 */
> +			if (!ret)
> +				xsk_tx_completed(tfile->pool, 1);

Peek semantics usually don't result in releasing the buffer. Am I
misunderstanding this operation?
> +		}
> +		spin_unlock(&tfile->pool_lock);
> +	} else {
> +		ret = PTR_RING_PEEK_CALL(&tfile->tx_ring, tun_ptr_peek_len);
> +	}
>  	tun_put(tun);
>  
>  	return ret;
> @@ -3469,8 +3627,11 @@ static int tun_chr_open(struct inode *inode, struct file * file)
>  
>  	mutex_init(&tfile->napi_mutex);
>  	RCU_INIT_POINTER(tfile->tun, NULL);
> +	spin_lock_init(&tfile->pool_lock);
>  	tfile->flags = 0;
>  	tfile->ifindex = 0;
> +	tfile->pool = NULL;
> +	tfile->desc.len = 0;
>  
>  	init_waitqueue_head(&tfile->socket.wq.wait);
>  
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index f2ed7167c848..a1f143ad2341 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c

For virtio maintainer: is it okay to have tun and vhost/net changes in
the same patch, or is it better to split them?

> @@ -169,9 +169,10 @@ static int vhost_net_buf_is_empty(struct vhost_net_buf *rxq)
>  
>  static void *vhost_net_buf_consume(struct vhost_net_buf *rxq)
>  {
> -	void *ret = vhost_net_buf_get_ptr(rxq);
> -	++rxq->head;
> -	return ret;
> +	if (rxq->tail == rxq->head)
> +		return NULL;
> +
> +	return rxq->queue[rxq->head++];

Why this change?

>  }
>  
>  static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq)
> @@ -993,12 +994,19 @@ static void handle_tx(struct vhost_net *net)
>  
>  static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *sk)
>  {
> +	struct socket *sock = sk->sk_socket;
>  	struct sk_buff *head;
>  	int len = 0;
>  	unsigned long flags;
>  
> -	if (rvq->rx_ring)
> -		return vhost_net_buf_peek(rvq);
> +	if (rvq->rx_ring) {
> +		len = vhost_net_buf_peek(rvq);
> +		if (likely(len))
> +			return len;
> +	}
> +
> +	if (sock->ops->peek_len)
> +		return sock->ops->peek_len(sock);
>  
>  	spin_lock_irqsave(&sk->sk_receive_queue.lock, flags);
>  	head = skb_peek(&sk->sk_receive_queue);
> -- 
> 2.33.0
> 



