Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12C5628589
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 17:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237739AbiKNQhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 11:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238071AbiKNQhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 11:37:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFE74B9BC
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 08:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668443490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ojH/psRRzArBJAwxVzugaljJuwFZRup6Gb5bmk7DgwQ=;
        b=V/h55OwPjyuYWgHzUniO2ecU7WcR48LkZbn4bZvdorTt6vKj+OyO2GVHaEShyeVUP973WI
        hep1csGybo6QkvR398tFTN8Uv/uf6n504DnIxpIDN369xHBgi5oNnIbpnw1d57qXDs354H
        LMNGVVs1GVT0vm28dqiVsTqlOll4EBY=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-132-yBr9F_ZJNfOcMvywvz6soQ-1; Mon, 14 Nov 2022 11:31:29 -0500
X-MC-Unique: yBr9F_ZJNfOcMvywvz6soQ-1
Received: by mail-pl1-f197.google.com with SMTP id k15-20020a170902c40f00b001887cd71fe6so9282524plk.5
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 08:31:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ojH/psRRzArBJAwxVzugaljJuwFZRup6Gb5bmk7DgwQ=;
        b=5bxDC9ExfQFT1fBZRwXlkJewSnpdmao5o+iYvrP7qcgdnt57gBwm9Oo5sEIH+MnDRo
         HVEOwrT9eQtYxGXKYtH97wVzGhHczRmId2cgNlZE0RYDUuf5G2Yf4bjxfWVbUWAA/Wxq
         5MGz8Nf0sx3Jr237PucD5BTXFzhfqJulerKKjuaTgmASpcI9SLFYZSC/5JkjCtT4yBtB
         2ARorV3vwVKw3I0lZNh5Dg/jEp8KxGUeWFhQ/TOJGST0uzxcsEiI1g9ZTMi8ChIhIQCv
         8fAudcxiAfayu5guGt0Md0vfAP0M2SOEesU3amh9APOkluwcgDaoUY8r4UVS6HwrYRVU
         fvhQ==
X-Gm-Message-State: ANoB5pkyIsIZ3q0kSumU/ToPATNq+h0p3f/DifZoU0OhmzY/udrqV8FH
        lAYaYwLbYYFsvfRyPZVBfViekJfmUDIB2aqy4OT6zLsAAWKVC+iun2kPjn7VVqdOMKnGMTP2vX8
        lxQVdVpfZrrB5oAD/pXNGv1fqDcQP
X-Received: by 2002:a17:902:ccca:b0:188:aa84:14 with SMTP id z10-20020a170902ccca00b00188aa840014mr150375ple.17.1668443488065;
        Mon, 14 Nov 2022 08:31:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4R9JZBu4RFHn7Ru1bTBL82/OuXiBi35elHsJcx/x4J3VxQPRa+NoAcmIQWZ/Qqx1MYow2GBAROuzHp4Pb+Rpc=
X-Received: by 2002:a17:902:ccca:b0:188:aa84:14 with SMTP id
 z10-20020a170902ccca00b00188aa840014mr150351ple.17.1668443487712; Mon, 14 Nov
 2022 08:31:27 -0800 (PST)
MIME-Version: 1.0
References: <20221108170755.92768-1-eperezma@redhat.com> <20221108170755.92768-10-eperezma@redhat.com>
 <CACGkMEsr=fpbbOpUBHawt5DR+nTWcK1uMzXgorEcbijso1wsMQ@mail.gmail.com>
 <CAJaqyWemKoRNd6_uvFc79qYe+7pbavJSjnZuczxk5uxSZZdZ2Q@mail.gmail.com>
 <be553273-7c06-78f7-4d23-de9f46a210b1@redhat.com> <CAJaqyWeZWQgGm7XZ-+DBHNS4XW_-GgWeeOqTb82v__jS8ONRyQ@mail.gmail.com>
 <6a35e659-698e-ff71-fe9b-06e15809c9e4@redhat.com>
In-Reply-To: <6a35e659-698e-ff71-fe9b-06e15809c9e4@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 14 Nov 2022 17:30:51 +0100
Message-ID: <CAJaqyWeF7bNuu-e6g4RghBkc-5oqEAuaEVbJ9uDgGPWWsP36Lg@mail.gmail.com>
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

