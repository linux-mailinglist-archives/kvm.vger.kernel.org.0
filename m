Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4302F22BC31
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 04:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgGXC5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 22:57:55 -0400
Received: from ozlabs.org ([203.11.71.1]:49133 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgGXC5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 22:57:53 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BCYlw00Rzz9sTF; Fri, 24 Jul 2020 12:57:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1595559468;
        bh=xgmDQa3udk5W0XmmFTnrKQDvJ/BjSvIb0v09eBORE70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGBTdOPiL8Nuu2cNvQr4R0hIaMZJWJVN7ZYOOU1+Jy0huQdGQy/w2e1zDJi8inGMI
         sfXsFRM+wueL5uASQSTxss6FU3dO287ugy3GwG20FzTIJmZBhmgeHhy9l/aCGLs3To
         iO87zT9VzxIzMNoBplOdxlcOc+iAP26IC9fuwfF0=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, brijesh.singh@amd.com
Cc:     ehabkost@redhat.com, marcel.apfelbaum@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, pasic@linux.ibm.com, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [for-5.2 v4 06/10] host trust limitation: Add Error ** to HostTrustLimitation::kvm_init
Date:   Fri, 24 Jul 2020 12:57:40 +1000
Message-Id: <20200724025744.69644-7-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200724025744.69644-1-david@gibson.dropbear.id.au>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
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
index 4b6402c12c..3f98c6be7c 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2164,9 +2164,11 @@ static int kvm_init(MachineState *ms)
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
index 8e3c9dcc2c..0d06976da5 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -626,7 +626,7 @@ sev_vm_state_change(void *opaque, int running, RunState state)
     }
 }
 
-static int sev_kvm_init(HostTrustLimitation *htl)
+static int sev_kvm_init(HostTrustLimitation *htl, Error **errp)
 {
     SevGuestState *sev = SEV_GUEST(htl);
     char *devname;
@@ -648,14 +648,14 @@ static int sev_kvm_init(HostTrustLimitation *htl)
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
 
@@ -664,20 +664,19 @@ static int sev_kvm_init(HostTrustLimitation *htl)
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
@@ -687,14 +686,14 @@ static int sev_kvm_init(HostTrustLimitation *htl)
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

