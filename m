Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE1BEBE29F
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 18:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505123AbfIYQi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 12:38:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502032AbfIYQiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 12:38:25 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 497C5307D985;
        Wed, 25 Sep 2019 16:38:25 +0000 (UTC)
Received: from thuth.com (ovpn-116-109.ams2.redhat.com [10.36.116.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D29760BF1;
        Wed, 25 Sep 2019 16:38:21 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 11/17] s390x: Use interrupts in SCLP and add locking
Date:   Wed, 25 Sep 2019 18:37:08 +0200
Message-Id: <20190925163714.27519-12-thuth@redhat.com>
In-Reply-To: <20190925163714.27519-1-thuth@redhat.com>
References: <20190925163714.27519-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 25 Sep 2019 16:38:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

We need to properly implement interrupt handling for SCLP, because on
z/VM and LPAR SCLP calls are not synchronous!

Also with smp CPUs have to compete for sclp. Let's add some locking,
so they execute sclp calls in an orderly fashion and don't compete for
the data buffer.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20190920080356.1948-2-frankja@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/interrupt.h |  2 ++
 lib/s390x/interrupt.c     | 12 +++++++--
 lib/s390x/sclp-console.c  |  2 ++
 lib/s390x/sclp.c          | 55 +++++++++++++++++++++++++++++++++++++--
 lib/s390x/sclp.h          |  3 +++
 5 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index 013709f..f485e96 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -11,6 +11,8 @@
 #define _ASMS390X_IRQ_H_
 #include <asm/arch_def.h>
 
+#define EXT_IRQ_SERVICE_SIG	0x2401
+
 void handle_pgm_int(void);
 void handle_ext_int(void);
 void handle_mcck_int(void);
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index cf0a794..7832711 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -12,6 +12,7 @@
 #include <libcflat.h>
 #include <asm/interrupt.h>
 #include <asm/barrier.h>
+#include <sclp.h>
 
 static bool pgm_int_expected;
 static struct lowcore *lc;
@@ -107,8 +108,15 @@ void handle_pgm_int(void)
 
 void handle_ext_int(void)
 {
-	report_abort("Unexpected external call interrupt: at %#lx",
-		     lc->ext_old_psw.addr);
+	if (lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
+		report_abort("Unexpected external call interrupt: at %#lx",
+			     lc->ext_old_psw.addr);
+	} else {
+		lc->ext_old_psw.mask &= ~PSW_MASK_EXT;
+		lc->sw_int_cr0 &= ~(1UL << 9);
+		sclp_handle_ext();
+		lc->ext_int_code = 0;
+	}
 }
 
 void handle_mcck_int(void)
diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index bc01f41..a5ef45f 100644
--- a/lib/s390x/sclp-console.c
+++ b/lib/s390x/sclp-console.c
@@ -17,6 +17,7 @@ static void sclp_set_write_mask(void)
 {
 	WriteEventMask *sccb = (void *)_sccb;
 
+	sclp_mark_busy();
 	sccb->h.length = sizeof(WriteEventMask);
 	sccb->mask_length = sizeof(unsigned int);
 	sccb->receive_mask = SCLP_EVENT_MASK_MSG_ASCII;
@@ -37,6 +38,7 @@ void sclp_print(const char *str)
 	int len = strlen(str);
 	WriteEventData *sccb = (void *)_sccb;
 
+	sclp_mark_busy();
 	sccb->h.length = sizeof(WriteEventData) + len;
 	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
 	sccb->ebh.length = sizeof(EventBufferHeader) + len;
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index b60f7a4..56fca0c 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -14,6 +14,8 @@
 #include <asm/page.h>
 #include <asm/arch_def.h>
 #include <asm/interrupt.h>
+#include <asm/barrier.h>
+#include <asm/spinlock.h>
 #include "sclp.h"
 #include <alloc_phys.h>
 #include <alloc_page.h>
@@ -25,6 +27,8 @@ static uint64_t max_ram_size;
 static uint64_t ram_size;
 
 char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
+static volatile bool sclp_busy;
+static struct spinlock sclp_lock;
 
 static void mem_init(phys_addr_t mem_end)
 {
@@ -41,17 +45,62 @@ static void mem_init(phys_addr_t mem_end)
 	page_alloc_ops_enable();
 }
 
+static void sclp_setup_int(void)
+{
+	uint64_t mask;
+
+	ctl_set_bit(0, 9);
+
+	mask = extract_psw_mask();
+	mask |= PSW_MASK_EXT;
+	load_psw_mask(mask);
+}
+
+void sclp_handle_ext(void)
+{
+	ctl_clear_bit(0, 9);
+	spin_lock(&sclp_lock);
+	sclp_busy = false;
+	spin_unlock(&sclp_lock);
+}
+
+void sclp_wait_busy(void)
+{
+	while (sclp_busy)
+		mb();
+}
+
+void sclp_mark_busy(void)
+{
+	/*
+	 * With multiple CPUs we might need to wait for another CPU's
+	 * request before grabbing the busy indication.
+	 */
+	while (true) {
+		sclp_wait_busy();
+		spin_lock(&sclp_lock);
+		if (!sclp_busy) {
+			sclp_busy = true;
+			spin_unlock(&sclp_lock);
+			return;
+		}
+		spin_unlock(&sclp_lock);
+	}
+}
+
 static void sclp_read_scp_info(ReadInfo *ri, int length)
 {
 	unsigned int commands[] = { SCLP_CMDW_READ_SCP_INFO_FORCED,
 				    SCLP_CMDW_READ_SCP_INFO };
-	int i;
+	int i, cc;
 
 	for (i = 0; i < ARRAY_SIZE(commands); i++) {
+		sclp_mark_busy();
 		memset(&ri->h, 0, sizeof(ri->h));
 		ri->h.length = length;
 
-		if (sclp_service_call(commands[i], ri))
+		cc = sclp_service_call(commands[i], ri);
+		if (cc)
 			break;
 		if (ri->h.response_code == SCLP_RC_NORMAL_READ_COMPLETION)
 			return;
@@ -66,12 +115,14 @@ int sclp_service_call(unsigned int command, void *sccb)
 {
 	int cc;
 
+	sclp_setup_int();
 	asm volatile(
 		"       .insn   rre,0xb2200000,%1,%2\n"  /* servc %1,%2 */
 		"       ipm     %0\n"
 		"       srl     %0,28"
 		: "=&d" (cc) : "d" (command), "a" (__pa(sccb))
 		: "cc", "memory");
+	sclp_wait_busy();
 	if (cc == 3)
 		return -1;
 	if (cc == 2)
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 583c4e5..63cf609 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -213,6 +213,9 @@ typedef struct ReadEventData {
 } __attribute__((packed)) ReadEventData;
 
 extern char _sccb[];
+void sclp_handle_ext(void);
+void sclp_wait_busy(void);
+void sclp_mark_busy(void);
 void sclp_console_setup(void);
 void sclp_print(const char *str);
 int sclp_service_call(unsigned int command, void *sccb);
-- 
2.18.1

