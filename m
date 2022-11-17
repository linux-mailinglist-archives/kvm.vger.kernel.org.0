Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7764262D2E5
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 06:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239064AbiKQFrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 00:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239029AbiKQFqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 00:46:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED736174E
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 21:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668663960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BtdoskQjcoHK0Pmy3hXWFgBFDBh739YMepNJmtBpfAY=;
        b=LEtYfdTO+IyB3s6ZnTL2SyXA/+Sosarpxzm7zbfRkooNBgTmdgKfmVlwuExK1Lmo7Shghr
        8P2wYWiI7+jiwCOpLyC/XyDc1+9Pqi0NzpWphFdV80EF/muKbX/gGAloTg5Nq0bsekOgOb
        IU44eDYV3JqILwCHuo1nuDUzN5J79vA=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-332-Lu3jgzrxNHqjluoEsIG3qQ-1; Thu, 17 Nov 2022 00:45:58 -0500
X-MC-Unique: Lu3jgzrxNHqjluoEsIG3qQ-1
Received: by mail-oi1-f200.google.com with SMTP id 13-20020aca280d000000b0035a3c3d34c7so411297oix.21
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 21:45:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BtdoskQjcoHK0Pmy3hXWFgBFDBh739YMepNJmtBpfAY=;
        b=cn/diXoOWpfx8lkvsmFT5P1/OHZIPaVAGa4j9EecOyv5c66xDsS65H+Z4tsEpTnEQT
         uSFyOprlOZ2+HUP7N6IPOMP12XniFfc7Ms5VqDaoWrxI0ZyHp8MfvsvK3Y5CquGlooA/
         mHsg1rCzD9wdPVwTZSZGgn+tQ9hPBycUxhCBX6qJfXVxAT+qBJbp03ogEabJlLoTown5
         N282+LNHHQYRX61RmG6ngEob6EFKiMwy75DAw4PM2ysUyq/BdI0CFx5ZACb3a9DxuQPG
         MiJ5Jb299Y5azeQliSuwHuO5eZabh/iDtuVP66YdKEA+5VABUfH+hjiZDxpInbTmxmqq
         1Cmg==
X-Gm-Message-State: ANoB5pmWw7aLBFJd+Yw8mHR5DiCujOvoRZEdIVaaaq/K38k0PJFa7Jcp
        KjGsg9yDaxok4mQyQS49YTg0J3hAsyF7SAV/9FJAfUP+8fwZ8p7fo3ibNyMuPzfvMoc8WYa8igW
        nFVNaAFoojllrj79nq5BXRmFEkDO5
X-Received: by 2002:a05:6870:1e83:b0:132:7b3:29ac with SMTP id pb3-20020a0568701e8300b0013207b329acmr3468104oab.35.1668663958044;
        Wed, 16 Nov 2022 21:45:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5o3A2pk1Ig3u4EljJ3Sz0sNmrXrwr3drFgESi7p9ocxigUf/Tl1iiOYbvT/ESQXGSC5bMSg3vfYXbKkE3liA0=
X-Received: by 2002:a05:6870:1e83:b0:132:7b3:29ac with SMTP id
 pb3-20020a0568701e8300b0013207b329acmr3468093oab.35.1668663957764; Wed, 16
 Nov 2022 21:45:57 -0800 (PST)
