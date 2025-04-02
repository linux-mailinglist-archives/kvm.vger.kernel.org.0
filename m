Return-Path: <kvm+bounces-42493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E3B0A792DB
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 18:15:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0B1A16DF53
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 16:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C86D1922DE;
	Wed,  2 Apr 2025 16:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QjXejAy9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D69518DB29
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 16:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743610476; cv=none; b=Rm/9BGABavAm6XLmG6Hk8DCQ6Xyztnx9+PPzBHuQYWizZB0Iucc224nGRfdKhSsgJCANmOXuKd6lSXdzSqmMxWYcz2kK3SYAFYTFz+TqD9Gnmx/0ae3t14TKRPY0vmYgMdWM8pjKSNdp9R5IfyFl/rV3yddrL6GJfmS+zIJnnto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743610476; c=relaxed/simple;
	bh=Ydm+k8HkvRBKYcyFFDL+gDh1pQECSDhmqUceWQb7CQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FV3Bbe9xoAo8/u3N0LKsgG0gfFDSwnso8ayuY+Wml5SFCkEQmlMwCeqvlLQmgaer/zsXB3LdwXskAoSMT0QzZhb1TPQKN9DJSPgprXC1R5y3r5sFVfGPtAOokjBbZZjMgDW6O29yBelv3kt40SQGexMOK5r0yVUM56wM8qjYFFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QjXejAy9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743610473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KAThrOka30otNhmkUJggV+4jdbUQdUkKGhzfYFKV8wA=;
	b=QjXejAy9RtVFmFWtaovGxMOFD7M1pq8bqvONLyjtB7sL4t+86vVgs9Xk4DZKqye0OoXJb7
	LgvRw78gn4CbkeFj2kxU1uUlzdZ1E0Cqb8AZgvaGugiO4rPSTxzT05G/5QmfwH5XgCcVJs
	8DpCihsk9prJeKnhRxyb3wScWr+I71w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-472-nJMGd8svOFyrmItM8fChUA-1; Wed,
 02 Apr 2025 12:14:28 -0400
X-MC-Unique: nJMGd8svOFyrmItM8fChUA-1
X-Mimecast-MFC-AGG-ID: nJMGd8svOFyrmItM8fChUA_1743610467
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 880E5180AF4D;
	Wed,  2 Apr 2025 16:14:26 +0000 (UTC)
Received: from localhost (unknown [10.2.16.101])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AE4671801747;
	Wed,  2 Apr 2025 16:14:25 +0000 (UTC)
Date: Wed, 2 Apr 2025 12:14:24 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Alexander Graf <graf@amazon.com>
Cc: netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, Asias He <asias@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S . Miller" <davem@davemloft.net>, nh-open-source@amazon.com
Subject: Re: [PATCH v2] vsock/virtio: Remove queued_replies pushback logic
Message-ID: <20250402161424.GA305204@fedora>
References: <20250401201349.23867-1-graf@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9/YZwLxNw5hXaRvd"
Content-Disposition: inline
In-Reply-To: <20250401201349.23867-1-graf@amazon.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111


--9/YZwLxNw5hXaRvd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 01, 2025 at 08:13:49PM +0000, Alexander Graf wrote:
> Ever since the introduction of the virtio vsock driver, it included
> pushback logic that blocks it from taking any new RX packets until the
> TX queue backlog becomes shallower than the virtqueue size.
>=20
> This logic works fine when you connect a user space application on the
> hypervisor with a virtio-vsock target, because the guest will stop
> receiving data until the host pulled all outstanding data from the VM.
>=20
> With Nitro Enclaves however, we connect 2 VMs directly via vsock:
>=20
>   Parent      Enclave
>=20
>     RX -------- TX
>     TX -------- RX
>=20
> This means we now have 2 virtio-vsock backends that both have the pushback
> logic. If the parent's TX queue runs full at the same time as the
> Enclave's, both virtio-vsock drivers fall into the pushback path and
> no longer accept RX traffic. However, that RX traffic is TX traffic on
> the other side which blocks that driver from making any forward
> progress. We're now in a deadlock.
>=20
> To resolve this, let's remove that pushback logic altogether and rely on
> higher levels (like credits) to ensure we do not consume unbounded
> memory.

The reason for queued_replies is that rx packet processing may emit tx
packets. Therefore tx virtqueue space is required in order to process
the rx virtqueue.

queued_replies puts a bound on the amount of tx packets that can be
queued in memory so the other side cannot consume unlimited memory. Once
that bound has been reached, rx processing stops until the other side
frees up tx virtqueue space.

