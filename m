Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09D25AD313
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 14:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237862AbiIEMoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 08:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238275AbiIEMnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 08:43:16 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C82D24960;
        Mon,  5 Sep 2022 05:40:13 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id q15so8496376pfn.11;
        Mon, 05 Sep 2022 05:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ZLlyAnNZ793JZrMXvTbxQFR4/v2HJhNRk38kZVF4NEc=;
        b=CoGB00PWicobs6W/fJFKBqn58QUlWmfH0ia6jcCebcoRBXHv+hdVXOLdn3qy7FoSRB
         fJqfSW5xZYr8opZjmm/CuME0KMigPiGiadwAEpJcBY2XqiYoBLNX01wcZOyJIF+yFJQj
         RyrLBz2CQ8nEqHGt6HgrZhGyxDVOUkskJxqjy+0ABKCZf53iJHDQX2DNthPpZuiqH73R
         xGumJy/S8TEnfBQAETKu1J71jBEkyh+JX+jlCIxA0lDTJE9/HelzP0XIsnej1BD28oPo
         9cZUUZA5PqqfQuEmrxo8W2AWJuYpGYq25qVznPKdS+HCP0hy6CsuN03lXXS4ei3PKfGW
         22qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ZLlyAnNZ793JZrMXvTbxQFR4/v2HJhNRk38kZVF4NEc=;
        b=rozyNzrkDwgzsWz2VkHxcG9NKo8a+vj2graC3Rx042glAai3R+BK4bGNTvYOrgaVul
         BKH3B+Ucig12jWRSep09x618MLSoEkk4xvmGUZhVAYX5HrTcZGHq34VkEnPLHBKKNToB
         BJoDzEs4lFGow+F7UjDLPbR6LkhMGGiF0B5ms1H4X/GWLwKA6aZdLn2bnQlPgHdqCncW
         ukgCfSYGKXNr8FiXzJQHLvsiBwncOrcUeiO3uxxFtYqp5QILXcQ2ryTntjNVlsSGMAYk
         XHQp4ndXM6FuFJVc9VmHYu+P9HLqaM9fiPndcLUrT4lxizKRfufe9PmpzW8PIWF1P9MU
         qqog==
X-Gm-Message-State: ACgBeo259Vye2yZuIXkToqnWj+Krgaxx9j4s3pjI1N6/lYSs6G0+4WcR
        8GLa4DdyY6bNa6DchPPHPis=
X-Google-Smtp-Source: AA6agR5LcZ0vz1buzH2luEZJ5XY89F8e59zZrBG/yE2h/lEaRTEmku0V1DJBBHjjuKeFQabp0FcaEg==
X-Received: by 2002:a63:8643:0:b0:42b:66ab:b051 with SMTP id x64-20020a638643000000b0042b66abb051mr43002626pgd.259.1662381612570;
        Mon, 05 Sep 2022 05:40:12 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x8-20020a170902ec8800b00168dadc7354sm7428431plg.78.2022.09.05.05.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 05:40:12 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sandipan Das <sandipan.das@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022
Date:   Mon,  5 Sep 2022 20:39:44 +0800
Message-Id: <20220905123946.95223-5-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220905123946.95223-1-likexu@tencent.com>
References: <20220905123946.95223-1-likexu@tencent.com>
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

From: Sandipan Das <sandipan.das@amd.com>

CPUID leaf 0x80000022 i.e. ExtPerfMonAndDbg advertises some
new performance monitoring features for AMD processors.

Bit 0 of EAX indicates support for Performance Monitoring
Version 2 (PerfMonV2) features. If found to be set during
PMU initialization, the EBX bits of the same CPUID function
can be used to determine the number of available PMCs for
different PMU types.

Expose the relevant bits via KVM_GET_SUPPORTED_CPUID so
that guests can make use of the PerfMonV2 features.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/include/asm/perf_event.h |  8 ++++++++
 arch/x86/kvm/cpuid.c              | 21 ++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index f6fc8dd51ef4..c848f504e467 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -214,6 +214,14 @@ union cpuid_0x80000022_ebx {
 	unsigned int		full;
 };
 
+union cpuid_0x80000022_eax {
+	struct {
+		/* Performance Monitoring Version 2 Supported */
+		unsigned int	perfmon_v2:1;
+	} split;
+	unsigned int		full;
+};
+
 struct x86_pmu_capability {
 	int		version;
 	int		num_counters_gp;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 75dcf7a72605..08a29ab096d2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1094,7 +1094,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->edx = 0;
 		break;
 	case 0x80000000:
-		entry->eax = min(entry->eax, 0x80000021);
+		entry->eax = min(entry->eax, 0x80000022);
 		/*
 		 * Serializing LFENCE is reported in a multitude of ways, and
 		 * NullSegClearsBase is not reported in CPUID on Zen2; help
@@ -1203,6 +1203,25 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 			entry->eax |= BIT(6);
 		break;
+	/* AMD Extended Performance Monitoring and Debug */
+	case 0x80000022: {
+		union cpuid_0x80000022_eax eax;
+		union cpuid_0x80000022_ebx ebx;
+
+		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		if (!enable_pmu)
+			break;
+
+		if (kvm_pmu_cap.version > 1) {
+			/* AMD PerfMon is only supported up to V2 in the KVM. */
+			eax.split.perfmon_v2 = 1;
+			ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
+						     KVM_AMD_PMC_MAX_GENERIC);
+		}
+		entry->eax = eax.full;
+		entry->ebx = ebx.full;
+		break;
+	}
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
 		/*Just support up to 0xC0000004 now*/
-- 
2.37.3

