Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E94600E3D
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiJQLx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiJQLxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:53:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A7E53D39
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:53:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64231B81639
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194EEC433B5;
        Mon, 17 Oct 2022 11:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666007620;
        bh=JkBWkPIuSIXe9eQIz3zlM+OZss3C50u/x/WKjBuAZA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJY/44EbJqi2edZBxPtRVP+qqaSOASnhmgTqtaEnSFfMaRQR3Xjt4JML3efHQEhEo
         ZaA0q0tC5hwUQF3g4+nzF0tAVFQSZqWj/d0lkXr2GcR7W1hh6udqBXQ+S8qdBUyOuM
         hpjGLuFdAs4iKaYd4IjPFmfrr68J/vTxZ7MsNVQOlavnPKna8LzfwltrPvImuE0cG/
         LIPof/259t6jrlLRUKYvx4+VHbK2tAF7TPIQb8gKkHJw44HgNfZEwmZEF2XFuCTGe2
         4aXy6IWT7OgqutZA82DWSk3r0+MeksIsGjIXCGckqMyRVc5jCdeJY3pwvO90gm5gxD
         CsLQaVas1j/yg==
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
Subject: [PATCH v4 22/25] KVM: arm64: Maintain a copy of 'kvm_arm_vmid_bits' at EL2
Date:   Mon, 17 Oct 2022 12:52:06 +0100
Message-Id: <20221017115209.2099-23-will@kernel.org>
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

Sharing 'kvm_arm_vmid_bits' between EL1 and EL2 allows the host to
modify the variable arbitrarily, potentially leading to all sorts of
shenanians as this is used to configure the VTTBR register for the
guest stage-2.

In preparation for unmapping host sections entirely from EL2, maintain
a copy of 'kvm_arm_vmid_bits' in the pKVM hypervisor and initialise it
from the host value while it is still trusted.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
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
index ae8f37f4aa8c..31ad75da4d58 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -71,9 +71,6 @@ KVM_NVHE_ALIAS(nvhe_hyp_panic_handler);
 /* Vectors installed by hyp-init on reset HVC. */
 KVM_NVHE_ALIAS(__hyp_stub_vectors);
 
-/* VMID bits set by the KVM VMID allocator */
-KVM_NVHE_ALIAS(kvm_arm_vmid_bits);
-
 /* Static keys which are set if a vGIC trap should be handled in hyp. */
 KVM_NVHE_ALIAS(vgic_v2_cpuif_trap);
 KVM_NVHE_ALIAS(vgic_v3_cpuif_trap);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 25467f24803d..1d4b8122d010 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1893,6 +1893,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
+	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
 }
 
 static int kvm_hyp_init_protection(u32 hyp_va_bits)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index f5f300cc5864..826335ccad9d 100644
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
2.38.0.413.g74048e4d9e-goog

