Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DED51B36F
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381583AbiEDXFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380200AbiEDW7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:59:49 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F8A56C10
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:53:01 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id t14-20020a1709028c8e00b0015cf7e541feso1376664plo.1
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ejt3XeASRuxrfpgeoyKmbPytv7MRM47JDoD5bu32ApE=;
        b=U1leitxRyCTziij67KBTtIJ3cMUxmcH5nAhK83lUpZeHQvXaR7vEWxe0/a9IMlrCs9
         57QLP5rhy9GVxUHlfgpglYR9N2UTyMhzIQOIQE7YaTDmhMZ9DWyxJ5qfw4HCRi00xgh6
         tUbrXA+8xZoiY9D6uRB7mitZYoQVAXemFfxfwq4UYf86bHEf/w7Qo5f4CSTiSwmiLL6Y
         zFjAZ6dKUKq0UtUnkvWzRunr5zcLko0I+SR6FE1C9ZOr2GXSXY+o07Q7/wr/juslHrmt
         9Lww78H95rvJVvTJJJgYRSHL+9GoJ7JckZ+QE+VjKKnwzQDFGYvm5InKPHmLcqNN/tKt
         Sibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ejt3XeASRuxrfpgeoyKmbPytv7MRM47JDoD5bu32ApE=;
        b=kZ7ByqxwZyGz/LRT0S6fT3IshYuaOzfwmwIVprxW8EdhyZpxkgj07cH+3hQuMo093k
         cMtyn4EZ/3uU2b7iSyQMG0kRMVa/HcD5adjL6PR+QhG9PINKbrO7WNe689ADrpZidHbi
         ysGawcezt20lZ5qOhV077Wx14FFD8PVUpLJIPi7r/XZOmjnw6r/wUfsfAx1KsvYRWM3b
         JuMLpNzSnkU5RzcdoWqjIqVKOLmP11O8mVbD7Nhe4lrlyVoxEea786CjkpmxRJPgmrum
         e4JDZX+kFNHgbDWuMnxVxEgmP2bv6k0AVYi0zLpei1D+ebA7w6rwV6q2MujN7Sr8pL5z
         lFnQ==
X-Gm-Message-State: AOAM5321mWPf22nmz3jyCUuf0HYLCsnWfdgtMgqQeTXgGzW8q7gmPIkQ
        v1QzkBEywMXYc6wFZVvJrX2hmSd7d7I=
X-Google-Smtp-Source: ABdhPJxJynHUNPShFz67qglSHrFGi4CecsJCJLogHPZYvdy1VcOJ/xScDb6A8Xm9vqrlQH7x4lvqvEE3Y4s=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:1d9:56e7:4e83 with SMTP id
 w6-20020a17090ac98600b001d956e74e83mr140243pjt.1.1651704751970; Wed, 04 May
 2022 15:52:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:51 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-106-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 105/128] KVM: selftests: Convert s390's "resets" test away
 from VCPU_ID
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass around a 'struct kvm_vcpu' object in the "resets" test instead of
referencing the vCPU by the global VCPU_ID.  Rename the #define for the
vCPU's ID to ARBITRARY_NON_ZERO_VCPU_ID to make it more obvious that (a)
the value matters but (b) is otherwise arbitrary.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/s390x/resets.c | 137 ++++++++++++---------
 1 file changed, 77 insertions(+), 60 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index cc4b7c86d69f..c9233f14689c 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -13,14 +13,12 @@
 #include "test_util.h"
 #include "kvm_util.h"
 
-#define VCPU_ID 3
 #define LOCAL_IRQS 32
 
-struct kvm_s390_irq buf[VCPU_ID + LOCAL_IRQS];
+#define ARBITRARY_NON_ZERO_VCPU_ID 3
+
+struct kvm_s390_irq buf[ARBITRARY_NON_ZERO_VCPU_ID + LOCAL_IRQS];
 
-struct kvm_vm *vm;
-struct kvm_run *run;
-struct kvm_sync_regs *sync_regs;
 static uint8_t regs_null[512];
 
 static void guest_code_initial(void)
@@ -58,25 +56,25 @@ static void guest_code_initial(void)
 		);
 }
 
-static void test_one_reg(uint64_t id, uint64_t value)
+static void test_one_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t value)
 {
 	struct kvm_one_reg reg;
 	uint64_t eval_reg;
 
 	reg.addr = (uintptr_t)&eval_reg;
 	reg.id = id;
-	vcpu_get_reg(vm, VCPU_ID, &reg);
+	vcpu_get_reg(vcpu->vm, vcpu->id, &reg);
 	TEST_ASSERT(eval_reg == value, "value == 0x%lx", value);
 }
 
