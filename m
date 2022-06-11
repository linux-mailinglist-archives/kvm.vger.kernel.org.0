Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3907A5470C9
	for <lists+kvm@lfdr.de>; Sat, 11 Jun 2022 02:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349262AbiFKA6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 20:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346475AbiFKA6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 20:58:10 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9217C69CF0
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:58:07 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id oa9-20020a17090b1bc900b001e67bbd7f83so2243695pjb.4
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=eZ8kTZcYsLZa7Sb/Uqf9XtHrVzcz+U7OgKi4WYD6wyc=;
        b=KhHmet355MHSc1wPItLL5984cuOsg9oaCLgxS78tJ4wM1x3notaW99CfqVyUL0CxZY
         PwNGzeUb6L/opMdlHaF6tGSus7GjqhyIf+TIf7a2vpNtIYOZIp1W6wVtsnyMtkgnZVXV
         iQ8L8KrUX3zuROC/ZVcrqcyJniBdJkf8YYbeaNB9OhcZH4xM/pQzPYwCi1kzp1VIAqwq
         qNpmxYHd5Q+xGtRU/1R0LH+aJwq8dcpsrn+Uj9hp0ZGeHF3tKWG3CXrZVZNNNG01Vc9Y
         FZMCi+cbC8+PYHrvdGtkYGhqMg/nvKAgoduX+xGOxTxhUP+R8ZpmG19hNwtE3dAtOCp8
         604A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=eZ8kTZcYsLZa7Sb/Uqf9XtHrVzcz+U7OgKi4WYD6wyc=;
        b=PK+EIqNBvaKiGywW0sFxCZIVTvzvBm01QCoEfdeKA+1SztEuh9sm+6PyekB2C4GXnL
         p3aU5tRl6G2HngI1I6l9vOMy0kjKNGM4S5qfUVZ+BtFGgQs/vi5a717m+5pBwIeUQBLB
         VQ4+sQa+6LBXETL40h4tcbCIruS5d6a6vHGG0QV0paQcYgnhb3Lqllh2QtRhOGbGcXOh
         5kttb+nYQj/3QEITGckOZsbY9Edl1MK4f7yFetM+/IRHHlmEvjjjuxshZt5s1lUV+1ZB
         mlMQlHfG7yyX6d5SypQIKJI/j1q7SzCJr1Q6J1x3qfnS/ptqhyJ17fHrgpEDgihfqM9b
         JPoA==
X-Gm-Message-State: AOAM532DeI9Zcf9Gz0YNK799aRSwl+yWPYprQ7odaUvDUL9BXf8uaOfP
        81qJwNWWsMZXpY1mzfAoi3ywRsC2pzs=
X-Google-Smtp-Source: ABdhPJzSqCMtWXFXI5FV8ny6OajgmJnz9VEynozz1BndGF+AM5OuFcXqv3HRZiFG8Y1ovQT3wKLMQSiXbg4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a91:b0:51c:2fab:7340 with SMTP id
 e17-20020a056a001a9100b0051c2fab7340mr24647144pfv.74.1654909087017; Fri, 10
 Jun 2022 17:58:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 11 Jun 2022 00:57:53 +0000
In-Reply-To: <20220611005755.753273-1-seanjc@google.com>
Message-Id: <20220611005755.753273-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220611005755.753273-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 5/7] KVM: VMX: Use vcpu_get_perf_capabilities() to get
 guest-visible value
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vcpu_get_perf_capabilities() when querying MSR_IA32_PERF_CAPABILITIES
from the guest's perspective, e.g. to update the vPMU and to determine
which MSRs exist.  If userspace ignores MSR_IA32_PERF_CAPABILITIES but
clear X86_FEATURE_PDCM, the guest should see '0'.

Fixes: 902caeb6841a ("KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS")
Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b1aae60cf061..53ccba896e77 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -199,7 +199,7 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	u64 perf_capabilities = vcpu->arch.perf_capabilities;
+	u64 perf_capabilities;
 	int ret;
 
 	switch (msr) {
@@ -210,12 +210,13 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		ret = pmu->version > 1;
 		break;
 	case MSR_IA32_PEBS_ENABLE:
-		ret = perf_capabilities & PERF_CAP_PEBS_FORMAT;
+		ret = vcpu_get_perf_capabilities(vcpu) & PERF_CAP_PEBS_FORMAT;
 		break;
 	case MSR_IA32_DS_AREA:
 		ret = guest_cpuid_has(vcpu, X86_FEATURE_DS);
 		break;
 	case MSR_PEBS_DATA_CFG:
+		perf_capabilities = vcpu_get_perf_capabilities(vcpu);
 		ret = (perf_capabilities & PERF_CAP_PEBS_BASELINE) &&
 			((perf_capabilities & PERF_CAP_PEBS_FORMAT) > 3);
 		break;
@@ -515,6 +516,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
+	u64 perf_capabilities;
 	u64 counter_mask;
 	int i;
 
@@ -599,8 +601,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (lbr_desc->records.nr)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
 
-	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
-		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
+	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
+	if (perf_capabilities & PERF_CAP_PEBS_FORMAT) {
+		if (perf_capabilities & PERF_CAP_PEBS_BASELINE) {
 			pmu->pebs_enable_mask = counter_mask;
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
 			for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
-- 
2.36.1.476.g0c4daa206d-goog

