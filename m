Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0961A78095E
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359608AbjHRKAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 06:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359622AbjHRJ77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:59:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2D830C4
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352772; x=1723888772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t3pZISWmXGxp6mBuscDNXGPMyfy1JI6oUdWzTtTZ32s=;
  b=mHerEiQ02HRTxzdN/J746q4vFEyfTu5boVWCaI18dUoTw5xHB5zJWhe3
   v4Mc2zOoVtZOlFxmrcaljRXgl75XdAlZaPjwsQWDhD9MTEmKprd9Jdd4D
   atnYplkyqQfz5c1BCWuAgTgGWNs0tvA+kYP6OZLLl1kkHURzY1JGZtttF
   1diEA4189LCerNdIL0NJ/1yLnQCfAt6D5+EubKuTRQqHUypAhV6ydDqi5
   9pUD37qDVd4HapqO6MqwJRnyK1kC0rTLdHmXcknDTKJz/CDqaJ8yMnNba
   oByf74xj97DSWtD1zMVUXFwlYzXDn5rLK/PcpKJ5xdlCF9cugsTJ6B4gP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966688"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966688"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:58:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235509"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235509"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:58:00 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>, xiaoyao.li@intel.com,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v2 42/58] i386/tdx: register the fd read callback with the main loop to read the quote data
Date:   Fri, 18 Aug 2023 05:50:25 -0400
Message-Id: <20230818095041.1973309-43-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230818095041.1973309-1-xiaoyao.li@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chenyi Qiang <chenyi.qiang@intel.com>

When TD guest invokes getquote tdvmcall, QEMU will register a async qio
task with default context when the qio channel is connected. However, as
there is a blocking action (recvmsg()) in qio_channel_read() and it will
block main thread and make TD guest have no response until the server
returns.

Set the io channel non-blocking and register the socket fd with the main
loop. Move the read operation into the callback. When the fd is readable,
inovke the callback to handle the quote data.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 147 +++++++++++++++++++++++++++---------------
 1 file changed, 96 insertions(+), 51 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 73d6cd88af9e..3cb2163a0335 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -997,6 +997,8 @@ struct tdx_get_quote_task {
     uint32_t apic_id;
     hwaddr gpa;
     uint64_t buf_len;
+    char *out_data;
+    uint64_t out_len;
     struct tdx_get_quote_header hdr;
     int event_notify_interrupt;
     QIOChannelSocket *ioc;
@@ -1082,78 +1084,53 @@ static void tdx_td_notify(struct tdx_get_quote_task *t)
     }
 }
 
