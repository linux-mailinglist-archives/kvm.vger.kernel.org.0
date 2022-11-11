Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4789625B0A
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 14:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbiKKNOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 08:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiKKNOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 08:14:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF07B38
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 05:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668172392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GvvPiYiG2g+lTyoBUPdYMINvBiZ9f2kPIFbaOkQx7Po=;
        b=GsjdkFOwN7pOJp4pdzZ1zo6mBroCDekCMMt1XT8fkEfNXA39VgVE/fk4TXunwaKvCpySDi
        AsCkoqgCMXc2GLockjpEEEjF4sUe3a81pWmzXUcxdUNT/pCZWIh9ODPaBDcXMIomLn4bdr
        VleNs85/LNZ8TIneRLvRnOSVBr993kk=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-267-UEN8FpcnOUqZQsPVF57x9Q-1; Fri, 11 Nov 2022 08:13:11 -0500
X-MC-Unique: UEN8FpcnOUqZQsPVF57x9Q-1
Received: by mail-pg1-f200.google.com with SMTP id f132-20020a636a8a000000b00473d0b600ebso2629517pgc.14
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 05:13:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GvvPiYiG2g+lTyoBUPdYMINvBiZ9f2kPIFbaOkQx7Po=;
        b=ywJwF8KmpQihVmaf0ikyY1uAujtYy81RzXhLF711Q6rlAhmx/Ye5IIjZiGI4dwcDtS
         D+LY+5IkZF07UvYEf3m+4ehvMv5/fPFc3b+95cQo3sq9XeJFQ9vEc0YUSX5GOpmLe3Vl
         JkfUS2X4q8TD4H5MMBt0rdsySE8DxoNWYRPCtX0m/KE3HBw/rHEGhMBd4+b8r9R/sO/y
         2AkgsRElChH/gtB5UZETc67a7PY9+GIOjA+mh9gSmPECDiaYuQWv74atrxOOHlE8ZqXh
         9bJYWpscgTSSqb8ajN0p6iajIoZLerGpSUXJUYaMW58UBgtW/UsCxQQ5T5IGw45FI/Km
         ++MQ==
X-Gm-Message-State: ANoB5pmtxGGs73luaIW4ZTrOauzUuQZsh8sxBHXJyrR9DH8fq9vu3AzX
        vH+aSjTymfiJEIpejA5deWBA9SkslAbX7douCSHj2Y8dXw0VTL07k7QFZ+DgZEcJCCviXrEFZnJ
        WViyQtD7IoKXPmcvKKPRpYFg4cySA
X-Received: by 2002:a17:90a:73cf:b0:213:7f5:a972 with SMTP id n15-20020a17090a73cf00b0021307f5a972mr1901811pjk.159.1668172390473;
        Fri, 11 Nov 2022 05:13:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5KTNEahIbT6kCmtMBl+5Gdcxr7Dx8rrcX5iEYDIUyInRiZ+qorQ/r7uJK5MN39LcjRseVVrPraDjH3tOVBOFk=
X-Received: by 2002:a17:90a:73cf:b0:213:7f5:a972 with SMTP id
 n15-20020a17090a73cf00b0021307f5a972mr1901782pjk.159.1668172390216; Fri, 11
 Nov 2022 05:13:10 -0800 (PST)
MIME-Version: 1.0
References: <20221108170755.92768-1-eperezma@redhat.com> <20221108170755.92768-10-eperezma@redhat.com>
 <CACGkMEsr=fpbbOpUBHawt5DR+nTWcK1uMzXgorEcbijso1wsMQ@mail.gmail.com>
 <CAJaqyWemKoRNd6_uvFc79qYe+7pbavJSjnZuczxk5uxSZZdZ2Q@mail.gmail.com> <be553273-7c06-78f7-4d23-de9f46a210b1@redhat.com>
In-Reply-To: <be553273-7c06-78f7-4d23-de9f46a210b1@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 11 Nov 2022 14:12:34 +0100
Message-ID: <CAJaqyWeZWQgGm7XZ-+DBHNS4XW_-GgWeeOqTb82v__jS8ONRyQ@mail.gmail.com>
Subject: Re: [PATCH v6 09/10] vdpa: Add listener_shadow_vq to vhost_vdpa
To:     Jason Wang <jasowang@redhat.com>
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

