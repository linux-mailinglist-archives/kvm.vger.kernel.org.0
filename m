Return-Path: <kvm+bounces-8372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 333E684E9E6
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 21:50:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FF6D1C20DF2
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 20:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9568350259;
	Thu,  8 Feb 2024 20:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g6wWk0Eh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842F94F8A3
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 20:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707425344; cv=none; b=mZtIxc+RWD+hkfECa3sa7q70mQrwHFBSXiNCKfbjQhEQTsaf+3TVWGQHpIZmCRoCauylstY7dcpB7V1/oWax6hG5ZObeSJnz2d3V+BdqgWK21X6IhaXmQB+glsfxQZKfIgXnWPrs8VnMjsmkg3LO0FH4ziSOnLQiOEZaVF4x/NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707425344; c=relaxed/simple;
	bh=JmcpKC400PbzX0ePL8d6anee58zWNUUDqWEZXEsRBrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YftCJasSVGSTz6Sfa0Y9sNWNYu9a/K5+OVd+p2DvurpU2aiJlO9F7ScaIX/vcK+A2nxrmBY51lQhn4GBe0/+gMIKNyjpbaCMN7BJdHp0z9W0X7yBS4WurVKlxlYUc22MVtikwEB/K5PjIp+KRCol9AH8FLIvlJq+2ldnZoQop+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g6wWk0Eh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707425340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N08fgZNntAWiFcUnTv+R2pdigPclu3Lgo6rPYfgbB7o=;
	b=g6wWk0Eh5aRwBYlBRetHUMpndqe5ITcMHy4D+Y+K2MJ1LPYiuO4gYtmT5xGb8qsVbJynbh
	nT4LI/v2WJKW3NOgE/tGfnRQMTPvA92j0aVkfh2utoTOJKdKwSbivt9Pb8EQXTz4gVaKWQ
	wOn9Em02uywvar7aSH9tzQoaqSmDeqE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-250-JrS4ZfH4OvG50sngGUxSqQ-1; Thu,
 08 Feb 2024 15:48:54 -0500
X-MC-Unique: JrS4ZfH4OvG50sngGUxSqQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13D9529AC01F;
	Thu,  8 Feb 2024 20:48:54 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.39.192.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DFE331C10C0C;
	Thu,  8 Feb 2024 20:48:51 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v3 3/8] KVM: selftests: Move setting a vCPU's entry point to a dedicated API
Date: Thu,  8 Feb 2024 21:48:39 +0100
Message-ID: <20240208204844.119326-4-thuth@redhat.com>
In-Reply-To: <20240208204844.119326-1-thuth@redhat.com>
References: <20240208204844.119326-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Sean Christopherson <seanjc@google.com>

Extract the code to set a vCPU's entry point out of vm_arch_vcpu_add() and
into a new API, vcpu_arch_set_entry_point().  Providing a separate API
will allow creating a KVM selftests hardness that can handle tests that
use different entry points for sub-tests, whereas *requiring* the entry
point to be specified at vCPU creation makes it difficult to create a
generic harness, e.g. the boilerplate setup/teardown can't easily create
and destroy the VM and vCPUs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 11 +++++----
 .../selftests/kvm/lib/aarch64/processor.c     | 23 ++++++++++++++-----
 .../selftests/kvm/lib/riscv/processor.c       |  9 +++++---
 .../selftests/kvm/lib/s390x/processor.c       | 13 ++++++-----
 .../selftests/kvm/lib/x86_64/processor.c      | 13 ++++++++---
 5 files changed, 47 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 9e5afc472c142..a6e7738a8db73 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -969,15 +969,18 @@ static inline void vcpu_dump(FILE *stream, struct kvm_vcpu *vcpu,
  * Input Args:
  *   vm - Virtual Machine
  *   vcpu_id - The id of the VCPU to add to the VM.
- *   guest_code - The vCPU's entry point
  */
-struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
-				  void *guest_code);
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
+void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code);
 
 static inline struct kvm_vcpu *vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 					   void *guest_code)
 {
-	return vm_arch_vcpu_add(vm, vcpu_id, guest_code);
+	struct kvm_vcpu *vcpu = vm_arch_vcpu_add(vm, vcpu_id);
+
+	vcpu_arch_set_entry_point(vcpu, guest_code);
+
+	return vcpu;
 }
 
 /* Re-create a vCPU after restarting a VM, e.g. for state save/restore tests. */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 41c776b642c0c..05b6c40e3655f 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -365,8 +365,13 @@ void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
 		indent, "", pstate, pc);
 }
 
-struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
-				  struct kvm_vcpu_init *init, void *guest_code)
+void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
+{
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
+}
+
+static struct kvm_vcpu *__aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+					   struct kvm_vcpu_init *init)
 {
 	size_t stack_size;
 	uint64_t stack_vaddr;
@@ -381,15 +386,21 @@ struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	aarch64_vcpu_setup(vcpu, init);
 
 	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), stack_vaddr + stack_size);
-	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
+}
+
+struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+				  struct kvm_vcpu_init *init, void *guest_code)
+{
+	struct kvm_vcpu *vcpu = __aarch64_vcpu_add(vm, vcpu_id, init);
+
+	vcpu_arch_set_entry_point(vcpu, guest_code);
 
 	return vcpu;
 }
 
-struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
-				  void *guest_code)
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 {
-	return aarch64_vcpu_add(vm, vcpu_id, NULL, guest_code);
+	return __aarch64_vcpu_add(vm, vcpu_id, NULL);
 }
 
 void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 7ca736fb41940..c993947f07823 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -277,8 +277,12 @@ static void __aligned(16) guest_unexp_trap(void)
 		  0, 0, 0, 0, 0, 0);
 }
 
-struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
-				  void *guest_code)
+void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
+{
+	vcpu_set_reg(vcpu, RISCV_CORE_REG(regs.pc), (unsigned long)guest_code);
+}
+
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 {
 	int r;
 	size_t stack_size;
@@ -312,7 +316,6 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 
 	/* Setup stack pointer and program counter of guest */
 	vcpu_set_reg(vcpu, RISCV_CORE_REG(regs.sp), stack_vaddr + stack_size);
-	vcpu_set_reg(vcpu, RISCV_CORE_REG(regs.pc), (unsigned long)guest_code);
 
 	/* Setup default exception vector of guest */
 	vcpu_set_reg(vcpu, RISCV_GENERAL_CSR_REG(stvec), (unsigned long)guest_unexp_trap);
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index 15945121daf17..cd5301cc9788a 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -155,15 +155,18 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	virt_dump_region(stream, vm, indent, vm->pgd);
 }
 
-struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
-				  void *guest_code)
+void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
+{
+	vcpu->run->psw_addr = (uintptr_t)guest_code;
+}
+
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 {
 	size_t stack_size =  DEFAULT_STACK_PGS * getpagesize();
 	uint64_t stack_vaddr;
 	struct kvm_regs regs;
 	struct kvm_sregs sregs;
 	struct kvm_vcpu *vcpu;
-	struct kvm_run *run;
 
 	TEST_ASSERT(vm->page_size == 4096, "Unsupported page size: 0x%x",
 		    vm->page_size);
@@ -184,9 +187,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	sregs.crs[1] = vm->pgd | 0xf;		/* Primary region table */
 	vcpu_sregs_set(vcpu, &sregs);
 
-	run = vcpu->run;
-	run->psw_mask = 0x0400000180000000ULL;  /* DAT enabled + 64 bit mode */
-	run->psw_addr = (uintptr_t)guest_code;
+	vcpu->run->psw_mask = 0x0400000180000000ULL;  /* DAT enabled + 64 bit mode */
 
 	return vcpu;
 }
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d8288374078e4..b9b6cb730a088 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -562,8 +562,16 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
 	sync_global_to_guest(vm, host_cpu_is_amd);
 }
 
-struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
-				  void *guest_code)
+void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
+{
+	struct kvm_regs regs;
+
+	vcpu_regs_get(vcpu, &regs);
+	regs.rip = (unsigned long) guest_code;
+	vcpu_regs_set(vcpu, &regs);
+}
+
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 {
 	struct kvm_mp_state mp_state;
 	struct kvm_regs regs;
@@ -597,7 +605,6 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	vcpu_regs_get(vcpu, &regs);
 	regs.rflags = regs.rflags | 0x2;
 	regs.rsp = stack_vaddr;
-	regs.rip = (unsigned long) guest_code;
 	vcpu_regs_set(vcpu, &regs);
 
 	/* Setup the MP state */
-- 
2.43.0


