Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A673DFD74
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbhHDI7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236862AbhHDI7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:59:02 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76DFC06179A
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:58:49 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id d6-20020a056e020506b0290208fe58bd16so643546ils.0
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pHbBznoto/w1DGPJijTV3nfkHaGebmmnj5HwOTBirkc=;
        b=dn/0nPYXirFwFfUZ2GEAi/qhuxAMc3UdhDO5zmOyzs4xgPPu1Issk8EocASn5/fyv4
         MQAn8vRHgozFqMtyCgZVR6SDS4qKCek2Jf+x2jEEDw5+sz044Vt95ZHgm1fwiYxlm8YX
         ukQuG2II6iGVwSqrZYFdafAwQC+k5t3CTrkXoJIYdnhEJg5alr2F+tA9OPsKKVDSVi3Y
         BHefOjNKnYGVSyVxjK2UOSfnx1q9BUaOobpoFWPlmrKVCt998wzyV0/IZhMWS0ApXxWH
         /hZirW/KtZLzZIrUTN+53iSMqDwzzqQ+cCjWotK5YAmKlkmNPQffOWK+hwL4ocJOa0/s
         a85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pHbBznoto/w1DGPJijTV3nfkHaGebmmnj5HwOTBirkc=;
        b=WY6dV4xCtXzhIAExPvGjqYAlNxu8POBmYc3LV/2iNKZmFhlsbo87HG9GFPydw/lK8G
         XxrwxSSpBah5ZM3zGhvzDm8wSeHuQIRSPn0u+6uh2+Lc0Shro2mvi3mQI0VEruLunlRc
         JkI/mf7ktnOlj2iH6A6yZJFDBDXBzq5pyFAVG2a0trKvT4Ad4wPPCATh9E8X+01/qwzU
         Wy7WX2WUAgxxJ3A/GhhaBLCn/q8jkD/cELudm/i+ZubYgQ5L6V3MWYaS4nQCuvBOuEnA
         DpgjETiwGKpcOjNAcHCX5xZZYVUN4Z5l8Eg8LfVPUKsp55ySTLKxY9083fh01CPG7BdG
         u2cg==
X-Gm-Message-State: AOAM53364DLGPxzZpO03zxz8jMT3uKiw4pyMcsQp2v6F77eBOGb4lxkY
        9wSyodCTJQKAGwe3xPOYu/WZB53NQkJs820fZdm/3kMza2tkN+IZK8sgSGMXVEOaFunfir1nuXh
        3J+lkIbIdLHuOHp1sjAWW3n9daS5QRENlnaPEic196Nlvq/+oRas2rLNojg==
X-Google-Smtp-Source: ABdhPJx430Og/gl8Ea4doYmCM5gKCd5oDpwqPEalh4SowVARGCh1NYO/9OTpOR3+C6ZHxiOd8eCjQClzb+4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:54c:: with SMTP id
 i12mr111057ils.103.1628067529077; Wed, 04 Aug 2021 01:58:49 -0700 (PDT)
Date:   Wed,  4 Aug 2021 08:58:11 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-14-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 13/21] KVM: arm64: Allow userspace to configure a vCPU's
 virtual offset
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow userspace to access the guest's virtual counter-timer offset
through the ONE_REG interface. The value read or written is defined to
be an offset from the guest's physical counter-timer. Add some
documentation to clarify how a VMM should use this and the existing
CNTVCT_EL0.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst    | 10 ++++++++++
 arch/arm64/include/uapi/asm/kvm.h |  1 +
 arch/arm64/kvm/arch_timer.c       | 11 +++++++++++
 arch/arm64/kvm/guest.c            |  6 +++++-
 include/kvm/arm_arch_timer.h      |  1 +
 5 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8d4a3471ad9e..28a65dc89985 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2487,6 +2487,16 @@ arm64 system registers have the following id bit patterns::
      derived from the register encoding for CNTV_CVAL_EL0.  As this is
      API, it must remain this way.
 
