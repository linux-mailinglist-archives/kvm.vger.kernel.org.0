Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639934257B1
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242723AbhJGQVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:21:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242743AbhJGQUy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:20:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eCfS+Asf+f1waC4AVoz1E9eLdrSZudUp689oYCk0mwY=;
        b=P4pS910ebnYGELRZBHyNHXkh6qlAFxg7sPQnOhBsEgWkwPbz1T8xi1A1NJNaKWxD2sCNzM
        NT9+1tVFXmn1oOJvzKpo4F04gBzW3SY09QdX2XE6X50DTLOteqJXPoNqEpzB8uaz/VxnHL
        pDGFr5Vs1leGC6dwWOhLVHGpqkPxH+8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-57JQ2bU4Mqy8TRW2_vmb5Q-1; Thu, 07 Oct 2021 12:18:58 -0400
X-MC-Unique: 57JQ2bU4Mqy8TRW2_vmb5Q-1
Received: by mail-wr1-f72.google.com with SMTP id a10-20020a5d508a000000b00160723ce588so5117523wrt.23
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:18:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eCfS+Asf+f1waC4AVoz1E9eLdrSZudUp689oYCk0mwY=;
        b=VRI9amAPPfRR2kaCcZlYx8pQVj+14EeDM2+P4Obr1u0tusITZA1FBr/UJmS6qL/Wbz
         +31KAkbW0NEkf9cfKOHwgB066cqUvIOsJCv0ACHIxtlDWE+DRGNfPVw00H2TCb1Fxnp7
         GghxuPYhWUJYys4lvZemXLtjEpoRaiWdx467n2eRWFz7otEWnkKwH8miSQ0Yj/2763H0
         /DzA0QPpBr96KWIBs6lg0lzBXzwXEoSjP07yPO4UtQDizIQU9Vxdu1QoCc0JcTFOuWQR
         qwkfxZy0BnmA/pwUcmlR+80zNOHOOIIJH+wo7us73XwGFrYPP+Yu86vAtoV8VuXUVV9c
         cVMg==
X-Gm-Message-State: AOAM5322zrF33rkzI+10YDfJVx/QSEAwy0tGH4LKY3B/FaHHZ4kTb4Nv
        Ok4rlECZjQVyIGeuTL1HGctO5XS1IALPTBQ7rDxit+Sk0tbkgvIFlvwqDgzrKZmJwLHxo/LFtPf
        JZski9Wng+m0r
X-Received: by 2002:a7b:c351:: with SMTP id l17mr5734555wmj.120.1633623534006;
        Thu, 07 Oct 2021 09:18:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMiBCCsPqIpoUFMotzmt5Xfmuwzj1LGT3FXGJkJ2kFOsOJzE9yp1pWqRATIf7s0cH57Uvvhg==
X-Received: by 2002:a7b:c351:: with SMTP id l17mr5734533wmj.120.1633623533832;
        Thu, 07 Oct 2021 09:18:53 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id o6sm130018wri.49.2021.10.07.09.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:18:53 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 21/23] target/i386/sev: Move qmp_query_sev() & hmp_info_sev() to sev.c
Date:   Thu,  7 Oct 2021 18:17:14 +0200
Message-Id: <20211007161716.453984-22-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move qmp_query_sev() & hmp_info_sev()() from monitor.c to sev.c
and make sev_get_info() static. We don't need the stub anymore,
remove it. Add a stub for hmp_info_sev().

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev.h             |  2 --
 target/i386/monitor.c         | 35 --------------------------------
 target/i386/sev-sysemu-stub.c | 10 ++++++++-
 target/i386/sev.c             | 38 +++++++++++++++++++++++++++++++++--
 4 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/target/i386/sev.h b/target/i386/sev.h
index dda350779f9..3fba1884a0d 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -19,7 +19,6 @@
 #endif
 
 #include "exec/confidential-guest-support.h"
-#include "qapi/qapi-types-misc-target.h"
 
 #define SEV_POLICY_NODBG        0x1
 #define SEV_POLICY_NOKS         0x2
@@ -47,7 +46,6 @@ bool sev_es_enabled(void);
 #define sev_es_enabled() 0
 #endif
 
-extern SevInfo *sev_get_info(void);
 extern uint32_t sev_get_cbit_position(void);
 extern uint32_t sev_get_reduced_phys_bits(void);
 extern bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp);
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index bd24d0d4737..680d282591c 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -31,7 +31,6 @@
 #include "qapi/qmp/qerror.h"
 #include "sysemu/kvm.h"
 #include "qapi/error.h"
-#include "sev.h"
 #include "qapi/qapi-commands-misc-target.h"
 #include "qapi/qapi-commands-misc.h"
 #include "hw/i386/pc.h"
