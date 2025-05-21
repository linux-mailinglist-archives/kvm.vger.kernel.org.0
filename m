Return-Path: <kvm+bounces-47244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E375ABEEB6
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 10:57:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41DBE3AD5DE
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 08:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45D1238C3A;
	Wed, 21 May 2025 08:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FjL1ugxT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B30A238143
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 08:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747817845; cv=none; b=fQwH8yEKziOhK2A/5oyUNlsQZKcYZovVwADFO80tjzQ5JExY/ae6wUm9jrHBLxJC6zQ3mjJLHlC5gsQcv7+zt4+ZhOdch044PCgR9a2BMc9NiZLHXaKFqtBYhot47QiU+8H6i2bhnkdfzXyQCa9Xw2oZwaCe54hfD9TZxNtGFOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747817845; c=relaxed/simple;
	bh=/4i/nK+t1ryn5HGVFpM4RXNec1OC5YglYAfJmaJDfgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gmbyKcAAwbcYw4cH+tQmMA9Ec+GEIXm3mVG0SFks8mVcciHmzoKI4ykHrcnPztAY8ozFzu55ocPkqvBQiGdgoekk+9J8vHAfig7ejanh7fkxncOLBSVdMkxbZ5cqaeMwmAHCfYmh1QQTXa4dpLq3/kEn8NwXtDH8FdPq0SoO2/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FjL1ugxT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747817842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JfOqXSQo7CKTaqGd/jh9hve0GBvT5oZOukPMAeA+fDA=;
	b=FjL1ugxTH3mB0NHcSOlLf0DcMJ739OFBPsrD5Le6QB+0/5vc6WCQJa8NbGM21fo3yKmt0W
	WhKnsQtqheQk/Oucl/Fg4ZZUXfGyZG+uWz1QHgukQtKxj1iyi+Um2mei5oqgGBdcJu/o22
	deM0pIrCcQzlScApt23cWbi7RyxTCHw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-_RZTWgzMMHuJWqVlcr8cKQ-1; Wed, 21 May 2025 04:57:20 -0400
X-MC-Unique: _RZTWgzMMHuJWqVlcr8cKQ-1
X-Mimecast-MFC-AGG-ID: _RZTWgzMMHuJWqVlcr8cKQ_1747817839
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-acbbb0009aeso195030466b.1
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 01:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747817839; x=1748422639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JfOqXSQo7CKTaqGd/jh9hve0GBvT5oZOukPMAeA+fDA=;
        b=i7m7TMakas4E1E2f1eoOhH6j2pxOk6GDW2ni3zt3m8b1rm2jal2SRhJUcj0P2avNfg
         i2rnsbo/bCQvpvJdFbnsND1sUpMsD1WwilP3gLjHkr9jtviRjuCUxhLm1jESLW1IAUwh
         W12GnRDmSrbfWyDdyJHvWf3FjMQPXKglQ4ypfeXexHgGH07r4zgOtGNYBStbasn03rLx
         EW+ozFCR45BbYvYg9DkPkWZK6RcTdb2xU7dk+N/roH8TE5waywewBh2glApO7xWJSXua
         zCZN5CQ5/vC8BmKmtpNzUdya5XH946ExU6WyDzhO+9xm01B1801/oFaHvXj/DuFGOdPv
         EflA==
X-Forwarded-Encrypted: i=1; AJvYcCV4zBJ6VMme7N9pt33DZiZy2EllaHxKgWDe8v0w/5RXuO2djmQVubyqFwvgYHkPj7BVw8M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUIQgTxk9xi5yEFVLcuCxJ1P+wG0pOdG9ORSFJhHHKgwgAUL61
	CYnNccTDdvWHo8WwaZ3T6FohT/hfW+92qpch7oNp0w/4tEPpOvnMDgpGoGTxSmpHQqQ7XGVcQH6
	y27pzeoDuRsdYyp7k0FQ3irTRVaZQby0DURAXTGjNH4kSXY/rIS7OaA==
