Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E661D6254DA
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 09:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbiKKIEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 03:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiKKIEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 03:04:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91FE79D08
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 00:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668153798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rEUy60sGJn4uSKUUOZoJ3F9IxBx/WMny2Uoi4AmXg70=;
        b=UYDXqpkb3gFezKMo3NBHX4gRsF8HBwHAJj4PbIciZTi3XKX9qIQN/xz1PKOdaPudaZ66Jx
        huUbE2zOqQN5MKC1UlyCvz0kKFsL3DsRCe+8tgNYjzW1ioiKFRj5SE1i6NIY10qD6CcAIq
        CR6j01nWoXpDv9hKhbzfRrmwndOhqVw=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-213-Dec3LchFN4mHGpiXn_SIqw-1; Fri, 11 Nov 2022 03:03:16 -0500
X-MC-Unique: Dec3LchFN4mHGpiXn_SIqw-1
Received: by mail-pj1-f72.google.com with SMTP id m1-20020a17090a5a4100b002138550729dso2418317pji.2
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 00:03:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rEUy60sGJn4uSKUUOZoJ3F9IxBx/WMny2Uoi4AmXg70=;
        b=NwpT3TTm7eLnSH+/rdIkYyCaCrSh89bowzy7GePkNHq8oOX34vj4FHJ55sWdLO9dgP
         eUtmg3Ymxb3+DXSTIOPv/j3P4Yu80IfYX+kfkvyaLQFXvWAMEbxVIzgnw5FkDrHweNAT
         kG+j7239wN6M+bR+ykciYuHxp86/H7KL385wpM8vsAZ3NmLgkkV7+8AHNvnHr6SkpQSt
         P/ZOhuKFC2yQRvKtJXM6mZDPtIFzjMph4FXQ+Yow60AXOEzU0N7e3ceCMcUTUN4OCmKm
         2zWsYbW8mtqDM4B8WwXg9IHERG6axRcKw5Q5BveXEdlvDg6EjeLtwgDHJ1KRmvXenenr
         /y5A==
X-Gm-Message-State: ANoB5plHSfv32+9Axs7TmVBJGUqjSG/YCDWUgXDrteiGHh6mO1EOCvLI
        6jGdEUtndLf0xSVpuuX01e1uAzi3zpBC3abl9S14x7boMFcjz9VHnk2zF0f/NK1rfL5fPhgZShx
        yW0/ruhWRyeyT
X-Received: by 2002:a17:90a:cb0e:b0:210:f235:1151 with SMTP id z14-20020a17090acb0e00b00210f2351151mr662614pjt.230.1668153795362;
        Fri, 11 Nov 2022 00:03:15 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4K3dah0E+bdbcOHV8L2q/f8SGTeUIM2jLPHuikhaxJk4voLdsXT3Io9WFmJEWgxWAkOIFxig==
X-Received: by 2002:a17:90a:cb0e:b0:210:f235:1151 with SMTP id z14-20020a17090acb0e00b00210f2351151mr662567pjt.230.1668153794887;
        Fri, 11 Nov 2022 00:03:14 -0800 (PST)
Received: from [10.72.13.217] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h4-20020a170902680400b0017b264a2d4asm1022537plk.44.2022.11.11.00.03.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 00:03:13 -0800 (PST)
Message-ID: <4b1df7b5-2ecd-0ab2-3192-dfd76aafa5e4@redhat.com>
Date:   Fri, 11 Nov 2022 16:02:58 +0800
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
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <CAJaqyWdj-EG==hs8D_G6rZOC=20V1fxoBwXqbeU119_EVtOWGw@mail.gmail.com>
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


在 2022/11/11 00:07, Eugenio Perez Martin 写道:
> On Thu, Nov 10, 2022 at 7:25 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2022/11/9 01:07, Eugenio Pérez 写道:
>>> Isolate control virtqueue in its own group, allowing to intercept control
>>> commands but letting dataplane run totally passthrough to the guest.
>>
>> I think we need to tweak the title to "vdpa: Always start CVQ in SVQ
>> mode if possible". Since SVQ for CVQ can't be enabled without ASID support?
>>
> Yes, I totally agree.


Btw, I wonder if it's worth to remove the "x-" prefix for the shadow 
virtqueue. It can help for the devices without ASID support but want do 
live migration.


