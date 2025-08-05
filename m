Return-Path: <kvm+bounces-53965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02678B1AF08
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 09:01:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A287B3AD45D
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 07:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E9622D4C0;
	Tue,  5 Aug 2025 07:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="em3MNbut"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674691EB5E3
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 07:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754377265; cv=none; b=TFKE0oG8Tyn1m2CsB8s45kecHhN0ynvX9pw2Tm8mq+H6c+HHYP/OD7Ix6PxwNqK2xH6hfOAN6nt+CaDyq0Vst/qix/D+zGMlB04nOTUnjkQ0f5TjDC+FOWtkZzU0EYG5Udljunc4zKmKyolCB8rGLUrdr8MoGH3yMr/3FfOaduM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754377265; c=relaxed/simple;
	bh=ygCeSeAh0m+wHTDyfFMhYQdNXoKy++DrVVWSwBZlVqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MjvUI7a//DU2uDz6I0M5bU+i5G5z5bH1ttlbXBkGeyytEQUn1NX5id4BR60cqvgJ2Dt/099sc85oG48Fj2KOfHHV2rOXgR/K6en8/523B2Zf+UCoPhXmowfTWsMkxx0ez6t2+kX0RerwZyKXzLlZYGlhr8VvFaQAiD21NYcKixE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=em3MNbut; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754377262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dSIbGepWdDgc96njCuHhSUJPUf+KzluXS7gRDoPBvAM=;
	b=em3MNbutoTNo2BAB8nE22QYAhUJu62kIfUkskfAvxFKKlwX/U+3SaWZALTdTw+bJFlIvYD
	CAwknnc7fUOUj/0X9jjUZSArob3MDnqiV6LkhCUt4tDne+sqfkMsDH1rthxAaktwZxGe+O
	FkduSuHiovqFi38YMx5gylNrr+suaWQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-234gEC7qMZKulhuK4O2lMA-1; Tue, 05 Aug 2025 03:01:01 -0400
X-MC-Unique: 234gEC7qMZKulhuK4O2lMA-1
X-Mimecast-MFC-AGG-ID: 234gEC7qMZKulhuK4O2lMA_1754377260
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c5bb68b386so1227371085a.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 00:01:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754377260; x=1754982060;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dSIbGepWdDgc96njCuHhSUJPUf+KzluXS7gRDoPBvAM=;
        b=aj7QdbudKqIh7qjCLR/u7cXcgFGNmKSZ9Ytz1+u/epri/KdbidKZIsifYNi7ZazAnA
         jdAKdOHNFFDDnJYovjdj5fcKH+LJLYHfTNXJoQ8in3bw3R3K7wIFtuxROUG5Lttw3Dyn
         BpVX+EAB9HT+osDwDtVxfAy1MG5UkgreLMlzFWx2L3DzOefNzmvgg345a7BOxVFm8W1g
         2q/7Q9uxTTxWFPRjuYn/jY0MGg0O/RtEZuXWER2wmYSZvUbSYy7OdLIWakwYyOcIkTbr
         eltUo9V1gzAimum65FSshQGirJABdRSY2M/qMSuxCeBhPF4Vmlg62XKHBY8iJQ6eq6aM
         bdjA==
X-Forwarded-Encrypted: i=1; AJvYcCU0XA89yjTdRiAwV/YmO5Ud7vXj4Hw/nFJnv1dWgzPVGhcbTOtw27mcdx03A6olUPdIadg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHFbe/ex8WPOQYtQwf20KSmaqKnF1dEv7stYuYJkH/MQdHKDng
	4ntPO8W8+GRJfRqPtrRWOG47ye8Jl9dkZIb7syYnE1nYcFDPgVEWdngITXGfM2u9AGZYznLbmwC
	QCVzoUfXeTsCICx+JUoc29N0mn+Z8TOC2u8PDsnFCDaQHdqzKmFiOdQ==
