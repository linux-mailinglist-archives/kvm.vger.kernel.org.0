Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A931D2806
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgENGld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726067AbgENGla (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 02:41:30 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B65C061A0C
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 23:41:30 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24j71lsz9sTG; Thu, 14 May 2020 16:41:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438485;
        bh=/Ppp1Hg0PYOGnrJ3d5TwbRjen9cW9muDcSCpWcuUnTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2S98DCeeZBCqspC1x4qQ3iJlkJjpeWHuXYoz0SsurRJ1MJG++EmbJ9y0pFNrzOq9
         X2QyUL5uy2/GJv/+b8jKXYKYHNKMXYcCAiG3qQ6zBUGTpa95hOzqa/CfS8ycwdsliE
         kf4TtW4sDC5kGrI1MD4a8qseYUPkzBSIdt3Sya40=
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
Subject: [RFC 06/18] target/i386: sev: Remove redundant cbitpos and reduced_phys_bits fields
Date:   Thu, 14 May 2020 16:41:08 +1000
Message-Id: <20200514064120.449050-7-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514064120.449050-1-david@gibson.dropbear.id.au>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
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
index 5f0c38da95..c85f59d78f 100644
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
@@ -381,13 +379,13 @@ sev_get_me_mask(void)
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
@@ -716,22 +714,19 @@ sev_guest_init(const char *id)
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

