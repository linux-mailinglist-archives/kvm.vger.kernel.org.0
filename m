Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09FC6133D7
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 11:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiJaKma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 06:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJaKm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 06:42:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CB0DFE2
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 03:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667212894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jg34LqUFq9kapneHl8gAo0S9bhs12rrReRlScpgS/yc=;
        b=a6JaYa3KC/1v8tPo6dEetOoRYkKYN1+KeKzFvEDX785Bv+955aByWbm+zkwjgRKXZMUDoY
        LV9MYsZJ4Bxp/bs+Lb1x1YZsbhlYbyWeirLkpfDdjvQZn3+ykP/yYweJDC/9vEv/S1v9j1
        JMYI8PZNK3g5nr0Lajp2Ic5N/Knk3Vo=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-246-3kn76Q_yP-2tiK1JTU1RpA-1; Mon, 31 Oct 2022 06:41:26 -0400
X-MC-Unique: 3kn76Q_yP-2tiK1JTU1RpA-1
Received: by mail-pj1-f69.google.com with SMTP id my9-20020a17090b4c8900b002130d29fd7cso10263150pjb.7
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 03:41:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jg34LqUFq9kapneHl8gAo0S9bhs12rrReRlScpgS/yc=;
        b=GxVqnT7EiZSaaKOi7M4OGVmx43FV5H15mA9adUX29kVuNEY+54zdb6logDtrr0wOWB
         +w1eLeMyxK4HJGZWGNx8+QkzfN2s3oFdIUSTpjbBjp+bFdVIbphBHmYUVlAtREkAvkVQ
         xpfMS6tM8Xh9NtYHFx+swXFV7HQzwPkIz1v0A9lLdu+1THfUtTwE/dfPKSj7lYLupH/6
         hcSbndPITtdFu+v68Aih/AZogpWKpTT/vSvZWIkVQb49ICCw+cM44FlXOBxqJU1AOuO1
         SE3izAdYDpaCoEmNThEaRGYrpPtvzyxTSdkTQSC/5jAWFJIdsikK4ZjGgD6zF9fe7frF
         TWpg==
X-Gm-Message-State: ACrzQf0tzd4IoML5ky7+jVoGZdPqb5Qr+EAw+XElm0x8BgMGZp8ujRtH
        al5LQG9QvUbO+/kKYec+ZhM44gH1Ti5mwbcqGR9+b+ZRBemI0JW8qEkXMu6ygUXMdPQbC/1q6C+
        LnK7lkM5dt7OmX4R1sqQWYJsNt5Xy
X-Received: by 2002:a05:6a00:170b:b0:56d:4b31:c4cf with SMTP id h11-20020a056a00170b00b0056d4b31c4cfmr7367844pfc.68.1667212884966;
        Mon, 31 Oct 2022 03:41:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5gXKVkhk9oEKr0v8jRDpRWowu8I9+BcHP9jg2RaNQ//MdQeP6EIwqtOTZ9+Nypmb1XNOQJT+mS3kYaqMaLQ4A=
X-Received: by 2002:a05:6a00:170b:b0:56d:4b31:c4cf with SMTP id
 h11-20020a056a00170b00b0056d4b31c4cfmr7367822pfc.68.1667212884618; Mon, 31
 Oct 2022 03:41:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221011104154.1209338-1-eperezma@redhat.com> <20221011104154.1209338-7-eperezma@redhat.com>
 <20221031042356-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221031042356-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 31 Oct 2022 11:40:48 +0100
Message-ID: <CAJaqyWdmvASZfj5rZLZjUxEnZB2AJWQFKEj30g_w2_0z9vqjow@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] vdpa: Always start CVQ in SVQ mode
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

On Mon, Oct 31, 2022 at 9:25 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Oct 11, 2022 at 12:41:54PM +0200, Eugenio P=C3=A9rez wrote:
> > Isolate control virtqueue in its own group, allowing to intercept contr=
ol
> > commands but letting dataplane run totally passthrough to the guest.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
>
> I guess we need svq for this. Not a reason to allocate it for
> all queues.

I'll document this part better.

> Also if vdpa does not support pasid then I guess
> we should not bother with svq.
>

Yes, if the device does not support ASID or it does not support all
conditions (like to be able to isolate precisely CVQ in its own AS),
svq is not enabled.

This is not documented properly in the patch description.


