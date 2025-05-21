Return-Path: <kvm+bounces-47245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26DB1ABEECF
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 10:59:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09B3E7A5A7C
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 08:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 444A12376F7;
	Wed, 21 May 2025 08:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LGh9DoA4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42993238174
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 08:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747817935; cv=none; b=YlzOAQIqVFsU8z/g3x7Nx5x3PXCtesZqV1E+Jp2z9kM3KjySLs68RnjNv5EtAkNBoMxioue9uKIcAjD9s+YsaIZeYgxNmcbIe86Jrb2mlgXwMl8ctxBbrCBldjsZDINffwxbCp/LZ28Tvo6xNUqcM2A459/wimmh2EfSO4hjMG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747817935; c=relaxed/simple;
	bh=cLZbAH3cI8GYQszXgLGU9IFYoJPGHxcZkZ0FHMaI3Rg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PLF5D+0FV1TITB+sb9ZxlAw6WkusfrGDeO5KChTn/1fdcLCWicpjG18/7LGH39BtpTLAcpysbcS6ikI1eXCCuy7hCpFEtyZLgqFPfD67HbnCQFlHAfINUwfUX5A+2I/brkxkidAt1F3USu95aue9EyVw67i+FS/Hz66UqPYZQUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LGh9DoA4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747817932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eVISUslNkkC359wr6/5NqmJ9IWZFEQzKItzM+WQ542w=;
	b=LGh9DoA46FgbRoMNm0QAHGkVhRhC9EiwTfXlkaWC9btd4kPc5OiohoXRf3z4cNp3dp0sc/
	1sutdA3cfm/CznPtgKSNjt/FtyS1kn3QwHQTxQ1i6Qyn+YRLQa3Yx9DbL/WNT1K4Wexi5D
	eOU0QZ27FtgbKGOYny8x3lDbsO7nUbQ=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-194-edY7XRORO1i1A6MMovwAQw-1; Wed, 21 May 2025 04:58:51 -0400
X-MC-Unique: edY7XRORO1i1A6MMovwAQw-1
X-Mimecast-MFC-AGG-ID: edY7XRORO1i1A6MMovwAQw_1747817930
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-708aca58513so89300827b3.0
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 01:58:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747817930; x=1748422730;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eVISUslNkkC359wr6/5NqmJ9IWZFEQzKItzM+WQ542w=;
        b=ViQeIcAetpsb9tm1GQB83MmIoW5yoIJpXUz/jGRlhIFApQdKusg5B6PhCFYnFVXA1C
         oKuVKicZ+QBlakwC4aBScZzTewNIq5nPtFYG3HPUP3FRbwB/R/Ew090v1SwFHzXLJvmQ
         cIo7c+B1ng755EE3TsS4FPuRGkEi8LfMeoePeiX5cILnf8bqmPkA/palOLWNLX4v2+og
         C7D8JS23OhzXKugyBowMYLu7dZec2uo72TFZnp+gdHEQ357FpiwsbDiYdyTZr9/P9FDe
         X10zuINtiQ+8ZDO5trOcnpUT1K5xpBh6Lb25KF1x//RnWm3Tn0CKVyAsG+Fpn29q/iSW
         tVSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGcyKDKy5kB37iqcao3xtIzb5Ehss/omqTS9XuxNS6RdEGYRJVAJjHfVfWXwapAhuZ36w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAbQRtJTJCEkLCnnzMXJhke8UK6AbkIhH3QGe4mKF6vHdaKEpe
	zgNtTxwGr/5iJf4+l4ZeP/NmJ80Hhgo9OEp9m7DgGutFIknVmlVjxEWVgy/W2zNgU6f12JGspFN
	KRyLb7alrauPEK2Adi/WGm1xFnNdQwW6OYAwx8FjP4jcR+hOsiGDKDE0Ecmz5SzCqsEngKpDH54
	IfZ6o10He9qH2FQ/tQeTu1sS/f2LZJ
X-Gm-Gg: ASbGncvNJq70HzfXQUspJ45ihqszTyKzIwfD9GLmdPhPAJi0aGwmFHVZTSRJCVluSDv
	PVEkEmUIf5VJF6aYx3ShgQR+nfDgw+0CEQVP7Dxj72vcFwgLify11SbFr4QLZ9K8z2kE=
X-Received: by 2002:a05:690c:386:b0:709:1b68:9f5c with SMTP id 00721157ae682-70ca79efe56mr284490527b3.16.1747817930398;
        Wed, 21 May 2025 01:58:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbsmo76CHdnOR6GqD8MpHPXZmwbQT3nuKbnT5FlUWzjISwiCA3vCYiMP0N1f4gKVoMHCzEb54dGnO5DlBvWi4=
X-Received: by 2002:a05:690c:386:b0:709:1b68:9f5c with SMTP id
 00721157ae682-70ca79efe56mr284490257b3.16.1747817929934; Wed, 21 May 2025
 01:58:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ca3jkuttkt3yfdgcevp7s3ejrxx3ngkoyuopqw2k2dtgsqox7w@fhicoics2kiv>
 <20250521020613.3218651-1-niuxuewei.nxw@antgroup.com> <bbn4lvdwh42m2zvi3rdyws66y5ulew32rchtz3kxirqlllkr63@7toa4tcepax3>
