Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E3458D4AF
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 09:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbiHIHf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 03:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239422AbiHIHf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 03:35:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA39921257
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 00:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660030495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1crRyPcZxQ0tLK84/4TAp/fqO/wLTwAcffndcqaI7Nk=;
        b=CzBikPcDh2vOyWgDJiPdVlIxkp6XIApw4nR7uZSYmzcyqCWaN8UWjI5mj23bZpmGfuO8Ae
        l3WLV5x5hQb8RfhHJs9vt9s1SolLRpn4907Fs7VGIYmiTsZnKMOHZWXdz+bpfDXjYXbX/I
        NCZ/YFsDebH4xP4uyeTMcFpQDrY/4qI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-lopMW1poND6_ZKLZTu6OjA-1; Tue, 09 Aug 2022 03:34:12 -0400
X-MC-Unique: lopMW1poND6_ZKLZTu6OjA-1
Received: by mail-lf1-f69.google.com with SMTP id e19-20020a05651236d300b0048d16bfadecso91790lfs.21
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 00:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1crRyPcZxQ0tLK84/4TAp/fqO/wLTwAcffndcqaI7Nk=;
        b=Ge52TGkA6uLNYJkrlvBxPw60s6hVSCm52avtqIwoXSAb8FP2+S2auGdlWk3hfHOFe4
         FXTe8BDM9hLOJRAbBCGMtRXvaph54wIj2Zy7b5NMagoUu2BS9hTcsf4aH70r3PN4KB0g
         CJb/2j0wa9NRa6VB529xDWydo+3yJBv91vwOULefVU8E0i2oyQvpw162BmI01ZM+oEFZ
         2/hXlYRGdexHybBar5HNlcXR47SZOOyk3lpcCKV1agcpdc79dnWTmhu0qpTRpVwvfAMa
         +ExyHr+3f+VH84kEQp69p4NVAJPDAJgmBVeub/+9KCtBgZIrmgwH+lxOsAuPQGw46ZLR
         xtRA==
X-Gm-Message-State: ACgBeo0US9FDq+AU4ZJT/X4iy0gqklhpdBe+BpdZ8DIRpLcOJrGEVfSI
        t6nCMzKiNvW8YQZDwwEL8dj1SdeAnIikBUjBGszWthSfkHX5TyOdj4T1/NOlxSGVRkDJikpvmiW
        WZ+bjq0t8w0+l5zHd1lCCrfCLf0jS
X-Received: by 2002:a2e:b983:0:b0:25f:d718:40e8 with SMTP id p3-20020a2eb983000000b0025fd71840e8mr3479147ljp.323.1660030451188;
        Tue, 09 Aug 2022 00:34:11 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7s0xpRwoliYYcvGl5opAb0QoMIanRpc991kxHphau8Nj1O6sz3Ib3zN9lIqUpt86IfWevT+GkUwwyXA0lsMGY=
X-Received: by 2002:a2e:b983:0:b0:25f:d718:40e8 with SMTP id
 p3-20020a2eb983000000b0025fd71840e8mr3479136ljp.323.1660030450900; Tue, 09
 Aug 2022 00:34:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220805163909.872646-1-eperezma@redhat.com> <20220805163909.872646-7-eperezma@redhat.com>
