Return-Path: <kvm+bounces-52144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 308F7B01CD3
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:05:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 673B31CC00EA
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10962DCF7F;
	Fri, 11 Jul 2025 13:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5qsNg7k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2098F2D0C67
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752238991; cv=none; b=ikyjefYFIVpQQOtq2CgNsNuS6A1RlriyhxEWgKkFccuWEQUV+LPSBK9RodU4ugLGgfD4/ay96Gzh8Osj+lBggmJGurXEAYeFfLCfNjTjQmf5L3Z6YwvyVEfQnXsCJPlAEKIhd796rkCFQGwqgYh8Ca7WfVEdqSeajyN7NxS4u4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752238991; c=relaxed/simple;
	bh=AtMBbCLaO75NkLv2Kd4W2NsahW33c4UwKSuT+Rn4u3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDXGvjZbqqmz4SZh1yQXTSstGJvTRZfmtz62CZ/AAuePszW6qNgDjgT2O2VWSkHBQhcU/q+RYVox/HH5ZGXjwf43Ks+lGk9oGxbRrBh23VA8X6OJxQGj1TkKSdLazRwGI3QyyWWF7OjfYsfbyTRE1ZkmBl3FgXAfaI+aHw4tIqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M5qsNg7k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752238987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5yly3nninxANG8fY6SgAUY1NzkHCj4BYLVU/1/Wli1k=;
	b=M5qsNg7k217asILvEfZrv804WV0zd4wGRrwpFZwx2RxvpT3MgG2r5OGPgnBRCjB2zpFzF6
	kTjzC+TtzUHK1LooxbGA1o44m5LyhYvRRMTr2zMw+IiKunFhKmtflbXEez2E4+XZrGdrVS
	85eqxbDWztfjV9OkwzF7qrUXp7OeE3E=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-546-bDRKrRr3Oni6HZBneah4dA-1; Fri,
 11 Jul 2025 09:03:03 -0400
X-MC-Unique: bDRKrRr3Oni6HZBneah4dA-1
X-Mimecast-MFC-AGG-ID: bDRKrRr3Oni6HZBneah4dA_1752238981
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DBDB19560A6;
	Fri, 11 Jul 2025 13:03:01 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.33.145])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 693BB19560B0;
	Fri, 11 Jul 2025 13:02:54 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Jason Wang <jasowang@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Luigi Rizzo <lrizzo@google.com>,
	Giuseppe Lettieri <g.lettieri@iet.unipi.it>,
	Vincenzo Maffione <v.maffione@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH RFC v2 03/13] virtio: introduce extended features type
Date: Fri, 11 Jul 2025 15:02:08 +0200
Message-ID: <8c179f9cd04d6cb5e6f822203c6a057704133386.1752229731.git.pabeni@redhat.com>
In-Reply-To: <cover.1752229731.git.pabeni@redhat.com>
References: <cover.1752229731.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The virtio specifications allows for up to 128 bits for the
device features. Soon we are going to use some of the 'extended'
bits features (above 64) for the virtio net driver.

Represent the virtio features bitmask with a fixes size array, and
introduce a few helpers to help manipulate them.

Most drivers will keep using only 64 bits features space: use union
to allow them access the lower part of the extended space without any
per driver change.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
  - use a fixed size array for features instead of uint128
  - use union with u64 to reduce the needed code churn
---
 include/hw/virtio/virtio-features.h | 124 ++++++++++++++++++++++++++++
 include/hw/virtio/virtio.h          |   7 +-
 2 files changed, 128 insertions(+), 3 deletions(-)
 create mode 100644 include/hw/virtio/virtio-features.h

