Return-Path: <kvm+bounces-63346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC43C632DA
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:33:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 86A2434F116
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 09:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95ED23271E5;
	Mon, 17 Nov 2025 09:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dTL8eZMC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dutEJfAN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C2732692B
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 09:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763371640; cv=none; b=PVYPFpqz36oyZlTWMUf3KN7eegy1v92BY/O+TPNss/a1OyR+JP+IiPK1Y8QR6ebOsOBtH2fF6SWH/UqrPAGhjG6B4v23ZMmdVHt9M7y66I9/aqBmH62ijz/8n9a5pBAYOenBF421yEScJ7KwHkSUiOS7gmO0BqLJv5+nbL8SDlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763371640; c=relaxed/simple;
	bh=p/mOhX5wU5TPg1ebgo1inWvk1dt88qml9Q0+hRWvaJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d7RQafWr0WJnRGSswODkglQn12OpOunXGedjOOlrexBqHKk2LcbZQBAffqvJq747VPDQr9na7U7EZ/D02cQV/11jp+xZCs80c/HraSckYSMqq7ajpvWBskjNHfG2a1sNKl+PXIjsNg0jFplELlHLyzz5Fbcdgv8Yyzk/hSuWffA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dTL8eZMC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dutEJfAN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763371637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dQqnpRSsfBU0PL63czO3vH9zmSpTVYGkOah3QsIuznM=;
	b=dTL8eZMCZDHlXzsu63Jqk0kYR+Ek9TqEG3PDnqScMEMdV4amlC/LlkEtYgP1wM/1RpS9Sq
	Pwaq2rNjw3mQnAcyPQd1o853ekIJkENJ+R96DTlBjGwriDHc///lPi7+cl98yuY6js3Rr9
	GorX7mkJ14tqQMN4ThLqdwLagi+791E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-qoZBPO5DPNSLNHVbQysZow-1; Mon, 17 Nov 2025 04:27:16 -0500
X-MC-Unique: qoZBPO5DPNSLNHVbQysZow-1
X-Mimecast-MFC-AGG-ID: qoZBPO5DPNSLNHVbQysZow_1763371635
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-40cfb98eddbso2389767f8f.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 01:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763371635; x=1763976435; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dQqnpRSsfBU0PL63czO3vH9zmSpTVYGkOah3QsIuznM=;
        b=dutEJfANB7fdI1knh/J2a9D5PVXlx9BE0+B9U5g5YOQJ+z0svt+uLvF5PWDj/3R4Hm
         XvQc7bjy5GMTW97IV6UpqOaWRPdDnI8Bg3B5w3blF1pyL/rgtpLV1w8im6cRzf61tmDh
         0iuywxLAzFKCPN/HHT8dQM+ZfQxQZ42nOMH9DyC5OLNcYlTFOZFWsLarQrvfOqa8GoBp
         zkYzYqZFX31LEqDfegfBpPZQ5FRckVkV6Wd3+UE9qz0ZdBlRc6J4v5hrfMUQzZXoVH31
         wgLw1XRvTk5Q6+sjDrWQ8kGJJQs+MkStBnTBhdZHiX+eZAvy4nBtrkNyyUiE2kCJDt0i
         k7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763371635; x=1763976435;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dQqnpRSsfBU0PL63czO3vH9zmSpTVYGkOah3QsIuznM=;
        b=H4dfJeGXNjY/P0bRH4rgNcAbaNgLxyon1CPVCvp8BhrDt5Yr1nuIUcLm9xK8NCOznU
         KysfbeN5Z6kSLe1yFmuYMtWraG3RHLXuWB68+OArk9YiSvpidswOmHL5sHriUWsZ81PI
         /djmhm0MVudy6VysYVkTSqH0DNY3gIVmuQdaS9NdjKoY8b1SkWDG3w5LsXfYeWmGg9vc
         VFH35E9qc70ADdh1mU3X6crJ4mUSVpDlstTp+QUmHLQ33uRuq8HI/LrquEURowr4cb/Q
         eiUlRhmVmLQZbldmwmBqeDdUsKvebyQQLdb8eYQ9Hxaw4WZaFMr+f6taqQkHU4S149Vt
         LKvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXMnCfOsMt8uHL6U/qRpVDUm7VadwflkAm56AoCx/OpGAXcT8U08RDLe5r5EqJD92MnkU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm6Try9QUzsZoqChFZ4K/wLQ6mqLHwztNH8eGF9F0lFkIhvKJd
	DHNKCPIfvoytZWftiW7b2CwNlLKIAZ2Shvg4a4i7DT/weqkQLSc31jntdpg0nMsgZWXSYvn8kqt
	ifbTCGX8tKFj4pbdAbFB/JikLay/734woCIusH1VFeR/eSF+16Xhczg==
