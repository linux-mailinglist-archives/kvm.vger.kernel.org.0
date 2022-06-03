Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9DE53C238
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241196AbiFCAu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240372AbiFCAqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:46:22 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E443637A84
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:04 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id h13-20020a170902f70d00b0015f4cc5d19aso3464979plo.18
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3AZUimij95bjf5gYvdhkHvlv855AKXpvwM8ZUYLyhNw=;
        b=XlZnkRi3t2vy0ZLpDkMjujVnZSo15I0e/Gv1KpGadfeMGgPTXnJXBq3iBVVXQLkGuP
         fsq4CCy3VjhV4Z6UDOES4Y1SX9s0p7hpWTo636PxSjKAOa6KhKZBR46WZey2LVIQzMn/
         kEU4U8ERfRzV/ds31rN9KHsjsdJK8oMrGoXxl+rSRKikuEnZCRpBqG681u8GRiN18p0g
         oafoX92Z8gTL5v5BVf2TOOIFRMGOAXGCExh5HWiIOisY9nn4jZPDxRYUFO7zKY+QFw4n
         4p0lsKOsEWShjbjGoqbXmHn/73gZYb+9//jKPCFjkjJVG5uiKRL78XeOx8irsOp38Pc6
         B/NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3AZUimij95bjf5gYvdhkHvlv855AKXpvwM8ZUYLyhNw=;
        b=C+0u4pQbIcSUwdoY4f+syZi67WqZKu9bITdSlLbVWBvBPzY4S17zl7MroR7HQE3axm
         zdwnXmBD5Vl3cWTcoGkPMmPV4Pp2ulokYGDxA/hh4GLnb4EkKWvJ4HlL4obdHJMBsK2s
         hvbzJUgBVPnGaAzzoZ4bnLTRjewv6yFsnc4zMFYEx/tNKeuw/EQTf/Leh8Wo1J2l2MVF
         ou8BkIrdFglh4UHjMykZgIv+1c64UYwszbZguToHi0/Eyh7ZxHgL3OFR7QQ/79nVNhq/
         /tu4IcyFiiS5TTmaeXrX3WD0BR/2xuaeqQJiwhlKtBOPCIYGA++Nbt8tx6iFJCWBkX4g
         HBMA==
X-Gm-Message-State: AOAM533Hb92NNZHnGV1XXpXBr86+0J9FvCe5BYiF2HygaDeM2g2ebsow
        Uh4UAeOvlW1pPxNddzKfEz7ygj2uMj4=
X-Google-Smtp-Source: ABdhPJywo4t07QOnGV8De5DPRS6yc/ynoS0+G/CTgjCWibvygcU9t5bQWHkMVrrFHnqeODnM9tLPeTUoCYw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e34b:b0:166:342f:82c6 with SMTP id
 p11-20020a170902e34b00b00166342f82c6mr7456216plc.29.1654217164436; Thu, 02
 Jun 2022 17:46:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:28 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-82-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 081/144] KVM: selftests: Convert debug_regs away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert debug_regs to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.

Opportunstically drop the CLEAR_DEBUG/APPLY_DEBUG macros as they only
obfuscate the code, e.g. operating on local variables not "passed" to the
macro is all kinds of confusing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/debug_regs.c | 53 +++++++++----------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86_64/debug_regs.c
index f726645bb9c3..182d71c6d13a 100644
--- a/tools/testing/selftests/kvm/x86_64/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86_64/debug_regs.c
@@ -10,8 +10,6 @@
 #include "processor.h"
 #include "apic.h"
 
-#define VCPU_ID 0
-
 #define DR6_BD		(1 << 13)
 #define DR7_GD		(1 << 13)
 
@@ -66,13 +64,11 @@ static void guest_code(void)
 	GUEST_DONE();
 }
 
-#define  CLEAR_DEBUG()  memset(&debug, 0, sizeof(debug))
-#define  APPLY_DEBUG()  vcpu_guest_debug_set(vm, VCPU_ID, &debug)
 #define  CAST_TO_RIP(v)  ((unsigned long long)&(v))
 #define  SET_RIP(v)  do {				\
-		vcpu_regs_get(vm, VCPU_ID, &regs);	\
+		vcpu_regs_get(vm, vcpu->id, &regs);	\
 		regs.rip = (v);				\
-		vcpu_regs_set(vm, VCPU_ID, &regs);	\
+		vcpu_regs_set(vm, vcpu->id, &regs);	\
 	} while (0)
 #define  MOVE_RIP(v)  SET_RIP(regs.rip + (v));
 
