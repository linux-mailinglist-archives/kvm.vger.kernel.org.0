Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E45262D2DA
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 06:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbiKQFoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 00:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiKQFoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 00:44:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F08F26D0
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 21:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668663805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PBMBfEnnPEN2MZOvERqsCSnzi4edcJDo9R6V1rzv/vQ=;
        b=XqJnhH2Kp3yTmlsZEI8b0PcwDfjVlp5DiW0GS53lu0nHmoFlOAQRs+c9U0/ov+yzJxJYfr
        2nG/z4EV8VsX00PyhWxvDrji6YxldpAVHPXIdwDuYqZS83dHuLxW7DPPQs0/17YG7wJToX
        IPb5RV7W7S/8A/EAMMnT/BKonzwzJUg=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-278-MyTHkmqGPfK7nqm7q8k6LQ-1; Thu, 17 Nov 2022 00:43:23 -0500
X-MC-Unique: MyTHkmqGPfK7nqm7q8k6LQ-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-14261bd9123so146271fac.21
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 21:43:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PBMBfEnnPEN2MZOvERqsCSnzi4edcJDo9R6V1rzv/vQ=;
        b=f2xHrPktV4vkO/ELhBL0cf7rdSTtYntMfEk7r84H8QTbbOIW+W3QeyLYbJXwp9Z4oQ
         k9AlJADuuohA5K4efXlYN4JVYuyNkWbJihLcN1Ty8ff6fCfBWmd7UlwD1isV1HmT8ICU
         QRXNf5TQUOFhY5pn8eVDePHAZPdMdJcL5b0ZfvX2QfBia+335sRrb6zxq+nd4N8ku3fm
         71+E+EvpesAbLlfAPRbgvAv4mHHnNRmZyMmWDfT9qmZFB384TN4R0qZM8c299mmbTmEu
         cxozG0uRYPGZJavus/NAjdGYSUEbk1o5oZlbXrUAGzOqHEK8aSlJKMN7psi2kIbiJN0N
         kQZQ==
X-Gm-Message-State: ANoB5pmMVBvBQZRtoOgQTwX7681/umz3iExh4wKkNfajrWzb7ywv/6Mj
        zF8cYZafJMGvaqIiUi5Bkd5hV/bXoA1zpBWy9ZgZBEXxyFsuH/DENyTbCUdV+x1Cx5cEtkwOKHO
        tnpdaN3H4uUbe9I1PwTcuBCGif47r
X-Received: by 2002:a4a:b145:0:b0:49f:449a:5f6c with SMTP id e5-20020a4ab145000000b0049f449a5f6cmr651061ooo.93.1668663803179;
        Wed, 16 Nov 2022 21:43:23 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4aIyM6TQSblqvB9prdwXIJgcHUZgakb0mFfB8niYk1S+XlF3oniGqAO2+JrimF9hW+GatROlPxinUOMcF7NN0=
X-Received: by 2002:a4a:b145:0:b0:49f:449a:5f6c with SMTP id
 e5-20020a4ab145000000b0049f449a5f6cmr651042ooo.93.1668663802991; Wed, 16 Nov
 2022 21:43:22 -0800 (PST)
MIME-Version: 1.0
References: <20221116150556.1294049-1-eperezma@redhat.com> <20221116150556.1294049-2-eperezma@redhat.com>
In-Reply-To: <20221116150556.1294049-2-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 17 Nov 2022 13:43:11 +0800
Message-ID: <CACGkMEtJ4aWS4J-5nrOzMLxDqZHUT0rb3qnjVJuN-TXZDebYSQ@mail.gmail.com>
Subject: Re: [PATCH for 8.0 v7 01/10] vdpa: Use v->shadow_vqs_enabled in
 vhost_vdpa_svqs_start & stop
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
> This function used to trust in v->shadow_vqs !=3D NULL to know if it must
> start svq or not.
>
> This is not going to be valid anymore, as qemu is going to allocate svq
> unconditionally (but it will only start them conditionally).
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  hw/virtio/vhost-vdpa.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 7468e44b87..7f0ff4df5b 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -1029,7 +1029,7 @@ static bool vhost_vdpa_svqs_start(struct vhost_dev =
*dev)
>      Error *err =3D NULL;
>      unsigned i;
>
> -    if (!v->shadow_vqs) {
> +    if (!v->shadow_vqs_enabled) {
>          return true;
>      }
>
> @@ -1082,7 +1082,7 @@ static void vhost_vdpa_svqs_stop(struct vhost_dev *=
dev)
>  {
>      struct vhost_vdpa *v =3D dev->opaque;
>
> -    if (!v->shadow_vqs) {
> +    if (!v->shadow_vqs_enabled) {
>          return;
>      }
>
> --
> 2.31.1
>

