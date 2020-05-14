Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D935D1D2809
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgENGlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726076AbgENGlb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 02:41:31 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C4BC061A0C
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 23:41:30 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24k27wDz9sTJ; Thu, 14 May 2020 16:41:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438486;
        bh=bQT71TWKX3NCB/UFODTabObDYIiXDrv2Y5gD3qwpA3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rw1/cFDQ3MC1VR/RKnxArcfl31iMmNtUT4KkItUbHWp98kS3hXwTC0+kH+2OdvU8b
         FXESPJlJ/Z3/rtVTwWtOXFMsV6sUQ+erbcXmRIUBir+RfKJlaPUcSJXutLOsIN/WAV
         hkM0XVKyidOMBf8nh+JxM3p0Tp5x1W2Nf1cK0BOI=
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
Subject: [RFC 08/18] target/i386: sev: Remove redundant handle field
Date:   Thu, 14 May 2020 16:41:10 +1000
Message-Id: <20200514064120.449050-9-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514064120.449050-1-david@gibson.dropbear.id.au>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The user can explicitly specify a handle via the "handle" property wired
to SevGuestState::handle.  That gets passed to the KVM_SEV_LAUNCH_START
ioctl() which may update it, the final value being copied back to both
SevGuestState::handle and SEVState::handle.

AFAICT, nothing will be looking SEVState::handle before it and
SevGuestState::handle have been updated from the ioctl().  So, remove the
field and just use SevGuestState::handle directly.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 target/i386/sev.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 1ba05cd2a6..11034ed356 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -40,7 +40,6 @@ struct SEVState {
     uint8_t api_minor;
     uint8_t build_id;
     uint64_t me_mask;
-    uint32_t handle;
     int sev_fd;
     SevState state;
     gchar *measurement;
@@ -64,13 +63,13 @@ struct SevGuestState {
     /* configuration parameters */
     char *sev_device;
     uint32_t policy;
-    uint32_t handle;
     char *dh_cert_file;
     char *session_file;
     uint32_t cbitpos;
     uint32_t reduced_phys_bits;
 
     /* runtime state */
+    uint32_t handle;
     SEVState state;
 };
 
@@ -401,7 +400,7 @@ sev_get_info(void)
         info->build_id = sev_guest->state.build_id;
         info->policy = sev_guest->policy;
         info->state = sev_guest->state.state;
-        info->handle = sev_guest->state.handle;
+        info->handle = sev_guest->handle;
     }
 
     return info;
@@ -520,8 +519,7 @@ sev_launch_start(SevGuestState *sev)
 
     start = g_new0(struct kvm_sev_launch_start, 1);
 
-    start->handle = object_property_get_int(OBJECT(sev), "handle",
-                                            &error_abort);
+    start->handle = sev->handle;
     start->policy = sev->policy;
     if (sev->session_file) {
         if (sev_read_file_base64(sev->session_file, &session, &sz) < 0) {
@@ -547,10 +545,8 @@ sev_launch_start(SevGuestState *sev)
         goto out;
     }
 
-    object_property_set_int(OBJECT(sev), start->handle, "handle",
-                            &error_abort);
     sev_set_guest_state(sev, SEV_STATE_LAUNCH_UPDATE);
-    s->handle = start->handle;
+    sev->handle = start->handle;
     ret = 0;
 
 out:
-- 
2.26.2

