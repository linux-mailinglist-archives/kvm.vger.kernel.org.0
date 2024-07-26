Return-Path: <kvm+bounces-22361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB9C793DB24
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 01:22:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 444BC1F23BA4
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 23:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8977A153808;
	Fri, 26 Jul 2024 23:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a/nL+KNw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B26314036F;
	Fri, 26 Jul 2024 23:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722036149; cv=none; b=gd4pYc37WiKgyHwac254kwGoY6Wq2raxFKHh1z9QuGEME4BNpsu7OYAPLFagb0SVOTYkoVgkJYvzBSvnxmMA21ngHuYJmeBIMuTlLnJncg4QwrdbsS2LBXSpHhNoCxCZmKGaO8nxS0c+MGBTgSaLASD+VgPlH4VBeUJ0bOiUS2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722036149; c=relaxed/simple;
	bh=QTihwxKdNfbuodKGhHZUu2S0sWalLUNdFqu3G+fz6vs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zt1dby+YLE2W2uQWBjBsox9qqnuc7HOrgKVU/ZQ8/byubQxoYQH/blbwjbQL3RbGYnvrC0TJlLjfwrGjOp3WlwBPFbUCRu0BadM7SnayKHtMaQBLzVpflK7u+1iv7h5ZP0gbVm/5m5IUlb6JBPqds3SJyaaWh7McyyT1tGcxY88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a/nL+KNw; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e05e4c3228bso211066276.0;
        Fri, 26 Jul 2024 16:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722036147; x=1722640947; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2v48RWsL/8+kJWmWAAV3oUELstcaxL2EQr9QFsJ90o4=;
        b=a/nL+KNw9ML5A2GdrNinB6CBn4ErDspZR2Z8JpFRBPpsV4ZGf0OS7pHKCFhbdwPIBo
         GPNmgfDEDSroql4m+iTQud4F/s8l8hgnVBCwhnLpN/4vp7TlQ0EN3einUX7Gi1qbhzdA
         lKXSfxXkjFfRCVwfCSWKyvz1zXsIVQf0CXpslhpRPHQpz9ExrO41t3vqoy2RMKqgU5yG
         1DIqzkM52y8MHnfLWbTawG29gZrg1fgga5+cT+4JPE8ItwMPZ9c7Uwx7LB5IJexltqkZ
         9COSLyGk3i0Aek4QQI86v09r8impkexxd2qOF9YZbI4e/SyinxORrRNQW+F0wqwOxY5T
         5Y0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722036147; x=1722640947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2v48RWsL/8+kJWmWAAV3oUELstcaxL2EQr9QFsJ90o4=;
        b=DZjuKtJ7Fm57LwiyeATFl4L/F6FAG0+ZkjOKg2BhcqYJKgcVstYED4uXSTQliV91Va
         e54xe4AlLRTv3LbWJgAuuPST6joRi2uEiAaYrTTO1+CUMbMDlgJCdpkB7DW42hYYx26L
         50NnVV5P6E2tx20QoIlYN8aSiNUBN9Rql88YcwzVmmV+WEL9e0YL6onJRjjhO8o6/pNN
         S58yoTNJHIHyIG8ml1zpNJ8ZqR+NGKW9zuV8YLOcGNdWj39Q0k7hwj1+bt56Mj3bs7Hh
         uXdX/X/YV6Kucf/0tHAY2XVM8aFaG0YAjFOsUyCiNqjrfMHNOhSBhbEdXweRz4DWhUGQ
         LHbw==
X-Forwarded-Encrypted: i=1; AJvYcCUA0r5TyuSJ4SP33okGS0ghSy26pcaURA5CJuf5h6qVc7epLP4Kga0H4+9g9fnndjkhmsV9zNWvVCNS0QDYqFmp5PsxXxzcgE1zxzBge/n9mz1JWd9obAqZ5MP4lxhHDCIyMVlfAXh+1zVr9cCAiLs7dSWRrTCIagp7Z0vZgHuobtVZEawBYA9RWtb9wOgYfs8XdmB/fmUAcaA5MkcvU9l0NocEQ2hyQoh/zmSt
X-Gm-Message-State: AOJu0Yy/PCmK8IYs2R+fUYCUnVKY8bUNZQ/QRGgrEqO1oT+OVqUwLYG0
	A0VVJLDhehKLJExUaod9aFuV8D3T6+y4Wpt5gBUxFEpGtIvB8FPZv4p1j7BjcJWEZvbD1Alz+vZ
	Q0M+UxlgCz5m3EqQsFCSgEr4yhYk=
