Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492B86170EB
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiKBWwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbiKBWvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:49 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0986DF83
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:37 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id n4-20020a17090a2fc400b002132adb9485so60893pjm.0
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=d0BfQE/JP2ctvVG1QvgxNQYqN5Egjcns/Jz1HDegAR4=;
        b=T8Iceg513g0kfAJdRT5Qpxx8NpLzeZ8HlGHGRpp1zGXZoCwSGc5Y/hsTJGgD15tMp4
         H0EOqGHyrTocV1zh6InqHpIjhVlsSgl6bLFkWh5OETwiqazFjIED0mtOKAfxnaNMunoq
         ddZfrso2KvoCFMfR3N4vOP/ExKXJnY3CAztQVZDbbKAQ+HoItsrBuKO4LQiqGJzRI+IV
         ntEkbskv+VHpXRHmOib7Vp0flYeY1Y3NDbm+8kCWN/EzOz10cko4OvrTjLlE+krsJmR2
         YNafwgsgHNywxwqdbjeFaXXzjpJbo5X0vOxs3dg+7HW9ucZ0ZVkSX6cH4YX19OOqsZqM
         avQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d0BfQE/JP2ctvVG1QvgxNQYqN5Egjcns/Jz1HDegAR4=;
        b=6F5d/MvALgBIgsMT/QZUS/NABMMsX+RgW5+lyIzGM/d5cK8eq6nPfR9RBki8edPLLX
         Kq50lhgWlgnzdt6Axe32P6//3bEBPcsHAzeZxNQIsiGyHYz+TCQIUqY8CYlCW9IINUdr
         PBR1qySnBFcIgjsHkiOUQsyL2+nWLjZUGhGV5QSageCzUx8tyrcPLttn9XzUeA6+SQdI
         IJr12bWK8dOX7cfAnlCexb4GKsi4Ykfrh2m9ONMUZyo0r/7grHJbgjRLZnItlb/askfN
         /ZaTy4hIS9CIE4MdoBoF+X+VpVJR+Z4tUdimt/0X/ZOI0IVRageONbM8QATAhNBBM52k
         eVwg==
X-Gm-Message-State: ACrzQf3we3Daa/PkVbibfOARt6I+tE3dxjA8/LSHUaWcnNdOtczIu0Cp
        vlZuIz/KT1OSyS0ZPKNtHw5Q3MbfnwY=
X-Google-Smtp-Source: AMsMyM4QerU7knYUygXG0TinFXJGmHjGwv2hDjfvQ+FL7Na1JaQrMaPYa/lS/qJuBozHMH4O/qLQkxkW0wI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2303:b0:186:ed93:fc46 with SMTP id
 d3-20020a170903230300b00186ed93fc46mr25885308plh.172.1667429497436; Wed, 02
 Nov 2022 15:51:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:56 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-14-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 13/27] x86/pmu: Add lib/x86/pmu.[c.h] and
 move common code to header files
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Given all the PMU stuff coming in, we need e.g. lib/x86/pmu.h to hold all
of the hardware-defined stuff, e.g. #defines, accessors, helpers and structs
that are dictated by hardware. This will greatly help with code reuse and
reduce unnecessary vm-exit.

Opportunistically move lbr msrs definition to header processor.h.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/msr.h       |   7 ++++
 lib/x86/pmu.c       |   1 +
 lib/x86/pmu.h       | 100 ++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/processor.h |  64 ----------------------------
 x86/Makefile.common |   1 +
 x86/pmu.c           |  25 +----------
 x86/pmu_lbr.c       |  11 +----
 x86/vmx_tests.c     |   1 +
 8 files changed, 112 insertions(+), 98 deletions(-)
 create mode 100644 lib/x86/pmu.c
 create mode 100644 lib/x86/pmu.h

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index fa1c0c81..bbe29fd9 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -86,6 +86,13 @@
 #define DEBUGCTLMSR_BTS_OFF_USR		(1UL << 10)
 #define DEBUGCTLMSR_FREEZE_LBRS_ON_PMI	(1UL << 11)
 
+#define MSR_LBR_NHM_FROM	0x00000680
+#define MSR_LBR_NHM_TO		0x000006c0
+#define MSR_LBR_CORE_FROM	0x00000040
+#define MSR_LBR_CORE_TO	0x00000060
+#define MSR_LBR_TOS		0x000001c9
+#define MSR_LBR_SELECT		0x000001c8
+
 #define MSR_IA32_MC0_CTL		0x00000400
 #define MSR_IA32_MC0_STATUS		0x00000401
 #define MSR_IA32_MC0_ADDR		0x00000402
diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
new file mode 100644
index 00000000..9d048abc
--- /dev/null
+++ b/lib/x86/pmu.c
@@ -0,0 +1 @@
+#include "pmu.h"
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
new file mode 100644
index 00000000..078a9747
--- /dev/null
+++ b/lib/x86/pmu.h
@@ -0,0 +1,100 @@
+#ifndef _X86_PMU_H_
+#define _X86_PMU_H_
+
+#include "processor.h"
+#include "libcflat.h"
+
+#define FIXED_CNT_INDEX 32
+#define MAX_NUM_LBR_ENTRY	  32
+
+/* Performance Counter Vector for the LVT PC Register */
+#define PMI_VECTOR	32
+
+#define DEBUGCTLMSR_LBR	  (1UL <<  0)
+
+#define PMU_CAP_LBR_FMT	  0x3f
+#define PMU_CAP_FW_WRITES	(1ULL << 13)
+
+#define EVNSEL_EVENT_SHIFT	0
+#define EVNTSEL_UMASK_SHIFT	8
+#define EVNTSEL_USR_SHIFT	16
+#define EVNTSEL_OS_SHIFT	17
+#define EVNTSEL_EDGE_SHIFT	18
+#define EVNTSEL_PC_SHIFT	19
+#define EVNTSEL_INT_SHIFT	20
+#define EVNTSEL_EN_SHIF		22
+#define EVNTSEL_INV_SHIF	23
+#define EVNTSEL_CMASK_SHIFT	24
+
+#define EVNTSEL_EN	(1 << EVNTSEL_EN_SHIF)
+#define EVNTSEL_USR	(1 << EVNTSEL_USR_SHIFT)
+#define EVNTSEL_OS	(1 << EVNTSEL_OS_SHIFT)
+#define EVNTSEL_PC	(1 << EVNTSEL_PC_SHIFT)
+#define EVNTSEL_INT	(1 << EVNTSEL_INT_SHIFT)
+#define EVNTSEL_INV	(1 << EVNTSEL_INV_SHIF)
+
+static inline u8 pmu_version(void)
+{
+	return cpuid(10).a & 0xff;
+}
+
+static inline bool this_cpu_has_pmu(void)
+{
+	return !!pmu_version();
+}
+
+static inline bool this_cpu_has_perf_global_ctrl(void)
+{
+	return pmu_version() > 1;
+}
+
+static inline u8 pmu_nr_gp_counters(void)
+{
+	return (cpuid(10).a >> 8) & 0xff;
+}
+
+static inline u8 pmu_gp_counter_width(void)
+{
+	return (cpuid(10).a >> 16) & 0xff;
+}
+
+static inline u8 pmu_gp_counter_mask_length(void)
+{
+	return (cpuid(10).a >> 24) & 0xff;
+}
+
+static inline u8 pmu_nr_fixed_counters(void)
+{
+	struct cpuid id = cpuid(10);
+
+	if ((id.a & 0xff) > 1)
+		return id.d & 0x1f;
+	else
+		return 0;
+}
+
+static inline u8 pmu_fixed_counter_width(void)
+{
+	struct cpuid id = cpuid(10);
+
+	if ((id.a & 0xff) > 1)
+		return (id.d >> 5) & 0xff;
+	else
+		return 0;
+}
+
+static inline bool pmu_gp_counter_is_available(int i)
+{
+	/* CPUID.0xA.EBX bit is '1 if they counter is NOT available. */
+	return !(cpuid(10).b & BIT(i));
+}
+
+static inline u64 this_cpu_perf_capabilities(void)
+{
+	if (!this_cpu_has(X86_FEATURE_PDCM))
+		return 0;
+
+	return rdmsr(MSR_IA32_PERF_CAPABILITIES);
+}
+
+#endif /* _X86_PMU_H_ */
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index ba14c7a0..c0716663 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -806,68 +806,4 @@ static inline void flush_tlb(void)
 	write_cr4(cr4);
 }
 
