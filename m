Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC56362D2DD
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 06:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238603AbiKQFpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 00:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbiKQFpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 00:45:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DA726D0
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 21:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668663882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FYOr5hpybhH+9zqQ2jktdqtrLOvIQkG/NJ+Z4lZqKJY=;
        b=KaE4PsI14bk/Gz1P5xv5ULmx52YP5Zi0//W+KTN95n6jLdyn51vUwa/IpfntSitYHbh8dF
        M0SC2gy3zstgDSsC2pOw5QQS5bDbxyNm9aNxKHSMKNXw3gx51cq2zPksbo9coMlEgxeBCk
        Wdb0pueUR/451hc6et9MpHMDqmAGYVk=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-536-ZE_MzGCRNr6TIhzjMRzxiQ-1; Thu, 17 Nov 2022 00:44:41 -0500
X-MC-Unique: ZE_MzGCRNr6TIhzjMRzxiQ-1
Received: by mail-oo1-f70.google.com with SMTP id v15-20020a4a244f000000b0049f177710abso468521oov.16
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 21:44:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FYOr5hpybhH+9zqQ2jktdqtrLOvIQkG/NJ+Z4lZqKJY=;
        b=EIl38k0E3sQ5y4XFZzhH1oSfA8sm9d4sjP3zFmOVdmAnD2k/Dy7sdz8hMp9ST+kjGp
         hf+RwXIcq8b9MfbXQAaa2ys0sbGnO4q2MjhL3aQA/pimPeegeEVG4ztUmqlTAbjVq+LZ
         cM4zgJdRG3KTYQ/Il94PWd6b/B9/EbwtH+aYw6+9AOPSrSnQaCmzoDWHdwbk4Ea04Mhz
         qay/2VXTyWvR84fKLue6Jiprqg3x1uNaBFxAkjRHkq/yR843o5cOR3YyFJZbTwbKiQko
         UV+Idf9loKVzNLA1+/WMO73K6AJO1qdsrGtvk3xw9lcNcVLdidfXvnkE3Eg+o3ihDqa0
         iSww==
X-Gm-Message-State: ANoB5pk/tb/Ke0kw+QtfPZ7YvM5IOp1V/+rud3mqEpcLPAJU3/UfefwK
        udRaaGTmBJJUlEFRM4LoxGR2/uVn2ppvApFDKE5nr+/MMQoU0jYahTzoR1X8hgTvs/bsM6a/dti
        A3UF+5zbL9a/AeyPKiU0lPPREm7zy
X-Received: by 2002:a4a:94a9:0:b0:480:8f4a:7062 with SMTP id k38-20020a4a94a9000000b004808f4a7062mr669933ooi.57.1668663880499;
        Wed, 16 Nov 2022 21:44:40 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5j1BanuW0SdKc18jcM4HSY4QyInPXCP+MLBD8FDg44fXKMfa0SUxH18LeKItWdoRIKcUv3y49kTZubn44lkVc=
X-Received: by 2002:a4a:94a9:0:b0:480:8f4a:7062 with SMTP id
 k38-20020a4a94a9000000b004808f4a7062mr669911ooi.57.1668663880252; Wed, 16 Nov
 2022 21:44:40 -0800 (PST)
MIME-Version: 1.0
References: <20221116150556.1294049-1-eperezma@redhat.com> <20221116150556.1294049-6-eperezma@redhat.com>
In-Reply-To: <20221116150556.1294049-6-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 17 Nov 2022 13:44:29 +0800
Message-ID: <CACGkMEsOLOYuiA=HUBmbgsSCjHZiD0N6UELz3hNRX7ziW=8SZQ@mail.gmail.com>
Subject: Re: [PATCH for 8.0 v7 05/10] vdpa: move SVQ vring features check to net/
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Cindy Lu <lulu@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Parav Pandit <parav@mellanox.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
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

On Wed, Nov 16, 2022 at 11:06 PM Eugenio P=C3=A9rez <eperezma@redhat.com> w=
rote:
>
> The next patches will start control SVQ if possible. However, we don't
> know if that will be possible at qemu boot anymore.
>
> Since the moved checks will be already evaluated at net/ to know if it
> is ok to shadow CVQ, move them.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  hw/virtio/vhost-vdpa.c | 33 ++-------------------------------
>  net/vhost-vdpa.c       |  3 ++-
>  2 files changed, 4 insertions(+), 32 deletions(-)
>
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 3df2775760..146f0dcb40 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -402,29 +402,9 @@ static int vhost_vdpa_get_dev_features(struct vhost_=
dev *dev,
>      return ret;
>  }
>
> -static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa=
 *v,
> -                               Error **errp)
> +static void vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdp=
a *v)
>  {
>      g_autoptr(GPtrArray) shadow_vqs =3D NULL;
> -    uint64_t dev_features, svq_features;
> -    int r;
> -    bool ok;
> -
> -    if (!v->shadow_vqs_enabled) {
> -        return 0;
> -    }
> -
> -    r =3D vhost_vdpa_get_dev_features(hdev, &dev_features);
> -    if (r !=3D 0) {
> -        error_setg_errno(errp, -r, "Can't get vdpa device features");
> -        return r;
> -    }
> -
> -    svq_features =3D dev_features;
> -    ok =3D vhost_svq_valid_features(svq_features, errp);
> -    if (unlikely(!ok)) {
> -        return -1;
> -    }
>
>      shadow_vqs =3D g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
>      for (unsigned n =3D 0; n < hdev->nvqs; ++n) {
> @@ -436,7 +416,6 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hdev=
, struct vhost_vdpa *v,
>      }
>
>      v->shadow_vqs =3D g_steal_pointer(&shadow_vqs);
> -    return 0;
>  }
>
>  static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, Error **=
errp)
> @@ -461,11 +440,7 @@ static int vhost_vdpa_init(struct vhost_dev *dev, vo=
id *opaque, Error **errp)
>      dev->opaque =3D  opaque ;
>      v->listener =3D vhost_vdpa_memory_listener;
>      v->msg_type =3D VHOST_IOTLB_MSG_V2;
> -    ret =3D vhost_vdpa_init_svq(dev, v, errp);
> -    if (ret) {
> -        goto err;
> -    }
> -
> +    vhost_vdpa_init_svq(dev, v);
>      vhost_vdpa_get_iova_range(v);
>
>      if (!vhost_vdpa_first_dev(dev)) {
> @@ -476,10 +451,6 @@ static int vhost_vdpa_init(struct vhost_dev *dev, vo=
id *opaque, Error **errp)
>                                 VIRTIO_CONFIG_S_DRIVER);
>
>      return 0;
> -
> -err:
> -    ram_block_discard_disable(false);
> -    return ret;
>  }
>
>  static void vhost_vdpa_host_notifier_uninit(struct vhost_dev *dev,
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index e98d5f5eac..dd9cea42d0 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -117,9 +117,10 @@ static bool vhost_vdpa_net_valid_svq_features(uint64=
_t features, Error **errp)
>      if (invalid_dev_features) {
>          error_setg(errp, "vdpa svq does not work with features 0x%" PRIx=
64,
>                     invalid_dev_features);
> +        return false;
>      }
>
> -    return !invalid_dev_features;
> +    return vhost_svq_valid_features(features, errp);
>  }
>
>  static int vhost_vdpa_net_check_device_id(struct vhost_net *net)
> --
> 2.31.1
>