diff --git a/include/hw/virtio/virtio-features.h b/include/hw/virtio/virtio-features.h
new file mode 100644
index 0000000000..cc735f7f81
--- /dev/null
+++ b/include/hw/virtio/virtio-features.h
@@ -0,0 +1,124 @@
+/*
+ * Virtio features helpers
+ *
+ * Copyright 2025 Red Hat, Inc.
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef _QEMU_VIRTIO_FEATURES_H
+#define _QEMU_VIRTIO_FEATURES_H
+
+#define VIRTIO_FEATURES_FMT        "%016"PRIx64"%016"PRIx64
+#define VIRTIO_FEATURES_PR(f)      f[1], f[0]
+
+#define VIRTIO_FEATURES_MAX        128
+#define VIRTIO_BIT(b)              (1ULL << (b & 0x3f))
+#define VIRTIO_DWORD(b)            ((b) >> 6)
+#define VIRTIO_FEATURES_WORDS     (VIRTIO_FEATURES_MAX >> 5)
+#define VIRTIO_FEATURES_DWORDS      (VIRTIO_FEATURES_WORDS >> 1)
+
+#define VIRTIO_DECLARE_FEATURES(name)                        \
+    union {                                                  \
+        uint64_t name;                                       \
+        uint64_t name##_array[VIRTIO_FEATURES_DWORDS];       \
+    }
+
+static inline void virtio_features_clear(uint64_t *features)
+{
+    memset(features, 0, sizeof(features[0]) * VIRTIO_FEATURES_DWORDS);
+}
+
+static inline void virtio_features_from_u64(uint64_t *features, uint64_t from)
+{
+    virtio_features_clear(features);
+    features[0] = from;
+}
+
+static inline bool virtio_has_feature_ex(const uint64_t *features,
+                                         unsigned int fbit)
+{
+    assert(fbit < VIRTIO_FEATURES_MAX);
+    return features[VIRTIO_DWORD(fbit)] & VIRTIO_BIT(fbit);
+}
+
+static inline void virtio_add_feature_ex(uint64_t *features,
+                                         unsigned int fbit)
+{
+    assert(fbit < VIRTIO_FEATURES_MAX);
+    features[VIRTIO_DWORD(fbit)] |= VIRTIO_BIT(fbit);
+}
+
+static inline void virtio_clear_feature_ex(uint64_t *features,
+                                           unsigned int fbit)
+{
+    assert(fbit < VIRTIO_FEATURES_MAX);
+    features[VIRTIO_DWORD(fbit)] &= ~VIRTIO_BIT(fbit);
+}
+
+static inline bool virtio_features_equal(const uint64_t *f1,
+                                         const uint64_t *f2)
+{
+    uint64_t diff = 0;
+    int i;
+
+    for (i = 0; i < VIRTIO_FEATURES_DWORDS; ++i) {
+        diff |= f1[i] ^ f2[i];
+    }
+    return !!diff;
+}
+
+static inline bool virtio_features_use_extended(const uint64_t *features)
+{
+    int i;
+
+    for (i = 1; i < VIRTIO_FEATURES_DWORDS; ++i) {
+        if (features[i]) {
+            return true;
+        }
+    }
+    return false;
+}
+
+static inline bool virtio_features_is_empty(const uint64_t *features)
+{
+    return !virtio_features_use_extended(features) && !features[0];
+}
+
+static inline void virtio_features_copy(uint64_t *to, const uint64_t *from)
+{
+    memcpy(to, from, sizeof(to[0]) * VIRTIO_FEATURES_DWORDS);
+}
+
+static inline void virtio_features_andnot(uint64_t *to, const uint64_t *f1,
+                                           const uint64_t *f2)
+{
+    int i;
+
+    for (i = 0; i < VIRTIO_FEATURES_DWORDS; i++) {
+        to[i] = f1[i] & ~f2[i];
+    }
+}
+
+static inline void virtio_features_and(uint64_t *to, const uint64_t *f1,
+                                       const uint64_t *f2)
+{
+    int i;
+
+    for (i = 0; i < VIRTIO_FEATURES_DWORDS; i++) {
+        to[i] = f1[i] & f2[i];
+    }
+}
+
+static inline void virtio_features_or(uint64_t *to, const uint64_t *f1,
+                                       const uint64_t *f2)
+{
+    int i;
+
+    for (i = 0; i < VIRTIO_FEATURES_DWORDS; i++) {
+        to[i] = f1[i] | f2[i];
+    }
+}
+
+#endif
+
diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 214d4a77e9..0d1eb20489 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -16,6 +16,7 @@
 
 #include "system/memory.h"
 #include "hw/qdev-core.h"
+#include "hw/virtio/virtio-features.h"
 #include "net/net.h"
 #include "migration/vmstate.h"
 #include "qemu/event_notifier.h"
@@ -121,9 +122,9 @@ struct VirtIODevice
      * backend (e.g. vhost) and could potentially be a subset of the
      * total feature set offered by QEMU.
      */
-    uint64_t host_features;
-    uint64_t guest_features;
-    uint64_t backend_features;
+    VIRTIO_DECLARE_FEATURES(host_features);
+    VIRTIO_DECLARE_FEATURES(guest_features);
+    VIRTIO_DECLARE_FEATURES(backend_features);
 
     size_t config_len;
     void *config;
-- 
2.50.0


