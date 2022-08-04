Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB0A5898C9
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 09:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239344AbiHDHzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 03:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239345AbiHDHy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 03:54:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1234E65559
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 00:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659599693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bJ16VF46u4pOdw/RGfqvVDi+9IGmgAsgCoVtqAp4xpg=;
        b=Hk7Y9+CPU9uZUNZqHt7S8m/IjxAV/z/KfgSth92+XA0uVZ6C2/T8gXwHDFmk6zg7dzZwpC
        th2SuWS9rqOdu7Sxv5u30sj5epy+KGJacII9UiJY44l6GcIzsLfGWSIt58VVAMQEGrnYQt
        JEv2QEJ8lHwMbVBJFOtn6jeF6IknQlU=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-TXlNmzofNOSer3f5UMij0g-1; Thu, 04 Aug 2022 03:54:52 -0400
X-MC-Unique: TXlNmzofNOSer3f5UMij0g-1
Received: by mail-qv1-f71.google.com with SMTP id u9-20020a0cec89000000b0047498457e00so8518494qvo.3
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 00:54:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bJ16VF46u4pOdw/RGfqvVDi+9IGmgAsgCoVtqAp4xpg=;
        b=SAHHJEDNsvz/nrnol31ABgRTGrpdSHjfXXs9/DXPwPV2JUFhpQsVEm52Lc2Z6gr/QD
         fDoWgxh21DQ5KYDuv06QNb2+xmHOemsNyoywsXlJ3idWMgEWY+5Al+2Y3b+GYSj1reyc
         1jdGA/Nn3Dt58FHhXPnPl78lqar5Ui4R687U5Xz6mnhAPM0ejUuYTeitr3lwI5CAMzrB
         97sBdwskj3wgnKeUaKkhuKKljB7KbfZqB8eF8o5WwoBHbbzFbFijEjiDnFXNVPtxDQfx
         ncDQmeT2UMvdiJqnkRLVIAxk1MdoMmUjPph6i3h1d5TJcj9dimyOtztW3vXxQBijLAMp
         MkKA==
X-Gm-Message-State: ACgBeo0NqmcaSgvCsmMC82Z1dTXGXDKQvT1isngELoN8b8kZvAr91nJi
        0ml+785g9z+enq0lIowmH85Fd31927npb3o3hJX8x3Aw3I8N5CNumaGWa0U8U3691HB2G+nYFGq
        AeNVMXXwRS0tgPnIgNoU8XRp4dBjF
X-Received: by 2002:a05:6214:5003:b0:474:a0c1:99b2 with SMTP id jo3-20020a056214500300b00474a0c199b2mr335378qvb.64.1659599690924;
        Thu, 04 Aug 2022 00:54:50 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4kUPdRZ6ttHQF1YrPpb+edyYW8adkT88spVcI4IWgoUmncK3hU4M1kaVTzNphQb2haNGv8mNzJUnLup4j+VH4=
X-Received: by 2002:a05:6214:5003:b0:474:a0c1:99b2 with SMTP id
 jo3-20020a056214500300b00474a0c199b2mr335363qvb.64.1659599690676; Thu, 04 Aug
 2022 00:54:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220803171821.481336-1-eperezma@redhat.com> <20220803171821.481336-8-eperezma@redhat.com>
 <dcc42e5b-cce7-63ed-5312-599b4a7a4a2d@redhat.com>
