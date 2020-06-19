Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF7B200007
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 04:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbgFSCGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 22:06:19 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59127 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729161AbgFSCGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 22:06:14 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49p2GT35rgz9sT8; Fri, 19 Jun 2020 12:06:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1592532369;
        bh=rKuvzP3I0zndPbCxEWAF/KYSFkgJfgyIKqNEdtPx2Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+8S4y1njyzLLozEwk54jAInltcAB7xtL2/XwnGGBQFN7qOQAQ0LZY3Evxk2yTYJd
         6bUkAK3fV2KpkTo/COE+7OTMowzQkzMykiAVXGhU7yVD8isuUojgXeq1Qi3x0BZowU
         tubDnZmwDpkophHRr3f8elKyeKGTHw6YoExLu9ag=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, dgilbert@redhat.com, frankja@linux.ibm.com
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, mdroth@linux.vnet.ibm.com,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        pasic@linux.ibm.com, Eduardo Habkost <ehabkost@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-s390x@nongnu.org, david@redhat.com,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 6/9] host trust limitation: Add Error ** to HostTrustLimitation::kvm_init
Date:   Fri, 19 Jun 2020 12:05:59 +1000
Message-Id: <20200619020602.118306-7-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619020602.118306-1-david@gibson.dropbear.id.au>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows failures to be reported richly and idiomatically.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/kvm/kvm-all.c                  |  4 +++-
 include/exec/host-trust-limitation.h |  2 +-
 target/i386/sev.c                    | 31 ++++++++++++++--------------
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 9645271ca5..c236ebeae0 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2158,9 +2158,11 @@ static int kvm_init(MachineState *ms)
     if (ms->htl) {
         HostTrustLimitationClass *htlc =
             HOST_TRUST_LIMITATION_GET_CLASS(ms->htl);
+        Error *local_err = NULL;
 
-        ret = htlc->kvm_init(ms->htl);
+        ret = htlc->kvm_init(ms->htl, &local_err);
         if (ret < 0) {
+            error_report_err(local_err);
             goto err;
         }
     }
diff --git a/include/exec/host-trust-limitation.h b/include/exec/host-trust-limitation.h
index fc30ea3f78..d93b537280 100644
--- a/include/exec/host-trust-limitation.h
+++ b/include/exec/host-trust-limitation.h
@@ -30,7 +30,7 @@
 typedef struct HostTrustLimitationClass {
     InterfaceClass parent;
 
-    int (*kvm_init)(HostTrustLimitation *);
+    int (*kvm_init)(HostTrustLimitation *, Error **);
     int (*encrypt_data)(HostTrustLimitation *, uint8_t *, uint64_t);
 } HostTrustLimitationClass;
 
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 052a05d15a..829f78436a 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -617,7 +617,7 @@ sev_vm_state_change(void *opaque, int running, RunState state)
     }
 }
 
-static int sev_kvm_init(HostTrustLimitation *htl)
+static int sev_kvm_init(HostTrustLimitation *htl, Error **errp)
 {
     SevGuestState *sev = SEV_GUEST(htl);
     char *devname;
@@ -633,14 +633,14 @@ static int sev_kvm_init(HostTrustLimitation *htl)
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
 
@@ -649,20 +649,19 @@ static int sev_kvm_init(HostTrustLimitation *htl)
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
@@ -672,14 +671,14 @@ static int sev_kvm_init(HostTrustLimitation *htl)
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

