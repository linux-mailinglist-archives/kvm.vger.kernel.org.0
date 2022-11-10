Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B936D624785
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 17:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbiKJQuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 11:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiKJQt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 11:49:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC056450
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668098898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mCeFUvd8Kq8Qt7Mn84nMP6ZZ97jPIWZ4yJQYiSlWipM=;
        b=VFOj3ozp4aboLBh5Ba55xrsPwzZNKy5ingvVQuhaEMTqG+lJHJYQW7JC4fPP5TN3wJ1OLN
        OSxAz8I7YfblfCth6bUGVDc1hfUfehevycKr1W8yZC0psSzB+FFnBDEVaqKqU1tMKM0mdP
        vui1uJmDyHtwTYxEfIXbR8z1ow4+paU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-cUdW0m5kOUiIb1_hL1gLog-1; Thu, 10 Nov 2022 11:48:12 -0500
X-MC-Unique: cUdW0m5kOUiIb1_hL1gLog-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C028887B2AC;
        Thu, 10 Nov 2022 16:48:09 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8081C40C94AA;
        Thu, 10 Nov 2022 16:48:09 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH v2 1/3] accel: introduce accelerator blocker API
Date:   Thu, 10 Nov 2022 11:48:05 -0500
Message-Id: <20221110164807.1306076-2-eesposit@redhat.com>
In-Reply-To: <20221110164807.1306076-1-eesposit@redhat.com>
References: <20221110164807.1306076-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This API allows the accelerators to prevent vcpus from issuing
new ioctls while execting a critical section marked with the
accel-ioctl_inhibit_begin/end functions.

Note that all functions submitting ioctls must mark where the
ioctl is being called with accel_{cpu_}set_in_ioctl().

This API requires the caller to always hold the BQL.
API documentation is in sysemu/accel-blocker.h

Internally, it uses a QemuLockCnt together with a per-CPU QemuLockCnt
(to minimize cache line bouncing) to keep avoid that new ioctls
run when the critical section starts, and a QemuEvent to wait
that all running ioctls finish.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 accel/accel-blocker.c          | 139 +++++++++++++++++++++++++++++++++
 accel/meson.build              |   2 +-
 include/sysemu/accel-blocker.h |  45 +++++++++++
 3 files changed, 185 insertions(+), 1 deletion(-)
 create mode 100644 accel/accel-blocker.c
 create mode 100644 include/sysemu/accel-blocker.h