X-Gm-Gg: ASbGnctOnmZDQteiy1EGZNP+Z+IjEGDzKIu97dIYcuIBCloBF5zf0u1mNtUHBnRfaoP
	Jnf0K/kvn1qUK443wcnKOQG4PF9K25QrXfVnUyf/msRMtsyXFTcqJoCgK8XfYEtuVOPnNHY+Nu8
	C5ueqRPLQbrcH2Fm37Azyy0M2bWDAitB6Rn4dOryFhxQF6gFDUGCuiYn43VUjrOuI2aE/2BQ78k
	lcc6t9Veuqzsw7IddOX7bOykeX5RTAfi3hi6T46hn663NFzlLpIFFhztp0saTQ3qwZku2xNkVZK
	tUOhfowykh2bRFpUD8P0vjE6Gj6LTov0AJ0d3GYZ5V2Y/b+4PxzgS0D6Qh9EEcC1dmKdGgZhuXY
	17zAOVSqGe/NNhh7NDxOJCUBbrHP9vDz/DDj3COBRfd769xsvYbg=
X-Received: by 2002:a05:6000:2c13:b0:429:eb80:11f5 with SMTP id ffacd0b85a97d-42b52844470mr15024946f8f.26.1763371634612;
        Mon, 17 Nov 2025 01:27:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEOfAeOwT64wQfDszMuYE9w8CzeegX6YU8PZBJXsP9KBtQpKpQ5VM0qnMs29giIOIDG2ykJgw==
X-Received: by 2002:a05:6000:2c13:b0:429:eb80:11f5 with SMTP id ffacd0b85a97d-42b52844470mr15024903f8f.26.1763371634074;
        Mon, 17 Nov 2025 01:27:14 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-153.retail.telecomitalia.it. [79.46.200.153])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e91f2dsm25732564f8f.19.2025.11.17.01.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 01:27:11 -0800 (PST)
Date: Mon, 17 Nov 2025 10:27:00 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>, berrange@redhat.com, 
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v9 06/14] vsock/loopback: add netns support
Message-ID: <i43cna2w32sysezh6v7b7qkl543g2danbv3kctfwnpcxlfo2oq@b6of2fd27pu6>
References: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
 <20251111-vsock-vmtest-v9-6-852787a37bed@meta.com>
 <g6bxp6hketbjrddzni2ln37gsezqvxbu2orheorzh7fs66roll@hhcrgsos3ui3>
 <aRTRhk/ok06YKTEu@devvm11784.nha0.facebook.com>
 <g5dcyor4aryvtcnqxm5aekldbettetlmog3c7sj7sjx3yp2pgy@hcpxyubied2n>
 <aRYivEKsa44u5Mh+@devvm11784.nha0.facebook.com>
 <kwgjzpxxqpkgwafydp65vlj6jlf7h7kcnhwgtwrrhzp2qtgkkq@z3xfl26ejspl>
 <aRepp4Weuhaxgn6W@devvm11784.nha0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aRepp4Weuhaxgn6W@devvm11784.nha0.facebook.com>

