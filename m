Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072AC1D27FC
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgENGla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725818AbgENGl3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 02:41:29 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA966C061A0C
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 23:41:29 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24j619Hz9sT5; Thu, 14 May 2020 16:41:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438485;
        bh=dpO+RDTJJnWPo3EBHZrvAdeYGFa/InNxOOFSk2e34ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tei7bRZYxQzXq2NYq+HfFeqtCPBeaZMZ/RuPd+hCYLuglITNmPT6VJbLU6FtJALFc
         AAFAcgRxUIJc/ZnBn5l5puAVISQAG0OftO/DYkqKuDnAEtOjAPcdiU6Dgfsw58P5R9
         ygMF64QY+Y+l6ehJ7dG6lgoF9BjZhf+ZXcbP4i2A=
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
Subject: [RFC 04/18] target/i386: sev: Embed SEVState in SevGuestState
Date:   Thu, 14 May 2020 16:41:06 +1000
Message-Id: <20200514064120.449050-5-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514064120.449050-1-david@gibson.dropbear.id.au>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently SevGuestState contains only configuration information.  For
runtime state another non-QOM struct SEVState is allocated separately.

Simplify things by instead embedding the SEVState structure in
SevGuestState.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 target/i386/sev.c | 54 +++++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 0f7abe134a..89138a7507 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -35,6 +35,22 @@
 
 typedef struct SevGuestState SevGuestState;
 
+struct SEVState {
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
 /**
  * SevGuestState:
  *
@@ -48,6 +64,7 @@ typedef struct SevGuestState SevGuestState;
 struct SevGuestState {
     Object parent_obj;
 
+    /* configuration parameters */
     char *sev_device;
     uint32_t policy;
     uint32_t handle;
@@ -55,25 +72,11 @@ struct SevGuestState {
     char *session_file;
     uint32_t cbitpos;
     uint32_t reduced_phys_bits;
-};
 
-struct SEVState {
-    SevGuestState *sev_info;
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
+    /* runtime state */
+    SEVState state;
 };
 
-typedef struct SEVState SEVState;
-
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
 
@@ -509,12 +512,12 @@ sev_read_file_base64(const char *filename, guchar **data, gsize *len)
 }
 
 static int
-sev_launch_start(SEVState *s)
+sev_launch_start(SevGuestState *sev)
 {
+    SEVState *s = &sev->state;
     gsize sz;
     int ret = 1;
     int fw_error, rc;
-    SevGuestState *sev = s->sev_info;
     struct kvm_sev_launch_start *start;
     guchar *session = NULL, *dh_cert = NULL;
 
@@ -689,6 +692,7 @@ sev_vm_state_change(void *opaque, int running, RunState state)
 void *
 sev_guest_init(const char *id)
 {
+    SevGuestState *sev;
     SEVState *s;
     char *devname;
     int ret, fw_error;
@@ -696,27 +700,27 @@ sev_guest_init(const char *id)
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
 
-    sev_state = s = g_new0(SEVState, 1);
-    s->sev_info = lookup_sev_guest_info(id);
-    if (!s->sev_info) {
+    sev = lookup_sev_guest_info(id);
+    if (!sev) {
         error_report("%s: '%s' is not a valid '%s' object",
                      __func__, id, TYPE_SEV_GUEST);
         goto err;
     }
 
+    sev_state = s = &sev->state;
     s->state = SEV_STATE_UNINIT;
 
     host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
     host_cbitpos = ebx & 0x3f;
 
-    s->cbitpos = object_property_get_int(OBJECT(s->sev_info), "cbitpos", NULL);
+    s->cbitpos = object_property_get_int(OBJECT(sev), "cbitpos", NULL);
     if (host_cbitpos != s->cbitpos) {
         error_report("%s: cbitpos check failed, host '%d' requested '%d'",
                      __func__, host_cbitpos, s->cbitpos);
         goto err;
     }
 
-    s->reduced_phys_bits = object_property_get_int(OBJECT(s->sev_info),
+    s->reduced_phys_bits = object_property_get_int(OBJECT(sev),
                                         "reduced-phys-bits", NULL);
     if (s->reduced_phys_bits < 1) {
         error_report("%s: reduced_phys_bits check failed, it should be >=1,"
@@ -726,7 +730,7 @@ sev_guest_init(const char *id)
 
     s->me_mask = ~(1UL << s->cbitpos);
 
-    devname = object_property_get_str(OBJECT(s->sev_info), "sev-device", NULL);
+    devname = object_property_get_str(OBJECT(sev), "sev-device", NULL);
     s->sev_fd = open(devname, O_RDWR);
     if (s->sev_fd < 0) {
         error_report("%s: Failed to open %s '%s'", __func__,
@@ -757,7 +761,7 @@ sev_guest_init(const char *id)
         goto err;
     }
 
-    ret = sev_launch_start(s);
+    ret = sev_launch_start(sev);
     if (ret) {
         error_report("%s: failed to create encryption context", __func__);
         goto err;
-- 
2.26.2

