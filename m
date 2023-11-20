Return-Path: <kvm+bounces-2067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37C6F7F1345
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:29:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8343281DFA
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 12:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 237F21A73D;
	Mon, 20 Nov 2023 12:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CuDHd9jW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83F4F1
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 04:29:34 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-5b9a456798eso2433112a12.3
        for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 04:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700483374; x=1701088174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/AIk7AbhJsW9eI62mKYQ2rkcdPJNjRacR/OdDnhUOic=;
        b=CuDHd9jWfIZ+zZPOqwcsry+7jtEnImVMb5GOkUhOTFXTFlWp3GXWdDFs9bztND23tr
         p2e+QE4M1IjX75dBB+MLbua7ZWVxrRB4IJ5XTlQtUx6SvTlkjZXWS34jwncedyaPvVoy
         MrDF9tZleCtuQ0qe0unDiuZWVbt7FhIjPTAD7K0qMmKUBFDsYSW0iPMawlKsiCJBwSxH
         W4Ih8oTQDjsKaaTo7WviL2sdWK9iCjqPhS5NQHr3A5yTWDhWbLSnEgyXVgzewZPbxLpi
         PAp1cOKXIuAgsBkETPNStVmUWxtjmrtui2ouGLYy9g8c/7Ckv1CmGKnDDuWHXX06zfoF
         vgWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700483374; x=1701088174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/AIk7AbhJsW9eI62mKYQ2rkcdPJNjRacR/OdDnhUOic=;
        b=ZIv/U6qRKHQy7ftadPQtykIVIAR0nyESL6xQHhURnNbyD++avmb7ILcHQ0/HCWW/8M
         gV9oHALYHdknpIBzvue/Ggo6cdsxdiT/mRLemEtQ9IDNlRfU4FpLTbkeNyOLqf/bwHSe
         SfEafy2EKYE2orpesL+y7DqPmUzjUVUdjIKXOB8kIu9W4qEFgcM716xaIHVzMXdFm0Bt
         fV0jlQ7N0OKEq64jYcjNGcfZ/3VefvCNEt0usF8ZvQaAS28JZ5bMX2H0yCpiUHKkP9lM
         pnQh7zJ7smPmWxcV4B+Eef2ZZsN7gflmXvc3KKiKgVFf5KT8jxTfefU0rxqugPDNhB2V
         O8uw==
X-Gm-Message-State: AOJu0Yx/+cX9c7ypOlsI/55sUMDT0FjCiRI3W0wkoV6OyD11Kp/dvfxZ
	0KIfY4qP/KdumO0eg5dXHEYH+hv9E30=
X-Google-Smtp-Source: AGHT+IHXYdEdlfMsZ45SCaLhC2tM2bY8qSW/M7grjYqtZC31LiALWBxgKLFG725Jn//bmEyqOc5Y5g==
X-Received: by 2002:a05:6a20:3d84:b0:187:94ca:2a91 with SMTP id s4-20020a056a203d8400b0018794ca2a91mr5379042pzi.39.1700483373821;
        Mon, 20 Nov 2023 04:29:33 -0800 (PST)
Received: from wheely.local0.net (203-219-179-16.tpgi.com.au. [203.219.179.16])
        by smtp.gmail.com with ESMTPSA id d13-20020a056a00244d00b00690fe1c928csm6047477pfj.147.2023.11.20.04.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 04:29:33 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org,
	Sean Christopherson <seanjc@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v4 1/4] KVM: selftests: Move pgd_created check into virt_pgd_alloc
Date: Mon, 20 Nov 2023 22:29:17 +1000
Message-ID: <20231120122920.293076-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231120122920.293076-1-npiggin@gmail.com>
References: <20231120122920.293076-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index a18db6a7b3cf..e592a75ec052 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -846,7 +846,12 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm);
 
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
index 6fe12e985ba5..69743d4c6748 100644
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
index d8288374078e..2ec64bb45db2 100644
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
2.42.0


