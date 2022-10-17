Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BBA600E33
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiJQLx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJQLxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:53:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B7059724
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5D10610A3
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AEFC4347C;
        Mon, 17 Oct 2022 11:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666007599;
        bh=M/4MPZmrF3Xl70G5UyY6515GYKhKwEoLZXAGqLSMA34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/CdCPgQGnwuaTuxakgdzbxNj0v8eLVsfYLdmxmp8SaiMouEUGMKu0TD6a+VEW9j5
         0v4EW5h/Y0q+j1suho8GB+wrXnmvveoFyCPLvFXebDx/Wr/AvbF2g2IpP5pvTQtAYM
         hiLacCF8eOeObUETT1kgy4/gN7+5OKrXcAdq9B+/wiVqmq3QaIlA9vovK9iBfOZJkY
         iHRJTXBFdb049K+xqf4EH0YcfAykIliqLrcgw+rmplneBkXIKF+HIz/egIECbXmnAa
         nJzkOZr2eEKn3tHq6socY5JFcXONaYJguy0qr+E9gY7lfnb8vnSs/iRcQ/KJ6nDfP6
         1rENzzTadFvvw==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 16/25] KVM: arm64: Provide I-cache invalidation by virtual address at EL2
Date:   Mon, 17 Oct 2022 12:52:00 +0100
Message-Id: <20221017115209.2099-17-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221017115209.2099-1-will@kernel.org>
References: <20221017115209.2099-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for handling cache maintenance of guest pages from within
the pKVM hypervisor at EL2, introduce an EL2 copy of icache_inval_pou()
which will later be plumbed into the stage-2 page-table cache
maintenance callbacks, ensuring that the initial contents of pages
mapped as executable into the guest stage-2 page-table is visible to the
instruction fetcher.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h |  1 +
 arch/arm64/kernel/image-vars.h   |  3 ---
 arch/arm64/kvm/arm.c             |  1 +
 arch/arm64/kvm/hyp/nvhe/cache.S  | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c   |  3 +++
 5 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index aa7fa2a08f06..fd99cf09972d 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,4 +123,5 @@ extern u64 kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val);
 
+extern unsigned long kvm_nvhe_sym(__icache_flags);
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 8151412653de..7f4e43bfaade 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -71,9 +71,6 @@ KVM_NVHE_ALIAS(nvhe_hyp_panic_handler);
 /* Vectors installed by hyp-init on reset HVC. */
 KVM_NVHE_ALIAS(__hyp_stub_vectors);
 
-/* Kernel symbol used by icache_is_vpipt(). */
-KVM_NVHE_ALIAS(__icache_flags);
-
 /* VMID bits set by the KVM VMID allocator */
 KVM_NVHE_ALIAS(kvm_arm_vmid_bits);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 584626e11797..d99e93e6ddf7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1894,6 +1894,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
+	kvm_nvhe_sym(__icache_flags) = __icache_flags;
 }
 
 static int kvm_hyp_init_protection(u32 hyp_va_bits)
diff --git a/arch/arm64/kvm/hyp/nvhe/cache.S b/arch/arm64/kvm/hyp/nvhe/cache.S
index 0c367eb5f4e2..85936c17ae40 100644
--- a/arch/arm64/kvm/hyp/nvhe/cache.S
+++ b/arch/arm64/kvm/hyp/nvhe/cache.S
@@ -12,3 +12,14 @@ SYM_FUNC_START(__pi_dcache_clean_inval_poc)
 	ret
 SYM_FUNC_END(__pi_dcache_clean_inval_poc)
 SYM_FUNC_ALIAS(dcache_clean_inval_poc, __pi_dcache_clean_inval_poc)
+
+SYM_FUNC_START(__pi_icache_inval_pou)
+alternative_if ARM64_HAS_CACHE_DIC
+	isb
+	ret
+alternative_else_nop_endif
+
+	invalidate_icache_by_line x0, x1, x2, x3
+	ret
+SYM_FUNC_END(__pi_icache_inval_pou)
+SYM_FUNC_ALIAS(icache_inval_pou, __pi_icache_inval_pou)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 5970fd1adbfb..2156ce546d90 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -12,6 +12,9 @@
 #include <nvhe/pkvm.h>
 #include <nvhe/trap_handler.h>
 
+/* Used by icache_is_vpipt(). */
+unsigned long __icache_flags;
+
 /*
  * Set trap register values based on features in ID_AA64PFR0.
  */
-- 
2.38.0.413.g74048e4d9e-goog

