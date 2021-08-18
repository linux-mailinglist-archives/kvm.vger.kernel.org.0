Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA963F0C9C
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 22:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhHRUWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 16:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbhHRUWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 16:22:14 -0400
Received: from mail-oi1-x249.google.com (mail-oi1-x249.google.com [IPv6:2607:f8b0:4864:20::249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89782C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 13:21:39 -0700 (PDT)
Received: by mail-oi1-x249.google.com with SMTP id w16-20020a0568081410b029025c350a89fdso1532818oiv.11
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 13:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hGb/ueygkMqaGjl0KMNjqvYzUKfaiFfnTNnmRtH2qjE=;
        b=LMeoFdjwl26WEwUvEYAKf71IpNGuy6iROwQXK5jLYTWCnMpoiWtHFZSjponxOa6Jw7
         pdxO8BC3LMXSQzkbUTfwccwO0/+FgxPcG39ivpgk/pj1qpS5fIO7wjCGve6hHpYVTny0
         1FNpIMRXx670vuJqd0l8WttCjI3rYAJQkmLNNvxUfB+bp3WFH3TvZjzlr+4dPD+rqNvQ
         Vny4af7srvH9a0H85EYncnqO32HOBqRrtbO4TUv4p+j8osuOEcfDsrfuJZM1sae1KUr4
         6bJm0fySxvg8Oz2KY+PYPDCaoLObDg1WyHigH7e0RB034hG3CUv4UOIck2WDYRaaLHTx
         ecxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hGb/ueygkMqaGjl0KMNjqvYzUKfaiFfnTNnmRtH2qjE=;
        b=Icof2eW8T5eDeXhdtmHmyedcpYG9uVhXvYJESqPjj5/UzP7kEc7fiewijuWzvfJ4NT
         jhx8r/I+U4Psc1XSQOsYaq3Mp0Wa6P9jdWjkAc4pjELRl+K7o/72trje4zLixcdPTTGP
         Yuf1vQFypERIV8/7h6d7xCPB/w3VMEb/LhHYicU3t43bpxeNM1Ntx5rKcDIPmRB3otQT
         W9Z4adNsHlCEp2RIBBtVq5EenUek9QwP91o9z/bLme8qrNN86ESy6okAa6cAj20SyJeF
         sBzpVL8RL+FBVUgRH+yEGLtzYD5/7C2H91oSmiV5tmEEUNFI98KOHrYXjgiiRL5p9/rL
         sAeQ==
X-Gm-Message-State: AOAM530rbE/q7IYuwzVYZ6GPyMs+eJ99lTECuksziAliLte0IbzNNQjv
        Djbu4wzx09z7iTneBeyeHX6xsbIB1A9GAbR4qpydQ3qEw19KwHGOTw3HyhnMfvXP2W2ieQluCP0
        RhzmMSHvxJyWIIQbZ9eH5jT6JqodEB8MYm0ZtTxuMFeahFqTCH/vW6dysDQ==
X-Google-Smtp-Source: ABdhPJxONHASSnzgn61nsjiHmFL+Yo64sPq7kL1PbwlMuzfrSrfWcFwbsKgj4L0YFIAJ0trU0iitWSJV4pU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:aca:de54:: with SMTP id v81mr65294oig.40.1629318098693;
 Wed, 18 Aug 2021 13:21:38 -0700 (PDT)
Date:   Wed, 18 Aug 2021 20:21:32 +0000
In-Reply-To: <20210818202133.1106786-1-oupton@google.com>
Message-Id: <20210818202133.1106786-4-oupton@google.com>
Mime-Version: 1.0
References: <20210818202133.1106786-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 3/4] KVM: arm64: Enforce reserved bits for PSCI target affinities
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

According to the PSCI specification, ARM DEN 0022D, 5.1.4 "CPU_ON", the
CPU_ON function takes a target_cpu argument that is bit-compatible with
the affinity fields in MPIDR_EL1. All other bits in the argument are
RES0. Note that the same constraints apply to the target_affinity
argument for the AFFINITY_INFO call.

Enforce the spec by returning INVALID_PARAMS if a guest incorrectly sets
a RES0 bit.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index db4056ecccfd..74c47d420253 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -59,6 +59,12 @@ static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
 	kvm_vcpu_kick(vcpu);
 }
 
+static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
+					   unsigned long affinity)
+{
+	return !(affinity & ~MPIDR_HWID_BITMASK);
+}
+
 static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 {
 	struct vcpu_reset_state *reset_state;
@@ -66,9 +72,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	struct kvm_vcpu *vcpu = NULL;
 	unsigned long cpu_id;
 
-	cpu_id = smccc_get_arg1(source_vcpu) & MPIDR_HWID_BITMASK;
-	if (vcpu_mode_is_32bit(source_vcpu))
-		cpu_id &= ~((u32) 0);
+	cpu_id = smccc_get_arg1(source_vcpu);
+	if (!kvm_psci_valid_affinity(source_vcpu, cpu_id))
+		return PSCI_RET_INVALID_PARAMS;
 
 	vcpu = kvm_mpidr_to_vcpu(kvm, cpu_id);
 
@@ -126,6 +132,9 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 	target_affinity = smccc_get_arg1(vcpu);
 	lowest_affinity_level = smccc_get_arg2(vcpu);
 
+	if (!kvm_psci_valid_affinity(vcpu, target_affinity))
+		return PSCI_RET_INVALID_PARAMS;
+
 	/* Determine target affinity mask */
 	target_affinity_mask = psci_affinity_mask(lowest_affinity_level);
 	if (!target_affinity_mask)
-- 
2.33.0.rc1.237.g0d66db33f3-goog

