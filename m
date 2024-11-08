Return-Path: <kvm+bounces-31246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FFA89C18E1
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 10:13:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2F6B1F21A91
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 09:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8052B1D356C;
	Fri,  8 Nov 2024 09:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RNzik05j"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454F31E00AC
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 09:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731057211; cv=none; b=kP515fCkWdPc2vpkP1+87EkfUIcffw86IBb5Ksw4GK69E2Zw7r0oHDhyHILfqRAPPCF+mfe/7pv9iEhoNdG+qAJFbrzQOV/1bG5Pjm16Uoi0utr7zCLaVkR4NFxk3yJ7RJsOPUpAtBgJz9WbN/5ZoLSCqPA6W1FDrTV/D/ajJ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731057211; c=relaxed/simple;
	bh=HEAsdYLwkrtGtogdvIBPZEXWue42gncPQ87YECUk5kY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGwjJ4hYnWQvoH4vZR4VRbXmC2o7gdj7FreR0soVLSNrziVPT6cs/dQ8mY5dtnw+n2PQUbIhfiCo4kopZManBc9YALGvbzMO00PVLcMDkVEEucdUnVWFAZRYyHjS15BooPvsuFFgdCB5lxhO1hmg7pOZSMyGRFq6jMfvCnjLeWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RNzik05j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731057208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GO0OGIRGWxKfjRBGTtqAfw57F84sGfgBv8XkGbO8UBE=;
	b=RNzik05jnXLZqJ9feI2reYharozV0DXk7KH98pr8XHdBcBqGH/60AwaZdKEvN81o5iym+k
	2RaeS+mfqN8Kpka9g8R6FqfpKtyFu1aeaOhEP9L9WNJ5N57Kf7OYJzsynwTHbOE27aoLHx
	0Ey55xd+g7TxmtYRUS7BfAvM0E9hbEs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-5F-Mfi9nNB2MKH7Rymhf-w-1; Fri, 08 Nov 2024 04:13:26 -0500
X-MC-Unique: 5F-Mfi9nNB2MKH7Rymhf-w-1
X-Mimecast-MFC-AGG-ID: 5F-Mfi9nNB2MKH7Rymhf-w
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4315a0f25afso13490065e9.3
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 01:13:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731057205; x=1731662005;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GO0OGIRGWxKfjRBGTtqAfw57F84sGfgBv8XkGbO8UBE=;
        b=r2xc2gD45uKUnDj1DgtjqcAChw99J+DH/9Ql6m/y2/w2pehlYIpZ8X37g8DWjdtu3p
         JblZ3lQB0VK4HCh2xueVRTOGG+O1aHNuXSltvQc3dXDLUUwykd86He7rWYLQecKEnw5x
         NHJZeycQXbp8Pbb6Ch+RLRAp7fLyJaXvYCTiKgTw2ov27qEt9tEvJBVGDT4tkKYvQlp9
         Jf5veSPOzKmqwSTT3ehDmBv8fzh/Z/a3bm9UoIiG9SBfwH+WaLv7KAmQy5xtuwY39IIg
         ekiy2AZlLY5TiijPRz0xWd5ZjArOBkOcydmNRUxeF3tYce+XZGpy2sQpDTJJdDX5c62T
         AbCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbvmGy9PLfrIPkvUzqrIx9XQI0sex+9m1QgWmk9wBnPQ3wtZCEmz2hKEZn1adhRyFEfrU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1ENWdWLAxcwBnc6mBg25nLC3OwUisw4N72VK67C6b6M9pncpP
	x9TAiSYRwo/Sz145VCHnzlpFTkCtiRpM90Ctoy71F+uOiJsLgB98z6PDIv8mZssSj24hrwT20qR
	VuYf+Bqmk2Z3vGKDCJ99JazjddqSh1iit2WM2iMc1mlrwMxpgbA==
