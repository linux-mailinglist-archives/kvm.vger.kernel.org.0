Return-Path: <kvm+bounces-1781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81EB97EBDE2
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:22:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A44161C20B3B
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACAC29464;
	Wed, 15 Nov 2023 07:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XEuPj26n"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC689465
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:22:36 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926229E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032954; x=1731568954;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l5L4cctcI5SBuxfjf0SnVwQgSL+9oPU1c49697KN69E=;
  b=XEuPj26nISfUw4uisndLn/m4IMcHl4bok1ISfJMZMuh8WqK/bX1f3P1e
   N30zZUfaMdGwWa0rV9PuNTTytUIGQr9aY1+445XdHF1ziDr4mBXyFkK9z
   rMQYKVLF21I8gGz6+ANCTsIgaAA95Ke6ORxLAShi4BfDlwy4E9pJGH2gS
   rR+aRW5X7VkbNeQxS7YdMCwnhG+3suVww3IPzqk1HEdvxISsVkdeDu4Sx
   UGwxXY3YohJlFuIonWx82H9wS7GKlhoYfKjfXze2xF7umTCz+llY8hi2x
   ERb+xUSl4hiL67abIriZqwHBMBt7Hrh3dcA1/avxa/kZYdyoxx8X1YyJh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623453"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623453"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:22:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714800264"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714800264"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:22:28 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3 53/70] i386/tdx: setup a timer for the qio channel
Date: Wed, 15 Nov 2023 02:15:02 -0500
Message-Id: <20231115071519.2864957-54-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chenyi Qiang <chenyi.qiang@intel.com>

To avoid no response from QGS server, setup a timer for the transaction.
If timeout, make it an error and interrupt guest. Define the threshold of
time to 30s at present, maybe change to other value if not appropriate.

Extract the common cleanup code to make it more clear.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v3:
 - Use t->timer_armed to track if t->timer is initialized;
---
 target/i386/kvm/tdx.c | 155 ++++++++++++++++++++++++------------------
 1 file changed, 89 insertions(+), 66 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 54b38c031fb3..3b87c36c485e 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -1069,6 +1069,8 @@ struct tdx_get_quote_task {
     struct tdx_get_quote_header hdr;
     int event_notify_interrupt;
     QIOChannelSocket *ioc;
+    QEMUTimer timer;
+    bool timer_armed;
 };
 
 struct x86_msi {
@@ -1151,13 +1153,49 @@ static void tdx_td_notify(struct tdx_get_quote_task *t)
     }
 }
 
+static void tdx_getquote_task_cleanup(struct tdx_get_quote_task *t, bool outlen_overflow)
+{
+    MachineState *ms;
+    TdxGuest *tdx;
+
+    if (t->hdr.error_code != cpu_to_le64(TDX_VP_GET_QUOTE_SUCCESS) && !outlen_overflow) {
+        t->hdr.out_len = cpu_to_le32(0);
+    }
+
+    /* Publish the response contents before marking this request completed. */
+    smp_wmb();
+    if (address_space_write(
+            &address_space_memory, t->gpa,
+            MEMTXATTRS_UNSPECIFIED, &t->hdr, sizeof(t->hdr)) != MEMTX_OK) {
+        error_report("TDX: failed to update GetQuote header.");
+    }
+    tdx_td_notify(t);
+
+    if (t->ioc->fd > 0) {
+        qemu_set_fd_handler(t->ioc->fd, NULL, NULL, NULL);
+    }
+    qio_channel_close(QIO_CHANNEL(t->ioc), NULL);
+    object_unref(OBJECT(t->ioc));
+    if (t->timer_armed)
+        timer_del(&t->timer);
+    g_free(t->out_data);
+    g_free(t);
+
+    /* Maintain the number of in-flight requests. */
+    ms = MACHINE(qdev_get_machine());
+    tdx = TDX_GUEST(ms->cgs);
+    qemu_mutex_lock(&tdx->lock);
+    tdx->quote_generation_num--;
+    qemu_mutex_unlock(&tdx->lock);
+}
+
+
 static void tdx_get_quote_read(void *opaque)
 {
     struct tdx_get_quote_task *t = opaque;
     ssize_t size = 0;
     Error *err = NULL;
-    MachineState *ms;
-    TdxGuest *tdx;
+    bool outlen_overflow = false;
 
     while (true) {
         char *buf;
@@ -1202,11 +1240,12 @@ static void tdx_get_quote_read(void *opaque)
          * There is no specific error code defined for this case(E2BIG) at the
          * moment.
          * TODO: Once an error code for this case is defined in GHCI spec ,
-         * update the error code.
+         * update the error code and the tdx_getquote_task_cleanup() argument.
          */
         t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_ERROR);
         t->hdr.out_len = cpu_to_le32(t->out_len);
-        goto error_hdr;
+        outlen_overflow = true;
+        goto error;
     }
 
     if (address_space_write(
@@ -1222,94 +1261,77 @@ static void tdx_get_quote_read(void *opaque)
     t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_SUCCESS);
 
 error:
-    if (t->hdr.error_code != cpu_to_le64(TDX_VP_GET_QUOTE_SUCCESS)) {
-        t->hdr.out_len = cpu_to_le32(0);
-    }
-error_hdr:
-    if (address_space_write(
-            &address_space_memory, t->gpa,
-            MEMTXATTRS_UNSPECIFIED, &t->hdr, sizeof(t->hdr)) != MEMTX_OK) {
-        error_report("TDX: failed to update GetQuote header.");
-    }
-    tdx_td_notify(t);
+    tdx_getquote_task_cleanup(t, outlen_overflow);
+}
+
+#define TRANSACTION_TIMEOUT 30000
+
+static void getquote_timer_expired(void *opaque)
+{
+    struct tdx_get_quote_task *t = opaque;
+
+    tdx_getquote_task_cleanup(t, false);
+}
 
