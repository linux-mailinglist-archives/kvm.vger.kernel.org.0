Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7FB6797A9
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbjAXMUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbjAXMUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EF944BF9
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XLDq11k/abGd5o2k94Ac+bOh5hEdpC30VkJC0F0iBFo=;
        b=CsDx+eySsC8+pGxGgrjBdkS+mWUqrUVjLgDu6XkoIebRv7YFX55twtfdm53S3AcVu4fMBd
        1ZGqeYGfL+uzQj1dsOTaOc6N4nM8Cincnt/CNZy5KNlqf1JNrAxSRbmEq1lj8/u0hRhXT4
        oAEc+ouiF2H4zS23Ge9TjSHA9F8Hivw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-z9BmHfZ_PJS7XJLzeZcZoA-1; Tue, 24 Jan 2023 07:19:49 -0500
X-MC-Unique: z9BmHfZ_PJS7XJLzeZcZoA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 393181C0512E;
        Tue, 24 Jan 2023 12:19:48 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D23240A3600;
        Tue, 24 Jan 2023 12:19:47 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 85BF121E6A21; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, kraxel@redhat.com, kwolf@redhat.com,
        hreitz@redhat.com, marcandre.lureau@redhat.com,
        dgilbert@redhat.com, mst@redhat.com, imammedo@redhat.com,
        ani@anisinha.ca, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        philmd@linaro.org, wangyanan55@huawei.com, jasowang@redhat.com,
        jiri@resnulli.us, berrange@redhat.com, thuth@redhat.com,
        quintela@redhat.com, stefanb@linux.vnet.ibm.com,
        stefanha@redhat.com, kvm@vger.kernel.org, qemu-block@nongnu.org
Subject: [PATCH 02/32] audio: Move HMP commands from monitor/ to audio/
Date:   Tue, 24 Jan 2023 13:19:16 +0100
Message-Id: <20230124121946.1139465-3-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This moves these commands from MAINTAINERS sections "Human
Monitor (HMP)" and "QMP" to "Overall Audio backends".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 include/monitor/hmp.h  |  3 ++
 audio/audio-hmp-cmds.c | 83 ++++++++++++++++++++++++++++++++++++++++++
 monitor/misc.c         | 56 ----------------------------
 audio/meson.build      |  1 +
 4 files changed, 87 insertions(+), 56 deletions(-)
 create mode 100644 audio/audio-hmp-cmds.c

diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
index 1b3bdcb446..c25bec1863 100644
--- a/include/monitor/hmp.h
+++ b/include/monitor/hmp.h
@@ -151,5 +151,8 @@ void hmp_human_readable_text_helper(Monitor *mon,
                                     HumanReadableText *(*qmp_handler)(Error **));
 void hmp_info_stats(Monitor *mon, const QDict *qdict);
 void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict);
+void hmp_info_capture(Monitor *mon, const QDict *qdict);
+void hmp_stopcapture(Monitor *mon, const QDict *qdict);
+void hmp_wavcapture(Monitor *mon, const QDict *qdict);
 
 #endif
