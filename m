Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704A11DC5D2
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 05:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgEUDnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 23:43:42 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35413 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728115AbgEUDnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 23:43:17 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49SFns2x39z9sTd; Thu, 21 May 2020 13:43:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1590032593;
        bh=+6wORPXba/FHMuWdDdlY8yg4w9EvwoE0aoktBT1heY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTpAIsFI7q+M5+ao82y+YJsAqkvYesCjXshW160mqdR1noSQAf7IMLGYDSZQPBD6Z
         xT7K8payzDPaDc0Auz7il9JClDi1XZPZyCegrjY980TiN9CUjCLZTOm4Dl9fvwemF8
         vgVTxAohZs8Ftss9pVJon67zZUybVuFXaz4tAIs0=
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
Subject: [RFC v2 09/18] target/i386: sev: Unify SEVState and SevGuestState
Date:   Thu, 21 May 2020 13:42:55 +1000
Message-Id: <20200521034304.340040-10-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEVState is contained with SevGuestState.  We've now fixed redundancies
and name conflicts, so there's no real point to the nested structure.  Just
move all the fields of SEVState into SevGuestState.

This eliminates the SEVState structure, which as a bonus removes the
confusion with the SevState enum.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 target/i386/sev.c | 79 ++++++++++++++++++++---------------------------
 1 file changed, 34 insertions(+), 45 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 24e2dea9b8..d273174ad3 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -35,18 +35,6 @@
 
 typedef struct SevGuestState SevGuestState;
 
-struct SEVState {
-    uint8_t api_major;
-    uint8_t api_minor;
-    uint8_t build_id;
-    uint64_t me_mask;
-    int sev_fd;
-    SevState state;
-    gchar *measurement;
-};
-
-typedef struct SEVState SEVState;
-
 /**
  * SevGuestState:
  *
@@ -70,7 +58,13 @@ struct SevGuestState {
 
     /* runtime state */
     uint32_t handle;
-    SEVState state;
+    uint8_t api_major;
+    uint8_t api_minor;
+    uint8_t build_id;
+    uint64_t me_mask;
+    int sev_fd;
+    SevState state;
+    gchar *measurement;
 };
 
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
@@ -158,7 +152,7 @@ static bool
 sev_check_state(const SevGuestState *sev, SevState state)
 {
     assert(sev);
-    return sev->state.state == state ? true : false;
+    return sev->state == state ? true : false;
 }
 
 static void
@@ -167,9 +161,9 @@ sev_set_guest_state(SevGuestState *sev, SevState new_state)
     assert(new_state < SEV_STATE__MAX);
     assert(sev);
 
-    trace_kvm_sev_change_state(SevState_str(sev->state.state),
+    trace_kvm_sev_change_state(SevState_str(sev->state),
                                SevState_str(new_state));
-    sev->state.state = new_state;
+    sev->state = new_state;
 }
 
 static void
@@ -368,7 +362,7 @@ sev_enabled(void)
 uint64_t
 sev_get_me_mask(void)
 {
-    return sev_guest ? sev_guest->state.me_mask : ~0;
+    return sev_guest ? sev_guest->me_mask : ~0;
 }
 
 uint32_t
@@ -392,11 +386,11 @@ sev_get_info(void)
     info->enabled = sev_enabled();
 
     if (info->enabled) {
-        info->api_major = sev_guest->state.api_major;
-        info->api_minor = sev_guest->state.api_minor;
-        info->build_id = sev_guest->state.build_id;
+        info->api_major = sev_guest->api_major;
+        info->api_minor = sev_guest->api_minor;
+        info->build_id = sev_guest->build_id;
         info->policy = sev_guest->policy;
-        info->state = sev_guest->state.state;
+        info->state = sev_guest->state;
         info->handle = sev_guest->handle;
     }
 
@@ -507,7 +501,6 @@ sev_read_file_base64(const char *filename, guchar **data, gsize *len)
 static int
 sev_launch_start(SevGuestState *sev)
 {
-    SEVState *s = &sev->state;
     gsize sz;
     int ret = 1;
     int fw_error, rc;
@@ -535,7 +528,7 @@ sev_launch_start(SevGuestState *sev)
     }
 
     trace_kvm_sev_launch_start(start->policy, session, dh_cert);
