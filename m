Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4E2561D60
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 16:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237140AbiF3OOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 10:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237520AbiF3ONY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 10:13:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F338F3D4AF
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:59:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7250B82AEE
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 13:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E616C34115;
        Thu, 30 Jun 2022 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656597538;
        bh=ZveGRgYhfySF35odUPkFs+MNL1f3DyIjjBE7MoE4TyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+1n+DWBniNKsEpzWDzTdUKWl3EUJfZu7PvHRXt9V8WZDDGGsltKsc9x09zvhUb7O
         biqrgnBhO0oFce9EdmYiK3bjLqYwkdIAn1UaSFQFjcy5EFiJ7sQ4VzBlU9XnfK2N7V
         jA1flOAivVlcxxI1QQmOHMnDun2ooKzaPPZc56nLTFBPk3Ch1s9IxeRH+yUV/CxlQ+
         2+Co0Z54uTIIB7eAmQ/DwjJINyJFpcufqeBwINwsYHjD3PCECyJc6eZjTu2mpedJ/d
         xG9mub5UMR8D2FbwPKQJolcf3Kfs4SbBaDGJHUvNuHSo3wij8XPAC9GiWMyHMWofUy
         abYxdUbMFKDzA==
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
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 16/24] KVM: arm64: Provide I-cache invalidation by VA at EL2
Date:   Thu, 30 Jun 2022 14:57:39 +0100
Message-Id: <20220630135747.26983-17-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for handling cache maintenance of guest pages at EL2,
introduce an EL2 copy of icache_inval_pou() which will later be plumbed
into the stage-2 page-table cache maintenance callbacks.

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
index 241c86b67d01..4e3b6d618ac1 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -80,9 +80,6 @@ KVM_NVHE_ALIAS(nvhe_hyp_panic_handler);
 /* Vectors installed by hyp-init on reset HVC. */
 KVM_NVHE_ALIAS(__hyp_stub_vectors);
 
-/* Kernel symbol used by icache_is_vpipt(). */
-KVM_NVHE_ALIAS(__icache_flags);
-
 /* VMID bits set by the KVM VMID allocator */
 KVM_NVHE_ALIAS(kvm_arm_vmid_bits);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a2343640c73c..90e0e7f38bb5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1901,6 +1901,7 @@ static void kvm_hyp_init_symbols(void)
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
index 77aeb787670b..114c5565de7d 100644
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
2.37.0.rc0.161.g10f37bed90-goog

