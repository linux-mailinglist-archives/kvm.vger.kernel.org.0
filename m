Return-Path: <kvm+bounces-53964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1129B1AEF1
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 08:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CF593BF30D
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 06:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D03892264BA;
	Tue,  5 Aug 2025 06:55:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C373F1917FB;
	Tue,  5 Aug 2025 06:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754376944; cv=none; b=IOKiRxYzQcegz7MyHYx1Y42R19MnuMkAdLDGs5wxAeOK54kqYI6n/bjaO9FsVn1ucM0Fp+M0vHrwBqM3QJzam8NlftcBkRBDhGFDf9tKFqzKA0L0/vAMpCrD3MeY04DNblJdjE2umdyYAQlO7jxPycYUV7I5MDuLMvx7nw+K9Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754376944; c=relaxed/simple;
	bh=FArsRfCOmBNuc3e584wfTFuUp9phIDbiTEt1k6FHVwY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CWEo4MBPlF13L8lrRlaQkDmPjstcd2XnD58QljiwFfpdZxnFJ0She3DBVkF0kAGra0lFGcP9SSSgSPgCG5oAxtIUcuBNzuMHqjR5kG5Vi89flY1WA3kaiZnAz+NexMeHS8o+kP7JdDt+xAeSGBCKQGeWxAjS5IqsG7rnfsFhf2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bx3z233LRz2TT4T;
	Tue,  5 Aug 2025 14:53:02 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id 3CE691A016C;
	Tue,  5 Aug 2025 14:55:32 +0800 (CST)
Received: from [10.174.176.70] (10.174.176.70) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 5 Aug 2025 14:55:30 +0800
Message-ID: <a841c987-5cd1-4105-94be-e0ea55068c5a@huawei.com>
Date: Tue, 5 Aug 2025 14:55:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] VSOCK: fix Information Leak in
 virtio_transport_shutdown()
To: <bsdhenrymartin@gmail.com>, <huntazhang@tencent.com>,
	<jitxie@tencent.com>, <landonsun@tencent.com>, <stefanha@redhat.com>,
	<sgarzare@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<xuanzhuo@linux.alibaba.com>, <eperezma@redhat.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<horms@kernel.org>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Henry Martin
	<bsdhenryma@tencent.com>, TCS Robot <tcs_robot@tencent.com>
References: <20250805051009.1766587-1-tcs_kernel@tencent.com>
From: Wang Liang <wangliang74@huawei.com>
In-Reply-To: <20250805051009.1766587-1-tcs_kernel@tencent.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500016.china.huawei.com (7.185.36.197)


在 2025/8/5 13:10, bsdhenrymartin@gmail.com 写道:
> From: Henry Martin <bsdhenryma@tencent.com>
>
> The `struct virtio_vsock_pkt_info` is declared on the stack but only
> partially initialized (only `op`, `flags`, and `vsk` are set)
>
> The uninitialized fields (including `pkt_len`, `remote_cid`,
> `remote_port`, etc.) contain residual kernel stack data. This structure
> is passed to `virtio_transport_send_pkt_info()`, which uses the
> uninitialized fields.
>
> Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
> Reported-by: TCS Robot <tcs_robot@tencent.com>
> Signed-off-by: Henry Martin <bsdhenryma@tencent.com>
> ---
>   net/vmw_vsock/virtio_transport_common.c | 15 +++++++--------
>   1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index fe92e5fa95b4..cb391a98d025 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1073,14 +1073,14 @@ EXPORT_SYMBOL_GPL(virtio_transport_connect);
>   
>   int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
>   {
> -	struct virtio_vsock_pkt_info info = {
> -		.op = VIRTIO_VSOCK_OP_SHUTDOWN,
> -		.flags = (mode & RCV_SHUTDOWN ?
> -			  VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
> -			 (mode & SEND_SHUTDOWN ?
> -			  VIRTIO_VSOCK_SHUTDOWN_SEND : 0),
> -		.vsk = vsk,
> -	};
> +	struct virtio_vsock_pkt_info info = {0};
> +
> +	info.op = VIRTIO_VSOCK_OP_SHUTDOWN;
> +	info.flags = (mode & RCV_SHUTDOWN ?
> +			VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
> +			(mode & SEND_SHUTDOWN ?
> +			VIRTIO_VSOCK_SHUTDOWN_SEND : 0);
> +	info.vsk = vsk;
>   
>   	return virtio_transport_send_pkt_info(vsk, &info);
>   }


No. The unassigned members (including `pkt_len`, `remote_cid`,
`remote_port`, etc.) will be automatically initialized to 0?


