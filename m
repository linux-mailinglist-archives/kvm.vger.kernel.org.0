Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6464E2B792
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 16:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfE0Obw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 10:31:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57062 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbfE0Obv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 10:31:51 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7382A307D926
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 14:31:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 297B460126;
        Mon, 27 May 2019 14:31:50 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, thuth@redhat.com,
        peterx@redhat.com
Subject: [PATCH v2 3/4] kvm: selftests: introduce aarch64_vcpu_setup
Date:   Mon, 27 May 2019 16:31:40 +0200
Message-Id: <20190527143141.13883-4-drjones@redhat.com>
In-Reply-To: <20190527143141.13883-1-drjones@redhat.com>
References: <20190527143141.13883-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 27 May 2019 14:31:51 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows aarch64 tests to run on more targets, such as the Arm
simulator that doesn't like KVM_ARM_TARGET_GENERIC_V8. And it also
allows aarch64 tests to provide vcpu features in struct kvm_vcpu_init.
Additionally it drops the unused memslot parameters.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/include/aarch64/processor.h |  2 ++
 .../selftests/kvm/lib/aarch64/processor.c     | 22 ++++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 9ef2ab1a0c08..37f8129e1ea9 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -52,4 +52,6 @@ static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id, uint
 	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &reg);
 }
 
+void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *init);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 16cba9480ad6..285d86a2b6c3 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -249,14 +249,21 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 	set_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
 }
 
-void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot)
+void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *init)
 {
-	struct kvm_vcpu_init init;
+	struct kvm_vcpu_init default_init = { .target = -1, };
 	uint64_t sctlr_el1, tcr_el1;
 
-	memset(&init, 0, sizeof(init));
-	init.target = KVM_ARM_TARGET_GENERIC_V8;
-	vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, &init);
+	if (!init)
+		init = &default_init;
+
+	if (init->target == -1) {
+		struct kvm_vcpu_init preferred;
+		vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &preferred);
+		init->target = preferred.target;
+	}
+
+	vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
 
 	/*
 	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
@@ -306,6 +313,11 @@ void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot)
 	set_reg(vm, vcpuid, ARM64_SYS_REG(TTBR0_EL1), vm->pgd);
 }
 
+void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot)
+{
+	aarch64_vcpu_setup(vm, vcpuid, NULL);
+}
+
 void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 {
 	uint64_t pstate, pc;
-- 
2.20.1

