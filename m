Return-Path: <kvm+bounces-34836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF73CA06567
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 20:31:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66D5E3A55AA
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 207911CF5C6;
	Wed,  8 Jan 2025 19:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=theori.io header.i=@theori.io header.b="EjdWt7UK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C8A1AAA15
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 19:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736364690; cv=none; b=MA7Ql0wXZKAZMYOM8QQdeuozaOrMM2o4BaFvjSv5FTY6tTXhQqAJOgdnzKcnhJp2wObGzsBe4UssJNAK0xmpF3kAbXEwWWo5dzXdXb8IXzSKlQ3zHICS/5u8kWLkJWFybgndfr4Yne2nX+gVnnOB/XEo0dtiaZA0nJ5ApXDc2sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736364690; c=relaxed/simple;
	bh=5b1MJ0amuIx6mkoE9SwD4e2ebV7znRTHvoH2P67Bib8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jc2f8jojkOoM3BGn1cdpCujpFXJK7G/T51dnqfiD8+sWnygBVi21wRVFYJL1+nXZWJ/agDn6XBWA2Nt6KiVqXEzwhLxToPL04gTNo2fqkL6VcNGRgnVKq/mqUZWSq36rl4l+AuRnhQCi76jt6ylweuyOZWJf6bpnCQVl6N0c9zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=theori.io; spf=pass smtp.mailfrom=theori.io; dkim=pass (1024-bit key) header.d=theori.io header.i=@theori.io header.b=EjdWt7UK; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=theori.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=theori.io
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2166f1e589cso1572115ad.3
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 11:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google; t=1736364687; x=1736969487; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Jtvo4ir8kxjljq7eka2U506iji5/r9yiGfObZJA9Hk=;
        b=EjdWt7UK2dCH98wTukK4CTeGQYayGHZLKvnNk31xsL26juOnQefnWXIVGMzhQnG1Hi
         Ki01tbNSWvC3vgSMxuxBVGoUUuF++z9IdYxMF7kQeUmD+EgHHCSMNCKLBboBtWEJuJcZ
         wRoz6yo9wqWrGatWpZUaiqaNN98ozbttAVusY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736364687; x=1736969487;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Jtvo4ir8kxjljq7eka2U506iji5/r9yiGfObZJA9Hk=;
        b=KTfKoOSODgrFAgLIHEY5olx/eAmL8WQn92XeYlIvPV5h8rFbQ4sBN0r288CF+D8l7M
         OrxGcVvcm0cldAcXLQjEn6RpvYTpzsbz2Xp9ngE/u3eK2PqTJa7sMiJth+soICjgLhwC
         +zWKTFJM9FDSwcWiMEW2zu+zWo9oHwM69+kBn9UoX8eGUvwKIqgx3QIfxGTGmsxOJwZJ
         2NMsnH6dQMpK+LvbJNvDAryIykZXVK761Ut9wHgO293Mq5zTZKXwJTYNf+vFTLASCd75
         HQyflF5a9OpAA8l/W+gmNj+/samr5++YFJESDG1UctSBfhYEiK5AHQccBSwt3SAAQhaR
         KhEA==
X-Forwarded-Encrypted: i=1; AJvYcCUhk/Es6UNdXjRzBBUjRvJuylPkC4Q/bApbQYdw717uzKdb1ONGjLEpGBhfLILnfTtq12g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3dADtoE3rUy+xoljJJF8WvFkXewEqpI0Jy13lFyfMsUVN0SXN
	RWyyNoCvyeuRmx8kJJq+Grdemot/5OxWkAjs6nCIaxoqVbqLAvBR7A0wUSZsKVU=
X-Gm-Gg: ASbGncsgCsHUo//l7o6695ludIQrOcwDuXi6rdCXvfE7I/SCzd3PubPXuSb8iGXmbJ6
	jDNhkY0JHxS1PXD+VjfhFCPct0Y9zLYssyx27tSIgqk0aVcbgGDQugaP26DlhyiOm7V9c6YshSz
	zeR2Xd+ZzVGKcomgJ8uASIaOJbHa2qUAHIdlt1wZZNqfkOY9JPYxsvML4WyRhbzQVQUKXySvdxM
	7yuMgxt+6rX+/0HLMVYofsB/zLzqTlewC3BIjIbv4ng7RIIp7xWeeGVx/1/HqeKHNBULA==