MIME-Version: 1.0
References: <20221116150556.1294049-1-eperezma@redhat.com> <20221116150556.1294049-8-eperezma@redhat.com>
In-Reply-To: <20221116150556.1294049-8-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 17 Nov 2022 13:45:46 +0800
Message-ID: <CACGkMEsVdDS52T_qDe6St5-vZuQc4vOkm0zR0FxS+YUxPLWPHw@mail.gmail.com>
Subject: Re: [PATCH for 8.0 v7 07/10] vdpa: Add asid parameter to vhost_vdpa_dma_map/unmap
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 11:06 PM Eugenio P=C3=A9rez <eperezma@redhat.com> w=
rote:
>
> So the caller can choose which ASID is destined.
>
> No need to update the batch functions as they will always be called from
> memory listener updates at the moment. Memory listener updates will
> always update ASID 0, as it's the passthrough ASID.
>
> All vhost devices's ASID are 0 at this moment.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
> v7:
> * Move comment on zero initailization of vhost_vdpa_dma_map above the
>   functions.
> * Add VHOST_VDPA_GUEST_PA_ASID macro.
>
> v5:
> * Solve conflict, now vhost_vdpa_svq_unmap_ring returns void
> * Change comment on zero initialization.
>
> v4: Add comment specifying behavior if device does not support _F_ASID
>
> v3: Deleted unneeded space
> ---
>  include/hw/virtio/vhost-vdpa.h | 14 ++++++++++---
>  hw/virtio/vhost-vdpa.c         | 36 +++++++++++++++++++++++-----------
>  net/vhost-vdpa.c               |  6 +++---
>  hw/virtio/trace-events         |  4 ++--
>  4 files changed, 41 insertions(+), 19 deletions(-)
>
> diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost-vdp=
a.h
> index 1111d85643..e57dfa1fd1 100644
> --- a/include/hw/virtio/vhost-vdpa.h
> +++ b/include/hw/virtio/vhost-vdpa.h
> @@ -19,6 +19,12 @@
>  #include "hw/virtio/virtio.h"
>  #include "standard-headers/linux/vhost_types.h"
>
> +/*
> + * ASID dedicated to map guest's addresses.  If SVQ is disabled it maps =
GPA to
> + * qemu's IOVA.  If SVQ is enabled it maps also the SVQ vring here
> + */
> +#define VHOST_VDPA_GUEST_PA_ASID 0
> +
>  typedef struct VhostVDPAHostNotifier {
>      MemoryRegion mr;
>      void *addr;
> @@ -29,6 +35,7 @@ typedef struct vhost_vdpa {
>      int index;
>      uint32_t msg_type;
>      bool iotlb_batch_begin_sent;
> +    uint32_t address_space_id;
>      MemoryListener listener;
>      struct vhost_vdpa_iova_range iova_range;
>      uint64_t acked_features;
> @@ -42,8 +49,9 @@ typedef struct vhost_vdpa {
>      VhostVDPAHostNotifier notifier[VIRTIO_QUEUE_MAX];
>  } VhostVDPA;
>
> -int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
> -                       void *vaddr, bool readonly);
> -int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, hwaddr iova, hwaddr size)=
;
> +int vhost_vdpa_dma_map(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
> +                       hwaddr size, void *vaddr, bool readonly);
> +int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, uint32_t asid, hwaddr iov=
a,
> +                         hwaddr size);
>
>  #endif
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 23efb8f49d..1e4e1cb523 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -72,22 +72,28 @@ static bool vhost_vdpa_listener_skipped_section(Memor=
yRegionSection *section,
>      return false;
>  }
>
> -int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
> -                       void *vaddr, bool readonly)
> +/*
> + * The caller must set asid =3D 0 if the device does not support asid.
> + * This is not an ABI break since it is set to 0 by the initializer anyw=
ay.
> + */
> +int vhost_vdpa_dma_map(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
> +                       hwaddr size, void *vaddr, bool readonly)
>  {
>      struct vhost_msg_v2 msg =3D {};
>      int fd =3D v->device_fd;
>      int ret =3D 0;
>
>      msg.type =3D v->msg_type;
> +    msg.asid =3D asid;
>      msg.iotlb.iova =3D iova;
>      msg.iotlb.size =3D size;
>      msg.iotlb.uaddr =3D (uint64_t)(uintptr_t)vaddr;
>      msg.iotlb.perm =3D readonly ? VHOST_ACCESS_RO : VHOST_ACCESS_RW;
>      msg.iotlb.type =3D VHOST_IOTLB_UPDATE;
>
> -   trace_vhost_vdpa_dma_map(v, fd, msg.type, msg.iotlb.iova, msg.iotlb.s=
ize,
> -                            msg.iotlb.uaddr, msg.iotlb.perm, msg.iotlb.t=
ype);
> +    trace_vhost_vdpa_dma_map(v, fd, msg.type, msg.asid, msg.iotlb.iova,
> +                             msg.iotlb.size, msg.iotlb.uaddr, msg.iotlb.=
perm,
> +                             msg.iotlb.type);
>
>      if (write(fd, &msg, sizeof(msg)) !=3D sizeof(msg)) {
>          error_report("failed to write, fd=3D%d, errno=3D%d (%s)",
> @@ -98,18 +104,24 @@ int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr =
iova, hwaddr size,
>      return ret;
>  }
>
> -int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, hwaddr iova, hwaddr size)
> +/*
> + * The caller must set asid =3D 0 if the device does not support asid.
> + * This is not an ABI break since it is set to 0 by the initializer anyw=
ay.
> + */
> +int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, uint32_t asid, hwaddr iov=
a,
> +                         hwaddr size)
>  {
>      struct vhost_msg_v2 msg =3D {};
>      int fd =3D v->device_fd;
>      int ret =3D 0;
>
>      msg.type =3D v->msg_type;
> +    msg.asid =3D asid;
>      msg.iotlb.iova =3D iova;
>      msg.iotlb.size =3D size;
>      msg.iotlb.type =3D VHOST_IOTLB_INVALIDATE;
>
> -    trace_vhost_vdpa_dma_unmap(v, fd, msg.type, msg.iotlb.iova,
> +    trace_vhost_vdpa_dma_unmap(v, fd, msg.type, msg.asid, msg.iotlb.iova=
,
>                                 msg.iotlb.size, msg.iotlb.type);
>
>      if (write(fd, &msg, sizeof(msg)) !=3D sizeof(msg)) {
> @@ -229,8 +241,8 @@ static void vhost_vdpa_listener_region_add(MemoryList=
ener *listener,
>      }
>
>      vhost_vdpa_iotlb_batch_begin_once(v);
> -    ret =3D vhost_vdpa_dma_map(v, iova, int128_get64(llsize),
> -                             vaddr, section->readonly);
> +    ret =3D vhost_vdpa_dma_map(v, VHOST_VDPA_GUEST_PA_ASID, iova,
> +                             int128_get64(llsize), vaddr, section->reado=
nly);
>      if (ret) {
>          error_report("vhost vdpa map fail!");
>          goto fail_map;
> @@ -303,7 +315,8 @@ static void vhost_vdpa_listener_region_del(MemoryList=
ener *listener,
>          vhost_iova_tree_remove(v->iova_tree, *result);
>      }
>      vhost_vdpa_iotlb_batch_begin_once(v);
> -    ret =3D vhost_vdpa_dma_unmap(v, iova, int128_get64(llsize));
> +    ret =3D vhost_vdpa_dma_unmap(v, VHOST_VDPA_GUEST_PA_ASID, iova,
> +                               int128_get64(llsize));
>      if (ret) {
>          error_report("vhost_vdpa dma unmap error!");
>      }
> @@ -884,7 +897,7 @@ static void vhost_vdpa_svq_unmap_ring(struct vhost_vd=
pa *v, hwaddr addr)
>      }
>
>      size =3D ROUND_UP(result->size, qemu_real_host_page_size());
> -    r =3D vhost_vdpa_dma_unmap(v, result->iova, size);
> +    r =3D vhost_vdpa_dma_unmap(v, v->address_space_id, result->iova, siz=
e);
>      if (unlikely(r < 0)) {
>          error_report("Unable to unmap SVQ vring: %s (%d)", g_strerror(-r=
), -r);
>          return;
> @@ -924,7 +937,8 @@ static bool vhost_vdpa_svq_map_ring(struct vhost_vdpa=
 *v, DMAMap *needle,
>          return false;
>      }
>
> -    r =3D vhost_vdpa_dma_map(v, needle->iova, needle->size + 1,
> +    r =3D vhost_vdpa_dma_map(v, v->address_space_id, needle->iova,
> +                           needle->size + 1,
>                             (void *)(uintptr_t)needle->translated_addr,
>                             needle->perm =3D=3D IOMMU_RO);
>      if (unlikely(r !=3D 0)) {
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index dd9cea42d0..89b01fcaec 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -258,7 +258,7 @@ static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdp=
a *v, void *addr)
>          return;
>      }
>
> -    r =3D vhost_vdpa_dma_unmap(v, map->iova, map->size + 1);
> +    r =3D vhost_vdpa_dma_unmap(v, v->address_space_id, map->iova, map->s=
ize + 1);
>      if (unlikely(r !=3D 0)) {
>          error_report("Device cannot unmap: %s(%d)", g_strerror(r), r);
>      }
> @@ -298,8 +298,8 @@ static int vhost_vdpa_cvq_map_buf(struct vhost_vdpa *=
v, void *buf, size_t size,
>          return r;
>      }
>
> -    r =3D vhost_vdpa_dma_map(v, map.iova, vhost_vdpa_net_cvq_cmd_page_le=
n(), buf,
> -                           !write);
> +    r =3D vhost_vdpa_dma_map(v, v->address_space_id, map.iova,
> +                           vhost_vdpa_net_cvq_cmd_page_len(), buf, !writ=
e);
>      if (unlikely(r < 0)) {
>          goto dma_map_err;
>      }
> diff --git a/hw/virtio/trace-events b/hw/virtio/trace-events
> index 820dadc26c..0ad9390307 100644
> --- a/hw/virtio/trace-events
> +++ b/hw/virtio/trace-events
> @@ -30,8 +30,8 @@ vhost_user_write(uint32_t req, uint32_t flags) "req:%d =
flags:0x%"PRIx32""
>  vhost_user_create_notifier(int idx, void *n) "idx:%d n:%p"
>
>  # vhost-vdpa.c
> -vhost_vdpa_dma_map(void *vdpa, int fd, uint32_t msg_type, uint64_t iova,=
 uint64_t size, uint64_t uaddr, uint8_t perm, uint8_t type) "vdpa:%p fd: %d=
 msg_type: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" uaddr: 0x%"PRIx64"=
 perm: 0x%"PRIx8" type: %"PRIu8
> -vhost_vdpa_dma_unmap(void *vdpa, int fd, uint32_t msg_type, uint64_t iov=
a, uint64_t size, uint8_t type) "vdpa:%p fd: %d msg_type: %"PRIu32" iova: 0=
x%"PRIx64" size: 0x%"PRIx64" type: %"PRIu8
> +vhost_vdpa_dma_map(void *vdpa, int fd, uint32_t msg_type, uint32_t asid,=
 uint64_t iova, uint64_t size, uint64_t uaddr, uint8_t perm, uint8_t type) =
"vdpa:%p fd: %d msg_type: %"PRIu32" asid: %"PRIu32" iova: 0x%"PRIx64" size:=
 0x%"PRIx64" uaddr: 0x%"PRIx64" perm: 0x%"PRIx8" type: %"PRIu8
> +vhost_vdpa_dma_unmap(void *vdpa, int fd, uint32_t msg_type, uint32_t asi=
d, uint64_t iova, uint64_t size, uint8_t type) "vdpa:%p fd: %d msg_type: %"=
PRIu32" asid: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" type: %"PRIu8
>  vhost_vdpa_listener_begin_batch(void *v, int fd, uint32_t msg_type, uint=
8_t type)  "vdpa:%p fd: %d msg_type: %"PRIu32" type: %"PRIu8
>  vhost_vdpa_listener_commit(void *v, int fd, uint32_t msg_type, uint8_t t=
ype)  "vdpa:%p fd: %d msg_type: %"PRIu32" type: %"PRIu8
>  vhost_vdpa_listener_region_add(void *vdpa, uint64_t iova, uint64_t llend=
, void *vaddr, bool readonly) "vdpa: %p iova 0x%"PRIx64" llend 0x%"PRIx64" =
vaddr: %p read-only: %d"
> --
> 2.31.1
>

