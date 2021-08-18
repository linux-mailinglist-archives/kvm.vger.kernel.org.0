Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCB93EFF93
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 10:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhHRIvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 04:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhHRIve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 04:51:34 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0775EC06179A
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 01:51:00 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id c16-20020a92cf500000b02902243aec7e27so820974ilr.22
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 01:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RzZprkEWFZ008a+bVSl7uQhCMtaydrmCD3SE9hzh+pU=;
        b=IvF/U5wPABq15FuyOcb0sbg1Hh2z0d5YLQIesZb8QDgekFfl6QTp2Rw/afAlIX9Z+6
         thKo2xaK2mWb7n4J3JAa8yCvMozOoixoWC10FyCSeSR5LZ/dAj5tgusvmZcQ8taRGUQN
         jW/AznJkcihfMUs4yd68+7ypyAySESNYd1iEKFtTkDGi/kGN3tgMdLY5GJR9LRsSYPcw
         rNu2gwHGzkdQhZShUhXfG5Q1mTHuOdOhCVD1yAId/kCmfqgVmapSPIORlrl8WCT5QbLD
         ZDAF2GEcPTEgRF4srRbekJZGaOFdr4Z+e9oqNsmtNHiV/ckI0JbEAlYEN5+RP0YcqAo4
         jWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RzZprkEWFZ008a+bVSl7uQhCMtaydrmCD3SE9hzh+pU=;
        b=CpwS700rP+knUE1XoAERK6hEoIri52oRrkFffxyDkUyRRrXfv48Bx4dYobZPgjWHdx
         gYm0L52T3W8A/XU3YLOiSAX04Ig9rFSopNU+6xVNOb1ZNVojdgWN6IHkvpttwoTcAcO+
         /z8CmDXpkMy23MtoPgz6Lu36ChhYfhavvl2MOUXOIGwUj4ULlqkpm3PckK48sn8+2+OA
         r85EvdmaphbA/inT7mYgDwrpWTft8V6W9TIgygEdjMswD2XTllLmB3UZQvlzP7CNcyiR
         tMuFO1/14NYsrvMrh4WIfUNK+TQlETq071C5QiPXWzlXuzOA/RA1Zqi4rX9I6YWTU673
         3ZbA==
X-Gm-Message-State: AOAM531LE4QPLk0VUmewLVolsaCmEV2b4PHe5UecdNFfi+zKzjps3WKV
        qXnorOo7r20xXux7lfzl1vz/rDQZvWnKT8PLTIb5KFuANkur1DpcAEP0I5VE0C6IpFz/Mx447gU
        Y0l3Xu8sOnaNUcJ804lh6ZqyCNBF+fLkVb9S0sIoEHvIODaWT+n2Sszai7Q==
X-Google-Smtp-Source: ABdhPJx15vycUuHJYydv3hMTk18jP78ZvSV61NkZ7tsJQUfLnkQHgNR6oAiadaFWKzz+sQBwMvhGLwMTc0U=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:e712:: with SMTP id b18mr6273736ioh.186.1629276659300;
 Wed, 18 Aug 2021 01:50:59 -0700 (PDT)
Date:   Wed, 18 Aug 2021 08:50:46 +0000
In-Reply-To: <20210818085047.1005285-1-oupton@google.com>
Message-Id: <20210818085047.1005285-4-oupton@google.com>
Mime-Version: 1.0
References: <20210818085047.1005285-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 3/4] KVM: arm64: Enforce reserved bits for PSCI target affinities
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some calls in PSCI take a target affinity argument, defined to be
bit-compatible with the affinity fields in MPIDR_EL1. All other bits in
the parameter are reserved and must be 0. Return INVALID_PARAMETERS if
the guest incorrectly sets a reserved bit.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index db4056ecccfd..bb76be01abd2 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -59,6 +59,17 @@ static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
 	kvm_vcpu_kick(vcpu);
 }
 
+static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
+					   unsigned long affinity)
+{
+	unsigned long mask = MPIDR_HWID_BITMASK;
+
+	if (vcpu_mode_is_32bit(vcpu))
+		mask &= ~((u32) 0);
+
+	return !(affinity & ~mask);
+}
+
 static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 {
 	struct vcpu_reset_state *reset_state;
@@ -66,9 +77,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	struct kvm_vcpu *vcpu = NULL;
 	unsigned long cpu_id;
 
-	cpu_id = smccc_get_arg1(source_vcpu) & MPIDR_HWID_BITMASK;
-	if (vcpu_mode_is_32bit(source_vcpu))
-		cpu_id &= ~((u32) 0);
+	cpu_id = smccc_get_arg1(source_vcpu);
+	if (!kvm_psci_valid_affinity(source_vcpu, cpu_id))
+		return PSCI_RET_INVALID_PARAMS;
 
 	vcpu = kvm_mpidr_to_vcpu(kvm, cpu_id);
 
@@ -126,6 +137,9 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
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

