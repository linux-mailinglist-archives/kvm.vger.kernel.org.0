Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C50C6254E5
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 09:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbiKKIIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 03:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiKKIIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 03:08:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E127B236
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 00:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668154037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQhQZEOZISlk9fKQJ7Er8qzmYInHW1XL7RMaTIOM9O0=;
        b=braTB18U47lK5fWlc4lur1b8R6TfkgoFZ0A7OqZe7vX+cjP3plMK3AcpIfQkzPP2M9HaWg
        BunZg+QRsFExar7Ui4peeGE0LUwd8QeRO56P9YvLJlMbH28YGma/rKPgfNbtxaCyoMB0Qo
        Ml77FYL3Q9y9suzJWkgTGUQhXRRzkf8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-221-QRwKRsbSMbKKBW1fw2to2A-1; Fri, 11 Nov 2022 03:07:16 -0500
X-MC-Unique: QRwKRsbSMbKKBW1fw2to2A-1
Received: by mail-ed1-f70.google.com with SMTP id e15-20020a056402190f00b00461b0576620so3113111edz.2
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 00:07:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RQhQZEOZISlk9fKQJ7Er8qzmYInHW1XL7RMaTIOM9O0=;
        b=5WYNWkKY9X2XM5koGdV6vR9h9ngu2SEj95P8genSKwaXJGVgzVUyuwbcXqg5PwSYQE
         h3O3A1a8AYxQzkSwwbzYHZCqE/Z9iMDcmVGgtDxvre/jwrWn6ZQ5iBDGkKJ5xM95LOw/
         p2Jsub7YH+pNfw+gv/MMPcy//0rgs4C/FfLUvAo29HnHxc6jEHpgTvLHPAQ/UXkx9D4n
         czFOH9PmgLAuDbQM+/M8Il/oH7wJrZkMTBZHWIurrbb9i05hmYgZ3ophz/HEOFR86+kr
         dsgkQKwRvtp/o48m8BP7k5Zz7Y717cnx/SYIO3Bo7fE2JBbJnD7J/2NCLEy0UFJwe9Us
         t8Cg==
X-Gm-Message-State: ANoB5plaqF/UUZMmSPzefKgm2moEbCk4SFdpSs7EmL3OTuJRwEaNpR6l
        n0X4HyUBetBkxp/9+bnb8pQ5oGZTJSJ10dn6xlrQyv3N81GK+g0k6ycNuMwapXUyMtoy0yhdbUP
        pDLZrjL3dWQUmfOnddB0IR9sLZLaX
X-Received: by 2002:a17:906:1441:b0:7ad:b97e:283a with SMTP id q1-20020a170906144100b007adb97e283amr917670ejc.567.1668154035177;
        Fri, 11 Nov 2022 00:07:15 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6jlYB1kbLtX8DBOQc7h3daJWakOmzPyV9ncSZ+waj/yiY9Qh36VCyaVkKNf//Hy76iSo3i+6rUBIHtBmsq+Y8=
X-Received: by 2002:a17:906:1441:b0:7ad:b97e:283a with SMTP id
 q1-20020a170906144100b007adb97e283amr917655ejc.567.1668154034930; Fri, 11 Nov
 2022 00:07:14 -0800 (PST)
MIME-Version: 1.0
References: <20221108170755.92768-1-eperezma@redhat.com> <20221108170755.92768-6-eperezma@redhat.com>
 <56bfad97-74d2-8570-c391-83ecf9965cfd@redhat.com> <CAJaqyWd47QdBoSm9RdF2yx21hKv_=YRp3uvP13Qb9PaVksss7Q@mail.gmail.com>
 <aa82783b-b1f5-a82b-5136-1f7f7725a433@redhat.com> <CAJaqyWfmTn1_o2z2S_o=bu2mD=r0+T=1+dh_WOwbpQaYQK0YSQ@mail.gmail.com>
