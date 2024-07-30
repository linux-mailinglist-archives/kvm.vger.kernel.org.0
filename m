Return-Path: <kvm+bounces-22535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 927C0940275
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 02:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 113831F2384D
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 00:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB7436FB0;
	Tue, 30 Jul 2024 00:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RFwlrUTV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794AA7E1;
	Tue, 30 Jul 2024 00:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299715; cv=none; b=gUW8q9yw81I9CLH/0a0m9C3a9hsVkbB6nhqh3ZCVys+pBAmz3eBSFL1Pr/bzegiwy+smMJZCLvUEOsg9HP8atTllzh2RQhk2wWlkNk5XNfI8vlKZMl8wrVo3bgOFjW/s0bkqFnPGSYmoj/esbMSz2coAU2A2lLSBkjYmXXRWt7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299715; c=relaxed/simple;
	bh=d/kFBuKQNh0Q9UbIyHywcyGbDWYA2LZn99Y1/6hKjlw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p0+SgYJV8CqCLH1i2tBpYmNE1yos43KM18H8KUjh30rr9LUir54lfzivCj8Ene8bn2i8OrSCd9hDCLwwmsT/YV2BLsTnH4K5WOKaXEUn2WmnvH2/QEX9PqApxpQfDx8JLhiewvnd6zcYUVQ9pCVC//OU103XpwfVx+6AvJsidHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RFwlrUTV; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e0b7efa1c1bso1719824276.3;
        Mon, 29 Jul 2024 17:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722299712; x=1722904512; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XQC8o6WuYV9zIhufZ9MsbGx/4n9VJXXESMMI8zl3XZ8=;
        b=RFwlrUTV57LWzKZZ5eEp+XD/BQxqFecJxZBzP4GktCjTfnL3kAYNd5urccsXl+Ecdn
         FVck9+m++60EG2X53LeRoBnQrFZ3+tdl4K8SDTjthQyqEOxy3dxPzwLyTng3ktp3W4WW
         NqIWLtHlntCK6oKxVBvGh8RP4T1pWjeOPaCF2AdnoDsmIxQAC7Hg/VfSYHen3ktmIR0u
         UYG25RvOleW1o5XT1P4eTF7ncZ7ziAKaEjir47aykLKA/Lnn8BQ38CnIu1y6hfXG0Von
         sg7ktvDYkeIm3QQ8vJsrnaTsTqrwkoR964es+TOwmGd/vD9Hx3KZ416YMYM3H6rAlezO
         qXuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722299712; x=1722904512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQC8o6WuYV9zIhufZ9MsbGx/4n9VJXXESMMI8zl3XZ8=;
        b=Tqad26LSz9wW01JZjHpDzbxs26zH9yM7PItf9dut5E5yIl0Lnds/Fyk8PYfKK7w9W1
         4RfEzVWpadwlJVvsJarEGUYER1/428u73+SqgNNG+0ogFiVdPxtB/ffOWuEy7KcFvZR7
         524qZ88FTJqdX2eSPQmQspNculbkxFkY1WKmJk67Ql6+PUQtXBQZPw2yMQHoVOxpCfFO
         5ZvGSuuyDnvadd4dokFOWx2ePq2AOql855XdIjkSeGtanNp/9ZHo0u640gENYNZXPwOI
         cTgBlgXZwfghIX5rjvPna2G5p3tMwZdpvRUK5ex8vMXQ71+j3Jo+IhQdjve5PjHN1+Oz
         Dn9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWVZ7n7BwaXhtoNs1dIWdvR2CWueG92JHHNT+rfyrG/eF1ZHNKCUd6A+rfR5ySsefHzJqrlsqaysccWid+/Ib4lnPLhultN1rdkr2RsXGjfzyu+XFAtFMEWufZoLuFi/KD2nB3K8mAqqHRxrJEACy6ysVOyoHkbuet+2GkDSDYqjc6DUKil49c861NFCK4KOeAFXyWElhvD47A4kn8jYGcrAmEN6YVzPu7U9BX3
