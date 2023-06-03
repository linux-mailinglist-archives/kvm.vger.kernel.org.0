Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71543720CEB
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 03:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbjFCBMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 21:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237073AbjFCBLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 21:11:46 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B5B1703
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 18:11:24 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b05714b3bfso12195925ad.0
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 18:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685754684; x=1688346684;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=O6aZ99/gTomPSpDx04dBgMUhLAou1VtK/fDnLslrZmU=;
        b=x7HWDH8/Bs9YtzCXj/mrZ81zxYF5I7CITbLVs3xIKM9SDl8Dj5A8nTCf6r3RXcbCn2
         blMFBeeTkuC5motXASnEpV1/tXRACqNxLOenferCAhBm54ivgYoqeyd48H878wW44RUh
         Be2SKu4/9omccwscEsK5eKJS32/tTOLSkQ/MwCfR1wvFCrEtth7QbICvOK5L2RRkCHhw
         GIKF2gf1ztel2DMowiBL4haf3VfY/E/eR3BvaajX65im7/Y3zWITDuCfOC8qWpfWQ2Av
         4uZxD2JZrD2g+4zgtsr6pxlRtA51RsTEYC4LdQQ/KJSmyBYowcXw1YoXo021O2sAwHNA
         XO+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685754684; x=1688346684;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O6aZ99/gTomPSpDx04dBgMUhLAou1VtK/fDnLslrZmU=;
        b=AtAYwSB7w1kusVPunuNFzcDCsbxnamEwZKFyg7mdPElke69pwCgJ7SFm6kng5QCgPa
         gRkrPYbHGY8WoDOYdXWII6N5dVasEhumnHMIZF5S2uuqUcvouDw5sd6gEu4bnnNR2ye6
         YieAYflbAClsde+yvmb7v7NTxxes5GeB4wmJMMQwCY0aW0OJhTFh/cK6JppX2k7pBSgE
         64zGC1dz0ybiC9PJGGxEPyy3NgtSxOh/GLpjpBwYIb+fxeJfc/r2qiZR+OUhWppNPwEU
         aPKSXP5LJQvEi1xoVtNUC4hHAveZY7erp3Q7xLil9uX7UueiZWU/0+S9fdREDhuq+pnG
         WMeA==
X-Gm-Message-State: AC+VfDxuvCQiGdcDBWuz9Chs6oemMz2iIRDZKbxqQeJ/U9hZF+Q/jVEp
        1WT0AgxBGCz39HGlznb7GPCG4oJ2X98=
X-Google-Smtp-Source: ACHHUZ5j4aR8F78dxip8RbVwwtN7tQSfuK9BhguCjo7+vHSO3ZVYBRQZ6EYSIpVmjSUrhNK8nWPG//nOytk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c204:b0:1a6:b4cf:f6c0 with SMTP id
 4-20020a170902c20400b001a6b4cff6c0mr375741pll.4.1685754683772; Fri, 02 Jun
 2023 18:11:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Jun 2023 18:10:58 -0700
In-Reply-To: <20230603011058.1038821-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230603011058.1038821-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230603011058.1038821-13-seanjc@google.com>
Subject: [PATCH v7 12/12] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

CPUID leaf 0x80000022 i.e. ExtPerfMonAndDbg advertises some new
performance monitoring features for AMD processors.

Bit 0 of EAX indicates support for Performance Monitoring Version 2
(PerfMonV2) features. If found to be set during PMU initialization,
the EBX bits of the same CPUID function can be used to determine
the number of available PMCs for different PMU types.

Expose the relevant bits via KVM_GET_SUPPORTED_CPUID so that
guests can make use of the PerfMonV2 features.

Co-developed-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c   | 28 +++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c |  4 ++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 61bc71882f07..0e5584f4acd7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -734,6 +734,10 @@ void kvm_set_cpu_caps(void)
 		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */
 	);
 
+	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0022_EAX,
+		F(PERFMON_V2)
+	);
+
 	/*
 	 * Synthesize "LFENCE is serializing" into the AMD-defined entry in
 	 * KVM's supported CPUID if the feature is reported as supported by the
@@ -1128,7 +1132,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->edx = 0;
 		break;
 	case 0x80000000:
-		entry->eax = min(entry->eax, 0x80000021);
+		entry->eax = min(entry->eax, 0x80000022);
 		/*
 		 * Serializing LFENCE is reported in a multitude of ways, and
 		 * NullSegClearsBase is not reported in CPUID on Zen2; help
@@ -1233,6 +1237,28 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->ebx = entry->ecx = entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
 		break;
+	/* AMD Extended Performance Monitoring and Debug */
+	case 0x80000022: {
+		union cpuid_0x80000022_ebx ebx;
+
+		entry->ecx = entry->edx = 0;
+		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2)) {
+			entry->eax = entry->ebx;
+			break;
+		}
+
+		cpuid_entry_override(entry, CPUID_8000_0022_EAX);
+
+		if (kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2))
+			ebx.split.num_core_pmc = kvm_pmu_cap.num_counters_gp;
+		else if (kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE))
+			ebx.split.num_core_pmc = AMD64_NUM_COUNTERS_CORE;
+		else
+			ebx.split.num_core_pmc = AMD64_NUM_COUNTERS;
+
+		entry->ebx = ebx.full;
+		break;
+	}
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
 		/*Just support up to 0xC0000004 now*/
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9669e3cc00a..ff48cdea1fbf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5036,6 +5036,10 @@ static __init void svm_set_cpu_caps(void)
 							  kvm_pmu_cap.num_counters_gp);
 		else
 			kvm_cpu_cap_check_and_set(X86_FEATURE_PERFCTR_CORE);
+
+		if (kvm_pmu_cap.version != 2 ||
+		    !kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE))
+			kvm_cpu_cap_clear(X86_FEATURE_PERFMON_V2);
 	}
 
 	/* CPUID 0x8000001F (SME/SEV features) */
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

