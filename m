Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0CD7C782F
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 22:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442834AbjJLUym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 16:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442643AbjJLUyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 16:54:41 -0400
Received: from out-190.mta1.migadu.com (out-190.mta1.migadu.com [IPv6:2001:41d0:203:375::be])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A2B9D
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 13:54:38 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697144077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G3v4AfwsSErK80a0XO6d3BcxY96LblAlYK4wSGGTqtg=;
        b=DVOcey/u6dGF+zMqoJNEwFxqJWaT+R159deGlq/dcbbZOJ/s3gE7i78b7JLaAhyjp80snT
        8POaKn2D940zX70I5tBfUT5mimRPHHJQamBWfHsLhq7VWe1XUcvwKyY3cc1rrPjrZmWh2L
        LXEd5LCifh+9/T382eZ68HyE4cD7yXE=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 3/5] KVM: arm64: Reload stage-2 for VMID change on VHE
Date:   Thu, 12 Oct 2023 20:54:20 +0000
Message-ID: <20231012205422.3924618-4-oliver.upton@linux.dev>
In-Reply-To: <20231012205422.3924618-1-oliver.upton@linux.dev>
References: <20231012205422.3924618-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

Naturally, a change to the VMID for an MMU implies a new value for
VTTBR. Reload on VMID change in anticipation of loading stage-2 on
vcpu_load() instead of every guest entry.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arm.c              |  5 ++++-
 arch/arm64/kvm/vmid.c             | 11 ++++++++---
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index af06ccb7ee34..be0ab101c557 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1025,7 +1025,7 @@ int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
 extern unsigned int __ro_after_init kvm_arm_vmid_bits;
 int __init kvm_arm_vmid_alloc_init(void);
 void __init kvm_arm_vmid_alloc_free(void);
-void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid);
+bool kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid);
 void kvm_arm_vmid_clear_active(void);
 
 static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4866b3f7b4ea..3ab904adbd64 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -950,7 +950,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * making a thread's VMID inactive. So we need to call
 		 * kvm_arm_vmid_update() in non-premptible context.
 		 */
-		kvm_arm_vmid_update(&vcpu->arch.hw_mmu->vmid);
+		if (kvm_arm_vmid_update(&vcpu->arch.hw_mmu->vmid) &&
+		    has_vhe())
+			__load_stage2(vcpu->arch.hw_mmu,
+				      vcpu->arch.hw_mmu->arch);
 
 		kvm_pmu_flush_hwstate(vcpu);
 
diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
index 7fe8ba1a2851..806223b7022a 100644
--- a/arch/arm64/kvm/vmid.c
+++ b/arch/arm64/kvm/vmid.c
@@ -135,10 +135,11 @@ void kvm_arm_vmid_clear_active(void)
 	atomic64_set(this_cpu_ptr(&active_vmids), VMID_ACTIVE_INVALID);
 }
 
-void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
+bool kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
 {
 	unsigned long flags;
 	u64 vmid, old_active_vmid;
+	bool updated = false;
 
 	vmid = atomic64_read(&kvm_vmid->id);
 
@@ -156,17 +157,21 @@ void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
 	if (old_active_vmid != 0 && vmid_gen_match(vmid) &&
 	    0 != atomic64_cmpxchg_relaxed(this_cpu_ptr(&active_vmids),
 					  old_active_vmid, vmid))
-		return;
+		return false;
 
 	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
 
 	/* Check that our VMID belongs to the current generation. */
 	vmid = atomic64_read(&kvm_vmid->id);
-	if (!vmid_gen_match(vmid))
+	if (!vmid_gen_match(vmid)) {
 		vmid = new_vmid(kvm_vmid);
+		updated = true;
+	}
 
 	atomic64_set(this_cpu_ptr(&active_vmids), vmid);
 	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
+
+	return updated;
 }
 
 /*
-- 
2.42.0.655.g421f12c284-goog

