Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3476B62431F
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 14:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiKJNYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 08:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiKJNYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 08:24:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B5DB4E
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 05:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668086604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q3q7vZZ6hvLVnoXGfWB8YvLJ7mySd3fvzdjJdGt/+ak=;
        b=dNZVYdZG/DB0Ei/3GHW33pePF9g+5ZIy4jjsWqWVRL+Aqotmxr3wjoExBxbgYM2x/BEoAa
        rRcoEz1FdzhRzy99wzmppioCgUa3i+j4CNp0Ot38xYf1JqhLUIagOu9ATwezQRAGY2pIq2
        t+t9NUTIhnr+rDTlpJILmxR/yxrK1NY=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-472-sJOroYRZOPKDSpMmRq5Esw-1; Thu, 10 Nov 2022 08:23:22 -0500
X-MC-Unique: sJOroYRZOPKDSpMmRq5Esw-1
Received: by mail-pl1-f197.google.com with SMTP id b18-20020a170903229200b00186e357f3b9so1368718plh.6
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 05:23:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q3q7vZZ6hvLVnoXGfWB8YvLJ7mySd3fvzdjJdGt/+ak=;
        b=BmeoTwsPzGsIkXWgwZ0DWCaQqKfUzBIkz6YwYoL2GOEzMY2iqJ92E27VnjTtdIc/ge
         yZqmNNvzCyyvwZ5pseKJKEp+MJ81xBC9tE7IZbDp5co25yOO6dy9A0aKUgL0fNUpD5E2
         Iy/V8wSppDY1xiFaSnCx/IGZS7+x6BFI/o/ICPx7cDlQz39dF+IysV+qsW8xf9EkuECm
         ZmsE0VT1NHmx4++8Z/rfDASCN2LSiWsNpn4Ip5FZOp80vF1hWeKaB9gtYSrngi9Kv3KG
         ++gXEeJw25SG6kGWOvlaE1ObSkzco3zHQ3m63boMQjyylehWwnZ1fNBXFdfl/YakPyhb
         IZxg==
X-Gm-Message-State: ACrzQf2Ll0dlJFYLGWQdrAO/FZls9v+5vb3EnTEwdtnSl7kgHscQM/p0
        9me2CEmC+OCq9cDDWo1LXdizLbwQPIfoTLfHugEFu73R2ImrEOML21BSOa1USiCmOfRoi+Ony/k
        CXx758JUeRu7f3PODDtvPhj3S8LRB
X-Received: by 2002:a17:902:ce82:b0:187:3591:edac with SMTP id f2-20020a170902ce8200b001873591edacmr48488802plg.153.1668086600670;
        Thu, 10 Nov 2022 05:23:20 -0800 (PST)
X-Google-Smtp-Source: AMsMyM60JtWWo+8r1fX04eXc7OnFF8dnAgixl/Vtg8iEneJB0G+bnbPRN9yBXp2W/vnf9wtqStSSz51zIUu0h7utnR0=
X-Received: by 2002:a17:902:ce82:b0:187:3591:edac with SMTP id
 f2-20020a170902ce8200b001873591edacmr48488761plg.153.1668086600262; Thu, 10
 Nov 2022 05:23:20 -0800 (PST)
MIME-Version: 1.0
References: <20221108170755.92768-1-eperezma@redhat.com> <20221108170755.92768-8-eperezma@redhat.com>
 <CACGkMEvzw283JE9Uo6kqKuAJ4CWpWyHciHe8DazLEP5Xzw91wg@mail.gmail.com>
In-Reply-To: <CACGkMEvzw283JE9Uo6kqKuAJ4CWpWyHciHe8DazLEP5Xzw91wg@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 10 Nov 2022 14:22:44 +0100
Message-ID: <CAJaqyWcbYLzdEcPMMjDNWsGV4bkb8NTJnNHj5Wp+v4WbM+LHeQ@mail.gmail.com>
Subject: Re: [PATCH v6 07/10] vdpa: Add asid parameter to vhost_vdpa_dma_map/unmap
To:     Jason Wang <jasowang@redhat.com>
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

