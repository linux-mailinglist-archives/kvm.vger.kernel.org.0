Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019F4627552
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 05:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbiKNEhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 23:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbiKNEhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 23:37:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314409FC8
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 20:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668400598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GRiY7YQMSdxx6ibL7i3f+VdVahvCihAUjQkZxZ2V9ag=;
        b=H8TpkDoonKnXYJEOeLk/YaQpkhtsuHatUwKxbJ4TpmBqodixt4B3pb9ehQ8LoX9WCqWJKz
        MQBNuIwaj5LBfUEC0xA71ZXWnAhpO+fzfvwgmgNa9zkgVqC2nC6T5DdG6uHLssAdk/a1kp
        XTK5EAW/3zKdN4t41dpKRDYer6uIgcw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-226-5UR2aXQHMXuIqhjOBVLtCg-1; Sun, 13 Nov 2022 23:36:35 -0500
X-MC-Unique: 5UR2aXQHMXuIqhjOBVLtCg-1
Received: by mail-pj1-f71.google.com with SMTP id q93-20020a17090a1b6600b0021311ab9082so5161411pjq.7
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 20:36:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GRiY7YQMSdxx6ibL7i3f+VdVahvCihAUjQkZxZ2V9ag=;
        b=g04yiKI+RWthltCTqvnNnZG6fqEyX+YbtAZC8Bzfdhmzpp0vN7/HQvN4lIdOL+v74q
         thTus8Bi71yhNpFFk2OaIxJdBZpdEyDvrlUEyIJOXHNqLPG5fOC7rJSZUYWqo5G7z3/W
         iiMS1UQnx9+Qt+TFKV9LPJLGPjO9XjFlywFMgnNqeNNEdf6sAmYMvTA1EPZDzAmOIPh5
         RcckgnOWl+jtFFbWgmWbya20EQMff3l90Jtlv6Y7qAXpLh5d4rnfU4k9NIaPZ3+fPsBU
         4gUeVEapqM/RfKw0jVttYGEv9MV+lrnFZLIot0vLKtuikUyB4I9lKE5FWpuUPsDpiIr5
         b7rA==
X-Gm-Message-State: ANoB5pluENHFvHSS6Pu7P0KMzs0lGDsb4Jl1BEDUMfIJS5FwOdWPyBrf
        l/4LoRFnsT9+nFM/V8PBaQFoSjIETH39lxE9TIb8K3c+YPiUqy/BFGI61igwlRzBoKFrm84y8MG
        9TmVG1gTRi9W6
X-Received: by 2002:a63:fb4d:0:b0:45c:19bb:d225 with SMTP id w13-20020a63fb4d000000b0045c19bbd225mr10192472pgj.242.1668400593679;
        Sun, 13 Nov 2022 20:36:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6psz6SN5caI0DFohY9oT0ULbb/rSaowgWAtCPvcoZCjERYwe6Wb23ShgeWnjziL2y6vqBRJQ==
X-Received: by 2002:a63:fb4d:0:b0:45c:19bb:d225 with SMTP id w13-20020a63fb4d000000b0045c19bbd225mr10192455pgj.242.1668400593290;
        Sun, 13 Nov 2022 20:36:33 -0800 (PST)
Received: from [10.72.13.180] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z27-20020aa7991b000000b0056c2e497ad6sm5691431pff.93.2022.11.13.20.36.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Nov 2022 20:36:32 -0800 (PST)
Message-ID: <ff6f313b-be4a-9b13-609c-4b0d2f43d8b0@redhat.com>
Date:   Mon, 14 Nov 2022 12:36:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v6 10/10] vdpa: Always start CVQ in SVQ mode
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
 <20221108170755.92768-11-eperezma@redhat.com>
 <5eb848d8-eb27-4c27-377d-cb6edfe3718c@redhat.com>
 <CAJaqyWdj-EG==hs8D_G6rZOC=20V1fxoBwXqbeU119_EVtOWGw@mail.gmail.com>
 <4b1df7b5-2ecd-0ab2-3192-dfd76aafa5e4@redhat.com>
 <CAJaqyWe__Z9x+1NxCLd1a-8v6Bd43+xOVLSq2Qs807T4tVZoCw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <CAJaqyWe__Z9x+1NxCLd1a-8v6Bd43+xOVLSq2Qs807T4tVZoCw@mail.gmail.com>
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