In-Reply-To: <CAJaqyWfmTn1_o2z2S_o=bu2mD=r0+T=1+dh_WOwbpQaYQK0YSQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 11 Nov 2022 16:07:01 +0800
Message-ID: <CACGkMEvQm_0VqF5q2XtWmaHXmSj0Xjg7br3ydOQVVcHJ0yb_GA@mail.gmail.com>
Subject: Re: [PATCH v6 05/10] vdpa: move SVQ vring features check to net/
To:     Eugenio Perez Martin <eperezma@redhat.com>
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

On Fri, Nov 11, 2022 at 3:56 PM Eugenio Perez Martin
<eperezma@redhat.com> wrote:
>
> On Fri, Nov 11, 2022 at 8:34 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> >
> > =E5=9C=A8 2022/11/10 21:09, Eugenio Perez Martin =E5=86=99=E9=81=93:
> > > On Thu, Nov 10, 2022 at 6:40 AM Jason Wang <jasowang@redhat.com> wrot=
e:
> > >>
> > >> =E5=9C=A8 2022/11/9 01:07, Eugenio P=C3=A9rez =E5=86=99=E9=81=93:
> > >>> The next patches will start control SVQ if possible. However, we do=
n't
> > >>> know if that will be possible at qemu boot anymore.
> > >>
> > >> If I was not wrong, there's no device specific feature that is check=
ed
> > >> in the function. So it should be general enough to be used by device=
s
> > >> other than net. Then I don't see any advantage of doing this.
> > >>
> > > Because vhost_vdpa_init_svq is called at qemu boot, failing if it is
> > > not possible to shadow the Virtqueue.
> > >
> > > Now the CVQ will be shadowed if possible, so we need to check this at
> > > device start, not at initialization.
> >
> >
> > Any reason we can't check this at device start? We don't need
> > driver_features and we can do any probing to make sure cvq has an uniqu=
e
> > group during initialization time.
> >
>
> We need the CVQ index to check if it has an independent group. CVQ
> index depends on the features the guest's ack:
> * If it acks _F_MQ, it is the last one.
> * If it doesn't, CVQ idx is 2.
>
> We cannot have acked features at initialization, and they could
> change: It is valid for a guest to ack _F_MQ, then reset the device,
> then not ack it.

Can we do some probing by negotiating _F_MQ if the device offers it,
then we can know if cvq has a unique group?

>
> >
> > >   To store this information at boot
> > > time is not valid anymore, because v->shadow_vqs_enabled is not valid
> > > at this time anymore.
> >
> >
> > Ok, but this doesn't explain why it is net specific but vhost-vdpa spec=
ific.
> >
>
> We can try to move it to a vhost op, but we have the same problem as
> the svq array allocation: We don't have the right place in vhost ops
> to check this. Maybe vhost_set_features is the right one here?

If we can do all the probing at the initialization phase, we can do
everything there.

Thanks

>
> Thanks!
>
> > Thanks
> >
> >
> > >
> > > Thanks!
> > >
> > >> Thanks
> > >>
> > >>
> > >>> Since the moved checks will be already evaluated at net/ to know if=
 it