X-Gm-Gg: ASbGncuUAEYgdkX+DIjlvhA2oB36e+rGCyVZrqbkQ32YLawNE9hoSmtonTyTSO+aOi/
	B+cEZB93mSnkHiUQwhzZf4AT9zP+6/y+sw1fXCHGQKvGKDWxsi9AzjkDWd0YQVxkR6xt4gq9ZUW
	HgPpSoPEXpYs32TSmTrK1JIzaH4BQy5Tgx/BYIPLXtpPXkcS6vrB/g3kU3Gtdqe9MMgnsxMrqoT
	GWzyvpBeWgSCfaYt9bK551BLlMemCwJDCRoI7Cm8LjU0+REbeQKVmHCErqEs2Tmm29NkuEzQtfP
	osm2ebZYx2nlyG0pAI9Zg1308Z2ZrvOEmp6zdd0ukXdMfHul/bWKXSBCK78qzigLx/M6B2pPzhV
	fhdS9unWsyYo6jkE=
X-Received: by 2002:a05:620a:916:b0:7e6:856d:bcb with SMTP id af79cd13be357-7e69625cd59mr1302045285a.6.1754377260476;
        Tue, 05 Aug 2025 00:01:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbo+rLta4n3tR1EMLfUV+fq1PsfLHsTA6oRYI7oXpPQbjgFFKmF+wjy0WLjzOdJ4+LHAbjcg==
X-Received: by 2002:a05:620a:916:b0:7e6:856d:bcb with SMTP id af79cd13be357-7e69625cd59mr1302041885a.6.1754377260042;
        Tue, 05 Aug 2025 00:01:00 -0700 (PDT)
Received: from sgarzare-redhat (host-79-45-205-118.retail.telecomitalia.it. [79.45.205.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f5b528bsm637184485a.21.2025.08.05.00.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 00:00:59 -0700 (PDT)
Date: Tue, 5 Aug 2025 09:00:50 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: bsdhenrymartin@gmail.com
Cc: huntazhang@tencent.com, jitxie@tencent.com, landonsun@tencent.com, 
	stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	eperezma@redhat.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Henry Martin <bsdhenryma@tencent.com>, TCS Robot <tcs_robot@tencent.com>
Subject: Re: [PATCH v1] VSOCK: fix Information Leak in
 virtio_transport_shutdown()
Message-ID: <4sbamls46k3dxlqgreifhhhd66iaosbeoxgbpyvwaipwlnwiba@dep4mseknust>
References: <20250805051009.1766587-1-tcs_kernel@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250805051009.1766587-1-tcs_kernel@tencent.com>

On Tue, Aug 05, 2025 at 01:10:09PM +0800, bsdhenrymartin@gmail.com wrote:
>From: Henry Martin <bsdhenryma@tencent.com>
>
>The `struct virtio_vsock_pkt_info` is declared on the stack but only
>partially initialized (only `op`, `flags`, and `vsk` are set)
>
>The uninitialized fields (including `pkt_len`, `remote_cid`,
>`remote_port`, etc.) contain residual kernel stack data. This structure
>is passed to `virtio_transport_send_pkt_info()`, which uses the
>uninitialized fields.
>
>Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
>Reported-by: TCS Robot <tcs_robot@tencent.com>
>Signed-off-by: Henry Martin <bsdhenryma@tencent.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 15 +++++++--------
> 1 file changed, 7 insertions(+), 8 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index fe92e5fa95b4..cb391a98d025 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1073,14 +1073,14 @@ EXPORT_SYMBOL_GPL(virtio_transport_connect);
>
> int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
> {
>-	struct virtio_vsock_pkt_info info = {
>-		.op = VIRTIO_VSOCK_OP_SHUTDOWN,
>-		.flags = (mode & RCV_SHUTDOWN ?
>-			  VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
>-			 (mode & SEND_SHUTDOWN ?
>-			  VIRTIO_VSOCK_SHUTDOWN_SEND : 0),
>-		.vsk = vsk,
>-	};

The compiler sets all other fields to 0, so I don't understand what this 
patch solves.
Can you give an example of the problem you found?

Furthermore, even if this fix were valid, why do it for just one 
function?

Stefano

>+	struct virtio_vsock_pkt_info info = {0};
>+
>+	info.op = VIRTIO_VSOCK_OP_SHUTDOWN;
>+	info.flags = (mode & RCV_SHUTDOWN ?
>+			VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
>+			(mode & SEND_SHUTDOWN ?
>+			VIRTIO_VSOCK_SHUTDOWN_SEND : 0);
>+	info.vsk = vsk;
>
> 	return virtio_transport_send_pkt_info(vsk, &info);
> }
>-- 
>2.41.3
>


