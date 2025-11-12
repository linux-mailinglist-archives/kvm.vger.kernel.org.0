Return-Path: <kvm+bounces-62921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7997EC53F15
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:41:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 871E83B40C7
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54924358D29;
	Wed, 12 Nov 2025 18:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nz4nFM7R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EFF34B40E
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 18:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972043; cv=none; b=FRlZ4oDlxbz4GQPEfpm7qMGWmZZJ98R4mEU6wOwz4daniSMh2udBq2v5U1/dMp0qeXQXif94r29HzRVV9SpXFvG0LmNNVyp3Uktg7WsAtg+/Ns1vuBOXRDFjc2V14e23zSEK37DJOaKr8iIz1sf0U5mT5vPFLoKN7KB8HlGnWtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972043; c=relaxed/simple;
	bh=t9WH0uIA0Kd5iVPDGi3VBM9RJJsL30m93Ocqn2bvwTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GFdB2NAaX5NIYmW7LdJgjpjKX/5a5KDsnYsvZHMsdsw8G0dL8jMdplLUGP4Vs1Ry5T9ToHtdnVFnqhvBD2d15x6N/9m2mEutUvCI6ZN0Mfz6yfQtAMJo9AyCcm6KDEBicQLxe76EKbkZ1ON9+RqMOOa474kGibnlOsnBAHQIQ7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nz4nFM7R; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-787e84ceaf7so14241827b3.2
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 10:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762972040; x=1763576840; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kn4iJ576u/8r69eAmbE1/5rsoTHMVU1gXmFF80Gkt/s=;
        b=Nz4nFM7RRsGZORcMyP1ZJXgR+glf+eHfJUMWYH7nhtTojAIbFV+StSznpgQRZ+LzDW
         jedLyy66Zg6EJszrHY1H7xC9gns4OxbZ2OS5waC/QNs1hu+xLnuVpZE+rPq1SCfBmJg6
         HYZ+db6bIBtckenS4UV0FRHxOlnrWGtCiQrHbzJ4pUquQNglGJE8ReSIwk7EWUvd84vP
         Z1oRS1bKpl3C2El95gc/4Z4fGE5SM9iMUujCGf22D3VsBLMcqRrupynAuJpWv+iovRFA
         xKpqhpoWk6fcSyBgnx1k14bwPEy0jGgdorls+Maps6I3lZ2t2vprvvVacKG4lENkOm6v
         nPUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762972040; x=1763576840;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kn4iJ576u/8r69eAmbE1/5rsoTHMVU1gXmFF80Gkt/s=;
        b=rPrFr0QiNVqF1NFHrTDuOeap6slmuwYRNNbFY5uje5jFBx9eXaMEXQgLg9jqJC239W
         22Uzuq/TQLBrsNPUa04lgOeEDY04adrEUFV2NWMzHVMu4wJ43LosqtJdOWrHUM/ZgZos
         y39Y4/FlvePK+sXzDseesH1kc0vPKYh8PnB7T2qxUHq3cKVMQnVVoMxo+cUuitN6eXNx
         yFOwTaSgJ7IOX/TUgpmiBsnLYtZSe794bjpg6Ry+e+fvdAG9KAAnlRjgGOhJB6mkSbNb
         xtsWY3SVGB6uRaWsMJsfIEoEpQzHyhsQKnhDy0TFRSv6ERGh4bNPess5du/FX1dnSL7W
         9q2w==
X-Forwarded-Encrypted: i=1; AJvYcCU/sGzh74HOp/H7iteuLkG3XMn4lVP+ildGp80ZwEJjGCzNinr5yb/5aiLsNlqEiGOakdc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDZy0ooC7ZPuEVZXASXbGU/3GQoLtGs8uQEEsi/i6WgogBLwZ1
	yfJJB8QsCcJ+bkKvDFZD0d5p4KvVcANt6CzC29SqznzM9ZlLrS18rq2s
