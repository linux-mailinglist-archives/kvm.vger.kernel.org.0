Return-Path: <kvm+bounces-62903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A92C53D0C
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:58:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5F47C5053F1
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 17:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38CD347BD6;
	Wed, 12 Nov 2025 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DrfbWSze";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iVG3IgM5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6985A332EBA
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 17:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762969188; cv=none; b=Q0WJXG2kCKBd0tKk9AUpgChLVJRRo/dVI+5A4tFmMxNr2nPROOp4ErntM31nz3IietCeKPEYUkeUZ1Q6DXCd3R/v8J8wJz84KTG0+g4dZuVmuv4vzSv4Srngb9Ekt6hKdS2MmMqogzHM9XVbfEHpAMGF9Yg55amirAdwlhWL3ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762969188; c=relaxed/simple;
	bh=bkZUOAUvakniAPV+vo0c7Bkt+t3YVSp2SiPuB3IAi4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VLwwWqKk0dLuF1JRerWZDOpsar8wJKtAOqwDL68Ew96TmDypkurfZXb5Q7ilem7b1ov/UwZUxtywdZ8+5nu27IKcF1Mp9eJxY2vdKLgvZoVJyWoIw3bZdFOTmLuzH+e7ue4mligzodnMlWp5DuOrqePgvG9rmjxCTuzzVdV8nH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DrfbWSze; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iVG3IgM5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762969185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7w9Yc3Pve610BqQtVYIhjYyTWyKwfQashDRC0GkETz0=;
	b=DrfbWSze2QFZ+yReJUHivnsq30tRylXjAwaxG7GsV41daW3quNXMHiDU8Soh4qEZYLNOzn
	JI0oLF74cGVBDySX2yVFPxMX8osGF/zT8DhLrtlUVvaGx4pslZ8B8i2zZrjl2uytqwSMz3
	M57c++wVe/f1qN+/ADAykDH41kcdcCQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-z18gkuLVOjSm5VTiKHMSwg-1; Wed, 12 Nov 2025 12:39:44 -0500
X-MC-Unique: z18gkuLVOjSm5VTiKHMSwg-1
X-Mimecast-MFC-AGG-ID: z18gkuLVOjSm5VTiKHMSwg_1762969182
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b22ab98226so537366485a.2
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 09:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762969182; x=1763573982; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7w9Yc3Pve610BqQtVYIhjYyTWyKwfQashDRC0GkETz0=;
        b=iVG3IgM5LYQsDeKVFfqQ+CKhdMHHwxHrNZn6allcOF6nMpUegPBaAmJefR6tPqEIR+
         wzv2i7GVTwE7qvCJwJNtF6gzI51VcvnQW4BwkwXCC0JpoABStwtwl3DYWoJ5YK342T9p
         EloIBzHr5NXNds9Mu1d0aolRYiJiImbPbeUW23afh025X2YwKjMa6YHO2JOtq/vjP/yG
         z38E+riNVzSTa39/IveNaP4dq1h6z3unlVZbelnPYQZhqVgAQqr9+1h7JMlyEhMRA+iH
         t+mcj1KEBHmlcVZaPmyVW0glcgBGCeAMviGFzZQ3sRMb6BX1PlIS5trYZXO0kvJRuFXm
         ya1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762969182; x=1763573982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7w9Yc3Pve610BqQtVYIhjYyTWyKwfQashDRC0GkETz0=;
        b=m8GM7BQ/LQhkUAfxBcHiGRoWWMFlqM6fT8L16NL1eZeNncXcF9irc9jZSsRHXPLxIP
         ScPN5ddlg6Dp7jaWSUP1JFQB9ZbinHaK06rr09jFbB1MYf4ijiNW1fGQKUiy5bfYYuGx
         9VQdXiXzeWM2MXVpbWmRYA1R2BnLR8iEKzy3JrJrgSTz965OwE7QPSk/L3zhllv7MnQW
         7iGmc26Wdl54At++m34YXviSnKNz1hQMX8En+0F6KJDwrxmPrRogshEfSaPb3qi/w+e6
         +MX1sX+4QEwwmsBAjFAMIZy8+EqRqxfeIXAkv7QC76EeYcSCj3T6FGJO2HIfWTagQirT
         ZRLA==
