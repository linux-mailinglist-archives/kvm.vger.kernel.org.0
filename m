Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E661A637D57
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 16:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiKXPxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 10:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiKXPxq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 10:53:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B28442E0
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669305167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0QDAmttFt0/uzyyfXC+uWtyx2ufyevmD2rR2wGnwGck=;
        b=EJUEiix1mIDh2wkiT2KfnZHtro4nCInHxObM6A3Qqhis9FWcwyLVP9gEZFrWXQwi38wwn0
        FUAY3MDrT/b/JPH3+aWS0pXcXY9YBhtV0Iqg2oL7HbTeFmdFLH9yaNUyhxyz1COtQekDZA
        BDf9CBdgp/2vFX6j1s9VQbnBzBJos4Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-KOa_z0INP--O0gfHRnMKsA-1; Thu, 24 Nov 2022 10:52:44 -0500
X-MC-Unique: KOa_z0INP--O0gfHRnMKsA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69A8485A5A6;
        Thu, 24 Nov 2022 15:52:43 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54489111E3F8;
        Thu, 24 Nov 2022 15:52:40 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>, Jason Wang <jasowang@redhat.com>,
        Cindy Lu <lulu@redhat.com>, Parav Pandit <parav@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH for 8.0 v8 11/12] vdpa: add shadow_data to vhost_vdpa
Date:   Thu, 24 Nov 2022 16:51:57 +0100
Message-Id: <20221124155158.2109884-12-eperezma@redhat.com>
In-Reply-To: <20221124155158.2109884-1-eperezma@redhat.com>
References: <20221124155158.2109884-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The memory listener that thells the device how to convert GPA to qemu's
va is registered against CVQ vhost_vdpa. memory listener translations
are always ASID 0, CVQ ones are ASID 1 if supported.

Let's tell the listener if it needs to register them on iova tree or
not.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
v7: Rename listener_shadow_vq to shadow_data
v5: Solve conflict about vhost_iova_tree_remove accepting mem_region by
    value.
---
 include/hw/virtio/vhost-vdpa.h | 2 ++
 hw/virtio/vhost-vdpa.c         | 6 +++---
 net/vhost-vdpa.c               | 1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost-vdpa.h
index e57dfa1fd1..45b969a311 100644
--- a/include/hw/virtio/vhost-vdpa.h
+++ b/include/hw/virtio/vhost-vdpa.h
@@ -40,6 +40,8 @@ typedef struct vhost_vdpa {
     struct vhost_vdpa_iova_range iova_range;
     uint64_t acked_features;
     bool shadow_vqs_enabled;
+    /* Vdpa must send shadow addresses as IOTLB key for data queues, not GPA */
+    bool shadow_data;
     /* IOVA mapping used by the Shadow Virtqueue */
     VhostIOVATree *iova_tree;
     GPtrArray *shadow_vqs;
diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 1100cde29e..8e54c5c0fc 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -224,7 +224,7 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
                                          vaddr, section->readonly);
 
     llsize = int128_sub(llend, int128_make64(iova));
-    if (v->shadow_vqs_enabled) {
+    if (v->shadow_data) {
         int r;
 
         mem_region.translated_addr = (hwaddr)(uintptr_t)vaddr,
@@ -251,7 +251,7 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
     return;
 
 fail_map:
-    if (v->shadow_vqs_enabled) {
+    if (v->shadow_data) {
         vhost_iova_tree_remove(v->iova_tree, mem_region);
     }
 
@@ -296,7 +296,7 @@ static void vhost_vdpa_listener_region_del(MemoryListener *listener,
 
     llsize = int128_sub(llend, int128_make64(iova));
 
-    if (v->shadow_vqs_enabled) {
+    if (v->shadow_data) {
         const DMAMap *result;
         const void *vaddr = memory_region_get_ram_ptr(section->mr) +
             section->offset_within_region +
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index 3ff149dfd9..a1f1e29b7c 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -587,6 +587,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
     s->vhost_vdpa.index = queue_pair_index;
     s->always_svq = svq;
     s->vhost_vdpa.shadow_vqs_enabled = svq;
+    s->vhost_vdpa.shadow_data = svq;
     s->vhost_vdpa.iova_tree = iova_tree;
     if (!is_datapath) {
         s->cvq_cmd_out_buffer = qemu_memalign(qemu_real_host_page_size(),
-- 
2.31.1

