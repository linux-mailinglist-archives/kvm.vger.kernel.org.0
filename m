Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D779A6797B2
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbjAXMU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbjAXMU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9D14523E
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EV1KxnH5GJxcinAE0LYKuLXcBwv7nDFzud9c9z52TaA=;
        b=PgfmBFNyVS4Fc6iW/6Rrm1+kZBwh7Zax4M6jSw+cCLKxZAXC6nETfA7rIwonc4/sidbgLh
        1+s/BrrD6C94HTL2Q0zuqmWqIbEagJWoudLZzIY0/fiAXMuC9NzHSi/+N4WW76SMISKHVn
        g/Oh8AaPV558YsBy4Jn5YOkeAEh6xSU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-Xwsq9gE4NW6_mL3VvqrOpA-1; Tue, 24 Jan 2023 07:19:50 -0500
X-MC-Unique: Xwsq9gE4NW6_mL3VvqrOpA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D11971006E28;
        Tue, 24 Jan 2023 12:19:49 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E999C15BAD;
        Tue, 24 Jan 2023 12:19:49 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id A8C2A21E6914; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 13/32] rocker: Move HMP commands from monitor to hw/net/rocker/
Date:   Tue, 24 Jan 2023 13:19:27 +0100
Message-Id: <20230124121946.1139465-14-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This moves these commands from MAINTAINERS section "Human
Monitor (HMP)" to "Rocker" and "Network devices".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 hw/net/rocker/rocker-hmp-cmds.c | 316 ++++++++++++++++++++++++++++++++
 monitor/hmp-cmds.c              | 297 ------------------------------
 hw/net/meson.build              |   1 +
 3 files changed, 317 insertions(+), 297 deletions(-)
 create mode 100644 hw/net/rocker/rocker-hmp-cmds.c