+.. warning::
+
+     The value of KVM_REG_ARM_TIMER_OFFSET is defined as an offset from
+     the guest's view of the physical counter-timer.
+
+     Userspace should use either KVM_REG_ARM_TIMER_OFFSET or
+     KVM_REG_ARM_TIMER_CVAL to pause and resume a guest's virtual
+     counter-timer. Mixed use of these registers could result in an
+     unpredictable guest counter value.
+
 arm64 firmware pseudo-registers have the following bit pattern::
 
   0x6030 0000 0014 <regno:16>
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b3edde68bc3e..949a31bc10f0 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -255,6 +255,7 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_TIMER_CTL		ARM64_SYS_REG(3, 3, 14, 3, 1)
 #define KVM_REG_ARM_TIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 0, 2)
 #define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
+#define KVM_REG_ARM_TIMER_OFFSET	ARM64_SYS_REG(3, 4, 14, 0, 3)
 
 /* KVM-as-firmware specific pseudo-registers */
 #define KVM_REG_ARM_FW			(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 4c2b763a8849..a8815b09da3e 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -868,6 +868,10 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 		timer = vcpu_vtimer(vcpu);
 		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CVAL, value);
 		break;
+	case KVM_REG_ARM_TIMER_OFFSET:
+		timer = vcpu_vtimer(vcpu);
+		update_vtimer_cntvoff(vcpu, value);
+		break;
 	case KVM_REG_ARM_PTIMER_CTL:
 		timer = vcpu_ptimer(vcpu);
 		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
@@ -912,6 +916,9 @@ u64 kvm_arm_timer_get_reg(struct kvm_vcpu *vcpu, u64 regid)
 	case KVM_REG_ARM_TIMER_CVAL:
 		return kvm_arm_timer_read(vcpu,
 					  vcpu_vtimer(vcpu), TIMER_REG_CVAL);
+	case KVM_REG_ARM_TIMER_OFFSET:
+		return kvm_arm_timer_read(vcpu,
+					  vcpu_vtimer(vcpu), TIMER_REG_OFFSET);
 	case KVM_REG_ARM_PTIMER_CTL:
 		return kvm_arm_timer_read(vcpu,
 					  vcpu_ptimer(vcpu), TIMER_REG_CTL);
@@ -949,6 +956,10 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 		val = kvm_phys_timer_read() - timer_get_offset(timer);
 		break;
 
+	case TIMER_REG_OFFSET:
+		val = timer_get_offset(timer);
+		break;
+
 	default:
 		BUG();
 	}
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1dfb83578277..17fc06e2b422 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -591,7 +591,7 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
  * ARM64 versions of the TIMER registers, always available on arm64
  */
 
-#define NUM_TIMER_REGS 3
+#define NUM_TIMER_REGS 4
 
 static bool is_timer_reg(u64 index)
 {
@@ -599,6 +599,7 @@ static bool is_timer_reg(u64 index)
 	case KVM_REG_ARM_TIMER_CTL:
 	case KVM_REG_ARM_TIMER_CNT:
 	case KVM_REG_ARM_TIMER_CVAL:
+	case KVM_REG_ARM_TIMER_OFFSET:
 		return true;
 	}
 	return false;
@@ -614,6 +615,9 @@ static int copy_timer_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	uindices++;
 	if (put_user(KVM_REG_ARM_TIMER_CVAL, uindices))
 		return -EFAULT;
+	uindices++;
+	if (put_user(KVM_REG_ARM_TIMER_OFFSET, uindices))
+		return -EFAULT;
 
 	return 0;
 }
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 9d65d4a29f81..615f9314f6a5 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -21,6 +21,7 @@ enum kvm_arch_timer_regs {
 	TIMER_REG_CVAL,
 	TIMER_REG_TVAL,
 	TIMER_REG_CTL,
+	TIMER_REG_OFFSET,
 };
 
 struct arch_timer_context {
-- 
2.32.0.605.g8dce9f2422-goog

