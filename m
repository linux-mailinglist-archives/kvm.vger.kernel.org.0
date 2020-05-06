Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4A01C6D87
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgEFJuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:50:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41292 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726935AbgEFJuJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 05:50:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588758608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1b7WzEdOr0opnS44tYvGmSayhyE3oXt+X3RgB8uyQ/4=;
        b=PEybXLPzyCAXbc0VPHNSmX4nyPKA9AIDQDyvs+FYMXf8oLwjU3hmQ5nnxuzlHYhMfjGnUo
        oPIFlxXn12O2P5lQ7GvMxly7eJEVKGhNSfc0P0hcn0nOb3H5wnzB0cz6gTdNTTPdUz7lOu
        RPZ8MxhsWZN4BLOVyY67FFmvgxAw6UU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-tQp4UaSBNF61XvzTMO_hOA-1; Wed, 06 May 2020 05:50:06 -0400
X-MC-Unique: tQp4UaSBNF61XvzTMO_hOA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99C2C835B44;
        Wed,  6 May 2020 09:50:05 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-17.ams2.redhat.com [10.36.113.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D68BA5C1D4;
        Wed,  6 May 2020 09:50:01 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 01/17] exec: Introduce ram_block_discard_set_(unreliable|required)()
Date:   Wed,  6 May 2020 11:49:32 +0200
Message-Id: <20200506094948.76388-2-david@redhat.com>
In-Reply-To: <20200506094948.76388-1-david@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want to replace qemu_balloon_inhibit() by something more generic.
Especially, we want to make sure that technologies that really rely on
RAM block discards to work reliably to run mutual exclusive with
technologies that break it.

E.g., vfio will usually pin all guest memory, turning the virtio-balloon
basically useless and make the VM consume more memory than reported via
the balloon. While the balloon is special already (=3D> no guarantees, sa=
me
behavior possible afer reboots and with huge pages), this will be
different, especially, with virtio-mem.

Let's implement a way such that we can make both types of technology run
mutually exclusive. We'll convert existing balloon inhibitors in successi=
ve
patches and add some new ones. Add the check to
qemu_balloon_is_inhibited() for now. We might want to make
virtio-balloon an acutal inhibitor in the future - however, that
requires more thought to not break existing setups.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 balloon.c             |  3 ++-
 exec.c                | 48 +++++++++++++++++++++++++++++++++++++++++++
 include/exec/memory.h | 41 ++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/balloon.c b/balloon.c
index f104b42961..c49f57c27b 100644
--- a/balloon.c
+++ b/balloon.c
@@ -40,7 +40,8 @@ static int balloon_inhibit_count;
=20
 bool qemu_balloon_is_inhibited(void)
 {
-    return atomic_read(&balloon_inhibit_count) > 0;
+    return atomic_read(&balloon_inhibit_count) > 0 ||
+           ram_block_discard_is_broken();
 }
=20
 void qemu_balloon_inhibit(bool state)
diff --git a/exec.c b/exec.c
index 2874bb5088..52a6e40e99 100644
--- a/exec.c
+++ b/exec.c
@@ -4049,4 +4049,52 @@ void mtree_print_dispatch(AddressSpaceDispatch *d,=
 MemoryRegion *root)
     }
 }
=20
+static int ram_block_discard_broken;
+
+int ram_block_discard_set_broken(bool state)
+{
+    int old;
+
+    if (!state) {
+        atomic_dec(&ram_block_discard_broken);
+        return 0;
+    }
+
+    do {
+        old =3D atomic_read(&ram_block_discard_broken);
+        if (old < 0) {
+            return -EBUSY;
+        }
+    } while (atomic_cmpxchg(&ram_block_discard_broken, old, old + 1) !=3D=
 old);
+    return 0;
+}
+
+int ram_block_discard_set_required(bool state)
+{
+    int old;
+
+    if (!state) {
+        atomic_inc(&ram_block_discard_broken);
+        return 0;
+    }
+
+    do {
+        old =3D atomic_read(&ram_block_discard_broken);
+        if (old > 0) {
+            return -EBUSY;
+        }
+    } while (atomic_cmpxchg(&ram_block_discard_broken, old, old - 1) !=3D=
 old);
+    return 0;
+}
+
+bool ram_block_discard_is_broken(void)
+{
+    return atomic_read(&ram_block_discard_broken) > 0;
+}
+
+bool ram_block_discard_is_required(void)
+{
+    return atomic_read(&ram_block_discard_broken) < 0;
+}
+
 #endif
diff --git a/include/exec/memory.h b/include/exec/memory.h
index e000bd2f97..9bb5ced38d 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -2463,6 +2463,47 @@ static inline MemOp devend_memop(enum device_endia=
n end)
 }
 #endif
=20
+/*
+ * Inhibit technologies that rely on discarding of parts of RAM blocks t=
o work
+ * reliably, e.g., to manage the actual amount of memory consumed by the=
 VM
+ * (then, the memory provided by RAM blocks might be bigger than the des=
ired
+ * memory consumption). This *must* be set if:
+ * - Discarding parts of a RAM blocks does not result in the change bein=
g
+ *   reflected in the VM and the pages getting freed.
+ * - All memory in RAM blocks is pinned or duplicated, invaldiating any =
previous
+ *   discards blindly.
+ * - Discarding parts of a RAM blocks will result in integrity issues (e=
.g.,
+ *   encrypted VMs).
+ * Technologies that only temporarily pin the current working set of a
+ * driver are fine, because we don't expect such pages to be discarded
+ * (esp. based on guest action like balloon inflation).
+ *
+ * This is *not* to be used to protect from concurrent discards (esp.,
+ * postcopy).
+ *
+ * Returns 0 if successful. Returns -EBUSY if a technology that relies o=
n
+ * discards to work reliably is active.
+ */
+int ram_block_discard_set_broken(bool state);
+
+/*
+ * Inhibit technologies that will break discarding of pages in RAM block=
s.
+ *
+ * Returns 0 if successful. Returns -EBUSY if discards are already set t=
o
+ * broken.
+ */
+int ram_block_discard_set_required(bool state);
+
+/*
+ * Test if discarding of memory in ram blocks is broken.
+ */
+bool ram_block_discard_is_broken(void);
+
+/*
+ * Test if discarding of memory in ram blocks is required to work reliab=
ly.
+ */
+bool ram_block_discard_is_required(void);
+
 #endif
=20
 #endif
--=20
2.25.3

