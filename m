Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF1557E9FD
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 00:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbiGVWoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 18:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236851AbiGVWoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 18:44:18 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DD7BE11
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 15:44:17 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s6-20020a170902a50600b0016d2e77252eso3296476plq.18
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 15:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nQbI7mgbPu76BJJTxIKbUpy3vK9Oikhk2MGU8S06ItM=;
        b=gs/mLRrabGlmhxpkstmEAULa3o8l9S4Z63InD53IX0DUsxaV8IDtM/l44DSpaEr4s1
         6IfW58DBfkAq4r0eKePk6jfemH3i6C1r5H2gXBgm5U4hlWK00pCLJ2a7s+0kxUfnT3eD
         ztg633DDoUaIEzb4XEtL5we+/SWkZSxIgcT3vMoVhfsaCTGcdGyxX5x1IPlEOEn5AF8R
         hm0JMYYzR+6/s20i1cGEKzocN4a1JIchljVAiFJOJDWQYcPR9NffUdUQgpX7ETAgbuU3
         fyWIdnOAxyJDVCGCTYBC38h3mKgKkP9XggQJpiin0is3kP5zr3itK6oj1UqwhAsnoq9L
         znWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nQbI7mgbPu76BJJTxIKbUpy3vK9Oikhk2MGU8S06ItM=;
        b=jxQMt2Hp6Hx+n9iJ83LlGdF+igKDka3wDZDzjCyQQM8xYGYLLm3V0SxqhJeyEoRoyy
         MvyIG1J2sPIiPOf/H7No5cMbJegdTWY8JymoZlebPVVyb+wzbIoRV5lpxJSlzs6Kn592
         ufyqfkDR9/trH+bjJhYJAf1YrnWJpspgc8kCmUgAJDmdW9LHmAPruDttoICDA5gd6Laa
         WXnYxLR9Kw5v+ZaQC3XtEIdiWnDIBr9RAcMh+WL/SfysrlBk/s3/yY71owRUu23h7rwy
         SbFnvJlW050U1tl0vo8tsqSH+Q8B2qS0E59Q9YADOStR7bgv6hFoj00A4jAXUGe2qeK9
         QtPg==
X-Gm-Message-State: AJIora/rNa28P2OQsY7hlQJj4VyrnEmT50A8UEJfHTAjMmHo/SS5X4VT
        +yeOzzuf/ssGgJxmc+EjQ8UyXxZ/IKQ=
X-Google-Smtp-Source: AGRyM1uMN9Bq8o664JObQs8A6sS3uPBc5ZuDgDK4I/bo2w4Ex/gpGwWdxLKgnS090UlnEcme99TIC85j/Gs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8c5:b0:510:6eae:6fa1 with SMTP id
 s5-20020a056a0008c500b005106eae6fa1mr2093741pfu.12.1658529857442; Fri, 22 Jul
 2022 15:44:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jul 2022 22:44:07 +0000
In-Reply-To: <20220722224409.1336532-1-seanjc@google.com>
Message-Id: <20220722224409.1336532-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220722224409.1336532-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 3/5] KVM: VMX: Add helper to check if the guest PMU has PERF_GLOBAL_CTRL
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to check of the guest PMU has PERF_GLOBAL_CTRL, which is
unintuitive _and_ diverges from Intel's architecturally defined behavior.
Even worse, KVM currently implements the check using two different (but
equivalent) checks, _and_ there has been at least one attempt to add a
_third_ flavor.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c |  4 ++--
 arch/x86/kvm/vmx/vmx.h       | 12 ++++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 6e355c5d2f40..78f2800fd850 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -111,7 +111,7 @@ static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
-	if (pmu->version < 2)
+	if (!intel_pmu_has_perf_global_ctrl(pmu))
 		return true;
 
 	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
@@ -207,7 +207,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_STATUS:
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		ret = pmu->version > 1;
+		return intel_pmu_has_perf_global_ctrl(pmu);
 		break;
 	case MSR_IA32_PEBS_ENABLE:
 		ret = vcpu_get_perf_capabilities(vcpu) & PERF_CAP_PEBS_FORMAT;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 286c88e285ea..2a0b94e0fda7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -91,6 +91,18 @@ union vmx_exit_reason {
 	u32 full;
 };
 
+static inline bool intel_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
+{
+	/*
+	 * Architecturally, Intel's SDM states that IA32_PERF_GLOBAL_CTRL is
+	 * supported if "CPUID.0AH: EAX[7:0] > 0", i.e. if the PMU version is
+	 * greater than zero.  However, KVM only exposes and emulates the MSR
+	 * to/for the guest if the guest PMU supports at least "Architectural
+	 * Performance Monitoring Version 2".
+	 */
+	return pmu->version > 1;
+}
+
 #define vcpu_to_lbr_desc(vcpu) (&to_vmx(vcpu)->lbr_desc)
 #define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
 
-- 
2.37.1.359.gd136c6c3e2-goog

