Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041E3627544
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 05:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbiKNE3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 23:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbiKNE3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 23:29:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEB96588
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 20:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668400090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FnCPqOnBW63b7XhnZnGIx9/kne/rAammMftT5XFzR5g=;
        b=cfC6hP/FBf/gY3l7ty4Tr7/7Sby/A3Q1yT+kyX2OosdEYAxU4M6p11UaIj/nhbI2Jr6Km6
        a9VyzGmGYq6afBb5BSJ0/AoAycjV+77uhyM8KsBRxFVABrGXkaBPAN3WbOOz5lSKCk7jAA
        BWHEryEWi2wSpDVYkFKfBGIse+GpuVY=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-383-153U5ty_Peq0gShKWpnlNw-1; Sun, 13 Nov 2022 23:28:09 -0500
X-MC-Unique: 153U5ty_Peq0gShKWpnlNw-1
Received: by mail-pl1-f197.google.com with SMTP id e13-20020a17090301cd00b001871e6f8714so8142694plh.14
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 20:28:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FnCPqOnBW63b7XhnZnGIx9/kne/rAammMftT5XFzR5g=;
        b=u60cw2OeFblaXk4pISGZs70UpB5dCwT5t30f1dSKCZH2vdbOP627flu6snwzSjpqjP
         RaDW38vH5Lk87WgULJ0bX3elUtlTQ6zJ5Qp0oe2/r/p1zKkNXWU6iq+rTqzj6cOYHm9v
         2XA/7QhL7tVgH097i/zNkmm4itLuIUwUZdVXnxP8jzn9M3fIXnCwvqb1MbMLNSQcb9OV
         quvXV4hat8FGu/qt6etFcF6EsuqHEw1niSVAmJCLeqcknmi6IY9x8st4MuiX7wTS9q/e
         Oar3l3qg7PhWPqOZQcA/pBu7ZdwU8PMEXbioIEToB4nwjKtySOJRdJcXgmwDYa0ulC01
         Vpiw==
X-Gm-Message-State: ANoB5pm4ARGSN50AslQKqNngzT74OhPW9X4yXsCx/KzDH3taYmbeI5N2
        26IwOvYIPyd1O9STKEhXQZKl/wrh6LFYxy66G3GHWMcJJFCjaLMwCGxUnrY4BiVAuqgv8ihw3OA
        4VP9W20zx6pnp
X-Received: by 2002:aa7:8891:0:b0:562:9a93:7c91 with SMTP id z17-20020aa78891000000b005629a937c91mr12396622pfe.21.1668400086235;
        Sun, 13 Nov 2022 20:28:06 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4MSmogPA49SumDAra8YDZaD+LuGediWf2p+caEJdzTmcM8EfESj0XKWavlCI1S/GvM7VsnNA==
X-Received: by 2002:aa7:8891:0:b0:562:9a93:7c91 with SMTP id z17-20020aa78891000000b005629a937c91mr12396604pfe.21.1668400085859;
        Sun, 13 Nov 2022 20:28:05 -0800 (PST)
Received: from [10.72.13.180] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w13-20020a627b0d000000b0056ee49d6e95sm5525565pfc.86.2022.11.13.20.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Nov 2022 20:28:04 -0800 (PST)
Message-ID: <cbe9b99c-3a8a-7c73-155a-306c9a28972d@redhat.com>
Date:   Mon, 14 Nov 2022 12:27:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v6 07/10] vdpa: Add asid parameter to
 vhost_vdpa_dma_map/unmap
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
 <20221108170755.92768-8-eperezma@redhat.com>
 <CACGkMEvzw283JE9Uo6kqKuAJ4CWpWyHciHe8DazLEP5Xzw91wg@mail.gmail.com>
 <CAJaqyWcbYLzdEcPMMjDNWsGV4bkb8NTJnNHj5Wp+v4WbM+LHeQ@mail.gmail.com>
 <fa24552a-4d82-4da9-bf15-10d75893afa3@redhat.com>
 <CAJaqyWc3zjYxFHe6ucZNOKq0e_b_cNajh5CHzHNBnnRiwbNEHg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <CAJaqyWc3zjYxFHe6ucZNOKq0e_b_cNajh5CHzHNBnnRiwbNEHg@mail.gmail.com>
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


