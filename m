Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA48764E7D3
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 08:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiLPHgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 02:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiLPHgo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 02:36:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAF52F008
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 23:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671176155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xjf7Uw2lvRn/Y4N/EbhXgyq4369fmFcLv50akapfEMo=;
        b=Ug6+dH/vNsToWt9gDLTshYE7WgVHb2S2xRL+eGg0dfypjxEoLgVHWqQc1hhXqC3ZW/Kj6m
        /9LoKG3c0FEcDUPDTldw1AtIDb/K23XB6iEVwjaABIfdub0UDyZTZhjNndlG2LkRrV8Ltd
        GgxlItM+u5rdMMzWZzxgl6z/gOjGR3w=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-549-g6VjWDA5NmyYiPyN2-e35g-1; Fri, 16 Dec 2022 02:35:54 -0500
X-MC-Unique: g6VjWDA5NmyYiPyN2-e35g-1
Received: by mail-oo1-f71.google.com with SMTP id f11-20020a4a920b000000b004a09a9f7095so836875ooh.10
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 23:35:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xjf7Uw2lvRn/Y4N/EbhXgyq4369fmFcLv50akapfEMo=;
        b=WDoVEXgQ+huV8z8yz//Z22ECdLGMTDbixb0vRIjXDLsrZzfARMyKT8izX37l6nGJEx
         T73+QFHgYYbRqs5SDqc05uZOUmLAuTJHsgw2yqoWSxRDLpm1pWEa/FjlaGY9aTDzZYC3
         PJwXk8Zpwu2JdsdAb1FeVvyq29z7rSca9m2ErekY/c5NEy7XdfyUjVEz1Ald0ccA9GKw
         eT3E7a1Aau5bGA8rY0ec89h6znQ7ccVBCdTAG7mYZ5G1M7wfcbVTzFAsI92PHQ8Atjl/
         KNDxhg9QnkbneIwUh9wJWOgwE0Kb5nUXknVkUGbpJ3Y265OaNCt/90XuD5OQ/NXrYOkM
         clLQ==
X-Gm-Message-State: ANoB5pnJCcUj5mTni/+lH7uB70FGn5qMiw1967WH5yBtE47usYfx+Xub
        jZhf8EPNJhCRbiOP5/Uv1tEi1CjQgHBgeJaWIyQDXJ3wFH4t9vQ8itNQdE3zekg2q3tApx1aip+
        mpy1tMbmRzTzJPhw6/kEvNvCYBxrj
X-Received: by 2002:a05:6808:114c:b0:35e:7a42:7ab5 with SMTP id u12-20020a056808114c00b0035e7a427ab5mr515104oiu.280.1671176153575;
        Thu, 15 Dec 2022 23:35:53 -0800 (PST)
X-Google-Smtp-Source: AA0mqf69qICvyQuu7IvaCwoLsD676kBKVhLY8/0qmG45U9xXvA/Fp61q/5TrlWXWeo6Dww8IYDzxXLHPI8I1HjWLkzs=
X-Received: by 2002:a05:6808:114c:b0:35e:7a42:7ab5 with SMTP id
 u12-20020a056808114c00b0035e7a427ab5mr515101oiu.280.1671176153334; Thu, 15
 Dec 2022 23:35:53 -0800 (PST)
MIME-Version: 1.0
References: <20221215113144.322011-1-eperezma@redhat.com> <20221215113144.322011-13-eperezma@redhat.com>
In-Reply-To: <20221215113144.322011-13-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 16 Dec 2022 15:35:42 +0800
Message-ID: <CACGkMEsjbkMvB9=9JbHq1gPbm5OZdBuGoGt7tRm2vAXH8yr79A@mail.gmail.com>
Subject: Re: [PATCH v9 12/12] vdpa: always start CVQ in SVQ mode if possible
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Parav Pandit <parav@mellanox.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
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

