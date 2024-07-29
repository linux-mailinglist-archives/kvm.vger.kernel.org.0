Return-Path: <kvm+bounces-22533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81A3D940162
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 00:52:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17D372825B3
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 22:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDC5218EFF8;
	Mon, 29 Jul 2024 22:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="agfj04Yn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094CF824AD;
	Mon, 29 Jul 2024 22:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722293528; cv=none; b=FkPXOSjZjjSA0gsBAbOKjATzITXG7PJ+1KqmFKIyMv9L+Qoys228Zodckh/z26rXd6SwcjuASrjEZ1QIfXuqX4XPIJouBnNKruFszrAukiJg31CStXB6QMLksb3xixF76CfWN4SuGrQ38uNTvCe01JFYCDV+C6KvchO9yL6Nc+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722293528; c=relaxed/simple;
	bh=jtcBiybF18rrhoGoJIJZVMTIuu4MOYpa6C8hIZbgkFM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KXTobOUYCBJuSGxHE4Uf4KnQSvKe+UyghhdvukjCJej96zCWA54jT22FwFfFbTW5fZMAqEuWKNRWikmFk25rqtsdm5Wt0bK3Expi8F0zW0rkyEG3hFNF+J+ye6n6lsXcC+QmuQvVQDRzMTzjqCDBlUSXKWio3RAlgAjzdiWm18Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=agfj04Yn; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e0b7efa1c1bso1647565276.3;
        Mon, 29 Jul 2024 15:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722293524; x=1722898324; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gg5HeEiGHzT8hT6f5/evSH/gSzb5Mo4puYNGhy7jr5U=;
        b=agfj04YnbKN5N478SFAzsYlFasD9ypv8qdLWT5wZ7Tma5jt8aU8cT++iF8mOiJdo9b
         yGTY98UTOLLqtuXnMSAiiBY7SA3kkuIhELfAKrT+lPmWUsWqMSXQt8pyRd3Ked3zj/fc
         c7Q53EdZmwdS2K0wssx4PdaTOE0oVADp3jPJjl0QlxKO85FhwhBLxNnwUlqYlVAoyUUJ
         A09JgayC02fE/cTyfi9X4FKnorX0nfhC/P7jNIR4MEg/idT4q7XgfkF6et444HX69Oj3
         O3Ip71ihrzVEHc4fvgF6GTfLajV9G99xgcmugYz8f0rLJxlY7156x6W3jvGZGR13XbHg
         HzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722293524; x=1722898324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gg5HeEiGHzT8hT6f5/evSH/gSzb5Mo4puYNGhy7jr5U=;
        b=rEcLRUj1vk54N0MGmOVZtkfMHdQWYlfZc6CkNj8j+spBHhD15H+0bNBrJD0HEhuIHW
         9XB7s7/oX5lvgVxdzNn8I+n/PD9lpyAIE2vqKuvtPJOfyKCa951swUfA08ZR4fi0CfWu
         RB8V3EztPB+AXTP75hgqfG5vu0XlRCoKuebfk4eEcAfpby83J2eVencQHKUzc4cdxUiv
         SaQOQFyRwy95l4XQZJ/txmBoQz8XuAP5M6rX7VIwdnnr4y1N9U99a66jG0jq50o4yC9Y
         gxq28qFFGkJ58BgMBUz5Ar6uqmyJ/+8yBBpmMOE5pc6kxgsv4Lc3XlWkIpDt58rnCPQx
         SV4g==
X-Forwarded-Encrypted: i=1; AJvYcCWREFPvkaXBiAKz5hlHwaF9RdIemcy4J6ww+djhAZOtuHcPVO8dA5VU1cBWyHreNbh0kAuURIbAikolEosyMZMSfJrVYmvcPtEUY5UVXPXYTr1e9FgBAhzjqsa+DpqADM7QzcQsSaMAOA19xtntMI1A7eb+cr2gJ/sCYKrPnnGS6K+O5cCEJH3Ele6AQ9f2+1USgw65hFJnhA27LvniM69tSaiqk/wEWgiocgdM
X-Gm-Message-State: AOJu0YwFwel12BGXuZVyKwS6YAcJOTT4IWmkyRfnVHJ0XWaytlCtASAF
	j1stjye2WyhBZ+c3RElCtZQFPfhMOibSNYQTlfeUvPtrXs56cY7WgWR46B2ibthhL1vFJZwNK9w
	TuM2Po06K/SEijBD5q4Hgozo+Tfo=
X-Google-Smtp-Source: AGHT+IFp1maKkseHyDEiVQrlMWP8F7GBiHqFsuJ7fcviqwFGiyOAHy2I1TSLKaLeQ7ojbPuZs/dqshqB1RUfEPRFJvM=
X-Received: by 2002:a25:dfc4:0:b0:e0b:1241:cc19 with SMTP id
 3f1490d57ef6-e0b544cbe9dmr10355797276.32.1722293523937; Mon, 29 Jul 2024
 15:52:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710212555.1617795-8-amery.hung@bytedance.com> <e1647f5f-5056-5cf0-e81c-5ef71fd6efd0@salutedevices.com>
In-Reply-To: <e1647f5f-5056-5cf0-e81c-5ef71fd6efd0@salutedevices.com>
From: Amery Hung <ameryhung@gmail.com>
Date: Mon, 29 Jul 2024 15:51:52 -0700
Message-ID: <CAMB2axMXzcxrFr+zWV6CFJxDrKwH+U85F7dkeXfJjAO10EmSAg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v6 07/14] virtio/vsock: add common datagram
 send path
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com, mst@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, kys@microsoft.com, 
	haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com, 
	bryantan@vmware.com, vdasa@vmware.com, pv-drivers@vmware.com, 
	dan.carpenter@linaro.org, simon.horman@corigine.com, oxffffaa@gmail.com, 
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, bpf@vger.kernel.org, 
	bobby.eshleman@bytedance.com, jiang.wang@bytedance.com, 
	amery.hung@bytedance.com, xiyou.wangcong@gmail.com, kernel@sberdevices.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2024 at 1:12=E2=80=AFPM Arseniy Krasnov