In-Reply-To: <20220805163909.872646-7-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 9 Aug 2022 15:33:59 +0800
Message-ID: <CACGkMEtOr7JOsOTHiwcrk8FoRWhwHTzBWX30iaKCuHz26UOzNQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] vdpa: Always start CVQ in SVQ mode
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
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
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 6, 2022 at 12:39 AM Eugenio P=C3=A9rez <eperezma@redhat.com> wr=
ote:
>
> Isolate control virtqueue in its own group, allowing to intercept control
> commands but letting dataplane run totally passthrough to the guest.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
> v4:
> * Squash vhost_vdpa_cvq_group_is_independent.
> * Rebased on last CVQ start series, that allocated CVQ cmd bufs at load
> * Do not check for cvq index on vhost_vdpa_net_prepare, we only have one
>   that callback registered in that NetClientInfo.
>
> v3:
> * Make asid related queries print a warning instead of returning an
>   error and stop the start of qemu.
> ---
>  hw/virtio/vhost-vdpa.c |   3 +-
>  net/vhost-vdpa.c       | 124 +++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 122 insertions(+), 5 deletions(-)
>
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 3eb67b27b7..69f34f4cc5 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -678,7 +678,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_de=
v *dev)
>  {
>      uint64_t features;
>      uint64_t f =3D 0x1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2 |
> -        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH;
> +        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH |
> +        0x1ULL << VHOST_BACKEND_F_IOTLB_ASID;
>      int r;
>
>      if (vhost_vdpa_call(dev, VHOST_GET_BACKEND_FEATURES, &features)) {
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index bf78b1332f..c820a5fd9f 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -37,6 +37,9 @@ typedef struct VhostVDPAState {
>      /* Control commands shadow buffers */
>      void *cvq_cmd_out_buffer, *cvq_cmd_in_buffer;
>
> +    /* Number of address spaces supported by the device */
> +    unsigned address_space_num;
> +
>      /* The device always have SVQ enabled */
>      bool always_svq;
>      bool started;
> @@ -100,6 +103,9 @@ static const uint64_t vdpa_svq_device_features =3D
>      BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
>      BIT_ULL(VIRTIO_NET_F_STANDBY);
>
> +#define VHOST_VDPA_NET_CVQ_PASSTHROUGH 0

We need a better name for the macro since it's not easy to see it's an asid=
.

> +#define VHOST_VDPA_NET_CVQ_ASID 1
> +
>  VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
>  {
>      VhostVDPAState *s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> @@ -224,6 +230,37 @@ static NetClientInfo net_vhost_vdpa_info =3D {
>          .check_peer_type =3D vhost_vdpa_check_peer_type,
>  };
>
> +static void vhost_vdpa_get_vring_group(int device_fd,
> +                                       struct vhost_vring_state *state)
> +{
> +    int r =3D ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, state);

Let's hide vhost_vring_state from the caller and simply accept a vq
index parameter (as the below function did) then we can return the
group id.

The hides low level ABI and simplify the caller's code.

> +    if (unlikely(r < 0)) {
> +        /*
> +         * Assume all groups are 0, the consequences are the same and we=
 will
> +         * not abort device creation
> +         */
> +        state->num =3D 0;
> +    }
> +}
> +
> +static int vhost_vdpa_set_address_space_id(struct vhost_vdpa *v,
> +                                           unsigned vq_group,
> +                                           unsigned asid_num)
> +{
> +    struct vhost_vring_state asid =3D {
> +        .index =3D vq_group,
> +        .num =3D asid_num,
> +    };
> +    int ret;
> +
> +    ret =3D ioctl(v->device_fd, VHOST_VDPA_SET_GROUP_ASID, &asid);
> +    if (unlikely(ret < 0)) {
> +        warn_report("Can't set vq group %u asid %u, errno=3D%d (%s)",
> +            asid.index, asid.num, errno, g_strerror(errno));
> +    }
> +    return ret;
> +}
> +
>  static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
>  {
>      VhostIOVATree *tree =3D v->iova_tree;
> @@ -298,11 +335,55 @@ dma_map_err:
>  static int vhost_vdpa_net_cvq_prepare(NetClientState *nc)
>  {
>      VhostVDPAState *s;
> +    struct vhost_vdpa *v;
> +    struct vhost_vring_state cvq_group =3D {};
>      int r;
>
>      assert(nc->info->type =3D=3D NET_CLIENT_DRIVER_VHOST_VDPA);
>
>      s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> +    v =3D &s->vhost_vdpa;
> +    cvq_group.index =3D v->dev->vq_index_end - 1;
> +
> +    /* Default values */

Code can explain itself so this comment is probably useless.

> +    v->shadow_vqs_enabled =3D false;
> +    s->vhost_vdpa.address_space_id =3D VHOST_VDPA_NET_CVQ_PASSTHROUGH;
> +
> +    if (s->always_svq) {
> +        v->shadow_vqs_enabled =3D true;

The name of the variable is suboptimal.

I think we need to differ:

1) shadow all virtqueues

from

2) shadow cvq only

Thanks

> +        goto out;
> +    }
> +
> +    if (s->address_space_num < 2) {
> +        return 0;
> +    }
> +
> +    /**
> +     * Check if all the virtqueues of the virtio device are in a differe=
nt vq
> +     * than the last vq. VQ group of last group passed in cvq_group.
> +     */
> +    vhost_vdpa_get_vring_group(v->device_fd, &cvq_group);
> +    for (int i =3D 0; i < (v->dev->vq_index_end - 1); ++i) {
> +        struct vhost_vring_state vq_group =3D {
> +            .index =3D i,
> +        };
> +
> +        vhost_vdpa_get_vring_group(v->device_fd, &vq_group);
> +        if (unlikely(vq_group.num =3D=3D cvq_group.num)) {
> +            warn_report("CVQ %u group is the same as VQ %u one (%u)",
> +                         cvq_group.index, vq_group.index, cvq_group.num)=
;
> +            return 0;
> +        }
> +    }
> +
> +    r =3D vhost_vdpa_set_address_space_id(v, cvq_group.num,
> +                                        VHOST_VDPA_NET_CVQ_ASID);
> +    if (r =3D=3D 0) {
> +        v->shadow_vqs_enabled =3D true;
> +        s->vhost_vdpa.address_space_id =3D VHOST_VDPA_NET_CVQ_ASID;
> +    }
> +
> +out:
>      if (!s->vhost_vdpa.shadow_vqs_enabled) {
>          return 0;
>      }
> @@ -523,12 +604,38 @@ static const VhostShadowVirtqueueOps vhost_vdpa_net=
_svq_ops =3D {
>      .avail_handler =3D vhost_vdpa_net_handle_ctrl_avail,
>  };
>
> +static uint32_t vhost_vdpa_get_as_num(int vdpa_device_fd)
> +{
> +    uint64_t features;
> +    unsigned num_as;
> +    int r;
> +
> +    r =3D ioctl(vdpa_device_fd, VHOST_GET_BACKEND_FEATURES, &features);
> +    if (unlikely(r < 0)) {
> +        warn_report("Cannot get backend features");
> +        return 1;
> +    }
> +
> +    if (!(features & BIT_ULL(VHOST_BACKEND_F_IOTLB_ASID))) {
> +        return 1;
> +    }
> +
> +    r =3D ioctl(vdpa_device_fd, VHOST_VDPA_GET_AS_NUM, &num_as);
> +    if (unlikely(r < 0)) {
> +        warn_report("Cannot retrieve number of supported ASs");
> +        return 1;
> +    }
> +
> +    return num_as;
> +}
> +
>  static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
>                                             const char *device,
>                                             const char *name,
>                                             int vdpa_device_fd,
>                                             int queue_pair_index,
>                                             int nvqs,
> +                                           unsigned nas,
>                                             bool is_datapath,
>                                             bool svq,
>                                             VhostIOVATree *iova_tree)
> @@ -547,6 +654,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientS=
tate *peer,
>      snprintf(nc->info_str, sizeof(nc->info_str), TYPE_VHOST_VDPA);
>      s =3D DO_UPCAST(VhostVDPAState, nc, nc);
>
> +    s->address_space_num =3D nas;
>      s->vhost_vdpa.device_fd =3D vdpa_device_fd;
>      s->vhost_vdpa.index =3D queue_pair_index;
>      s->always_svq =3D svq;
> @@ -632,6 +740,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, const c=
har *name,
>      g_autoptr(VhostIOVATree) iova_tree =3D NULL;
>      NetClientState *nc;
>      int queue_pairs, r, i =3D 0, has_cvq =3D 0;
> +    unsigned num_as =3D 1;
> +    bool svq_cvq;
>
>      assert(netdev->type =3D=3D NET_CLIENT_DRIVER_VHOST_VDPA);
>      opts =3D &netdev->u.vhost_vdpa;
> @@ -656,7 +766,13 @@ int net_init_vhost_vdpa(const Netdev *netdev, const =
char *name,
>          goto err;
>      }
>
> -    if (opts->x_svq) {
> +    svq_cvq =3D opts->x_svq;
> +    if (has_cvq && !opts->x_svq) {
> +        num_as =3D vhost_vdpa_get_as_num(vdpa_device_fd);
> +        svq_cvq =3D num_as > 1;
> +    }
> +
> +    if (opts->x_svq || svq_cvq) {
>          struct vhost_vdpa_iova_range iova_range;
>
>          uint64_t invalid_dev_features =3D
> @@ -679,15 +795,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, const=
 char *name,
>
>      for (i =3D 0; i < queue_pairs; i++) {
>          ncs[i] =3D net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
> -                                     vdpa_device_fd, i, 2, true, opts->x=
_svq,
> -                                     iova_tree);
> +                                     vdpa_device_fd, i, 2, num_as, true,
> +                                     opts->x_svq, iova_tree);
>          if (!ncs[i])
>              goto err;
>      }
>
>      if (has_cvq) {
>          nc =3D net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
> -                                 vdpa_device_fd, i, 1, false,
> +                                 vdpa_device_fd, i, 1, num_as, false,
>                                   opts->x_svq, iova_tree);
>          if (!nc)
>              goto err;
> --
> 2.31.1
>

