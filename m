Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7D21DC5D5
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 05:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgEUDnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 23:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728224AbgEUDnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 23:43:16 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D624C061A0E
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 20:43:16 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49SFnr6g2mz9sTS; Thu, 21 May 2020 13:43:12 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1590032592;
        bh=M+eXnJW1btziN4G5uNLQz37je7bEajAkkFSb+aa7K24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AENwXPgM3o2mrp3sS7zPYmSBF/8anerUXVNQPs5uVXFDn8EyJJhXEqi4VkHd0KqOv
         6m/sMcCkNAFxRrKBOxheict5WSLXJh58UG4TXmTVRMmenMr3W73InyJ07jwtHgT0rR
         Sgt/OYUwSTN4V/5UmjcoBEudbhL31PQrN1kahEdM=
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
Subject: [RFC v2 06/18] target/i386: sev: Remove redundant cbitpos and reduced_phys_bits fields
Date:   Thu, 21 May 2020 13:42:52 +1000
Message-Id: <20200521034304.340040-7-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEVState structure has cbitpos and reduced_phys_bits fields which are
simply copied from the SevGuestState structure and never changed.  Now that
SEVState is embedded in SevGuestState we can just access the original copy
directly.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 target/i386/sev.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 9e8ab7b056..d25af37136 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -41,8 +41,6 @@ struct SEVState {
     uint8_t build_id;
     uint32_t policy;
     uint64_t me_mask;
-    uint32_t cbitpos;
-    uint32_t reduced_phys_bits;
     uint32_t handle;
     int sev_fd;
     SevState state;
@@ -378,13 +376,13 @@ sev_get_me_mask(void)
 uint32_t
 sev_get_cbit_position(void)
 {
-    return sev_guest ? sev_guest->state.cbitpos : 0;
+    return sev_guest ? sev_guest->cbitpos : 0;
 }
 
 uint32_t
 sev_get_reduced_phys_bits(void)
 {
-    return sev_guest ? sev_guest->state.reduced_phys_bits : 0;
+    return sev_guest ? sev_guest->reduced_phys_bits : 0;
 }
 
 SevInfo *
@@ -713,22 +711,19 @@ sev_guest_init(const char *id)
     host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
     host_cbitpos = ebx & 0x3f;
 
-    s->cbitpos = object_property_get_int(OBJECT(sev), "cbitpos", NULL);
-    if (host_cbitpos != s->cbitpos) {
+    if (host_cbitpos != sev->cbitpos) {
         error_report("%s: cbitpos check failed, host '%d' requested '%d'",
-                     __func__, host_cbitpos, s->cbitpos);
+                     __func__, host_cbitpos, sev->cbitpos);
         goto err;
     }
 
-    s->reduced_phys_bits = object_property_get_int(OBJECT(sev),
-                                        "reduced-phys-bits", NULL);
-    if (s->reduced_phys_bits < 1) {
+    if (sev->reduced_phys_bits < 1) {
         error_report("%s: reduced_phys_bits check failed, it should be >=1,"
-                     " requested '%d'", __func__, s->reduced_phys_bits);
+                     " requested '%d'", __func__, sev->reduced_phys_bits);
         goto err;
     }
 
-    s->me_mask = ~(1UL << s->cbitpos);
+    s->me_mask = ~(1UL << sev->cbitpos);
 
     devname = object_property_get_str(OBJECT(sev), "sev-device", NULL);
     s->sev_fd = open(devname, O_RDWR);
-- 
2.26.2