X-Gm-Gg: ASbGncvEOUIvLc8Pz2ojh0OMlixeMX582to1zY6A45DCbM/y4V8CQtaoXqBu8K498Rs
	MbBZwJkH1e6onwuzZ24s7dRLlNN3QhsLZY+Wen6zYEON1qovccpVyaumI84QxiyqB3L68RDERvr
	h3xdwi9rTS8Bfzx8dxMtQAylo7kjCncoeyBrx5ChbSe2I1qrFlRAplwXyFi8rKMTiVvWrmmrTxe
	uIPJOOCW/UMth+ySoGo4W3+EKlfP16VkDcmpQoHjPdYjuycaSNdXUHf6rY2ArUeis8jAt8INkZx
	elMxFejXOodLy7KqdtHJp1r5DExKlyzng78dR5OPPRZwsxGnGXmKNGZxww0c
X-Received: by 2002:a17:907:6d23:b0:ac1:ea29:4e63 with SMTP id a640c23a62f3a-ad52d54495amr1849744166b.26.1747817839317;
        Wed, 21 May 2025 01:57:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtnUdwERWpUNuT2ZQpVUSKe1pvNBlwNoQW+BT1WYvMhwywmwvGk8BSRk37JEWNFyWGGlv3dA==
X-Received: by 2002:a17:907:6d23:b0:ac1:ea29:4e63 with SMTP id a640c23a62f3a-ad52d54495amr1849740766b.26.1747817838661;
        Wed, 21 May 2025 01:57:18 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d047754sm858957766b.7.2025.05.21.01.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 01:57:17 -0700 (PDT)
Date: Wed, 21 May 2025 10:57:13 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: davem@davemloft.net, fupan.lfp@antgroup.com, jasowang@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com, 
	niuxuewei.nxw@antgroup.com, pabeni@redhat.com, stefanha@redhat.com, 
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH 2/3] vsock/virtio: Add SIOCINQ support for all virtio
 based transports
Message-ID: <bbn4lvdwh42m2zvi3rdyws66y5ulew32rchtz3kxirqlllkr63@7toa4tcepax3>
References: <ca3jkuttkt3yfdgcevp7s3ejrxx3ngkoyuopqw2k2dtgsqox7w@fhicoics2kiv>
 <20250521020613.3218651-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250521020613.3218651-1-niuxuewei.nxw@antgroup.com>

On Wed, May 21, 2025 at 10:06:13AM +0800, Xuewei Niu wrote:
>> On Mon, May 19, 2025 at 03:06:48PM +0800, Xuewei Niu wrote:
>> >The virtio_vsock_sock has a new field called bytes_unread as the return
>> >value of the SIOCINQ ioctl.
>> >
>> >Though the rx_bytes exists, we introduce a bytes_unread field to the
>> >virtio_vsock_sock struct. The reason is that it will not be updated
>> >until the skbuff is fully consumed, which causes inconsistency.
>> >
>> >The byte_unread is increased by the length of the skbuff when skbuff is
>> >enqueued, and it is decreased when dequeued.
>> >
>> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>> >---
>> > drivers/vhost/vsock.c                   |  1 +
>> > include/linux/virtio_vsock.h            |  2 ++
>> > net/vmw_vsock/virtio_transport.c        |  1 +
>> > net/vmw_vsock/virtio_transport_common.c | 17 +++++++++++++++++
>> > net/vmw_vsock/vsock_loopback.c          |  1 +
>> > 5 files changed, 22 insertions(+)
>> >
>> >diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> >index 802153e23073..0f20af6e5036 100644
>> >--- a/drivers/vhost/vsock.c
>> >+++ b/drivers/vhost/vsock.c
>> >@@ -452,6 +452,7 @@ static struct virtio_transport vhost_transport = {
>> > 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>> >
>> > 		.unsent_bytes             = virtio_transport_unsent_bytes,
>> >+		.unread_bytes             = virtio_transport_unread_bytes,
>> >
>> > 		.read_skb = virtio_transport_read_skb,
>> > 	},
>> >diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> >index 0387d64e2c66..0a7bd240113a 100644
>> >--- a/include/linux/virtio_vsock.h
>> >+++ b/include/linux/virtio_vsock.h
>> >@@ -142,6 +142,7 @@ struct virtio_vsock_sock {
>> > 	u32 buf_alloc;
>> > 	struct sk_buff_head rx_queue;
>> > 	u32 msg_count;
>> >+	size_t bytes_unread;
>>
>> Can we just use `rx_bytes` field we already have?
>>
>> Thanks,
>> Stefano
>
>I perfer not. The `rx_bytes` won't be updated until the skbuff is fully
>consumed, causing inconsistency issues. If it is acceptable to you, I'll
>reuse the field instead.

I think here we found a little pre-existing issue that should be related
also to what Arseniy (CCed) is trying to fix (low_rx_bytes).

We basically have 2 counters:
- rx_bytes, which we use internally to see if there are bytes to read
   and for sock_rcvlowat
- fwd_cnt, which we use instead for the credit mechanism and informing
   the other peer whether we have space or not

These are updated with virtio_transport_dec_rx_pkt() and 
virtio_transport_inc_rx_pkt()

As far as I can see, from the beginning, we call 
virtio_transport_dec_rx_pkt() only when we consume the entire packet.
This makes sense for `fwd_cnt`, because we still have occupied space in 
memory and we don't want to update the credit until we free all the 
space, but I think it makes no sense for `rx_bytes`, which is only used 
internally and should reflect the current situation of bytes to read.

So in my opinion we should fix it this way (untested):

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 11eae88c60fc..ee70cb114328 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -449,10 +449,10 @@ static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
  }

  static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
