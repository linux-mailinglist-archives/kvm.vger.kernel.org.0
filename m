Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B7F105AC
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 09:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbfEAHAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 03:00:48 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39962 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfEAHAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 May 2019 03:00:48 -0400
Received: by mail-pl1-f196.google.com with SMTP id b3so7850761plr.7;
        Wed, 01 May 2019 00:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bFJwXZ0l2LDfOhDt4J1l5mutAx6iUOrT+q1e6hmvUSY=;
        b=QA1V1EqZr0/ryxfykPoTQrY97ByQE4UPRa5a3aYli+qCX98Vz5wHMFy4ht+3SUXfh/
         gztjL/QOFD7l0CviS/3zXF2aZEhHDDBC6hQ6d5L99uZ4RVBPQBrPiwkQR+zXkkDKP+I3
         3rD2Av3NjGYsNlN5yKE7YlXXUyVjBRvfnsgWq8rWmQpDaXXi4OWzO9S1JLsz1XbGaFfC
         PiL9g63YuzlcZMnEpa4jzdSGgEL9LIk/xnUELtsdB+o0OLDxKbQ3fGcEUTpnEp2oJ5uu
         1ms81OOXJw4QPES1AtwV08ALhznUd2D3OlRYSLroSyj/Qpz3r3DYUNrUlmsu+iGy5aXq
         yiCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bFJwXZ0l2LDfOhDt4J1l5mutAx6iUOrT+q1e6hmvUSY=;
        b=cpUX5wB8Wla+MTNfcj5WEn6G4+7V4snVO262qrsTegCAWFooegSROb5+zePt9s6PuP
         RXhltnwbOZaKLYXn+KoDl1PN20kD6AlZ1KeCkITt39G9A/rAYPa+4ZAD7EFXb5DHuvm1
         ZiC2ZIX0etJlTbwdq6wfq1LH6gmG0jBMmQJcxCG7QxZtG4migZaJHe4JXVICnXtiOxiZ
         XbQR+99zvauZEyuMZLnmCfNMtROPXNr+O/lo4O6A8fOd2q9mNYlTkirA7CLuUhFNrysX
         p85QiAKtszNmUooVBwBJD4uYNSCyVY4q/qOkyYj8ybhO3dCyTGJeDSM78Xu3LaLvC8M6
         Isqw==
X-Gm-Message-State: APjAAAXBGAtuItR/GCxCRxFzwP8NTOCoqJGqSaOfFRCqvV1RhPD3Cabf
        0s3oy1L4DyJ9LYvZozNvo4ZGmnbE
X-Google-Smtp-Source: APXvYqyCkVLIT7sOjeUfWc0bfBlAcDyiQ3qVJs36hYC+Fv5G9MHa0rfn9nWE1U+D1vUY7bRYQWykqg==
X-Received: by 2002:a17:902:b68d:: with SMTP id c13mr11959140pls.10.1556694046944;
        Wed, 01 May 2019 00:00:46 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id l19sm50559616pff.1.2019.05.01.00.00.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 May 2019 00:00:46 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm@vger.kernel.org
Cc:     lvivier@redhat.com, thuth@redhat.com, kvm-ppc@vger.kernel.org,
        dgibson@redhat.com, Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [kvm-unit-tests PATCH] powerpc: Allow for a custom decr value to be specified to load on decr excp
Date:   Wed,  1 May 2019 17:00:39 +1000
Message-Id: <20190501070039.2903-1-sjitindarsingh@gmail.com>
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
 lib/powerpc/handlers.c | 7 ++++---
 powerpc/sprs.c         | 3 ++-
 powerpc/tm.c           | 3 ++-
 3 files changed, 8 insertions(+), 5 deletions(-)

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
index 6744bd8..3bd6ac7 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -253,6 +253,7 @@ int main(int argc, char **argv)
 		0x1234567890ABCDEFULL, 0xFEDCBA0987654321ULL,
 		-1ULL,
 	};
+	uint64_t decr = 0x7FFFFFFF;
 
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
index bd56baa..0f3f543 100644
--- a/powerpc/tm.c
+++ b/powerpc/tm.c
@@ -95,11 +95,12 @@ static bool enable_tm(void)
 static void test_h_cede_tm(int argc, char **argv)
 {
 	int i;
+	uint64_t decr = 0x3FFFFF;
 
 	if (argc > 2)
 		report_abort("Unsupported argument: '%s'", argv[2]);
 
-	handle_exception(0x900, &dec_except_handler, NULL);
+	handle_exception(0x900, &dec_except_handler, &decr);
 
 	if (!start_all_cpus(halt, 0))
 		report_abort("Failed to start secondary cpus");
-- 
2.13.6