X-Gm-Message-State: AOJu0Yy8oJK+yDl25CSX5ZydC1tUEG24ktquy3tD26mlSl1NS2RypmKC
	NVK22q7ViyMhHpl19eFH/7f4CmCgsS/iA/jxYDfhLsabgfQ96j1s/j04Aipo2NSzHyTv/Is3Ml9
	QbBCwxTwliJ+A1wtVMiu4tsSpbSY=
X-Google-Smtp-Source: AGHT+IFQjYAiuUNdG3Z25QWxW/dvCFzkKCQJekH2WlgkA5EDri9u87GttBOpsXZ4ybgaGUzALcovMGKdNQVJv65VoNw=
X-Received: by 2002:a05:6902:10cd:b0:e08:5b14:dfb4 with SMTP id
 3f1490d57ef6-e0b545f178bmr10382412276.55.1722299712320; Mon, 29 Jul 2024
 17:35:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
 <20240710212555.1617795-10-amery.hung@bytedance.com> <ldyfzp5k2qmhlydflu7biz6bcrekothacitzgbmw2k264zwuxh@hmgoku5kgghp>
In-Reply-To: <ldyfzp5k2qmhlydflu7biz6bcrekothacitzgbmw2k264zwuxh@hmgoku5kgghp>
From: Amery Hung <ameryhung@gmail.com>
Date: Mon, 29 Jul 2024 17:35:01 -0700
Message-ID: <CAMB2axNx=nCh-B-=XLtto2nEsKsV0p+b7yzXRX9OKSgUbRzzWA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v6 09/14] virtio/vsock: add common datagram
 recv path
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, kys@microsoft.com, haiyangz@microsoft.com, 
	wei.liu@kernel.org, decui@microsoft.com, bryantan@vmware.com, 
	vdasa@vmware.com, pv-drivers@vmware.com, dan.carpenter@linaro.org, 
	simon.horman@corigine.com, oxffffaa@gmail.com, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	bpf@vger.kernel.org, bobby.eshleman@bytedance.com, jiang.wang@bytedance.com, 
	amery.hung@bytedance.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2024 at 7:42=E2=80=AFAM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> On Wed, Jul 10, 2024 at 09:25:50PM GMT, Amery Hung wrote:
> >From: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >
> >This commit adds the common datagram receive functionality for virtio
> >transports. It does not add the vhost/virtio users of that
> >functionality.
> >
> >This functionality includes:
> >- changes to the virtio_transport_recv_pkt() path for finding the
> >  bound socket receiver for incoming packets
> >- virtio_transport_recv_pkt() saves the source cid and port to the
> >  control buffer for recvmsg() to initialize sockaddr_vm structure
> >  when using datagram
> >
> >Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >Signed-off-by: Amery Hung <amery.hung@bytedance.com>
> >---
> > net/vmw_vsock/virtio_transport_common.c | 79 +++++++++++++++++++++----
> > 1 file changed, 66 insertions(+), 13 deletions(-)
> >
> >diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/vir=
tio_transport_common.c
> >index 46cd1807f8e3..a571b575fde9 100644
> >--- a/net/vmw_vsock/virtio_transport_common.c
> >+++ b/net/vmw_vsock/virtio_transport_common.c
> >@@ -235,7 +235,9 @@ EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
> >
> > static u16 virtio_transport_get_type(struct sock *sk)
> > {
> >-      if (sk->sk_type =3D=3D SOCK_STREAM)
> >+      if (sk->sk_type =3D=3D SOCK_DGRAM)
> >+              return VIRTIO_VSOCK_TYPE_DGRAM;
> >+      else if (sk->sk_type =3D=3D SOCK_STREAM)
> >               return VIRTIO_VSOCK_TYPE_STREAM;
> >       else
> >               return VIRTIO_VSOCK_TYPE_SEQPACKET;
> >@@ -1422,6 +1424,33 @@ virtio_transport_recv_enqueue(struct vsock_sock *=
vsk,
> >               kfree_skb(skb);
> > }
> >
> >+static void
> >+virtio_transport_dgram_kfree_skb(struct sk_buff *skb, int err)
> >+{
> >+      if (err =3D=3D -ENOMEM)
> >+              kfree_skb_reason(skb, SKB_DROP_REASON_SOCKET_RCVBUFF);
> >+      else if (err =3D=3D -ENOBUFS)
> >+              kfree_skb_reason(skb, SKB_DROP_REASON_PROTO_MEM);
> >+      else
> >+              kfree_skb(skb);
> >+}
> >+
> >+/* This function takes ownership of the skb.
> >+ *
> >+ * It either places the skb on the sk_receive_queue or frees it.
> >+ */
> >+static void
> >+virtio_transport_recv_dgram(struct sock *sk, struct sk_buff *skb)
> >+{
> >+      int err;
> >+
> >+      err =3D sock_queue_rcv_skb(sk, skb);
> >+      if (err) {
> >+              virtio_transport_dgram_kfree_skb(skb, err);
> >+              return;
> >+      }
> >+}
> >+
> > static int
> > virtio_transport_recv_connected(struct sock *sk,
> >                               struct sk_buff *skb)
> >@@ -1591,7 +1620,8 @@ virtio_transport_recv_listen(struct sock *sk, stru=
ct sk_buff *skb,
> > static bool virtio_transport_valid_type(u16 type)
> > {
> >       return (type =3D=3D VIRTIO_VSOCK_TYPE_STREAM) ||
> >-             (type =3D=3D VIRTIO_VSOCK_TYPE_SEQPACKET);
> >+             (type =3D=3D VIRTIO_VSOCK_TYPE_SEQPACKET) ||
> >+             (type =3D=3D VIRTIO_VSOCK_TYPE_DGRAM);
> > }
> >
> > /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->=
mutex
> >@@ -1601,44 +1631,57 @@ void virtio_transport_recv_pkt(struct virtio_tra=
nsport *t,
> >                              struct sk_buff *skb)
> > {
> >       struct virtio_vsock_hdr *hdr =3D virtio_vsock_hdr(skb);
> >+      struct vsock_skb_cb *vsock_cb;
>
> This can be defined in the block where it's used.
>

Got it.

> >       struct sockaddr_vm src, dst;
> >       struct vsock_sock *vsk;
> >       struct sock *sk;
> >       bool space_available;
> >+      u16 type;
> >
> >       vsock_addr_init(&src, le64_to_cpu(hdr->src_cid),
> >                       le32_to_cpu(hdr->src_port));
> >       vsock_addr_init(&dst, le64_to_cpu(hdr->dst_cid),
> >                       le32_to_cpu(hdr->dst_port));
> >
> >+      type =3D le16_to_cpu(hdr->type);
> >+
> >       trace_virtio_transport_recv_pkt(src.svm_cid, src.svm_port,
> >                                       dst.svm_cid, dst.svm_port,
> >                                       le32_to_cpu(hdr->len),
> >-                                      le16_to_cpu(hdr->type),
> >+                                      type,
> >                                       le16_to_cpu(hdr->op),
> >                                       le32_to_cpu(hdr->flags),
> >                                       le32_to_cpu(hdr->buf_alloc),
> >                                       le32_to_cpu(hdr->fwd_cnt));
> >
> >-      if (!virtio_transport_valid_type(le16_to_cpu(hdr->type))) {
> >+      if (!virtio_transport_valid_type(type)) {
> >               (void)virtio_transport_reset_no_sock(t, skb);
> >               goto free_pkt;
> >       }
> >
> >-      /* The socket must be in connected or bound table
> >-       * otherwise send reset back
> >+      /* For stream/seqpacket, the socket must be in connected or bound=
 table
> >+       * otherwise send reset back.
> >+       *
> >+       * For datagrams, no reset is sent back.
> >        */
> >       sk =3D vsock_find_connected_socket(&src, &dst);
> >       if (!sk) {
> >-              sk =3D vsock_find_bound_socket(&dst);
> >-              if (!sk) {
> >-                      (void)virtio_transport_reset_no_sock(t, skb);
> >-                      goto free_pkt;
> >+              if (type =3D=3D VIRTIO_VSOCK_TYPE_DGRAM) {
> >+                      sk =3D vsock_find_bound_dgram_socket(&dst);
> >+                      if (!sk)
> >+                              goto free_pkt;
> >+              } else {
> >+                      sk =3D vsock_find_bound_socket(&dst);
> >+                      if (!sk) {
> >+                              (void)virtio_transport_reset_no_sock(t, s=
kb);
> >+                              goto free_pkt;
> >+                      }
> >               }
> >       }
> >
> >-      if (virtio_transport_get_type(sk) !=3D le16_to_cpu(hdr->type)) {
> >-              (void)virtio_transport_reset_no_sock(t, skb);
> >+      if (virtio_transport_get_type(sk) !=3D type) {
> >+              if (type !=3D VIRTIO_VSOCK_TYPE_DGRAM)
> >+                      (void)virtio_transport_reset_no_sock(t, skb);
> >               sock_put(sk);
> >               goto free_pkt;
> >       }
> >@@ -1654,12 +1697,21 @@ void virtio_transport_recv_pkt(struct virtio_tra=
nsport *t,
> >
> >       /* Check if sk has been closed before lock_sock */
> >       if (sock_flag(sk, SOCK_DONE)) {
> >-              (void)virtio_transport_reset_no_sock(t, skb);
> >+              if (type !=3D VIRTIO_VSOCK_TYPE_DGRAM)
> >+                      (void)virtio_transport_reset_no_sock(t, skb);
> >               release_sock(sk);
> >               sock_put(sk);
> >               goto free_pkt;
> >       }
> >
> >+      if (sk->sk_type =3D=3D SOCK_DGRAM) {
> >+              vsock_cb =3D vsock_skb_cb(skb);
> >+              vsock_cb->src_cid =3D src.svm_cid;
> >+              vsock_cb->src_port =3D src.svm_port;
> >+              virtio_transport_recv_dgram(sk, skb);
>
>
> What about adding an API that transports can use to hide this?
>
> I mean something that hide vsock_cb creation and queue packet in the
> socket receive queue. I'd also not expose vsock_skb_cb in an header, but
> I'd handle it internally in af_vsock.c. So I'd just expose API to
> queue/dequeue them.
>

Got it. I will move vsock_skb_cb to af_vsock.c and create an API:

vsock_dgram_skb_save_src_addr(struct sk_buff *skb, u32 cid, u32 port)

Different dgram implementations will call this API instead of the code
block above to save the source address information into the control
buffer.

A side note on why this is a vsock API instead of a member function in
transport: As we move to support multi-transport dgram, different
transport implementations can place skb into the sk->sk_receive_queue.
Therefore, we cannot call transport-specific function in
vsock_dgram_recvmsg() to initialize struct sockaddr_vm. Hence, the
receiving paths of different transports need to call this API to save
source address.

> Also why VMCI is using sk_receive_skb(), while we are using
> sock_queue_rcv_skb()?
>

I _think_ originally we referred to UDP and UDS when designing virtio
dgram, and ended up with placing skb into sk_receive_queue directly. I
will look into this to provide better justification.

Thank you,
Amery

> Thanks,
> Stefano
>
> >+              goto out;
> >+      }
> >+
> >       space_available =3D virtio_transport_space_update(sk, skb);
> >
> >       /* Update CID in case it has changed after a transport reset even=
t */
> >@@ -1691,6 +1743,7 @@ void virtio_transport_recv_pkt(struct virtio_trans=
port *t,
> >               break;
> >       }
> >
> >+out:
> >       release_sock(sk);
> >
> >       /* Release refcnt obtained when we fetched this socket out of the
> >--
> >2.20.1
> >
>

