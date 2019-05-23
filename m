Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0CA27D6A
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 14:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbfEWM6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 08:58:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbfEWM6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 08:58:02 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3F013307D986
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 12:58:02 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C52F6090E;
        Thu, 23 May 2019 12:58:00 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, thuth@redhat.com
Subject: [PATCH 2/4] kvm: selftests: introduce vm_vcpu_add
Date:   Thu, 23 May 2019 14:57:54 +0200
Message-Id: <20190523125756.4645-3-drjones@redhat.com>
In-Reply-To: <20190523125756.4645-1-drjones@redhat.com>
References: <20190523125756.4645-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 23 May 2019 12:58:02 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vm_vcpu_add() just adds a vcpu to the vm, but doesn't do any
additional vcpu setup.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 32 +++++++++++++++----
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 4e92f34cf46a..32fabbc98803 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -88,6 +88,7 @@ int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
 		void *arg);
 void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
+void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 void vm_vcpu_add_memslots(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
 			  int gdt_memslot);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 937292dca81b..ae6d4b274ddd 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -756,23 +756,20 @@ static int vcpu_mmap_sz(void)
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
- * and then sets it up with vcpu_setup() and the provided memslots.
+ * Adds a virtual CPU to the VM specified by vm with the ID given by vcpuid.
+ * No additional VCPU setup is done.
  */
-void vm_vcpu_add_memslots(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
-			  int gdt_memslot)
+void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct vcpu *vcpu;
 
@@ -806,7 +803,28 @@ void vm_vcpu_add_memslots(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
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
+ * Adds a virtual CPU the VM specified by vm with the ID given by vcpuid
+ * and then sets it up with vcpu_setup() and the provided memslots.
+ */
+void vm_vcpu_add_memslots(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
+			  int gdt_memslot)
+{
+	vm_vcpu_add(vm, vcpuid);
 	vcpu_setup(vm, vcpuid, pgd_memslot, gdt_memslot);
 }
 
-- 
2.20.1

