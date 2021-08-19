Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293D43F2337
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 00:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbhHSWh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 18:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236451AbhHSWh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 18:37:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A3FC061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:36:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c63-20020a25e5420000b0290580b26e708aso7936968ybh.12
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GduHB+LuNnn17JQwnFUUGpb4vq7FFHKWtZZovjljTrc=;
        b=Y7dntEfFJ7WOljoIUDV8MWAx6zh8vpEV5M0aVv8qhZkVXDbtKyGp1R1SfOUpR33Qhh
         HFZ+Gt/r+2DpTUTps/8+FYOiI/WJcGFBsv6I8IvhMsKK3vu/umB3eCecQx6rVc1Oh9H0
         E3fVMGMjz4324zSVAOQXh/gRQUaQssC6XB+9vSLH2ntiTxNUCz42U3H7opsgM6hRk5Hk
         T9JrUODZJMukiLF3PBua4DRyPB7DZhXJ3q+yJ6Y3Y4EbM7FiWAZx3shQfqlwlhW3ri1X
         T3SO3rvBYtG87CWgkwdGMH6xJ7LjUasDbhLQ4mMUJx4XTKTqOZLBTfGHkyAYwxD3ASbM
         A7PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GduHB+LuNnn17JQwnFUUGpb4vq7FFHKWtZZovjljTrc=;
        b=CgSP+JNgWijxkiV7wxtv8TT1a5Du79PchCVKEcv/tESF5zIpqodUPsnAIxLj+Dkm1E
         y985h66pwB5hIwgZ7ByUoY8JrR33ElRbgCK+tBrxFV1hJj1lbX2RtthAFntVpLe2ML+d
         pSlSOJKONwvLDrXj6GCDgj7JFU/ts4Fwzk3OMf8CbxMaWr2e7mP+14Z1/AYhVAjm36eO
         tY+6825GSUVUfQW1b/9u+LZeI5OXbL5zgPxNH1CynC9vbRUTyOJ1rncEGsfHrcLMt+MT
         RLZzWvO0H/H7I3BcTMrC1ZoNzAjWXYTnIvyg1qTVUdOJQTK16XXXMcxrfhIbD+LTuIGe
         W2uQ==
X-Gm-Message-State: AOAM5319yuwNbQBjCxpbXNZ/hNzT5oXQArlcUM46+K+Fw2PKnj9cg/pz
        J+uaTCiO7B2HQmhdge+EPOXHA3UajqiLRh7NExoOjfRCuhHK3fMl+5cu6BeLVK9LGJgfVJuX/Zy
        sPBeAlY7KyOCPa8tW8IJy1hPosyyhskkvuDGIEqwJvgrB7SwQyuokrtvqOg==
X-Google-Smtp-Source: ABdhPJyai54SFGCqbJAplLj6O+77sdh2OKzkezJyM9mmvtg9hY9R1hWBsj/wlH3tzxAlYSHyy9++k6vRs+g=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:d2c6:: with SMTP id j189mr22255168ybg.187.1629412609911;
 Thu, 19 Aug 2021 15:36:49 -0700 (PDT)
Date:   Thu, 19 Aug 2021 22:36:40 +0000
In-Reply-To: <20210819223640.3564975-1-oupton@google.com>
Message-Id: <20210819223640.3564975-7-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 6/6] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test KVM's newly-added support for the SYSTEM_SUSPEND PSCI call. Since
it is ABI that the vCPUs remain runnable after a system exit (i.e. a VMM
can blissfully ignore this exit), assert that the exiting vCPU is reset
at the requested entrypoint.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 110 +++++++++++++-----
 1 file changed, 84 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
index 9c22374fc0f5..b08b006cc4b4 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -54,7 +54,21 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
 	return x0;
 }
 
-static void guest_main(uint64_t target_cpu)
+static uint64_t psci_system_suspend(uint64_t entry_addr, uint64_t context_id)
+{
+	register uint64_t x0 asm("x0") = PSCI_1_0_FN64_SYSTEM_SUSPEND;
+	register uint64_t x1 asm("x1") = entry_addr;
+	register uint64_t x2 asm("x2") = context_id;
+
+	asm volatile("hvc #0"
+		     : "=r"(x0)
+		     : "r"(x0), "r"(x1), "r"(x2)
+		     : "memory");
+
+	return x0;
+}
+
+static void guest_test_cpu_on(uint64_t target_cpu)
 {
 	GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
 	uint64_t target_state;
@@ -69,52 +83,96 @@ static void guest_main(uint64_t target_cpu)
 	GUEST_DONE();
 }
 
