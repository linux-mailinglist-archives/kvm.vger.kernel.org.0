Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BEB42BCE0
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhJMKgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:36:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37358 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230460AbhJMKgn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:36:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634121280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6RfXT0bxeLK1QDswcENw90bGti15VyXGN95wefMGXc8=;
        b=AyCNtnnXgvhAjekTUi6rLVfCDaVx7xsBKIljrkMMus++9EPND4zy8DnLlXkUis2WXVl28F
        R2O+nStI7UpuegRi/gnSJgAstB7ep631zF22IB3MBz6HVUaHQxTJT+d1BbJjH8Hn9nlqSo
        E8iaqpukUymBlzLkwCoofru/GfOcMCs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-BtHvFrdKPYKtxqIbfhIHPQ-1; Wed, 13 Oct 2021 06:34:37 -0400
X-MC-Unique: BtHvFrdKPYKtxqIbfhIHPQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FEF35074F;
        Wed, 13 Oct 2021 10:34:36 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35FF85D9D5;
        Wed, 13 Oct 2021 10:34:30 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org
Subject: [PATCH RFC 03/15] vhost: Return number of free memslots
Date:   Wed, 13 Oct 2021 12:33:18 +0200
Message-Id: <20211013103330.26869-4-david@redhat.com>
In-Reply-To: <20211013103330.26869-1-david@redhat.com>
References: <20211013103330.26869-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's return the number of free slots instead of only checking if there
is a free slot. Required to support memory devices that consume multiple
memslots.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/mem/memory-device.c    | 2 +-
 hw/virtio/vhost-stub.c    | 2 +-
 hw/virtio/vhost.c         | 4 ++--
 include/hw/virtio/vhost.h | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index 9045ead33e..7f76a09e57 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -77,7 +77,7 @@ static void memory_device_check_addable(MachineState *ms, uint64_t size,
         error_setg(errp, "hypervisor has no free memory slots left");
         return;
     }
-    if (!vhost_has_free_slot()) {
+    if (!vhost_get_free_memslots()) {
         error_setg(errp, "a used vhost backend has no free memory slots left");
         return;
     }
diff --git a/hw/virtio/vhost-stub.c b/hw/virtio/vhost-stub.c
index c175148fce..fe111e5e45 100644
--- a/hw/virtio/vhost-stub.c
+++ b/hw/virtio/vhost-stub.c
@@ -2,7 +2,7 @@
 #include "hw/virtio/vhost.h"
 #include "hw/virtio/vhost-user.h"
 
-bool vhost_has_free_slot(void)
+unsigned int vhost_get_free_memslots(void)
 {
     return true;
 }
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 437347ad01..2707972870 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -48,7 +48,7 @@ static unsigned int used_memslots;
 static QLIST_HEAD(, vhost_dev) vhost_devices =
     QLIST_HEAD_INITIALIZER(vhost_devices);
 
-bool vhost_has_free_slot(void)
+unsigned int vhost_get_free_memslots(void)
 {
     unsigned int slots_limit = ~0U;
     struct vhost_dev *hdev;
@@ -57,7 +57,7 @@ bool vhost_has_free_slot(void)
         unsigned int r = hdev->vhost_ops->vhost_backend_memslots_limit(hdev);
         slots_limit = MIN(slots_limit, r);
     }
-    return slots_limit > used_memslots;
+    return slots_limit - used_memslots;
 }
 
 static void vhost_dev_sync_region(struct vhost_dev *dev,
diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index 1a9fc65089..1613af8855 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -128,7 +128,7 @@ uint64_t vhost_get_features(struct vhost_dev *hdev, const int *feature_bits,
                             uint64_t features);
 void vhost_ack_features(struct vhost_dev *hdev, const int *feature_bits,
                         uint64_t features);
-bool vhost_has_free_slot(void);
+unsigned int vhost_get_free_memslots(void);
 
 int vhost_net_set_backend(struct vhost_dev *hdev,
                           struct vhost_vring_file *file);
-- 
2.31.1

