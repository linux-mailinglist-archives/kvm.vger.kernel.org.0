Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E02623B33
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 06:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiKJFXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 00:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKJFXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 00:23:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDCDBF75
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 21:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668057728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=39bJkdb1ZhD+vECu9SAvHeqKZ+aFs/dYe/MiEsKgSjY=;
        b=IOJ8InrUqltqd4pDwS2mmNAWyYZbp4ScO6i0CGx+sLoMqYm8RwTe2GbZkmrKBkwtGAkCTB
        7J/dVlktKVT0BOLHGjku2qqes16V/NSxa128nO+WY8gSRPuJ/i1vQ4uDfpVLBALX/yX2vO
        9s0UONY+D/5ycYJhllPKJjgnu4OSjaQ=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-582-uE7kmOBcPKSthVJR3RNKxg-1; Thu, 10 Nov 2022 00:22:05 -0500
X-MC-Unique: uE7kmOBcPKSthVJR3RNKxg-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-13af11be44dso554274fac.21
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 21:22:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=39bJkdb1ZhD+vECu9SAvHeqKZ+aFs/dYe/MiEsKgSjY=;
        b=JxbTWjv0UnAGvX/ur/br4ta+gYiap+Aw9oBkuQLTriX/7Q5i3nSRUPDUnA/LwzJNjQ
         hzqnWvAvfMQryzPOMsEFK83ajK6Ry66v2fLdPyxKQaScKRAQ417cYOENz+nF5LAvpW8q
         a6sluJsibfEEjOi1XAw5KIxXVfhVRBOo1b6Lesa+FYIvCo3N/87VSCa2d7H+2CbilHDc
         K53LEM0qAJ1FVI02cVsKUtrMB9VD/gIcCQzyDZjGDo+Q4IztYNO+JXjgGD99koa7Tk5F
         zahQZz014q1rEtTyjYzG779J/MywBF3B4Ci5vrSv0IhKb0c2YyfWhbplj/iYTM/zoy+M
         IXKA==
X-Gm-Message-State: ACrzQf1GY9M247hoFC9Wup5WZcElypBoEiOhiSY9HtpoHJn5GIkxKWTl
        MAW1oP/FqNuvJfoaN9luWbDszX+oK8Jm6BrIlN/4MUJtO8phhzDqC2d7/99rhIWESn9l+KaLB1j
        jSXS0QN8dlKdwX58QBE3xVR3G+bQK
X-Received: by 2002:aca:908:0:b0:354:68aa:9c59 with SMTP id 8-20020aca0908000000b0035468aa9c59mr1094244oij.35.1668057725215;
        Wed, 09 Nov 2022 21:22:05 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5Ntrqyanq4iCvD/7JhkyrTaPhUkC3GXZMAZSkKLcKRV9waH6kFq/1vvPwY9tNcDd4EGPMzUp1ibemhm+vI5Lg=
X-Received: by 2002:aca:908:0:b0:354:68aa:9c59 with SMTP id
 8-20020aca0908000000b0035468aa9c59mr1094225oij.35.1668057725029; Wed, 09 Nov
 2022 21:22:05 -0800 (PST)
MIME-Version: 1.0
References: <20221108170755.92768-1-eperezma@redhat.com> <20221108170755.92768-2-eperezma@redhat.com>
In-Reply-To: <20221108170755.92768-2-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 10 Nov 2022 13:21:53 +0800
Message-ID: <CACGkMEtvbSbsNZQV5RB1yyNzpam4QezdJ-f75nh4ToMJU=KYQQ@mail.gmail.com>
Subject: Re: [PATCH v6 01/10] vdpa: Use v->shadow_vqs_enabled in
 vhost_vdpa_svqs_start & stop
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
> This function used to trust in v->shadow_vqs !=3D NULL to know if it must
> start svq or not.
>
> This is not going to be valid anymore, as qemu is going to allocate svq
> unconditionally (but it will only start them conditionally).

It might be a waste of memory if we did this. Any reason for this?

Thanks

>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
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