diff --git a/hw/net/rocker/rocker-hmp-cmds.c b/hw/net/rocker/rocker-hmp-cmds.c
new file mode 100644
index 0000000000..197c6e28dc
--- /dev/null
+++ b/hw/net/rocker/rocker-hmp-cmds.c
@@ -0,0 +1,316 @@
+/*
+ * Human Monitor Interface commands
+ *
+ * Copyright IBM, Corp. 2011
+ *
+ * Authors:
+ *  Anthony Liguori   <aliguori@us.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ * Contributions after 2012-01-13 are licensed under the terms of the
+ * GNU GPL, version 2 or (at your option) any later version.
+ */
+
+#include "qemu/osdep.h"
+#include "monitor/hmp.h"
+#include "monitor/monitor.h"
+#include "net/eth.h"
+#include "qapi/qapi-commands-rocker.h"
+#include "qapi/qmp/qdict.h"
+
+void hmp_rocker(Monitor *mon, const QDict *qdict)
+{
+    const char *name = qdict_get_str(qdict, "name");
+    RockerSwitch *rocker;
+    Error *err = NULL;
+
+    rocker = qmp_query_rocker(name, &err);
+    if (hmp_handle_error(mon, err)) {
+        return;
+    }
+
+    monitor_printf(mon, "name: %s\n", rocker->name);
+    monitor_printf(mon, "id: 0x%" PRIx64 "\n", rocker->id);
+    monitor_printf(mon, "ports: %d\n", rocker->ports);
+
+    qapi_free_RockerSwitch(rocker);
+}
+
+void hmp_rocker_ports(Monitor *mon, const QDict *qdict)
+{
+    RockerPortList *list, *port;
+    const char *name = qdict_get_str(qdict, "name");
+    Error *err = NULL;
+
+    list = qmp_query_rocker_ports(name, &err);
+    if (hmp_handle_error(mon, err)) {
+        return;
+    }
+
+    monitor_printf(mon, "            ena/    speed/ auto\n");
+    monitor_printf(mon, "      port  link    duplex neg?\n");
+
+    for (port = list; port; port = port->next) {
+        monitor_printf(mon, "%10s  %-4s   %-3s  %2s  %s\n",
+                       port->value->name,
+                       port->value->enabled ? port->value->link_up ?
+                       "up" : "down" : "!ena",
+                       port->value->speed == 10000 ? "10G" : "??",
+                       port->value->duplex ? "FD" : "HD",
+                       port->value->autoneg ? "Yes" : "No");
+    }
+
+    qapi_free_RockerPortList(list);
+}
+
+void hmp_rocker_of_dpa_flows(Monitor *mon, const QDict *qdict)
+{
+    RockerOfDpaFlowList *list, *info;
+    const char *name = qdict_get_str(qdict, "name");
+    uint32_t tbl_id = qdict_get_try_int(qdict, "tbl_id", -1);
+    Error *err = NULL;
+
+    list = qmp_query_rocker_of_dpa_flows(name, tbl_id != -1, tbl_id, &err);
+    if (hmp_handle_error(mon, err)) {
+        return;
+    }
+
+    monitor_printf(mon, "prio tbl hits key(mask) --> actions\n");
+
+    for (info = list; info; info = info->next) {
+        RockerOfDpaFlow *flow = info->value;
+        RockerOfDpaFlowKey *key = flow->key;
+        RockerOfDpaFlowMask *mask = flow->mask;
+        RockerOfDpaFlowAction *action = flow->action;
+
+        if (flow->hits) {
+            monitor_printf(mon, "%-4d %-3d %-4" PRIu64,
+                           key->priority, key->tbl_id, flow->hits);
+        } else {
+            monitor_printf(mon, "%-4d %-3d     ",
+                           key->priority, key->tbl_id);
+        }
+
+        if (key->has_in_pport) {
+            monitor_printf(mon, " pport %d", key->in_pport);
+            if (mask->has_in_pport) {
+                monitor_printf(mon, "(0x%x)", mask->in_pport);
+            }
+        }
+
+        if (key->has_vlan_id) {
+            monitor_printf(mon, " vlan %d",
+                           key->vlan_id & VLAN_VID_MASK);
+            if (mask->has_vlan_id) {
+                monitor_printf(mon, "(0x%x)", mask->vlan_id);
+            }
+        }
+
+        if (key->has_tunnel_id) {
+            monitor_printf(mon, " tunnel %d", key->tunnel_id);
+            if (mask->has_tunnel_id) {
+                monitor_printf(mon, "(0x%x)", mask->tunnel_id);
+            }
+        }
+
+        if (key->has_eth_type) {
+            switch (key->eth_type) {
+            case 0x0806:
+                monitor_printf(mon, " ARP");
+                break;
+            case 0x0800:
+                monitor_printf(mon, " IP");
+                break;
+            case 0x86dd:
+                monitor_printf(mon, " IPv6");
+                break;
+            case 0x8809:
+                monitor_printf(mon, " LACP");
+                break;
+            case 0x88cc:
+                monitor_printf(mon, " LLDP");
+                break;
+            default:
+                monitor_printf(mon, " eth type 0x%04x", key->eth_type);
+                break;
+            }
+        }
+
+        if (key->eth_src) {
+            if ((strcmp(key->eth_src, "01:00:00:00:00:00") == 0) &&
+                mask->eth_src &&
+                (strcmp(mask->eth_src, "01:00:00:00:00:00") == 0)) {
+                monitor_printf(mon, " src <any mcast/bcast>");
+            } else if ((strcmp(key->eth_src, "00:00:00:00:00:00") == 0) &&
+                mask->eth_src &&
+                (strcmp(mask->eth_src, "01:00:00:00:00:00") == 0)) {
+                monitor_printf(mon, " src <any ucast>");
+            } else {
+                monitor_printf(mon, " src %s", key->eth_src);
+                if (mask->eth_src) {
+                    monitor_printf(mon, "(%s)", mask->eth_src);
+                }
+            }
+        }
+
+        if (key->eth_dst) {
+            if ((strcmp(key->eth_dst, "01:00:00:00:00:00") == 0) &&
+                mask->eth_dst &&
+                (strcmp(mask->eth_dst, "01:00:00:00:00:00") == 0)) {
+                monitor_printf(mon, " dst <any mcast/bcast>");
+            } else if ((strcmp(key->eth_dst, "00:00:00:00:00:00") == 0) &&
+                mask->eth_dst &&
+                (strcmp(mask->eth_dst, "01:00:00:00:00:00") == 0)) {
+                monitor_printf(mon, " dst <any ucast>");
+            } else {
+                monitor_printf(mon, " dst %s", key->eth_dst);
+                if (mask->eth_dst) {
+                    monitor_printf(mon, "(%s)", mask->eth_dst);
+                }
+            }
+        }
+
+        if (key->has_ip_proto) {
+            monitor_printf(mon, " proto %d", key->ip_proto);
+            if (mask->has_ip_proto) {
+                monitor_printf(mon, "(0x%x)", mask->ip_proto);
+            }
+        }
+
+        if (key->has_ip_tos) {
+            monitor_printf(mon, " TOS %d", key->ip_tos);
+            if (mask->has_ip_tos) {
+                monitor_printf(mon, "(0x%x)", mask->ip_tos);
+            }
+        }
+
+        if (key->ip_dst) {
+            monitor_printf(mon, " dst %s", key->ip_dst);
+        }
+
+        if (action->has_goto_tbl || action->has_group_id ||
+            action->has_new_vlan_id) {
+            monitor_printf(mon, " -->");
+        }
+
+        if (action->has_new_vlan_id) {
+            monitor_printf(mon, " apply new vlan %d",
+                           ntohs(action->new_vlan_id));
+        }
+
+        if (action->has_group_id) {
+            monitor_printf(mon, " write group 0x%08x", action->group_id);
+        }
+
+        if (action->has_goto_tbl) {
+            monitor_printf(mon, " goto tbl %d", action->goto_tbl);
+        }
+
+        monitor_printf(mon, "\n");
+    }
+
+    qapi_free_RockerOfDpaFlowList(list);
+}
+
+void hmp_rocker_of_dpa_groups(Monitor *mon, const QDict *qdict)
+{
+    RockerOfDpaGroupList *list, *g;
+    const char *name = qdict_get_str(qdict, "name");
+    uint8_t type = qdict_get_try_int(qdict, "type", 9);
+    Error *err = NULL;
+
+    list = qmp_query_rocker_of_dpa_groups(name, type != 9, type, &err);
+    if (hmp_handle_error(mon, err)) {
+        return;
+    }
+
+    monitor_printf(mon, "id (decode) --> buckets\n");
+
+    for (g = list; g; g = g->next) {
+        RockerOfDpaGroup *group = g->value;
+        bool set = false;
+
+        monitor_printf(mon, "0x%08x", group->id);
+
+        monitor_printf(mon, " (type %s", group->type == 0 ? "L2 interface" :
+                                         group->type == 1 ? "L2 rewrite" :
+                                         group->type == 2 ? "L3 unicast" :
+                                         group->type == 3 ? "L2 multicast" :
+                                         group->type == 4 ? "L2 flood" :
+                                         group->type == 5 ? "L3 interface" :
+                                         group->type == 6 ? "L3 multicast" :
+                                         group->type == 7 ? "L3 ECMP" :
+                                         group->type == 8 ? "L2 overlay" :
+                                         "unknown");
+
+        if (group->has_vlan_id) {
+            monitor_printf(mon, " vlan %d", group->vlan_id);
+        }
+
+        if (group->has_pport) {
+            monitor_printf(mon, " pport %d", group->pport);
+        }
+
+        if (group->has_index) {
+            monitor_printf(mon, " index %d", group->index);
+        }
+
+        monitor_printf(mon, ") -->");
+
+        if (group->has_set_vlan_id && group->set_vlan_id) {
+            set = true;
+            monitor_printf(mon, " set vlan %d",
+                           group->set_vlan_id & VLAN_VID_MASK);
+        }
+
+        if (group->set_eth_src) {
+            if (!set) {
+                set = true;
+                monitor_printf(mon, " set");
+            }
+            monitor_printf(mon, " src %s", group->set_eth_src);
+        }
+
+        if (group->set_eth_dst) {
+            if (!set) {
+                monitor_printf(mon, " set");
+            }
+            monitor_printf(mon, " dst %s", group->set_eth_dst);
+        }
+
+        if (group->has_ttl_check && group->ttl_check) {
+            monitor_printf(mon, " check TTL");
+        }
+
+        if (group->has_group_id && group->group_id) {
+            monitor_printf(mon, " group id 0x%08x", group->group_id);
+        }
+
+        if (group->has_pop_vlan && group->pop_vlan) {
+            monitor_printf(mon, " pop vlan");
+        }
+
+        if (group->has_out_pport) {
+            monitor_printf(mon, " out pport %d", group->out_pport);
+        }
+
+        if (group->has_group_ids) {
+            struct uint32List *id;
+
+            monitor_printf(mon, " groups [");
+            for (id = group->group_ids; id; id = id->next) {
+                monitor_printf(mon, "0x%08x", id->value);
+                if (id->next) {
+                    monitor_printf(mon, ",");
+                }
+            }
+            monitor_printf(mon, "]");
+        }
+
+        monitor_printf(mon, "\n");
+    }
+
+    qapi_free_RockerOfDpaGroupList(list);
+}
diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
index bed75af656..edb50da1ff 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -16,7 +16,6 @@
 #include "qemu/osdep.h"
 #include "monitor/hmp.h"
 #include "net/net.h"
