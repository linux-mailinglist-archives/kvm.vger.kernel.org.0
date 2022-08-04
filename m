Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A61589719
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 06:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiHDEgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 00:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238486AbiHDEgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 00:36:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E43B5656D
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 21:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659587765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3pusb/gArFFwJGvdatRkIk+S/33mt+/MIat6GqC/G1Q=;
        b=h3Y4pS11Gbkr/UXGMlhcbN854JqAnxSWqdl3HVXGGwWJI0Ul+6H1ng6hv4PhWOGDguU80B
        mTAIq3qdKxs5Bh6R7rXzan0j+U+e5vDxX6TXiOO/1k5altWLGjNMm2rbsnUHPcOhWPDWQA
        AE1//R60LZnlwZURCC7FBmyewMIqOg8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-pGY34mJmPnWOGq_DU8e4PA-1; Thu, 04 Aug 2022 00:36:01 -0400
X-MC-Unique: pGY34mJmPnWOGq_DU8e4PA-1
Received: by mail-pj1-f72.google.com with SMTP id 92-20020a17090a09e500b001d917022847so8207622pjo.1
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 21:36:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3pusb/gArFFwJGvdatRkIk+S/33mt+/MIat6GqC/G1Q=;
        b=WI2puVU+drmWY4bA5J1pd7g4/9Gw8wuiHjOVQOUIYyumt7hDz3N2i9YjmC5rDZAC/t
         N9URqittd5VrMdRIxyYJzbVNmmgR3y9yZrnaH1um1ZsmfnP4s6GVyUCfywPlStSqpmmA
         RgiZbD3CSNYjmlCaqckRmuVJBPZEFtue0gWjGp7bufYf45+VqYWaLIaWYm/6kHDpIkmk
         oCwtEqQdveBqnSzVqlQqJEwKIx2L2mrVWU5Yrde1eaxxqh/+jzC4Vv6mqj7BMgPK6HDe
         PrjLAQqTKfnPSNmSnlZw1J+SrX3Cdp9FZL4PVz+fCZAqt3agTeAP6wunlgY/cxuxn7ST
         SIFw==
X-Gm-Message-State: ACgBeo1V2IFSB/IX/rm1apkltzslyDi1Xu28+pHoPHEaHokOUl5W/QwK
        9y4JTLte2ZW096orHeIVYMmdicsOfT4SSpBd5fyY7rUwXfnsK11L4THyGcJAh0x1hFIEDCzw6pU
        c9Cfe9wpW1QKK
X-Received: by 2002:a63:688a:0:b0:412:6728:4bf3 with SMTP id d132-20020a63688a000000b0041267284bf3mr129808pgc.339.1659587760492;
        Wed, 03 Aug 2022 21:36:00 -0700 (PDT)
X-Google-Smtp-Source: AA6agR48+uv2EDVbrKWm5/8sZOq5h+c4brLjiVHqiPOE++XMa6GPhG1Nt2KEPsW41VUaRCkmfzgRAg==
X-Received: by 2002:a63:688a:0:b0:412:6728:4bf3 with SMTP id d132-20020a63688a000000b0041267284bf3mr129785pgc.339.1659587760107;
        Wed, 03 Aug 2022 21:36:00 -0700 (PDT)