diff --git a/accel/accel-blocker.c b/accel/accel-blocker.c
new file mode 100644
index 0000000000..2701a05945
--- /dev/null
+++ b/accel/accel-blocker.c
@@ -0,0 +1,139 @@
+/*
+ * QEMU accel blocker class
+ *
+ * Copyright (c) 2014 Red Hat Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to deal
+ * in the Software without restriction, including without limitation the rights
+ * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
+ * copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
+ * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
+ * THE SOFTWARE.
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/thread.h"
+#include "qemu/main-loop.h"
+#include "hw/core/cpu.h"
+#include "sysemu/accel-blocker.h"
+
+static QemuLockCnt accel_in_ioctl_lock;
+static QemuEvent accel_in_ioctl_event;
+
+void accel_blocker_init(void)
+{
+    qemu_lockcnt_init(&accel_in_ioctl_lock);
+    qemu_event_init(&accel_in_ioctl_event, false);
+}
+
+void accel_set_in_ioctl(bool in_ioctl)
+{
+    if (likely(qemu_mutex_iothread_locked())) {
+        return;
+    }
+    if (in_ioctl) {
+        /* block if lock is taken in kvm_ioctl_inhibit_begin() */
+        qemu_lockcnt_inc(&accel_in_ioctl_lock);
+    } else {
+        qemu_lockcnt_dec(&accel_in_ioctl_lock);
+        /* change event to SET. If event was BUSY, wake up all waiters */
+        qemu_event_set(&accel_in_ioctl_event);
+    }
+}
+
+void accel_cpu_set_in_ioctl(CPUState *cpu, bool in_ioctl)
+{
+    if (unlikely(qemu_mutex_iothread_locked())) {
+        return;
+    }
+    if (in_ioctl) {
+        /* block if lock is taken in kvm_ioctl_inhibit_begin() */
+        qemu_lockcnt_inc(&cpu->in_ioctl_lock);
+    } else {
+        qemu_lockcnt_dec(&cpu->in_ioctl_lock);
+        /* change event to SET. If event was BUSY, wake up all waiters */
+        qemu_event_set(&accel_in_ioctl_event);
+    }
+}
+
+static int accel_in_ioctls(void)
+{
+    CPUState *cpu;
+    int ret = qemu_lockcnt_count(&accel_in_ioctl_lock);
+
+    CPU_FOREACH(cpu) {
+        ret += qemu_lockcnt_count(&cpu->in_ioctl_lock);
+    }
+
+    return  ret;
+}
+
+void accel_ioctl_inhibit_begin(void)
+{
+    CPUState *cpu;
+
+    /*
+     * We allow to inhibit only when holding the BQL, so we can identify
+     * when an inhibitor wants to issue an ioctl easily.
+     */
+    g_assert(qemu_mutex_iothread_locked());
+
+    /* Block further invocations of the ioctls outside the BQL.  */
+    CPU_FOREACH(cpu) {
+        qemu_lockcnt_lock(&cpu->in_ioctl_lock);
+    }
+    qemu_lockcnt_lock(&accel_in_ioctl_lock);
+
+    /* Keep waiting until there are running ioctls */
+    while (accel_in_ioctls()) {
+        /* Reset event to FREE. */
+        qemu_event_reset(&accel_in_ioctl_event);
+
+        if (accel_in_ioctls()) {
+
+            CPU_FOREACH(cpu) {
+                /* exit the ioctl */
+                qemu_cpu_kick(cpu);
+            }
+
+            /*
+             * If event is still FREE, and there are ioctls still in progress,
+             * wait.
+             *
+             *  If an ioctl finishes before qemu_event_wait(), it will change
+             * the event state to SET. This will prevent qemu_event_wait() from
+             * blocking, but it's not a problem because if other ioctls are
+             * still running (accel_in_ioctls is true) the loop will iterate
+             * once more and reset the event status to FREE so that it can wait
+             * properly.
+             *
+             * If an ioctls finishes while qemu_event_wait() is blocking, then
+             * it will be waken up, but also here the while loop makes sure
+             * to re-enter the wait if there are other running ioctls.
+             */
+            qemu_event_wait(&accel_in_ioctl_event);
+        }
+    }
+}
+
+void accel_ioctl_inhibit_end(void)
+{
+    CPUState *cpu;
+
+    qemu_lockcnt_unlock(&accel_in_ioctl_lock);
+    CPU_FOREACH(cpu) {
+        qemu_lockcnt_unlock(&cpu->in_ioctl_lock);
+    }
+}
+
diff --git a/accel/meson.build b/accel/meson.build
index b9a963cf80..a0d49c4f31 100644
--- a/accel/meson.build
+++ b/accel/meson.build
@@ -1,4 +1,4 @@
-specific_ss.add(files('accel-common.c'))
+specific_ss.add(files('accel-common.c', 'accel-blocker.c'))
 softmmu_ss.add(files('accel-softmmu.c'))
 user_ss.add(files('accel-user.c'))
 
diff --git a/include/sysemu/accel-blocker.h b/include/sysemu/accel-blocker.h
new file mode 100644
index 0000000000..135ebea566
--- /dev/null
+++ b/include/sysemu/accel-blocker.h
@@ -0,0 +1,45 @@
+/*
+ * Accelerator blocking API, to prevent new ioctls from starting and wait the
+ * running ones finish.
+ * This mechanism differs from pause/resume_all_vcpus() in that it does not
+ * release the BQL.
+ *
+ *  Copyright (c) 2014 Red Hat Inc.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ */
+#ifndef ACCEL_BLOCKER_H
+#define ACCEL_BLOCKER_H
+
+#include "qemu/osdep.h"
+#include "qemu/accel.h"
+#include "sysemu/cpus.h"
+
+extern void accel_blocker_init(void);
+
+/*
+ * accel_set_in_ioctl/accel_cpu_set_in_ioctl:
+ * Mark when ioctl is about to run or just finished.
+ * If @in_ioctl is true, then mark it is beginning. Otherwise marks that it is
+ * ending.
+ *
+ * These functions will block after accel_ioctl_inhibit_begin() is called,
+ * preventing new ioctls to run. They will continue only after
+ * accel_ioctl_inibith_end().
+ */
+extern void accel_set_in_ioctl(bool in_ioctl);
+extern void accel_cpu_set_in_ioctl(CPUState *cpu, bool in_ioctl);
+
+/*
+ * accel_ioctl_inhibit_begin/end: start/end critical section
+ * Between these two calls, no ioctl marked with accel_set_in_ioctl() and
+ * accel_cpu_set_in_ioctl() is allowed to run.
+ *
+ * This allows the caller to access shared data or perform operations without
+ * worrying of concurrent vcpus accesses.
+ */
+extern void accel_ioctl_inhibit_begin(void);
+extern void accel_ioctl_inhibit_end(void);
+
+#endif /* ACCEL_BLOCKER_H */
-- 
2.31.1