X-Google-Smtp-Source: AGHT+IE8eQ8lHv0aThBvkkelmXblMeJEqsMKM3GoNmG5ryHhqvDYjHXResG10v+ubvnoi/etG44LWQwWd+owOufroPA=
X-Received: by 2002:a25:8907:0:b0:e08:5ee3:7a03 with SMTP id
 3f1490d57ef6-e0b5447b082mr1495365276.22.1722036147014; Fri, 26 Jul 2024
 16:22:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
 <20240710212555.1617795-8-amery.hung@bytedance.com> <bpb36dtlbs6osr5cudvwrbagt7bls3cllg35lsusrly5pxwe7o@kjphrbuc64ix>
In-Reply-To: <bpb36dtlbs6osr5cudvwrbagt7bls3cllg35lsusrly5pxwe7o@kjphrbuc64ix>
From: Amery Hung <ameryhung@gmail.com>
Date: Fri, 26 Jul 2024 16:22:16 -0700
Message-ID: <CAMB2axPwUV9EusNPaemLVx5NN2_1wkq0ney4NazAj7P+WRo=NQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v6 07/14] virtio/vsock: add common datagram
 send path
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
> On Wed, Jul 10, 2024 at 09:25:48PM GMT, Amery Hung wrote:
> >From: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >
> >This commit implements the common function
> >virtio_transport_dgram_enqueue for enqueueing datagrams. It does not add
> >usage in either vhost or virtio yet.
> >
> >Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >Signed-off-by: Amery Hung <amery.hung@bytedance.com>
> >---
> > include/linux/virtio_vsock.h            |  1 +
> > include/net/af_vsock.h                  |  2 +
> > net/vmw_vsock/af_vsock.c                |  2 +-
> > net/vmw_vsock/virtio_transport_common.c | 87 ++++++++++++++++++++++++-
> > 4 files changed, 90 insertions(+), 2 deletions(-)
> >
> >diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> >index f749a066af46..4408749febd2 100644
> >--- a/include/linux/virtio_vsock.h
> >+++ b/include/linux/virtio_vsock.h
> >@@ -152,6 +152,7 @@ struct virtio_vsock_pkt_info {
> >       u16 op;
> >       u32 flags;
> >       bool reply;
> >+      u8 remote_flags;
> > };
> >
> > struct virtio_transport {
> >diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> >index 44db8f2c507d..6e97d344ac75 100644
> >--- a/include/net/af_vsock.h
> >+++ b/include/net/af_vsock.h
> >@@ -216,6 +216,8 @@ void vsock_for_each_connected_socket(struct vsock_tr=
ansport *transport,
> >                                    void (*fn)(struct sock *sk));
> > int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *p=
sk);
> > bool vsock_find_cid(unsigned int cid);
> >+const struct vsock_transport *vsock_dgram_lookup_transport(unsigned int=
 cid,
> >+                                                         __u8 flags);
>
> Why __u8 and not just u8?
>

Will change to u8.

