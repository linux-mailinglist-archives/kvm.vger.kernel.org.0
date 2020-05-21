Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EF41DC5C2
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 05:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgEUDnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 23:43:16 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58701 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgEUDnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 23:43:15 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49SFnr46D4z9sTM; Thu, 21 May 2020 13:43:12 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1590032592;
        bh=qt1SRH9INoxyxgglr9QeYCX23oCC/+kJcGSaqPbv7SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCodzQxQJSyz8Wn7Jsmit/eQ8OxfEseFlAV2jSTI7S+W2WGOXRr36p+AxAiQEHlwu
         X5x27w/rGSj0qLr4UbVu6tdvRNzBuzwVa1H0gsJ22ighBFfo5WY2K2d0RggbA4iDEC
         lBOJ6UsmnxWplajoHGFuNG/j0WOR+bEWYdrbJwUM=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com
Cc:     qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        mdroth@linux.vnet.ibm.com, cohuck@redhat.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v2 02/18] target/i386: sev: Move local structure definitions into .c file
Date:   Thu, 21 May 2020 13:42:48 +1000
Message-Id: <20200521034304.340040-3-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
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
index 2312510cf2..53def5f41a 100644
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

