Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8126E84CB
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbjDSWW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbjDSWVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:21:47 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055406E85
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:20:19 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a92369761cso4220805ad.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942740; x=1684534740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XoUTXkkdzp66fUQa0SZgxh2I0hcfFcSevl2ozJzsZr8=;
        b=IhesJB7cf1n2WZ7fBKb+dS6w3v0TIDtk6aiBcZra2CO2eehnlOUntTGLXPnoKcGUou
         bLgl/XcFe6/UB+ywV55miS51XCkHEWA0laPJEt1KJ/aJ0rahNvo0Q/dF7ADasdpm9XXJ
         UbjbI+Mf8nQXeZ5MyqNpR4s0bolzM0xGm/nM+7/6dJzXpWgydjb9eiN4RqXE1WgIi7X8
         Cthi7K85fjMc6Q2drU0GHSRvqnoqTSaztCaljlOhPnma9qwgoHLv2753zQOCcA61wCJ4
         ASXuml6AjUU1EX63a78TtnBe3v9dKyM8HxF0mGk0OEwSi9vUl2cLdbi3OnS7mPROB1q6
         5uTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942740; x=1684534740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XoUTXkkdzp66fUQa0SZgxh2I0hcfFcSevl2ozJzsZr8=;
        b=CRjXKUmsFIWf6hKOl/Ac1lSfukTdCmc4w0CKg7NqxVJXoqheFVZhV3BAVZRlBGIusu
         XTge42i8OrnPHUoImfUnWNXz2qLToO7suLIvsPwsWDZNzB0EembO9zXuLudhAvBK86Ay
         nWysI+v6EB+hl87xc56hCLgW2Ma7eBGIh/idi5BMx9qAmB0CuVhvAvamcxMv5wq/MJF2
         3kPtyw5ASLDCiivUqkr360ZbX3VN0dXStSa3sbPL9jNwDa3725q+xjuOXan/SGBd+8dD
         kC7ar6gVn3Vw+cjFUIy9Dbx4DogdGzd68b9tEIDN3Y90QGymWEnvO+/hLK4rctKugYml
         bB4w==
X-Gm-Message-State: AAQBX9djWc3Q+aNg5cBX9nzPPKBiHTijhAWkDac5c8juLiJ5aYyUEL2G
        0i+ovdsthM4e8UttChCIlu5v6w==
X-Google-Smtp-Source: AKy350Y7aINNAc9YHSFZjS/1v/4hxySiR9RBBeMIRAwJ/RoWtbD0/kdtTdNjVZfjscd6qYzOFWfZ9Q==
X-Received: by 2002:a17:902:eb91:b0:1a6:d2a9:3fab with SMTP id q17-20020a170902eb9100b001a6d2a93fabmr5967973plg.47.1681942740547;
        Wed, 19 Apr 2023 15:19:00 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:19:00 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Atish Patra <atishp@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 41/48] RISC-V: KVM: Add host side support to handle COVG SBI calls.
Date:   Wed, 19 Apr 2023 15:17:09 -0700
Message-Id: <20230419221716.3603068-42-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rajnesh Kanwal <rkanwal@rivosinc.com>

Adding host side support to allow memory sharing/unsharing.
Host needs to check if the page has been already assigned
(converted) to a TVM or not. If yes, that page needs to be
reclaimed before sharing that page.

For the remaining ECALLs host doesn't really need to do anything
and we just return in those cases.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_cove.h     |  11 +-
 arch/riscv/include/asm/kvm_cove_sbi.h |   4 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h |   3 +
 arch/riscv/include/uapi/asm/kvm.h     |   1 +
 arch/riscv/kvm/Makefile               |   2 +-
 arch/riscv/kvm/cove.c                 |  48 +++++-
 arch/riscv/kvm/cove_sbi.c             |  18 ++
 arch/riscv/kvm/vcpu_exit.c            |   2 +-
 arch/riscv/kvm/vcpu_sbi.c             |  14 ++
 arch/riscv/kvm/vcpu_sbi_covg.c        | 232 ++++++++++++++++++++++++++
 10 files changed, 328 insertions(+), 7 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi_covg.c

