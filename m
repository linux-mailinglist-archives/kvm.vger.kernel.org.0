Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A50152D48D
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239059AbiESNpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239037AbiESNnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:43:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549D7443F8
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:43:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F133FB824AB
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFD8C34116;
        Thu, 19 May 2022 13:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967820;
        bh=ZKFkdmQPlHoIGxtsviQjoI5whn3KGkXdjZ9/Hq7eV5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYocypmRqQAjksl1sou8UeHVogLdcxfGY5ei08yODBnJD8cunzCU47bnzdvuMa3Or
         nrPcI3DlkILGnfJb1bx6tSBUtpxgErrAJYsSteRTTXECFZJxrf2p+TYvNzWJHMWdJG
         J6jfPUX7+mS8aaEAQD0X9B1q7BJkgmJUYuRItzWEKHkqnNYEnp3TNqLpkI2+zgNCCp
         kNESjIWdXbcnxRkBNWRU1ARTEWkMguHMCZnHJoMdplEOwZhNl8FVWCdAt14macV5cc
         W5pyD8izX+t1RZ0LF4XVXd3Ji+Xtiy6Ay0hdTwuRYRXZVCDf7u5Zj0v+eW3udpuAex
         PFE/l80nd0Ndg==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 19/89] KVM: arm64: Add pcpu fixmap infrastructure at EL2
Date:   Thu, 19 May 2022 14:40:54 +0100
Message-Id: <20220519134204.5379-20-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

We will soon need to temporarily map pages into the hypervisor stage-1
in nVHE protected mode. To do this efficiently, let's introduce a
per-cpu fixmap allowing to map a single page without needing to take any
lock or to allocate memory.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  4 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  1 -
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 85 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |  4 +
 5 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 3a0817b5c739..d11d9d68a680 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -59,6 +59,8 @@ enum pkvm_component_id {
 	PKVM_ID_HYP,
 };
 
+extern unsigned long hyp_nr_cpus;
+
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 73309ccc192e..45b04bfee171 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -13,6 +13,10 @@
 extern struct kvm_pgtable pkvm_pgtable;
 extern hyp_spinlock_t pkvm_pgd_lock;
 
+int hyp_create_pcpu_fixmap(void);
+void *hyp_fixmap_map(phys_addr_t phys);
+int hyp_fixmap_unmap(void);
+
 int hyp_create_idmap(u32 hyp_va_bits);
 int hyp_map_vectors(void);
 int hyp_back_vmemmap(phys_addr_t back);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 502bc0d04858..707bd832145f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -21,7 +21,6 @@
 
 #define KVM_HOST_S2_FLAGS (KVM_PGTABLE_S2_NOFWB | KVM_PGTABLE_S2_IDMAP)
 
-extern unsigned long hyp_nr_cpus;
 struct host_kvm host_kvm;
 
 static struct hyp_pool host_s2_pool;
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 4377b067dc0e..bdb39897343f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -14,6 +14,7 @@
 #include <nvhe/early_alloc.h>
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
+#include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/spinlock.h>
 
@@ -24,6 +25,7 @@ struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
 unsigned int hyp_memblock_nr;
 
 static u64 __io_map_base;
+static DEFINE_PER_CPU(void *, hyp_fixmap_base);
 
 static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 				  unsigned long phys, enum kvm_pgtable_prot prot)
@@ -198,6 +200,89 @@ int hyp_map_vectors(void)
 	return 0;
 }
 
+void *hyp_fixmap_map(phys_addr_t phys)
+{
+	void *addr = *this_cpu_ptr(&hyp_fixmap_base);
+	int ret = kvm_pgtable_hyp_map(&pkvm_pgtable, (u64)addr, PAGE_SIZE,
+				      phys, PAGE_HYP);
+	return ret ? NULL : addr;
+}
+
+int hyp_fixmap_unmap(void)
+{
+	void *addr = *this_cpu_ptr(&hyp_fixmap_base);
+	int ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)addr, PAGE_SIZE);
+
+	return (ret != PAGE_SIZE) ? -EINVAL : 0;
+}
+
+static int __pin_pgtable_cb(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			    enum kvm_pgtable_walk_flags flag, void * const arg)
+{
+	if (!kvm_pte_valid(*ptep) || level != KVM_PGTABLE_MAX_LEVELS - 1)
+		return -EINVAL;
+	hyp_page_ref_inc(hyp_virt_to_page(ptep));
+
+	return 0;
+}
+
+static int hyp_pin_pgtable_pages(u64 addr)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= __pin_pgtable_cb,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+	};
+
+	return kvm_pgtable_walk(&pkvm_pgtable, addr, PAGE_SIZE, &walker);
+}
+
+int hyp_create_pcpu_fixmap(void)
+{
+	unsigned long i;
+	int ret = 0;
+	u64 addr;
+
+	hyp_spin_lock(&pkvm_pgd_lock);
+
+	for (i = 0; i < hyp_nr_cpus; i++) {
+		addr = hyp_alloc_private_va_range(PAGE_SIZE);
+		if (IS_ERR((void *)addr)) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
+
+		/*
+		 * Create a dummy mapping, to get the intermediate page-table
+		 * pages allocated, then take a reference on the last level
+		 * page to keep it around at all times.
+		 */
+		ret = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, PAGE_SIZE,
+					  __hyp_pa(__hyp_bss_start), PAGE_HYP);
+		if (ret) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+
+		ret = hyp_pin_pgtable_pages(addr);
+		if (ret)
+			goto unlock;
+
+		ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, addr, PAGE_SIZE);
+		if (ret != PAGE_SIZE) {
+			ret = -EINVAL;
+			goto unlock;
+		} else {
+			ret = 0;
+		}
+
+		*per_cpu_ptr(&hyp_fixmap_base, i) = (void *)addr;
+	}
+unlock:
+	hyp_spin_unlock(&pkvm_pgd_lock);
+
+	return ret;
+}
+
 int hyp_create_idmap(u32 hyp_va_bits)
 {
 	unsigned long start, end;
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index b306da2b5dae..59a478dde533 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -296,6 +296,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = hyp_create_pcpu_fixmap();
+	if (ret)
+		goto out;
+
 	hyp_shadow_table_init(shadow_table_base);
 out:
 	/*
-- 
2.36.1.124.g0e6072fb45-goog

