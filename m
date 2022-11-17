Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A2962D455
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 08:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239400AbiKQHpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 02:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239321AbiKQHpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 02:45:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069FE43AD1
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 23:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668671074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qpMRegVBuduzYKr3IwI+Uc48IKGXs4ukqFgJMgG9hoI=;
        b=VE9+GaLpGyMjYdYAbjvMutxJkKMn/MtpjcoJw7bct0+mkcPtPAp8BSbubnsJPT3MdPvbOF
        G7coYdrv9QKaNXTcLo+QiA0GeAPbpUx2MwLONusBKIocDACjLMYy/4zVOqaAnDmsLnffPQ
        +EwjKUv7X/xILIvYx5pTbVEg3xlqxj0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-264-1Z0vI82VOimGWLZEELN0bA-1; Thu, 17 Nov 2022 02:44:30 -0500
X-MC-Unique: 1Z0vI82VOimGWLZEELN0bA-1
Received: by mail-qv1-f70.google.com with SMTP id q16-20020a0ce210000000b004ba8976d3aaso985452qvl.5
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 23:44:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qpMRegVBuduzYKr3IwI+Uc48IKGXs4ukqFgJMgG9hoI=;
        b=ruoWfvyNtgKxY2rh1/jzFkmpyMf8yNoOxfX7+LARWN43OwsURDBDM+NEzf5VBDWIxa
         jSWn0Vvqvmti/BQ0+UUlVMGHpEsOe8JbzK4n86HLuZnLDOONLEV+Cemxpc3yNILUI1Vl
         neeEZ5rA+YPKxERsst/r/QVnt1iuwacydy6cHk0y2o02vcQHa8mvGbucafvpAF0ZCDqe
         6Sen4ZUm+hpHb40kXoGUrfvOj3LTf4gCFxQP4uyZ9sehFXqElgG49Edoym0/LsUc98La
         nMzKmtsLxEw0v6XuluP/CpSoy3WDC11zhH2izguhEmfzrWR81ttg7WJlIvbtS1yu58sH
         2Qug==
X-Gm-Message-State: ANoB5pnDRLlTkhHe1Kgd7ZlaeOiuaanthHpTqZdTGbmMwUzCvmvp+08q
        2FGgdWdD7GyJeqYA+Z3IxpVCukMRTlw0LLUfUJN4O3m7WV60LtqxQhGzAVDCC3JVR2qZXE1dSo9
        A545I2YR01dTkC8E/07Yq578KFk6q
X-Received: by 2002:a05:622a:1b18:b0:3a4:ae7c:c70d with SMTP id bb24-20020a05622a1b1800b003a4ae7cc70dmr1285351qtb.40.1668671070108;
        Wed, 16 Nov 2022 23:44:30 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4RTuSKgy5H/Ol6PVtgBHsPQgdq7KTcyEV8BTgr/JclOhWcI+CwH6zsmIA66MuT4RFuWtITzizSwxI+SWdsg0E=
X-Received: by 2002:a05:622a:1b18:b0:3a4:ae7c:c70d with SMTP id
 bb24-20020a05622a1b1800b003a4ae7cc70dmr1285339qtb.40.1668671069876; Wed, 16
 Nov 2022 23:44:29 -0800 (PST)
MIME-Version: 1.0
References: <20221116150556.1294049-1-eperezma@redhat.com> <20221116150556.1294049-11-eperezma@redhat.com>
 <f22d530b-3c5e-5b94-948d-594608668687@redhat.com>
In-Reply-To: <f22d530b-3c5e-5b94-948d-594608668687@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 17 Nov 2022 08:43:54 +0100
Message-ID: <CAJaqyWfj0dAnto_S003ei28Y9Ei+8JJApcGN4K+P-7yH683VGA@mail.gmail.com>
Subject: Re: [PATCH for 8.0 v7 10/10] vdpa: Always start CVQ in SVQ mode if possible
To:     Jason Wang <jasowang@redhat.com>
Cc:     qemu-devel@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Cindy Lu <lulu@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Parav Pandit <parav@mellanox.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
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

