Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB6B61367C
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 13:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJaMgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 08:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJaMgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 08:36:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FBD223
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 05:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667219720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1yhV9og6xMidPHkhKafgY9wqf2C0SYDwlTocQUt/3zo=;
        b=AIOfXiepbKjecjjMnMtHu9bHfkFSEOgE5h5hr+Pr9i3qT1HvYvFt/ES6GTaF68MhjLHBdZ
        N4hOithUvBa6Aqajf4h5v73DIh7fWLPrtGjsMMFjCtfxM/96gK8as/hhTlsspU3mKyDzk3
        dWneLzF4Z70n30HXWHrZi8HZVNCfQWw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-103-auaAzZKrMSeMr8yaQlyg8A-1; Mon, 31 Oct 2022 08:35:19 -0400
X-MC-Unique: auaAzZKrMSeMr8yaQlyg8A-1
Received: by mail-qk1-f197.google.com with SMTP id i11-20020a05620a404b00b006eeb0791c1aso9325737qko.10
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 05:35:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1yhV9og6xMidPHkhKafgY9wqf2C0SYDwlTocQUt/3zo=;
        b=7oTEovDavY/Sf020puF4ria8Ds9WDulNwfZAL/gVjPWBkcB/XwgfOLLOE3WoNji91I
         f6LdHxo67BP12Mgsm4ev5wBoe1GbkQx6+IymJdEGFj/CB+f09FcepfrrljuROLKjaAlv
         H0IdMa/6ADckeivV3RVksje9AsVcWZ7Vjfz35tgUFhfs3OxPijM+E5BKmcaSkqpIULxv
         THwtwYel2tqQh+avAOMoMqkjVmClYdmGIN469TRnBrzvtFqajNyGlQyiQ/32R/la4P/E
         BxlkMdJDht4HJPybhJOdp71ftZyXFOhW9PCBKzqFMlEbFbiE9d8RRYAxNSlxuvlAvY9I
         5PRA==
X-Gm-Message-State: ACrzQf1MlokfsnF9ZOr0i9Pb0EjUbx+amUH9VJvG+SpYTEfnOahuszdy
        xP3bVGhtsX3DK18mGaOYoeDi2ThPFfNzOkdyNmGzHECx/R79PpF2R9V6uLhKePWzCoCgR6+FOgh
        eDrrWI35xHPnl/mtod6rCMthdzWF5
X-Received: by 2002:a05:620a:2144:b0:6fa:30e6:8438 with SMTP id m4-20020a05620a214400b006fa30e68438mr2176162qkm.342.1667219718774;
        Mon, 31 Oct 2022 05:35:18 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6WHyieclkmLuJAalPbaiNPj7gaPgtxUCpcL8qtzHUfJvy4J1Q64mCt5Dq82ocfkUWl9etw4UHav8cZBz9ovN8=
X-Received: by 2002:a05:620a:2144:b0:6fa:30e6:8438 with SMTP id
 m4-20020a05620a214400b006fa30e68438mr2176130qkm.342.1667219718525; Mon, 31
 Oct 2022 05:35:18 -0700 (PDT)
MIME-Version: 1.0
References: <20221011104154.1209338-1-eperezma@redhat.com> <20221011104154.1209338-3-eperezma@redhat.com>
 <20221031041821-mutt-send-email-mst@kernel.org> <CAJaqyWcaZ32agF0CKPUU89NHj0Di9Q5kFJDsWcUwCG2q0u_kEQ@mail.gmail.com>
 <20221031082106-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221031082106-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 31 Oct 2022 13:34:42 +0100
Message-ID: <CAJaqyWdCRBL-5bBqrOyyTMqmKDEXjufaCs85+vr2E7akhNC0rg@mail.gmail.com>
Subject: Re: [PATCH v5 2/6] vdpa: Allocate SVQ unconditionally
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, Gautam Dawar <gdawar@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Cindy Lu <lulu@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Harpreet Singh Anand <hanand@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022 at 1:25 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Oct 31, 2022 at 12:56:06PM +0100, Eugenio Perez Martin wrote:
> > On Mon, Oct 31, 2022 at 9:21 AM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> > >
> > > On Tue, Oct 11, 2022 at 12:41:50PM +0200, Eugenio P=C3=A9rez wrote:
> > > > SVQ may run or not in a device depending on runtime conditions (for
> > > > example, if the device can move CVQ to its own group or not).
> > > >
> > > > Allocate the resources unconditionally, and decide later if to use =
them
> > > > or not.
> > > >
> > > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > >
> > > I applied this for now but I really dislike it that we are wasting
> > > resources like this.
> > >
> > > Can I just drop this patch from the series? It looks like things
> > > will just work anyway ...
> > >
> >
> > It will not work simply dropping this patch, because new code expects
> > SVQ vrings to be already allocated. But that is doable with more work.
> >
> > > I know, when one works on a feature it seems like everyone should
> > > enable it - but the reality is qemu already works quite well for
> > > most users and it is our resposibility to first do no harm.
> > >
> >
> > I agree, but then it is better to drop this series entirely for this
> > merge window. I think it is justified to add it at the beginning of
> > the next merge window, and to give more time for testing and adding
> > more features actually.
>
> Not sure what "then" means. You tell me - should I drop it?
>

