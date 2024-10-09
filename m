Return-Path: <kvm+bounces-28176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 147649961DD
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:06:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EC911C2402C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016EB188018;
	Wed,  9 Oct 2024 08:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W+2VKi+D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C6017B402
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 08:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728461183; cv=none; b=kLwW6VV8dloAlaVayd78mjdUkJoqO6OnsURoZGxAtrBaZcu9d3csfgh0M849UOumFdd6nTFvPJ1aoUlEG4FG4sOdeX8Q9DgRcuacarWc3VmcBbQNow3mdj0rd5KaKQRCM6o0i7W++o4/RuBwR16yLoMZkuZuTI+1DoaggXG6HJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728461183; c=relaxed/simple;
	bh=9XcedcnggzsqKhXgXiIzFaQ46ePcc6pD+7VzfPbyzYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N+PqI76KVM4qDyXJd//mdPiaufz5GP55Tqqmisv889c8XkMiKZ5UPt5jWbF7SOEjl1KiRwvEQgQx08F5JvnnH909HCU+4DFE8quzemnqqM5tAwXIbhIIpxwTCVBH5+zHZ4HiPTHECDW+J1BecITJEfe5vP8F9iIzAza+/dJqTNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W+2VKi+D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728461180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n7iozva3yX97aaV/kdom1QBsV86i5P13im7bYVWHNno=;
	b=W+2VKi+D1Lg2l80Xd+0ZJ8Ny2I4LmknskF0GWJgjyoNbw7JhMFXnfxHNyhAzJkRyKRKRh+
	PY0EY8G6vOBXpx7AaX5Y3JzBdC9GNUNqA7cUbWpdyZqXcelVHkinjJPttIu+zJTVKuHtCi
	GAqOKeSTgNQNBWbd100vztWNRaX0PCs=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-eonXhv5SOduF6JRNbk6rRQ-1; Wed, 09 Oct 2024 04:05:21 -0400
X-MC-Unique: eonXhv5SOduF6JRNbk6rRQ-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2e29e8d47e0so738322a91.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 01:05:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728461115; x=1729065915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n7iozva3yX97aaV/kdom1QBsV86i5P13im7bYVWHNno=;
        b=eC8fSXsGQIgfL0NnkiwbZNM6bEB3Z5rlV78t5t5wQSnALRFIthnInD/HwcG6binncr
         n6+044y4yWRCi9GTxOLb+cEWfRVj/sjyGltEHug/a75S4ExTiEmtM7w9EYS+HLPSvLv9
         l/q+3jtD7FzQQv8pqQ+9AyUXUeoPug5ENv+L/ppmlrge6/V58aRqUqH9vnSOoDxjcUYv
         j/zhZEXi+Tqn9mz8P7kYyOSDYDeYzqAPfGkksEmnLv5iWKpEYqLqYEV+CQitwe8aesQd
         AT0VdOwSKWtbiNGXFukvmvqBcqiVhtZ/rujY5LfRu0vMtVTy2ZMtaO1heNvg3Gz5RUNR
         htWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxZBRVs21DztQcm7wWFkc2nqEEKmzwa+aTKFc1o7plGs7uCg+gQAwqDMm7u+JvQHca2LU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMl6aIWB4+BdXAyZ7cH3BTjJIGjdqO49m6XO7fMpfMz+++FkfH
	1x5hzfiecE3gj0QFOgX5m1S/vZIp1PhDl9Tqz6xfmP5bP2pNEp6mcFSpStT3zgMeAjscviQLf/I
	WfHu9VNPB88QnvZyReQv9xhxJ/QC5sJ30U4GySbLslNz0paEd0vc2k82hsHnTOyvv+ba62AtoXc
	PtXZ4Q+Sn2G8tqOdau/li3xIjd
X-Received: by 2002:a17:90a:8f05:b0:2da:8e9b:f37b with SMTP id 98e67ed59e1d1-2e2a24a1e06mr1782708a91.24.1728461114754;
        Wed, 09 Oct 2024 01:05:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTqUrpGxCFJzvNXw4GtQHNE85zMwBtDhN5XTaZDwpAF4nEsOWc9Wr1SZNX/IApnlModNi8U38RCvLDq1Z7bKs=
