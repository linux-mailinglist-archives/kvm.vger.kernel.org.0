Return-Path: <kvm+bounces-62214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7687BC3C72B
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:33:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 71B75505AE1
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC1F7350281;
	Thu,  6 Nov 2025 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AiALqfbe";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iKsVSt5N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9F034FF54
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 16:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445860; cv=none; b=X4bCHBEyEavmg3nxe0i4Pp1by6e2gqo8fCa47xfm6IUsTlXS8x0G8NNzX5jjicy0AMrn6bwJFfuMNJgDJgecXbMnMkdhj24ueE34JrIZrAvYW9d60UGjzQrojk6yfXCjwm1ow+ApNpfeK6xtZkbXHyl4DhXjRRZ1fre5rlvgO34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445860; c=relaxed/simple;
	bh=GtjRPF6DweArbtHMO2aemgxvXl0n5TLyq2tqJNlhivM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cz74pE4z9KDu49T9xOV26C+QvRKsbsGb8No9UbPS1p/AATQqnH1oYsbHVc2dXbcrlbWTpEB+zEzgDYBcvfhKSxQ0sKTunVpDCJCQDbIOvsPJe3lGKvEnaDjsn79ezK1leRN/cyFltM9pAJnOdYLm1FxZpPkRDBvLLjFXDO4+FJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AiALqfbe; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iKsVSt5N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762445857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HE8pWaDjxM5gntEvWaYK9FfKJ/5DWKgS7aJeLXUwhc8=;
	b=AiALqfbejqRfbUcqzlhxIVz+vSbPYPqCinjwVeBQwOIqWRWHU8Rla8mUdPf8gJ9IYa1zFs
	2dBJPKhB6OX+N92GUNni6OeVGofp1gFDwqlzc3224WqTuny19VLiMEpR905HAwAYOu5JOs
	yAUKFdaVs5W5BTN3ownOazFu2RoN02A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-xAsE13VqOVuMO871rkuVvg-1; Thu, 06 Nov 2025 11:17:35 -0500
X-MC-Unique: xAsE13VqOVuMO871rkuVvg-1
X-Mimecast-MFC-AGG-ID: xAsE13VqOVuMO871rkuVvg_1762445854
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e39567579so5888625e9.0
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 08:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762445854; x=1763050654; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HE8pWaDjxM5gntEvWaYK9FfKJ/5DWKgS7aJeLXUwhc8=;
        b=iKsVSt5Npxh8mfVnPOCQP/U7IHNG73lzYNn5N4BKAHCbGQmx7nrWVsQ6UF3EJ0xQMb
         7SOdi24OrFPjfVgAaH8kcMdVFCoybqVrZ6feGpBiWYFYFeb+ZSeGSwFeblXBxwa1lSQ+
         7KBlTHkdsUqZqBT0tHk+vcVltBbulxH9SGqLCml5Y4FSFRRfbxaFCgothSO8PnPRniq5
         RnuwtTah23BxLYiDLHJu0Zw+0/axKNPJtjkUETBRJ1qhhglw6WQ4QBf4FFEoKdPlsWZg
         J/sFKu1GmtVmJIlg7OmKM0KeuArcPxgrTRh+HU0I2J9/tWqj/vTBzt5Le3bnhfMtc7Rr
         9tFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762445854; x=1763050654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HE8pWaDjxM5gntEvWaYK9FfKJ/5DWKgS7aJeLXUwhc8=;
        b=oe3RUUP2YZCrkds+nx3id2Fof6JpcRPYmsGrNZWYsg56qWhidINHIV9O261whC7u56
         WDGFT1EIo7tN1r53p36RIpWaFOP7SsmrfTtSyukdS/SQjLvZ5ExhC57w9G3E2ImFOhSt
         SzZvwqBuZUgNkx/npRTc+dLN4BhsTOwc/+PH+CtXgHNevk8EtZX5+787yr373dTX7lP2
         TDIpwOKo5l9msiuARm0XAf38vuXVLnTGrNyJ0HBZDwkI8HI5eDBiYESJ/msHzsVdVjUk
         YL2WeHWsvcGTK7RB+i5qVb8G/OnpG0Eyh5vDaulyDBv4ecU4dTKKzFy1os7aFzlyCPoC
         qIIg==
X-Forwarded-Encrypted: i=1; AJvYcCW6/FkffND/P3wL+LSBEXNbNdmCi2x2RMIPYoH5MoHW0mje8bvge3ieI4fhq7tNMTEpFWI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBL5kiWMfSf38Lv+Nlut1HTp3GoGiclXMn1JBt2iUQ8JFHFHe6
	IobriY+9RxWeSty9YFyWH/oePCyXWVdueRW8aN87j4uCwD3XIeZbv9UuQC63odcj+JOdUSdYPlG
	qjaolbBo6h/A5Q+SryUzUn866N8DSVgfzmjRz9yhO6Yxe+2HYCPhSwA==
