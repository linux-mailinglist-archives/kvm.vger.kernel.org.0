Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F901E61A
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 02:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfEOA2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 20:28:17 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45819 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfEOA2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 20:28:17 -0400
Received: by mail-pg1-f193.google.com with SMTP id i21so375418pgi.12;
        Tue, 14 May 2019 17:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=APbUiEWtsn5UYHvxww0x21/cxMCspJF7WW5D6ZYjgYA=;
        b=PjOoN1qNjGvu9pSadyZbNVaB0nE5NfEgm2l1q5DNZuSI6by0AnI4Ci0HM+mPYIt+iO
         tNrAi/uIqoDDOIYYMUI55SAv6q+/KEfOlDpu8sLhj2M59Q1QFV2+wwAi9rBlQmzD0TDE
         eL89UUzv2iP7yJV4tYDJGOnKqcB9qQlhWlP6ba1v7eoYBjvxVKgCVhJ+jC6M8wSMQXcY
         ZRKCq68HzlMQJMwmhyzxjg2eC8WKoh2s9jPmQYOIxlV/OJTttYIvhb11aXo7IdCSMZhp
         VsFMbnyzu+sF5rkp3NapZW7l9IyZq46jCXWAKPpPVtri8Hebb6ybDEG6mHTTJxc+QIFc
         y+7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=APbUiEWtsn5UYHvxww0x21/cxMCspJF7WW5D6ZYjgYA=;
        b=IUCRIH79aQJU3lPaJ59jdZ8KcncYtRXgqF9XcmZWJoOFc+YnyRhCIIZByFXd/SrJQ8
         aBQH3nxuPo0tOZ6kTT0GOZbnVTU5SX69wvsV9SWlKEOO5QOQCWM/+MDdvFEiF6kEl60J
         dt/UC2R709Ypsu44rFcjJnC6dC1PHT+gOR+8z/hFfiRr1fDZ1OmSmCVTxJxrirnE3ZkO
         iPZL+f7UlbsLMyUY6CI5Sn/zTjGyhrhONYlOUfyXsvllm/bbqSsNdQK0b9U0k7fD24Xm
         J6Te8yMy+yVfW/cwG7XtMCZVeDNl/COw6XF5hcv/lezs3FJhN6I1uoyj9IbE0vIh0kcw
         dCuQ==
X-Gm-Message-State: APjAAAVlp4rw/iOYXFNGB/UUtwigCVvpvES40Q/eZy0D/8KrEzYZs1F3
        AhQZt8ZnYLOD91CqRqkdZseBYFz2
X-Google-Smtp-Source: APXvYqwUYM9uS1Ia0hb7mGkvq7XoHqMcfyVZiXM27fP5ey+h1I/rPJWxFukRUorlpYaGRsDp5B/XBQ==
X-Received: by 2002:a63:3e47:: with SMTP id l68mr40513155pga.85.1557880096281;
        Tue, 14 May 2019 17:28:16 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id o2sm281374pgq.1.2019.05.14.17.28.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 17:28:15 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com,
        dgibson@redhat.com, Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [kvm-unit-tests PATCH v2 1/2] powerpc: Allow for a custom decr value to be specified to load on decr excp
Date:   Wed, 15 May 2019 10:28:00 +1000
Message-Id: <20190515002801.20517-1-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

---

V1 -> V2:
- Make decr variables static
- Load intial decr value in tm test to ensure known value present
---
 lib/powerpc/handlers.c | 7 ++++---
 powerpc/sprs.c         | 5 +++--
 powerpc/tm.c           | 4 +++-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/lib/powerpc/handlers.c b/lib/powerpc/handlers.c
index be8226a..c8721e0 100644
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
index 6744bd8..0e2e1c9 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -253,6 +253,7 @@ int main(int argc, char **argv)
 		0x1234567890ABCDEFULL, 0xFEDCBA0987654321ULL,
 		-1ULL,
 	};
+	static uint64_t decr = 0x7FFFFFFF; /* Max value */
 
 	for (i = 1; i < argc; i++) {
 		if (!strcmp(argv[i], "-w")) {
@@ -288,8 +289,8 @@ int main(int argc, char **argv)
 		(void) getchar();
 	} else {
 		puts("Sleeping...\n");
-		handle_exception(0x900, &dec_except_handler, NULL);
-		asm volatile ("mtdec %0" : : "r" (0x3FFFFFFF));
+		handle_exception(0x900, &dec_except_handler, &decr);
+		asm volatile ("mtdec %0" : : "r" (decr));
 		hcall(H_CEDE);
 	}
 
diff --git a/powerpc/tm.c b/powerpc/tm.c
index bd56baa..c588985 100644
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
2.13.6

