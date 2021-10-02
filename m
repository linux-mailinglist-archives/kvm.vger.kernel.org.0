Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6727A41FBEB
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhJBMz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:55:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21764 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233277AbhJBMz5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:55:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AZLS+m7xAvvk2uRB++FAfryJbzXnCIDe39YBz1qMJyo=;
        b=cAJsT9hPxKeAPOiS3lTpLkXmCWqN/L7g21neJdhTZYR3flL8ZYkm7Ao01JTNuM0pU6506T
        DSgw6vsSOGzMXhH+NXUd5jRFjYwpKU+EGZIRvrtKeRwl6jbhGf7TCY+zDev5KWPTzgzZTk
        zNTmPTfjSgj2aIJziMEdTDWyWzV3maw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-WcEH7UnDPWWKETcxOi4BDw-1; Sat, 02 Oct 2021 08:54:10 -0400
X-MC-Unique: WcEH7UnDPWWKETcxOi4BDw-1
Received: by mail-wm1-f69.google.com with SMTP id o11-20020a05600c378b00b0030d4f47013aso2285875wmr.7
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:54:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AZLS+m7xAvvk2uRB++FAfryJbzXnCIDe39YBz1qMJyo=;
        b=3SsdQtmeXQZgPMXub4QhVRSCgrNYTYURokVIuV+HATQxRSztL4nVjw6k5Cog4b7JQc
         +iCzdDG9hXjmtcChkwShUGtDSi+66SJU0zdII80rKfgjGMn+L8/7HV+9UYQGlYyKWyCG
         QLRDoH/lDTs0I0IaI2NxVxaADZi61e3zT1EP1XH10x5FYbk9UpBZ+QUN7UYy3KW+cW7B
         rUbl4ph5B9STEoDj5FrDgy+5sO+o63/fMkphO4YG57WZmw5R8P+gcUNdYrIcF9EHNR3B
         a4hzNI+P7JMyMhIlaKBnyh8kYUYKXgZlcwvSeQoSMYr9qmI7z9XK739ayhEoYWwA+tml
         plcw==
X-Gm-Message-State: AOAM532YTI8WBTs/JxrIMosifOfFbqlpMABGt4UuADQ43ZEAcn/Q4wpS
        b565vytUQ8Mqhv/Q+Vni+2p0ckYAnBkf6ZAEk1DkyFUY5Zbb3bFwbB6TqmQIU5HG7LioQ2KXdZV
        kVwyRFmMlQxLk
X-Received: by 2002:adf:b185:: with SMTP id q5mr1100016wra.213.1633179248985;
        Sat, 02 Oct 2021 05:54:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhvlat8mS6Fsi/9Q+MqqxK+CL6/DlRnFXF7c3AjMW/EsZmLOxs5oU2baglAlxjjo/FnbXepw==
X-Received: by 2002:adf:b185:: with SMTP id q5mr1100005wra.213.1633179248822;
        Sat, 02 Oct 2021 05:54:08 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id z8sm9814721wrm.63.2021.10.02.05.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:54:08 -0700 (PDT)
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
Subject: [PATCH v3 11/22] target/i386/sev: Restrict SEV to system emulation
Date:   Sat,  2 Oct 2021 14:53:06 +0200
Message-Id: <20211002125317.3418648-12-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV is irrelevant on user emulation, so restrict it to sysemu.
Some stubs are still required because used in cpu.c by
x86_register_cpudef_types(), so move the sysemu specific stubs
to sev-sysemu-stub.c instead. This will allow us to simplify
monitor.c (which is not available in user emulation) in the
next commit.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev-stub.c        | 43 -------------------------
 target/i386/sev-sysemu-stub.c | 60 +++++++++++++++++++++++++++++++++++
 target/i386/meson.build       |  4 ++-
 3 files changed, 63 insertions(+), 44 deletions(-)
 create mode 100644 target/i386/sev-sysemu-stub.c

diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index 4668365fd3e..8eae5d2fa8d 100644
--- a/target/i386/sev-stub.c
+++ b/target/i386/sev-stub.c
@@ -15,11 +15,6 @@
 #include "qapi/error.h"
 #include "sev_i386.h"
 
-SevInfo *sev_get_info(void)
-{
-    return NULL;
-}
-
 bool sev_enabled(void)
 {
     return false;
@@ -35,45 +30,7 @@ uint32_t sev_get_reduced_phys_bits(void)
     return 0;
 }
 
-char *sev_get_launch_measurement(void)
-{
-    return NULL;
-}
-
-SevCapability *sev_get_capabilities(Error **errp)
-{
-    error_setg(errp, "SEV is not available in this QEMU");
-    return NULL;
-}
-
-int sev_inject_launch_secret(const char *hdr, const char *secret,
-                             uint64_t gpa, Error **errp)
-{
-    return 1;
-}
-
-int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
-{
-    g_assert_not_reached();
-}
-
 bool sev_es_enabled(void)
 {
     return false;
 }
-
-void sev_es_set_reset_vector(CPUState *cpu)
-{
-}
-
-int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
-{
-    g_assert_not_reached();
-}
-
-SevAttestationReport *
-sev_get_attestation_report(const char *mnonce, Error **errp)
-{
-    error_setg(errp, "SEV is not available in this QEMU");
-    return NULL;
-}
diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
new file mode 100644
index 00000000000..d556b4f091f
--- /dev/null
+++ b/target/i386/sev-sysemu-stub.c
@@ -0,0 +1,60 @@
+/*
+ * QEMU SEV system stub
+ *
+ * Copyright Advanced Micro Devices 2018
+ *
+ * Authors:
+ *      Brijesh Singh <brijesh.singh@amd.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ *
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/qapi-commands-misc-target.h"
+#include "qapi/error.h"
+#include "sev_i386.h"
+
+SevInfo *sev_get_info(void)
+{
+    return NULL;
+}
+
+char *sev_get_launch_measurement(void)
+{
+    return NULL;
+}
+
+SevCapability *sev_get_capabilities(Error **errp)
+{
+    error_setg(errp, "SEV is not available in this QEMU");
+    return NULL;
+}
+
+int sev_inject_launch_secret(const char *hdr, const char *secret,
+                             uint64_t gpa, Error **errp)
+{
+    return 1;
+}
+
+int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
+{
+    g_assert_not_reached();
+}
+
+void sev_es_set_reset_vector(CPUState *cpu)
+{
+}
+
+int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
+{
+    g_assert_not_reached();
+}
+
+SevAttestationReport *sev_get_attestation_report(const char *mnonce,
+                                                 Error **errp)
+{
+    error_setg(errp, "SEV is not available in this QEMU");
+    return NULL;
+}
diff --git a/target/i386/meson.build b/target/i386/meson.build
index dac19ec00d4..a4f45c3ec1d 100644
--- a/target/i386/meson.build
+++ b/target/i386/meson.build
@@ -6,7 +6,7 @@
   'xsave_helper.c',
   'cpu-dump.c',
 ))
-i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c', 'sev.c'), if_false: files('sev-stub.c'))
+i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c'), if_false: files('sev-stub.c'))
 
 # x86 cpu type
 i386_ss.add(when: 'CONFIG_KVM', if_true: files('host-cpu.c'))
@@ -20,6 +20,8 @@
   'monitor.c',
   'cpu-sysemu.c',
 ))
+i386_softmmu_ss.add(when: 'CONFIG_SEV', if_true: files('sev.c'), if_false: files('sev-sysemu-stub.c'))
+
 i386_user_ss = ss.source_set()
 
 subdir('kvm')
-- 
2.31.1