在 2022/11/11 21:02, Eugenio Perez Martin 写道:
> On Fri, Nov 11, 2022 at 8:41 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2022/11/10 21:22, Eugenio Perez Martin 写道:
>>> On Thu, Nov 10, 2022 at 6:51 AM Jason Wang <jasowang@redhat.com> wrote:
>>>> On Wed, Nov 9, 2022 at 1:08 AM Eugenio Pérez <eperezma@redhat.com> wrote:
>>>>> So the caller can choose which ASID is destined.
>>>>>
>>>>> No need to update the batch functions as they will always be called from
>>>>> memory listener updates at the moment. Memory listener updates will
>>>>> always update ASID 0, as it's the passthrough ASID.
>>>>>
>>>>> All vhost devices's ASID are 0 at this moment.
>>>>>
>>>>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>>>>> ---
>>>>> v5:
>>>>> * Solve conflict, now vhost_vdpa_svq_unmap_ring returns void
>>>>> * Change comment on zero initialization.
>>>>>
>>>>> v4: Add comment specifying behavior if device does not support _F_ASID
>>>>>
>>>>> v3: Deleted unneeded space
>>>>> ---
>>>>>    include/hw/virtio/vhost-vdpa.h |  8 +++++---
>>>>>    hw/virtio/vhost-vdpa.c         | 29 +++++++++++++++++++----------
>>>>>    net/vhost-vdpa.c               |  6 +++---
>>>>>    hw/virtio/trace-events         |  4 ++--
>>>>>    4 files changed, 29 insertions(+), 18 deletions(-)
>>>>>
>>>>> diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost-vdpa.h
>>>>> index 1111d85643..6560bb9d78 100644
>>>>> --- a/include/hw/virtio/vhost-vdpa.h
>>>>> +++ b/include/hw/virtio/vhost-vdpa.h
>>>>> @@ -29,6 +29,7 @@ typedef struct vhost_vdpa {
>>>>>        int index;
>>>>>        uint32_t msg_type;
>>>>>        bool iotlb_batch_begin_sent;
>>>>> +    uint32_t address_space_id;
>>>> So the trick is let device specific code to zero this during allocation?
>>>>
>>> Yes, but I don't see how that is a trick :). All other parameters also
>>> trust it to be 0 at allocation.
>>>
>>>>>        MemoryListener listener;
>>>>>        struct vhost_vdpa_iova_range iova_range;
>>>>>        uint64_t acked_features;
>>>>> @@ -42,8 +43,9 @@ typedef struct vhost_vdpa {
>>>>>        VhostVDPAHostNotifier notifier[VIRTIO_QUEUE_MAX];
>>>>>    } VhostVDPA;
>>>>>
>>>>> -int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
>>>>> -                       void *vaddr, bool readonly);
>>>>> -int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, hwaddr iova, hwaddr size);
>>>>> +int vhost_vdpa_dma_map(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
>>>>> +                       hwaddr size, void *vaddr, bool readonly);
>>>>> +int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
>>>>> +                         hwaddr size);
>>>>>
>>>>>    #endif
>>>>> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
>>>>> index 23efb8f49d..8fd32ba32b 100644
>>>>> --- a/hw/virtio/vhost-vdpa.c
>>>>> +++ b/hw/virtio/vhost-vdpa.c
>>>>> @@ -72,22 +72,24 @@ static bool vhost_vdpa_listener_skipped_section(MemoryRegionSection *section,
>>>>>        return false;
>>>>>    }
>>>>>
>>>>> -int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
>>>>> -                       void *vaddr, bool readonly)
>>>>> +int vhost_vdpa_dma_map(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
>>>>> +                       hwaddr size, void *vaddr, bool readonly)
>>>>>    {
>>>>>        struct vhost_msg_v2 msg = {};
>>>>>        int fd = v->device_fd;
>>>>>        int ret = 0;
>>>>>
>>>>>        msg.type = v->msg_type;
>>>>> +    msg.asid = asid; /* 0 if vdpa device does not support asid */
>>>> The comment here is confusing. If this is a requirement, we need either
>>>>
>>>> 1) doc this
>>>>
>>>> or
>>>>
>>>> 2) perform necessary checks in the function itself.
>>>>
>>> I only documented it in vhost_vdpa_dma_unmap and now I realize it.
>>> Would it work to just copy that comment here?
>>
>> Probably, and let's move the comment above the function definition.
>>
>>
>>>>>        msg.iotlb.iova = iova;
>>>>>        msg.iotlb.size = size;
>>>>>        msg.iotlb.uaddr = (uint64_t)(uintptr_t)vaddr;
>>>>>        msg.iotlb.perm = readonly ? VHOST_ACCESS_RO : VHOST_ACCESS_RW;
>>>>>        msg.iotlb.type = VHOST_IOTLB_UPDATE;
>>>>>
>>>>> -   trace_vhost_vdpa_dma_map(v, fd, msg.type, msg.iotlb.iova, msg.iotlb.size,
>>>>> -                            msg.iotlb.uaddr, msg.iotlb.perm, msg.iotlb.type);
>>>>> +    trace_vhost_vdpa_dma_map(v, fd, msg.type, msg.asid, msg.iotlb.iova,
>>>>> +                             msg.iotlb.size, msg.iotlb.uaddr, msg.iotlb.perm,
>>>>> +                             msg.iotlb.type);
>>>>>
>>>>>        if (write(fd, &msg, sizeof(msg)) != sizeof(msg)) {
>>>>>            error_report("failed to write, fd=%d, errno=%d (%s)",
>>>>> @@ -98,18 +100,24 @@ int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
>>>>>        return ret;
>>>>>    }
>>>>>
>>>>> -int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, hwaddr iova, hwaddr size)
>>>>> +int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
>>>>> +                         hwaddr size)
>>>>>    {
>>>>>        struct vhost_msg_v2 msg = {};
>>>>>        int fd = v->device_fd;
>>>>>        int ret = 0;
>>>>>
>>>>>        msg.type = v->msg_type;
>>>>> +    /*
>>>>> +     * The caller must set asid = 0 if the device does not support asid.
>>>>> +     * This is not an ABI break since it is set to 0 by the initializer anyway.
>>>>> +     */
>>>>> +    msg.asid = asid;
>>>>>        msg.iotlb.iova = iova;
>>>>>        msg.iotlb.size = size;
>>>>>        msg.iotlb.type = VHOST_IOTLB_INVALIDATE;
>>>>>
>>>>> -    trace_vhost_vdpa_dma_unmap(v, fd, msg.type, msg.iotlb.iova,
>>>>> +    trace_vhost_vdpa_dma_unmap(v, fd, msg.type, msg.asid, msg.iotlb.iova,
>>>>>                                   msg.iotlb.size, msg.iotlb.type);
>>>>>
>>>>>        if (write(fd, &msg, sizeof(msg)) != sizeof(msg)) {
>>>>> @@ -229,7 +237,7 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
>>>>>        }
>>>>>
>>>>>        vhost_vdpa_iotlb_batch_begin_once(v);
>>>>> -    ret = vhost_vdpa_dma_map(v, iova, int128_get64(llsize),
>>>>> +    ret = vhost_vdpa_dma_map(v, 0, iova, int128_get64(llsize),
>>>> Can we use v->address_space_id here? Then we don't need to modify this
>>>> line when we support multiple asids logic in the future.
>>>>
>>> The registered memory listener is the one of the last vhost_vdpa, the
>>> one that handles the last queue.
>>>
>>> If all data virtqueues are not shadowed but CVQ is,
>>> v->address_space_id is 1 with the current code.
>>
>> Ok, right. So let's add a comment here. It would be even better to
>> define the macro for data vq asid in this patch.
>>
> I agree that it must be changed to a macro.
>
> However, currently the _ASID macros belong to net/ . Maybe to declare
> VHOST_VDPA_GPA_ASID in include/hw/virtio/vhost-vdpa.h and just let
> VHOST_VDPA_NET_CVQ_ASID in net/vhost-vdpa.c?
>
> Thanks!


That should be fine.

Thanks


>
>> Thanks
>>
>>
>>>    But the listener is
>>> actually mapping the ASID 0, not 1.
>>>
>>> Another alternative is to register it to the last data virtqueue, not
>>> the last queue of vhost_vdpa. But it is hard to express it in a
>>> generic way at virtio/vhost-vdpa.c . To have a boolean indicating the
>>> vhost_vdpa we want to register its memory listener?
>>>
>>> It seems easier to me to simply assign 0 at GPA translations. If SVQ
>>> is enabled for all queues, then 0 is GPA to qemu's VA + SVQ stuff. If
>>> it is not, 0 is always GPA to qemu's VA.
>>>
>>> Thanks!
>>>
>>>> Thanks
>>>>
>>>>>                                 vaddr, section->readonly);
>>>>>        if (ret) {
>>>>>            error_report("vhost vdpa map fail!");
>>>>> @@ -303,7 +311,7 @@ static void vhost_vdpa_listener_region_del(MemoryListener *listener,
>>>>>            vhost_iova_tree_remove(v->iova_tree, *result);
>>>>>        }
>>>>>        vhost_vdpa_iotlb_batch_begin_once(v);
>>>>> -    ret = vhost_vdpa_dma_unmap(v, iova, int128_get64(llsize));
>>>>> +    ret = vhost_vdpa_dma_unmap(v, 0, iova, int128_get64(llsize));
>>>>>        if (ret) {
>>>>>            error_report("vhost_vdpa dma unmap error!");
>>>>>        }
>>>>> @@ -884,7 +892,7 @@ static void vhost_vdpa_svq_unmap_ring(struct vhost_vdpa *v, hwaddr addr)
>>>>>        }
>>>>>
>>>>>        size = ROUND_UP(result->size, qemu_real_host_page_size());
>>>>> -    r = vhost_vdpa_dma_unmap(v, result->iova, size);
>>>>> +    r = vhost_vdpa_dma_unmap(v, v->address_space_id, result->iova, size);
>>>>>        if (unlikely(r < 0)) {
>>>>>            error_report("Unable to unmap SVQ vring: %s (%d)", g_strerror(-r), -r);
>>>>>            return;
>>>>> @@ -924,7 +932,8 @@ static bool vhost_vdpa_svq_map_ring(struct vhost_vdpa *v, DMAMap *needle,
>>>>>            return false;
>>>>>        }
>>>>>
>>>>> -    r = vhost_vdpa_dma_map(v, needle->iova, needle->size + 1,
>>>>> +    r = vhost_vdpa_dma_map(v, v->address_space_id, needle->iova,
>>>>> +                           needle->size + 1,
>>>>>                               (void *)(uintptr_t)needle->translated_addr,
>>>>>                               needle->perm == IOMMU_RO);
>>>>>        if (unlikely(r != 0)) {
>>>>> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
>>>>> index fb35b17ab4..ca1acc0410 100644
>>>>> --- a/net/vhost-vdpa.c
>>>>> +++ b/net/vhost-vdpa.c
>>>>> @@ -258,7 +258,7 @@ static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
>>>>>            return;
>>>>>        }
>>>>>
>>>>> -    r = vhost_vdpa_dma_unmap(v, map->iova, map->size + 1);
>>>>> +    r = vhost_vdpa_dma_unmap(v, v->address_space_id, map->iova, map->size + 1);
>>>>>        if (unlikely(r != 0)) {
>>>>>            error_report("Device cannot unmap: %s(%d)", g_strerror(r), r);
>>>>>        }
>>>>> @@ -298,8 +298,8 @@ static int vhost_vdpa_cvq_map_buf(struct vhost_vdpa *v, void *buf, size_t size,
>>>>>            return r;
>>>>>        }
>>>>>
>>>>> -    r = vhost_vdpa_dma_map(v, map.iova, vhost_vdpa_net_cvq_cmd_page_len(), buf,
>>>>> -                           !write);
>>>>> +    r = vhost_vdpa_dma_map(v, v->address_space_id, map.iova,
>>>>> +                           vhost_vdpa_net_cvq_cmd_page_len(), buf, !write);
>>>>>        if (unlikely(r < 0)) {
>>>>>            goto dma_map_err;
>>>>>        }
>>>>> diff --git a/hw/virtio/trace-events b/hw/virtio/trace-events
>>>>> index 820dadc26c..0ad9390307 100644
>>>>> --- a/hw/virtio/trace-events
>>>>> +++ b/hw/virtio/trace-events
>>>>> @@ -30,8 +30,8 @@ vhost_user_write(uint32_t req, uint32_t flags) "req:%d flags:0x%"PRIx32""
>>>>>    vhost_user_create_notifier(int idx, void *n) "idx:%d n:%p"
>>>>>
>>>>>    # vhost-vdpa.c
>>>>> -vhost_vdpa_dma_map(void *vdpa, int fd, uint32_t msg_type, uint64_t iova, uint64_t size, uint64_t uaddr, uint8_t perm, uint8_t type) "vdpa:%p fd: %d msg_type: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" uaddr: 0x%"PRIx64" perm: 0x%"PRIx8" type: %"PRIu8
>>>>> -vhost_vdpa_dma_unmap(void *vdpa, int fd, uint32_t msg_type, uint64_t iova, uint64_t size, uint8_t type) "vdpa:%p fd: %d msg_type: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" type: %"PRIu8
>>>>> +vhost_vdpa_dma_map(void *vdpa, int fd, uint32_t msg_type, uint32_t asid, uint64_t iova, uint64_t size, uint64_t uaddr, uint8_t perm, uint8_t type) "vdpa:%p fd: %d msg_type: %"PRIu32" asid: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" uaddr: 0x%"PRIx64" perm: 0x%"PRIx8" type: %"PRIu8
>>>>> +vhost_vdpa_dma_unmap(void *vdpa, int fd, uint32_t msg_type, uint32_t asid, uint64_t iova, uint64_t size, uint8_t type) "vdpa:%p fd: %d msg_type: %"PRIu32" asid: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" type: %"PRIu8
>>>>>    vhost_vdpa_listener_begin_batch(void *v, int fd, uint32_t msg_type, uint8_t type)  "vdpa:%p fd: %d msg_type: %"PRIu32" type: %"PRIu8
>>>>>    vhost_vdpa_listener_commit(void *v, int fd, uint32_t msg_type, uint8_t type)  "vdpa:%p fd: %d msg_type: %"PRIu32" type: %"PRIu8
>>>>>    vhost_vdpa_listener_region_add(void *vdpa, uint64_t iova, uint64_t llend, void *vaddr, bool readonly) "vdpa: %p iova 0x%"PRIx64" llend 0x%"PRIx64" vaddr: %p read-only: %d"
>>>>> --
>>>>> 2.31.1
>>>>>

