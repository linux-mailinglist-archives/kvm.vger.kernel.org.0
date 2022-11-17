Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510F262D3A2
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 07:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbiKQGw7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 01:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiKQGw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 01:52:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807CF5D6A3
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 22:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668667918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rbU31RtGVYLfg4O3Trb1BvKjAcaXkSmbmDSuqwJzErA=;
        b=KkLWFr9K/T3QlAnK74STj7hwFYhLbHJ2O7KhL3qP+JwdjDW8Ic8ZrPufnWDZitJFqPmRe3
        Wpwc6cIWP2/1Rv5NXlFcI3qrAQdz2XeLoXwTxM62GVmPzcddDbLPxXh8Ghq/9JS5sWZqLw
        wF6xBYsV0L4IrWtGYuAQlYmPrmXXrzs=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-442-9EP2s_LRMxGAZCd8FuwUlQ-1; Thu, 17 Nov 2022 01:51:57 -0500
X-MC-Unique: 9EP2s_LRMxGAZCd8FuwUlQ-1
Received: by mail-pl1-f199.google.com with SMTP id a6-20020a170902ecc600b00186f035ed74so760710plh.12
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 22:51:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rbU31RtGVYLfg4O3Trb1BvKjAcaXkSmbmDSuqwJzErA=;
        b=3VyIpxjTvuSt+zlbT/0Iyjpj/uFPcSb+Uipe8PQz/xa/YxBVfnhsFRbBGtgXhChJNe
         bKnZ2WXmqn4uGcmAiytcxb/WaXFW2s7QbXnTtkPCrL2r5bqSh0QUgDt5MQZrIRGQov0q
         AIIWcekBKO+++16RNiCWAY8JuS696HUCAYmaQxWAC8gSFmqVcAx86x3hi4js5GKc5lyz
         hAkOI9zA0etfMDuTx3riz16Bkrg9taVg7R45e8g93NQx5gss3dtpjOvhJYuFg3Dig7eV
         fIqMNKDnG5I0UhLeYf94qZqKFfGv+lrD3pdfb7IRPU4HqjDN/kOZL0WSPmzFCbATmzLN
         0YDA==
X-Gm-Message-State: ANoB5pm6OT7eyN7nru90zsQ6yWpeKGbzGCNHvVv8r/kdgVPIKDVWot+2
        YtYT/BWOmis1nT6qbU99brIegByZY6PI7Eun4VJWF5Rc1/PRsbZl4/r/ESRnVAcLOj8EjbWNrrr
        K6WXD9Xy8si59
X-Received: by 2002:a63:4b07:0:b0:46e:9363:d96e with SMTP id y7-20020a634b07000000b0046e9363d96emr930524pga.85.1668667915788;
        Wed, 16 Nov 2022 22:51:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7uEPMxxM20WDRomEVyVlJvMpsYi2YDb+yv5Lw+UkIN9h3fUtxBJTPQfhOnfza8hl3OXmmISg==
X-Received: by 2002:a63:4b07:0:b0:46e:9363:d96e with SMTP id y7-20020a634b07000000b0046e9363d96emr930507pga.85.1668667915476;
        Wed, 16 Nov 2022 22:51:55 -0800 (PST)
Received: from [10.72.13.24] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z7-20020aa79f87000000b005625d5ae760sm271304pfr.11.2022.11.16.22.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 22:51:55 -0800 (PST)
Message-ID: <f22d530b-3c5e-5b94-948d-594608668687@redhat.com>
Date:   Thu, 17 Nov 2022 14:51:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH for 8.0 v7 10/10] vdpa: Always start CVQ in SVQ mode if
 possible
Content-Language: en-US
To:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Cindy Lu <lulu@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Parav Pandit <parav@mellanox.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
References: <20221116150556.1294049-1-eperezma@redhat.com>
 <20221116150556.1294049-11-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221116150556.1294049-11-eperezma@redhat.com>
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


