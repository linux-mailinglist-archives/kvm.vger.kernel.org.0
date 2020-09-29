Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFC527C0DF
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 11:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgI2JSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 05:18:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14711 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728025AbgI2JSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 05:18:21 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B1E9BF27A1E5B154B283;
        Tue, 29 Sep 2020 17:18:07 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.69) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 17:17:58 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <will@kernel.org>, <catalin.marinas@arm.com>, <maz@kernel.org>,
        <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
        <suzuki.poulose@arm.com>, <wanghaibin.wang@huawei.com>,
        <yezengruan@huawei.com>, <shameerali.kolothum.thodi@huawei.com>,
        <fanhenglong@huawei.com>, <wangjingyi11@huawei.com>,
        <prime.zeng@hisilicon.com>
Subject: [RFC PATCH 3/4] KVM: arm64: Use dynamic TWE Delay value
Date:   Tue, 29 Sep 2020 17:17:26 +0800
Message-ID: <20200929091727.8692-4-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
In-Reply-To: <20200929091727.8692-1-wangjingyi11@huawei.com>
References: <20200929091727.8692-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.69]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We implement two new kernel parameters for changing the delay adaptively:
twed_grow and twed_shrink
twed_grow affects the delay on WFE trap and twed_shrink does it on
sched_in; depending on their value, the delay is modifier like this:

     twed_shrink/ |
     twed_grow    | WFE trap exit | sched_in
    --------------+---------------+------------
     < 1          | = twed        | = twed
     otherwise    | = twed + 1    | = twed - 1

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  6 ++++++
 arch/arm64/include/asm/kvm_host.h    |  6 +++++-
 arch/arm64/kvm/arm.c                 | 32 ++++++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c         |  2 ++
 4 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 1a9cce836170..546d10b3b534 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -116,16 +116,22 @@ static inline void vcpu_twed_disable(struct kvm_vcpu *vcpu)
 static inline void vcpu_twed_init(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.twed = (u64)twed;
+	vcpu->arch.twed_dirty = true;
 }
 
 static inline void vcpu_set_twed(struct kvm_vcpu *vcpu)
 {
 	u64 delay = vcpu->arch.twed;
+
+	if (!vcpu->arch.twed_dirty)
+		return;
+
 	if (delay > HCR_TWEDEL_MAX)
 		delay = HCR_TWEDEL_MAX;
 
 	vcpu->arch.hcr_el2 &= ~HCR_TWEDEL_MASK;
 	vcpu->arch.hcr_el2 |= (delay << HCR_TWEDEL_SHIFT);
+	vcpu->arch.twed_dirty = false;
 }
 #else
 static inline void vcpu_twed_enable(struct kvm_vcpu *vcpu) {};
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 380cd9c8ad0f..35d1953d9d35 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -375,6 +375,7 @@ struct kvm_vcpu_arch {
 #ifdef CONFIG_ARM64_TWED
 	/* WFE trap delay */
 	u64 twed;
+	bool twed_dirty;
 #endif
 };
 
@@ -595,7 +596,6 @@ void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
 
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 void kvm_arm_init_debug(void);
@@ -697,8 +697,12 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 #define use_twed() (has_twed() && twed_enable)
 extern bool twed_enable;
 extern unsigned int twed;
+void grow_twed(struct kvm_vcpu *vcpu);
+void shrink_twed(struct kvm_vcpu *vcpu);
 #else
 #define use_twed() false
+static inline void grow_twed(struct kvm_vcpu *vcpu) {};
+static inline void shrink_twed(struct kvm_vcpu *vcpu) {};
 #endif
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5b5e8b14dcd5..989bffdcb3e9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -65,6 +65,32 @@ module_param(twed_enable, bool, S_IRUGO | S_IWUSR);
 
 unsigned int twed = 0;
 module_param(twed, uint, S_IRUGO | S_IWUSR);
+
+static unsigned int twed_grow = 0;
+module_param(twed_grow, uint, S_IRUGO | S_IWUSR);
+
+static unsigned int twed_shrink = 0;
+module_param(twed_shrink, uint, S_IRUGO | S_IWUSR);
+
+void grow_twed(struct kvm_vcpu *vcpu)
+{
+	u64 old = vcpu->arch.twed;
+
+	if (old < HCR_TWEDEL_MAX && twed_grow) {
+		vcpu->arch.twed += 1;
+		vcpu->arch.twed_dirty = true;
+	}
+}
+
+void shrink_twed(struct kvm_vcpu *vcpu)
+{
+	u64 old = vcpu->arch.twed;
+
+	if (old > 0 && twed_shrink) {
+		vcpu->arch.twed -= 1;
+		vcpu->arch.twed_dirty = true;
+	}
+}
 #endif
 
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
@@ -108,6 +134,12 @@ static int kvm_arm_default_max_vcpus(void)
 	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 }
 
+void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+	if (use_twed())
+		shrink_twed(vcpu);
+}
+
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 5d690d60ccad..2ad72defa3c9 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -91,6 +91,8 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
+		if (use_twed())
+			grow_twed(vcpu);
 		vcpu->stat.wfe_exit_stat++;
 		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
 	} else {
-- 
2.19.1