X-Received: by 2002:a17:90a:8f05:b0:2da:8e9b:f37b with SMTP id
 98e67ed59e1d1-2e2a24a1e06mr1782663a91.24.1728461114124; Wed, 09 Oct 2024
 01:05:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241008-rss-v5-0-f3cf68df005d@daynix.com> <20241008-rss-v5-6-f3cf68df005d@daynix.com>
In-Reply-To: <20241008-rss-v5-6-f3cf68df005d@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 9 Oct 2024 16:05:02 +0800
Message-ID: <CACGkMEtExrXA-fz1pBCoGHE8JoxbXumALd8OXWDNv3NCtzZXsQ@mail.gmail.com>
Subject: Re: [PATCH RFC v5 06/10] tun: Introduce virtio-net hash reporting feature
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 8, 2024 at 2:55=E2=80=AFPM Akihiko Odaki <akihiko.odaki@daynix.=
com> wrote:
>
> Allow the guest to reuse the hash value to make receive steering
> consistent between the host and guest, and to save hash computation.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>

I wonder if this would cause overhead when hash reporting is not enabled?

> ---
>  Documentation/networking/tuntap.rst |   7 +++
>  drivers/net/Kconfig                 |   1 +
>  drivers/net/tap.c                   |  45 ++++++++++++++--

Tile should be for tap as well or is this just for tun?

>  drivers/net/tun.c                   |  46 ++++++++++++----
>  drivers/net/tun_vnet.h              | 102 ++++++++++++++++++++++++++++++=
+-----
>  include/linux/if_tap.h              |   2 +
>  include/uapi/linux/if_tun.h         |  48 +++++++++++++++++
>  7 files changed, 223 insertions(+), 28 deletions(-)
>
> diff --git a/Documentation/networking/tuntap.rst b/Documentation/networki=
ng/tuntap.rst
> index 4d7087f727be..86b4ae8caa8a 100644
> --- a/Documentation/networking/tuntap.rst
> +++ b/Documentation/networking/tuntap.rst
> @@ -206,6 +206,13 @@ enable is true we enable it, otherwise we disable it=
::
>        return ioctl(fd, TUNSETQUEUE, (void *)&ifr);
>    }
>
> +3.4 Reference
> +-------------
> +
> +``linux/if_tun.h`` defines the interface described below:
> +
> +.. kernel-doc:: include/uapi/linux/if_tun.h
> +
>  Universal TUN/TAP device driver Frequently Asked Question
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 9920b3a68ed1..e2a7bd703550 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -395,6 +395,7 @@ config TUN
>         tristate "Universal TUN/TAP device driver support"
>         depends on INET
>         select CRC32
> +       select SKB_EXTENSIONS

Then we need this for macvtap at least as well?

