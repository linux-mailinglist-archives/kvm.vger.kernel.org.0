Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08287625AD0
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 14:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbiKKNAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 08:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbiKKNAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 08:00:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400F82D1F1
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 04:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668171550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZnBONThViMJVPuuW7wQadL5B0C0ITj2uYBaB3BF9e1w=;
        b=IwKvCrFIIwVtlz+UvMoH4M6kQ/SKr7Xln2xPVATXEDeX60o3ykOWXl5tm90wC4T76MbvuS
        Oofm9gVQrnwy8agvDjAGAfwx128O3I8pGxcbZbQ6cYwWDg9WjRpGWrc9qJwU/zSRIab3oe
        2YwbKhQlQ6i5x60mTOGOTSbW1mmT5+4=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-260-DbmjBd97N723VgP5fPqp-g-1; Fri, 11 Nov 2022 07:59:08 -0500
X-MC-Unique: DbmjBd97N723VgP5fPqp-g-1
Received: by mail-pj1-f69.google.com with SMTP id lx3-20020a17090b4b0300b002137705324eso5195450pjb.1
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 04:59:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZnBONThViMJVPuuW7wQadL5B0C0ITj2uYBaB3BF9e1w=;
        b=koRBkgURY23FQDCb6OhAvNA2ZNf5ZNBtBR5zKthXHNTAGsaME7MH4U5OGrN4820+47
         wcak26ESAItzSK86F1zPl4alx2wD7ANNwum1VnMLdd3acjDfzJIrmMs0dohNJdxylGyz
         fqPRC9yOThXinlRVxxbPbmP8T1OE9YeELlsykDoNscoKEROtfWzERm2V7HV43f8I+bIY
         J11r45MnX8RWwqp6Kvp764TmN4H9IEvbgBQwG7Qc0VHli0QsgGWZqA6WBOn2mPebGLtg
         0DSjuzjxpPCLsGjBmeTNYskTVe+FwDwOm8MgGjkhqYvs7CZEv8bcwhjJmw2J3KwXGwKP
         mA+A==
X-Gm-Message-State: ANoB5pkeOaDIffxHo4652mT7lqs9jbu0vd672GhMukFm8n+datxGEKJ8
        Xxhoe6ojG+3rc5ijbOQlOrwbR79jEjhn88C+eiqMdmePP2rH5JbOOOY3f63iRSmg1nxfl5IdMPU
        mvKP1fEr+tYQ/9x7V34uC81XzulIN
X-Received: by 2002:a17:902:d708:b0:186:5ce5:8022 with SMTP id w8-20020a170902d70800b001865ce58022mr2163461ply.62.1668171547627;
        Fri, 11 Nov 2022 04:59:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6U9B0fyld0TkqFb2ToxPEhYhQRwMBoz0NNTbMjmp54qIcAIr9kPIQlZ+1r6wDbHVjq3IvwQVmaMu5Y/G5DzTI=
X-Received: by 2002:a17:902:d708:b0:186:5ce5:8022 with SMTP id
 w8-20020a170902d70800b001865ce58022mr2163445ply.62.1668171547327; Fri, 11 Nov
 2022 04:59:07 -0800 (PST)
MIME-Version: 1.0
References: <20221108170755.92768-1-eperezma@redhat.com> <20221108170755.92768-6-eperezma@redhat.com>
 <56bfad97-74d2-8570-c391-83ecf9965cfd@redhat.com> <CAJaqyWd47QdBoSm9RdF2yx21hKv_=YRp3uvP13Qb9PaVksss7Q@mail.gmail.com>
 <aa82783b-b1f5-a82b-5136-1f7f7725a433@redhat.com> <CAJaqyWfmTn1_o2z2S_o=bu2mD=r0+T=1+dh_WOwbpQaYQK0YSQ@mail.gmail.com>
 <CACGkMEvQm_0VqF5q2XtWmaHXmSj0Xjg7br3ydOQVVcHJ0yb_GA@mail.gmail.com>
