Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450C56797BB
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbjAXMVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbjAXMVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:21:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C817457E3
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uxEEtJ3IM5/1IWK4VNaU3e06Of2cEbir0W1pV/yWgx0=;
        b=DYFa99pxcjU/rUM+BPiwBPLTGg7d+TP/+PSXXQjo1wOukEEWfDs/K7iqhb84HkvrGjqSut
        tL+tr9o6/SxWA58ixTqiQoKU1AeJGF+cRPwv5az+lPoJqq6+/ONO3rv4J8UFRiz9Z81S2B
        NmpCugFyCsbXwTvqzMhUS6vu9qeBn7Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-JQdgETT1Oeq9NMIopkS-_Q-1; Tue, 24 Jan 2023 07:19:50 -0500
X-MC-Unique: JQdgETT1Oeq9NMIopkS-_Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A1768533DB;
        Tue, 24 Jan 2023 12:19:49 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AC93400D795;
        Tue, 24 Jan 2023 12:19:49 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id A596F21E6913; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 12/32] block: Factor out hmp_change_medium(), and move to block/monitor/
Date:   Tue, 24 Jan 2023 13:19:26 +0100
Message-Id: <20230124121946.1139465-13-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
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

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 include/monitor/hmp.h          |  3 +++
 block/monitor/block-hmp-cmds.c | 21 +++++++++++++++++++++
 monitor/hmp-cmds.c             | 17 +----------------
 3 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
index 58ed1bec62..6fafa7ffb4 100644
--- a/include/monitor/hmp.h
+++ b/include/monitor/hmp.h
@@ -78,6 +78,9 @@ void hmp_change_vnc(Monitor *mon, const char *device, const char *target,
                     const char *arg, const char *read_only, bool force,
                     Error **errp);
 #endif
+void hmp_change_medium(Monitor *mon, const char *device, const char *target,
+                       const char *arg, const char *read_only, bool force,
+                       Error **errp);
 void hmp_migrate(Monitor *mon, const QDict *qdict);
 void hmp_device_add(Monitor *mon, const QDict *qdict);
 void hmp_device_del(Monitor *mon, const QDict *qdict);
diff --git a/block/monitor/block-hmp-cmds.c b/block/monitor/block-hmp-cmds.c
index 0ff7c84039..ae624ab575 100644
--- a/block/monitor/block-hmp-cmds.c
+++ b/block/monitor/block-hmp-cmds.c
@@ -1005,3 +1005,24 @@ void hmp_info_snapshots(Monitor *mon, const QDict *qdict)
     g_free(sn_tab);
     g_free(global_snapshots);
 }
+
+void hmp_change_medium(Monitor *mon, const char *device, const char *target,
+                       const char *arg, const char *read_only, bool force,
+                       Error **errp)
+{
+    ERRP_GUARD();
+    BlockdevChangeReadOnlyMode read_only_mode = 0;
+
+    if (read_only) {
+        read_only_mode =
+            qapi_enum_parse(&BlockdevChangeReadOnlyMode_lookup,
+                            read_only,
+                            BLOCKDEV_CHANGE_READ_ONLY_MODE_RETAIN, errp);
+        if (*errp) {
+            return;
+        }
+    }
+
+    qmp_blockdev_change_medium(device, NULL, target, arg, true, force,
+                               !!read_only, read_only_mode, errp);
+}
diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
index 4fe2aaebcd..bed75af656 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -24,7 +24,6 @@
 #include "qapi/error.h"
 #include "qapi/clone-visitor.h"
 #include "qapi/qapi-builtin-visit.h"
-#include "qapi/qapi-commands-block.h"
 #include "qapi/qapi-commands-control.h"
 #include "qapi/qapi-commands-migration.h"
 #include "qapi/qapi-commands-misc.h"
@@ -916,7 +915,6 @@ void hmp_change(Monitor *mon, const QDict *qdict)
     const char *arg = qdict_get_try_str(qdict, "arg");
     const char *read_only = qdict_get_try_str(qdict, "read-only-mode");
     bool force = qdict_get_try_bool(qdict, "force", false);
-    BlockdevChangeReadOnlyMode read_only_mode = 0;
     Error *err = NULL;
 
 #ifdef CONFIG_VNC
@@ -925,22 +923,9 @@ void hmp_change(Monitor *mon, const QDict *qdict)
     } else
 #endif
     {
-        if (read_only) {
-            read_only_mode =
-                qapi_enum_parse(&BlockdevChangeReadOnlyMode_lookup,
-                                read_only,
-                                BLOCKDEV_CHANGE_READ_ONLY_MODE_RETAIN, &err);
-            if (err) {
-                goto end;
-            }
-        }
-
-        qmp_blockdev_change_medium(device, NULL, target, arg, true, force,
-                                   !!read_only, read_only_mode,
-                                   &err);
+        hmp_change_medium(mon, device, target, arg, read_only, force, &err);
     }
 
-end:
     hmp_handle_error(mon, err);
 }
 
-- 
2.39.0