在 2022/11/11 22:38, Eugenio Perez Martin 写道:
> On Fri, Nov 11, 2022 at 9:03 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2022/11/11 00:07, Eugenio Perez Martin 写道:
>>> On Thu, Nov 10, 2022 at 7:25 AM Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2022/11/9 01:07, Eugenio Pérez 写道:
>>>>> Isolate control virtqueue in its own group, allowing to intercept control
>>>>> commands but letting dataplane run totally passthrough to the guest.
>>>> I think we need to tweak the title to "vdpa: Always start CVQ in SVQ
>>>> mode if possible". Since SVQ for CVQ can't be enabled without ASID support?
>>>>
>>> Yes, I totally agree.
>>
>> Btw, I wonder if it's worth to remove the "x-" prefix for the shadow
>> virtqueue. It can help for the devices without ASID support but want do
>> live migration.
>>
> Sure I can propose on top.
>
>>>>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>>>>> ---
>>>>> v6:
>>>>> * Disable control SVQ if the device does not support it because of
>>>>> features.
>>>>>
>>>>> v5:
>>>>> * Fixing the not adding cvq buffers when x-svq=on is specified.
>>>>> * Move vring state in vhost_vdpa_get_vring_group instead of using a
>>>>>      parameter.
>>>>> * Rename VHOST_VDPA_NET_CVQ_PASSTHROUGH to VHOST_VDPA_NET_DATA_ASID
>>>>>
>>>>> v4:
>>>>> * Squash vhost_vdpa_cvq_group_is_independent.
>>>>> * Rebased on last CVQ start series, that allocated CVQ cmd bufs at load
>>>>> * Do not check for cvq index on vhost_vdpa_net_prepare, we only have one
>>>>>      that callback registered in that NetClientInfo.
>>>>>
>>>>> v3:
>>>>> * Make asid related queries print a warning instead of returning an
>>>>>      error and stop the start of qemu.
>>>>> ---
>>>>>     hw/virtio/vhost-vdpa.c |   3 +-
>>>>>     net/vhost-vdpa.c       | 138 ++++++++++++++++++++++++++++++++++++++---
>>>>>     2 files changed, 132 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
>>>>> index e3914fa40e..6401e7efb1 100644
>>>>> --- a/hw/virtio/vhost-vdpa.c
>>>>> +++ b/hw/virtio/vhost-vdpa.c
>>>>> @@ -648,7 +648,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_dev *dev)
>>>>>     {
>>>>>         uint64_t features;
>>>>>         uint64_t f = 0x1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2 |
>>>>> -        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH;
>>>>> +        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH |
>>>>> +        0x1ULL << VHOST_BACKEND_F_IOTLB_ASID;
>>>>>         int r;
>>>>>
>>>>>         if (vhost_vdpa_call(dev, VHOST_GET_BACKEND_FEATURES, &features)) {
>>>>> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
>>>>> index 02780ee37b..7245ea70c6 100644
>>>>> --- a/net/vhost-vdpa.c
>>>>> +++ b/net/vhost-vdpa.c
>>>>> @@ -38,6 +38,9 @@ typedef struct VhostVDPAState {
>>>>>         void *cvq_cmd_out_buffer;
>>>>>         virtio_net_ctrl_ack *status;
>>>>>
>>>>> +    /* Number of address spaces supported by the device */
>>>>> +    unsigned address_space_num;
>>>> I'm not sure this is the best place to store thing like this since it
>>>> can cause confusion. We will have multiple VhostVDPAState when
>>>> multiqueue is enabled.
>>>>
>>> I think we can delete this and ask it on each device start.
>>>
>>>>> +
>>>>>         /* The device always have SVQ enabled */
>>>>>         bool always_svq;
>>>>>         bool started;
>>>>> @@ -101,6 +104,9 @@ static const uint64_t vdpa_svq_device_features =
>>>>>         BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
>>>>>         BIT_ULL(VIRTIO_NET_F_STANDBY);
>>>>>
>>>>> +#define VHOST_VDPA_NET_DATA_ASID 0
>>>>> +#define VHOST_VDPA_NET_CVQ_ASID 1
>>>>> +
>>>>>     VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
>>>>>     {
>>>>>         VhostVDPAState *s = DO_UPCAST(VhostVDPAState, nc, nc);
>>>>> @@ -242,6 +248,34 @@ static NetClientInfo net_vhost_vdpa_info = {
>>>>>             .check_peer_type = vhost_vdpa_check_peer_type,
>>>>>     };
>>>>>
>>>>> +static uint32_t vhost_vdpa_get_vring_group(int device_fd, unsigned vq_index)
>>>>> +{
>>>>> +    struct vhost_vring_state state = {
>>>>> +        .index = vq_index,
>>>>> +    };
>>>>> +    int r = ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, &state);
>>>>> +
>>>>> +    return r < 0 ? 0 : state.num;
>>>> Assume 0 when ioctl() fail is probably not a good idea: errors in ioctl
>>>> might be hidden. It would be better to fallback to 0 when ASID is not
>>>> supported.
>>>>
>>> Did I misunderstand you on [1]?
>>
>> Nope. I think I was wrong at that time then :( Sorry for that.
>>
>> We should differ from the case
>>
>> 1) no ASID support so 0 is assumed
>>
>> 2) something wrong in the case of ioctl, it's not necessarily a ENOTSUPP.
>>
> What action should we take here? Isn't it better to disable SVQ and
> let the device run?


It should fail the function instead of assuming 0 like how other vhost 
ioctl work.


>
>>>>> +}
>>>>> +
>>>>> +static int vhost_vdpa_set_address_space_id(struct vhost_vdpa *v,
>>>>> +                                           unsigned vq_group,
>>>>> +                                           unsigned asid_num)
>>>>> +{
>>>>> +    struct vhost_vring_state asid = {
>>>>> +        .index = vq_group,
>>>>> +        .num = asid_num,
>>>>> +    };
>>>>> +    int ret;
>>>>> +
>>>>> +    ret = ioctl(v->device_fd, VHOST_VDPA_SET_GROUP_ASID, &asid);
>>>>> +    if (unlikely(ret < 0)) {
>>>>> +        warn_report("Can't set vq group %u asid %u, errno=%d (%s)",
>>>>> +            asid.index, asid.num, errno, g_strerror(errno));
>>>>> +    }
>>>>> +    return ret;
>>>>> +}
>>>>> +
>>>>>     static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
>>>>>     {
>>>>>         VhostIOVATree *tree = v->iova_tree;
>>>>> @@ -316,11 +350,54 @@ dma_map_err:
>>>>>     static int vhost_vdpa_net_cvq_start(NetClientState *nc)
>>>>>     {
>>>>>         VhostVDPAState *s;
>>>>> -    int r;
>>>>> +    struct vhost_vdpa *v;
>>>>> +    uint32_t cvq_group;
>>>>> +    int cvq_index, r;
>>>>>
>>>>>         assert(nc->info->type == NET_CLIENT_DRIVER_VHOST_VDPA);
>>>>>
>>>>>         s = DO_UPCAST(VhostVDPAState, nc, nc);
>>>>> +    v = &s->vhost_vdpa;
>>>>> +
>>>>> +    v->listener_shadow_vq = s->always_svq;
>>>>> +    v->shadow_vqs_enabled = s->always_svq;
>>>>> +    s->vhost_vdpa.address_space_id = VHOST_VDPA_NET_DATA_ASID;
>>>>> +
>>>>> +    if (s->always_svq) {
>>>>> +        goto out;
>>>>> +    }
>>>>> +
>>>>> +    if (s->address_space_num < 2) {
>>>>> +        return 0;
>>>>> +    }
>>>>> +
>>>>> +    if (!vhost_vdpa_net_valid_svq_features(v->dev->features, NULL)) {
>>>>> +        return 0;
>>>>> +    }
>>>> Any reason we do the above check during the start/stop? It should be
>>>> easier to do that in the initialization.
>>>>
>>> We can store it as a member of VhostVDPAState maybe? They will be
>>> duplicated like the current number of AS.
>>
>> I meant each VhostVDPAState just need to know the ASID it needs to use.
>> There's no need to know the total number of address spaces or do the
>> validation on it during start (the validation could be done during
>> initialization).
>>
> I thought we were talking about the virtio features.
>
> So let's omit this check and simply try to set ASID? The worst case is
> an -ENOTSUPP or -EINVAL, so the actions to take are the same as if we
> don't have enough AS.


See the discussion in other thread:

1) do the probing of asid stuffs during initalization, we can simply try 
to set the ASID here and fail the vhost dev start
2) do the probing each time during vhost start

Personally I like 1, but if you want to go with 2 it should also fine. 
(need some comments)


>
>>>>> +
>>>>> +    /**
>>>>> +     * Check if all the virtqueues of the virtio device are in a different vq
>>>>> +     * than the last vq. VQ group of last group passed in cvq_group.
>>>>> +     */
>>>>> +    cvq_index = v->dev->vq_index_end - 1;
>>>>> +    cvq_group = vhost_vdpa_get_vring_group(v->device_fd, cvq_index);
>>>>> +    for (int i = 0; i < cvq_index; ++i) {
>>>>> +        uint32_t group = vhost_vdpa_get_vring_group(v->device_fd, i);
>>>>> +
>>>>> +        if (unlikely(group == cvq_group)) {
>>>>> +            warn_report("CVQ %u group is the same as VQ %u one (%u)", cvq_group,
>>>>> +                        i, group);
>>>>> +            return 0;
>>>>> +        }
>>>>> +    }
>>>>> +
>>>>> +    r = vhost_vdpa_set_address_space_id(v, cvq_group, VHOST_VDPA_NET_CVQ_ASID);
>>>>> +    if (r == 0) {
>>>>> +        v->shadow_vqs_enabled = true;
>>>>> +        s->vhost_vdpa.address_space_id = VHOST_VDPA_NET_CVQ_ASID;
>>>>> +    }
>>>>> +
>>>>> +out:
>>>>>         if (!s->vhost_vdpa.shadow_vqs_enabled) {
>>>>>             return 0;
>>>>>         }
>>>>> @@ -542,12 +619,38 @@ static const VhostShadowVirtqueueOps vhost_vdpa_net_svq_ops = {
>>>>>         .avail_handler = vhost_vdpa_net_handle_ctrl_avail,
>>>>>     };
>>>>>
>>>>> +static uint32_t vhost_vdpa_get_as_num(int vdpa_device_fd)
>>>>> +{
>>>>> +    uint64_t features;
>>>>> +    unsigned num_as;
>>>>> +    int r;
>>>>> +
>>>>> +    r = ioctl(vdpa_device_fd, VHOST_GET_BACKEND_FEATURES, &features);
>>>>> +    if (unlikely(r < 0)) {
>>>>> +        warn_report("Cannot get backend features");
>>>>> +        return 1;
>>>>> +    }
>>>>> +
>>>>> +    if (!(features & BIT_ULL(VHOST_BACKEND_F_IOTLB_ASID))) {
>>>>> +        return 1;
>>>>> +    }
>>>>> +
>>>>> +    r = ioctl(vdpa_device_fd, VHOST_VDPA_GET_AS_NUM, &num_as);
>>>>> +    if (unlikely(r < 0)) {
>>>>> +        warn_report("Cannot retrieve number of supported ASs");
>>>>> +        return 1;
>>>> Let's return error here. This help. to identify bugs of qemu or kernel.
>>>>
>>> Same comment as with VHOST_VDPA_GET_VRING_GROUP.
>>>
>>>>> +    }
>>>>> +
>>>>> +    return num_as;
>>>>> +}
>>>>> +
>>>>>     static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
>>>>>                                                const char *device,
>>>>>                                                const char *name,
>>>>>                                                int vdpa_device_fd,
>>>>>                                                int queue_pair_index,
>>>>>                                                int nvqs,
>>>>> +                                           unsigned nas,
>>>>>                                                bool is_datapath,
>>>>>                                                bool svq,
>>>>>                                                VhostIOVATree *iova_tree)
>>>>> @@ -566,6 +669,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
>>>>>         qemu_set_info_str(nc, TYPE_VHOST_VDPA);
>>>>>         s = DO_UPCAST(VhostVDPAState, nc, nc);
>>>>>
>>>>> +    s->address_space_num = nas;
>>>>>         s->vhost_vdpa.device_fd = vdpa_device_fd;
>>>>>         s->vhost_vdpa.index = queue_pair_index;
>>>>>         s->always_svq = svq;
>>>>> @@ -652,6 +756,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>>>>>         g_autoptr(VhostIOVATree) iova_tree = NULL;
>>>>>         NetClientState *nc;
>>>>>         int queue_pairs, r, i = 0, has_cvq = 0;
>>>>> +    unsigned num_as = 1;
>>>>> +    bool svq_cvq;
>>>>>
>>>>>         assert(netdev->type == NET_CLIENT_DRIVER_VHOST_VDPA);
>>>>>         opts = &netdev->u.vhost_vdpa;
>>>>> @@ -693,12 +799,28 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>>>>>             return queue_pairs;
>>>>>         }
>>>>>
>>>>> -    if (opts->x_svq) {
>>>>> -        struct vhost_vdpa_iova_range iova_range;
>>>>> +    svq_cvq = opts->x_svq;
>>>>> +    if (has_cvq && !opts->x_svq) {
>>>>> +        num_as = vhost_vdpa_get_as_num(vdpa_device_fd);
>>>>> +        svq_cvq = num_as > 1;
>>>>> +    }
>>>> The above check is not easy to follow, how about?
>>>>
>>>> svq_cvq = vhost_vdpa_get_as_num() > 1 ? true : opts->x_svq;
>>>>
>>> That would allocate the iova tree even if CVQ is not used in the
>>> guest. And num_as is reused later, although we can ask it to the
>>> device at device start to avoid this.
>>
>> Ok.
>>
>>
>>> If any, the linear conversion would be:
>>> svq_cvq = opts->x_svq || (has_cvq && vhost_vdpa_get_as_num(vdpa_device_fd))
>>>
>>> So we avoid the AS_NUM ioctl if not needed.
>>
>> So when !opts->x_svq, we need to check num_as is at least 2?
>>
> As I think you proposed, we can simply try to set CVQ ASID and react to -EINVAL.
>
> But this code here is trying to not to allocate iova_tree if we're
> sure it will not be needed. Maybe it is easier to always allocate the
> empty iova tree and only fill it if needed?


I feel it should work.


>
>>>>> +
>>>>> +    if (opts->x_svq || svq_cvq) {
>>>> Any chance we can have opts->x_svq = true but svq_cvq = false? Checking
>>>> svq_cvq seems sufficient here.
>>>>
>>> The reverse is possible, to have svq_cvq but no opts->x_svq.
>>>
>>> Depending on that, this code emits a warning or a fatal error.
>>
>> Ok, as replied in the previous patch, I think we need a better name for
>> those ones.
>>
> cvq_svq can be renamed for sure. x_svq can be aliased with other
> variable if needed too.
>
>> if (opts->x_svq) {
>>           shadow_data_vq = true;
>>           if(has_cvq) shadow_cvq = true;
>> } else if (num_as >= 2 && has_cvq) {
>>           shadow_cvq = true;
>> }
>>
>> The other logic can just check shadow_cvq or shadow_data_vq individually.
>>
> Not sure if shadow_data_vq is accurate. It sounds to me as "Only
> shadow data virtqueues but not CVQ".
>
> shadow_device and shadow_cvq?


Should work, let's see.

Thanks


>
>>>>> +        Error *warn = NULL;
>>>>>
>>>>> -        if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
>>>>> -            goto err_svq;
>>>>> +        svq_cvq = vhost_vdpa_net_valid_svq_features(features,
>>>>> +                                                   opts->x_svq ? errp : &warn);
>>>>> +        if (!svq_cvq) {
>>>> Same question as above.
>>>>
>>>>
>>>>> +            if (opts->x_svq) {
>>>>> +                goto err_svq;
>>>>> +            } else {
>>>>> +                warn_reportf_err(warn, "Cannot shadow CVQ: ");
>>>>> +            }
>>>>>             }
>>>>> +    }
>>>>> +
>>>>> +    if (opts->x_svq || svq_cvq) {
>>>>> +        struct vhost_vdpa_iova_range iova_range;
>>>>>
>>>>>             vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
>>>>>             iova_tree = vhost_iova_tree_new(iova_range.first, iova_range.last);
>>>>> @@ -708,15 +830,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>>>>>
>>>>>         for (i = 0; i < queue_pairs; i++) {
>>>>>             ncs[i] = net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
>>>>> -                                     vdpa_device_fd, i, 2, true, opts->x_svq,
>>>>> -                                     iova_tree);
>>>>> +                                     vdpa_device_fd, i, 2, num_as, true,
>>>> I don't get why we need pass num_as to a specific vhost_vdpa structure.
>>>> It should be sufficient to pass asid there.
>>>>
>>> ASID is not known at this time, but at device's start. This is because
>>> we cannot ask if the CVQ is in its own vq group, because we don't know
>>> the control virtqueue index until the guest acknowledges the different
>>> features.
>>
>> We can probe those during initialization I think. E.g doing some
>> negotiation in the initialization phase.
>>
> We've developed this idea in other threads, let's continue there better.
>
> Thanks!
>
>> Thanks
>>
>>
>>> Thanks!
>>>
>>> [1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg901685.html
>>>
>>>
>>>>> +                                     opts->x_svq, iova_tree);
>>>>>             if (!ncs[i])
>>>>>                 goto err;
>>>>>         }
>>>>>
>>>>>         if (has_cvq) {
>>>>>             nc = net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
>>>>> -                                 vdpa_device_fd, i, 1, false,
>>>>> +                                 vdpa_device_fd, i, 1, num_as, false,
>>>>>                                      opts->x_svq, iova_tree);
>>>>>             if (!nc)
>>>>>                 goto err;

