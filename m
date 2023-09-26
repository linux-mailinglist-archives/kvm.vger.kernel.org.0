Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1FF7AF391
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 21:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbjIZTAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 15:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbjIZTAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 15:00:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182151B7
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 11:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695754792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=adaLIN+oCidzf9Yl1V7wtFZZqNM0t8YdJyA6CFGysIY=;
        b=OdK+5XTxM8Beq20VR8cDyjmU9yaAFAVkwCbInx877z0z1KP6CxwO3ei4+anQkGMs4lKvQq
        YHvy0WN7qr1li05GehzkEXu0XXEtBG2hX9LiCM43woATlDivCIunNEVCk0yHXq9F/Izooa
        E5MQYowt7onx9itRe8I/RVvbkqiDTZI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-x1igqqiVPtOTFGoR0hcyVg-1; Tue, 26 Sep 2023 14:59:47 -0400
X-MC-Unique: x1igqqiVPtOTFGoR0hcyVg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 140603C0BE3C;
        Tue, 26 Sep 2023 18:59:47 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.192.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FBBE2026D4B;
        Tue, 26 Sep 2023 18:59:41 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
Subject: [PATCH v4 14/18] virtio-mem: Pass non-const VirtIOMEM via virtio_mem_range_cb
Date:   Tue, 26 Sep 2023 20:57:34 +0200
Message-ID: <20230926185738.277351-15-david@redhat.com>
In-Reply-To: <20230926185738.277351-1-david@redhat.com>
References: <20230926185738.277351-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's prepare for a user that has to modify the VirtIOMEM device state.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/virtio-mem.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index da5b09cefc..0b0e6c5090 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -177,10 +177,10 @@ static bool virtio_mem_is_busy(void)
     return migration_in_incoming_postcopy() || !migration_is_idle();
 }
 
-typedef int (*virtio_mem_range_cb)(const VirtIOMEM *vmem, void *arg,
+typedef int (*virtio_mem_range_cb)(VirtIOMEM *vmem, void *arg,
                                    uint64_t offset, uint64_t size);
 
-static int virtio_mem_for_each_unplugged_range(const VirtIOMEM *vmem, void *arg,
+static int virtio_mem_for_each_unplugged_range(VirtIOMEM *vmem, void *arg,
                                                virtio_mem_range_cb cb)
 {
     unsigned long first_zero_bit, last_zero_bit;
@@ -204,7 +204,7 @@ static int virtio_mem_for_each_unplugged_range(const VirtIOMEM *vmem, void *arg,
     return ret;
 }
 
-static int virtio_mem_for_each_plugged_range(const VirtIOMEM *vmem, void *arg,
+static int virtio_mem_for_each_plugged_range(VirtIOMEM *vmem, void *arg,
                                              virtio_mem_range_cb cb)
 {
     unsigned long first_bit, last_bit;
@@ -969,7 +969,7 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
     ram_block_coordinated_discard_require(false);
 }
 
-static int virtio_mem_discard_range_cb(const VirtIOMEM *vmem, void *arg,
+static int virtio_mem_discard_range_cb(VirtIOMEM *vmem, void *arg,
                                        uint64_t offset, uint64_t size)
 {
     RAMBlock *rb = vmem->memdev->mr.ram_block;
@@ -1021,7 +1021,7 @@ static int virtio_mem_post_load(void *opaque, int version_id)
     return virtio_mem_restore_unplugged(vmem);
 }
 
-static int virtio_mem_prealloc_range_cb(const VirtIOMEM *vmem, void *arg,
+static int virtio_mem_prealloc_range_cb(VirtIOMEM *vmem, void *arg,
                                         uint64_t offset, uint64_t size)
 {
     void *area = memory_region_get_ram_ptr(&vmem->memdev->mr) + offset;
-- 
2.41.0

