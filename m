Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6574A6797C2
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbjAXMVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbjAXMVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:21:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD1B44BDE
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lxkUjVMzzCrxK9LQ+NlO+/+7Ms3fkaP4HnAmZct7f1s=;
        b=KRSidK4VUqhbs1eWeREL4E+/F/1WPcMzE9XQiNphuxmw+7ZRbYI3bojVboOLczWag5iptw
        D871Fm42Rq5RAATx/Jip+BXhqjcDyh5gE0SJk5A4zoOGc6b4ykSsRC9vKGsABFy9FSvpH0
        d+afDkyph54cqr4k1DEKAKnscfrTVlI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-oBD4Hi5kPjGBhbme7EoTnQ-1; Tue, 24 Jan 2023 07:19:51 -0500
X-MC-Unique: oBD4Hi5kPjGBhbme7EoTnQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E34EC1024D07;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 84BBA2026D4B;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id B10E121E691A; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 16/32] net: Move hmp_info_network() to net-hmp-cmds.c
Date:   Tue, 24 Jan 2023 13:19:30 +0100
Message-Id: <20230124121946.1139465-17-armbru@redhat.com>
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

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 include/monitor/hmp.h |  1 +
 include/net/net.h     |  4 +++-
 monitor/hmp-cmds.c    |  1 -
 monitor/misc.c        |  1 -
 net/net-hmp-cmds.c    | 28 ++++++++++++++++++++++++++++
 net/net.c             | 28 +---------------------------
 6 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
index d60d1305b8..a248ee9ed1 100644
--- a/include/monitor/hmp.h
+++ b/include/monitor/hmp.h
@@ -56,6 +56,7 @@ void hmp_ringbuf_read(Monitor *mon, const QDict *qdict);
 void hmp_cont(Monitor *mon, const QDict *qdict);
 void hmp_system_wakeup(Monitor *mon, const QDict *qdict);
 void hmp_nmi(Monitor *mon, const QDict *qdict);
+void hmp_info_network(Monitor *mon, const QDict *qdict);
 void hmp_set_link(Monitor *mon, const QDict *qdict);
 void hmp_balloon(Monitor *mon, const QDict *qdict);
 void hmp_loadvm(Monitor *mon, const QDict *qdict);
diff --git a/include/net/net.h b/include/net/net.h
index dc20b31e9f..fad589cc1d 100644
--- a/include/net/net.h
+++ b/include/net/net.h
@@ -115,6 +115,8 @@ struct NetClientState {
     QTAILQ_HEAD(, NetFilterState) filters;
 };
 
+typedef QTAILQ_HEAD(NetClientStateList, NetClientState) NetClientStateList;
+
 typedef struct NICState {
     NetClientState *ncs;
     NICConf *conf;
@@ -196,7 +198,6 @@ int qemu_find_nic_model(NICInfo *nd, const char * const *models,
                         const char *default_model);
 
 void print_net_client(Monitor *mon, NetClientState *nc);
-void hmp_info_network(Monitor *mon, const QDict *qdict);
 void net_socket_rs_init(SocketReadState *rs,
                         SocketReadStateFinalize *finalize,
                         bool vnet_hdr);
@@ -222,6 +223,7 @@ extern NICInfo nd_table[MAX_NICS];
 extern const char *host_net_devices[];
 
 /* from net.c */
+extern NetClientStateList net_clients;
 bool netdev_is_modern(const char *optarg);
 void netdev_parse_modern(const char *optarg);
 void net_client_parse(QemuOptsList *opts_list, const char *str);
diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
index 90259d02d7..b059af7abd 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -15,7 +15,6 @@
 
 #include "qemu/osdep.h"
 #include "monitor/hmp.h"
-#include "net/net.h"
 #include "sysemu/runstate.h"
 #include "qemu/sockets.h"
 #include "qemu/help_option.h"
diff --git a/monitor/misc.c b/monitor/misc.c
index bf3d863227..77a76b2b5f 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -26,7 +26,6 @@
 #include "monitor-internal.h"
 #include "monitor/qdev.h"
 #include "exec/gdbstub.h"
-#include "net/net.h"
 #include "net/slirp.h"
 #include "ui/qemu-spice.h"
 #include "qemu/ctype.h"
diff --git a/net/net-hmp-cmds.c b/net/net-hmp-cmds.c
index d7427ea4f8..41d326bf5f 100644
--- a/net/net-hmp-cmds.c
+++ b/net/net-hmp-cmds.c
@@ -16,7 +16,9 @@
 #include "qemu/osdep.h"
 #include "migration/misc.h"
 #include "monitor/hmp.h"
+#include "monitor/monitor.h"
 #include "net/net.h"
+#include "net/hub.h"
 #include "qapi/clone-visitor.h"
 #include "qapi/qapi-commands-net.h"
 #include "qapi/qapi-visit-net.h"
@@ -25,6 +27,32 @@
 #include "qemu/help_option.h"
 #include "qemu/option.h"
 
+void hmp_info_network(Monitor *mon, const QDict *qdict)
+{
+    NetClientState *nc, *peer;
+    NetClientDriver type;
+
+    net_hub_info(mon);
+
+    QTAILQ_FOREACH(nc, &net_clients, next) {
+        peer = nc->peer;
+        type = nc->info->type;
+
+        /* Skip if already printed in hub info */
+        if (net_hub_id_for_client(nc, NULL) == 0) {
+            continue;
+        }
+
+        if (!peer || type == NET_CLIENT_DRIVER_NIC) {
+            print_net_client(mon, nc);
+        } /* else it's a netdev connected to a NIC, printed with the NIC */
+        if (peer && type == NET_CLIENT_DRIVER_NIC) {
+            monitor_printf(mon, " \\ ");
+            print_net_client(mon, peer);
+        }
+    }
+}
+
 void hmp_set_link(Monitor *mon, const QDict *qdict)
 {
     const char *name = qdict_get_str(qdict, "name");
diff --git a/net/net.c b/net/net.c
index 2d01472998..251fc5ab55 100644
--- a/net/net.c
+++ b/net/net.c
@@ -63,7 +63,7 @@
 #endif
 
 static VMChangeStateEntry *net_change_state_entry;
-static QTAILQ_HEAD(, NetClientState) net_clients;
+NetClientStateList net_clients;
 
 typedef struct NetdevQueueEntry {
     Netdev *nd;
@@ -1345,32 +1345,6 @@ RxFilterInfoList *qmp_query_rx_filter(const char *name, Error **errp)
     return filter_list;
 }
 
-void hmp_info_network(Monitor *mon, const QDict *qdict)
-{
-    NetClientState *nc, *peer;
-    NetClientDriver type;
-
-    net_hub_info(mon);
-
-    QTAILQ_FOREACH(nc, &net_clients, next) {
-        peer = nc->peer;
-        type = nc->info->type;
-
-        /* Skip if already printed in hub info */
-        if (net_hub_id_for_client(nc, NULL) == 0) {
-            continue;
-        }
-
-        if (!peer || type == NET_CLIENT_DRIVER_NIC) {
-            print_net_client(mon, nc);
-        } /* else it's a netdev connected to a NIC, printed with the NIC */
-        if (peer && type == NET_CLIENT_DRIVER_NIC) {
-            monitor_printf(mon, " \\ ");
-            print_net_client(mon, peer);
-        }
-    }
-}
-
 void colo_notify_filters_event(int event, Error **errp)
 {
     NetClientState *nc;
-- 
2.39.0

