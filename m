Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140595898BD
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 09:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238862AbiHDHxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 03:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238903AbiHDHxt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 03:53:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F9476554B
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 00:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659599626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p5pJ4vT8W9lschBMc1OdFDNJ7KAv4QhAYE1/fksJYk8=;
        b=cBgRCwx9bcagRUXPd2Rc+hI6I/4wmPVh79G0mjXH0FtmqKm2nbEpFMhAcsr4Tbo4IkWs68
        a98ftMaIjVJgrbKIRjdYn2t/i3+lrCmikinNdOQEkZ3cW9MQQpe2ffHJ3usCDJcDLGiz06
        BefJP45HAfUmFC/gUxNNTzeyBKFC4eo=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-YJW8Eja0Ps614X9OM3ppdg-1; Thu, 04 Aug 2022 03:53:44 -0400
X-MC-Unique: YJW8Eja0Ps614X9OM3ppdg-1
Received: by mail-lj1-f199.google.com with SMTP id h18-20020a2e9012000000b0025e4f48d24dso2836442ljg.10
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 00:53:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p5pJ4vT8W9lschBMc1OdFDNJ7KAv4QhAYE1/fksJYk8=;
        b=k3j1CabGuvLM4Exu2TOTUbxu5jMYTu21K53WL7iG9TiSCuIJIBtMAFJwJGVHjb9jKh
         PzXYwGg+i3h/5N8SVZ7rPP2VID+NjFVd0AhSrQh70mSDbnrKZswfWTYYaDOtIwbx+e6A
         4zsChOfmigdUpgsX5PuivIKNkF+8okvTLaoaPtmRtefTiBD7fwOM4c1WP9Jb+9vi9ROI
         TBzI78FbOthKTJD3Gw9ncIMs1zybjydbC2DRmzfBF0OhK70Dxfl0s7phr4SJ9k+MOJGj
         MkSmL9NlgDsIu5OWmHRhLyK6fbhHgC9pEsx2v2vnmEdzJZKDMfHrAXFO1JWRbmBYxSvB
         YlWQ==
X-Gm-Message-State: ACgBeo0Fh/PnD2zfC9u0DwlkWE8eJqiNaRBQn1E6Cxm3rCDhOefWOIn9
        jC64AqVk5RgHYkGZbttPZ7V8BQKF/k+vFLNNzqifU61du7wGQ23TB+Fbv3FXJmxRizAtlVNkroe
        vOe0Q1Ci8pBkSk4XNK5RGRNvmbQsL
X-Received: by 2002:a05:651c:2103:b0:25d:6478:2a57 with SMTP id a3-20020a05651c210300b0025d64782a57mr192295ljq.496.1659599623351;
        Thu, 04 Aug 2022 00:53:43 -0700 (PDT)
X-Google-Smtp-Source: AA6agR77h50JZbDLdow9b/rL2hz22Xc6xmVQDqQR5Tp3yI2A4iDS/sL66r+cEBOc3mtCs6y2407g9U5Fb2iXzox6dxw=
X-Received: by 2002:a05:651c:2103:b0:25d:6478:2a57 with SMTP id
 a3-20020a05651c210300b0025d64782a57mr192281ljq.496.1659599623181; Thu, 04 Aug
 2022 00:53:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220803171821.481336-1-eperezma@redhat.com> <20220803171821.481336-7-eperezma@redhat.com>
 <c25c142f-ad9d-a5cf-9837-5570d563ad07@redhat.com> <CAJaqyWd8ddjFLk=C=Mw_6o2=+0w=ior5fvCV2jSMx7LodVnmAA@mail.gmail.com>
In-Reply-To: <CAJaqyWd8ddjFLk=C=Mw_6o2=+0w=ior5fvCV2jSMx7LodVnmAA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 4 Aug 2022 15:53:26 +0800
Message-ID: <CACGkMEuDm1uACYL+NgKw9BEo1UpKRb0CoDh04SZeUuNbGTbJAA@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] vhost_net: Add NetClientInfo prepare callback
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     qemu-level <qemu-devel@nongnu.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Parav Pandit <parav@mellanox.com>, Cindy Lu <lulu@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 4, 2022 at 3:52 PM Eugenio Perez Martin <eperezma@redhat.com> w=
rote:
>
> On Thu, Aug 4, 2022 at 6:46 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> >
> > =E5=9C=A8 2022/8/4 01:18, Eugenio P=C3=A9rez =E5=86=99=E9=81=93:
> > > This is used by the backend to perform actions before the device is
> > > started.
> > >
> > > In particular, vdpa will use it to isolate CVQ in its own ASID if
> > > possible, and start SVQ unconditionally only in CVQ.
> > >
> > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > ---
> > >   include/net/net.h  | 2 ++
> > >   hw/net/vhost_net.c | 4 ++++
> > >   2 files changed, 6 insertions(+)
> > >
> > > diff --git a/include/net/net.h b/include/net/net.h
> > > index a8d47309cd..efa6448886 100644
> > > --- a/include/net/net.h
> > > +++ b/include/net/net.h
> > > @@ -44,6 +44,7 @@ typedef struct NICConf {
> > >
> > >   typedef void (NetPoll)(NetClientState *, bool enable);
> > >   typedef bool (NetCanReceive)(NetClientState *);
> > > +typedef void (NetPrepare)(NetClientState *);
> > >   typedef int (NetLoad)(NetClientState *);
> > >   typedef ssize_t (NetReceive)(NetClientState *, const uint8_t *, siz=
e_t);
> > >   typedef ssize_t (NetReceiveIOV)(NetClientState *, const struct iove=
c *, int);
> > > @@ -72,6 +73,7 @@ typedef struct NetClientInfo {
> > >       NetReceive *receive_raw;
> > >       NetReceiveIOV *receive_iov;
> > >       NetCanReceive *can_receive;
> > > +    NetPrepare *prepare;
> > >       NetLoad *load;
> > >       NetCleanup *cleanup;
> > >       LinkStatusChanged *link_status_changed;
> > > diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
> > > index a9bf72dcda..bbbb6d759b 100644
> > > --- a/hw/net/vhost_net.c
> > > +++ b/hw/net/vhost_net.c
> > > @@ -244,6 +244,10 @@ static int vhost_net_start_one(struct vhost_net =
*net,
> > >       struct vhost_vring_file file =3D { };
> > >       int r;
> > >
> > > +    if (net->nc->info->prepare) {
> > > +        net->nc->info->prepare(net->nc);
> > > +    }
> >
> >
> > Any chance we can reuse load()?
> >
>
> We would be setting the ASID of CVQ after DRIVER_OK, vring
> addresses... if we move to load.

Ok, then this patch should be fine.

Thanks

>
> Thanks!
>
> > Thanks
> >
> >
> > > +
> > >       r =3D vhost_dev_enable_notifiers(&net->dev, dev);
> > >       if (r < 0) {
> > >           goto fail_notifiers;
> >
>