-/*
- * TODO: If QGS doesn't reply for long time, make it an error and interrupt
- * guest.
- */
-static void tdx_handle_get_quote_connected(QIOTask *task, gpointer opaque)
+static void tdx_get_quote_read(void *opaque)
 {
     struct tdx_get_quote_task *t = opaque;
+    ssize_t size = 0;
     Error *err = NULL;
-    char *in_data = NULL;
-    char *out_data = NULL;
-    size_t out_len;
-    ssize_t size;
     MachineState *ms;
     TdxGuest *tdx;
 
-    t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_ERROR);
-    if (qio_task_propagate_error(task, NULL)) {
-        t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
-        goto error;
-    }
-
-    in_data = g_malloc(le32_to_cpu(t->hdr.in_len));
-    if (address_space_read(&address_space_memory, t->gpa + sizeof(t->hdr),
-                           MEMTXATTRS_UNSPECIFIED, in_data,
-                           le32_to_cpu(t->hdr.in_len)) != MEMTX_OK) {
-        goto error;
-    }
-
-    if (qio_channel_write_all(QIO_CHANNEL(t->ioc), in_data,
-                              le32_to_cpu(t->hdr.in_len), &err) ||
-        err) {
-        t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
-        goto error;
-    }
-
-    out_data = g_malloc(t->buf_len);
-    out_len = 0;
-    size = 0;
     while (true) {
         char *buf;
         size_t buf_size;
 
-        if (out_len < t->buf_len) {
-            buf = out_data + out_len;
-            buf_size = t->buf_len - out_len;
+        if (t->out_len < t->buf_len) {
+            buf = t->out_data + t->out_len;
+            buf_size = t->buf_len - t->out_len;
         } else {
             /*
              * The received data is too large to fit in the shared GPA.
              * Discard the received data and try to know the data size.
              */
-            buf = out_data;
+            buf = t->out_data;
             buf_size = t->buf_len;
         }
 
         size = qio_channel_read(QIO_CHANNEL(t->ioc), buf, buf_size, &err);
-        if (err) {
+        if (!size) {
             break;
         }
-        if (size <= 0) {
-            break;
+
+        if (size < 0) {
+            if (size == QIO_CHANNEL_ERR_BLOCK) {
+                return;
+            } else {
+                break;
+            }
         }
-        out_len += size;
+        t->out_len += size;
     }
     /*
-     * Treat partial read as success and let the QGS client to handle it because
-     * the client knows better about the QGS.
+     * If partial read successfully but return error at last, also treat it
+     * as failure.
      */
-    if (out_len == 0 && (err || size < 0)) {
+    if (size < 0) {
         t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
         goto error;
     }
-    if (out_len > 0 && out_len > t->buf_len) {
+    if (t->out_len > 0 && t->out_len > t->buf_len) {
         /*
          * There is no specific error code defined for this case(E2BIG) at the
          * moment.
@@ -1161,20 +1138,20 @@ static void tdx_handle_get_quote_connected(QIOTask *task, gpointer opaque)
          * update the error code.
          */
         t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_ERROR);
-        t->hdr.out_len = cpu_to_le32(out_len);
+        t->hdr.out_len = cpu_to_le32(t->out_len);
         goto error_hdr;
     }
 
     if (address_space_write(
             &address_space_memory, t->gpa + sizeof(t->hdr),
-            MEMTXATTRS_UNSPECIFIED, out_data, out_len) != MEMTX_OK) {
+            MEMTXATTRS_UNSPECIFIED, t->out_data, t->out_len) != MEMTX_OK) {
         goto error;
     }
     /*
      * Even if out_len == 0, it's a success.  It's up to the QGS-client contract
      * how to interpret the zero-sized message as return message.
      */
-    t->hdr.out_len = cpu_to_le32(out_len);
+    t->hdr.out_len = cpu_to_le32(t->out_len);
     t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_SUCCESS);
 
 error:
@@ -1185,14 +1162,15 @@ error_hdr:
     if (address_space_write(
             &address_space_memory, t->gpa,
             MEMTXATTRS_UNSPECIFIED, &t->hdr, sizeof(t->hdr)) != MEMTX_OK) {
-        error_report("TDX: failed to updsate GetQuote header.\n");
+        error_report("TDX: failed to update GetQuote header.");
     }
     tdx_td_notify(t);
 
+    qemu_set_fd_handler(t->ioc->fd, NULL, NULL, NULL);
     qio_channel_close(QIO_CHANNEL(t->ioc), &err);
     object_unref(OBJECT(t->ioc));
-    g_free(in_data);
-    g_free(out_data);
+    g_free(t->out_data);
+    g_free(t);
 
     /* Maintain the number of in-flight requests. */
     ms = MACHINE(qdev_get_machine());
@@ -1200,7 +1178,71 @@ error_hdr:
     qemu_mutex_lock(&tdx->lock);
     tdx->quote_generation_num--;
     qemu_mutex_unlock(&tdx->lock);
+}
+
+/*
+ * TODO: If QGS doesn't reply for long time, make it an error and interrupt
+ * guest.
+ */
+static void tdx_handle_get_quote_connected(QIOTask *task, gpointer opaque)
+{
+    struct tdx_get_quote_task *t = opaque;
+    Error *err = NULL;
+    char *in_data = NULL;
+    MachineState *ms;
+    TdxGuest *tdx;
+
+    t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_ERROR);
+    if (qio_task_propagate_error(task, NULL)) {
+        t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
+        goto error;
+    }
+
+    in_data = g_malloc(le32_to_cpu(t->hdr.in_len));
+    if (!in_data) {
+        goto error;
+    }
+
+    if (address_space_read(&address_space_memory, t->gpa + sizeof(t->hdr),
+                           MEMTXATTRS_UNSPECIFIED, in_data,
+                           le32_to_cpu(t->hdr.in_len)) != MEMTX_OK) {
+        goto error;
+    }
+
+    qio_channel_set_blocking(QIO_CHANNEL(t->ioc), false, NULL);
+
+    if (qio_channel_write_all(QIO_CHANNEL(t->ioc), in_data,
+                              le32_to_cpu(t->hdr.in_len), &err) ||
+        err) {
+        t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
+        goto error;
+    }
+
+    g_free(in_data);
+    qemu_set_fd_handler(t->ioc->fd, tdx_get_quote_read, NULL, t);
+
+    return;
+error:
+    t->hdr.out_len = cpu_to_le32(0);
 
+    if (address_space_write(
+            &address_space_memory, t->gpa,
+            MEMTXATTRS_UNSPECIFIED, &t->hdr, sizeof(t->hdr)) != MEMTX_OK) {
+        error_report("TDX: failed to update GetQuote header.\n");
+    }
+    tdx_td_notify(t);
+
+    qio_channel_close(QIO_CHANNEL(t->ioc), &err);
+    object_unref(OBJECT(t->ioc));
+    g_free(t);
+    g_free(in_data);
+
+    /* Maintain the number of in-flight requests. */
+    ms = MACHINE(qdev_get_machine());
+    tdx = TDX_GUEST(ms->cgs);
+    qemu_mutex_lock(&tdx->lock);
+    tdx->quote_generation_num--;
+    qemu_mutex_unlock(&tdx->lock);
     return;
 }
 
@@ -1269,6 +1311,8 @@ static void tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
     t->apic_id = tdx->event_notify_apic_id;
     t->gpa = gpa;
     t->buf_len = buf_len;
+    t->out_data = g_malloc(t->buf_len);
+    t->out_len = 0;
     t->hdr = hdr;
     t->ioc = ioc;
 
@@ -1279,13 +1323,14 @@ static void tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
         qemu_mutex_unlock(&tdx->lock);
         vmcall->status_code = TDG_VP_VMCALL_RETRY;
         object_unref(OBJECT(ioc));
+        g_free(t->out_data);
         g_free(t);
         return;
     }
     tdx->quote_generation_num++;
     t->event_notify_interrupt = tdx->event_notify_interrupt;
     qio_channel_socket_connect_async(
-        ioc, tdx->quote_generation, tdx_handle_get_quote_connected, t, g_free,
+        ioc, tdx->quote_generation, tdx_handle_get_quote_connected, t, NULL,
         NULL);
     qemu_mutex_unlock(&tdx->lock);
 
-- 
2.34.1