> > ---
> > v5:
> > * Fixing the not adding cvq buffers when x-svq=3Don is specified.
> > * Move vring state in vhost_vdpa_get_vring_group instead of using a
> >   parameter.
> > * Rename VHOST_VDPA_NET_CVQ_PASSTHROUGH to VHOST_VDPA_NET_DATA_ASID
> >
> > v4:
> > * Squash vhost_vdpa_cvq_group_is_independent.
> > * Rebased on last CVQ start series, that allocated CVQ cmd bufs at load
> > * Do not check for cvq index on vhost_vdpa_net_prepare, we only have on=
e
> >   that callback registered in that NetClientInfo.
> >
> > v3:
> > * Make asid related queries print a warning instead of returning an
> >   error and stop the start of qemu.
> > ---
> >  hw/virtio/vhost-vdpa.c |   3 +-
> >  net/vhost-vdpa.c       | 118 +++++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 115 insertions(+), 6 deletions(-)
> >
> > diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > index 29d009c02b..fd4de06eab 100644
> > --- a/hw/virtio/vhost-vdpa.c
> > +++ b/hw/virtio/vhost-vdpa.c
> > @@ -682,7 +682,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_=
dev *dev)
> >  {
> >      uint64_t features;
> >      uint64_t f =3D 0x1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2 |
> > -        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH;
> > +        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH |
> > +        0x1ULL << VHOST_BACKEND_F_IOTLB_ASID;
> >      int r;
> >
> >      if (vhost_vdpa_call(dev, VHOST_GET_BACKEND_FEATURES, &features)) {
> > diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> > index f7831aeb8d..6f6ef59ea3 100644
> > --- a/net/vhost-vdpa.c
> > +++ b/net/vhost-vdpa.c
> > @@ -38,6 +38,9 @@ typedef struct VhostVDPAState {
> >      void *cvq_cmd_out_buffer;
> >      virtio_net_ctrl_ack *status;
> >
> > +    /* Number of address spaces supported by the device */
> > +    unsigned address_space_num;
> > +
> >      /* The device always have SVQ enabled */
> >      bool always_svq;
> >      bool started;
> > @@ -102,6 +105,9 @@ static const uint64_t vdpa_svq_device_features =3D
> >      BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
> >      BIT_ULL(VIRTIO_NET_F_STANDBY);
> >
> > +#define VHOST_VDPA_NET_DATA_ASID 0
> > +#define VHOST_VDPA_NET_CVQ_ASID 1
> > +
> >  VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
> >  {
> >      VhostVDPAState *s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> > @@ -226,6 +232,34 @@ static NetClientInfo net_vhost_vdpa_info =3D {
> >          .check_peer_type =3D vhost_vdpa_check_peer_type,
> >  };
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
> >  static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
> >  {
> >      VhostIOVATree *tree =3D v->iova_tree;
> > @@ -300,11 +334,50 @@ dma_map_err:
> >  static int vhost_vdpa_net_cvq_start(NetClientState *nc)
> >  {
> >      VhostVDPAState *s;
> > -    int r;
> > +    struct vhost_vdpa *v;
> > +    uint32_t cvq_group;
> > +    int cvq_index, r;
> >
> >      assert(nc->info->type =3D=3D NET_CLIENT_DRIVER_VHOST_VDPA);
> >
> >      s =3D DO_UPCAST(VhostVDPAState, nc, nc);
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
> >      if (!s->vhost_vdpa.shadow_vqs_enabled) {
> >          return 0;
> >      }
> > @@ -576,12 +649,38 @@ static const VhostShadowVirtqueueOps vhost_vdpa_n=
et_svq_ops =3D {
> >      .avail_handler =3D vhost_vdpa_net_handle_ctrl_avail,
> >  };
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
> >  static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
> >                                             const char *device,
> >                                             const char *name,
> >                                             int vdpa_device_fd,
> >                                             int queue_pair_index,
> >                                             int nvqs,
> > +                                           unsigned nas,
> >                                             bool is_datapath,
> >                                             bool svq,
> >                                             VhostIOVATree *iova_tree)
> > @@ -600,6 +699,7 @@ static NetClientState *net_vhost_vdpa_init(NetClien=
tState *peer,
> >      snprintf(nc->info_str, sizeof(nc->info_str), TYPE_VHOST_VDPA);
> >      s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> >
> > +    s->address_space_num =3D nas;
> >      s->vhost_vdpa.device_fd =3D vdpa_device_fd;
> >      s->vhost_vdpa.index =3D queue_pair_index;
> >      s->always_svq =3D svq;
> > @@ -686,6 +786,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, const=
 char *name,
> >      g_autoptr(VhostIOVATree) iova_tree =3D NULL;
> >      NetClientState *nc;
> >      int queue_pairs, r, i =3D 0, has_cvq =3D 0;
> > +    unsigned num_as =3D 1;
> > +    bool svq_cvq;
> >
> >      assert(netdev->type =3D=3D NET_CLIENT_DRIVER_VHOST_VDPA);
> >      opts =3D &netdev->u.vhost_vdpa;
> > @@ -711,7 +813,13 @@ int net_init_vhost_vdpa(const Netdev *netdev, cons=
t char *name,
> >          return queue_pairs;
> >      }
> >
> > -    if (opts->x_svq) {
> > +    svq_cvq =3D opts->x_svq;
> > +    if (has_cvq && !opts->x_svq) {
> > +        num_as =3D vhost_vdpa_get_as_num(vdpa_device_fd);
> > +        svq_cvq =3D num_as > 1;
> > +    }
> > +
> > +    if (opts->x_svq || svq_cvq) {
> >          struct vhost_vdpa_iova_range iova_range;
> >
> >          uint64_t invalid_dev_features =3D
> > @@ -734,15 +842,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, con=
st char *name,
> >
> >      for (i =3D 0; i < queue_pairs; i++) {
> >          ncs[i] =3D net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
> > -                                     vdpa_device_fd, i, 2, true, opts-=
>x_svq,
> > -                                     iova_tree);
> > +                                     vdpa_device_fd, i, 2, num_as, tru=
e,
> > +                                     opts->x_svq, iova_tree);
> >          if (!ncs[i])
> >              goto err;
> >      }
> >
> >      if (has_cvq) {
> >          nc =3D net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
> > -                                 vdpa_device_fd, i, 1, false,
> > +                                 vdpa_device_fd, i, 1, num_as, false,
> >                                   opts->x_svq, iova_tree);
> >          if (!nc)
> >              goto err;
> > --
> > 2.31.1
>

