Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A63B51B2FF
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379785AbiEDXAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379811AbiEDW6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:58:40 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D21656236
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:52:21 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b10-20020a170902bd4a00b0015e7ee90842so1372169plx.8
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=6e5R6qJyolq/A/MgAj1aBQRLvw+sWPtn4dgLZCCgPjs=;
        b=WGHuID3eErubzDv34bBGHi+76Lbid+M6zitNzei7JvEwsU0Ac17RHdq71L76qE4Ox8
         nidzhpmAWXPyMg4LcpEWsWwyefiDf4jYFfNlAimhrqcEZFGVkBu7xw3b0GGXHG8Js77C
         IDLW7AtmX9EfBoC10JrAjVOg6DuV2ShTVkFQygRjmAaDbxXMO6k0xQ01BME0PuPLZmom
         OXCWy7bbTt5q+0MeAfFPL3yAJdnTXXQPmaOg2mR5V9DTroweE7BXjv5ITywVfeaW81c2
         N5jhsma7XfhBM0TAtrnCkk0UgdTrDnJ7VZHVuaxUkUx3fLUJTbmB57f+rWAUvNiu9Gb2
         PiJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=6e5R6qJyolq/A/MgAj1aBQRLvw+sWPtn4dgLZCCgPjs=;
        b=u5EprYMQDv/tqo8Iz7mpBg5FjBMR24RCrqyocCoYt6UGbtxlCF7fZq2Sg2nQZKOhcM
         Ply20F3WGZDW69+4lylZ8BIEmYxaBplYRlobTZUJVTptdvRNWXSICovg82rl9R3so7U4
         AhgHmxDZqcbmLcURIsRe4X4OSTd6cdghHfJgNIfypHIbF43R3CmEZGc4je7HkWzGjdCO
         s0Kfg8qRT44ZuGKW7OM2agE5rT2E434l88cpG9S7pAHfaMzX7kB5U4Hsjl/ZZgHLV0CB
         1GdyvH9g4nRqhV6nAxMJGikLTYiDvsmbkCrnirhzxS+k3qmeUhYsFdUBSmoqMPlIj1hz
         wSSw==
X-Gm-Message-State: AOAM532NfjJPIDzWCCwuMSg8bneeDk2/HvviocMqDOfqi63z8h4n+Qfk
        dt8cTdj/JNhw1y8iK7q9h4qAlyX7T+I=
X-Google-Smtp-Source: ABdhPJxh/VmB/LCapiCKXDUxJMoaOJU5QJFLPOXeMphJReD6Rzg3RzFWjDpC27TNAOV+0pIWhDpl6Ws86SY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9304:b0:15c:fe50:6581 with SMTP id
 bc4-20020a170902930400b0015cfe506581mr23688899plb.132.1651704728928; Wed, 04
 May 2022 15:52:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:38 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-93-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 092/128] KVM: selftests: Add "arch" to common utils that have
 arch implementations
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add "arch" into the name of utility functions that are declared in common
code, but (surprise!) have arch-specific implementations.  Shuffle code
around so that all such helpers' declarations are bundled together.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 200 ++++++++++--------
 .../selftests/kvm/lib/aarch64/processor.c     |  12 +-
 .../selftests/kvm/lib/riscv/processor.c       |  12 +-
 .../selftests/kvm/lib/s390x/processor.c       |  12 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  12 +-
 5 files changed, 141 insertions(+), 107 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 570eb05005ea..5e316f7cd927 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -95,23 +95,6 @@ struct kvm_vm {
 
 struct kvm_vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpuid);
 
-/*
- * Virtual Translation Tables Dump
- *
- * Input Args:
- *   stream - Output FILE stream
- *   vm     - Virtual Machine
- *   indent - Left margin indent amount
- *
- * Output Args: None
- *
- * Return: None
- *
- * Dumps to the FILE stream given by @stream, the contents of all the
- * virtual translation tables for the VM given by @vm.
- */
-void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
-
 struct userspace_mem_region *
 memslot2region(struct kvm_vm *vm, uint32_t memslot);
 
@@ -283,25 +266,6 @@ static inline int vm_get_stats_fd(struct kvm_vm *vm)
 	return fd;
 }
 
-/*
- * VM VCPU Dump
- *
- * Input Args:
- *   stream - Output FILE stream
- *   vm     - Virtual Machine
- *   vcpuid - VCPU ID
- *   indent - Left margin indent amount
- *
- * Output Args: None
- *
- * Return: None
- *
- * Dumps the current state of the VCPU specified by @vcpuid, within the VM
- * given by @vm, to the FILE stream given by @stream.
- */
-void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid,
-	       uint8_t indent);
-
 void vm_create_irqchip(struct kvm_vm *vm);
 
 void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
