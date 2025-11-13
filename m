Return-Path: <kvm+bounces-63034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DC338C5972C
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 19:26:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 749DE350DA2
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 18:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66690359FAA;
	Thu, 13 Nov 2025 18:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j29f4Eqx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8877264614
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 18:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763058369; cv=none; b=R2xsllB5L+H7Y61S9hipqW7GN9KxxXOak+YPCy4y2WN7jiBGrKSH/XWWEjsnPZHDwTLx+xh/6SySfR2nYrFlajMxtjZGUAA/4Q+7ZGEi0SmWI+bzci8U5hupqiWv/xPJkZZJzjX/YcAJXkJ0bVnmS/Ap+ckY4XcD8ySLOtW7ltQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763058369; c=relaxed/simple;
	bh=NJWfzzFj8vgG4jgYe+zOfuZHD36yc5H5fI4S6VnrPoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZTNdSbR2ReN4pFFMpacT3Gv5OS6xeUlfIcCx+mWZcw9x6uQaeOk6rsKJIu/CdaBunl2wo3jyEs2L2FJJgHtS8Y56izCd8kwCBIF+Ek8IBTnkFiJEzVJVKGzINhDOaczFHQ9zMFmdk9cXj66J3/Hf27oqKQwDYZ+ue5TakjrtEGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j29f4Eqx; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71d71bcac45so11302777b3.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 10:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763058367; x=1763663167; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PWcA86QhcaogO/P79JJUHrKh+Hv3BICSCdLFq4V4bOY=;
        b=j29f4EqxVQsnNHPZTIc/ZsF6yW5nheZieAY0YTvbTNA7NcaGk9d5XL1LRU4cd4c5Vq
         TXhEfhVKNmJPSSq08CSZkOmOWW90xpA3KY3x1LBF7Yu6Cji8Ywn+Ndz/0e/bsDzmckDZ
         T07KoHeq0VKTMSx4mUKVNhP+g0zz8s+p7MPMZmicCEl8zo3DLgfiuk5m/fORYvKXAfre
         NsVzyZzDw3Aq24ke268hv0ft+8bvBc9HLoulFWNv3COzLNCQkY94bXCc7WWdN1Pw0YR+
         LM23D727zBohmrEq7Qi6Zz7m68KYloCKeELI+TXJpKF6ZgGYwWYroHAc4nG68CLQPkJ9
         RbGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763058367; x=1763663167;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PWcA86QhcaogO/P79JJUHrKh+Hv3BICSCdLFq4V4bOY=;
        b=kEjDhZx8Lobp7PYnVqS3SXWiyTwNugAZIpJjVVfd/U79E5rDCGSl3jjkj8dhki5S9s
         VQh7SmvEgN2UfZqHhyCfO93mM1Q/E1X1KkeXgyqqZ6eb2q22oGAW2S7H1PQA4IH44n7c
         e6riNmBBDFmyJ5loYzgelURJ9DHj9ebwLm9ZG2BVpPSU11A+hq1nvUxK9+ZcJNpj6L1V
         iIxg6h2dAmq2ECt1fTleClw5aNzQ3U+NdQtsbelrf/NR9P4SwHjX5NF5s7g8u08bdEz8
         dH1oCxmaReAoFtqmhHZqK/GSZE3LFkPmU+7xwP7yjdggVjJnIw88sTzbwBQAWD66p8AC
         hHzw==
X-Forwarded-Encrypted: i=1; AJvYcCWmkbto+zkBlTeLbCBQxIUM84T9aEcaBknqhx9JlLe77YEvAJDk0V+uHSA1Z1y3ujYq8Oo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgy1I6cxa7GwhDhIFz43c+YwuIAAvd7+ttxUMP/yM5s6LpCVyK
	bXB2uwpDgZArLGdnBGePm/n0B8vftOrf5jAKiWxXdub9ojDeMVy+/ivO