In-Reply-To: <dcc42e5b-cce7-63ed-5312-599b4a7a4a2d@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 4 Aug 2022 09:54:14 +0200
Message-ID: <CAJaqyWersesOBjai1EVQ5-8Z2DfjOwFdKd_86VdtbObuK8h88Q@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] vdpa: Always start CVQ in SVQ mode
To:     Jason Wang <jasowang@redhat.com>
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
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 4, 2022 at 6:44 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/8/4 01:18, Eugenio P=C3=A9rez =E5=86=99=E9=81=93:
> > Isolate control virtqueue in its own group, allowing to intercept contr=
ol
> > commands but letting dataplane run totally passthrough to the guest.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> > v3:
> > * Make asid related queries print a warning instead of returning an
> >    error and stop the start of qemu.
> > ---
> >   hw/virtio/vhost-vdpa.c |   3 +-
> >   net/vhost-vdpa.c       | 144 +++++++++++++++++++++++++++++++++++++++-=
-
> >   2 files changed, 142 insertions(+), 5 deletions(-)
> >
> > diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > index 131100841c..a4cb68862b 100644
> > --- a/hw/virtio/vhost-vdpa.c
> > +++ b/hw/virtio/vhost-vdpa.c
> > @@ -674,7 +674,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_=
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
> > index e3b65ed546..5f39f0edb5 100644
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
> > @@ -224,6 +229,101 @@ static NetClientInfo net_vhost_vdpa_info =3D {
> >           .check_peer_type =3D vhost_vdpa_check_peer_type,
> >   };
> >
> > +static void vhost_vdpa_get_vring_group(int device_fd,
> > +                                       struct vhost_vring_state *state=
)
> > +{
> > +    int r =3D ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, state);
> > +    if (unlikely(r < 0)) {
> > +        /*
> > +         * Assume all groups are 0, the consequences are the same and =
we will
> > +         * not abort device creation
> > +         */
> > +        state->num =3D 0;
> > +    }
> > +}
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
> > +
> > +    for (int i =3D 0; i < (dev->vq_index_end - 1); ++i) {
> > +        struct vhost_vring_state vq_group =3D {
> > +            .index =3D i,
> > +        };
> > +
> > +        vhost_vdpa_get_vring_group(v->device_fd, &vq_group);
> > +        if (unlikely(vq_group.num =3D=3D cvq_group.num)) {
> > +            warn_report("CVQ %u group is the same as VQ %u one (%u)",
> > +                         cvq_group.index, vq_group.index, cvq_group.nu=
m);
>
>
> I don't get why we need warn here.
>

Is not mandatory, but vhost will set a migration blocker and there is
no way to trace it back to the cause without it.

>
> > +            return false;
> > +        }
> > +    }
> > +
> > +    return true;
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
> > +        warn_report("Can't set vq group %u asid %u, errno=3D%d (%s)",
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
> > +    vhost_vdpa_get_vring_group(v->device_fd, &cvq_group);
> > +    if (!vhost_vdpa_cvq_group_is_independent(v, cvq_group)) {
>
>
> If there's no other caller of vhost_vdpa_cvq_group_is_independent(), I'd
> suggest to unitfy them into a single helper.
>

Sure, that can be done.

Thanks!

> (Btw, the name of the function is kind of too long).
>
> Thanks
>
>
> > +        v->shadow_vqs_enabled =3D false;
> > +        return;
> > +    }
> > +
> > +    r =3D vhost_vdpa_set_address_space_id(v, cvq_group.num,
> > +                                        VHOST_VDPA_NET_CVQ_ASID);
> > +    v->shadow_vqs_enabled =3D r =3D=3D 0;
> > +    s->vhost_vdpa.address_space_id =3D r =3D=3D 0 ? 1 : 0;
> > +}
> > +
> >   static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr=
)
> >   {
> >       VhostIOVATree *tree =3D v->iova_tree;
> > @@ -431,6 +531,7 @@ static NetClientInfo net_vhost_vdpa_cvq_info =3D {
> >       .type =3D NET_CLIENT_DRIVER_VHOST_VDPA,
> >       .size =3D sizeof(VhostVDPAState),
> >       .receive =3D vhost_vdpa_receive,
> > +    .prepare =3D vhost_vdpa_net_prepare,
> >       .load =3D vhost_vdpa_net_load,
> >       .cleanup =3D vhost_vdpa_cleanup,
> >       .has_vnet_hdr =3D vhost_vdpa_has_vnet_hdr,
> > @@ -541,12 +642,38 @@ static const VhostShadowVirtqueueOps vhost_vdpa_n=
et_svq_ops =3D {
> >       .avail_handler =3D vhost_vdpa_net_handle_ctrl_avail,
> >   };
> >
> > +static uint32_t vhost_vdpa_get_as_num(int vdpa_device_fd)
> > +{
> > +    uint64_t features;
> > +    unsigned num_as;
> > +    int r;
> > +
> > +    r =3D ioctl(vdpa_device_fd, VHOST_GET_BACKEND_FEATURES, &features)=
;
> > +    if (unlikely(r < 0)) {
> > +        warn_report("Cannot get backend features");
> > +        return 1;
> > +    }
> > +
> > +    if (!(features & BIT_ULL(VHOST_BACKEND_F_IOTLB_ASID))) {
> > +        return 1;
> > +    }
> > +
> > +    r =3D ioctl(vdpa_device_fd, VHOST_VDPA_GET_AS_NUM, &num_as);
> > +    if (unlikely(r < 0)) {
> > +        warn_report("Cannot retrieve number of supported ASs");
> > +        return 1;
> > +    }
> > +
> > +    return num_as;
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
> > @@ -565,6 +692,7 @@ static NetClientState *net_vhost_vdpa_init(NetClien=
tState *peer,
> >       snprintf(nc->info_str, sizeof(nc->info_str), TYPE_VHOST_VDPA);
> >       s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> >
> > +    s->address_space_num =3D nas;
> >       s->vhost_vdpa.device_fd =3D vdpa_device_fd;
> >       s->vhost_vdpa.index =3D queue_pair_index;
> >       s->always_svq =3D svq;
> > @@ -650,6 +778,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, const=
 char *name,
> >       g_autoptr(VhostIOVATree) iova_tree =3D NULL;
> >       NetClientState *nc;
> >       int queue_pairs, r, i =3D 0, has_cvq =3D 0;
> > +    unsigned num_as =3D 1;
> > +    bool svq_cvq;
> >
> >       assert(netdev->type =3D=3D NET_CLIENT_DRIVER_VHOST_VDPA);
> >       opts =3D &netdev->u.vhost_vdpa;
> > @@ -674,7 +804,13 @@ int net_init_vhost_vdpa(const Netdev *netdev, cons=
t char *name,
> >           goto err;
> >       }
> >
> > -    if (opts->x_svq) {
> > +    svq_cvq =3D opts->x_svq;
> > +    if (has_cvq && !opts->x_svq) {
> > +        num_as =3D vhost_vdpa_get_as_num(vdpa_device_fd);
> > +        svq_cvq =3D num_as > 1;
> > +    }
> > +
> > +    if (opts->x_svq || svq_cvq) {
> >           struct vhost_vdpa_iova_range iova_range;
> >
> >           uint64_t invalid_dev_features =3D
> > @@ -697,15 +833,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, con=
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

