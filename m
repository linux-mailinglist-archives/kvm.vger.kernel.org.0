Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06BDB62B3
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 14:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbfIRMEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 08:04:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33903 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730555AbfIRMEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 08:04:41 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B69F30ADBA7;
        Wed, 18 Sep 2019 12:04:41 +0000 (UTC)
Received: from thuth.com (ovpn-116-90.ams2.redhat.com [10.36.116.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6C52600C8;
        Wed, 18 Sep 2019 12:04:39 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 3/9] s390x: Move stsi to library
Date:   Wed, 18 Sep 2019 14:04:20 +0200
Message-Id: <20190918120426.20832-4-thuth@redhat.com>
In-Reply-To: <20190918120426.20832-1-thuth@redhat.com>
References: <20190918120426.20832-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 18 Sep 2019 12:04:41 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

It's needed in multiple tests now.
Return value changes from 0/-1 to the cc.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20190826163502.1298-4-frankja@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h | 16 ++++++++++++++++
 s390x/skey.c             | 18 ------------------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 4bbb428..5f8f45e 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -240,4 +240,20 @@ static inline void enter_pstate(void)
 	load_psw_mask(mask);
 }
 
+static inline int stsi(void *addr, int fc, int sel1, int sel2)
+{
+	register int r0 asm("0") = (fc << 28) | sel1;
+	register int r1 asm("1") = sel2;
+	int cc;
+
+	asm volatile(
+		"stsi	0(%3)\n"
+		"ipm	%[cc]\n"
+		"srl	%[cc],28\n"
+		: "+d" (r0), [cc] "=d" (cc)
+		: "d" (r1), "a" (addr)
+		: "cc", "memory");
+	return cc;
+}
+
 #endif
diff --git a/s390x/skey.c b/s390x/skey.c
index b1e11af..fd4fcc7 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -70,24 +70,6 @@ static void test_set(void)
 	       skey.str.acc == ret.str.acc && skey.str.fp == ret.str.fp);
 }
 
-static inline int stsi(void *addr, int fc, int sel1, int sel2)
-{
-	register int r0 asm("0") = (fc << 28) | sel1;
-	register int r1 asm("1") = sel2;
-	int rc = 0;
-
-	asm volatile(
-		"	stsi	0(%3)\n"
-		"	jz	0f\n"
-		"	lhi	%1,-1\n"
-		"0:\n"
-		: "+d" (r0), "+d" (rc)
-		: "d" (r1), "a" (addr)
-		: "cc", "memory");
-
-	return rc;
-}
-
 /* Returns true if we are running under z/VM 6.x */
 static bool check_for_zvm6(void)
 {
-- 
2.18.1

