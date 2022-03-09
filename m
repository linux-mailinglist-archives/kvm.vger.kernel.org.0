Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FC54D2AC8
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 09:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbiCIIoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 03:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiCIIoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 03:44:10 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41D5A41BA;
        Wed,  9 Mar 2022 00:43:10 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id bx5so1705680pjb.3;
        Wed, 09 Mar 2022 00:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UUlw5iop1hg2LcntCzOm7pJNZ6lZKUbeGMjMuteL4pc=;
        b=LbW67smhAalQyd7nOFqRjXDlUebOp1rQCcw5RxCkbXxCi++bWhev53p48zrLBYaBMV
         LV5wRz4huARv02anX7mB2v2G+mIWSn8/tLjtI0RE9tidrZiQb2B1QkT/9H9lgE0nmux7
         GBJLRdMK1oC6RdM3M3x8AanKvdKpUmvdAhLLLMgSYfK7plXk68DyfY463EbG2Y20OVrN
         ZXUuLDQ1l8EM4g/CCXADC7CSSzRDT9TKRbflNqUzT5hV8Rg36aV7VzFsXPOgZxaCMV5N
         qttSLnfzMnkk6GIbarOixaYddJIR891i1mXoy8JmNogliaW8yPNOKcFOj0KGplXWtd7O
         UeLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UUlw5iop1hg2LcntCzOm7pJNZ6lZKUbeGMjMuteL4pc=;
        b=WHIoqXQg/8NRchs2bTLddrmqMl8e2vnmSht+9lOAMhcnGKSD3uTpDnfrR4keqyLtNQ
         UktHc2K9DYcX4MKsTepoJSuyskepXXvZjuuoU3oq/9MxyJP53IP+brzB+6AJ1S0hiv2o
         mFu9YvZYdfgM+1f2gzt+0L6PvdPwbWqH5gLXePWdiQSdIP0tNTik9MTpar5VH/n5Ho8g
         I91dsdnMZLZQQBZqj3nGzVu9x2Ba7MrQeK5I+8qa8DtsohoYYszGtDV/wu72zUve3BC+
         Bluinm6ZgbYXafy/W53yqDXyY0aURagL42cu07rcVOfYQp9z/J+zvk0ovf3CqrAHBsIS
         faKQ==
X-Gm-Message-State: AOAM533ekiiRQe8jQQtqWL9S2Q4T6wkCjmESYvumOTYDraN4oVvE+hrU
        a1sUgmW45EazRq3aNVq7YDE=
X-Google-Smtp-Source: ABdhPJzKxCI6STq01WzJZgDiHz8+77NWfM0lbC4I8yysxBae/noSe/Q5poixGyGpFl70Ch3T/N57Tg==
X-Received: by 2002:a17:902:e88d:b0:151:ba78:3bc1 with SMTP id w13-20020a170902e88d00b00151ba783bc1mr21890601plg.13.1646815390346;
        Wed, 09 Mar 2022 00:43:10 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m8-20020a17090a158800b001bf2cec0377sm7094436pja.3.2022.03.09.00.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 00:43:09 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@amd.com>,
        Andi Kleen <ak@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86/pmu: Fix and isolate TSX-specific performance event logic
Date:   Wed,  9 Mar 2022 16:42:57 +0800
Message-Id: <20220309084257.88931-1-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

HSW_IN_TX* bits are used in generic code which are not supported on
AMD. Worse, these bits overlap with AMD EventSelect[11:8] and hence
using HSW_IN_TX* bits unconditionally in generic code is resulting in
unintentional pmu behavior on AMD. For example, if EventSelect[11:8]
is 0x2, pmc_reprogram_counter() wrongly assumes that
HSW_IN_TX_CHECKPOINTED is set and thus forces sampling period to be 0.

Also per the SDM, both bits 32 and 33 "may only be set if the processor
supports HLE or RTM" and for "IN_TXCP (bit 33): this bit may only be set
for IA32_PERFEVTSEL2."

Opportunistically eliminate code redundancy, because if the HSW_IN_TX*
bit is set in pmc->eventsel, it is already set in attr.config.

Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Reported-by: Jim Mattson <jmattson@google.com>
Fixes: 103af0a98788 ("perf, kvm: Support the in_tx/in_tx_cp modifiers in KVM arch perfmon emulation v5")
Co-developed-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
v1 -> v2 Changelog:
- Benefit from the insights provided by commit fdefb96c608e; (Jim)
- IN_TXCP bit may only be set for IA32_PERFEVTSEL2; (Jim)
- Remove the redundant code about attr.config; (Jim)

Previous:
https://lore.kernel.org/kvm/20220307063805.65030-1-likexu@tencent.com/

 arch/x86/kvm/pmu.c           | 15 +++++----------
 arch/x86/kvm/vmx/pmu_intel.c | 13 ++++++++++---
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 902b6d700215..eca39f56c231 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -96,8 +96,7 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 
 static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 				  u64 config, bool exclude_user,
-				  bool exclude_kernel, bool intr,
-				  bool in_tx, bool in_tx_cp)
+				  bool exclude_kernel, bool intr)
 {
 	struct perf_event *event;
 	struct perf_event_attr attr = {
@@ -116,16 +115,14 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
-	if (in_tx)
-		attr.config |= HSW_IN_TX;
-	if (in_tx_cp) {
+	if ((attr.config & HSW_IN_TX_CHECKPOINTED) &&
+	    guest_cpuid_is_intel(pmc->vcpu)) {
 		/*
 		 * HSW_IN_TX_CHECKPOINTED is not supported with nonzero
 		 * period. Just clear the sample period so at least
 		 * allocating the counter doesn't fail.
 		 */
 		attr.sample_period = 0;
-		attr.config |= HSW_IN_TX_CHECKPOINTED;
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
@@ -233,9 +230,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	pmc_reprogram_counter(pmc, type, config,
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
-			      eventsel & ARCH_PERFMON_EVENTSEL_INT,
-			      (eventsel & HSW_IN_TX),
-			      (eventsel & HSW_IN_TX_CHECKPOINTED));
+			      eventsel & ARCH_PERFMON_EVENTSEL_INT);
 }
 EXPORT_SYMBOL_GPL(reprogram_gp_counter);
 
@@ -271,7 +266,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 			      kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
-			      pmi, false, false);
+			      pmi);
 }
 EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index da71160a50d6..efa172a7278e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -389,6 +389,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct kvm_pmc *pmc;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
+	u64 reserved_bits;
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
@@ -443,7 +444,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			if (data == pmc->eventsel)
 				return 0;
-			if (!(data & pmu->reserved_bits)) {
+			reserved_bits = pmu->reserved_bits;
+			if ((pmc->idx == 2) &&
+			    (pmu->raw_event_mask & HSW_IN_TX_CHECKPOINTED))
+				reserved_bits ^= HSW_IN_TX_CHECKPOINTED;
+			if (!(data & reserved_bits)) {
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
@@ -534,8 +539,10 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
 	if (entry &&
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
-	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
-		pmu->reserved_bits ^= HSW_IN_TX|HSW_IN_TX_CHECKPOINTED;
+	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM))) {
+		pmu->reserved_bits ^= HSW_IN_TX;
+		pmu->raw_event_mask |= (HSW_IN_TX|HSW_IN_TX_CHECKPOINTED);
+	}
 
 	bitmap_set(pmu->all_valid_pmc_idx,
 		0, pmu->nr_arch_gp_counters);
-- 
2.35.1

