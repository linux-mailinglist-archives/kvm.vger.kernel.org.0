Return-Path: <kvm+bounces-21669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 948DD931DB7
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 01:40:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE796B21020
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 23:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31BA3143C46;
	Mon, 15 Jul 2024 23:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZiU9du0G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A50E13D24C;
	Mon, 15 Jul 2024 23:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721086809; cv=none; b=LqmwzT4xkgqEnXe/Ro/SZk+bbH2VEj2zHUU1zIkzGXAsOacdArq/kKdbtl3yD8YdOL8yfxgeAxUdo0QlRoI0EIU6R3YdP710krBT5bGJrGR2U1ocqC0P6D1nzpjHAXMckl2TGG8IhiVepwIBmgKpdqnqq8G8jKmLoCrUQ8JC4H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721086809; c=relaxed/simple;
	bh=IYxflzTkvvDnzo/O5Exeaaz6QZwX1+dOjhXFIdh5qjM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N+0cMOvCKGTx2BlsM30R2ovEHqhFte+FE5n+tr1xattTH8qAAm83ex5yVGjQQMlHuRezGZaDH62kjl3EangAkI1WcmN5iFbt17co9nMlErDqa6+byjGMqxTD/g/CIHNWpGs7hvw9HaYC/sGYFMq2m1qiftsDPoibP5NxIopmZz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZiU9du0G; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e05a61303b7so2277649276.0;
        Mon, 15 Jul 2024 16:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721086806; x=1721691606; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=11nSWK2DsfMrraLYfcTYiqBnSNQFLOrBGZBeHRpNduU=;
        b=ZiU9du0GDvirzo1EdkN6k0NsyFMYTdtQbRmK6pAWqjqYO60J9dnzg0Gb0GTCHcm9eo
         dya4qAffU58RABzc0OiY8T3LQWJI1F2618mat/RV/sPOJloiK0b4FJN7l6RGNJfua1mP
         mRxU2E2W/c3iGOeh6QLqGtFOWzkzDmsWf1bnLPBOoP401z3FsyOAXTSgtteQ+5NT3NpT
         ku8wAniKbjRBGPUdaocFFfGhkn7mDK8VLRl3EvjrET4Oyg+nQKJbJVdDQtNBHigPcnmr
         oG1EYa9ydyWc7Or23CAxc4ffardZqNh0fjgEKBf/anqFhq/sqF8n8W8UYSmm/5Y1XqVo
         BStQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721086806; x=1721691606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=11nSWK2DsfMrraLYfcTYiqBnSNQFLOrBGZBeHRpNduU=;
        b=hxxHuToI2Io5nsENGl0mIbDshGZ2bGQacSF/mRVZioXPP2/hfBV5KZsQIZDp0Ve6ka
         aZwQe8ZKyqvt0Gdw0YwG6cgHFUP6q2p9gtn8ILHW7bVDSmcMIpqECd0bRF+wIyUS/wyo
         hDwst8qB2rvDjgjmpqLfMBO74G449ySyzcn0A6k4DHt6gV6zkqJ4tngKcAtgNqBTynqy
         riibd7fj0Nbr4fDSZqEA5Csfe/Bo4ZKpec5/7iS28jB9z3XlNkXdxNiyKIMNN1/naFpM
         bXlnrAv3Sq7s54jC282FhVDbIeqfGY7DIWHHbdeXcutzgIHUfkiiKTtukQrbvKHly4eA
         HQvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXirCa6MMeUOhlgp/iN/Pd36KxQI68bPjHSNkzH2R2WWTA4BQjccuwIGufSMySBpm+HNLhBUUIgZeX1joCTdo43is/wILAWExf9u6/NVNP3YaornASlKfgcKEZnP2Szd+4gtivAbFaCP9wRR/aY6TSkW5xxs7jzadcpVxcC4jaJWE/del92gYOeElg5oHmR0OOSKaek9xs4wIZJbAt0wV13NuNzIjcCBQp7J0pn
X-Gm-Message-State: AOJu0YzBkGRxW5Xno5/NfpjQNCHo/tEo28n0SVvgKzM4STu6/gDhO4r7
	gD8i/bNgLkFpMdblE5blF4IN1zbEal8OD/mVMMSnBnBr2ArnRNBAMlyX0M4zpeoX1KAJE8iQAzp
	bd84+z7+kyS8P6j6gnTc7RCQxe8Q=
