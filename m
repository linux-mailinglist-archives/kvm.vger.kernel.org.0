Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA41623BC7
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 07:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbiKJG0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 01:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiKJG0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 01:26:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C306A1DD
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 22:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668061516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1yPCMesLzAi91hlI11sYZW04SqKKMi7wFZsNU5sCdCM=;
        b=Ci+QyPJkLPJHtq+7STsQTlyj7e3nScXHJV5Z+w+5RnYQ5M973utOQuhCeVX4lOiP3YCGhy
        NzJXgNbmyhdPNihWbTVGsNRUhkL3mEsO+/vm38a0BMFE/jc9sQlFXUPtl9VqKYeBic8Enm
        AhqLtZydeKOqEMu/DSMb/7eY1v4jpDo=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-436-RefD_2YnN2etmgqYSq1Vxg-1; Thu, 10 Nov 2022 01:25:09 -0500
X-MC-Unique: RefD_2YnN2etmgqYSq1Vxg-1
Received: by mail-pl1-f199.google.com with SMTP id k9-20020a170902c40900b0018734e872a9so735763plk.21
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 22:25:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1yPCMesLzAi91hlI11sYZW04SqKKMi7wFZsNU5sCdCM=;
        b=wbl7xcOPGi2ZvUjpDXTdygFUDQQe/yvPIK5IAmbk1iKCuALsSrO2jxh18Sl2fQHQo1
         uK1quZuJqc9uUQrUKE4kCWA8q1POFjDRS+4ZDYk/qE60I0rr/r8x/Sr3C1Xp2qrWyNCw
         JW9ASP0iYKz9NRm3D6g2pok2DfVc437LU3hXyHemoQB1AT8b0C30hjtkYOIlYeh+kqfL
         55Ix5I1VxvGjWKNVw1Eorv8ibgE8dIcLdCbKR5v/H+LJ8yHLizPoINuu1qQn7KHqXiyj
         Lq8lmhVCjqUE8z98clJbLjXNpDeXVSvJQvc1NrxBZShn9jB7GMSZ1Lj0ZCzopTMxkpR0
         88CQ==
X-Gm-Message-State: ACrzQf0dbrKxdo8qbL4zozCu7uOxgGyKAB3m4MrAcJmyAMjxm84LZHix
        5p+5yYb/FcyxdxQ0+3WwgRyfXlmej2P7yzYwaz9kaDDFzQa6/uZKxKGyCAS3TpxBxqEFaG0vmTg
        Zm/5zupS3a6XG
X-Received: by 2002:a17:90a:f2cb:b0:213:9afa:d13a with SMTP id gt11-20020a17090af2cb00b002139afad13amr64280214pjb.180.1668061507935;
        Wed, 09 Nov 2022 22:25:07 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5RptU47vR52AXRUeK0iNkW8pvYXotqtTe+FgttOxgennvPrdRh0GM5XJ8kbZwrZB9h5E+V0g==
X-Received: by 2002:a17:90a:f2cb:b0:213:9afa:d13a with SMTP id gt11-20020a17090af2cb00b002139afad13amr64280188pjb.180.1668061507558;
        Wed, 09 Nov 2022 22:25:07 -0800 (PST)
Received: from [10.72.13.112] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id l5-20020a622505000000b0056be1581126sm9636709pfl.143.2022.11.09.22.24.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 22:25:05 -0800 (PST)
Message-ID: <5eb848d8-eb27-4c27-377d-cb6edfe3718c@redhat.com>
Date:   Thu, 10 Nov 2022 14:24:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v6 10/10] vdpa: Always start CVQ in SVQ mode
Content-Language: en-US
To:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Parav Pandit <parav@mellanox.com>,
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
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221108170755.92768-11-eperezma@redhat.com>
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


在 2022/11/9 01:07, Eugenio Pérez 写道:
> Isolate control virtqueue in its own group, allowing to intercept control
> commands but letting dataplane run totally passthrough to the guest.


I think we need to tweak the title to "vdpa: Always start CVQ in SVQ 
mode if possible". Since SVQ for CVQ can't be enabled without ASID support?


