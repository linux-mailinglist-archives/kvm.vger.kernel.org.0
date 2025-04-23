Return-Path: <kvm+bounces-43980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51CDFA9957E
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 18:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 040113A666C
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 16:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3747528936B;
	Wed, 23 Apr 2025 16:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LRWkJ1+j"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D4A2798E7
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 16:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745426094; cv=none; b=ZP842yEPxemBgryRLupEJ8Ys801dQmHIYQNfThFPvu/DwC2M0n3WFfkYctv543B6sqbotHSIyFf8mgZuDPm3miVCpDyzi3dEqvbO7FsnVRzc9kswyoy9+P9vtdeRxWNBv3sI1nwUwVa+IIKfkBw90iULfZ07qeJ1tpc+Yog7DDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745426094; c=relaxed/simple;
	bh=bXXIovlNwDDSL/qXa0t+pqlwF7YhlNYF0hxtdu3MOBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=skRORZlj/v+UrbmsXCDXskIgEaiIrWlSPRPMzl3YEJFr/OdgY38IL6s8ty6klX1Sk8g9/r1jlrGwlB5G2MuKfVqbb9MoTlKq8BxKWXvm89gzm11M/RoLKq2liBPM/u0TlQnDyZzF2hj5jKHCEqK702b6euMbDprJNZXyAqoFwJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LRWkJ1+j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745426090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hX0ZWPxzqOkirz1sKOlbutSepxCMmH8RyV6IiHrCUKw=;
	b=LRWkJ1+jVDmko8Ecp4apyMQHCI9uaqGnZqQ0lzGwEMkPhGCljEwUKt2O3aNo0xkhKXptRY
	da+9dz7txjEtwIa89/KgHGp3enOeS146Qr4ix1tKbKJbxH6Gjs5kRCAoSt4Ono0QpI7AMV
	PwG+mI2RBZtICk00/96LofXjPbGWUM0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-41PK8FyCOset3My4-FOcjg-1; Wed, 23 Apr 2025 12:34:30 -0400
X-MC-Unique: 41PK8FyCOset3My4-FOcjg-1
X-Mimecast-MFC-AGG-ID: 41PK8FyCOset3My4-FOcjg_1745426070
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c5bb68b386so1781185a.3
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 09:34:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745426070; x=1746030870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hX0ZWPxzqOkirz1sKOlbutSepxCMmH8RyV6IiHrCUKw=;
        b=CoESR/FO02C6J/kYPNaguiypVsnND/hjUcn2lA2IsVe++xxGMp8aytTwT0FeaN/NXK
         0qIlp8kJJhmSRVITqcWWUhI1BLFGl2a+1gts1rpKbn727nuqfU54davW3n+U1ApqFdmu
         hLHddEGBB1FLEowM+/6gzDBRc62vm2zi+aaCGORqWYAN8GIGNRx+Lh2iG49IaP76hGhH
         JlDvAuvEXDhyA1LoxCFSAdWDuFJEOuFpA6kONLZrURn9dSa6ySnSA1b6mkbEvnIXXxSN
         3clAIOv5EXR34ocifIbpQRSdp308GujrleiR0utKGBwD/EbOQ97hDkPusXsmPDqM1LiZ
         25YA==
X-Forwarded-Encrypted: i=1; AJvYcCW4G+bOAZ7lceaUxTFWh2f/0fLGViou08qWgQsy+b0PjlRPwPQFu7F1H8M4yCKmjyY24dk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd+0L2xytyS/SEwxD9xJib0/d3SVvB8jJvT2hYAQowLY98/5aa
	oj3zjsYPuyg/Og2+7IZAe4s2c0gfRxWVLQDLBhCc/+Ty7bSWm7Zd5mTAT8P6IN8dDAZNUWazOgU
	bSuAd3IbDF8OHdpcaB4fITcD7MadgrsHue/Db0l342InkBLWQfw==
X-Gm-Gg: ASbGncv+DcT8SRZFbO1/nLio/I7Iz9/y76W35Hv9QzwjnmZn1eaC2xgiHOT0AtHXsAU
	pDJh4xLtH+PhkXjSqJ2tcxWkhhxyTNxiNZj36Jzz1FiXWrhEO02NI4YrhCFpQdgUXSXunAXUnKS
	VqnDhOky2akA0viL+XnM2lo8hRFQvEDuHDTjSmU/d37jpOYSYAiB5SF3pMnacbfoCiniSmR7V8I
	Iz9bELra4+yJzM6oYvKl4nizDEpr/COYvcH06dsaSb1fIobd1koXPbFz1x3rMbUA3yIAQswe5GG
	xlCpxBQTTcmzzYPjUw==