On Fri, Nov 11, 2022 at 8:49 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/11/10 21:47, Eugenio Perez Martin =E5=86=99=E9=81=93:
> > On Thu, Nov 10, 2022 at 7:01 AM Jason Wang <jasowang@redhat.com> wrote:
> >> On Wed, Nov 9, 2022 at 1:08 AM Eugenio P=C3=A9rez <eperezma@redhat.com=
> wrote:
> >>> The memory listener that thells the device how to convert GPA to qemu=
's
> >>> va is registered against CVQ vhost_vdpa. This series try to map the
> >>> memory listener translations to ASID 0, while it maps the CVQ ones to
> >>> ASID 1.
> >>>
> >>> Let's tell the listener if it needs to register them on iova tree or
> >>> not.
> >>>
> >>> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >>> ---
> >>> v5: Solve conflict about vhost_iova_tree_remove accepting mem_region =
by
> >>>      value.
> >>> ---
> >>>   include/hw/virtio/vhost-vdpa.h | 2 ++
> >>>   hw/virtio/vhost-vdpa.c         | 6 +++---
> >>>   net/vhost-vdpa.c               | 1 +
> >>>   3 files changed, 6 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost=
-vdpa.h
> >>> index 6560bb9d78..0c3ed2d69b 100644
> >>> --- a/include/hw/virtio/vhost-vdpa.h
> >>> +++ b/include/hw/virtio/vhost-vdpa.h
> >>> @@ -34,6 +34,8 @@ typedef struct vhost_vdpa {
> >>>       struct vhost_vdpa_iova_range iova_range;
> >>>       uint64_t acked_features;
> >>>       bool shadow_vqs_enabled;
> >>> +    /* The listener must send iova tree addresses, not GPA */
>
>
> Btw, cindy's vIOMMU series will make it not necessarily GPA any more.
>

Yes, this comment should be tuned then. But the SVQ iova_tree will not
be equal to vIOMMU one because shadow vrings.

But maybe SVQ can inspect both instead of having all the duplicated entries=
.

>
> >>> +    bool listener_shadow_vq;
> >>>       /* IOVA mapping used by the Shadow Virtqueue */
> >>>       VhostIOVATree *iova_tree;
> >>>       GPtrArray *shadow_vqs;
> >>> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> >>> index 8fd32ba32b..e3914fa40e 100644
> >>> --- a/hw/virtio/vhost-vdpa.c
> >>> +++ b/hw/virtio/vhost-vdpa.c
> >>> @@ -220,7 +220,7 @@ static void vhost_vdpa_listener_region_add(Memory=
Listener *listener,
> >>>                                            vaddr, section->readonly);
> >>>
> >>>       llsize =3D int128_sub(llend, int128_make64(iova));
> >>> -    if (v->shadow_vqs_enabled) {
> >>> +    if (v->listener_shadow_vq) {
> >>>           int r;
> >>>
> >>>           mem_region.translated_addr =3D (hwaddr)(uintptr_t)vaddr,
> >>> @@ -247,7 +247,7 @@ static void vhost_vdpa_listener_region_add(Memory=
Listener *listener,
> >>>       return;
> >>>
> >>>   fail_map:
> >>> -    if (v->shadow_vqs_enabled) {
> >>> +    if (v->listener_shadow_vq) {
> >>>           vhost_iova_tree_remove(v->iova_tree, mem_region);
> >>>       }
> >>>
> >>> @@ -292,7 +292,7 @@ static void vhost_vdpa_listener_region_del(Memory=
Listener *listener,
> >>>
> >>>       llsize =3D int128_sub(llend, int128_make64(iova));
> >>>
> >>> -    if (v->shadow_vqs_enabled) {
> >>> +    if (v->listener_shadow_vq) {
> >>>           const DMAMap *result;
> >>>           const void *vaddr =3D memory_region_get_ram_ptr(section->mr=
) +
> >>>               section->offset_within_region +
> >>> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> >>> index 85a318faca..02780ee37b 100644
> >>> --- a/net/vhost-vdpa.c
> >>> +++ b/net/vhost-vdpa.c
> >>> @@ -570,6 +570,7 @@ static NetClientState *net_vhost_vdpa_init(NetCli=
entState *peer,
> >>>       s->vhost_vdpa.index =3D queue_pair_index;
> >>>       s->always_svq =3D svq;
> >>>       s->vhost_vdpa.shadow_vqs_enabled =3D svq;
> >>> +    s->vhost_vdpa.listener_shadow_vq =3D svq;
> >> Any chance those above two can differ?
> >>
> > If CVQ is shadowed but data VQs are not, shadow_vqs_enabled is true
> > but listener_shadow_vq is not.
> >
> > It is more clear in the next commit, where only shadow_vqs_enabled is
> > set to true at vhost_vdpa_net_cvq_start.
>
>
> Ok, the name looks a little bit confusing. I wonder if it's better to
> use shadow_cvq and shadow_data ?
>

I'm ok with renaming it, but struct vhost_vdpa is generic across all
kind of devices, and it does not know if it is a datapath or not for
the moment.

Maybe listener_uses_iova_tree?

Thanks!

