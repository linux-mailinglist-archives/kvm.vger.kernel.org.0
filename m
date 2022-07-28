Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E5058370E
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 04:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbiG1CjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 22:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237769AbiG1CjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 22:39:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 303F05A8A6
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 19:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658975947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ymtTMNSBtFOhhmPgtQl8t8lfFLbeHZYYSYD2cD7gjw=;
        b=QBCh3KK50GFUx38IMhBMt404Mu9V0AFHLXGLOrjPioyWrmOTXpCMKpz6lINE7fhWH724Cd
        KA6wUB/IBUau2eo29kS1tNxn3NUxOmraVWEBBtAp7fQ50kozt6qEOGPWjHMV208iS0/hmo
        EppBbO/NcNfbHNhxU85zV6vCyVQHqX4=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-kYnRypCHP5m4RRLtVWEPyg-1; Wed, 27 Jul 2022 22:39:04 -0400
X-MC-Unique: kYnRypCHP5m4RRLtVWEPyg-1
Received: by mail-lf1-f70.google.com with SMTP id a19-20020a19f813000000b0048a7379e38bso225123lff.5
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 19:39:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5ymtTMNSBtFOhhmPgtQl8t8lfFLbeHZYYSYD2cD7gjw=;
        b=TIQP94SjPkvscizRCPFneUV0L8jHPPeHkixbfzT7DSMkE7wS0C6sdU+I3qVILbvdE+
         lm/CLLYvgYPGVuydegXN3bOgq2tidPra/iVLu1X+fCY0x6M4O5RyUyTIVAqLcPpWgfUO
         W3Pk0hg085MV1NCF7tj8lvuU7kvDb8CUsZuDCOgYEaLVvfvjTQbzi2L2KloNOyn4WGK4
         FQXQ/HTcFs9RD3rpv9XiG7et3w0z0zepZ/IRTVO7CSuAvsTvIpNPn80auDAcmUjvcz8a
         Ox6rYLPSj7Fe0foKC9uduGK96P9Wf1Vixrf3NDzWUhbqU3p8cS+di7b8Hf4mG4AQz+ic
         XVsw==
X-Gm-Message-State: AJIora/HC9WBWqujTMnFcmdvTrfxWjw9/iA4E2DPTBeWrkm62Xgkmbbg
        z6j5nsbA2WYlIFne+ZWvN9IyWwx1GDfqpIpgU5nIGdZtEDw2rTMBjxlaBSyxEMVkO4PgOGCEsyj
        AdYvyyrBjU4RPGNvPgV/8tM4RagAV
X-Received: by 2002:a05:651c:2103:b0:25d:6478:2a57 with SMTP id a3-20020a05651c210300b0025d64782a57mr8391227ljq.496.1658975943183;
        Wed, 27 Jul 2022 19:39:03 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uHdGB5CGdI+a5RxWiQio7u+TOL7GEOspu6vejhdOqf5wuC1xMtb49c5PXiFMMNBwahHTh2HSqnjfW+BjjqQXo=
X-Received: by 2002:a05:651c:2103:b0:25d:6478:2a57 with SMTP id
 a3-20020a05651c210300b0025d64782a57mr8391199ljq.496.1658975942872; Wed, 27
 Jul 2022 19:39:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
 <20220726072225.19884-17-xuanzhuo@linux.alibaba.com> <15aa26f2-f8af-5dbd-f2b2-9270ad873412@redhat.com>
 <1658907413.1860468-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1658907413.1860468-2-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 28 Jul 2022 10:38:51 +0800
Message-ID: <CACGkMEvxsOfiiaWWAR8P68GY1yfwgTvaAbHk1JF7pTw-o2k25w@mail.gmail.com>
Subject: Re: [PATCH v13 16/42] virtio_ring: split: introduce virtqueue_resize_split()
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
        Kangjie Xu <kangjie.xu@linux.alibaba.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 27, 2022 at 3:44 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrot=
e:
>
> On Wed, 27 Jul 2022 11:12:19 +0800, Jason Wang <jasowang@redhat.com> wrot=
e:
> >
> > =E5=9C=A8 2022/7/26 15:21, Xuan Zhuo =E5=86=99=E9=81=93:
> > > virtio ring split supports resize.
> > >
> > > Only after the new vring is successfully allocated based on the new n=
um,
> > > we will release the old vring. In any case, an error is returned,
> > > indicating that the vring still points to the old vring.
> > >
> > > In the case of an error, re-initialize(virtqueue_reinit_split()) the
> > > virtqueue to ensure that the vring can be used.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > >   drivers/virtio/virtio_ring.c | 34 +++++++++++++++++++++++++++++++++=
+
> > >   1 file changed, 34 insertions(+)
> > >
> > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_rin=
g.c
> > > index b6fda91c8059..58355e1ac7d7 100644
> > > --- a/drivers/virtio/virtio_ring.c
> > > +++ b/drivers/virtio/virtio_ring.c
> > > @@ -220,6 +220,7 @@ static struct virtqueue *__vring_new_virtqueue(un=
signed int index,
> > >                                            void (*callback)(struct vi=
rtqueue *),
> > >                                            const char *name);
> > >   static struct vring_desc_extra *vring_alloc_desc_extra(unsigned int=
 num);
> > > +static void vring_free(struct virtqueue *_vq);
> > >
> > >   /*
> > >    * Helpers.
> > > @@ -1117,6 +1118,39 @@ static struct virtqueue *vring_create_virtqueu=
e_split(
> > >     return vq;
> > >   }
> > >
> > > +static int virtqueue_resize_split(struct virtqueue *_vq, u32 num)
> > > +{
> > > +   struct vring_virtqueue_split vring_split =3D {};
> > > +   struct vring_virtqueue *vq =3D to_vvq(_vq);
> > > +   struct virtio_device *vdev =3D _vq->vdev;
> > > +   int err;
> > > +
> > > +   err =3D vring_alloc_queue_split(&vring_split, vdev, num,
> > > +                                 vq->split.vring_align,
> > > +                                 vq->split.may_reduce_num);
> > > +   if (err)
> > > +           goto err;
> >
> >
> > I think we don't need to do anything here?
>
> Am I missing something?

I meant it looks to me most of the virtqueue_reinit() is unnecessary.
We probably only need to reinit avail/used idx there.

Thanks

>
> >
> >
> > > +
> > > +   err =3D vring_alloc_state_extra_split(&vring_split);
> > > +   if (err) {
> > > +           vring_free_split(&vring_split, vdev);
> > > +           goto err;
> >
> >
> > I suggest to move vring_free_split() into a dedicated error label.
>
> Will change.
>
> Thanks.
>
>
> >
> > Thanks
> >
> >
> > > +   }
> > > +
> > > +   vring_free(&vq->vq);
> > > +
> > > +   virtqueue_vring_init_split(&vring_split, vq);
> > > +
> > > +   virtqueue_init(vq, vring_split.vring.num);
> > > +   virtqueue_vring_attach_split(vq, &vring_split);
> > > +
> > > +   return 0;
> > > +
> > > +err:
> > > +   virtqueue_reinit_split(vq);
> > > +   return -ENOMEM;
> > > +}
> > > +
> > >
> > >   /*
> > >    * Packed ring specific functions - *_packed().
> >
>

