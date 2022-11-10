Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A672623B3F
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 06:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiKJF3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 00:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiKJF3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 00:29:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A0455BF
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 21:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668058119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FZ9yNZRWrzRVhGuUcnX8i46nuRNhbHXIg73hJkv2J6c=;
        b=hdVx6xiIgl5fUZuWGyyUk0L5pVavpMdwx4jGzNDcqZcu3JGZibJymuaVKkgnfxV3wEB8WQ
        p+/i+ntHxmpOLIIBDvZJJ14iqv/mdeGO9oeQ01q0LmThZDxZ7CVFphcjjSiznfduWSaJoQ
        emLnzl9fC5GuiUg1ojBO8O3BwxmExNk=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-515-Z_wQxi4oOcOIXSAP9U09aA-1; Thu, 10 Nov 2022 00:28:38 -0500
X-MC-Unique: Z_wQxi4oOcOIXSAP9U09aA-1
Received: by mail-oi1-f199.google.com with SMTP id v129-20020acaac87000000b0035a4772703cso282875oie.14
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 21:28:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FZ9yNZRWrzRVhGuUcnX8i46nuRNhbHXIg73hJkv2J6c=;
        b=UQn/IUhXVseQiRgVNbDGLP9ib91LYHx/ZwGRV9VAUplMNUwbIWKNJ6E9Aiz4Ac2WHZ
         MiLeD+Q7I+1JMAki5dxGTUPwswOrdg4qDhFvar66efTSZD/8vMTqf1SjX/B/tXK7ProT
         oqhGBi6E8pEqT8RMoL3k8uaCqqLChfUqMStzsFJJFjUfWQIV2jJRQgU3QCAWQldkA8J1
         Kkyx2hPRmswZBYiuawWmMgEfxEt+ehStB4XttXgDdh7aZmEZ+iMeRWqarvPjXvRHaiwi
         OQZJHt+EucvJdueWp6BG9taAL5l4YT3mdRhf4RGusm4QukEKcIc6/OJZY6npX6vPjHgN
         vePA==
X-Gm-Message-State: ACrzQf15WOKytuljabKBj9ZGvhnLkYQzJZVVG+zCyPKnuI66fN6gxSub
        RCzoKZ165lptmaoE2MW5wM8Jlakkc6cb+/+/FDiBLhazRiqOnFFpqo9mQSHc00gSuiNiVqDPgp8
        fGHmUw0C+SmTosFn1qhTmmfrrKyOh
X-Received: by 2002:a05:6871:54e:b0:13b:29b7:e2e8 with SMTP id t14-20020a056871054e00b0013b29b7e2e8mr45848516oal.35.1668058117442;
        Wed, 09 Nov 2022 21:28:37 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5B16fN8VF8lBDbDb2ll+gYuLLDYt1XE0XjaaKO1pEu2jEE1ZLsIgbSLNm2JA0dpBB7rBsdmF3wknx0vsGViYM=
X-Received: by 2002:a05:6871:54e:b0:13b:29b7:e2e8 with SMTP id
 t14-20020a056871054e00b0013b29b7e2e8mr45848507oal.35.1668058117216; Wed, 09
 Nov 2022 21:28:37 -0800 (PST)
MIME-Version: 1.0
References: <20221108170755.92768-1-eperezma@redhat.com> <20221108170755.92768-4-eperezma@redhat.com>
In-Reply-To: <20221108170755.92768-4-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 10 Nov 2022 13:28:24 +0800
Message-ID: <CACGkMEvPeJhjB=CV5-XagUw7urpjRgLa+F9KB2qpd3s_kjEZ8g@mail.gmail.com>
Subject: Re: [PATCH v6 03/10] vhost: Allocate SVQ device file descriptors at
 device start
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
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