+static void guest_test_system_suspend(uint64_t target_cpu)
+{
+	psci_system_suspend(CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID);
+
+	/* should never be reached */
+	GUEST_ASSERT(0);
+}
+
+static void guest_main(uint64_t target_cpu)
+{
+	guest_test_cpu_on(target_cpu);
+	guest_test_system_suspend(target_cpu);
+}
+
 int main(void)
 {
+	struct kvm_mp_state target_mp_state = { .mp_state = KVM_MP_STATE_STOPPED };
 	uint64_t target_mpidr, obs_pc, obs_x0;
+	struct kvm_enable_cap cap = {0};
+	uint32_t vcpu_to_test = -1;
 	struct kvm_vcpu_init init;
 	struct kvm_vm *vm;
 	struct ucall uc;
+	int i;
+
+	if (!kvm_check_cap(KVM_CAP_ARM_SYSTEM_SUSPEND)) {
+		print_skip("KVM_CAP_ARM_SYSTEM_SUSPEND not supported");
+		exit(KSFT_SKIP);
+	}
 
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
 	kvm_vm_elf_load(vm, program_invocation_name);
 	ucall_init(vm, NULL);
 
+	cap.cap = KVM_CAP_ARM_SYSTEM_SUSPEND;
+	vm_enable_cap(vm, &cap);
+
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
 
 	aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_main);
-
-	/*
-	 * make sure the target is already off when executing the test.
-	 */
-	init.features[0] |= (1 << KVM_ARM_VCPU_POWER_OFF);
 	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
 
 	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
 	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
-	vcpu_run(vm, VCPU_ID_SOURCE);
-
-	switch (get_ucall(vm, VCPU_ID_SOURCE, &uc)) {
-	case UCALL_DONE:
-		break;
-	case UCALL_ABORT:
-		TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0], __FILE__,
-			  uc.args[1]);
-		break;
-	default:
-		TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
-	}
 
-	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.pc), &obs_pc);
-	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
+	for (i = 0; i < 2; i++) {
+		struct kvm_run *run = vcpu_state(vm, VCPU_ID_SOURCE);
+
+		/*
+		 * make sure the target is already off when executing the test.
+		 */
+		vcpu_set_mp_state(vm, VCPU_ID_TARGET, &target_mp_state);
+		vcpu_run(vm, VCPU_ID_SOURCE);
+		switch (run->exit_reason) {
+		case KVM_EXIT_MMIO:
+			switch (get_ucall(vm, VCPU_ID_SOURCE, &uc)) {
+			case UCALL_DONE:
+				vcpu_to_test = VCPU_ID_TARGET;
+				break;
+			case UCALL_ABORT:
+				TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0], __FILE__,
+					  uc.args[1]);
+				break;
+			default:
+				TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
+			}
+			break;
+		case KVM_EXIT_SYSTEM_EVENT:
+			TEST_ASSERT(run->system_event.type == KVM_SYSTEM_EVENT_SUSPEND,
+				    "unhandled system event: %u (expected: %u)",
+				    run->system_event.type, KVM_SYSTEM_EVENT_SUSPEND);
+			vcpu_to_test = VCPU_ID_SOURCE;
+			break;
+		default:
+			TEST_FAIL("unhandled exit reason: %u (%s)",
+				  run->exit_reason, exit_reason_str(run->exit_reason));
+		}
+
+		get_reg(vm, vcpu_to_test, ARM64_CORE_REG(regs.pc), &obs_pc);
+		get_reg(vm, vcpu_to_test, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
+
+		TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
+			    "unexpected target cpu pc: %lx (expected: %lx)",
+			    obs_pc, CPU_ON_ENTRY_ADDR);
+		TEST_ASSERT(obs_x0 == CPU_ON_CONTEXT_ID,
+			    "unexpected target context id: %lx (expected: %lx)",
+			    obs_x0, CPU_ON_CONTEXT_ID);
 
-	TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
-		    "unexpected target cpu pc: %lx (expected: %lx)",
-		    obs_pc, CPU_ON_ENTRY_ADDR);
-	TEST_ASSERT(obs_x0 == CPU_ON_CONTEXT_ID,
-		    "unexpected target context id: %lx (expected: %lx)",
-		    obs_x0, CPU_ON_CONTEXT_ID);
+	}
 
 	kvm_vm_free(vm);
 	return 0;
-- 
2.33.0.rc2.250.ged5fa647cd-goog

