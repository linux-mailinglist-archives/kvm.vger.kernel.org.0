Return-Path: <kvm+bounces-65767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA9BCB5FD7
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 14:16:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 248E13034EE1
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 13:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70DE1DB13A;
	Thu, 11 Dec 2025 13:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rh4qFncq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qwgAsfsm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602BC1F151C
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 13:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765458963; cv=none; b=il6ntKROOIvi6AFNiQt/fHCWXwX3wAp23qdt3r+kP19JtcjdxTHXo2F7gP1wHZ2yutzDcFVd2nvdKuPyfbHROwiNTU8+2MgT92IituD6QfBwgT6B58Mr5LiEsnEv3Za8VQ04UvVm//5smxkHRWOr3fKBF7GiD5CHSUq2J9QkzYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765458963; c=relaxed/simple;
	bh=D4DGGb+z62y89qoodZRwxBqyQ2W24OvlNfUQo6Mp9cE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FvEC0lH7A+DdcSyfaA+6sKeH3ryVGtoU2Wq5fatHJ/ECj3NbNF8oDHtCK0tRRp20a6/B8CQYnXYG+yeB2LZHLkR+gptFQ9wQOU4Cmj3rnZ+7yP4OfV93QNW5WLtahCoeHAmb0aQlpGZVaOxLj4xKvpXcbqVna39QKYQ0XW7c1OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rh4qFncq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qwgAsfsm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765458959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pcxS9gtwtWQRG7jJr9nwORwV625I1nRnmvMTOs/IWiM=;
	b=Rh4qFncqX2rWp9tDcm+PfzAMZf8ITfN13W50ZSxFArddWpD2McUsZdP9XyFOBJYEWDKzcB
	dQY2G+Bhqd8PnpSbTnsFumo9MpF+smEwbe3ACKeZ6Csul9hiBpoPqUkrO56RF0oFHWgHQA
	Uu+AM5HmOEG3Sptv/WkWpNLveVcVi3o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-zsZPRHbKOr2gfai8f_A9LA-1; Thu, 11 Dec 2025 08:15:57 -0500
X-MC-Unique: zsZPRHbKOr2gfai8f_A9LA-1
X-Mimecast-MFC-AGG-ID: zsZPRHbKOr2gfai8f_A9LA_1765458956
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b487cda00so52024f8f.3
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765458956; x=1766063756; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pcxS9gtwtWQRG7jJr9nwORwV625I1nRnmvMTOs/IWiM=;
        b=qwgAsfsm/+eg6noY8vcpjPkjaLEOtgYn3i9HBsHs1HyhVSRC9NfOq1KVfJ+TpM4P6v
         luOL7JCY77kLwcpIG8A44MCeuDYVdR3HLes8G5eBv5xlq/lEcvEb3CqKPGRW+7okgn+r
         P7Qqqz4YvBtfl4TSaEVjXlQtsoJ48sPVsRLYhGlVEcxCiqOa4e0VNhgaB0YeitZBo2uv
         peNkW2yiMO72BFcr0ylzGQ/uREG5WPv2rhSvYZ6vzI+Mun80Se8uimFybxoavKw1zuHI
         i5IjpYzWNczP27r00x0KXrYNhodhiMgqExoRRZKTE8dX+cleQE2tz8UGTLug8hqObuiV
         V0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765458956; x=1766063756;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pcxS9gtwtWQRG7jJr9nwORwV625I1nRnmvMTOs/IWiM=;
        b=Onq+aYGeMEx2K9rTfxFQTwTsRP4oM5Chx9yOJm0YsjbKEb5bdQoMwzR8gJU9EyK5yi
         5f0U+l2Dy8dKHk0ksGsNu9bRL+UapyV65lLluJ0JderUK3PicDt1uYlXvAmAexe4OYpD
         F9jEaYRQROgKAoscpx+DILZ19fj3GCrYPNFnlb00HM86cLhno48BBxdypeU1ZyFCXWqf
         20RXGPpNGF5K1x/tm2ngFl4DTlhdhE/FkMYvAJmV3ZqB29Va9wpTY2Y3d7A0afhQLa5w
         REhbL2LHO98wIQi7mEm6haek91HVvn0WHRWukjteh2IqjwjjoeVt+gqDwjFxyWkRxcN/
         nfbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWg8UztFAygRQRjXc3l4uXDsdLZHubx9OSPb6x/QZ7452q245w0J/BZzCJ3EM0feWWxnx0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxywjw116oPBlvVXaSCA0iMpMRjs5znkDrvfhdEZcThvt3DO5e2
	U6GCg5uLFpWJB9NzZo29DS/sqTaceVucEbgi3NGcf2SbFgFsGgUmoJnIoaDY4KIe2l37RY8Whh4
	Ls6Lij7P8CCM/UlReAEQVL0Ci+5uGOvNVuFSH8thsB7Z1jiQWpDwHtg==