>         help
>           TUN/TAP provides packet reception and transmission for user spa=
ce
>           programs.  It can be viewed as a simple Point-to-Point or Ether=
net
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index 9a34ceed0c2c..5e2fbe63ca47 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -179,6 +179,16 @@ static void tap_put_queue(struct tap_queue *q)
>         sock_put(&q->sk);
>  }
>
> +static struct virtio_net_hash *tap_add_hash(struct sk_buff *skb)
> +{
> +       return (struct virtio_net_hash *)skb->cb;

Any reason that tap uses skb->cb but not skb extensions? (And is it
safe to use that without cloning?)

> +}
> +
> +static const struct virtio_net_hash *tap_find_hash(const struct sk_buff =
*skb)
> +{
> +       return (const struct virtio_net_hash *)skb->cb;
> +}
> +
>  /*
>   * Select a queue based on the rxq of the device on which this packet
>   * arrived. If the incoming device is not mq, calculate a flow hash
> @@ -189,6 +199,7 @@ static void tap_put_queue(struct tap_queue *q)
>  static struct tap_queue *tap_get_queue(struct tap_dev *tap,
>                                        struct sk_buff *skb)
>  {
> +       struct flow_keys_basic keys_basic;
>         struct tap_queue *queue =3D NULL;
>         /* Access to taps array is protected by rcu, but access to numvta=
ps
>          * isn't. Below we use it to lookup a queue, but treat it as a hi=
nt
> @@ -198,15 +209,32 @@ static struct tap_queue *tap_get_queue(struct tap_d=
ev *tap,
>         int numvtaps =3D READ_ONCE(tap->numvtaps);
>         __u32 rxq;
>
> +       *tap_add_hash(skb) =3D (struct virtio_net_hash) { .report =3D VIR=
TIO_NET_HASH_REPORT_NONE };
> +
>         if (!numvtaps)
>                 goto out;
>
>         if (numvtaps =3D=3D 1)
>                 goto single;
>
> +       if (!skb->l4_hash && !skb->sw_hash) {
> +               struct flow_keys keys;
> +
> +               skb_flow_dissect_flow_keys(skb, &keys, FLOW_DISSECTOR_F_S=
TOP_AT_FLOW_LABEL);
> +               rxq =3D flow_hash_from_keys(&keys);
> +               keys_basic =3D (struct flow_keys_basic) {
> +                       .control =3D keys.control,
> +                       .basic =3D keys.basic
> +               };
> +       } else {
> +               skb_flow_dissect_flow_keys_basic(NULL, skb, &keys_basic, =
NULL, 0, 0, 0,
> +                                                FLOW_DISSECTOR_F_STOP_AT=
_FLOW_LABEL);
> +               rxq =3D skb->hash;
> +       }
> +
>         /* Check if we can use flow to select a queue */
> -       rxq =3D skb_get_hash(skb);
>         if (rxq) {
> +               tun_vnet_hash_report(&tap->vnet_hash, skb, &keys_basic, r=
xq, tap_add_hash);
>                 queue =3D rcu_dereference(tap->taps[rxq % numvtaps]);
>                 goto out;
>         }
> @@ -713,15 +741,16 @@ static ssize_t tap_put_user(struct tap_queue *q,
>         int total;
>
>         if (q->flags & IFF_VNET_HDR) {
> -               struct virtio_net_hdr vnet_hdr;
> +               struct virtio_net_hdr_v1_hash vnet_hdr;
>
>                 vnet_hdr_len =3D READ_ONCE(q->vnet_hdr_sz);
>
> -               ret =3D tun_vnet_hdr_from_skb(q->flags, NULL, skb, &vnet_=
hdr);
> +               ret =3D tun_vnet_hdr_from_skb(vnet_hdr_len, q->flags, NUL=
L, skb,
> +                                           tap_find_hash, &vnet_hdr);
>                 if (ret < 0)
>                         goto done;
>
> -               ret =3D tun_vnet_hdr_put(vnet_hdr_len, iter, &vnet_hdr);
> +               ret =3D tun_vnet_hdr_put(vnet_hdr_len, iter, &vnet_hdr, r=
et);
>                 if (ret < 0)
>                         goto done;
>         }
> @@ -1025,7 +1054,13 @@ static long tap_ioctl(struct file *file, unsigned =
int cmd,
>                 return ret;
>
>         default:
> -               return tun_vnet_ioctl(&q->vnet_hdr_sz, &q->flags, cmd, sp=
);
> +               rtnl_lock();
> +               tap =3D rtnl_dereference(q->tap);
> +               ret =3D tun_vnet_ioctl(&q->vnet_hdr_sz, &q->flags,
> +                                    tap ? &tap->vnet_hash : NULL, -EINVA=
L,
> +                                    cmd, sp);
> +               rtnl_unlock();
> +               return ret;
>         }
>  }
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index dd8799d19518..27308417b834 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -209,6 +209,7 @@ struct tun_struct {
>         struct bpf_prog __rcu *xdp_prog;
>         struct tun_prog __rcu *steering_prog;
>         struct tun_prog __rcu *filter_prog;
> +       struct tun_vnet_hash vnet_hash;
>         struct ethtool_link_ksettings link_ksettings;
>         /* init args */
>         struct file *file;
> @@ -451,6 +452,16 @@ static inline void tun_flow_save_rps_rxhash(struct t=
un_flow_entry *e, u32 hash)
>                 e->rps_rxhash =3D hash;
>  }
>
> +static struct virtio_net_hash *tun_add_hash(struct sk_buff *skb)
> +{
> +       return skb_ext_add(skb, SKB_EXT_TUN_VNET_HASH);
> +}
> +
> +static const struct virtio_net_hash *tun_find_hash(const struct sk_buff =
*skb)
> +{
> +       return skb_ext_find(skb, SKB_EXT_TUN_VNET_HASH);
> +}
> +
>  /* We try to identify a flow through its rxhash. The reason that
>   * we do not check rxq no. is because some cards(e.g 82599), chooses
>   * the rxq based on the txq where the last packet of the flow comes. As
> @@ -459,12 +470,17 @@ static inline void tun_flow_save_rps_rxhash(struct =
tun_flow_entry *e, u32 hash)
>   */
>  static u16 tun_automq_select_queue(struct tun_struct *tun, struct sk_buf=
f *skb)
>  {
> +       struct flow_keys keys;
> +       struct flow_keys_basic keys_basic;
>         struct tun_flow_entry *e;
>         u32 txq, numqueues;
>
>         numqueues =3D READ_ONCE(tun->numqueues);
>
> -       txq =3D __skb_get_hash_symmetric(skb);
> +       memset(&keys, 0, sizeof(keys));
> +       skb_flow_dissect(skb, &flow_keys_dissector_symmetric, &keys, 0);
> +
> +       txq =3D flow_hash_from_keys(&keys);
>         e =3D tun_flow_find(&tun->flows[tun_hashfn(txq)], txq);
>         if (e) {
>                 tun_flow_save_rps_rxhash(e, txq);
> @@ -473,6 +489,13 @@ static u16 tun_automq_select_queue(struct tun_struct=
 *tun, struct sk_buff *skb)
>                 txq =3D reciprocal_scale(txq, numqueues);
>         }
>
> +       keys_basic =3D (struct flow_keys_basic) {
> +               .control =3D keys.control,
> +               .basic =3D keys.basic
> +       };
> +       tun_vnet_hash_report(&tun->vnet_hash, skb, &keys_basic, skb->l4_h=
ash ? skb->hash : txq,
> +                            tun_add_hash);

Is using txq required when not l4_hash is required by the virtio-spec?

> +
>         return txq;
>  }
>
> @@ -1990,10 +2013,8 @@ static ssize_t tun_put_user_xdp(struct tun_struct =
*tun,
>         size_t total;
>
>         if (tun->flags & IFF_VNET_HDR) {
> -               struct virtio_net_hdr gso =3D { 0 };
> -
>                 vnet_hdr_sz =3D READ_ONCE(tun->vnet_hdr_sz);
> -               ret =3D tun_vnet_hdr_put(vnet_hdr_sz, iter, &gso);
> +               ret =3D tun_vnet_hdr_put(vnet_hdr_sz, iter, NULL, 0);
>                 if (ret < 0)
>                         return ret;
>         }
> @@ -2018,7 +2039,6 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>         int vlan_offset =3D 0;
>         int vlan_hlen =3D 0;
>         int vnet_hdr_sz =3D 0;
> -       int ret;
>
>         if (skb_vlan_tag_present(skb))
>                 vlan_hlen =3D VLAN_HLEN;
> @@ -2043,13 +2063,15 @@ static ssize_t tun_put_user(struct tun_struct *tu=
n,
>         }
>
>         if (vnet_hdr_sz) {
> -               struct virtio_net_hdr gso;
> +               struct virtio_net_hdr_v1_hash gso;
> +               int ret;
>
> -               ret =3D tun_vnet_hdr_from_skb(tun->flags, tun->dev, skb, =
&gso);
> +               ret =3D tun_vnet_hdr_from_skb(vnet_hdr_sz, tun->flags, tu=
n->dev, skb,
> +                                           tun_find_hash, &gso);
>                 if (ret < 0)
>                         goto done;
>
> -               ret =3D tun_vnet_hdr_put(vnet_hdr_sz, iter, &gso);
> +               ret =3D tun_vnet_hdr_put(vnet_hdr_sz, iter, &gso, ret);
>                 if (ret < 0)
>                         goto done;
>         }
> @@ -3055,9 +3077,10 @@ static long __tun_chr_ioctl(struct file *file, uns=
igned int cmd,
>                 goto unlock;
>         }
>
> -       ret =3D -EBADFD;
> -       if (!tun)
> +       if (!tun) {
> +               ret =3D tun_vnet_ioctl(NULL, NULL, NULL, -EBADFD, cmd, ar=
gp);

This seems not elegant (passing three NULL pointers). Any reason we
can't just modify __tun_chr_ioctl() instead of introducing things like
tun_vnet_ioctl()?

>                 goto unlock;
> +       }
>
>         netif_info(tun, drv, tun->dev, "tun_chr_ioctl cmd %u\n", cmd);
>
> @@ -3256,7 +3279,8 @@ static long __tun_chr_ioctl(struct file *file, unsi=
gned int cmd,
>                 break;
>
>         default:
> -               ret =3D tun_vnet_ioctl(&tun->vnet_hdr_sz, &tun->flags, cm=
d, argp);
> +               ret =3D tun_vnet_ioctl(&tun->vnet_hdr_sz, &tun->flags,
> +                                    &tun->vnet_hash, -EINVAL, cmd, argp)=
;
>         }
>
>         if (do_notify)
> diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h
> index c40bde0fdf8c..589a97dd7d02 100644
> --- a/drivers/net/tun_vnet.h
> +++ b/drivers/net/tun_vnet.h
> @@ -6,6 +6,9 @@
>  #define TUN_VNET_LE 0x80000000
>  #define TUN_VNET_BE 0x40000000
>
> +typedef struct virtio_net_hash *(*tun_vnet_hash_add)(struct sk_buff *);
> +typedef const struct virtio_net_hash *(*tun_vnet_hash_find)(const struct=
 sk_buff *);
> +
>  static inline bool tun_vnet_legacy_is_little_endian(unsigned int flags)
>  {
>         return !(IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE) && (flags & TUN_VNE=
T_BE)) &&
> @@ -59,18 +62,31 @@ static inline __virtio16 cpu_to_tun_vnet16(unsigned i=
nt flags, u16 val)
>  }
>
>  static inline long tun_vnet_ioctl(int *sz, unsigned int *flags,
> -                                 unsigned int cmd, int __user *sp)
> +                                 struct tun_vnet_hash *hash, long fallba=
ck,
> +                                 unsigned int cmd, void __user *argp)
>  {
> +       static const struct tun_vnet_hash cap =3D {
> +               .flags =3D TUN_VNET_HASH_REPORT,
> +               .types =3D VIRTIO_NET_SUPPORTED_HASH_TYPES
> +       };

Let's find a way to reuse virtio-net uAPI instead of introducing new
stuff to stress the management layer.

> +       struct tun_vnet_hash hash_buf;
> +       int __user *sp =3D argp;
>         int s;
>
>         switch (cmd) {
>         case TUNGETVNETHDRSZ:
> +               if (!sz)
> +                       return -EBADFD;
> +
>                 s =3D *sz;
>                 if (put_user(s, sp))
>                         return -EFAULT;
>                 return 0;
>
>         case TUNSETVNETHDRSZ:
> +               if (!sz)
> +                       return -EBADFD;
> +
>                 if (get_user(s, sp))
>                         return -EFAULT;
>                 if (s < (int)sizeof(struct virtio_net_hdr))
> @@ -80,12 +96,18 @@ static inline long tun_vnet_ioctl(int *sz, unsigned i=
nt *flags,
>                 return 0;
>
>         case TUNGETVNETLE:
> +               if (!flags)
> +                       return -EBADFD;
> +
>                 s =3D !!(*flags & TUN_VNET_LE);
>                 if (put_user(s, sp))
>                         return -EFAULT;
>                 return 0;
>
>         case TUNSETVNETLE:
> +               if (!flags)
> +                       return -EBADFD;
> +
>                 if (get_user(s, sp))
>                         return -EFAULT;
>                 if (s)
> @@ -95,16 +117,56 @@ static inline long tun_vnet_ioctl(int *sz, unsigned =
int *flags,
>                 return 0;
>
>         case TUNGETVNETBE:
> +               if (!flags)
> +                       return -EBADFD;
> +
>                 return tun_vnet_get_be(*flags, sp);
>
>         case TUNSETVNETBE:
> +               if (!flags)
> +                       return -EBADFD;
> +
>                 return tun_vnet_set_be(flags, sp);
>
> +       case TUNGETVNETHASHCAP:
> +               return copy_to_user(argp, &cap, sizeof(cap)) ? -EFAULT : =
0;
> +
> +       case TUNSETVNETHASH:
> +               if (!hash)
> +                       return -EBADFD;
> +
> +               if (copy_from_user(&hash_buf, argp, sizeof(hash_buf)))
> +                       return -EFAULT;
> +
> +               *hash =3D hash_buf;
> +               return 0;
> +
>         default:
> -               return -EINVAL;
> +               return fallback;
>         }
>  }
>
> +static inline void tun_vnet_hash_report(const struct tun_vnet_hash *hash=
,
> +                                       struct sk_buff *skb,
> +                                       const struct flow_keys_basic *key=
s,
> +                                       u32 value,
> +                                       tun_vnet_hash_add vnet_hash_add)
> +{
> +       struct virtio_net_hash *report;
> +
> +       if (!(hash->flags & TUN_VNET_HASH_REPORT))
> +               return;
> +
> +       report =3D vnet_hash_add(skb);
> +       if (!report)
> +               return;
> +
> +       *report =3D (struct virtio_net_hash) {
> +               .report =3D virtio_net_hash_report(hash->types, keys),
> +               .value =3D value
> +       };
> +}
> +
>  static inline int tun_vnet_hdr_get(int sz, unsigned int flags,
>                                    struct iov_iter *from,
>                                    struct virtio_net_hdr *hdr)
> @@ -130,15 +192,15 @@ static inline int tun_vnet_hdr_get(int sz, unsigned=
 int flags,
>  }
>
>  static inline int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
> -                                  const struct virtio_net_hdr *hdr)
> +                                  const void *hdr, int content_sz)
>  {
>         if (iov_iter_count(iter) < sz)
>                 return -EINVAL;
>
> -       if (copy_to_iter(hdr, sizeof(*hdr), iter) !=3D sizeof(*hdr))
> +       if (copy_to_iter(hdr, content_sz, iter) !=3D content_sz)
>                 return -EFAULT;
>
> -       if (iov_iter_zero(sz - sizeof(*hdr), iter) !=3D sz - sizeof(*hdr)=
)
> +       if (iov_iter_zero(sz - content_sz, iter) !=3D sz - content_sz)
>                 return -EFAULT;
>
>         return 0;
> @@ -151,32 +213,48 @@ static inline int tun_vnet_hdr_to_skb(unsigned int =
flags,
>         return virtio_net_hdr_to_skb(skb, hdr, tun_vnet_is_little_endian(=
flags));
>  }
>
> -static inline int tun_vnet_hdr_from_skb(unsigned int flags,
> +static inline int tun_vnet_hdr_from_skb(int sz, unsigned int flags,
>                                         const struct net_device *dev,
>                                         const struct sk_buff *skb,
> -                                       struct virtio_net_hdr *hdr)
> +                                       tun_vnet_hash_find vnet_hash_find=
,
> +                                       struct virtio_net_hdr_v1_hash *hd=
r)
>  {
>         int vlan_hlen =3D skb_vlan_tag_present(skb) ? VLAN_HLEN : 0;
> +       const struct virtio_net_hash *report =3D sz < sizeof(struct virti=
o_net_hdr_v1_hash) ?
> +                                              NULL : vnet_hash_find(skb)=
;
> +       int content_sz;
> +
> +       if (report) {
> +               content_sz =3D sizeof(struct virtio_net_hdr_v1_hash);
> +
> +               *hdr =3D (struct virtio_net_hdr_v1_hash) {
> +                       .hdr =3D { .num_buffers =3D __cpu_to_virtio16(tru=
e, 1) },
> +                       .hash_value =3D cpu_to_le32(report->value),
> +                       .hash_report =3D cpu_to_le16(report->report)
> +               };
> +       } else {
> +               content_sz =3D sizeof(struct virtio_net_hdr);
> +       }
>
> -       if (virtio_net_hdr_from_skb(skb, hdr,
> +       if (virtio_net_hdr_from_skb(skb, (struct virtio_net_hdr *)hdr,
>                                     tun_vnet_is_little_endian(flags), tru=
e,
>                                     vlan_hlen)) {
>                 struct skb_shared_info *sinfo =3D skb_shinfo(skb);
>
>                 if (net_ratelimit()) {
>                         netdev_err(dev, "unexpected GSO type: 0x%x, gso_s=
ize %d, hdr_len %d\n",
> -                                  sinfo->gso_type, tun_vnet16_to_cpu(fla=
gs, hdr->gso_size),
> -                                  tun_vnet16_to_cpu(flags, hdr->hdr_len)=
);
> +                                  sinfo->gso_type, tun_vnet16_to_cpu(fla=
gs, hdr->hdr.gso_size),
> +                                  tun_vnet16_to_cpu(flags, hdr->hdr.hdr_=
len));
>                         print_hex_dump(KERN_ERR, "tun: ",
>                                        DUMP_PREFIX_NONE,
>                                        16, 1, skb->head,
> -                                      min(tun_vnet16_to_cpu(flags, hdr->=
hdr_len), 64), true);
> +                                      min(tun_vnet16_to_cpu(flags, hdr->=
hdr.hdr_len), 64), true);
>                 }
>                 WARN_ON_ONCE(1);
>                 return -EINVAL;
>         }
>
> -       return 0;
> +       return content_sz;
>  }
>
>  #endif /* TUN_VNET_H */
> diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
> index 553552fa635c..5bbb343a6dba 100644
> --- a/include/linux/if_tap.h
> +++ b/include/linux/if_tap.h
> @@ -4,6 +4,7 @@
>
>  #include <net/sock.h>
>  #include <linux/skb_array.h>
> +#include <uapi/linux/if_tun.h>
>
>  struct file;
>  struct socket;
> @@ -43,6 +44,7 @@ struct tap_dev {
>         int                     numqueues;
>         netdev_features_t       tap_features;
>         int                     minor;
> +       struct tun_vnet_hash    vnet_hash;
>
>         void (*update_features)(struct tap_dev *tap, netdev_features_t fe=
atures);
>         void (*count_tx_dropped)(struct tap_dev *tap);
> diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
> index 287cdc81c939..d11e79b4e0dc 100644
> --- a/include/uapi/linux/if_tun.h
> +++ b/include/uapi/linux/if_tun.h
> @@ -62,6 +62,34 @@
>  #define TUNSETCARRIER _IOW('T', 226, int)
>  #define TUNGETDEVNETNS _IO('T', 227)
>
> +/**
> + * define TUNGETVNETHASHCAP - ioctl to get virtio_net hashing capability=
.
> + *
> + * The argument is a pointer to &struct tun_vnet_hash which will store t=
he
> + * maximal virtio_net hashing configuration.
> + */
> +#define TUNGETVNETHASHCAP _IOR('T', 228, struct tun_vnet_hash)
> +
> +/**
> + * define TUNSETVNETHASH - ioctl to configure virtio_net hashing
> + *
> + * The argument is a pointer to &struct tun_vnet_hash.
> + *
> + * The %TUN_VNET_HASH_REPORT flag set with this ioctl will be effective =
only
> + * after calling the %TUNSETVNETHDRSZ ioctl with a number greater than o=
r equal
> + * to the size of &struct virtio_net_hdr_v1_hash.

I think we don't need & here.

> + *
> + * The members added to the legacy header by %TUN_VNET_HASH_REPORT flag =
will
> + * always be little-endian.
> + *
> + * This ioctl results in %EBADFD if the underlying device is deleted. It=
 affects
> + * all queues attached to the same device.
> + *
> + * This ioctl currently has no effect on XDP packets and packets with
> + * queue_mapping set by TC.

This needs to be fixed?

> + */
> +#define TUNSETVNETHASH _IOW('T', 229, struct tun_vnet_hash)
> +
>  /* TUNSETIFF ifr flags */
>  #define IFF_TUN                0x0001
>  #define IFF_TAP                0x0002
> @@ -115,4 +143,24 @@ struct tun_filter {
>         __u8   addr[][ETH_ALEN];
>  };
>
> +/**
> + * define TUN_VNET_HASH_REPORT - Request virtio_net hash reporting for v=
host
> + */
> +#define TUN_VNET_HASH_REPORT   0x0001
> +
> +/**
> + * struct tun_vnet_hash - virtio_net hashing configuration
> + * @flags:
> + *             Bitmask consists of %TUN_VNET_HASH_REPORT and %TUN_VNET_H=
ASH_RSS

Could we reuse TUNGETIFF by introduce new IFF_XXX stuffs?

> + * @pad:
> + *             Should be filled with zero before passing to %TUNSETVNETH=
ASH
> + * @types:
> + *             Bitmask of allowed hash types

What are they?

> + */
> +struct tun_vnet_hash {
> +       __u16 flags;
> +       __u8 pad[2];
> +       __u32 types;
> +};
> +
>  #endif /* _UAPI__IF_TUN_H */
>
> --
> 2.46.2
>

Thanks


