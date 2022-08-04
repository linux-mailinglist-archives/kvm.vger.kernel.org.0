Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2331F589722
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 06:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237530AbiHDEo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 00:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236949AbiHDEo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 00:44:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D6DD5927F
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 21:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659588265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rWEQuXK3Ijx7H7DPgBEaQnciptwVvhmJsueW/ejFO38=;
        b=LZhgoz3Y5trPIuj5hQKqqljSaejEfidsDNmRaAjVG4yO6sjhyQ3gqywpU/SOkfK+KUGgYV
        GwWTqC8mBJbbK+0SJcODGPzqEyDnoI/EH/v6K6VddCUFG/Xq4UKkckPRlbZ72J/IQ+g2VB
        158d1eLAUPmN2fXtY6umUDmlWwR9tQ8=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-IaP3kKq-NO6UT3WzlJaL2Q-1; Thu, 04 Aug 2022 00:44:23 -0400
X-MC-Unique: IaP3kKq-NO6UT3WzlJaL2Q-1
Received: by mail-pl1-f200.google.com with SMTP id d3-20020a170902cec300b0016f04e2e730so3896381plg.1
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 21:44:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rWEQuXK3Ijx7H7DPgBEaQnciptwVvhmJsueW/ejFO38=;
        b=xqtHLHf2sf3HUih7PD3NUJwCj5zVSWiH2J8Tc5YX2iX2cHKfLbZUUPsQw0SBke3fSj
         kqfEvYSGulLPstAE4xVxWqt0xsb6SuZtyTDU8ovh7hjVwZxLXnbGS3RlOYXo39nXVJja
         6IK01c9S6DaIThyuEd9Y1f08+Z/HvLAP5gqvLJOy3lgzFpNWNSIZmkK2Q70gejlXQ6tM
         T3Bi57L4eTq/gwpex+XboV0YlnzBA2yVV4u6lp2/JA8vqGTZ7yUP3CJ/O3RvlsT5NEL8
         YTv1tkJPrFTK7cbqtUHgWOOMOVn//kczVGE44Gb64ajZnBVzx+nI+XO4U9XhIrMeEYk7
         9/cA==
X-Gm-Message-State: ACgBeo3KyKCVYq9ljlaV9F8aHy9YxVpvRQXQZe8/b6ym9hoKT0It25D8
        m+oxdWhWXdSvUy9zLp1kemzOmANqMg9db2pdlYMr1p8XIyyDMixa2MEVJm8eSlD4zbc9/QB+QPj
        MkN0Nwi75pd7E
X-Received: by 2002:a17:903:240f:b0:16d:7865:4b4e with SMTP id e15-20020a170903240f00b0016d78654b4emr201566plo.82.1659588262728;
        Wed, 03 Aug 2022 21:44:22 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5qZDXWQSE2RAWLQkX0OISI/0+cAqsah2ltJk6Tcy2bDaqtnazDxCiw62x3lzue+nUu6UOPCA==
X-Received: by 2002:a17:903:240f:b0:16d:7865:4b4e with SMTP id e15-20020a170903240f00b0016d78654b4emr201538plo.82.1659588262413;
        Wed, 03 Aug 2022 21:44:22 -0700 (PDT)
Received: from [10.72.12.192] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902c1c400b0016d773aae60sm2912422plc.19.2022.08.03.21.44.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 21:44:21 -0700 (PDT)
Message-ID: <dcc42e5b-cce7-63ed-5312-599b4a7a4a2d@redhat.com>
Date:   Thu, 4 Aug 2022 12:44:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v3 7/7] vdpa: Always start CVQ in SVQ mode
Content-Language: en-US
To:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Parav Pandit <parav@mellanox.com>, Cindy Lu <lulu@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
References: <20220803171821.481336-1-eperezma@redhat.com>
 <20220803171821.481336-8-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220803171821.481336-8-eperezma@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/8/4 01:18, Eugenio Pérez 写道:
