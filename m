Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A76D7275AB
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 05:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbjFHDZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 23:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbjFHDYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 23:24:44 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9693270E
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 20:24:39 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-5343c3daff0so7704a12.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 20:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686194679; x=1688786679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VOCdNvewECOQ5+r30J+0zwy8ziQLU8oKSXOMN2+Hq4s=;
        b=d9EhnBemmD2f4oibbfAEEtWejICQ1rNiFBazg0jFGkD4tHwSNxfejfLeSyWocMTaLl
         69ynTHOgeRffw9JCwU/y0mkCtCcRzp2JHpPre42leBmr68P2ymOJOS1NDhptQVpW7X6i
         OuTRe1NRirHOLlD1MDgzWUn20RpLjBGhZqNJ9T4QpmYittxkECm/5cS7vFLw/DAsHcew
         ThrwAgWJ+opa5bWMZGPTAachovkIliDPpSvhae4lb1OTYqOhKYA1wORhDjSg+pwrwt9K
         mAyxel8HQuUxkV8F6oZKoh5+SB2GPc84eFHWuvG3IfNBkKX+AyUTIjyhmdcYcWEA2oIH
         dwew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686194679; x=1688786679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VOCdNvewECOQ5+r30J+0zwy8ziQLU8oKSXOMN2+Hq4s=;
        b=Y9Q4lBQpXegZfFwayde9zeipjUbqvdwqnHGl8ACoz9KITUEIlit4KKfFk2tzpn9EZ5
         oNmxPRuxzS4DhQ8Vg1B/u1QkmQ7lI/HjFVdLiAUQw9998gX9n8ukxk0lEmkB1uID90Fb
         o/zxvuapL9Oph60pyjalmnKRls1Wo4GULphMn1PKfRkjPm0DdXwvSv0zu0RBpePp/78d
         Xv/7zn6r+Kfepm0G/eJYGWjHZ57802dIDeF4fxnvy/0B+G2wS5ok1iqMVqSKJQv9mXWY
         uCnn0EAq5Coje6MqWXu4VKh+OiAbWZdXup6b6SVmpfOOqFk3ysn3Fz42zj0crGZA8IbU
         9UQw==
X-Gm-Message-State: AC+VfDx8MJFKscx68MYuDOfW8sBpC+Plb+taISGhE0zmmXZpuR8/bcVA
        fELFpzAWqENguUst95HEJChgylP4xf0=
X-Google-Smtp-Source: ACHHUZ6Fc9Zs7wtSCeCsqeNk7P4TIUVPbOq/F2Y/2HPWYYO86i9s/Q34WVH0CArGjz6ZCHpbTvyAxw==
X-Received: by 2002:a17:90a:4409:b0:256:675c:e552 with SMTP id s9-20020a17090a440900b00256675ce552mr3139034pjg.13.1686194678781;
        Wed, 07 Jun 2023 20:24:38 -0700 (PDT)
Received: from wheely.local0.net (58-6-224-112.tpgi.com.au. [58.6.224.112])
        by smtp.gmail.com with ESMTPSA id s12-20020a17090a5d0c00b0025930e50e28sm2015629pji.41.2023.06.07.20.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 20:24:38 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 1/6] KVM: selftests: Move pgd_created check into virt_pgd_alloc
Date:   Thu,  8 Jun 2023 13:24:20 +1000
Message-Id: <20230608032425.59796-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608032425.59796-1-npiggin@gmail.com>
References: <20230608032425.59796-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

virt_arch_pgd_alloc all do the same test and set of pgd_created. Move
this into common code.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 5 +++++
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 4 ----
 tools/testing/selftests/kvm/lib/riscv/processor.c   | 4 ----
 tools/testing/selftests/kvm/lib/s390x/processor.c   | 4 ----
 tools/testing/selftests/kvm/lib/x86_64/processor.c  | 7 ++-----
 5 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a089c356f354..d630a0a1877c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -822,7 +822,12 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm);
 
 static inline void virt_pgd_alloc(struct kvm_vm *vm)
 {
+	if (vm->pgd_created)
+		return;
+
 	virt_arch_pgd_alloc(vm);
+
+	vm->pgd_created = true;
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 3a0259e25335..3da3ec7c5b23 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -96,13 +96,9 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
 	size_t nr_pages = page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size;
 
-	if (vm->pgd_created)
-		return;
-
 	vm->pgd = vm_phy_pages_alloc(vm, nr_pages,
 				     KVM_GUEST_PAGE_TABLE_MIN_PADDR,
 				     vm->memslots[MEM_REGION_PT]);
-	vm->pgd_created = true;
 }
 
 static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index d146ca71e0c0..7695ba2cd369 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -57,13 +57,9 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
 	size_t nr_pages = page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size;
 
-	if (vm->pgd_created)
-		return;
-
 	vm->pgd = vm_phy_pages_alloc(vm, nr_pages,
 				     KVM_GUEST_PAGE_TABLE_MIN_PADDR,
 				     vm->memslots[MEM_REGION_PT]);
-	vm->pgd_created = true;
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index 15945121daf1..358e03f09c7a 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -17,16 +17,12 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	TEST_ASSERT(vm->page_size == 4096, "Unsupported page size: 0x%x",
 		    vm->page_size);
 
-	if (vm->pgd_created)
-		return;
-
 	paddr = vm_phy_pages_alloc(vm, PAGES_PER_REGION,
 				   KVM_GUEST_PAGE_TABLE_MIN_PADDR,
 				   vm->memslots[MEM_REGION_PT]);
 	memset(addr_gpa2hva(vm, paddr), 0xff, PAGES_PER_REGION * vm->page_size);
 
 	vm->pgd = paddr;
-	vm->pgd_created = true;
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d4a0b504b1e0..d4deb2718e86 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -127,11 +127,8 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
 		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
 
-	/* If needed, create page map l4 table. */
-	if (!vm->pgd_created) {
-		vm->pgd = vm_alloc_page_table(vm);
-		vm->pgd_created = true;
-	}
+	/* Create page map l4 table. */
+	vm->pgd = vm_alloc_page_table(vm);
 }
 
 static void *virt_get_pte(struct kvm_vm *vm, uint64_t *parent_pte,
-- 
2.40.1