diff --git a/audio/audio-hmp-cmds.c b/audio/audio-hmp-cmds.c
new file mode 100644
index 0000000000..1237ce9e75
--- /dev/null
+++ b/audio/audio-hmp-cmds.c
@@ -0,0 +1,83 @@
+/*
+ * HMP commands related to audio backends
+ *
+ * Copyright (c) 2003-2004 Fabrice Bellard
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
+#include "audio/audio.h"
+#include "monitor/hmp.h"
+#include "monitor/monitor.h"
+#include "qapi/qmp/qdict.h"
+
+static QLIST_HEAD (capture_list_head, CaptureState) capture_head;
+
+void hmp_info_capture(Monitor *mon, const QDict *qdict)
+{
+    int i;
+    CaptureState *s;
+
+    for (s = capture_head.lh_first, i = 0; s; s = s->entries.le_next, ++i) {
+        monitor_printf(mon, "[%d]: ", i);
+        s->ops.info (s->opaque);
+    }
+}
+
+void hmp_stopcapture(Monitor *mon, const QDict *qdict)
+{
+    int i;
+    int n = qdict_get_int(qdict, "n");
+    CaptureState *s;
+
+    for (s = capture_head.lh_first, i = 0; s; s = s->entries.le_next, ++i) {
+        if (i == n) {
+            s->ops.destroy (s->opaque);
+            QLIST_REMOVE (s, entries);
+            g_free (s);
+            return;
+        }
+    }
+}
+
+void hmp_wavcapture(Monitor *mon, const QDict *qdict)
+{
+    const char *path = qdict_get_str(qdict, "path");
+    int freq = qdict_get_try_int(qdict, "freq", 44100);
+    int bits = qdict_get_try_int(qdict, "bits", 16);
+    int nchannels = qdict_get_try_int(qdict, "nchannels", 2);
+    const char *audiodev = qdict_get_str(qdict, "audiodev");
+    CaptureState *s;
+    AudioState *as = audio_state_by_name(audiodev);
+
+    if (!as) {
+        monitor_printf(mon, "Audiodev '%s' not found\n", audiodev);
+        return;
+    }
+
+    s = g_malloc0 (sizeof (*s));
+
+    if (wav_start_capture(as, s, path, freq, bits, nchannels)) {
+        monitor_printf(mon, "Failed to add wave capture\n");
+        g_free (s);
+        return;
+    }
+    QLIST_INSERT_HEAD (&capture_head, s, entries);
+}
diff --git a/monitor/misc.c b/monitor/misc.c
index 6fc8bfef13..80d5527774 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -30,7 +30,6 @@
 #include "net/slirp.h"
 #include "ui/qemu-spice.h"
 #include "qemu/ctype.h"
-#include "audio/audio.h"
 #include "disas/disas.h"
 #include "qemu/log.h"
 #include "sysemu/hw_accel.h"
@@ -892,61 +891,6 @@ static void hmp_info_mtree(Monitor *mon, const QDict *qdict)
     mtree_info(flatview, dispatch_tree, owner, disabled);
 }
 
-/* Capture support */
-static QLIST_HEAD (capture_list_head, CaptureState) capture_head;
-
-static void hmp_info_capture(Monitor *mon, const QDict *qdict)
-{
-    int i;
-    CaptureState *s;
-
-    for (s = capture_head.lh_first, i = 0; s; s = s->entries.le_next, ++i) {
-        monitor_printf(mon, "[%d]: ", i);
-        s->ops.info (s->opaque);
-    }
-}
-
-static void hmp_stopcapture(Monitor *mon, const QDict *qdict)
-{
-    int i;
-    int n = qdict_get_int(qdict, "n");
-    CaptureState *s;
-
-    for (s = capture_head.lh_first, i = 0; s; s = s->entries.le_next, ++i) {
-        if (i == n) {
-            s->ops.destroy (s->opaque);
-            QLIST_REMOVE (s, entries);
-            g_free (s);
-            return;
-        }
-    }
-}
-
-static void hmp_wavcapture(Monitor *mon, const QDict *qdict)
-{
-    const char *path = qdict_get_str(qdict, "path");
-    int freq = qdict_get_try_int(qdict, "freq", 44100);
-    int bits = qdict_get_try_int(qdict, "bits", 16);
-    int nchannels = qdict_get_try_int(qdict, "nchannels", 2);
-    const char *audiodev = qdict_get_str(qdict, "audiodev");
-    CaptureState *s;
-    AudioState *as = audio_state_by_name(audiodev);
-
-    if (!as) {
-        monitor_printf(mon, "Audiodev '%s' not found\n", audiodev);
-        return;
-    }
-
-    s = g_malloc0 (sizeof (*s));
-
-    if (wav_start_capture(as, s, path, freq, bits, nchannels)) {
-        monitor_printf(mon, "Failed to add wave capture\n");
-        g_free (s);
-        return;
-    }
-    QLIST_INSERT_HEAD (&capture_head, s, entries);
-}
-
 void qmp_getfd(const char *fdname, Error **errp)
 {
     Monitor *cur_mon = monitor_cur();
diff --git a/audio/meson.build b/audio/meson.build
index 34aed78342..0722224ba9 100644
--- a/audio/meson.build
+++ b/audio/meson.build
@@ -1,5 +1,6 @@
 softmmu_ss.add([spice_headers, files('audio.c')])
 softmmu_ss.add(files(
+  'audio-hmp-cmds.c',
   'audio_legacy.c',
   'mixeng.c',
   'noaudio.c',
-- 
2.39.0

