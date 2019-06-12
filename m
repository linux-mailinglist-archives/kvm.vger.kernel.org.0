Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17DB42B0C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 17:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437553AbfFLPgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 11:36:31 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:63119 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437543AbfFLPgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 11:36:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560353790; x=1591889790;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=YD1Fi0GvdNAKUu8A+dqXH3sOUetAnqKZZEfujw59KzM=;
  b=ipmiOu/3ZJoQzP0NCQw2D2tIqIubIXK1aJ9JIAd2ArtpCWH/6wmlEAwR
   4dIgwcsbumT1PSnwq9duknlEzaHWjYuxiciFx5n5nmIscQl9BLwrl2GiW
   qEjeteP5YfoscJ60ckU8hF+8im11X0fJ1DJzaZpqASrv8IyN3RDaNFXHo
   c=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="679536197"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 12 Jun 2019 15:36:28 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 5360CA2413;
        Wed, 12 Jun 2019 15:36:27 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Jun 2019 15:36:27 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Jun 2019 15:36:26 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 12 Jun 2019 15:36:24 +0000
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
Subject: [v2, 3/4] Demonstrating unit testing via simple-harness
Date:   Wed, 12 Jun 2019 17:35:59 +0200
Message-ID: <20190612153600.13073-4-samcacc@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190612153600.13073-1-samcacc@amazon.de>
References: <20190612153600.13073-1-samcacc@amazon.de>
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

CR: https://code.amazon.com/reviews/CR-8591638
---
 tools/fuzz/x86ie/Makefile         |  7 ++++--
 tools/fuzz/x86ie/simple-harness.c | 42 +++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 2 deletions(-)
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
index 000000000000..f21fdafe1dd1
--- /dev/null
+++ b/tools/fuzz/x86ie/simple-harness.c
@@ -0,0 +1,42 @@
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
+	asm volatile("__start:"
+		     ".byte 0x32, 0x05, 0x00, 0x00, 0x00, 0x00;" // xor eax,DWORD PTR [rip+0x0]
+		     ".byte 0x90;"
+		     //".byte 0x0f, 0x7f, 0xde;" // movq mm6,mm3
+		     ".byte 0x0f, 0x6f, 0xde;" // same instruction...
+		     ".byte 0x90;"
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
+	/* rip addressed instruction */
+	rc = emulate_until_complete(state);
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



