Return-Path: <kvm+bounces-31086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB15D9C020D
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 11:15:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4304AB219E2
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 934B21EC00A;
	Thu,  7 Nov 2024 10:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i5Qgcbv9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E21198825
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 10:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730974538; cv=none; b=SFprdKKTIrrbUVZQuOxatSm+mwVca77KpBT+jo7IV7RI3snTf1jgjJUeOv0WzcYUsg6jM+s5QWZvwuKpisnDhRMnt0oO8FvBqLxqn19Qr78iYl+ivH403i0FnKVf4ijVsY9wp76jJqYiFHGflCZaZAf3/Wx6TWyDHSNc1vGqOys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730974538; c=relaxed/simple;
	bh=x7ik3dUZ4qfgretMWTs0q2SwyKs1yvwePHnw90ALGms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UXYzoipBzXiDpkfV1KyW/XZf3V/lkQezZ4LAWg76sbFrSRzOwFN2q19gTL1vXSFHIcN+mLYhXsBN0MNUnpwUdPTWZcY3FSSnt7TJGCDcJZKuNGBggeImHHYV9RrcHGd8v8KO/dAiBVJEb0gTIX3IDxbruwOJMuKNxPnKTdhKAbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i5Qgcbv9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730974535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qic0KprwlmFJxdJGsLKtec/+hybwkWidV6RrLX35zxs=;
	b=i5Qgcbv9KDsBthzFIXSjE2DL7u8wbWXdcAsXtewuKQEAqIekfnkEom2cNjX9tBIZI2iZOk
	Y+o5DWq4WqjhIBPyHGThJtpeP7AwDRfznfpTE1x7n8vdR55xPDdvG+4FhfSl/ce76m0ILo
	pMzJl33FeA5YRVeDvi/mjQvysQM3X9U=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-J_DaeWMuN1OUiKiAfRurmw-1; Thu, 07 Nov 2024 05:15:33 -0500
X-MC-Unique: J_DaeWMuN1OUiKiAfRurmw-1
X-Mimecast-MFC-AGG-ID: J_DaeWMuN1OUiKiAfRurmw
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6cbee7a9e7dso9916836d6.0
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 02:15:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730974533; x=1731579333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qic0KprwlmFJxdJGsLKtec/+hybwkWidV6RrLX35zxs=;
        b=MpyyttC1n70wCtTlBqM5xOk7E1FKgcbLPUKIAIQtDk4E9nUfW6hFMWsXMP7EwOiKvH
         FdMITg39AJSNRzZW/bDIU6C8wQVg5tWThgyOxAQK+JzQgWm0YkkrTliq9zP3wiIZLoAT
         O11TADQHSqfYbt/zhYcS3AGDy0N+rGeIeiK/oYFEAc7bDVLX/Hqs+hwt/Mrl1KJmpYum
         ckAlzPgiTQUPwNiXDQ06vrVEbDrtFfSu4wzXbCTiZIpL8Fd9h17Xf94FOlv1uRdngpwu
         SmRydyo9yrQDugjwaNoO6w8BwxdzxWnFy8qp9OSE4ey0P1HQ3izh2J1qO2lqslI7SV3g
         99gA==
X-Forwarded-Encrypted: i=1; AJvYcCXO6fS/xMVgiH5rYlTqq3EFBtK1sh7KLUY10tVjWRAi28XP02eIHlYMo6/JKXqY3UAAWhw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQe6OPT9rvZRyVUHwPtE84JAy4es0jUlL0s227hjEMNHI6y3Gt
	Xb8B7aysJ7OTE0k7lxd96C0NjlIbWeJioWoLdoyRMO5qwAXkMM1//7/8QcJnQYeZ+ozi2Lb5Ygr
	6W1WB1w79gdFdrqx/ukzAK2flwksweTC4V5NG5IHVfPJJIoglPg==
X-Received: by 2002:a05:6214:3f8d:b0:6cd:3a49:34e8 with SMTP id 6a1803df08f44-6d39a525c00mr7104786d6.20.1730974533189;
        Thu, 07 Nov 2024 02:15:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHFQWBdcj0fFKhWjLh9ILVMNEnmMAKMSoYgq0CTrZlBpSg2wx5nk5hVOaqP6XnuB6b/bKS9cQ==
X-Received: by 2002:a05:6214:3f8d:b0:6cd:3a49:34e8 with SMTP id 6a1803df08f44-6d39a525c00mr7104366d6.20.1730974532720;
        Thu, 07 Nov 2024 02:15:32 -0800 (PST)
