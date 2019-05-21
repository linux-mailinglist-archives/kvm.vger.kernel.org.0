Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE3C25436
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 17:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbfEUPkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 11:40:19 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:15059 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbfEUPkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 11:40:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1558453217; x=1589989217;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=5B9enZJwF3veiFRzLvmeNGG7DvSS35w6K7vV8jk0rNY=;
  b=ub+Iqxp1E3xolTbZyTAHaPxBNMwh8fDeL8Hxny8LIMKp56Yzq7ejYZhL
   xMyrSMILX+bq664eR8CckK7kYxbXFBzXWGZA2ipi4f0bt1bWofCiv50Oz
   Qied2bI6CiU3AgEdEAsaugQsIpUNqYdoezrstW2mKs8IcgcsCjj9yHb+A
   s=;
X-IronPort-AV: E=Sophos;i="5.60,495,1549929600"; 
   d="scan'208";a="767022279"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 21 May 2019 15:40:14 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x4LFeBCx117178
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 21 May 2019 15:40:12 GMT
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 21 May 2019 15:39:59 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 21 May 2019 15:39:59 +0000
Received: from uc2253769c0055c.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 21 May 2019 15:39:54 +0000
From:   Sam Caccavale <samcacc@amazon.de>
CC:     <samcacc@amazon.de>, <samcaccavale@gmail.com>,
        <nmanthey@amazon.de>, <wipawel@amazon.de>, <dwmw@amazon.co.uk>,
        <mpohlack@amazon.de>, <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <anirudhkaushik@google.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] Demonstrating unit testing via simple-harness
Date:   Tue, 21 May 2019 17:39:24 +0200
Message-ID: <20190521153924.15110-4-samcacc@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190521153924.15110-1-samcacc@amazon.de>
References: <20190521153924.15110-1-samcacc@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simple-harness.c uses inline asm support to generate asm and then has the
emulator emulate this code.  This may be useful as a form of testing for
the emulator.

---
 tools/fuzz/x86_instruction_emulation/Makefile |  7 ++-
 .../simple-harness.c                          | 49 +++++++++++++++++++
 2 files changed, 54 insertions(+), 2 deletions(-)
 create mode 100644 tools/fuzz/x86_instruction_emulation/simple-harness.c

diff --git a/tools/fuzz/x86_instruction_emulation/Makefile b/tools/fuzz/x86_instruction_emulation/Makefile
index d2854a332605..bb29149ae0f7 100644
--- a/tools/fuzz/x86_instruction_emulation/Makefile
+++ b/tools/fuzz/x86_instruction_emulation/Makefile
@@ -43,7 +43,10 @@ LOCAL_OBJS := emulator_ops.o stubs.o
 afl-harness: afl-harness.o $(LOCAL_OBJS) $(KERNEL_OBJS)
 	@$(CC) -v $(KBUILD_CFLAGS) $(LOCAL_OBJS) $(KERNEL_OBJS) $< $(INCLUDES) -Istubs.h -o $@ -no-pie
 
-all: afl-harness
+simple-harness: simple-harness.o $(LOCAL_OBJS) $(KERNEL_OBJS)
+	@$(CC) -v $(KBUILD_CFLAGS) $(LOCAL_OBJS) $(KERNEL_OBJS) $< $(INCLUDES) -Istubs.h -o $@ -no-pie
+
+all: afl-harness simple-harness
 
 .PHONY: fuzz_deps
 fuzz_deps:
@@ -54,4 +57,4 @@ fuzz_deps:
 
 .PHONY: clean
 clean:
-	$(RM) -r *.o afl-harness
+	$(RM) -r *.o afl-harness simple-harness
diff --git a/tools/fuzz/x86_instruction_emulation/simple-harness.c b/tools/fuzz/x86_instruction_emulation/simple-harness.c
new file mode 100644
index 000000000000..9601aafb9423
--- /dev/null
+++ b/tools/fuzz/x86_instruction_emulation/simple-harness.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <assert.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include "emulator_ops.h"
+#include <asm/kvm_emulate.h>
+
+extern void foo(void)
+{
+	asm volatile("__start:mov $0xdeadbeef, %rax;"
+		     "xor %rax, %rax;"
+		     "__end:");
+}
+
+int main(int argc, char **argv)
+{
+	extern unsigned char __start;
+	extern unsigned char __end;
+	struct state *state = create_emulator();
+	int rc;
+
+	/* Ensures the emulator is in a valid state. */
+	initialize_emulator(state);
+
+	/* Provide the emulator with instructions to emulate. */
+	state->data = &__start;
+	state->data_available = &__end - &__start;
+
+	/* Execute mov $0xdeadbeef, %rax */
+	rc = step_emulator(state);
+	/* Check that the emulator succeeded. */
+	assert(rc == X86EMUL_CONTINUE);
+	/* Check that 0xdeadbeef was moved to rax. */
+	assert(state->ctxt._regs[REGS_RAX] == 0xdeadbeef);
+
+	/* Execute xor %rax, %rax */
+	rc = step_emulator(state);
+	/* Check that the emulator succeeded. */
+	assert(rc == X86EMUL_CONTINUE);
+	/* Check that xoring rax with itself cleared rax. */
+	assert(state->ctxt._regs[REGS_RAX] == 0);
+
+	/* Free the emulator. */
+	free_emulator(state);
+
+	return 0;
+}
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrer: Christian Schlaeger, Ralf Herbrich
Ust-ID: DE 289 237 879
Eingetragen am Amtsgericht Charlottenburg HRB 149173 B


