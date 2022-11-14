Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD1E62754F
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 05:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235817AbiKNEbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 23:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235338AbiKNEbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 23:31:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E4F63A1
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 20:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668400222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KfG44Vz1URbgkpQEdXRZWY0nTsuZKI0JGhM4zYGq6UE=;
        b=F+ZW4ZtNjCbH/XbvdXvCeLJlHJ4WMNVgbgQwTzc18CMWoc26P0qMdKsP4rGiLdfQf59l23
        SwcdrSTtH+R+5nrg7oGUeS5CV7Jbu/n3siODevDRuiXhvTgUfDMNa/bBH+QwIJAYomiIkP
        ZJeR3YW4S1DjUZP03QldxRzHT93MY8M=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-499-ZK5kYWIdOkujZzBaG99gJg-1; Sun, 13 Nov 2022 23:30:20 -0500
X-MC-Unique: ZK5kYWIdOkujZzBaG99gJg-1
Received: by mail-pl1-f200.google.com with SMTP id a6-20020a170902ecc600b00186f035ed74so8115463plh.12
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 20:30:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KfG44Vz1URbgkpQEdXRZWY0nTsuZKI0JGhM4zYGq6UE=;
        b=GBcfEw3QUAERVj1hmeFXH0VacBXJSfXLxqrhGN+QwFXFemLSIVKXt3J7LPf5r3iqRB
         GrTZR8WlyrOd6VfjJpTLv2kCzg97uvg2Sqky4j21YXd5qtUVHcAgi168Iw/oT44tuxyc
         6/1vPlRQ7gjo8FdXC6M3jbCe1hC+2L4RU8RWycXv549ueKT2a/0kv/VG0Cp0MuSeCFCR
         gpdt4MwM6r/r+STL2T4hjqUNfvd0aXW0u83vkY+rv0PM/u/YLxApx2YhNntcF7c2H4FD
         Wq6QgcEryYmnCrIbex4f2XyKL17s0fDTArjEvyQgi9Bm5UmVQc3ri4Z0VkE0jb1Cx4C4
         cPyw==
X-Gm-Message-State: ANoB5pk++4a+46g8TO1NY9qaPIRJb3diD65HXfYi2KOFBnsfZGQgoobi
        /wlTaMK+rz3sh4Zr4PSZqxtGWGfzlyo+gDkNZKZBy1avL6WMyanajZlhSXrobl4/pyYbkhSpcOA
        7RVr9ioCutE9g
X-Received: by 2002:a17:903:3308:b0:186:d89d:f0bc with SMTP id jk8-20020a170903330800b00186d89df0bcmr12144129plb.19.1668400219488;
        Sun, 13 Nov 2022 20:30:19 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4JGvLcGS0rUrYEviFQkpojH+lEE7BEpMuELAsAPQuEtf4LBl9s7c8lbM64KlBjB5Q420+QeQ==
X-Received: by 2002:a17:903:3308:b0:186:d89d:f0bc with SMTP id jk8-20020a170903330800b00186d89df0bcmr12144113plb.19.1668400219229;
        Sun, 13 Nov 2022 20:30:19 -0800 (PST)
Received: from [10.72.13.180] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i8-20020a170902c94800b00187197c4999sm6134805pla.167.2022.11.13.20.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Nov 2022 20:30:18 -0800 (PST)
Message-ID: <6a35e659-698e-ff71-fe9b-06e15809c9e4@redhat.com>
Date:   Mon, 14 Nov 2022 12:30:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v6 09/10] vdpa: Add listener_shadow_vq to vhost_vdpa
Content-Language: en-US
To:     Eugenio Perez Martin <eperezma@redhat.com>
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
References: <20221108170755.92768-1-eperezma@redhat.com>
 <20221108170755.92768-10-eperezma@redhat.com>
 <CACGkMEsr=fpbbOpUBHawt5DR+nTWcK1uMzXgorEcbijso1wsMQ@mail.gmail.com>
 <CAJaqyWemKoRNd6_uvFc79qYe+7pbavJSjnZuczxk5uxSZZdZ2Q@mail.gmail.com>
 <be553273-7c06-78f7-4d23-de9f46a210b1@redhat.com>
 <CAJaqyWeZWQgGm7XZ-+DBHNS4XW_-GgWeeOqTb82v__jS8ONRyQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <CAJaqyWeZWQgGm7XZ-+DBHNS4XW_-GgWeeOqTb82v__jS8ONRyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/11/11 21:12, Eugenio Perez Martin 写道:
> On Fri, Nov 11, 2022 at 8:49 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2022/11/10 21:47, Eugenio Perez Martin 写道:
>>> On Thu, Nov 10, 2022 at 7:01 AM Jason Wang <jasowang@redhat.com> wrote:
>>>> On Wed, Nov 9, 2022 at 1:08 AM Eugenio Pérez <eperezma@redhat.com> wrote:
>>>>> The memory listener that thells the device how to convert GPA to qemu's
>>>>> va is registered against CVQ vhost_vdpa. This series try to map the
>>>>> memory listener translations to ASID 0, while it maps the CVQ ones to
>>>>> ASID 1.
>>>>>
>>>>> Let's tell the listener if it needs to register them on iova tree or
>>>>> not.
>>>>>
>>>>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>>>>> ---
>>>>> v5: Solve conflict about vhost_iova_tree_remove accepting mem_region by
>>>>>       value.
>>>>> ---
>>>>>    include/hw/virtio/vhost-vdpa.h | 2 ++
>>>>>    hw/virtio/vhost-vdpa.c         | 6 +++---
>>>>>    net/vhost-vdpa.c               | 1 +
>>>>>    3 files changed, 6 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost-vdpa.h
>>>>> index 6560bb9d78..0c3ed2d69b 100644
>>>>> --- a/include/hw/virtio/vhost-vdpa.h
>>>>> +++ b/include/hw/virtio/vhost-vdpa.h
>>>>> @@ -34,6 +34,8 @@ typedef struct vhost_vdpa {
>>>>>        struct vhost_vdpa_iova_range iova_range;
>>>>>        uint64_t acked_features;
>>>>>        bool shadow_vqs_enabled;
>>>>> +    /* The listener must send iova tree addresses, not GPA */
>>
>> Btw, cindy's vIOMMU series will make it not necessarily GPA any more.
>>
> Yes, this comment should be tuned then. But the SVQ iova_tree will not
> be equal to vIOMMU one because shadow vrings.
>
> But maybe SVQ can inspect both instead of having all the duplicated entries.
>
>>>>> +    bool listener_shadow_vq;
>>>>>        /* IOVA mapping used by the Shadow Virtqueue */
>>>>>        VhostIOVATree *iova_tree;
>>>>>        GPtrArray *shadow_vqs;
>>>>> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
>>>>> index 8fd32ba32b..e3914fa40e 100644
>>>>> --- a/hw/virtio/vhost-vdpa.c
>>>>> +++ b/hw/virtio/vhost-vdpa.c
>>>>> @@ -220,7 +220,7 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
>>>>>                                             vaddr, section->readonly);
>>>>>
>>>>>        llsize = int128_sub(llend, int128_make64(iova));
>>>>> -    if (v->shadow_vqs_enabled) {
>>>>> +    if (v->listener_shadow_vq) {
>>>>>            int r;
>>>>>
>>>>>            mem_region.translated_addr = (hwaddr)(uintptr_t)vaddr,
>>>>> @@ -247,7 +247,7 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
>>>>>        return;
>>>>>
>>>>>    fail_map:
>>>>> -    if (v->shadow_vqs_enabled) {
>>>>> +    if (v->listener_shadow_vq) {
>>>>>            vhost_iova_tree_remove(v->iova_tree, mem_region);
>>>>>        }
>>>>>
>>>>> @@ -292,7 +292,7 @@ static void vhost_vdpa_listener_region_del(MemoryListener *listener,
>>>>>
>>>>>        llsize = int128_sub(llend, int128_make64(iova));
>>>>>
>>>>> -    if (v->shadow_vqs_enabled) {
>>>>> +    if (v->listener_shadow_vq) {
>>>>>            const DMAMap *result;
>>>>>            const void *vaddr = memory_region_get_ram_ptr(section->mr) +
>>>>>                section->offset_within_region +
>>>>> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
>>>>> index 85a318faca..02780ee37b 100644
>>>>> --- a/net/vhost-vdpa.c
>>>>> +++ b/net/vhost-vdpa.c
>>>>> @@ -570,6 +570,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
>>>>>        s->vhost_vdpa.index = queue_pair_index;
>>>>>        s->always_svq = svq;
>>>>>        s->vhost_vdpa.shadow_vqs_enabled = svq;
>>>>> +    s->vhost_vdpa.listener_shadow_vq = svq;
>>>> Any chance those above two can differ?
>>>>
>>> If CVQ is shadowed but data VQs are not, shadow_vqs_enabled is true
>>> but listener_shadow_vq is not.
>>>
>>> It is more clear in the next commit, where only shadow_vqs_enabled is
>>> set to true at vhost_vdpa_net_cvq_start.
>>
>> Ok, the name looks a little bit confusing. I wonder if it's better to
>> use shadow_cvq and shadow_data ?
>>
> I'm ok with renaming it, but struct vhost_vdpa is generic across all
> kind of devices, and it does not know if it is a datapath or not for
> the moment.
>
> Maybe listener_uses_iova_tree?


I think "iova_tree" is something that is internal to svq implementation, 
it's better to define the name from the view of vhost_vdpa level.

Thanks


>
> Thanks!
>