Received: from [10.72.12.192] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l7-20020a170903244700b0016cd74dae66sm2920856pls.28.2022.08.03.21.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 21:35:59 -0700 (PDT)
Message-ID: <a0b976bd-112b-1c0c-34f2-a9de38241fb8@redhat.com>
Date:   Thu, 4 Aug 2022 12:35:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v3 4/7] vdpa: Add asid parameter to
 vhost_vdpa_dma_map/unmap
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
 <20220803171821.481336-5-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220803171821.481336-5-eperezma@redhat.com>
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
> So the caller can choose which ASID is destined.
>
> No need to update the batch functions as they will always be called from
> memory listener updates at the moment. Memory listener updates will
> always update ASID 0, as it's the passthrough ASID.
>
> All vhost devices's ASID are 0 at this moment.
>
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> ---
> v3: Deleted unneeded space
> ---
>   include/hw/virtio/vhost-vdpa.h |  8 +++++---
>   hw/virtio/vhost-vdpa.c         | 25 +++++++++++++++----------
>   net/vhost-vdpa.c               |  6 +++---
>   hw/virtio/trace-events         |  4 ++--
>   4 files changed, 25 insertions(+), 18 deletions(-)
>
> diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost-vdpa.h
> index 1111d85643..6560bb9d78 100644
> --- a/include/hw/virtio/vhost-vdpa.h
> +++ b/include/hw/virtio/vhost-vdpa.h
> @@ -29,6 +29,7 @@ typedef struct vhost_vdpa {
>       int index;
>       uint32_t msg_type;
>       bool iotlb_batch_begin_sent;
> +    uint32_t address_space_id;
>       MemoryListener listener;
>       struct vhost_vdpa_iova_range iova_range;
>       uint64_t acked_features;
> @@ -42,8 +43,9 @@ typedef struct vhost_vdpa {
>       VhostVDPAHostNotifier notifier[VIRTIO_QUEUE_MAX];
>   } VhostVDPA;
>   
> -int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
> -                       void *vaddr, bool readonly);
> -int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, hwaddr iova, hwaddr size);
> +int vhost_vdpa_dma_map(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
> +                       hwaddr size, void *vaddr, bool readonly);
> +int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
> +                         hwaddr size);
>   
>   #endif
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 2fefcc66ad..131100841c 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -72,22 +72,24 @@ static bool vhost_vdpa_listener_skipped_section(MemoryRegionSection *section,
>       return false;
>   }
>   
> -int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
> -                       void *vaddr, bool readonly)
> +int vhost_vdpa_dma_map(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
> +                       hwaddr size, void *vaddr, bool readonly)
>   {
>       struct vhost_msg_v2 msg = {};
>       int fd = v->device_fd;
>       int ret = 0;
>   
>       msg.type = v->msg_type;
> +    msg.asid = asid;


I wonder what happens if we're running is a kernel without ASID support.

Does it work since asid will be simply ignored? Can we have a case that 
we want asid!=0 on old kernel?

Thanks


>       msg.iotlb.iova = iova;
>       msg.iotlb.size = size;
>       msg.iotlb.uaddr = (uint64_t)(uintptr_t)vaddr;
>       msg.iotlb.perm = readonly ? VHOST_ACCESS_RO : VHOST_ACCESS_RW;
>       msg.iotlb.type = VHOST_IOTLB_UPDATE;
>   
> -   trace_vhost_vdpa_dma_map(v, fd, msg.type, msg.iotlb.iova, msg.iotlb.size,
> -                            msg.iotlb.uaddr, msg.iotlb.perm, msg.iotlb.type);
> +    trace_vhost_vdpa_dma_map(v, fd, msg.type, msg.asid, msg.iotlb.iova,
> +                             msg.iotlb.size, msg.iotlb.uaddr, msg.iotlb.perm,
> +                             msg.iotlb.type);
>   
>       if (write(fd, &msg, sizeof(msg)) != sizeof(msg)) {
>           error_report("failed to write, fd=%d, errno=%d (%s)",
> @@ -98,18 +100,20 @@ int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
>       return ret;
>   }
>   
> -int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, hwaddr iova, hwaddr size)
> +int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
> +                         hwaddr size)
>   {
>       struct vhost_msg_v2 msg = {};
>       int fd = v->device_fd;
>       int ret = 0;
>   
>       msg.type = v->msg_type;
> +    msg.asid = asid;
>       msg.iotlb.iova = iova;
>       msg.iotlb.size = size;
>       msg.iotlb.type = VHOST_IOTLB_INVALIDATE;
>   
> -    trace_vhost_vdpa_dma_unmap(v, fd, msg.type, msg.iotlb.iova,
> +    trace_vhost_vdpa_dma_unmap(v, fd, msg.type, msg.asid, msg.iotlb.iova,
>                                  msg.iotlb.size, msg.iotlb.type);
>   
>       if (write(fd, &msg, sizeof(msg)) != sizeof(msg)) {
> @@ -229,7 +233,7 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
>       }
>   
>       vhost_vdpa_iotlb_batch_begin_once(v);
> -    ret = vhost_vdpa_dma_map(v, iova, int128_get64(llsize),
> +    ret = vhost_vdpa_dma_map(v, 0, iova, int128_get64(llsize),
>                                vaddr, section->readonly);
>       if (ret) {
>           error_report("vhost vdpa map fail!");
> @@ -299,7 +303,7 @@ static void vhost_vdpa_listener_region_del(MemoryListener *listener,
>           vhost_iova_tree_remove(v->iova_tree, result);
>       }
>       vhost_vdpa_iotlb_batch_begin_once(v);
> -    ret = vhost_vdpa_dma_unmap(v, iova, int128_get64(llsize));
> +    ret = vhost_vdpa_dma_unmap(v, 0, iova, int128_get64(llsize));
>       if (ret) {
>           error_report("vhost_vdpa dma unmap error!");
>       }
> @@ -890,7 +894,7 @@ static bool vhost_vdpa_svq_unmap_ring(struct vhost_vdpa *v,
>       }
>   
>       size = ROUND_UP(result->size, qemu_real_host_page_size());
> -    r = vhost_vdpa_dma_unmap(v, result->iova, size);
> +    r = vhost_vdpa_dma_unmap(v, v->address_space_id, result->iova, size);
>       return r == 0;
>   }
>   
> @@ -932,7 +936,8 @@ static bool vhost_vdpa_svq_map_ring(struct vhost_vdpa *v, DMAMap *needle,
>           return false;
>       }
>   
> -    r = vhost_vdpa_dma_map(v, needle->iova, needle->size + 1,
> +    r = vhost_vdpa_dma_map(v, v->address_space_id, needle->iova,
> +                           needle->size + 1,
>                              (void *)(uintptr_t)needle->translated_addr,
>                              needle->perm == IOMMU_RO);
>       if (unlikely(r != 0)) {
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index f933ba53a3..f96c3cb1da 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -239,7 +239,7 @@ static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
>           return;
>       }
>   
> -    r = vhost_vdpa_dma_unmap(v, map->iova, map->size + 1);
> +    r = vhost_vdpa_dma_unmap(v, v->address_space_id, map->iova, map->size + 1);
>       if (unlikely(r != 0)) {
>           error_report("Device cannot unmap: %s(%d)", g_strerror(r), r);
>       }
> @@ -288,8 +288,8 @@ static bool vhost_vdpa_cvq_map_buf(struct vhost_vdpa *v,
>           return false;
>       }
>   
> -    r = vhost_vdpa_dma_map(v, map.iova, vhost_vdpa_net_cvq_cmd_page_len(), buf,
> -                           !write);
> +    r = vhost_vdpa_dma_map(v, v->address_space_id, map.iova,
> +                           vhost_vdpa_net_cvq_cmd_page_len(), buf, !write);
>       if (unlikely(r < 0)) {
>           goto dma_map_err;
>       }
> diff --git a/hw/virtio/trace-events b/hw/virtio/trace-events
> index 20af2e7ebd..36e5ae75f6 100644
> --- a/hw/virtio/trace-events
> +++ b/hw/virtio/trace-events
> @@ -26,8 +26,8 @@ vhost_user_write(uint32_t req, uint32_t flags) "req:%d flags:0x%"PRIx32""
>   vhost_user_create_notifier(int idx, void *n) "idx:%d n:%p"
>   
>   # vhost-vdpa.c
> -vhost_vdpa_dma_map(void *vdpa, int fd, uint32_t msg_type, uint64_t iova, uint64_t size, uint64_t uaddr, uint8_t perm, uint8_t type) "vdpa:%p fd: %d msg_type: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" uaddr: 0x%"PRIx64" perm: 0x%"PRIx8" type: %"PRIu8
> -vhost_vdpa_dma_unmap(void *vdpa, int fd, uint32_t msg_type, uint64_t iova, uint64_t size, uint8_t type) "vdpa:%p fd: %d msg_type: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" type: %"PRIu8
> +vhost_vdpa_dma_map(void *vdpa, int fd, uint32_t msg_type, uint32_t asid, uint64_t iova, uint64_t size, uint64_t uaddr, uint8_t perm, uint8_t type) "vdpa:%p fd: %d msg_type: %"PRIu32" asid: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" uaddr: 0x%"PRIx64" perm: 0x%"PRIx8" type: %"PRIu8
> +vhost_vdpa_dma_unmap(void *vdpa, int fd, uint32_t msg_type, uint32_t asid, uint64_t iova, uint64_t size, uint8_t type) "vdpa:%p fd: %d msg_type: %"PRIu32" asid: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" type: %"PRIu8
>   vhost_vdpa_listener_begin_batch(void *v, int fd, uint32_t msg_type, uint8_t type)  "vdpa:%p fd: %d msg_type: %"PRIu32" type: %"PRIu8
>   vhost_vdpa_listener_commit(void *v, int fd, uint32_t msg_type, uint8_t type)  "vdpa:%p fd: %d msg_type: %"PRIu32" type: %"PRIu8
>   vhost_vdpa_listener_region_add(void *vdpa, uint64_t iova, uint64_t llend, void *vaddr, bool readonly) "vdpa: %p iova 0x%"PRIx64" llend 0x%"PRIx64" vaddr: %p read-only: %d"

