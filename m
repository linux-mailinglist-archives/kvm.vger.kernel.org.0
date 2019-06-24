Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405A050DE0
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 16:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbfFXOZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 10:25:07 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:26819 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728610AbfFXOZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 10:25:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1561386304; x=1592922304;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=e5/wzZOHO5jX+iWdhi+/Gax6J9/hZVi/ZItfnLr/b9k=;
  b=YqIwLtakvOnZ1IE0kqpOAJUUVc7qE+ezVebE4O6iaPlJuCv3mNeT1Li0
   vON6BhSGJUq2o+4n5kK67UZXjFSuXYLBbjbQ5efDOQtIJ2p8+lwYBrLTV
   tS8/0lLLhs6dgWuRA39c65LeruYYbbIi+UbxUpONqEnBJ591ZFNQLFdvt
   g=;
X-IronPort-AV: E=Sophos;i="5.62,412,1554768000"; 
   d="scan'208";a="771743144"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 24 Jun 2019 14:25:02 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 47CD524154B;
        Mon, 24 Jun 2019 14:24:57 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 24 Jun 2019 14:24:38 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 24 Jun 2019 14:24:38 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 24 Jun 2019 14:24:33 +0000
From:   Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <anirudhkaushik@google.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sam Caccavale <samcacc@amazon.de>
Subject: [PATCH v3 3/5] Demonstrating unit testing via simple-harness
Date:   Mon, 24 Jun 2019 16:24:12 +0200
Message-ID: <20190624142414.22096-4-samcacc@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190624142414.22096-1-samcacc@amazon.de>
References: <20190624142414.22096-1-samcacc@amazon.de>
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
index d45fe6d266b9..e79d275e1040 100644
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