X-Forwarded-Encrypted: i=1; AJvYcCU+AFUINlBS0gW4BlVI0UN4eYoNeO6PKhq90NmqBxEVR12whsc/XnOJW6UApudDTAnxdME=@vger.kernel.org
X-Gm-Message-State: AOJu0YztfySJurcv6S6RLRNqL7W4TbvvHPvm1UtgEJfmJ88/KcC1p8Ff
	+bhjUeZZKVBolyov0a6jOBWYsX6sol3y6a2iIOpb4XNPSUHZ87xL982o26vLNpXHmzp/Ib9rJ3O
	2Xcwrr4zGQWgK+HAhconN1R6kNFXje6I5Aqr5+57jfU9UHXCkjAcTLA==
X-Gm-Gg: ASbGncuQLXB/CCNZiqv7wGBmOhl6A1/O2OhhYtvlJMWeaYpXqK98pS6V4uhBO9Hn8En
	CVraEOpwkGBstLU4421RsP/VH6T1O6o6bbxpwWFfBQfFco+f8ewJyNWajNLo2x0vPDcdWU+917c
	4Ut1+kablbVdNv0sUugY1I/vMAZoX7JtbnS00X7z0ys7Fu8QLmmXdDaQ6FVUrrYGWC5Rqh03swP
	DDhR7xv0RH1y7Wg6znZAZOFlmcdTTVI7aqhTapzZQYXAcH88yFYQXUQIbRNev6P5mGAi8GHknbe
	juznkkPxxZzufSmC6/64OkMrqmTOVm0LqfdmD/7sW9/DqFmXgVCbx8Jwvz5U8nhBTo+jkv6Q62C
	4dVQZxOYZESMyqL8wElWJ5UFLrMhnuYxYQS9NXa5lVUyo1dtKYKg=
X-Received: by 2002:a05:622a:1209:b0:4e8:99f5:e331 with SMTP id d75a77b69052e-4eddbd9bb20mr56897221cf.60.1762969182266;
        Wed, 12 Nov 2025 09:39:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHWJycI8sVmnsa17OInLt0w2fsInYTjYimM7tusyBjLzya5sfsfjlUt75T1UCF7L9QTdzDrHA==
X-Received: by 2002:a05:622a:1209:b0:4e8:99f5:e331 with SMTP id d75a77b69052e-4eddbd9bb20mr56896551cf.60.1762969181690;
        Wed, 12 Nov 2025 09:39:41 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-153.retail.telecomitalia.it. [79.46.200.153])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88238b746f8sm95575216d6.45.2025.11.12.09.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 09:39:40 -0800 (PST)
Date: Wed, 12 Nov 2025 18:39:22 +0100
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
Subject: Re: [PATCH net-next v9 03/14] vsock/virtio: add netns support to
 virtio transport and virtio common
Message-ID: <bhc6s7anskmnnrnpp2r3xzjbesadsex24kmyi5tvsgup7c2rfi@arj4iw5ndnr3>
References: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
 <20251111-vsock-vmtest-v9-3-852787a37bed@meta.com>
 <cah4sqsqbdp52byutxngl3ko44kduesbhan6luhk3ukzml7bs6@hlv4ckunx7jj>
 <aRSyPqNo1LhqGLBq@devvm11784.nha0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aRSyPqNo1LhqGLBq@devvm11784.nha0.facebook.com>