在 2022/11/16 23:05, Eugenio Pérez 写道:
> Isolate control virtqueue in its own group, allowing to intercept control
> commands but letting dataplane run totally passthrough to the guest.
>
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> ---
> v7:
> * Never ask for number of address spaces, just react if isolation is not
>    possible.
> * Return ASID ioctl errors instead of masking them as if the device has
>    no asid.
> * Simplify net_init_vhost_vdpa logic
> * Add "if possible" suffix
>
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
>   net/vhost-vdpa.c       | 117 +++++++++++++++++++++++++++++++++++++++--
>   2 files changed, 114 insertions(+), 6 deletions(-)
>
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 852baf8b2c..a29a18a6a9 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -653,7 +653,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_dev *dev)
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
> index a9c864741a..dc13a49311 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -101,6 +101,8 @@ static const uint64_t vdpa_svq_device_features =
>       BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
>       BIT_ULL(VIRTIO_NET_F_STANDBY);
>   
> +#define VHOST_VDPA_NET_CVQ_ASID 1
> +
>   VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
>   {
>       VhostVDPAState *s = DO_UPCAST(VhostVDPAState, nc, nc);
> @@ -242,6 +244,40 @@ static NetClientInfo net_vhost_vdpa_info = {
>           .check_peer_type = vhost_vdpa_check_peer_type,
>   };
>   
> +static int64_t vhost_vdpa_get_vring_group(int device_fd, unsigned vq_index)
> +{
> +    struct vhost_vring_state state = {
> +        .index = vq_index,
> +    };
> +    int r = ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, &state);
> +
> +    if (unlikely(r < 0)) {
> +        error_report("Cannot get VQ %u group: %s", vq_index,
> +                     g_strerror(errno));
> +        return r;
> +    }
> +
> +    return state.num;
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
> +    int r;
> +
> +    r = ioctl(v->device_fd, VHOST_VDPA_SET_GROUP_ASID, &asid);
> +    if (unlikely(r < 0)) {
> +        error_report("Can't set vq group %u asid %u, errno=%d (%s)",
> +                     asid.index, asid.num, errno, g_strerror(errno));
> +    }
> +    return r;
> +}
> +
>   static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
>   {
>       VhostIOVATree *tree = v->iova_tree;
> @@ -316,11 +352,69 @@ dma_map_err:
>   static int vhost_vdpa_net_cvq_start(NetClientState *nc)
>   {
>       VhostVDPAState *s;
> -    int r;
> +    struct vhost_vdpa *v;
> +    uint64_t backend_features;
> +    int64_t cvq_group;
> +    int cvq_index, r;
>   
>       assert(nc->info->type == NET_CLIENT_DRIVER_VHOST_VDPA);
>   
>       s = DO_UPCAST(VhostVDPAState, nc, nc);
> +    v = &s->vhost_vdpa;
> +
> +    v->shadow_data = s->always_svq;
> +    v->shadow_vqs_enabled = s->always_svq;
> +    s->vhost_vdpa.address_space_id = VHOST_VDPA_GUEST_PA_ASID;
> +
> +    if (s->always_svq) {
> +        goto out;
> +    }
> +
> +    /* Backend features are not available in v->dev yet. */
> +    r = ioctl(v->device_fd, VHOST_GET_BACKEND_FEATURES, &backend_features);
> +    if (unlikely(r < 0)) {
> +        error_report("Cannot get vdpa backend_features: %s(%d)",
> +            g_strerror(errno), errno);
> +        return -1;
> +    }
> +    if (!(backend_features & VHOST_BACKEND_F_IOTLB_ASID) ||
> +        !vhost_vdpa_net_valid_svq_features(v->dev->features, NULL)) {


I think there should be some logic to block migration in this case?


> +        return 0;
> +    }
> +
> +    /**
> +     * Check if all the virtqueues of the virtio device are in a different vq
> +     * than the last vq. VQ group of last group passed in cvq_group.
> +     */
> +    cvq_index = v->dev->vq_index_end - 1;
> +    cvq_group = vhost_vdpa_get_vring_group(v->device_fd, cvq_index);
> +    if (unlikely(cvq_group < 0)) {
> +        return cvq_group;x
> +    }
> +    for (int i = 0; i < cvq_index; ++i) {
> +        int64_t group = vhost_vdpa_get_vring_group(v->device_fd, i);
> +
> +        if (unlikely(group < 0)) {
> +            return group;
> +        }
> +
> +        if (unlikely(group == cvq_group)) {
> +            warn_report(
> +                "CVQ %"PRId64" group is the same as VQ %d one (%"PRId64")",
> +                cvq_group, i, group);
> +            return 0;


Ditto.


> +        }
> +    }
> +
> +    r = vhost_vdpa_set_address_space_id(v, cvq_group, VHOST_VDPA_NET_CVQ_ASID);
> +    if (unlikely(r < 0)) {
> +        return r;
> +    } else {
> +        v->shadow_vqs_enabled = true;
> +        s->vhost_vdpa.address_space_id = VHOST_VDPA_NET_CVQ_ASID;
> +    }
> +
> +out:
>       if (!s->vhost_vdpa.shadow_vqs_enabled) {
>           return 0;
>       }
> @@ -652,6 +746,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>       g_autoptr(VhostIOVATree) iova_tree = NULL;
>       NetClientState *nc;
>       int queue_pairs, r, i = 0, has_cvq = 0;
> +    bool svq_cvq;
>   
>       assert(netdev->type == NET_CLIENT_DRIVER_VHOST_VDPA);
>       opts = &netdev->u.vhost_vdpa;
> @@ -693,12 +788,24 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>           return queue_pairs;
>       }
>   
> -    if (opts->x_svq) {
> -        struct vhost_vdpa_iova_range iova_range;
> +    svq_cvq = opts->x_svq || has_cvq;
> +    if (svq_cvq) {
> +        Error *warn = NULL;
>   
> -        if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
> -            goto err_svq;
> +        svq_cvq = vhost_vdpa_net_valid_svq_features(features,
> +                                                   opts->x_svq ? errp : &warn);
> +        if (!svq_cvq) {
> +            if (opts->x_svq) {
> +                goto err_svq;
> +            } else {
> +                warn_reportf_err(warn, "Cannot shadow CVQ: ");


This seems suspicious, we reach here we we can't just use svq for cvq.



> +            }
>           }


The above logic is not easy to follow. I guess the root cause is the 
variable name. It looks to me svq_cvq is better to be renamed as "svq"?

Thanks


> +    }
> +
> +    if (svq_cvq) {
> +        /* Allocate a common iova tree if there is a possibility of SVQ */
> +        struct vhost_vdpa_iova_range iova_range;
>   
>           vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
>           iova_tree = vhost_iova_tree_new(iova_range.first, iova_range.last);

