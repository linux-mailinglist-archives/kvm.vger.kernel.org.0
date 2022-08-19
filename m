Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8853599AA0
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348703AbiHSLKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348694AbiHSLKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:10:07 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A1CF6196
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:06 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id k14so4063655pfh.0
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=DsUNkpvOMHdR49JPNiJyAnTXkdk3lRpHK1A3nq8N0v4=;
        b=AklcV29sl4eiNHQjUriB7F69bIxN7m1obab/P2uGARfEDjf4gHG6GImykULsm12ka3
         o6wniu8cOv1Ken6ci1diFggcThBUyHpBbu+vx03vsf9Nu9C3xAxz79tTxUHnC3NU4JuY
         7Bf8b3yLypOIxMuj4LCyZwi6YujB02o6pdCLrNMAS4xsKmb8adjn09dcQpkAgzSfGNqt
         bmvGjgdLtQxW6Nm0kr9OF0HCPF3sXIawuob3VxGCa61/I58v9QXwNvIXRr48EUcagXip
         JVIadDPYdSSoBIF+tIzt3Ze2XOmYLU1DypsYOycZTmqfsWVS9/jurdMv/MwxWqckdIsD
         B11w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=DsUNkpvOMHdR49JPNiJyAnTXkdk3lRpHK1A3nq8N0v4=;
        b=1VDZcFUo71mutofw9sCAQCeNc35WMwkFXqLIcsZhBovlnhP5FlC1clJJ7e29XE9So6
         PWnilVvb1ViiUrYG0DbVdyb2lrK3b8s/1Nif8gijBJZ3ABs+R68nuoI0PCmpg+SsfAEH
         YcpAxlu7gmITKKcI/+xXCnd1sXJ8pqEIGTSMCRQTtWm0YeL0i5B7YfcLzJsXzjLR5XZ+
         wkY/O0OiB6gYF+qBkDWrxQsKopnPir21BAZ0Hc3WNNDTOR68Yi8HmnZtDVYz0ColF1B5
         TIKNdFuRc9rHyvteaSukfV+uO1lvYl4iGiQqj8amvXwkT7PvlYwqfxFdAvzi1JwyZRlU
         L11A==
X-Gm-Message-State: ACgBeo3yURK/uM+PwbWp1vcPEoJ1Pu4HPi1jsA5TLwsRtpYVDlO1+x6D
        1nH6DI8eyD8vyEdqf7Vr7cUzXloNMf02XQ==
X-Google-Smtp-Source: AA6agR4z1upAUPaTdQSe3duoVQcuO0VZnPZPEXm6KB3HURZ58eHbAlObgPQTvfdHlJ2WuK1IHVm+nQ==
X-Received: by 2002:a05:6a00:1409:b0:52e:d946:b2f5 with SMTP id l9-20020a056a00140900b0052ed946b2f5mr7251888pfu.20.1660907405756;
        Fri, 19 Aug 2022 04:10:05 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jd7-20020a170903260700b0016bfbd99f64sm2957778plb.118.2022.08.19.04.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:10:05 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 04/13] x86/pmu: Add tests for Intel Processor Event Based Sampling (PEBS)
Date:   Fri, 19 Aug 2022 19:09:30 +0800
Message-Id: <20220819110939.78013-5-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819110939.78013-1-likexu@tencent.com>
References: <20220819110939.78013-1-likexu@tencent.com>
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
 x86/pmu_pebs.c      | 486 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |   7 +
 4 files changed, 495 insertions(+)
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
index 8f9463c..bd827fe 100644
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
index 0000000..db4ecbf
--- /dev/null
+++ b/x86/pmu_pebs.c
@@ -0,0 +1,486 @@
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
+#define PMU_CAP_PEBS_BASELINE	(1ULL << 14)
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
+static u64 gp_counter_base = MSR_IA32_PERFCTR0;
+static unsigned int max_nr_gp_events;
+static unsigned long *ds_bufer;
+static unsigned long *pebs_buffer;
+static u64 ctr_start_val;
+static u64 perf_cap;
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
+static inline u8 pebs_format(void)
+{
+	return (perf_cap & PERF_CAP_PEBS_FORMAT ) >> 8;
+}
+
+static inline bool pebs_has_baseline(void)
+{
+	return perf_cap & PMU_CAP_PEBS_BASELINE;
+}
+
+static unsigned int get_adaptive_pebs_record_size(u64 pebs_data_cfg)
+{
+	unsigned int sz = sizeof(struct pebs_basic);
+
+	if (!pebs_has_baseline())
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
+	if (pebs_has_baseline())
+		wrmsr(MSR_PEBS_DATA_CFG, pebs_data_cfg);
+
+	ds = (struct debug_store *)ds_bufer;
+	ds->pebs_index = ds->pebs_buffer_base = (unsigned long)pebs_buffer;
+	ds->pebs_absolute_maximum = (unsigned long)pebs_buffer + PAGE_SIZE;
+	ds->pebs_interrupt_threshold = ds->pebs_buffer_base +
+		get_adaptive_pebs_record_size(pebs_data_cfg);
+
+	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++) {
+		if (!(BIT_ULL(INTEL_PMC_IDX_FIXED + idx) & bitmask))
+			continue;
+		baseline_extra_ctrl = pebs_has_baseline() ?
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
+		baseline_extra_ctrl = pebs_has_baseline() ?
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
+	if (pebs_has_baseline())
+		wrmsr(MSR_PEBS_DATA_CFG, 0);
+
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+
+	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
+	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++) {
+		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + idx, 0);
+	}
+
+	for (idx = 0; idx < pmu_nr_gp_counters(); idx++) {
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
+	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++)
+		check_one_counter(FIXED, idx, pebs_data_cfg);
+
+	for (idx = 0; idx < max_nr_gp_events; idx++)
+		check_one_counter(GP, idx, pebs_data_cfg);
+
+	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++)
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
+	unsigned int i, j;
+
+	setup_vm();
+
+	max_nr_gp_events = MIN(pmu_nr_gp_counters(), ARRAY_SIZE(intel_arch_events));
+
+	printf("PMU version: %d\n", pmu_version());
+	if (this_cpu_has(X86_FEATURE_PDCM))
+		perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+
+	if (perf_cap & PMU_CAP_FW_WRITES)
+		gp_counter_base = MSR_IA32_PMC0;
+
+	if (!is_intel()) {
+		report_skip("PEBS is only supported on Intel CPUs (ICX or later)");
+		return report_summary();
+	} else if (pmu_version() < 2) {
+		report_skip("Architectural PMU version is not high enough");
+		return report_summary();
+	} else if (!pebs_format()) {
+		report_skip("PEBS not enumerated in PERF_CAPABILITIES");
+		return report_summary();
+	} else if (rdmsr(MSR_IA32_MISC_ENABLE) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL) {
+		report_skip("PEBS unavailable according to MISC_ENABLE");
+		return report_summary();
+	}
+
+	printf("PEBS format: %d\n", pebs_format());
+	printf("PEBS GP counters: %d\n", pmu_nr_gp_counters());
+	printf("PEBS Fixed counters: %d\n", pmu_nr_fixed_counters());
+	printf("PEBS baseline (Adaptive PEBS): %d\n", pebs_has_baseline());
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
+		if (!pebs_has_baseline())
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
index ed65185..c5efb25 100644
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
 [vmware_backdoors]
 file = vmware_backdoors.flat
 extra_params = -machine vmport=on -cpu max
-- 
2.37.2

