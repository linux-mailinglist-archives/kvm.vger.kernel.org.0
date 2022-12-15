Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C8464DA6F
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 12:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiLOLet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 06:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiLOLeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 06:34:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16CE2E9C8
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 03:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671103960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXGuhwfeZjBxFZikNv60tkGbMJIoXpvVQ00BB1y2Yk8=;
        b=Xpgt3ooX1UM9jXIaly0davSdvKtmx8AhocbCtrWbbC3oewRRf7SVos89RXV/YBndbOFWdO
        S/XT4iJUsCAVuG6rbCwWuvSzezAmztCYhzBgZRj7Vv3LMun57wG6R6CE7nV2gs7C1sBanv
        4BIYIDrM+KQ7WiC8y4KXcN2icfmE4c4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-vKKsX5eoP3KDbGp0Okt8eQ-1; Thu, 15 Dec 2022 06:32:35 -0500
X-MC-Unique: vKKsX5eoP3KDbGp0Okt8eQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D713802C1B;
        Thu, 15 Dec 2022 11:32:35 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2686D2166B26;
        Thu, 15 Dec 2022 11:32:32 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Parav Pandit <parav@mellanox.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v9 11/12] vdpa: add shadow_data to vhost_vdpa
Date:   Thu, 15 Dec 2022 12:31:43 +0100
Message-Id: <20221215113144.322011-12-eperezma@redhat.com>
In-Reply-To: <20221215113144.322011-1-eperezma@redhat.com>
References: <20221215113144.322011-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
index 5e591a8fda..48d8c60e76 100644
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
index bff72717d0..710c5efe96 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -573,6 +573,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
     s->always_svq = svq;
     s->vhost_vdpa.shadow_vqs_enabled = svq;
     s->vhost_vdpa.iova_range = iova_range;
+    s->vhost_vdpa.shadow_data = svq;
     s->vhost_vdpa.iova_tree = iova_tree;
     if (!is_datapath) {
         s->cvq_cmd_out_buffer = qemu_memalign(qemu_real_host_page_size(),
-- 
2.31.1

