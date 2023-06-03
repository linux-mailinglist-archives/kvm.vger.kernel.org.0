Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B47720CE1
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 03:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbjFCBLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 21:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237079AbjFCBL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 21:11:27 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39526E62
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 18:11:15 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6540e7d7db6so182591b3a.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 18:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685754674; x=1688346674;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zr+/pnb/J2jPCGA1Q1JKmqMm9BtDe3UI/Uh5NJfZaa0=;
        b=W6Vz7Xw1rbw0gXa2rsXOXRYx9YEGjz4vKv2uzqozbUhgFxNAOk9kfVUKB+AJhWcN1+
         wpQ10OmxsNP3yWnjcyC5p/scv4pyLFvcBHi84A9pe5DlHO4mJ5iGsQq1dqopovSnEPOy
         Q2Xrpm+0Eq/hvEM14iRld1pFqKnm3BTumBvvyN8vXrGGOcc7oROUj7Rb9zFvKW9IGUvV
         zBfimPAEhr8ADG+4l6OPTeJCAqSqDk1j6r6HTLtlUBDDA4eoV6a5wjWZJS/adiuARAqD
         2bJ1Iqhfq7vcWI3RPYcQypDU5RfldmC+YlfMFwI5OcU2Fc7YfxJStT/9auzVNgKIiuqc
         NHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685754674; x=1688346674;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zr+/pnb/J2jPCGA1Q1JKmqMm9BtDe3UI/Uh5NJfZaa0=;
        b=VVMB3Z6weLX1Jc7d45OF5h7TRjUr/wXeH03uhO4C0ojmWpsadgOXrkub5g/Zfv0ZXY
         AUg11J/8+X+WBjPPkc0j3+9PAkkY2fS5CxSlHDha0Kg6BufLRaUxShrit5/Mj8j/K0hR
         XpL9EMWAxbC9pPtZUtVERt8TKJt7ba6fFbyLXT6GhccHxCGH9XliuEX4ivflETM4fdP0
         05DxO8GA0M15rFhzAdmFyfbHGfD9EoI2D6z1Nvq2tOOx8OOHr5oZTaBBQmVGUDjI5p3E
         yV6Y6D4FMsAJE2AhPpHGw8lRMMwKRRn6A7gDrNyVC3KjnIxpWYb4uWlqL6bXI+xxlA5Z
         86Sw==
X-Gm-Message-State: AC+VfDzqeb/Ei+zr8WYoDvzj2+GJVNq/XtA3SfEilQME34nRoQ3OjEn+
        E4IZ/sp+4T20W3i2RAKHGbYfr+5KwhE=
X-Google-Smtp-Source: ACHHUZ5XAS8BSRnTJQzXlIkYsfeCLg9EJh+dmhJjUP7A+EonEwCcxy3lNQoPjRXB0ILz1JUba+A4Ih51Ml0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:495f:0:b0:53f:7713:5e0e with SMTP id
 y31-20020a63495f000000b0053f77135e0emr2571629pgk.5.1685754674630; Fri, 02 Jun
 2023 18:11:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Jun 2023 18:10:53 -0700
In-Reply-To: <20230603011058.1038821-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230603011058.1038821-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230603011058.1038821-8-seanjc@google.com>
Subject: [PATCH v7 07/12] KVM: x86/pmu: Disable vPMU if the minimum num of
 counters isn't met
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>,
        Like Xu <likexu@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Disable PMU support when running on AMD and perf reports fewer than four
general purpose counters. All AMD PMUs must define at least four counters
due to AMD's legacy architecture hardcoding the number of counters
without providing a way to enumerate the number of counters to software,
e.g. from AMD's APM:

 The legacy architecture defines four performance counters (PerfCtrn)
 and corresponding event-select registers (PerfEvtSeln).

Virtualizing fewer than four counters can lead to guest instability as
software expects four counters to be available. Rather than bleed AMD
details into the common code, just define a const unsigned int and
provide a convenient location to document why Intel and AMD have different
mins (in particular, AMD's lack of any way to enumerate less than four
counters to the guest).

Keep the minimum number of counters at Intel at one, even though old P6
and Core Solo/Duo processor effectively require a minimum of two counters.
KVM can, and more importantly has up until this point, supported a vPMU so
long as the CPU has at least one counter.  Perf's support for P6/Core CPUs
does require two counters, but perf will happily chug along with a single
counter when running on a modern CPU.

Cc: Jim Mattson <jmattson@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
[sean: set Intel min to '1', not '2']
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.h           | 14 ++++++++++----
 arch/x86/kvm/svm/pmu.c       |  1 +
 arch/x86/kvm/vmx/pmu_intel.c |  1 +
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index f77bfc7ede42..7d9ba301c090 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -36,6 +36,7 @@ struct kvm_pmu_ops {
 
 	const u64 EVENTSEL_EVENT;
 	const int MAX_NR_GP_COUNTERS;
+	const int MIN_NR_GP_COUNTERS;
 };
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
@@ -174,6 +175,7 @@ extern struct x86_pmu_capability kvm_pmu_cap;
 static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 {
 	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
+	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
 
 	/*
 	 * Hybrid PMUs don't play nice with virtualization without careful
@@ -188,11 +190,15 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 		perf_get_x86_pmu_capability(&kvm_pmu_cap);
 
 		/*
-		 * For Intel, only support guest architectural pmu
-		 * on a host with architectural pmu.
+		 * WARN if perf did NOT disable hardware PMU if the number of
+		 * architecturally required GP counters aren't present, i.e. if
+		 * there are a non-zero number of counters, but fewer than what
+		 * is architecturally required.
 		 */
-		if ((is_intel && !kvm_pmu_cap.version) ||
-		    !kvm_pmu_cap.num_counters_gp)
+		if (!kvm_pmu_cap.num_counters_gp ||
+		    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < min_nr_gp_ctrs))
+			enable_pmu = false;
+		else if (is_intel && !kvm_pmu_cap.version)
 			enable_pmu = false;
 	}
 
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 70143275e0a7..e5c69062a909 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -224,4 +224,5 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.reset = amd_pmu_reset,
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
+	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
 };
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b2f279f934b1..30ec9ccdea47 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -777,4 +777,5 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.cleanup = intel_pmu_cleanup,
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
+	.MIN_NR_GP_COUNTERS = 1,
 };
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

