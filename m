Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B2C6797A8
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbjAXMUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjAXMUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1AC44BD6
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ap26owxk1u3DODVJclTuu2Ko/YuNT5FBtaRfmrv7qaU=;
        b=GqOaemS1o8SKJZuoxIgjHHSUdBf+GEdH67sB/DQwrmk/bPB3l4X9Pp4HxXBz64WW4DPszd
        6pupguudmPEd4aHlWMisa8U7ekBWkQD4ZuoSCT/LCmYTQcB4BxI9d2CWq/5J4BBbYdP9QZ
        KsKp2+GudwjrdhEEuWBaXU96aXyM7KE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-oOQxsG-zNginQXfvQCHDKg-1; Tue, 24 Jan 2023 07:19:50 -0500
X-MC-Unique: oOQxsG-zNginQXfvQCHDKg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B69D802D1B;
        Tue, 24 Jan 2023 12:19:49 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 345172026D4B;
        Tue, 24 Jan 2023 12:19:49 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 95F6F21E6A26; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 07/32] hmp: Rename help_cmd() to hmp_help_cmd(), move declaration to hmp.h
Date:   Tue, 24 Jan 2023 13:19:21 +0100
Message-Id: <20230124121946.1139465-8-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next commit will move a caller of help_cmd() to a new file.
Including monitor/monitor-internal.h there just for help_cmd() feels
silly.  Better to provide it in monitor/hmp.h suitably renamed.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 include/monitor/hmp.h      | 1 +
 monitor/monitor-internal.h | 1 -
 monitor/hmp.c              | 2 +-
 monitor/misc.c             | 8 ++++----
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
index c25bec1863..5a75f4659c 100644
--- a/include/monitor/hmp.h
+++ b/include/monitor/hmp.h
@@ -18,6 +18,7 @@
 #include "qapi/qapi-types-common.h"
 
 bool hmp_handle_error(Monitor *mon, Error *err);
+void hmp_help_cmd(Monitor *mon, const char *name);
 
 void hmp_info_name(Monitor *mon, const QDict *qdict);
 void hmp_info_version(Monitor *mon, const QDict *qdict);
diff --git a/monitor/monitor-internal.h b/monitor/monitor-internal.h
index a2cdbbf646..53e3808054 100644
--- a/monitor/monitor-internal.h
+++ b/monitor/monitor-internal.h
@@ -186,7 +186,6 @@ void monitor_data_destroy_qmp(MonitorQMP *mon);
 void coroutine_fn monitor_qmp_dispatcher_co(void *data);
 
 int get_monitor_def(Monitor *mon, int64_t *pval, const char *name);
-void help_cmd(Monitor *mon, const char *name);
 void handle_hmp_command(MonitorHMP *mon, const char *cmdline);
 int hmp_compare_cmd(const char *name, const char *list);
 
diff --git a/monitor/hmp.c b/monitor/hmp.c
index 893e100581..844cf54c18 100644
--- a/monitor/hmp.c
+++ b/monitor/hmp.c
@@ -271,7 +271,7 @@ static void help_cmd_dump(Monitor *mon, const HMPCommand *cmds,
     }
 }
 
-void help_cmd(Monitor *mon, const char *name)
+void hmp_help_cmd(Monitor *mon, const char *name)
 {
     char *args[MAX_ARGS];
     int nb_args = 0;
diff --git a/monitor/misc.c b/monitor/misc.c
index 9da52939b2..240d137327 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -153,7 +153,7 @@ int hmp_compare_cmd(const char *name, const char *list)
 
 static void do_help_cmd(Monitor *mon, const QDict *qdict)
 {
-    help_cmd(mon, qdict_get_try_str(qdict, "name"));
+    hmp_help_cmd(mon, qdict_get_try_str(qdict, "name"));
 }
 
 static void hmp_trace_event(Monitor *mon, const QDict *qdict)
@@ -195,14 +195,14 @@ static void hmp_trace_file(Monitor *mon, const QDict *qdict)
         }
     } else {
         monitor_printf(mon, "unexpected argument \"%s\"\n", op);
-        help_cmd(mon, "trace-file");
+        hmp_help_cmd(mon, "trace-file");
     }
 }
 #endif
 
 static void hmp_info_help(Monitor *mon, const QDict *qdict)
 {
-    help_cmd(mon, "info");
+    hmp_help_cmd(mon, "info");
 }
 
 static void monitor_init_qmp_commands(void)
@@ -424,7 +424,7 @@ static void hmp_log(Monitor *mon, const QDict *qdict)
     } else {
         mask = qemu_str_to_log_mask(items);
         if (!mask) {
-            help_cmd(mon, "log");
+            hmp_help_cmd(mon, "log");
             return;
         }
     }
-- 
2.39.0