X-Gm-Gg: AY/fxX6ch3OBYwBtVpyzeWGFzr3kvZGjtOzmRO42Ig8Ul7kxPG760nu2zN/N9RHtWrb
	c81rftmS8W8i0rp0Y/elNt9SfDxXKmC6aaqa3gBL0RQQ5hGoBjUdPOSb5Huk5npnJzt7rYNPArM
	4OHXCld+3yHSkmx0vyQQ3nJy32nodJdF7mbJ3PT4NuF5J7MbVkjNTyYiY5WXqDt0RP78wlMqgaB
	Z95SxTKEhtmd4hh6FOGvs85mlTcmxTEFR0RxV5RVzHlyC/Wj6ZVSUh56N6vgXa9iXAeKtk7JZNw
	4W/eQFOXiVVwghy2Ycsu+PvFke9WG29O2vqvf3UDicHg32YKWIJ5b+glRU5AB73rPphCC2YCQxj
	6YPFh4GzkEADXzLIjGfO/ex2iRpWDzvt9FOnzWkQqAVQ2KR7Ju09jEMeFG+hXXA==
X-Received: by 2002:a05:600c:811a:b0:471:786:94d3 with SMTP id 5b1f17b1804b1-47a8380695emr46248865e9.22.1765458956178;
        Thu, 11 Dec 2025 05:15:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGPy0Hrynl/SKJgf0tueBAFzbll9ERYzFk6T5Mif9KPff/zyeo06XmGrpdpM7whHIa5OMi70Q==
X-Received: by 2002:a05:600c:811a:b0:471:786:94d3 with SMTP id 5b1f17b1804b1-47a8380695emr46248335e9.22.1765458954662;
        Thu, 11 Dec 2025 05:15:54 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a89d8405dsm14222975e9.2.2025.12.11.05.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 05:15:54 -0800 (PST)
Date: Thu, 11 Dec 2025 14:15:49 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Melbin K Mathew <mlbnkm1@gmail.com>
Cc: stefanha@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, mst@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org
Subject: Re: [PATCH net v3] vsock/virtio: cap TX credit to local buffer size
Message-ID: <uo63g2tsmgcqqg3tpzm7tdtfn2pr73kymfyl4woulpwcobevuw@vr3d4i4konge>
References: <20251211125104.375020-1-mlbnkm1@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251211125104.375020-1-mlbnkm1@gmail.com>