On Wed, Nov 12, 2025 at 08:13:50AM -0800, Bobby Eshleman wrote:
>On Wed, Nov 12, 2025 at 03:18:42PM +0100, Stefano Garzarella wrote:
>> On Tue, Nov 11, 2025 at 10:54:45PM -0800, Bobby Eshleman wrote:
>> > From: Bobby Eshleman <bobbyeshleman@meta.com>
>> >
>> > Enable network namespace support in the virtio-vsock and common
>> > transport layer.
>> >
>> > The changes include:
>>
>> This list seems to have been generated by AI. I have nothing against it, but
>> I don't think it's important to list all the things that have changed, but
>> rather to explain why.
>
>Sounds good, I'll keep that in mind on why vs what. I have been
>experimenting with AI in my process, but sadly this list was mostly
>hand-rolled. I guess exhaustive listing is an over-correction for too
>sparse of commit messages on my part.
>
>>
>> > 1. Add a 'net' field to virtio_vsock_pkt_info to carry the namespace
>> >   pointer for outgoing packets.
>>
>> Why?
>>
>> > 2. Add 'net' and 'net_mode' to t->send_pkt() and
>> >   virtio_transport_recv_pkt() functions
>>
>> Why?
>>
>> > 3. Modify callback functions to accept placeholder values
>> >   (NULL and 0) for net and net_mode. The placeholders will be
>>
>> Why 0 ? I mean VSOCK_NET_MODE_GLOBAL is also 0, no?
>> So I don't understand if you want to specify an invalid value (like NULL) or
>> VSOCK_NET_MODE_GLOBAL.
>>
>> >   replaced when later patches in this series add namespace support
>> >   to transports.
>> > 4. Set virtio-vsock to global mode unconditionally, instead of using
>> >   placeholders. This is done in this patch because virtio-vsock won't
>> >   have any additional changes to choose the net/net_mode, unlike the
>> >   other transports. Same complexity as placeholders.
>> > 5. Pass net and net_mode to virtio_transport_reset_no_sock() directly.
>> >   This ensures that the outgoing RST packets are scoped based on the
>> >   namespace of the receiver of the failed request.
>>
>> "Receiver" is confusing IMO, see the comment on
>> virtio_transport_reset_no_sock().
>>
>> > 6. Pass net and net_mode to socket lookup functions using
>> >   vsock_find_{bound,connected}_socket_net().
>>
>> mmmm, are those functions working fine with the placeholders?
>
>They should resolve everything to global mode as this is why
>virtio-vsock does by the end of this series, but I didn't run the
>tests specifically on this patch.
>>
>> If it simplifies, I think we can eventually merge all changes to transports
>> that depends on virtio_transport_common in a single commit.
>> IMO is better to have working commits than better split.
>
>That would be so much easier. Much of this patch is just me trying to
>find a way to keep total patch size reasonably small for review... if
>having them all in one commit is preferred then that makes life easier.
>
>The answer to all of the above is that I was just trying to make the
>virtio_common changes in one place, but not break bisect/build by
>failing to update the transport-level call sites. So the placeholder
>values are primarily there to compile.

In theory, they should compile, but they should also properly behave.

BTW I strongly believe that having separate commits is a great thing, 
but we shouldn't take things to extremes and complicate our lives when 
things are too closely related, as in this case.

There is a clear dependency between these patches, so IMO, if the patch 
doesn't become huge, it's better to have everything together. (I mean 
between dependencies with virtio_transport_common).

What we could perhaps do is have an initial commit where you make the 
changes, but the behavior remains unchanged (continue to use global 
everywhere, as for virtio_transport.c in this patch), and then specific 
commits to just enable support for local/global.

Not sure if it's doable, but I'd like to remove the placeholders if 
possibile. Let's discuss more about it if there are issues.

