Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD7041FBEC
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbhJBM4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:56:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38186 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233277AbhJBM4I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:56:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ORMXV0Tst1vudHF4i8O0+oN0mxRTrnSBxDsiV4I1LIw=;
        b=NlshnXKVitQtim8qSGiGgdDN/uE/knkcCci3ShAkF8RzV8+HRJhXPkgspWm9ZjLG4Z81Wa
        Qldl+PqfWSC+PgvHDj83bkx4ZMeXCa0XYW6g/cH1luqBCcVv/O4OAh4GicF5d2ZZOPzfOD
        I0Y0R59VkcNeovBR8rYmXOaKEGANyjg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-gzmGQhyCPy6JWZ8S7JOG4w-1; Sat, 02 Oct 2021 08:54:19 -0400
X-MC-Unique: gzmGQhyCPy6JWZ8S7JOG4w-1
Received: by mail-wm1-f70.google.com with SMTP id j21-20020a05600c1c1500b0030ccce95837so3789305wms.3
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ORMXV0Tst1vudHF4i8O0+oN0mxRTrnSBxDsiV4I1LIw=;
        b=DtAydpPoYqHW6WbIWDm3sszAy/Wh41FY5mE7TpaggoecOnHNmECWglB+QTxaVS8KQY
         ezTZ5ECcx258rW7SYH0e4raYtMyBDd6G9HD8FShweDIhLx9AqlftW0kFAKZgPpE9QkSr
         rMCiWJA3vHh2WQMEeF00if7iD4/QZOlxcFOo2oCZOZjzh5zv3eQukQZs6PXwYV57MAqf
         xnHPk51XrmX5Yr90L3Bgq0N0LmFA8F2mRznjbRmW7Ye0qJ7hiiGbssq+Zi6ptpmXSJZv
         cEHX0fqKpL9xFBs4FnxHOMOLWiIodtyCQ3a/y+O6P84uFn1Ata44faFduiGlVqpigMHL
         +Zmg==
X-Gm-Message-State: AOAM533TrQvjsrcDf1ozz/s0yKVGm6RkmoxL9SA+nGdnFQjBHvr6gyaM
        iyWvflY5hsDuGAa0Ovl9bon/Zw0n0skOKe7lVKu8aQSfWcPeB79wilE+Q/WNhogRlkoATtb2qvU
        yu1nZEmS6BZoI
X-Received: by 2002:adf:a18d:: with SMTP id u13mr3368088wru.275.1633179258172;
        Sat, 02 Oct 2021 05:54:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuWjXvREy5i/oGIVOiC0tBm2gnRbqZb/64Psa7EoqmzOxcl6FWYaAG1lUh/i/7mWLZCmUUqw==
X-Received: by 2002:adf:a18d:: with SMTP id u13mr3368069wru.275.1633179258011;
        Sat, 02 Oct 2021 05:54:18 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id i2sm8381097wrq.78.2021.10.02.05.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:54:17 -0700 (PDT)
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
Subject: [PATCH v3 13/22] target/i386/sev: Remove stubs by using code elision
Date:   Sat,  2 Oct 2021 14:53:08 +0200
Message-Id: <20211002125317.3418648-14-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only declare sev_enabled() and sev_es_enabled() when CONFIG_SEV is
set, to allow the compiler to elide unused code. Remove unnecessary
stubs.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/sysemu/sev.h    | 14 +++++++++++++-
 target/i386/sev_i386.h  |  3 ---
 target/i386/cpu.c       | 16 +++++++++-------
 target/i386/sev-stub.c  | 36 ------------------------------------
 target/i386/meson.build |  2 +-
 5 files changed, 23 insertions(+), 48 deletions(-)
 delete mode 100644 target/i386/sev-stub.c

diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
index a329ed75c1c..f5c625bb3b3 100644
--- a/include/sysemu/sev.h
+++ b/include/sysemu/sev.h
@@ -14,9 +14,21 @@
 #ifndef QEMU_SEV_H
 #define QEMU_SEV_H
 
