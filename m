Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6E72F56D5
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbhANBxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729683AbhAMX7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 18:59:08 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9A1C0617A4
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 15:58:23 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DGPXQ66Hrz9sWX; Thu, 14 Jan 2021 10:58:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610582294;
        bh=Dv66XL0Xu5XiFw4ZQdSY1TGdKn45Up+V2jY+iQE5wYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JdKn1pyUgh8JG5peE6mRyJ64v8KTjhz72BvdOgs5QU/LfMlPjPuWaw8GqxGDlCXqq
         3SWntlvSbE+ZZfh0iqWAKIyw0C0KCBeYMTMAuY5p2+wLto1rqq5NSs4Nt/JYMwaXuf
         k0ewiEFCG4zhlVaFaS/0U7y7gmboRPSLhFpjQyJs=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org
Cc:     cohuck@redhat.com,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@de.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>,
        berrange@redhat.com, andi.kleen@intel.com,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v7 06/13] sev: Add Error ** to sev_kvm_init()
Date:   Thu, 14 Jan 2021 10:58:04 +1100
Message-Id: <20210113235811.1909610-7-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
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
index 28ab126f70..c5b0750fd0 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2182,9 +2182,11 @@ static int kvm_init(MachineState *ms)
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
index 5399a136ad..e2b41ef342 100644
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