>
>>
>> I mean, is this commit working (at runtime) well?
>
>In theory it should, but I only build checked it.
>
>> >
>> > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>> > ---
>> > Changes in v9:
>> > - include/virtio_vsock.h: send_pkt() cb takes net and net_mode
>> > - virtio_transport reset_no_sock() takes net and net_mode
>> > - vhost-vsock: add placeholders to recv_pkt() for compilation
>> > - loopback: add placeholders to recv_pkt() for compilation
>> > - remove skb->cb net/net_mode usage, pass as arguments to
>> >  t->send_pkt() and virtio_transport_recv_pkt() functions instead.
>> >  Note that skb->cb will still be used by loopback, but only internal
>> >  to loopback and never passing it to virtio common.
>> > - remove virtio_vsock_alloc_rx_skb(), it is not needed after removing
>> >  skb->cb usage.
>> > - pass net and net_mode to virtio_transport_reset_no_sock()
>> >
>> > Changes in v8:
>> > - add the virtio_vsock_alloc_rx_skb(), to be in same patch that fields
>> > are read (Stefano)
>> >
>> > Changes in v7:
>> > - add comment explaining the !vsk case in virtio_transport_alloc_skb()
>> > ---
>> > drivers/vhost/vsock.c                   |  6 ++--
>> > include/linux/virtio_vsock.h            |  8 +++--
>> > net/vmw_vsock/virtio_transport.c        | 10 ++++--
>> > net/vmw_vsock/virtio_transport_common.c | 57 ++++++++++++++++++++++++---------
>> > net/vmw_vsock/vsock_loopback.c          |  5 +--
>> > 5 files changed, 62 insertions(+), 24 deletions(-)
>> >
>> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> > index 34adf0cf9124..0a0e73405532 100644
>> > --- a/drivers/vhost/vsock.c
>> > +++ b/drivers/vhost/vsock.c
>> > @@ -269,7 +269,8 @@ static void vhost_transport_send_pkt_work(struct vhost_work *work)
>> > }
>> >
>> > static int
>> > -vhost_transport_send_pkt(struct sk_buff *skb)
>> > +vhost_transport_send_pkt(struct sk_buff *skb, struct net *net,
>> > +			 enum vsock_net_mode net_mode)
>> > {
>> > 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
>> > 	struct vhost_vsock *vsock;
>> > @@ -537,7 +538,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>> > 		if (le64_to_cpu(hdr->src_cid) == vsock->guest_cid &&
>> > 		    le64_to_cpu(hdr->dst_cid) ==
>> > 		    vhost_transport_get_local_cid())
>> > -			virtio_transport_recv_pkt(&vhost_transport, skb);
>> > +			virtio_transport_recv_pkt(&vhost_transport, skb, NULL,
>> > +						  0);
>> > 		else
>> > 			kfree_skb(skb);
>> >
>> > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> > index 0c67543a45c8..5ed6136a4ed4 100644
>> > --- a/include/linux/virtio_vsock.h
>> > +++ b/include/linux/virtio_vsock.h
>> > @@ -173,6 +173,8 @@ struct virtio_vsock_pkt_info {
>> > 	u32 remote_cid, remote_port;
>> > 	struct vsock_sock *vsk;
>> > 	struct msghdr *msg;
>> > +	struct net *net;
>> > +	enum vsock_net_mode net_mode;
>> > 	u32 pkt_len;
>> > 	u16 type;
>> > 	u16 op;
>> > @@ -185,7 +187,8 @@ struct virtio_transport {
>> > 	struct vsock_transport transport;
>> >
>> > 	/* Takes ownership of the packet */
>> > -	int (*send_pkt)(struct sk_buff *skb);
>> > +	int (*send_pkt)(struct sk_buff *skb, struct net *net,
>> > +			enum vsock_net_mode net_mode);
>> >
>> > 	/* Used in MSG_ZEROCOPY mode. Checks, that provided data
>> > 	 * (number of buffers) could be transmitted with zerocopy
>> > @@ -280,7 +283,8 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
>> > void virtio_transport_destruct(struct vsock_sock *vsk);
>> >
>> > void virtio_transport_recv_pkt(struct virtio_transport *t,
>> > -			       struct sk_buff *skb);
>> > +			       struct sk_buff *skb, struct net *net,
>> > +			       enum vsock_net_mode net_mode);
>> > void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *skb);
>> > u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 wanted);
>> > void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
>> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> > index f92f23be3f59..9395fd875823 100644
>> > --- a/net/vmw_vsock/virtio_transport.c
>> > +++ b/net/vmw_vsock/virtio_transport.c
>> > @@ -231,7 +231,8 @@ static int virtio_transport_send_skb_fast_path(struct virtio_vsock *vsock, struc
>> > }
>> >
>> > static int
>> > -virtio_transport_send_pkt(struct sk_buff *skb)
>> > +virtio_transport_send_pkt(struct sk_buff *skb, struct net *net,
>> > +			  enum vsock_net_mode net_mode)
>> > {
>> > 	struct virtio_vsock_hdr *hdr;
>> > 	struct virtio_vsock *vsock;
>> > @@ -660,7 +661,12 @@ static void virtio_transport_rx_work(struct work_struct *work)
>> > 				virtio_vsock_skb_put(skb, payload_len);
>> >
>> > 			virtio_transport_deliver_tap_pkt(skb);
>> > -			virtio_transport_recv_pkt(&virtio_transport, skb);
>> > +
>> > +			/* Force virtio-transport into global mode since it
>> > +			 * does not yet support local-mode namespacing.
>> > +			 */
>> > +			virtio_transport_recv_pkt(&virtio_transport, skb,
>> > +						  NULL, VSOCK_NET_MODE_GLOBAL);
>> > 		}
>> > 	} while (!virtqueue_enable_cb(vq));
>> >
>> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> > index dcc8a1d5851e..f4e09cb1567c 100644
>> > --- a/net/vmw_vsock/virtio_transport_common.c
>> > +++ b/net/vmw_vsock/virtio_transport_common.c
>> > @@ -413,7 +413,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>> >
>> > 		virtio_transport_inc_tx_pkt(vvs, skb);
>> >
>> > -		ret = t_ops->send_pkt(skb);
>> > +		ret = t_ops->send_pkt(skb, info->net, info->net_mode);
>> > 		if (ret < 0)
>> > 			break;
>> >
>> > @@ -527,6 +527,8 @@ static int virtio_transport_send_credit_update(struct vsock_sock *vsk)
>> > 	struct virtio_vsock_pkt_info info = {
>> > 		.op = VIRTIO_VSOCK_OP_CREDIT_UPDATE,
>> > 		.vsk = vsk,
>> > +		.net = sock_net(sk_vsock(vsk)),
>> > +		.net_mode = vsk->net_mode,
>> > 	};
>> >
>> > 	return virtio_transport_send_pkt_info(vsk, &info);
>> > @@ -1067,6 +1069,8 @@ int virtio_transport_connect(struct vsock_sock *vsk)
>> > 	struct virtio_vsock_pkt_info info = {
>> > 		.op = VIRTIO_VSOCK_OP_REQUEST,
>> > 		.vsk = vsk,
>> > +		.net = sock_net(sk_vsock(vsk)),
>> > +		.net_mode = vsk->net_mode,
>> > 	};
>> >
>> > 	return virtio_transport_send_pkt_info(vsk, &info);
>> > @@ -1082,6 +1086,8 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
>> > 			 (mode & SEND_SHUTDOWN ?
>> > 			  VIRTIO_VSOCK_SHUTDOWN_SEND : 0),
>> > 		.vsk = vsk,
>> > +		.net = sock_net(sk_vsock(vsk)),
>> > +		.net_mode = vsk->net_mode,
>> > 	};
>> >
>> > 	return virtio_transport_send_pkt_info(vsk, &info);
>> > @@ -1108,6 +1114,8 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
>> > 		.msg = msg,
>> > 		.pkt_len = len,
>> > 		.vsk = vsk,
>> > +		.net = sock_net(sk_vsock(vsk)),
>> > +		.net_mode = vsk->net_mode,
>> > 	};
>> >
>> > 	return virtio_transport_send_pkt_info(vsk, &info);
>> > @@ -1145,6 +1153,8 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
>> > 		.op = VIRTIO_VSOCK_OP_RST,
>> > 		.reply = !!skb,
>> > 		.vsk = vsk,
>> > +		.net = sock_net(sk_vsock(vsk)),
>> > +		.net_mode = vsk->net_mode,
>> > 	};
>> >
>> > 	/* Send RST only if the original pkt is not a RST pkt */
>> > @@ -1156,15 +1166,27 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
>> >
>> > /* Normally packets are associated with a socket.  There may be no socket if an
>> >  * attempt was made to connect to a socket that does not exist.
>> > + *
>> > + * net and net_mode refer to the net and mode of the receiving device (e.g.,
>> > + * vhost_vsock). For loopback, they refer to the sending socket net/mode. This
>> > + * way the RST packet is sent back to the same namespace as the bad request.
>>
>> Could this be a problem, should we split this function?
>>
>> BTW, I'm a bit confused. For vhost-vsock, this is the namespace of the
>> device, so the namespace of the guest, so also in that case the namespace of
>> the sender, no?
>>
>> Maybe sender/receiver are confusing. What you want to highlight with this
>> comment?
>>
>
>Sounds good, I'll try to update it with clarification. The namespace
>passed in needs to be the namespace of whoever sent the bad message.
>For vhost-vsock (and probably virtio-vsock eventually) that will be the
>device/guest namespace. For loopback, it is just the namespace of the
>socket that sent the bad message.

Yeah now is clear, thanks! So, IMO the `receiving device` was a bit 
confusing.

>
>> >  */
>> > static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
>> > -					  struct sk_buff *skb)
>> > +					  struct sk_buff *skb, struct net *net,
>> > +					  enum vsock_net_mode net_mode)
>> > {
>> > 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
>> > 	struct virtio_vsock_pkt_info info = {
>> > 		.op = VIRTIO_VSOCK_OP_RST,
>> > 		.type = le16_to_cpu(hdr->type),
>> > 		.reply = true,
>> > +
>> > +		/* net or net_mode are not defined here because we pass
>> > +		 * net and net_mode directly to t->send_pkt(), instead of
>> > +		 * relying on virtio_transport_send_pkt_info() to pass them to
>> > +		 * t->send_pkt(). They are not needed by
>> > +		 * virtio_transport_alloc_skb().
>> > +		 */
>> > 	};
>> > 	struct sk_buff *reply;
>> >
>> > @@ -1183,7 +1205,7 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
>> > 	if (!reply)
>> > 		return -ENOMEM;
>> >
>> > -	return t->send_pkt(reply);
>> > +	return t->send_pkt(reply, net, net_mode);
>> > }
>> >
>> > /* This function should be called with sk_lock held and SOCK_DONE set */
>> > @@ -1465,6 +1487,8 @@ virtio_transport_send_response(struct vsock_sock *vsk,
>> > 		.remote_port = le32_to_cpu(hdr->src_port),
>> > 		.reply = true,
>> > 		.vsk = vsk,
>> > +		.net = sock_net(sk_vsock(vsk)),
>> > +		.net_mode = vsk->net_mode,
>> > 	};
>> >
>> > 	return virtio_transport_send_pkt_info(vsk, &info);
>> > @@ -1507,12 +1531,12 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
>> > 	int ret;
>> >
>> > 	if (le16_to_cpu(hdr->op) != VIRTIO_VSOCK_OP_REQUEST) {
>> > -		virtio_transport_reset_no_sock(t, skb);
>> > +		virtio_transport_reset_no_sock(t, skb, sock_net(sk), vsk->net_mode);
>> > 		return -EINVAL;
>> > 	}
>> >
>> > 	if (sk_acceptq_is_full(sk)) {
>> > -		virtio_transport_reset_no_sock(t, skb);
>> > +		virtio_transport_reset_no_sock(t, skb, sock_net(sk), vsk->net_mode);
>> > 		return -ENOMEM;
>> > 	}
>> >
>> > @@ -1520,13 +1544,13 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
>> > 	 * Subsequent enqueues would lead to a memory leak.
>> > 	 */
>> > 	if (sk->sk_shutdown == SHUTDOWN_MASK) {
>> > -		virtio_transport_reset_no_sock(t, skb);
>> > +		virtio_transport_reset_no_sock(t, skb, sock_net(sk), vsk->net_mode);
>> > 		return -ESHUTDOWN;
>> > 	}
>> >
>> > 	child = vsock_create_connected(sk);
>> > 	if (!child) {
>> > -		virtio_transport_reset_no_sock(t, skb);
>> > +		virtio_transport_reset_no_sock(t, skb, sock_net(sk), vsk->net_mode);
>> > 		return -ENOMEM;
>> > 	}
>> >
>> > @@ -1548,7 +1572,7 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
>> > 	 */
>> > 	if (ret || vchild->transport != &t->transport) {
>> > 		release_sock(child);
>> > -		virtio_transport_reset_no_sock(t, skb);
>> > +		virtio_transport_reset_no_sock(t, skb, sock_net(sk), vsk->net_mode);
>> > 		sock_put(child);
>> > 		return ret;
>> > 	}
>> > @@ -1576,7 +1600,8 @@ static bool virtio_transport_valid_type(u16 type)
>> >  * lock.
>> >  */
>> > void virtio_transport_recv_pkt(struct virtio_transport *t,
>> > -			       struct sk_buff *skb)
>> > +			       struct sk_buff *skb, struct net *net,
>> > +			       enum vsock_net_mode net_mode)
>> > {
>> > 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
>> > 	struct sockaddr_vm src, dst;
>> > @@ -1599,24 +1624,24 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>> > 					le32_to_cpu(hdr->fwd_cnt));
>> >
>> > 	if (!virtio_transport_valid_type(le16_to_cpu(hdr->type))) {
>> > -		(void)virtio_transport_reset_no_sock(t, skb);
>> > +		(void)virtio_transport_reset_no_sock(t, skb, net, net_mode);
>> > 		goto free_pkt;
>> > 	}
>> >
>> > 	/* The socket must be in connected or bound table
>> > 	 * otherwise send reset back
>> > 	 */
>> > -	sk = vsock_find_connected_socket(&src, &dst);
>> > +	sk = vsock_find_connected_socket_net(&src, &dst, net, net_mode);
>>
>> Here `net` can be null, right? Is this okay?
>>
>
>Yes, it can be null. net_eq() comparisons pointers (returns false), and
>then the modes evaluate w/ GLOBAL == GLOBAL.
>
>This goes away if we combine patches though.

I see, thanks!
Stefano


