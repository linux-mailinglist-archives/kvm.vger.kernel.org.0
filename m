Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118B06DC5ED
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 12:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjDJKwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 06:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjDJKwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 06:52:08 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DF24C35;
        Mon, 10 Apr 2023 03:51:51 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-632384298b3so2128511b3a.0;
        Mon, 10 Apr 2023 03:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681123896; x=1683715896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=shTAJjoP/kMqph17lkb+8XrRhyx71EN5DXZWSR76Xz0=;
        b=M1VbOqcRBKre5yLtQKDufWY+fEKY1pEx2Mp/r4qVSt2dxuu8K3XcWP0+4mJKQoC3ag
         D3xmYigN5RbZ8aFQqMFOxn6CS/Fu5Xn1nIdLg2lPbUFhBwyIkH3wXnGMkL7D8FL78BLm
         +eJgPO96lC1GDn2UcWlSfEhXnx52zyEvU+jz/8gRltHlN0SJz9XylYdEPcQxyYsXqloG
         zPr0XaBxA/vLa0jRTyPms0oRi1QQwvaJj6ZOlCU81CMz9c5+X+vVYZZKpEYjHMc2IzIz
         4LHdDuPllZEbDJDaMxYqxjiDDilOGAVTPjit4u+lSuqpbxZMTFClBl5puuMyKyGnD70+
         sj5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681123896; x=1683715896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=shTAJjoP/kMqph17lkb+8XrRhyx71EN5DXZWSR76Xz0=;
        b=OjLGPKUm6aekPWv/fySsBrdqymVJg5YTzrv/RLREG3HJ97eQrntbuEUG6aB+g1tIfH
         +JEpjJ+W+SNnytuN/aVi50tDxp6uA+4Y+Qi0juPpE69+75TgPS3/ooPHHGnYopz16fXt
         cXfkvFKCJP2nEvTbGdLlDDay7jzVbASu23qw6Pfd5e5XB6L7raDwb2vxFszY4JgEXj8i
         aAi5XAdGhTAPUoHlNymdRjVo8Q2iP+Hg7sTWAIJyjEC/7kNCzJ+Gfxye8DkmNte2BC9i
         WpNp3RiVmnq/dimtY1uHzCwNsJAy3hYzNkjzFzKqq5dBUdR3Y4MpEKxrnqkeJ17ougrt
         BpNw==
X-Gm-Message-State: AAQBX9eCq0NUhhUrSWVXNfRhYH5qsZz4xOjKRj1MWxw/TK2NOnmdk5VT
        qA/RNnyuVVYVcR43obGgp+c=
X-Google-Smtp-Source: AKy350aVSY6Edqu5OyygBd7u0sQgZQuE0wDebTnZIjvfqaz/f3cGkLyomY0QlMAsL/H2/DuzJ8Jygw==
X-Received: by 2002:aa7:96f2:0:b0:638:62f9:6625 with SMTP id i18-20020aa796f2000000b0063862f96625mr2581607pfq.10.1681123895844;
        Mon, 10 Apr 2023 03:51:35 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00170400b0062e032b61a6sm7783252pfc.91.2023.04.10.03.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 03:51:35 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
Subject: [PATCH V5 10/10] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022
Date:   Mon, 10 Apr 2023 18:50:56 +0800
Message-Id: <20230410105056.60973-11-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230410105056.60973-1-likexu@tencent.com>
References: <20230410105056.60973-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 arch/x86/kvm/cpuid.c   | 28 +++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c |  4 ++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 52a7acf2c965..9b25036ab042 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -756,6 +756,10 @@ void kvm_set_cpu_caps(void)
 		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */
 	);
 
+	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0022_EAX,
+		F(PERFMON_V2)
+	);
+
 	/*
 	 * Synthesize "LFENCE is serializing" into the AMD-defined entry in
 	 * KVM's supported CPUID if the feature is reported as supported by the
@@ -1150,7 +1154,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->edx = 0;
 		break;
 	case 0x80000000:
-		entry->eax = min(entry->eax, 0x80000021);
+		entry->eax = min(entry->eax, 0x80000022);
 		/*
 		 * Serializing LFENCE is reported in a multitude of ways, and
 		 * NullSegClearsBase is not reported in CPUID on Zen2; help
@@ -1255,6 +1259,28 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
index 683f1b480fcb..dc1a9104c274 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4939,6 +4939,10 @@ static __init void svm_set_cpu_caps(void)
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
2.40.0