>
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> ---
> v6:
> * Disable control SVQ if the device does not support it because of
> features.
>
> v5:
> * Fixing the not adding cvq buffers when x-svq=on is specified.
> * Move vring state in vhost_vdpa_get_vring_group instead of using a
>    parameter.
> * Rename VHOST_VDPA_NET_CVQ_PASSTHROUGH to VHOST_VDPA_NET_DATA_ASID
>
> v4:
> * Squash vhost_vdpa_cvq_group_is_independent.
> * Rebased on last CVQ start series, that allocated CVQ cmd bufs at load
> * Do not check for cvq index on vhost_vdpa_net_prepare, we only have one
>    that callback registered in that NetClientInfo.
>
> v3:
> * Make asid related queries print a warning instead of returning an
>    error and stop the start of qemu.
> ---
>   hw/virtio/vhost-vdpa.c |   3 +-
>   net/vhost-vdpa.c       | 138 ++++++++++++++++++++++++++++++++++++++---
>   2 files changed, 132 insertions(+), 9 deletions(-)
>
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index e3914fa40e..6401e7efb1 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -648,7 +648,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_dev *dev)
>   {
>       uint64_t features;
>       uint64_t f = 0x1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2 |
> -        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH;
> +        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH |
> +        0x1ULL << VHOST_BACKEND_F_IOTLB_ASID;
>       int r;
>   
>       if (vhost_vdpa_call(dev, VHOST_GET_BACKEND_FEATURES, &features)) {
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index 02780ee37b..7245ea70c6 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -38,6 +38,9 @@ typedef struct VhostVDPAState {
>       void *cvq_cmd_out_buffer;
>       virtio_net_ctrl_ack *status;
>   
> +    /* Number of address spaces supported by the device */
> +    unsigned address_space_num;


I'm not sure this is the best place to store thing like this since it 
can cause confusion. We will have multiple VhostVDPAState when 
multiqueue is enabled.


> +
>       /* The device always have SVQ enabled */
>       bool always_svq;
>       bool started;
> @@ -101,6 +104,9 @@ static const uint64_t vdpa_svq_device_features =
>       BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
>       BIT_ULL(VIRTIO_NET_F_STANDBY);
>   
> +#define VHOST_VDPA_NET_DATA_ASID 0
> +#define VHOST_VDPA_NET_CVQ_ASID 1
> +
>   VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
>   {
>       VhostVDPAState *s = DO_UPCAST(VhostVDPAState, nc, nc);
> @@ -242,6 +248,34 @@ static NetClientInfo net_vhost_vdpa_info = {
>           .check_peer_type = vhost_vdpa_check_peer_type,
>   };
>   
> +static uint32_t vhost_vdpa_get_vring_group(int device_fd, unsigned vq_index)
> +{
> +    struct vhost_vring_state state = {
> +        .index = vq_index,
> +    };
> +    int r = ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, &state);
> +
> +    return r < 0 ? 0 : state.num;


Assume 0 when ioctl() fail is probably not a good idea: errors in ioctl 
might be hidden. It would be better to fallback to 0 when ASID is not 
supported.


> +}
> +
> +static int vhost_vdpa_set_address_space_id(struct vhost_vdpa *v,
> +                                           unsigned vq_group,
> +                                           unsigned asid_num)
> +{
> +    struct vhost_vring_state asid = {
> +        .index = vq_group,
> +        .num = asid_num,
> +    };
> +    int ret;
> +
> +    ret = ioctl(v->device_fd, VHOST_VDPA_SET_GROUP_ASID, &asid);
> +    if (unlikely(ret < 0)) {
> +        warn_report("Can't set vq group %u asid %u, errno=%d (%s)",
> +            asid.index, asid.num, errno, g_strerror(errno));
> +    }
> +    return ret;
> +}
> +
>   static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
>   {
>       VhostIOVATree *tree = v->iova_tree;
> @@ -316,11 +350,54 @@ dma_map_err:
>   static int vhost_vdpa_net_cvq_start(NetClientState *nc)
>   {
>       VhostVDPAState *s;
> -    int r;
> +    struct vhost_vdpa *v;
> +    uint32_t cvq_group;
> +    int cvq_index, r;
>   
>       assert(nc->info->type == NET_CLIENT_DRIVER_VHOST_VDPA);
>   
>       s = DO_UPCAST(VhostVDPAState, nc, nc);
> +    v = &s->vhost_vdpa;
> +
> +    v->listener_shadow_vq = s->always_svq;
> +    v->shadow_vqs_enabled = s->always_svq;
> +    s->vhost_vdpa.address_space_id = VHOST_VDPA_NET_DATA_ASID;
> +
> +    if (s->always_svq) {
> +        goto out;
> +    }
> +
> +    if (s->address_space_num < 2) {
> +        return 0;
> +    }
> +
> +    if (!vhost_vdpa_net_valid_svq_features(v->dev->features, NULL)) {
> +        return 0;
> +    }


Any reason we do the above check during the start/stop? It should be 
easier to do that in the initialization.


> +
> +    /**
> +     * Check if all the virtqueues of the virtio device are in a different vq
> +     * than the last vq. VQ group of last group passed in cvq_group.
> +     */
> +    cvq_index = v->dev->vq_index_end - 1;
> +    cvq_group = vhost_vdpa_get_vring_group(v->device_fd, cvq_index);
> +    for (int i = 0; i < cvq_index; ++i) {
> +        uint32_t group = vhost_vdpa_get_vring_group(v->device_fd, i);
> +
> +        if (unlikely(group == cvq_group)) {
> +            warn_report("CVQ %u group is the same as VQ %u one (%u)", cvq_group,
> +                        i, group);
> +            return 0;
> +        }
> +    }
> +
> +    r = vhost_vdpa_set_address_space_id(v, cvq_group, VHOST_VDPA_NET_CVQ_ASID);
> +    if (r == 0) {
> +        v->shadow_vqs_enabled = true;
> +        s->vhost_vdpa.address_space_id = VHOST_VDPA_NET_CVQ_ASID;
> +    }
> +
> +out:
>       if (!s->vhost_vdpa.shadow_vqs_enabled) {
>           return 0;
>       }
> @@ -542,12 +619,38 @@ static const VhostShadowVirtqueueOps vhost_vdpa_net_svq_ops = {
>       .avail_handler = vhost_vdpa_net_handle_ctrl_avail,
>   };
>   
> +static uint32_t vhost_vdpa_get_as_num(int vdpa_device_fd)
> +{
> +    uint64_t features;
> +    unsigned num_as;
> +    int r;
> +
> +    r = ioctl(vdpa_device_fd, VHOST_GET_BACKEND_FEATURES, &features);
> +    if (unlikely(r < 0)) {
> +        warn_report("Cannot get backend features");
> +        return 1;
> +    }
> +
> +    if (!(features & BIT_ULL(VHOST_BACKEND_F_IOTLB_ASID))) {
> +        return 1;
> +    }
> +
> +    r = ioctl(vdpa_device_fd, VHOST_VDPA_GET_AS_NUM, &num_as);
> +    if (unlikely(r < 0)) {
> +        warn_report("Cannot retrieve number of supported ASs");
> +        return 1;


Let's return error here. This help to identify bugs of qemu or kernel.


> +    }
> +
> +    return num_as;
> +}
> +
>   static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
>                                              const char *device,
>                                              const char *name,
>                                              int vdpa_device_fd,
>                                              int queue_pair_index,
>                                              int nvqs,
> +                                           unsigned nas,
>                                              bool is_datapath,
>                                              bool svq,
>                                              VhostIOVATree *iova_tree)
> @@ -566,6 +669,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
>       qemu_set_info_str(nc, TYPE_VHOST_VDPA);
>       s = DO_UPCAST(VhostVDPAState, nc, nc);
>   
> +    s->address_space_num = nas;
>       s->vhost_vdpa.device_fd = vdpa_device_fd;
>       s->vhost_vdpa.index = queue_pair_index;
>       s->always_svq = svq;
> @@ -652,6 +756,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>       g_autoptr(VhostIOVATree) iova_tree = NULL;
>       NetClientState *nc;
>       int queue_pairs, r, i = 0, has_cvq = 0;
> +    unsigned num_as = 1;
> +    bool svq_cvq;
>   
>       assert(netdev->type == NET_CLIENT_DRIVER_VHOST_VDPA);
>       opts = &netdev->u.vhost_vdpa;
> @@ -693,12 +799,28 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>           return queue_pairs;
>       }
>   
> -    if (opts->x_svq) {
> -        struct vhost_vdpa_iova_range iova_range;
> +    svq_cvq = opts->x_svq;
> +    if (has_cvq && !opts->x_svq) {
> +        num_as = vhost_vdpa_get_as_num(vdpa_device_fd);
> +        svq_cvq = num_as > 1;
> +    }


The above check is not easy to follow, how about?

svq_cvq = vhost_vdpa_get_as_num() > 1 ? true : opts->x_svq;


> +
> +    if (opts->x_svq || svq_cvq) {


Any chance we can have opts->x_svq = true but svq_cvq = false? Checking 
svq_cvq seems sufficient here.


> +        Error *warn = NULL;
>   
> -        if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
> -            goto err_svq;
> +        svq_cvq = vhost_vdpa_net_valid_svq_features(features,
> +                                                   opts->x_svq ? errp : &warn);
> +        if (!svq_cvq) {


Same question as above.


> +            if (opts->x_svq) {
> +                goto err_svq;
> +            } else {
> +                warn_reportf_err(warn, "Cannot shadow CVQ: ");
> +            }
>           }
> +    }
> +
> +    if (opts->x_svq || svq_cvq) {
> +        struct vhost_vdpa_iova_range iova_range;
>   
>           vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
>           iova_tree = vhost_iova_tree_new(iova_range.first, iova_range.last);
> @@ -708,15 +830,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>   
>       for (i = 0; i < queue_pairs; i++) {
>           ncs[i] = net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
> -                                     vdpa_device_fd, i, 2, true, opts->x_svq,
> -                                     iova_tree);
> +                                     vdpa_device_fd, i, 2, num_as, true,


I don't get why we need pass num_as to a specific vhost_vdpa structure. 
It should be sufficient to pass asid there.

Thanks


> +                                     opts->x_svq, iova_tree);
>           if (!ncs[i])
>               goto err;
>       }
>   
>       if (has_cvq) {
>           nc = net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
> -                                 vdpa_device_fd, i, 1, false,
> +                                 vdpa_device_fd, i, 1, num_as, false,
>                                    opts->x_svq, iova_tree);
>           if (!nc)
>               goto err;

