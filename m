Return-Path: <kvm+bounces-47338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD0FAC0256
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 04:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74EC71B66E51
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 02:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B32B76025;
	Thu, 22 May 2025 02:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3ZQPctC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00641854;
	Thu, 22 May 2025 02:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747880134; cv=none; b=MNsR4ePVG4wEkRCQyPdiqS1JQHA6G9LU8SzhbGb+t3/a2z3mQoZjmzARXOw2YSEJmPg23qbqUl9R4rC8fxv3wDU9kRQ8LFL4cYjsL5mUmnCzGaUmECOx7IgndmfXOBbFryUyKcDc+9osj3NqBtPLqFAU1zuRovQIlzaME7C+0rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747880134; c=relaxed/simple;
	bh=oSahH06uVmwCsq+yHzJyH1D2BdQZvaZfL9Gd9mn8ALw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=unu6cgPVLrK7cXLUfSK1jk7Uky1xxV6oWAtBXKVCbl7auWfPRnbeIjRdrBLVp7WjiUfQ9aQF+yARoZhVW/AOY8/bnR/tfKphcT2ORh1Y4lUVCUkvqDrcL6iT2yMovn7U+NgAg0+XBB1SZ1fiyxcAdVQZg2niVnvGHnQm87PzBXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O3ZQPctC; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-231fd67a9aeso42236585ad.1;
        Wed, 21 May 2025 19:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747880132; x=1748484932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=smLItdwum/8I9JeK/ur2YCvKvfD6GUpMkvynImLJvVA=;
        b=O3ZQPctC+iN9ZpA3mVDIk63CJ7lzCYbXM8rxm0CgioeA6lQ5C2eywmkkvnQlW0QG3t
         uxIB3D9jmzcxa/1U3xqr2SERaiCQIl01wRqr3Hpg06H6OCnA4RDBM8X0amQk+71jE7P2
         faEGTgJoYABIg/jUzWA0SI0YNqvEqa+8Cw5RQ4Bdc9bMf7/RXx9DYfnCbWdXBBPPzwXV
         LES+8diFrXgFPXtke0LKcdcc8vJ9mov9QQCPs25Hz5AONT+Qtsc7Nalv4S9603SgKWyY
         9QVIcoi7S0Emd/sCyLrkb2tMdaV7OkDsNlA6UihsyRX5zinnLGSEMPbMKozedsf/VEU9
         yG/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747880132; x=1748484932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=smLItdwum/8I9JeK/ur2YCvKvfD6GUpMkvynImLJvVA=;
        b=QAZshU6tYxes5jsDPlaRzIOh6+FlhowteYRJQpkFatB61b6I5M/dZt0G+2MsZmnlIa
         Wx7reXHgAhk9BBOJXL69MixUoOd/c2HBNZOFBvVaME3wqWCejzCqRY5UTnkawKlL9APo
         pZ2OPrl6WR1zy9bNfdubfw8m6IvBHnKtnX/zGO9biRR5ucEQruIksUnQqch1JgA1SeZz
         O+0zSZr7/R9vKUZcMhnaWHjm6vaTZm1uj8m5q9KDOch23zOoF4y3DsCCBJs2VeAPAQ/R
         i5Pv3zqBFJiTYRyOyad1s0ui0B4mG/hF50g0tvT6cfic29WovyBiiicSWto9QaAGLoOh
         zj3g==
X-Forwarded-Encrypted: i=1; AJvYcCUfM/P0CkhmeTDV6T+Zgv8tKPcVMTUAwFDx4JkOI3VT8O1K57a5c0e/gk01N4YSrdDvmG8=@vger.kernel.org, AJvYcCWb8VXYg8tO7Br3aK1+mKpe+1SVliCZuOMJnhy5bhiXVQb6uTpk0raxiUrZOhHUwAv6RW/xR0VXAF6625sr@vger.kernel.org
X-Gm-Message-State: AOJu0YwFuNIQQ4tzhQURVZJECQ/I2pKR/GOHqbT6AXwi4zsHX5H9WjA/
	2xLKxL+KAV8CL5H1crJ6IGiseNk9hc30vzdMr0ncwS6/H+qQR2z0GMwl