On Thu, Dec 11, 2025 at 01:51:04PM +0100, Melbin K Mathew wrote:
>The virtio vsock transport currently derives its TX credit directly from
>peer_buf_alloc, which is populated from the remote endpoint's
>SO_VM_SOCKETS_BUFFER_SIZE value.
>
>On the host side, this means the amount of data we are willing to queue
>for a given connection is scaled purely by a peer-chosen value, rather
>than by the host's own vsock buffer configuration. A guest that
>advertises a very large buffer and reads slowly can cause the host to
>allocate a correspondingly large amount of sk_buff memory for that
>connection.
>
>In practice, a malicious guest can:
>
>  - set a large AF_VSOCK buffer size (e.g. 2 GiB) with
>    SO_VM_SOCKETS_BUFFER_MAX_SIZE / SO_VM_SOCKETS_BUFFER_SIZE, and
>
>  - open multiple connections to a host vsock service that sends data
>    while the guest drains slowly.
>
>On an unconstrained host this can drive Slab/SUnreclaim into the tens of
>GiB range, causing allocation failures and OOM kills in unrelated host
>processes while the offending VM remains running.
>
>On non-virtio transports and compatibility:
>
>  - VMCI uses the AF_VSOCK buffer knobs to size its queue pairs per
>    socket based on the local vsk->buffer_* values; the remote side
>    can’t enlarge those queues beyond what the local endpoint
>    configured.
>
>  - Hyper-V’s vsock transport uses fixed-size VMBus ring buffers and
>    an MTU bound; there is no peer-controlled credit field comparable
>    to peer_buf_alloc, and the remote endpoint can’t drive in-flight
>    kernel memory above those ring sizes.
>
>  - The loopback path reuses virtio_transport_common.c, so it
>    naturally follows the same semantics as the virtio transport.
>
>Make virtio-vsock consistent with that model by intersecting the peer’s
>advertised receive window with the local vsock buffer size when
>computing TX credit. We introduce a small helper and use it in
>virtio_transport_get_credit(), virtio_transport_has_space() and
>virtio_transport_seqpacket_enqueue(), so that:
>
>    effective_tx_window = min(peer_buf_alloc, buf_alloc)
>
>This prevents a remote endpoint from forcing us to queue more data than
>our own configuration allows, while preserving the existing credit
>semantics and keeping virtio-vsock compatible with the other transports.
>
>On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC with
>32 guest vsock connections advertising 2 GiB each and reading slowly
>drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB and the system only
>recovered after killing the QEMU process.
>
>With this patch applied, rerunning the same PoC yields:
>
>  Before:
>    MemFree:        ~61.6 GiB
>    MemAvailable:   ~62.3 GiB
>    Slab:           ~142 MiB
>    SUnreclaim:     ~117 MiB
>
>  After 32 high-credit connections:
>    MemFree:        ~61.5 GiB
>    MemAvailable:   ~62.3 GiB
>    Slab:           ~178 MiB
>    SUnreclaim:     ~152 MiB
>
>i.e. only ~35 MiB increase in Slab/SUnreclaim, no host OOM, and the
>guest remains responsive.
>
>Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
>Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 27 ++++++++++++++++++++++---
> 1 file changed, 24 insertions(+), 3 deletions(-)

Changes LGTM, but the patch seems corrupted.

$ git am ./v3_20251211_mlbnkm1_vsock_virtio_cap_tx_credit_to_local_buffer_size.mbx
Applying: vsock/virtio: cap TX credit to local buffer size
error: corrupt patch at line 29
Patch failed at 0001 vsock/virtio: cap TX credit to local buffer size

See also 
https://patchwork.kernel.org/project/netdevbpf/patch/20251211125104.375020-1-mlbnkm1@gmail.com/

Stefano

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index dcc8a1d58..02eeb96dd 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -491,6 +491,25 @@ void virtio_transport_consume_skb_sent(struct sk_buff *skb, bool consume)
> }
> EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
>
>+/* Return the effective peer buffer size for TX credit computation.
>+ *
>+ * The peer advertises its receive buffer via peer_buf_alloc, but we
>+ * cap that to our local buf_alloc (derived from
>+ * SO_VM_SOCKETS_BUFFER_SIZE and already clamped to buffer_max_size)
>+ * so that a remote endpoint cannot force us to queue more data than
>+ * our own configuration allows.
>+ */
>+static u32 virtio_transport_tx_buf_alloc(struct virtio_vsock_sock *vvs)
>+{
>+	return min(vvs->peer_buf_alloc, vvs->buf_alloc);
>+}
>+
> u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> {
> 	u32 ret;
>@@ -499,7 +518,8 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> 		return 0;
>
> 	spin_lock_bh(&vvs->tx_lock);
>-	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>+	ret = virtio_transport_tx_buf_alloc(vvs) -
>+		(vvs->tx_cnt - vvs->peer_fwd_cnt);
> 	if (ret > credit)
> 		ret = credit;
> 	vvs->tx_cnt += ret;
>@@ -831,7 +851,7 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>
> 	spin_lock_bh(&vvs->tx_lock);
>
>-	if (len > vvs->peer_buf_alloc) {
>+	if (len > virtio_transport_tx_buf_alloc(vvs)) {
> 		spin_unlock_bh(&vvs->tx_lock);
> 		return -EMSGSIZE;
> 	}
>@@ -882,7 +902,8 @@ static s64 virtio_transport_has_space(struct vsock_sock *vsk)
> 	struct virtio_vsock_sock *vvs = vsk->trans;
> 	s64 bytes;
>
>-	bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>+	bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
>+		(vvs->tx_cnt - vvs->peer_fwd_cnt);
> 	if (bytes < 0)
> 		bytes = 0;
>
>-- 
>2.34.1
>


