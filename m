Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B957F57365C
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 14:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbiGMM0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 08:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236435AbiGMMZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 08:25:54 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AB7EBBEE;
        Wed, 13 Jul 2022 05:25:46 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id b9so10076449pfp.10;
        Wed, 13 Jul 2022 05:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mLfv4gYeDItEgVRz9PItH5aCwae3B43Nv7NY39XpJ2k=;
        b=MmmpCkVPM08TYlivHR0ecqR0HXLSwGhKYmdjfwDbYwp+JTwsgf43AqGdohw6D34dcl
         8jH4vtDWyTmSFHdsnTHAqueAh5g8m0j+gL7QzeLev6gccaDJoSTaKRW3MCk+OcheHJmy
         oSM2se23+ReSpr3juvIainV1V58MCQ8QGUMZ4LuU5tDbubIxf1upnCOvwSGcq/0tppJK
         svFiJAofLQ5nRnLdXoK+3zdu/X22ngPFZ+x7+Jewv84PDYhJtyAYbDhWJmYVmsiK8gPx
         yDaJ3NYrKvHgb0Xv5JiLW6O/PnNoP8JOoFjZh3/bv9nbgocm2h40i4l8wdy6/LcwmYrb
         KW9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mLfv4gYeDItEgVRz9PItH5aCwae3B43Nv7NY39XpJ2k=;
        b=ANKhE0Eoyeg/JLjKlCGV1kPW1lasDQ09xz+MAsDs/GQH5BbTIdpY0c74eZmRJz/m/Q
         CbDv/K9i246m70/5GWS96v99LQC9/2alLClkgr3KrpreOm2oz0/9QjlTS0/CWWlkaIMn
         X8hL6xulNyAO2zsrgTY4izlqkdLZF6bIN1zuZbY1UA7Gm/Q3lyf3MH/FRHVFPFTnffwg
         TRhE5X1YmlXv94WxqjxINWKVueEQX5HOsUlgHwWpd1PWFxAFegt5gOiGKNb7wSowhjKK
         swdsW4xSXgfxTZGa57QehhNzy0O9aPF4/6hrWxTdiQ4Dn2z7GT6HrIIjHYw1sxFwKuEi
         Mwvg==
X-Gm-Message-State: AJIora9pc93TKdN/O1LqhsEn92yBKdw0T4tBWH4Svhe2BrG2by2sy0uU
        yRv13w2q9CV1KJAVhClwoQ0=
X-Google-Smtp-Source: AGRyM1shYNUzgPefO3LCFzU/EYXhJ9YTO32t47FM1lZmrUvuKKM+dQr9pB4C+tNR96AT5rryeIus0Q==
X-Received: by 2002:a05:6a00:1248:b0:52b:ca7:f2b6 with SMTP id u8-20020a056a00124800b0052b0ca7f2b6mr2243449pfi.82.1657715145801;
        Wed, 13 Jul 2022 05:25:45 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902bb8700b0016bf1ed3489sm8719233pls.143.2022.07.13.05.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 05:25:45 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [kvm-unit-tests PATCH] x86: Add tests for Guest Processor Event Based Sampling (PEBS)
Date:   Wed, 13 Jul 2022 20:25:07 +0800
Message-Id: <20220713122507.29236-9-likexu@tencent.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713122507.29236-1-likexu@tencent.com>
References: <20220713122507.29236-1-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

This unit-test is intended to test the KVM's support for
the Processor Event Based Sampling (PEBS) which is another
PMU feature on Intel processors (start from Ice Lake Server).

If a bit in PEBS_ENABLE is set to 1, its corresponding counter will
write at least one PEBS records (including partial state of the vcpu
at the time of the current hardware event) to the guest memory on
counter overflow, and trigger an interrupt at a specific DS state.
The format of a PEBS record can be configured by another register.

