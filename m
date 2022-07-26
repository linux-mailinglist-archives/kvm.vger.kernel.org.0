Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FC45809C2
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 05:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbiGZDEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 23:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237452AbiGZDEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 23:04:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3E3A2A267
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 20:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658804657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nkiR8P6g/pEBNZsusOeObjWrXOKsBzlWFFnakVDcLp4=;
        b=UcJwq5S0Vvn673WVUXcIKuC7KGlOEJRkVVuvRnPPQIP3KlKyH450mIXgXaGpuvJaFBlz51
        JqfeNNzVQTBlKVJ4yUCXOt2we6Tulwag3ePZC7PSpGB5nKLi8aoQQjOu0+ssaEs6Ejm31Z
        0uZKtEmhFKnq2gJd+VpLsRqgTRxuuP4=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-Rn8y0zeMOt292a3kwe6C9g-1; Mon, 25 Jul 2022 23:04:16 -0400
X-MC-Unique: Rn8y0zeMOt292a3kwe6C9g-1
Received: by mail-pl1-f199.google.com with SMTP id m5-20020a170902f64500b0016d313f3ce7so7689739plg.23
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 20:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nkiR8P6g/pEBNZsusOeObjWrXOKsBzlWFFnakVDcLp4=;
        b=X1gIak6nSk3NaWnNlg+rjYFft946AQK65nxmQmQZ+rXvq8Bu0IEwgb/yPHK7Jj6JVw
         6R0VLZtsmqsn8w8s71QPUXVsGAxjw29WUh49F00+vyEXLlnWdhM8YgzvFnoBDqYFzswa
         qIj+bvdtd5zIa9pWuj/OJaaGUBClAKgkK+pp8521VI9qrRVZjuYm6p2YVNfW8ZLvl3rv
         WELwQ9jpz88sT82A4KO7W2CHlhWcawKRMnaNB4TMf2J5jnncL+vbHCPQ+oXZT23KMIqz
         zDgPnHdrAu0evZmxH8RR+5Ucbv6X8PnNRmEhify6AhjKxJml+ylrUaAHQFchgvNyrUn/
         r/1A==
X-Gm-Message-State: AJIora/nf/2FD9ttumMSqID0GYzyurA4g9sqRf0kjhxHJfCQsvrVfBWu
        PqGo6DvVaWpMfNV59zYDJWb80SaUup0nglFm9WkjP+2Hzg/REg7TJehoYIvSzA52UNW1xG6VF7w
        zKMjBKWeo4xG7
X-Received: by 2002:a17:90b:1d04:b0:1f2:c5a7:9344 with SMTP id on4-20020a17090b1d0400b001f2c5a79344mr6337681pjb.192.1658804655121;
        Mon, 25 Jul 2022 20:04:15 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tBMyHs89lnC/hr50by+2gkTxgDKxESt8I4/AGVVKxeuagROH2lPqwQNAXyjgmjOOaTUGvtIQ==
X-Received: by 2002:a17:90b:1d04:b0:1f2:c5a7:9344 with SMTP id on4-20020a17090b1d0400b001f2c5a79344mr6337644pjb.192.1658804654835;
        Mon, 25 Jul 2022 20:04:14 -0700 (PDT)
Received: from [10.72.12.201] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k34-20020a634b62000000b00415fcde23a4sm9020646pgl.27.2022.07.25.20.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 20:04:14 -0700 (PDT)
Message-ID: <74d24a62-7017-e937-3bcb-af8f6b605fee@redhat.com>
Date:   Tue, 26 Jul 2022 11:04:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v2 7/7] vdpa: Always start CVQ in SVQ mode
Content-Language: en-US
To:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Harpreet Singh Anand <hanand@xilinx.com>,
        Cindy Lu <lulu@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>
References: <20220722134318.3430667-1-eperezma@redhat.com>
 <20220722134318.3430667-8-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220722134318.3430667-8-eperezma@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/7/22 21:43, Eugenio Pérez 写道:
