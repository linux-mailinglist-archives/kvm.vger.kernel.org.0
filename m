Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15936246A0
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 17:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiKJQI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 11:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiKJQI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 11:08:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0C030F73
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668096477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vFDmj7cS93WsNeALzw6JqRF2YsJviPisBnmWcDHA1oE=;
        b=QBVrCNGeCP5tBohumJpTi8uLhYl3IRB7DasNIgPJ4pwtsDkzRedWPH0PYc4931+88OOZNa
        EK7+3Yae9zHETrB4rlSp8QMJjgh69TDQO8EdkDbN8Kk057VJgVJmy6p5xJCJiiCt9n7CIK
        AGacDNGwS6lIOqyFrWzVsL6krUHp68Y=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-523-mSgVUj91OjyyMMLeFqpo5Q-1; Thu, 10 Nov 2022 11:07:55 -0500
X-MC-Unique: mSgVUj91OjyyMMLeFqpo5Q-1
Received: by mail-pl1-f197.google.com with SMTP id c1-20020a170902d48100b0018723580343so1641163plg.15
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:07:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vFDmj7cS93WsNeALzw6JqRF2YsJviPisBnmWcDHA1oE=;
        b=gW4vz4FBGP86VX4+bUn1IwO1YyoCRBvaXD4zzyKqMEIfVY8k+5l/+yyx/VF9JxWpiD
         zBpOLPxj3hWD3WSYo96fRDrGM/L/FXz3oX4yQL2sL1iqArwrawmnEjiQb86wl5rJ2QDu
         NjmLkKafHmVy07nzziHWitG1JilKkH1w10yZnam1phbhvOGPvWOUOLKWKDNqiBwkxXci
         HRy6C2pD8P5tzdXLiGdDqE/80vvgGPSis2F99xE5YhBPnH4uDqzGqhzTcAzGFmbAQa/o
         TcyJsvh0A2dihk9aEz/fWgHBk7IcotoK1iA2lIsK2iihSVB9P8mP0C42eSWiaPoIb+jJ
         LJVQ==
X-Gm-Message-State: ACrzQf3Trd+iNF/6UlKEwMSKmuFgRzh2LEPUFTMlOQN3Eof4JAMfSXlC
        prDQIJqgh6889ABMxGDA/NY6rEomJsD3BOW5w651FT1CLm3qpQPf4uaRlRVIm0zCesiXn83iK6f
        jJNowJxzUb/XVMCYjCWmBS3/RXrCL
X-Received: by 2002:a17:902:ce82:b0:187:3591:edac with SMTP id f2-20020a170902ce8200b001873591edacmr48887926plg.153.1668096470921;
        Thu, 10 Nov 2022 08:07:50 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6fqvE9KeQrv0jG700sRITuN7H2QtYeZx9sZN/QANDq4HWhSPupkE9Hw7ld+/+FjEl09vU+uxnPpauxfAJbuWc=
X-Received: by 2002:a17:902:ce82:b0:187:3591:edac with SMTP id
 f2-20020a170902ce8200b001873591edacmr48887896plg.153.1668096470371; Thu, 10
 Nov 2022 08:07:50 -0800 (PST)
MIME-Version: 1.0
References: <20221108170755.92768-1-eperezma@redhat.com> <20221108170755.92768-11-eperezma@redhat.com>
 <5eb848d8-eb27-4c27-377d-cb6edfe3718c@redhat.com>
In-Reply-To: <5eb848d8-eb27-4c27-377d-cb6edfe3718c@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 10 Nov 2022 17:07:14 +0100
Message-ID: <CAJaqyWdj-EG==hs8D_G6rZOC=20V1fxoBwXqbeU119_EVtOWGw@mail.gmail.com>
Subject: Re: [PATCH v6 10/10] vdpa: Always start CVQ in SVQ mode
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

On Thu, Nov 10, 2022 at 7:25 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/11/9 01:07, Eugenio P=C3=A9rez =E5=86=99=E9=81=93:
> > Isolate control virtqueue in its own group, allowing to intercept contr=
ol
> > commands but letting dataplane run totally passthrough to the guest.
>
>
> I think we need to tweak the title to "vdpa: Always start CVQ in SVQ
> mode if possible". Since SVQ for CVQ can't be enabled without ASID suppor=
t?
>

Yes, I totally agree.

