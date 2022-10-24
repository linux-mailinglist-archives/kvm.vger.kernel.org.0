Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A6F609D9F
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiJXJNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiJXJNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:38 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79C66A4A2
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:34 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id jo13so4339524plb.13
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSkj+WOujRg4RHSzSLHE3d4VitztuhVOwma0quWKcQs=;
        b=hyvTG+4tbavxhnPhjBD7r51AEUFAGFo2kHMQwifgsJZj3WWx5Qye1ujFxbRS+npOkR
         W12ZeJB7ZxPs8UpG7QZR8FJtscmr0EbdJg/xADKqKHYKW6EJ5q5kera2BKfJe58m9cs5
         0+8VsD+DQ2cVBmYpIz8JPmfGgklI2GnEMsT2H8DuT7aRUwEojArAm5T9TjBWhpznl4kX
         sFRQxiKvMN/nBJjGbM26/T8X4UsRLgnGlVKISo7ERKLGtub7kBp5fQKc2dkduF6EDZ5Y
         vZboePB9sQtUMdF35GJJ8WrGNk0eNKAJxHH6oE2AP3BCHrmrho3isAaWOL1QdJWsNqG2
         qYWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hSkj+WOujRg4RHSzSLHE3d4VitztuhVOwma0quWKcQs=;
        b=MsQHvIROH7+prInE09fFxeUDcdPrAdCsTxYCL8nwzMLTZU+MowO8EcbixY3VGVSRUn
         Lb+P3DYGAhtaNxuBjijlW0YVCxWLEjfPcFfEqjSnD7G/YJvFMHR8Z+5mPnQw4Xu0qK/j
         bqabkM4kblS4scKu2JmdxIZfmGJPYtKH55pa0oV5EJEgG6v2J+7Tq77z/UrWTDmDS46M
         /OD3rGPjUeuaUKLhf8XyOkQHH1bwIk5HILKdKXxBcHiZqCzT3QYWm5f95ZxS0H3yhYwN
         /xLhFAgaxW0ikLSBEpphglAE7Wr+x9wnOPNog6cYMbM3KhFGZjX2qOtk0oIdV/MHtyJv
         R68Q==
X-Gm-Message-State: ACrzQf2/Gr0O0Np0PGV6WON89Bqyhb/02jCYFpT5FWcKpwEiJHeuqUWc
        kZs4RN4NB4IujWDbOeD11dqvSSSTbtvyKCKJ
X-Google-Smtp-Source: AMsMyM6e63k/DVPeOawUSLE70Wao84sngPPMOOvAdWESE09QvtC2DL2RpDHS+MA6s0OKdNEpBlo8Mg==
X-Received: by 2002:a17:90b:1f87:b0:212:533:3184 with SMTP id so7-20020a17090b1f8700b0021205333184mr25537554pjb.3.1666602812499;
        Mon, 24 Oct 2022 02:13:32 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:32 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 19/24] x86: Add tests for Guest Processor Event Based Sampling (PEBS)
Date:   Mon, 24 Oct 2022 17:12:18 +0800
Message-Id: <20221024091223.42631-20-likexu@tencent.com>
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
 lib/x86/pmu.h       |  29 +++
 x86/Makefile.x86_64 |   1 +
 x86/pmu_pebs.c      | 433 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |   8 +
 5 files changed, 472 insertions(+)
 create mode 100644 x86/pmu_pebs.c

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index bbe29fd..68d8837 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -52,6 +52,7 @@
 #define MSR_IA32_MCG_CTL		0x0000017b
 
 #define MSR_IA32_PEBS_ENABLE		0x000003f1
+#define MSR_PEBS_DATA_CFG		0x000003f2
 #define MSR_IA32_DS_AREA		0x00000600
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
 
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index ef83934..9ba2419 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -14,6 +14,8 @@
 
 #define PMU_CAP_LBR_FMT	  0x3f
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
+#define PMU_CAP_PEBS_BASELINE	(1ULL << 14)
+#define PERF_CAP_PEBS_FORMAT           0xf00
 
 #define EVNSEL_EVENT_SHIFT	0
 #define EVNTSEL_UMASK_SHIFT	8
@@ -33,6 +35,18 @@
 #define EVNTSEL_INT	(1 << EVNTSEL_INT_SHIFT)
 #define EVNTSEL_INV	(1 << EVNTSEL_INV_SHIF)
 