-#include "net/eth.h"
 #include "sysemu/runstate.h"
 #include "qemu/sockets.h"
 #include "qemu/help_option.h"
@@ -28,7 +27,6 @@
 #include "qapi/qapi-commands-migration.h"
 #include "qapi/qapi-commands-misc.h"
 #include "qapi/qapi-commands-net.h"
-#include "qapi/qapi-commands-rocker.h"
 #include "qapi/qapi-commands-run-state.h"
 #include "qapi/qapi-commands-stats.h"
 #include "qapi/qapi-commands-tpm.h"
@@ -1076,301 +1074,6 @@ void hmp_info_iothreads(Monitor *mon, const QDict *qdict)
     qapi_free_IOThreadInfoList(info_list);
 }
 
-void hmp_rocker(Monitor *mon, const QDict *qdict)
-{
-    const char *name = qdict_get_str(qdict, "name");
-    RockerSwitch *rocker;
-    Error *err = NULL;
-
-    rocker = qmp_query_rocker(name, &err);
-    if (hmp_handle_error(mon, err)) {
-        return;
-    }
-
-    monitor_printf(mon, "name: %s\n", rocker->name);
-    monitor_printf(mon, "id: 0x%" PRIx64 "\n", rocker->id);
-    monitor_printf(mon, "ports: %d\n", rocker->ports);
-
-    qapi_free_RockerSwitch(rocker);
-}
-
-void hmp_rocker_ports(Monitor *mon, const QDict *qdict)
-{
-    RockerPortList *list, *port;
-    const char *name = qdict_get_str(qdict, "name");
-    Error *err = NULL;
-
-    list = qmp_query_rocker_ports(name, &err);
-    if (hmp_handle_error(mon, err)) {
-        return;
-    }
-
-    monitor_printf(mon, "            ena/    speed/ auto\n");
-    monitor_printf(mon, "      port  link    duplex neg?\n");
-
-    for (port = list; port; port = port->next) {
-        monitor_printf(mon, "%10s  %-4s   %-3s  %2s  %s\n",
-                       port->value->name,
-                       port->value->enabled ? port->value->link_up ?
-                       "up" : "down" : "!ena",
-                       port->value->speed == 10000 ? "10G" : "??",
-                       port->value->duplex ? "FD" : "HD",
-                       port->value->autoneg ? "Yes" : "No");
-    }
-
-    qapi_free_RockerPortList(list);
-}
-
-void hmp_rocker_of_dpa_flows(Monitor *mon, const QDict *qdict)
-{
-    RockerOfDpaFlowList *list, *info;
-    const char *name = qdict_get_str(qdict, "name");
-    uint32_t tbl_id = qdict_get_try_int(qdict, "tbl_id", -1);
-    Error *err = NULL;
-
-    list = qmp_query_rocker_of_dpa_flows(name, tbl_id != -1, tbl_id, &err);
-    if (hmp_handle_error(mon, err)) {
-        return;
-    }
-
-    monitor_printf(mon, "prio tbl hits key(mask) --> actions\n");
-
-    for (info = list; info; info = info->next) {
-        RockerOfDpaFlow *flow = info->value;
-        RockerOfDpaFlowKey *key = flow->key;
-        RockerOfDpaFlowMask *mask = flow->mask;
-        RockerOfDpaFlowAction *action = flow->action;
-
-        if (flow->hits) {
-            monitor_printf(mon, "%-4d %-3d %-4" PRIu64,
-                           key->priority, key->tbl_id, flow->hits);
-        } else {
-            monitor_printf(mon, "%-4d %-3d     ",
-                           key->priority, key->tbl_id);
-        }
-
-        if (key->has_in_pport) {
-            monitor_printf(mon, " pport %d", key->in_pport);
-            if (mask->has_in_pport) {
-                monitor_printf(mon, "(0x%x)", mask->in_pport);
-            }
-        }
-
-        if (key->has_vlan_id) {
-            monitor_printf(mon, " vlan %d",
-                           key->vlan_id & VLAN_VID_MASK);
-            if (mask->has_vlan_id) {
-                monitor_printf(mon, "(0x%x)", mask->vlan_id);
-            }
-        }
-
-        if (key->has_tunnel_id) {
-            monitor_printf(mon, " tunnel %d", key->tunnel_id);
-            if (mask->has_tunnel_id) {
-                monitor_printf(mon, "(0x%x)", mask->tunnel_id);
-            }
-        }
-
-        if (key->has_eth_type) {
-            switch (key->eth_type) {
-            case 0x0806:
-                monitor_printf(mon, " ARP");
-                break;
-            case 0x0800:
-                monitor_printf(mon, " IP");
-                break;
-            case 0x86dd:
-                monitor_printf(mon, " IPv6");
-                break;
-            case 0x8809:
-                monitor_printf(mon, " LACP");
-                break;
-            case 0x88cc:
-                monitor_printf(mon, " LLDP");
-                break;
-            default:
-                monitor_printf(mon, " eth type 0x%04x", key->eth_type);
-                break;
-            }
-        }
-
-        if (key->eth_src) {
-            if ((strcmp(key->eth_src, "01:00:00:00:00:00") == 0) &&
-                mask->eth_src &&
-                (strcmp(mask->eth_src, "01:00:00:00:00:00") == 0)) {
-                monitor_printf(mon, " src <any mcast/bcast>");
-            } else if ((strcmp(key->eth_src, "00:00:00:00:00:00") == 0) &&
-                mask->eth_src &&
-                (strcmp(mask->eth_src, "01:00:00:00:00:00") == 0)) {
-                monitor_printf(mon, " src <any ucast>");
-            } else {
-                monitor_printf(mon, " src %s", key->eth_src);
-                if (mask->eth_src) {
-                    monitor_printf(mon, "(%s)", mask->eth_src);
-                }
-            }
-        }
-
-        if (key->eth_dst) {
-            if ((strcmp(key->eth_dst, "01:00:00:00:00:00") == 0) &&
-                mask->eth_dst &&
-                (strcmp(mask->eth_dst, "01:00:00:00:00:00") == 0)) {
-                monitor_printf(mon, " dst <any mcast/bcast>");
-            } else if ((strcmp(key->eth_dst, "00:00:00:00:00:00") == 0) &&
-                mask->eth_dst &&
-                (strcmp(mask->eth_dst, "01:00:00:00:00:00") == 0)) {
-                monitor_printf(mon, " dst <any ucast>");
-            } else {
-                monitor_printf(mon, " dst %s", key->eth_dst);
-                if (mask->eth_dst) {
-                    monitor_printf(mon, "(%s)", mask->eth_dst);
-                }
-            }
-        }
-
-        if (key->has_ip_proto) {
-            monitor_printf(mon, " proto %d", key->ip_proto);
-            if (mask->has_ip_proto) {
-                monitor_printf(mon, "(0x%x)", mask->ip_proto);
-            }
-        }
-
-        if (key->has_ip_tos) {
-            monitor_printf(mon, " TOS %d", key->ip_tos);
-            if (mask->has_ip_tos) {
-                monitor_printf(mon, "(0x%x)", mask->ip_tos);
-            }
-        }
-
-        if (key->ip_dst) {
-            monitor_printf(mon, " dst %s", key->ip_dst);
-        }
-
-        if (action->has_goto_tbl || action->has_group_id ||
-            action->has_new_vlan_id) {
-            monitor_printf(mon, " -->");
-        }
-
-        if (action->has_new_vlan_id) {
-            monitor_printf(mon, " apply new vlan %d",
-                           ntohs(action->new_vlan_id));
-        }
-
-        if (action->has_group_id) {
-            monitor_printf(mon, " write group 0x%08x", action->group_id);
-        }
-
-        if (action->has_goto_tbl) {
-            monitor_printf(mon, " goto tbl %d", action->goto_tbl);
-        }
-
-        monitor_printf(mon, "\n");
-    }
-
-    qapi_free_RockerOfDpaFlowList(list);
-}
-
-void hmp_rocker_of_dpa_groups(Monitor *mon, const QDict *qdict)
-{
-    RockerOfDpaGroupList *list, *g;
-    const char *name = qdict_get_str(qdict, "name");
-    uint8_t type = qdict_get_try_int(qdict, "type", 9);
-    Error *err = NULL;
-
-    list = qmp_query_rocker_of_dpa_groups(name, type != 9, type, &err);
-    if (hmp_handle_error(mon, err)) {
-        return;
-    }
-
-    monitor_printf(mon, "id (decode) --> buckets\n");
-
-    for (g = list; g; g = g->next) {
-        RockerOfDpaGroup *group = g->value;
-        bool set = false;
-
-        monitor_printf(mon, "0x%08x", group->id);
-
-        monitor_printf(mon, " (type %s", group->type == 0 ? "L2 interface" :
-                                         group->type == 1 ? "L2 rewrite" :
-                                         group->type == 2 ? "L3 unicast" :
-                                         group->type == 3 ? "L2 multicast" :
-                                         group->type == 4 ? "L2 flood" :
-                                         group->type == 5 ? "L3 interface" :
-                                         group->type == 6 ? "L3 multicast" :
-                                         group->type == 7 ? "L3 ECMP" :
-                                         group->type == 8 ? "L2 overlay" :
-                                         "unknown");
-
-        if (group->has_vlan_id) {
-            monitor_printf(mon, " vlan %d", group->vlan_id);
-        }
-
-        if (group->has_pport) {
-            monitor_printf(mon, " pport %d", group->pport);
-        }
-
-        if (group->has_index) {
-            monitor_printf(mon, " index %d", group->index);
-        }
-
-        monitor_printf(mon, ") -->");
-
-        if (group->has_set_vlan_id && group->set_vlan_id) {
-            set = true;
-            monitor_printf(mon, " set vlan %d",
-                           group->set_vlan_id & VLAN_VID_MASK);
-        }
-
-        if (group->set_eth_src) {
-            if (!set) {
-                set = true;
-                monitor_printf(mon, " set");
-            }
-            monitor_printf(mon, " src %s", group->set_eth_src);
-        }
-
-        if (group->set_eth_dst) {
-            if (!set) {
-                monitor_printf(mon, " set");
-            }
-            monitor_printf(mon, " dst %s", group->set_eth_dst);
-        }
-
-        if (group->has_ttl_check && group->ttl_check) {
-            monitor_printf(mon, " check TTL");
-        }
-
-        if (group->has_group_id && group->group_id) {
-            monitor_printf(mon, " group id 0x%08x", group->group_id);
-        }
-
-        if (group->has_pop_vlan && group->pop_vlan) {
-            monitor_printf(mon, " pop vlan");
-        }
-
-        if (group->has_out_pport) {
-            monitor_printf(mon, " out pport %d", group->out_pport);
-        }
-
-        if (group->has_group_ids) {
-            struct uint32List *id;
-
-            monitor_printf(mon, " groups [");
-            for (id = group->group_ids; id; id = id->next) {
-                monitor_printf(mon, "0x%08x", id->value);
-                if (id->next) {
-                    monitor_printf(mon, ",");
-                }
-            }
-            monitor_printf(mon, "]");
-        }
-
-        monitor_printf(mon, "\n");
-    }
-
-    qapi_free_RockerOfDpaGroupList(list);
-}
-
 static void print_stats_schema_value(Monitor *mon, StatsSchemaValue *value)
 {
     const char *unit = NULL;
diff --git a/hw/net/meson.build b/hw/net/meson.build
index ebac261542..4285145715 100644
--- a/hw/net/meson.build
+++ b/hw/net/meson.build
@@ -68,5 +68,6 @@ softmmu_ss.add(when: 'CONFIG_ROCKER', if_true: files(
   'rocker/rocker_world.c',
 ), if_false: files('rocker/qmp-norocker.c'))
 softmmu_ss.add(when: 'CONFIG_ALL', if_true: files('rocker/qmp-norocker.c'))
+softmmu_ss.add(files('rocker/rocker-hmp-cmds.c'))
 
 subdir('can')
-- 
2.39.0

