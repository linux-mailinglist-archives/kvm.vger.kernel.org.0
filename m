Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511023F0C9B
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 22:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhHRUWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 16:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbhHRUWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 16:22:12 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FB6C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 13:21:37 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id gw9-20020a0562140f0900b0035decb1dfecso3026944qvb.5
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 13:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RsQw2+A6Y7v0C6V3YM0HBQbdtVAQ2NdDTbPPjc85eBM=;
        b=TUbYJCoU5mNFScZR1T6MWKR0qv9dR3+Cv2+4X3Nd2cRi6UXDkt3rmAzI5bXsjMFaJL
         m5vg09zXuY0c78nd4U+tpJCriXknDWGd4FvJS8NFNr98PaxCHdv+1kTEoNMslSqHD1QX
         JhwYhXysgKmydSBaQyFEC7qT3ySd7zOu4z5eOPGPqaS7VhNC0tkragx/ABg5fiKeCi80
         sQcXm5docwNzGfUGGprbBLbDQyodr0we9559CqUJzDqklmyPaN+L8UlJwUdvrPottnyX
         BmCka7tnuCU5RBTeksUAa+Nfz3dAQ+GP+JsWK9IL0FEkkIWK1TutAIlsADq48osIleFW
         ND+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RsQw2+A6Y7v0C6V3YM0HBQbdtVAQ2NdDTbPPjc85eBM=;
        b=iYNJmpgPuH3QnkxwsNPXPcwoeE8XRObEEzQGIRFPsMB+/zv08WThmB0vLlDLedUyH9
         94GDMsPntH+UYxvxtLCPsezDdCl/PFo0kvrztEt4pwL90A9nx16oAnyCuavqX14JUiOk
         2D8I44PRZaZBILDLZ+RaOinj8MUpOgjdRE4qBe8yDevurA18Y2lN4iwzR00/YZLxIVVv
         ZLExBBBrH4Jg0pzTSIxjEyxKyELMiEINBfqR/DLiupJLg/moZy8RmUsRnWoCZ7CUxA00
         G8KB/9tFswWrmbhAmThXFMe11JG0T9NkihBfMS/u7g9rlxiecW0pEvpG9L30ZeXR+VnQ
         Ay/Q==
X-Gm-Message-State: AOAM533fn84EfioCrZIQW8zQbk2IEyKjW9sr+B+roE14JF+FWIl/NzHx
        oV2cg9ypsTd9I9t9igHCWpSaz/2IlGTCumz0cG+R0wJZBVjf3YdkH10U67WHRKCyJg+90p6/PUC
        4gVddrjOPjLYWzxbOndb3JOBKOA2LF3VOYKVAuHEyCswYsahXjDNAkKMSjg==
X-Google-Smtp-Source: ABdhPJz4xN3hybVA6/XryTpEYGPYLhn3XqACAJim9UMbamFc5G7dYZ5hZazqjOJDpZO5CPCkmrtHSgv7QNg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0c:be85:: with SMTP id n5mr10684618qvi.59.1629318096780;
 Wed, 18 Aug 2021 13:21:36 -0700 (PDT)
Date:   Wed, 18 Aug 2021 20:21:30 +0000
In-Reply-To: <20210818202133.1106786-1-oupton@google.com>
Message-Id: <20210818202133.1106786-2-oupton@google.com>
Mime-Version: 1.0
References: <20210818202133.1106786-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 1/4] KVM: arm64: Fix read-side race on updates to vcpu
 reset state
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM correctly serializes writes to a vCPU's reset state, however since
we do not take the KVM lock on the read side it is entirely possible to
read state from two different reset requests.

Cure the race for now by taking the KVM lock when reading the
reset_state structure.

Fixes: 358b28f09f0a ("arm/arm64: KVM: Allow a VCPU to fully reset itself")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/reset.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index cba7872d69a8..d862441b03b1 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -210,10 +210,16 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
  */
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_reset_state reset_state;
 	int ret;
 	bool loaded;
 	u32 pstate;
 
+	mutex_lock(&vcpu->kvm->lock);
+	reset_state = vcpu->arch.reset_state;
+	WRITE_ONCE(vcpu->arch.reset_state.reset, false);
+	mutex_unlock(&vcpu->kvm->lock);
+
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
 
@@ -276,8 +282,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	 * Additional reset state handling that PSCI may have imposed on us.
 	 * Must be done after all the sys_reg reset.
 	 */
-	if (vcpu->arch.reset_state.reset) {
-		unsigned long target_pc = vcpu->arch.reset_state.pc;
+	if (reset_state.reset) {
+		unsigned long target_pc = reset_state.pc;
 
 		/* Gracefully handle Thumb2 entry point */
 		if (vcpu_mode_is_32bit(vcpu) && (target_pc & 1)) {
@@ -286,13 +292,11 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		}
 
 		/* Propagate caller endianness */
-		if (vcpu->arch.reset_state.be)
+		if (reset_state.be)
 			kvm_vcpu_set_be(vcpu);
 
 		*vcpu_pc(vcpu) = target_pc;
-		vcpu_set_reg(vcpu, 0, vcpu->arch.reset_state.r0);
-
-		vcpu->arch.reset_state.reset = false;
+		vcpu_set_reg(vcpu, 0, reset_state.r0);
 	}
 
 	/* Reset timer */
-- 
2.33.0.rc1.237.g0d66db33f3-goog

