Return-Path: <kvm+bounces-19679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82315908D9D
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:38:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 894B01C22369
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 14:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CED2F503;
	Fri, 14 Jun 2024 14:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PFNZ/OFj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E35DF55
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 14:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718375881; cv=none; b=D65XBggcZ7hFG10yAFDU4zoOWUGMHyR/X8A5Pf3I/5FApfVoKB/DHGR7Zoyn0EBz/86CVl4GVVvmHDNiH4mk3/my50JWN0q/u+0EYgSKo3Dfy4moPssCUFFYK3Q9W5bLrPkQ7ZFBWCsTdAzXZqgJAD0pM/ZYK/b3no69i6nTtEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718375881; c=relaxed/simple;
	bh=zRcSTM/jhvBjnbHtwwSwnO+RyKYuFmGLajopZybpesk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RKar7fNiXRxeg2IYukGyeO4+L/enGQQKOOZzaBc/MjbNL3bEj3dgQldEwzkoSDqO2HTCR06M+WIyaosGaud1hXKeWsmaiTNWRzueaZA1SjGybuWkbzD3YHBstDIekvbQ+zfRmZ9mehGTJrZbjcRn6pi/LfFdhXtHk7ZoQQJxBx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PFNZ/OFj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718375879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ma55eji0wwByhy1PlNAJaDlIbtX5hUNyQUsxW6m6B4Y=;
	b=PFNZ/OFjjYAsqyUIWHec3wI+XZtpsG1dvFicJNupAryZ340ZQ6ciY2F6XVhaEQy/0uiyeo
	OJN+JJVwIGNPEqIS/52h1rJ8Aw4Fc2Ll8P0gBN+xu8plgnYtsgCc8tB/jsXvlEXUw0rubO
	uKSHM6mEzJzJP97fLLqopKYB9z1BMUA=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-WGQPuN5WMoqBS4D5gg-0tQ-1; Fri, 14 Jun 2024 10:37:57 -0400
X-MC-Unique: WGQPuN5WMoqBS4D5gg-0tQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-52c82e67810so1755494e87.3
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 07:37:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718375875; x=1718980675;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ma55eji0wwByhy1PlNAJaDlIbtX5hUNyQUsxW6m6B4Y=;
        b=rFhfI1Vsapg49Rx0DUwhV58JPjHX458OKjF7q6jAERifehLPfm3K0Q7RJ5NzvEEReA
         QabSzUfSZYPqko6zYUqZjj+0oJw7AqW7MqTMy8kwWSYoBYCJByXFfv94Jh1RqtLfun8f
         m9LAZ8ZfXlPOp7gqVmQVjr0ZUNgx3+laoMTbFj2alXtXUDdGMpvAq0ymli5o5yfkzMrD
         KW9v8TcWJs/l/cGNCfQXR51VWsYg95pG/nUmR+XogRENy7gIvFgOBpeQaftvZcIODbSh
         A0gUudl9N0EFpcJs9kTotUEsDA2KL53ziWV43GeEXmSK2Ht6d9hzbV92W3QhN0UCjxeG
         LeEA==
X-Forwarded-Encrypted: i=1; AJvYcCW6xEzBsjeu2l/hODoUyDkm2Q/kPRfjgj9z/oJHpOfwCIpgx4dzwxVa++/mt2amKqnbruR4CnLRJPqQ7H66A2g9G//w
X-Gm-Message-State: AOJu0YyyA3encj2zFrC3pcMN7Y7f8fIle0HO5mBfRq4CwR0IIm2J3Ujo
	KqFGjrYT1F/fy29TrtNHDoawUt4ZVL8bwPco0jjayV7hzdMFQkDzLwbeVPmYlTlSOENWGsUJC5d
	V5tJ04sDgBreDA/FXR0aMlNPiZNFWoG9CX7OWCUblNTsUo/OIEg==
X-Received: by 2002:a05:6512:1386:b0:52c:823f:2a10 with SMTP id 2adb3069b0e04-52ca6e56edfmr2747332e87.1.1718375875240;
        Fri, 14 Jun 2024 07:37:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFak61X5Q4K8Fy3vqgh4FnlQ8USF63/URwCi1pVyOdl1kZeb7CjFn+k73mvZyYTw9AmJzOfKQ==
X-Received: by 2002:a05:6512:1386:b0:52c:823f:2a10 with SMTP id 2adb3069b0e04-52ca6e56edfmr2747312e87.1.1718375874854;
        Fri, 14 Jun 2024 07:37:54 -0700 (PDT)