X-Google-Smtp-Source: AGHT+IEBq0pvl8kIIqh5kP5RjyqtMxsRfTwvg+dA7+/RIKG3tCsg9lQtVLnTQrLXFec1OXYriekS+isTPIt8B7q07RA=
X-Received: by 2002:a05:6902:114c:b0:e03:ab31:9aa6 with SMTP id
 3f1490d57ef6-e05d56d3d2dmr919642276.24.1721086806098; Mon, 15 Jul 2024
 16:40:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710212555.1617795-2-amery.hung@bytedance.com> <AS2P194MB2170B9984C55A5F460F9E03E9AA12@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
In-Reply-To: <AS2P194MB2170B9984C55A5F460F9E03E9AA12@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
From: Amery Hung <ameryhung@gmail.com>
Date: Mon, 15 Jul 2024 16:39:55 -0700
Message-ID: <CAMB2axPcjTvbriw7rNXRy5dN4n8Zq-myesXWsH1USM44XFyMxA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v6 01/14] af_vsock: generalize
 vsock_dgram_recvmsg() to all transports
To: Luigi Leonardi <luigi.leonardi@outlook.com>
Cc: amery.hung@bytedance.com, bobby.eshleman@bytedance.com, 
	bpf@vger.kernel.org, bryantan@vmware.com, dan.carpenter@linaro.org, 
	davem@davemloft.net, decui@microsoft.com, edumazet@google.com, 
	haiyangz@microsoft.com, jasowang@redhat.com, jiang.wang@bytedance.com, 
	kuba@kernel.org, kvm@vger.kernel.org, kys@microsoft.com, 
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com, 
	netdev@vger.kernel.org, oxffffaa@gmail.com, pabeni@redhat.com, 
	pv-drivers@vmware.com, sgarzare@redhat.com, simon.horman@corigine.com, 
	stefanha@redhat.com, vdasa@vmware.com, 
	virtualization@lists.linux-foundation.org, wei.liu@kernel.org, 
	xiyou.wangcong@gmail.com, xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2024 at 1:02=E2=80=AFAM Luigi Leonardi
