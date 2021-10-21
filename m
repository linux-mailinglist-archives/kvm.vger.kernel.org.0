Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB57436545
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhJUPNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231659AbhJUPNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 11:13:48 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90ADE60F9F;
        Thu, 21 Oct 2021 15:11:32 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mdZj8-000jKD-Pq; Thu, 21 Oct 2021 16:11:30 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, broonie@kernel.org,
        kernel-team@android.com
Subject: [PATCH 2/4] KVM: arm64: Introduce flag shadowing TIF_FOREIGN_FPSTATE
Date:   Thu, 21 Oct 2021 16:11:22 +0100
Message-Id: <20211021151124.3098113-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211021151124.3098113-1-maz@kernel.org>
References: <20211021151124.3098113-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We currently have to maintain a mapping the thread_info structure
at EL2 in order to be able to check the TIF_FOREIGN_FPSTATE flag.

In order to eventually get rid of this, start with a vcpu flag that
shadows the thread flag on each entry into the hypervisor.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       | 2 ++
 arch/arm64/kvm/arm.c                    | 1 +
 arch/arm64/kvm/fpsimd.c                 | 8 ++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f856ab63f092..5a05ff062458 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -442,6 +442,7 @@ struct kvm_vcpu_arch {
 
 #define KVM_ARM64_DEBUG_STATE_SAVE_SPE	(1 << 12) /* Save SPE context if active  */
 #define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
+#define KVM_ARM64_FP_FOREIGN_FPSTATE	(1 << 14)
 
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
@@ -737,6 +738,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 24a1e86d7128..c610971c7e72 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -850,6 +850,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		}
 
 		kvm_arm_setup_debug(vcpu);
+		kvm_arch_vcpu_ctxflush_fp(vcpu);
 
 		/**************************************************************
 		 * Enter the guest
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 5621020b28de..12186c7d8cd8 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -86,6 +86,14 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
 }
 
+void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
+{
+	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
+		vcpu->arch.flags |= KVM_ARM64_FP_FOREIGN_FPSTATE;
+	else
+		vcpu->arch.flags &= ~KVM_ARM64_FP_FOREIGN_FPSTATE;
+}
+
 /*
  * If the guest FPSIMD state was loaded, update the host's context
  * tracking data mark the CPU FPSIMD regs as dirty and belonging to vcpu
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index c6e98c7e918b..dbd721a450d3 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -45,7 +45,7 @@ static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 	 * trap the accesses.
 	 */
 	if (!system_supports_fpsimd() ||
-	    vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE)
+	    vcpu->arch.flags & KVM_ARM64_FP_FOREIGN_FPSTATE)
 		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
 				      KVM_ARM64_FP_HOST);
 
-- 
2.30.2

