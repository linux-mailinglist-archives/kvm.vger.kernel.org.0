Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B425B831F
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 10:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiINIgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 04:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiINIgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 04:36:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2796E74CFA
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 01:36:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B1E9B8167C
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 08:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5BAC43140;
        Wed, 14 Sep 2022 08:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663144587;
        bh=C6lb+SGUbChCXAYDSH5eSoT2q/RGEauP1K9rMRYRbXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6l7u4rhVRQpBFzCVfPVKCYKhI06IPChZ/Z8/lazLNQ6ALEwwBUhlF3S4O0raeY84
         shSTykddmN/7YAvAidsE6dnaU4ObSUXZov8u9h9iu1LVnnBEBLtII1vkjDAgwsi/DB
         kIUhH6Hd/bPv2pyKCi2mi0D5In5MqGxh4YUDfwxy8Ks8vSfx0vC/ELpIMM61qPFyT1
         3Qgk9hJQrFyW9E6ixXHeKLv0MVLyeTog+8IKKGPgZ7kCafDfBMK+IcOIZstytGoz3a
         FypCgXTRWA3jFoAk8t5/+Dp2EG4terQgY1hbSEZpRUKsiyuCBIRUQj/Ge0vbcvqtWg
         ptS6TTl+DTICg==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
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
Subject: [PATCH v3 22/25] KVM: arm64: Maintain a copy of 'kvm_arm_vmid_bits' at EL2
Date:   Wed, 14 Sep 2022 09:34:57 +0100
Message-Id: <20220914083500.5118-23-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sharing 'kvm_arm_vmid_bits' between EL1 and EL2 allows the host to
modify the variable arbitrarily, potentially leading to all sorts of
shenanians as this is used to configure the VTTBR register for the
guest stage-2.

In preparation for unmapping host sections entirely from EL2, maintain
a copy of 'kvm_arm_vmid_bits' in the pKVM hypervisor and initialise it
from the host value while it is still trusted.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 2 ++
 arch/arm64/kernel/image-vars.h   | 3 ---
 arch/arm64/kvm/arm.c             | 1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c   | 3 +++
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index fd99cf09972d..6797eafe7890 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -124,4 +124,6 @@ extern u64 kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val);
 
 extern unsigned long kvm_nvhe_sym(__icache_flags);
+extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
+
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 1407533dfb97..d20dc9d555af 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -83,9 +83,6 @@ KVM_NVHE_ALIAS(nvhe_hyp_panic_handler);
 /* Vectors installed by hyp-init on reset HVC. */
 KVM_NVHE_ALIAS(__hyp_stub_vectors);
 
-/* VMID bits set by the KVM VMID allocator */
-KVM_NVHE_ALIAS(kvm_arm_vmid_bits);
-
 /* Kernel symbols needed for cpus_have_final/const_caps checks. */
 KVM_NVHE_ALIAS(arm64_const_caps_ready);
 KVM_NVHE_ALIAS(cpu_hwcap_keys);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 56083ed49708..503046dca288 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1895,6 +1895,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
+	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
 }
 
 static int kvm_hyp_init_protection(u32 hyp_va_bits)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 09e221ea6184..3c9ce49dc15c 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -15,6 +15,9 @@
 /* Used by icache_is_vpipt(). */
 unsigned long __icache_flags;
 
+/* Used by kvm_get_vttbr(). */
+unsigned int kvm_arm_vmid_bits;
+
 /*
  * Set trap register values based on features in ID_AA64PFR0.
  */
-- 
2.37.2.789.g6183377224-goog