<avkrasnov@salutedevices.com> wrote:
>
> Hi,
>
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/vi=
rtio_transport_common.c
> > index a1c76836d798..46cd1807f8e3 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -1040,13 +1040,98 @@ int virtio_transport_shutdown(struct vsock_sock=
 *vsk, int mode)
> >  }
> >  EXPORT_SYMBOL_GPL(virtio_transport_shutdown);
> >
> > +static int virtio_transport_dgram_send_pkt_info(struct vsock_sock *vsk=
,
> > +                                             struct virtio_vsock_pkt_i=
nfo *info)
> > +{
> > +     u32 src_cid, src_port, dst_cid, dst_port;
> > +     const struct vsock_transport *transport;
> > +     const struct virtio_transport *t_ops;
> > +     struct sock *sk =3D sk_vsock(vsk);
> > +     struct virtio_vsock_hdr *hdr;
> > +     struct sk_buff *skb;
> > +     void *payload;
> > +     int noblock =3D 0;
> > +     int err;
> > +
> > +     info->type =3D virtio_transport_get_type(sk_vsock(vsk));
> > +
> > +     if (info->pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
> > +             return -EMSGSIZE;
>
> Small suggestion, i think we can check for packet length earlier ? Before
> info->type =3D ...

Certainly.

>
> > +
> > +     transport =3D vsock_dgram_lookup_transport(info->remote_cid, info=
->remote_flags);
> > +     t_ops =3D container_of(transport, struct virtio_transport, transp=
ort);
> > +     if (unlikely(!t_ops))
> > +             return -EFAULT;
> > +
> > +     if (info->msg)
> > +             noblock =3D info->msg->msg_flags & MSG_DONTWAIT;
> > +
> > +     /* Use sock_alloc_send_skb to throttle by sk_sndbuf. This helps a=
void
> > +      * triggering the OOM.
> > +      */
> > +     skb =3D sock_alloc_send_skb(sk, info->pkt_len + VIRTIO_VSOCK_SKB_=
HEADROOM,
> > +                               noblock, &err);
> > +     if (!skb)
> > +             return err;
> > +
> > +     skb_reserve(skb, VIRTIO_VSOCK_SKB_HEADROOM);
> > +
> > +     src_cid =3D t_ops->transport.get_local_cid();
> > +     src_port =3D vsk->local_addr.svm_port;
> > +     dst_cid =3D info->remote_cid;
> > +     dst_port =3D info->remote_port;
> > +
> > +     hdr =3D virtio_vsock_hdr(skb);
> > +     hdr->type       =3D cpu_to_le16(info->type);
> > +     hdr->op         =3D cpu_to_le16(info->op);
> > +     hdr->src_cid    =3D cpu_to_le64(src_cid);
> > +     hdr->dst_cid    =3D cpu_to_le64(dst_cid);
> > +     hdr->src_port   =3D cpu_to_le32(src_port);
> > +     hdr->dst_port   =3D cpu_to_le32(dst_port);
> > +     hdr->flags      =3D cpu_to_le32(info->flags);
> > +     hdr->len        =3D cpu_to_le32(info->pkt_len);
>
> There is function 'virtio_transport_init_hdr()' in this file, may be reus=
e it ?

Will do.

>
> > +
> > +     if (info->msg && info->pkt_len > 0) {
>
> If pkt_len is 0, do we really need to send such packets ? Because for con=
nectible
> sockets, we ignore empty OP_RW packets.

Thanks for pointing this out. I think virtio dgram should also follow that.

>
> > +             payload =3D skb_put(skb, info->pkt_len);
> > +             err =3D memcpy_from_msg(payload, info->msg, info->pkt_len=
);
> > +             if (err)
> > +                     goto out;
> > +     }
> > +
> > +     trace_virtio_transport_alloc_pkt(src_cid, src_port,
> > +                                      dst_cid, dst_port,
> > +                                      info->pkt_len,
> > +                                      info->type,
> > +                                      info->op,
> > +                                      info->flags,
> > +                                      false);
>
> ^^^ For SOCK_DGRAM, include/trace/events/vsock_virtio_transport_common.h =
also should
> be updated?

Can you elaborate what needs to be changed?

Thank you,
Amery

>
> > +
> > +     return t_ops->send_pkt(skb);
> > +out:
> > +     kfree_skb(skb);
> > +     return err;
> > +}
> > +
> >  int
> >  virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
> >                              struct sockaddr_vm *remote_addr,
> >                              struct msghdr *msg,
> >                              size_t dgram_len)
> >  {
> > -     return -EOPNOTSUPP;
> > +     /* Here we are only using the info struct to retain style uniform=
ity
> > +      * and to ease future refactoring and merging.
> > +      */
> > +     struct virtio_vsock_pkt_info info =3D {
> > +             .op =3D VIRTIO_VSOCK_OP_RW,
> > +             .remote_cid =3D remote_addr->svm_cid,
> > +             .remote_port =3D remote_addr->svm_port,
> > +             .remote_flags =3D remote_addr->svm_flags,
> > +             .msg =3D msg,
> > +             .vsk =3D vsk,
> > +             .pkt_len =3D dgram_len,
> > +     };
> > +
> > +     return virtio_transport_dgram_send_pkt_info(vsk, &info);
> >  }
> >  EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
> >
> > --
> > 2.20.1
>
> Thanks, Arseniy

