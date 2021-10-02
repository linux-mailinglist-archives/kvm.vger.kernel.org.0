Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92D341FBF1
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhJBM43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:56:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38855 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233310AbhJBM42 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zmeHSaAJmvIQWkoqQvBbbph1YlHUwqkxNB0lhULs12o=;
        b=f9d9n+474myHbdMtMa4nwz4md0QpUXCxUGHaOVPuetXc6otKxKt/bYHNlTXRJ8qqsTXPLk
        frvg51/TBkyn1j7BSEIOo882wBAZXObDAY8BpmUOyDdKp3k5QjpsNTKh633KyY5MYy7uRa
        My/uC0YdLsU0DYosPX1CvSrXPu44QG4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-mTXAltLDMpaqgtnS-n5fYA-1; Sat, 02 Oct 2021 08:54:41 -0400
X-MC-Unique: mTXAltLDMpaqgtnS-n5fYA-1
Received: by mail-wm1-f70.google.com with SMTP id m9-20020a05600c4f4900b003057c761567so7367977wmq.1
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:54:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zmeHSaAJmvIQWkoqQvBbbph1YlHUwqkxNB0lhULs12o=;
        b=0tLHR1rB1i2kMvaiHkZMqcjpI/1T7TWCGrdMp7Vw93Sq6hFuzeT9gNeElYDOVSzo5V
         CmN/oT6/Zv8JFVEYXUnD52ODTOA18KvVk8NLg9lv2+wla0b2WKcyvP7BavJhR0inrzkW
         25qo0RVDdhTOy+aXYQxD+FZ4dyEVzgF85sPA4Dd45HKprLcoaXE/TWcOQUvFxGNZ+M1q
         wvETMxhKLve1rsHLfnkRCL2L0O6v1+S8rPlqa5HnDPLBiaC9NQ+/zjgn+0UWcVP/GIpR
         UPY+q2CdT1dqQhMyhnjwMF3LcuhJAJjL9gKMpgzE34/tS2XZabX9V8XeFmSEY85pIsk7
         xitg==
X-Gm-Message-State: AOAM533479qBDk0HC/969HgbFiSXze2uzx1KdxdVrsX74LScDBaLKlyt
        7I3ACnU5OL+27IWo8fJ2GtOjn4ZOssKpjokVBIT0wsvN8jryzxP9lNv881xHM3A+8Aixj9iQ4sz
        laZJ625TukqMA
X-Received: by 2002:a1c:7302:: with SMTP id d2mr9391302wmb.92.1633179280617;
        Sat, 02 Oct 2021 05:54:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgPMBEpdCmd98sav+qHs899wgnlAFISSby1vK2IYSyDBW7M/2t9a3jNO0u1D6NgduWenHWdg==
X-Received: by 2002:a1c:7302:: with SMTP id d2mr9391291wmb.92.1633179280396;
        Sat, 02 Oct 2021 05:54:40 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id m29sm8762685wrb.89.2021.10.02.05.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:54:40 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org,
        James Bottomley <jejb@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Daniel P . Berrange" <berrange@redhat.com>
Subject: [PATCH v3 18/22] target/i386/sev: Move qmp_query_sev() & hmp_info_sev() to sev.c
Date:   Sat,  2 Oct 2021 14:53:13 +0200
Message-Id: <20211002125317.3418648-19-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move qmp_query_sev() & hmp_info_sev()() from monitor.c to sev.c
and make sev_get_info() static. We don't need the stub anymore,
remove it. Add a stub for hmp_info_sev().

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev_i386.h        |  3 ---
 target/i386/monitor.c         | 38 +---------------------------------
 target/i386/sev-sysemu-stub.c | 10 ++++++++-
 target/i386/sev.c             | 39 +++++++++++++++++++++++++++++++++--
 4 files changed, 47 insertions(+), 43 deletions(-)

diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index 1699376ad87..15a959d6174 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -15,7 +15,6 @@
 #define QEMU_SEV_I386_H
 
 #include "sysemu/sev.h"
-#include "qapi/qapi-types-misc-target.h"
 
 #define SEV_POLICY_NODBG        0x1
 #define SEV_POLICY_NOKS         0x2
@@ -24,8 +23,6 @@
 #define SEV_POLICY_DOMAIN       0x10
 #define SEV_POLICY_SEV          0x20
 
-extern SevInfo *sev_get_info(void);
-
 int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
 int sev_inject_launch_secret(const char *hdr, const char *secret,
                              uint64_t gpa, Error **errp);
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index 0b38e970c73..890870b252d 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -28,11 +28,9 @@
 #include "monitor/hmp-target.h"
 #include "monitor/hmp.h"
 #include "qapi/qmp/qdict.h"
-#include "qapi/qmp/qerror.h"
+//#include "qapi/qmp/qerror.h"
 #include "sysemu/kvm.h"
-#include "sysemu/sev.h"
 #include "qapi/error.h"
-#include "sev_i386.h"
 #include "qapi/qapi-commands-misc-target.h"
 #include "qapi/qapi-commands-misc.h"
 #include "hw/i386/pc.h"
@@ -677,40 +675,6 @@ void hmp_info_io_apic(Monitor *mon, const QDict *qdict)
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
index 355391c16c4..1836b32e4fc 100644
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
 #include "sev_i386.h"
 
-SevInfo *sev_get_info(void)
+SevInfo *qmp_query_sev(Error **errp)
 {
+    error_setg(errp, QERR_UNSUPPORTED);
     return NULL;
 }
 
@@ -60,3 +63,8 @@ SevAttestationReport *qmp_query_sev_attestation_report(const char *mnonce,
     error_setg(errp, QERR_UNSUPPORTED);
     return NULL;
 }
+
+void hmp_info_sev(Monitor *mon, const QDict *qdict)
+{
+    monitor_printf(mon, "SEV is not available in this QEMU\n");
+}
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 8e9cce62196..7caaa117ff7 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -27,10 +27,12 @@
 #include "sev_i386.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/runstate.h"
+#include "sysemu/sev.h"
 #include "trace.h"
 #include "migration/blocker.h"
 #include "qom/object.h"
 #include "monitor/monitor.h"
+#include "monitor/hmp.h"
 #include "qapi/qapi-commands-misc-target.h"
 #include "qapi/qmp/qerror.h"
 #include "exec/confidential-guest-support.h"
@@ -375,8 +377,7 @@ sev_get_reduced_phys_bits(void)
     return sev_guest ? sev_guest->reduced_phys_bits : 0;
 }
 
-SevInfo *
-sev_get_info(void)
+static SevInfo *sev_get_info(void)
 {
     SevInfo *info;
 
@@ -395,6 +396,40 @@ sev_get_info(void)
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

