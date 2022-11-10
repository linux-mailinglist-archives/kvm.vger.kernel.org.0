Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A6A624399
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 14:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiKJNt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 08:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiKJNtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 08:49:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9693CE0
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 05:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668088102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n2vKrhn0W6zmDQL4p2cy55bsV2E6VIdPzjBOi6hj00M=;
        b=IrUpfI0q8AdUolw5Fuh++ZbQsVynQmHS9fL864y13mTkvo9bcqpvbHthsJlWP7nWZyas8v
        wBeC1CypQQO1E6mCePvFxGPB/Mw0CVi35ooxc7xL4C3Ho1xjTJ7Jp7By/kLpKO78fEDkOk
        vTAD2BhqKHyiA2n9xIzoQr8Q0k04sqg=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-93-VW00R0HBM-CqbQ5p9rWtsw-1; Thu, 10 Nov 2022 08:48:21 -0500
X-MC-Unique: VW00R0HBM-CqbQ5p9rWtsw-1
Received: by mail-pf1-f200.google.com with SMTP id cj8-20020a056a00298800b0056cee8a0cf8so1063654pfb.9
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 05:48:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n2vKrhn0W6zmDQL4p2cy55bsV2E6VIdPzjBOi6hj00M=;
        b=UXtCJ8Eeh2S7thzdqTXojvzIEYBCV3kfBvYxni1TZ6tyBREEptQYeaArATv3ATw/di
         EZVpymKTzXBAPRWwLs6Ant5nldB55x151MaER+STcDo0n8RtqtYn2bxQFymeATwLSBnH
         1WdokPkBmdHcWiUilhfGkfpd64n8FeRrKio3eY4IialzeD6EboTIfW0PiaxMPhDAq2t8
         j6y91MRM6cQWsuxxFr46WzsN57QiOlmPdibOeeA573tu1M6sc2vItidIKhs8fVRCGw8z
         GaecYYsBUn4q57yK+8bVEgc+eJAtmC7nxMOqw4E/FVBUEd7HCh4ACs1+4wRT7VWkO2Rc
         l0Kw==
X-Gm-Message-State: ACrzQf0xQ+VicgvAfwoZaE52CEjfQ2Mpq272KYpKVXJCcujlFCLZc5/p
        TXMFg7WTk5ZEdTnIIcyB4rGEaVspblSFIKYHff9CrOd7FQfTgEazso8ilt8lq9DyvlD29v/tUps
        beVtVr8frUrX5+UAoOw1+vB4gQ/ks
X-Received: by 2002:a63:40c4:0:b0:470:18d5:e914 with SMTP id n187-20020a6340c4000000b0047018d5e914mr35251814pga.58.1668088100670;
        Thu, 10 Nov 2022 05:48:20 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6kCjm98mwDiswamvSe9FxW3UTuG/9V2DnQlWH0uiqVqjU3TVFAbI6lMN6jpeP4rKjnDw6drD6Nf4+AENVVmfs=
X-Received: by 2002:a63:40c4:0:b0:470:18d5:e914 with SMTP id
 n187-20020a6340c4000000b0047018d5e914mr35251792pga.58.1668088100439; Thu, 10
 Nov 2022 05:48:20 -0800 (PST)
MIME-Version: 1.0
References: <20221108170755.92768-1-eperezma@redhat.com> <20221108170755.92768-10-eperezma@redhat.com>
 <CACGkMEsr=fpbbOpUBHawt5DR+nTWcK1uMzXgorEcbijso1wsMQ@mail.gmail.com>
In-Reply-To: <CACGkMEsr=fpbbOpUBHawt5DR+nTWcK1uMzXgorEcbijso1wsMQ@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 10 Nov 2022 14:47:44 +0100
Message-ID: <CAJaqyWemKoRNd6_uvFc79qYe+7pbavJSjnZuczxk5uxSZZdZ2Q@mail.gmail.com>
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

