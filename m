Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64F2798893
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 16:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243836AbjIHOXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 10:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243853AbjIHOXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 10:23:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A541FC6
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 07:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694182937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=514wTQxaHYtnxSk3ThPQLF4tfMogtFuGARQoE0qmeVc=;
        b=YsFRxCxQty2yplh83BFIA0Kqnxw2g76n5HC4ItfRS+V4j8Ewk6tAIMVablxIFxLB+49019
        PZgDQzgpP7oJUkbG2pGAIsG/SqbG5DbmrKoL66sN9Jqh/VKiBV/JfYWeWkxkTPGUPyeVdr
        MDFcIw4mDiCi9DDCaG9vL0IMR2eGZx4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-D7Up91O8OEWekiN_z8Wg9w-1; Fri, 08 Sep 2023 10:22:13 -0400
X-MC-Unique: D7Up91O8OEWekiN_z8Wg9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7649980D75F;
        Fri,  8 Sep 2023 14:22:12 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.194.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3CE1C03295;
        Fri,  8 Sep 2023 14:22:09 +0000 (UTC)
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
Subject: [PATCH v3 11/16] vhost: Add vhost_get_max_memslots()
Date:   Fri,  8 Sep 2023 16:21:31 +0200
Message-ID: <20230908142136.403541-12-david@redhat.com>
In-Reply-To: <20230908142136.403541-1-david@redhat.com>
References: <20230908142136.403541-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's add vhost_get_max_memslots().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/vhost-stub.c    |  5 +++++
 hw/virtio/vhost.c         | 11 +++++++++++
 include/hw/virtio/vhost.h |  1 +
 3 files changed, 17 insertions(+)

diff --git a/hw/virtio/vhost-stub.c b/hw/virtio/vhost-stub.c
index d53dd9d288..52d42adab2 100644
--- a/hw/virtio/vhost-stub.c
+++ b/hw/virtio/vhost-stub.c
@@ -2,6 +2,11 @@
 #include "hw/virtio/vhost.h"
 #include "hw/virtio/vhost-user.h"
 
+unsigned int vhost_get_max_memslots(void)
+{
+    return UINT_MAX;
+}
+
 unsigned int vhost_get_free_memslots(void)
 {
     return UINT_MAX;
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index f7e1ac12a8..ee193b07c7 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -55,6 +55,17 @@ static unsigned int used_shared_memslots;
 static QLIST_HEAD(, vhost_dev) vhost_devices =
     QLIST_HEAD_INITIALIZER(vhost_devices);
 
+unsigned int vhost_get_max_memslots(void)
+{
+    unsigned int max = UINT_MAX;
+    struct vhost_dev *hdev;
+
+    QLIST_FOREACH(hdev, &vhost_devices, entry) {
+        max = MIN(max, hdev->vhost_ops->vhost_backend_memslots_limit(hdev));
+    }
+    return max;
+}
+
 unsigned int vhost_get_free_memslots(void)
 {
     unsigned int free = UINT_MAX;
diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index 603bf834be..c7e5467693 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -315,6 +315,7 @@ uint64_t vhost_get_features(struct vhost_dev *hdev, const int *feature_bits,
  */
 void vhost_ack_features(struct vhost_dev *hdev, const int *feature_bits,
                         uint64_t features);
+unsigned int vhost_get_max_memslots(void);
 unsigned int vhost_get_free_memslots(void);
 
 int vhost_net_set_backend(struct vhost_dev *hdev,
-- 
2.41.0

