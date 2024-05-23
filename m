Return-Path: <kvm+bounces-18030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B070F8CD090
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 12:44:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D405B1C2274D
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 10:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C65F14532F;
	Thu, 23 May 2024 10:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZrlmGANq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6301411F5
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 10:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716461069; cv=none; b=hn4GCekuO1zI+Nn5h6AEkvJQKG2R8wJXtDmjYXLYZ4VAJb4u+qQYdIf9FC4ea7ow0Ss9aUl3a9Up8SJv2iO7nKAJmspkIgagq64Lb1KuttkAKYiIiIWJLPdeWEqe6vPoV0JEKlT1Da5OpojIFSdIZuML64ijFJ+yubR5wgMZMd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716461069; c=relaxed/simple;
	bh=5hx2fSiT2DY4uOpmEnaz0dH8rVhtHW/XCwPNtgDvYrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pf9UvQ5Q9kRGTWtbia73bLqBtiBoVvRotkDvNvgIfcRI3zv68xp4rOHZlAOf2yoo5jiF668aV2Qd0C5SyX2aczz7jvU7Y36JCHIH4E0Jw8M1rGecEn1H14DBtO6+1JhwPQPP5LP1gPvYfv1hOM1L7xC1it3sIQ6r1MNqGwzjIro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZrlmGANq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716461067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+b8FaGjpy1m/+RszNBOW0Osd/3HyG6oUQQPlglChFwA=;
	b=ZrlmGANqUk02/p2DlxIAjjQkjsGLceI4MwBiV0opvzx00xQDl91hbefSiHd+edY92SBzLO
	hOt7Wm420QH6zOvVSu+ImmhZ4pu4/eiAP5Uwb2MUDVFmU0fkH3GA2DAvWpBd+KSYHBBuw2
	NO2GK+4mMxwPm3O/LSBqWjKz5gIvwv0=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-UR-9tBkUM06yHC3z70zXkA-1; Thu, 23 May 2024 06:44:25 -0400
X-MC-Unique: UR-9tBkUM06yHC3z70zXkA-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-80245e4043eso3709999241.2
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 03:44:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716461065; x=1717065865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+b8FaGjpy1m/+RszNBOW0Osd/3HyG6oUQQPlglChFwA=;
        b=KTTmq2HBGzSN8z92ClhyFzVcc2pVkh17o3hkVqE59SrZiNazF2W9z5bJfRI/FZLuJq
         MqdqjcZITeLn92NRN1oIMsoNNsjNs6eKn0qDHAb2oW8OHIKblxxK/CkmhcHv9OM5ez6x
         KSjtqLLoNpI7wHmW+sCOt7ykNPo3SQLkEUvoBr2TB7QYSzX98dk1188VlFBDmAUHCBla
         J+U6leim++foyh7Pjnbi8Y499A+LpgS4JFhT5Umw1+B9q8nDRCMpPQZVPqfk7RcVG9mv
         wDr0B8ALrM80FMu0D4JoJUPEsR5jawBe5u56/eyqjoqeveHxZPBtRNB1HsEvBIg7izw8
         UVng==
X-Forwarded-Encrypted: i=1; AJvYcCXp8aSE2VVy40Gqr/ToW4RKHCoBcdfl6GG3k8HJbJvtbgO64K/G9c/O3mhIHqKkhyagteUpdDKGZsIp2fQVKnSU7tn8
X-Gm-Message-State: AOJu0YxeXjR9vKgs4QMfdNbVfF/bmI7/K6nVgLgSaBV/4gVW5cs03PCX
	AhsXp1+I6FW47RfWMOiAHdQRXlkaj89uBm/h/bzFJRU+G31kSDjqlKedG/w2sqsFih8rbq4Z5i2
	LdLadMYq4kV6Bw9KrebilO41r1mxowZH9Fz4KZwjJGZBfCBPtAA==
X-Received: by 2002:a05:6102:6ce:b0:47e:ee4d:8431 with SMTP id ada2fe7eead31-48900956d84mr4979034137.3.1716461065124;
        Thu, 23 May 2024 03:44:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdYH7eg5e7F0lmFvh+zqemu/wAXsYnj8cJrd8nRmIqAi48RSdPDX0vAHPDdTcHVnbmyC6Ojw==