>
>>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>>> ---
>>> v6:
>>> * Disable control SVQ if the device does not support it because of
>>> features.
>>>
>>> v5:
>>> * Fixing the not adding cvq buffers when x-svq=on is specified.
>>> * Move vring state in vhost_vdpa_get_vring_group instead of using a
>>>     parameter.
>>> * Rename VHOST_VDPA_NET_CVQ_PASSTHROUGH to VHOST_VDPA_NET_DATA_ASID
>>>
>>> v4:
>>> * Squash vhost_vdpa_cvq_group_is_independent.
>>> * Rebased on last CVQ start series, that allocated CVQ cmd bufs at load
>>> * Do not check for cvq index on vhost_vdpa_net_prepare, we only have one
>>>     that callback registered in that NetClientInfo.
>>>
>>> v3:
>>> * Make asid related queries print a warning instead of returning an
>>>     error and stop the start of qemu.
>>> ---
>>>    hw/virtio/vhost-vdpa.c |   3 +-
>>>    net/vhost-vdpa.c       | 138 ++++++++++++++++++++++++++++++++++++++---
>>>    2 files changed, 132 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
>>> index e3914fa40e..6401e7efb1 100644
>>> --- a/hw/virtio/vhost-vdpa.c
>>> +++ b/hw/virtio/vhost-vdpa.c
>>> @@ -648,7 +648,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_dev *dev)
>>>    {
>>>        uint64_t features;
>>>        uint64_t f = 0x1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2 |
>>> -        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH;
>>> +        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH |
>>> +        0x1ULL << VHOST_BACKEND_F_IOTLB_ASID;
>>>        int r;
>>>
>>>        if (vhost_vdpa_call(dev, VHOST_GET_BACKEND_FEATURES, &features)) {
>>> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
>>> index 02780ee37b..7245ea70c6 100644
>>> --- a/net/vhost-vdpa.c
>>> +++ b/net/vhost-vdpa.c
>>> @@ -38,6 +38,9 @@ typedef struct VhostVDPAState {
>>>        void *cvq_cmd_out_buffer;
>>>        virtio_net_ctrl_ack *status;
>>>
>>> +    /* Number of address spaces supported by the device */
>>> +    unsigned address_space_num;
>>
>> I'm not sure this is the best place to store thing like this since it
>> can cause confusion. We will have multiple VhostVDPAState when
>> multiqueue is enabled.
>>
> I think we can delete this and ask it on each device start.
>
>>> +
>>>        /* The device always have SVQ enabled */
>>>        bool always_svq;
>>>        bool started;
>>> @@ -101,6 +104,9 @@ static const uint64_t vdpa_svq_device_features =
>>>        BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
>>>        BIT_ULL(VIRTIO_NET_F_STANDBY);
>>>
>>> +#define VHOST_VDPA_NET_DATA_ASID 0
>>> +#define VHOST_VDPA_NET_CVQ_ASID 1
>>> +
>>>    VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
>>>    {
>>>        VhostVDPAState *s = DO_UPCAST(VhostVDPAState, nc, nc);
>>> @@ -242,6 +248,34 @@ static NetClientInfo net_vhost_vdpa_info = {
>>>            .check_peer_type = vhost_vdpa_check_peer_type,
>>>    };
>>>
>>> +static uint32_t vhost_vdpa_get_vring_group(int device_fd, unsigned vq_index)
>>> +{
>>> +    struct vhost_vring_state state = {
>>> +        .index = vq_index,
>>> +    };
>>> +    int r = ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, &state);
>>> +
>>> +    return r < 0 ? 0 : state.num;
>>
>> Assume 0 when ioctl() fail is probably not a good idea: errors in ioctl
>> might be hidden. It would be better to fallback to 0 when ASID is not
>> supported.
>>
> Did I misunderstand you on [1]?


Nope. I think I was wrong at that time then :( Sorry for that.

We should differ from the case

1) no ASID support so 0 is assumed

2) something wrong in the case of ioctl, it's not necessarily a ENOTSUPP.


>
>>> +}
>>> +
>>> +static int vhost_vdpa_set_address_space_id(struct vhost_vdpa *v,
>>> +                                           unsigned vq_group,
>>> +                                           unsigned asid_num)
>>> +{
>>> +    struct vhost_vring_state asid = {
>>> +        .index = vq_group,
>>> +        .num = asid_num,
>>> +    };
>>> +    int ret;
>>> +
>>> +    ret = ioctl(v->device_fd, VHOST_VDPA_SET_GROUP_ASID, &asid);
>>> +    if (unlikely(ret < 0)) {
>>> +        warn_report("Can't set vq group %u asid %u, errno=%d (%s)",
>>> +            asid.index, asid.num, errno, g_strerror(errno));
>>> +    }
>>> +    return ret;
>>> +}
>>> +
>>>    static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
>>>    {
>>>        VhostIOVATree *tree = v->iova_tree;
>>> @@ -316,11 +350,54 @@ dma_map_err:
>>>    static int vhost_vdpa_net_cvq_start(NetClientState *nc)
>>>    {
>>>        VhostVDPAState *s;
>>> -    int r;
>>> +    struct vhost_vdpa *v;
>>> +    uint32_t cvq_group;
>>> +    int cvq_index, r;
>>>
>>>        assert(nc->info->type == NET_CLIENT_DRIVER_VHOST_VDPA);
>>>
>>>        s = DO_UPCAST(VhostVDPAState, nc, nc);
>>> +    v = &s->vhost_vdpa;
>>> +
>>> +    v->listener_shadow_vq = s->always_svq;
>>> +    v->shadow_vqs_enabled = s->always_svq;
>>> +    s->vhost_vdpa.address_space_id = VHOST_VDPA_NET_DATA_ASID;
>>> +
>>> +    if (s->always_svq) {
>>> +        goto out;
>>> +    }
>>> +
>>> +    if (s->address_space_num < 2) {
>>> +        return 0;
>>> +    }
>>> +
>>> +    if (!vhost_vdpa_net_valid_svq_features(v->dev->features, NULL)) {
>>> +        return 0;
>>> +    }
>>
>> Any reason we do the above check during the start/stop? It should be
>> easier to do that in the initialization.
>>
> We can store it as a member of VhostVDPAState maybe? They will be
> duplicated like the current number of AS.


I meant each VhostVDPAState just need to know the ASID it needs to use. 
There's no need to know the total number of address spaces or do the 
validation on it during start (the validation could be done during 
initialization).


>
>>> +
>>> +    /**
>>> +     * Check if all the virtqueues of the virtio device are in a different vq
>>> +     * than the last vq. VQ group of last group passed in cvq_group.
>>> +     */
>>> +    cvq_index = v->dev->vq_index_end - 1;
>>> +    cvq_group = vhost_vdpa_get_vring_group(v->device_fd, cvq_index);
>>> +    for (int i = 0; i < cvq_index; ++i) {
>>> +        uint32_t group = vhost_vdpa_get_vring_group(v->device_fd, i);
>>> +
>>> +        if (unlikely(group == cvq_group)) {
>>> +            warn_report("CVQ %u group is the same as VQ %u one (%u)", cvq_group,
>>> +                        i, group);
>>> +            return 0;
>>> +        }
>>> +    }
>>> +
>>> +    r = vhost_vdpa_set_address_space_id(v, cvq_group, VHOST_VDPA_NET_CVQ_ASID);
>>> +    if (r == 0) {
>>> +        v->shadow_vqs_enabled = true;
>>> +        s->vhost_vdpa.address_space_id = VHOST_VDPA_NET_CVQ_ASID;
>>> +    }
>>> +
>>> +out:
>>>        if (!s->vhost_vdpa.shadow_vqs_enabled) {
>>>            return 0;
>>>        }
>>> @@ -542,12 +619,38 @@ static const VhostShadowVirtqueueOps vhost_vdpa_net_svq_ops = {
>>>        .avail_handler = vhost_vdpa_net_handle_ctrl_avail,
>>>    };
>>>
>>> +static uint32_t vhost_vdpa_get_as_num(int vdpa_device_fd)
>>> +{
>>> +    uint64_t features;
>>> +    unsigned num_as;
>>> +    int r;
>>> +
>>> +    r = ioctl(vdpa_device_fd, VHOST_GET_BACKEND_FEATURES, &features);
>>> +    if (unlikely(r < 0)) {
>>> +        warn_report("Cannot get backend features");
>>> +        return 1;
>>> +    }
>>> +
>>> +    if (!(features & BIT_ULL(VHOST_BACKEND_F_IOTLB_ASID))) {
>>> +        return 1;
>>> +    }
>>> +
>>> +    r = ioctl(vdpa_device_fd, VHOST_VDPA_GET_AS_NUM, &num_as);
>>> +    if (unlikely(r < 0)) {
>>> +        warn_report("Cannot retrieve number of supported ASs");
>>> +        return 1;
>>
>> Let's return error here. This help. to identify bugs of qemu or kernel.
>>
> Same comment as with VHOST_VDPA_GET_VRING_GROUP.
>
>>> +    }
>>> +
>>> +    return num_as;
>>> +}
>>> +
>>>    static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
>>>                                               const char *device,
>>>                                               const char *name,
>>>                                               int vdpa_device_fd,
>>>                                               int queue_pair_index,
>>>                                               int nvqs,
>>> +                                           unsigned nas,
>>>                                               bool is_datapath,
>>>                                               bool svq,
>>>                                               VhostIOVATree *iova_tree)
>>> @@ -566,6 +669,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
>>>        qemu_set_info_str(nc, TYPE_VHOST_VDPA);
>>>        s = DO_UPCAST(VhostVDPAState, nc, nc);
>>>
>>> +    s->address_space_num = nas;
>>>        s->vhost_vdpa.device_fd = vdpa_device_fd;
>>>        s->vhost_vdpa.index = queue_pair_index;
>>>        s->always_svq = svq;
>>> @@ -652,6 +756,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>>>        g_autoptr(VhostIOVATree) iova_tree = NULL;
>>>        NetClientState *nc;
>>>        int queue_pairs, r, i = 0, has_cvq = 0;
>>> +    unsigned num_as = 1;
>>> +    bool svq_cvq;
>>>
>>>        assert(netdev->type == NET_CLIENT_DRIVER_VHOST_VDPA);
>>>        opts = &netdev->u.vhost_vdpa;
>>> @@ -693,12 +799,28 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>>>            return queue_pairs;
>>>        }
>>>
>>> -    if (opts->x_svq) {
>>> -        struct vhost_vdpa_iova_range iova_range;
>>> +    svq_cvq = opts->x_svq;
>>> +    if (has_cvq && !opts->x_svq) {
>>> +        num_as = vhost_vdpa_get_as_num(vdpa_device_fd);
>>> +        svq_cvq = num_as > 1;
>>> +    }
>>
>> The above check is not easy to follow, how about?
>>
>> svq_cvq = vhost_vdpa_get_as_num() > 1 ? true : opts->x_svq;
>>
> That would allocate the iova tree even if CVQ is not used in the
> guest. And num_as is reused later, although we can ask it to the
> device at device start to avoid this.


Ok.


>
> If any, the linear conversion would be:
> svq_cvq = opts->x_svq || (has_cvq && vhost_vdpa_get_as_num(vdpa_device_fd))
>
> So we avoid the AS_NUM ioctl if not needed.


So when !opts->x_svq, we need to check num_as is at least 2?


>
>>> +
>>> +    if (opts->x_svq || svq_cvq) {
>>
>> Any chance we can have opts->x_svq = true but svq_cvq = false? Checking
>> svq_cvq seems sufficient here.
>>
> The reverse is possible, to have svq_cvq but no opts->x_svq.
>
> Depending on that, this code emits a warning or a fatal error.


Ok, as replied in the previous patch, I think we need a better name for 
those ones.

if (opts->x_svq) {
         shadow_data_vq = true;
         if(has_cvq) shadow_cvq = true;
} else if (num_as >= 2 && has_cvq) {
         shadow_cvq = true;
}

The other logic can just check shadow_cvq or shadow_data_vq individually.


>
>>> +        Error *warn = NULL;
>>>
>>> -        if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
>>> -            goto err_svq;
>>> +        svq_cvq = vhost_vdpa_net_valid_svq_features(features,
>>> +                                                   opts->x_svq ? errp : &warn);
>>> +        if (!svq_cvq) {
>>
>> Same question as above.
>>
>>
>>> +            if (opts->x_svq) {
>>> +                goto err_svq;
>>> +            } else {
>>> +                warn_reportf_err(warn, "Cannot shadow CVQ: ");
>>> +            }
>>>            }
>>> +    }
>>> +
>>> +    if (opts->x_svq || svq_cvq) {
>>> +        struct vhost_vdpa_iova_range iova_range;
>>>
>>>            vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
>>>            iova_tree = vhost_iova_tree_new(iova_range.first, iova_range.last);
>>> @@ -708,15 +830,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>>>
>>>        for (i = 0; i < queue_pairs; i++) {
>>>            ncs[i] = net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
>>> -                                     vdpa_device_fd, i, 2, true, opts->x_svq,
>>> -                                     iova_tree);
>>> +                                     vdpa_device_fd, i, 2, num_as, true,
>>
>> I don't get why we need pass num_as to a specific vhost_vdpa structure.
>> It should be sufficient to pass asid there.
>>
> ASID is not known at this time, but at device's start. This is because
> we cannot ask if the CVQ is in its own vq group, because we don't know
> the control virtqueue index until the guest acknowledges the different
> features.


We can probe those during initialization I think. E.g doing some 
negotiation in the initialization phase.

Thanks


>
> Thanks!
>
> [1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg901685.html
>
>
>>> +                                     opts->x_svq, iova_tree);
>>>            if (!ncs[i])
>>>                goto err;
>>>        }
>>>
>>>        if (has_cvq) {
>>>            nc = net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
>>> -                                 vdpa_device_fd, i, 1, false,
>>> +                                 vdpa_device_fd, i, 1, num_as, false,
>>>                                     opts->x_svq, iova_tree);
>>>            if (!nc)
>>>                goto err;

