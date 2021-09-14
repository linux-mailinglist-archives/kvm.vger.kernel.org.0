Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B74640BB87
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 00:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbhINWc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 18:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235553AbhINWcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 18:32:50 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B88AC061762
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 15:31:32 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j4-20020a258b84000000b005a203c5e066so869756ybl.19
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 15:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rldmmOvQ286OBfHeQQaA2W9m6pECqOfEzNQCe0j5Do8=;
        b=nBP4Hy5B/LCmiOwecIUDtE3XFOoGWPaNUBEoABCau/cc41F35AOFw/Qg4SVui8lWXL
         nmJCaf9xVXAyFCjxgyKic+acD8OpRLVy1nL58v6qHeDrtzwpz+X/UJib3rmnoat6Xt0C
         notshYoDd1UDVb31ksw9uQeGKGWrGQt54Q7U31OHfrm/3Q3fTaUXAel3MBWm4nhw56/C
         qcUybAGbs4i4BSDTBowtiMX9UfhCkPTQcBTD2xODD0149TU3egF2VT1z8Kgk9gVMQZo7
         HxtDRsBdfvD2oKiDw7WMj0D8B3fjzNqAsw0yYu79zaontofOWi0qtfsSYUjl289YVwQD
         k0cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rldmmOvQ286OBfHeQQaA2W9m6pECqOfEzNQCe0j5Do8=;
        b=36XtOatjE52P+U2Bz5ZnRW9WqUtsPTad0GOJx5l6XWtcz+RaCI+I2qgGug7nHm3LhI
         u4ezKnEX81uaJdifXIi3eWq5zWpmNI1gw1xRiMna9isYbsUuPly/AMmjzeZcIER0jOOg
         MNbpIg27srX372z2/DXM+vnf1JeYRnVM2G0jmkQv7HgfzdGI+lKnztbWGSeaXM6MoYbI
         cc81SR1QhTe+C4Qs3vFO8CdXQjY89dFQDN+fPzXmC5X3NaxsMEOkz7icU98iW6C3cOBo
         TXUHctO4Cs3MiI3NqQX22Q8jumNQdgXn6wzOCNETcScbjWTAGLBmBoBnZ9AVl9R0/YWV
         eTVA==
X-Gm-Message-State: AOAM531nkoei2LZjadMQlP7VjTfZXvbLnKHiBFlR+xgrJhU7qsI2qR+C
        fEgBLmgMbEwqZl7BfyHs/nRfChYnhfsM
X-Google-Smtp-Source: ABdhPJyKMSwBoZuHjalLSFd/lA3edxShAWGOIZV4xmqxFSWTBEG+6/yHkYf3GzltNK9RWy8kXe6ebEYP30It
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:be0c:: with SMTP id
 h12mr2067388ybk.22.1631658691604; Tue, 14 Sep 2021 15:31:31 -0700 (PDT)
Date:   Tue, 14 Sep 2021 22:31:03 +0000
In-Reply-To: <20210914223114.435273-1-rananta@google.com>
Message-Id: <20210914223114.435273-5-rananta@google.com>
Mime-Version: 1.0
References: <20210914223114.435273-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v7 04/15] KVM: arm64: selftests: Introduce ARM64_SYS_KVM_REG
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

With the inclusion of sysreg.h, that brings in system register
encodings, it would be redundant to re-define register encodings
again in processor.h to use it with ARM64_SYS_REG for the KVM
functions such as set_reg() or get_reg(). Hence, add helper macro,
ARM64_SYS_KVM_REG, that converts SYS_* definitions in sysreg.h
into ARM64_SYS_REG definitions.

Also replace all the users of ARM64_SYS_REG, relying on
the encodings created in processor.h, with ARM64_SYS_KVM_REG and
remove the definitions.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  |  2 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  |  2 +-
 .../selftests/kvm/include/aarch64/processor.h | 20 ++++++++++---------
 .../selftests/kvm/lib/aarch64/processor.c     | 16 +++++++--------
 4 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 11fd23e21cb4..ea189d83abf7 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -190,7 +190,7 @@ static int debug_version(struct kvm_vm *vm)
 {
 	uint64_t id_aa64dfr0;
 
-	get_reg(vm, VCPU_ID, ARM64_SYS_REG(ID_AA64DFR0_EL1), &id_aa64dfr0);
+	get_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
 	return id_aa64dfr0 & 0xf;
 }
 
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
index 018c269990e1..4c5f6814030f 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -91,7 +91,7 @@ int main(void)
 	init.features[0] |= (1 << KVM_ARM_VCPU_POWER_OFF);
 	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
 
-	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
+	get_reg(vm, VCPU_ID_TARGET, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
 	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
 	vcpu_run(vm, VCPU_ID_SOURCE);
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 7989e832cafb..93797783abad 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -16,15 +16,17 @@
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
+/*
+ * KVM_ARM64_SYS_REG(sys_reg_id): Helper macro to convert
+ * SYS_* register definitions in asm/sysreg.h to use in KVM
+ * calls such as get_reg() and set_reg().
+ */
+#define KVM_ARM64_SYS_REG(sys_reg_id)			\
+	ARM64_SYS_REG(sys_reg_Op0(sys_reg_id),		\
+			sys_reg_Op1(sys_reg_id),	\
+			sys_reg_CRn(sys_reg_id),	\
+			sys_reg_CRm(sys_reg_id),	\
+			sys_reg_Op2(sys_reg_id))
 
 /*
  * Default MAIR
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 632b74d6b3ca..db64ee206064 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -232,10 +232,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
 	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
 	 * registers, which the variable argument list macros do.
 	 */
-	set_reg(vm, vcpuid, ARM64_SYS_REG(CPACR_EL1), 3 << 20);
+	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_CPACR_EL1), 3 << 20);
 
-	get_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), &sctlr_el1);
-	get_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), &tcr_el1);
+	get_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), &sctlr_el1);
+	get_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), &tcr_el1);
 
 	switch (vm->mode) {
 	case VM_MODE_P52V48_4K:
@@ -273,10 +273,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
 	tcr_el1 |= (1 << 8) | (1 << 10) | (3 << 12);
 	tcr_el1 |= (64 - vm->va_bits) /* T0SZ */;
 
-	set_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), sctlr_el1);
-	set_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), tcr_el1);
-	set_reg(vm, vcpuid, ARM64_SYS_REG(MAIR_EL1), DEFAULT_MAIR_EL1);
-	set_reg(vm, vcpuid, ARM64_SYS_REG(TTBR0_EL1), vm->pgd);
+	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), sctlr_el1);
+	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), tcr_el1);
+	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
+	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TTBR0_EL1), vm->pgd);
 }
 
 void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
@@ -362,7 +362,7 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	extern char vectors;
 
-	set_reg(vm, vcpuid, ARM64_SYS_REG(VBAR_EL1), (uint64_t)&vectors);
+	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_VBAR_EL1), (uint64_t)&vectors);
 }
 
 void route_exception(struct ex_regs *regs, int vector)
-- 
2.33.0.309.g3052b89438-goog