X-Received: by 2002:a05:620a:28d0:b0:7c5:6df2:b7a5 with SMTP id af79cd13be357-7c927fa2b71mr3166544285a.29.1745426070346;
        Wed, 23 Apr 2025 09:34:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/i+wfr+aLg9YJcmFsbtb0FZaYC+Ua4737Sifb8T35B0q4/iqB5jGvO/7HQVtCV2sdLcI6OQ==
X-Received: by 2002:a05:620a:28d0:b0:7c5:6df2:b7a5 with SMTP id af79cd13be357-7c927fa2b71mr3166538685a.29.1745426069796;
        Wed, 23 Apr 2025 09:34:29 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.206.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c925b69579sm700021485a.91.2025.04.23.09.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 09:34:29 -0700 (PDT)
Date: Wed, 23 Apr 2025 18:34:18 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Luigi Leonardi <leonardi@redhat.com>, Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] vsock: Linger on unsent data
Message-ID: <k47d2h7dwn26eti2p6nv2fupuybabvbexwinvxv7jnfbn6o3ep@cqtbaqlqyfrq>
References: <20250421-vsock-linger-v2-0-fe9febd64668@rbox.co>
 <20250421-vsock-linger-v2-1-fe9febd64668@rbox.co>
 <km2nad6hkdi3ngtho2xexyhhosh4aq37scir2hgxkcfiwes2wd@5dyliiq7cpuh>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <km2nad6hkdi3ngtho2xexyhhosh4aq37scir2hgxkcfiwes2wd@5dyliiq7cpuh>

On Wed, Apr 23, 2025 at 05:53:12PM +0200, Luigi Leonardi wrote:
>Hi Michal,
>
>On Mon, Apr 21, 2025 at 11:50:41PM +0200, Michal Luczaj wrote:
>>Currently vsock's lingering effectively boils down to waiting (or timing
>>out) until packets are consumed or dropped by the peer; be it by receiving
>>the data, closing or shutting down the connection.
>>
>>To align with the semantics described in the SO_LINGER section of man
>>socket(7) and to mimic AF_INET's behaviour more closely, change the logic
>>of a lingering close(): instead of waiting for all data to be handled,
>>block until data is considered sent from the vsock's transport point of
>>view. That is until worker picks the packets for processing and decrements
>>virtio_vsock_sock::bytes_unsent down to 0.
>>
>>Note that such lingering is limited to transports that actually implement
>>vsock_transport::unsent_bytes() callback. This excludes Hyper-V and VMCI,
>>under which no lingering would be observed.
>>
>>The implementation does not adhere strictly to man page's interpretation of
>>SO_LINGER: shutdown() will not trigger the lingering. This follows AF_INET.
>>
>>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>>---
>>net/vmw_vsock/virtio_transport_common.c | 13 +++++++++++--
>>1 file changed, 11 insertions(+), 2 deletions(-)
>>
>>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>index 7f7de6d8809655fe522749fbbc9025df71f071bd..aeb7f3794f7cfc251dde878cb44fdcc54814c89c 100644
>>--- a/net/vmw_vsock/virtio_transport_common.c
>>+++ b/net/vmw_vsock/virtio_transport_common.c
>>@@ -1196,12 +1196,21 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
>>{
>>	if (timeout) {
>>		DEFINE_WAIT_FUNC(wait, woken_wake_function);
>>+		ssize_t (*unsent)(struct vsock_sock *vsk);
>>+		struct vsock_sock *vsk = vsock_sk(sk);
>>+
>>+		/* Some transports (Hyper-V, VMCI) do not implement
>>+		 * unsent_bytes. For those, no lingering on close().
>>+		 */
>>+		unsent = vsk->transport->unsent_bytes;
>>+		if (!unsent)
>>+			return;
>
>IIUC if `unsent_bytes` is not implemented, virtio_transport_wait_close 
>basically does nothing. My concern is that we are breaking the 
>userspace due to a change in the behavior: Before this patch, with a 
>vmci/hyper-v transport, this function would wait for SOCK_DONE to be 
>set, but not anymore.

Wait, we are in virtio_transport_common.c, why we are talking about 
Hyper-V and VMCI?

I asked to check `vsk->transport->unsent_bytes` in the v1, because this 
code was part of af_vsock.c, but now we are back to virtio code, so I'm 
confused...

Stefano

>
>>
>>		add_wait_queue(sk_sleep(sk), &wait);
>>
>>		do {
>>-			if (sk_wait_event(sk, &timeout,
>>-					  sock_flag(sk, SOCK_DONE), &wait))
>>+			if (sk_wait_event(sk, &timeout, unsent(vsk) == 0,
>>+					  &wait))
>>				break;
>>		} while (!signal_pending(current) && timeout);
>>
>>
>>-- 2.49.0
>>
>
>Thanks,
>Luigi
>


