Return-Path: <kvm+bounces-68710-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UGuuHQHEcGkNZwAAu9opvQ
	(envelope-from <kvm+bounces-68710-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 13:18:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2975A56A09
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 13:18:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A8B389ADC33
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 12:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E19E428482;
	Wed, 21 Jan 2026 12:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XBblhhci";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yk/plsDL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3D841322D
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 12:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768997441; cv=none; b=lCrm9HsDvBHcbLqoN5WRsv6myZfqy2RMPg9ad9FKYjfuvLhabZnb2uHtzVyyxVMZSsnyuBe6DdNwQNYkxBKM065N+sjRfWnipDf//T4k3fy2IXSckn9211bdQ6hGg4i46+lixoTqvv4SR7m+uJCbE8liq58+7xIMYB/t30t8Zfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768997441; c=relaxed/simple;
	bh=GZ3GsuG+E3Qr6/RqofEs4s8euNMw69P/GSTuShgkEDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VBU4oA3azIO1A2G715JfRQ/YsH4UQTsQwYNtsePxf+8EdvbxYI+34D3tNI1VhFL6JHPmdIYs8D6w8YpFE2Ll+qdzqx0xi179X4Zk2WF+xnbu1fP2v5dAc3z+1p3OytFtcpp3KJ1hv3Ikfhlke1xucJCVXg9e5JoZ9CRY5TL9wIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XBblhhci; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yk/plsDL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768997433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vvEBWBLr1X14L0avrzDsdXo8a3nnKtSJtim3XAg072w=;
	b=XBblhhcipS6CBp0PsHeddJ5djqSj78auvENTW0NrVlsm4ivrA+4oLWrhFfxf1gcWi6/iGl
	ab2ALUtBtEbVRknHxN/346x9quwPafFUfwi5WiyqGedkif4z7fUp1m1N7aCfAjg3Ayv4pr
	4ne1WviKmg/GU8bww7wZ+S4FOKD73gQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-kuTElRl_NomG_pSwKivO8g-1; Wed, 21 Jan 2026 07:10:32 -0500
X-MC-Unique: kuTElRl_NomG_pSwKivO8g-1
X-Mimecast-MFC-AGG-ID: kuTElRl_NomG_pSwKivO8g_1768997431
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4801e9e7159so31071475e9.1
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 04:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768997431; x=1769602231; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vvEBWBLr1X14L0avrzDsdXo8a3nnKtSJtim3XAg072w=;
        b=Yk/plsDLRsXjspA2NU+UhMAWnxvtMa4C1QG66a6QwipcN23tLPLzNjLlIzZDuPiHWb
         fiFcfOOagmr4dVqGNQEw1rAEV4IAzly4t92GWRJm1KS7w34YARnGc9bxGgFTCVxQcOtt
         zBixAiUtWhQhLfy3kXXPvzwoIl0evUEVjXnHZ1RfL+kTpmNMJfgAwNhcrEcG2nJbeR2q
         LbYKO0JmNCHzKnycIIb1TLtbIbLaGfkQQG1LaIEpyaYXTFwVdYcP2PseyUbQByfCmOcM
         pgQa0Bo1j2WLVy3oBu4USNq1BOIBzPlsy3DwtM5AUdSdb2XwWf05HxRF5j4DK/9GCyou
         QaFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768997431; x=1769602231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vvEBWBLr1X14L0avrzDsdXo8a3nnKtSJtim3XAg072w=;
        b=iMHI3L2cFxIrl39f31Aa66A+/odznQO/I4ngPRMZCHpd1S16mj3xFQri1inzHdnMvl
         utXSpDtqWrj2QV76HNfrw8MhYqNr7/+RTYRg5GI3zI2iGEv+IMF/eat06XbQAh0GfSZW
         B2k0+9m0aLQFc8yIUuK5O3nY4Nt9JYXlXAs8jvOVQYZUjfGpDwRrdVYNbZs0Lf1C6A/i
         md0k0Hc0ctEhURxuEeLl9FhGFYytcJlzxD1HnUiM9vyyLhDK8DM4UT+tT7YRoEPOL+lT
         SmIeZ1J746m2ritBbzar+K5s64ytanw3vRyfu9FLXZtKYz151ACadE4GoeZ/olySSfPU
         66Uw==
X-Forwarded-Encrypted: i=1; AJvYcCUeGUahZXlnP2R57r5CydRKYD8SMFAITzcfo1amLaJ3FysDYMTOY5/Nb7e49ag+4FLKvM4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx17Z8FE4HUVoCd438xsRAT4whFOxlsKDSXhekrEiCzA+gbTVJN
	gwF0FYLTeC+XELd+o9mtt2lODOEFXJQHY8JNFxRt3TrnQUV/giaXSVQaETzYqtxW4MYAM7En1t8
	WaJBI/370A3LaYmRxzH69OuinJRE8mPSL3hmaHHQuhC63OUcdV4ymBA==
X-Gm-Gg: AZuq6aJvlLuofkAGJp2W4xdlmo1dsoTdpotZLFqa+AuEeWnZOSgT81Ma0vjKdv9Y74W
	I7MR7v3BJFDBnhDINK+yBMfCSVjI1lIwwbRVLsmrqDrVmt8r/w5UkhiuYDwOQumETBm+O2RR7cF
	fdLgbhdD5Ty510VlqPJslaKCMV6xWe7iVmAEXye5IdnS/KnFF1PYLPWnD8A0v+AIjB9Qr6+BcgI
	BPsFTYKyXat3ckPxXVqNiQzjmGjss7Jx73R2aA1ymrZXZRMiaNavj2oOqJ1jo3w+RgZGGiU1rMF
	OtHn/0u91c2kAx8TxRa8w9cpeRGWcHb/B9VVs7PUpWURhE77noG6xMu3d276um27iNNCBIQed47
	2EgKoI+almC1vxeQ=
X-Received: by 2002:a05:600c:81c5:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-4803e7a529emr72395265e9.15.1768997431368;
        Wed, 21 Jan 2026 04:10:31 -0800 (PST)
X-Received: by 2002:a05:600c:81c5:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-4803e7a529emr72394825e9.15.1768997430942;
        Wed, 21 Jan 2026 04:10:30 -0800 (PST)
Received: from leonardi-redhat ([176.206.16.134])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48043617b81sm38961085e9.0.2026.01.21.04.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 04:10:30 -0800 (PST)
Date: Wed, 21 Jan 2026 13:10:28 +0100
From: Luigi Leonardi <leonardi@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, Simon Horman <horms@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>, "David S. Miller" <davem@davemloft.net>, 
	virtualization@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>, 
	Jakub Kicinski <kuba@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Asias He <asias@redhat.com>, Melbin K Mathew <mlbnkm1@gmail.com>
Subject: Re: [PATCH net v6 3/4] vsock/virtio: cap TX credit to local buffer
 size
Message-ID: <aXDCKQ_yX9fT2W9o@leonardi-redhat>
References: <20260121093628.9941-1-sgarzare@redhat.com>
 <20260121093628.9941-4-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260121093628.9941-4-sgarzare@redhat.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,google.com,redhat.com,sberdevices.ru,davemloft.net,lists.linux.dev,linux.vnet.ibm.com,linux.alibaba.com,gmail.com];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	TAGGED_FROM(0.00)[bounces-68710-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leonardi@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 2975A56A09
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 10:36:27AM +0100, Stefano Garzarella wrote:
>From: Melbin K Mathew <mlbnkm1@gmail.com>
>
>The virtio transports derives its TX credit directly from peer_buf_alloc,
>which is set from the remote endpoint's SO_VM_SOCKETS_BUFFER_SIZE value.
>
>On the host side this means that the amount of data we are willing to
>queue for a connection is scaled by a guest-chosen buffer size, rather
>than the host's own vsock configuration. A malicious guest can advertise
>a large buffer and read slowly, causing the host to allocate a
>correspondingly large amount of sk_buff memory.
>The same thing would happen in the guest with a malicious host, since
>virtio transports share the same code base.
>
>Introduce a small helper, virtio_transport_tx_buf_size(), that
>returns min(peer_buf_alloc, buf_alloc), and use it wherever we consume
>peer_buf_alloc.
>
>This ensures the effective TX window is bounded by both the peer's
>advertised buffer and our own buf_alloc (already clamped to
>buffer_max_size via SO_VM_SOCKETS_BUFFER_MAX_SIZE), so a remote peer
>cannot force the other to queue more data than allowed by its own
>vsock settings.
>
>On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC with
>32 guest vsock connections advertising 2 GiB each and reading slowly
>drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB; the system only
>recovered after killing the QEMU process. That said, if QEMU memory is
>limited with cgroups, the maximum memory used will be limited.
>
>With this patch applied:
>
>  Before:
>    MemFree:        ~61.6 GiB
>    Slab:           ~142 MiB
>    SUnreclaim:     ~117 MiB
>
>  After 32 high-credit connections:
>    MemFree:        ~61.5 GiB
>    Slab:           ~178 MiB
>    SUnreclaim:     ~152 MiB
>
>Only ~35 MiB increase in Slab/SUnreclaim, no host OOM, and the guest
>remains responsive.
>
>Compatibility with non-virtio transports:
>
>  - VMCI uses the AF_VSOCK buffer knobs to size its queue pairs per
>    socket based on the local vsk->buffer_* values; the remote side
>    cannot enlarge those queues beyond what the local endpoint
>    configured.
>
>  - Hyper-V's vsock transport uses fixed-size VMBus ring buffers and
>    an MTU bound; there is no peer-controlled credit field comparable
>    to peer_buf_alloc, and the remote endpoint cannot drive in-flight
>    kernel memory above those ring sizes.
>
>  - The loopback path reuses virtio_transport_common.c, so it
>    naturally follows the same semantics as the virtio transport.
>
>This change is limited to virtio_transport_common.c and thus affects
>virtio-vsock, vhost-vsock, and loopback, bringing them in line with the
>"remote window intersected with local policy" behaviour that VMCI and
>Hyper-V already effectively have.
>
>Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
>Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
>[Stefano: small adjustments after changing the previous patch]
>[Stefano: tweak the commit message]
>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 14 ++++++++++++--
> 1 file changed, 12 insertions(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 6175124d63d3..d3e26025ef58 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -821,6 +821,15 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
> }
> EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>
>+static u32 virtio_transport_tx_buf_size(struct virtio_vsock_sock *vvs)
>+{
>+	/* The peer advertises its receive buffer via peer_buf_alloc, but we
>+	 * cap it to our local buf_alloc so a remote peer cannot force us to
>+	 * queue more data than our own buffer configuration allows.
>+	 */
>+	return min(vvs->peer_buf_alloc, vvs->buf_alloc);
>+}
>+
> int
> virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
> 				   struct msghdr *msg,
>@@ -830,7 +839,7 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>
> 	spin_lock_bh(&vvs->tx_lock);
>
>-	if (len > vvs->peer_buf_alloc) {
>+	if (len > virtio_transport_tx_buf_size(vvs)) {
> 		spin_unlock_bh(&vvs->tx_lock);
> 		return -EMSGSIZE;
> 	}
>@@ -884,7 +893,8 @@ static s64 virtio_transport_has_space(struct virtio_vsock_sock *vvs)
> 	 * we have bytes in flight (tx_cnt - peer_fwd_cnt), the subtraction
> 	 * does not underflow.
> 	 */
>-	bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>+	bytes = (s64)virtio_transport_tx_buf_size(vvs) -
>+		(vvs->tx_cnt - vvs->peer_fwd_cnt);
> 	if (bytes < 0)
> 		bytes = 0;
>
>-- 
>2.52.0
>

LGTM!

Reviewed-by: Luigi Leonardi <leonardi@redhat.com>


