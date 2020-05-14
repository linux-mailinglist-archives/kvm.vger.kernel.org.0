Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFA61D27FB
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgENGl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725818AbgENGl3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 02:41:29 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB8CC061A0C
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 23:41:29 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24j2TJxz9sSm; Thu, 14 May 2020 16:41:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438485;
        bh=e/F3jfkYY4pCFSP1J0ppy4A2lsfK0cXkbXmTVdiZhHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMo9uaKWVQ8yfQ39oEQ9aKcLMQmxgFW/Rl9kTb4goZRePtFhR7A9MBPOBIAov5D0j
         U/cyPFE5QknwaUAg3x56EeQF6PMRSjOKYqFR5W3aTf+7yBXrfUEn5MP5QIPJjdqGFJ
         MZAar0qq4xmtSkOIJbS5A0ymRCG8DZmhkiRDzecc=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.redhat.com,
        qemu-devel@nongnu.org, brijesh.singh@amd.com
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.-rg,
        mdroth@linux.vnet.ibm.com
Subject: [RFC 02/18] target/i386: sev: Move local structure definitions into .c file
Date:   Thu, 14 May 2020 16:41:04 +1000
Message-Id: <20200514064120.449050-3-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514064120.449050-1-david@gibson.dropbear.id.au>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Neither QSevGuestInfo nor SEVState (not to be confused with SevState) is
used anywhere outside target/i386/sev.c, so they might as well live in
there rather than in a (somewhat) exposed header.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 target/i386/sev.c      | 44 ++++++++++++++++++++++++++++++++++++++++++
 target/i386/sev_i386.h | 44 ------------------------------------------
 2 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index d73d53d558..c7a6e3f6d2 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -29,6 +29,50 @@
 #include "trace.h"
 #include "migration/blocker.h"
 
+#define TYPE_QSEV_GUEST_INFO "sev-guest"
+#define QSEV_GUEST_INFO(obj)                  \
+    OBJECT_CHECK(QSevGuestInfo, (obj), TYPE_QSEV_GUEST_INFO)
+
+typedef struct QSevGuestInfo QSevGuestInfo;
+
+/**
+ * QSevGuestInfo:
+ *
+ * The QSevGuestInfo object is used for creating a SEV guest.
+ *
+ * # $QEMU \
+ *         -object sev-guest,id=sev0 \
+ *         -machine ...,memory-encryption=sev0
+ */
+struct QSevGuestInfo {
+    Object parent_obj;
+
+    char *sev_device;
+    uint32_t policy;
+    uint32_t handle;
+    char *dh_cert_file;
+    char *session_file;
+    uint32_t cbitpos;
+    uint32_t reduced_phys_bits;
+};
+
+struct SEVState {
+    QSevGuestInfo *sev_info;
+    uint8_t api_major;
+    uint8_t api_minor;
+    uint8_t build_id;
+    uint32_t policy;
+    uint64_t me_mask;
+    uint32_t cbitpos;
+    uint32_t reduced_phys_bits;
+    uint32_t handle;
+    int sev_fd;
+    SevState state;
+    gchar *measurement;
+};
+
+typedef struct SEVState SEVState;
+
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
 
diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index 4f193642ac..8eb7de1bef 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -28,10 +28,6 @@
 #define SEV_POLICY_DOMAIN       0x10
 #define SEV_POLICY_SEV          0x20
 
-#define TYPE_QSEV_GUEST_INFO "sev-guest"
-#define QSEV_GUEST_INFO(obj)                  \
-    OBJECT_CHECK(QSevGuestInfo, (obj), TYPE_QSEV_GUEST_INFO)
-
 extern bool sev_enabled(void);
 extern uint64_t sev_get_me_mask(void);
 extern SevInfo *sev_get_info(void);
@@ -40,44 +36,4 @@ extern uint32_t sev_get_reduced_phys_bits(void);
 extern char *sev_get_launch_measurement(void);
 extern SevCapability *sev_get_capabilities(void);
 
-typedef struct QSevGuestInfo QSevGuestInfo;
-
-/**
- * QSevGuestInfo:
- *
- * The QSevGuestInfo object is used for creating a SEV guest.
- *
- * # $QEMU \
- *         -object sev-guest,id=sev0 \
- *         -machine ...,memory-encryption=sev0
- */
-struct QSevGuestInfo {
-    Object parent_obj;
-
-    char *sev_device;
-    uint32_t policy;
-    uint32_t handle;
-    char *dh_cert_file;
-    char *session_file;
-    uint32_t cbitpos;
-    uint32_t reduced_phys_bits;
-};
-
-struct SEVState {
-    QSevGuestInfo *sev_info;
-    uint8_t api_major;
-    uint8_t api_minor;
-    uint8_t build_id;
-    uint32_t policy;
-    uint64_t me_mask;
-    uint32_t cbitpos;
-    uint32_t reduced_phys_bits;
-    uint32_t handle;
-    int sev_fd;
-    SevState state;
-    gchar *measurement;
-};
-
-typedef struct SEVState SEVState;
-
 #endif
-- 
2.26.2

