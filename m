Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16405FB09D
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 12:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiJKKme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 06:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiJKKmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 06:42:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3818B2EC
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 03:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665484941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JjLZSMxDoJzukfhronBWmF9VBo9r0DM5fgqfGZCuCT8=;
        b=eBT3NtbRWIWau6gBcbXn1I8EBLdBADmOCXX0DHBlk7Yas/xoxtsRl2Cu3Yze1VWRWiL6ez
        3IA2ZF0wmzDOzCG/y7iOTidRRas6R7bHnIEUzAn58ujkrH4KKJyEZ6vnp/KRnG71uE6BOS
        ZBMqblsnUlAiJpbbsVZrXpx0qPAvzh0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-nV4AtLQ3Oxyct-JUmFvcQA-1; Tue, 11 Oct 2022 06:42:18 -0400
X-MC-Unique: nV4AtLQ3Oxyct-JUmFvcQA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD56F299E754;
        Tue, 11 Oct 2022 10:42:17 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5293492B10;
        Tue, 11 Oct 2022 10:42:14 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Gautam Dawar <gdawar@xilinx.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Cindy Lu <lulu@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Harpreet Singh Anand <hanand@xilinx.com>
Subject: [PATCH v5 5/6] vdpa: Add listener_shadow_vq to vhost_vdpa
Date:   Tue, 11 Oct 2022 12:41:53 +0200
Message-Id: <20221011104154.1209338-6-eperezma@redhat.com>
In-Reply-To: <20221011104154.1209338-1-eperezma@redhat.com>
References: <20221011104154.1209338-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The memory listener that thells the device how to convert GPA to qemu's
va is registered against CVQ vhost_vdpa. This series try to map the
memory listener translations to ASID 0, while it maps the CVQ ones to
ASID 1.

Let's tell the listener if it needs to register them on iova tree or
not.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
v5: Solve conflict about vhost_iova_tree_remove accepting mem_region by
    value.
---
 include/hw/virtio/vhost-vdpa.h | 2 ++
 hw/virtio/vhost-vdpa.c         | 6 +++---
 net/vhost-vdpa.c               | 1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost-vdpa.h
index 6560bb9d78..0c3ed2d69b 100644
--- a/include/hw/virtio/vhost-vdpa.h
+++ b/include/hw/virtio/vhost-vdpa.h
@@ -34,6 +34,8 @@ typedef struct vhost_vdpa {
     struct vhost_vdpa_iova_range iova_range;
     uint64_t acked_features;
     bool shadow_vqs_enabled;
+    /* The listener must send iova tree addresses, not GPA */
+    bool listener_shadow_vq;
     /* IOVA mapping used by the Shadow Virtqueue */
     VhostIOVATree *iova_tree;
     GPtrArray *shadow_vqs;
diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index ad663feacc..29d009c02b 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -220,7 +220,7 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
                                          vaddr, section->readonly);
 
     llsize = int128_sub(llend, int128_make64(iova));
-    if (v->shadow_vqs_enabled) {
+    if (v->listener_shadow_vq) {
         int r;
 
         mem_region.translated_addr = (hwaddr)(uintptr_t)vaddr,
@@ -247,7 +247,7 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
     return;
 
 fail_map:
-    if (v->shadow_vqs_enabled) {
+    if (v->listener_shadow_vq) {
         vhost_iova_tree_remove(v->iova_tree, mem_region);
     }
 
@@ -292,7 +292,7 @@ static void vhost_vdpa_listener_region_del(MemoryListener *listener,
 
     llsize = int128_sub(llend, int128_make64(iova));
 
-    if (v->shadow_vqs_enabled) {
+    if (v->listener_shadow_vq) {
         const DMAMap *result;
         const void *vaddr = memory_region_get_ram_ptr(section->mr) +
             section->offset_within_region +
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index e8c78e4813..f7831aeb8d 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -604,6 +604,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
     s->vhost_vdpa.index = queue_pair_index;
     s->always_svq = svq;
     s->vhost_vdpa.shadow_vqs_enabled = svq;
+    s->vhost_vdpa.listener_shadow_vq = svq;
     s->vhost_vdpa.iova_tree = iova_tree;
     if (!is_datapath) {
         s->cvq_cmd_out_buffer = qemu_memalign(qemu_real_host_page_size(),
-- 
2.31.1

