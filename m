Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CEF1D2803
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgENGli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:38 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:41639 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbgENGlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 02:41:35 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24m2Kcgz9sTv; Thu, 14 May 2020 16:41:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438488;
        bh=xjHDg8Z3iGOs6YznvRxJzwX+DfrCk0xxIpH+LyqX4Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFtidWvgRhBxe0rjuuQ3Dk9h6baNyRMxiT+z2dwQi9B9B7R5Sk1CzytiwgfOOU//X
         YhbOAvJaTGcH0Su6+unQzr+t/haGZnpfOeVeAymWY7+ehSXGuJr/mrm24L7joDTtWV
         y7o5WR/T5CP1GKdoxkUGaLQH8v2TtAclt/ed38TQ=
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
Subject: [RFC 16/18] use errp for gmpo kvm_init
Date:   Thu, 14 May 2020 16:41:18 +1000
Message-Id: <20200514064120.449050-17-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514064120.449050-1-david@gibson.dropbear.id.au>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

---
 accel/kvm/kvm-all.c                    |  4 +++-
 include/exec/guest-memory-protection.h |  2 +-
 target/i386/sev.c                      | 32 +++++++++++++-------------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 5451728425..392ab02867 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2045,9 +2045,11 @@ static int kvm_init(MachineState *ms)
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
index 2051fae0c1..82f16b2f3b 100644
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
 
@@ -649,20 +649,20 @@ static int sev_kvm_init(GuestMemoryProtection *gmpo)
     devname = object_property_get_str(OBJECT(sev), "sev-device", NULL);
     sev->sev_fd = open(devname, O_RDWR);
     if (sev->sev_fd < 0) {
-        error_report("%s: Failed to open %s '%s'", __func__,
-                     devname, strerror(errno));
-    }
-    g_free(devname);
-    if (sev->sev_fd < 0) {
+        g_free(devname);
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
@@ -672,14 +672,14 @@ static int sev_kvm_init(GuestMemoryProtection *gmpo)
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