-static void assert_noirq(void)
+static void assert_noirq(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_irq_state irq_state;
 	int irqs;
 
 	irq_state.len = sizeof(buf);
 	irq_state.buf = (unsigned long)buf;
-	irqs = __vcpu_ioctl(vm, VCPU_ID, KVM_S390_GET_IRQ_STATE, &irq_state);
+	irqs = __vcpu_ioctl(vcpu->vm, vcpu->id, KVM_S390_GET_IRQ_STATE, &irq_state);
 	/*
 	 * irqs contains the number of retrieved interrupts. Any interrupt
 	 * (notably, the emergency call interrupt we have injected) should
@@ -86,19 +84,20 @@ static void assert_noirq(void)
 	TEST_ASSERT(!irqs, "IRQ pending");
 }
 
-static void assert_clear(void)
+static void assert_clear(struct kvm_vcpu *vcpu)
 {
+	struct kvm_sync_regs *sync_regs = &vcpu->run->s.regs;
 	struct kvm_sregs sregs;
 	struct kvm_regs regs;
 	struct kvm_fpu fpu;
 
-	vcpu_regs_get(vm, VCPU_ID, &regs);
+	vcpu_regs_get(vcpu->vm, vcpu->id, &regs);
 	TEST_ASSERT(!memcmp(&regs.gprs, regs_null, sizeof(regs.gprs)), "grs == 0");
 
-	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	vcpu_sregs_get(vcpu->vm, vcpu->id, &sregs);
 	TEST_ASSERT(!memcmp(&sregs.acrs, regs_null, sizeof(sregs.acrs)), "acrs == 0");
 
-	vcpu_fpu_get(vm, VCPU_ID, &fpu);
+	vcpu_fpu_get(vcpu->vm, vcpu->id, &fpu);
 	TEST_ASSERT(!memcmp(&fpu.fprs, regs_null, sizeof(fpu.fprs)), "fprs == 0");
 
 	/* sync regs */
@@ -112,8 +111,10 @@ static void assert_clear(void)
 		    "vrs0-15 == 0 (sync_regs)");
 }
 