> Isolate control virtqueue in its own group, allowing to intercept control
> commands but letting dataplane run totally passthrough to the guest.
>
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> ---
> v3:
> * Make asid related queries print a warning instead of returning an
>    error and stop the start of qemu.
> ---
>   hw/virtio/vhost-vdpa.c |   3 +-
>   net/vhost-vdpa.c       | 144 +++++++++++++++++++++++++++++++++++++++--
>   2 files changed, 142 insertions(+), 5 deletions(-)
>
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 131100841c..a4cb68862b 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -674,7 +674,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_dev *dev)
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
> index e3b65ed546..5f39f0edb5 100644
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
> @@ -224,6 +229,101 @@ static NetClientInfo net_vhost_vdpa_info = {
>           .check_peer_type = vhost_vdpa_check_peer_type,
>   };
>   
> +static void vhost_vdpa_get_vring_group(int device_fd,
> +                                       struct vhost_vring_state *state)
> +{
> +    int r = ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, state);
> +    if (unlikely(r < 0)) {
> +        /*
> +         * Assume all groups are 0, the consequences are the same and we will
> +         * not abort device creation
> +         */
> +        state->num = 0;
> +    }
> +}
> +
> +/**
> + * Check if all the virtqueues of the virtio device are in a different vq than
> + * the last vq. VQ group of last group passed in cvq_group.
> + */
> +static bool vhost_vdpa_cvq_group_is_independent(struct vhost_vdpa *v,
> +                                            struct vhost_vring_state cvq_group)
> +{
> +    struct vhost_dev *dev = v->dev;
> +
> +    for (int i = 0; i < (dev->vq_index_end - 1); ++i) {
> +        struct vhost_vring_state vq_group = {
> +            .index = i,
> +        };
> +
> +        vhost_vdpa_get_vring_group(v->device_fd, &vq_group);
> +        if (unlikely(vq_group.num == cvq_group.num)) {
> +            warn_report("CVQ %u group is the same as VQ %u one (%u)",
> +                         cvq_group.index, vq_group.index, cvq_group.num);


I don't get why we need warn here.


> +            return false;
> +        }
> +    }
> +
> +    return true;
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
> +    vhost_vdpa_get_vring_group(v->device_fd, &cvq_group);
> +    if (!vhost_vdpa_cvq_group_is_independent(v, cvq_group)) {


If there's no other caller of vhost_vdpa_cvq_group_is_independent(), I'd 
suggest to unitfy them into a single helper.

(Btw, the name of the function is kind of too long).

Thanks


> +        v->shadow_vqs_enabled = false;
> +        return;
> +    }
> +
> +    r = vhost_vdpa_set_address_space_id(v, cvq_group.num,
> +                                        VHOST_VDPA_NET_CVQ_ASID);
> +    v->shadow_vqs_enabled = r == 0;
> +    s->vhost_vdpa.address_space_id = r == 0 ? 1 : 0;
> +}
> +
>   static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
>   {
>       VhostIOVATree *tree = v->iova_tree;
> @@ -431,6 +531,7 @@ static NetClientInfo net_vhost_vdpa_cvq_info = {
>       .type = NET_CLIENT_DRIVER_VHOST_VDPA,
>       .size = sizeof(VhostVDPAState),
>       .receive = vhost_vdpa_receive,
> +    .prepare = vhost_vdpa_net_prepare,
>       .load = vhost_vdpa_net_load,
>       .cleanup = vhost_vdpa_cleanup,
>       .has_vnet_hdr = vhost_vdpa_has_vnet_hdr,
> @@ -541,12 +642,38 @@ static const VhostShadowVirtqueueOps vhost_vdpa_net_svq_ops = {
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
> @@ -565,6 +692,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
>       snprintf(nc->info_str, sizeof(nc->info_str), TYPE_VHOST_VDPA);
>       s = DO_UPCAST(VhostVDPAState, nc, nc);
>   
> +    s->address_space_num = nas;
>       s->vhost_vdpa.device_fd = vdpa_device_fd;
>       s->vhost_vdpa.index = queue_pair_index;
>       s->always_svq = svq;
> @@ -650,6 +778,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>       g_autoptr(VhostIOVATree) iova_tree = NULL;
>       NetClientState *nc;
>       int queue_pairs, r, i = 0, has_cvq = 0;
> +    unsigned num_as = 1;
> +    bool svq_cvq;
>   
>       assert(netdev->type == NET_CLIENT_DRIVER_VHOST_VDPA);
>       opts = &netdev->u.vhost_vdpa;
> @@ -674,7 +804,13 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
>           goto err;
>       }
>   
> -    if (opts->x_svq) {
> +    svq_cvq = opts->x_svq;
> +    if (has_cvq && !opts->x_svq) {
> +        num_as = vhost_vdpa_get_as_num(vdpa_device_fd);
> +        svq_cvq = num_as > 1;
> +    }
> +
> +    if (opts->x_svq || svq_cvq) {
>           struct vhost_vdpa_iova_range iova_range;
>   
>           uint64_t invalid_dev_features =
> @@ -697,15 +833,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
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