+#define GLOBAL_STATUS_BUFFER_OVF_BIT		62
+#define GLOBAL_STATUS_BUFFER_OVF	BIT_ULL(GLOBAL_STATUS_BUFFER_OVF_BIT)
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
 struct pmu_caps {
     u64 perf_cap;
     u32 msr_gp_counter_base;
@@ -227,4 +241,19 @@ static inline void pmu_ack_global_status(u64 value)
 	wrmsr(pmu.msr_global_status_clr, value);
 }
 
+static inline bool pmu_version_support_pebs(void)
+{
+	return pmu_version() > 1;
+}
+
+static inline u8 pmu_pebs_format(void)
+{
+	return (pmu.perf_cap & PERF_CAP_PEBS_FORMAT ) >> 8;
+}
+
+static inline bool pebs_has_baseline(void)
+{
+	return pmu.perf_cap & PMU_CAP_PEBS_BASELINE;
+}
+
 #endif /* _X86_PMU_H_ */
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
index 0000000..b318a2c
--- /dev/null
+++ b/x86/pmu_pebs.c
@@ -0,0 +1,433 @@
+#include "x86/msr.h"
+#include "x86/processor.h"
+#include "x86/pmu.h"
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
+/* bits [63:48] provides the size of the current record in bytes */
+#define	RECORD_SIZE_OFFSET	48
+
+static unsigned int max_nr_gp_events;
+static unsigned long *ds_bufer;
+static unsigned long *pebs_buffer;
+static u64 ctr_start_val;
+static bool has_baseline;
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
+	if (!has_baseline)
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
+	u64 baseline_extra_ctrl = 0, fixed_ctr_ctrl = 0;
+	unsigned int idx;
+
+	if (has_baseline)
+		wrmsr(MSR_PEBS_DATA_CFG, pebs_data_cfg);
+
+	ds = (struct debug_store *)ds_bufer;
+	ds->pebs_index = ds->pebs_buffer_base = (unsigned long)pebs_buffer;
+	ds->pebs_absolute_maximum = (unsigned long)pebs_buffer + PAGE_SIZE;
+	ds->pebs_interrupt_threshold = ds->pebs_buffer_base +
+		get_adaptive_pebs_record_size(pebs_data_cfg);
+
+	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++) {
+		if (!(BIT_ULL(FIXED_CNT_INDEX + idx) & bitmask))
+			continue;
+		if (has_baseline)
+			baseline_extra_ctrl = BIT(FIXED_CNT_INDEX + idx * 4);
+		write_fixed_counter_value(idx, ctr_start_val);
+		fixed_ctr_ctrl |= (0xbULL << (idx * 4) | baseline_extra_ctrl);
+	}
+	if (fixed_ctr_ctrl)
+		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, fixed_ctr_ctrl);
+
+	for (idx = 0; idx < max_nr_gp_events; idx++) {
+		if (!(BIT_ULL(idx) & bitmask))
+			continue;
+		if (has_baseline)
+			baseline_extra_ctrl = ICL_EVENTSEL_ADAPTIVE;
+		write_gp_event_select(idx, EVNTSEL_EN | EVNTSEL_OS | EVNTSEL_USR |
+		      intel_arch_events[idx] | baseline_extra_ctrl);
+		write_gp_counter_value(idx, ctr_start_val);
+	}
+
+	wrmsr(MSR_IA32_DS_AREA,  (unsigned long)ds_bufer);
+	wrmsr(MSR_IA32_PEBS_ENABLE, bitmask);
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, bitmask);
+}
+
+static void reset_pebs(void)
+{
+	memset(ds_bufer, 0x0, PAGE_SIZE);
+	memset(pebs_buffer, 0x0, PAGE_SIZE);
+	wrmsr(MSR_IA32_PEBS_ENABLE, 0);
+	wrmsr(MSR_IA32_DS_AREA,  0);
+	if (has_baseline)
+		wrmsr(MSR_PEBS_DATA_CFG, 0);
+
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+
+	reset_all_counters();
+}
+
+static void pebs_disable(unsigned int idx)
+{
+	/*
+	* If we only clear the PEBS_ENABLE bit, the counter will continue to increment.
+	* In this very tiny time window, if the counter overflows no pebs record will be generated,
+	* but a normal counter irq. Test this fully with two ways.
+	*/
+	if (idx % 2)
+		wrmsr(MSR_IA32_PEBS_ENABLE, 0);
+
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+}
+
+static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg)
+{
+	struct pebs_basic *pebs_rec = (struct pebs_basic *)pebs_buffer;
+	struct debug_store *ds = (struct debug_store *)ds_bufer;
+	unsigned int pebs_record_size = get_adaptive_pebs_record_size(pebs_data_cfg);
+	unsigned int count = 0;
+	bool expected, pebs_idx_match, pebs_size_match, data_cfg_match;
+	void *cur_record;
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
+	cur_record = (void *)pebs_buffer;
+	do {
+		pebs_rec = (struct pebs_basic *)cur_record;
+		pebs_record_size = pebs_rec->format_size >> RECORD_SIZE_OFFSET;
+		pebs_idx_match =
+			pebs_rec->applicable_counters & bitmask;
+		pebs_size_match =
+			pebs_record_size == get_adaptive_pebs_record_size(pebs_data_cfg);
+		data_cfg_match =
+			(pebs_rec->format_size & GENMASK_ULL(47, 0)) == pebs_data_cfg;
+		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
+		report(expected,
+		       "PEBS record (written seq %d) is verified (inclduing size, counters and cfg).", count);
+		cur_record = cur_record + pebs_record_size;
+		count++;
+	} while (expected && (void *)cur_record < (void *)ds->pebs_index);
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
+	int pebs_bit = BIT_ULL(type == FIXED ? FIXED_CNT_INDEX + idx : idx);
+
+	report_prefix_pushf("%s counter %d (0x%lx)",
+			    type == FIXED ? "Extended Fixed" : "GP", idx, ctr_start_val);
+	reset_pebs();
+	pebs_enable(pebs_bit, pebs_data_cfg);
+	workload();
+	pebs_disable(idx);
+	check_pebs_records(pebs_bit, pebs_data_cfg);
+	report_prefix_pop();
+}
+
+/* more than one PEBS records will be generated. */
+static void check_multiple_counters(u64 bitmask, u64 pebs_data_cfg)
+{
+	reset_pebs();
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
+		bitmask |= BIT_ULL(FIXED_CNT_INDEX + idx);
+	for (idx = 0; idx < max_nr_gp_events; idx += 2)
+		bitmask |= BIT_ULL(idx);
+	report_prefix_pushf("Multiple (0x%lx)", bitmask);
+	check_multiple_counters(bitmask, pebs_data_cfg);
+	report_prefix_pop();
+}
+
+/*
+ * Known reasons for none PEBS records:
+ *	1. The selected event does not support PEBS;
+ *	2. From a core pmu perspective, the vCPU and pCPU models are not same;
+ * 	3. Guest counter has not yet overflowed or been cross-mapped by the host;
+ */
+int main(int ac, char **av)
+{
+	unsigned int i, j;
+
+	setup_vm();
+
+	max_nr_gp_events = MIN(pmu_nr_gp_counters(), ARRAY_SIZE(intel_arch_events));
+
+	printf("PMU version: %d\n", pmu_version());
+
+	has_baseline = pebs_has_baseline();
+	if (pmu_has_full_writes())
+		set_gp_counter_base(MSR_IA32_PMC0);
+
+	if (!is_intel()) {
+		report_skip("PEBS requires Intel ICX or later, non-Intel detected");
+		return report_summary();
+	} else if (!pmu_version_support_pebs()) {
+		report_skip("PEBS required PMU version 2, reported version is %d", pmu_version());
+		return report_summary();
+	} else if (!pmu_pebs_format()) {
+		report_skip("PEBS not enumerated in PERF_CAPABILITIES");
+		return report_summary();
+	} else if (rdmsr(MSR_IA32_MISC_ENABLE) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL) {
+		report_skip("PEBS unavailable according to MISC_ENABLE");
+		return report_summary();
+	}
+
+	printf("PEBS format: %d\n", pmu_pebs_format());
+	printf("PEBS GP counters: %d\n", pmu_nr_gp_counters());
+	printf("PEBS Fixed counters: %d\n", pmu_nr_fixed_counters());
+	printf("PEBS baseline (Adaptive PEBS): %d\n", has_baseline);
+
+	handle_irq(PMI_VECTOR, cnt_overflow);
+	alloc_buffers();
+
+	for (i = 0; i < ARRAY_SIZE(counter_start_values); i++) {
+		ctr_start_val = counter_start_values[i];
+		check_pebs_counters(0);
+		if (!has_baseline)
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
index 07d0507..54f0437 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -200,6 +200,14 @@ check = /proc/sys/kernel/nmi_watchdog=0
 accel = kvm
 groups = pmu
 
+[pmu_pebs]
+arch = x86_64
+file = pmu_pebs.flat
+extra_params = -cpu host,migratable=no
+check = /proc/sys/kernel/nmi_watchdog=0
+accel = kvm
+groups = pmu
+
 [vmware_backdoors]
 file = vmware_backdoors.flat
 extra_params = -machine vmport=on -cpu max
-- 
2.38.1

