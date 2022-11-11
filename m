Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2FD62584D
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 11:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbiKKK1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 05:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbiKKK1S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 05:27:18 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3017CBC95;
        Fri, 11 Nov 2022 02:27:17 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id z26so4563821pff.1;
        Fri, 11 Nov 2022 02:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=snd8EsmksAMhhSS8x8+8tyu0YocpzQSNL51L6K4kBnU=;
        b=bG6pAHaiSfbuszj9sjt+R7GBIADN9ur286f+ts12AciRM7NgaamlSKC6sLXNGTh+ZG
         4OKuuGSKTCSEPSX7qZmSSsMgOtwmfsYMuWJJ8+ezUl6e7xqDoUBTM5iFnovhIz0ARt4x
         QSHwaMts1coGSxqFRjM8nCY5IFtITcvx0mp6rFbzdF5BNFDNk5uAjWMYVoYuj/TMWEas
         Kl1GtsnRHryeYNlb0oQZEvDJw277nnHKiYdaLLI06EkKMXNO7ThIxfLvhOl+9eFx9l1g
         9rBqlTbn33Qc5P4FOxZTGyCK5qoVNTPcB4xjW8Ip4kf2gwR/Tpsw0mOymPZP3wlfvoPK
         jAfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=snd8EsmksAMhhSS8x8+8tyu0YocpzQSNL51L6K4kBnU=;
        b=OcCNo1vLf1paEvP6077FxHe4YwYsvRDhCKEZ8FKQQugsIFHfwzlMz11yIclOlyDCGD
         /18fTPEXLhKbEe9czeeeraxqCnezLNZGOgLZrmg5SRoq5MAEGYTeSAcxzt4wuqshfl3x
         kHWIk2icYqVfR1vZXpIJFOpX//MnLiHC2TMudbkZyF/TMyr2Y4QDGOhgWhHVV04gr1a9
         wd1friv7HzKZwKqmqDZggWgKaEvYmfE9bgI3KgEEuMSB5wW7NTXzj5qGI2TcvRo3xvpn
         cjEYJJXFrGp/yqIbtOENtQ8IxnCCw21Fcl75tAFc0GGwG3APtqYIf57gx/tLSNprO1Um
         zOyA==
X-Gm-Message-State: ANoB5plRJdj3dUxqSXWrtn2/C3Lj4rnOwnfExn+v+j7sjw0Chau4H7yT
        TKXT97SOUKyVZZ3rV3yADzE=
X-Google-Smtp-Source: AA0mqf7b2U8loY2E/k5vnrYIFXeCMcJ4ybMZdQbwW3GqUqh5lLWOUDkOu8ZEg6f2qU6NOHzVzP28hA==
X-Received: by 2002:a62:e806:0:b0:563:8011:e9e4 with SMTP id c6-20020a62e806000000b005638011e9e4mr1934656pfi.76.1668162436743;
        Fri, 11 Nov 2022 02:27:16 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u67-20020a626046000000b0056b6acb58a0sm1248612pfb.102.2022.11.11.02.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 02:27:16 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sandipan Das <sandipan.das@amd.com>
Subject: [PATCH v3 7/8] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022
Date:   Fri, 11 Nov 2022 18:26:44 +0800
Message-Id: <20221111102645.82001-8-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111102645.82001-1-likexu@tencent.com>
References: <20221111102645.82001-1-likexu@tencent.com>
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
---
 arch/x86/kvm/cpuid.c   | 30 +++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c | 11 ++++++++---
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6b5912578edd..df551fa66ccc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1113,7 +1113,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->edx = 0;
 		break;
 	case 0x80000000:
-		entry->eax = min(entry->eax, 0x80000021);
+		entry->eax = min(entry->eax, 0x80000022);
 		/*
 		 * Serializing LFENCE is reported in a multitude of ways, and
 		 * NullSegClearsBase is not reported in CPUID on Zen2; help
@@ -1229,6 +1229,34 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 			entry->eax |= BIT(6);
 		break;
+	/* AMD Extended Performance Monitoring and Debug */
+	case 0x80000022: {
+		union cpuid_0x80000022_ebx ebx;
+
+		entry->ecx = entry->edx = 0;
+		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_AMD_PMU_V2)) {
+			entry->eax = entry->ebx;
+			break;
+		}
+
+		cpuid_entry_override(entry, CPUID_8000_0022_EAX);
+
+		if (kvm_cpu_cap_has(X86_FEATURE_AMD_PMU_V2))
+			ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
+						     KVM_AMD_PMC_MAX_GENERIC);
+
+		if (kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE))
+			ebx.split.num_core_pmc = max_t(unsigned int,
+						       ebx.split.num_core_pmc,
+						       AMD64_NUM_COUNTERS_CORE);
+		else
+			ebx.split.num_core_pmc = max_t(unsigned int,
+						       ebx.split.num_core_pmc,
+						       AMD64_NUM_COUNTERS);
+
+		entry->ebx = ebx.full;
+		break;
+	}
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
 		/*Just support up to 0xC0000004 now*/
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 527f18d8cc44..127983ab8307 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4914,9 +4914,14 @@ static __init void svm_set_cpu_caps(void)
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
-	/* AMD PMU PERFCTR_CORE CPUID */
-	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
-		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
+	if (enable_pmu) {
+		/* AMD PMU PERFCTR_CORE CPUID */
+		if (boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
+			kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
+		/* KVM only support AMD PerfMon V2 */
+		if (kvm_pmu_cap.version > 1)
+			kvm_cpu_cap_set(X86_FEATURE_AMD_PMU_V2);
+	}
 
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
-- 
2.38.1

