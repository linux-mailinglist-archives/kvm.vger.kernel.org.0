Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80CBA6797C7
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbjAXMVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233827AbjAXMVI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:21:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A8C45201
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hzhkCtiGE/Nt/5UhkRP2EOhS734lSSVlGakAMxcfwlA=;
        b=fuPTCGV1FKe6bRKHMtikOXDn4WvVtnhpqGQzwBzAaco2vEkHp3UzEkIB25E4hdPRL+8+Lx
        NIh2ydSxnz/Zbr3//EAMEDco9q62Rvc77FqMQAyrvFFTJUCS0If7nDfUjyo1DTs23oGoM2
        itW4ZtnPIHw8OiHneBcubWG7B5LW6nw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-5qmKE6X0Ovu-q1UFc15yWQ-1; Tue, 24 Jan 2023 07:19:49 -0500
X-MC-Unique: 5qmKE6X0Ovu-q1UFc15yWQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 307D718A6462;
        Tue, 24 Jan 2023 12:19:48 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D9BF53A0;
        Tue, 24 Jan 2023 12:19:47 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 8C41B21E6A23; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 04/32] char: Factor out qmp_add_client() parts and move to chardev/
Date:   Tue, 24 Jan 2023 13:19:18 +0100
Message-Id: <20230124121946.1139465-5-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Code moves from MAINTAINERS section "QMP" to "Character device
backends".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 include/monitor/qmp-helpers.h |  3 +++
 chardev/char.c                | 20 ++++++++++++++++++++
 monitor/qmp-cmds.c            | 13 ++-----------
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/monitor/qmp-helpers.h b/include/monitor/qmp-helpers.h
index 4718c63c73..318c3357a2 100644
--- a/include/monitor/qmp-helpers.h
+++ b/include/monitor/qmp-helpers.h
@@ -22,5 +22,8 @@ bool qmp_add_client_vnc(int fd, bool has_skipauth, bool skipauth,
 bool qmp_add_client_dbus_display(int fd, bool has_skipauth, bool skipauth,
                         bool has_tls, bool tls, Error **errp);
 #endif
+bool qmp_add_client_char(int fd, bool has_skipauth, bool skipauth,
+                         bool has_tls, bool tls, const char *protocol,
+                         Error **errp);
 
 #endif
diff --git a/chardev/char.c b/chardev/char.c
index 87ab6efbcc..11eab7764c 100644
--- a/chardev/char.c
+++ b/chardev/char.c
@@ -25,6 +25,7 @@
 #include "qemu/osdep.h"
 #include "qemu/cutils.h"
 #include "monitor/monitor.h"
+#include "monitor/qmp-helpers.h"
 #include "qemu/config-file.h"
 #include "qemu/error-report.h"
 #include "qemu/qemu-print.h"
@@ -1166,6 +1167,25 @@ void qmp_chardev_send_break(const char *id, Error **errp)
     qemu_chr_be_event(chr, CHR_EVENT_BREAK);
 }
 
+bool qmp_add_client_char(int fd, bool has_skipauth, bool skipauth,
+                         bool has_tls, bool tls, const char *protocol,
+                         Error **errp)
+{
+    Chardev *s = qemu_chr_find(protocol);
+
+    if (!s) {
+        error_setg(errp, "protocol '%s' is invalid", protocol);
+        close(fd);
+        return false;
+    }
+    if (qemu_chr_add_client(s, fd) < 0) {
+        error_setg(errp, "failed to add client");
+        close(fd);
+        return false;
+    }
+    return true;
+}
+
 /*
  * Add a timeout callback for the chardev (in milliseconds), return
  * the GSource object created. Please use this to add timeout hook for
diff --git a/monitor/qmp-cmds.c b/monitor/qmp-cmds.c
index 743849c0b5..e5ab77f6c6 100644
--- a/monitor/qmp-cmds.c
+++ b/monitor/qmp-cmds.c
@@ -17,7 +17,6 @@
 #include "monitor/monitor.h"
 #include "monitor/qmp-helpers.h"
 #include "sysemu/sysemu.h"
-#include "chardev/char.h"
 #include "sysemu/kvm.h"
 #include "sysemu/runstate.h"
 #include "sysemu/runstate-action.h"
@@ -174,7 +173,6 @@ void qmp_add_client(const char *protocol, const char *fdname,
         { "@dbus-display", qmp_add_client_dbus_display },
 #endif
     };
-    Chardev *s;
     int fd, i;
 
     fd = monitor_get_fd(monitor_cur(), fdname, errp);
@@ -192,16 +190,9 @@ void qmp_add_client(const char *protocol, const char *fdname,
         }
     }
 
-    s = qemu_chr_find(protocol);
-    if (!s) {
-        error_setg(errp, "protocol '%s' is invalid", protocol);
+    if (!qmp_add_client_char(fd, has_skipauth, skipauth, has_tls, tls,
+                             protocol, errp)) {
         close(fd);
-        return;
-    }
-    if (qemu_chr_add_client(s, fd) < 0) {
-        error_setg(errp, "failed to add client");
-        close(fd);
-        return;
     }
 }
 
-- 
2.39.0

