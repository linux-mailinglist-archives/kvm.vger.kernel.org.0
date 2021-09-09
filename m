Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B2B40430E
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 03:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349694AbhIIBm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 21:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350036AbhIIBmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 21:42:14 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82411C06114A
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 18:39:05 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id n12-20020a17090a2fcc00b001971a2d91b9so293774pjm.6
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 18:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fhJBhdTI7Fph8U8UIbebfbsbJEo/+U9ZAKdtVVmT0OQ=;
        b=rP8SFpJgPxh5O3rCo7DlGcKTQcyeoV5/8Amp4gBI8kJiTtJgE1jEuvY/WmpuCQuFdw
         Ol5TEtCV7UxcmNrgAiMoi3ZMFJ1fOL13rECQ6SDHrCnAeHftRvScWKwQtdAh/m1WnwBM
         AwAxJjd4jVZyvg9I3pCCNJufENKS7X9OPjXgh/rNbDIhZ/1NRb7Pb0dZtZL3x0FIoTZw
         WWe9GS21MN2Co959shkpEpn3GO2WxfKW9VfGk06hr770AF+kqaBAsT4Mag16JXd3a5tB
         tOxYrzOzi7UY+KbUpcEPORumjkWyN7gqFlEMSY+ox4pDYJlSUGlLD8U5xqmXzHYzI9mR
         9Khg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fhJBhdTI7Fph8U8UIbebfbsbJEo/+U9ZAKdtVVmT0OQ=;
        b=8QEAixFmJM2+oJpf1BZLvAruggjsZyinIuffp+mScYLelY77z0vn3eiUiQeaE7Jmgk
         jCEPpNbjBVmEy0l17W5WDmQh5s/Tj9tNk2EZV+n+jflePFtFZ2RHKw7rkBfMstoh+X2o
         snhRSDxy1gJ+ooqYVexS7Jb0cr71+pmJNEjRN5cxO+oJsKj0CGbEmmmDW1gRMP0OL5O7
         QJ9g2TMG2zH9XMuwrto/uHosVu128ZqyY8A8XguhuF7Rybumq2nJ5WrUwrVukjxKZ0C4
         jXFOjPgRiBS7k1OLp+zZ8QlHjlcrECnk96nuMb1foHXP2xEgaUKpqRdUs2QdFi9lX0eN
         RmFQ==
X-Gm-Message-State: AOAM531N14keRegCezZ9bbpZl/ecDSymNNCP0R4h5yh45vXcebOYDFTt
        Aji6bS6/A/Rm+/2R9RFb2JgDOBKr0yOu
X-Google-Smtp-Source: ABdhPJy1lNBcGsIrqRNLwlUOtJjNJsPjnKdPd3b+kR3weBs5ZRkHHcD0ZUb/rO+VqjVCBrvKm12LfqSuKHJa
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:fd7:: with SMTP id
 gd23mr51155pjb.1.1631151544636; Wed, 08 Sep 2021 18:39:04 -0700 (PDT)
Date:   Thu,  9 Sep 2021 01:38:17 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-18-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 17/18] KVM: arm64: selftests: Replace ARM64_SYS_REG with ARM64_SYS_KVM_REG
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the introduction of ARM64_SYS_KVM_REG, that takes the
system register encodings from sysreg.h directly, replace
all the users of ARM64_SYS_REG, relyiing on the encodings
created in processor.h, with ARM64_SYS_KVM_REG.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c     |  2 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c     |  3 ++-
 .../selftests/kvm/include/aarch64/processor.h    | 10 ----------
 .../selftests/kvm/lib/aarch64/processor.c        | 16 ++++++++--------
 4 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 11fd23e21cb4..b28b311f4dd7 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -190,7 +190,7 @@ static int debug_version(struct kvm_vm *vm)
 {
 	uint64_t id_aa64dfr0;
 
-	get_reg(vm, VCPU_ID, ARM64_SYS_REG(ID_AA64DFR0_EL1), &id_aa64dfr0);
+	get_reg(vm, VCPU_ID, ARM64_SYS_KVM_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
 	return id_aa64dfr0 & 0xf;
 }
 
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
index 018c269990e1..4c8aa7b8a65d 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -91,7 +91,8 @@ int main(void)
 	init.features[0] |= (1 << KVM_ARM_VCPU_POWER_OFF);
 	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
 
-	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
+	get_reg(vm, VCPU_ID_TARGET,
+		ARM64_SYS_KVM_REG(SYS_MPIDR_EL1), &target_mpidr);
 	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
 	vcpu_run(vm, VCPU_ID_SOURCE);
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 150f63101f4c..ee81dd3db516 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -16,16 +16,6 @@
 #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
 			   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
 
-#define CPACR_EL1               3, 0,  1, 0, 2
-#define TCR_EL1                 3, 0,  2, 0, 2
-#define MAIR_EL1                3, 0, 10, 2, 0
-#define MPIDR_EL1               3, 0,  0, 0, 5
-#define TTBR0_EL1               3, 0,  2, 0, 0
-#define SCTLR_EL1               3, 0,  1, 0, 0
-#define VBAR_EL1                3, 0, 12, 0, 0
-
-#define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
-
 /*
  * ARM64_SYS_KVM_REG(sys_reg_id): Helper macro to convert
  * SYS_* register definitions in sysreg.h to use in KVM
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 9844b62227b1..d7b89aa092f5 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -240,10 +240,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
 	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
 	 * registers, which the variable argument list macros do.
 	 */
-	set_reg(vm, vcpuid, ARM64_SYS_REG(CPACR_EL1), 3 << 20);
+	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_CPACR_EL1), 3 << 20);
 
-	get_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), &sctlr_el1);
-	get_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), &tcr_el1);
+	get_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_SCTLR_EL1), &sctlr_el1);
+	get_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TCR_EL1), &tcr_el1);
 
 	switch (vm->mode) {
 	case VM_MODE_P52V48_4K:
@@ -281,10 +281,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
 	tcr_el1 |= (1 << 8) | (1 << 10) | (3 << 12);
 	tcr_el1 |= (64 - vm->va_bits) /* T0SZ */;
 
-	set_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), sctlr_el1);
-	set_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), tcr_el1);
-	set_reg(vm, vcpuid, ARM64_SYS_REG(MAIR_EL1), DEFAULT_MAIR_EL1);
-	set_reg(vm, vcpuid, ARM64_SYS_REG(TTBR0_EL1), vm->pgd);
+	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_SCTLR_EL1), sctlr_el1);
+	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TCR_EL1), tcr_el1);
+	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
+	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TTBR0_EL1), vm->pgd);
 }
 
 void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
@@ -370,7 +370,7 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	extern char vectors;
 
-	set_reg(vm, vcpuid, ARM64_SYS_REG(VBAR_EL1), (uint64_t)&vectors);
+	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_VBAR_EL1), (uint64_t)&vectors);
 }
 
 void route_exception(struct ex_regs *regs, int vector)
-- 
2.33.0.153.gba50c8fa24-goog

