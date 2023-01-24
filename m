Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEB36797BE
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbjAXMVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbjAXMVC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:21:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E4A4520C
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1IrD0JNMa6EgZRJfoLAnNinrZH+R/R11fkdtoGYsJmY=;
        b=VEXDkjUc+/EA7SrTGil43ppYUkFB3aXuEreYupTPIiLNUvB8NrUC2H0W7bgpRiK/ey4NQ4
        4hsQQ3dEZACCWVjZMCbBe61H2sIKHGZUE/HLC3DNT67pvLGWRjTDKGTmf3bUjcyP6LMW+9
        61DRH+G8GBXcQW2UeeqnBotlwn5nu44=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-EVQ9P68yOSG-B5WpFJi8jg-1; Tue, 24 Jan 2023 07:19:51 -0500
X-MC-Unique: EVQ9P68yOSG-B5WpFJi8jg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1A0080D182;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B1250492C18;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id D285321E6936; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 27/32] monitor: Move monitor_putc() next to monitor_puts & external linkage
Date:   Tue, 24 Jan 2023 13:19:41 +0100
Message-Id: <20230124121946.1139465-28-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

monitor_putc() will soon be used from more than one .c file.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 include/monitor/monitor.h |  1 +
 monitor/misc.c            | 27 ---------------------------
 monitor/monitor.c         | 27 +++++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/include/monitor/monitor.h b/include/monitor/monitor.h
index 1e6f4c9bd7..033390f699 100644
--- a/include/monitor/monitor.h
+++ b/include/monitor/monitor.h
@@ -35,6 +35,7 @@ int monitor_puts(Monitor *mon, const char *str);
 int monitor_vprintf(Monitor *mon, const char *fmt, va_list ap)
     G_GNUC_PRINTF(2, 0);
 int monitor_printf(Monitor *mon, const char *fmt, ...) G_GNUC_PRINTF(2, 3);
+void monitor_printc(Monitor *mon, int ch);
 void monitor_flush(Monitor *mon);
 int monitor_set_cpu(Monitor *mon, int cpu_index);
 int monitor_get_cpu_index(Monitor *mon);
diff --git a/monitor/misc.c b/monitor/misc.c
index c531d95b5b..7a0ba35923 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -304,33 +304,6 @@ static void hmp_gdbserver(Monitor *mon, const QDict *qdict)
     }
 }
 
-static void monitor_printc(Monitor *mon, int c)
-{
-    monitor_printf(mon, "'");
-    switch(c) {
-    case '\'':
-        monitor_printf(mon, "\\'");
-        break;
-    case '\\':
-        monitor_printf(mon, "\\\\");
-        break;
-    case '\n':
-        monitor_printf(mon, "\\n");
-        break;
-    case '\r':
-        monitor_printf(mon, "\\r");
-        break;
-    default:
-        if (c >= 32 && c <= 126) {
-            monitor_printf(mon, "%c", c);
-        } else {
-            monitor_printf(mon, "\\x%02x", c);
-        }
-        break;
-    }
-    monitor_printf(mon, "'");
-}
-
 static void memory_dump(Monitor *mon, int count, int format, int wsize,
                         hwaddr addr, int is_physical)
 {
diff --git a/monitor/monitor.c b/monitor/monitor.c
index 605fe41748..0a990633d8 100644
--- a/monitor/monitor.c
+++ b/monitor/monitor.c
@@ -259,6 +259,33 @@ int monitor_printf(Monitor *mon, const char *fmt, ...)
     return ret;
 }
 
+void monitor_printc(Monitor *mon, int c)
+{
+    monitor_printf(mon, "'");
+    switch(c) {
+    case '\'':
+        monitor_printf(mon, "\\'");
+        break;
+    case '\\':
+        monitor_printf(mon, "\\\\");
+        break;
+    case '\n':
+        monitor_printf(mon, "\\n");
+        break;
+    case '\r':
+        monitor_printf(mon, "\\r");
+        break;
+    default:
+        if (c >= 32 && c <= 126) {
+            monitor_printf(mon, "%c", c);
+        } else {
+            monitor_printf(mon, "\\x%02x", c);
+        }
+        break;
+    }
+    monitor_printf(mon, "'");
+}
+
 /*
  * Print to current monitor if we have one, else to stderr.
  */
-- 
2.39.0