X-Gm-Gg: ASbGncvtEi6byxInHAtXJCzWzPuZ6OMZQbvKk6OKVwMy2vnqzCsrWNhPsrgW93Az0Dm
	o030CmL1mykLlxfulF7qWIs0Giprzl2+qPG2CjhZosz8eG8bjWqh8H7tbPLmTABTDExrOO8eQ4N
	T2xfwLAzg6nXgkAqtZlWk5ZdZiXdsfiwHlEc05U8UAr3Xy8t7JwwLYN5+5PtSmHgic2AmNtFGAL
	iwQluGbfPoc1E3HolwNXCbzdyAg9YZur8t4ZJvmLpsxJkt6lILu4ZPs1rc2OCDcqnYYlbn0Kmtr
	p+aLvCEEtLRFDbExo5cbCiHBvKGk0XKmzjCINw6kQhTW0DZfGd4lWwU9jVGFDuSE2Nek8gqiiRU
	IXE36NAg8X8yo039v8jFUW63A4tqzK/Wd1PC07H1az80zWu8YMBWMZdh9cYHGl2SdldkdgfEPjw
	8bR1Bhe8zkkEhr4LMaUbLGJ742O++umCI34HE=
X-Google-Smtp-Source: AGHT+IGv1NUbsmH0mBFSpcmwoDDPPls56gYuUVpN5OeRP+WyZcaWbsNJTzNc/oyC8pxSybEkxYaXCQ==
X-Received: by 2002:a05:690c:7008:b0:786:5f03:2b65 with SMTP id 00721157ae682-78929f09730mr3233697b3.33.1763058366513;
        Thu, 13 Nov 2025 10:26:06 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:6::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78821e76af5sm8637957b3.27.2025.11.13.10.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 10:26:06 -0800 (PST)
Date: Thu, 13 Nov 2025 10:26:04 -0800
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
Message-ID: <aRYivEKsa44u5Mh+@devvm11784.nha0.facebook.com>
References: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
 <20251111-vsock-vmtest-v9-6-852787a37bed@meta.com>
 <g6bxp6hketbjrddzni2ln37gsezqvxbu2orheorzh7fs66roll@hhcrgsos3ui3>
 <aRTRhk/ok06YKTEu@devvm11784.nha0.facebook.com>
 <g5dcyor4aryvtcnqxm5aekldbettetlmog3c7sj7sjx3yp2pgy@hcpxyubied2n>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g5dcyor4aryvtcnqxm5aekldbettetlmog3c7sj7sjx3yp2pgy@hcpxyubied2n>

On Thu, Nov 13, 2025 at 04:24:44PM +0100, Stefano Garzarella wrote:
> On Wed, Nov 12, 2025 at 10:27:18AM -0800, Bobby Eshleman wrote:
> > On Wed, Nov 12, 2025 at 03:19:47PM +0100, Stefano Garzarella wrote:
> > > On Tue, Nov 11, 2025 at 10:54:48PM -0800, Bobby Eshleman wrote:
> > > > From: Bobby Eshleman <bobbyeshleman@meta.com>
> > > >
> > > > Add NS support to vsock loopback. Sockets in a global mode netns
> > > > communicate with each other, regardless of namespace. Sockets in a local
> > > > mode netns may only communicate with other sockets within the same
> > > > namespace.
> > > >
> > > > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>

[...]

