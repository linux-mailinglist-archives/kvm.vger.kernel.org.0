Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC90623B92
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 07:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbiKJGCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 01:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiKJGCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 01:02:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A615723EA7
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 22:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668060068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PQnPm1YLduHu1it/yH/StRprHEQQCZZMP7zcvCp6u3E=;
        b=X1Ui/a5vdS0sqII5GVEKAYR7I25ETBob63m0nhntMYDc4lYznMcJT2CX51jp7Ii1A06xsP
        sySfKzuX4OZT3PrbPdm5yPazUvEYVJYLSPlPBJwOOuxW5GJooHYttxdnHsoBPBrixeh7N1
        jq4WPrUP4MqKu+nMizhSSnl4mbRo1XU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-448-xityafaKPfaD4hS2Ikzm8w-1; Thu, 10 Nov 2022 01:01:07 -0500
X-MC-Unique: xityafaKPfaD4hS2Ikzm8w-1
Received: by mail-ed1-f72.google.com with SMTP id v18-20020a056402349200b004622e273bbbso726193edc.14
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 22:01:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PQnPm1YLduHu1it/yH/StRprHEQQCZZMP7zcvCp6u3E=;
        b=QdBlPYlmUJfJQdHqFjaQowlzsP8eIS8pAfkmBC450sHKlNO0BgpqMPm/5oxJssZF4N
         98QCggMfuzPc5YSlhos9qY0seSwssrn3Nf96BwZQp2lKZyqodLO1PQbJSZGlWuOQeLSI
         mcyOIzSWnF9ruixUQrhMNZw2bMKLojiXDTxUiby3gJBWQ5rXFuZfIYpkUlcXk4KxX8vU
         m2G+tKVkd/7zw4c6GcBHMJ4MNsjtIuzMX63/FD523SU/hzf4d08s6/eDPSdGmhfJWFDw
         RmX8dS09J9M8kWT0RMRBlYHMT7QysUoQ4zB4nXVahErpEphxfKYLBkJ1fedi4zD0cODu
         tDNA==
X-Gm-Message-State: ACrzQf3y7Uwa5u/I0qX91CPRlV08eNdl7JKnVTOWhKR8R9aDG6t5c+Pi
        kqfpzLav4fOAVszjfkN3hBaeHtCOdzrEF8ssXX+FZmckNZLj0VCnxoVjqc+Je7tKykcX32gY8BQ
        VZJiD13vKP0cR5ZwfSJgzRGBFaEIt
X-Received: by 2002:a17:907:1b1f:b0:72f:56db:cce9 with SMTP id mp31-20020a1709071b1f00b0072f56dbcce9mr57164931ejc.605.1668060065996;
        Wed, 09 Nov 2022 22:01:05 -0800 (PST)
X-Google-Smtp-Source: AMsMyM50QMsSJcTUvrOlRwWiIjykGta2yvRyJdFwvVL9lpLzTelIP9oNRfitCVX+nxlZTF3bE3A1UT/8Ui4SoFG7REM=
X-Received: by 2002:a17:907:1b1f:b0:72f:56db:cce9 with SMTP id
 mp31-20020a1709071b1f00b0072f56dbcce9mr57164912ejc.605.1668060065782; Wed, 09
 Nov 2022 22:01:05 -0800 (PST)
MIME-Version: 1.0
References: <20221108170755.92768-1-eperezma@redhat.com> <20221108170755.92768-10-eperezma@redhat.com>
In-Reply-To: <20221108170755.92768-10-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 10 Nov 2022 14:00:52 +0800
Message-ID: <CACGkMEsr=fpbbOpUBHawt5DR+nTWcK1uMzXgorEcbijso1wsMQ@mail.gmail.com>
Subject: Re: [PATCH v6 09/10] vdpa: Add listener_shadow_vq to vhost_vdpa
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
> The memory listener that thells the device how to convert GPA to qemu's
> va is registered against CVQ vhost_vdpa. This series try to map the
> memory listener translations to ASID 0, while it maps the CVQ ones to
> ASID 1.
>
> Let's tell the listener if it needs to register them on iova tree or
> not.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
> v5: Solve conflict about vhost_iova_tree_remove accepting mem_region by
>     value.
> ---
>  include/hw/virtio/vhost-vdpa.h | 2 ++
>  hw/virtio/vhost-vdpa.c         | 6 +++---
>  net/vhost-vdpa.c               | 1 +
>  3 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost-vdp=
a.h
> index 6560bb9d78..0c3ed2d69b 100644
> --- a/include/hw/virtio/vhost-vdpa.h
> +++ b/include/hw/virtio/vhost-vdpa.h
> @@ -34,6 +34,8 @@ typedef struct vhost_vdpa {
>      struct vhost_vdpa_iova_range iova_range;
>      uint64_t acked_features;
>      bool shadow_vqs_enabled;
> +    /* The listener must send iova tree addresses, not GPA */
> +    bool listener_shadow_vq;
>      /* IOVA mapping used by the Shadow Virtqueue */
>      VhostIOVATree *iova_tree;
>      GPtrArray *shadow_vqs;
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 8fd32ba32b..e3914fa40e 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -220,7 +220,7 @@ static void vhost_vdpa_listener_region_add(MemoryList=
ener *listener,
>                                           vaddr, section->readonly);
>
>      llsize =3D int128_sub(llend, int128_make64(iova));
> -    if (v->shadow_vqs_enabled) {
> +    if (v->listener_shadow_vq) {
>          int r;
>
>          mem_region.translated_addr =3D (hwaddr)(uintptr_t)vaddr,
> @@ -247,7 +247,7 @@ static void vhost_vdpa_listener_region_add(MemoryList=
ener *listener,
>      return;
>
>  fail_map:
> -    if (v->shadow_vqs_enabled) {
> +    if (v->listener_shadow_vq) {
>          vhost_iova_tree_remove(v->iova_tree, mem_region);
>      }
>
> @@ -292,7 +292,7 @@ static void vhost_vdpa_listener_region_del(MemoryList=
ener *listener,
>
>      llsize =3D int128_sub(llend, int128_make64(iova));
>
> -    if (v->shadow_vqs_enabled) {
> +    if (v->listener_shadow_vq) {
>          const DMAMap *result;
>          const void *vaddr =3D memory_region_get_ram_ptr(section->mr) +
>              section->offset_within_region +
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index 85a318faca..02780ee37b 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -570,6 +570,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientS=
tate *peer,
>      s->vhost_vdpa.index =3D queue_pair_index;
>      s->always_svq =3D svq;
>      s->vhost_vdpa.shadow_vqs_enabled =3D svq;
> +    s->vhost_vdpa.listener_shadow_vq =3D svq;

Any chance those above two can differ?

Thanks

>      s->vhost_vdpa.iova_tree =3D iova_tree;
>      if (!is_datapath) {
>          s->cvq_cmd_out_buffer =3D qemu_memalign(qemu_real_host_page_size=
(),
> --
> 2.31.1
>