X-Received: by 2002:a05:600c:1c88:b0:42c:de34:34be with SMTP id 5b1f17b1804b1-432b74fa92amr16075615e9.3.1731057205634;
        Fri, 08 Nov 2024 01:13:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFAK5vTncKeqE+EzHOeYy/PGvMNPyTWcejCYkWGsZcXDWCK4COat90VpxuJseJwMBr3OSiYWQ==
X-Received: by 2002:a05:600c:1c88:b0:42c:de34:34be with SMTP id 5b1f17b1804b1-432b74fa92amr16075165e9.3.1731057205008;
        Fri, 08 Nov 2024 01:13:25 -0800 (PST)
Received: from sgarzare-redhat ([193.207.101.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432b05c1c81sm56640315e9.32.2024.11.08.01.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2024 01:13:24 -0800 (PST)
Date: Fri, 8 Nov 2024 10:13:17 +0100
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
Subject: Re: [PATCH net v2 2/3] vsock: Fix sk_error_queue memory leak
Message-ID: <qjib7qrjxitohmdyjdvnxh7pavzkqohzthwn3mxiaot5copoh2@yg4dstc2fx5w>
References: <20241107-vsock-mem-leaks-v2-0-4e21bfcfc818@rbox.co>
 <20241107-vsock-mem-leaks-v2-2-4e21bfcfc818@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20241107-vsock-mem-leaks-v2-2-4e21bfcfc818@rbox.co>

On Thu, Nov 07, 2024 at 09:46:13PM +0100, Michal Luczaj wrote:
>Kernel queues MSG_ZEROCOPY completion notifications on the error queue.
>Where they remain, until explicitly recv()ed. To prevent memory leaks,
>clean up the queue when the socket is destroyed.
>
>unreferenced object 0xffff8881028beb00 (size 224):
>  comm "vsock_test", pid 1218, jiffies 4294694897
>  hex dump (first 32 bytes):
>    90 b0 21 17 81 88 ff ff 90 b0 21 17 81 88 ff ff  ..!.......!.....
>    00 00 00 00 00 00 00 00 00 b0 21 17 81 88 ff ff  ..........!.....
>  backtrace (crc 6c7031ca):
>    [<ffffffff81418ef7>] kmem_cache_alloc_node_noprof+0x2f7/0x370
>    [<ffffffff81d35882>] __alloc_skb+0x132/0x180
>    [<ffffffff81d2d32b>] sock_omalloc+0x4b/0x80
>    [<ffffffff81d3a8ae>] msg_zerocopy_realloc+0x9e/0x240
>    [<ffffffff81fe5cb2>] virtio_transport_send_pkt_info+0x412/0x4c0
>    [<ffffffff81fe6183>] virtio_transport_stream_enqueue+0x43/0x50
>    [<ffffffff81fe0813>] vsock_connectible_sendmsg+0x373/0x450
>    [<ffffffff81d233d5>] ____sys_sendmsg+0x365/0x3a0
>    [<ffffffff81d246f4>] ___sys_sendmsg+0x84/0xd0
>    [<ffffffff81d26f47>] __sys_sendmsg+0x47/0x80
>    [<ffffffff820d3df3>] do_syscall_64+0x93/0x180
>    [<ffffffff8220012b>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
>Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> net/vmw_vsock/af_vsock.c | 3 +++
> 1 file changed, 3 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 35681adedd9aaec3565495158f5342b8aa76c9bc..dfd29160fe11c4675f872c1ee123d65b2da0dae6 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -836,6 +836,9 @@ static void vsock_sk_destruct(struct sock *sk)
> {
> 	struct vsock_sock *vsk = vsock_sk(sk);
>
>+	/* Flush MSG_ZEROCOPY leftovers. */
>+	__skb_queue_purge(&sk->sk_error_queue);
>+
> 	vsock_deassign_transport(vsk);
>
> 	/* When clearing these addresses, there's no need to set the family and
>
>-- 
>2.46.2
>