On Thu, Nov 17, 2022 at 7:52 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/11/16 23:05, Eugenio P=C3=A9rez =E5=86=99=E9=81=93:
> > Isolate control virtqueue in its own group, allowing to intercept contr=
ol
> > commands but letting dataplane run totally passthrough to the guest.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> > v7:
> > * Never ask for number of address spaces, just react if isolation is no=
t
> >    possible.
> > * Return ASID ioctl errors instead of masking them as if the device has
> >    no asid.
> > * Simplify net_init_vhost_vdpa logic
> > * Add "if possible" suffix
> >
> > v6:
> > * Disable control SVQ if the device does not support it because of
> > features.
> >
> > v5:
> > * Fixing the not adding cvq buffers when x-svq=3Don is specified.
> > * Move vring state in vhost_vdpa_get_vring_group instead of using a
> >    parameter.
> > * Rename VHOST_VDPA_NET_CVQ_PASSTHROUGH to VHOST_VDPA_NET_DATA_ASID
> >
> > v4:
> > * Squash vhost_vdpa_cvq_group_is_independent.
> > * Rebased on last CVQ start series, that allocated CVQ cmd bufs at load
> > * Do not check for cvq index on vhost_vdpa_net_prepare, we only have on=
e
> >    that callback registered in that NetClientInfo.
> >
> > v3:
> > * Make asid related queries print a warning instead of returning an
> >    error and stop the start of qemu.
> > ---
> >   hw/virtio/vhost-vdpa.c |   3 +-
> >   net/vhost-vdpa.c       | 117 +++++++++++++++++++++++++++++++++++++++-=
-
> >   2 files changed, 114 insertions(+), 6 deletions(-)
> >
> > diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > index 852baf8b2c..a29a18a6a9 100644
> > --- a/hw/virtio/vhost-vdpa.c
> > +++ b/hw/virtio/vhost-vdpa.c
> > @@ -653,7 +653,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_=
dev *dev)
> >   {
> >       uint64_t features;
> >       uint64_t f =3D 0x1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2 |
> > -        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH;
> > +        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH |
> > +        0x1ULL << VHOST_BACKEND_F_IOTLB_ASID;
> >       int r;
> >
> >       if (vhost_vdpa_call(dev, VHOST_GET_BACKEND_FEATURES, &features)) =
{
> > diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> > index a9c864741a..dc13a49311 100644
> > --- a/net/vhost-vdpa.c
> > +++ b/net/vhost-vdpa.c
> > @@ -101,6 +101,8 @@ static const uint64_t vdpa_svq_device_features =3D
> >       BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
> >       BIT_ULL(VIRTIO_NET_F_STANDBY);
> >
> > +#define VHOST_VDPA_NET_CVQ_ASID 1
> > +
> >   VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
> >   {
> >       VhostVDPAState *s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> > @@ -242,6 +244,40 @@ static NetClientInfo net_vhost_vdpa_info =3D {
> >           .check_peer_type =3D vhost_vdpa_check_peer_type,
> >   };
> >
> > +static int64_t vhost_vdpa_get_vring_group(int device_fd, unsigned vq_i=
ndex)
> > +{
> > +    struct vhost_vring_state state =3D {
> > +        .index =3D vq_index,
> > +    };
> > +    int r =3D ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, &state);
> > +
> > +    if (unlikely(r < 0)) {
> > +        error_report("Cannot get VQ %u group: %s", vq_index,
> > +                     g_strerror(errno));
> > +        return r;
> > +    }
> > +
> > +    return state.num;
> > +}
> > +
> > +static int vhost_vdpa_set_address_space_id(struct vhost_vdpa *v,
> > +                                           unsigned vq_group,
> > +                                           unsigned asid_num)
> > +{
> > +    struct vhost_vring_state asid =3D {
> > +        .index =3D vq_group,
> > +        .num =3D asid_num,
> > +    };
> > +    int r;
> > +
> > +    r =3D ioctl(v->device_fd, VHOST_VDPA_SET_GROUP_ASID, &asid);
> > +    if (unlikely(r < 0)) {
> > +        error_report("Can't set vq group %u asid %u, errno=3D%d (%s)",
> > +                     asid.index, asid.num, errno, g_strerror(errno));
> > +    }
> > +    return r;
> > +}
> > +
> >   static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr=
)
> >   {
> >       VhostIOVATree *tree =3D v->iova_tree;
> > @@ -316,11 +352,69 @@ dma_map_err:
> >   static int vhost_vdpa_net_cvq_start(NetClientState *nc)
> >   {
> >       VhostVDPAState *s;
> > -    int r;
> > +    struct vhost_vdpa *v;
> > +    uint64_t backend_features;
> > +    int64_t cvq_group;
> > +    int cvq_index, r;
> >
> >       assert(nc->info->type =3D=3D NET_CLIENT_DRIVER_VHOST_VDPA);
> >
> >       s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> > +    v =3D &s->vhost_vdpa;
> > +
> > +    v->shadow_data =3D s->always_svq;
> > +    v->shadow_vqs_enabled =3D s->always_svq;
> > +    s->vhost_vdpa.address_space_id =3D VHOST_VDPA_GUEST_PA_ASID;
> > +
> > +    if (s->always_svq) {
> > +        goto out;
> > +    }
> > +
> > +    /* Backend features are not available in v->dev yet. */
> > +    r =3D ioctl(v->device_fd, VHOST_GET_BACKEND_FEATURES, &backend_fea=
tures);
> > +    if (unlikely(r < 0)) {
> > +        error_report("Cannot get vdpa backend_features: %s(%d)",
> > +            g_strerror(errno), errno);
> > +        return -1;
> > +    }
> > +    if (!(backend_features & VHOST_BACKEND_F_IOTLB_ASID) ||
> > +        !vhost_vdpa_net_valid_svq_features(v->dev->features, NULL)) {
>
>
> I think there should be some logic to block migration in this case?
>

Since vhost_vdpa are not shadowed they don't expose _F_LOG, so
migration is blocked that way.

We can override it to make its message a little bit clearer.

>
> > +        return 0;
> > +    }
> > +
> > +    /**
> > +     * Check if all the virtqueues of the virtio device are in a diffe=
rent vq
> > +     * than the last vq. VQ group of last group passed in cvq_group.
> > +     */
> > +    cvq_index =3D v->dev->vq_index_end - 1;
> > +    cvq_group =3D vhost_vdpa_get_vring_group(v->device_fd, cvq_index);
> > +    if (unlikely(cvq_group < 0)) {
> > +        return cvq_group;x
> > +    }
> > +    for (int i =3D 0; i < cvq_index; ++i) {
> > +        int64_t group =3D vhost_vdpa_get_vring_group(v->device_fd, i);
> > +
> > +        if (unlikely(group < 0)) {
> > +            return group;
> > +        }
> > +
> > +        if (unlikely(group =3D=3D cvq_group)) {
> > +            warn_report(
> > +                "CVQ %"PRId64" group is the same as VQ %d one (%"PRId6=
4")",
> > +                cvq_group, i, group);
> > +            return 0;
>
>
> Ditto.
>
>
> > +        }
> > +    }
> > +
> > +    r =3D vhost_vdpa_set_address_space_id(v, cvq_group, VHOST_VDPA_NET=
_CVQ_ASID);
> > +    if (unlikely(r < 0)) {
> > +        return r;
> > +    } else {
> > +        v->shadow_vqs_enabled =3D true;
> > +        s->vhost_vdpa.address_space_id =3D VHOST_VDPA_NET_CVQ_ASID;
> > +    }
> > +
> > +out:
> >       if (!s->vhost_vdpa.shadow_vqs_enabled) {
> >           return 0;
> >       }
> > @@ -652,6 +746,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const=
 char *name,
> >       g_autoptr(VhostIOVATree) iova_tree =3D NULL;
> >       NetClientState *nc;
> >       int queue_pairs, r, i =3D 0, has_cvq =3D 0;
> > +    bool svq_cvq;
> >
> >       assert(netdev->type =3D=3D NET_CLIENT_DRIVER_VHOST_VDPA);
> >       opts =3D &netdev->u.vhost_vdpa;
> > @@ -693,12 +788,24 @@ int net_init_vhost_vdpa(const Netdev *netdev, con=
st char *name,
> >           return queue_pairs;
> >       }
> >
> > -    if (opts->x_svq) {
> > -        struct vhost_vdpa_iova_range iova_range;
> > +    svq_cvq =3D opts->x_svq || has_cvq;
> > +    if (svq_cvq) {
> > +        Error *warn =3D NULL;
> >
> > -        if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
> > -            goto err_svq;
> > +        svq_cvq =3D vhost_vdpa_net_valid_svq_features(features,
> > +                                                   opts->x_svq ? errp =
: &warn);
> > +        if (!svq_cvq) {
> > +            if (opts->x_svq) {
> > +                goto err_svq;
> > +            } else {
> > +                warn_reportf_err(warn, "Cannot shadow CVQ: ");
>
>
> This seems suspicious, we reach here we we can't just use svq for cvq.
>

Right, but what is the suspicious part?

>
>
> > +            }
> >           }
>
>
> The above logic is not easy to follow. I guess the root cause is the
> variable name. It looks to me svq_cvq is better to be renamed as "svq"?
>

Yes, we can rename it. I'll send a newer version with the rename.

Thanks!

> Thanks
>
>
> > +    }
> > +
> > +    if (svq_cvq) {
> > +        /* Allocate a common iova tree if there is a possibility of SV=
Q */
> > +        struct vhost_vdpa_iova_range iova_range;
> >
> >           vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
> >           iova_tree =3D vhost_iova_tree_new(iova_range.first, iova_rang=
e.last);
>

