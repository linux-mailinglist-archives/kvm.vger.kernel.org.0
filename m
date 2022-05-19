Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F9D52D494
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbiESNpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239096AbiESNpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936C8633B2
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:44:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B5EAB824AF
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99165C34116;
        Thu, 19 May 2022 13:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967888;
        bh=zqVKKbCik0BT2NOr+vAjDmAd6qPp7FwhBrExj8PC3kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jy8ugjMKFxgJUzCZw6EpncJky9cpGzBKD5/4kvwzMIa55oGxz246ROlAncFfRa1UM
         9hREYDF0Ni1ok99Q2uLXDG/J8/0/6J5jiusuaRlvOVYXiWwB7+ruivYt/MlDKcZUx8
         VlEAZyJYVaL7c9KAz273kzz1aRLPFLdVps8hRYWMjDIt7yOAXlLzU9TOjnCjl6mfV0
         RP6pk6GJtA0ldfTMZH4/t5gWXjAiqXhID8G8r9oz3Y3ije/2BPPtZQyIs7YV8J7kMb
         0RItXDoYdh/FH5aB3ziBvqo9CfIvsENgFpTOG4D8G1vPRYIVD0mdYI3xoongn169V4
         mmz3pHulVGSkQ==
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
Subject: [PATCH 36/89] KVM: arm64: Maintain a copy of 'kvm_arm_vmid_bits' at EL2
Date:   Thu, 19 May 2022 14:41:11 +0100
Message-Id: <20220519134204.5379-37-will@kernel.org>
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

Sharing 'kvm_arm_vmids_bits' between EL1 and EL2 allows the host to
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
index c7b362db692f..07d2ac6a5aff 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1839,6 +1839,7 @@ static int kvm_hyp_init_protection(u32 hyp_va_bits)
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
+	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
 
 	ret = create_hyp_mappings(addr, addr + hyp_mem_size, PAGE_HYP);
 	if (ret)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 9cd2bf75ed88..b29142a09e36 100644
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
2.36.1.124.g0e6072fb45-goog

