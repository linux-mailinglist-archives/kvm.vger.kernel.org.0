Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75901FACA4
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 11:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgFPJg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 05:36:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6267 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728131AbgFPJg0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 05:36:26 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B1B0AEC54AB3263F89AF;
        Tue, 16 Jun 2020 17:36:23 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.173.221.230) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Tue, 16 Jun 2020 17:36:14 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <liangpeng10@huawei.com>, <zhengxiang9@huawei.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH 12/12] KVM: arm64: Enable stage2 hardware DBM
Date:   Tue, 16 Jun 2020 17:35:53 +0800
Message-ID: <20200616093553.27512-13-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200616093553.27512-1-zhukeqian1@huawei.com>
References: <20200616093553.27512-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We are ready to support hw management of dirty state, enable it if
hardware support it.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/include/asm/sysreg.h | 2 ++
 arch/arm64/kvm/reset.c          | 9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 463175f80341..b22bd903284d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -744,6 +744,8 @@
 #define ID_AA64MMFR1_VMIDBITS_8		0
 #define ID_AA64MMFR1_VMIDBITS_16	2
 
+#define ID_AA64MMFR1_HADBS_DBS		2
+
 /* id_aa64mmfr2 */
 #define ID_AA64MMFR2_E0PD_SHIFT		60
 #define ID_AA64MMFR2_FWB_SHIFT		40
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 52bb801c9b2c..c1215b13bdd5 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -427,7 +427,7 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
 {
 	u64 vtcr = VTCR_EL2_FLAGS, mmfr0;
 	u32 parange, phys_shift;
-	u8 lvls;
+	u8 lvls, hadbs;
 
 	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
 		return -EINVAL;
@@ -465,6 +465,13 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
 	 */
 	vtcr |= VTCR_EL2_HA;
 
+#ifdef CONFIG_ARM64_HW_AFDBM
+	hadbs = (read_sysreg(id_aa64mmfr1_el1) >>
+			ID_AA64MMFR1_HADBS_SHIFT) & 0xf;
+	if (hadbs == ID_AA64MMFR1_HADBS_DBS)
+		vtcr |= VTCR_EL2_HD;
+#endif
+
 	/* Set the vmid bits */
 	vtcr |= (kvm_get_vmid_bits() == 16) ?
 		VTCR_EL2_VS_16BIT :
-- 
2.19.1