X-Gm-Gg: ASbGncvPP0PIUZ5jkHuoVsXnqm4rczu/wU9y/kJUfuwFTokhxFUGJzGqxhxyo+vx8TU
	zveMBzTCn6E5+zmt1JGZisXLl3l5+h1kMex6yPU05Rjz5pNenMY8HuMhIWniDaqe3PSzJkvmYUW
	fY4d8yLQ8Oe8AzX8EG84C6PO9NihOhy1LrgIz55i11457k8FWinmYV2775aEQfkLT9YZ0V9nO3Q
	ftH8y+HUj6SrEoV85fYcAcb5yCGpYyw520+xN7Z/i9+9IRwd8TpeV15O4ZCP6cFTfSvdIxp6bCD
	B6GpC4v6KY8+l+dGGi6ZHZDTUMHycLHSZ023fr8MaLtFpBmj4Zutjb5hUoT+luT5EX7hQrrXEaG
	1SA==
X-Received: by 2002:a05:600c:4ed4:b0:477:63a4:8419 with SMTP id 5b1f17b1804b1-47763a48438mr23006265e9.12.1762445854310;
        Thu, 06 Nov 2025 08:17:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHIyTOWs4nIR7QeOKb8n83iy6iz/GaHMuA92Bwhg2oq7+DwP0ugN/AgSAqGuvWOvF3ICA0YJw==
X-Received: by 2002:a05:600c:4ed4:b0:477:63a4:8419 with SMTP id 5b1f17b1804b1-47763a48438mr23005835e9.12.1762445853789;
        Thu, 06 Nov 2025 08:17:33 -0800 (PST)
Received: from sgarzare-redhat ([78.209.9.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477640fba3esm20572515e9.6.2025.11.06.08.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:17:32 -0800 (PST)
Date: Thu, 6 Nov 2025 17:17:27 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, berrange@redhat.com, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v8 03/14] vsock: add netns to vsock skb cb
Message-ID: <q5w5y5qomj54k2tzztsy4pz2h2zqkvgfzkysjiv3uguoufrqy7@tfz7dj6cssxf>
References: <20251023-vsock-vmtest-v8-0-dea984d02bb0@meta.com>
 <20251023-vsock-vmtest-v8-3-dea984d02bb0@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251023-vsock-vmtest-v8-3-dea984d02bb0@meta.com>

On Thu, Oct 23, 2025 at 11:27:42AM -0700, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add a net pointer and net_mode to the vsock skb and helpers for
>getting/setting them. When skbs are received the transport needs a way
>to tell the vsock layer and/or virtio common layer which namespace and
>what namespace mode the packet belongs to. This will be used by those
>upper layers for finding the correct socket object. This patch stashes
>these fields in the skb control buffer.
>
>This extends virtio_vsock_skb_cb to 24 bytes:
>
>struct virtio_vsock_skb_cb {
>	struct net *               net;                  /*     0     8 */
>	enum vsock_net_mode        net_mode;        /*     8     4 */
>	u32                        offset;               /*    12     4 */
>	bool                       reply;                /*    16     1 */
>	bool                       tap_delivered;        /*    17     1 */
>
>	/* size: 24, cachelines: 1, members: 5 */
>	/* padding: 6 */
>	/* last cacheline: 24 bytes */
>};
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
>Changes in v7:
>- rename `orig_net_mode` to `net_mode`
>- update commit message with a more complete explanation of changes
>
>Changes in v5:
>- some diff context change due to rebase to current net-next
>---
> include/linux/virtio_vsock.h | 23 +++++++++++++++++++++++
> 1 file changed, 23 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 87cf4dcac78a..7f334a32133c 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -10,6 +10,8 @@
> #define VIRTIO_VSOCK_SKB_HEADROOM (sizeof(struct virtio_vsock_hdr))
>
> struct virtio_vsock_skb_cb {
>+	struct net *net;
>+	enum vsock_net_mode net_mode;
> 	u32 offset;
> 	bool reply;
> 	bool tap_delivered;
>@@ -130,6 +132,27 @@ static inline size_t virtio_vsock_skb_len(struct sk_buff *skb)
> 	return (size_t)(skb_end_pointer(skb) - skb->head);
> }
>
>+static inline struct net *virtio_vsock_skb_net(struct sk_buff *skb)
>+{
>+	return VIRTIO_VSOCK_SKB_CB(skb)->net;
>+}
>+
>+static inline void virtio_vsock_skb_set_net(struct sk_buff *skb, struct net *net)
>+{
>+	VIRTIO_VSOCK_SKB_CB(skb)->net = net;
>+}
>+
>+static inline enum vsock_net_mode virtio_vsock_skb_net_mode(struct sk_buff *skb)
>+{
>+	return VIRTIO_VSOCK_SKB_CB(skb)->net_mode;
>+}
>+
>+static inline void virtio_vsock_skb_set_net_mode(struct sk_buff *skb,
>+						      enum vsock_net_mode net_mode)
>+{
>+	VIRTIO_VSOCK_SKB_CB(skb)->net_mode = net_mode;
>+}
>+
> /* Dimension the RX SKB so that the entire thing fits exactly into
>  * a single 4KiB page. This avoids wasting memory due to alloc_skb()
>  * rounding up to the next page order and also means that we
>
>-- 
>2.47.3
>