On Mon, Nov 14, 2022 at 5:30 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/11/11 21:12, Eugenio Perez Martin =E5=86=99=E9=81=93:
> > On Fri, Nov 11, 2022 at 8:49 AM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> =E5=9C=A8 2022/11/10 21:47, Eugenio Perez Martin =E5=86=99=E9=81=93:
> >>> On Thu, Nov 10, 2022 at 7:01 AM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>> On Wed, Nov 9, 2022 at 1:08 AM Eugenio P=C3=A9rez <eperezma@redhat.c=
om> wrote:
> >>>>> The memory listener that thells the device how to convert GPA to qe=
mu's
> >>>>> va is registered against CVQ vhost_vdpa. This series try to map the
> >>>>> memory listener translations to ASID 0, while it maps the CVQ ones =
to
> >>>>> ASID 1.
> >>>>>
> >>>>> Let's tell the listener if it needs to register them on iova tree o=
r
> >>>>> not.
> >>>>>
> >>>>> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >>>>> ---
> >>>>> v5: Solve conflict about vhost_iova_tree_remove accepting mem_regio=
n by
> >>>>>       value.
> >>>>> ---
> >>>>>    include/hw/virtio/vhost-vdpa.h | 2 ++
> >>>>>    hw/virtio/vhost-vdpa.c         | 6 +++---
> >>>>>    net/vhost-vdpa.c               | 1 +
> >>>>>    3 files changed, 6 insertions(+), 3 deletions(-)
> >>>>>
> >>>>> diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vho=
st-vdpa.h
> >>>>> index 6560bb9d78..0c3ed2d69b 100644
> >>>>> --- a/include/hw/virtio/vhost-vdpa.h
> >>>>> +++ b/include/hw/virtio/vhost-vdpa.h
> >>>>> @@ -34,6 +34,8 @@ typedef struct vhost_vdpa {
> >>>>>        struct vhost_vdpa_iova_range iova_range;
> >>>>>        uint64_t acked_features;
> >>>>>        bool shadow_vqs_enabled;
> >>>>> +    /* The listener must send iova tree addresses, not GPA */
> >>
> >> Btw, cindy's vIOMMU series will make it not necessarily GPA any more.
> >>
> > Yes, this comment should be tuned then. But the SVQ iova_tree will not
> > be equal to vIOMMU one because shadow vrings.
> >
> > But maybe SVQ can inspect both instead of having all the duplicated ent=
ries.
> >
> >>>>> +    bool listener_shadow_vq;
> >>>>>        /* IOVA mapping used by the Shadow Virtqueue */
> >>>>>        VhostIOVATree *iova_tree;
> >>>>>        GPtrArray *shadow_vqs;
> >>>>> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> >>>>> index 8fd32ba32b..e3914fa40e 100644
> >>>>> --- a/hw/virtio/vhost-vdpa.c
> >>>>> +++ b/hw/virtio/vhost-vdpa.c
> >>>>> @@ -220,7 +220,7 @@ static void vhost_vdpa_listener_region_add(Memo=
ryListener *listener,
> >>>>>                                             vaddr, section->readonl=
y);
> >>>>>
> >>>>>        llsize =3D int128_sub(llend, int128_make64(iova));
> >>>>> -    if (v->shadow_vqs_enabled) {
> >>>>> +    if (v->listener_shadow_vq) {
> >>>>>            int r;
> >>>>>
> >>>>>            mem_region.translated_addr =3D (hwaddr)(uintptr_t)vaddr,
> >>>>> @@ -247,7 +247,7 @@ static void vhost_vdpa_listener_region_add(Memo=
ryListener *listener,
> >>>>>        return;
> >>>>>
> >>>>>    fail_map:
> >>>>> -    if (v->shadow_vqs_enabled) {
> >>>>> +    if (v->listener_shadow_vq) {
> >>>>>            vhost_iova_tree_remove(v->iova_tree, mem_region);
> >>>>>        }
> >>>>>
> >>>>> @@ -292,7 +292,7 @@ static void vhost_vdpa_listener_region_del(Memo=
ryListener *listener,
> >>>>>
> >>>>>        llsize =3D int128_sub(llend, int128_make64(iova));
> >>>>>
> >>>>> -    if (v->shadow_vqs_enabled) {
> >>>>> +    if (v->listener_shadow_vq) {
> >>>>>            const DMAMap *result;
> >>>>>            const void *vaddr =3D memory_region_get_ram_ptr(section-=
>mr) +
> >>>>>                section->offset_within_region +
> >>>>> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> >>>>> index 85a318faca..02780ee37b 100644
> >>>>> --- a/net/vhost-vdpa.c
> >>>>> +++ b/net/vhost-vdpa.c
> >>>>> @@ -570,6 +570,7 @@ static NetClientState *net_vhost_vdpa_init(NetC=
lientState *peer,
> >>>>>        s->vhost_vdpa.index =3D queue_pair_index;
> >>>>>        s->always_svq =3D svq;
> >>>>>        s->vhost_vdpa.shadow_vqs_enabled =3D svq;
> >>>>> +    s->vhost_vdpa.listener_shadow_vq =3D svq;
> >>>> Any chance those above two can differ?
> >>>>
> >>> If CVQ is shadowed but data VQs are not, shadow_vqs_enabled is true
> >>> but listener_shadow_vq is not.
> >>>
> >>> It is more clear in the next commit, where only shadow_vqs_enabled is
> >>> set to true at vhost_vdpa_net_cvq_start.
> >>
> >> Ok, the name looks a little bit confusing. I wonder if it's better to
> >> use shadow_cvq and shadow_data ?
> >>
> > I'm ok with renaming it, but struct vhost_vdpa is generic across all
> > kind of devices, and it does not know if it is a datapath or not for
> > the moment.
> >
> > Maybe listener_uses_iova_tree?
>
>
> I think "iova_tree" is something that is internal to svq implementation,
> it's better to define the name from the view of vhost_vdpa level.
>

I don't get this, vhost_vdpa struct already has a pointer to its iova_tree.

Thanks!