On Wed, Nov 9, 2022 at 1:08 AM Eugenio P=C3=A9rez <eperezma@redhat.com> wro=
te:
>
> The next patches will start control SVQ if possible. However, we don't
> know if that will be possible at qemu boot anymore.
>
> Delay device file descriptors until we know it at device start.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  hw/virtio/vhost-shadow-virtqueue.c | 31 ++------------------------
>  hw/virtio/vhost-vdpa.c             | 35 ++++++++++++++++++++++++------
>  2 files changed, 30 insertions(+), 36 deletions(-)
>
> diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-=
virtqueue.c
> index 264ddc166d..3b05bab44d 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.c
> +++ b/hw/virtio/vhost-shadow-virtqueue.c
> @@ -715,43 +715,18 @@ void vhost_svq_stop(VhostShadowVirtqueue *svq)
>   * @iova_tree: Tree to perform descriptors translations
>   * @ops: SVQ owner callbacks
>   * @ops_opaque: ops opaque pointer
> - *
> - * Returns the new virtqueue or NULL.
> - *
> - * In case of error, reason is reported through error_report.
>   */
>  VhostShadowVirtqueue *vhost_svq_new(VhostIOVATree *iova_tree,
>                                      const VhostShadowVirtqueueOps *ops,
>                                      void *ops_opaque)
>  {
> -    g_autofree VhostShadowVirtqueue *svq =3D g_new0(VhostShadowVirtqueue=
, 1);
> -    int r;
> -
> -    r =3D event_notifier_init(&svq->hdev_kick, 0);
> -    if (r !=3D 0) {
> -        error_report("Couldn't create kick event notifier: %s (%d)",
> -                     g_strerror(errno), errno);
> -        goto err_init_hdev_kick;
> -    }
> -
> -    r =3D event_notifier_init(&svq->hdev_call, 0);
> -    if (r !=3D 0) {
> -        error_report("Couldn't create call event notifier: %s (%d)",
> -                     g_strerror(errno), errno);
> -        goto err_init_hdev_call;
> -    }
> +    VhostShadowVirtqueue *svq =3D g_new0(VhostShadowVirtqueue, 1);
>
>      event_notifier_init_fd(&svq->svq_kick, VHOST_FILE_UNBIND);
>      svq->iova_tree =3D iova_tree;
>      svq->ops =3D ops;
>      svq->ops_opaque =3D ops_opaque;
> -    return g_steal_pointer(&svq);
> -
> -err_init_hdev_call:
> -    event_notifier_cleanup(&svq->hdev_kick);
> -
> -err_init_hdev_kick:
> -    return NULL;
> +    return svq;
>  }
>
>  /**
> @@ -763,7 +738,5 @@ void vhost_svq_free(gpointer pvq)
>  {
>      VhostShadowVirtqueue *vq =3D pvq;
>      vhost_svq_stop(vq);
> -    event_notifier_cleanup(&vq->hdev_kick);
> -    event_notifier_cleanup(&vq->hdev_call);
>      g_free(vq);
>  }
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 7f0ff4df5b..3df2775760 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -428,15 +428,11 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hd=
ev, struct vhost_vdpa *v,
>
>      shadow_vqs =3D g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
>      for (unsigned n =3D 0; n < hdev->nvqs; ++n) {
> -        g_autoptr(VhostShadowVirtqueue) svq;
> +        VhostShadowVirtqueue *svq;
>
>          svq =3D vhost_svq_new(v->iova_tree, v->shadow_vq_ops,
>                              v->shadow_vq_ops_opaque);
> -        if (unlikely(!svq)) {
> -            error_setg(errp, "Cannot create svq %u", n);
> -            return -1;
> -        }
> -        g_ptr_array_add(shadow_vqs, g_steal_pointer(&svq));
> +        g_ptr_array_add(shadow_vqs, svq);
>      }
>
>      v->shadow_vqs =3D g_steal_pointer(&shadow_vqs);
> @@ -864,11 +860,23 @@ static int vhost_vdpa_svq_set_fds(struct vhost_dev =
*dev,
>      const EventNotifier *event_notifier =3D &svq->hdev_kick;
>      int r;
>
> +    r =3D event_notifier_init(&svq->hdev_kick, 0);
> +    if (r !=3D 0) {
> +        error_setg_errno(errp, -r, "Couldn't create kick event notifier"=
);
> +        goto err_init_hdev_kick;
> +    }
> +
> +    r =3D event_notifier_init(&svq->hdev_call, 0);
> +    if (r !=3D 0) {
> +        error_setg_errno(errp, -r, "Couldn't create call event notifier"=
);
> +        goto err_init_hdev_call;
> +    }
> +
>      file.fd =3D event_notifier_get_fd(event_notifier);
>      r =3D vhost_vdpa_set_vring_dev_kick(dev, &file);
>      if (unlikely(r !=3D 0)) {
>          error_setg_errno(errp, -r, "Can't set device kick fd");
> -        return r;
> +        goto err_init_set_dev_fd;
>      }
>
>      event_notifier =3D &svq->hdev_call;
> @@ -876,8 +884,18 @@ static int vhost_vdpa_svq_set_fds(struct vhost_dev *=
dev,
>      r =3D vhost_vdpa_set_vring_dev_call(dev, &file);
>      if (unlikely(r !=3D 0)) {
>          error_setg_errno(errp, -r, "Can't set device call fd");
> +        goto err_init_set_dev_fd;
>      }
>
> +    return 0;
> +
> +err_init_set_dev_fd:
> +    event_notifier_set_handler(&svq->hdev_call, NULL);
> +
> +err_init_hdev_call:
> +    event_notifier_cleanup(&svq->hdev_kick);
> +
> +err_init_hdev_kick:
>      return r;
>  }
>
> @@ -1089,6 +1107,9 @@ static void vhost_vdpa_svqs_stop(struct vhost_dev *=
dev)
>      for (unsigned i =3D 0; i < v->shadow_vqs->len; ++i) {
>          VhostShadowVirtqueue *svq =3D g_ptr_array_index(v->shadow_vqs, i=
);
>          vhost_vdpa_svq_unmap_rings(dev, svq);
> +
> +        event_notifier_cleanup(&svq->hdev_kick);
> +        event_notifier_cleanup(&svq->hdev_call);
>      }
>  }
>
> --
> 2.31.1
>