On Thu, Dec 15, 2022 at 7:32 PM Eugenio P=C3=A9rez <eperezma@redhat.com> wr=
ote:
>
> Isolate control virtqueue in its own group, allowing to intercept control
> commands but letting dataplane run totally passthrough to the guest.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
> v9:
> * Reuse iova_range fetched from the device at initialization, instead of
>   fetch it again at vhost_vdpa_net_cvq_start.
> * Add comment about how migration is blocked in case ASID does not met
>   our expectations.
> * Delete warning about CVQ group not being independent.
>
> v8:
> * Do not allocate iova_tree on net_init_vhost_vdpa if only CVQ is
>   shadowed. Move the iova_tree handling in this case to
>   vhost_vdpa_net_cvq_start and vhost_vdpa_net_cvq_stop.
>
> v7:
> * Never ask for number of address spaces, just react if isolation is not
>   possible.
> * Return ASID ioctl errors instead of masking them as if the device has
>   no asid.
> * Simplify net_init_vhost_vdpa logic
> * Add "if possible" suffix
>
> v6:
> * Disable control SVQ if the device does not support it because of
> features.
>
> v5:
> * Fixing the not adding cvq buffers when x-svq=3Don is specified.
> * Move vring state in vhost_vdpa_get_vring_group instead of using a
>   parameter.
> * Rename VHOST_VDPA_NET_CVQ_PASSTHROUGH to VHOST_VDPA_NET_DATA_ASID
>
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
>  net/vhost-vdpa.c       | 110 ++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 111 insertions(+), 2 deletions(-)
>
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 48d8c60e76..8cd00f5a96 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -638,7 +638,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_de=
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
> index 710c5efe96..d36664f33a 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -102,6 +102,8 @@ static const uint64_t vdpa_svq_device_features =3D
>      BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
>      BIT_ULL(VIRTIO_NET_F_STANDBY);
>
> +#define VHOST_VDPA_NET_CVQ_ASID 1
> +
>  VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
>  {
>      VhostVDPAState *s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> @@ -243,6 +245,40 @@ static NetClientInfo net_vhost_vdpa_info =3D {
>          .check_peer_type =3D vhost_vdpa_check_peer_type,
>  };
>
> +static int64_t vhost_vdpa_get_vring_group(int device_fd, unsigned vq_ind=
ex)
> +{
> +    struct vhost_vring_state state =3D {
> +        .index =3D vq_index,
> +    };
> +    int r =3D ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, &state);
> +
> +    if (unlikely(r < 0)) {
> +        error_report("Cannot get VQ %u group: %s", vq_index,
> +                     g_strerror(errno));
> +        return r;
> +    }
> +
> +    return state.num;
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
> +    int r;
> +
> +    r =3D ioctl(v->device_fd, VHOST_VDPA_SET_GROUP_ASID, &asid);
> +    if (unlikely(r < 0)) {
> +        error_report("Can't set vq group %u asid %u, errno=3D%d (%s)",
> +                     asid.index, asid.num, errno, g_strerror(errno));
> +    }
> +    return r;
> +}
> +
>  static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
>  {
>      VhostIOVATree *tree =3D v->iova_tree;
> @@ -317,11 +353,75 @@ dma_map_err:
>  static int vhost_vdpa_net_cvq_start(NetClientState *nc)
>  {
>      VhostVDPAState *s;
> -    int r;
> +    struct vhost_vdpa *v;
> +    uint64_t backend_features;
> +    int64_t cvq_group;
> +    int cvq_index, r;
>
>      assert(nc->info->type =3D=3D NET_CLIENT_DRIVER_VHOST_VDPA);
>
>      s =3D DO_UPCAST(VhostVDPAState, nc, nc);
> +    v =3D &s->vhost_vdpa;
> +
> +    v->shadow_data =3D s->always_svq;
> +    v->shadow_vqs_enabled =3D s->always_svq;
> +    s->vhost_vdpa.address_space_id =3D VHOST_VDPA_GUEST_PA_ASID;
> +
> +    if (s->always_svq) {
> +        /* SVQ is already configured for all virtqueues */
> +        goto out;
> +    }
> +
> +    /*
> +     * If we early return in these cases SVQ will not be enabled. The mi=
gration
> +     * will be blocked as long as vhost-vdpa backends will not offer _F_=
LOG.
> +     *
> +     * Calling VHOST_GET_BACKEND_FEATURES as they are not available in v=
->dev
> +     * yet.
> +     */
> +    r =3D ioctl(v->device_fd, VHOST_GET_BACKEND_FEATURES, &backend_featu=
res);
> +    if (unlikely(r < 0)) {
> +        error_report("Cannot get vdpa backend_features: %s(%d)",
> +            g_strerror(errno), errno);
> +        return -1;
> +    }
> +    if (!(backend_features & VHOST_BACKEND_F_IOTLB_ASID) ||
> +        !vhost_vdpa_net_valid_svq_features(v->dev->features, NULL)) {
> +        return 0;
> +    }
> +
> +    /*
> +     * Check if all the virtqueues of the virtio device are in a differe=
nt vq
> +     * than the last vq. VQ group of last group passed in cvq_group.
> +     */
> +    cvq_index =3D v->dev->vq_index_end - 1;
> +    cvq_group =3D vhost_vdpa_get_vring_group(v->device_fd, cvq_index);
> +    if (unlikely(cvq_group < 0)) {
> +        return cvq_group;
> +    }
> +    for (int i =3D 0; i < cvq_index; ++i) {
> +        int64_t group =3D vhost_vdpa_get_vring_group(v->device_fd, i);
> +
> +        if (unlikely(group < 0)) {
> +            return group;
> +        }
> +
> +        if (group =3D=3D cvq_group) {
> +            return 0;
> +        }
> +    }
> +
> +    r =3D vhost_vdpa_set_address_space_id(v, cvq_group, VHOST_VDPA_NET_C=
VQ_ASID);
> +    if (unlikely(r < 0)) {
> +        return r;
> +    }
> +
> +    v->iova_tree =3D vhost_iova_tree_new(v->iova_range.first,
> +                                       v->iova_range.last);
> +    v->shadow_vqs_enabled =3D true;
> +    s->vhost_vdpa.address_space_id =3D VHOST_VDPA_NET_CVQ_ASID;
> +
> +out:
>      if (!s->vhost_vdpa.shadow_vqs_enabled) {
>          return 0;
>      }
> @@ -350,6 +450,14 @@ static void vhost_vdpa_net_cvq_stop(NetClientState *=
nc)
>      if (s->vhost_vdpa.shadow_vqs_enabled) {
>          vhost_vdpa_cvq_unmap_buf(&s->vhost_vdpa, s->cvq_cmd_out_buffer);
>          vhost_vdpa_cvq_unmap_buf(&s->vhost_vdpa, s->status);
> +        if (!s->always_svq) {
> +            /*
> +             * If only the CVQ is shadowed we can delete this safely.
> +             * If all the VQs are shadows this will be needed by the tim=
e the
> +             * device is started again to register SVQ vrings and simila=
r.
> +             */
> +            g_clear_pointer(&s->vhost_vdpa.iova_tree, vhost_iova_tree_de=
lete);
> +        }
>      }
>  }
>
> --
> 2.31.1
>

