Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD38E4165DD
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 21:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242911AbhIWTSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 15:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242929AbhIWTSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 15:18:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43B2C061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i77-20020a25d150000000b005b1d20152b0so299874ybg.14
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iaLxJyQl/R2XLxgbK/Yc9KCKg/FcSd6fsVvahhw1gbk=;
        b=MqZIRMrNmbaHF93vIL8MIjYz2FQMq964YhsWtPj5J9/0PZjaTBZpanOXfeFLtiaHD6
         Hsgb+G10pPVRL3jFu9SHOfUQVSQ7fGYx/a82WtqnoWdfGLYU2XoGYrqILas2jRPIB+/E
         kmYvDT8rmmUHm2NSVM0jhH3pOM6ZobF3TeTwVtJtYZKa9pvK+gVSBWawg72Bvnql/ZaW
         jnudsfUiXLzKsyUzFN8yATBQoCq2+iJdo2ChUcjejGtjDrjsCYIVX1iLmpqv2SVDf9/r
         WOpKinDu5OyTWsFnWFIcnGYP9vXMkQFAcN6ygsEvgfxniC2rcaMQlYG0BigOBa9xfF8s
         uPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iaLxJyQl/R2XLxgbK/Yc9KCKg/FcSd6fsVvahhw1gbk=;
        b=m7QDqGMT8MPLkjzGHs4sy38ADFDwffNZ0J4X0gfqam3aH9x1KKbKxsJ5EryrhCwZuZ
         0ZFQF4oPECCsr/E4H3qdgqkYH/cp/NGAJ4DC8UeEWTr/eMzuYQ+n2lxjN7tC/qfb5AwO
         qFN9X0EDmX05JQzLhmEVjDbGbi2O/0bcjbaHLxsRJTcWU5DO0GDd0xZXs2MLMerJ/OCR
         qa2TFIukXPf+I+zQ+bQDLuYW7V5WJ0GZv50G6oSodUsZIP3WOr6FqptRp1hh1Y4E/qVN
         nA+gDhn0DuEuU1cHktzp5QK+L2XSXQknRcSU7F2nPjBN/Qb8bWjT9DLamcMBfLbKuxQm
         HXUQ==
X-Gm-Message-State: AOAM531hXPSWiKb5m+GJc2NzxTQGie8FF3SK81158Yoz8z4mGI5r/kyK
        lPXtiNw+nXgn7ys87Q42fAdedCbFuLo=
X-Google-Smtp-Source: ABdhPJyjXGf6r7078NOSI+fwirDQAYTFCKMH/ZKp0jWghQ7m5qJfBJ9PqydzFMi5FrxM+rw+lmH3oJ2XpIA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:2d4c:: with SMTP id s12mr7301465ybe.350.1632424587972;
 Thu, 23 Sep 2021 12:16:27 -0700 (PDT)
Date:   Thu, 23 Sep 2021 19:16:10 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-12-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 11/11] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
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

Assert that the vCPU exits to userspace with KVM_SYSTEM_EVENT_SUSPEND if
it correctly executes the SYSTEM_SUSPEND PSCI call. Additionally, assert
that the guest PSCI call fails if preconditions are not met (more than 1
running vCPU).

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 90312be335da..5b881ca4d102 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -45,6 +45,16 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
 	return res.a0;
 }
 
+static uint64_t psci_system_suspend(uint64_t entry_addr, uint64_t context_id)
+{
+	struct arm_smccc_res res;
+
+	smccc_hvc(PSCI_1_0_FN64_SYSTEM_SUSPEND, entry_addr, context_id,
+		  0, 0, 0, 0, 0, &res);
+
+	return res.a0;
+}
+
 static void guest_test_cpu_on(uint64_t target_cpu)
 {
 	GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
@@ -69,6 +79,13 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
 	vcpu_set_mp_state(vm, vcpuid, &mp_state);
 }
 
+static void guest_test_system_suspend(void)
+{
+	uint64_t r = psci_system_suspend(CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID);
+
+	GUEST_SYNC(r);
+}
+
 static struct kvm_vm *setup_vm(void *guest_code)
 {
 	struct kvm_vcpu_init init;
@@ -136,8 +153,66 @@ static void host_test_cpu_on(void)
 	kvm_vm_free(vm);
 }
 
+static void enable_system_suspend(struct kvm_vm *vm)
+{
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_ARM_SYSTEM_SUSPEND,
+	};
+
+	vm_enable_cap(vm, &cap);
+}
+
+static void host_test_system_suspend(void)
+{
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+
+	vm = setup_vm(guest_test_system_suspend);
+	enable_system_suspend(vm);
+
+	vcpu_power_off(vm, VCPU_ID_TARGET);
+	run = vcpu_state(vm, VCPU_ID_SOURCE);
+
+	enter_guest(vm, VCPU_ID_SOURCE);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
+		    "Unhandled exit reason: %u (%s)",
+		    run->exit_reason, exit_reason_str(run->exit_reason));
+	TEST_ASSERT(run->system_event.type == KVM_SYSTEM_EVENT_SUSPEND,
+		    "Unhandled system event: %u (expected: %u)",
+		    run->system_event.type, KVM_SYSTEM_EVENT_SUSPEND);
+
+	assert_vcpu_reset(vm, VCPU_ID_SOURCE);
+	kvm_vm_free(vm);
+}
+
+static void host_test_system_suspend_fails(void)
+{
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = setup_vm(guest_test_system_suspend);
+	enable_system_suspend(vm);
+
+	enter_guest(vm, VCPU_ID_SOURCE);
+	TEST_ASSERT(get_ucall(vm, VCPU_ID_SOURCE, &uc) == UCALL_SYNC,
+		    "Unhandled ucall: %lu", uc.cmd);
+	TEST_ASSERT(uc.args[1] == PSCI_RET_DENIED,
+		    "Unrecognized PSCI return code: %lu (expected: %u)",
+		    uc.args[1], PSCI_RET_DENIED);
+
+	kvm_vm_free(vm);
+}
+
 int main(void)
 {
+	if (!kvm_check_cap(KVM_CAP_ARM_SYSTEM_SUSPEND)) {
+		print_skip("KVM_CAP_ARM_SYSTEM_SUSPEND not supported");
+		exit(KSFT_SKIP);
+	}
+
 	host_test_cpu_on();
+	host_test_system_suspend();
+	host_test_system_suspend_fails();
 	return 0;
 }
-- 
2.33.0.685.g46640cef36-goog

