Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABC84165CC
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 21:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242861AbhIWTRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 15:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242823AbhIWTRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 15:17:51 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B19AC061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:20 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id s8-20020a92cbc8000000b002582a281a7bso3698351ilq.10
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2asC0Rqx18RgPRLiSzHgbr40dKQc4/+1utoD7s7ji4c=;
        b=qmWxJl8N7VPhQwq1iVzn7zIRiLfz55FQdBAPpXmcXjkncp+qy2dX9MWloQCvvPvJ2z
         YFltQyoEZ2XVmE7ByBDa1hXpmU190EeKmxQ01GuRis1+KDUgCJhksdK/AT4Zsgu7uRlo
         61YkmElQFogLLTpS+8vqdwrxCTpI/gjiG/Ws1sg8imVHPNwAFTXsfxN323raR1jtS2/n
         C+7976GUVrs4rJGi+8G/C2drf3/B7JW6x6epW2KCoBr1JmAMeXzisIfVCwdPI1lJbymA
         M1bdRQZOgpd0+6zVtD9ESuWnW/gx7eJ74K55G6T0LgY7pikP7ONSGqjZynj9wVJGZZvv
         Mmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2asC0Rqx18RgPRLiSzHgbr40dKQc4/+1utoD7s7ji4c=;
        b=SiZFL/Du9NuzIeAcPc4Ud+ZB6EWRHAY/tz1sLxR9xJe+Lx9Q68GQPaHnMw23DPQeiV
         kYf2W2MlahPQicEManQt/A/pAKZ9xgnUG/7Q3fOoeaTcoB5GXewqFkF8ayu5vIhrT0yp
         FYUc3+No26oTKCEmaVkTk9q8AvQqLxIWExs0ZcYd6ULa4EeoBLZ1nBG5iMoEnqCKHLNw
         srdJH2W+xafIuuXFiIpPeC/28YZ5DEafyK8w7n+wfE5yXD31A+TOWa6cbeCuFsGd82VJ
         T7VX936Nu82z0jKEkBxTAM3GN2GBx0GOyp1Efwo5yllc4S2ddA49HMOo+RslQsNUJUu9
         Y6Mg==
X-Gm-Message-State: AOAM530boY5XWvOQanYTW6dRhHawKBXFqLJ0Ch1t05jXnqQj6rSlwhye
        1rZn0h5soM6pPn8urg2I+HzA8sZisu0=
X-Google-Smtp-Source: ABdhPJxtuC86c4seq0Yi0ytSDi5No4IEOB4Xjc6doIoIAtU4XvjZFliTDgFtlqolEDhlMd3rYKHr6CIkr9A=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:b0d5:: with SMTP id w21mr5489320jah.45.1632424579479;
 Thu, 23 Sep 2021 12:16:19 -0700 (PDT)
Date:   Thu, 23 Sep 2021 19:16:02 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-4-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 03/11] KVM: arm64: Encapsulate reset request logic in a
 helper function
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In its implementation of the PSCI function, KVM needs to request that a
target vCPU resets before its next entry into the guest. Wrap the logic
for requesting a reset in a function for later use by other implemented
PSCI calls.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 310b9cb2b32b..bb59b692998b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
 	return !(affinity & ~MPIDR_HWID_BITMASK);
 }
 
-static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
+static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
+					unsigned long entry_addr,
+					unsigned long context_id,
+					bool big_endian)
 {
 	struct vcpu_reset_state *reset_state;
+
+	lockdep_assert_held(&vcpu->kvm->lock);
+
+	reset_state = &vcpu->arch.reset_state;
+	reset_state->pc = entry_addr;
+
+	/* Propagate caller endianness */
+	reset_state->be = big_endian;
+
+	/*
+	 * NOTE: We always update r0 (or x0) because for PSCI v0.1
+	 * the general purpose registers are undefined upon CPU_ON.
+	 */
+	reset_state->r0 = context_id;
+
+	WRITE_ONCE(reset_state->reset, true);
+	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
+
+	/*
+	 * Make sure the reset request is observed if the change to
+	 * power_state is observed.
+	 */
+	smp_wmb();
+	vcpu->arch.power_off = false;
+}
+
+static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
+{
 	struct kvm *kvm = source_vcpu->kvm;
 	struct kvm_vcpu *vcpu = NULL;
 	unsigned long cpu_id;
@@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 			return PSCI_RET_INVALID_PARAMS;
 	}
 
-	reset_state = &vcpu->arch.reset_state;
-
-	reset_state->pc = smccc_get_arg2(source_vcpu);
-
-	/* Propagate caller endianness */
-	reset_state->be = kvm_vcpu_is_be(source_vcpu);
-
-	/*
-	 * NOTE: We always update r0 (or x0) because for PSCI v0.1
-	 * the general purpose registers are undefined upon CPU_ON.
-	 */
-	reset_state->r0 = smccc_get_arg3(source_vcpu);
-
-	WRITE_ONCE(reset_state->reset, true);
-	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
-
-	/*
-	 * Make sure the reset request is observed if the change to
-	 * power_state is observed.
-	 */
-	smp_wmb();
-
-	vcpu->arch.power_off = false;
+	kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
+				    smccc_get_arg3(source_vcpu),
+				    kvm_vcpu_is_be(source_vcpu));
 	kvm_vcpu_wake_up(vcpu);
 
 	return PSCI_RET_SUCCESS;
-- 
2.33.0.685.g46640cef36-goog

