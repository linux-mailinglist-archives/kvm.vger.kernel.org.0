Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6155C53C2A5
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240688AbiFCA5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240759AbiFCAuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:07 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B209D2458B
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:08 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id m5-20020a17090a4d8500b001e0cfe135c7so3411641pjh.3
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SUSBvq+yOLMaxNvGnQWV114iFEv+Mzc/vwuqUVp/f1w=;
        b=SiWy0tDdCzYtE/3vy+MHM3jxSD2HfYrrWSZ4ct5jdxuWjbBNMTNpQMk9Bff2jMXG/s
         SBzHimlCB8bKCqp4/nTUuYGhpDfIVG2OESdiiXSOE2R5MdzznLw88/imQNpgAiu5dT6L
         Z5ICsE8ucbL4ogOUQ+JBT4AIbqAc3HT9nuHSVFSRD3eyP5CTeRG/apxoz3E1stJm/d9X
         E8NNGkOqXjzbxMLdxhLPL4xWCREcEyZDLPmf+fnz3wWsWtiKAt37eb660Xn9pMfyKnft
         MjoMYVPBlUqPF+1PIk6XeJIaDiBPH3XVIGbuVFlmD5Yvh3/mb8CGj/E9qAqtD37hkKkt
         h7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SUSBvq+yOLMaxNvGnQWV114iFEv+Mzc/vwuqUVp/f1w=;
        b=AfsRaCBwKX5MXhswQl/eXXNKC9dMkQglu7kXrqAmfyg7J1DXV5J1J1U8ZhfBHMrgqu
         QplCQn8okaJAON6EA7rzvmPbcT3Nupwe93JSVOcyNFI9hNapJlDs4YxTRsyzYQXqSc4w
         kl43EtizMMBad+wUYC1O0YfpG03zcy0tOkXU9r+MMBs8sDTHCh6+6Yt3MNuBCCY86JWT
         Q2zF9b4m/1uWbExVpjgNn/xeNFXn7XcLGXBRtDIwTGdcBL2TsrBplkoMC9U9FV7KC/DD
         GhQZ1OrexH4KpbmMFO/45THCZcTJOUQvFNAnkf9vSSEylJBAAhSM41E6L6Y/X6qSGjLQ
         90yA==
X-Gm-Message-State: AOAM531EFrZl8WXkLA4gU/0kneALOzhiJSjh+s5kldJ8d3NrvSWUnydL
        97ndCROrSBue81Ja+2ZeXQbYa2I/AMk=
X-Google-Smtp-Source: ABdhPJySs/uBwgb/u9A64yPk/ISneqKw1+cdikIpTTTUATJUs88xlMgcihxZ5bcMsIK13hBtPu1dMwZ8lh8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr307326pje.0.1654217227378; Thu, 02 Jun
 2022 17:47:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:04 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-118-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 117/144] KVM: selftests: Convert s390's "resets" test away
 from VCPU_ID
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

Pass around a 'struct kvm_vcpu' object in the "resets" test instead of
referencing the vCPU by the global VCPU_ID.  Rename the #define for the
vCPU's ID to ARBITRARY_NON_ZERO_VCPU_ID to make it more obvious that (a)
the value matters but (b) is otherwise arbitrary.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/s390x/resets.c | 137 ++++++++++++---------
 1 file changed, 77 insertions(+), 60 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index a62de5351d7b..f7b938f9f2c6 100644
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
@@ -58,22 +56,22 @@ static void guest_code_initial(void)
 		);
 }
 
-static void test_one_reg(uint64_t id, uint64_t value)
+static void test_one_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t value)
 {
 	uint64_t eval_reg;
 
-	vcpu_get_reg(vm, VCPU_ID, id, &eval_reg);
+	vcpu_get_reg(vcpu->vm, vcpu->id, id, &eval_reg);
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
@@ -83,19 +81,20 @@ static void assert_noirq(void)
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
@@ -109,8 +108,10 @@ static void assert_clear(void)
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
@@ -124,13 +125,14 @@ static void assert_initial_noclear(void)
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
@@ -153,36 +155,38 @@ static void assert_initial(void)
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
@@ -192,73 +196,86 @@ static void inject_irq(int cpu_id)
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
2.36.1.255.ge46751e96f-goog

