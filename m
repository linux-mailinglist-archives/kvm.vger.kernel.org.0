Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3338C1DC5D6
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 05:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgEUDnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 23:43:46 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57597 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728193AbgEUDnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 23:43:15 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49SFns1NXdz9sTT; Thu, 21 May 2020 13:43:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1590032593;
        bh=d27Ffc+UM25I6jMKKixH/o4N+rS/wECOugs7Ml/AULE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyyiKIgRv8Sa41xtepCYVJluBW+AhLBvINnbN87OdeeyM3yp4/39vXYbVeNhQymmh
         w9h5HFnBxqtFma/Dgw4COf4HOWHWO0y7kNHNCWwxUKEF0NL/sue/3Cjot/cnJ24R8g
         0hCZAyi+kNc4RRVPYdd1yxxpob8XWUeWxID41pRw=
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
Subject: [RFC v2 08/18] target/i386: sev: Remove redundant handle field
Date:   Thu, 21 May 2020 13:42:54 +1000
Message-Id: <20200521034304.340040-9-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
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
index 4b261beaa7..24e2dea9b8 100644
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
 
@@ -398,7 +397,7 @@ sev_get_info(void)
         info->build_id = sev_guest->state.build_id;
         info->policy = sev_guest->policy;
         info->state = sev_guest->state.state;
-        info->handle = sev_guest->state.handle;
+        info->handle = sev_guest->handle;
     }
 
     return info;
@@ -517,8 +516,7 @@ sev_launch_start(SevGuestState *sev)
 
     start = g_new0(struct kvm_sev_launch_start, 1);
 
-    start->handle = object_property_get_int(OBJECT(sev), "handle",
-                                            &error_abort);
+    start->handle = sev->handle;
     start->policy = sev->policy;
     if (sev->session_file) {
         if (sev_read_file_base64(sev->session_file, &session, &sz) < 0) {
@@ -544,10 +542,8 @@ sev_launch_start(SevGuestState *sev)
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

