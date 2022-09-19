Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753395BC57A
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 11:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiISJf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 05:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiISJfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 05:35:20 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBE913D4D;
        Mon, 19 Sep 2022 02:35:18 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id r23so17662357pgr.6;
        Mon, 19 Sep 2022 02:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=0cqMyWQutsMAxI20YbD4ifnKYwp8U+1kDSgy/TLVs/g=;
        b=EEywciGiEQcX01vDWJmJvuVM/40CLDipwxKvk+e13qeTvMwVgtfokX0J0f/zOlBpAv
         8NQBdu5z3S1KbT2tvhvtd7yFbdn0Rjs6heHZef9Q2Q7xdI57ZnbxQzFGfP65vYVO6RPB
         YuOF08eNs9cWjB4Xbsr9EgNj0oO3RCthxYuh81J2KhGFhOnqqWoAgWeavEqqb/GK5kSi
         q0lXxdexe0GO/+h4HwYUw/BNmb1hS6fwQUZi4WQaPegKVK3xFUDGtx2fkfx6Mpidyegs
         MD9zcp+zIM6odrW7g43IRkddG8TnvNx+90bgYW5ogArvkwtttU72f4USse2NjhRD5wah
         iZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=0cqMyWQutsMAxI20YbD4ifnKYwp8U+1kDSgy/TLVs/g=;
        b=XdEeRrhZf8ai60+AAvv8TqOWqeqszDl9KtQQ4n10d8QPyPUUNJsESTiwj3s420rr23
         T4CiwZ1CN/EBFEPjBSkfO5Z/pb7jcKdC7aKUqaCPzW+SHjDtYZxn+p4S97b+1rlakFNM
         Rh65q7ZuS1nXikHEP77p7oDFHt1+77KRcEDLYWr91GLX/UQm+r3OdcW2PeJbBd00PtMn
         E1GMNxTkd1rlEAKZycUGuwQvs6YnA7uwhqhWQvLGu96j0Ovyb8W+wbRRNWUf2HaycRAE
         EWwmG9rdFC426WlaKzWIvgvRhNzaPleVUwD5cN+lTJ2XMcmVv3Sazv/VsNLFQIP5Fe+L
         MdPQ==
X-Gm-Message-State: ACrzQf3jJTQ6567TIEsjALel3WY9BH/7jPDWw/02vfNGnr46fZgcOdmQ
        vmDn+HjWxcdS+cR5oh8pxfzUKzMtTbmGMg==
X-Google-Smtp-Source: AMsMyM4RS2bsQxAeINqH2ms+NOOEVmxqmdStlqobQ5tJj5s/3dokAAeHvn4UAFhTMq++b+0ts+RGrA==
X-Received: by 2002:aa7:87d6:0:b0:53e:79bb:feb2 with SMTP id i22-20020aa787d6000000b0053e79bbfeb2mr17608236pfo.13.1663580117883;
        Mon, 19 Sep 2022 02:35:17 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w5-20020aa79545000000b0053818255880sm19815434pfq.193.2022.09.19.02.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 02:35:17 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
Subject: [PATCH v2 3/3] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022
Date:   Mon, 19 Sep 2022 17:34:53 +0800
Message-Id: <20220919093453.71737-4-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220919093453.71737-1-likexu@tencent.com>
References: <20220919093453.71737-1-likexu@tencent.com>
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

From: Sandipan Das <sandipan.das@amd.com>

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
 arch/x86/kvm/cpuid.c              | 32 ++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

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
index 75dcf7a72605..34ba845c91b7 100644
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
@@ -1203,6 +1203,36 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
+
+		if (kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE)) {
+			ebx.split.num_core_pmc = max_t(unsigned int,
+						       ebx.split.num_core_pmc,
+						       AMD64_NUM_COUNTERS_CORE);
+		} else {
+			ebx.split.num_core_pmc = max_t(unsigned int,
+						       ebx.split.num_core_pmc,
+						       AMD64_NUM_COUNTERS);
+		}
+
+		entry->eax = eax.full;
+		entry->ebx = ebx.full;
+		break;
+	}
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
 		/*Just support up to 0xC0000004 now*/
-- 
2.37.3