X-Gm-Gg: ASbGncviTOhjC1xxdivcLhzVKxgdS/D/awR8/wSaGAZnurqxvZofXsMDHKZ03XNkPRW
	Y248dhx0WcR3qzSurF5MerCJIm4ndwF+LiBPaxpJo2Ra8j+r8isN0UiaQEbwHLTIT76/E0folvw
	XQzDGj5SGzm4CaK1SHf8Ai/VVMuPlq6yHX35bGTy4nVp8UGqY/u/wvvegpVVyzLdXg6YUTWMVhi
	saj3bZyfNU4stgcscePE/yNP98MtpGbKW+5TRoPnGvwC4V0wIjvfPRgAqcZ3ltJoStONrYHgzjR
	ORzPa8aPo0Ecnr8+arHcVGuGysqfscMsY9LkGa/dBfmrpxjJJS1hY/LmT49zvNhWtL77uoJIAg=
	=
X-Google-Smtp-Source: AGHT+IG7zVAceghA234kavxhxXs1Ej2SW/BsPc7sDi/3WNlt3zuydIdWGwrVWK9FvQkB11RhnirMSg==
X-Received: by 2002:a17:902:d484:b0:231:e413:986c with SMTP id d9443c01a7336-231e4139adamr290367545ad.11.1747880131556;
        Wed, 21 May 2025 19:15:31 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4adbfecsm99377425ad.76.2025.05.21.19.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 19:15:31 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net,
	fupan.lfp@antgroup.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH 2/3] vsock/virtio: Add SIOCINQ support for all virtio based transports
