Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EA6577E20
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 10:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiGRI6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 04:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbiGRI6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 04:58:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49F23192A7
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 01:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658134696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7nIMD1pZp7DvAbftOgkHoQnYaSEiIlnRZj9mFpTSWE0=;
        b=QPlH13eisJK+PF4F+OOusZO1ZgMY1xNE6GIAeLkLGMZWq7jU8Ew2a/H8RNwou5kjZKADd1
        l0ighHxQGCt02ngPrASbXYAhf4ZotDSD5F4A5gN9wDVss1JxzTGl8JRapiAx+YQLoVuMj7
        xs7RDyS52ld442s0c4SM/6q7Y69dFCE=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-TMLu0hs9MmipmYxL9hQORw-1; Mon, 18 Jul 2022 04:58:06 -0400
X-MC-Unique: TMLu0hs9MmipmYxL9hQORw-1
Received: by mail-lf1-f69.google.com with SMTP id f11-20020a05651232cb00b00489da4c3a52so4058770lfg.16
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 01:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7nIMD1pZp7DvAbftOgkHoQnYaSEiIlnRZj9mFpTSWE0=;
        b=XPfarPodzJMp3ygN95oZI6TGfKeNNg2pmyI28Y5xS4ubokJiGNnXU2Uqkuc2Jfcfb/
         PaXnL+3mjeGeU4oBb3Q7CKi84E6FuyLOFx7fA11vALbZCawzs2uCS8jcjb+/ELuXkymY
         KV5PyspuCCzYryyi7W8lYj0gtpMO+qAe8/HUCNJpJb+JBWBD7HhYNCnLrKCuryUF1jKD
         xRAuhgPQ/ffdSt8KIiDn9nP9O+1u6IRXs1EcV97sLrFSzTYM9HT4CHfP05UEJb7glAGJ
         eKJCfppC2lIwFp7tnHyimiScFUxag0A1597DBrah4em1As5H4tPQiZaeM8nt2t/196gs
         hq7A==
X-Gm-Message-State: AJIora8RS0wSViyUKYU3xtYuZKsk8plf1yzZavaAKsmoTVeQVTPGYCGL
        7cRoLRd29tpWKnnywzwk/mwYZCljcRizgrezmg0Rp3kSkmJIt74b5j0C8SUXyhNrUNjDZZgxv5L
        /QefbpifaL+mX4pat4oBoZAObeVgB
X-Received: by 2002:a05:6512:3f0f:b0:47f:6f89:326 with SMTP id y15-20020a0565123f0f00b0047f6f890326mr13647771lfa.124.1658134685247;
        Mon, 18 Jul 2022 01:58:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vD/uj0rBcjiBGY3Pz66eOvA4LBNOKix2XOGkqmNrz5XDPze6r4T1HFvAe5/PHEmMxafySmO7QbTaIHfgsMrcc=
X-Received: by 2002:a05:6512:3f0f:b0:47f:6f89:326 with SMTP id
 y15-20020a0565123f0f00b0047f6f890326mr13647755lfa.124.1658134685003; Mon, 18
 Jul 2022 01:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-40-xuanzhuo@linux.alibaba.com> <102d3b83-1ae9-a59a-16ce-251c22b7afb0@redhat.com>
 <1656986432.1164997-2-xuanzhuo@linux.alibaba.com> <CACGkMEt8MSS=tcn=Hd6WF9+btT0ccocxEd1ighRgK-V1uiWmCQ@mail.gmail.com>
 <1657873703.9301925-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1657873703.9301925-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 18 Jul 2022 16:57:53 +0800
