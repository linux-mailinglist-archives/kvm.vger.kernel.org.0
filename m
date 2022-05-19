Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2ED52D48B
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiESNpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239018AbiESNna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:43:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FD211A0B
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:43:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5717B61783
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D70C36AE5;
        Thu, 19 May 2022 13:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967808;
        bh=VpCHFYe7b/5jyhZPAK7fuHkHfa8hXGsnhqm9qxHLxXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gB0CNkl1yevGk58fK78reoE/0Yio09r1ADUJfaH5lY+bJD/N7olBepAghMJksnDgm
         ekGLJ/KMeoNZqPadOeiy923fx8In5qSr7MDO1XEzhu/ORKvM1ssle0lHTq++ZcippI
         /rxCbC1vaujql1njxf41PeSq8yt36mXQU8MBMHPf6HEnQd90U1ktmqB9xXpvqbBDYh
         jEK62sg01e/i45IzkXOSp57tJ2n8aiFTh+DAjLrxkLvH9jMCDmjsGt22ap2qEXaGUC
         f0D3+n4+XIQqT2EdwMG30QtgQeifz/lQV/FWhilfSz2SZ3vC5Z/h7RhA+N22aCrMIG
         MnCnhJWB/DkXQ==
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
Subject: [PATCH 16/89] KVM: arm64: Instantiate VM shadow data from EL1
Date:   Thu, 19 May 2022 14:40:51 +0100
Message-Id: <20220519134204.5379-17-will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Now that EL2 provides calls to create and destroy shadow VM structures,
plumb these into the KVM code at EL1 so that a shadow VM is created on
first vCPU run and destroyed later along with the 'struct kvm' at
teardown time.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h  |   6 ++
 arch/arm64/include/asm/kvm_pkvm.h  |   4 ++
 arch/arm64/kvm/arm.c               |  14 ++++
 arch/arm64/kvm/hyp/hyp-constants.c |   3 +
 arch/arm64/kvm/pkvm.c              | 112 +++++++++++++++++++++++++++++
 5 files changed, 139 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9ba721fc1600..13967fc9731a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -103,6 +103,12 @@ struct kvm_arch_memory_slot {
 
 struct kvm_protected_vm {
 	unsigned int shadow_handle;
+	struct mutex shadow_lock;
+
+	struct {
+		void *pgd;
+		void *shadow;
+	} hyp_donations;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 11526e89fe5c..1dc7372950b1 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -14,6 +14,10 @@
 
 #define HYP_MEMBLOCK_REGIONS 128
 
+int kvm_init_pvm(struct kvm *kvm);
+int kvm_shadow_create(struct kvm *kvm);
+void kvm_shadow_destroy(struct kvm *kvm);
+
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
 extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7f8731306c2a..14adfd09e882 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -37,6 +37,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_pkvm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/sections.h>
 
@@ -146,6 +147,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_free_stage2_pgd;
 
+	ret = kvm_init_pvm(kvm);
+	if (ret)
+		goto out_free_stage2_pgd;
+
 	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL)) {
 		ret = -ENOMEM;
 		goto out_free_stage2_pgd;
@@ -182,6 +187,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 
 	kvm_vgic_destroy(kvm);
 
+	if (is_protected_kvm_enabled())
+		kvm_shadow_destroy(kvm);
+
 	kvm_destroy_vcpus(kvm);
 
 	kvm_unshare_hyp(kvm, kvm + 1);
@@ -545,6 +553,12 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
+	if (is_protected_kvm_enabled()) {
+		ret = kvm_shadow_create(kvm);
+		if (ret)
+			return ret;
+	}
+
 	if (!irqchip_in_kernel(kvm)) {
 		/*
 		 * Tell the rest of the code that there are userspace irqchip
diff --git a/arch/arm64/kvm/hyp/hyp-constants.c b/arch/arm64/kvm/hyp/hyp-constants.c
index b3742a6691e8..eee79527f901 100644
--- a/arch/arm64/kvm/hyp/hyp-constants.c
+++ b/arch/arm64/kvm/hyp/hyp-constants.c
@@ -2,9 +2,12 @@
 
 #include <linux/kbuild.h>
 #include <nvhe/memory.h>
+#include <nvhe/pkvm.h>
 
 int main(void)
 {
 	DEFINE(STRUCT_HYP_PAGE_SIZE,	sizeof(struct hyp_page));
+	DEFINE(KVM_SHADOW_VM_SIZE,	sizeof(struct kvm_shadow_vm));
+	DEFINE(KVM_SHADOW_VCPU_STATE_SIZE, sizeof(struct kvm_shadow_vcpu_state));
 	return 0;
 }
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 3947063cc3a1..b4466b31d7c8 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -6,6 +6,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/memblock.h>
+#include <linux/mutex.h>
 #include <linux/sort.h>
 
 #include <asm/kvm_pkvm.h>
@@ -94,3 +95,114 @@ void __init kvm_hyp_reserve(void)
 	kvm_info("Reserved %lld MiB at 0x%llx\n", hyp_mem_size >> 20,
 		 hyp_mem_base);
 }
+
+/*
+ * Allocates and donates memory for EL2 shadow structs.
+ *
+ * Allocates space for the shadow state, which includes the shadow vm as well as
+ * the shadow vcpu states.
+ *
+ * Stores an opaque handler in the kvm struct for future reference.
+ *
+ * Return 0 on success, negative error code on failure.
+ */
+static int __kvm_shadow_create(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu, **vcpu_array;
+	unsigned int shadow_handle;
+	size_t pgd_sz, shadow_sz;
+	void *pgd, *shadow_addr;
+	unsigned long idx;
+	int ret;
+
+	if (kvm->created_vcpus < 1)
+		return -EINVAL;
+
+	pgd_sz = kvm_pgtable_stage2_pgd_size(kvm->arch.vtcr);
+	/*
+	 * The PGD pages will be reclaimed using a hyp_memcache which implies
+	 * page granularity. So, use alloc_pages_exact() to get individual
+	 * refcounts.
+	 */
+	pgd = alloc_pages_exact(pgd_sz, GFP_KERNEL_ACCOUNT);
+	if (!pgd)
+		return -ENOMEM;
+
+	/* Allocate memory to donate to hyp for the kvm and vcpu state. */
+	shadow_sz = PAGE_ALIGN(KVM_SHADOW_VM_SIZE +
+			       KVM_SHADOW_VCPU_STATE_SIZE * kvm->created_vcpus);
+	shadow_addr = alloc_pages_exact(shadow_sz, GFP_KERNEL_ACCOUNT);
+	if (!shadow_addr) {
+		ret = -ENOMEM;
+		goto free_pgd;
+	}
+
+	/* Stash the vcpu pointers into the PGD */
+	BUILD_BUG_ON(KVM_MAX_VCPUS > (PAGE_SIZE / sizeof(u64)));
+	vcpu_array = pgd;
+	kvm_for_each_vcpu(idx, vcpu, kvm) {
+		/* Indexing of the vcpus to be sequential starting at 0. */
+		if (WARN_ON(vcpu->vcpu_idx != idx)) {
+			ret = -EINVAL;
+			goto free_shadow;
+		}
+
+		vcpu_array[idx] = vcpu;
+	}
+
+	/* Donate the shadow memory to hyp and let hyp initialize it. */
+	ret = kvm_call_hyp_nvhe(__pkvm_init_shadow, kvm, shadow_addr, shadow_sz,
+				pgd);
+	if (ret < 0)
+		goto free_shadow;
+
+	shadow_handle = ret;
+
+	/* Store the shadow handle given by hyp for future call reference. */
+	kvm->arch.pkvm.shadow_handle = shadow_handle;
+	kvm->arch.pkvm.hyp_donations.pgd = pgd;
+	kvm->arch.pkvm.hyp_donations.shadow = shadow_addr;
+	return 0;
+
+free_shadow:
+	free_pages_exact(shadow_addr, shadow_sz);
+free_pgd:
+	free_pages_exact(pgd, pgd_sz);
+	return ret;
+}
+
+int kvm_shadow_create(struct kvm *kvm)
+{
+	int ret = 0;
+
+	mutex_lock(&kvm->arch.pkvm.shadow_lock);
+	if (!kvm->arch.pkvm.shadow_handle)
+		ret = __kvm_shadow_create(kvm);
+	mutex_unlock(&kvm->arch.pkvm.shadow_lock);
+
+	return ret;
+}
+
+void kvm_shadow_destroy(struct kvm *kvm)
+{
+	size_t pgd_sz, shadow_sz;
+
+	if (kvm->arch.pkvm.shadow_handle)
+		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_shadow,
+					  kvm->arch.pkvm.shadow_handle));
+
+	kvm->arch.pkvm.shadow_handle = 0;
+
+	shadow_sz = PAGE_ALIGN(KVM_SHADOW_VM_SIZE +
+			       KVM_SHADOW_VCPU_STATE_SIZE * kvm->created_vcpus);
+	pgd_sz = kvm_pgtable_stage2_pgd_size(kvm->arch.vtcr);
+
+	free_pages_exact(kvm->arch.pkvm.hyp_donations.shadow, shadow_sz);
+	free_pages_exact(kvm->arch.pkvm.hyp_donations.pgd, pgd_sz);
+}
+
+int kvm_init_pvm(struct kvm *kvm)
+{
+	mutex_init(&kvm->arch.pkvm.shadow_lock);
+	return 0;
+}
-- 
2.36.1.124.g0e6072fb45-goog

