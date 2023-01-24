Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F08A6797B9
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbjAXMVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbjAXMU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B69457D1
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fuw2IqjvQJhgQ7y8l9uv2HOctTbLu8XeG6lMuEPE7vQ=;
        b=IGq0cNS10BlPfRX5FRFKerpx8iExS1qSF7E7FnC2glwPon8y8jb6QMSLedMger8tpy2fjd
        y1FTU67DVqfcFsjh4YSgrPGPhb/NsFdgtOVexvS+C6tA8stcs8GsLX/H3LvtNhhrrE+0NI
        W4rgDwNB18DYgT7CPP9piwLNhFH39/M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-s22F3_A-NQu9LV-YEuVOtA-1; Tue, 24 Jan 2023 07:19:51 -0500
X-MC-Unique: s22F3_A-NQu9LV-YEuVOtA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC27A29DD990;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ACD7B2026D2B;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id C948B21E692A; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 24/32] acpi: Move the QMP command from monitor/ to hw/acpi/
Date:   Tue, 24 Jan 2023 13:19:38 +0100
Message-Id: <20230124121946.1139465-25-armbru@redhat.com>
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

This moves the command from MAINTAINERS section "QMP" to section
"ACPI/SMBIOS)".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 hw/acpi/acpi-qmp-cmds.c | 30 ++++++++++++++++++++++++++++++
 monitor/qmp-cmds.c      | 21 ---------------------
 hw/acpi/meson.build     |  1 +
 3 files changed, 31 insertions(+), 21 deletions(-)
 create mode 100644 hw/acpi/acpi-qmp-cmds.c

diff --git a/hw/acpi/acpi-qmp-cmds.c b/hw/acpi/acpi-qmp-cmds.c
new file mode 100644
index 0000000000..2d47cac52c
--- /dev/null
+++ b/hw/acpi/acpi-qmp-cmds.c
@@ -0,0 +1,30 @@
+/*
+ * QMP commands related to ACPI
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * (at your option) any later version.
+ */
+
+#include "qemu/osdep.h"
+#include "hw/acpi/acpi_dev_interface.h"
+#include "qapi/error.h"
+#include "qapi/qapi-commands-acpi.h"
+
+ACPIOSTInfoList *qmp_query_acpi_ospm_status(Error **errp)
+{
+    bool ambig;
+    ACPIOSTInfoList *head = NULL;
+    ACPIOSTInfoList **prev = &head;
+    Object *obj = object_resolve_path_type("", TYPE_ACPI_DEVICE_IF, &ambig);
+
+    if (obj) {
+        AcpiDeviceIfClass *adevc = ACPI_DEVICE_IF_GET_CLASS(obj);
+        AcpiDeviceIf *adev = ACPI_DEVICE_IF(obj);
+
+        adevc->ospm_status(adev, &prev);
+    } else {
+        error_setg(errp, "command is not supported, missing ACPI device");
+    }
+
+    return head;
+}
diff --git a/monitor/qmp-cmds.c b/monitor/qmp-cmds.c
index ab23e52f97..cc22f3fcc7 100644
--- a/monitor/qmp-cmds.c
+++ b/monitor/qmp-cmds.c
@@ -22,12 +22,10 @@
 #include "sysemu/runstate-action.h"
 #include "sysemu/block-backend.h"
 #include "qapi/error.h"
-#include "qapi/qapi-commands-acpi.h"
 #include "qapi/qapi-commands-control.h"
 #include "qapi/qapi-commands-misc.h"
 #include "qapi/type-helpers.h"
 #include "hw/mem/memory-device.h"
-#include "hw/acpi/acpi_dev_interface.h"
 #include "hw/intc/intc.h"
 #include "hw/rdma/rdma.h"
 
@@ -153,22 +151,3 @@ void qmp_add_client(const char *protocol, const char *fdname,
         close(fd);
     }
 }
-
-ACPIOSTInfoList *qmp_query_acpi_ospm_status(Error **errp)
-{
-    bool ambig;
-    ACPIOSTInfoList *head = NULL;
-    ACPIOSTInfoList **prev = &head;
-    Object *obj = object_resolve_path_type("", TYPE_ACPI_DEVICE_IF, &ambig);
-
-    if (obj) {
-        AcpiDeviceIfClass *adevc = ACPI_DEVICE_IF_GET_CLASS(obj);
-        AcpiDeviceIf *adev = ACPI_DEVICE_IF(obj);
-
-        adevc->ospm_status(adev, &prev);
-    } else {
-        error_setg(errp, "command is not supported, missing ACPI device");
-    }
-
-    return head;
-}
diff --git a/hw/acpi/meson.build b/hw/acpi/meson.build
index 30054a8cdc..7818846d88 100644
--- a/hw/acpi/meson.build
+++ b/hw/acpi/meson.build
@@ -36,3 +36,4 @@ softmmu_ss.add(when: 'CONFIG_ALL', if_true: files('acpi-stub.c', 'aml-build-stub
                                                   'acpi-mem-hotplug-stub.c', 'acpi-cpu-hotplug-stub.c',
                                                   'acpi-pci-hotplug-stub.c', 'acpi-nvdimm-stub.c',
                                                   'cxl-stub.c'))
+softmmu_ss.add(files('acpi-qmp-cmds.c'))
-- 
2.39.0

