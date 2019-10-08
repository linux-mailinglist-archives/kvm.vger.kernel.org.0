Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E34BD007D
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 20:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbfJHSIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 14:08:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfJHSIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 14:08:12 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 064547BDD2;
        Tue,  8 Oct 2019 18:08:12 +0000 (UTC)
Received: from vitty.brq.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24EBD60BE0;
        Tue,  8 Oct 2019 18:08:09 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH] selftests: kvm: fix sync_regs_test with newer gccs
Date:   Tue,  8 Oct 2019 20:08:08 +0200
Message-Id: <20191008180808.14181-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 08 Oct 2019 18:08:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 204c91eff798a ("KVM: selftests: do not blindly clobber registers in
 guest asm") was intended to make test more gcc-proof, however, the result
is exactly the opposite: on newer gccs (e.g. 8.2.1) the test breaks with

==== Test Assertion Failure ====
  x86_64/sync_regs_test.c:168: run->s.regs.regs.rbx == 0xBAD1DEA + 1
  pid=14170 tid=14170 - Invalid argument
     1	0x00000000004015b3: main at sync_regs_test.c:166 (discriminator 6)
     2	0x00007f413fb66412: ?? ??:0
     3	0x000000000040191d: _start at ??:?
  rbx sync regs value incorrect 0x1.

Apparently, compile is still free to play games with registers even
when they have variables attaches.

Re-write guest code with 'asm volatile' by embedding ucall there and
making sure rbx is preserved.

Fixes: 204c91eff798a ("KVM: selftests: do not blindly clobber registers in guest asm")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/sync_regs_test.c     | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index 11c2a70a7b87..5c8224256294 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -22,18 +22,19 @@
 
 #define VCPU_ID 5
 
+#define UCALL_PIO_PORT ((uint16_t)0x1000)
+
+/*
+ * ucall is embedded here to protect against compiler reshuffling registers
+ * before calling a function. In this test we only need to get KVM_EXIT_IO
+ * vmexit and preserve RBX, no additional information is needed.
+ */
 void guest_code(void)
 {
-	/*
-	 * use a callee-save register, otherwise the compiler
-	 * saves it around the call to GUEST_SYNC.
-	 */
-	register u32 stage asm("rbx");
-	for (;;) {
-		GUEST_SYNC(0);
-		stage++;
-		asm volatile ("" : : "r" (stage));
-	}
+	asm volatile("1: in %[port], %%al\n"
+		     "add $0x1, %%rbx\n"
+		     "jmp 1b"
+		     : : [port] "d" (UCALL_PIO_PORT) : "rax", "rbx");
 }
 
 static void compare_regs(struct kvm_regs *left, struct kvm_regs *right)
-- 
2.20.1