-    rc = sev_ioctl(s->sev_fd, KVM_SEV_LAUNCH_START, start, &fw_error);
+    rc = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_START, start, &fw_error);
     if (rc < 0) {
         error_report("%s: LAUNCH_START ret=%d fw_error=%d '%s'",
                 __func__, ret, fw_error, fw_error_to_str(fw_error));
@@ -566,7 +559,7 @@ sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
     update.uaddr = (__u64)(unsigned long)addr;
     update.len = len;
     trace_kvm_sev_launch_update_data(addr, len);
-    ret = sev_ioctl(sev->state.sev_fd, KVM_SEV_LAUNCH_UPDATE_DATA,
+    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_UPDATE_DATA,
                     &update, &fw_error);
     if (ret) {
         error_report("%s: LAUNCH_UPDATE ret=%d fw_error=%d '%s'",
@@ -582,7 +575,6 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
     SevGuestState *sev = sev_guest;
     int ret, error;
     guchar *data;
-    SEVState *s = &sev->state;
     struct kvm_sev_launch_measure *measurement;
 
     if (!sev_check_state(sev, SEV_STATE_LAUNCH_UPDATE)) {
@@ -592,7 +584,7 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
     measurement = g_new0(struct kvm_sev_launch_measure, 1);
 
     /* query the measurement blob length */
-    ret = sev_ioctl(sev->state.sev_fd, KVM_SEV_LAUNCH_MEASURE,
+    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_MEASURE,
                     measurement, &error);
     if (!measurement->len) {
         error_report("%s: LAUNCH_MEASURE ret=%d fw_error=%d '%s'",
@@ -604,7 +596,7 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
     measurement->uaddr = (unsigned long)data;
 
     /* get the measurement blob */
-    ret = sev_ioctl(sev->state.sev_fd, KVM_SEV_LAUNCH_MEASURE,
+    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_MEASURE,
                     measurement, &error);
     if (ret) {
         error_report("%s: LAUNCH_MEASURE ret=%d fw_error=%d '%s'",
@@ -615,8 +607,8 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
     sev_set_guest_state(sev, SEV_STATE_LAUNCH_SECRET);
 
     /* encode the measurement value and emit the event */
-    s->measurement = g_base64_encode(data, measurement->len);
-    trace_kvm_sev_launch_measurement(s->measurement);
+    sev->measurement = g_base64_encode(data, measurement->len);
+    trace_kvm_sev_launch_measurement(sev->measurement);
 
 free_data:
     g_free(data);
@@ -628,8 +620,8 @@ char *
 sev_get_launch_measurement(void)
 {
     if (sev_guest &&
-        sev_guest->state.state >= SEV_STATE_LAUNCH_SECRET) {
-        return g_strdup(sev_guest->state.measurement);
+        sev_guest->state >= SEV_STATE_LAUNCH_SECRET) {
+        return g_strdup(sev_guest->measurement);
     }
 
     return NULL;
@@ -642,12 +634,11 @@ static Notifier sev_machine_done_notify = {
 static void
 sev_launch_finish(SevGuestState *sev)
 {
-    SEVState *s = &sev->state;
     int ret, error;
     Error *local_err = NULL;
 
     trace_kvm_sev_launch_finish();
-    ret = sev_ioctl(s->sev_fd, KVM_SEV_LAUNCH_FINISH, 0, &error);
+    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_FINISH, 0, &error);
     if (ret) {
         error_report("%s: LAUNCH_FINISH ret=%d fw_error=%d '%s'",
                      __func__, ret, error, fw_error_to_str(error));
@@ -683,7 +674,6 @@ void *
 sev_guest_init(const char *id)
 {
     SevGuestState *sev;
-    SEVState *s;
     char *devname;
     int ret, fw_error;
     uint32_t ebx;
@@ -698,8 +688,7 @@ sev_guest_init(const char *id)
     }
 
     sev_guest = sev;
-    s = &sev->state;
-    s->state = SEV_STATE_UNINIT;
+    sev->state = SEV_STATE_UNINIT;
 
     host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
     host_cbitpos = ebx & 0x3f;
@@ -716,20 +705,20 @@ sev_guest_init(const char *id)
         goto err;
     }
 
-    s->me_mask = ~(1UL << sev->cbitpos);
+    sev->me_mask = ~(1UL << sev->cbitpos);
 
     devname = object_property_get_str(OBJECT(sev), "sev-device", NULL);
-    s->sev_fd = open(devname, O_RDWR);
-    if (s->sev_fd < 0) {
+    sev->sev_fd = open(devname, O_RDWR);
+    if (sev->sev_fd < 0) {
         error_report("%s: Failed to open %s '%s'", __func__,
                      devname, strerror(errno));
     }
     g_free(devname);
-    if (s->sev_fd < 0) {
+    if (sev->sev_fd < 0) {
         goto err;
     }
 
-    ret = sev_platform_ioctl(s->sev_fd, SEV_PLATFORM_STATUS, &status,
+    ret = sev_platform_ioctl(sev->sev_fd, SEV_PLATFORM_STATUS, &status,
                              &fw_error);
     if (ret) {
         error_report("%s: failed to get platform status ret=%d "
@@ -737,12 +726,12 @@ sev_guest_init(const char *id)
                      fw_error_to_str(fw_error));
         goto err;
     }
-    s->build_id = status.build;
-    s->api_major = status.api_major;
-    s->api_minor = status.api_minor;
+    sev->build_id = status.build;
+    sev->api_major = status.api_major;
+    sev->api_minor = status.api_minor;
 
     trace_kvm_sev_init();
-    ret = sev_ioctl(s->sev_fd, KVM_SEV_INIT, NULL, &fw_error);
+    ret = sev_ioctl(sev->sev_fd, KVM_SEV_INIT, NULL, &fw_error);
     if (ret) {
         error_report("%s: failed to initialize ret=%d fw_error=%d '%s'",
                      __func__, ret, fw_error, fw_error_to_str(fw_error));
-- 
2.26.2

