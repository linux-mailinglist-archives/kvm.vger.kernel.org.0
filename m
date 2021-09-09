Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD68A4042FB
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 03:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349958AbhIIBk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 21:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349302AbhIIBkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 21:40:05 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADF0C06129F
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 18:38:47 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id s9-20020a17090aa10900b001797c5272b4so294056pjp.7
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 18:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CjBV1NcFy7p27eV1/jQ5yVLZ7UVN92HtWY4NlfI6+Nk=;
        b=qs44jTJxzDkHSQpQ3NQhsxvConzusDrdn8GVAQZkcQJ5b+Gf5cFcq+1LrnKjJ3qm4U
         IuVGUIv+Jm5UBRAL0UWp2YKCJiJWATPdxBLM7NOxgHM87/Ubckxo1gtt4k9jA/7RGXBM
         Qou8fUA1VNeeZou9MCS5yT/PR9gx7Il1wk+bXjTtgmUyNXl/4E7N57Q+12qLz3f3ZE2y
         ecBKEYRHqKGHv80Qqr+cRsYSsEpyK8YERJW3DxnoO0EtISch3Bvh9NCq5sZSd3XWfv4Y
         ABcqFuy0WPFgkDqTcVpYf5C4WGuZvOQ+4Vej5j0NsDyBBV5zXMiKM0YkCvBFObLVGX13
         FLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CjBV1NcFy7p27eV1/jQ5yVLZ7UVN92HtWY4NlfI6+Nk=;
        b=KzmaPqN00pPG6XxaRIaKvSK5IJqZ72BhgU03beZYfF/7WoXJr221oAaGQdfa3mk7/I
         ZceESMwreOJUZDuR0byjjRYX8V4dIxmsSBc2YIBsOFzSoWDiWUbOyZS2yHUTQt/gE0fO
         KoHC3UcQs+6tsE/EPWhQZaeGt16SGOc+u6quOYbxM//mxSnapDh9yVtLPa+PVZaAT7wM
         RbEkI06HQUnDcHL1pQTFNf80m/cSbpfFr/Djj6Y039osL7+pWodIZkY3HR4G4Oyh87id
         D1MlYUMNzKrOiNye9W14jVv1Ckenjak0FJROGHp4yDlFfqv/51x9NbBzmIKJRywAqJqu
         jCKA==
X-Gm-Message-State: AOAM5328jHdeq3V4wKk9diN+8/tej+ac4wSi0TxkumHrti59lkpp6i2N
        hJ92gPP9AV6Z3n+CGCCM6MR+V4sul0CG
X-Google-Smtp-Source: ABdhPJyuqoo++7vtCPsZXEiAOGwdyb60M1j/VQFztVww0kA042US1QoYXW+DsIcfE2quLAQ598C/fZFY3ypv
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a62:cdcd:0:b0:405:27a5:fbbb with SMTP id
 o196-20020a62cdcd000000b0040527a5fbbbmr605460pfg.7.1631151526738; Wed, 08 Sep
 2021 18:38:46 -0700 (PDT)
Date:   Thu,  9 Sep 2021 01:38:09 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-10-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get the vcpuid
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

At times, such as when in the interrupt handler, the guest wants
to get the vcpuid that it's running on. As a result, introduce
get_vcpuid() that returns the vcpuid of the calling vcpu. At its
backend, the VMM prepares a map of vcpuid and mpidr during VM
initialization and exports the map to the guest for it to read.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h |  3 ++
 .../selftests/kvm/lib/aarch64/processor.c     | 46 +++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index b6088c3c67a3..150f63101f4c 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -133,6 +133,7 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 		int vector, handler_fn handler);
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
+void vm_vcpuid_map_init(struct kvm_vm *vm);
 
 static inline void cpu_relax(void)
 {
@@ -194,4 +195,6 @@ static inline void local_irq_disable(void)
 	asm volatile("msr daifset, #3" : : : "memory");
 }
 
+int get_vcpuid(void);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 632b74d6b3ca..9844b62227b1 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -13,9 +13,17 @@
 #include "processor.h"
 
 #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
+#define VM_VCPUID_MAP_INVAL			-1
 
 static vm_vaddr_t exception_handlers;
 
+struct vm_vcpuid_map {
+	uint64_t mpidr;
+	int vcpuid;
+};
+
+static struct vm_vcpuid_map vcpuid_map[KVM_MAX_VCPUS];
+
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
 	return (v + vm->page_size) & ~(vm->page_size - 1);
@@ -426,3 +434,41 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	assert(vector < VECTOR_NUM);
 	handlers->exception_handlers[vector][0] = handler;
 }
+
+void vm_vcpuid_map_init(struct kvm_vm *vm)
+{
+	int i = 0;
+	struct vcpu *vcpu;
+	struct vm_vcpuid_map *map;
+
+	list_for_each_entry(vcpu, &vm->vcpus, list) {
+		map = &vcpuid_map[i++];
+		map->vcpuid = vcpu->id;
+		get_reg(vm, vcpu->id,
+			ARM64_SYS_KVM_REG(SYS_MPIDR_EL1), &map->mpidr);
+		map->mpidr &= MPIDR_HWID_BITMASK;
+	}
+
+	if (i < KVM_MAX_VCPUS)
+		vcpuid_map[i].vcpuid = VM_VCPUID_MAP_INVAL;
+
+	sync_global_to_guest(vm, vcpuid_map);
+}
+
+int get_vcpuid(void)
+{
+	int i, vcpuid;
+	uint64_t mpidr = read_sysreg(mpidr_el1) & MPIDR_HWID_BITMASK;
+
+	for (i = 0; i < KVM_MAX_VCPUS; i++) {
+		vcpuid = vcpuid_map[i].vcpuid;
+		GUEST_ASSERT_1(vcpuid != VM_VCPUID_MAP_INVAL, mpidr);
+
+		if (mpidr == vcpuid_map[i].mpidr)
+			return vcpuid;
+	}
+
+	/* We should not be reaching here */
+	GUEST_ASSERT_1(0, mpidr);
+	return -1;
+}
-- 
2.33.0.153.gba50c8fa24-goog

