Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A638E599541
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 08:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344159AbiHSGSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 02:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239390AbiHSGS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 02:18:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2ED525E81
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 23:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660889900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0pgjEoL4Ix1j6h8R5TCk6lNImyXtXHknncSlwzEHJZs=;
        b=DZnw+l9tGliASZ5vXMURLxVHsB+71XCDxw8jaquFISbwAOyoW0M7h3MlipxZz8Fj3wUSRR
        0/LZ0xttllyZs0nrB5AtaayEOZ9ByI6hX1Cn9mJtGyiew6KRJk5DgkwAJ8rMdJlGngdHOC
        Xi1Fezsmp6llZzE8/2/ePb2AKrtAGEA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-1-sxMLMIqsNdS-Sm9d-zN7sQ-1; Fri, 19 Aug 2022 02:18:19 -0400
X-MC-Unique: sxMLMIqsNdS-Sm9d-zN7sQ-1
Received: by mail-lj1-f197.google.com with SMTP id q5-20020a2e84c5000000b0025ec9ff93c8so748020ljh.15
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 23:18:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=0pgjEoL4Ix1j6h8R5TCk6lNImyXtXHknncSlwzEHJZs=;
        b=Vq82TSnOHhlLyEM/UH8FBVs9Hgc818a7ozdnGV1dV8n7M2p1d4l329EVpzDdDYbGT4
         g2EMy9OGBL945DRVPPxWBd/mWP64LjFC1GaBktHtc300pbdpAJvc8rTkSmXoOayQXygF
         n7Ns8trN3PILASlvMWPlK75F34j2JTx+PaG23CvlQdFustViUT1w0ZSnuhBLmWw894pU
         3er/wcLRLqcgZbLdVf+6faN4DATDHBtD8ZDAIc/Nw9+0qps0uz3rZgsmcavb55rHfMjj
         1hPEbtjMTujqc6kul02Up6Xxrz62xHt2zbiCfRjl6sQLKey6muF7QN5BIsgPddQXjSY3
         0UhQ==
X-Gm-Message-State: ACgBeo3xSt+Kib20RsvIZQHT+Wm3eer/OP+rhJj6PZhq/j5U2YzpiJlI
        83zOgmSMa4oBm7R05t9h8ZTvn0cxom7hsaRgyq2GAO/y47WQ8eJwn3dG8PQ+I3g5FxjKHs5RGf5
        NKSJvjAMWQ530fkNe10ucsGbuKBp7
X-Received: by 2002:a05:6512:3da1:b0:48f:cad0:195a with SMTP id k33-20020a0565123da100b0048fcad0195amr2024358lfv.397.1660889897713;
        Thu, 18 Aug 2022 23:18:17 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6Y44dktn926PPqLldGFhb4gwG4PfmSj09PfUV9/GGzyXux8X1NnRcoBSuj7gVWNR33cLUBRJ2KzNfQ6ie0quI=
X-Received: by 2002:a05:6512:3da1:b0:48f:cad0:195a with SMTP id
 k33-20020a0565123da100b0048fcad0195amr2024346lfv.397.1660889897376; Thu, 18
 Aug 2022 23:18:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220805163909.872646-1-eperezma@redhat.com> <20220805163909.872646-7-eperezma@redhat.com>
 <CACGkMEtOr7JOsOTHiwcrk8FoRWhwHTzBWX30iaKCuHz26UOzNQ@mail.gmail.com> <CAJaqyWfY9py+K3KOww+2BcVJcyqC+GAt271hgVz5PzHsDP34BQ@mail.gmail.com>