On Fri, Nov 14, 2025 at 02:13:59PM -0800, Bobby Eshleman wrote:
>On Fri, Nov 14, 2025 at 10:33:42AM +0100, Stefano Garzarella wrote:
>> On Thu, Nov 13, 2025 at 10:26:04AM -0800, Bobby Eshleman wrote:
>> > On Thu, Nov 13, 2025 at 04:24:44PM +0100, Stefano Garzarella wrote:
>> > > On Wed, Nov 12, 2025 at 10:27:18AM -0800, Bobby Eshleman wrote:
>> > > > On Wed, Nov 12, 2025 at 03:19:47PM +0100, Stefano Garzarella wrote:
>> > > > > On Tue, Nov 11, 2025 at 10:54:48PM -0800, Bobby Eshleman wrote:
>> > > > > > From: Bobby Eshleman <bobbyeshleman@meta.com>
>> > > > > >
>> > > > > > Add NS support to vsock loopback. Sockets in a global mode netns
>> > > > > > communicate with each other, regardless of namespace. Sockets in a local
>> > > > > > mode netns may only communicate with other sockets within the same
>> > > > > > namespace.
>> > > > > >
>> > > > > > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>> >
>> > [...]
>> >
>> > > > > > @@ -131,7 +136,41 @@ static void vsock_loopback_work(struct work_struct *work)
>> > > > > > 		 */
>> > > > > > 		virtio_transport_consume_skb_sent(skb, false);
>> > > > > > 		virtio_transport_deliver_tap_pkt(skb);
>> > > > > > -		virtio_transport_recv_pkt(&loopback_transport, skb, NULL, 0);
>> > > > > > +
>> > > > > > +		/* In the case of virtio_transport_reset_no_sock(), the skb
>> > > > > > +		 * does not hold a reference on the socket, and so does not
>> > > > > > +		 * transitively hold a reference on the net.
>> > > > > > +		 *
>> > > > > > +		 * There is an ABA race condition in this sequence:
>> > > > > > +		 * 1. the sender sends a packet
>> > > > > > +		 * 2. worker calls virtio_transport_recv_pkt(), using the
>> > > > > > +		 *    sender's net
>> > > > > > +		 * 3. virtio_transport_recv_pkt() uses t->send_pkt() passing the
>> > > > > > +		 *    sender's net
>> > > > > > +		 * 4. virtio_transport_recv_pkt() free's the skb, dropping the
>> > > > > > +		 *    reference to the socket
>> > > > > > +		 * 5. the socket closes, frees its reference to the net
>> > > > > > +		 * 6. Finally, the worker for the second t->send_pkt() call
>> > > > > > +		 *    processes the skb, and uses the now stale net pointer for
>> > > > > > +		 *    socket lookups.
>> > > > > > +		 *
>> > > > > > +		 * To prevent this, we acquire a net reference in vsock_loopback_send_pkt()
>> > > > > > +		 * and hold it until virtio_transport_recv_pkt() completes.
>> > > > > > +		 *
>> > > > > > +		 * Additionally, we must grab a reference on the skb before
>> > > > > > +		 * calling virtio_transport_recv_pkt() to prevent it from
>> > > > > > +		 * freeing the skb before we have a chance to release the net.
>> > > > > > +		 */
>> > > > > > +		net_mode = virtio_vsock_skb_net_mode(skb);
>> > > > > > +		net = virtio_vsock_skb_net(skb);
>> > > > >
>> > > > > Wait, we are adding those just for loopback (in theory used only for
>> > > > > testing/debugging)? And only to support virtio_transport_reset_no_sock() use
>> > > > > case?
>> > > >
>> > > > Yes, exactly, only loopback + reset_no_sock(). The issue doesn't exist
>> > > > for vhost-vsock because vhost_vsock holds a net reference, and it
>> > > > doesn't exist for non-reset_no_sock calls because after looking up the
>> > > > socket we transfer skb ownership to it, which holds down the skb -> sk ->
>> > > > net reference chain.
>> > > >
>> > > > >
>> > > > > Honestly I don't like this, do we have any alternative?
>> > > > >
>> > > > > I'll also try to think something else.
>> > > > >
>> > > > > Stefano
>> > > >
>> > > >
>> > > > I've been thinking about this all morning... maybe
>> > > > we can do something like this:
>> > > >
>> > > > ```
>> > > >
>> > > > virtio_transport_recv_pkt(...,  struct sock *reply_sk) {... }
>> > > >
>> > > > virtio_transport_reset_no_sock(..., reply_sk)
>> > > > {
>> > > > 	if (reply_sk)
>> > > > 		skb_set_owner_sk_safe(reply, reply_sk)
>> > >
>> > > Interesting, but what about if we call skb_set_owner_sk_safe() in
>> > > vsock_loopback.c just before calling virtio_transport_recv_pkt() for every
>> > > skb?
>> >
>> > I think the issue with this is that at the time vsock_loopback calls
>> > virtio_transport_recv_pkt() the reply skb hasn't yet been allocated by
>> > virtio_transport_reset_no_sock() and we can't wait for it to return
>> > because the original skb may be freed by then.
>>
>> Right!
>>
>> >
>> > We might be able to keep it all in vsock_loopback if we removed the need
>> > to use the original skb or sk by just using the net. But to do that we
>> > would need to add a netns_tracker per net somewhere. I guess that would
>> > end up in a list or hashmap in struct vsock_loopback.
>> >
>> > Another option that does simplify a little, but unfortunately still doesn't keep
>> > everything in loopback:
>> >
>> > @@ -1205,7 +1205,7 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
>> > 	if (!reply)
>> > 		return -ENOMEM;
>> >
>> > -	return t->send_pkt(reply, net, net_mode);
>> > +	return t->send_pkt(reply, net, net_mode, skb->sk);
>> > }
>> >
>> > @@ -27,11 +27,16 @@ static u32 vsock_loopback_get_local_cid(void)
>> > }
>> >
>> > static int vsock_loopback_send_pkt(struct sk_buff *skb, struct net *net,
>> > -				   enum vsock_net_mode net_mode)
>> > +				   enum vsock_net_mode net_mode,
>> > +				   struct sock *rst_owner)
>> > {
>> > 	struct vsock_loopback *vsock = &the_vsock_loopback;
>> > 	int len = skb->len;
>> >
>> > +	if (!skb->sk && rst_owner)
>> > +		WARN_ONCE(!skb_set_owner_sk_safe(skb, rst_owner),
>> > +			  "loopback socket has sk_refcnt == 0\n");
>> > +
>>
>> This doesn't seem too bad IMO, but at this point, why we can't do that
>> in virtio_transport_reset_no_sock() for any kind of transport?
>>
>> I mean, in any case the RST packet should be handled by the same net of the
>> "sender", no?
>>
>> At this point, can we just put the `vsk` of the sender in the `info` and
>> virtio_transport_alloc_skb() will already do that.
>>
>> WDYT?
>> Am I missing something?
>
>This is the right answer... I'm pretty sure this works out-of-the-box
>for all transports.

I hope too, but I was worried there was something hidden, even though it 
should make sense. Anyway, I would make this change in a separate patch, 
explaining our reasoning clearly (that reset packets should be 
associated with the sending socket, etc.), so that if we find something 
wrong in the future, we can revert it if necessary.

>
>I'll implement it and report back with a new rev if all good or come
>back to this thread to discuss if any issues arise.
>
>Have a good weekend!

I did :-) hope it was good for you too!

Ciao,
Stefano