@@ -676,40 +675,6 @@ void hmp_info_io_apic(Monitor *mon, const QDict *qdict)
                    "removed soon. Please use 'info pic' instead.\n");
 }
 
-SevInfo *qmp_query_sev(Error **errp)
-{
-    SevInfo *info;
-
-    info = sev_get_info();
-    if (!info) {
-        error_setg(errp, "SEV feature is not available");
-        return NULL;
-    }
-
-    return info;
-}
-
-void hmp_info_sev(Monitor *mon, const QDict *qdict)
-{
-    SevInfo *info = sev_get_info();
-
-    if (info && info->enabled) {
-        monitor_printf(mon, "handle: %d\n", info->handle);
-        monitor_printf(mon, "state: %s\n", SevState_str(info->state));
-        monitor_printf(mon, "build: %d\n", info->build_id);
-        monitor_printf(mon, "api version: %d.%d\n",
-                       info->api_major, info->api_minor);
-        monitor_printf(mon, "debug: %s\n",
-                       info->policy & SEV_POLICY_NODBG ? "off" : "on");
-        monitor_printf(mon, "key-sharing: %s\n",
-                       info->policy & SEV_POLICY_NOKS ? "off" : "on");
-    } else {
-        monitor_printf(mon, "SEV is not enabled\n");
-    }
-
-    qapi_free_SevInfo(info);
-}
-
 SGXInfo *qmp_query_sgx(Error **errp)
 {
     return sgx_get_info(errp);
diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
index 8d97d7c7e14..68518fd3f9d 100644
--- a/target/i386/sev-sysemu-stub.c
+++ b/target/i386/sev-sysemu-stub.c
@@ -12,13 +12,16 @@
  */
 
 #include "qemu/osdep.h"
+#include "monitor/monitor.h"
+#include "monitor/hmp.h"
 #include "qapi/qapi-commands-misc-target.h"
 #include "qapi/qmp/qerror.h"
 #include "qapi/error.h"
 #include "sev.h"
 
-SevInfo *sev_get_info(void)
+SevInfo *qmp_query_sev(Error **errp)
 {
+    error_setg(errp, "SEV is not available in this QEMU");
     return NULL;
 }
 
@@ -60,3 +63,8 @@ SevAttestationReport *qmp_query_sev_attestation_report(const char *mnonce,
     error_setg(errp, "SEV is not available in this QEMU");
     return NULL;
 }
+
+void hmp_info_sev(Monitor *mon, const QDict *qdict)
+{
+    monitor_printf(mon, "SEV is not available in this QEMU\n");
+}
diff --git a/target/i386/sev.c b/target/i386/sev.c
index ec874b3df82..19504796fb7 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -32,6 +32,7 @@
 #include "migration/blocker.h"
 #include "qom/object.h"
 #include "monitor/monitor.h"
+#include "monitor/hmp.h"
 #include "qapi/qapi-commands-misc-target.h"
 #include "qapi/qmp/qerror.h"
 #include "exec/confidential-guest-support.h"
@@ -402,8 +403,7 @@ sev_get_reduced_phys_bits(void)
     return sev_guest ? sev_guest->reduced_phys_bits : 0;
 }
 
-SevInfo *
-sev_get_info(void)
+static SevInfo *sev_get_info(void)
 {
     SevInfo *info;
 
@@ -422,6 +422,40 @@ sev_get_info(void)
     return info;
 }
 
+SevInfo *qmp_query_sev(Error **errp)
+{
+    SevInfo *info;
+
+    info = sev_get_info();
+    if (!info) {
+        error_setg(errp, "SEV feature is not available");
+        return NULL;
+    }
+
+    return info;
+}
+
+void hmp_info_sev(Monitor *mon, const QDict *qdict)
+{
+    SevInfo *info = sev_get_info();
+
+    if (info && info->enabled) {
+        monitor_printf(mon, "handle: %d\n", info->handle);
+        monitor_printf(mon, "state: %s\n", SevState_str(info->state));
+        monitor_printf(mon, "build: %d\n", info->build_id);
+        monitor_printf(mon, "api version: %d.%d\n",
+                       info->api_major, info->api_minor);
+        monitor_printf(mon, "debug: %s\n",
+                       info->policy & SEV_POLICY_NODBG ? "off" : "on");
+        monitor_printf(mon, "key-sharing: %s\n",
+                       info->policy & SEV_POLICY_NOKS ? "off" : "on");
+    } else {
+        monitor_printf(mon, "SEV is not enabled\n");
+    }
+
+    qapi_free_SevInfo(info);
+}
+
 static int
 sev_get_pdh_info(int fd, guchar **pdh, size_t *pdh_len, guchar **cert_chain,
                  size_t *cert_chain_len, Error **errp)
-- 
2.31.1