It's been a while since I looked at this problem, so I don't have a
solution ready. In fact, last time I thought about it I wondered if the
design of virtio-vsock fundamentally suffers from deadlocks.

I don't think removing queued_replies is possible without a replacement
for the bounded memory and virtqueue exhaustion issue though. Credits
are not a solution - they are about socket buffer space, not about
virtqueue space, which includes control packets that are not accounted
by socket buffer space.

>=20
> RX and TX queues share the same work queue. To prevent starvation of TX
> by an RX flood and vice versa now that the pushback logic is gone, let's
> deliberately reschedule RX and TX work after a fixed threshold (256) of
> packets to process.
>=20
> Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
> Signed-off-by: Alexander Graf <graf@amazon.com>
> ---
>  net/vmw_vsock/virtio_transport.c | 70 +++++++++-----------------------
>  1 file changed, 19 insertions(+), 51 deletions(-)
>=20
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_tran=
sport.c
> index f0e48e6911fc..54030c729767 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -26,6 +26,12 @@ static struct virtio_vsock __rcu *the_virtio_vsock;
>  static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsoc=
k */
>  static struct virtio_transport virtio_transport; /* forward declaration =
*/
> =20
> +/*
> + * Max number of RX packets transferred before requeueing so we do
> + * not starve TX traffic because they share the same work queue.
> + */
> +#define VSOCK_MAX_PKTS_PER_WORK 256
> +
>  struct virtio_vsock {
>  	struct virtio_device *vdev;
>  	struct virtqueue *vqs[VSOCK_VQ_MAX];
> @@ -44,8 +50,6 @@ struct virtio_vsock {
>  	struct work_struct send_pkt_work;
>  	struct sk_buff_head send_pkt_queue;
> =20
> -	atomic_t queued_replies;
> -
>  	/* The following fields are protected by rx_lock.  vqs[VSOCK_VQ_RX]
>  	 * must be accessed with rx_lock held.
>  	 */
> @@ -158,7 +162,7 @@ virtio_transport_send_pkt_work(struct work_struct *wo=
rk)
>  		container_of(work, struct virtio_vsock, send_pkt_work);
>  	struct virtqueue *vq;
>  	bool added =3D false;
> -	bool restart_rx =3D false;
> +	int pkts =3D 0;
> =20
>  	mutex_lock(&vsock->tx_lock);
> =20
> @@ -172,6 +176,12 @@ virtio_transport_send_pkt_work(struct work_struct *w=
ork)
>  		bool reply;
>  		int ret;
> =20
> +		if (++pkts > VSOCK_MAX_PKTS_PER_WORK) {
> +			/* Allow other works on the same queue to run */
> +			queue_work(virtio_vsock_workqueue, work);
> +			break;
> +		}
> +
>  		skb =3D virtio_vsock_skb_dequeue(&vsock->send_pkt_queue);
>  		if (!skb)
>  			break;
> @@ -184,17 +194,6 @@ virtio_transport_send_pkt_work(struct work_struct *w=
ork)
>  			break;
>  		}
> =20
> -		if (reply) {
> -			struct virtqueue *rx_vq =3D vsock->vqs[VSOCK_VQ_RX];
> -			int val;
> -
> -			val =3D atomic_dec_return(&vsock->queued_replies);
> -
> -			/* Do we now have resources to resume rx processing? */
> -			if (val + 1 =3D=3D virtqueue_get_vring_size(rx_vq))
> -				restart_rx =3D true;
> -		}
> -
>  		added =3D true;
>  	}
> =20
> @@ -203,9 +202,6 @@ virtio_transport_send_pkt_work(struct work_struct *wo=
rk)
> =20
>  out:
>  	mutex_unlock(&vsock->tx_lock);
> -
> -	if (restart_rx)
> -		queue_work(virtio_vsock_workqueue, &vsock->rx_work);
>  }
> =20
>  /* Caller need to hold RCU for vsock.
> @@ -261,9 +257,6 @@ virtio_transport_send_pkt(struct sk_buff *skb)
>  	 */
>  	if (!skb_queue_empty_lockless(&vsock->send_pkt_queue) ||
>  	    virtio_transport_send_skb_fast_path(vsock, skb)) {
> -		if (virtio_vsock_skb_reply(skb))
> -			atomic_inc(&vsock->queued_replies);
> -
>  		virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
>  		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
>  	}
> @@ -277,7 +270,7 @@ static int
>  virtio_transport_cancel_pkt(struct vsock_sock *vsk)
>  {
>  	struct virtio_vsock *vsock;
> -	int cnt =3D 0, ret;
> +	int ret;
> =20
>  	rcu_read_lock();
>  	vsock =3D rcu_dereference(the_virtio_vsock);
> @@ -286,17 +279,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
>  		goto out_rcu;
>  	}
> =20
> -	cnt =3D virtio_transport_purge_skbs(vsk, &vsock->send_pkt_queue);
> -
> -	if (cnt) {
> -		struct virtqueue *rx_vq =3D vsock->vqs[VSOCK_VQ_RX];
> -		int new_cnt;
> -
> -		new_cnt =3D atomic_sub_return(cnt, &vsock->queued_replies);
> -		if (new_cnt + cnt >=3D virtqueue_get_vring_size(rx_vq) &&
> -		    new_cnt < virtqueue_get_vring_size(rx_vq))
> -			queue_work(virtio_vsock_workqueue, &vsock->rx_work);
> -	}
> +	virtio_transport_purge_skbs(vsk, &vsock->send_pkt_queue);
> =20
>  	ret =3D 0;
> =20
> @@ -367,18 +350,6 @@ static void virtio_transport_tx_work(struct work_str=
uct *work)
>  		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
>  }
> =20
> -/* Is there space left for replies to rx packets? */
> -static bool virtio_transport_more_replies(struct virtio_vsock *vsock)
> -{
> -	struct virtqueue *vq =3D vsock->vqs[VSOCK_VQ_RX];
> -	int val;
> -
> -	smp_rmb(); /* paired with atomic_inc() and atomic_dec_return() */
> -	val =3D atomic_read(&vsock->queued_replies);
> -
> -	return val < virtqueue_get_vring_size(vq);
> -}
> -
>  /* event_lock must be held */
>  static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
>  				       struct virtio_vsock_event *event)
> @@ -613,6 +584,7 @@ static void virtio_transport_rx_work(struct work_stru=
ct *work)
>  	struct virtio_vsock *vsock =3D
>  		container_of(work, struct virtio_vsock, rx_work);
>  	struct virtqueue *vq;
> +	int pkts =3D 0;
> =20
>  	vq =3D vsock->vqs[VSOCK_VQ_RX];
> =20
> @@ -627,11 +599,9 @@ static void virtio_transport_rx_work(struct work_str=
uct *work)
>  			struct sk_buff *skb;
>  			unsigned int len;
> =20
> -			if (!virtio_transport_more_replies(vsock)) {
> -				/* Stop rx until the device processes already
> -				 * pending replies.  Leave rx virtqueue
> -				 * callbacks disabled.
> -				 */
> +			if (++pkts > VSOCK_MAX_PKTS_PER_WORK) {
> +				/* Allow other works on the same queue to run */
> +				queue_work(virtio_vsock_workqueue, work);
>  				goto out;
>  			}
> =20
> @@ -675,8 +645,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock =
*vsock)
>  	vsock->rx_buf_max_nr =3D 0;
>  	mutex_unlock(&vsock->rx_lock);
> =20
> -	atomic_set(&vsock->queued_replies, 0);
> -
>  	ret =3D virtio_find_vqs(vdev, VSOCK_VQ_MAX, vsock->vqs, vqs_info, NULL);
>  	if (ret < 0)
>  		return ret;
> --=20
> 2.47.1
>=20

--9/YZwLxNw5hXaRvd
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmftYmAACgkQnKSrs4Gr
c8iHJwf8DA62FfOqEa7CozkdJzfzPBDN2Mp5277J19LYcEKpXUoxufoTN8Os0CFy
dNDZX0ipYNHwLLSxqUY4n4RWgrJ9S46eZ5e3U1+3+Pk72YOrSN/gYErnoauynhnK
Aw1Ai2S2bAFU+YxiPH2mwqzZTbHV0FdtYrO03U39QptOp4+IIKy5IM0OXMcj3ilR
nOC0o5f/QTKwKSne9lgC+t/3QbXeH34DsID8oSHp6w4Q8Lj2d5g2GWHIRkNfc9rm
hKLnOVblK2IEJ6QaztTDpYtoECFlWuYOy5K+vryC1MAzopkYavSsxZTP6httJzii
T7j+rofOap/1icDDiW3ld85xWHSyKQ==
=uC9e
-----END PGP SIGNATURE-----

--9/YZwLxNw5hXaRvd--