Message-ID: <CACGkMEvgjX+67NxwrUym7CnbNFU2-=CbAXPN_UmtvDOTS1LrHA@mail.gmail.com>
Subject: Re: [PATCH v11 39/40] virtio_net: support tx queue resize
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        kangjie.xu@linux.alibaba.com,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 15, 2022 at 4:32 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrot=
e:
>
> On Fri, 8 Jul 2022 14:23:57 +0800, Jason Wang <jasowang@redhat.com> wrote=
:
> > On Tue, Jul 5, 2022 at 10:01 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> =
wrote:
> > >
> > > On Mon, 4 Jul 2022 11:45:52 +0800, Jason Wang <jasowang@redhat.com> w=
rote:
> > > >
> > > > =E5=9C=A8 2022/6/29 14:56, Xuan Zhuo =E5=86=99=E9=81=93:
> > > > > This patch implements the resize function of the tx queues.
> > > > > Based on this function, it is possible to modify the ring num of =
the
> > > > > queue.
> > > > >
> > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > ---
> > > > >   drivers/net/virtio_net.c | 48 +++++++++++++++++++++++++++++++++=
+++++++
> > > > >   1 file changed, 48 insertions(+)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 6ab16fd193e5..fd358462f802 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -135,6 +135,9 @@ struct send_queue {
> > > > >     struct virtnet_sq_stats stats;
> > > > >
> > > > >     struct napi_struct napi;
> > > > > +
> > > > > +   /* Record whether sq is in reset state. */
> > > > > +   bool reset;
> > > > >   };
> > > > >
> > > > >   /* Internal representation of a receive virtqueue */
> > > > > @@ -279,6 +282,7 @@ struct padded_vnet_hdr {
> > > > >   };
> > > > >
> > > > >   static void virtnet_rq_free_unused_buf(struct virtqueue *vq, vo=
id *buf);
> > > > > +static void virtnet_sq_free_unused_buf(struct virtqueue *vq, voi=
d *buf);
> > > > >
> > > > >   static bool is_xdp_frame(void *ptr)
> > > > >   {
> > > > > @@ -1603,6 +1607,11 @@ static void virtnet_poll_cleantx(struct re=
ceive_queue *rq)
> > > > >             return;
> > > > >
> > > > >     if (__netif_tx_trylock(txq)) {
> > > > > +           if (READ_ONCE(sq->reset)) {
> > > > > +                   __netif_tx_unlock(txq);
> > > > > +                   return;
> > > > > +           }
> > > > > +
> > > > >             do {
> > > > >                     virtqueue_disable_cb(sq->vq);
> > > > >                     free_old_xmit_skbs(sq, true);
> > > > > @@ -1868,6 +1877,45 @@ static int virtnet_rx_resize(struct virtne=
t_info *vi,
> > > > >     return err;
> > > > >   }
> > > > >
> > > > > +static int virtnet_tx_resize(struct virtnet_info *vi,
> > > > > +                        struct send_queue *sq, u32 ring_num)
> > > > > +{
> > > > > +   struct netdev_queue *txq;
> > > > > +   int err, qindex;
> > > > > +
> > > > > +   qindex =3D sq - vi->sq;
> > > > > +
> > > > > +   virtnet_napi_tx_disable(&sq->napi);
> > > > > +
> > > > > +   txq =3D netdev_get_tx_queue(vi->dev, qindex);
> > > > > +
> > > > > +   /* 1. wait all ximt complete
> > > > > +    * 2. fix the race of netif_stop_subqueue() vs netif_start_su=
bqueue()
> > > > > +    */
> > > > > +   __netif_tx_lock_bh(txq);
> > > > > +
> > > > > +   /* Prevent rx poll from accessing sq. */
> > > > > +   WRITE_ONCE(sq->reset, true);
> > > >
> > > >
> > > > Can we simply disable RX NAPI here?
> > >
> > > Disable rx napi is indeed a simple solution. But I hope that when dea=
ling with
> > > tx, it will not affect rx.
> >
> > Ok, but I think we've already synchronized with tx lock here, isn't it?
>
> Yes, do you have any questions about WRITE_ONCE()? There is a set false o=
peration
> later, I did not use lock there, so I used WRITE/READ_ONCE
> uniformly.

I mean, since we've already used tx locks somewhere, we'd better use
them here as well at least as a start.

Thanks

>
> Thanks.
>
> >
> > Thanks
> >
> > >
> > > Thanks.
> > >
> > >
> > > >
> > > > Thanks
> > > >
> > > >
> > > > > +
> > > > > +   /* Prevent the upper layer from trying to send packets. */
> > > > > +   netif_stop_subqueue(vi->dev, qindex);
> > > > > +
> > > > > +   __netif_tx_unlock_bh(txq);
> > > > > +
> > > > > +   err =3D virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_un=
used_buf);
> > > > > +   if (err)
> > > > > +           netdev_err(vi->dev, "resize tx fail: tx queue index: =
%d err: %d\n", qindex, err);
> > > > > +
> > > > > +   /* Memory barrier before set reset and start subqueue. */
> > > > > +   smp_mb();
> > > > > +
> > > > > +   WRITE_ONCE(sq->reset, false);
> > > > > +   netif_tx_wake_queue(txq);
> > > > > +
> > > > > +   virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> > > > > +   return err;
> > > > > +}
> > > > > +
> > > > >   /*
> > > > >    * Send command via the control virtqueue and check status.  Co=
mmands
> > > > >    * supported by the hypervisor, as indicated by feature bits, s=
hould
> > > >
> > >
> >
>

