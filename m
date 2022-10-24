Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13324609D9C
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiJXJNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbiJXJNg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:36 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94295C9DA
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:25 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id g16so3033862pfr.12
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H2wDWa5anhn02VmOEJnPcmUczDdx54RmT/GSoURgY3U=;
        b=ldm/rcGTCIIntLzN6owiG3h+Q6ZFb3LhNBqnj7fw1CvrDjo4OgS9WNPtfA7J1ido8Q
         6jqS+8EES7ep9I/kYCdqUhdjUJMguTcoi9CnD7om8+xPAc4pcYBwVXb7uVnVKQm5KcK6
         T4JykQSEeSAsZZGS/S70la2UCdFcdJKsTa+RtK8OX27KzoVnwS8OD9STVSJdefbmNtrt
         EzulDM7QWhI1Hu48tSvpRFRxs42z93YLdKj4MCSrkqv5PZLu8GYue9wqMTSMMhxJAlzm
         oBDXx/qU9LkmqrcmpoQdEzLUuGSw0sxz0NATKRv8TGex93h7NQ5VawIRrX5nIwUFJXj7
         EhFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H2wDWa5anhn02VmOEJnPcmUczDdx54RmT/GSoURgY3U=;
        b=ZS5HieuLYLKX4AMX47qgkuq0jSYfAds7Yw6zNrPOIrQ7ti/kfXdUuXVbSIjyFBpT4H
         f+QmhtyUKv2iEzANrPDKZXeRuIXA/2++nre2u3JnyuHNXUD/pWTZuRHtMeMSGY7AOyj1
         /gU5rWAfwolFL7dFpkw0NOdR72y2CgROJ+fCXnO3iQ19cwDa9qJWkV3mVc+Xa3nBQvHQ
         sf0tfpQRG8KseMgt+8eC8pnBYvoc0dJ2p16JMop0gwSy95e3PoM/vgpAOAjaPioRSKzb
         Bf1WviLy/n7JgjL6Tpucij/LD3eeMhJsivs+9SX254VHkE2JKsu5FEwbw7KdgwJTpwjN
         stHQ==
X-Gm-Message-State: ACrzQf3EbMNlGdlRwSzWcrzujlS79OlICB28JPFdUclA/EcQmP4n2nD1
        gVmdpQrKAX4hayWtQ3O0hlAWFqV4ceLgk29/
X-Google-Smtp-Source: AMsMyM717Hs7aIxOFDvX+okvXZObJBR5cb8WNjZiaxo2vIZrB+xzBiUaEt4vwGi0thAnIH2+Ty8TYA==
X-Received: by 2002:a05:6a00:450d:b0:562:51ad:7cdf with SMTP id cw13-20020a056a00450d00b0056251ad7cdfmr32224466pfb.54.1666602802821;
        Mon, 24 Oct 2022 02:13:22 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:22 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 13/24] x86/pmu: Add lib/x86/pmu.[c.h] and move common code to header files
Date:   Mon, 24 Oct 2022 17:12:12 +0800
Message-Id: <20221024091223.42631-14-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024091223.42631-1-likexu@tencent.com>
References: <20221024091223.42631-1-likexu@tencent.com>
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

Given all the PMU stuff coming in, we need e.g. lib/x86/pmu.h to hold all
of the hardware-defined stuff, e.g. #defines, accessors, helpers and structs
that are dictated by hardware. This will greatly help with code reuse and
reduce unnecessary vm-exit.

Opportunistically move lbr msrs definition to header processor.h.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
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
index fa1c0c8..bbe29fd 100644
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
index 0000000..9d048ab
--- /dev/null
+++ b/lib/x86/pmu.c
@@ -0,0 +1 @@
+#include "pmu.h"
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
new file mode 100644
index 0000000..078a974
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
index cb396ed..ee2b5a2 100644
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
index b7010e2..8cbdd2a 100644
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
index 3b36caa..46e9fca 100644
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
index a641d79..e6d9823 100644
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
index aa2ecbb..fd36e43 100644
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
2.38.1

