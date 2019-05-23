Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B9827972
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 11:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbfEWJkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 05:40:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbfEWJkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 05:40:24 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BFD0AF74B5
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 09:40:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E2DC69181;
        Thu, 23 May 2019 09:40:22 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, thuth@redhat.com
Subject: [PATCH] kvm: selftests: aarch64: compile with warnings on
Date:   Thu, 23 May 2019 11:40:21 +0200
Message-Id: <20190523094021.18116-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 23 May 2019 09:40:23 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

aarch64 fixups needed to compile with warnings as errors.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index e8c42506a09d..62b381a930ec 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -7,6 +7,8 @@
 
 #define _GNU_SOURCE /* for program_invocation_name */
 
+#include <linux/compiler.h>
+
 #include "kvm_util.h"
 #include "../kvm_util_internal.h"
 #include "processor.h"
@@ -67,15 +69,13 @@ static uint64_t ptrs_per_pgd(struct kvm_vm *vm)
 	return 1 << (vm->va_bits - shift);
 }
 
-static uint64_t ptrs_per_pte(struct kvm_vm *vm)
+static uint64_t __maybe_unused ptrs_per_pte(struct kvm_vm *vm)
 {
 	return 1 << (vm->page_shift - 3);
 }
 
 void virt_pgd_alloc(struct kvm_vm *vm, uint32_t pgd_memslot)
 {
-	int rc;
-
 	if (!vm->pgd_created) {
 		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
 			page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size,
@@ -181,6 +181,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 unmapped_gva:
 	TEST_ASSERT(false, "No mapping for vm virtual address, "
 		    "gva: 0x%lx", gva);
+	return 0;
 }
 
 static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, uint64_t page, int level)
@@ -312,6 +313,6 @@ void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pstate), &pstate);
 	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &pc);
 
-	fprintf(stream, "%*spstate: 0x%.16llx pc: 0x%.16llx\n",
+	fprintf(stream, "%*spstate: 0x%.16lx pc: 0x%.16lx\n",
 		indent, "", pstate, pc);
 }
-- 
2.18.1

