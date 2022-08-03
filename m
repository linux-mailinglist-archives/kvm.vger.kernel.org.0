Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FC95892BB
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 21:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbiHCT1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 15:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238566AbiHCT1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 15:27:19 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A3B5B792
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 12:27:13 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id i16-20020a17090adc1000b001f4e121847eso4508067pjv.3
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 12:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=GeP9RItuT5cX0x8bod8txy1j8Bx4gMfigExcAQKorEA=;
        b=TH39iZbQfjrOovP6PSkDuCuS1K49VQy+rHdokoRe8Vd6fIqvucm5OmGFpX08KC9cko
         qtR88vT2RLqC05Cjmf6Qzexgo6uCk80zekZzYc6Gbs2AHwjSuiMZWV6RxkWIqgYCP9YV
         EpjmxTFjxvjk3OhnIB55DRUzd2ILIDgUtghPGZ1aErMB5J/1QFgVyJRyjCqikMW9qkmj
         glgZaRijKDZxBX1i9q5SGvO4pQzh5QxwCQppSNvjsedGAq1C2fgTBZ7SyEfTM6dcfk9/
         9cugZPgy2EL0e253nEbHKTfXTshu9tCvTxTdR73CbL3M21WKLLHajXj1R15ryMZU9Scg
         UIFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=GeP9RItuT5cX0x8bod8txy1j8Bx4gMfigExcAQKorEA=;
        b=ULdjCA9cLSjpF8nvgG09cFSGmUOVMRj3VUQrQJuo0S7nKNPEFWLc0KBx+wTbGCSXR+
         HCT/o7Q9zesRQXVBm5KWRh/T/kgiqsem+r46ryrXN4/V84WfU1VakAGm65f680kkyfUn
         1cveyS88bC8oh20Kom09KljRE2fWrsYnzwCBFkW73EHF+4P/O1aYZaJIGnChb0m7Fcyo
         RmFvr3mVpOxb2QDd3JuV0jfFZYP3XO+ds+WJJWPA5/JQdbejiB0+V0d7Z8bafp7CK7uL
         LIuiCqjlfkzdRLTUMTL++TNaqk7bMIRXKn6khGhG1lZLxCPSb+ltgvAQpliKly45e/NM
         6qwQ==
X-Gm-Message-State: ACgBeo2qRCwfBxJaPGTc8n5NPEYg56CWr7k9F2UoyQh0whKBcngbulUX
        vt3hrP+CAC93LIq8cyZ+TOKAu37v1Lc=
X-Google-Smtp-Source: AA6agR70W4WfP/jyajIwpsWZD3Yz/LI6VDrsaqbQLRj42kpQfzh6LodaF+ZwCJ1s72gveDyQK98NJvXN98c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:110e:b0:16c:defc:a092 with SMTP id
 n14-20020a170903110e00b0016cdefca092mr27719373plh.143.1659554832817; Wed, 03
 Aug 2022 12:27:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Aug 2022 19:26:57 +0000
In-Reply-To: <20220803192658.860033-1-seanjc@google.com>
Message-Id: <20220803192658.860033-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220803192658.860033-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v2 6/7] KVM: VMX: Adjust number of LBR records for
 PERF_CAPABILITIES at refresh
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the PMU is refreshed when MSR_IA32_PERF_CAPABILITIES is written
by host userspace, zero out the number of LBR records for a vCPU during
PMU refresh if PMU_CAP_LBR_FMT is not set in PERF_CAPABILITIES instead of
handling the check at run-time.

guest_cpuid_has() is expensive due to the linear search of guest CPUID
entries, intel_pmu_lbr_is_enabled() is checked on every VM-Enter, _and_
simply enumerating the same "Model" as the host causes KVM to set the
number of LBR records to a non-zero value.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 12 +++---------
 arch/x86/kvm/vmx/vmx.h       |  7 +++++--
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 862c1a4d971b..c399637a3a79 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -171,13 +171,6 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
 }
 
-bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
-{
-	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
-
-	return lbr->nr && (vcpu_get_perf_capabilities(vcpu) & PMU_CAP_LBR_FMT);
-}
-
 static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 {
 	struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
@@ -592,7 +585,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
-	if (cpuid_model_is_consistent(vcpu))
+	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
+	if (cpuid_model_is_consistent(vcpu) &&
+	    (perf_capabilities & PMU_CAP_LBR_FMT))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
 		lbr_desc->records.nr = 0;
@@ -600,7 +595,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (lbr_desc->records.nr)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
 
-	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
 	if (perf_capabilities & PERF_CAP_PEBS_FORMAT) {
 		if (perf_capabilities & PERF_CAP_PEBS_BASELINE) {
 			pmu->pebs_enable_mask = counter_mask;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 35b39dab175d..413702dc1315 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -532,6 +532,11 @@ static inline struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu)
 	return &vcpu_to_lbr_desc(vcpu)->records;
 }
 
+static inline bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
+{
+	return !!vcpu_to_lbr_records(vcpu)->nr;
+}
+
 static inline bool intel_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
 {
 	/*
@@ -545,8 +550,6 @@ static inline bool intel_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
 }
 
 void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
-bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
-
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
 void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
 
-- 
2.37.1.559.g78731f0fdb-goog