> Isolate control virtqueue in its own group, allowing to intercept control
> commands but letting dataplane run totally passthrough to the guest.
>
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> ---
>   hw/virtio/vhost-vdpa.c |   3 +-
>   net/vhost-vdpa.c       | 158 +++++++++++++++++++++++++++++++++++++++--
>   2 files changed, 156 insertions(+), 5 deletions(-)
>
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 79623badf2..fe1c85b086 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -668,7 +668,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_dev *dev)
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
> index 6c1c64f9b1..f5075ef487 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -37,6 +37,9 @@ typedef struct VhostVDPAState {
>       /* Control commands shadow buffers */
>       void *cvq_cmd_out_buffer, *cvq_cmd_in_buffer;
>   
> +    /* Number of address spaces supported by the device */
> +    unsigned address_space_num;
> +
>       /* The device always have SVQ enabled */
>       bool always_svq;
>       bool started;
> @@ -100,6 +103,8 @@ static const uint64_t vdpa_svq_device_features =
>       BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
>       BIT_ULL(VIRTIO_NET_F_STANDBY);
>   
> +#define VHOST_VDPA_NET_CVQ_ASID 1
> +
>   VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
>   {
>       VhostVDPAState *s = DO_UPCAST(VhostVDPAState, nc, nc);
> @@ -214,6 +219,109 @@ static ssize_t vhost_vdpa_receive(NetClientState *nc, const uint8_t *buf,
>       return 0;
>   }
>   
> +static int vhost_vdpa_get_vring_group(int device_fd,
> +                                      struct vhost_vring_state *state)
> +{
> +    int r = ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, state);
> +    return r < 0 ? -errno : 0;
> +}


It would be more convenient for the caller if we can simply return 0 here.


> +
> +/**
> + * Check if all the virtqueues of the virtio device are in a different vq than
> + * the last vq. VQ group of last group passed in cvq_group.
> + */
> +static bool vhost_vdpa_cvq_group_is_independent(struct vhost_vdpa *v,
> +                                            struct vhost_vring_state cvq_group)
> +{
> +    struct vhost_dev *dev = v->dev;
> +    int ret;
> +
> +    for (int i = 0; i < (dev->vq_index_end - 1); ++i) {
> +        struct vhost_vring_state vq_group = {
> +            .index = i,
> +        };
> +
> +        ret = vhost_vdpa_get_vring_group(v->device_fd, &vq_group);
> +        if (unlikely(ret)) {
> +            goto call_err;
> +        }
> +        if (unlikely(vq_group.num == cvq_group.num)) {
> +            error_report("CVQ %u group is the same as VQ %u one (%u)",
> +                         cvq_group.index, vq_group.index, cvq_group.num);


Any reason we need error_report() here?

Btw, I'd suggest to introduce new field in vhost_vdpa, then we can get 
and store the group_id there during init.

This could be useful for the future e.g PASID virtualization.


> +            return false;
> +        }
> +    }
> +
> +    return true;
> +
> +call_err:
> +    error_report("Can't read vq group, errno=%d (%s)", -ret, g_strerror(-ret));
> +    return false;
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
> +        error_report("Can't set vq group %u asid %u, errno=%d (%s)",
> +            asid.index, asid.num, errno, g_strerror(errno));
> +    }
> +    return ret;
> +}
> +
> +static void vhost_vdpa_net_prepare(NetClientState *nc)
> +{
> +    VhostVDPAState *s = DO_UPCAST(VhostVDPAState, nc, nc);
> +    struct vhost_vdpa *v = &s->vhost_vdpa;
> +    struct vhost_dev *dev = v->dev;
> +    struct vhost_vring_state cvq_group = {
> +        .index = v->dev->vq_index_end - 1,
> +    };
> +    int r;
> +
> +    assert(nc->info->type == NET_CLIENT_DRIVER_VHOST_VDPA);
> +
> +    if (dev->nvqs != 1 || dev->vq_index + dev->nvqs != dev->vq_index_end) {
> +        /* Only interested in CVQ */
> +        return;
> +    }
> +
> +    if (s->always_svq) {
> +        /* SVQ is already enabled */
> +        return;
> +    }
> +
> +    if (s->address_space_num < 2) {
> +        v->shadow_vqs_enabled = false;
> +        return;
> +    }
> +
> +    r = vhost_vdpa_get_vring_group(v->device_fd, &cvq_group);
> +    if (unlikely(r)) {
> +        error_report("Can't read cvq group, errno=%d (%s)", r, g_strerror(-r));
> +        v->shadow_vqs_enabled = false;
> +        return;
> +    }
> +
> +    if (!vhost_vdpa_cvq_group_is_independent(v, cvq_group)) {
> +        v->shadow_vqs_enabled = false;
> +        return;
> +    }
> +
> +    r = vhost_vdpa_set_address_space_id(v, cvq_group.num,
> +                                        VHOST_VDPA_NET_CVQ_ASID);
> +    v->shadow_vqs_enabled = r == 0;
> +    s->vhost_vdpa.address_space_id = r == 0 ? 1 : 0;


I'd expect this to be done net_init_vhost_vdpa(). Or any advantage of 
initializing thing here?


> +}
> +
>   static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
>   {
>       VhostIOVATree *tree = v->iova_tree;
> @@ -432,6 +540,7 @@ static NetClientInfo net_vhost_vdpa_info = {
>           .type = NET_CLIENT_DRIVER_VHOST_VDPA,
>           .size = sizeof(VhostVDPAState),
>           .receive = vhost_vdpa_receive,
> +        .prepare = vhost_vdpa_net_prepare,
>           .start = vhost_vdpa_net_start,
>           .cleanup = vhost_vdpa_cleanup,
>           .has_vnet_hdr = vhost_vdpa_has_vnet_hdr,
> @@ -542,12 +651,40 @@ static const VhostShadowVirtqueueOps vhost_vdpa_net_svq_ops = {
>       .avail_handler = vhost_vdpa_net_handle_ctrl_avail,
>   };
>   
> +static bool vhost_vdpa_get_as_num(int vdpa_device_fd, unsigned *num_as,
> +                                  Error **errp)


Let's simply return int as the #as here.

Thanks


> +{
> +    uint64_t features;
> +    int r;
> +
> +    r = ioctl(vdpa_device_fd, VHOST_GET_BACKEND_FEATURES, &features);
> +    if (unlikely(r < 0)) {
> +        error_setg_errno(errp, errno, "Cannot get backend features");
> +        return r;
> +    }
> +
> +    if (!(features & BIT_ULL(VHOST_BACKEND_F_IOTLB_ASID))) {
> +        *num_as = 1;
> +        return 0;
> +    }
> +
> +    r = ioctl(vdpa_device_fd, VHOST_VDPA_GET_AS_NUM, num_as);
> +    if (unlikely(r < 0)) {
> +        error_setg_errno(errp, errno,
> +                         "Cannot retrieve number of supported ASs");
> +        return r;
> +    }
> +
> +    return 0;
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
> @@ -566,6 +703,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
>       snprintf(nc->info_str, sizeof(nc->info_str), TYPE_VHOST_VDPA);
>       s = DO_UPCAST(VhostVDPAState, nc, nc);
>   
> +    s->address_space_num = nas;
>       s->vhost_vdpa.device_fd = vdpa_device_fd;
>       s->vhost_vdpa.index = queue_pair_index;
>       s->always_svq = svq;
> @@ -651,6 +789,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>       g_autoptr(VhostIOVATree) iova_tree = NULL;
>       NetClientState *nc;
>       int queue_pairs, r, i, has_cvq = 0;
> +    unsigned num_as = 1;
> +    bool svq_cvq;
>   
>       assert(netdev->type == NET_CLIENT_DRIVER_VHOST_VDPA);
>       opts = &netdev->u.vhost_vdpa;
> @@ -676,7 +816,17 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>           return queue_pairs;
>       }
>   
> -    if (opts->x_svq) {
> +    svq_cvq = opts->x_svq;
> +    if (has_cvq && !opts->x_svq) {
> +        r = vhost_vdpa_get_as_num(vdpa_device_fd, &num_as, errp);
> +        if (unlikely(r < 0)) {
> +            return r;
> +        }
> +
> +        svq_cvq = num_as > 1;
> +    }
> +
> +    if (opts->x_svq || svq_cvq) {
>           struct vhost_vdpa_iova_range iova_range;
>   
>           uint64_t invalid_dev_features =
> @@ -699,15 +849,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>   
>       for (i = 0; i < queue_pairs; i++) {
>           ncs[i] = net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
> -                                     vdpa_device_fd, i, 2, true, opts->x_svq,
> -                                     iova_tree);
> +                                     vdpa_device_fd, i, 2, num_as, true,
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