-    qemu_set_fd_handler(t->ioc->fd, NULL, NULL, NULL);
-    qio_channel_close(QIO_CHANNEL(t->ioc), &err);
-    object_unref(OBJECT(t->ioc));
-    g_free(t->out_data);
-    g_free(t);
+static void tdx_transaction_start(struct tdx_get_quote_task *t)
+{
+    int64_t time;
 
-    /* Maintain the number of in-flight requests. */
-    ms = MACHINE(qdev_get_machine());
-    tdx = TDX_GUEST(ms->cgs);
-    qemu_mutex_lock(&tdx->lock);
-    tdx->quote_generation_num--;
-    qemu_mutex_unlock(&tdx->lock);
+    time = qemu_clock_get_ms(QEMU_CLOCK_VIRTUAL);
+    /*
+     * Timeout callback and fd callback both run in main loop thread,
+     * thus no need to worry about race condition.
+     */
+    qemu_set_fd_handler(t->ioc->fd, tdx_get_quote_read, NULL, t);
+    timer_init_ms(&t->timer, QEMU_CLOCK_VIRTUAL, getquote_timer_expired, t);
+    timer_mod(&t->timer, time + TRANSACTION_TIMEOUT);
+    t->timer_armed = true;
 }
 
-/*
- * TODO: If QGS doesn't reply for long time, make it an error and interrupt
- * guest.
- */
 static void tdx_handle_get_quote_connected(QIOTask *task, gpointer opaque)
 {
     struct tdx_get_quote_task *t = opaque;
     Error *err = NULL;
     char *in_data = NULL;
-    MachineState *ms;
-    TdxGuest *tdx;
+    int ret = 0;
 
     t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_ERROR);
-    if (qio_task_propagate_error(task, NULL)) {
+    ret = qio_task_propagate_error(task, NULL);
+    if (ret) {
         t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
-        goto error;
+        goto out;
     }
 
     in_data = g_malloc(le32_to_cpu(t->hdr.in_len));
     if (!in_data) {
-        goto error;
+        ret = -1;
+        goto out;
     }
 
-    if (address_space_read(&address_space_memory, t->gpa + sizeof(t->hdr),
-                           MEMTXATTRS_UNSPECIFIED, in_data,
-                           le32_to_cpu(t->hdr.in_len)) != MEMTX_OK) {
-        goto error;
+    ret = address_space_read(&address_space_memory, t->gpa + sizeof(t->hdr),
+                             MEMTXATTRS_UNSPECIFIED, in_data,
+                             le32_to_cpu(t->hdr.in_len));
+    if (ret) {
+        g_free(in_data);
+        goto out;
     }
 
     qio_channel_set_blocking(QIO_CHANNEL(t->ioc), false, NULL);
 
-    if (qio_channel_write_all(QIO_CHANNEL(t->ioc), in_data,
-                              le32_to_cpu(t->hdr.in_len), &err) ||
-        err) {
+    ret = qio_channel_write_all(QIO_CHANNEL(t->ioc), in_data,
+                              le32_to_cpu(t->hdr.in_len), &err);
+    if (ret) {
         t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
-        goto error;
+        g_free(in_data);
+        goto out;
     }
 
-    g_free(in_data);
-    qemu_set_fd_handler(t->ioc->fd, tdx_get_quote_read, NULL, t);
-
-    return;
-error:
-    t->hdr.out_len = cpu_to_le32(0);
-
-    if (address_space_write(
-            &address_space_memory, t->gpa,
-            MEMTXATTRS_UNSPECIFIED, &t->hdr, sizeof(t->hdr)) != MEMTX_OK) {
-        error_report("TDX: failed to update GetQuote header.\n");
+out:
+    if (ret) {
+        tdx_getquote_task_cleanup(t, false);
+    } else {
+        tdx_transaction_start(t);
     }
-    tdx_td_notify(t);
-
-    qio_channel_close(QIO_CHANNEL(t->ioc), &err);
-    object_unref(OBJECT(t->ioc));
-    g_free(t);
-    g_free(in_data);
-
-    /* Maintain the number of in-flight requests. */
-    ms = MACHINE(qdev_get_machine());
-    tdx = TDX_GUEST(ms->cgs);
-    qemu_mutex_lock(&tdx->lock);
-    tdx->quote_generation_num--;
-    qemu_mutex_unlock(&tdx->lock);
     return;
 }
 
@@ -1382,6 +1404,7 @@ static void tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
     t->out_len = 0;
     t->hdr = hdr;
     t->ioc = ioc;
+    t->timer_armed = false;
 
     qemu_mutex_lock(&tdx->lock);
     if (!tdx->quote_generation ||
-- 
2.34.1