@@ -328,23 +292,6 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
 
-/*
- * Address Guest Virtual to Guest Physical
- *
- * Input Args:
- *   vm - Virtual Machine
- *   gva - VM virtual address
- *
- * Output Args: None
- *
- * Return:
- *   Equivalent VM physical address
- *
- * Returns the VM physical address of the translated VM virtual
- * address given by @gva.
- */
-vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
-
 struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
@@ -568,26 +515,6 @@ void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
 
 const char *exit_reason_str(unsigned int exit_reason);
 
-void virt_pgd_alloc(struct kvm_vm *vm);
-
-/*
- * VM Virtual Page Map
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vaddr - VM Virtual Address
- *   paddr - VM Physical Address
- *   memslot - Memory region slot for new virtual translation tables
- *
- * Output Args: None
- *
- * Return: None
- *
- * Within @vm, creates a virtual translation for the page starting
- * at @vaddr to the page starting at @paddr.
- */
-void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr);
-
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot);
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
@@ -656,16 +583,6 @@ static inline struct kvm_vm *vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 
 struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
 
-/*
- * Adds a vCPU with reasonable defaults (e.g. a stack)
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - The id of the VCPU to add to the VM.
- *   guest_code - The vCPU's entry point
- */
-void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
-
 unsigned int vm_get_page_size(struct kvm_vm *vm);
 unsigned int vm_get_page_shift(struct kvm_vm *vm);
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
@@ -704,4 +621,121 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 
 void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 
+/*
+ * VM VCPU Dump
+ *
+ * Input Args:
+ *   stream - Output FILE stream
+ *   vm     - Virtual Machine
+ *   vcpuid - VCPU ID
+ *   indent - Left margin indent amount
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Dumps the current state of the VCPU specified by @vcpuid, within the VM
+ * given by @vm, to the FILE stream given by @stream.
+ */
+
+void vcpu_arch_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid,
+		    uint8_t indent);
+
+static inline void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid,
+			     uint8_t indent)
+{
+	vcpu_arch_dump(stream, vm, vcpuid, indent);
+}
+
+/*
+ * Adds a vCPU with reasonable defaults (e.g. a stack)
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vcpuid - The id of the VCPU to add to the VM.
+ *   guest_code - The vCPU's entry point
+ */
+void vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
+
+static inline void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
+				       void *guest_code)
+{
+	vm_arch_vcpu_add(vm, vcpuid, guest_code);
+}
+
+void virt_arch_pgd_alloc(struct kvm_vm *vm);
+
+static inline void virt_pgd_alloc(struct kvm_vm *vm)
+{
+	virt_arch_pgd_alloc(vm);
+}
+
+/*
+ * VM Virtual Page Map
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vaddr - VM Virtual Address
+ *   paddr - VM Physical Address
+ *   memslot - Memory region slot for new virtual translation tables
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Within @vm, creates a virtual translation for the page starting
+ * at @vaddr to the page starting at @paddr.
+ */
+void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr);
+
+static inline void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+{
+	virt_arch_pg_map(vm, vaddr, paddr);
+}
+
+
+/*
+ * Address Guest Virtual to Guest Physical
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   gva - VM virtual address
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Equivalent VM physical address
+ *
+ * Returns the VM physical address of the translated VM virtual
+ * address given by @gva.
+ */
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
+
+static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	return addr_arch_gva2gpa(vm, gva);
+}
+
+/*
+ * Virtual Translation Tables Dump
+ *
+ * Input Args:
+ *   stream - Output FILE stream
+ *   vm     - Virtual Machine
+ *   indent - Left margin indent amount
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Dumps to the FILE stream given by @stream, the contents of all the
+ * virtual translation tables for the VM given by @vm.
+ */
+void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
+
+static inline void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+{
+	virt_arch_dump(stream, vm, indent);
+}
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 5f6967058647..653e740c46b1 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -74,7 +74,7 @@ static uint64_t __maybe_unused ptrs_per_pte(struct kvm_vm *vm)
 	return 1 << (vm->page_shift - 3);
 }
 
-void virt_pgd_alloc(struct kvm_vm *vm)
+void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
 	if (!vm->pgd_created) {
 		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
@@ -131,14 +131,14 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	*ptep |= (attr_idx << 2) | (1 << 10) /* Access Flag */;
 }
 
-void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
 	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
 
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
 
-vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	uint64_t *ptep;
 
@@ -195,7 +195,7 @@ static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, uint64_t p
 #endif
 }
 
-void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	int level = 4 - (vm->pgtable_levels - 1);
 	uint64_t pgd, *ptep;
@@ -303,7 +303,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init
 	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TPIDR_EL1), vcpuid);
 }
 