<luigi.leonardi@outlook.com> wrote:
>
> Hi Amery, Bobby
>
> > From: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >
> > This commit drops the transport->dgram_dequeue callback and makes
> > vsock_dgram_recvmsg() generic to all transports.
> >
> > To make this possible, two transport-level changes are introduced:
> > - transport in the receiving path now stores the cid and port into
> >   the control buffer of an skb when populating an skb. The information
> >   later is used to initialize sockaddr_vm structure in recvmsg()
> >   without referencing vsk->transport.
> > - transport implementations set the skb->data pointer to the beginning
> >   of the payload prior to adding the skb to the socket's receive queue.
> >   That is, they must use skb_pull() before enqueuing. This is an
> >   agreement between the transport and the socket layer that skb->data
> >   always points to the beginning of the payload (and not, for example,
> >   the packet header).
> >
> Like in the other patch, please use imperative in the commit message.
> >
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > Signed-off-by: Amery Hung <amery.hung@bytedance.com>
> > ---
> >  drivers/vhost/vsock.c                   |  1 -
> >  include/linux/virtio_vsock.h            |  5 ---
> >  include/net/af_vsock.h                  | 11 ++++-
> >  net/vmw_vsock/af_vsock.c                | 42 +++++++++++++++++-
> >  net/vmw_vsock/hyperv_transport.c        |  7 ---
> >  net/vmw_vsock/virtio_transport.c        |  1 -
> >  net/vmw_vsock/virtio_transport_common.c |  9 ----
> >  net/vmw_vsock/vmci_transport.c          | 59 +++----------------------
> >  net/vmw_vsock/vsock_loopback.c          |  1 -
> >  9 files changed, 55 insertions(+), 81 deletions(-)
> >
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > index ec20ecff85c7..97fffa914e66 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -419,7 +419,6 @@ static struct virtio_transport vhost_transport =3D =
{
> >               .cancel_pkt               =3D vhost_transport_cancel_pkt,
> >
> >               .dgram_enqueue            =3D virtio_transport_dgram_enqu=
eue,
> > -             .dgram_dequeue            =3D virtio_transport_dgram_dequ=
eue,
> >               .dgram_bind               =3D virtio_transport_dgram_bind=
,
> >               .dgram_allow              =3D virtio_transport_dgram_allo=
w,
> >
> > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.=
h
> > index c82089dee0c8..8b56b8a19ddd 100644
> > --- a/include/linux/virtio_vsock.h
> > +++ b/include/linux/virtio_vsock.h
> > @@ -177,11 +177,6 @@ virtio_transport_stream_dequeue(struct vsock_sock =
*vsk,
> >                               size_t len,
> >                               int type);
> >  int
> > -virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> > -                            struct msghdr *msg,
> > -                            size_t len, int flags);
> > -
> > -int
> >  virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
> >                                  struct msghdr *msg,
> >                                  size_t len);
> > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > index 535701efc1e5..7aa1f5f2b1a5 100644
> > --- a/include/net/af_vsock.h
> > +++ b/include/net/af_vsock.h
> > @@ -120,8 +120,6 @@ struct vsock_transport {
> >
> >       /* DGRAM. */
> >       int (*dgram_bind)(struct vsock_sock *, struct sockaddr_vm *);
> > -     int (*dgram_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
> > -                          size_t len, int flags);
> >       int (*dgram_enqueue)(struct vsock_sock *, struct sockaddr_vm *,
> >                            struct msghdr *, size_t len);
> >       bool (*dgram_allow)(u32 cid, u32 port);
> > @@ -219,6 +217,15 @@ void vsock_for_each_connected_socket(struct vsock_=
transport *transport,
> >  int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *=
psk);
> >  bool vsock_find_cid(unsigned int cid);
> >
> > +struct vsock_skb_cb {
> > +     unsigned int src_cid;
> > +     unsigned int src_port;
> > +};
> > +
> > +static inline struct vsock_skb_cb *vsock_skb_cb(struct sk_buff *skb) {
> > +     return (struct vsock_skb_cb *)skb->cb;
> > +};
> > +
> >
>
> Running scripts/checkpatch.pl --strict --codespell on the patch shows thi=
s error:
>
>  ERROR: open brace '{' following function definitions go on the next line
>  #183: FILE: include/net/af_vsock.h:225:
>  +static inline struct vsock_skb_cb *vsock_skb_cb(struct sk_buff *skb) {
>
>  total: 1 errors, 0 warnings, 0 checks, 235 lines checked
> >
> >  /**** TAP ****/
> >
> >  struct vsock_tap {
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index 4b040285aa78..5e7d4d99ea2c 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -1273,11 +1273,15 @@ static int vsock_dgram_connect(struct socket *s=
ock,
> >  int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> >                       size_t len, int flags)
> >  {
> > +     struct vsock_skb_cb *vsock_cb;
> >  #ifdef CONFIG_BPF_SYSCALL
> >       const struct proto *prot;
> >  #endif
> >       struct vsock_sock *vsk;
> > +     struct sk_buff *skb;
> > +     size_t payload_len;
> >       struct sock *sk;
> > +     int err;
> >
> >       sk =3D sock->sk;
> >       vsk =3D vsock_sk(sk);
> > @@ -1288,7 +1292,43 @@ int vsock_dgram_recvmsg(struct socket *sock, str=
uct msghdr *msg,
> >               return prot->recvmsg(sk, msg, len, flags, NULL);
> >  #endif
> >
> > -     return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
> > +     if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> > +             return -EOPNOTSUPP;
> > +
> > +     if (unlikely(flags & MSG_ERRQUEUE))
> > +             return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, 0);
> >
> This if statement is always false!
> >
> > +
> > +     /* Retrieve the head sk_buff from the socket's receive queue. */
> > +     err =3D 0;
> > +     skb =3D skb_recv_datagram(sk_vsock(vsk), flags, &err);
> > +     if (!skb)
> > +             return err;
> > +
> > +     payload_len =3D skb->len;
> > +
> nit: I'd remove this blank line.
> > +     if (payload_len > len) {
> > +             payload_len =3D len;
> > +             msg->msg_flags |=3D MSG_TRUNC;
> > +     }
> > +
> > +     /* Place the datagram payload in the user's iovec. */
> > +     err =3D skb_copy_datagram_msg(skb, 0, msg, payload_len);
> > +     if (err)
> > +             goto out;
> > +
> > +     if (msg->msg_name) {
> > +             /* Provide the address of the sender. */
> > +             DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_=
name);
> > +
> > +             vsock_cb =3D vsock_skb_cb(skb);
> > +             vsock_addr_init(vm_addr, vsock_cb->src_cid, vsock_cb->src=
_port);
> > +             msg->msg_namelen =3D sizeof(*vm_addr);
> > +     }
> > +     err =3D payload_len;
> > +
> > +out:
> > +     skb_free_datagram(&vsk->sk, skb);
> > +     return err;
> >  }
> >  EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
> >
> > diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_tr=
ansport.c
> > index e2157e387217..326dd41ee2d5 100644
> > --- a/net/vmw_vsock/hyperv_transport.c
> > +++ b/net/vmw_vsock/hyperv_transport.c
> > @@ -556,12 +556,6 @@ static int hvs_dgram_bind(struct vsock_sock *vsk, =
struct sockaddr_vm *addr)
> >       return -EOPNOTSUPP;
> >  }
> >
> > -static int hvs_dgram_dequeue(struct vsock_sock *vsk, struct msghdr *ms=
g,
> > -                          size_t len, int flags)
> > -{
> > -     return -EOPNOTSUPP;
> > -}
> > -
> >  static int hvs_dgram_enqueue(struct vsock_sock *vsk,
> >                            struct sockaddr_vm *remote, struct msghdr *m=
sg,
> >                            size_t dgram_len)
> > @@ -833,7 +827,6 @@ static struct vsock_transport hvs_transport =3D {
> >       .shutdown                 =3D hvs_shutdown,
> >
> >       .dgram_bind               =3D hvs_dgram_bind,
> > -     .dgram_dequeue            =3D hvs_dgram_dequeue,
> >       .dgram_enqueue            =3D hvs_dgram_enqueue,
> >       .dgram_allow              =3D hvs_dgram_allow,
> >
> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_tr=
ansport.c
> > index 43d405298857..a8c97e95622a 100644
> > --- a/net/vmw_vsock/virtio_transport.c
> > +++ b/net/vmw_vsock/virtio_transport.c
> > @@ -508,7 +508,6 @@ static struct virtio_transport virtio_transport =3D=
 {
> >               .cancel_pkt               =3D virtio_transport_cancel_pkt=
,
> >
> >               .dgram_bind               =3D virtio_transport_dgram_bind=
,
> > -             .dgram_dequeue            =3D virtio_transport_dgram_dequ=
eue,
> >               .dgram_enqueue            =3D virtio_transport_dgram_enqu=
eue,
> >               .dgram_allow              =3D virtio_transport_dgram_allo=
w,
> >
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/vi=
rtio_transport_common.c
> > index 16ff976a86e3..4bf73d20c12a 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -810,15 +810,6 @@ virtio_transport_seqpacket_enqueue(struct vsock_so=
ck *vsk,
> >  }
> >  EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
> >
> > -int
> > -virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> > -                            struct msghdr *msg,
> > -                            size_t len, int flags)
> > -{
> > -     return -EOPNOTSUPP;
> > -}
> > -EXPORT_SYMBOL_GPL(virtio_transport_dgram_dequeue);
> > -
> >  s64 virtio_transport_stream_has_data(struct vsock_sock *vsk)
> >  {
> >       struct virtio_vsock_sock *vvs =3D vsk->trans;
> > diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transp=
ort.c
> > index b370070194fa..b39df3ed8c8d 100644
> > --- a/net/vmw_vsock/vmci_transport.c
> > +++ b/net/vmw_vsock/vmci_transport.c
> > @@ -610,6 +610,7 @@ vmci_transport_datagram_create_hnd(u32 resource_id,
> >
> >  static int vmci_transport_recv_dgram_cb(void *data, struct vmci_datagr=
am *dg)
> >  {
> > +     struct vsock_skb_cb *vsock_cb;
> >       struct sock *sk;
> >       size_t size;
> >       struct sk_buff *skb;
> > @@ -637,10 +638,14 @@ static int vmci_transport_recv_dgram_cb(void *dat=
a, struct vmci_datagram *dg)
> >       if (!skb)
> >               return VMCI_ERROR_NO_MEM;
> >
> > +     vsock_cb =3D vsock_skb_cb(skb);
> > +     vsock_cb->src_cid =3D dg->src.context;
> > +     vsock_cb->src_port =3D dg->src.resource;
> >       /* sk_receive_skb() will do a sock_put(), so hold here. */
> >       sock_hold(sk);
> >       skb_put(skb, size);
> >       memcpy(skb->data, dg, size);
> > +     skb_pull(skb, VMCI_DG_HEADERSIZE);
> >       sk_receive_skb(sk, skb, 0);
> >
> >       return VMCI_SUCCESS;
> > @@ -1731,59 +1736,6 @@ static int vmci_transport_dgram_enqueue(
> >       return err - sizeof(*dg);
> >  }
> >
> > -static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
> > -                                     struct msghdr *msg, size_t len,
> > -                                     int flags)
> > -{
> > -     int err;
> > -     struct vmci_datagram *dg;
> > -     size_t payload_len;
> > -     struct sk_buff *skb;
> > -
> > -     if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> > -             return -EOPNOTSUPP;
> > -
> > -     /* Retrieve the head sk_buff from the socket's receive queue. */
> > -     err =3D 0;
> > -     skb =3D skb_recv_datagram(&vsk->sk, flags, &err);
> > -     if (!skb)
> > -             return err;
> > -
> > -     dg =3D (struct vmci_datagram *)skb->data;
> > -     if (!dg)
> > -             /* err is 0, meaning we read zero bytes. */
> > -             goto out;
> > -
> > -     payload_len =3D dg->payload_size;
> > -     /* Ensure the sk_buff matches the payload size claimed in the pac=
ket. */
> > -     if (payload_len !=3D skb->len - sizeof(*dg)) {
> > -             err =3D -EINVAL;
> > -             goto out;
> > -     }
> > -
> > -     if (payload_len > len) {
> > -             payload_len =3D len;
> > -             msg->msg_flags |=3D MSG_TRUNC;
> > -     }
> > -
> > -     /* Place the datagram payload in the user's iovec. */
> > -     err =3D skb_copy_datagram_msg(skb, sizeof(*dg), msg, payload_len)=
;
> > -     if (err)
> > -             goto out;
> > -
> > -     if (msg->msg_name) {
> > -             /* Provide the address of the sender. */
> > -             DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_=
name);
> > -             vsock_addr_init(vm_addr, dg->src.context, dg->src.resourc=
e);
> > -             msg->msg_namelen =3D sizeof(*vm_addr);
> > -     }
> > -     err =3D payload_len;
> > -
> > -out:
> > -     skb_free_datagram(&vsk->sk, skb);
> > -     return err;
> > -}
> > -
> >  static bool vmci_transport_dgram_allow(u32 cid, u32 port)
> >  {
> >       if (cid =3D=3D VMADDR_CID_HYPERVISOR) {
> > @@ -2040,7 +1992,6 @@ static struct vsock_transport vmci_transport =3D =
{
> >       .release =3D vmci_transport_release,
> >       .connect =3D vmci_transport_connect,
> >       .dgram_bind =3D vmci_transport_dgram_bind,
> > -     .dgram_dequeue =3D vmci_transport_dgram_dequeue,
> >       .dgram_enqueue =3D vmci_transport_dgram_enqueue,
> >       .dgram_allow =3D vmci_transport_dgram_allow,
> >       .stream_dequeue =3D vmci_transport_stream_dequeue,
> > diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopb=
ack.c
> > index 6dea6119f5b2..11488887a5cc 100644
> > --- a/net/vmw_vsock/vsock_loopback.c
> > +++ b/net/vmw_vsock/vsock_loopback.c
> > @@ -66,7 +66,6 @@ static struct virtio_transport loopback_transport =3D=
 {
> >               .cancel_pkt               =3D vsock_loopback_cancel_pkt,
> >
> >               .dgram_bind               =3D virtio_transport_dgram_bind=
,
> > -             .dgram_dequeue            =3D virtio_transport_dgram_dequ=
eue,
> >               .dgram_enqueue            =3D virtio_transport_dgram_enqu=
eue,
> >               .dgram_allow              =3D virtio_transport_dgram_allo=
w,
> >
> > --
> > 2.20.1
> >
> >
>
> Small changes :)
> Rest LGTM!
>

I will fix the two style issues.

Thank you,
Amery

> Thanks,
> Luigi

