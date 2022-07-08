Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7ED56B2B9
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 08:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbiGHGVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 02:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237271AbiGHGVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 02:21:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE1652CE0B
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 23:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657261268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vucI6v2UNiSkfdv0+LNa4VjRInUBJ0CkIXv+ERyy8hk=;
        b=FgMDuwjXglaB1EExow9vFBO9vMdfPJZ3MinvIC8WU2ZPUxf+Ksc887StiIaoW4GufZOLdt
        WPsJSMSDnuwQ2qJPlZmuOEPuUO7hUJUWtqAA9RwoqIGwCfWjat0aeMDZC25G8o39+Dme1V
        zx5deSF0z4nrftNEb1ncAw0hHoO2CBI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-cKhim27qPeK0pjynoueDjw-1; Fri, 08 Jul 2022 02:21:05 -0400
X-MC-Unique: cKhim27qPeK0pjynoueDjw-1
Received: by mail-lf1-f71.google.com with SMTP id e8-20020ac24e08000000b0047fad5770d2so7425023lfr.17
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 23:21:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vucI6v2UNiSkfdv0+LNa4VjRInUBJ0CkIXv+ERyy8hk=;
        b=65vEoKeOmhxAUJANpuOsr0xNPxS0wLIu5EmzG4Weq3RO2cA+mInxPW0AXIRtlnCtkM
         70v1A7UlqzOnWqbkKbDWyFx84YIBzRvvqmlncCV/6ElDF73ZpBkUramZJlzl8nCKqnCQ
         2dGJopJ0okzhcW821XJDZTyt0gAMLWy8PYzR1Vch27D32CmOMEN9yquv8N76rrgHsVd0
         blGrg0xOVS9Vaj6Gx3XUCkqYlv1iODhrO7wtUwX+sX697Jsdq2O5fpe+j7i+QsXKNJ4e
         fdT1VMtiKSb/7yN7XiJWL4fyKpX8kwDrgnbLqmcQwhDDPv9OYHoP4RdUQ7cZix25KygB
         xf2A==
X-Gm-Message-State: AJIora9VU1J0VeCbQsfPeTmvHb4CyAj+ZhV7c5iQYdFOz0rZxV/os8Gx
        i2FDh6kNW7FoIzAayBf2OZh5BGiFMD2/Iyn7gsZq3KxKZR+BaCQEgGBwDff/7ho/F6G3b14YwzA
        LNEi9wBmholKCXEkbGETPfy8tPr4u
X-Received: by 2002:a2e:9ad0:0:b0:25a:7156:26bb with SMTP id p16-20020a2e9ad0000000b0025a715626bbmr999491ljj.141.1657261263912;
        Thu, 07 Jul 2022 23:21:03 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1siGvuif2Z3b/qz6BV5rwXiRX4Y2KnHOm/sW0UQhHOR8L3Ua/tIp6J6o+V7iV6847cM54TvfHUP9+sN1Wog1zw=
X-Received: by 2002:a2e:9ad0:0:b0:25a:7156:26bb with SMTP id
 p16-20020a2e9ad0000000b0025a715626bbmr999458ljj.141.1657261263714; Thu, 07
 Jul 2022 23:21:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-39-xuanzhuo@linux.alibaba.com> <c0747cbc-685b-85a9-1931-0124124755f2@redhat.com>
 <1656986375.3420787-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1656986375.3420787-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 8 Jul 2022 14:20:52 +0800
Message-ID: <CACGkMEu80KP-ULz_CBvauRk_3XsCubMkkWv0uLnbt-wib5KOnA@mail.gmail.com>
Subject: Re: [PATCH v11 38/40] virtio_net: support rx queue resize
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
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 5, 2022 at 10:00 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrot=
e:
>
> On Mon, 4 Jul 2022 11:44:12 +0800, Jason Wang <jasowang@redhat.com> wrote=
:
> >
> > =E5=9C=A8 2022/6/29 14:56, Xuan Zhuo =E5=86=99=E9=81=93:
> > > This patch implements the resize function of the rx queues.
> > > Based on this function, it is possible to modify the ring num of the
> > > queue.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >   drivers/net/virtio_net.c | 22 ++++++++++++++++++++++
> > >   1 file changed, 22 insertions(+)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 9fe222a3663a..6ab16fd193e5 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -278,6 +278,8 @@ struct padded_vnet_hdr {
> > >     char padding[12];
> > >   };
> > >
> > > +static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *b=
uf);
> > > +
> > >   static bool is_xdp_frame(void *ptr)
> > >   {
> > >     return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> > > @@ -1846,6 +1848,26 @@ static netdev_tx_t start_xmit(struct sk_buff *=
skb, struct net_device *dev)
> > >     return NETDEV_TX_OK;
> > >   }
> > >
> > > +static int virtnet_rx_resize(struct virtnet_info *vi,
> > > +                        struct receive_queue *rq, u32 ring_num)
> > > +{
> > > +   int err, qindex;
> > > +
> > > +   qindex =3D rq - vi->rq;
> > > +
> > > +   napi_disable(&rq->napi);
> >
> >
> > Do we need to cancel the refill work here?
>
>
> I think no, napi_disable is mutually exclusive, which ensures that there =
will be
> no conflicts between them.

So this sounds similar to what I've fixed recently.

1) NAPI schedule delayed work.
2) we disable NAPI here
3) delayed work get schedule and call NAPI again

?

Thanks

>
> Thanks.
>
> >
> > Thanks
> >
> >
> > > +
> > > +   err =3D virtqueue_resize(rq->vq, ring_num, virtnet_rq_free_unused=
_buf);
> > > +   if (err)
> > > +           netdev_err(vi->dev, "resize rx fail: rx queue index: %d e=
rr: %d\n", qindex, err);
> > > +
> > > +   if (!try_fill_recv(vi, rq, GFP_KERNEL))
> > > +           schedule_delayed_work(&vi->refill, 0);
> > > +
> > > +   virtnet_napi_enable(rq->vq, &rq->napi);
> > > +   return err;
> > > +}
> > > +
> > >   /*
> > >    * Send command via the control virtqueue and check status.  Comman=
ds
> > >    * supported by the hypervisor, as indicated by feature bits, shoul=
d
> >
>