X-Google-Smtp-Source: AGHT+IF6d1lxbSLuWO/THk+x8aSRyMXzHsLrJNMSbGKpqc+WLXQkKiPlHLgXRv3O4vL92v4Ati9bOw==
X-Received: by 2002:a05:6a21:398:b0:1e1:ae83:ad04 with SMTP id adf61e73a8af0-1e88d134c3emr6681500637.27.1736364686950;
        Wed, 08 Jan 2025 11:31:26 -0800 (PST)
Received: from v4bel-B760M-AORUS-ELITE-AX ([211.219.71.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8dbbabsm37006185b3a.101.2025.01.08.11.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 11:31:26 -0800 (PST)
Date: Wed, 8 Jan 2025 14:31:19 -0500
From: Hyunwoo Kim <v4bel@theori.io>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Wongi Lee <qwerty@theori.io>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>,
	virtualization@lists.linux.dev,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>, bpf@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>, Michal Luczaj <mhal@rbox.co>,
	kvm@vger.kernel.org, v4bel@theori.io, imv4bel@gmail.com
Subject: Re: [PATCH net 1/2] vsock/virtio: discard packets if the transport
 changes
Message-ID: <Z37Sh+utS+iV3+eb@v4bel-B760M-AORUS-ELITE-AX>
References: <20250108180617.154053-1-sgarzare@redhat.com>
 <20250108180617.154053-2-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108180617.154053-2-sgarzare@redhat.com>

On Wed, Jan 08, 2025 at 07:06:16PM +0100, Stefano Garzarella wrote:
> If the socket has been de-assigned or assigned to another transport,
> we must discard any packets received because they are not expected
> and would cause issues when we access vsk->transport.
> 
> A possible scenario is described by Hyunwoo Kim in the attached link,
> where after a first connect() interrupted by a signal, and a second
> connect() failed, we can find `vsk->transport` at NULL, leading to a
> NULL pointer dereference.
> 
> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> Reported-by: Hyunwoo Kim <v4bel@theori.io>
> Reported-by: Wongi Lee <qwerty@theori.io>
> Closes: https://lore.kernel.org/netdev/Z2LvdTTQR7dBmPb5@v4bel-B760M-AORUS-ELITE-AX/
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 9acc13ab3f82..51a494b69be8 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1628,8 +1628,11 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>  
>  	lock_sock(sk);
>  
> -	/* Check if sk has been closed before lock_sock */
> -	if (sock_flag(sk, SOCK_DONE)) {
> +	/* Check if sk has been closed or assigned to another transport before
> +	 * lock_sock (note: listener sockets are not assigned to any transport)
> +	 */
> +	if (sock_flag(sk, SOCK_DONE) ||
> +	    (sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {

If a race scenario with vsock_listen() is added to the existing 
race scenario, the patch can be bypassed.

In addition to the existing scenario:
```
                     cpu0                                                      cpu1

                                                               socket(A)

                                                               bind(A, {cid: VMADDR_CID_LOCAL, port: 1024})
                                                                 vsock_bind()

                                                               listen(A)
                                                                 vsock_listen()
  socket(B)

  connect(B, {cid: VMADDR_CID_LOCAL, port: 1024})
    vsock_connect()
      lock_sock(sk);
      virtio_transport_connect()
        virtio_transport_connect()
          virtio_transport_send_pkt_info()
            vsock_loopback_send_pkt(VIRTIO_VSOCK_OP_REQUEST)
              queue_work(vsock_loopback_work)
      sk->sk_state = TCP_SYN_SENT;
      release_sock(sk);
                                                               vsock_loopback_work()
                                                                 virtio_transport_recv_pkt(VIRTIO_VSOCK_OP_REQUEST)
                                                                   sk = vsock_find_bound_socket(&dst);
                                                                   virtio_transport_recv_listen(sk, skb)
                                                                     child = vsock_create_connected(sk);
                                                                     vsock_assign_transport()
                                                                       vvs = kzalloc(sizeof(*vvs), GFP_KERNEL);
                                                                     vsock_insert_connected(vchild);
                                                                       list_add(&vsk->connected_table, list);
                                                                     virtio_transport_send_response(vchild, skb);
                                                                       virtio_transport_send_pkt_info()
                                                                         vsock_loopback_send_pkt(VIRTIO_VSOCK_OP_RESPONSE)
                                                                           queue_work(vsock_loopback_work)

                                                               vsock_loopback_work()
                                                                 virtio_transport_recv_pkt(VIRTIO_VSOCK_OP_RESPONSE)
                                                                   sk = vsock_find_bound_socket(&dst);
                                                                   lock_sock(sk);
                                                                   case TCP_SYN_SENT:
                                                                   virtio_transport_recv_connecting()
                                                                     sk->sk_state = TCP_ESTABLISHED;
                                                                   release_sock(sk);

                                                               kill(connect(B));
      lock_sock(sk);
      if (signal_pending(current)) {
      sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
      sock->state = SS_UNCONNECTED;    // [1]
      release_sock(sk);

  connect(B, {cid: VMADDR_CID_HYPERVISOR, port: 1024})
    vsock_connect(B)
      lock_sock(sk);
      vsock_assign_transport()
        virtio_transport_release()
          virtio_transport_close()
            if (!(sk->sk_state == TCP_ESTABLISHED || sk->sk_state == TCP_CLOSING))
            virtio_transport_shutdown()
              virtio_transport_send_pkt_info()
                vsock_loopback_send_pkt(VIRTIO_VSOCK_OP_SHUTDOWN)
                  queue_work(vsock_loopback_work)
            schedule_delayed_work(&vsk->close_work, VSOCK_CLOSE_TIMEOUT);	// [5]
        vsock_deassign_transport()
          vsk->transport = NULL;
        return -ESOCKTNOSUPPORT;
      release_sock(sk);
                                                               vsock_loopback_work()
                                                                 virtio_transport_recv_pkt(VIRTIO_VSOCK_OP_SHUTDOWN)
                                                                   virtio_transport_recv_connected()
                                                                     virtio_transport_reset()
                                                                       virtio_transport_send_pkt_info()
                                                                         vsock_loopback_send_pkt(VIRTIO_VSOCK_OP_RST)
                                                                           queue_work(vsock_loopback_work)
  listen(B)
    vsock_listen()
      if (sock->state != SS_UNCONNECTED)    // [2]
      sk->sk_state = TCP_LISTEN;    // [3]

                                                               vsock_loopback_work()
                                                                 virtio_transport_recv_pkt(VIRTIO_VSOCK_OP_RST)
								   if ((sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {    // [4]
								   ...
							       
  virtio_transport_close_timeout()
    virtio_transport_do_close()
      vsock_stream_has_data()
        return vsk->transport->stream_has_data(vsk);    // null-ptr-deref 

```
(Yes, This is quite a crazy scenario, but it can actually be induced)

Since sock->state is set to SS_UNCONNECTED during the first connect()[1], 
it can pass the sock->state check[2] in vsock_listen() and set 
sk->sk_state to TCP_LISTEN[3].
If this happens, the check in the patch with 
`sk->sk_state != TCP_LISTEN` will pass[4], and a null-ptr-deref can 
still occur.

More specifically, because the sk_state has changed to TCP_LISTEN, 
virtio_transport_recv_disconnecting() will not be called by the 
loopback worker. However, a null-ptr-deref may occur in 
virtio_transport_close_timeout(), which is scheduled by 
virtio_transport_close() called in the flow of the second connect()[5].
(The patch no longer cancels the virtio_transport_close_timeout() worker)

And even if the `sk->sk_state != TCP_LISTEN` check is removed from the 
patch, it seems that a null-ptr-deref will still occur due to 
virtio_transport_close_timeout(). 
It might be necessary to add worker cancellation at the 
appropriate location.

