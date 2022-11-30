Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B60D63CF4F
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 07:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbiK3Gmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 01:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiK3Gml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 01:42:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA17C24BFB
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 22:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669790506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IHsnUPgsAXHYQy/PElwkoAe59Hk4r6bXlAIKPglqcY0=;
        b=LNKciMKSpFtfssdW5vypjXu8S9tcZkcYC0y/yEaGu/Fiz+DcktWHsHIcmvBASvje1BRj/Z
        0455jKzTYarJRxnmNS4fkhKRCBTIlrLfIKXaGx32JT34YZs/2eo8ozL3HOmX/dZ9arwj/n
        gjOxWEOsC7JnH+VK8EQ9KOaEHHuKt3Q=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-671-0ru4rBjzNp2EQDFjy7T9EA-1; Wed, 30 Nov 2022 01:41:45 -0500
X-MC-Unique: 0ru4rBjzNp2EQDFjy7T9EA-1
Received: by mail-ot1-f72.google.com with SMTP id v17-20020a9d7d11000000b0066c33c3e0easo6687111otn.11
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 22:41:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IHsnUPgsAXHYQy/PElwkoAe59Hk4r6bXlAIKPglqcY0=;
        b=oa3bv8C/nFqcCMpcjlEJRDpn5sV6KoCVqWy4kMsRlEwwDi8kCt/aU1hUc8idwegHVk
         0UoQ6Zgs95RL4xqiK6TLJfQ7Gu6+LW068ohQQxdHDJbZs96owDteDwg39p7SWfO9uFdF
         Zzd/5hhNbR2jPQIB1ai29bn+iefOkorE9/qBQ4xl0Ij8XWoeiosqtkjsScRNh1rKY9Dc
         wxZ3odWREr9XKVCWgPXRY6IVHHCXhsSf811rB65+Y0oCg9JKJA9YtPU/DyXy6RN3/UY2
         OYtgmNkl5OG6vgWpmZyZfHGSyV0c8CnAaaq91PS02yB41ZlLdR3Z1uuvks1b6qrWmd7p
         7DKw==
X-Gm-Message-State: ANoB5plzrdasDjmL6rhczmxFjTgw0KfMjt7oI3NOZo1UI9X3xUSqDpYA
        qUYLHmsj0KP4UOlhY7OVWM3L4b+l1w1M7+eUlOBFnBdc2m7A3vsk5/uveTVxfnHJzaqbcRJRSIn
        J03mhr9B2ZYvS0Xozc1tZWNOwMAuy
X-Received: by 2002:aca:2103:0:b0:35b:9abf:5031 with SMTP id 3-20020aca2103000000b0035b9abf5031mr10600882oiz.280.1669790503017;
        Tue, 29 Nov 2022 22:41:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5d4xDQb4e1F645YO2KQm0Mp+bvrkNm64BpAmQo7DMgdle3BEU29Odfyc3Bq60SM2d3syTn91xlnjtj6X1LD3w=
X-Received: by 2002:aca:2103:0:b0:35b:9abf:5031 with SMTP id
 3-20020aca2103000000b0035b9abf5031mr10600864oiz.280.1669790502807; Tue, 29
 Nov 2022 22:41:42 -0800 (PST)
MIME-Version: 1.0
References: <20221124155158.2109884-1-eperezma@redhat.com> <20221124155158.2109884-5-eperezma@redhat.com>
In-Reply-To: <20221124155158.2109884-5-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 30 Nov 2022 14:41:31 +0800
Message-ID: <CACGkMEub1-n_54-10PcyZejPgGrZFhnGe-k1fQ-g0X663UH7vQ@mail.gmail.com>
Subject: Re: [PATCH for 8.0 v8 04/12] vhost: move iova_tree set to vhost_svq_start
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>, Cindy Lu <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>
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