>
> >
> > struct vsock_skb_cb {
> >       unsigned int src_cid;
> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >index ab08cd81720e..f83b655fdbe9 100644
> >--- a/net/vmw_vsock/af_vsock.c
> >+++ b/net/vmw_vsock/af_vsock.c
> >@@ -487,7 +487,7 @@ vsock_connectible_lookup_transport(unsigned int cid,=
 __u8 flags)
> >       return transport;
> > }
> >
> >-static const struct vsock_transport *
> >+const struct vsock_transport *
> > vsock_dgram_lookup_transport(unsigned int cid, __u8 flags)
> > {
> >       const struct vsock_transport *transport;
> >diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/vir=
tio_transport_common.c
> >index a1c76836d798..46cd1807f8e3 100644
> >--- a/net/vmw_vsock/virtio_transport_common.c
> >+++ b/net/vmw_vsock/virtio_transport_common.c
> >@@ -1040,13 +1040,98 @@ int virtio_transport_shutdown(struct vsock_sock =
*vsk, int mode)
> > }
> > EXPORT_SYMBOL_GPL(virtio_transport_shutdown);
> >
> >+static int virtio_transport_dgram_send_pkt_info(struct vsock_sock *vsk,
> >+                                              struct virtio_vsock_pkt_i=
nfo *info)
> >+{
> >+      u32 src_cid, src_port, dst_cid, dst_port;
> >+      const struct vsock_transport *transport;
> >+      const struct virtio_transport *t_ops;
> >+      struct sock *sk =3D sk_vsock(vsk);
> >+      struct virtio_vsock_hdr *hdr;
> >+      struct sk_buff *skb;
> >+      void *payload;
> >+      int noblock =3D 0;
> >+      int err;
> >+
> >+      info->type =3D virtio_transport_get_type(sk_vsock(vsk));
> >+
> >+      if (info->pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
> >+              return -EMSGSIZE;
> >+
> >+      transport =3D vsock_dgram_lookup_transport(info->remote_cid, info=
->remote_flags);
>
> Can `transport` be null?
>
> I don't understand why we are calling vsock_dgram_lookup_transport()
> again. Didn't we already do that in vsock_dgram_sendmsg()?
>

transport should be valid here since we null-checked it in
vsock_dgram_sendmsg(). The reason vsock_dgram_lookup_transport() is
called again here is we don't have the transport when we called into
transport->dgram_enqueue(). I can also instead add transport to the
argument of dgram_enqueue() to eliminate this redundant lookup.

> Also should we add a comment mentioning that we can't use
> virtio_transport_get_ops()? IIUC becuase the vsk can be not assigned
> to a specific transport, right?
>

Correct. For virtio dgram socket, transport is not assigned unless
vsock_dgram_connect() is called. I will add a comment here explaining
this.

> >+      t_ops =3D container_of(transport, struct virtio_transport, transp=
ort);
> >+      if (unlikely(!t_ops))
> >+              return -EFAULT;
> >+
> >+      if (info->msg)
> >+              noblock =3D info->msg->msg_flags & MSG_DONTWAIT;
> >+
> >+      /* Use sock_alloc_send_skb to throttle by sk_sndbuf. This helps a=
void
> >+       * triggering the OOM.
> >+       */
> >+      skb =3D sock_alloc_send_skb(sk, info->pkt_len + VIRTIO_VSOCK_SKB_=
HEADROOM,
> >+                                noblock, &err);
> >+      if (!skb)
> >+              return err;
> >+
> >+      skb_reserve(skb, VIRTIO_VSOCK_SKB_HEADROOM);
> >+
> >+      src_cid =3D t_ops->transport.get_local_cid();
> >+      src_port =3D vsk->local_addr.svm_port;
> >+      dst_cid =3D info->remote_cid;
> >+      dst_port =3D info->remote_port;
> >+
> >+      hdr =3D virtio_vsock_hdr(skb);
> >+      hdr->type       =3D cpu_to_le16(info->type);
> >+      hdr->op         =3D cpu_to_le16(info->op);
> >+      hdr->src_cid    =3D cpu_to_le64(src_cid);
> >+      hdr->dst_cid    =3D cpu_to_le64(dst_cid);
> >+      hdr->src_port   =3D cpu_to_le32(src_port);
> >+      hdr->dst_port   =3D cpu_to_le32(dst_port);
> >+      hdr->flags      =3D cpu_to_le32(info->flags);
> >+      hdr->len        =3D cpu_to_le32(info->pkt_len);
> >+
> >+      if (info->msg && info->pkt_len > 0) {
> >+              payload =3D skb_put(skb, info->pkt_len);
> >+              err =3D memcpy_from_msg(payload, info->msg, info->pkt_len=
);
> >+              if (err)
> >+                      goto out;
> >+      }
> >+
> >+      trace_virtio_transport_alloc_pkt(src_cid, src_port,
> >+                                       dst_cid, dst_port,
> >+                                       info->pkt_len,
> >+                                       info->type,
> >+                                       info->op,
> >+                                       info->flags,
> >+                                       false);
> >+
> >+      return t_ops->send_pkt(skb);
> >+out:
> >+      kfree_skb(skb);
> >+      return err;
> >+}
> >+
> > int
> > virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
> >                              struct sockaddr_vm *remote_addr,
> >                              struct msghdr *msg,
> >                              size_t dgram_len)
> > {
> >-      return -EOPNOTSUPP;
> >+      /* Here we are only using the info struct to retain style uniform=
ity
> >+       * and to ease future refactoring and merging.
> >+       */
> >+      struct virtio_vsock_pkt_info info =3D {
> >+              .op =3D VIRTIO_VSOCK_OP_RW,
> >+              .remote_cid =3D remote_addr->svm_cid,
> >+              .remote_port =3D remote_addr->svm_port,
> >+              .remote_flags =3D remote_addr->svm_flags,
> >+              .msg =3D msg,
> >+              .vsk =3D vsk,
> >+              .pkt_len =3D dgram_len,
> >+      };
> >+
> >+      return virtio_transport_dgram_send_pkt_info(vsk, &info);
> > }
> > EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
> >
> >--
> >2.20.1
> >
>

