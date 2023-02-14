Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A323C69583B
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjBNFJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbjBNFJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:09:04 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E48C17CF2;
        Mon, 13 Feb 2023 21:08:38 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso844885pju.0;
        Mon, 13 Feb 2023 21:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OWR1aZtd/m+anAz1/vi6a0lTWZtpyayUx/qgggC5GfI=;
        b=h6voPmac2HA7L2HzbWXyJ2mC5+yfbtzh8gZ9uTGuseZ4Wb82Sfwcbcp7WgAtJ7h7gZ
         4I81Yc6tRI7mblmX14vVWxjPLJuM9C+eW/izHFrB2ZSQLcEgRCyl0KvXxiVSo1+qbqEM
         iSLzKVddLvCOZDMECdfCAlAGzVPX5a43cEc8+9B7pWyzsZcT0RRTj/FMYpbq60Ouwxau
         svC+liS/RYwKjncA2j+SxjNmuoyPm18GF+vzNVaYoCgkWolW0L4XtVtjtj99w7BdmeUC
         Vd5ztPt9CcC3phiNopSEYYIMqOi471MMCJ5aCxw3qRYUOkN/Xnl+HU6WxuslupA6vY9u
         zxdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OWR1aZtd/m+anAz1/vi6a0lTWZtpyayUx/qgggC5GfI=;
        b=YTDNgmHOv5WZzJdHwVUFhnA/O81tFgLYiOhXuUYfejfx47sKlEOhP1AUDbbRjZzieJ
         Uqz/dDGiSglu5D8JaCTT8q2ZK89wTDW6dtDPzhlLnMy0OjfS01uz0CsRtBa3tAPjDD4w
         11FA9zMAmZ+ZeBLvomKeJfSs0bm40k/Cke+aUIdx9X7NnWAP5FXnj3ihEUjB3d+ymrGV
         a91/ESxC77LVDvvUBuKt8xp3XeFS9WJgPWRCAxzlLu9XRNfERBzpa0nJrJX7OgLEbm+k
         dYZY2Cn8McqQWEtLvA7eKYoK++Zeo9r4M7CiOYNewTWBj49NK08Ctq+SOcjhsY5O49Rg
         9hng==
X-Gm-Message-State: AO0yUKWMmyQ80RK0vmpNtxIfeHfOEz6fV4DpaAozAoWV3JP4x8umGC+W
        C2NZjueLrnfAAvfMsP8NwIY=
X-Google-Smtp-Source: AK7set++yByUL/EzVM8pxUT6V98JwU8tyKWO4OJq3ZuQOQfjULPGQwSCuaVK6hiI/IrU1Y8aW9m9hg==
X-Received: by 2002:a05:6a20:12d6:b0:bf:14cc:51d8 with SMTP id v22-20020a056a2012d600b000bf14cc51d8mr1181154pzg.26.1676351317268;
        Mon, 13 Feb 2023 21:08:37 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22-20020aa79296000000b005a79f5d9f53sm8738919pfa.165.2023.02.13.21.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 21:08:37 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
Subject: [PATCH v4 12/12] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022
Date:   Tue, 14 Feb 2023 13:07:57 +0800
Message-Id: <20230214050757.9623-13-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214050757.9623-1-likexu@tencent.com>
References: <20230214050757.9623-1-likexu@tencent.com>
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
 arch/x86/kvm/cpuid.c   | 24 +++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c |  6 ++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b0bb5f9f5307..274cae531d7f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1124,7 +1124,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->edx = 0;
 		break;
 	case 0x80000000:
-		entry->eax = min(entry->eax, 0x80000021);
+		entry->eax = min(entry->eax, 0x80000022);
 		/*
 		 * Serializing LFENCE is reported in a multitude of ways, and
 		 * NullSegClearsBase is not reported in CPUID on Zen2; help
@@ -1247,6 +1247,28 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 			entry->eax |= BIT(6);
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
index f4a4691b4f4e..2472fa8746c2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4916,6 +4916,12 @@ static __init void svm_set_cpu_caps(void)
 		} else {
 			/* AMD PMU PERFCTR_CORE CPUID */
 			kvm_cpu_cap_check_and_set(X86_FEATURE_PERFCTR_CORE);
+			/*
+			 * KVM only supports AMD PerfMon V2, even if it supports V3+.
+			 * For PerfMon V3+, it's unsafe to expect V2 bit is set or cleared.
+			 */
+			if (kvm_pmu_cap.version > 1)
+				kvm_cpu_cap_set(X86_FEATURE_PERFMON_V2);
 		}
 	}
 
-- 
2.39.1

