Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEF841FBEE
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhJBM4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:56:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233303AbhJBM4P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:56:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MFPED/lWL7McgnfaLMNLaFFcTGfU944hsrHyvaxNr8c=;
        b=Np2brtWWkoftLajluTJEbcJ9Td+yudIRnJOCacgoCA7kvZ+Nnu8EkgcCqlGtBUZ01XFEZp
        QvDpOvhIB4mIKGkQqzrHHLEWDu69JrDBww4kkYKXUqOfWeBEj5fL33a6cL5XrQhqIgtUQA
        O3/n91SjMtIZZF4/bF4xLG+x1vPPthg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-zLpZr1HxOmmyXkCZsUuqJQ-1; Sat, 02 Oct 2021 08:54:28 -0400
X-MC-Unique: zLpZr1HxOmmyXkCZsUuqJQ-1
Received: by mail-wm1-f71.google.com with SMTP id o28-20020a05600c511c00b0030cdce826f9so3791974wms.5
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:54:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MFPED/lWL7McgnfaLMNLaFFcTGfU944hsrHyvaxNr8c=;
        b=X39bCPP0900gin3VLy7LEfyyN2OtCH6n4hHYzxSn0I32Bn4GYBxbnfIOszh5Mf/7Hc
         tMUb/530smVYUDRKYhNGMyZBY/EXkl1OE+OaIrLHzEFAc05J5r04dxYci085hv5DnTPW
         IA/Cl+x6GNNbKJJVSK9u99K5NKooIUC+oJV3YVacVjcE/45ZQeXbvDniTBUsbswKEAU5
         ASzucvYyrt3jPi6uKtBzGoaPBseEFKk2WK2aBzkCMoOKy71WMEvl8a3C/pMmt+m7pWVt
         zteevpIIHMlRomVZL5w0Haolp0JeNUc5pgSeJEjOj4ox2Ndu9nGLQGkLYJaIrVUsQQ8N
         d3pg==
X-Gm-Message-State: AOAM532i3ekk2v5/I2dFGe7X2qQivz8Bne2QGRBxs3FLOx8bCch5rju/
        kINuN3NGCxlCIkQSbF9tSys9A4KhPIvEugtQKahWUxlPQ2BBsNj5e61AeTpJRArtf6XHNL5cm+5
        NPfFRv7dmwkTO
X-Received: by 2002:a5d:608e:: with SMTP id w14mr3315467wrt.119.1633179267185;
        Sat, 02 Oct 2021 05:54:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1NL6M/YsdfSGb125vbKkdnK0ovBHXMOfTrj0Zv4qPiwD4uvPRl8NF6jMFLf6uS8Tsr9ze6A==
X-Received: by 2002:a5d:608e:: with SMTP id w14mr3315454wrt.119.1633179266991;
        Sat, 02 Oct 2021 05:54:26 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id j7sm9971641wrr.27.2021.10.02.05.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:54:26 -0700 (PDT)
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
Subject: [PATCH v3 15/22] target/i386/sev: Move qmp_sev_inject_launch_secret() to sev.c
Date:   Sat,  2 Oct 2021 14:53:10 +0200
Message-Id: <20211002125317.3418648-16-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move qmp_sev_inject_launch_secret() from monitor.c to sev.c
and make sev_inject_launch_secret() static. We don't need the
stub anymore, remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/monitor.c         | 31 -------------------------------
 target/i386/sev-sysemu-stub.c |  6 +++---
 target/i386/sev.c             | 31 +++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index c05d70252a2..188203da6f2 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -733,37 +733,6 @@ SevCapability *qmp_query_sev_capabilities(Error **errp)
     return sev_get_capabilities(errp);
 }
 
-#define SEV_SECRET_GUID "4c2eb361-7d9b-4cc3-8081-127c90d3d294"
-struct sev_secret_area {
-    uint32_t base;
-    uint32_t size;
-};
-
-void qmp_sev_inject_launch_secret(const char *packet_hdr,
-                                  const char *secret,
-                                  bool has_gpa, uint64_t gpa,
-                                  Error **errp)
-{
-    if (!sev_enabled()) {
-        error_setg(errp, QERR_UNSUPPORTED);
-        return;
-    }
-    if (!has_gpa) {
-        uint8_t *data;
-        struct sev_secret_area *area;
-
-        if (!pc_system_ovmf_table_find(SEV_SECRET_GUID, &data, NULL)) {
-            error_setg(errp, "SEV: no secret area found in OVMF,"
-                       " gpa must be specified.");
-            return;
-        }
-        area = (struct sev_secret_area *)data;
-        gpa = area->base;
-    }
-
-    sev_inject_launch_secret(packet_hdr, secret, gpa, errp);
-}
-
 SGXInfo *qmp_query_sgx(Error **errp)
 {
     return sgx_get_info(errp);
diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
index 813b9a6a03b..66b69540aa5 100644
--- a/target/i386/sev-sysemu-stub.c
+++ b/target/i386/sev-sysemu-stub.c
@@ -33,10 +33,10 @@ SevCapability *sev_get_capabilities(Error **errp)
     return NULL;
 }
 
-int sev_inject_launch_secret(const char *hdr, const char *secret,
-                             uint64_t gpa, Error **errp)
+void qmp_sev_inject_launch_secret(const char *packet_header, const char *secret,
+                                  bool has_gpa, uint64_t gpa, Error **errp)
 {
-    return 1;
+    error_setg(errp, QERR_UNSUPPORTED);
 }
 
 int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 91a217bbb85..2198d550be2 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -949,6 +949,37 @@ int sev_inject_launch_secret(const char *packet_hdr, const char *secret,
     return 0;
 }
 
+#define SEV_SECRET_GUID "4c2eb361-7d9b-4cc3-8081-127c90d3d294"
+struct sev_secret_area {
+    uint32_t base;
+    uint32_t size;
+};
+
+void qmp_sev_inject_launch_secret(const char *packet_hdr,
+                                  const char *secret,
+                                  bool has_gpa, uint64_t gpa,
+                                  Error **errp)
+{
+    if (!sev_enabled()) {
+        error_setg(errp, QERR_UNSUPPORTED);
+        return;
+    }
+    if (!has_gpa) {
+        uint8_t *data;
+        struct sev_secret_area *area;
+
+        if (!pc_system_ovmf_table_find(SEV_SECRET_GUID, &data, NULL)) {
+            error_setg(errp, "SEV: no secret area found in OVMF,"
+                       " gpa must be specified.");
+            return;
+        }
+        area = (struct sev_secret_area *)data;
+        gpa = area->base;
+    }
+
+    sev_inject_launch_secret(packet_hdr, secret, gpa, errp);
+}
+
 static int
 sev_es_parse_reset_block(SevInfoBlock *info, uint32_t *addr)
 {
-- 
2.31.1

