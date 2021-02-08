Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86ADA312A73
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 07:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhBHGGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 01:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhBHGGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 01:06:34 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09F1C06178A
        for <kvm@vger.kernel.org>; Sun,  7 Feb 2021 22:05:53 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DYwVs4vGhz9sW3; Mon,  8 Feb 2021 17:05:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612764341;
        bh=bpg8O2zL5MdjoFw9vYkyKLGdob6Mhf9Zggqku1TuXHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/SGkHivcwOCLiCFkJUYM9QQLERqA4X0mTiv3rHRNDAeKZ97eZB3yprHHRBweRwZ3
         cXsfNwnVbZbn2Q0ZDQGn4y10nFMmcxCaYSppbZN0mHVYb9Up5hCsiFgkaIohNgk5zE
         NfwIkWnCZeM60RKaSjcTfVcvdPdeBWit+emqNfX4=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pasic@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, brijesh.singh@amd.com
Cc:     ehabkost@redhat.com, mtosatti@redhat.com, mst@redhat.com,
        jun.nakajima@intel.com, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, frankja@linux.ibm.com, andi.kleen@intel.com,
        cohuck@redhat.com, Thomas Huth <thuth@redhat.com>,
        borntraeger@de.ibm.com, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        qemu-ppc@nongnu.org, David Hildenbrand <david@redhat.com>,
        Greg Kurz <groug@kaod.org>, pragyansri.pathi@intel.com,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PULL v9 06/13] sev: Add Error ** to sev_kvm_init()
Date:   Mon,  8 Feb 2021 17:05:31 +1100
Message-Id: <20210208060538.39276-7-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208060538.39276-1-david@gibson.dropbear.id.au>
References: <20210208060538.39276-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows failures to be reported richly and idiomatically.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 accel/kvm/kvm-all.c  |  4 +++-
 accel/kvm/sev-stub.c |  2 +-
 include/sysemu/sev.h |  2 +-
 target/i386/sev.c    | 31 +++++++++++++++----------------
 4 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 88a6b8c19e..226e1556f9 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2185,9 +2185,11 @@ static int kvm_init(MachineState *ms)
      * encryption context.
      */
     if (ms->cgs) {
+        Error *local_err = NULL;
         /* FIXME handle mechanisms other than SEV */
-        ret = sev_kvm_init(ms->cgs);
+        ret = sev_kvm_init(ms->cgs, &local_err);
         if (ret < 0) {
+            error_report_err(local_err);
             goto err;
         }
     }
diff --git a/accel/kvm/sev-stub.c b/accel/kvm/sev-stub.c
index 3d4787ae4a..512e205f7f 100644
--- a/accel/kvm/sev-stub.c
+++ b/accel/kvm/sev-stub.c
@@ -15,7 +15,7 @@
 #include "qemu-common.h"
 #include "sysemu/sev.h"
 
-int sev_kvm_init(ConfidentialGuestSupport *cgs)
+int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     /* SEV can't be selected if it's not compiled */
     g_assert_not_reached();
diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
index 3b5b1aacf1..5c5a13c6ca 100644
--- a/include/sysemu/sev.h
+++ b/include/sysemu/sev.h
@@ -16,7 +16,7 @@
 
 #include "sysemu/kvm.h"
 
-int sev_kvm_init(ConfidentialGuestSupport *cgs);
+int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
 int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
 int sev_inject_launch_secret(const char *hdr, const char *secret,
                              uint64_t gpa, Error **errp);
diff --git a/target/i386/sev.c b/target/i386/sev.c
index fa962d533c..590cb31fa8 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -662,7 +662,7 @@ sev_vm_state_change(void *opaque, int running, RunState state)
     }
 }
 
-int sev_kvm_init(ConfidentialGuestSupport *cgs)
+int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     SevGuestState *sev = SEV_GUEST(cgs);
     char *devname;
@@ -684,14 +684,14 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs)
     host_cbitpos = ebx & 0x3f;
 
     if (host_cbitpos != sev->cbitpos) {
-        error_report("%s: cbitpos check failed, host '%d' requested '%d'",
-                     __func__, host_cbitpos, sev->cbitpos);
+        error_setg(errp, "%s: cbitpos check failed, host '%d' requested '%d'",
+                   __func__, host_cbitpos, sev->cbitpos);
         goto err;
     }
 
     if (sev->reduced_phys_bits < 1) {
-        error_report("%s: reduced_phys_bits check failed, it should be >=1,"
-                     " requested '%d'", __func__, sev->reduced_phys_bits);
+        error_setg(errp, "%s: reduced_phys_bits check failed, it should be >=1,"
+                   " requested '%d'", __func__, sev->reduced_phys_bits);
         goto err;
     }
 
@@ -700,20 +700,19 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs)
     devname = object_property_get_str(OBJECT(sev), "sev-device", NULL);
     sev->sev_fd = open(devname, O_RDWR);
     if (sev->sev_fd < 0) {
-        error_report("%s: Failed to open %s '%s'", __func__,
-                     devname, strerror(errno));
-    }
-    g_free(devname);
-    if (sev->sev_fd < 0) {
+        error_setg(errp, "%s: Failed to open %s '%s'", __func__,
+                   devname, strerror(errno));
+        g_free(devname);
         goto err;
     }
+    g_free(devname);
 
     ret = sev_platform_ioctl(sev->sev_fd, SEV_PLATFORM_STATUS, &status,
                              &fw_error);
     if (ret) {
-        error_report("%s: failed to get platform status ret=%d "
-                     "fw_error='%d: %s'", __func__, ret, fw_error,
-                     fw_error_to_str(fw_error));
+        error_setg(errp, "%s: failed to get platform status ret=%d "
+                   "fw_error='%d: %s'", __func__, ret, fw_error,
+                   fw_error_to_str(fw_error));
         goto err;
     }
     sev->build_id = status.build;
@@ -723,14 +722,14 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs)
     trace_kvm_sev_init();
     ret = sev_ioctl(sev->sev_fd, KVM_SEV_INIT, NULL, &fw_error);
     if (ret) {
-        error_report("%s: failed to initialize ret=%d fw_error=%d '%s'",
-                     __func__, ret, fw_error, fw_error_to_str(fw_error));
+        error_setg(errp, "%s: failed to initialize ret=%d fw_error=%d '%s'",
+                   __func__, ret, fw_error, fw_error_to_str(fw_error));
         goto err;
     }
 
     ret = sev_launch_start(sev);
     if (ret) {
-        error_report("%s: failed to create encryption context", __func__);
+        error_setg(errp, "%s: failed to create encryption context", __func__);
         goto err;
     }
 
-- 
2.29.2