>
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
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
> >   net/vhost-vdpa.c       | 138 ++++++++++++++++++++++++++++++++++++++--=
-
> >   2 files changed, 132 insertions(+), 9 deletions(-)
> >
> > diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > index e3914fa40e..6401e7efb1 100644
> > --- a/hw/virtio/vhost-vdpa.c
> > +++ b/hw/virtio/vhost-vdpa.c
> > @@ -648,7 +648,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_=
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
> > index 02780ee37b..7245ea70c6 100644
> > --- a/net/vhost-vdpa.c
> > +++ b/net/vhost-vdpa.c
> > @@ -38,6 +38,9 @@ typedef struct VhostVDPAState {
> >       void *cvq_cmd_out_buffer;
> >       virtio_net_ctrl_ack *status;
> >
> > +    /* Number of address spaces supported by the device */
> > +    unsigned address_space_num;
>
>
> I'm not sure this is the best place to store thing like this since it
> can cause confusion. We will have multiple VhostVDPAState when
> multiqueue is enabled.
>

I think we can delete this and ask it on each device start.

>
> > +
> >       /* The device always have SVQ enabled */
> >       bool always_svq;
> >       bool started;
> > @@ -101,6 +104,9 @@ static const uint64_t vdpa_svq_device_features =3D
> >       BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
> >       BIT_ULL(VIRTIO_NET_F_STANDBY);
> >
> > +#define VHOST_VDPA_NET_DATA_ASID 0
> > +#define VHOST_VDPA_NET_CVQ_ASID 1
> > +
> >   VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
> >   {
> >       VhostVDPAState *s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> > @@ -242,6 +248,34 @@ static NetClientInfo net_vhost_vdpa_info =3D {
> >           .check_peer_type =3D vhost_vdpa_check_peer_type,
> >   };
> >
> > +static uint32_t vhost_vdpa_get_vring_group(int device_fd, unsigned vq_=
index)
> > +{
> > +    struct vhost_vring_state state =3D {
> > +        .index =3D vq_index,
> > +    };
> > +    int r =3D ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, &state);
> > +
> > +    return r < 0 ? 0 : state.num;
>
>
> Assume 0 when ioctl() fail is probably not a good idea: errors in ioctl
> might be hidden. It would be better to fallback to 0 when ASID is not
> supported.
>

Did I misunderstand you on [1]?

>
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
> >   static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr=
)
> >   {
> >       VhostIOVATree *tree =3D v->iova_tree;
> > @@ -316,11 +350,54 @@ dma_map_err:
> >   static int vhost_vdpa_net_cvq_start(NetClientState *nc)
> >   {
> >       VhostVDPAState *s;
> > -    int r;
> > +    struct vhost_vdpa *v;
> > +    uint32_t cvq_group;
> > +    int cvq_index, r;
> >
> >       assert(nc->info->type =3D=3D NET_CLIENT_DRIVER_VHOST_VDPA);
> >
> >       s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> > +    v =3D &s->vhost_vdpa;
> > +
> > +    v->listener_shadow_vq =3D s->always_svq;
> > +    v->shadow_vqs_enabled =3D s->always_svq;
> > +    s->vhost_vdpa.address_space_id =3D VHOST_VDPA_NET_DATA_ASID;
> > +
> > +    if (s->always_svq) {
> > +        goto out;
> > +    }
> > +
> > +    if (s->address_space_num < 2) {
> > +        return 0;
> > +    }
> > +
> > +    if (!vhost_vdpa_net_valid_svq_features(v->dev->features, NULL)) {
> > +        return 0;
> > +    }
>
>
> Any reason we do the above check during the start/stop? It should be
> easier to do that in the initialization.
>

We can store it as a member of VhostVDPAState maybe? They will be
duplicated like the current number of AS.

>
> > +
> > +    /**
> > +     * Check if all the virtqueues of the virtio device are in a diffe=
rent vq
> > +     * than the last vq. VQ group of last group passed in cvq_group.
> > +     */
> > +    cvq_index =3D v->dev->vq_index_end - 1;
> > +    cvq_group =3D vhost_vdpa_get_vring_group(v->device_fd, cvq_index);
> > +    for (int i =3D 0; i < cvq_index; ++i) {
> > +        uint32_t group =3D vhost_vdpa_get_vring_group(v->device_fd, i)=
;
> > +
> > +        if (unlikely(group =3D=3D cvq_group)) {
> > +            warn_report("CVQ %u group is the same as VQ %u one (%u)", =
cvq_group,
> > +                        i, group);
> > +            return 0;
> > +        }
> > +    }
> > +
> > +    r =3D vhost_vdpa_set_address_space_id(v, cvq_group, VHOST_VDPA_NET=
_CVQ_ASID);
> > +    if (r =3D=3D 0) {
> > +        v->shadow_vqs_enabled =3D true;
> > +        s->vhost_vdpa.address_space_id =3D VHOST_VDPA_NET_CVQ_ASID;
> > +    }
> > +
> > +out:
> >       if (!s->vhost_vdpa.shadow_vqs_enabled) {
> >           return 0;
> >       }
> > @@ -542,12 +619,38 @@ static const VhostShadowVirtqueueOps vhost_vdpa_n=
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
>
>
> Let's return error here. This help. to identify bugs of qemu or kernel.
>

Same comment as with VHOST_VDPA_GET_VRING_GROUP.

>
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
> > @@ -566,6 +669,7 @@ static NetClientState *net_vhost_vdpa_init(NetClien=
tState *peer,
> >       qemu_set_info_str(nc, TYPE_VHOST_VDPA);
> >       s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> >
> > +    s->address_space_num =3D nas;
> >       s->vhost_vdpa.device_fd =3D vdpa_device_fd;
> >       s->vhost_vdpa.index =3D queue_pair_index;
> >       s->always_svq =3D svq;
> > @@ -652,6 +756,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, const=
 char *name,
> >       g_autoptr(VhostIOVATree) iova_tree =3D NULL;
> >       NetClientState *nc;
> >       int queue_pairs, r, i =3D 0, has_cvq =3D 0;
> > +    unsigned num_as =3D 1;
> > +    bool svq_cvq;
> >
> >       assert(netdev->type =3D=3D NET_CLIENT_DRIVER_VHOST_VDPA);
> >       opts =3D &netdev->u.vhost_vdpa;
> > @@ -693,12 +799,28 @@ int net_init_vhost_vdpa(const Netdev *netdev, con=
st char *name,
> >           return queue_pairs;
> >       }
> >
> > -    if (opts->x_svq) {
> > -        struct vhost_vdpa_iova_range iova_range;
> > +    svq_cvq =3D opts->x_svq;
> > +    if (has_cvq && !opts->x_svq) {
> > +        num_as =3D vhost_vdpa_get_as_num(vdpa_device_fd);
> > +        svq_cvq =3D num_as > 1;
> > +    }
>
>
> The above check is not easy to follow, how about?
>
> svq_cvq =3D vhost_vdpa_get_as_num() > 1 ? true : opts->x_svq;
>

That would allocate the iova tree even if CVQ is not used in the
guest. And num_as is reused later, although we can ask it to the
device at device start to avoid this.

If any, the linear conversion would be:
svq_cvq =3D opts->x_svq || (has_cvq && vhost_vdpa_get_as_num(vdpa_device_fd=
))

So we avoid the AS_NUM ioctl if not needed.

>
> > +
> > +    if (opts->x_svq || svq_cvq) {
>
>
> Any chance we can have opts->x_svq =3D true but svq_cvq =3D false? Checki=
ng
> svq_cvq seems sufficient here.
>

The reverse is possible, to have svq_cvq but no opts->x_svq.

Depending on that, this code emits a warning or a fatal error.

>
> > +        Error *warn =3D NULL;
> >
> > -        if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
> > -            goto err_svq;
> > +        svq_cvq =3D vhost_vdpa_net_valid_svq_features(features,
> > +                                                   opts->x_svq ? errp =
: &warn);
> > +        if (!svq_cvq) {
>
>
> Same question as above.
>
>
> > +            if (opts->x_svq) {
> > +                goto err_svq;
> > +            } else {
> > +                warn_reportf_err(warn, "Cannot shadow CVQ: ");
> > +            }
> >           }
> > +    }
> > +
> > +    if (opts->x_svq || svq_cvq) {
> > +        struct vhost_vdpa_iova_range iova_range;
> >
> >           vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
> >           iova_tree =3D vhost_iova_tree_new(iova_range.first, iova_rang=
e.last);
> > @@ -708,15 +830,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, con=
st char *name,
> >
> >       for (i =3D 0; i < queue_pairs; i++) {
> >           ncs[i] =3D net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
> > -                                     vdpa_device_fd, i, 2, true, opts-=
>x_svq,
> > -                                     iova_tree);
> > +                                     vdpa_device_fd, i, 2, num_as, tru=
e,
>
>
> I don't get why we need pass num_as to a specific vhost_vdpa structure.
> It should be sufficient to pass asid there.
>

ASID is not known at this time, but at device's start. This is because
we cannot ask if the CVQ is in its own vq group, because we don't know
the control virtqueue index until the guest acknowledges the different
features.

Thanks!

[1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg901685.html


>
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

