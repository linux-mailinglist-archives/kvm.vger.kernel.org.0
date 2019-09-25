Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7169FBE2A3
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 18:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391867AbfIYQid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 12:38:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38138 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391845AbfIYQic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 12:38:32 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 17EE018CB8E7;
        Wed, 25 Sep 2019 16:38:32 +0000 (UTC)
Received: from thuth.com (ovpn-116-109.ams2.redhat.com [10.36.116.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0E1960BF1;
        Wed, 25 Sep 2019 16:38:30 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 15/17] s390x: Prepare for external calls
Date:   Wed, 25 Sep 2019 18:37:12 +0200
Message-Id: <20190925163714.27519-16-thuth@redhat.com>
In-Reply-To: <20190925163714.27519-1-thuth@redhat.com>
References: <20190925163714.27519-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Wed, 25 Sep 2019 16:38:32 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

With SMP we also get new external interrupts like external call and
emergency call. Let's make them known.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20190920080356.1948-6-frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h  |  5 +++++
 lib/s390x/asm/interrupt.h |  3 +++
 lib/s390x/interrupt.c     | 23 +++++++++++++++++++----
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index d5a7f51..96cca2e 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -19,6 +19,11 @@ struct psw {
 #define PSW_MASK_DAT			0x0400000000000000UL
 #define PSW_MASK_PSTATE			0x0001000000000000UL
 
+#define CR0_EXTM_SCLP			0X0000000000000200UL
+#define CR0_EXTM_EXTC			0X0000000000002000UL
+#define CR0_EXTM_EMGC			0X0000000000004000UL
+#define CR0_EXTM_MASK			0X0000000000006200UL
+
 struct lowcore {
 	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
 	uint32_t	ext_int_param;			/* 0x0080 */
diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index f485e96..4cfade9 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -11,6 +11,8 @@
 #define _ASMS390X_IRQ_H_
 #include <asm/arch_def.h>
 
+#define EXT_IRQ_EMERGENCY_SIG	0x1201
+#define EXT_IRQ_EXTERNAL_CALL	0x1202
 #define EXT_IRQ_SERVICE_SIG	0x2401
 
 void handle_pgm_int(void);
@@ -19,6 +21,7 @@ void handle_mcck_int(void);
 void handle_io_int(void);
 void handle_svc_int(void);
 void expect_pgm_int(void);
+void expect_ext_int(void);
 uint16_t clear_pgm_int(void);
 void check_pgm_int_code(uint16_t code);
 
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 7832711..5cade23 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -15,6 +15,7 @@
 #include <sclp.h>
 
 static bool pgm_int_expected;
+static bool ext_int_expected;
 static struct lowcore *lc;
 
 void expect_pgm_int(void)
@@ -24,6 +25,13 @@ void expect_pgm_int(void)
 	mb();
 }
 
+void expect_ext_int(void)
+{
+	ext_int_expected = true;
+	lc->ext_int_code = 0;
+	mb();
+}
+
 uint16_t clear_pgm_int(void)
 {
 	uint16_t code;
@@ -108,15 +116,22 @@ void handle_pgm_int(void)
 
 void handle_ext_int(void)
 {
-	if (lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
+	if (!ext_int_expected &&
+	    lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
 		report_abort("Unexpected external call interrupt: at %#lx",
 			     lc->ext_old_psw.addr);
-	} else {
-		lc->ext_old_psw.mask &= ~PSW_MASK_EXT;
+		return;
+	}
+
+	if (lc->ext_int_code == EXT_IRQ_SERVICE_SIG) {
 		lc->sw_int_cr0 &= ~(1UL << 9);
 		sclp_handle_ext();
-		lc->ext_int_code = 0;
+	} else {
+		ext_int_expected = false;
 	}
+
+	if (!(lc->sw_int_cr0 & CR0_EXTM_MASK))
+		lc->ext_old_psw.mask &= ~PSW_MASK_EXT;
 }
 
 void handle_mcck_int(void)
-- 
2.18.1

