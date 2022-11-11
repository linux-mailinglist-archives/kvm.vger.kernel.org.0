Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F36162549E
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 08:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiKKHuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 02:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiKKHuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 02:50:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58DC54B12
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 23:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668152954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lQ2OMg/XDBnbe2LjD68xEzX2Z9rZ/ij03O6xGIiQqzA=;
        b=ZU/COOHMj0h7XzjFkRFfO5mr1A8OfIXN0odcQ1mlCP77IEZE/MxsAjPuo9NvC7ia4JW1gf
        M9wioTqkOMuC+h6Ju57sXIVml4wW+BA/flhWZ9usui7JGYN9qU4DkypL3ebHkq7zB0B171
        AXTeR7SwRtXgayE8ucUSn4d8Zpgmi0E=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-553-XzhX5PKiNBimW_Dp5SI1Bw-1; Fri, 11 Nov 2022 02:49:12 -0500
X-MC-Unique: XzhX5PKiNBimW_Dp5SI1Bw-1
Received: by mail-pf1-f199.google.com with SMTP id cj8-20020a056a00298800b0056cee8a0cf8so2365248pfb.9
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 23:49:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lQ2OMg/XDBnbe2LjD68xEzX2Z9rZ/ij03O6xGIiQqzA=;
        b=epBjb9uafLunqDx0hv2kt5f3rYbayuIPw4I0Tg0lFUQH1hTue+CaucV4L18b3x24Pd
         hwazvMxhwvGMOa44Olhz7vgmKd980KL3yZSH1Pj38N8hLB4opNfqGl1ocT5d+ve003dG
         Tl6coYON04HSTjcKjowm9uHQz4SFyjjZQcQiYuBI1DRjdiHr+e0rgUp5fnzjy1J/nHCB
         9Grg4TdI8D+R3KiUf9bvfb3LaRm7E7BIasOquEy4aVMFXhZxUqFI5GzYBHWi6sEZq0Xo
         rVt4A4lqP6b9q6W1vjZ/0T24mQ5bm4bKA7/sRmh9baLYjv4kH2VgN124/MwIc7bkA4kc
         oVlQ==
X-Gm-Message-State: ANoB5pnnfaQ5QZLWTW+nlqSuLFMe5SJoBQhfnyJ9vvTtq3Q4z6PbN+rL
        +gw/bkitggz6csLEEXkft85KC3pJgDd5yXicqVZHFioj8xeYtuIEqPdPX/TXEotMu2AweqG5Ewa
        UHZW+tkQczvxT
X-Received: by 2002:a17:902:d353:b0:180:be71:6773 with SMTP id l19-20020a170902d35300b00180be716773mr1580524plk.42.1668152950585;
        Thu, 10 Nov 2022 23:49:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5hugxwU3w8Xl0Dv7S4TgEzgOZHCVEsrDcsWDpBKgH57oQNNCHlxuBgcCknkXEzU/xAGZjPTQ==
X-Received: by 2002:a17:902:d353:b0:180:be71:6773 with SMTP id l19-20020a170902d35300b00180be716773mr1580496plk.42.1668152950286;
        Thu, 10 Nov 2022 23:49:10 -0800 (PST)
Received: from [10.72.13.217] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p13-20020a17090b010d00b002009db534d1sm1000708pjz.24.2022.11.10.23.49.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 23:49:09 -0800 (PST)
Message-ID: <be553273-7c06-78f7-4d23-de9f46a210b1@redhat.com>
Date:   Fri, 11 Nov 2022 15:48:58 +0800
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
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <CAJaqyWemKoRNd6_uvFc79qYe+7pbavJSjnZuczxk5uxSZZdZ2Q@mail.gmail.com>
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


