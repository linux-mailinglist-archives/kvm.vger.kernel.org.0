Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59A720ACF4
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 09:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgFZHX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 03:23:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43812 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727022AbgFZHX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 03:23:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593156204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=infcIEMl/Gu4WfpC7vb6GTLKifCdfLNGQXbx7ZFcrfg=;
        b=O+xTlzBcSqSY+mRxNlPDbKEunMqXdJIQOGg1CazK2nzUwjrInvYz9zUw4uZiZT2oy8X+BB
        icv1Cq8chO6XyJulTywVIQm40ebBAYhr8Al2K4Jlnls1hydYTOH1n9fW2Gddhk9pMMaGoQ
        bnE/5y7uIMfQaDVL+F2D6BiXxC2TARI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-30gyrpDANUyD9sflQgKWxQ-1; Fri, 26 Jun 2020 03:23:21 -0400
X-MC-Unique: 30gyrpDANUyD9sflQgKWxQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3107C18FE879;
        Fri, 26 Jun 2020 07:23:20 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-35.ams2.redhat.com [10.36.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A2FD60C1D;
        Fri, 26 Jun 2020 07:23:18 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v5 02/21] exec: Introduce ram_block_discard_(disable|require)()
Date:   Fri, 26 Jun 2020 09:22:29 +0200
Message-Id: <20200626072248.78761-3-david@redhat.com>
In-Reply-To: <20200626072248.78761-1-david@redhat.com>
References: <20200626072248.78761-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want to replace qemu_balloon_inhibit() by something more generic.
Especially, we want to make sure that technologies that really rely on
RAM block discards to work reliably to run mutual exclusive with
technologies that effectively break it.

E.g., vfio will usually pin all guest memory, turning the virtio-balloon
basically useless and make the VM consume more memory than reported via
the balloon. While the balloon is special already (=> no guarantees, same
behavior possible afer reboots and with huge pages), this will be
different, especially, with virtio-mem.

Let's implement a way such that we can make both types of technology run
mutually exclusive. We'll convert existing balloon inhibitors in successive
patches and add some new ones. Add the check to
qemu_balloon_is_inhibited() for now. We might want to make
virtio-balloon an acutal inhibitor in the future - however, that
requires more thought to not break existing setups.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 balloon.c             |  3 ++-
 exec.c                | 52 +++++++++++++++++++++++++++++++++++++++++++
 include/exec/memory.h | 41 ++++++++++++++++++++++++++++++++++
 3 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/balloon.c b/balloon.c
index f104b42961..5fff79523a 100644
--- a/balloon.c
+++ b/balloon.c
@@ -40,7 +40,8 @@ static int balloon_inhibit_count;
 
 bool qemu_balloon_is_inhibited(void)
 {
-    return atomic_read(&balloon_inhibit_count) > 0;
+    return atomic_read(&balloon_inhibit_count) > 0 ||
+           ram_block_discard_is_disabled();
 }
 
 void qemu_balloon_inhibit(bool state)
diff --git a/exec.c b/exec.c
index d6712fba7e..b15187d9ab 100644
--- a/exec.c
+++ b/exec.c
@@ -4063,4 +4063,56 @@ void mtree_print_dispatch(AddressSpaceDispatch *d, MemoryRegion *root)
     }
 }
 
+/*
+ * If positive, discarding RAM is disabled. If negative, discarding RAM is
+ * required to work and cannot be disabled.
+ */
+static int ram_block_discard_disabled;
+
+int ram_block_discard_disable(bool state)
+{
+    int old;
+
+    if (!state) {
+        atomic_dec(&ram_block_discard_disabled);
+        return 0;
+    }
+
+    do {
+        old = atomic_read(&ram_block_discard_disabled);
+        if (old < 0) {
+            return -EBUSY;
+        }
+    } while (atomic_cmpxchg(&ram_block_discard_disabled, old, old + 1) != old);
+    return 0;
+}
+
+int ram_block_discard_require(bool state)
+{
+    int old;
+
+    if (!state) {
+        atomic_inc(&ram_block_discard_disabled);
+        return 0;
+    }
+
+    do {
+        old = atomic_read(&ram_block_discard_disabled);
+        if (old > 0) {
+            return -EBUSY;
+        }
+    } while (atomic_cmpxchg(&ram_block_discard_disabled, old, old - 1) != old);
+    return 0;
+}
+
+bool ram_block_discard_is_disabled(void)
+{
+    return atomic_read(&ram_block_discard_disabled) > 0;
+}
+
+bool ram_block_discard_is_required(void)
+{
+    return atomic_read(&ram_block_discard_disabled) < 0;
+}
+
 #endif
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 7207025bd4..38ec38b9a8 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -2472,6 +2472,47 @@ static inline MemOp devend_memop(enum device_endian end)
 }
 #endif
 
+/*
+ * Inhibit technologies that require discarding of pages in RAM blocks, e.g.,
+ * to manage the actual amount of memory consumed by the VM (then, the memory
+ * provided by RAM blocks might be bigger than the desired memory consumption).
+ * This *must* be set if:
+ * - Discarding parts of a RAM blocks does not result in the change being
+ *   reflected in the VM and the pages getting freed.
+ * - All memory in RAM blocks is pinned or duplicated, invaldiating any previous
+ *   discards blindly.
+ * - Discarding parts of a RAM blocks will result in integrity issues (e.g.,
+ *   encrypted VMs).
+ * Technologies that only temporarily pin the current working set of a
+ * driver are fine, because we don't expect such pages to be discarded
+ * (esp. based on guest action like balloon inflation).
+ *
+ * This is *not* to be used to protect from concurrent discards (esp.,
+ * postcopy).
+ *
+ * Returns 0 if successful. Returns -EBUSY if a technology that relies on
+ * discards to work reliably is active.
+ */
+int ram_block_discard_disable(bool state);
+
+/*
+ * Inhibit technologies that disable discarding of pages in RAM blocks.
+ *
+ * Returns 0 if successful. Returns -EBUSY if discards are already set to
+ * broken.
+ */
+int ram_block_discard_require(bool state);
+
+/*
+ * Test if discarding of memory in ram blocks is disabled.
+ */
+bool ram_block_discard_is_disabled(void);
+
+/*
+ * Test if discarding of memory in ram blocks is required to work reliably.
+ */
+bool ram_block_discard_is_required(void);
+
 #endif
 
 #endif
-- 
2.26.2

