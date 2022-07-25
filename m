Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9594857FC8B
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 11:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbiGYJgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 05:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbiGYJgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 05:36:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 511DAA18D
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 02:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658741800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AOYFRhGkb10OAe8LzC2iXHQJ5iqncr95aKZsdocQoTE=;
        b=F7KMhgLO9ZUn/ehncm8tO6pkH0inKJh8ia7xXQOeiylyCH+kWnwPIUlFXwfsnpTmKM7HaX
        P4ojBo11kzARMyUC51Q2odNMLzVdL60ZHBfSkcNgJvxFERI97MnORBgC07Emnc26S5uquE
        caIqXgevsezTaFT+Df/Euec4sPCrvjw=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-w5duZuEwMymEFCvPAB3wDw-1; Mon, 25 Jul 2022 05:36:38 -0400
X-MC-Unique: w5duZuEwMymEFCvPAB3wDw-1
Received: by mail-pf1-f199.google.com with SMTP id r7-20020aa79627000000b00528beaf82c3so3572759pfg.8
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 02:36:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AOYFRhGkb10OAe8LzC2iXHQJ5iqncr95aKZsdocQoTE=;
        b=dpgp57kvAgwnJCxIIrHBjjrFw/CPsmfZMKBcZMjMoLKjyokK+Mzrzxd2rELnB+nUns
         JCkIDKZt1yS+JDvnolbmFX1suekZ7iVzaDnwHWef0t1dAnmZD2bkpjJjCkehaeFPpyfN
         286d3uJspmJNs2ZNG6NpYwubr9iY2/sEmN+3+2Z1XRpVS4bbzeN768RZ7sXOabzp0jjh
         HmvDmHLFt2m/alzpBXDvoFMG8szLPoLmk34Ul2ZfhmpJ62iA3Vsv/v8HODqdN7rowZ1I
         piYJ/ns77s407yvrt8dXF5h3RHw9w43tX+GPxge7C5B06TIQg7ZypHvRi/7e2UccKBlY
         oaoA==
X-Gm-Message-State: AJIora+91ZpJSXbJngbayrVFXim6RKyaWZJE5mWujQvXXjlUioRZBUEu
        juCkxBMIOllfheyJ4PbkZQ/3wj5SnSTk+oy/cW1ZHbEB+HvNPLOgqhzo4MM1aiheeHBTtpdy/LP
        ek6GGR412OW37
X-Received: by 2002:a62:3884:0:b0:52b:ead1:7bc8 with SMTP id f126-20020a623884000000b0052bead17bc8mr9166316pfa.78.1658741797525;
        Mon, 25 Jul 2022 02:36:37 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uAJPwLww74z3mRYesDxBU6PPDsp78NaoLITE97YOswfQ8HkwxKokcN0osi5NGWFDnkVbKTzg==
X-Received: by 2002:a62:3884:0:b0:52b:ead1:7bc8 with SMTP id f126-20020a623884000000b0052bead17bc8mr9166277pfa.78.1658741797065;
        Mon, 25 Jul 2022 02:36:37 -0700 (PDT)
Received: from [10.72.13.203] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902a50600b0016a0ac06424sm8739568plq.51.2022.07.25.02.36.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 02:36:36 -0700 (PDT)
Message-ID: <22b35cff-bcd5-78b8-cab4-43d2e65dccbe@redhat.com>
Date:   Mon, 25 Jul 2022 17:36:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v2 4/7] vdpa: Add asid parameter to
 vhost_vdpa_dma_map/unmap
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
 <20220722134318.3430667-5-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220722134318.3430667-5-eperezma@redhat.com>
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


在 2022/7/22 21:43, Eugenio Pérez 写道:
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
>   include/hw/virtio/vhost-vdpa.h |  8 +++++---
>   hw/virtio/vhost-vdpa.c         | 26 ++++++++++++++++----------
>   net/vhost-vdpa.c               |  6 +++---
>   hw/virtio/trace-events         |  4 ++--
>   4 files changed, 26 insertions(+), 18 deletions(-)
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
> index e1ed56b26d..79623badf2 100644
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
> @@ -228,7 +232,7 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
>       }
>   
>       vhost_vdpa_iotlb_batch_begin_once(v);
> -    ret = vhost_vdpa_dma_map(v, iova, int128_get64(llsize),
> +    ret = vhost_vdpa_dma_map(v, 0, iova, int128_get64(llsize),
>                                vaddr, section->readonly);
>       if (ret) {
>           error_report("vhost vdpa map fail!");
> @@ -293,7 +297,7 @@ static void vhost_vdpa_listener_region_del(MemoryListener *listener,
>           vhost_iova_tree_remove(v->iova_tree, result);
>       }
>       vhost_vdpa_iotlb_batch_begin_once(v);
> -    ret = vhost_vdpa_dma_unmap(v, iova, int128_get64(llsize));
> +    ret = vhost_vdpa_dma_unmap(v, 0, iova, int128_get64(llsize));
>       if (ret) {
>           error_report("vhost_vdpa dma unmap error!");
>       }
> @@ -884,7 +888,7 @@ static bool vhost_vdpa_svq_unmap_ring(struct vhost_vdpa *v,
>       }
>   
>       size = ROUND_UP(result->size, qemu_real_host_page_size());
> -    r = vhost_vdpa_dma_unmap(v, result->iova, size);
> +    r = vhost_vdpa_dma_unmap(v, v->address_space_id, result->iova, size);
>       return r == 0;
>   }
>   
> @@ -926,7 +930,8 @@ static bool vhost_vdpa_svq_map_ring(struct vhost_vdpa *v, DMAMap *needle,
>           return false;
>       }
>   
> -    r = vhost_vdpa_dma_map(v, needle->iova, needle->size + 1,
> +    r = vhost_vdpa_dma_map(v, v->address_space_id, needle->iova,
> +                           needle->size + 1,
>                              (void *)(uintptr_t)needle->translated_addr,
>                              needle->perm == IOMMU_RO);
>       if (unlikely(r != 0)) {
> @@ -1092,6 +1097,7 @@ static int vhost_vdpa_dev_start(struct vhost_dev *dev, bool started)
>   
>       if (started) {
>           vhost_vdpa_host_notifiers_init(dev);
> +


Unnecessary changes.

Other looks good.

Thanks


>           ok = vhost_vdpa_svqs_start(dev);
>           if (unlikely(!ok)) {
>               return -1;
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index 75143ded8b..8203200c2a 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -229,7 +229,7 @@ static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
>           return;
>       }
>   
> -    r = vhost_vdpa_dma_unmap(v, map->iova, map->size + 1);
> +    r = vhost_vdpa_dma_unmap(v, v->address_space_id, map->iova, map->size + 1);
>       if (unlikely(r != 0)) {
>           error_report("Device cannot unmap: %s(%d)", g_strerror(r), r);
>       }
> @@ -278,8 +278,8 @@ static bool vhost_vdpa_cvq_map_buf(struct vhost_vdpa *v,
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

