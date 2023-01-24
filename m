Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C266797C8
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbjAXMVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233845AbjAXMVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:21:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E977144BD5
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wzQC1Tn0WROzw+IvKMHePgK0za3SJ2FSd6cG8NT27uM=;
        b=V8nUc0uY2tmOGmpZ30WZz1i/TgHkhAPkn8xbQ2gVe9ru1Qv9/Dfl+WWu0J6NB3v2FR8kUK
        VVoYpvQKf2Nu2pg5bqP2xxFESz/eEtg7Fnt2RwjLF60PCSH8ZiushZG9wrnpbS0WlMNF0X
        yaSgIiNyerb4tN6PN9ptEgNsvJQHSU4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-o8jK0O-nN6aTJOvKEuXrlg-1; Tue, 24 Jan 2023 07:19:51 -0500
X-MC-Unique: o8jK0O-nN6aTJOvKEuXrlg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9903802BF3;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BD8240A3600;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id B759F21E691C; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 18/32] migration: Move the QMP command from monitor/ to migration/
Date:   Tue, 24 Jan 2023 13:19:32 +0100
Message-Id: <20230124121946.1139465-19-armbru@redhat.com>
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

This moves the command from MAINTAINERS sections "Human Monitor (HMP)"
and "QMP" to "Migration".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 migration/migration.c | 30 ++++++++++++++++++++++++++++++
 monitor/misc.c        | 31 -------------------------------
 2 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/migration/migration.c b/migration/migration.c
index 52b5d39244..56859d5869 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -61,6 +61,7 @@
 #include "sysemu/cpus.h"
 #include "yank_functions.h"
 #include "sysemu/qtest.h"
+#include "ui/qemu-spice.h"
 
 #define MAX_THROTTLE  (128 << 20)      /* Migration transfer speed throttling */
 
@@ -963,6 +964,35 @@ MigrationParameters *qmp_query_migrate_parameters(Error **errp)
     return params;
 }
 
+void qmp_client_migrate_info(const char *protocol, const char *hostname,
+                             bool has_port, int64_t port,
+                             bool has_tls_port, int64_t tls_port,
+                             const char *cert_subject,
+                             Error **errp)
+{
+    if (strcmp(protocol, "spice") == 0) {
+        if (!qemu_using_spice(errp)) {
+            return;
+        }
+
+        if (!has_port && !has_tls_port) {
+            error_setg(errp, QERR_MISSING_PARAMETER, "port/tls-port");
+            return;
+        }
+
+        if (qemu_spice.migrate_info(hostname,
+                                    has_port ? port : -1,
+                                    has_tls_port ? tls_port : -1,
+                                    cert_subject)) {
+            error_setg(errp, "Could not set up display for migration");
+            return;
+        }
+        return;
+    }
+
+    error_setg(errp, QERR_INVALID_PARAMETER_VALUE, "protocol", "'spice'");
+}
+
 AnnounceParameters *migrate_announce_params(void)
 {
     static AnnounceParameters ap;
diff --git a/monitor/misc.c b/monitor/misc.c
index 780f2a6b04..ff3002a880 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -27,7 +27,6 @@
 #include "monitor/qdev.h"
 #include "exec/gdbstub.h"
 #include "net/slirp.h"
-#include "ui/qemu-spice.h"
 #include "qemu/ctype.h"
 #include "disas/disas.h"
 #include "qemu/log.h"
@@ -43,7 +42,6 @@
 #include "exec/ioport.h"
 #include "block/block-hmp-cmds.h"
 #include "qapi/qapi-commands-control.h"
-#include "qapi/qapi-commands-migration.h"
 #include "qapi/qapi-commands-misc.h"
 #include "qapi/qapi-commands-run-state.h"
 #include "qapi/qapi-commands-machine.h"
@@ -291,35 +289,6 @@ static void hmp_info_history(Monitor *mon, const QDict *qdict)
     }
 }
 
-void qmp_client_migrate_info(const char *protocol, const char *hostname,
-                             bool has_port, int64_t port,
-                             bool has_tls_port, int64_t tls_port,
-                             const char *cert_subject,
-                             Error **errp)
-{
-    if (strcmp(protocol, "spice") == 0) {
-        if (!qemu_using_spice(errp)) {
-            return;
-        }
-
-        if (!has_port && !has_tls_port) {
-            error_setg(errp, QERR_MISSING_PARAMETER, "port/tls-port");
-            return;
-        }
-
-        if (qemu_spice.migrate_info(hostname,
-                                    has_port ? port : -1,
-                                    has_tls_port ? tls_port : -1,
-                                    cert_subject)) {
-            error_setg(errp, "Could not set up display for migration");
-            return;
-        }
-        return;
-    }
-
-    error_setg(errp, QERR_INVALID_PARAMETER_VALUE, "protocol", "'spice'");
-}
-
 static void hmp_logfile(Monitor *mon, const QDict *qdict)
 {
     Error *err = NULL;
-- 
2.39.0

