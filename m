Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F241DC5C9
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 05:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgEUDna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 23:43:30 -0400
Received: from ozlabs.org ([203.11.71.1]:55071 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728293AbgEUDnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 23:43:21 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49SFnt57zsz9sVF; Thu, 21 May 2020 13:43:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1590032594;
        bh=eup3iyYUWnuqB9PIhUENkDwPcTYFDbBI7Pm2SOCB26g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNlximYBa0hlzRkqewPUvqQcL4/R29JENQCQDo/w2gabH//RHCoafExY6olBai97u
         dBQwRafjSrUt1N7sGl4TCztWSHVjBRgZF3YIvdHrb5leAvrL2fd0eMZZRQFV5J5kPj
         /BTpeFjCzuO4WBH9PcgTwAQYVEQ4Kou+DlBjYV8c=
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
Subject: [RFC v2 16/18] guest memory protection: Add Error ** to GuestMemoryProtection::kvm_init
Date:   Thu, 21 May 2020 13:43:02 +1000
Message-Id: <20200521034304.340040-17-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows failures to be reported richly and idiomatically.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 accel/kvm/kvm-all.c                    |  4 +++-
 include/exec/guest-memory-protection.h |  2 +-
 target/i386/sev.c                      | 31 +++++++++++++-------------
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 1b10e94222..4011699736 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2079,9 +2079,11 @@ static int kvm_init(MachineState *ms)
     if (ms->gmpo) {
         GuestMemoryProtectionClass *gmpc =
             GUEST_MEMORY_PROTECTION_GET_CLASS(ms->gmpo);
+        Error *local_err = NULL;
 
-        ret = gmpc->kvm_init(ms->gmpo);
+        ret = gmpc->kvm_init(ms->gmpo, &local_err);
         if (ret < 0) {
+            error_report_err(local_err);
             goto err;
         }
     }
diff --git a/include/exec/guest-memory-protection.h b/include/exec/guest-memory-protection.h
index 7d959b4910..2a88475136 100644
--- a/include/exec/guest-memory-protection.h
+++ b/include/exec/guest-memory-protection.h
@@ -32,7 +32,7 @@ typedef struct GuestMemoryProtection GuestMemoryProtection;
 typedef struct GuestMemoryProtectionClass {
     InterfaceClass parent;
 
-    int (*kvm_init)(GuestMemoryProtection *);
+    int (*kvm_init)(GuestMemoryProtection *, Error **);
     int (*encrypt_data)(GuestMemoryProtection *, uint8_t *, uint64_t);
 } GuestMemoryProtectionClass;
 
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 60e9d8c735..6a56ec203b 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -617,7 +617,7 @@ sev_vm_state_change(void *opaque, int running, RunState state)
     }
 }
 
-static int sev_kvm_init(GuestMemoryProtection *gmpo)
+static int sev_kvm_init(GuestMemoryProtection *gmpo, Error **errp)
 {
     SevGuestState *sev = SEV_GUEST(gmpo);
     char *devname;
@@ -633,14 +633,14 @@ static int sev_kvm_init(GuestMemoryProtection *gmpo)
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
 
@@ -649,20 +649,19 @@ static int sev_kvm_init(GuestMemoryProtection *gmpo)
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
@@ -672,14 +671,14 @@ static int sev_kvm_init(GuestMemoryProtection *gmpo)
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
2.26.2