In-Reply-To: <bbn4lvdwh42m2zvi3rdyws66y5ulew32rchtz3kxirqlllkr63@7toa4tcepax3>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Wed, 21 May 2025 10:58:38 +0200
X-Gm-Features: AX0GCFs5skc8nIzcPaCTdrKZN88iXmzsQVaSrJKyy593gFhRVNImi9lYzr9o8V4
Message-ID: <CAGxU2F78hGUarnzz8Mf1UUOHPQin_Mf4U=wX0nASzmNTr1A6+g@mail.gmail.com>
Subject: Re: [PATCH 2/3] vsock/virtio: Add SIOCINQ support for all virtio
 based transports
To: Xuewei Niu <niuxuewei97@gmail.com>, Krasnov Arseniy <Oxffffaa@gmail.com>
Cc: davem@davemloft.net, fupan.lfp@antgroup.com, jasowang@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com, 
	niuxuewei.nxw@antgroup.com, pabeni@redhat.com, stefanha@redhat.com, 
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"

Forgot to CC Arseniy.

On Wed, 21 May 2025 at 10:57, Stefano Garzarella <sgarzare@redhat.com> wrote:
>
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
> >> >            .notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
> >> >
> >> >            .unsent_bytes             = virtio_transport_unsent_bytes,
> >> >+           .unread_bytes             = virtio_transport_unread_bytes,
> >> >
> >> >            .read_skb = virtio_transport_read_skb,
> >> >    },
> >> >diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> >> >index 0387d64e2c66..0a7bd240113a 100644
> >> >--- a/include/linux/virtio_vsock.h
> >> >+++ b/include/linux/virtio_vsock.h
> >> >@@ -142,6 +142,7 @@ struct virtio_vsock_sock {
> >> >    u32 buf_alloc;
> >> >    struct sk_buff_head rx_queue;
> >> >    u32 msg_count;
> >> >+   size_t bytes_unread;
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
> -                                       u32 len)
> +                                       u32 bytes_read, u32 bytes_dequeued)
>   {
> -       vvs->rx_bytes -= len;
> -       vvs->fwd_cnt += len;
> +       vvs->rx_bytes -= bytes_read;
> +       vvs->fwd_cnt += bytes_dequeued;
>   }
>
>   void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *skb)
> @@ -581,11 +581,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>                                    size_t len)
>   {
>         struct virtio_vsock_sock *vvs = vsk->trans;
> -       size_t bytes, total = 0;
>         struct sk_buff *skb;
>         u32 fwd_cnt_delta;
>         bool low_rx_bytes;
>         int err = -EFAULT;
> +       size_t total = 0;
>         u32 free_space;
>
>         spin_lock_bh(&vvs->rx_lock);
> @@ -597,6 +597,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>         }
>
>         while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
> +               size_t bytes, dequeued = 0;
> +
>                 skb = skb_peek(&vvs->rx_queue);
>
>                 bytes = min_t(size_t, len - total,
> @@ -620,12 +622,12 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>                 VIRTIO_VSOCK_SKB_CB(skb)->offset += bytes;
>
>                 if (skb->len == VIRTIO_VSOCK_SKB_CB(skb)->offset) {
> -                       u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
> -
> -                       virtio_transport_dec_rx_pkt(vvs, pkt_len);
> +                       dequeued = le32_to_cpu(virtio_vsock_hdr(skb)->len);
>                         __skb_unlink(skb, &vvs->rx_queue);
>                         consume_skb(skb);
>                 }
> +
> +               virtio_transport_dec_rx_pkt(vvs, bytes, dequeued);
>         }
>
>         fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
> @@ -782,7 +784,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>                                 msg->msg_flags |= MSG_EOR;
>                 }
>
> -               virtio_transport_dec_rx_pkt(vvs, pkt_len);
> +               virtio_transport_dec_rx_pkt(vvs, pkt_len, pkt_len);
>                 vvs->bytes_unread -= pkt_len;
>                 kfree_skb(skb);
>         }
> @@ -1752,6 +1754,7 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
>         struct sock *sk = sk_vsock(vsk);
>         struct virtio_vsock_hdr *hdr;
>         struct sk_buff *skb;
> +       u32 pkt_len;
>         int off = 0;
>         int err;
>
> @@ -1769,7 +1772,8 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
>         if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)
>                 vvs->msg_count--;
>
> -       virtio_transport_dec_rx_pkt(vvs, le32_to_cpu(hdr->len));
> +       pkt_len = le32_to_cpu(hdr->len);
> +       virtio_transport_dec_rx_pkt(vvs, pkt_len, pkt_len);
>         spin_unlock_bh(&vvs->rx_lock);
>
>         virtio_transport_send_credit_update(vsk);
>
> @Arseniy WDYT?
> I will test it and send a proper patch.
>
> @Xuewei with that fixed, I think you can use `rx_bytes`, right?
>
> Also because you missed for example `virtio_transport_read_skb()` used
> by ebpf (see commit 3543152f2d33 ("vsock: Update rx_bytes on
> read_skb()")).
>
> Thanks,
> Stefano