在 2022/11/10 21:47, Eugenio Perez Martin 写道:
> On Thu, Nov 10, 2022 at 7:01 AM Jason Wang <jasowang@redhat.com> wrote:
>> On Wed, Nov 9, 2022 at 1:08 AM Eugenio Pérez <eperezma@redhat.com> wrote:
>>> The memory listener that thells the device how to convert GPA to qemu's
>>> va is registered against CVQ vhost_vdpa. This series try to map the
>>> memory listener translations to ASID 0, while it maps the CVQ ones to
>>> ASID 1.
>>>
>>> Let's tell the listener if it needs to register them on iova tree or
>>> not.
>>>
>>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>>> ---
>>> v5: Solve conflict about vhost_iova_tree_remove accepting mem_region by
>>>      value.
>>> ---
>>>   include/hw/virtio/vhost-vdpa.h | 2 ++
>>>   hw/virtio/vhost-vdpa.c         | 6 +++---
>>>   net/vhost-vdpa.c               | 1 +
>>>   3 files changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost-vdpa.h
>>> index 6560bb9d78..0c3ed2d69b 100644
>>> --- a/include/hw/virtio/vhost-vdpa.h
>>> +++ b/include/hw/virtio/vhost-vdpa.h
>>> @@ -34,6 +34,8 @@ typedef struct vhost_vdpa {
>>>       struct vhost_vdpa_iova_range iova_range;
>>>       uint64_t acked_features;
>>>       bool shadow_vqs_enabled;
>>> +    /* The listener must send iova tree addresses, not GPA */


Btw, cindy's vIOMMU series will make it not necessarily GPA any more.


>>> +    bool listener_shadow_vq;
>>>       /* IOVA mapping used by the Shadow Virtqueue */
>>>       VhostIOVATree *iova_tree;
>>>       GPtrArray *shadow_vqs;
>>> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
>>> index 8fd32ba32b..e3914fa40e 100644
>>> --- a/hw/virtio/vhost-vdpa.c
>>> +++ b/hw/virtio/vhost-vdpa.c
>>> @@ -220,7 +220,7 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
>>>                                            vaddr, section->readonly);
>>>
>>>       llsize = int128_sub(llend, int128_make64(iova));
>>> -    if (v->shadow_vqs_enabled) {
>>> +    if (v->listener_shadow_vq) {
>>>           int r;
>>>
>>>           mem_region.translated_addr = (hwaddr)(uintptr_t)vaddr,
>>> @@ -247,7 +247,7 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
>>>       return;
>>>
>>>   fail_map:
>>> -    if (v->shadow_vqs_enabled) {
>>> +    if (v->listener_shadow_vq) {
>>>           vhost_iova_tree_remove(v->iova_tree, mem_region);
>>>       }
>>>
>>> @@ -292,7 +292,7 @@ static void vhost_vdpa_listener_region_del(MemoryListener *listener,
>>>
>>>       llsize = int128_sub(llend, int128_make64(iova));
>>>
>>> -    if (v->shadow_vqs_enabled) {
>>> +    if (v->listener_shadow_vq) {
>>>           const DMAMap *result;
>>>           const void *vaddr = memory_region_get_ram_ptr(section->mr) +
>>>               section->offset_within_region +
>>> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
>>> index 85a318faca..02780ee37b 100644
>>> --- a/net/vhost-vdpa.c
>>> +++ b/net/vhost-vdpa.c
>>> @@ -570,6 +570,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
>>>       s->vhost_vdpa.index = queue_pair_index;
>>>       s->always_svq = svq;
>>>       s->vhost_vdpa.shadow_vqs_enabled = svq;
>>> +    s->vhost_vdpa.listener_shadow_vq = svq;
>> Any chance those above two can differ?
>>
> If CVQ is shadowed but data VQs are not, shadow_vqs_enabled is true
> but listener_shadow_vq is not.
>
> It is more clear in the next commit, where only shadow_vqs_enabled is
> set to true at vhost_vdpa_net_cvq_start.


Ok, the name looks a little bit confusing. I wonder if it's better to 
use shadow_cvq and shadow_data ?

Thanks


>
> Thanks!
>
>> Thanks
>>
>>>       s->vhost_vdpa.iova_tree = iova_tree;
>>>       if (!is_datapath) {
>>>           s->cvq_cmd_out_buffer = qemu_memalign(qemu_real_host_page_size(),
>>> --
>>> 2.31.1
>>>

