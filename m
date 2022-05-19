Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6652252D4BE
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbiESNq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239087AbiESNpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87D1A503B
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:44:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80FE1B824AA
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2201C385AA;
        Thu, 19 May 2022 13:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967884;
        bh=4phMg5qKrrVOBZXC4vAMZ7uzsL/5lQSk91h6zsw+z5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYWUF7O+dZINKj8uUBJpxtiB+gKrfEI/2nL7l0N2Lr5z7rDx+cb0dAwDbLOcrYoGY
         WWM9Ip1wrYt2oIR8x34eqWc/uKJatACQ3BBWo6RdvTSOcuoRNh8aZriG5Ap+nN4Cc4
         sGlX1GkSoza2sWPCH+ZnmulcJRnnGkgoDUokF5hSoWC4MdHyh1CaQUtqIbf1Pq2/cj
         44Oo9U2tqWNRXFu64vNzoRvFXHZ4k1EXABMGdZjLMcNNM95bacGWt9AFeQcQkDtmaS
         SexpSKJc2RvTJ75aUFSaXQ8Bz2JU2uOph3beGtY23t+1DAaeC55ZnsUby52r1F2Ij4
         /DfDowgaTA3fw==
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
Subject: [PATCH 35/89] KVM: arm64: Unmap kvm_arm_hyp_percpu_base from the host
Date:   Thu, 19 May 2022 14:41:10 +0100
Message-Id: <20220519134204.5379-36-will@kernel.org>
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

In pKVM mode, we can't trust the host not to mess with the hypervisor
per-cpu offsets, so let's move the array containing them to the nVHE
code.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h  | 4 ++--
 arch/arm64/kernel/image-vars.h    | 3 ---
 arch/arm64/kvm/arm.c              | 9 ++++-----
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c | 2 ++
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 931a351da3f2..35b9d590bb74 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -110,7 +110,7 @@ enum __kvm_host_smccc_func {
 #define per_cpu_ptr_nvhe_sym(sym, cpu)						\
 	({									\
 		unsigned long base, off;					\
-		base = kvm_arm_hyp_percpu_base[cpu];				\
+		base = kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu];		\
 		off = (unsigned long)&CHOOSE_NVHE_SYM(sym) -			\
 		      (unsigned long)&CHOOSE_NVHE_SYM(__per_cpu_start);		\
 		base ? (typeof(CHOOSE_NVHE_SYM(sym))*)(base + off) : NULL;	\
@@ -198,7 +198,7 @@ DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
 #define __kvm_hyp_init		CHOOSE_NVHE_SYM(__kvm_hyp_init)
 #define __kvm_hyp_vector	CHOOSE_HYP_SYM(__kvm_hyp_vector)
 
-extern unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
+extern unsigned long kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[];
 DECLARE_KVM_NVHE_SYM(__per_cpu_start);
 DECLARE_KVM_NVHE_SYM(__per_cpu_end);
 
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 4e3b6d618ac1..37a2d833851a 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -102,9 +102,6 @@ KVM_NVHE_ALIAS(gic_nonsecure_priorities);
 KVM_NVHE_ALIAS(__start___kvm_ex_table);
 KVM_NVHE_ALIAS(__stop___kvm_ex_table);
 
-/* Array containing bases of nVHE per-CPU memory regions. */
-KVM_NVHE_ALIAS(kvm_arm_hyp_percpu_base);
-
 /* PMU available static key */
 #ifdef CONFIG_HW_PERF_EVENTS
 KVM_NVHE_ALIAS(kvm_arm_pmu_available);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5b41551a978b..c7b362db692f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -51,7 +51,6 @@ DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
-unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 static bool vgic_present;
@@ -1800,13 +1799,13 @@ static void teardown_hyp_mode(void)
 	free_hyp_pgds();
 	for_each_possible_cpu(cpu) {
 		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
-		free_pages(kvm_arm_hyp_percpu_base[cpu], nvhe_percpu_order());
+		free_pages(kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu], nvhe_percpu_order());
 	}
 }
 
 static int do_pkvm_init(u32 hyp_va_bits)
 {
-	void *per_cpu_base = kvm_ksym_ref(kvm_arm_hyp_percpu_base);
+	void *per_cpu_base = kvm_ksym_ref(kvm_nvhe_sym(kvm_arm_hyp_percpu_base));
 	int ret;
 
 	preempt_disable();
@@ -1907,7 +1906,7 @@ static int init_hyp_mode(void)
 
 		page_addr = page_address(page);
 		memcpy(page_addr, CHOOSE_NVHE_SYM(__per_cpu_start), nvhe_percpu_size());
-		kvm_arm_hyp_percpu_base[cpu] = (unsigned long)page_addr;
+		kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu] = (unsigned long)page_addr;
 	}
 
 	/*
@@ -1968,7 +1967,7 @@ static int init_hyp_mode(void)
 	}
 
 	for_each_possible_cpu(cpu) {
-		char *percpu_begin = (char *)kvm_arm_hyp_percpu_base[cpu];
+		char *percpu_begin = (char *)kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu];
 		char *percpu_end = percpu_begin + nvhe_percpu_size();
 
 		/* Map Hyp percpu pages */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index 9f54833af400..04d194583f1e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -23,6 +23,8 @@ u64 cpu_logical_map(unsigned int cpu)
 	return hyp_cpu_logical_map[cpu];
 }
 
+unsigned long __ro_after_init kvm_arm_hyp_percpu_base[NR_CPUS];
+
 unsigned long __hyp_per_cpu_offset(unsigned int cpu)
 {
 	unsigned long *cpu_base_array;
-- 
2.36.1.124.g0e6072fb45-goog