X-Gm-Gg: ASbGnculB+jZCpkWFyYqO+2678cFNv0wdWHFfDG4JvN+h4uIFVjFAakRl3LtNzskodw
	JR9LwuI6cVcfBcDzmOyUxxOiJXoujdVZy5wFUzAILvgMxb+Eail9GvH9IpJVw6lVSNLEA5zb+XM
	T8vysRyq5FOLn0HBOVehrzA+atvShSgW/+AWwitSaC9wGhjIAXU60Sky9XEy5+HzwLNOVUejKCw
	TxoQOeh0fU5/zoD0PCyOP9byIdmqwP0tK3Zri9ZQJJBD9RN6R2r1cMX1rSJNIKBYy3Iyz4VRTH/
	NEwRxCvw4wDrwjmQqnMyI+Ojyh0FR0ieWveu+K7YFLK9cYUClMPKUkzyGO9m8xmEnwQN7/84uNV
	y/+n3QhSub5Avio78dBbPTjtTMB7bmUN/EfrI2E2k/l9OjA0krzI3ArhLrG1fT4BRpB5zbSIs3A
	UGNnALy6EG2GFRcGdU7f8GkhoVkIBh8C42V9s4Wz8kcDEfMjQ=
X-Google-Smtp-Source: AGHT+IFtItqGMv7c9zs0jQHS1j4i/TwYkKYfFZ78q75Lc+7yrpynqEhiYQ57+QLFTujVr5ZJ9SSG/A==
X-Received: by 2002:a05:690c:a9a:b0:786:82fc:ab57 with SMTP id 00721157ae682-788136f832emr34080737b3.67.1762972040554;
        Wed, 12 Nov 2025 10:27:20 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:5e::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d69e9dbesm44067957b3.42.2025.11.12.10.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:27:19 -0800 (PST)
Date: Wed, 12 Nov 2025 10:27:18 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
	Sargun Dhillon <sargun@sargun.me>, berrange@redhat.com,
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v9 06/14] vsock/loopback: add netns support
Message-ID: <aRTRhk/ok06YKTEu@devvm11784.nha0.facebook.com>
References: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
 <20251111-vsock-vmtest-v9-6-852787a37bed@meta.com>
 <g6bxp6hketbjrddzni2ln37gsezqvxbu2orheorzh7fs66roll@hhcrgsos3ui3>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g6bxp6hketbjrddzni2ln37gsezqvxbu2orheorzh7fs66roll@hhcrgsos3ui3>