X-Received: by 2002:a05:6102:6ce:b0:47e:ee4d:8431 with SMTP id ada2fe7eead31-48900956d84mr4979019137.3.1716461064769;
        Thu, 23 May 2024 03:44:24 -0700 (PDT)
Received: from sgarzare-redhat (host-79-53-30-109.retail.telecomitalia.it. [79.53.30.109])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43f991bb19dsm25568231cf.63.2024.05.23.03.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 03:44:24 -0700 (PDT)
Date: Thu, 23 May 2024 12:44:20 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: stefanha@redhat.com, mst@redhat.com, davem@davemloft.net, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [RFC PATCH 3/5] vsock/virtio: can_msgzerocopy adapts to
 multi-devices
Message-ID: <dv6zyjbcl7zlkyzxc5q67zyq6sef6a5dz2nslb4ezscruhvi4d@pxjvo5t7zftk>
References: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>
 <20240517144607.2595798-4-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240517144607.2595798-4-niuxuewei.nxw@antgroup.com>

On Fri, May 17, 2024 at 10:46:05PM GMT, Xuewei Niu wrote:
>Adds a new argument, named "cid", to let them know which `virtio_vsock` to
>be selected.
>
>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>---
> include/linux/virtio_vsock.h            | 2 +-
> net/vmw_vsock/virtio_transport.c        | 5 ++---
> net/vmw_vsock/virtio_transport_common.c | 6 +++---
> 3 files changed, 6 insertions(+), 7 deletions(-)

Every commit in linux must be working to support bisection. So these 
changes should be made before adding multi-device support.

>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index c82089dee0c8..21bfd5e0c2e7 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -168,7 +168,7 @@ struct virtio_transport {
> 	 * extra checks and can perform zerocopy transmission by
> 	 * default.
> 	 */
>-	bool (*can_msgzerocopy)(int bufs_num);
>+	bool (*can_msgzerocopy)(u32 cid, int bufs_num);
> };
>
> ssize_t
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 93d25aeafb83..998b22e5ce36 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -521,14 +521,13 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
> 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
> }
>
>-static bool virtio_transport_can_msgzerocopy(int bufs_num)
>+static bool virtio_transport_can_msgzerocopy(u32 cid, int bufs_num)
> {
> 	struct virtio_vsock *vsock;
> 	bool res = false;
>
> 	rcu_read_lock();
>-
>-	vsock = rcu_dereference(the_virtio_vsock);
>+	vsock = virtio_transport_get_virtio_vsock(cid);
> 	if (vsock) {
> 		struct virtqueue *vq = vsock->vqs[VSOCK_VQ_TX];
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index bed75a41419e..e7315d7b9af1 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -39,7 +39,7 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
>
> static bool virtio_transport_can_zcopy(const struct virtio_transport *t_ops,
> 				       struct virtio_vsock_pkt_info *info,
>-				       size_t pkt_len)
>+				       size_t pkt_len, unsigned int cid)
> {
> 	struct iov_iter *iov_iter;
>
>@@ -62,7 +62,7 @@ static bool virtio_transport_can_zcopy(const struct virtio_transport *t_ops,
> 		int pages_to_send = iov_iter_npages(iov_iter, MAX_SKB_FRAGS);
>
> 		/* +1 is for packet header. */
>-		return t_ops->can_msgzerocopy(pages_to_send + 1);
>+		return t_ops->can_msgzerocopy(cid, pages_to_send + 1);
> 	}
>
> 	return true;
>@@ -375,7 +375,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 			info->msg->msg_flags &= ~MSG_ZEROCOPY;
>
> 		if (info->msg->msg_flags & MSG_ZEROCOPY)
>-			can_zcopy = virtio_transport_can_zcopy(t_ops, info, pkt_len);
>+			can_zcopy = virtio_transport_can_zcopy(t_ops, info, pkt_len, src_cid);
>
> 		if (can_zcopy)
> 			max_skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE,
>-- 
>2.34.1
>