-static void assert_initial_noclear(void)
+static void assert_initial_noclear(struct kvm_vcpu *vcpu)
 {
+	struct kvm_sync_regs *sync_regs = &vcpu->run->s.regs;
+
 	TEST_ASSERT(sync_regs->gprs[0] == 0xffff000000000000UL,
 		    "gpr0 == 0xffff000000000000 (sync_regs)");
 	TEST_ASSERT(sync_regs->gprs[1] == 0x0000555500000000UL,
@@ -127,13 +128,14 @@ static void assert_initial_noclear(void)
 	TEST_ASSERT(sync_regs->acrs[9] == 1, "ar9 == 1 (sync_regs)");
 }
 
-static void assert_initial(void)
+static void assert_initial(struct kvm_vcpu *vcpu)
 {
+	struct kvm_sync_regs *sync_regs = &vcpu->run->s.regs;
 	struct kvm_sregs sregs;
 	struct kvm_fpu fpu;
 
 	/* KVM_GET_SREGS */
-	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	vcpu_sregs_get(vcpu->vm, vcpu->id, &sregs);
 	TEST_ASSERT(sregs.crs[0] == 0xE0UL, "cr0 == 0xE0 (KVM_GET_SREGS)");
 	TEST_ASSERT(sregs.crs[14] == 0xC2000000UL,
 		    "cr14 == 0xC2000000 (KVM_GET_SREGS)");
@@ -156,36 +158,38 @@ static void assert_initial(void)
 	TEST_ASSERT(sync_regs->gbea == 1, "gbea == 1 (sync_regs)");
 
 	/* kvm_run */
-	TEST_ASSERT(run->psw_addr == 0, "psw_addr == 0 (kvm_run)");
-	TEST_ASSERT(run->psw_mask == 0, "psw_mask == 0 (kvm_run)");
+	TEST_ASSERT(vcpu->run->psw_addr == 0, "psw_addr == 0 (kvm_run)");
+	TEST_ASSERT(vcpu->run->psw_mask == 0, "psw_mask == 0 (kvm_run)");
 
-	vcpu_fpu_get(vm, VCPU_ID, &fpu);
+	vcpu_fpu_get(vcpu->vm, vcpu->id, &fpu);
 	TEST_ASSERT(!fpu.fpc, "fpc == 0");
 
-	test_one_reg(KVM_REG_S390_GBEA, 1);
-	test_one_reg(KVM_REG_S390_PP, 0);
-	test_one_reg(KVM_REG_S390_TODPR, 0);
-	test_one_reg(KVM_REG_S390_CPU_TIMER, 0);
-	test_one_reg(KVM_REG_S390_CLOCK_COMP, 0);
+	test_one_reg(vcpu, KVM_REG_S390_GBEA, 1);
+	test_one_reg(vcpu, KVM_REG_S390_PP, 0);
+	test_one_reg(vcpu, KVM_REG_S390_TODPR, 0);
+	test_one_reg(vcpu, KVM_REG_S390_CPU_TIMER, 0);
+	test_one_reg(vcpu, KVM_REG_S390_CLOCK_COMP, 0);
 }
 
-static void assert_normal_noclear(void)
+static void assert_normal_noclear(struct kvm_vcpu *vcpu)
 {
+	struct kvm_sync_regs *sync_regs = &vcpu->run->s.regs;
+
 	TEST_ASSERT(sync_regs->crs[2] == 0x10, "cr2 == 10 (sync_regs)");
 	TEST_ASSERT(sync_regs->crs[8] == 1, "cr10 == 1 (sync_regs)");
 	TEST_ASSERT(sync_regs->crs[10] == 1, "cr10 == 1 (sync_regs)");
 	TEST_ASSERT(sync_regs->crs[11] == -1, "cr11 == -1 (sync_regs)");
 }
 
-static void assert_normal(void)
+static void assert_normal(struct kvm_vcpu *vcpu)
 {
-	test_one_reg(KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
-	TEST_ASSERT(sync_regs->pft == KVM_S390_PFAULT_TOKEN_INVALID,
+	test_one_reg(vcpu, KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
+	TEST_ASSERT(vcpu->run->s.regs.pft == KVM_S390_PFAULT_TOKEN_INVALID,
 			"pft == 0xff.....  (sync_regs)");
-	assert_noirq();
+	assert_noirq(vcpu);
 }
 
-static void inject_irq(int cpu_id)
+static void inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_irq_state irq_state;
 	struct kvm_s390_irq *irq = &buf[0];
@@ -195,73 +199,86 @@ static void inject_irq(int cpu_id)
 	irq_state.len = sizeof(struct kvm_s390_irq);
 	irq_state.buf = (unsigned long)buf;
 	irq->type = KVM_S390_INT_EMERGENCY;
-	irq->u.emerg.code = cpu_id;
-	irqs = __vcpu_ioctl(vm, cpu_id, KVM_S390_SET_IRQ_STATE, &irq_state);
+	irq->u.emerg.code = vcpu->id;
+	irqs = __vcpu_ioctl(vcpu->vm, vcpu->id, KVM_S390_SET_IRQ_STATE, &irq_state);
 	TEST_ASSERT(irqs >= 0, "Error injecting EMERGENCY IRQ errno %d\n", errno);
 }
 
+static struct kvm_vm *create_vm(struct kvm_vcpu **vcpu)
+{
+	struct kvm_vm *vm;
+
+	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
+
+	*vcpu = vm_vcpu_add(vm, ARBITRARY_NON_ZERO_VCPU_ID, guest_code_initial);
+
+	return vm;
+}
+
 static void test_normal(void)
 {
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
 	pr_info("Testing normal reset\n");
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
-	run = vcpu_state(vm, VCPU_ID);
-	sync_regs = &run->s.regs;
+	vm = create_vm(&vcpu);
 
-	vcpu_run(vm, VCPU_ID);
+	vcpu_run(vm, vcpu->id);
 
-	inject_irq(VCPU_ID);
+	inject_irq(vcpu);
 
-	vcpu_ioctl(vm, VCPU_ID, KVM_S390_NORMAL_RESET, 0);
+	vcpu_ioctl(vm, vcpu->id, KVM_S390_NORMAL_RESET, 0);
 
 	/* must clears */
-	assert_normal();
+	assert_normal(vcpu);
 	/* must not clears */
-	assert_normal_noclear();
-	assert_initial_noclear();
+	assert_normal_noclear(vcpu);
+	assert_initial_noclear(vcpu);
 
 	kvm_vm_free(vm);
 }
 
 static void test_initial(void)
 {
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
 	pr_info("Testing initial reset\n");
-	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
-	run = vcpu_state(vm, VCPU_ID);
-	sync_regs = &run->s.regs;
+	vm = create_vm(&vcpu);
 
-	vcpu_run(vm, VCPU_ID);
+	vcpu_run(vm, vcpu->id);
 
-	inject_irq(VCPU_ID);
+	inject_irq(vcpu);
 
-	vcpu_ioctl(vm, VCPU_ID, KVM_S390_INITIAL_RESET, 0);
+	vcpu_ioctl(vm, vcpu->id, KVM_S390_INITIAL_RESET, 0);
 
 	/* must clears */
-	assert_normal();
-	assert_initial();
+	assert_normal(vcpu);
+	assert_initial(vcpu);
 	/* must not clears */
-	assert_initial_noclear();
+	assert_initial_noclear(vcpu);
 
 	kvm_vm_free(vm);
 }
 
 static void test_clear(void)
 {
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
 	pr_info("Testing clear reset\n");
-	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
-	run = vcpu_state(vm, VCPU_ID);
-	sync_regs = &run->s.regs;
+	vm = create_vm(&vcpu);
 
-	vcpu_run(vm, VCPU_ID);
+	vcpu_run(vm, vcpu->id);
 
-	inject_irq(VCPU_ID);
+	inject_irq(vcpu);
 
-	vcpu_ioctl(vm, VCPU_ID, KVM_S390_CLEAR_RESET, 0);
+	vcpu_ioctl(vm, vcpu->id, KVM_S390_CLEAR_RESET, 0);
 
 	/* must clears */
-	assert_normal();
-	assert_initial();
-	assert_clear();
+	assert_normal(vcpu);
+	assert_initial(vcpu);
+	assert_clear(vcpu);
 
 	kvm_vm_free(vm);
 }
-- 
2.36.0.464.gb9c8b46e94-goog

