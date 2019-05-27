Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABCF52B793
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 16:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfE0Obx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 10:31:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53916 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbfE0Obx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 10:31:53 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 146CE883A2
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 14:31:53 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBC6960126;
        Mon, 27 May 2019 14:31:51 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, thuth@redhat.com,
        peterx@redhat.com
Subject: [PATCH v2 4/4] kvm: selftests: introduce aarch64_vcpu_add_default
Date:   Mon, 27 May 2019 16:31:41 +0200
Message-Id: <20190527143141.13883-5-drjones@redhat.com>
In-Reply-To: <20190527143141.13883-1-drjones@redhat.com>
References: <20190527143141.13883-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 27 May 2019 14:31:53 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the same as vm_vcpu_add_default, but it also takes a
kvm_vcpu_init struct pointer.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/include/aarch64/processor.h |  2 ++
 tools/testing/selftests/kvm/lib/aarch64/processor.c   | 11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 37f8129e1ea9..b7fa0c8551db 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -53,5 +53,7 @@ static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id, uint
 }
 
 void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *init);
+void aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
+			      struct kvm_vcpu_init *init, void *guest_code);
 
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 285d86a2b6c3..284dfd63b65b 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -235,7 +235,8 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
 	return vm;
 }
 
-void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
+void aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
+			      struct kvm_vcpu_init *init, void *guest_code)
 {
 	size_t stack_size = vm->page_size == 4096 ?
 					DEFAULT_STACK_PGS * vm->page_size :
@@ -243,12 +244,18 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 	uint64_t stack_vaddr = vm_vaddr_alloc(vm, stack_size,
 					DEFAULT_ARM64_GUEST_STACK_VADDR_MIN, 0, 0);
 
-	vm_vcpu_add_with_memslots(vm, vcpuid, 0, 0);
+	vm_vcpu_add(vm, vcpuid);
+	aarch64_vcpu_setup(vm, vcpuid, init);
 
 	set_reg(vm, vcpuid, ARM64_CORE_REG(sp_el1), stack_vaddr + stack_size);
 	set_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
 }
 
+void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
+{
+	aarch64_vcpu_add_default(vm, vcpuid, NULL, guest_code);
+}
+
 void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *init)
 {
 	struct kvm_vcpu_init default_init = { .target = -1, };
-- 
2.20.1