@@ -80,6 +76,7 @@ int main(void)
 {
 	struct kvm_guest_debug debug;
 	unsigned long long target_dr6, target_rip;
+	struct kvm_vcpu *vcpu;
 	struct kvm_regs regs;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
@@ -101,14 +98,14 @@ int main(void)
 		return 0;
 	}
 
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	run = vcpu_state(vm, VCPU_ID);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
 
 	/* Test software BPs - int3 */
-	CLEAR_DEBUG();
+	memset(&debug, 0, sizeof(debug));
 	debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
-	APPLY_DEBUG();
-	vcpu_run(vm, VCPU_ID);
+	vcpu_guest_debug_set(vm, vcpu->id, &debug);
+	vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
 		    run->debug.arch.exception == BP_VECTOR &&
 		    run->debug.arch.pc == CAST_TO_RIP(sw_bp),
@@ -119,12 +116,12 @@ int main(void)
 
 	/* Test instruction HW BP over DR[0-3] */
 	for (i = 0; i < 4; i++) {
-		CLEAR_DEBUG();
+		memset(&debug, 0, sizeof(debug));
 		debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW_BP;
 		debug.arch.debugreg[i] = CAST_TO_RIP(hw_bp);
 		debug.arch.debugreg[7] = 0x400 | (1UL << (2*i+1));
-		APPLY_DEBUG();
-		vcpu_run(vm, VCPU_ID);
+		vcpu_guest_debug_set(vm, vcpu->id, &debug);
+		vcpu_run(vm, vcpu->id);
 		target_dr6 = 0xffff0ff0 | (1UL << i);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
 			    run->debug.arch.exception == DB_VECTOR &&
@@ -141,13 +138,13 @@ int main(void)
 
 	/* Test data access HW BP over DR[0-3] */
 	for (i = 0; i < 4; i++) {
-		CLEAR_DEBUG();
+		memset(&debug, 0, sizeof(debug));
 		debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW_BP;
 		debug.arch.debugreg[i] = CAST_TO_RIP(guest_value);
 		debug.arch.debugreg[7] = 0x00000400 | (1UL << (2*i+1)) |
 		    (0x000d0000UL << (4*i));
-		APPLY_DEBUG();
-		vcpu_run(vm, VCPU_ID);
+		vcpu_guest_debug_set(vm, vcpu->id, &debug);
+		vcpu_run(vm, vcpu->id);
 		target_dr6 = 0xffff0ff0 | (1UL << i);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
 			    run->debug.arch.exception == DB_VECTOR &&
@@ -167,15 +164,15 @@ int main(void)
 	/* Test single step */
 	target_rip = CAST_TO_RIP(ss_start);
 	target_dr6 = 0xffff4ff0ULL;
-	vcpu_regs_get(vm, VCPU_ID, &regs);
+	vcpu_regs_get(vm, vcpu->id, &regs);
 	for (i = 0; i < (sizeof(ss_size) / sizeof(ss_size[0])); i++) {
 		target_rip += ss_size[i];
-		CLEAR_DEBUG();
+		memset(&debug, 0, sizeof(debug));
 		debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLESTEP |
 				KVM_GUESTDBG_BLOCKIRQ;
 		debug.arch.debugreg[7] = 0x00000400;
-		APPLY_DEBUG();
-		vcpu_run(vm, VCPU_ID);
+		vcpu_guest_debug_set(vm, vcpu->id, &debug);
+		vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
 			    run->debug.arch.exception == DB_VECTOR &&
 			    run->debug.arch.pc == target_rip &&
@@ -188,11 +185,11 @@ int main(void)
 	}
 
 	/* Finally test global disable */
-	CLEAR_DEBUG();
+	memset(&debug, 0, sizeof(debug));
 	debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW_BP;
 	debug.arch.debugreg[7] = 0x400 | DR7_GD;
-	APPLY_DEBUG();
-	vcpu_run(vm, VCPU_ID);
+	vcpu_guest_debug_set(vm, vcpu->id, &debug);
+	vcpu_run(vm, vcpu->id);
 	target_dr6 = 0xffff0ff0 | DR6_BD;
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
 		    run->debug.arch.exception == DB_VECTOR &&
@@ -205,12 +202,12 @@ int main(void)
 			    target_dr6);
 
 	/* Disable all debug controls, run to the end */
-	CLEAR_DEBUG();
-	APPLY_DEBUG();
+	memset(&debug, 0, sizeof(debug));
+	vcpu_guest_debug_set(vm, vcpu->id, &debug);
 
-	vcpu_run(vm, VCPU_ID);
+	vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO, "KVM_EXIT_IO");
-	cmd = get_ucall(vm, VCPU_ID, &uc);
+	cmd = get_ucall(vm, vcpu->id, &uc);
 	TEST_ASSERT(cmd == UCALL_DONE, "UCALL_DONE");
 
 	kvm_vm_free(vm);
-- 
2.36.1.255.ge46751e96f-goog

