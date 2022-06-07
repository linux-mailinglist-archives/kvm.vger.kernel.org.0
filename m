Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519DC5421E3
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443546AbiFHBAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382295AbiFGXjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:39:05 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EBE1737DE
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:30 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id q12-20020a056a0002ac00b0051bb2e66c91so9815633pfs.4
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GmS2Zfk79J/Sy/RToehyTdCO4x0cZbdTb+j/zQ23WRQ=;
        b=bdzmq7UnnPvyPEMgI3dsae1dM+24A3NDnSWf4gIbLMniZ2r+Aq4+nRpXJeZPPB9xL8
         PK2dP2sPhxm42na7Jm0Eep0e+8o5d5QH9UDPqbjcsE/VWDdOrTWQ2asiqtAsh3BmYVBz
         HFXIyvQgt7roQVy8YOrqw6ZqEAfovWah6OHIiWgSxODHxPCKVHdzC9QY9emiU80JH6c6
         Pf9AY6vbYJZsdWVbS8Utv1IcJ6z3SCEdzpio9yHXPzxLYiTu0UudYuPUblOSgy2Kr46l
         fLzlCtqxY70zJB5zQcWyWFB+McvkwFLgrM4/v7DiqHrbVt1Y1Bqq3nqDXxLf26xzQ9Mh
         90rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GmS2Zfk79J/Sy/RToehyTdCO4x0cZbdTb+j/zQ23WRQ=;
        b=z7WiILbAJBhTODNXBGViuGiEavjGz/1g2NL6MmFssuHGVh1ObE4Z9A4BYVUhc1uVbx
         GchPzOtaBBIjK+s2y20f51hGWdEdLv2YfCQpXV3/ehbs7YXV/hpbwK4muL4MQ4bDAlR1
         qdnGMVczBg4QRw0qQl4n4hfgboA4RnzopEN0s9e0NwlEO/YTsXcnWA9aC3pDKMgo++Yf
         bVbfyApBl2D2HhjSMmiyjxtYlg/J9piRlO18DRPxOApTIrqYYVjYHcjAjAIJNMeQ4hRC
         irhXpiL0vHxlAsc6igFeqtsNo90dnGvXWGdwTKMPQU4lBOIHbHRk9eI8vchTuM6QD18b
         EOPA==
X-Gm-Message-State: AOAM531JIhskF0P4sD0/hXkBvX25pLuEG2e+iufxfAbtUXhGl8+rzGta
        dXEOyHpv97633x2OqRNrwqy/hyUjR7s=
X-Google-Smtp-Source: ABdhPJzLtIwGn7tXr8E4ox73+ncuEOoNaH720aApuV9kLjNuT2EKO4l6xAlZFYo1g5kpgraplK4mzENO8E8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:2d0:b0:14d:8a8d:cb1 with SMTP id
 s16-20020a17090302d000b0014d8a8d0cb1mr30934054plk.50.1654637789914; Tue, 07
 Jun 2022 14:36:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:35:56 +0000
In-Reply-To: <20220607213604.3346000-1-seanjc@google.com>
Message-Id: <20220607213604.3346000-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220607213604.3346000-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 07/15] KVM: VMX: Add helper to check if the guest PMU has PERF_GLOBAL_CTRL
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
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

Add a helper to check of the guest PMU has PERF_GLOBAL_CTRL, which is
unintuitive _and_ diverges from Intel's architecturally defined behavior.
Even worse, KVM currently implements the check using two different, but
equivalent checksand , _and_ there has been at least one attempt to add a
_third_ flavor.

Link: https://lore.kernel.org/all/Yk4ugOETeo%2FqDRbW@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c |  4 ++--
 arch/x86/kvm/vmx/vmx.h       | 12 ++++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 5b85320fc9f1..6ce3b066f7d9 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -111,7 +111,7 @@ static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
-	if (pmu->version < 2)
+	if (!intel_pmu_has_perf_global_ctrl(pmu))
 		return true;
 
 	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
@@ -208,7 +208,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr, bool host_initiat
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		if (host_initiated)
 			return true;
-		return pmu->version > 1;
+		return intel_pmu_has_perf_global_ctrl(pmu);
 		break;
 	case MSR_IA32_PEBS_ENABLE:
 		if (host_initiated)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 576fed7e33de..215f17eb6732 100644
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
2.36.1.255.ge46751e96f-goog

