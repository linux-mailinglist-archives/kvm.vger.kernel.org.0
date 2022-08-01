Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6E25865DD
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 09:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiHAHvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 03:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiHAHu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 03:50:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0188F380
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 00:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659340255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/+UyS8DzqXh878QkjFjhBHrIJgfcT45MTc/yc/0BW48=;
        b=AR/jRChUJC3nKAC5e+p67aNuPnxLbUvbZeT2FtzGZtl/XcEpurMYTkM9udOiyZZqBESMqN
        AQqgE7FKZc+Lb1JTvpK2hL5H81rX5WOaQuY6jlJXfgkyRgoPeSovYqY6u9bKewmp22Jbi7
        g2MxfphcnSeMGgOOACXhiPaaJWaVVEA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-lzS3lpgRPCWU6Ly90r6nzg-1; Mon, 01 Aug 2022 03:50:54 -0400
X-MC-Unique: lzS3lpgRPCWU6Ly90r6nzg-1
Received: by mail-qv1-f70.google.com with SMTP id k7-20020a056214102700b004740a13b3bcso5958132qvr.4
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 00:50:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/+UyS8DzqXh878QkjFjhBHrIJgfcT45MTc/yc/0BW48=;
        b=KucHB/wrPZjFdFxsWLJ9stsx4Zr2KY/y/FesbYPG4NcXpRfnbOA3X7rCyTiNFJ22Qg
         TDPmvC77QNyYucR4NpVYdMuXYQu+cvffOEEjri6aTSBhso09troSVPZnHTQya6zrM+b3
         aa9GERpGPLkyvVm6RAVyk8k/1cTQdkz22U/yvycARgvvK9bTb1PnDZ5Qib/dC5vaQ3qb
         aA2gIpbfxDyhoP6kkgvTLvVKGuNApeJyLk2mnJrONWFKKEu6RpGywIenR+theGL25Ry8
         CjeDWgtRm0T9F+j40ZLdTaPIXuwTHflN1gkvXcXppeOy97B7WM18BH/++kuvz4mcZg5z
         bvig==
X-Gm-Message-State: AJIora9bYw+iniArtS8ugZNk9SJQ8kZ3HHjcFGk7fS03tHSkLfjmBCMH
        aaqQgw/uINow2mjUdy8rfLb18ruc6n/b7Czy3BSdmS4o6uXadxQGfS04WJlM+lBlffb2z8y2Ry6
        5jH2jiR90t++zPffzv39awSu0l0Zg
X-Received: by 2002:a05:620a:29d5:b0:6b5:dc06:5762 with SMTP id s21-20020a05620a29d500b006b5dc065762mr10847749qkp.522.1659340253455;
        Mon, 01 Aug 2022 00:50:53 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uEC9zxz+Cbnlys5mCZOduhSUlkB8q/ckaxlv+q83GrNX/6hN+UsOcJO8IJBJLH1fTgSYLBBdt5Zmnkz1RfBSk=
X-Received: by 2002:a05:620a:29d5:b0:6b5:dc06:5762 with SMTP id
 s21-20020a05620a29d500b006b5dc065762mr10847742qkp.522.1659340253177; Mon, 01
 Aug 2022 00:50:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220722134318.3430667-1-eperezma@redhat.com> <20220722134318.3430667-8-eperezma@redhat.com>
 <74d24a62-7017-e937-3bcb-af8f6b605fee@redhat.com>
In-Reply-To: <74d24a62-7017-e937-3bcb-af8f6b605fee@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 1 Aug 2022 09:50:17 +0200
Message-ID: <CAJaqyWf3Ua5LFxO9E-nJ+2DD0_nEX_-aK=Gw+R20TBcYnwr2Ng@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] vdpa: Always start CVQ in SVQ mode
To:     Jason Wang <jasowang@redhat.com>
Cc:     qemu-level <qemu-devel@nongnu.org>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Cindy Lu <lulu@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>
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

