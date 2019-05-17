Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB1B218C6
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 15:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbfEQNDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 09:03:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47204 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728746AbfEQNDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 09:03:10 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A6344C09AD1A;
        Fri, 17 May 2019 13:03:10 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.40.205.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96838600C4;
        Fri, 17 May 2019 13:03:08 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: [kvm-unit-tests PULL 1/2] powerpc: Allow for a custom decr value to be specified to load on decr excp
Date:   Fri, 17 May 2019 15:03:04 +0200
Message-Id: <20190517130305.32123-2-lvivier@redhat.com>
In-Reply-To: <20190517130305.32123-1-lvivier@redhat.com>
References: <20190517130305.32123-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 17 May 2019 13:03:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

Currently the handler for a decrementer exception will simply reload the
maximum value (0x7FFFFFFF), which will take ~4 seconds to expire again.
This means that if a vcpu cedes, it will be ~4 seconds between wakeups.

The h_cede_tm test is testing a known breakage when a guest cedes while
suspended. To be sure we cede 500 times to check for the bug. However
since it takes ~4 seconds to be woken up once we've ceded, we only get
through ~20 iterations before we reach the 90 seconds timeout and the
test appears to fail.

Add an option when registering the decrementer handler to specify the
value which should be reloaded by the handler, allowing the timeout to be
chosen.

Modify the spr test to use the max timeout to preserve existing
behaviour.
Modify the h_cede_tm test to use a 10ms timeout to ensure we can perform
500 iterations before hitting the 90 second time limit for a test.

This means the h_cede_tm test now succeeds rather than timing out.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Laurent Vivier <lvivier@redhat.com>
[lv: reset initial value to 0x3FFFFFFF]
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 lib/powerpc/handlers.c | 7 ++++---
 powerpc/sprs.c         | 3 ++-
 powerpc/tm.c           | 4 +++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/lib/powerpc/handlers.c b/lib/powerpc/handlers.c
index be8226a2e573..c8721e0a11ae 100644
--- a/lib/powerpc/handlers.c
+++ b/lib/powerpc/handlers.c
@@ -12,11 +12,12 @@
 
 /*
  * Generic handler for decrementer exceptions (0x900)
- * Just reset the decrementer back to its maximum value (0x7FFFFFFF)
+ * Just reset the decrementer back to the value specified when registering the
+ * handler
  */
-void dec_except_handler(struct pt_regs *regs __unused, void *data __unused)
+void dec_except_handler(struct pt_regs *regs __unused, void *data)
 {
-	uint32_t dec = 0x7FFFFFFF;
+	uint64_t dec = *((uint64_t *) data);
 
 	asm volatile ("mtdec %0" : : "r" (dec));
 }
diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index 6744bd8d8049..3c2d98c9ca99 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -253,6 +253,7 @@ int main(int argc, char **argv)
 		0x1234567890ABCDEFULL, 0xFEDCBA0987654321ULL,
 		-1ULL,
 	};
+	static uint64_t decr = 0x7FFFFFFF; /* Max value */
 
 	for (i = 1; i < argc; i++) {
 		if (!strcmp(argv[i], "-w")) {
@@ -288,7 +289,7 @@ int main(int argc, char **argv)
 		(void) getchar();
 	} else {
 		puts("Sleeping...\n");
-		handle_exception(0x900, &dec_except_handler, NULL);
+		handle_exception(0x900, &dec_except_handler, &decr);
 		asm volatile ("mtdec %0" : : "r" (0x3FFFFFFF));
 		hcall(H_CEDE);
 	}
diff --git a/powerpc/tm.c b/powerpc/tm.c
index bd56baa5b3d8..c588985352f4 100644
--- a/powerpc/tm.c
+++ b/powerpc/tm.c
@@ -95,11 +95,13 @@ static bool enable_tm(void)
 static void test_h_cede_tm(int argc, char **argv)
 {
 	int i;
+	static uint64_t decr = 0x3FFFFF; /* ~10ms */
 
 	if (argc > 2)
 		report_abort("Unsupported argument: '%s'", argv[2]);
 
-	handle_exception(0x900, &dec_except_handler, NULL);
+	handle_exception(0x900, &dec_except_handler, &decr);
+	asm volatile ("mtdec %0" : : "r" (decr));
 
 	if (!start_all_cpus(halt, 0))
 		report_abort("Failed to start secondary cpus");
-- 
2.20.1