Received: from sgarzare-redhat ([5.77.70.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d3961df223sm5932806d6.5.2024.11.07.02.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 02:15:32 -0800 (PST)
Date: Thu, 7 Nov 2024 11:15:20 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jia He <justin.he@arm.com>, Arseniy Krasnov <avkrasnov@salutedevices.com>, 
	Dmitry Torokhov <dtor@vmware.com>, Andy King <acking@vmware.com>, 
	George Zhang <georgezhang@vmware.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org
Subject: Re: [PATCH net 1/4] virtio/vsock: Fix accept_queue memory leak
Message-ID: <dcboxomaif7b3qt3ofls4wvnobclv3onb32ynnq5uchzqoz6kg@5htm6qcbvmpg>
References: <20241106-vsock-mem-leaks-v1-0-8f4ffc3099e6@rbox.co>
 <20241106-vsock-mem-leaks-v1-1-8f4ffc3099e6@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20241106-vsock-mem-leaks-v1-1-8f4ffc3099e6@rbox.co>

On Wed, Nov 06, 2024 at 06:51:18PM +0100, Michal Luczaj wrote:
>As the final stages of socket destruction may be delayed, it is possible
>that virtio_transport_recv_listen() will be called after the accept_queue
>has been flushed, but before the SOCK_DONE flag has been set. As a result,
>sockets enqueued after the flush would remain unremoved, leading to a
>memory leak.
>
>vsock_release
>  __vsock_release
>    lock
>    virtio_transport_release
>      virtio_transport_close
>        schedule_delayed_work(close_work)
>    sk_shutdown = SHUTDOWN_MASK
>(!) flush accept_queue
>    release
>                                        virtio_transport_recv_pkt
>                                          vsock_find_bound_socket
>                                          lock
>                                          if flag(SOCK_DONE) return
>                                          virtio_transport_recv_listen
>                                            child = vsock_create_connected
>                                      (!)   vsock_enqueue_accept(child)
>                                          release
>close_work
>  lock
>  virtio_transport_do_close
>    set_flag(SOCK_DONE)
>    virtio_transport_remove_sock
>      vsock_remove_sock
>        vsock_remove_bound
>  release
>
>Introduce a sk_shutdown check to disallow vsock_enqueue_accept() during
>socket destruction.
>
>unreferenced object 0xffff888109e3f800 (size 2040):
>  comm "kworker/5:2", pid 371, jiffies 4294940105
>  hex dump (first 32 bytes):
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    28 00 0b 40 00 00 00 00 00 00 00 00 00 00 00 00  (..@............
>  backtrace (crc 9e5f4e84):
>    [<ffffffff81418ff1>] kmem_cache_alloc_noprof+0x2c1/0x360
>    [<ffffffff81d27aa0>] sk_prot_alloc+0x30/0x120
>    [<ffffffff81d2b54c>] sk_alloc+0x2c/0x4b0
>    [<ffffffff81fe049a>] __vsock_create.constprop.0+0x2a/0x310
>    [<ffffffff81fe6d6c>] virtio_transport_recv_pkt+0x4dc/0x9a0
>    [<ffffffff81fe745d>] vsock_loopback_work+0xfd/0x140
>    [<ffffffff810fc6ac>] process_one_work+0x20c/0x570
>    [<ffffffff810fce3f>] worker_thread+0x1bf/0x3a0
>    [<ffffffff811070dd>] kthread+0xdd/0x110
>    [<ffffffff81044fdd>] ret_from_fork+0x2d/0x50
>    [<ffffffff8100785a>] ret_from_fork_asm+0x1a/0x30
>
>Fixes: 3fe356d58efa ("vsock/virtio: discard packets only when socket is really closed")
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> net/vmw_vsock/virtio_transport_common.c | 8 ++++++++
> 1 file changed, 8 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index ccbd2bc0d2109aea4f19e79a0438f85893e1d89c..cd075f608d4f6f48f894543e5e9c966d3e5f22df 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1512,6 +1512,14 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
> 		return -ENOMEM;
> 	}
>
>+	/* __vsock_release() might have already flushed accept_queue.
>+	 * Subsequent enqueues would lead to a memory leak.
>+	 */
>+	if (sk->sk_shutdown == SHUTDOWN_MASK) {
>+		virtio_transport_reset_no_sock(t, skb);
>+		return -ESHUTDOWN;
>+	}
>+
> 	child = vsock_create_connected(sk);
> 	if (!child) {
> 		virtio_transport_reset_no_sock(t, skb);
>
>-- 
>2.46.2
>