On Thu, Nov 10, 2022 at 7:01 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Wed, Nov 9, 2022 at 1:08 AM Eugenio P=C3=A9rez <eperezma@redhat.com> w=
rote:
> >
> > The memory listener that thells the device how to convert GPA to qemu's
> > va is registered against CVQ vhost_vdpa. This series try to map the
> > memory listener translations to ASID 0, while it maps the CVQ ones to
> > ASID 1.
> >
> > Let's tell the listener if it needs to register them on iova tree or
> > not.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> > v5: Solve conflict about vhost_iova_tree_remove accepting mem_region by
> >     value.
> > ---
> >  include/hw/virtio/vhost-vdpa.h | 2 ++
> >  hw/virtio/vhost-vdpa.c         | 6 +++---
> >  net/vhost-vdpa.c               | 1 +
> >  3 files changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost-v=
dpa.h
> > index 6560bb9d78..0c3ed2d69b 100644
> > --- a/include/hw/virtio/vhost-vdpa.h
> > +++ b/include/hw/virtio/vhost-vdpa.h
> > @@ -34,6 +34,8 @@ typedef struct vhost_vdpa {
> >      struct vhost_vdpa_iova_range iova_range;
> >      uint64_t acked_features;
> >      bool shadow_vqs_enabled;
> > +    /* The listener must send iova tree addresses, not GPA */
> > +    bool listener_shadow_vq;
> >      /* IOVA mapping used by the Shadow Virtqueue */
> >      VhostIOVATree *iova_tree;
> >      GPtrArray *shadow_vqs;
> > diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > index 8fd32ba32b..e3914fa40e 100644
> > --- a/hw/virtio/vhost-vdpa.c
> > +++ b/hw/virtio/vhost-vdpa.c
> > @@ -220,7 +220,7 @@ static void vhost_vdpa_listener_region_add(MemoryLi=
stener *listener,
> >                                           vaddr, section->readonly);
> >
> >      llsize =3D int128_sub(llend, int128_make64(iova));
> > -    if (v->shadow_vqs_enabled) {
> > +    if (v->listener_shadow_vq) {
> >          int r;
> >
> >          mem_region.translated_addr =3D (hwaddr)(uintptr_t)vaddr,
> > @@ -247,7 +247,7 @@ static void vhost_vdpa_listener_region_add(MemoryLi=
stener *listener,
> >      return;
> >
> >  fail_map:
> > -    if (v->shadow_vqs_enabled) {
> > +    if (v->listener_shadow_vq) {
> >          vhost_iova_tree_remove(v->iova_tree, mem_region);
> >      }
> >
> > @@ -292,7 +292,7 @@ static void vhost_vdpa_listener_region_del(MemoryLi=
stener *listener,
> >
> >      llsize =3D int128_sub(llend, int128_make64(iova));
> >
> > -    if (v->shadow_vqs_enabled) {
> > +    if (v->listener_shadow_vq) {
> >          const DMAMap *result;
> >          const void *vaddr =3D memory_region_get_ram_ptr(section->mr) +
> >              section->offset_within_region +
> > diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> > index 85a318faca..02780ee37b 100644
> > --- a/net/vhost-vdpa.c
> > +++ b/net/vhost-vdpa.c
> > @@ -570,6 +570,7 @@ static NetClientState *net_vhost_vdpa_init(NetClien=
tState *peer,
> >      s->vhost_vdpa.index =3D queue_pair_index;
> >      s->always_svq =3D svq;
> >      s->vhost_vdpa.shadow_vqs_enabled =3D svq;
> > +    s->vhost_vdpa.listener_shadow_vq =3D svq;
>
> Any chance those above two can differ?
>

If CVQ is shadowed but data VQs are not, shadow_vqs_enabled is true
but listener_shadow_vq is not.

It is more clear in the next commit, where only shadow_vqs_enabled is
set to true at vhost_vdpa_net_cvq_start.

Thanks!

> Thanks
>
> >      s->vhost_vdpa.iova_tree =3D iova_tree;
> >      if (!is_datapath) {
> >          s->cvq_cmd_out_buffer =3D qemu_memalign(qemu_real_host_page_si=
ze(),
> > --
> > 2.31.1
> >
>