In-Reply-To: <CACGkMEvQm_0VqF5q2XtWmaHXmSj0Xjg7br3ydOQVVcHJ0yb_GA@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 11 Nov 2022 13:58:30 +0100
Message-ID: <CAJaqyWfYN_Y6OQ-ugdH3d4VRGBJufMLBhH47dfB0rLg=MEt47g@mail.gmail.com>
Subject: Re: [PATCH v6 05/10] vdpa: move SVQ vring features check to net/
To:     Jason Wang <jasowang@redhat.com>
Cc:     qemu-devel@nongnu.org, Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Cindy Lu <lulu@redhat.com>, Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, kvm@vger.kernel.org,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022 at 9:07 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Fri, Nov 11, 2022 at 3:56 PM Eugenio Perez Martin
> <eperezma@redhat.com> wrote:
> >
> > On Fri, Nov 11, 2022 at 8:34 AM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > >
> > > =E5=9C=A8 2022/11/10 21:09, Eugenio Perez Martin =E5=86=99=E9=81=93:
> > > > On Thu, Nov 10, 2022 at 6:40 AM Jason Wang <jasowang@redhat.com> wr=
ote:
> > > >>
> > > >> =E5=9C=A8 2022/11/9 01:07, Eugenio P=C3=A9rez =E5=86=99=E9=81=93:
> > > >>> The next patches will start control SVQ if possible. However, we =
don't
> > > >>> know if that will be possible at qemu boot anymore.
> > > >>
> > > >> If I was not wrong, there's no device specific feature that is che=
cked
> > > >> in the function. So it should be general enough to be used by devi=
ces
> > > >> other than net. Then I don't see any advantage of doing this.
> > > >>
> > > > Because vhost_vdpa_init_svq is called at qemu boot, failing if it i=
s
> > > > not possible to shadow the Virtqueue.
> > > >
> > > > Now the CVQ will be shadowed if possible, so we need to check this =
at
> > > > device start, not at initialization.
> > >
> > >
> > > Any reason we can't check this at device start? We don't need
> > > driver_features and we can do any probing to make sure cvq has an uni=
que
> > > group during initialization time.
> > >
> >
> > We need the CVQ index to check if it has an independent group. CVQ
> > index depends on the features the guest's ack:
> > * If it acks _F_MQ, it is the last one.
> > * If it doesn't, CVQ idx is 2.
> >
> > We cannot have acked features at initialization, and they could
> > change: It is valid for a guest to ack _F_MQ, then reset the device,
> > then not ack it.
>
> Can we do some probing by negotiating _F_MQ if the device offers it,
> then we can know if cvq has a unique group?
>

What if the guest does not ack _F_MQ?

To be completed it would go like:

* Probe negotiate _F_MQ, check unique group,
* Probe negotiate !_F_MQ, check unique group,
* Actually negotiate with the guest's feature set.
* React to failures. Probably the same way as if the CVQ is not
isolated, disabling SVQ?

To me it seems simpler to specify somehow that the vq must be independent.

Thanks!

