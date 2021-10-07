Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216FC4257AD
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242695AbhJGQUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:20:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242688AbhJGQUh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gRE3NNVTx8SI9X33FPifPWmCEg7suN8YDk0KQOEofaw=;
        b=GsZ8Az/59ZZaDLydHoDSus0pDAlHpBQsotHKEGnSJRDyIO3Vf5okgEMhnFLyAV71zVTBSh
        C06BMZzMpERv4FkIfduneQpt8SBatxcImuyItwzkjRqaoNK/0mru0vPdZxjBUzqpzo0Znc
        e1rEKKQycPB8R8bqiSyIl6tjZzkwikY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-Eyjt8-Q_N2y8mIYMBNeT4g-1; Thu, 07 Oct 2021 12:18:42 -0400
X-MC-Unique: Eyjt8-Q_N2y8mIYMBNeT4g-1
Received: by mail-wr1-f71.google.com with SMTP id f11-20020adfc98b000000b0015fedc2a8d4so5146761wrh.0
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:18:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gRE3NNVTx8SI9X33FPifPWmCEg7suN8YDk0KQOEofaw=;
        b=UFcgDa16JusKNg3sS4mf/V7noJpdkgHMsbafhv18XyBJGQUSezovIVM9ocIwlCECDM
         AwbqJmMzeUxkrHqwbJC1nw/Sf3Hlj6n4wL6bCVT/arf/BZVpaPKgTB7AmW9CR8+eqHpA
         xj64qgVOkRF6bOEllwMnkiTrT/Xkse44HWTjTymx9cTU255ckp9DZEdIrEZ7UJ5t66Ej
         zXdCxP91w1uq+20Qleutp1SFjP5hTvQTl/mBluSztrrX6l8soTKqpUHSITnQPfGaeBE3
         r/P4BKF0I4IDv/lP7hAXKEVfSqYEpfK2JEm0e7uL/4fKoU+XpfG50XYEvcPzJ9+45Z/Y
         9Z7Q==
X-Gm-Message-State: AOAM5317ZySNxFZ1R4vjx0D0OXs78nPQtOWI12v1haPElu61a3jT5NtA
        ZKexeO3K9/yl19Q9bBGFlp44cRcmQXqR3/KcfGAp/9pI5qfrn9cvaCCW0NxvOBjf9hCqSHcyB7K
        QyQ06FEYKyd1F
X-Received: by 2002:a05:6000:18aa:: with SMTP id b10mr6550211wri.270.1633623520776;
        Thu, 07 Oct 2021 09:18:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyeSWibl7b2NVZJa7Vkddhan4RmMUK+An6BeboL1TOS5wajjOas8bdfopDiRz2IE0A5yVSojA==
X-Received: by 2002:a05:6000:18aa:: with SMTP id b10mr6550171wri.270.1633623520408;
        Thu, 07 Oct 2021 09:18:40 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id c5sm9182174wml.9.2021.10.07.09.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:18:40 -0700 (PDT)
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
Subject: [PATCH v4 18/23] target/i386/sev: Move qmp_sev_inject_launch_secret() to sev.c
Date:   Thu,  7 Oct 2021 18:17:11 +0200
Message-Id: <20211007161716.453984-19-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move qmp_sev_inject_launch_secret() from monitor.c to sev.c
and make sev_inject_launch_secret() static. We don't need the
stub anymore, remove it.

Previously with binaries built without SEV, management layer
was getting an empty response:

  { "execute": "sev-inject-launch-secret",
    "arguments": { "packet-header": "mypkt", "secret": "mypass", "gpa": 4294959104 }
  }
  {
      "return": {
      }
  }

Now the response is explicit, mentioning the feature is disabled:

  { "execute": "sev-inject-launch-secret",
          "arguments": { "packet-header": "mypkt", "secret": "mypass", "gpa": 4294959104 }
  }
  {
      "error": {
          "class": "GenericError",
          "desc": "this feature or command is not currently supported"
      }
  }

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/monitor.c         | 31 -------------------------------
 target/i386/sev-sysemu-stub.c |  6 +++---
 target/i386/sev.c             | 31 +++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index cf4a8a61a02..22883ef2ebb 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -732,37 +732,6 @@ SevCapability *qmp_query_sev_capabilities(Error **errp)
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
-        error_setg(errp, "SEV not enabled for guest");
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
index d5ec6b32e0a..82c5ebb92fa 100644
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
+    error_setg(errp, "SEV is not available in this QEMU");
 }
 
 int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 038fa560588..072bb6f0fd7 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -973,6 +973,37 @@ int sev_inject_launch_secret(const char *packet_hdr, const char *secret,
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
+        error_setg(errp, "SEV not enabled for guest");
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

