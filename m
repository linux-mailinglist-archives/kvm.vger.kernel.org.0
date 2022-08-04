Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00C65898A1
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 09:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239211AbiHDHs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 03:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiHDHs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 03:48:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0F5F33A03
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 00:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659599334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eD7ROU0wXyXqJ34qnm9zR/26AxTneE/OFfaQEE4mo4k=;
        b=fq8VXFHkq1zVr7U23ACQdd6RSKdiySx1/HIapw0HIlY4KCvO0wjkS2IjCK6ap1gv3HZ6kj
        dlVciqXMx+AR3e7FMVUsnhrWIlD88XOpg3rpK6Ap101tVNjJ4u4yoRWQOnFfrutHr75gHl
        bTTtVBjGfkevnwYrNGOr/xk7ylIJ88U=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-FJJ2az7qN3mmwAp5Aw_iEg-1; Thu, 04 Aug 2022 03:48:53 -0400
X-MC-Unique: FJJ2az7qN3mmwAp5Aw_iEg-1
Received: by mail-qv1-f72.google.com with SMTP id m11-20020a0cfbab000000b004738181b474so11300261qvp.6
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 00:48:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eD7ROU0wXyXqJ34qnm9zR/26AxTneE/OFfaQEE4mo4k=;
        b=aDD+LF0dedUy2y0xyTc7Zn1WsZoBv2s6GLbtw/lgJ0dDlautbTLvt5lYvt3KynKz2P
         Fu9qAo2zZlgL3pWZ6nJuX0oyMGK8qg3liqQLFyGuYRsAclku5HxeUjazI7ovRnEQrTDA
         9riDROTZ13DwCVPYCySWBSOobSyp0POZuRE75JlbkRmEbXBdxAX9ye5DFe0wPCEL4xRa
         DoyJz1U53fG9wQtIa2cFOBg5FB6xFIed+Qubvmvww8ROknfIyo3l+jfe19Y2NTstodFB
         ZFV2Xx24ryfqXjP+MLdfL8jOggJ+AWzAy5VGMj4sUQimprZWBFspbKiP8csB54JnLFVk
         PfLQ==
X-Gm-Message-State: ACgBeo20s92K46BGqCvDaV8RLkpRkwWYvlIs7Z2hTa7DEoyvBYXy1jDr
        A3H/TpBheQ75mEfwavksySAKootdl9NDC3Iye1WIEUQ07hwQTPkixtZr06l8LIqA8x8uBOE/XOa
        VyXB02Gob/V2nJFkn1KgBBKkBbptv
X-Received: by 2002:a05:620a:f10:b0:6aa:318e:55a9 with SMTP id v16-20020a05620a0f1000b006aa318e55a9mr403713qkl.559.1659599332543;
        Thu, 04 Aug 2022 00:48:52 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7QxYu/BDPwczpgWz25YFHTHZ7pSe/W7kEAQNCgPTPyB0zBdfzcGHuM19DwX6wi/nu78/siUxfcwiZZ74Rjh/Y=
X-Received: by 2002:a05:620a:f10:b0:6aa:318e:55a9 with SMTP id
 v16-20020a05620a0f1000b006aa318e55a9mr403693qkl.559.1659599332243; Thu, 04
 Aug 2022 00:48:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220803171821.481336-1-eperezma@redhat.com> <20220803171821.481336-5-eperezma@redhat.com>
 <a0b976bd-112b-1c0c-34f2-a9de38241fb8@redhat.com>