-#include "sysemu/kvm.h"
+#ifndef CONFIG_USER_ONLY
+#include CONFIG_DEVICES /* CONFIG_SEV */
+#endif
 
+#ifdef CONFIG_SEV
 bool sev_enabled(void);
+bool sev_es_enabled(void);
+#else
+#define sev_enabled() 0
+#define sev_es_enabled() 0
+#endif
+
+uint32_t sev_get_cbit_position(void);
+uint32_t sev_get_reduced_phys_bits(void);
+
 int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
 
 #endif
diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index 0798ab3519a..2d9a1a0112e 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -24,10 +24,7 @@
 #define SEV_POLICY_DOMAIN       0x10
 #define SEV_POLICY_SEV          0x20
 
-extern bool sev_es_enabled(void);
 extern SevInfo *sev_get_info(void);
-extern uint32_t sev_get_cbit_position(void);
-extern uint32_t sev_get_reduced_phys_bits(void);
 extern char *sev_get_launch_measurement(void);
 extern SevCapability *sev_get_capabilities(Error **errp);
 extern SevAttestationReport *
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e169a01713d..27992bdc9f8 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -25,8 +25,8 @@
 #include "tcg/helper-tcg.h"
 #include "sysemu/reset.h"
 #include "sysemu/hvf.h"
+#include "sysemu/sev.h"
 #include "kvm/kvm_i386.h"
-#include "sev_i386.h"
 #include "qapi/error.h"
 #include "qapi/qapi-visit-machine.h"
 #include "qapi/qmp/qerror.h"
@@ -38,6 +38,7 @@
 #include "exec/address-spaces.h"
 #include "hw/boards.h"
 #include "hw/i386/sgx-epc.h"
+#include "sev_i386.h"
 #endif
 
 #include "disas/capstone.h"
@@ -5764,12 +5765,13 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *edx = 0;
         break;
     case 0x8000001F:
-        *eax = sev_enabled() ? 0x2 : 0;
-        *eax |= sev_es_enabled() ? 0x8 : 0;
-        *ebx = sev_get_cbit_position();
-        *ebx |= sev_get_reduced_phys_bits() << 6;
-        *ecx = 0;
-        *edx = 0;
+        *eax = *ebx = *ecx = *edx = 0;
+        if (sev_enabled()) {
+            *eax = 0x2;
+            *eax |= sev_es_enabled() ? 0x8 : 0;
+            *ebx = sev_get_cbit_position();
+            *ebx |= sev_get_reduced_phys_bits() << 6;
+        }
         break;
     default:
         /* reserved values: zero */
diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
deleted file mode 100644
index 8eae5d2fa8d..00000000000
--- a/target/i386/sev-stub.c
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * QEMU SEV stub
- *
- * Copyright Advanced Micro Devices 2018
- *
- * Authors:
- *      Brijesh Singh <brijesh.singh@amd.com>
- *
- * This work is licensed under the terms of the GNU GPL, version 2 or later.
- * See the COPYING file in the top-level directory.
- *
- */
-
-#include "qemu/osdep.h"
-#include "qapi/error.h"
-#include "sev_i386.h"
-
-bool sev_enabled(void)
-{
-    return false;
-}
-
-uint32_t sev_get_cbit_position(void)
-{
-    return 0;
-}
-
-uint32_t sev_get_reduced_phys_bits(void)
-{
-    return 0;
-}
-
-bool sev_es_enabled(void)
-{
-    return false;
-}
diff --git a/target/i386/meson.build b/target/i386/meson.build
index a4f45c3ec1d..ae38dc95635 100644
--- a/target/i386/meson.build
+++ b/target/i386/meson.build
@@ -6,7 +6,7 @@
   'xsave_helper.c',
   'cpu-dump.c',
 ))
-i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c'), if_false: files('sev-stub.c'))
+i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c'))
 
 # x86 cpu type
 i386_ss.add(when: 'CONFIG_KVM', if_true: files('host-cpu.c'))
-- 
2.31.1

