Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEEAA6B3CE5
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 11:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjCJKyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 05:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjCJKyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 05:54:24 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8472BF9D1E;
        Fri, 10 Mar 2023 02:54:12 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u5so5121386plq.7;
        Fri, 10 Mar 2023 02:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678445652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EEzHwUubKyQzeZbhTkJFVtBrjdYEyf0DVFK0mJ5dj7w=;
        b=ZINmPDTbFKRM1dxUq4Ry/OA60Wf5Ez33YnIH8+a8ArGwTFftO749yxbrc3SxvcX215
         617Zb1CSbBf/DaxX/dX4I5xNhCLpX+TAce3UEWwFtWBqNnGCff7y9T4F3ek0qGd2r9qU
         0KjR5xIH2I1JamwKSwruFwW0QlLzqMk/fuw3U7mPnO3TkdRep6QbupQoiIIAcqMRZecw
         9olmNgMnVMB+9Ig8nrj6PF1y7X7UUwrK60JrtIrX+CB7sgmMfq9KP5on5yMvqH5cMbUW
         W5cJjlWzb7ydh7QOXYealgU1nahtelAy0e+BQSTb0kg5Rti6nTg1sCt6Pk+GFdn000tS
         0tSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678445652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EEzHwUubKyQzeZbhTkJFVtBrjdYEyf0DVFK0mJ5dj7w=;
        b=JLNnnj4jWjzwq36Zij8Ci8wJQtUdNGImLX36GkoZH1Ak8y5jw6dL95vbyH81xuxBs/
         K2g1kHoGcTwfSWTG947uA60q0m1AJzaQG3CFQgtm5qidRo2Bo7Si0fUqwFIILkZjWJhE
         hj6qk+12Z40+8/v+uptxTJLSIznXKqx1PpjZYu3nV+otnFw6+sIhTIGbolMK/P/AAAcR
         8hWDBmNA1zTmHWBwCyWZqJvO18UdeY806I2OJ1CdUybCF6+T7xTRXVNCbGxl3qltoMdg
         jvuynDT06lZ5c/2mXkwf9WJWkyBZRlBwa9Uzq1xtW/ka1kRFGnU5PtqsBKd9II+VF3iz
         ru0w==
X-Gm-Message-State: AO0yUKU6Qzizdj5kmPU63AQX0U4WtEnkaqjZdI1nLvBkMMQcH14TaaJ3
        CxsZdP2qDyvieIC9LaK2Ia0=
X-Google-Smtp-Source: AK7set/S2QZaAGp2rQGblYsw8dLFhL3vafq7KCiEce8tvLDYN48jQAiSrwbC6o2wRs3OfWKCQEXeOQ==
X-Received: by 2002:a17:902:e741:b0:19e:7bd2:a224 with SMTP id p1-20020a170902e74100b0019e7bd2a224mr31449817plf.62.1678445651796;
        Fri, 10 Mar 2023 02:54:11 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ks3-20020a170903084300b0019cbabf127dsm1174167plb.182.2023.03.10.02.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 02:54:11 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] KVM: x86/pmu: Reorder functions to reduce unnecessary declarations
Date:   Fri, 10 Mar 2023 18:53:45 +0800
Message-Id: <20230310105346.12302-5-likexu@tencent.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310105346.12302-1-likexu@tencent.com>
References: <20230310105346.12302-1-likexu@tencent.com>
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

Considering that more emulations are deferred to kvm_pmu_handle_event(),
moving it to the end of pmu.c makes it easier to call previous functions,
instead of just piling up the function declarations to make compiler green.
The same motivation is applied to kvm_pmu_request_counter_reprogram(),
as it is the trigger for any emulations delay.

No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 52 +++++++++++++++++++++++-----------------------
 arch/x86/kvm/pmu.h | 12 +++++------
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 81c7cc4ceadf..2a0504732966 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -467,32 +467,6 @@ static inline void kvm_pmu_handle_pmc_overflow(struct kvm_pmc *pmc)
 	pmc->prev_counter = 0;
 }
 
-void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
-{
-	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	int bit;
-
-	for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
-		struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, bit);
-
-		if (unlikely(!pmc)) {
-			clear_bit(bit, pmu->reprogram_pmi);
-			continue;
-		}
-
-		reprogram_counter(pmc);
-		kvm_pmu_handle_pmc_overflow(pmc);
-	}
-
-	/*
-	 * Unused perf_events are only released if the corresponding MSRs
-	 * weren't accessed during the last vCPU time slice. kvm_arch_sched_in
-	 * triggers KVM_REQ_PMU if cleanup is needed.
-	 */
-	if (unlikely(pmu->need_cleanup))
-		kvm_pmu_cleanup(vcpu);
-}
-
 /* check if idx is a valid index to access PMU */
 bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
@@ -847,3 +821,29 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	kfree(filter);
 	return r;
 }
+
+void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	int bit;
+
+	for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
+		struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, bit);
+
+		if (unlikely(!pmc)) {
+			clear_bit(bit, pmu->reprogram_pmi);
+			continue;
+		}
+
+		reprogram_counter(pmc);
+		kvm_pmu_handle_pmc_overflow(pmc);
+	}
+
+	/*
+	 * Unused perf_events are only released if the corresponding MSRs
+	 * weren't accessed during the last vCPU time slice. kvm_arch_sched_in
+	 * triggers KVM_REQ_PMU if cleanup is needed.
+	 */
+	if (unlikely(pmu->need_cleanup))
+		kvm_pmu_cleanup(vcpu);
+}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index db4262fe8814..a47b579667c6 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -48,6 +48,12 @@ static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
 	return pmu->counter_bitmask[pmc->type];
 }
 
+static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
+{
+	set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
+	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
+}
+
 static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 {
 	u64 counter, enabled, running;
@@ -183,12 +189,6 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 					     KVM_PMC_MAX_FIXED);
 }
 
-static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
-{
-	set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
-	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
-}
-
 static inline bool pebs_is_enabled(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-- 
2.39.2