On Thu, Nov 10, 2022 at 6:51 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Wed, Nov 9, 2022 at 1:08 AM Eugenio P=C3=A9rez <eperezma@redhat.com> w=
rote:
> >
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
> > v5:
> > * Solve conflict, now vhost_vdpa_svq_unmap_ring returns void
> > * Change comment on zero initialization.
> >
> > v4: Add comment specifying behavior if device does not support _F_ASID
> >
> > v3: Deleted unneeded space
> > ---
> >  include/hw/virtio/vhost-vdpa.h |  8 +++++---
> >  hw/virtio/vhost-vdpa.c         | 29 +++++++++++++++++++----------
> >  net/vhost-vdpa.c               |  6 +++---
> >  hw/virtio/trace-events         |  4 ++--
> >  4 files changed, 29 insertions(+), 18 deletions(-)
> >
> > diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost-v=
dpa.h
> > index 1111d85643..6560bb9d78 100644
> > --- a/include/hw/virtio/vhost-vdpa.h
> > +++ b/include/hw/virtio/vhost-vdpa.h
> > @@ -29,6 +29,7 @@ typedef struct vhost_vdpa {
> >      int index;
> >      uint32_t msg_type;
> >      bool iotlb_batch_begin_sent;
> > +    uint32_t address_space_id;
>
> So the trick is let device specific code to zero this during allocation?
>

Yes, but I don't see how that is a trick :). All other parameters also
trust it to be 0 at allocation.

> >      MemoryListener listener;
> >      struct vhost_vdpa_iova_range iova_range;
> >      uint64_t acked_features;
> > @@ -42,8 +43,9 @@ typedef struct vhost_vdpa {
> >      VhostVDPAHostNotifier notifier[VIRTIO_QUEUE_MAX];
> >  } VhostVDPA;
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
> >  #endif
> > diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > index 23efb8f49d..8fd32ba32b 100644
> > --- a/hw/virtio/vhost-vdpa.c
> > +++ b/hw/virtio/vhost-vdpa.c
> > @@ -72,22 +72,24 @@ static bool vhost_vdpa_listener_skipped_section(Mem=
oryRegionSection *section,
> >      return false;
> >  }
> >
> > -int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
> > -                       void *vaddr, bool readonly)
> > +int vhost_vdpa_dma_map(struct vhost_vdpa *v, uint32_t asid, hwaddr iov=
a,
> > +                       hwaddr size, void *vaddr, bool readonly)
> >  {
> >      struct vhost_msg_v2 msg =3D {};
> >      int fd =3D v->device_fd;
> >      int ret =3D 0;
> >
> >      msg.type =3D v->msg_type;
> > +    msg.asid =3D asid; /* 0 if vdpa device does not support asid */
>
> The comment here is confusing. If this is a requirement, we need either
>
> 1) doc this
>
> or
>
> 2) perform necessary checks in the function itself.
>

I only documented it in vhost_vdpa_dma_unmap and now I realize it.
Would it work to just copy that comment here?

