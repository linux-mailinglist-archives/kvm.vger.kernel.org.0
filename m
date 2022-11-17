Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899D962D36C
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 07:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbiKQGZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 01:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbiKQGZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 01:25:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BB7B482
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 22:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668666263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dotBqQixle9Fv+CAJsS4WLtWi7mY07UiSHvQQq1r/W8=;
        b=VXtTEj6dS4ErtmKBpdvNq9sU7YYfSDykZ64+Z8gPn+y2Zg/TOSuDhcVOYeG+DHqp+gtSAz
        F4Bg4Jx12HKwC4yrzDzCt9FED8n84IywZmvL/S4F5LJ3gymvm2m1xJ+QLAQZLXb6aS/trs
        mf7/bnbT7knE+wvpmfUHpHXfK3TdeWU=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-151-1U56V3RjMrKKEHJ_T26ARg-1; Thu, 17 Nov 2022 01:24:21 -0500
X-MC-Unique: 1U56V3RjMrKKEHJ_T26ARg-1
Received: by mail-pg1-f200.google.com with SMTP id 186-20020a6300c3000000b004702c90a4bdso741323pga.9
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 22:24:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dotBqQixle9Fv+CAJsS4WLtWi7mY07UiSHvQQq1r/W8=;
        b=gTlWttkI4amBhc9mlEBkePaROf+xfNjsMAr3VbWEiitTBnm6f7C/itvaJZz48mDYSM
         rm4hz7YWDvQs0wfkXC8j7q4Dp4dOVgQvEnS+KqjK+HOVaEmvD+z0/YWw10b8xODwSE+w
         MBeSwZUB4z+KaWZOUuNksaXAAVva4cAVDzaa0qckfvzp8e2lnrrvamoYU9OTk/O4KFBM
         PxtQpbgmRfQBa6m9/537XHJMfiXuJRuOVr4a8tT1oTDsiPOeom5WDhC7urYE8j3tQWrC
         OSOmkupUDYEHFTKkmsC4BB4Hc38MquwvZRVSBmEWm8WU0pw+DJFq+i4BTO01KDlNy1hg
         1JLA==
X-Gm-Message-State: ANoB5pnIhr3PY8AihkEQIITp6irs2buJhPxn9UY0nNW79nRHKCJ1odVF
        VMdRZ+f1mZ5RkhYYmDMOb5MyF8BVXdxDi8taHqWTsNDohRZM/bQt7Vfe0EhzRLruUVP/Dfc9lEG
        JjLu/ibcdEgV0
X-Received: by 2002:a17:90a:8d14:b0:213:e4:3f57 with SMTP id c20-20020a17090a8d1400b0021300e43f57mr7079461pjo.204.1668666260681;
        Wed, 16 Nov 2022 22:24:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7JFRfp0oTUPztKaEkbITppFUXEjjDeQ9Y+n/J/QQz14rr0+/jI6u86xVDLPMECSy7qH3Fd4g==
X-Received: by 2002:a17:90a:8d14:b0:213:e4:3f57 with SMTP id c20-20020a17090a8d1400b0021300e43f57mr7079446pjo.204.1668666260466;
        Wed, 16 Nov 2022 22:24:20 -0800 (PST)
Received: from [10.72.13.24] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id l6-20020a170903120600b0018157b415dbsm328428plh.63.2022.11.16.22.24.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 22:24:20 -0800 (PST)
Message-ID: <524ed251-517b-52df-5d84-c9376c4f0a2b@redhat.com>
Date:   Thu, 17 Nov 2022 14:24:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH for 8.0 v7 09/10] vdpa: Add shadow_data to vhost_vdpa
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
 <20221116150556.1294049-10-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221116150556.1294049-10-eperezma@redhat.com>
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
> The memory listener that thells the device how to convert GPA to qemu's
> va is registered against CVQ vhost_vdpa. memory listener translations
> are always ASID 0, CVQ ones are ASID 1 if supported.
>
> Let's tell the listener if it needs to register them on iova tree or
> not.
>
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


> ---
> v7: Rename listener_shadow_vq to shadow_data
> v5: Solve conflict about vhost_iova_tree_remove accepting mem_region by
>      value.
> ---
>   include/hw/virtio/vhost-vdpa.h | 2 ++
>   hw/virtio/vhost-vdpa.c         | 6 +++---
>   net/vhost-vdpa.c               | 1 +
>   3 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost-vdpa.h
> index e57dfa1fd1..45b969a311 100644
> --- a/include/hw/virtio/vhost-vdpa.h
> +++ b/include/hw/virtio/vhost-vdpa.h
> @@ -40,6 +40,8 @@ typedef struct vhost_vdpa {
>       struct vhost_vdpa_iova_range iova_range;
>       uint64_t acked_features;
>       bool shadow_vqs_enabled;
> +    /* Vdpa must send shadow addresses as IOTLB key for data queues, not GPA */
> +    bool shadow_data;
>       /* IOVA mapping used by the Shadow Virtqueue */
>       VhostIOVATree *iova_tree;
>       GPtrArray *shadow_vqs;
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 1e4e1cb523..852baf8b2c 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -224,7 +224,7 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
>                                            vaddr, section->readonly);
>   
>       llsize = int128_sub(llend, int128_make64(iova));
> -    if (v->shadow_vqs_enabled) {
> +    if (v->shadow_data) {
>           int r;
>   
>           mem_region.translated_addr = (hwaddr)(uintptr_t)vaddr,
> @@ -251,7 +251,7 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
>       return;
>   
>   fail_map:
> -    if (v->shadow_vqs_enabled) {
> +    if (v->shadow_data) {
>           vhost_iova_tree_remove(v->iova_tree, mem_region);
>       }
>   
> @@ -296,7 +296,7 @@ static void vhost_vdpa_listener_region_del(MemoryListener *listener,
>   
>       llsize = int128_sub(llend, int128_make64(iova));
>   
> -    if (v->shadow_vqs_enabled) {
> +    if (v->shadow_data) {
>           const DMAMap *result;
>           const void *vaddr = memory_region_get_ram_ptr(section->mr) +
>               section->offset_within_region +
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index 5185ac7042..a9c864741a 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -570,6 +570,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
>       s->vhost_vdpa.index = queue_pair_index;
>       s->always_svq = svq;
>       s->vhost_vdpa.shadow_vqs_enabled = svq;
> +    s->vhost_vdpa.shadow_data = svq;
>       s->vhost_vdpa.iova_tree = iova_tree;
>       if (!is_datapath) {
>           s->cvq_cmd_out_buffer = qemu_memalign(qemu_real_host_page_size(),

