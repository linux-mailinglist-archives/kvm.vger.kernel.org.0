Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4673C623B36
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 06:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiKJFXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 00:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbiKJFXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 00:23:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15082175BB
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 21:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668057761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zBADNIHQ/2w9bsFk7qq7GQ+B6yI6upSrghyoXHyUfDo=;
        b=DTB/qz8uTuxna1xSOnm0Ymsh0yOGUA+GW2hghEo4z9yBpvURj76hINX7Dre79kPXzi0SOv
        NXAuxkzzlck6GyyyUZJwnVJ/AosmzsaCOVSDKExq44D8PfySAgUN30ucL9Oeq2UU3ULrZL
        mECFxgl7w2pC1+Mu+l6nYSg4EfG8+no=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-570-xQvSsoitOlmUBAfe5BfWVQ-1; Thu, 10 Nov 2022 00:22:38 -0500
X-MC-Unique: xQvSsoitOlmUBAfe5BfWVQ-1
Received: by mail-ot1-f71.google.com with SMTP id cj4-20020a056830640400b0065c0c211f4dso551438otb.8
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 21:22:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zBADNIHQ/2w9bsFk7qq7GQ+B6yI6upSrghyoXHyUfDo=;
        b=y8kAgAhuLOUtLcGlvPi4RWKwrLYvzg6fxxm0h1+JuJckwuHzBz+NqnqCe837NUCSR2
         VKdrPc3iug7coVQu789TRgizZqctZxYRaJGYGBclxxQaV9+EqXnJHjDM6XxvOV2qAfpO
         MfwlP8neRlLYyW1LRDPOCWIVgo6uzmPnzRoiY7kU3TYbRikN3aeFXoRs6u2n1OghVG43
         /Iwl0fkalfa4ztwwfqPEDLvpa8PbEaTDIqVrr4+QGEkFDJnDRl+kysdK2Q6Lug/atL9+
         MnlC8p7K+6f3XdawYO0gtKhVzmbbhPyRGwbuFYJHYlps+w7JsIJM9reN/rQ0RL3QBmtj
         ktng==
X-Gm-Message-State: ACrzQf210bAFDG3wkhShjnao1SReS1LLBx2GVRnXz+h1WtouUDFlMRLy
        imTmP93mnD0eGHbfIRwzCAu1EVKJdoSkhuGwbvqA8XwMAQE6IoF5kBKiF7gQGG61GPso6wx6TF6
        l89CF/SUZy7hTrRLm+kRr7b8N0h62
X-Received: by 2002:a05:6808:181e:b0:35a:5959:5909 with SMTP id bh30-20020a056808181e00b0035a59595909mr17148347oib.35.1668057757436;
        Wed, 09 Nov 2022 21:22:37 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4fFxYqbqgMLqtqpgis0P4gU8U/nEIqOFJsyP10xJ7MQKudn4hRCzjbgLwqGbIMqBeg/bACAqJ5q+/FHECoafY=
X-Received: by 2002:a05:6808:181e:b0:35a:5959:5909 with SMTP id
 bh30-20020a056808181e00b0035a59595909mr17148329oib.35.1668057757247; Wed, 09
 Nov 2022 21:22:37 -0800 (PST)
MIME-Version: 1.0
References: <20221108170755.92768-1-eperezma@redhat.com> <20221108170755.92768-3-eperezma@redhat.com>
In-Reply-To: <20221108170755.92768-3-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 10 Nov 2022 13:22:25 +0800
Message-ID: <CACGkMEt0EVQtRUVqFpfdAKPhqgEdmLWhCvLKDjF0gMMj=rh+9w@mail.gmail.com>
Subject: Re: [PATCH v6 02/10] vhost: set SVQ device call handler at SVQ start
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
> By the end of this series CVQ is shadowed as long as the features
> support it.
>
> Since we don't know at the beginning of qemu running if this is
> supported, move the event notifier handler setting to the start of the
> SVQ, instead of the start of qemu run.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  hw/virtio/vhost-shadow-virtqueue.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-=
virtqueue.c
> index 5bd14cad96..264ddc166d 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.c
> +++ b/hw/virtio/vhost-shadow-virtqueue.c
> @@ -648,6 +648,7 @@ void vhost_svq_start(VhostShadowVirtqueue *svq, VirtI=
ODevice *vdev,
>  {
>      size_t desc_size, driver_size, device_size;
>
> +    event_notifier_set_handler(&svq->hdev_call, vhost_svq_handle_call);
>      svq->next_guest_avail_elem =3D NULL;
>      svq->shadow_avail_idx =3D 0;
>      svq->shadow_used_idx =3D 0;
> @@ -704,6 +705,7 @@ void vhost_svq_stop(VhostShadowVirtqueue *svq)
>      g_free(svq->desc_state);
>      qemu_vfree(svq->vring.desc);
>      qemu_vfree(svq->vring.used);
> +    event_notifier_set_handler(&svq->hdev_call, NULL);
>  }
>
>  /**
> @@ -740,7 +742,6 @@ VhostShadowVirtqueue *vhost_svq_new(VhostIOVATree *io=
va_tree,
>      }
>
>      event_notifier_init_fd(&svq->svq_kick, VHOST_FILE_UNBIND);
> -    event_notifier_set_handler(&svq->hdev_call, vhost_svq_handle_call);
>      svq->iova_tree =3D iova_tree;
>      svq->ops =3D ops;
>      svq->ops_opaque =3D ops_opaque;
> @@ -763,7 +764,6 @@ void vhost_svq_free(gpointer pvq)
>      VhostShadowVirtqueue *vq =3D pvq;
>      vhost_svq_stop(vq);
>      event_notifier_cleanup(&vq->hdev_kick);
> -    event_notifier_set_handler(&vq->hdev_call, NULL);
>      event_notifier_cleanup(&vq->hdev_call);
>      g_free(vq);
>  }
> --
> 2.31.1
>

