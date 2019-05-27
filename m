Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31EE72B791
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 16:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfE0Obu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 10:31:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47118 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbfE0Obu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 10:31:50 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D8FBE80F6D
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 14:31:49 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8828160126;
        Mon, 27 May 2019 14:31:48 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, thuth@redhat.com,
        peterx@redhat.com
Subject: [PATCH v2 2/4] kvm: selftests: introduce vm_vcpu_add
Date:   Mon, 27 May 2019 16:31:39 +0200
Message-Id: <20190527143141.13883-3-drjones@redhat.com>
In-Reply-To: <20190527143141.13883-1-drjones@redhat.com>
References: <20190527143141.13883-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 27 May 2019 14:31:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vm_vcpu_add() just adds a vcpu to the vm, but doesn't do any
additional vcpu setup.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 34 ++++++++++++++-----
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a82f877ea163..d16fdaad0511 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -88,6 +88,7 @@ int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
 		void *arg);
 void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
+void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 void vm_vcpu_add_with_memslots(struct kvm_vm *vm, uint32_t vcpuid,
 			       int pgd_memslot, int gdt_memslot);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 98d664825aa7..0ac1ee93a519 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -754,24 +754,20 @@ static int vcpu_mmap_sz(void)
 }
 
 /*
- * VM VCPU Add with provided memslots
+ * VM VCPU Add
  *
  * Input Args:
  *   vm - Virtual Machine
  *   vcpuid - VCPU ID
- *   pgd_memslot - Memory region slot for new virtual translation tables
- *   gdt_memslot - Memory region slot for data pages
  *
  * Output Args: None
  *
  * Return: None
  *
- * Adds a virtual CPU to the VM specified by vm with the ID given by vcpuid
- * and then sets it up with vcpu_setup() using the provided memslots for the
- * MMU setup.
+ * Adds a virtual CPU to the VM specified by vm with the ID given by vcpuid.
+ * No additional VCPU setup is done.
  */
-void vm_vcpu_add_with_memslots(struct kvm_vm *vm, uint32_t vcpuid,
-			       int pgd_memslot, int gdt_memslot)
+void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct vcpu *vcpu;
 
@@ -805,7 +801,29 @@ void vm_vcpu_add_with_memslots(struct kvm_vm *vm, uint32_t vcpuid,
 		vm->vcpu_head->prev = vcpu;
 	vcpu->next = vm->vcpu_head;
 	vm->vcpu_head = vcpu;
+}
 
+/*
+ * VM VCPU Add with provided memslots
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vcpuid - VCPU ID
+ *   pgd_memslot - Memory region slot for new virtual translation tables
+ *   gdt_memslot - Memory region slot for data pages
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Adds a virtual CPU to the VM specified by vm with the ID given by vcpuid
+ * and then sets it up with vcpu_setup() using the provided memslots for the
+ * MMU setup.
+ */
+void vm_vcpu_add_with_memslots(struct kvm_vm *vm, uint32_t vcpuid,
+			       int pgd_memslot, int gdt_memslot)
+{
+	vm_vcpu_add(vm, vcpuid);
 	vcpu_setup(vm, vcpuid, pgd_memslot, gdt_memslot);
 }
 
-- 
2.20.1

