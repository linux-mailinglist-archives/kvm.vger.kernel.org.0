Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF9B6797C3
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbjAXMVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbjAXMVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:21:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9134E45885
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aA3UG40IuCC83MPuaNaIfGgaRo/pnOr3gMdu0sFseUw=;
        b=D1hMVeh4LxY4UxC34HopI4FR3nHzgSWBns8aJzAx5thfzLEOPzX5b6yQGXUvgkcJaayPjL
        yPxF888mmyC8FKsCpwjMtzwopSjYCAQUm4vXQY7Q0fcL/ZtXRj4GaMZpiLHK9YxVaeKVsz
        VFpZwW/IE74hGWTKExqi1hIxE/K8kIM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-cnDkY-VhNdWrGaRUyHDb3A-1; Tue, 24 Jan 2023 07:19:51 -0500
X-MC-Unique: cnDkY-VhNdWrGaRUyHDb3A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 178038533EF;
        Tue, 24 Jan 2023 12:19:51 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ACE642166B29;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id CC41321E692B; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 25/32] qdev: Move HMP command completion from monitor to softmmu/
Date:   Tue, 24 Jan 2023 13:19:39 +0100
Message-Id: <20230124121946.1139465-26-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This moves the completion code from MAINTAINERS sections "Human
Monitor (HMP)" and "QMP" to section "QOM".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 monitor/misc.c         | 82 ------------------------------------------
 softmmu/qdev-monitor.c | 82 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 82 deletions(-)

diff --git a/monitor/misc.c b/monitor/misc.c
index a2584df0ca..c76d583b4f 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -1206,88 +1206,6 @@ int get_monitor_def(Monitor *mon, int64_t *pval, const char *name)
     return ret;
 }
 
-void device_add_completion(ReadLineState *rs, int nb_args, const char *str)
-{
-    GSList *list, *elt;
-    size_t len;
-
-    if (nb_args != 2) {
-        return;
-    }
-
-    len = strlen(str);
-    readline_set_completion_index(rs, len);
-    list = elt = object_class_get_list(TYPE_DEVICE, false);
-    while (elt) {
-        DeviceClass *dc = OBJECT_CLASS_CHECK(DeviceClass, elt->data,
-                                             TYPE_DEVICE);
-
-        if (dc->user_creatable) {
-            readline_add_completion_of(rs, str,
-                                object_class_get_name(OBJECT_CLASS(dc)));
-        }
-        elt = elt->next;
-    }
-    g_slist_free(list);
-}
-
-static int qdev_add_hotpluggable_device(Object *obj, void *opaque)
-{
-    GSList **list = opaque;
-    DeviceState *dev = (DeviceState *)object_dynamic_cast(obj, TYPE_DEVICE);
-
-    if (dev == NULL) {
-        return 0;
-    }
-
-    if (dev->realized && object_property_get_bool(obj, "hotpluggable", NULL)) {
-        *list = g_slist_append(*list, dev);
-    }
-
-    return 0;
-}
-
-static GSList *qdev_build_hotpluggable_device_list(Object *peripheral)
-{
-    GSList *list = NULL;
-
-    object_child_foreach(peripheral, qdev_add_hotpluggable_device, &list);
-
-    return list;
-}
-
-static void peripheral_device_del_completion(ReadLineState *rs,
-                                             const char *str)
-{
-    Object *peripheral = container_get(qdev_get_machine(), "/peripheral");
-    GSList *list, *item;
-
-    list = qdev_build_hotpluggable_device_list(peripheral);
-    if (!list) {
-        return;
-    }
-
-    for (item = list; item; item = g_slist_next(item)) {
-        DeviceState *dev = item->data;
-
-        if (dev->id) {
-            readline_add_completion_of(rs, str, dev->id);
-        }
-    }
-
-    g_slist_free(list);
-}
-
-void device_del_completion(ReadLineState *rs, int nb_args, const char *str)
-{
-    if (nb_args != 2) {
-        return;
-    }
-
-    readline_set_completion_index(rs, strlen(str));
-    peripheral_device_del_completion(rs, str);
-}
-
 static int
 compare_mon_cmd(const void *a, const void *b)
 {
diff --git a/softmmu/qdev-monitor.c b/softmmu/qdev-monitor.c
index 4b0ef65780..b8d2c4dadd 100644
--- a/softmmu/qdev-monitor.c
+++ b/softmmu/qdev-monitor.c
@@ -973,6 +973,88 @@ void hmp_device_del(Monitor *mon, const QDict *qdict)
     hmp_handle_error(mon, err);
 }
 
+void device_add_completion(ReadLineState *rs, int nb_args, const char *str)
+{
+    GSList *list, *elt;
+    size_t len;
+
+    if (nb_args != 2) {
+        return;
+    }
+
+    len = strlen(str);
+    readline_set_completion_index(rs, len);
+    list = elt = object_class_get_list(TYPE_DEVICE, false);
+    while (elt) {
+        DeviceClass *dc = OBJECT_CLASS_CHECK(DeviceClass, elt->data,
+                                             TYPE_DEVICE);
+
+        if (dc->user_creatable) {
+            readline_add_completion_of(rs, str,
+                                object_class_get_name(OBJECT_CLASS(dc)));
+        }
+        elt = elt->next;
+    }
+    g_slist_free(list);
+}
+
+static int qdev_add_hotpluggable_device(Object *obj, void *opaque)
+{
+    GSList **list = opaque;
+    DeviceState *dev = (DeviceState *)object_dynamic_cast(obj, TYPE_DEVICE);
+
+    if (dev == NULL) {
+        return 0;
+    }
+
+    if (dev->realized && object_property_get_bool(obj, "hotpluggable", NULL)) {
+        *list = g_slist_append(*list, dev);
+    }
+
+    return 0;
+}
+
+static GSList *qdev_build_hotpluggable_device_list(Object *peripheral)
+{
+    GSList *list = NULL;
+
+    object_child_foreach(peripheral, qdev_add_hotpluggable_device, &list);
+
+    return list;
+}
+
+static void peripheral_device_del_completion(ReadLineState *rs,
+                                             const char *str)
+{
+    Object *peripheral = container_get(qdev_get_machine(), "/peripheral");
+    GSList *list, *item;
+
+    list = qdev_build_hotpluggable_device_list(peripheral);
+    if (!list) {
+        return;
+    }
+
+    for (item = list; item; item = g_slist_next(item)) {
+        DeviceState *dev = item->data;
+
+        if (dev->id) {
+            readline_add_completion_of(rs, str, dev->id);
+        }
+    }
+
+    g_slist_free(list);
+}
+
+void device_del_completion(ReadLineState *rs, int nb_args, const char *str)
+{
+    if (nb_args != 2) {
+        return;
+    }
+
+    readline_set_completion_index(rs, strlen(str));
+    peripheral_device_del_completion(rs, str);
+}
+
 BlockBackend *blk_by_qdev_id(const char *id, Error **errp)
 {
     DeviceState *dev;
-- 
2.39.0

