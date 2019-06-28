Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8303E59774
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 11:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfF1J1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 05:27:10 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:59219 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfF1J1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 05:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1561714029; x=1593250029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Kl/4zUxzxiMl2/TnHDmxSjA0zBqyzH5U0GdQJ6JWDUk=;
  b=rkQuePVrVXs+tnXCsJCrQt6NX0DRZTP31DRwWszOQxb+z3bmsm9U+EHV
   epE6ykhZAR+1ZzUCf9a3DZoHYMbKsYJdFGjEl4NsTe6yugvFXADhtp8fc
   LITE4E0u6Zyf+tpIyIJHzVY/tkRTj11pkSKz4HMIXOHxEmDw2+l9UXvXH
   s=;
X-IronPort-AV: E=Sophos;i="5.62,427,1554768000"; 
   d="scan'208";a="739581286"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 28 Jun 2019 09:27:07 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id C1F77A1E93;
        Fri, 28 Jun 2019 09:27:03 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 09:26:44 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 09:26:43 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Fri, 28 Jun 2019 09:26:39 +0000
From:   Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sam Caccavale <samcacc@amazon.de>
Subject: [PATCH v4 3/5] Demonstrating unit testing via simple-harness
Date:   Fri, 28 Jun 2019 11:26:19 +0200
Message-ID: <20190628092621.17823-4-samcacc@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628092621.17823-1-samcacc@amazon.de>
References: <20190628092621.17823-1-samcacc@amazon.de>
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

v1 -> v2:
 - Accidentally changed the example

V2 -> v3:
 - Reverted the example back to the more useful original one

Signed-off-by: Sam Caccavale <samcacc@amazon.de>
---
 tools/fuzz/x86ie/Makefile         |  7 +++--
 tools/fuzz/x86ie/simple-harness.c | 49 +++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 2 deletions(-)
 create mode 100644 tools/fuzz/x86ie/simple-harness.c

diff --git a/tools/fuzz/x86ie/Makefile b/tools/fuzz/x86ie/Makefile
index 07a784519100..2724b0cb387f 100644
--- a/tools/fuzz/x86ie/Makefile
+++ b/tools/fuzz/x86ie/Makefile
@@ -44,8 +44,11 @@ LOCAL_OBJS := emulator_ops.o stubs.o
 afl-harness: afl-harness.o $(LOCAL_OBJS) $(KERNEL_OBJS)
 	@$(CC) -v $(KBUILD_CFLAGS) $(LOCAL_OBJS) $(KERNEL_OBJS) $< $(INCLUDES) -Istubs.h -o $@ -no-pie
 
-all: afl-harness
+simple-harness: simple-harness.o $(LOCAL_OBJS) $(KERNEL_OBJS)
+	@$(CC) -v $(KBUILD_CFLAGS) $(LOCAL_OBJS) $(KERNEL_OBJS) $< $(INCLUDES) -Istubs.h -o $@ -no-pie
+
+all: afl-harness simple-harness
 
 .PHONY: clean
 clean:
-	$(RM) -r *.o afl-harness
+	$(RM) -r *.o afl-harness simple-harness
diff --git a/tools/fuzz/x86ie/simple-harness.c b/tools/fuzz/x86ie/simple-harness.c
new file mode 100644
index 000000000000..9601aafb9423
--- /dev/null
+++ b/tools/fuzz/x86ie/simple-harness.c
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
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