These tests cover most usage scenarios, for example there are some
specially constructed scenarios (not a typical behaviour of Linux 
PEBS driver). It lowers the threshold for others to understand this
feature and opens up more exploration of KVM implementation or
hw feature itself.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 lib/x86/msr.h       |   1 +
 x86/Makefile.x86_64 |   1 +
 x86/pmu_pebs.c      | 511 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |   7 +
 4 files changed, 520 insertions(+)
 create mode 100644 x86/pmu_pebs.c

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index fa1c0c8..252e041 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -52,6 +52,7 @@
 #define MSR_IA32_MCG_CTL		0x0000017b
 
 #define MSR_IA32_PEBS_ENABLE		0x000003f1
+#define MSR_PEBS_DATA_CFG		0x000003f2
 #define MSR_IA32_DS_AREA		0x00000600
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
 
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index e19284a..c82c274 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -33,6 +33,7 @@ tests += $(TEST_DIR)/vmware_backdoors.$(exe)
 tests += $(TEST_DIR)/rdpru.$(exe)
 tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
+tests += $(TEST_DIR)/pmu_pebs.$(exe)
 
 ifeq ($(CONFIG_EFI),y)
 tests += $(TEST_DIR)/amd_sev.$(exe)
diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
new file mode 100644
index 0000000..5498bb0
--- /dev/null
+++ b/x86/pmu_pebs.c
@@ -0,0 +1,511 @@
+#include "x86/msr.h"
+#include "x86/processor.h"
+#include "x86/isr.h"
+#include "x86/apic.h"
+#include "x86/apic-defs.h"
+#include "x86/desc.h"
+#include "alloc.h"
+
+#include "vm.h"
+#include "types.h"
+#include "processor.h"
+#include "vmalloc.h"
+#include "alloc_page.h"
+
+#define PC_VECTOR	32
+
+#define	X86_FEATURE_PDCM		(CPUID(0x1, 0, ECX, 15))
+
+#define PERF_CAP_PEBS_FORMAT           0xf00
+#define PMU_CAP_FW_WRITES	(1ULL << 13)
+
+#define INTEL_PMC_IDX_FIXED				       32
+
+#define GLOBAL_STATUS_BUFFER_OVF_BIT		62
+#define GLOBAL_STATUS_BUFFER_OVF	BIT_ULL(GLOBAL_STATUS_BUFFER_OVF_BIT)
+
+#define EVNTSEL_USR_SHIFT       16
+#define EVNTSEL_OS_SHIFT        17
+#define EVNTSEL_EN_SHIF         22
+
+#define EVNTSEL_EN      (1 << EVNTSEL_EN_SHIF)
+#define EVNTSEL_USR     (1 << EVNTSEL_USR_SHIFT)
+#define EVNTSEL_OS      (1 << EVNTSEL_OS_SHIFT)
+
+#define PEBS_DATACFG_MEMINFO	BIT_ULL(0)
+#define PEBS_DATACFG_GP	BIT_ULL(1)
+#define PEBS_DATACFG_XMMS	BIT_ULL(2)
+#define PEBS_DATACFG_LBRS	BIT_ULL(3)
+
+#define ICL_EVENTSEL_ADAPTIVE				(1ULL << 34)
+#define PEBS_DATACFG_LBR_SHIFT	24
+#define MAX_NUM_LBR_ENTRY	32
+
+union perf_capabilities {
+	struct {
+		u64	lbr_format:6;
+		u64	pebs_trap:1;
+		u64	pebs_arch_reg:1;
+		u64	pebs_format:4;
+		u64	smm_freeze:1;
+		/*
+		 * PMU supports separate counter range for writing
+		 * values > 32bit.
+		 */
+		u64	full_width_write:1;
+		u64 pebs_baseline:1;
+		u64	perf_metrics:1;
+		u64	pebs_output_pt_available:1;
+		u64	anythread_deprecated:1;
+	};
+	u64	capabilities;
+};
+
+union cpuid10_eax {
+        struct {
+                unsigned int version_id:8;
+                unsigned int num_counters:8;
+                unsigned int bit_width:8;
+                unsigned int mask_length:8;
+        } split;
+        unsigned int full;
+} pmu_eax;
+
+union cpuid10_edx {
+        struct {
+                unsigned int num_counters_fixed:5;
+                unsigned int bit_width_fixed:8;
+                unsigned int reserved:19;
+        } split;
+        unsigned int full;
+} pmu_edx;
+
+static u64 gp_counter_base = MSR_IA32_PERFCTR0;
+static union perf_capabilities perf;
+static unsigned int max_nr_gp_events;
+static unsigned long *ds_bufer;
+static unsigned long *pebs_buffer;
+static u64 ctr_start_val;
+
+struct debug_store {
+	u64	bts_buffer_base;
+	u64	bts_index;
+	u64	bts_absolute_maximum;
+	u64	bts_interrupt_threshold;
+	u64	pebs_buffer_base;
+	u64	pebs_index;
+	u64	pebs_absolute_maximum;
+	u64	pebs_interrupt_threshold;
+	u64	pebs_event_reset[64];
+};
+
+struct pebs_basic {
+	u64 format_size;
+	u64 ip;
+	u64 applicable_counters;
+	u64 tsc;
+};
+
+struct pebs_meminfo {
+	u64 address;
+	u64 aux;
+	u64 latency;
+	u64 tsx_tuning;
+};
+
+struct pebs_gprs {
+	u64 flags, ip, ax, cx, dx, bx, sp, bp, si, di;
+	u64 r8, r9, r10, r11, r12, r13, r14, r15;
+};
+
+struct pebs_xmm {
+	u64 xmm[16*2];	/* two entries for each register */
+};
+
+struct lbr_entry {
+	u64 from;
+	u64 to;
+	u64 info;
+};
+
+enum pmc_type {
+	GP = 0,
+	FIXED,
+};
+
+static uint32_t intel_arch_events[] = {
+	0x00c4, /* PERF_COUNT_HW_BRANCH_INSTRUCTIONS */
+	0x00c5, /* PERF_COUNT_HW_BRANCH_MISSES */
+	0x0300, /* PERF_COUNT_HW_REF_CPU_CYCLES */
+	0x003c, /* PERF_COUNT_HW_CPU_CYCLES */
+	0x00c0, /* PERF_COUNT_HW_INSTRUCTIONS */
+	0x013c, /* PERF_COUNT_HW_BUS_CYCLES */
+	0x4f2e, /* PERF_COUNT_HW_CACHE_REFERENCES */
+	0x412e, /* PERF_COUNT_HW_CACHE_MISSES */
+};
+
+static u64 pebs_data_cfgs[] = {
+	PEBS_DATACFG_MEMINFO,
+	PEBS_DATACFG_GP,
+	PEBS_DATACFG_XMMS,
+	PEBS_DATACFG_LBRS | ((MAX_NUM_LBR_ENTRY -1) << PEBS_DATACFG_LBR_SHIFT),
+};
+
+/* Iterating each counter value is a waste of time, pick a few typical values. */
+static u64 counter_start_values[] = {
+	/* if PEBS counter doesn't overflow at all */
+	0,
+	0xfffffffffff0,
+	/* normal counter overflow to have PEBS records */
+	0xfffffffffffe,
+	/* test whether emulated instructions should trigger PEBS */
+	0xffffffffffff,
+};
+
+static unsigned int get_adaptive_pebs_record_size(u64 pebs_data_cfg)
+{
+	unsigned int sz = sizeof(struct pebs_basic);
+
+	if (!perf.pebs_baseline)
+		return sz;
+
+	if (pebs_data_cfg & PEBS_DATACFG_MEMINFO)
+		sz += sizeof(struct pebs_meminfo);
+	if (pebs_data_cfg & PEBS_DATACFG_GP)
+		sz += sizeof(struct pebs_gprs);
+	if (pebs_data_cfg & PEBS_DATACFG_XMMS)
+		sz += sizeof(struct pebs_xmm);
+	if (pebs_data_cfg & PEBS_DATACFG_LBRS)
+		sz += MAX_NUM_LBR_ENTRY * sizeof(struct lbr_entry);
+
+	return sz;
+}
+
+static void cnt_overflow(isr_regs_t *regs)
+{
+	apic_write(APIC_EOI, 0);
+}
+
+static inline void workload(void)
+{
+	asm volatile(
+		"mov $0x0, %%eax\n"
+		"cmp $0x0, %%eax\n"
+		"jne label2\n"
+		"jne label2\n"
+		"jne label2\n"
+		"jne label2\n"
+		"mov $0x0, %%eax\n"
+		"cmp $0x0, %%eax\n"
+		"jne label2\n"
+		"jne label2\n"
+		"jne label2\n"
+		"jne label2\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"label2:\n"
+		:
+		:
+		: "eax", "ebx", "ecx", "edx");
+}
+
+static inline void workload2(void)
+{
+	asm volatile(
+		"mov $0x0, %%eax\n"
+		"cmp $0x0, %%eax\n"
+		"jne label3\n"
+		"jne label3\n"
+		"jne label3\n"
+		"jne label3\n"
+		"mov $0x0, %%eax\n"
+		"cmp $0x0, %%eax\n"
+		"jne label3\n"
+		"jne label3\n"
+		"jne label3\n"
+		"jne label3\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"label3:\n"
+		:
+		:
+		: "eax", "ebx", "ecx", "edx");
+}
+
+static void alloc_buffers(void)
+{
+	ds_bufer = alloc_page();
+	force_4k_page(ds_bufer);
+	memset(ds_bufer, 0x0, PAGE_SIZE);
+
+	pebs_buffer = alloc_page();
+	force_4k_page(pebs_buffer);
+	memset(pebs_buffer, 0x0, PAGE_SIZE);
+}
+
+static void free_buffers(void)
+{
+	if (ds_bufer)
+		free_page(ds_bufer);
+
+	if (pebs_buffer)
+		free_page(pebs_buffer);
+}
+
+static void pebs_enable(u64 bitmask, u64 pebs_data_cfg)
+{
+	static struct debug_store *ds;
+	u64 baseline_extra_ctrl, fixed_ctr_ctrl = 0;
+	unsigned int idx;
+
+	if (perf.pebs_baseline)
+		wrmsr(MSR_PEBS_DATA_CFG, pebs_data_cfg);
+
+	ds = (struct debug_store *)ds_bufer;
+	ds->pebs_index = ds->pebs_buffer_base = (unsigned long)pebs_buffer;
+	ds->pebs_absolute_maximum = (unsigned long)pebs_buffer + PAGE_SIZE;
+	ds->pebs_interrupt_threshold = ds->pebs_buffer_base +
+		get_adaptive_pebs_record_size(pebs_data_cfg);
+
+	for (idx = 0; idx < pmu_edx.split.num_counters_fixed; idx++) {
+		if (!(BIT_ULL(INTEL_PMC_IDX_FIXED + idx) & bitmask))
+			continue;
+		baseline_extra_ctrl = perf.pebs_baseline ?
+			(1ULL << (INTEL_PMC_IDX_FIXED + idx * 4)) : 0;
+		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + idx, ctr_start_val);
+		fixed_ctr_ctrl |= (0xbULL << (idx * 4) | baseline_extra_ctrl);
+	}
+	if (fixed_ctr_ctrl)
+		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, fixed_ctr_ctrl);
+
+	for (idx = 0; idx < max_nr_gp_events; idx++) {
+		if (!(BIT_ULL(idx) & bitmask))
+			continue;
+		baseline_extra_ctrl = perf.pebs_baseline ?
+			ICL_EVENTSEL_ADAPTIVE : 0;
+		wrmsr(MSR_P6_EVNTSEL0 + idx,
+		      EVNTSEL_EN | EVNTSEL_OS | EVNTSEL_USR |
+		      intel_arch_events[idx] | baseline_extra_ctrl);
+		wrmsr(gp_counter_base + idx, ctr_start_val);
+	}
+
+	wrmsr(MSR_IA32_DS_AREA,  (unsigned long)ds_bufer);
+	wrmsr(MSR_IA32_PEBS_ENABLE, bitmask);
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, bitmask);
+}
+
+static void pmu_env_cleanup(void)
+{
+	unsigned int idx;
+
+	memset(ds_bufer, 0x0, PAGE_SIZE);
+	memset(pebs_buffer, 0x0, PAGE_SIZE);
+	wrmsr(MSR_IA32_PEBS_ENABLE, 0);
+	wrmsr(MSR_IA32_DS_AREA,  0);
+	if (perf.pebs_baseline)
+		wrmsr(MSR_PEBS_DATA_CFG, 0);
+
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+
+	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
+	for (idx = 0; idx < pmu_edx.split.num_counters_fixed; idx++) {
+		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + idx, 0);
+	}
+
+	for (idx = 0; idx < pmu_eax.split.num_counters; idx++) {
+		wrmsr(MSR_P6_EVNTSEL0 + idx, 0);
+		wrmsr(MSR_IA32_PERFCTR0 + idx, 0);
+	}
+
+	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+}
+
+static inline void pebs_disable_1(void)
+{
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+}
+
+static inline void pebs_disable_2(void)
+{
+	wrmsr(MSR_IA32_PEBS_ENABLE, 0);
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+}
+
+static void pebs_disable(unsigned int idx)
+{
+	if (idx % 2) {
+		pebs_disable_1();
+	} else {
+		pebs_disable_2();
+	}
+}
+
+static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg)
+{
+	struct pebs_basic *pebs_rec = (struct pebs_basic *)pebs_buffer;
+	struct debug_store *ds = (struct debug_store *)ds_bufer;
+	unsigned int pebs_record_size = get_adaptive_pebs_record_size(pebs_data_cfg);
+	unsigned int count = 0;
+	bool expected, pebs_idx_match, pebs_size_match, data_cfg_match;
+	void *vernier;
+
+	expected = (ds->pebs_index == ds->pebs_buffer_base) && !pebs_rec->format_size;
+	if (!(rdmsr(MSR_CORE_PERF_GLOBAL_STATUS) & GLOBAL_STATUS_BUFFER_OVF)) {
+		report(expected, "No OVF irq, none PEBS records.");
+		return;
+	}
+
+	if (expected) {
+		report(!expected, "A OVF irq, but none PEBS records.");
+		return;
+	}
+
+	expected = ds->pebs_index >= ds->pebs_interrupt_threshold;
+	vernier = (void *)pebs_buffer;
+	do {
+		pebs_rec = (struct pebs_basic *)vernier;
+		pebs_record_size = pebs_rec->format_size >> 48;
+		pebs_idx_match =
+			pebs_rec->applicable_counters & bitmask;
+		pebs_size_match =
+			pebs_record_size == get_adaptive_pebs_record_size(pebs_data_cfg);
+		data_cfg_match =
+			(pebs_rec->format_size & 0xffffffffffff) == pebs_data_cfg;
+		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
+		report(expected,
+		       "PEBS record (written seq %d) is verified (inclduing size, counters and cfg).", count);
+		vernier = vernier + pebs_record_size;
+		count++;
+	} while (expected && (void *)vernier < (void *)ds->pebs_index);
+
+	if (!expected) {
+		if (!pebs_idx_match)
+			printf("FAIL: The applicable_counters (0x%lx) doesn't match with pmc_bitmask (0x%lx).\n",
+			       pebs_rec->applicable_counters, bitmask);
+		if (!pebs_size_match)
+			printf("FAIL: The pebs_record_size (%d) doesn't match with MSR_PEBS_DATA_CFG (%d).\n",
+			       pebs_record_size, get_adaptive_pebs_record_size(pebs_data_cfg));
+		if (!data_cfg_match)
+			printf("FAIL: The pebs_data_cfg (0x%lx) doesn't match with MSR_PEBS_DATA_CFG (0x%lx).\n",
+			       pebs_rec->format_size & 0xffffffffffff, pebs_data_cfg);
+	}
+}
+
+static void check_one_counter(enum pmc_type type,
+			      unsigned int idx, u64 pebs_data_cfg)
+{
+	report_prefix_pushf("%s counter %d (0x%lx)",
+			    type == FIXED ? "Extended Fixed" : "GP", idx, ctr_start_val);
+	pmu_env_cleanup();
+	pebs_enable(BIT_ULL(type == FIXED ? INTEL_PMC_IDX_FIXED + idx : idx), pebs_data_cfg);
+	workload();
+	pebs_disable(idx);
+	check_pebs_records(BIT_ULL(type == FIXED ? INTEL_PMC_IDX_FIXED + idx : idx), pebs_data_cfg);
+	report_prefix_pop();
+}
+
+static void check_multiple_counters(u64 bitmask, u64 pebs_data_cfg)
+{
+	pmu_env_cleanup();
+	pebs_enable(bitmask, pebs_data_cfg);
+	workload2();
+	pebs_disable(0);
+	check_pebs_records(bitmask, pebs_data_cfg);
+}
+
+static void check_pebs_counters(u64 pebs_data_cfg)
+{
+	unsigned int idx;
+	u64 bitmask = 0;
+
+	for (idx = 0; idx < pmu_edx.split.num_counters_fixed; idx++)
+		check_one_counter(FIXED, idx, pebs_data_cfg);
+
+	for (idx = 0; idx < max_nr_gp_events; idx++)
+		check_one_counter(GP, idx, pebs_data_cfg);
+
+	for (idx = 0; idx < pmu_edx.split.num_counters_fixed; idx++)
+		bitmask |= BIT_ULL(INTEL_PMC_IDX_FIXED + idx);
+	for (idx = 0; idx < max_nr_gp_events; idx += 2)
+		bitmask |= BIT_ULL(idx);
+	report_prefix_pushf("Multiple (0x%lx)", bitmask);
+	check_multiple_counters(bitmask, pebs_data_cfg);
+	report_prefix_pop();
+}
+
+int main(int ac, char **av)
+{
+	struct cpuid id;
+	unsigned int i, j;
+
+	setup_vm();
+	id = cpuid(10);
+
+	pmu_eax.full = id.a;
+	pmu_edx.full = id.d;
+	max_nr_gp_events = MIN(pmu_eax.split.num_counters, ARRAY_SIZE(intel_arch_events));
+
+	printf("PMU version: %d\n", pmu_eax.split.version_id);
+	if (this_cpu_has(X86_FEATURE_PDCM))
+		perf.capabilities = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+
+	if (perf.capabilities & PMU_CAP_FW_WRITES)
+		gp_counter_base = MSR_IA32_PMC0;
+
+	if (!is_intel() || (pmu_eax.split.version_id < 2) ||
+	    !(perf.capabilities & PERF_CAP_PEBS_FORMAT) ||
+	    (rdmsr(MSR_IA32_MISC_ENABLE) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL)) {
+		report_skip("This platform doesn't support guest PEBS.");
+		return 0;
+	}
+
+	printf("PEBS format: %d\n", perf.pebs_format);
+	printf("PEBS GP counters: %d\n", pmu_eax.split.num_counters);
+	printf("PEBS Fixed counters: %d\n", pmu_edx.split.num_counters_fixed);
+	printf("PEBS baseline (Adaptive PEBS): %d\n", perf.pebs_baseline);
+
+	printf("Known reasons for none PEBS records:\n");
+	printf("1. The selected event does not support PEBS;\n");
+	printf("2. From a core pmu perspective, the vCPU and pCPU models are not same;\n");
+	printf("3. Guest counter has not yet overflowed or been cross-mapped by the host;\n");
+
+	handle_irq(PC_VECTOR, cnt_overflow);
+	alloc_buffers();
+
+	for (i = 0; i < ARRAY_SIZE(counter_start_values); i++) {
+		ctr_start_val = counter_start_values[i];
+		check_pebs_counters(0);
+		if (!perf.pebs_baseline)
+			continue;
+
+		for (j = 0; j < ARRAY_SIZE(pebs_data_cfgs); j++) {
+			report_prefix_pushf("Adaptive (0x%lx)", pebs_data_cfgs[j]);
+			check_pebs_counters(pebs_data_cfgs[j]);
+			report_prefix_pop();
+		}
+	}
+
+	free_buffers();
+
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index d6dc19f..5731454 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -198,6 +198,13 @@ check = /sys/module/kvm/parameters/ignore_msrs=N
 check = /proc/sys/kernel/nmi_watchdog=0
 accel = kvm
 
+[pmu_pebs]
+arch = x86_64
+file = pmu_pebs.flat
+extra_params = -cpu host,migratable=no
+check = /proc/sys/kernel/nmi_watchdog=0
+accel = kvm
+
 [pmu_emulation]
 file = pmu.flat
 arch = x86_64
-- 
2.37.0