Date: Thu, 22 May 2025 10:15:18 +0800
Message-Id: <20250522021519.3362114-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <bbn4lvdwh42m2zvi3rdyws66y5ulew32rchtz3kxirqlllkr63@7toa4tcepax3>
References: <bbn4lvdwh42m2zvi3rdyws66y5ulew32rchtz3kxirqlllkr63@7toa4tcepax3>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Wed, May 21, 2025 at 10:06:13AM +0800, Xuewei Niu wrote:
> >> On Mon, May 19, 2025 at 03:06:48PM +0800, Xuewei Niu wrote:
> >> >The virtio_vsock_sock has a new field called bytes_unread as the return
> >> >value of the SIOCINQ ioctl.
> >> >
> >> >Though the rx_bytes exists, we introduce a bytes_unread field to the
> >> >virtio_vsock_sock struct. The reason is that it will not be updated
> >> >until the skbuff is fully consumed, which causes inconsistency.
> >> >
> >> >The byte_unread is increased by the length of the skbuff when skbuff is
> >> >enqueued, and it is decreased when dequeued.
> >> >
> >> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> >> >---
> >> > drivers/vhost/vsock.c                   |  1 +
> >> > include/linux/virtio_vsock.h            |  2 ++
> >> > net/vmw_vsock/virtio_transport.c        |  1 +
> >> > net/vmw_vsock/virtio_transport_common.c | 17 +++++++++++++++++
> >> > net/vmw_vsock/vsock_loopback.c          |  1 +
> >> > 5 files changed, 22 insertions(+)
> >> >
> >> >diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> >> >index 802153e23073..0f20af6e5036 100644
> >> >--- a/drivers/vhost/vsock.c
> >> >+++ b/drivers/vhost/vsock.c
> >> >@@ -452,6 +452,7 @@ static struct virtio_transport vhost_transport = {
> >> > 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
> >> >
> >> > 		.unsent_bytes             = virtio_transport_unsent_bytes,
> >> >+		.unread_bytes             = virtio_transport_unread_bytes,
> >> >
> >> > 		.read_skb = virtio_transport_read_skb,
> >> > 	},
> >> >diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> >> >index 0387d64e2c66..0a7bd240113a 100644
> >> >--- a/include/linux/virtio_vsock.h
> >> >+++ b/include/linux/virtio_vsock.h
> >> >@@ -142,6 +142,7 @@ struct virtio_vsock_sock {
> >> > 	u32 buf_alloc;
> >> > 	struct sk_buff_head rx_queue;
> >> > 	u32 msg_count;
> >> >+	size_t bytes_unread;
> >>
> >> Can we just use `rx_bytes` field we already have?
> >>
> >> Thanks,
> >> Stefano
> >
> >I perfer not. The `rx_bytes` won't be updated until the skbuff is fully
> >consumed, causing inconsistency issues. If it is acceptable to you, I'll
> >reuse the field instead.
> 
> I think here we found a little pre-existing issue that should be related
> also to what Arseniy (CCed) is trying to fix (low_rx_bytes).
> 
> We basically have 2 counters:
> - rx_bytes, which we use internally to see if there are bytes to read
>    and for sock_rcvlowat
> - fwd_cnt, which we use instead for the credit mechanism and informing
>    the other peer whether we have space or not
> 
> These are updated with virtio_transport_dec_rx_pkt() and 
> virtio_transport_inc_rx_pkt()
> 
> As far as I can see, from the beginning, we call 
> virtio_transport_dec_rx_pkt() only when we consume the entire packet.
> This makes sense for `fwd_cnt`, because we still have occupied space in 
> memory and we don't want to update the credit until we free all the 
> space, but I think it makes no sense for `rx_bytes`, which is only used 
> internally and should reflect the current situation of bytes to read.
> 
> So in my opinion we should fix it this way (untested):
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 11eae88c60fc..ee70cb114328 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -449,10 +449,10 @@ static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
>   }
> 
>   static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
> -					u32 len)
> +					u32 bytes_read, u32 bytes_dequeued)
>   {
> -	vvs->rx_bytes -= len;
> -	vvs->fwd_cnt += len;
> +	vvs->rx_bytes -= bytes_read;
> +	vvs->fwd_cnt += bytes_dequeued;
>   }
> 
>   void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *skb)
> @@ -581,11 +581,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>   				   size_t len)
>   {
>   	struct virtio_vsock_sock *vvs = vsk->trans;
> -	size_t bytes, total = 0;
>   	struct sk_buff *skb;
>   	u32 fwd_cnt_delta;
>   	bool low_rx_bytes;
>   	int err = -EFAULT;
> +	size_t total = 0;
>   	u32 free_space;
> 
>   	spin_lock_bh(&vvs->rx_lock);
> @@ -597,6 +597,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>   	}
> 
>   	while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
> +		size_t bytes, dequeued = 0;
> +
>   		skb = skb_peek(&vvs->rx_queue);
> 
>   		bytes = min_t(size_t, len - total,
> @@ -620,12 +622,12 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>   		VIRTIO_VSOCK_SKB_CB(skb)->offset += bytes;
> 
>   		if (skb->len == VIRTIO_VSOCK_SKB_CB(skb)->offset) {
> -			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
> -
> -			virtio_transport_dec_rx_pkt(vvs, pkt_len);
> +			dequeued = le32_to_cpu(virtio_vsock_hdr(skb)->len);
>   			__skb_unlink(skb, &vvs->rx_queue);
>   			consume_skb(skb);
>   		}
> +
> +		virtio_transport_dec_rx_pkt(vvs, bytes, dequeued);
>   	}
> 
>   	fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
> @@ -782,7 +784,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>   				msg->msg_flags |= MSG_EOR;
>   		}
> 
> -		virtio_transport_dec_rx_pkt(vvs, pkt_len);
> +		virtio_transport_dec_rx_pkt(vvs, pkt_len, pkt_len);
>   		vvs->bytes_unread -= pkt_len;
>   		kfree_skb(skb);
>   	}
> @@ -1752,6 +1754,7 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
>   	struct sock *sk = sk_vsock(vsk);
>   	struct virtio_vsock_hdr *hdr;
>   	struct sk_buff *skb;
> +	u32 pkt_len;
>   	int off = 0;
>   	int err;
> 
> @@ -1769,7 +1772,8 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
>   	if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)
>   		vvs->msg_count--;
> 
> -	virtio_transport_dec_rx_pkt(vvs, le32_to_cpu(hdr->len));
> +	pkt_len = le32_to_cpu(hdr->len);
> +	virtio_transport_dec_rx_pkt(vvs, pkt_len, pkt_len);
>   	spin_unlock_bh(&vvs->rx_lock);
> 
>   	virtio_transport_send_credit_update(vsk);
> 
> @Arseniy WDYT?
> I will test it and send a proper patch.
> 
> @Xuewei with that fixed, I think you can use `rx_bytes`, right?

I've seen your patch, and looks good to me. This will greatly simplify the
SIOCINQ ioctl implementation. I'll rework after your patch gets merged.

Thanks,
Xuewei

> Also because you missed for example `virtio_transport_read_skb()` used 
> by ebpf (see commit 3543152f2d33 ("vsock: Update rx_bytes on 
> read_skb()")).
> 
> Thanks,
> Stefano