On Wed, Nov 12, 2025 at 03:19:47PM +0100, Stefano Garzarella wrote:
> On Tue, Nov 11, 2025 at 10:54:48PM -0800, Bobby Eshleman wrote:
> > From: Bobby Eshleman <bobbyeshleman@meta.com>
> > 
> > Add NS support to vsock loopback. Sockets in a global mode netns
> > communicate with each other, regardless of namespace. Sockets in a local
> > mode netns may only communicate with other sockets within the same
> > namespace.
> > 
> > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> > ---
> > Changes in v9:
> > - remove per-netns vsock_loopback and workqueues, just re-using
> >  the net and net_mode in skb->cb achieved the same result in a simpler
> >  way. Also removed need for pernet_subsys.
> > - properly track net references
> > 
> > Changes in v7:
> > - drop for_each_net() init/exit, drop net_rwsem, the pernet registration
> >  handles this automatically and race-free
> > - flush workqueue before destruction, purge pkt list
> > - remember net_mode instead of current net mode
> > - keep space after INIT_WORK()
> > - change vsock_loopback in netns_vsock to ->priv void ptr
> > - rename `orig_net_mode` to `net_mode`
> > - remove useless comment
> > - protect `register_pernet_subsys()` with `net_rwsem`
> > - do cleanup before releasing `net_rwsem` when failure happens
> > - call `unregister_pernet_subsys()` in `vsock_loopback_exit()`
> > - call `vsock_loopback_deinit_vsock()` in `vsock_loopback_exit()`
> > 
> > Changes in v6:
> > - init pernet ops for vsock_loopback module
> > - vsock_loopback: add space in struct to clarify lock protection
> > - do proper cleanup/unregister on vsock_loopback_exit()
> > - vsock_loopback: use virtio_vsock_skb_net()
> > 
> > Changes in v5:
> > - add callbacks code to avoid reverse dependency
> > - add logic for handling vsock_loopback setup for already existing
> >  namespaces
> > ---
> > net/vmw_vsock/vsock_loopback.c | 41 ++++++++++++++++++++++++++++++++++++++++-
> > 1 file changed, 40 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> > index d3ac056663ea..e62f6c516992 100644
> > --- a/net/vmw_vsock/vsock_loopback.c
> > +++ b/net/vmw_vsock/vsock_loopback.c
> > @@ -32,6 +32,9 @@ static int vsock_loopback_send_pkt(struct sk_buff *skb, struct net *net,
> > 	struct vsock_loopback *vsock = &the_vsock_loopback;
> > 	int len = skb->len;
> > 
> > +	virtio_vsock_skb_set_net(skb, net);
> > +	virtio_vsock_skb_set_net_mode(skb, net_mode);
> > +
> > 	virtio_vsock_skb_queue_tail(&vsock->pkt_queue, skb);
> > 	queue_work(vsock->workqueue, &vsock->pkt_work);
> > 
> > @@ -116,8 +119,10 @@ static void vsock_loopback_work(struct work_struct *work)
> > {
> > 	struct vsock_loopback *vsock =
> > 		container_of(work, struct vsock_loopback, pkt_work);
> > +	enum vsock_net_mode net_mode;
> > 	struct sk_buff_head pkts;
> > 	struct sk_buff *skb;
> > +	struct net *net;
> > 
> > 	skb_queue_head_init(&pkts);
> > 
> > @@ -131,7 +136,41 @@ static void vsock_loopback_work(struct work_struct *work)
> > 		 */
> > 		virtio_transport_consume_skb_sent(skb, false);
> > 		virtio_transport_deliver_tap_pkt(skb);
> > -		virtio_transport_recv_pkt(&loopback_transport, skb, NULL, 0);
> > +
> > +		/* In the case of virtio_transport_reset_no_sock(), the skb
> > +		 * does not hold a reference on the socket, and so does not
> > +		 * transitively hold a reference on the net.
> > +		 *
> > +		 * There is an ABA race condition in this sequence:
> > +		 * 1. the sender sends a packet
> > +		 * 2. worker calls virtio_transport_recv_pkt(), using the
> > +		 *    sender's net
> > +		 * 3. virtio_transport_recv_pkt() uses t->send_pkt() passing the
> > +		 *    sender's net
> > +		 * 4. virtio_transport_recv_pkt() free's the skb, dropping the
> > +		 *    reference to the socket
> > +		 * 5. the socket closes, frees its reference to the net
> > +		 * 6. Finally, the worker for the second t->send_pkt() call
> > +		 *    processes the skb, and uses the now stale net pointer for
> > +		 *    socket lookups.
> > +		 *
> > +		 * To prevent this, we acquire a net reference in vsock_loopback_send_pkt()
> > +		 * and hold it until virtio_transport_recv_pkt() completes.
> > +		 *
> > +		 * Additionally, we must grab a reference on the skb before
> > +		 * calling virtio_transport_recv_pkt() to prevent it from
> > +		 * freeing the skb before we have a chance to release the net.
> > +		 */
> > +		net_mode = virtio_vsock_skb_net_mode(skb);
> > +		net = virtio_vsock_skb_net(skb);
> 
> Wait, we are adding those just for loopback (in theory used only for
> testing/debugging)? And only to support virtio_transport_reset_no_sock() use
> case?

Yes, exactly, only loopback + reset_no_sock(). The issue doesn't exist
for vhost-vsock because vhost_vsock holds a net reference, and it
doesn't exist for non-reset_no_sock calls because after looking up the
socket we transfer skb ownership to it, which holds down the skb -> sk ->
net reference chain.

> 
> Honestly I don't like this, do we have any alternative?
> 
> I'll also try to think something else.
> 
> Stefano


I've been thinking about this all morning... maybe
we can do something like this:

```

virtio_transport_recv_pkt(...,  struct sock *reply_sk) {... }

virtio_transport_reset_no_sock(..., reply_sk)
{
	if (reply_sk)
		skb_set_owner_sk_safe(reply, reply_sk)

	t->send_pkt(reply);
}

vsock_loopback_work(...)
{
	virtio_transport_recv_pkt(..., skb, skb->sk);
}


for other transports:

	virtio_transport_recv_pkt(..., skb, NULL);

```

This way 'reply' keeps the sk and sk->net alive even after
virtio_transport_recv_pkt() frees 'skb'. The net won't be released until
after 'reply' is freed back on the other side, removing the race.

It makes semantic sense too... for loopback, we already know which sk
the reply is going back to. For other transports, we don't because
they're across the virt boundary.

WDYT?

I hate to suggest this, but another option might be to just do nothing?
In order for this race to have any real effect, a loopback socket must
send a pkt to a non-existent socket, immediately close(), then the
namespace deleted, a new namespace created with the same pointer
address, and finally a new socket with the same port created in that
namespace, all before the reply RST reaches recv_pkt()... at which point
the newly created socket would wrongfully receive the RST.

Best,
Bobby