> > > > @@ -131,7 +136,41 @@ static void vsock_loopback_work(struct work_struct *work)
> > > > 		 */
> > > > 		virtio_transport_consume_skb_sent(skb, false);
> > > > 		virtio_transport_deliver_tap_pkt(skb);
> > > > -		virtio_transport_recv_pkt(&loopback_transport, skb, NULL, 0);
> > > > +
> > > > +		/* In the case of virtio_transport_reset_no_sock(), the skb
> > > > +		 * does not hold a reference on the socket, and so does not
> > > > +		 * transitively hold a reference on the net.
> > > > +		 *
> > > > +		 * There is an ABA race condition in this sequence:
> > > > +		 * 1. the sender sends a packet
> > > > +		 * 2. worker calls virtio_transport_recv_pkt(), using the
> > > > +		 *    sender's net
> > > > +		 * 3. virtio_transport_recv_pkt() uses t->send_pkt() passing the
> > > > +		 *    sender's net
> > > > +		 * 4. virtio_transport_recv_pkt() free's the skb, dropping the
> > > > +		 *    reference to the socket
> > > > +		 * 5. the socket closes, frees its reference to the net
> > > > +		 * 6. Finally, the worker for the second t->send_pkt() call
> > > > +		 *    processes the skb, and uses the now stale net pointer for
> > > > +		 *    socket lookups.
> > > > +		 *
> > > > +		 * To prevent this, we acquire a net reference in vsock_loopback_send_pkt()
> > > > +		 * and hold it until virtio_transport_recv_pkt() completes.
> > > > +		 *
> > > > +		 * Additionally, we must grab a reference on the skb before
> > > > +		 * calling virtio_transport_recv_pkt() to prevent it from
> > > > +		 * freeing the skb before we have a chance to release the net.
> > > > +		 */
> > > > +		net_mode = virtio_vsock_skb_net_mode(skb);
> > > > +		net = virtio_vsock_skb_net(skb);
> > > 
> > > Wait, we are adding those just for loopback (in theory used only for
> > > testing/debugging)? And only to support virtio_transport_reset_no_sock() use
> > > case?
> > 
> > Yes, exactly, only loopback + reset_no_sock(). The issue doesn't exist
> > for vhost-vsock because vhost_vsock holds a net reference, and it
> > doesn't exist for non-reset_no_sock calls because after looking up the
> > socket we transfer skb ownership to it, which holds down the skb -> sk ->
> > net reference chain.
> > 
> > > 
> > > Honestly I don't like this, do we have any alternative?
> > > 
> > > I'll also try to think something else.
> > > 
> > > Stefano
> > 
> > 
> > I've been thinking about this all morning... maybe
> > we can do something like this:
> > 
> > ```
> > 
> > virtio_transport_recv_pkt(...,  struct sock *reply_sk) {... }
> > 
> > virtio_transport_reset_no_sock(..., reply_sk)
> > {
> > 	if (reply_sk)
> > 		skb_set_owner_sk_safe(reply, reply_sk)
> 
> Interesting, but what about if we call skb_set_owner_sk_safe() in
> vsock_loopback.c just before calling virtio_transport_recv_pkt() for every
> skb?

I think the issue with this is that at the time vsock_loopback calls
virtio_transport_recv_pkt() the reply skb hasn't yet been allocated by
virtio_transport_reset_no_sock() and we can't wait for it to return
because the original skb may be freed by then.

We might be able to keep it all in vsock_loopback if we removed the need
to use the original skb or sk by just using the net. But to do that we
would need to add a netns_tracker per net somewhere. I guess that would
end up in a list or hashmap in struct vsock_loopback.

Another option that does simplify a little, but unfortunately still doesn't keep
everything in loopback:

@@ -1205,7 +1205,7 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 	if (!reply)
 		return -ENOMEM;
 
-	return t->send_pkt(reply, net, net_mode);
+	return t->send_pkt(reply, net, net_mode, skb->sk);
 }

@@ -27,11 +27,16 @@ static u32 vsock_loopback_get_local_cid(void)
 }

 static int vsock_loopback_send_pkt(struct sk_buff *skb, struct net *net,
-				   enum vsock_net_mode net_mode)
+				   enum vsock_net_mode net_mode,
+				   struct sock *rst_owner)
 {
 	struct vsock_loopback *vsock = &the_vsock_loopback;
 	int len = skb->len;
 
+	if (!skb->sk && rst_owner)
+		WARN_ONCE(!skb_set_owner_sk_safe(skb, rst_owner),
+			  "loopback socket has sk_refcnt == 0\n");
+
 	virtio_vsock_skb_queue_tail(&vsock->pkt_queue, skb);
 	queue_work(vsock->workqueue, &vsock->pkt_work);

> 
> Maybe we should refactor a bit virtio_transport_recv_pkt() e.g. moving
> `skb_set_owner_sk_safe()` to be sure it's called only when we are sure it's
> the right socket (e.g. after checking SOCK_DONE).
> 
> WDYT?

I agree, it is called a little prematurely.

Thanks,
Bobby

