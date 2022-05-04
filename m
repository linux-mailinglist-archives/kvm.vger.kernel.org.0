Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5944351B2EA
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379404AbiEDW5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379323AbiEDW4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:56:03 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C335354BC3
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:37 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id u1-20020a17090a2b8100b001d9325a862fso1080335pjd.6
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=E8bGK5PVBFzhrYg0aSqyNIfNbUg8lebD5YMo3ihXQFw=;
        b=ju6DgO2ll2SfG1Q2SHpR1TiItryw2hgtmZj/p0en6P3uzs2vdVd/ZPdjPEc8lOpjZU
         sI+Za/opR98R/IdVTxXW1okhIWA+Xk4hYlG0O+9SJ+aLU8BXMH1CTvbGl3NXPjhp3O+b
         sN9sjF8LPvr1hcGz8srPPMzHkUfN2gG2PK5j4lTpbMRG/dy87D8AVQcwgP9/UT1CclfQ
         r5ocz15hhAhDWHbgRceohMTnb4XzMVTnjt0rlrr5lXoBc9bBsC4xJKDrAEmRKv2t/dqQ
         seqx5pCTcwThNcFNGHqdRrfQW+v0+dCG1aTeaROOvz7Ps/rv6M0XJd6TVa8VbC0fk7mG
         xbWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=E8bGK5PVBFzhrYg0aSqyNIfNbUg8lebD5YMo3ihXQFw=;
        b=s8Qnp+jiEfabMyPpC1/+o1uFpKTHBMC5S2RNUs2c3+Kgrt6OqVfFCApeL+FC4C6EiL
         7z5T5S+7sGTQHcBNyLqGoqWyWkK2qS3ai/rfbKTmA0ROIUGeppcjPJM9dW0KbNzMfrrX
         W5wA+VUBnFp0PAp2EOq3Z1n7PTlZ4cRMG/KP4ql0lo9OTbNYP7tYdsFk9OFbgELoWR/x
         9+6mEJPtj9GwLKF0M6m3mfH8OBAzcYfETNWiXZyY0qbYQ22/PMvqs+HcVo70edUkHUHi
         xYSvgx1WiPln0lTVfEAG0g/jX1Aja+rJETi+jJsIgFn8SBTRRq/7ssKq6qSbl3an5jiA
         2wvg==
X-Gm-Message-State: AOAM531wEu11LLAmtvSrX3s+fPYWwaL7wmerNRO/GPk/BFJhJEbCy4/q
        LxHRJigeNM6h0Xv7PF1mCNGMqdMJop0=
X-Google-Smtp-Source: ABdhPJyVv2gHDUooRrhrjR1Cxdy1ukNh4vqDHRZo5cApp1oPleS+KQOPaPD88ELcqjP5znH58I0nVn+c+n8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a06:b0:4fc:d6c5:f3d7 with SMTP id
 g6-20020a056a001a0600b004fcd6c5f3d7mr22897547pfv.53.1651704697249; Wed, 04
 May 2022 15:51:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:19 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-74-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 073/128] KVM: selftests: Convert debug_regs away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
index 5f078db1bcba..b999c9753fc3 100644
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
-#define  APPLY_DEBUG()  vcpu_set_guest_debug(vm, VCPU_ID, &debug)
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
+	vcpu_set_guest_debug(vm, vcpu->id, &debug);
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
+		vcpu_set_guest_debug(vm, vcpu->id, &debug);
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
+		vcpu_set_guest_debug(vm, vcpu->id, &debug);
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
+		vcpu_set_guest_debug(vm, vcpu->id, &debug);
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
+	vcpu_set_guest_debug(vm, vcpu->id, &debug);
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
+	vcpu_set_guest_debug(vm, vcpu->id, &debug);
 
-	vcpu_run(vm, VCPU_ID);
+	vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO, "KVM_EXIT_IO");
-	cmd = get_ucall(vm, VCPU_ID, &uc);
+	cmd = get_ucall(vm, vcpu->id, &uc);
 	TEST_ASSERT(cmd == UCALL_DONE, "UCALL_DONE");
 
 	kvm_vm_free(vm);
-- 
2.36.0.464.gb9c8b46e94-goog