> >      msg.iotlb.iova =3D iova;
> >      msg.iotlb.size =3D size;
> >      msg.iotlb.uaddr =3D (uint64_t)(uintptr_t)vaddr;
> >      msg.iotlb.perm =3D readonly ? VHOST_ACCESS_RO : VHOST_ACCESS_RW;
> >      msg.iotlb.type =3D VHOST_IOTLB_UPDATE;
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
> >      if (write(fd, &msg, sizeof(msg)) !=3D sizeof(msg)) {
> >          error_report("failed to write, fd=3D%d, errno=3D%d (%s)",
> > @@ -98,18 +100,24 @@ int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwadd=
r iova, hwaddr size,
> >      return ret;
> >  }
> >
> > -int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, hwaddr iova, hwaddr siz=
e)
> > +int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, uint32_t asid, hwaddr i=
ova,
> > +                         hwaddr size)
> >  {
> >      struct vhost_msg_v2 msg =3D {};
> >      int fd =3D v->device_fd;
> >      int ret =3D 0;
> >
> >      msg.type =3D v->msg_type;
> > +    /*
> > +     * The caller must set asid =3D 0 if the device does not support a=
sid.
> > +     * This is not an ABI break since it is set to 0 by the initialize=
r anyway.
> > +     */
> > +    msg.asid =3D asid;
> >      msg.iotlb.iova =3D iova;
> >      msg.iotlb.size =3D size;
> >      msg.iotlb.type =3D VHOST_IOTLB_INVALIDATE;
> >
> > -    trace_vhost_vdpa_dma_unmap(v, fd, msg.type, msg.iotlb.iova,
> > +    trace_vhost_vdpa_dma_unmap(v, fd, msg.type, msg.asid, msg.iotlb.io=
va,
> >                                 msg.iotlb.size, msg.iotlb.type);
> >
> >      if (write(fd, &msg, sizeof(msg)) !=3D sizeof(msg)) {
> > @@ -229,7 +237,7 @@ static void vhost_vdpa_listener_region_add(MemoryLi=
stener *listener,
> >      }
> >
> >      vhost_vdpa_iotlb_batch_begin_once(v);
> > -    ret =3D vhost_vdpa_dma_map(v, iova, int128_get64(llsize),
> > +    ret =3D vhost_vdpa_dma_map(v, 0, iova, int128_get64(llsize),
>
> Can we use v->address_space_id here? Then we don't need to modify this
> line when we support multiple asids logic in the future.
>

The registered memory listener is the one of the last vhost_vdpa, the
one that handles the last queue.

If all data virtqueues are not shadowed but CVQ is,
v->address_space_id is 1 with the current code. But the listener is
actually mapping the ASID 0, not 1.

Another alternative is to register it to the last data virtqueue, not
the last queue of vhost_vdpa. But it is hard to express it in a
generic way at virtio/vhost-vdpa.c . To have a boolean indicating the
vhost_vdpa we want to register its memory listener?

It seems easier to me to simply assign 0 at GPA translations. If SVQ
is enabled for all queues, then 0 is GPA to qemu's VA + SVQ stuff. If
it is not, 0 is always GPA to qemu's VA.

Thanks!

> Thanks
>
> >                               vaddr, section->readonly);
> >      if (ret) {
> >          error_report("vhost vdpa map fail!");
> > @@ -303,7 +311,7 @@ static void vhost_vdpa_listener_region_del(MemoryLi=
stener *listener,
> >          vhost_iova_tree_remove(v->iova_tree, *result);
> >      }
> >      vhost_vdpa_iotlb_batch_begin_once(v);
> > -    ret =3D vhost_vdpa_dma_unmap(v, iova, int128_get64(llsize));
> > +    ret =3D vhost_vdpa_dma_unmap(v, 0, iova, int128_get64(llsize));
> >      if (ret) {
> >          error_report("vhost_vdpa dma unmap error!");
> >      }
> > @@ -884,7 +892,7 @@ static void vhost_vdpa_svq_unmap_ring(struct vhost_=
vdpa *v, hwaddr addr)
> >      }
> >
> >      size =3D ROUND_UP(result->size, qemu_real_host_page_size());
> > -    r =3D vhost_vdpa_dma_unmap(v, result->iova, size);
> > +    r =3D vhost_vdpa_dma_unmap(v, v->address_space_id, result->iova, s=
ize);
> >      if (unlikely(r < 0)) {
> >          error_report("Unable to unmap SVQ vring: %s (%d)", g_strerror(=
-r), -r);
> >          return;
> > @@ -924,7 +932,8 @@ static bool vhost_vdpa_svq_map_ring(struct vhost_vd=
pa *v, DMAMap *needle,
> >          return false;
> >      }
> >
> > -    r =3D vhost_vdpa_dma_map(v, needle->iova, needle->size + 1,
> > +    r =3D vhost_vdpa_dma_map(v, v->address_space_id, needle->iova,
> > +                           needle->size + 1,
> >                             (void *)(uintptr_t)needle->translated_addr,
> >                             needle->perm =3D=3D IOMMU_RO);
> >      if (unlikely(r !=3D 0)) {
> > diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> > index fb35b17ab4..ca1acc0410 100644
> > --- a/net/vhost-vdpa.c
> > +++ b/net/vhost-vdpa.c
> > @@ -258,7 +258,7 @@ static void vhost_vdpa_cvq_unmap_buf(struct vhost_v=
dpa *v, void *addr)
> >          return;
> >      }
> >
> > -    r =3D vhost_vdpa_dma_unmap(v, map->iova, map->size + 1);
> > +    r =3D vhost_vdpa_dma_unmap(v, v->address_space_id, map->iova, map-=
>size + 1);
> >      if (unlikely(r !=3D 0)) {
> >          error_report("Device cannot unmap: %s(%d)", g_strerror(r), r);
> >      }
> > @@ -298,8 +298,8 @@ static int vhost_vdpa_cvq_map_buf(struct vhost_vdpa=
 *v, void *buf, size_t size,
> >          return r;
> >      }
> >
> > -    r =3D vhost_vdpa_dma_map(v, map.iova, vhost_vdpa_net_cvq_cmd_page_=
len(), buf,
> > -                           !write);
> > +    r =3D vhost_vdpa_dma_map(v, v->address_space_id, map.iova,
> > +                           vhost_vdpa_net_cvq_cmd_page_len(), buf, !wr=
ite);
> >      if (unlikely(r < 0)) {
> >          goto dma_map_err;
> >      }
> > diff --git a/hw/virtio/trace-events b/hw/virtio/trace-events
> > index 820dadc26c..0ad9390307 100644
> > --- a/hw/virtio/trace-events
> > +++ b/hw/virtio/trace-events
> > @@ -30,8 +30,8 @@ vhost_user_write(uint32_t req, uint32_t flags) "req:%=
d flags:0x%"PRIx32""
> >  vhost_user_create_notifier(int idx, void *n) "idx:%d n:%p"
> >
> >  # vhost-vdpa.c
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
> >  vhost_vdpa_listener_begin_batch(void *v, int fd, uint32_t msg_type, ui=
nt8_t type)  "vdpa:%p fd: %d msg_type: %"PRIu32" type: %"PRIu8
> >  vhost_vdpa_listener_commit(void *v, int fd, uint32_t msg_type, uint8_t=
 type)  "vdpa:%p fd: %d msg_type: %"PRIu32" type: %"PRIu8
> >  vhost_vdpa_listener_region_add(void *vdpa, uint64_t iova, uint64_t lle=
nd, void *vaddr, bool readonly) "vdpa: %p iova 0x%"PRIx64" llend 0x%"PRIx64=
" vaddr: %p read-only: %d"
> > --
> > 2.31.1
> >
>

