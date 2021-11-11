Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5AC44DCEB
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 22:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhKKVPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 16:15:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233500AbhKKVPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 16:15:07 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F80161078;
        Thu, 11 Nov 2021 21:12:18 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mlHMm-004tjr-DU; Thu, 11 Nov 2021 21:12:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: [PATCH 3/4] KVM: arm64: Change the return type of kvm_vcpu_preferred_target()
Date:   Thu, 11 Nov 2021 21:11:34 +0000
Message-Id: <20211111211135.3991240-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211111211135.3991240-1-maz@kernel.org>
References: <20211111211135.3991240-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, tabba@google.com, james.morse@arm.com, mark.rutland@arm.com, qperret@google.com, rdunlap@infradead.org, suzuki.poulose@arm.com, will@kernel.org, yuehaibing@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

kvm_vcpu_preferred_target() always return 0 because kvm_target_cpu()
never returns a negative error code.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211105011500.16280-1-yuehaibing@huawei.com
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/arm.c              | 5 +----
 arch/arm64/kvm/guest.c            | 7 +------
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d0221fb69a60..f7e36e33406b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -584,7 +584,7 @@ struct kvm_vcpu_stat {
 	u64 exits;
 };
 
-int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
+void kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
 unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 24a1e86d7128..e2dd575e40f8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1397,12 +1397,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		return kvm_vm_ioctl_set_device_addr(kvm, &dev_addr);
 	}
 	case KVM_ARM_PREFERRED_TARGET: {
-		int err;
 		struct kvm_vcpu_init init;
 
-		err = kvm_vcpu_preferred_target(&init);
-		if (err)
-			return err;
+		kvm_vcpu_preferred_target(&init);
 
 		if (copy_to_user(argp, &init, sizeof(init)))
 			return -EFAULT;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5ce26bedf23c..e116c7767730 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -869,13 +869,10 @@ u32 __attribute_const__ kvm_target_cpu(void)
 	return KVM_ARM_TARGET_GENERIC_V8;
 }
 
-int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
+void kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
 {
 	u32 target = kvm_target_cpu();
 
-	if (target < 0)
-		return -ENODEV;
-
 	memset(init, 0, sizeof(*init));
 
 	/*
@@ -885,8 +882,6 @@ int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
 	 * target type.
 	 */
 	init->target = (__u32)target;
-
-	return 0;
 }
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
-- 
2.30.2