-void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
+void vcpu_arch_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 {
 	uint64_t pstate, pc;
 
@@ -330,7 +330,7 @@ void aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
 	set_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
 }
 
-void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
+void vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 {
 	aarch64_vcpu_add_default(vm, vcpuid, NULL, guest_code);
 }
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index c61c4856ed03..e43651ad7729 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -53,7 +53,7 @@ static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva, int level)
 	return (gva & pte_index_mask[level]) >> pte_index_shift[level];
 }
 
-void virt_pgd_alloc(struct kvm_vm *vm)
+void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
 	if (!vm->pgd_created) {
 		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
@@ -64,7 +64,7 @@ void virt_pgd_alloc(struct kvm_vm *vm)
 	}
 }
 
-void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
 	uint64_t *ptep, next_ppn;
 	int level = vm->pgtable_levels - 1;
@@ -108,7 +108,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 		PGTBL_PTE_PERM_MASK | PGTBL_PTE_VALID_MASK;
 }
 
-vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	uint64_t *ptep;
 	int level = vm->pgtable_levels - 1;
@@ -159,7 +159,7 @@ static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent,
 #endif
 }
 
-void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	int level = vm->pgtable_levels - 1;
 	uint64_t pgd, *ptep;
@@ -201,7 +201,7 @@ void riscv_vcpu_mmu_setup(struct kvm_vm *vm, int vcpuid)
 	set_reg(vm, vcpuid, RISCV_CSR_REG(satp), satp);
 }
 
-void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
+void vcpu_arch_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 {
 	struct kvm_riscv_core core;
 
@@ -273,7 +273,7 @@ static void __aligned(16) guest_hang(void)
 		;
 }
 
-void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
+void vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 {
 	int r;
 	size_t stack_size = vm->page_size == 4096 ?
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index aec15ca9d887..c2fe56a3fb74 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -10,7 +10,7 @@
 
 #define PAGES_PER_REGION 4
 
-void virt_pgd_alloc(struct kvm_vm *vm)
+void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
 	vm_paddr_t paddr;
 
@@ -46,7 +46,7 @@ static uint64_t virt_alloc_region(struct kvm_vm *vm, int ri)
 		| ((ri < 4 ? (PAGES_PER_REGION - 1) : 0) & REGION_ENTRY_LENGTH);
 }
 
-void virt_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
+void virt_arch_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
 {
 	int ri, idx;
 	uint64_t *entry;
@@ -85,7 +85,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
 	entry[idx] = gpa;
 }
 
-vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	int ri, idx;
 	uint64_t *entry;
@@ -146,7 +146,7 @@ static void virt_dump_region(FILE *stream, struct kvm_vm *vm, uint8_t indent,
 	}
 }
 
-void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	if (!vm->pgd_created)
 		return;
@@ -154,7 +154,7 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	virt_dump_region(stream, vm, indent, vm->pgd);
 }
 
-void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
+void vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 {
 	size_t stack_size =  DEFAULT_STACK_PGS * getpagesize();
 	uint64_t stack_vaddr;
@@ -205,7 +205,7 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
 	va_end(ap);
 }
 
-void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
+void vcpu_arch_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 {
 	struct kvm_vcpu *vcpu = vcpu_get(vm, vcpuid);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 31a0fd79110d..c5335345323c 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -109,7 +109,7 @@ static void sregs_dump(FILE *stream, struct kvm_sregs *sregs, uint8_t indent)
 	}
 }
 
-void virt_pgd_alloc(struct kvm_vm *vm)
+void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
 		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
@@ -208,7 +208,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
 }
 
-void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
 	__virt_pg_map(vm, vaddr, paddr, X86_PAGE_SIZE_4K);
 }
@@ -303,7 +303,7 @@ void vm_set_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr,
 	*(uint64_t *)new_pte = pte;
 }
 
-void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	uint64_t *pml4e, *pml4e_start;
 	uint64_t *pdpe, *pdpe_start;
@@ -484,7 +484,7 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_vm *vm, uint16_t selector,
 		kvm_seg_fill_gdt_64bit(vm, segp);
 }
 
-vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	uint16_t index[4];
 	uint64_t *pml4e, *pdpe, *pde;
@@ -633,7 +633,7 @@ void vm_xsave_req_perm(int bit)
 		    bitmask);
 }
 
-void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
+void vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 {
 	struct kvm_mp_state mp_state;
 	struct kvm_regs regs;
@@ -888,7 +888,7 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
 	va_end(ap);
 }
 
-void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
+void vcpu_arch_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 {
 	struct kvm_regs regs;
 	struct kvm_sregs sregs;
-- 
2.36.0.464.gb9c8b46e94-goog