Yes, I think it is better to drop it for this merge window, since it
is possible to both not to allocate SVQ unconditionally and to improve
the conditions where the shadow CVQ can be enabled.

> > However, I think shadow CVQ should start by default as long as the
> > device has the right set of both virtio and vdpa features. Otherwise,
> > we need another cmdline parameter, something like x-cvq-svq, and the
> > update of other layers like libvirt.
> >
> > Thanks!
>
> OK maybe that is not too bad.
>

So it would be more preferable to add more parameters?

>
> > >
> > > > ---
> > > >  hw/virtio/vhost-vdpa.c | 33 +++++++++++++++------------------
> > > >  1 file changed, 15 insertions(+), 18 deletions(-)
> > > >
> > > > diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > > > index 7f0ff4df5b..d966966131 100644
> > > > --- a/hw/virtio/vhost-vdpa.c
> > > > +++ b/hw/virtio/vhost-vdpa.c
> > > > @@ -410,6 +410,21 @@ static int vhost_vdpa_init_svq(struct vhost_de=
v *hdev, struct vhost_vdpa *v,
> > > >      int r;
> > > >      bool ok;
> > > >
> > > > +    shadow_vqs =3D g_ptr_array_new_full(hdev->nvqs, vhost_svq_free=
);
> > > > +    for (unsigned n =3D 0; n < hdev->nvqs; ++n) {
> > > > +        g_autoptr(VhostShadowVirtqueue) svq;
> > > > +
> > > > +        svq =3D vhost_svq_new(v->iova_tree, v->shadow_vq_ops,
> > > > +                            v->shadow_vq_ops_opaque);
> > > > +        if (unlikely(!svq)) {
> > > > +            error_setg(errp, "Cannot create svq %u", n);
> > > > +            return -1;
> > > > +        }
> > > > +        g_ptr_array_add(shadow_vqs, g_steal_pointer(&svq));
> > > > +    }
> > > > +
> > > > +    v->shadow_vqs =3D g_steal_pointer(&shadow_vqs);
> > > > +
> > > >      if (!v->shadow_vqs_enabled) {
> > > >          return 0;
> > > >      }
> > > > @@ -426,20 +441,6 @@ static int vhost_vdpa_init_svq(struct vhost_de=
v *hdev, struct vhost_vdpa *v,
> > > >          return -1;
> > > >      }
> > > >
> > > > -    shadow_vqs =3D g_ptr_array_new_full(hdev->nvqs, vhost_svq_free=
);
> > > > -    for (unsigned n =3D 0; n < hdev->nvqs; ++n) {
> > > > -        g_autoptr(VhostShadowVirtqueue) svq;
> > > > -
> > > > -        svq =3D vhost_svq_new(v->iova_tree, v->shadow_vq_ops,
> > > > -                            v->shadow_vq_ops_opaque);
> > > > -        if (unlikely(!svq)) {
> > > > -            error_setg(errp, "Cannot create svq %u", n);
> > > > -            return -1;
> > > > -        }
> > > > -        g_ptr_array_add(shadow_vqs, g_steal_pointer(&svq));
> > > > -    }
> > > > -
> > > > -    v->shadow_vqs =3D g_steal_pointer(&shadow_vqs);
> > > >      return 0;
> > > >  }
> > > >
> > > > @@ -580,10 +581,6 @@ static void vhost_vdpa_svq_cleanup(struct vhos=
t_dev *dev)
> > > >      struct vhost_vdpa *v =3D dev->opaque;
> > > >      size_t idx;
> > > >
> > > > -    if (!v->shadow_vqs) {
> > > > -        return;
> > > > -    }
> > > > -
> > > >      for (idx =3D 0; idx < v->shadow_vqs->len; ++idx) {
> > > >          vhost_svq_stop(g_ptr_array_index(v->shadow_vqs, idx));
> > > >      }
> > > > --
> > > > 2.31.1
> > >
>