> >
> > >
> > > >   To store this information at boot
> > > > time is not valid anymore, because v->shadow_vqs_enabled is not val=
id
> > > > at this time anymore.
> > >
> > >
> > > Ok, but this doesn't explain why it is net specific but vhost-vdpa sp=
ecific.
> > >
> >
> > We can try to move it to a vhost op, but we have the same problem as
> > the svq array allocation: We don't have the right place in vhost ops
> > to check this. Maybe vhost_set_features is the right one here?
>
> If we can do all the probing at the initialization phase, we can do
> everything there.
>
> Thanks
>
> >
> > Thanks!
> >
> > > Thanks
> > >
> > >
> > > >
> > > > Thanks!
> > > >
> > > >> Thanks
> > > >>
> > > >>
> > > >>> Since the moved checks will be already evaluated at net/ to know =
if it
> > > >>> is ok to shadow CVQ, move them.
> > > >>>
> > > >>> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > >>> ---
> > > >>>    hw/virtio/vhost-vdpa.c | 33 ++-------------------------------
> > > >>>    net/vhost-vdpa.c       |  3 ++-
> > > >>>    2 files changed, 4 insertions(+), 32 deletions(-)
> > > >>>
> > > >>> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > > >>> index 3df2775760..146f0dcb40 100644
> > > >>> --- a/hw/virtio/vhost-vdpa.c
> > > >>> +++ b/hw/virtio/vhost-vdpa.c
> > > >>> @@ -402,29 +402,9 @@ static int vhost_vdpa_get_dev_features(struc=
t vhost_dev *dev,
> > > >>>        return ret;
> > > >>>    }
> > > >>>
> > > >>> -static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vh=
ost_vdpa *v,
> > > >>> -                               Error **errp)
> > > >>> +static void vhost_vdpa_init_svq(struct vhost_dev *hdev, struct v=
host_vdpa *v)
> > > >>>    {
> > > >>>        g_autoptr(GPtrArray) shadow_vqs =3D NULL;
> > > >>> -    uint64_t dev_features, svq_features;
> > > >>> -    int r;
> > > >>> -    bool ok;
> > > >>> -
> > > >>> -    if (!v->shadow_vqs_enabled) {
> > > >>> -        return 0;
> > > >>> -    }
> > > >>> -
> > > >>> -    r =3D vhost_vdpa_get_dev_features(hdev, &dev_features);
> > > >>> -    if (r !=3D 0) {
> > > >>> -        error_setg_errno(errp, -r, "Can't get vdpa device featur=
es");
> > > >>> -        return r;
> > > >>> -    }
> > > >>> -
> > > >>> -    svq_features =3D dev_features;
> > > >>> -    ok =3D vhost_svq_valid_features(svq_features, errp);
> > > >>> -    if (unlikely(!ok)) {
> > > >>> -        return -1;
> > > >>> -    }
> > > >>>
> > > >>>        shadow_vqs =3D g_ptr_array_new_full(hdev->nvqs, vhost_svq_=
free);
> > > >>>        for (unsigned n =3D 0; n < hdev->nvqs; ++n) {
> > > >>> @@ -436,7 +416,6 @@ static int vhost_vdpa_init_svq(struct vhost_d=
ev *hdev, struct vhost_vdpa *v,
> > > >>>        }
> > > >>>
> > > >>>        v->shadow_vqs =3D g_steal_pointer(&shadow_vqs);
> > > >>> -    return 0;
> > > >>>    }
> > > >>>
> > > >>>    static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque=
, Error **errp)
> > > >>> @@ -461,11 +440,7 @@ static int vhost_vdpa_init(struct vhost_dev =
*dev, void *opaque, Error **errp)
> > > >>>        dev->opaque =3D  opaque ;
> > > >>>        v->listener =3D vhost_vdpa_memory_listener;
> > > >>>        v->msg_type =3D VHOST_IOTLB_MSG_V2;
> > > >>> -    ret =3D vhost_vdpa_init_svq(dev, v, errp);
> > > >>> -    if (ret) {
> > > >>> -        goto err;
> > > >>> -    }
> > > >>> -
> > > >>> +    vhost_vdpa_init_svq(dev, v);
> > > >>>        vhost_vdpa_get_iova_range(v);
> > > >>>
> > > >>>        if (!vhost_vdpa_first_dev(dev)) {
> > > >>> @@ -476,10 +451,6 @@ static int vhost_vdpa_init(struct vhost_dev =
*dev, void *opaque, Error **errp)
> > > >>>                                   VIRTIO_CONFIG_S_DRIVER);
> > > >>>
> > > >>>        return 0;
> > > >>> -
> > > >>> -err:
> > > >>> -    ram_block_discard_disable(false);
> > > >>> -    return ret;
> > > >>>    }
> > > >>>
> > > >>>    static void vhost_vdpa_host_notifier_uninit(struct vhost_dev *=
dev,
> > > >>> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> > > >>> index d3b1de481b..fb35b17ab4 100644
> > > >>> --- a/net/vhost-vdpa.c
> > > >>> +++ b/net/vhost-vdpa.c
> > > >>> @@ -117,9 +117,10 @@ static bool vhost_vdpa_net_valid_svq_feature=
s(uint64_t features, Error **errp)
> > > >>>        if (invalid_dev_features) {
> > > >>>            error_setg(errp, "vdpa svq does not work with features=
 0x%" PRIx64,
> > > >>>                       invalid_dev_features);
> > > >>> +        return false;
> > > >>>        }
> > > >>>
> > > >>> -    return !invalid_dev_features;
> > > >>> +    return vhost_svq_valid_features(features, errp);
> > > >>>    }
> > > >>>
> > > >>>    static int vhost_vdpa_net_check_device_id(struct vhost_net *ne=
t)
> > >
> >
>

