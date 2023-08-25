Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF5978887B
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 15:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245122AbjHYNXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 09:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245116AbjHYNX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 09:23:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7611FD5
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 06:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692969759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U7/3L+fmU3fYKwMJT6ynagwXlgCdln3DW7gbBYqoanY=;
        b=X1NarY709k/D1goTZwBWrE50P9E5w7TY/+CJlrsReBzuGf1jVi96O8BaELJ6kHQlCNOnNE
        WojYpxDWeZOpO11OldmOxobipGYGD5Ou08EljGsvpUUH7DEFaK4H1sDHBp7vIn3vB35Ugo
        yZ4EY1YoTm8DuLQWwt/sHOpCEEsnIXA=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-Ge2dHd-XNH--sXiN2Lyo3A-1; Fri, 25 Aug 2023 09:22:35 -0400
X-MC-Unique: Ge2dHd-XNH--sXiN2Lyo3A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6402029ABA02;
        Fri, 25 Aug 2023 13:22:35 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.193.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EB7A140E950;
        Fri, 25 Aug 2023 13:22:32 +0000 (UTC)
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
Subject: [PATCH v2 11/16] vhost: Add vhost_get_max_memslots()
Date:   Fri, 25 Aug 2023 15:21:44 +0200
Message-ID: <20230825132149.366064-12-david@redhat.com>
In-Reply-To: <20230825132149.366064-1-david@redhat.com>
References: <20230825132149.366064-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's add vhost_get_max_memslots(), to perform a similar task as
kvm_get_max_memslots().

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

