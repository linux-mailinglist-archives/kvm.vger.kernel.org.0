Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD0C78096E
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359626AbjHRKAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 06:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357784AbjHRKAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 06:00:22 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBE73AAE
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352792; x=1723888792;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S4EZHfYghN1GjPp6m8DZk1tSGfZ9qOmPSLsbN3NvmO0=;
  b=KBvbsM8Gd2bheIFBbFYU3z4PuiJmlfSBuGxB6akfU/cg9m6ESonZAjH4
   crQuvMVIq074WCmbFzxAnITODLkwUuLwU7hQGNuKr53Mvh3H7KbIWq5hE
   U4ZnBXIClkFiy8bEODrMOtdSQr/prttBN7PavfpSB3sTFTZcnWG8tQJSr
   cnFMTqwGjR44oad9sBGjPSlFtIK5eKSouwwo57f4j1HqFRQN6U6S9vVCs
   dMikr+Cpt5ajiqZcg8v0nuSYjOlRMJegTwWHx8381uW1iq7zpIKWepRV4
   yR+L/GSKhZpAiKOUR21Gyyie5LV1ekqU6R7WQXuH/6V64qVffhN4Dyyr7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966701"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966701"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:58:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235519"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235519"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:58:06 -0700
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
Subject: [PATCH v2 43/58] i386/tdx: setup a timer for the qio channel
Date:   Fri, 18 Aug 2023 05:50:26 -0400
Message-Id: <20230818095041.1973309-44-xiaoyao.li@intel.com>
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

To avoid no response from QGS server, setup a timer for the transaction. If
timeout, make it an error and interrupt guest. Define the threshold of time
to 30s at present, maybe change to other value if not appropriate.

Extract the common cleanup code to make it more clear.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 151 ++++++++++++++++++++++++------------------
 1 file changed, 85 insertions(+), 66 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 3cb2163a0335..fa658ce1f2e4 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -1002,6 +1002,7 @@ struct tdx_get_quote_task {
     struct tdx_get_quote_header hdr;
     int event_notify_interrupt;
     QIOChannelSocket *ioc;
+    QEMUTimer timer;
 };
 
 struct x86_msi {
@@ -1084,13 +1085,48 @@ static void tdx_td_notify(struct tdx_get_quote_task *t)
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
+    timer_del(&t->timer);
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
@@ -1135,11 +1171,12 @@ static void tdx_get_quote_read(void *opaque)
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
@@ -1155,94 +1192,76 @@ static void tdx_get_quote_read(void *opaque)
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
 
-- 
2.34.1

