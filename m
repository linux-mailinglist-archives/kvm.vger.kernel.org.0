Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847E4561D7E
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 16:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbiF3OOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 10:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236866AbiF3ONn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 10:13:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FEA3EA94
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:59:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C5A8B82AF5
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 13:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF40C341CE;
        Thu, 30 Jun 2022 13:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656597557;
        bh=hzobqoaj7h3GSxvMaHY728giC2LOivXExMKuupqC9ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y47t9JBw8RLykJWdILmhP9lGaYyY3zojiXUcsCZJ5ocvfeiRuDmzVliGU5K1mi+uz
         RdE2KGH8eX1TZeJts53UT6qiPEns3us/X0w+bJ4GggulzREJtF+DbujsWV7t7lX259
         IESGDT1knZXSHPhjRZGAu69LOIFIU1+2qDhV0RwT7yr6zHz9kxh2HH+5BDSzyLHYm0
         qUY05bXc9cTm8fALh2PfVRK+pak4yu+4vr4k+LV9HnZKLYx8pRQLCwIVcEtbpnZDVm
         MRskc1JpGki1Ym9uHCR9hd7LT1lx+439rhKTzdS3R8cj2gHEj0vxzcV2qmjqnnLbYa
         CamYheOaDKg5A==
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
Subject: [PATCH v2 21/24] KVM: arm64: Maintain a copy of 'kvm_arm_vmid_bits' at EL2
Date:   Thu, 30 Jun 2022 14:57:44 +0100
Message-Id: <20220630135747.26983-22-will@kernel.org>
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

Sharing 'kvm_arm_vmid_bits' between EL1 and EL2 allows the host to
modify the variable arbitrarily, potentially leading to all sorts of
shenanians as this is used to configure the VTTBR register for the
guest stage-2.

In preparation for unmapping host sections entirely from EL2, maintain
a copy of 'kvm_arm_vmid_bits' and initialise it from the host value
while it is still trusted.

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
index 37a2d833851a..3e2489d23ff0 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -80,9 +80,6 @@ KVM_NVHE_ALIAS(nvhe_hyp_panic_handler);
 /* Vectors installed by hyp-init on reset HVC. */
 KVM_NVHE_ALIAS(__hyp_stub_vectors);
 
-/* VMID bits set by the KVM VMID allocator */
-KVM_NVHE_ALIAS(kvm_arm_vmid_bits);
-
 /* Kernel symbols needed for cpus_have_final/const_caps checks. */
 KVM_NVHE_ALIAS(arm64_const_caps_ready);
 KVM_NVHE_ALIAS(cpu_hwcap_keys);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1934fcb2c2d3..fe249b584115 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1901,6 +1901,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
+	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
 }
 
 static int kvm_hyp_init_protection(u32 hyp_va_bits)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index a4a518b2a43b..571334fd58ff 100644
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
2.37.0.rc0.161.g10f37bed90-goog

