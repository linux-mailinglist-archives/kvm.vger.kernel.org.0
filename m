Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F44588C94
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiHCNBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiHCNBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:01:47 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C524DB8C;
        Wed,  3 Aug 2022 06:01:44 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 13so597084pgc.8;
        Wed, 03 Aug 2022 06:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U/sZgVfzX4POYhlxOsTuA0LPr+8HMxvmYXlH0o3YoUE=;
        b=qoiK89xyuHlqVm3orh4O+7OWn58FOg5dYSTTkfwcLZX1E0ik3uNbTg1oJ7KLgFtE8B
         DojwHscPtbW3J0uc7fkoWXDwQSEziQbwvNrLlg8LMvx/UAcQz9QRofqmmgsW6+Ch/3KQ
         IEmdLiD7AzGQVs4sIWb9XZJJhjsnQsOZIE+REcjJyU+IgY+zUFsRKUq7d0T9UlD8PMgB
         wM+VM2lobiC/XzucCmPTFfTUn0jjPOzdQZuNc5uAGmFHNtwQK4kLFSY2t3iZzDnNtyRl
         QF/a1K5ItJvzZVrHKMvGM8vi0Ahb9uu93YOefUqiZPqlc6PN0vMjxz+hkOmFe+NVaK6b
         WI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U/sZgVfzX4POYhlxOsTuA0LPr+8HMxvmYXlH0o3YoUE=;
        b=k12Ucp3xiPK1WoXOWU3U+BlPZxHfyKadTheYHBkAGPetHJqAOCd9HMSKlKmDBvN67j
         P/U6IXFRYcbLFENr06081sCR/giTJRP2Bi3hESKgKTgrAnwtgB2JAoPfxnMhAFXmPhxT
         naUH6FugG/CEht/vfbZhJpJmF3EXzRJTQzhd0TItc3L+AKkewpl3Kq3DlIAi4lBmedfi
         mIuNU4yJHmgiz7Pq44f43m9hRPShKgo7jPRWXOeVlVfu+bIX7dbtOXK2rnGrzk1mdvD6
         bJhKG+TtzWgRCp7V6Y6dfENP1dX3nWguW6OJQXvB3ux4+zkLYQKhtM4ghVkyG4mcmhmd
         3f2A==
X-Gm-Message-State: ACgBeo0uua5hiekIBCq7gX3KZeVvmoyQ7B0Bw7M617BCuezKje3KBqfL
        sxYzl0HbwA44cCMxxKSKGUFVphJm9psT4Q==
X-Google-Smtp-Source: AA6agR5MQ3+8xknkh8zg6JGjb63NY1F/qZugc3HDmF6I6Ty3Vi0LykC3EUz44gyanOD/URjEUaneXQ==
X-Received: by 2002:a63:214:0:b0:41c:b4fc:f3a6 with SMTP id 20-20020a630214000000b0041cb4fcf3a6mr845669pgc.132.1659531703921;
        Wed, 03 Aug 2022 06:01:43 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id k3-20020a170902c40300b0016f1ef2cd44sm198058plk.154.2022.08.03.06.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 06:01:43 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: x86/svm/pmu: Direct access pmu->gp_counter[] to implement amd_*_to_pmc()
Date:   Wed,  3 Aug 2022 21:01:23 +0800
Message-Id: <20220803130124.72340-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

AMD only has gp counters, whose corresponding vPMCs are initialised
and stored in pmu->gp_counter[] in order of idx, so we can access this
array directly based on any valid pmc->idx, without any help from other
interfaces at all. The amd_rdpmc_ecx_to_pmc() can now reuse this part
of the code quite naturally.

Opportunistically apply array_index_nospec() to reduce the attack
surface for speculative execution and remove the dead code.

Signed-off-by: Like Xu <likexu@tencent.com>
---
v1: https://lore.kernel.org/kvm/20220510115718.93335-2-likexu@tencent.com/
v1 -> v2 Changelog:
- Remove unused helper get_msr_base();

 arch/x86/kvm/svm/pmu.c | 41 +++++------------------------------------
 1 file changed, 5 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index f24613a108c5..d1c3b766841e 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -33,23 +33,6 @@ enum index {
 	INDEX_ERROR,
 };
 
-static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
-{
-	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
-
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
-		if (type == PMU_TYPE_COUNTER)
-			return MSR_F15H_PERF_CTR;
-		else
-			return MSR_F15H_PERF_CTL;
-	} else {
-		if (type == PMU_TYPE_COUNTER)
-			return MSR_K7_PERFCTR0;
-		else
-			return MSR_K7_EVNTSEL0;
-	}
-}
-
 static enum index msr_to_index(u32 msr)
 {
 	switch (msr) {
@@ -141,18 +124,12 @@ static bool amd_pmc_is_enabled(struct kvm_pmc *pmc)
 
 static struct kvm_pmc *amd_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 {
-	unsigned int base = get_msr_base(pmu, PMU_TYPE_COUNTER);
-	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
+	unsigned int num_counters = pmu->nr_arch_gp_counters;
 
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
-		/*
-		 * The idx is contiguous. The MSRs are not. The counter MSRs
-		 * are interleaved with the event select MSRs.
-		 */
-		pmc_idx *= 2;
-	}
+	if (pmc_idx >= num_counters)
+		return NULL;
 
-	return get_gp_pmc_amd(pmu, base + pmc_idx, PMU_TYPE_COUNTER);
+	return &pmu->gp_counters[array_index_nospec(pmc_idx, num_counters)];
 }
 
 static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
@@ -168,15 +145,7 @@ static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	unsigned int idx, u64 *mask)
 {
-	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *counters;
-
-	idx &= ~(3u << 30);
-	if (idx >= pmu->nr_arch_gp_counters)
-		return NULL;
-	counters = pmu->gp_counters;
-
-	return &counters[idx];
+	return amd_pmc_idx_to_pmc(vcpu_to_pmu(vcpu), idx & ~(3u << 30));
 }
 
 static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
-- 
2.37.1

