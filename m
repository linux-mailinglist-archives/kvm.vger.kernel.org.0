Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809015E599B
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 05:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiIVDW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 23:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiIVDVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 23:21:45 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B819322B
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:13 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id w14-20020a170902e88e00b00177ab7a12f6so5020702plg.16
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=liu7uI/e22f8WJg4KuLaGgmLgmCrsiW3uXCrNS+fFnk=;
        b=fXssmAtSBDIn2rfBB4d/5FIiwDq1eTLpavdwubE5eQewmc+0bmawRazFueWyjdXY9L
         tgo6q+2bcERUsk+6eO2GqsdjNhr0J+UT/O0zziO4rIbsWrs0P/lS4CpvktH6YJlTePeX
         tE5Hwl1Fw3FlEoAmFgJSBb6TBTf5rk0qmq+5NNmaK5WdAQMqxKHXi8AxxzbPpWKd449g
         qKFLrNlh2JUSjPxAmeq0W6FuNVl5by2W+2bwpa0Lphnfwo4XHioXyDT9ZG9+hBfdHDTa
         /f3Y+aX2x6lAF/2pKlw8CfxxZBcnimOl6uHxsnRVKfDAsSbjUNDK0ItP3cjM6k846p5p
         QhCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=liu7uI/e22f8WJg4KuLaGgmLgmCrsiW3uXCrNS+fFnk=;
        b=qFzmYIwN7c1eD++b4elToLn0y7mWTBGDQ5DjG8dyi55g/XQjKDYP/BwvsFVpkvzzAa
         J2bRzv0N0zGX5CxpPmPkaEmCx5OIqhBDM0bEFjjSJ5Hbi/WByCxiVmxz3EeqDcnnAvjX
         XeYCnXtHJnbCjAQf8Vz3w2LDDkxXriJaA36t4smqzGzWckiLKAHlG5mn3CHt862rMnia
         M4rrV2s9humUFLToSe4i/hwdmKVvSwMdMTy1z5+hMxCnAvBwy6x0XkOZtY4pSoZfhSu0
         XhjzXsvdhQOa/ZBDpzU4TVmOFFfS7g1Vgy6CyUg0aw7ZBIHjyjIm9n4zbDMGcbf4duEx
         3p0w==
X-Gm-Message-State: ACrzQf2gzMlDeg0Qy5WYLoKmDvE9hYE8KCuyu3q1fWg7yjtXshJenx3f
        tuEY3VBeA9PAppZa5W7aGlTJs/RDO1Y+Lne7NYQWnsPRgMpoSnUqPT7FaOqzbNVtc84TQLwjRVq
        IPO5kztI/d328j6Toc//iYiziIYjObTFiiEUL/zrliqGZ62s6TvfHYzSQ2RB5LUg=
X-Google-Smtp-Source: AMsMyM78mwru01meZ94QbbtZNQpK6DQ0wTBBe66B9NESWpPDZnszYvOvdyZwVK3YgDjfIB4ig/xQZzBy0wY4iw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:c944:b0:178:4568:9f99 with SMTP
 id i4-20020a170902c94400b0017845689f99mr1265948pla.98.1663816753218; Wed, 21
 Sep 2022 20:19:13 -0700 (PDT)
Date:   Thu, 22 Sep 2022 03:18:51 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-9-ricarkol@google.com>
Subject: [PATCH v8 08/14] KVM: selftests: Fix alignment in virt_arch_pgd_alloc()
 and vm_vaddr_alloc()
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor virt_arch_pgd_alloc() and vm_vaddr_alloc() in both RISC-V and
aarch64 to fix the alignment of parameters in a couple of calls. This will
make it easier to fix the alignment in a future commit that adds an extra
parameter (that happens to be very long).

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/lib/aarch64/processor.c     | 27 ++++++++++---------
 .../selftests/kvm/lib/riscv/processor.c       | 27 ++++++++++---------
 2 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 26f0eccff6fe..6ff2b9d6cea6 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -76,13 +76,14 @@ static uint64_t __maybe_unused ptrs_per_pte(struct kvm_vm *vm)
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	if (!vm->pgd_created) {
-		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
-			page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
-		vm->pgd = paddr;
-		vm->pgd_created = true;
-	}
+	size_t nr_pages = page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size;
+
+	if (vm->pgd_created)
+		return;
+
+	vm->pgd = vm_phy_pages_alloc(vm, nr_pages,
+				     KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+	vm->pgd_created = true;
 }
 
 static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
@@ -325,13 +326,15 @@ void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
 struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 				  struct kvm_vcpu_init *init, void *guest_code)
 {
-	size_t stack_size = vm->page_size == 4096 ?
-					DEFAULT_STACK_PGS * vm->page_size :
-					vm->page_size;
-	uint64_t stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-					      DEFAULT_ARM64_GUEST_STACK_VADDR_MIN);
+	size_t stack_size;
+	uint64_t stack_vaddr;
 	struct kvm_vcpu *vcpu = __vm_vcpu_add(vm, vcpu_id);
 
+	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
+					     vm->page_size;
+	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
+				     DEFAULT_ARM64_GUEST_STACK_VADDR_MIN);
+
 	aarch64_vcpu_setup(vcpu, init);
 
 	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), stack_vaddr + stack_size);
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 604478151212..ac7fc9d317db 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -55,13 +55,14 @@ static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva, int level)
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	if (!vm->pgd_created) {
-		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
-			page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
-		vm->pgd = paddr;
-		vm->pgd_created = true;
-	}
+	size_t nr_pages = page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size;
+
+	if (vm->pgd_created)
+		return;
+
+	vm->pgd = vm_phy_pages_alloc(vm, nr_pages,
+				     KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+	vm->pgd_created = true;
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@ -279,15 +280,17 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 				  void *guest_code)
 {
 	int r;
-	size_t stack_size = vm->page_size == 4096 ?
-					DEFAULT_STACK_PGS * vm->page_size :
-					vm->page_size;
-	unsigned long stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-					DEFAULT_RISCV_GUEST_STACK_VADDR_MIN);
+	size_t stack_size;
+	unsigned long stack_vaddr;
 	unsigned long current_gp = 0;
 	struct kvm_mp_state mps;
 	struct kvm_vcpu *vcpu;
 
+	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
+					     vm->page_size;
+	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
+				     DEFAULT_RISCV_GUEST_STACK_VADDR_MIN);
+
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	riscv_vcpu_mmu_setup(vcpu);
 
-- 
2.37.3.968.ga6b4b080e4-goog

