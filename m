Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49274165DA
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 21:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242935AbhIWTSA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 15:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242917AbhIWTR7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 15:17:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C046EC061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:27 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 63-20020a250d42000000b0059dc43162c9so298999ybn.23
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RpCaoc9NjAjS8EPpoMHzceVcM/1k9Q8w60NaBShbdjk=;
        b=co+l9oAZ6355c5KhVTyfzYGWYP4Nz4ZFxvDXKSvChvxDr80DIEgkapPvd97PPbdvea
         VOZss+k6ebLGG56OKre3eSslEiClTm8WuzSWmupPzatR6i0tjpNlx5ocuWQPAIwGisvC
         ZUo8fhiOkMNAHNBGjLsjxvkmyAAAXyXzsd/cdzxRVBqRtps4eqF5BzcPy81nrqx6/bH6
         sBcJqbW1Sy4SinO0XY0qnxlxnSNSAakTfL+Bry8VNLW66ZM5XfDwH7xMgN9RzCDzvkMU
         PdiANmn/wMNAHVhRhoNTb6qWJBxiYdXY14otq5o+X9aKtS3x21wgZQXTulAAN7RCtrDZ
         Yrlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RpCaoc9NjAjS8EPpoMHzceVcM/1k9Q8w60NaBShbdjk=;
        b=TJBk/AcdWIwgyhrdkuwiRkmRHWxpawhqsfbCikpoQV1nQyMV1A+2ozaS46RmlEC6/d
         d0LcX1LCzBzPDn/5Db/WA3qh3UN76vGTwG3v/MUkFTMitOaj0DtF3R5zfWe6mtEQ5TDZ
         6DlIQkC556fRtWwYvfxKZ9+rHgOXL6HdvEHSt+NFaOS6jqzZ04jP8ztDoeO0QkDjnw2X
         4b7uPYrtczJy2ZxlRxprlaLDuZIVlIdcZJh0YSvwyQJYxH57OLh4K7qxcpPHF27dLKoI
         snt4DuxxEmXsKd4NB1ai9d1Y7yMoqZPraAphcmSXzDc2se/fgC0bqju/f7S3YqEO6PQW
         2Iew==
X-Gm-Message-State: AOAM532qP0EYyfTJreXjIx3fYOKq9Y/qkTQUf4vaBB2InhPhp/suzzUw
        CmZYIhPerSkcW5Am2sScTg4nnO3cIJQ=
X-Google-Smtp-Source: ABdhPJwtQ6SLPk6GlotikeJMiXCr9jbW1lJ4tjuIL9GlrCgGr5LzgSgMMJ90sHZpVANG5pT8u15504jtnvM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:dd6:: with SMTP id 205mr7437042ybn.82.1632424586935;
 Thu, 23 Sep 2021 12:16:26 -0700 (PDT)
Date:   Thu, 23 Sep 2021 19:16:09 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-11-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 10/11] selftests: KVM: Refactor psci_test to make it
 amenable to new tests
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split up the current test into several helpers that will be useful to
subsequent test cases added to the PSCI test suite.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c | 68 ++++++++++++-------
 1 file changed, 45 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 8d043e12b137..90312be335da 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -45,7 +45,7 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
 	return res.a0;
 }
 
-static void guest_main(uint64_t target_cpu)
+static void guest_test_cpu_on(uint64_t target_cpu)
 {
 	GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
 	uint64_t target_state;
@@ -69,12 +69,10 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
 	vcpu_set_mp_state(vm, vcpuid, &mp_state);
 }
 
-int main(void)
+static struct kvm_vm *setup_vm(void *guest_code)
 {
-	uint64_t target_mpidr, obs_pc, obs_x0;
 	struct kvm_vcpu_init init;
 	struct kvm_vm *vm;
-	struct ucall uc;
 
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
 	kvm_vm_elf_load(vm, program_invocation_name);
@@ -83,31 +81,28 @@ int main(void)
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
 
-	aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_main);
-	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
+	aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_code);
+	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_code);
 
-	/*
-	 * make sure the target is already off when executing the test.
-	 */
-	vcpu_power_off(vm, VCPU_ID_TARGET);
+	return vm;
+}
 
-	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
-	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
-	vcpu_run(vm, VCPU_ID_SOURCE);
+static void enter_guest(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct ucall uc;
 
-	switch (get_ucall(vm, VCPU_ID_SOURCE, &uc)) {
-	case UCALL_DONE:
-		break;
-	case UCALL_ABORT:
+	vcpu_run(vm, vcpuid);
+	if (get_ucall(vm, vcpuid, &uc) == UCALL_ABORT)
 		TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0], __FILE__,
 			  uc.args[1]);
-		break;
-	default:
-		TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
-	}
+}
 
-	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.pc), &obs_pc);
-	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
+static void assert_vcpu_reset(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	uint64_t obs_pc, obs_x0;
+
+	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &obs_pc);
+	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
 
 	TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
 		    "unexpected target cpu pc: %lx (expected: %lx)",
@@ -115,7 +110,34 @@ int main(void)
 	TEST_ASSERT(obs_x0 == CPU_ON_CONTEXT_ID,
 		    "unexpected target context id: %lx (expected: %lx)",
 		    obs_x0, CPU_ON_CONTEXT_ID);
+}
 
+static void host_test_cpu_on(void)
+{
+	uint64_t target_mpidr;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = setup_vm(guest_test_cpu_on);
+
+	/*
+	 * make sure the target is already off when executing the test.
+	 */
+	vcpu_power_off(vm, VCPU_ID_TARGET);
+
+	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
+	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
+	enter_guest(vm, VCPU_ID_SOURCE);
+
+	if (get_ucall(vm, VCPU_ID_SOURCE, &uc) != UCALL_DONE)
+		TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
+
+	assert_vcpu_reset(vm, VCPU_ID_TARGET);
 	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	host_test_cpu_on();
 	return 0;
 }
-- 
2.33.0.685.g46640cef36-goog

