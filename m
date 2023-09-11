Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428A879B81B
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbjIKUsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236949AbjIKLoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 07:44:39 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17BFCDD;
        Mon, 11 Sep 2023 04:44:34 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 98e67ed59e1d1-271c700efb2so2752496a91.0;
        Mon, 11 Sep 2023 04:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694432674; x=1695037474; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BqwEtjLCi3U6rqZ2y48qo1ozi13OTalhUpfS7LbQ5Mc=;
        b=ij43+g8AISfvl+zKDkFgp84qgf/VbVaQlTMmF03n00HOjCOUztSYa7WrfzFbv3nGAz
         JCaKANulOgL0JA/KZ2mGedNL2LbLJ6Fz1Jpt1i36jo0ERSQIMUmCxB1McTuzSgOpKZys
         mCFBsNEhsfVK65LrbE+MNcZW++NBMTotVOUjP8oy9BWX7EM3ByZrnklnH7mlM+oLFEzH
         2luE/uQ5KzFxh2OwoyB7/dZUauj7KVutEIJXACQSNYwpoFEQILftqbT3d4iSLR7OzuW3
         HgDNDikhbyo3y8XRnr1OjgaFVUQM2psaduHzGMkf4baGm+23ZZ4CwniIcZUHD8QAk78I
         hJYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694432674; x=1695037474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BqwEtjLCi3U6rqZ2y48qo1ozi13OTalhUpfS7LbQ5Mc=;
        b=FKB0I91c+Q4ixMB9ii28GrVSN/xk18qf794Lq8wuqKomtPvlGi/HJGuH0Rg+tugHY3
         BxVQmlMAi4Ci15v6Nd8IKnAqkMKmIeDxE94cYHAqVw+5JZLsLyjksH7J85QBYKcTaqBA
         L3w0AhitVO0ab0yUu4YLbUc7I6dd0CK/aXJbUhFiTLHsNvjXjmJDwtEhDC1D+k2ZxHTh
         KP2cI1HiI6bDqFJtNZ/2IULJNqb2kTfMvz6SpwNtWLF3v5qbaY19Wfcns7aAeOfwQA4v
         V50H4pkRoCiNA8iPgV054ME/rqYXB99qErNaLRRYDfsmw7H5IZhErYOyIt0YKHh9Gx+Z
         z0Vg==
X-Gm-Message-State: AOJu0YzJkjhoWh7blR55UpYYmxRoQ6HliwNEVn23Pl4c5g1BV6Pp2D7u
        +Q8MCmwZLlJvomF4euv3HvA=
X-Google-Smtp-Source: AGHT+IGqCIyNTy/xpw76QDiAv/g30oRyBkDY0TZp/XgcUY6e6TaZh84jHpSyFB+vim/QKZzScucyNw==
X-Received: by 2002:a17:90b:948:b0:271:8195:8 with SMTP id dw8-20020a17090b094800b0027181950008mr7162217pjb.36.1694432674306;
        Mon, 11 Sep 2023 04:44:34 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090a10c900b00273f65fa424sm3855390pje.8.2023.09.11.04.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 04:44:33 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/9] KVM: selftests: Extend this_pmu_has() and kvm_pmu_has() to check arch events
Date:   Mon, 11 Sep 2023 19:43:40 +0800
Message-Id: <20230911114347.85882-3-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230911114347.85882-1-cloudliang@tencent.com>
References: <20230911114347.85882-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The kvm_x86_pmu_feature struct has been updated to use the more
descriptive name "pmu_feature" instead of "anti_feature".

Extend this_pmu_has() and kvm_pmu_has() functions to better support
checking for Intel architectural events. Rename this_pmu_has() and
kvm_pmu_has() to this_pmu_has_arch_event() and kvm_pmu_has_arch_event().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 38 ++++++++++++++-----
 .../kvm/x86_64/pmu_event_filter_test.c        |  2 +-
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 6b146e1c6736..ede433eb6541 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -280,12 +280,12 @@ struct kvm_x86_cpu_property {
  * architectural event is supported.
  */
 struct kvm_x86_pmu_feature {
-	struct kvm_x86_cpu_feature anti_feature;
+	struct kvm_x86_cpu_feature pmu_feature;
 };
 #define	KVM_X86_PMU_FEATURE(name, __bit)					\
 ({										\
 	struct kvm_x86_pmu_feature feature = {					\
-		.anti_feature = KVM_X86_CPU_FEATURE(0xa, 0, EBX, __bit),	\
+		.pmu_feature = KVM_X86_CPU_FEATURE(0xa, 0, EBX, __bit),		\
 	};									\
 										\
 	feature;								\
@@ -681,12 +681,21 @@ static __always_inline bool this_cpu_has_p(struct kvm_x86_cpu_property property)
 	return max_leaf >= property.function;
 }
 
-static inline bool this_pmu_has(struct kvm_x86_pmu_feature feature)
+static inline bool this_pmu_has_arch_event(struct kvm_x86_pmu_feature feature)
 {
-	uint32_t nr_bits = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+	uint32_t nr_bits;
 
-	return nr_bits > feature.anti_feature.bit &&
-	       !this_cpu_has(feature.anti_feature);
+	if (feature.pmu_feature.reg == KVM_CPUID_EBX) {
+		nr_bits = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+		return nr_bits > feature.pmu_feature.bit &&
+			!this_cpu_has(feature.pmu_feature);
+	} else if (feature.pmu_feature.reg == KVM_CPUID_ECX) {
+		nr_bits = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+		return nr_bits > feature.pmu_feature.bit ||
+			this_cpu_has(feature.pmu_feature);
+	} else {
+		TEST_FAIL("Invalid register in kvm_x86_pmu_feature");
+	}
 }
 
 static __always_inline uint64_t this_cpu_supported_xcr0(void)
@@ -900,12 +909,21 @@ static __always_inline bool kvm_cpu_has_p(struct kvm_x86_cpu_property property)
 	return max_leaf >= property.function;
 }
 
-static inline bool kvm_pmu_has(struct kvm_x86_pmu_feature feature)
+static inline bool kvm_pmu_has_arch_event(struct kvm_x86_pmu_feature feature)
 {
-	uint32_t nr_bits = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+	uint32_t nr_bits;
 
-	return nr_bits > feature.anti_feature.bit &&
-	       !kvm_cpu_has(feature.anti_feature);
+	if (feature.pmu_feature.reg == KVM_CPUID_EBX) {
+		nr_bits = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+		return nr_bits > feature.pmu_feature.bit &&
+			!kvm_cpu_has(feature.pmu_feature);
+	} else if (feature.pmu_feature.reg == KVM_CPUID_ECX) {
+		nr_bits = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+		return nr_bits > feature.pmu_feature.bit ||
+			kvm_cpu_has(feature.pmu_feature);
+	} else {
+		TEST_FAIL("Invalid register in kvm_x86_pmu_feature");
+	}
 }
 
 static inline size_t kvm_cpuid2_size(int nr_entries)
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 283cc55597a4..b0b91e6e79fb 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -408,7 +408,7 @@ static bool use_intel_pmu(void)
 	return host_cpu_is_intel &&
 	       kvm_cpu_property(X86_PROPERTY_PMU_VERSION) &&
 	       kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS) &&
-	       kvm_pmu_has(X86_PMU_FEATURE_BRANCH_INSNS_RETIRED);
+	       kvm_pmu_has_arch_event(X86_PMU_FEATURE_BRANCH_INSNS_RETIRED);
 }
 
 static bool is_zen1(uint32_t family, uint32_t model)
-- 
2.39.3