On Tue, Jul 26, 2022 at 5:04 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/7/22 21:43, Eugenio P=C3=A9rez =E5=86=99=E9=81=93:
> > Isolate control virtqueue in its own group, allowing to intercept contr=
ol
> > commands but letting dataplane run totally passthrough to the guest.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >   hw/virtio/vhost-vdpa.c |   3 +-
> >   net/vhost-vdpa.c       | 158 +++++++++++++++++++++++++++++++++++++++-=
-
> >   2 files changed, 156 insertions(+), 5 deletions(-)
> >
> > diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > index 79623badf2..fe1c85b086 100644
> > --- a/hw/virtio/vhost-vdpa.c
> > +++ b/hw/virtio/vhost-vdpa.c
> > @@ -668,7 +668,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_=
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
> > index 6c1c64f9b1..f5075ef487 100644
> > --- a/net/vhost-vdpa.c
> > +++ b/net/vhost-vdpa.c
> > @@ -37,6 +37,9 @@ typedef struct VhostVDPAState {
> >       /* Control commands shadow buffers */
> >       void *cvq_cmd_out_buffer, *cvq_cmd_in_buffer;
> >
> > +    /* Number of address spaces supported by the device */
> > +    unsigned address_space_num;
> > +
> >       /* The device always have SVQ enabled */
> >       bool always_svq;
> >       bool started;
> > @@ -100,6 +103,8 @@ static const uint64_t vdpa_svq_device_features =3D
> >       BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
> >       BIT_ULL(VIRTIO_NET_F_STANDBY);
> >
> > +#define VHOST_VDPA_NET_CVQ_ASID 1
> > +
> >   VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
> >   {
> >       VhostVDPAState *s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> > @@ -214,6 +219,109 @@ static ssize_t vhost_vdpa_receive(NetClientState =
*nc, const uint8_t *buf,
> >       return 0;
> >   }
> >
> > +static int vhost_vdpa_get_vring_group(int device_fd,
> > +                                      struct vhost_vring_state *state)
> > +{
> > +    int r =3D ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, state);
> > +    return r < 0 ? -errno : 0;
> > +}
>
>
> It would be more convenient for the caller if we can simply return 0 here=
.
>

I don't follow this, how do we know if the call failed then?

>
> > +
> > +/**
> > + * Check if all the virtqueues of the virtio device are in a different=
 vq than
> > + * the last vq. VQ group of last group passed in cvq_group.
> > + */
> > +static bool vhost_vdpa_cvq_group_is_independent(struct vhost_vdpa *v,
> > +                                            struct vhost_vring_state c=
vq_group)
> > +{
> > +    struct vhost_dev *dev =3D v->dev;
> > +    int ret;
> > +
> > +    for (int i =3D 0; i < (dev->vq_index_end - 1); ++i) {
> > +        struct vhost_vring_state vq_group =3D {
> > +            .index =3D i,
> > +        };
> > +
> > +        ret =3D vhost_vdpa_get_vring_group(v->device_fd, &vq_group);
> > +        if (unlikely(ret)) {
> > +            goto call_err;
> > +        }
> > +        if (unlikely(vq_group.num =3D=3D cvq_group.num)) {
> > +            error_report("CVQ %u group is the same as VQ %u one (%u)",
> > +                         cvq_group.index, vq_group.index, cvq_group.nu=
m);
>
>
> Any reason we need error_report() here?
>

We can move it to a migration blocker.

> Btw, I'd suggest to introduce new field in vhost_vdpa, then we can get
> and store the group_id there during init.
>
> This could be useful for the future e.g PASID virtualization.
>

Answering below.

>
> > +            return false;
> > +        }
> > +    }
> > +
> > +    return true;
> > +
> > +call_err:
> > +    error_report("Can't read vq group, errno=3D%d (%s)", -ret, g_strer=
ror(-ret));
> > +    return false;
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
> > +    int ret;
> > +
> > +    ret =3D ioctl(v->device_fd, VHOST_VDPA_SET_GROUP_ASID, &asid);
> > +    if (unlikely(ret < 0)) {
> > +        error_report("Can't set vq group %u asid %u, errno=3D%d (%s)",
> > +            asid.index, asid.num, errno, g_strerror(errno));
> > +    }
> > +    return ret;
> > +}
> > +
> > +static void vhost_vdpa_net_prepare(NetClientState *nc)
> > +{
> > +    VhostVDPAState *s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> > +    struct vhost_vdpa *v =3D &s->vhost_vdpa;
> > +    struct vhost_dev *dev =3D v->dev;
> > +    struct vhost_vring_state cvq_group =3D {
> > +        .index =3D v->dev->vq_index_end - 1,
> > +    };
> > +    int r;
> > +
> > +    assert(nc->info->type =3D=3D NET_CLIENT_DRIVER_VHOST_VDPA);
> > +
> > +    if (dev->nvqs !=3D 1 || dev->vq_index + dev->nvqs !=3D dev->vq_ind=
ex_end) {
> > +        /* Only interested in CVQ */
> > +        return;
> > +    }
> > +
> > +    if (s->always_svq) {
> > +        /* SVQ is already enabled */
> > +        return;
> > +    }
> > +
> > +    if (s->address_space_num < 2) {
> > +        v->shadow_vqs_enabled =3D false;
> > +        return;
> > +    }
> > +
> > +    r =3D vhost_vdpa_get_vring_group(v->device_fd, &cvq_group);
> > +    if (unlikely(r)) {
> > +        error_report("Can't read cvq group, errno=3D%d (%s)", r, g_str=
error(-r));
> > +        v->shadow_vqs_enabled =3D false;
> > +        return;
> > +    }
> > +
> > +    if (!vhost_vdpa_cvq_group_is_independent(v, cvq_group)) {
> > +        v->shadow_vqs_enabled =3D false;
> > +        return;
> > +    }
> > +
> > +    r =3D vhost_vdpa_set_address_space_id(v, cvq_group.num,
> > +                                        VHOST_VDPA_NET_CVQ_ASID);
> > +    v->shadow_vqs_enabled =3D r =3D=3D 0;
> > +    s->vhost_vdpa.address_space_id =3D r =3D=3D 0 ? 1 : 0;
>
>
> I'd expect this to be done net_init_vhost_vdpa(). Or any advantage of
> initializing thing here?
>

We don't know the CVQ index at initialization time, since the guest is
not even running so it has not acked the features. So we cannot know
its VQ group, which is needed to call set_address_space_id.

In my opinion, we shouldn't even cache "cvq has group id N", since the
device could return a different group id between resets (for example,
because the negotiation of different features).

>
> > +}
> > +
> >   static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr=
)
> >   {
> >       VhostIOVATree *tree =3D v->iova_tree;
> > @@ -432,6 +540,7 @@ static NetClientInfo net_vhost_vdpa_info =3D {
> >           .type =3D NET_CLIENT_DRIVER_VHOST_VDPA,
> >           .size =3D sizeof(VhostVDPAState),
> >           .receive =3D vhost_vdpa_receive,
> > +        .prepare =3D vhost_vdpa_net_prepare,
> >           .start =3D vhost_vdpa_net_start,
> >           .cleanup =3D vhost_vdpa_cleanup,
> >           .has_vnet_hdr =3D vhost_vdpa_has_vnet_hdr,
> > @@ -542,12 +651,40 @@ static const VhostShadowVirtqueueOps vhost_vdpa_n=
et_svq_ops =3D {
> >       .avail_handler =3D vhost_vdpa_net_handle_ctrl_avail,
> >   };
> >
> > +static bool vhost_vdpa_get_as_num(int vdpa_device_fd, unsigned *num_as=
,
> > +                                  Error **errp)
>
>
> Let's simply return int as the #as here.
>

If as is uint32_t, should we return int64_t and both leave negative
values for errors and check that #as <=3D UINT32_MAX then?

Thanks!

> Thanks
>
>
> > +{
> > +    uint64_t features;
> > +    int r;
> > +
> > +    r =3D ioctl(vdpa_device_fd, VHOST_GET_BACKEND_FEATURES, &features)=
;
> > +    if (unlikely(r < 0)) {
> > +        error_setg_errno(errp, errno, "Cannot get backend features");
> > +        return r;
> > +    }
> > +
> > +    if (!(features & BIT_ULL(VHOST_BACKEND_F_IOTLB_ASID))) {
> > +        *num_as =3D 1;
> > +        return 0;
> > +    }
> > +
> > +    r =3D ioctl(vdpa_device_fd, VHOST_VDPA_GET_AS_NUM, num_as);
> > +    if (unlikely(r < 0)) {
> > +        error_setg_errno(errp, errno,
> > +                         "Cannot retrieve number of supported ASs");
> > +        return r;
> > +    }
> > +
> > +    return 0;
> > +}
> > +
> >   static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
> >                                              const char *device,
> >                                              const char *name,
> >                                              int vdpa_device_fd,
> >                                              int queue_pair_index,
> >                                              int nvqs,
> > +                                           unsigned nas,
> >                                              bool is_datapath,
> >                                              bool svq,
> >                                              VhostIOVATree *iova_tree)
> > @@ -566,6 +703,7 @@ static NetClientState *net_vhost_vdpa_init(NetClien=
tState *peer,
> >       snprintf(nc->info_str, sizeof(nc->info_str), TYPE_VHOST_VDPA);
> >       s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> >
> > +    s->address_space_num =3D nas;
> >       s->vhost_vdpa.device_fd =3D vdpa_device_fd;
> >       s->vhost_vdpa.index =3D queue_pair_index;
> >       s->always_svq =3D svq;
> > @@ -651,6 +789,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, const=
 char *name,
> >       g_autoptr(VhostIOVATree) iova_tree =3D NULL;
> >       NetClientState *nc;
> >       int queue_pairs, r, i, has_cvq =3D 0;
> > +    unsigned num_as =3D 1;
> > +    bool svq_cvq;
> >
> >       assert(netdev->type =3D=3D NET_CLIENT_DRIVER_VHOST_VDPA);
> >       opts =3D &netdev->u.vhost_vdpa;
> > @@ -676,7 +816,17 @@ int net_init_vhost_vdpa(const Netdev *netdev, cons=
t char *name,
> >           return queue_pairs;
> >       }
> >
> > -    if (opts->x_svq) {
> > +    svq_cvq =3D opts->x_svq;
> > +    if (has_cvq && !opts->x_svq) {
> > +        r =3D vhost_vdpa_get_as_num(vdpa_device_fd, &num_as, errp);
> > +        if (unlikely(r < 0)) {
> > +            return r;
> > +        }
> > +
> > +        svq_cvq =3D num_as > 1;
> > +    }
> > +
> > +    if (opts->x_svq || svq_cvq) {
> >           struct vhost_vdpa_iova_range iova_range;
> >
> >           uint64_t invalid_dev_features =3D
> > @@ -699,15 +849,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, con=
st char *name,
> >
> >       for (i =3D 0; i < queue_pairs; i++) {
> >           ncs[i] =3D net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
> > -                                     vdpa_device_fd, i, 2, true, opts-=
>x_svq,
> > -                                     iova_tree);
> > +                                     vdpa_device_fd, i, 2, num_as, tru=
e,
> > +                                     opts->x_svq, iova_tree);
> >           if (!ncs[i])
> >               goto err;
> >       }
> >
> >       if (has_cvq) {
> >           nc =3D net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
> > -                                 vdpa_device_fd, i, 1, false,
> > +                                 vdpa_device_fd, i, 1, num_as, false,
> >                                    opts->x_svq, iova_tree);
> >           if (!nc)
> >               goto err;
>