> > >>> is ok to shadow CVQ, move them.
> > >>>
> > >>> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > >>> ---
> > >>>    hw/virtio/vhost-vdpa.c | 33 ++-------------------------------
> > >>>    net/vhost-vdpa.c       |  3 ++-
> > >>>    2 files changed, 4 insertions(+), 32 deletions(-)
> > >>>
> > >>> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > >>> index 3df2775760..146f0dcb40 100644
> > >>> --- a/hw/virtio/vhost-vdpa.c
> > >>> +++ b/hw/virtio/vhost-vdpa.c
> > >>> @@ -402,29 +402,9 @@ static int vhost_vdpa_get_dev_features(struct =
vhost_dev *dev,
> > >>>        return ret;
> > >>>    }
> > >>>
> > >>> -static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhos=
t_vdpa *v,
> > >>> -                               Error **errp)
> > >>> +static void vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vho=
st_vdpa *v)
> > >>>    {
> > >>>        g_autoptr(GPtrArray) shadow_vqs =3D NULL;
> > >>> -    uint64_t dev_features, svq_features;
> > >>> -    int r;
> > >>> -    bool ok;
> > >>> -
> > >>> -    if (!v->shadow_vqs_enabled) {
> > >>> -        return 0;
> > >>> -    }
> > >>> -
> > >>> -    r =3D vhost_vdpa_get_dev_features(hdev, &dev_features);
> > >>> -    if (r !=3D 0) {
> > >>> -        error_setg_errno(errp, -r, "Can't get vdpa device features=
");
> > >>> -        return r;
> > >>> -    }
> > >>> -
> > >>> -    svq_features =3D dev_features;
> > >>> -    ok =3D vhost_svq_valid_features(svq_features, errp);
> > >>> -    if (unlikely(!ok)) {
> > >>> -        return -1;
> > >>> -    }
> > >>>
> > >>>        shadow_vqs =3D g_ptr_array_new_full(hdev->nvqs, vhost_svq_fr=
ee);
> > >>>        for (unsigned n =3D 0; n < hdev->nvqs; ++n) {
> > >>> @@ -436,7 +416,6 @@ static int vhost_vdpa_init_svq(struct vhost_dev=
 *hdev, struct vhost_vdpa *v,
> > >>>        }
> > >>>
> > >>>        v->shadow_vqs =3D g_steal_pointer(&shadow_vqs);
> > >>> -    return 0;
> > >>>    }
> > >>>
> > >>>    static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, =
Error **errp)
> > >>> @@ -461,11 +440,7 @@ static int vhost_vdpa_init(struct vhost_dev *d=
ev, void *opaque, Error **errp)
> > >>>        dev->opaque =3D  opaque ;
> > >>>        v->listener =3D vhost_vdpa_memory_listener;
> > >>>        v->msg_type =3D VHOST_IOTLB_MSG_V2;
> > >>> -    ret =3D vhost_vdpa_init_svq(dev, v, errp);
> > >>> -    if (ret) {
> > >>> -        goto err;
> > >>> -    }
> > >>> -
> > >>> +    vhost_vdpa_init_svq(dev, v);
> > >>>        vhost_vdpa_get_iova_range(v);
> > >>>
> > >>>        if (!vhost_vdpa_first_dev(dev)) {
> > >>> @@ -476,10 +451,6 @@ static int vhost_vdpa_init(struct vhost_dev *d=
ev, void *opaque, Error **errp)
> > >>>                                   VIRTIO_CONFIG_S_DRIVER);
> > >>>
> > >>>        return 0;
> > >>> -
> > >>> -err:
> > >>> -    ram_block_discard_disable(false);
> > >>> -    return ret;
> > >>>    }
> > >>>
> > >>>    static void vhost_vdpa_host_notifier_uninit(struct vhost_dev *de=
v,
> > >>> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> > >>> index d3b1de481b..fb35b17ab4 100644
> > >>> --- a/net/vhost-vdpa.c
> > >>> +++ b/net/vhost-vdpa.c
> > >>> @@ -117,9 +117,10 @@ static bool vhost_vdpa_net_valid_svq_features(=
uint64_t features, Error **errp)
> > >>>        if (invalid_dev_features) {
> > >>>            error_setg(errp, "vdpa svq does not work with features 0=
x%" PRIx64,
> > >>>                       invalid_dev_features);
> > >>> +        return false;
> > >>>        }
> > >>>
> > >>> -    return !invalid_dev_features;
> > >>> +    return vhost_svq_valid_features(features, errp);
> > >>>    }
> > >>>
> > >>>    static int vhost_vdpa_net_check_device_id(struct vhost_net *net)
> >
>