In-Reply-To: <a0b976bd-112b-1c0c-34f2-a9de38241fb8@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 4 Aug 2022 09:48:16 +0200
Message-ID: <CAJaqyWc--=vLGp9_q+K+dwd1YZL8NKeaQ0W-m_ei8Tm352haog@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] vdpa: Add asid parameter to vhost_vdpa_dma_map/unmap
To:     Jason Wang <jasowang@redhat.com>
Cc:     qemu-level <qemu-devel@nongnu.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Parav Pandit <parav@mellanox.com>, Cindy Lu <lulu@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 4, 2022 at 6:36 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/8/4 01:18, Eugenio P=C3=A9rez =E5=86=99=E9=81=93:
> > So the caller can choose which ASID is destined.
> >
> > No need to update the batch functions as they will always be called fro=
m
> > memory listener updates at the moment. Memory listener updates will
> > always update ASID 0, as it's the passthrough ASID.
> >
> > All vhost devices's ASID are 0 at this moment.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> > v3: Deleted unneeded space
> > ---
> >   include/hw/virtio/vhost-vdpa.h |  8 +++++---
> >   hw/virtio/vhost-vdpa.c         | 25 +++++++++++++++----------
> >   net/vhost-vdpa.c               |  6 +++---
> >   hw/virtio/trace-events         |  4 ++--
> >   4 files changed, 25 insertions(+), 18 deletions(-)
> >
> > diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost-v=
dpa.h
> > index 1111d85643..6560bb9d78 100644
> > --- a/include/hw/virtio/vhost-vdpa.h
> > +++ b/include/hw/virtio/vhost-vdpa.h
> > @@ -29,6 +29,7 @@ typedef struct vhost_vdpa {
> >       int index;
> >       uint32_t msg_type;
> >       bool iotlb_batch_begin_sent;
> > +    uint32_t address_space_id;
> >       MemoryListener listener;
> >       struct vhost_vdpa_iova_range iova_range;
> >       uint64_t acked_features;
> > @@ -42,8 +43,9 @@ typedef struct vhost_vdpa {
> >       VhostVDPAHostNotifier notifier[VIRTIO_QUEUE_MAX];
> >   } VhostVDPA;
> >
> > -int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
> > -                       void *vaddr, bool readonly);
> > -int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, hwaddr iova, hwaddr siz=
e);
> > +int vhost_vdpa_dma_map(struct vhost_vdpa *v, uint32_t asid, hwaddr iov=
a,
> > +                       hwaddr size, void *vaddr, bool readonly);
> > +int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, uint32_t asid, hwaddr i=
ova,
> > +                         hwaddr size);
> >
> >   #endif
> > diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > index 2fefcc66ad..131100841c 100644
> > --- a/hw/virtio/vhost-vdpa.c
> > +++ b/hw/virtio/vhost-vdpa.c
> > @@ -72,22 +72,24 @@ static bool vhost_vdpa_listener_skipped_section(Mem=
oryRegionSection *section,
> >       return false;
> >   }
> >
> > -int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
> > -                       void *vaddr, bool readonly)
> > +int vhost_vdpa_dma_map(struct vhost_vdpa *v, uint32_t asid, hwaddr iov=
a,
> > +                       hwaddr size, void *vaddr, bool readonly)
> >   {
> >       struct vhost_msg_v2 msg =3D {};
> >       int fd =3D v->device_fd;
> >       int ret =3D 0;
> >
> >       msg.type =3D v->msg_type;
> > +    msg.asid =3D asid;
>
>
> I wonder what happens if we're running is a kernel without ASID support.
>
> Does it work since asid will be simply ignored? Can we have a case that
> we want asid!=3D0 on old kernel?
>

No, it should always be 0 in that case. I can set it conditionally if
you prefer.

Thanks!

> Thanks
>
>
> >       msg.iotlb.iova =3D iova;
> >       msg.iotlb.size =3D size;
> >       msg.iotlb.uaddr =3D (uint64_t)(uintptr_t)vaddr;
> >       msg.iotlb.perm =3D readonly ? VHOST_ACCESS_RO : VHOST_ACCESS_RW;
> >       msg.iotlb.type =3D VHOST_IOTLB_UPDATE;
> >
> > -   trace_vhost_vdpa_dma_map(v, fd, msg.type, msg.iotlb.iova, msg.iotlb=
.size,
> > -                            msg.iotlb.uaddr, msg.iotlb.perm, msg.iotlb=
.type);
> > +    trace_vhost_vdpa_dma_map(v, fd, msg.type, msg.asid, msg.iotlb.iova=
,
> > +                             msg.iotlb.size, msg.iotlb.uaddr, msg.iotl=
b.perm,
> > +                             msg.iotlb.type);
> >
> >       if (write(fd, &msg, sizeof(msg)) !=3D sizeof(msg)) {
> >           error_report("failed to write, fd=3D%d, errno=3D%d (%s)",
> > @@ -98,18 +100,20 @@ int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwadd=
r iova, hwaddr size,
> >       return ret;
> >   }
> >
> > -int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, hwaddr iova, hwaddr siz=
e)
> > +int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, uint32_t asid, hwaddr i=
ova,
> > +                         hwaddr size)
> >   {
> >       struct vhost_msg_v2 msg =3D {};
> >       int fd =3D v->device_fd;
> >       int ret =3D 0;
> >
> >       msg.type =3D v->msg_type;
> > +    msg.asid =3D asid;
> >       msg.iotlb.iova =3D iova;
> >       msg.iotlb.size =3D size;
> >       msg.iotlb.type =3D VHOST_IOTLB_INVALIDATE;
> >
> > -    trace_vhost_vdpa_dma_unmap(v, fd, msg.type, msg.iotlb.iova,
> > +    trace_vhost_vdpa_dma_unmap(v, fd, msg.type, msg.asid, msg.iotlb.io=
va,
> >                                  msg.iotlb.size, msg.iotlb.type);
> >
> >       if (write(fd, &msg, sizeof(msg)) !=3D sizeof(msg)) {
> > @@ -229,7 +233,7 @@ static void vhost_vdpa_listener_region_add(MemoryLi=
stener *listener,
> >       }
> >
> >       vhost_vdpa_iotlb_batch_begin_once(v);
> > -    ret =3D vhost_vdpa_dma_map(v, iova, int128_get64(llsize),
> > +    ret =3D vhost_vdpa_dma_map(v, 0, iova, int128_get64(llsize),
> >                                vaddr, section->readonly);
> >       if (ret) {
> >           error_report("vhost vdpa map fail!");
> > @@ -299,7 +303,7 @@ static void vhost_vdpa_listener_region_del(MemoryLi=
stener *listener,
> >           vhost_iova_tree_remove(v->iova_tree, result);
> >       }
> >       vhost_vdpa_iotlb_batch_begin_once(v);
> > -    ret =3D vhost_vdpa_dma_unmap(v, iova, int128_get64(llsize));
> > +    ret =3D vhost_vdpa_dma_unmap(v, 0, iova, int128_get64(llsize));
> >       if (ret) {
> >           error_report("vhost_vdpa dma unmap error!");
> >       }
> > @@ -890,7 +894,7 @@ static bool vhost_vdpa_svq_unmap_ring(struct vhost_=
vdpa *v,
> >       }
> >
> >       size =3D ROUND_UP(result->size, qemu_real_host_page_size());
> > -    r =3D vhost_vdpa_dma_unmap(v, result->iova, size);
> > +    r =3D vhost_vdpa_dma_unmap(v, v->address_space_id, result->iova, s=
ize);
> >       return r =3D=3D 0;
> >   }
> >
> > @@ -932,7 +936,8 @@ static bool vhost_vdpa_svq_map_ring(struct vhost_vd=
pa *v, DMAMap *needle,
> >           return false;
> >       }
> >
> > -    r =3D vhost_vdpa_dma_map(v, needle->iova, needle->size + 1,
> > +    r =3D vhost_vdpa_dma_map(v, v->address_space_id, needle->iova,
> > +                           needle->size + 1,
> >                              (void *)(uintptr_t)needle->translated_addr=
,
> >                              needle->perm =3D=3D IOMMU_RO);
> >       if (unlikely(r !=3D 0)) {
> > diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> > index f933ba53a3..f96c3cb1da 100644
> > --- a/net/vhost-vdpa.c
> > +++ b/net/vhost-vdpa.c
> > @@ -239,7 +239,7 @@ static void vhost_vdpa_cvq_unmap_buf(struct vhost_v=
dpa *v, void *addr)
> >           return;
> >       }
> >
> > -    r =3D vhost_vdpa_dma_unmap(v, map->iova, map->size + 1);
> > +    r =3D vhost_vdpa_dma_unmap(v, v->address_space_id, map->iova, map-=
>size + 1);
> >       if (unlikely(r !=3D 0)) {
> >           error_report("Device cannot unmap: %s(%d)", g_strerror(r), r)=
;
> >       }
> > @@ -288,8 +288,8 @@ static bool vhost_vdpa_cvq_map_buf(struct vhost_vdp=
a *v,
> >           return false;
> >       }
> >
> > -    r =3D vhost_vdpa_dma_map(v, map.iova, vhost_vdpa_net_cvq_cmd_page_=
len(), buf,
> > -                           !write);
> > +    r =3D vhost_vdpa_dma_map(v, v->address_space_id, map.iova,
> > +                           vhost_vdpa_net_cvq_cmd_page_len(), buf, !wr=
ite);
> >       if (unlikely(r < 0)) {
> >           goto dma_map_err;
> >       }
> > diff --git a/hw/virtio/trace-events b/hw/virtio/trace-events
> > index 20af2e7ebd..36e5ae75f6 100644
> > --- a/hw/virtio/trace-events
> > +++ b/hw/virtio/trace-events
> > @@ -26,8 +26,8 @@ vhost_user_write(uint32_t req, uint32_t flags) "req:%=
d flags:0x%"PRIx32""
> >   vhost_user_create_notifier(int idx, void *n) "idx:%d n:%p"
> >
> >   # vhost-vdpa.c
> > -vhost_vdpa_dma_map(void *vdpa, int fd, uint32_t msg_type, uint64_t iov=
a, uint64_t size, uint64_t uaddr, uint8_t perm, uint8_t type) "vdpa:%p fd: =
%d msg_type: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" uaddr: 0x%"PRIx6=
4" perm: 0x%"PRIx8" type: %"PRIu8
> > -vhost_vdpa_dma_unmap(void *vdpa, int fd, uint32_t msg_type, uint64_t i=
ova, uint64_t size, uint8_t type) "vdpa:%p fd: %d msg_type: %"PRIu32" iova:=
 0x%"PRIx64" size: 0x%"PRIx64" type: %"PRIu8
> > +vhost_vdpa_dma_map(void *vdpa, int fd, uint32_t msg_type, uint32_t asi=
d, uint64_t iova, uint64_t size, uint64_t uaddr, uint8_t perm, uint8_t type=
) "vdpa:%p fd: %d msg_type: %"PRIu32" asid: %"PRIu32" iova: 0x%"PRIx64" siz=
e: 0x%"PRIx64" uaddr: 0x%"PRIx64" perm: 0x%"PRIx8" type: %"PRIu8
> > +vhost_vdpa_dma_unmap(void *vdpa, int fd, uint32_t msg_type, uint32_t a=
sid, uint64_t iova, uint64_t size, uint8_t type) "vdpa:%p fd: %d msg_type: =
%"PRIu32" asid: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" type: %"PRIu8
> >   vhost_vdpa_listener_begin_batch(void *v, int fd, uint32_t msg_type, u=
int8_t type)  "vdpa:%p fd: %d msg_type: %"PRIu32" type: %"PRIu8
> >   vhost_vdpa_listener_commit(void *v, int fd, uint32_t msg_type, uint8_=
t type)  "vdpa:%p fd: %d msg_type: %"PRIu32" type: %"PRIu8
> >   vhost_vdpa_listener_region_add(void *vdpa, uint64_t iova, uint64_t ll=
end, void *vaddr, bool readonly) "vdpa: %p iova 0x%"PRIx64" llend 0x%"PRIx6=
4" vaddr: %p read-only: %d"
>