In-Reply-To: <CAJaqyWfY9py+K3KOww+2BcVJcyqC+GAt271hgVz5PzHsDP34BQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 19 Aug 2022 14:18:06 +0800
Message-ID: <CACGkMEuJ_dwsh26N-EuriyC42Uy_Fu_Bifnh6=Fwz_vLDf_X6w@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] vdpa: Always start CVQ in SVQ mode
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@mellanox.com>, Cindy Lu <lulu@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 9, 2022 at 3:54 PM Eugenio Perez Martin <eperezma@redhat.com> w=
rote:
>
> On Tue, Aug 9, 2022 at 9:36 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Sat, Aug 6, 2022 at 12:39 AM Eugenio P=C3=A9rez <eperezma@redhat.com=
> wrote:
> > >
> > > Isolate control virtqueue in its own group, allowing to intercept con=
trol
> > > commands but letting dataplane run totally passthrough to the guest.
> > >
> > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > ---
> > > v4:
> > > * Squash vhost_vdpa_cvq_group_is_independent.
> > > * Rebased on last CVQ start series, that allocated CVQ cmd bufs at lo=
ad
> > > * Do not check for cvq index on vhost_vdpa_net_prepare, we only have =
one
> > >   that callback registered in that NetClientInfo.
> > >
> > > v3:
> > > * Make asid related queries print a warning instead of returning an
> > >   error and stop the start of qemu.
> > > ---
> > >  hw/virtio/vhost-vdpa.c |   3 +-
> > >  net/vhost-vdpa.c       | 124 +++++++++++++++++++++++++++++++++++++++=
--
> > >  2 files changed, 122 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > > index 3eb67b27b7..69f34f4cc5 100644
> > > --- a/hw/virtio/vhost-vdpa.c
> > > +++ b/hw/virtio/vhost-vdpa.c
> > > @@ -678,7 +678,8 @@ static int vhost_vdpa_set_backend_cap(struct vhos=
t_dev *dev)
> > >  {
> > >      uint64_t features;
> > >      uint64_t f =3D 0x1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2 |
> > > -        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH;
> > > +        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH |
> > > +        0x1ULL << VHOST_BACKEND_F_IOTLB_ASID;
> > >      int r;
> > >
> > >      if (vhost_vdpa_call(dev, VHOST_GET_BACKEND_FEATURES, &features))=
 {
> > > diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> > > index bf78b1332f..c820a5fd9f 100644
> > > --- a/net/vhost-vdpa.c
> > > +++ b/net/vhost-vdpa.c
> > > @@ -37,6 +37,9 @@ typedef struct VhostVDPAState {
> > >      /* Control commands shadow buffers */
> > >      void *cvq_cmd_out_buffer, *cvq_cmd_in_buffer;
> > >
> > > +    /* Number of address spaces supported by the device */
> > > +    unsigned address_space_num;
> > > +
> > >      /* The device always have SVQ enabled */
> > >      bool always_svq;
> > >      bool started;
> > > @@ -100,6 +103,9 @@ static const uint64_t vdpa_svq_device_features =
=3D
> > >      BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
> > >      BIT_ULL(VIRTIO_NET_F_STANDBY);
> > >
> > > +#define VHOST_VDPA_NET_CVQ_PASSTHROUGH 0
> >
> > We need a better name for the macro since it's not easy to see it's an =
asid.
> >
>
> VHOST_VDPA_NET_DATA_ASID?

Looks fine.

>
> > > +#define VHOST_VDPA_NET_CVQ_ASID 1
> > > +
> > >  VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
> > >  {
> > >      VhostVDPAState *s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> > > @@ -224,6 +230,37 @@ static NetClientInfo net_vhost_vdpa_info =3D {
> > >          .check_peer_type =3D vhost_vdpa_check_peer_type,
> > >  };
> > >
> > > +static void vhost_vdpa_get_vring_group(int device_fd,
> > > +                                       struct vhost_vring_state *sta=
te)
> > > +{
> > > +    int r =3D ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, state);
> >
> > Let's hide vhost_vring_state from the caller and simply accept a vq
> > index parameter (as the below function did) then we can return the
> > group id.
> >
> > The hides low level ABI and simplify the caller's code.
> >
>
> We need to return an error.
>
> The example is a little bit pathological, but if we get that CVQ is on
> vq group !=3D 0, and all data vqs returns an error reading the vq group,
> I think we shouldn't assume they belong to the asid 0. Some of them
> could be on the same vq group as cvq, making all of this fail.
>
> Can we assume the vq group is an uint32_t? Would it work to return an
> int64_t with the possibility of errors?

Yes, or I think a simple int should be fine, I can't image we will
make use of the full 32 bit in near future.

>
> > > +    if (unlikely(r < 0)) {
> > > +        /*
> > > +         * Assume all groups are 0, the consequences are the same an=
d we will
> > > +         * not abort device creation
> > > +         */
> > > +        state->num =3D 0;
> > > +    }
> > > +}
> > > +
> > > +static int vhost_vdpa_set_address_space_id(struct vhost_vdpa *v,
> > > +                                           unsigned vq_group,
> > > +                                           unsigned asid_num)
> > > +{
> > > +    struct vhost_vring_state asid =3D {
> > > +        .index =3D vq_group,
> > > +        .num =3D asid_num,
> > > +    };
> > > +    int ret;
> > > +
> > > +    ret =3D ioctl(v->device_fd, VHOST_VDPA_SET_GROUP_ASID, &asid);
> > > +    if (unlikely(ret < 0)) {
> > > +        warn_report("Can't set vq group %u asid %u, errno=3D%d (%s)"=
,
> > > +            asid.index, asid.num, errno, g_strerror(errno));
> > > +    }
> > > +    return ret;
> > > +}
> > > +
> > >  static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *add=
r)
> > >  {
> > >      VhostIOVATree *tree =3D v->iova_tree;
> > > @@ -298,11 +335,55 @@ dma_map_err:
> > >  static int vhost_vdpa_net_cvq_prepare(NetClientState *nc)
> > >  {
> > >      VhostVDPAState *s;
> > > +    struct vhost_vdpa *v;
> > > +    struct vhost_vring_state cvq_group =3D {};
> > >      int r;
> > >
> > >      assert(nc->info->type =3D=3D NET_CLIENT_DRIVER_VHOST_VDPA);
> > >
> > >      s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> > > +    v =3D &s->vhost_vdpa;
> > > +    cvq_group.index =3D v->dev->vq_index_end - 1;
> > > +
> > > +    /* Default values */
> >
> > Code can explain itself so this comment is probably useless.
> >
>
> I'll delete.
>
> > > +    v->shadow_vqs_enabled =3D false;
> > > +    s->vhost_vdpa.address_space_id =3D VHOST_VDPA_NET_CVQ_PASSTHROUG=
H;
> > > +
> > > +    if (s->always_svq) {
> > > +        v->shadow_vqs_enabled =3D true;
> >
> > The name of the variable is suboptimal.
> >
> > I think we need to differ:
> >
> > 1) shadow all virtqueues
> >
> > from
> >
> > 2) shadow cvq only
> >
>
> Note that shadow_vqs_enabled is per vhost_vdpa, so
> v->shadow_vqs_enabled means that vqs of *v* are shadowed.
>
> Data vhost_vdpa can have a different value than CVQ vhost_vdpa.
>
> Having said that, I'm ok with changing the name of the variable, but I
> cannot come with a better one.

Ok, let's leave it as is.

Thanks

>
> Thanks!
>
> > Thanks
> >
> > > +        goto out;
> > > +    }
> > > +
> > > +    if (s->address_space_num < 2) {
> > > +        return 0;
> > > +    }
> > > +
> > > +    /**
> > > +     * Check if all the virtqueues of the virtio device are in a dif=
ferent vq
> > > +     * than the last vq. VQ group of last group passed in cvq_group.
> > > +     */
> > > +    vhost_vdpa_get_vring_group(v->device_fd, &cvq_group);
> > > +    for (int i =3D 0; i < (v->dev->vq_index_end - 1); ++i) {
> > > +        struct vhost_vring_state vq_group =3D {
> > > +            .index =3D i,
> > > +        };
> > > +
> > > +        vhost_vdpa_get_vring_group(v->device_fd, &vq_group);
> > > +        if (unlikely(vq_group.num =3D=3D cvq_group.num)) {
> > > +            warn_report("CVQ %u group is the same as VQ %u one (%u)"=
,
> > > +                         cvq_group.index, vq_group.index, cvq_group.=
num);
> > > +            return 0;
> > > +        }
> > > +    }
> > > +
> > > +    r =3D vhost_vdpa_set_address_space_id(v, cvq_group.num,
> > > +                                        VHOST_VDPA_NET_CVQ_ASID);
> > > +    if (r =3D=3D 0) {
> > > +        v->shadow_vqs_enabled =3D true;
> > > +        s->vhost_vdpa.address_space_id =3D VHOST_VDPA_NET_CVQ_ASID;
> > > +    }
> > > +
> > > +out:
> > >      if (!s->vhost_vdpa.shadow_vqs_enabled) {
> > >          return 0;
> > >      }
> > > @@ -523,12 +604,38 @@ static const VhostShadowVirtqueueOps vhost_vdpa=
_net_svq_ops =3D {
> > >      .avail_handler =3D vhost_vdpa_net_handle_ctrl_avail,
> > >  };
> > >
> > > +static uint32_t vhost_vdpa_get_as_num(int vdpa_device_fd)
> > > +{
> > > +    uint64_t features;
> > > +    unsigned num_as;
> > > +    int r;
> > > +
> > > +    r =3D ioctl(vdpa_device_fd, VHOST_GET_BACKEND_FEATURES, &feature=
s);
> > > +    if (unlikely(r < 0)) {
> > > +        warn_report("Cannot get backend features");
> > > +        return 1;
> > > +    }
> > > +
> > > +    if (!(features & BIT_ULL(VHOST_BACKEND_F_IOTLB_ASID))) {
> > > +        return 1;
> > > +    }
> > > +
> > > +    r =3D ioctl(vdpa_device_fd, VHOST_VDPA_GET_AS_NUM, &num_as);
> > > +    if (unlikely(r < 0)) {
> > > +        warn_report("Cannot retrieve number of supported ASs");
> > > +        return 1;
> > > +    }
> > > +
> > > +    return num_as;
> > > +}
> > > +
> > >  static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
> > >                                             const char *device,
> > >                                             const char *name,
> > >                                             int vdpa_device_fd,
> > >                                             int queue_pair_index,
> > >                                             int nvqs,
> > > +                                           unsigned nas,
> > >                                             bool is_datapath,
> > >                                             bool svq,
> > >                                             VhostIOVATree *iova_tree)
> > > @@ -547,6 +654,7 @@ static NetClientState *net_vhost_vdpa_init(NetCli=
entState *peer,
> > >      snprintf(nc->info_str, sizeof(nc->info_str), TYPE_VHOST_VDPA);
> > >      s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> > >
> > > +    s->address_space_num =3D nas;
> > >      s->vhost_vdpa.device_fd =3D vdpa_device_fd;
> > >      s->vhost_vdpa.index =3D queue_pair_index;
> > >      s->always_svq =3D svq;
> > > @@ -632,6 +740,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, con=
st char *name,
> > >      g_autoptr(VhostIOVATree) iova_tree =3D NULL;
> > >      NetClientState *nc;
> > >      int queue_pairs, r, i =3D 0, has_cvq =3D 0;
> > > +    unsigned num_as =3D 1;
> > > +    bool svq_cvq;
> > >
> > >      assert(netdev->type =3D=3D NET_CLIENT_DRIVER_VHOST_VDPA);
> > >      opts =3D &netdev->u.vhost_vdpa;
> > > @@ -656,7 +766,13 @@ int net_init_vhost_vdpa(const Netdev *netdev, co=
nst char *name,
> > >          goto err;
> > >      }
> > >
> > > -    if (opts->x_svq) {
> > > +    svq_cvq =3D opts->x_svq;
> > > +    if (has_cvq && !opts->x_svq) {
> > > +        num_as =3D vhost_vdpa_get_as_num(vdpa_device_fd);
> > > +        svq_cvq =3D num_as > 1;
> > > +    }
> > > +
> > > +    if (opts->x_svq || svq_cvq) {
> > >          struct vhost_vdpa_iova_range iova_range;
> > >
> > >          uint64_t invalid_dev_features =3D
> > > @@ -679,15 +795,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, c=
onst char *name,
> > >
> > >      for (i =3D 0; i < queue_pairs; i++) {
> > >          ncs[i] =3D net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
> > > -                                     vdpa_device_fd, i, 2, true, opt=
s->x_svq,
> > > -                                     iova_tree);
> > > +                                     vdpa_device_fd, i, 2, num_as, t=
rue,
> > > +                                     opts->x_svq, iova_tree);
> > >          if (!ncs[i])
> > >              goto err;
> > >      }
> > >
> > >      if (has_cvq) {
> > >          nc =3D net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
> > > -                                 vdpa_device_fd, i, 1, false,
> > > +                                 vdpa_device_fd, i, 1, num_as, false=
,
> > >                                   opts->x_svq, iova_tree);
> > >          if (!nc)
> > >              goto err;
> > > --
> > > 2.31.1
> > >
> >
>

