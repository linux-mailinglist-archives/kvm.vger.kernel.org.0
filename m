Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0515A1D280E
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgENGl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:29 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42297 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgENGl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 02:41:29 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24j5GCVz9sSw; Thu, 14 May 2020 16:41:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438485;
        bh=4iK55x5nbEBfmBq+1jTmMiSPazlH1pv/Q1o85gYQHAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nf9kop+FcMKKPLbXlq8ZQ690wU5UBrbHBC7fNd4Z5oOYC7tVyn4Q2stYfQVO1wOcj
         4xT76IDPFEzo8ZWjYrHz1s/u+31wuszzxgt4wbK/8Lf9IqYMPnLzMwQrDz8DdQBnB7
         9g4vEauY8G8/mGmdH1mg9A2qQCyPvn+vhs7FWIHs=
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
Subject: [RFC 05/18] target/i386: sev: Partial cleanup to sev_state global
Date:   Thu, 14 May 2020 16:41:07 +1000
Message-Id: <20200514064120.449050-6-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514064120.449050-1-david@gibson.dropbear.id.au>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV code uses a pretty ugly global to access its internal state.  Now
that SEVState is embedded in SevGuestState, we can avoid accessing it via
the global in some cases.  In the remaining cases use a new global
referencing the containing SevGuestState which will simplify some future
transformations.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 target/i386/sev.c | 92 ++++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 44 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 89138a7507..5f0c38da95 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -80,7 +80,7 @@ struct SevGuestState {
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
 
-static SEVState *sev_state;
+static SevGuestState *sev_guest;
 static Error *sev_mig_blocker;
 
 static const char *const sev_fw_errlist[] = {
@@ -159,21 +159,21 @@ fw_error_to_str(int code)
 }
 
 static bool
-sev_check_state(SevState state)
+sev_check_state(const SevGuestState *sev, SevState state)
 {
-    assert(sev_state);
-    return sev_state->state == state ? true : false;
+    assert(sev);
+    return sev->state.state == state ? true : false;
 }
 
 static void
-sev_set_guest_state(SevState new_state)
+sev_set_guest_state(SevGuestState *sev, SevState new_state)
 {
     assert(new_state < SEV_STATE__MAX);
-    assert(sev_state);
+    assert(sev);
 
-    trace_kvm_sev_change_state(SevState_str(sev_state->state),
+    trace_kvm_sev_change_state(SevState_str(sev->state.state),
                                SevState_str(new_state));
-    sev_state->state = new_state;
+    sev->state.state = new_state;
 }
 
 static void
@@ -369,25 +369,25 @@ lookup_sev_guest_info(const char *id)
 bool
 sev_enabled(void)
 {
-    return sev_state ? true : false;
+    return !!sev_guest;
 }
 
 uint64_t
 sev_get_me_mask(void)
 {
-    return sev_state ? sev_state->me_mask : ~0;
+    return sev_guest ? sev_guest->state.me_mask : ~0;
 }
 
 uint32_t
 sev_get_cbit_position(void)
 {
-    return sev_state ? sev_state->cbitpos : 0;
+    return sev_guest ? sev_guest->state.cbitpos : 0;
 }
 
 uint32_t
 sev_get_reduced_phys_bits(void)
 {
-    return sev_state ? sev_state->reduced_phys_bits : 0;
+    return sev_guest ? sev_guest->state.reduced_phys_bits : 0;
 }
 
 SevInfo *
@@ -396,15 +396,15 @@ sev_get_info(void)
     SevInfo *info;
 
     info = g_new0(SevInfo, 1);
-    info->enabled = sev_state ? true : false;
+    info->enabled = sev_enabled();
 
     if (info->enabled) {
-        info->api_major = sev_state->api_major;
-        info->api_minor = sev_state->api_minor;
-        info->build_id = sev_state->build_id;
-        info->policy = sev_state->policy;
-        info->state = sev_state->state;
-        info->handle = sev_state->handle;
+        info->api_major = sev_guest->state.api_major;
+        info->api_minor = sev_guest->state.api_minor;
+        info->build_id = sev_guest->state.build_id;
+        info->policy = sev_guest->state.policy;
+        info->state = sev_guest->state.state;
+        info->handle = sev_guest->state.handle;
     }
 
     return info;
@@ -553,7 +553,7 @@ sev_launch_start(SevGuestState *sev)
 
     object_property_set_int(OBJECT(sev), start->handle, "handle",
                             &error_abort);
-    sev_set_guest_state(SEV_STATE_LAUNCH_UPDATE);
+    sev_set_guest_state(sev, SEV_STATE_LAUNCH_UPDATE);
     s->handle = start->handle;
     s->policy = start->policy;
     ret = 0;
@@ -566,7 +566,7 @@ out:
 }
 
 static int
-sev_launch_update_data(uint8_t *addr, uint64_t len)
+sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
 {
     int ret, fw_error;
     struct kvm_sev_launch_update_data update;
@@ -578,7 +578,7 @@ sev_launch_update_data(uint8_t *addr, uint64_t len)
     update.uaddr = (__u64)(unsigned long)addr;
     update.len = len;
     trace_kvm_sev_launch_update_data(addr, len);
-    ret = sev_ioctl(sev_state->sev_fd, KVM_SEV_LAUNCH_UPDATE_DATA,
+    ret = sev_ioctl(sev->state.sev_fd, KVM_SEV_LAUNCH_UPDATE_DATA,
                     &update, &fw_error);
     if (ret) {
         error_report("%s: LAUNCH_UPDATE ret=%d fw_error=%d '%s'",
@@ -591,19 +591,20 @@ sev_launch_update_data(uint8_t *addr, uint64_t len)
 static void
 sev_launch_get_measure(Notifier *notifier, void *unused)
 {
+    SevGuestState *sev = sev_guest;
     int ret, error;
     guchar *data;
-    SEVState *s = sev_state;
+    SEVState *s = &sev->state;
     struct kvm_sev_launch_measure *measurement;
 
-    if (!sev_check_state(SEV_STATE_LAUNCH_UPDATE)) {
+    if (!sev_check_state(sev, SEV_STATE_LAUNCH_UPDATE)) {
         return;
     }
 
     measurement = g_new0(struct kvm_sev_launch_measure, 1);
 
     /* query the measurement blob length */
-    ret = sev_ioctl(sev_state->sev_fd, KVM_SEV_LAUNCH_MEASURE,
+    ret = sev_ioctl(sev->state.sev_fd, KVM_SEV_LAUNCH_MEASURE,
                     measurement, &error);
     if (!measurement->len) {
         error_report("%s: LAUNCH_MEASURE ret=%d fw_error=%d '%s'",
@@ -615,7 +616,7 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
     measurement->uaddr = (unsigned long)data;
 
     /* get the measurement blob */
-    ret = sev_ioctl(sev_state->sev_fd, KVM_SEV_LAUNCH_MEASURE,
+    ret = sev_ioctl(sev->state.sev_fd, KVM_SEV_LAUNCH_MEASURE,
                     measurement, &error);
     if (ret) {
         error_report("%s: LAUNCH_MEASURE ret=%d fw_error=%d '%s'",
@@ -623,7 +624,7 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
         goto free_data;
     }
 
-    sev_set_guest_state(SEV_STATE_LAUNCH_SECRET);
+    sev_set_guest_state(sev, SEV_STATE_LAUNCH_SECRET);
 
     /* encode the measurement value and emit the event */
     s->measurement = g_base64_encode(data, measurement->len);
@@ -638,9 +639,9 @@ free_measurement:
 char *
 sev_get_launch_measurement(void)
 {
-    if (sev_state &&
-        sev_state->state >= SEV_STATE_LAUNCH_SECRET) {
-        return g_strdup(sev_state->measurement);
+    if (sev_guest &&
+        sev_guest->state.state >= SEV_STATE_LAUNCH_SECRET) {
+        return g_strdup(sev_guest->state.measurement);
     }
 
     return NULL;
@@ -651,20 +652,21 @@ static Notifier sev_machine_done_notify = {
 };
 
 static void
-sev_launch_finish(SEVState *s)
+sev_launch_finish(SevGuestState *sev)
 {
+    SEVState *s = &sev->state;
     int ret, error;
     Error *local_err = NULL;
 
     trace_kvm_sev_launch_finish();
-    ret = sev_ioctl(sev_state->sev_fd, KVM_SEV_LAUNCH_FINISH, 0, &error);
+    ret = sev_ioctl(s->sev_fd, KVM_SEV_LAUNCH_FINISH, 0, &error);
     if (ret) {
         error_report("%s: LAUNCH_FINISH ret=%d fw_error=%d '%s'",
                      __func__, ret, error, fw_error_to_str(error));
         exit(1);
     }
 
-    sev_set_guest_state(SEV_STATE_RUNNING);
+    sev_set_guest_state(sev, SEV_STATE_RUNNING);
 
     /* add migration blocker */
     error_setg(&sev_mig_blocker,
@@ -680,11 +682,11 @@ sev_launch_finish(SEVState *s)
 static void
 sev_vm_state_change(void *opaque, int running, RunState state)
 {
-    SEVState *s = opaque;
+    SevGuestState *sev = opaque;
 
     if (running) {
-        if (!sev_check_state(SEV_STATE_RUNNING)) {
-            sev_launch_finish(s);
+        if (!sev_check_state(sev, SEV_STATE_RUNNING)) {
+            sev_launch_finish(sev);
         }
     }
 }
@@ -707,7 +709,8 @@ sev_guest_init(const char *id)
         goto err;
     }
 
-    sev_state = s = &sev->state;
+    sev_guest = sev;
+    s = &sev->state;
     s->state = SEV_STATE_UNINIT;
 
     host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
@@ -769,23 +772,24 @@ sev_guest_init(const char *id)
 
     ram_block_notifier_add(&sev_ram_notifier);
     qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
-    qemu_add_vm_change_state_handler(sev_vm_state_change, s);
+    qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
 
-    return s;
+    return sev;
 err:
-    g_free(sev_state);
-    sev_state = NULL;
+    sev_guest = NULL;
     return NULL;
 }
 
 int
 sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
 {
-    assert(handle);
+    SevGuestState *sev = handle;
+
+    assert(sev);
 
     /* if SEV is in update state then encrypt the data else do nothing */
-    if (sev_check_state(SEV_STATE_LAUNCH_UPDATE)) {
-        return sev_launch_update_data(ptr, len);
+    if (sev_check_state(sev, SEV_STATE_LAUNCH_UPDATE)) {
+        return sev_launch_update_data(sev, ptr, len);
     }
 
     return 0;
-- 
2.26.2

