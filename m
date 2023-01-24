Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCF76797C0
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbjAXMVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbjAXMVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:21:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C264588A
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBnxRdikimEViOMsZDCD4ZdXoeBVO5zZwlfSxnM5OEw=;
        b=AbAOY9NWNGRayTtaJjXsG4EFlsO6OBzJ6L73yXro+M0TKZ8AVdFapdRKQom/GpmASLj+ze
        P2tjMQdKMZpaqOn9SkUb8VuDW0mpWmOMZYDLdZqepR22IGDHbF3aKekEvImJ5qMSHjT+M3
        5Ke0bjnjC0O3IImXtoE1rL9b3179uLg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-AhyXXLwEO1SlhSbXiHKAXw-1; Tue, 24 Jan 2023 07:19:51 -0500
X-MC-Unique: AhyXXLwEO1SlhSbXiHKAXw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 199E080D0E3;
        Tue, 24 Jan 2023 12:19:51 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD36C14171B6;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id DF27821E6884; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 31/32] monitor: Loosen coupling between misc.c and monitor.c slightly
Date:   Tue, 24 Jan 2023 13:19:45 +0100
Message-Id: <20230124121946.1139465-32-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
 monitor/misc.c                       | 8 +-------
 monitor/monitor.c                    | 2 +-
 storage-daemon/qemu-storage-daemon.c | 4 ++--
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/monitor/misc.c b/monitor/misc.c
index 9ddf32da97..99317a8ff4 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -135,7 +135,7 @@ compare_mon_cmd(const void *a, const void *b)
             ((const HMPCommand *)b)->name);
 }
 
-static void sortcmdlist(void)
+static void __attribute__((__constructor__)) sortcmdlist(void)
 {
     qsort(hmp_cmds, ARRAY_SIZE(hmp_cmds) - 1,
           sizeof(*hmp_cmds),
@@ -176,9 +176,3 @@ void monitor_register_hmp_info_hrt(const char *name,
     }
     g_assert_not_reached();
 }
-
-void monitor_init_globals(void)
-{
-    monitor_init_globals_core();
-    sortcmdlist();
-}
diff --git a/monitor/monitor.c b/monitor/monitor.c
index 0a990633d8..ca233ab80f 100644
--- a/monitor/monitor.c
+++ b/monitor/monitor.c
@@ -719,7 +719,7 @@ static void monitor_qapi_event_init(void)
                                                 qapi_event_throttle_equal);
 }
 
-void monitor_init_globals_core(void)
+void monitor_init_globals(void)
 {
     monitor_qapi_event_init();
     qemu_mutex_init(&monitor_lock);
diff --git a/storage-daemon/qemu-storage-daemon.c b/storage-daemon/qemu-storage-daemon.c
index da19498c66..0e9354faa6 100644
--- a/storage-daemon/qemu-storage-daemon.c
+++ b/storage-daemon/qemu-storage-daemon.c
@@ -299,7 +299,7 @@ static void process_options(int argc, char *argv[], bool pre_init_pass)
         case OPTION_DAEMONIZE:
             if (os_set_daemonize(true) < 0) {
                 /*
-                 * --daemonize is parsed before monitor_init_globals_core(), so
+                 * --daemonize is parsed before monitor_init_globals(), so
                  * error_report() does not work yet
                  */
                 fprintf(stderr, "--daemonize not supported in this build\n");
@@ -411,7 +411,7 @@ int main(int argc, char *argv[])
     qemu_add_opts(&qemu_trace_opts);
     qcrypto_init(&error_fatal);
     bdrv_init();
-    monitor_init_globals_core();
+    monitor_init_globals();
     init_qmp_commands();
 
     if (!trace_init_backends()) {
-- 
2.39.0

