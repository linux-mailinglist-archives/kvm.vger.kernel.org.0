Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7B14623A3
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 22:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhK2Vto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 16:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbhK2Vrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 16:47:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDC1C08EB3D
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:06:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 874D1B815E0
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479A0C53FD0;
        Mon, 29 Nov 2021 20:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216398;
        bh=RUzBdFFRKwomJbEXUVng8IsQUXhzc/leqrUw6Lmm0PE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHkGPDG649+5QGiYEEA7f2YHI1eidd1UWQLt3GVjRoA3Iv7tDw2cATK07JzyvrQP/
         lZhcGxS2J0xFcJU4fODGwrDET2kZOTl/QLVkH7AUR/j3zSp6ExEYIARdUaeTbd6SFW
         ZUYzvX956lNA7rgwsl5dQ1qgORB7/w31/kN07xVROe7A8QVUV8zJVumv9O/sfF1D9e
         qAaEvt8f50mSr2BD3N+OjPg+reVv+KvoWY+TW0igUOgeePh9yxtGv7opG3WmplXrvl
         p181BrHWx4Q6oYeM8vAXu3STP8Yx7zC39MdvJmcW7bYdr7jIp9c6TDZVQSlM5xSTNU
         Ise2JMsFWvQkQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmrI-008gvR-Bq; Mon, 29 Nov 2021 20:02:40 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 66/69] KVM: arm64: nv: Allocate VNCR page when required
Date:   Mon, 29 Nov 2021 20:01:47 +0000
Message-Id: <20211129200150.351436-67-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If running a NV guest on an ARMv8.4-NV capable system, let's
allocate an additional page that will be used by the hypervisor
to fulfill system register accesses.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++-
 arch/arm64/kvm/nested.c           | 10 ++++++++++
 arch/arm64/kvm/reset.c            |  1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c21551551ddf..595516450637 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -575,7 +575,8 @@ struct kvm_vcpu_arch {
  */
 static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
 {
-	if (unlikely(r >= __VNCR_START__ && ctxt->vncr_array))
+	if (unlikely(cpus_have_final_cap(ARM64_HAS_ENHANCED_NESTED_VIRT) &&
+		     r >= __VNCR_START__ && ctxt->vncr_array))
 		return &ctxt->vncr_array[r - __VNCR_START__];
 
 	return (u64 *)&ctxt->sys_regs[r];
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index e11bdee15df2..7c9dd1edf011 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -47,6 +47,14 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
 		return -EINVAL;
 
+	if (cpus_have_final_cap(ARM64_HAS_ENHANCED_NESTED_VIRT)) {
+		if (!vcpu->arch.ctxt.vncr_array)
+			vcpu->arch.ctxt.vncr_array = (u64 *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+
+		if (!vcpu->arch.ctxt.vncr_array)
+			return -ENOMEM;
+	}
+
 	mutex_lock(&kvm->lock);
 
 	/*
@@ -76,6 +84,8 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 		    kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2])) {
 			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
 			kvm_free_stage2_pgd(&tmp[num_mmus - 2]);
+			free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
+			vcpu->arch.ctxt.vncr_array = NULL;
 		} else {
 			kvm->arch.nested_mmus_size = num_mmus;
 			ret = 0;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 38a7182819fb..9f580241b0bd 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -146,6 +146,7 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	kfree(vcpu->arch.sve_state);
+	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
 }
 
 static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
-- 
2.30.2