diff --git a/arch/riscv/include/asm/kvm_cove.h b/arch/riscv/include/asm/kvm_cove.h
index 4367281..afaea7c 100644
--- a/arch/riscv/include/asm/kvm_cove.h
+++ b/arch/riscv/include/asm/kvm_cove.h
@@ -31,6 +31,9 @@
 
 #define get_order_num_pages(n) (get_order(n << PAGE_SHIFT))
 
+#define get_gpr_index(goffset) \
+	((goffset - KVM_ARCH_GUEST_ZERO) / (__riscv_xlen / 8))
+
 /* Describe a confidential or shared memory region */
 struct kvm_riscv_cove_mem_region {
 	unsigned long hva;
@@ -139,7 +142,8 @@ int kvm_riscv_cove_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
 int kvm_riscv_cove_vm_measure_pages(struct kvm *kvm, struct kvm_riscv_cove_measure_region *mr);
 int kvm_riscv_cove_vm_add_memreg(struct kvm *kvm, unsigned long gpa, unsigned long size);
-int kvm_riscv_cove_gstage_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva);
+int kvm_riscv_cove_handle_pagefault(struct kvm_vcpu *vcpu, gpa_t gpa,
+				    unsigned long hva);
 /* Fence related function */
 int kvm_riscv_cove_tvm_fence(struct kvm_vcpu *vcpu);
 