Received: from sgarzare-redhat ([147.229.117.1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56da4486sm191157266b.1.2024.06.14.07.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 07:37:54 -0700 (PDT)
Date: Fri, 14 Jun 2024 16:37:51 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Luigi Leonardi <luigi.leonardi@outlook.com>
Cc: edumazet@google.com, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, kuba@kernel.org, kvm@vger.kernel.org, stefanha@redhat.com, 
	pabeni@redhat.com, davem@davemloft.net, Marco Pinna <marco.pinn95@gmail.com>
Subject: Re: [PATCH net-next 2/2] vsock/virtio: avoid enqueue packets when
 work queue is empty
Message-ID: <2ytwqkmnmp3ebdnhioevunpkyfe5nh2lcpitzggqeu4ptao7ry@ivxkicurl5ft>
References: <20240614135543.31515-1-luigi.leonardi@outlook.com>
 <AS2P194MB21706E349197C1466937052C9AC22@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AS2P194MB21706E349197C1466937052C9AC22@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>

On Fri, Jun 14, 2024 at 03:55:43PM GMT, Luigi Leonardi wrote:
>From: Marco Pinna <marco.pinn95@gmail.com>
>
>This introduces an optimization in virtio_transport_send_pkt:
>when the work queue (send_pkt_queue) is empty the packet is
>put directly in the virtqueue reducing latency.
>
>In the following benchmark (pingpong mode) the host sends
>a payload to the guest and waits for the same payload back.
>
>Tool: Fio version 3.37-56
>Env: Phys host + L1 Guest
>Payload: 4k
>Runtime-per-test: 50s
>Mode: pingpong (h-g-h)
>Test runs: 50
>Type: SOCK_STREAM
>
>Before (Linux 6.8.11)
>------
>mean(1st percentile):     722.45 ns
>mean(overall):           1686.23 ns
>mean(99th percentile):  35379.27 ns
>
>After
>------
>mean(1st percentile):     602.62 ns
>mean(overall):           1248.83 ns
>mean(99th percentile):  17557.33 ns

Cool, thanks for this improvement!
Can you also report your host CPU detail?

>
>Co-developed-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>Signed-off-by: Marco Pinna <marco.pinn95@gmail.com>
>---
> net/vmw_vsock/virtio_transport.c | 32 ++++++++++++++++++++++++++++++--
> 1 file changed, 30 insertions(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index c930235ecaec..e89bf87282b2 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -214,7 +214,9 @@ virtio_transport_send_pkt(struct sk_buff *skb)
> {
> 	struct virtio_vsock_hdr *hdr;
> 	struct virtio_vsock *vsock;
>+	bool use_worker = true;
> 	int len = skb->len;
>+	int ret = -1;

Please define ret in the block we use it. Also, we don't need to initialize it.

>
> 	hdr = virtio_vsock_hdr(skb);
>
>@@ -235,8 +237,34 @@ virtio_transport_send_pkt(struct sk_buff *skb)
> 	if (virtio_vsock_skb_reply(skb))
> 		atomic_inc(&vsock->queued_replies);
>
>-	virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
>-	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
>+	/* If the send_pkt_queue is empty there is no need to enqueue the packet.

We should clarify which queue. I mean we are always queueing the packet
somewhere, or in the internal queue for the worker or in the virtqueue,
so this comment is not really clear.

>+	 * Just put it on the ringbuff using virtio_transport_send_skb.

ringbuff? Do you mean virtqueue?

>+	 */
>+

we can avoid this empty line.

>+	if (skb_queue_empty_lockless(&vsock->send_pkt_queue)) {
>+		bool restart_rx = false;
>+		struct virtqueue *vq;

... `int ret;` here.

>+
>+		mutex_lock(&vsock->tx_lock);
>+
>+		vq = vsock->vqs[VSOCK_VQ_TX];
>+
>+		ret = virtio_transport_send_skb(skb, vq, vsock, &restart_rx);

Ah, at the end we don't need `ret` at all.

What about just `if (!virtio_transport_send_skb())`?

>+		if (ret == 0) {
>+			use_worker = false;
>+			virtqueue_kick(vq);
>+		}
>+
>+		mutex_unlock(&vsock->tx_lock);
>+
>+		if (restart_rx)
>+			queue_work(virtio_vsock_workqueue, &vsock->rx_work);
>+	}
>+
>+	if (use_worker) {
>+		virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
>+		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
>+	}
>
> out_rcu:
> 	rcu_read_unlock();
>-- 
>2.45.2
>