-					u32 len)
+					u32 bytes_read, u32 bytes_dequeued)
  {
-	vvs->rx_bytes -= len;
-	vvs->fwd_cnt += len;
+	vvs->rx_bytes -= bytes_read;
+	vvs->fwd_cnt += bytes_dequeued;
  }

  void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *skb)
@@ -581,11 +581,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
  				   size_t len)
  {
  	struct virtio_vsock_sock *vvs = vsk->trans;
-	size_t bytes, total = 0;
  	struct sk_buff *skb;
  	u32 fwd_cnt_delta;
  	bool low_rx_bytes;
  	int err = -EFAULT;
+	size_t total = 0;
  	u32 free_space;

  	spin_lock_bh(&vvs->rx_lock);
@@ -597,6 +597,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
  	}

  	while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
+		size_t bytes, dequeued = 0;
+
  		skb = skb_peek(&vvs->rx_queue);

  		bytes = min_t(size_t, len - total,
@@ -620,12 +622,12 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
  		VIRTIO_VSOCK_SKB_CB(skb)->offset += bytes;

  		if (skb->len == VIRTIO_VSOCK_SKB_CB(skb)->offset) {
-			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
-
-			virtio_transport_dec_rx_pkt(vvs, pkt_len);
+			dequeued = le32_to_cpu(virtio_vsock_hdr(skb)->len);
  			__skb_unlink(skb, &vvs->rx_queue);
  			consume_skb(skb);
  		}
+
+		virtio_transport_dec_rx_pkt(vvs, bytes, dequeued);
  	}

  	fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
@@ -782,7 +784,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
  				msg->msg_flags |= MSG_EOR;
  		}

-		virtio_transport_dec_rx_pkt(vvs, pkt_len);
+		virtio_transport_dec_rx_pkt(vvs, pkt_len, pkt_len);
  		vvs->bytes_unread -= pkt_len;
  		kfree_skb(skb);
  	}
@@ -1752,6 +1754,7 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
  	struct sock *sk = sk_vsock(vsk);
  	struct virtio_vsock_hdr *hdr;
  	struct sk_buff *skb;
+	u32 pkt_len;
  	int off = 0;
  	int err;

@@ -1769,7 +1772,8 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
  	if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)
  		vvs->msg_count--;

-	virtio_transport_dec_rx_pkt(vvs, le32_to_cpu(hdr->len));
+	pkt_len = le32_to_cpu(hdr->len);
+	virtio_transport_dec_rx_pkt(vvs, pkt_len, pkt_len);
  	spin_unlock_bh(&vvs->rx_lock);

  	virtio_transport_send_credit_update(vsk);

@Arseniy WDYT?
I will test it and send a proper patch.

@Xuewei with that fixed, I think you can use `rx_bytes`, right?

Also because you missed for example `virtio_transport_read_skb()` used 
by ebpf (see commit 3543152f2d33 ("vsock: Update rx_bytes on 
read_skb()")).

Thanks,
Stefano