@@ -179,8 +183,9 @@ static inline int kvm_riscv_cove_vm_measure_pages(struct kvm *kvm,
 {
 	return -1;
 }
-static inline int kvm_riscv_cove_gstage_map(struct kvm_vcpu *vcpu,
-					    gpa_t gpa, unsigned long hva) {return -1; }
+static inline int kvm_riscv_cove_handle_pagefault(struct kvm_vcpu *vcpu,
+						  gpa_t gpa, unsigned long hva) { return -1; }
+
 /* TVM interrupt managenet via AIA functions */
 static inline int kvm_riscv_cove_aia_init(struct kvm *kvm) { return -1; }
 static inline int kvm_riscv_cove_vcpu_inject_interrupt(struct kvm_vcpu *vcpu,
diff --git a/arch/riscv/include/asm/kvm_cove_sbi.h b/arch/riscv/include/asm/kvm_cove_sbi.h
index b554a8d..c930265 100644
--- a/arch/riscv/include/asm/kvm_cove_sbi.h
+++ b/arch/riscv/include/asm/kvm_cove_sbi.h
@@ -59,6 +59,10 @@ int sbi_covh_create_tvm_vcpu(unsigned long tvmid, unsigned long tvm_vcpuid,
 
 int sbi_covh_run_tvm_vcpu(unsigned long tvmid, unsigned long tvm_vcpuid);
 
+int sbi_covh_add_shared_pages(unsigned long tvmid, unsigned long page_addr_phys,
+			      enum sbi_cove_page_type ptype,
+			      unsigned long npages,
+			      unsigned long tvm_base_page_addr);
 int sbi_covh_tvm_invalidate_pages(unsigned long tvmid,
 			     unsigned long tvm_base_page_addr,
 			     unsigned long len);
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index b10c896..5b37a12 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -66,5 +66,8 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_dbcn;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
+#ifdef CONFIG_RISCV_COVE_HOST
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_covg;
+#endif
 
 #endif /* __RISCV_KVM_VCPU_SBI_H__ */
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index ac3def0..2a24341 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -148,6 +148,7 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_EXPERIMENTAL,
 	KVM_RISCV_SBI_EXT_VENDOR,
 	KVM_RISCV_SBI_EXT_DBCN,
+	KVM_RISCV_SBI_EXT_COVG,
 	KVM_RISCV_SBI_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 8c91551..31f4dbd 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -31,4 +31,4 @@ kvm-y += aia.o
 kvm-y += aia_device.o
 kvm-y += aia_aplic.o
 kvm-y += aia_imsic.o
-kvm-$(CONFIG_RISCV_COVE_HOST) += cove_sbi.o cove.o
+kvm-$(CONFIG_RISCV_COVE_HOST) += cove_sbi.o cove.o vcpu_sbi_covg.o
diff --git a/arch/riscv/kvm/cove.c b/arch/riscv/kvm/cove.c
index 154b01a..ba596b7 100644
--- a/arch/riscv/kvm/cove.c
+++ b/arch/riscv/kvm/cove.c
@@ -44,6 +44,18 @@ static void kvm_cove_local_fence(void *info)
 		kvm_err("local fence for TSM failed %d on cpu %d\n", rc, smp_processor_id());
 }
 
+static void cove_delete_shared_pinned_page_list(struct kvm *kvm,
+						struct list_head *tpages)
+{
+	struct kvm_riscv_cove_page *tpage, *temp;
+
+	list_for_each_entry_safe(tpage, temp, tpages, link) {
+		unpin_user_pages_dirty_lock(&tpage->page, 1, true);
+		list_del(&tpage->link);
+		kfree(tpage);
+	}
+}
+
 static void cove_delete_page_list(struct kvm *kvm, struct list_head *tpages, bool unpin)
 {
 	struct kvm_riscv_cove_page *tpage, *temp;
@@ -425,7 +437,8 @@ int kvm_riscv_cove_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	sbi_ext = kvm_vcpu_sbi_find_ext(vcpu, cp->a7);
 	if ((sbi_ext && sbi_ext->handler) && ((cp->a7 == SBI_EXT_DBCN) ||
-	    (cp->a7 == SBI_EXT_HSM) || (cp->a7 == SBI_EXT_SRST) || ext_is_01)) {
+	    (cp->a7 == SBI_EXT_HSM) || (cp->a7 == SBI_EXT_SRST) ||
+	    (cp->a7 == SBI_EXT_COVG) || ext_is_01)) {
 		ret = sbi_ext->handler(vcpu, run, &sbi_ret);
 	} else {
 		kvm_err("%s: SBI EXT %lx not supported for TVM\n", __func__, cp->a7);
@@ -451,7 +464,8 @@ int kvm_riscv_cove_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return ret;
 }
 
-int kvm_riscv_cove_gstage_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva)
+static int kvm_riscv_cove_gstage_map(struct kvm_vcpu *vcpu, gpa_t gpa,
+				     unsigned long hva)
 {
 	struct kvm_riscv_cove_page *tpage;
 	struct mm_struct *mm = current->mm;
@@ -517,6 +531,35 @@ int kvm_riscv_cove_gstage_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hv
 	return rc;
 }
 
+int kvm_riscv_cove_handle_pagefault(struct kvm_vcpu *vcpu, gpa_t gpa,
+				    unsigned long hva)
+{
+	struct kvm_cove_tvm_context *tvmc = vcpu->kvm->arch.tvmc;
+	struct kvm_riscv_cove_page *tpage, *next;
+	bool shared = false;
+
+	/* TODO: Implement a better approach to track regions to avoid
+	 * traversing the whole list on each fault.
+	 */
+	spin_lock(&vcpu->kvm->mmu_lock);
+	list_for_each_entry_safe(tpage, next, &tvmc->shared_pages, link) {
+		if (tpage->gpa == (gpa & PAGE_MASK)) {
+			shared = true;
+			break;
+		}
+	}
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	if (shared) {
+		return sbi_covh_add_shared_pages(tvmc->tvm_guest_id,
+						 page_to_phys(tpage->page),
+						 SBI_COVE_PAGE_4K, 1,
+						 gpa & PAGE_MASK);
+	}
+
+	return kvm_riscv_cove_gstage_map(vcpu, gpa, hva);
+}
+
 void noinstr kvm_riscv_cove_vcpu_switchto(struct kvm_vcpu *vcpu, struct kvm_cpu_trap *trap)
 {
 	int rc;
@@ -804,6 +847,7 @@ void kvm_riscv_cove_vm_destroy(struct kvm *kvm)
 	cove_delete_page_list(kvm, &tvmc->reclaim_pending_pages, false);
 	cove_delete_page_list(kvm, &tvmc->measured_pages, false);
 	cove_delete_page_list(kvm, &tvmc->zero_pages, true);
+	cove_delete_shared_pinned_page_list(kvm, &tvmc->shared_pages);
 
 	/* Reclaim and Free the pages for tvm state management */
 	rc = sbi_covh_tsm_reclaim_pages(page_to_phys(tvmc->tvm_state.page), tvmc->tvm_state.npages);
diff --git a/arch/riscv/kvm/cove_sbi.c b/arch/riscv/kvm/cove_sbi.c
index 01dc260..4759b49 100644
--- a/arch/riscv/kvm/cove_sbi.c
+++ b/arch/riscv/kvm/cove_sbi.c
@@ -380,6 +380,24 @@ int sbi_covh_add_zero_pages(unsigned long tvmid, unsigned long page_addr_phys,
 	return 0;
 }
 
+int sbi_covh_add_shared_pages(unsigned long tvmid, unsigned long page_addr_phys,
+			      enum sbi_cove_page_type ptype,
+			      unsigned long npages,
+			      unsigned long tvm_base_page_addr)
+{
+	struct sbiret ret;
+
+	if (!PAGE_ALIGNED(page_addr_phys))
+		return -EINVAL;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_TVM_ADD_SHARED_PAGES, tvmid,
+			page_addr_phys, ptype, npages, tvm_base_page_addr, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
 int sbi_covh_create_tvm_vcpu(unsigned long tvmid, unsigned long vcpuid,
 			     unsigned long vcpu_state_paddr)
 {
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index c46e7f2..51eb434 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -43,7 +43,7 @@ static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 
 	if (is_cove_vcpu(vcpu)) {
 		/* CoVE doesn't care about PTE prots now. No need to compute the prots */
-		ret = kvm_riscv_cove_gstage_map(vcpu, fault_addr, hva);
+		ret = kvm_riscv_cove_handle_pagefault(vcpu, fault_addr, hva);
 	} else {
 		ret = kvm_riscv_gstage_map(vcpu, memslot, fault_addr, hva,
 			(trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false);
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index d2f43bc..8bc7d73 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -13,6 +13,8 @@
 #include <asm/kvm_nacl.h>
 #include <asm/kvm_cove_sbi.h>
 #include <asm/kvm_vcpu_sbi.h>
+#include <asm/asm-offsets.h>
+#include <asm/kvm_cove.h>
 
 #ifndef CONFIG_RISCV_SBI_V01
 static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
@@ -32,6 +34,14 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu = {
 };
 #endif
 
+#ifndef CONFIG_RISCV_COVE_HOST
+static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_covg = {
+	.extid_start = -1UL,
+	.extid_end = -1UL,
+	.handler = NULL,
+};
+#endif
+
 struct kvm_riscv_sbi_extension_entry {
 	enum KVM_RISCV_SBI_EXT_ID dis_idx;
 	const struct kvm_vcpu_sbi_extension *ext_ptr;
@@ -82,6 +92,10 @@ static const struct kvm_riscv_sbi_extension_entry sbi_ext[] = {
 		.dis_idx = KVM_RISCV_SBI_EXT_VENDOR,
 		.ext_ptr = &vcpu_sbi_ext_vendor,
 	},
+	{
+		.dis_idx = KVM_RISCV_SBI_EXT_COVG,
+		.ext_ptr = &vcpu_sbi_ext_covg,
+	},
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
diff --git a/arch/riscv/kvm/vcpu_sbi_covg.c b/arch/riscv/kvm/vcpu_sbi_covg.c
new file mode 100644
index 0000000..44a3b06
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi_covg.c
@@ -0,0 +1,232 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2023 Rivos Inc.
+ *
+ * Authors:
+ *     Rajnesh Kanwal <rkanwal@rivosinc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/spinlock.h>
+#include <asm/csr.h>
+#include <asm/sbi.h>
+#include <asm/kvm_vcpu_sbi.h>
+#include <asm/kvm_cove.h>
+#include <asm/kvm_cove_sbi.h>
+
+static int cove_share_converted_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+				     struct kvm_riscv_cove_page *tpage)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_cove_tvm_context *tvmc = kvm->arch.tvmc;
+	int rc;
+
+	rc = sbi_covh_tvm_invalidate_pages(tvmc->tvm_guest_id, gpa, PAGE_SIZE);
+	if (rc)
+		return rc;
+
+	rc = kvm_riscv_cove_tvm_fence(vcpu);
+	if (rc)
+		goto err;
+
+	rc = sbi_covh_tvm_remove_pages(tvmc->tvm_guest_id, gpa, PAGE_SIZE);
+	if (rc)
+		goto err;
+
+	rc = sbi_covh_tsm_reclaim_page(page_to_phys(tpage->page));
+	if (rc)
+		return rc;
+
+	spin_lock(&kvm->mmu_lock);
+	list_del(&tpage->link);
+	list_add(&tpage->link, &tvmc->shared_pages);
+	spin_unlock(&kvm->mmu_lock);
+
+	return 0;
+
+err:
+	sbi_covh_tvm_validate_pages(tvmc->tvm_guest_id, gpa, PAGE_SIZE);
+
+	return rc;
+}
+
+static int cove_share_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+			   unsigned long *sbi_err)
+{
+	unsigned long hva = gfn_to_hva(vcpu->kvm, gpa >> PAGE_SHIFT);
+	struct kvm_cove_tvm_context *tvmc = vcpu->kvm->arch.tvmc;
+	struct mm_struct *mm = current->mm;
+	struct kvm_riscv_cove_page *tpage;
+	struct page *page;
+	int rc;
+
+	if (kvm_is_error_hva(hva)) {
+		/* Address is out of the guest ram memory region. */
+		*sbi_err = SBI_ERR_INVALID_PARAM;
+		return 0;
+	}
+
+	tpage = kmalloc(sizeof(*tpage), GFP_KERNEL_ACCOUNT);
+	if (!tpage)
+		return -ENOMEM;
+
+	mmap_read_lock(mm);
+	rc = pin_user_pages(hva, 1, FOLL_LONGTERM | FOLL_WRITE, &page, NULL);
+	mmap_read_unlock(mm);
+
+	if (rc != 1) {
+		rc = -EINVAL;
+		goto free_tpage;
+	} else if (!PageSwapBacked(page)) {
+		rc = -EIO;
+		goto free_tpage;
+	}
+
+	tpage->page = page;
+	tpage->gpa = gpa;
+	tpage->hva = hva;
+	INIT_LIST_HEAD(&tpage->link);
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+	list_add(&tpage->link, &tvmc->shared_pages);
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	return 0;
+
+free_tpage:
+	kfree(tpage);
+
+	return rc;
+}
+
+static int kvm_riscv_cove_share_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+				     unsigned long *sbi_err)
+{
+	struct kvm_cove_tvm_context *tvmc = vcpu->kvm->arch.tvmc;
+	struct kvm_riscv_cove_page *tpage, *next;
+	bool converted = false;
+
+	/*
+	 * Check if the shared memory is part of the pages already assigned
+	 * to the TVM.
+	 *
+	 * TODO: Implement a better approach to track regions to avoid
+	 * traversing the whole list.
+	 */
+	spin_lock(&vcpu->kvm->mmu_lock);
+	list_for_each_entry_safe(tpage, next, &tvmc->zero_pages, link) {
+		if (tpage->gpa == gpa) {
+			converted = true;
+			break;
+		}
+	}
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	if (converted)
+		return cove_share_converted_page(vcpu, gpa, tpage);
+
+	return cove_share_page(vcpu, gpa, sbi_err);
+}
+
+static int kvm_riscv_cove_unshare_page(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	struct kvm_riscv_cove_page *tpage, *next;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_cove_tvm_context *tvmc = kvm->arch.tvmc;
+	struct page *page = NULL;
+	int rc;
+
+	spin_lock(&kvm->mmu_lock);
+	list_for_each_entry_safe(tpage, next, &tvmc->shared_pages, link) {
+		if (tpage->gpa == gpa) {
+			page = tpage->page;
+			break;
+		}
+	}
+	spin_unlock(&kvm->mmu_lock);
+
+	if (unlikely(!page))
+		return -EINVAL;
+
+	rc = sbi_covh_tvm_invalidate_pages(tvmc->tvm_guest_id, gpa, PAGE_SIZE);
+	if (rc)
+		return rc;
+
+	rc = kvm_riscv_cove_tvm_fence(vcpu);
+	if (rc)
+		return rc;
+
+	rc = sbi_covh_tvm_remove_pages(tvmc->tvm_guest_id, gpa, PAGE_SIZE);
+	if (rc)
+		return rc;
+
+	unpin_user_pages_dirty_lock(&page, 1, true);
+
+	spin_lock(&kvm->mmu_lock);
+	list_del(&tpage->link);
+	spin_unlock(&kvm->mmu_lock);
+
+	kfree(tpage);
+
+	return 0;
+}
+
+static int kvm_sbi_ext_covg_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				    struct kvm_vcpu_sbi_return *retdata)
+{
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	uint32_t num_pages = cp->a1 / PAGE_SIZE;
+	unsigned long funcid = cp->a6;
+	unsigned long *err_val = &retdata->err_val;
+	uint32_t i;
+	int ret;
+
+	switch (funcid) {
+	case SBI_EXT_COVG_SHARE_MEMORY:
+		for (i = 0; i < num_pages; i++) {
+			ret = kvm_riscv_cove_share_page(
+				vcpu, cp->a0 + i * PAGE_SIZE, err_val);
+			if (ret || *err_val != SBI_SUCCESS)
+				return ret;
+		}
+		return 0;
+
+	case SBI_EXT_COVG_UNSHARE_MEMORY:
+		for (i = 0; i < num_pages; i++) {
+			ret = kvm_riscv_cove_unshare_page(
+				vcpu, cp->a0 + i * PAGE_SIZE);
+			if (ret)
+				return ret;
+		}
+		return 0;
+
+	case SBI_EXT_COVG_ADD_MMIO_REGION:
+	case SBI_EXT_COVG_REMOVE_MMIO_REGION:
+	case SBI_EXT_COVG_ALLOW_EXT_INTERRUPT:
+	case SBI_EXT_COVG_DENY_EXT_INTERRUPT:
+		/* We don't really need to do anything here for now. */
+		return 0;
+
+	default:
+		kvm_err("%s: Unsupported guest SBI %ld.\n", __func__, funcid);
+		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
+		return -EOPNOTSUPP;
+	}
+}
+
+unsigned long kvm_sbi_ext_covg_probe(struct kvm_vcpu *vcpu)
+{
+	/* KVM COVG SBI handler is only meant for handling calls from TSM */
+	return 0;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_covg = {
+	.extid_start = SBI_EXT_COVG,
+	.extid_end = SBI_EXT_COVG,
+	.handler = kvm_sbi_ext_covg_handler,
+	.probe = kvm_sbi_ext_covg_probe,
+};
-- 
2.25.1