-static inline u8 pmu_version(void)
-{
-	return cpuid(10).a & 0xff;
-}
-
-static inline bool this_cpu_has_pmu(void)
-{
-	return !!pmu_version();
-}
-
-static inline bool this_cpu_has_perf_global_ctrl(void)
-{
-	return pmu_version() > 1;
-}
-
-static inline u8 pmu_nr_gp_counters(void)
-{
-	return (cpuid(10).a >> 8) & 0xff;
-}
-
-static inline u8 pmu_gp_counter_width(void)
-{
-	return (cpuid(10).a >> 16) & 0xff;
-}
-
-static inline u8 pmu_gp_counter_mask_length(void)
-{
-	return (cpuid(10).a >> 24) & 0xff;
-}
-
-static inline u8 pmu_nr_fixed_counters(void)
-{
-	struct cpuid id = cpuid(10);
-
-	if ((id.a & 0xff) > 1)
-		return id.d & 0x1f;
-	else
-		return 0;
-}
-
-static inline u8 pmu_fixed_counter_width(void)
-{
-	struct cpuid id = cpuid(10);
-
-	if ((id.a & 0xff) > 1)
-		return (id.d >> 5) & 0xff;
-	else
-		return 0;
-}
-
-static inline bool pmu_gp_counter_is_available(int i)
-{
-	/* CPUID.0xA.EBX bit is '1 if they counter is NOT available. */
-	return !(cpuid(10).b & BIT(i));
-}
-
-static inline u64 this_cpu_perf_capabilities(void)
-{
-	if (!this_cpu_has(X86_FEATURE_PDCM))
-		return 0;
-
-	return rdmsr(MSR_IA32_PERF_CAPABILITIES);
-}
-
 #endif
diff --git a/x86/Makefile.common b/x86/Makefile.common
index b7010e2f..8cbdd2a9 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -22,6 +22,7 @@ cflatobjs += lib/x86/acpi.o
 cflatobjs += lib/x86/stack.o
 cflatobjs += lib/x86/fault_test.o
 cflatobjs += lib/x86/delay.o
+cflatobjs += lib/x86/pmu.o
 ifeq ($(CONFIG_EFI),y)
 cflatobjs += lib/x86/amd_sev.o
 cflatobjs += lib/efi.o
diff --git a/x86/pmu.c b/x86/pmu.c
index b5828a14..7d67746e 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -1,6 +1,7 @@
 
 #include "x86/msr.h"
 #include "x86/processor.h"
+#include "x86/pmu.h"
 #include "x86/apic-defs.h"
 #include "x86/apic.h"
 #include "x86/desc.h"
@@ -10,29 +11,6 @@
 #include "libcflat.h"
 #include <stdint.h>
 
-#define FIXED_CNT_INDEX 32
-
-/* Performance Counter Vector for the LVT PC Register */
-#define PMI_VECTOR	32
-
-#define EVNSEL_EVENT_SHIFT	0
-#define EVNTSEL_UMASK_SHIFT	8
-#define EVNTSEL_USR_SHIFT	16
-#define EVNTSEL_OS_SHIFT	17
-#define EVNTSEL_EDGE_SHIFT	18
-#define EVNTSEL_PC_SHIFT	19
-#define EVNTSEL_INT_SHIFT	20
-#define EVNTSEL_EN_SHIF		22
-#define EVNTSEL_INV_SHIF	23
-#define EVNTSEL_CMASK_SHIFT	24
-
-#define EVNTSEL_EN	(1 << EVNTSEL_EN_SHIF)
-#define EVNTSEL_USR	(1 << EVNTSEL_USR_SHIFT)
-#define EVNTSEL_OS	(1 << EVNTSEL_OS_SHIFT)
-#define EVNTSEL_PC	(1 << EVNTSEL_PC_SHIFT)
-#define EVNTSEL_INT	(1 << EVNTSEL_INT_SHIFT)
-#define EVNTSEL_INV	(1 << EVNTSEL_INV_SHIF)
-
 #define N 1000000
 
 // These values match the number of instructions and branches in the
@@ -66,7 +44,6 @@ struct pmu_event {
 	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
 };
 
-#define PMU_CAP_FW_WRITES	(1ULL << 13)
 static u64 gp_counter_base = MSR_IA32_PERFCTR0;
 
 char *buf;
diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index a641d793..e6d98236 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -1,18 +1,9 @@
 #include "x86/msr.h"
 #include "x86/processor.h"
+#include "x86/pmu.h"
 #include "x86/desc.h"
 
 #define N 1000000
-#define MAX_NUM_LBR_ENTRY	  32
-#define DEBUGCTLMSR_LBR	  (1UL <<  0)
-#define PMU_CAP_LBR_FMT	  0x3f
-
-#define MSR_LBR_NHM_FROM	0x00000680
-#define MSR_LBR_NHM_TO		0x000006c0
-#define MSR_LBR_CORE_FROM	0x00000040
-#define MSR_LBR_CORE_TO	0x00000060
-#define MSR_LBR_TOS		0x000001c9
-#define MSR_LBR_SELECT		0x000001c8
 
 volatile int count;
 u32 lbr_from, lbr_to;
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index aa2ecbbc..fd36e436 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -9,6 +9,7 @@
 #include "vmx.h"
 #include "msr.h"
 #include "processor.h"
+#include "pmu.h"
 #include "vm.h"
 #include "pci.h"
 #include "fwcfg.h"
-- 
2.38.1.431.g37b22c650d-goog