On Thu, Nov 24, 2022 at 11:52 PM Eugenio P=C3=A9rez <eperezma@redhat.com> w=
rote:
>
> Since we don't know if we will use SVQ at qemu initialization, let's
> allocate iova_tree only if needed. To do so, accept it at SVQ start, not
> at initialization.
>
> This will avoid to create it if the device does not support SVQ.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  hw/virtio/vhost-shadow-virtqueue.h | 5 ++---
>  hw/virtio/vhost-shadow-virtqueue.c | 9 ++++-----
>  hw/virtio/vhost-vdpa.c             | 5 ++---
>  3 files changed, 8 insertions(+), 11 deletions(-)
>
> diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-=
virtqueue.h
> index d04c34a589..926a4897b1 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.h
> +++ b/hw/virtio/vhost-shadow-virtqueue.h
> @@ -126,11 +126,10 @@ size_t vhost_svq_driver_area_size(const VhostShadow=
Virtqueue *svq);
>  size_t vhost_svq_device_area_size(const VhostShadowVirtqueue *svq);
>
>  void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
> -                     VirtQueue *vq);
> +                     VirtQueue *vq, VhostIOVATree *iova_tree);
>  void vhost_svq_stop(VhostShadowVirtqueue *svq);
>
> -VhostShadowVirtqueue *vhost_svq_new(VhostIOVATree *iova_tree,
> -                                    const VhostShadowVirtqueueOps *ops,
> +VhostShadowVirtqueue *vhost_svq_new(const VhostShadowVirtqueueOps *ops,
>                                      void *ops_opaque);
>
>  void vhost_svq_free(gpointer vq);
> diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-=
virtqueue.c
> index 3b05bab44d..4307296358 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.c
> +++ b/hw/virtio/vhost-shadow-virtqueue.c
> @@ -642,9 +642,10 @@ void vhost_svq_set_svq_kick_fd(VhostShadowVirtqueue =
*svq, int svq_kick_fd)
>   * @svq: Shadow Virtqueue
>   * @vdev: VirtIO device
>   * @vq: Virtqueue to shadow
> + * @iova_tree: Tree to perform descriptors translations
>   */
>  void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
> -                     VirtQueue *vq)
> +                     VirtQueue *vq, VhostIOVATree *iova_tree)
>  {
>      size_t desc_size, driver_size, device_size;
>
> @@ -655,6 +656,7 @@ void vhost_svq_start(VhostShadowVirtqueue *svq, VirtI=
ODevice *vdev,
>      svq->last_used_idx =3D 0;
>      svq->vdev =3D vdev;
>      svq->vq =3D vq;
> +    svq->iova_tree =3D iova_tree;
>
>      svq->vring.num =3D virtio_queue_get_num(vdev, virtio_get_queue_index=
(vq));
>      driver_size =3D vhost_svq_driver_area_size(svq);
> @@ -712,18 +714,15 @@ void vhost_svq_stop(VhostShadowVirtqueue *svq)
>   * Creates vhost shadow virtqueue, and instructs the vhost device to use=
 the
>   * shadow methods and file descriptors.
>   *
> - * @iova_tree: Tree to perform descriptors translations
>   * @ops: SVQ owner callbacks
>   * @ops_opaque: ops opaque pointer
>   */
> -VhostShadowVirtqueue *vhost_svq_new(VhostIOVATree *iova_tree,
> -                                    const VhostShadowVirtqueueOps *ops,
> +VhostShadowVirtqueue *vhost_svq_new(const VhostShadowVirtqueueOps *ops,
>                                      void *ops_opaque)
>  {
>      VhostShadowVirtqueue *svq =3D g_new0(VhostShadowVirtqueue, 1);
>
>      event_notifier_init_fd(&svq->svq_kick, VHOST_FILE_UNBIND);
> -    svq->iova_tree =3D iova_tree;
>      svq->ops =3D ops;
>      svq->ops_opaque =3D ops_opaque;
>      return svq;
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 3df2775760..691bcc811a 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -430,8 +430,7 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hdev=
, struct vhost_vdpa *v,
>      for (unsigned n =3D 0; n < hdev->nvqs; ++n) {
>          VhostShadowVirtqueue *svq;
>
> -        svq =3D vhost_svq_new(v->iova_tree, v->shadow_vq_ops,
> -                            v->shadow_vq_ops_opaque);
> +        svq =3D vhost_svq_new(v->shadow_vq_ops, v->shadow_vq_ops_opaque)=
;
>          g_ptr_array_add(shadow_vqs, svq);
>      }
>
> @@ -1063,7 +1062,7 @@ static bool vhost_vdpa_svqs_start(struct vhost_dev =
*dev)
>              goto err;
>          }
>
> -        vhost_svq_start(svq, dev->vdev, vq);
> +        vhost_svq_start(svq, dev->vdev, vq, v->iova_tree);
>          ok =3D vhost_vdpa_svq_map_rings(dev, svq, &addr, &err);
>          if (unlikely(!ok)) {
>              goto err_map;
> --
> 2.31.1
>

