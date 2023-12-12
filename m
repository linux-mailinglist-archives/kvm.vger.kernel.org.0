Return-Path: <kvm+bounces-4256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A03C80F84E
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 21:49:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D51D1C20C8B
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 20:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D24D864CE5;
	Tue, 12 Dec 2023 20:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o/fM5xQl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C291D19AF
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:39 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1d053953954so30444605ad.2
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702414058; x=1703018858; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H/Dndi1239gwCc2M1UpDzeOelUNamAjzhLbQUW3a080=;
        b=o/fM5xQldEVi6jYSmRB3HNLhkO20sFzxDYwBB6jRRV9ks06+vn1Mj6hI/bRaATejSx
         u3Yz3U2QBDALYrdRq4SYsNXfvgad3JXfQ7EJ+W0QEPJmmxJFWunv9QQc9QgflHWs9yVI
         r1BPABaarVd7HbBt3GMhF26Ov4ykK3Yd9UCH0bf3o6gCNAyudShLIR0SlXtUFwW2Kzbx
         EeoxoqYlb4b3e11AshzO2ss94Xg41M5a3gsFZbauVz7zV7NvyonRu+7aVXqI/84jHf98
         HyJdH3xHxK0pMaj2nwdD5g0foLm1DdVrhs9+tn//7n1FvFKtBuR9fRJfjLe2Wigv0RwQ
         20uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702414058; x=1703018858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H/Dndi1239gwCc2M1UpDzeOelUNamAjzhLbQUW3a080=;
        b=Mcm1qclcB3ICjcUhVuyB4jEq24tHkxUscorpaCzFvcyZ2RxX0JeclbOUSfBua/6hCb
         m8ZOX1Fnks1tETjUnEeGWrAAVJkVnwqRwmCEcVYc/BS4bfp1H6fvaRLY8pR2cFeCr4bt
         I8Bn7D9jBWteEunF3bFzpOq97/w17N2sLZMCkk65PzTeRLEIqjEof+mLTp8CdWV+co7I
         XNweyTXMXPRqET2lxKw3/HSejrciMYoGhAYrOXFT3gbfaW1QjZIOIYtkOaX2TIT2Ur8J
         PFXYV43kzOHWVMuGx9mVyU1ovIexxoNQNE+e9qSYhSdhASRG031u95UdBjTKER/SHZhq
         mCQQ==
X-Gm-Message-State: AOJu0YyPriPdyMhsbMkCAa5gKjmFqetuKO3ycJyEyShoag7zcH9YcrOe
	6CuG1JIsNdU9by7m3AcjhzI9CQDzFA==
X-Google-Smtp-Source: AGHT+IF90pAMjCwjeHxfySVElT6LDGL6d14S5h4fspD1Gay3dn08vhLUXCGLUkTCyivuxiIl7pjXKXPVEw==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a17:903:2292:b0:1d0:bf4c:163d with SMTP id
 b18-20020a170903229200b001d0bf4c163dmr56827plh.2.1702414058496; Tue, 12 Dec
 2023 12:47:38 -0800 (PST)
Date: Tue, 12 Dec 2023 12:46:37 -0800
In-Reply-To: <20231212204647.2170650-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231212204647.2170650-1-sagis@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231212204647.2170650-23-sagis@google.com>
Subject: [RFC PATCH v5 22/29] KVM: selftests: Add functions to allow mapping
 as shared
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Erdem Aktas <erdemaktas@google.com>, 
	Sagi Shahar <sagis@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Peter Gonda <pgonda@google.com>, Haibo Xu <haibo1.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Roger Wang <runanwang@google.com>, Vipin Sharma <vipinsh@google.com>, jmattson@google.com, 
	dmatlack@google.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ryan Afranji <afranji@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 24 ++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 32 +++++++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 15 +++++++--
 3 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index b353617fcdd1..efd7ae8abb20 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -574,6 +574,8 @@ vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
 
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	      unsigned int npages);
+void virt_map_shared(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+		     unsigned int npages);
 void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
@@ -1034,6 +1036,28 @@ static inline void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr
 	virt_arch_pg_map(vm, vaddr, paddr);
 }
 
+/*
+ * VM Virtual Page Map as Shared
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
+void virt_arch_pg_map_shared(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr);
+
+static inline void virt_pg_map_shared(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+{
+	virt_arch_pg_map_shared(vm, vaddr, paddr);
+}
 
 /*
  * Address Guest Virtual to Guest Physical
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 4f1ae0f1eef0..28780fa1f0f2 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1573,6 +1573,38 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 }
 
+/*
+ * Map a range of VM virtual address to the VM's physical address as shared
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vaddr - Virtuall address to map
+ *   paddr - VM Physical Address
+ *   npages - The number of pages to map
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Within the VM given by @vm, creates a virtual translation for
+ * @npages starting at @vaddr to the page range starting at @paddr.
+ */
+void virt_map_shared(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+		     unsigned int npages)
+{
+	size_t page_size = vm->page_size;
+	size_t size = npages * page_size;
+
+	TEST_ASSERT(vaddr + size > vaddr, "Vaddr overflow");
+	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
+
+	while (npages--) {
+		virt_pg_map_shared(vm, vaddr, paddr);
+		vaddr += page_size;
+		paddr += page_size;
+	}
+}
+
 /*
  * Address VM Physical to Host Virtual
  *
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 566d82829da4..aa2a57ddb8d3 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -190,7 +190,8 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 	return pte;
 }
 
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
+static void ___virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+			   int level, bool protected)
 {
 	const uint64_t pg_size = PG_LEVEL_SIZE(level);
 	uint64_t *pml4e, *pdpe, *pde;
@@ -235,17 +236,27 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
 	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
 
-	if (vm_is_gpa_protected(vm, paddr))
+	if (protected)
 		*pte |= vm->arch.c_bit;
 	else
 		*pte |= vm->arch.s_bit;
 }
 
+void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
+{
+	___virt_pg_map(vm, vaddr, paddr, level, vm_is_gpa_protected(vm, paddr));
+}
+
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
 	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K);
 }
 
+void virt_arch_pg_map_shared(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+{
+	___virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K, false);
+}
+
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    uint64_t nr_bytes, int level)
 {
-- 
2.43.0.472.g3155946c3a-goog


