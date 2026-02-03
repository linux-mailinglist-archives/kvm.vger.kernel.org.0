Return-Path: <kvm+bounces-70057-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6LXnGuI9gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70057-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:26:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BBF1DD8E5
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:26:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1364130610B7
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 449EE3EDAA0;
	Tue,  3 Feb 2026 18:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A0n0Rmrt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492173E9F73;
	Tue,  3 Feb 2026 18:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142672; cv=none; b=NqGggX17t5/Ukpngtgmpyezuc1tPua+ys1QQ0tnfCngtwSKgBk5yZfimjWyCqGt1yn0c2rHwmgnF2IgfCYyb+sClPtjshrtrUQZMroXI27rx9tcRroyC+HZR5+tPe3aa6d1Hk8L4NXWnAv6Y5bI/QxE98qplZVQP1M9GnMeW/Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142672; c=relaxed/simple;
	bh=we2sIhVXtUPvYa/AJ3J/k7gvy9fThDWbSAlpUUdRmQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oh1gEm4L546k7posyQ2ugMjdXUJ42jUu2z9d6BzQIHVBfKGR5JVk6+898v5eGgEtr9Jx+lx5kidZc5PWugFo8wWu3DvKenB68sx2B/CZqIk3balMWD41fsvvvT7U20tUhWKvGc/0cvLK4IfVAq3kEsMyil/As2OPOcCYVwldU0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A0n0Rmrt; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142671; x=1801678671;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=we2sIhVXtUPvYa/AJ3J/k7gvy9fThDWbSAlpUUdRmQU=;
  b=A0n0RmrtYYMvDa79VjkJ9W2K1GS7pSKA5L7F5wADoc95OKXrygqjWv0O
   wElFe36jWAZ7uDyjqFux5lScy1FqXTj+oDDD7IFwfq6WsqRvuwvWfzexQ
   +UoTOt28IJBHyihybmzFRqzWT2C8N9v2Ne6deMvI6GXodHjIg7NUKaaD6
   fPyaNZJ/QaTNkwxbP7EDZ4bDfoEf26ioa9MM7xZ2HLvs8pDUvyAELpHjI
   aF6Oqh49mIy4OWGuN3zel+Y3VoNpy2qXO0jNQ4ul1GgRoN1zW5e+eP9Ke
   T9Il+9ciZE8Bwi0mqenPr7isTlu/aecPDMnC+6lWofnDXFILpP7CsiyWa
   g==;
X-CSE-ConnectionGUID: TspSFukVQCmEK43RGW/CcA==
X-CSE-MsgGUID: ocALFzGHQOm5riRco0qvLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745854"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745854"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:46 -0800
X-CSE-ConnectionGUID: vJG9b3OWQS+m3Zm8ZdATFg==
X-CSE-MsgGUID: Z80vKbtXR52HG+27ZVLhGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605526"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:46 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 24/32] KVM: selftests: Add a test to measure local timer latency
Date: Tue,  3 Feb 2026 10:17:07 -0800
Message-ID: <7e6fa29d20d36e1191c5c64d612ec43f5375adac.1770116051.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1770116050.git.isaku.yamahata@intel.com>
References: <cover.1770116050.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70057-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 9BBF1DD8E5
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

A test case to measure local timer latency and to confirm that VMExit
doesn't happen on TSC DEADLINE MSR on the platform that supports VMX APIC
timer virtualization.  Or VMExit happens on the platform without the
feature.

This is inspired by kvm-unit-test x86/tscdeadline_latency.c.  The original
test records all latency, but this records only the max/min/avg of the
latency for simplicity.  It sets the local APIC timer (APIC oneshot or TSC
deadline) and the timer interrupt handler records the delay from the timer
value.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/x86/timer_latency.c | 574 ++++++++++++++++++
 2 files changed, 575 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/timer_latency.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index ba5c2b643efa..695d19c73199 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -139,6 +139,7 @@ TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
 TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
 TEST_GEN_PROGS_x86 += x86/aperfmperf_test
+TEST_GEN_PROGS_x86 += x86/timer_latency
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86/timer_latency.c b/tools/testing/selftests/kvm/x86/timer_latency.c
new file mode 100644
index 000000000000..a87a744330c8
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/timer_latency.c
@@ -0,0 +1,574 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025, Intel Corporation.
+ *
+ * Measure timer interrupt latency between time set to the local timer and
+ * interrupt arrival time.  Optionally print out max/min/avg of the latency.
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdatomic.h>
+#include <signal.h>
+#include <pthread.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "apic.h"
+
+#define LOCAL_TIMER_VECTOR	0xec
+
+#define TEST_DURATION_DEFAULT_IN_SEC   10
+
+/* Random number in ns, appropriate for timer interrupt */
+#define DEFAULT_TIMER_INC_NS	10000
+
+/* Twice 100Hz scheduler tick for nested virtualization. */
+#define DEFAULT_ALLOWED_TIMER_LATENCY_NS	(20 * 1000 * 1000)
+
+struct options {
+	bool use_oneshot_timer;
+	bool use_x2apic;
+	bool use_poll;
+
+	uint64_t timer_inc_ns;
+	uint64_t allowed_timer_latency_ns;
+
+	bool print_result;
+};
+
+static struct options options = {
+	.use_x2apic = true,
+	.timer_inc_ns = DEFAULT_TIMER_INC_NS,
+	.allowed_timer_latency_ns = DEFAULT_ALLOWED_TIMER_LATENCY_NS,
+};
+
+enum event_type {
+	EVENT_TIMER_HANDLER,
+	EVENT_HLT_WAKEUP,
+	EVENT_MAX,
+};
+
+struct test_sample {
+	uint64_t time_stamp;
+	enum event_type etype;
+	uint32_t latency;
+};
+
+struct test_latency_stat {
+	uint64_t sum;
+	uint64_t count;
+	uint32_t min;
+	uint32_t max;
+};
+
+struct test_shared_data {
+	atomic_bool stop_test;
+	atomic_bool terminated;
+	uint64_t tsc_khz;
+	uint64_t apic_bus_cycle_ns;
+	uint64_t allowed_timer_latency_tsc;
+
+	uint64_t timer_inc;
+
+	uint64_t hlt_count;
+	uint64_t timer_interrupt_set;
+	uint64_t timer_interrupt_received;
+
+	struct test_latency_stat latency_stat[EVENT_MAX];
+};
+
+#define GUEST_ASSERT_LATENCY(latency_tsc)				\
+	__GUEST_ASSERT((latency_tsc) <= data->allowed_timer_latency_tsc, \
+		       "too large timer latency %ld ns "		\
+		       "(requires %ld ns) %ld khz tsc",			\
+		       tsc_to_ns(data, latency_tsc),			\
+		       options.allowed_timer_latency_ns,		\
+		       data->tsc_khz)
+
+static struct test_shared_data shared_data;
+
+static u64 tsc_to_ns(struct test_shared_data *data, u64 tsc_delta)
+{
+	return tsc_delta * NSEC_PER_SEC / (data->tsc_khz * 1000);
+}
+
+static u64 ns_to_tsc(struct test_shared_data *data, u64 ns)
+{
+	return ns * (data->tsc_khz * 1000) / NSEC_PER_SEC;
+}
+
+static void latency_init(struct test_latency_stat *stat)
+{
+	stat->sum = 0;
+	stat->count = 0;
+	stat->min = -1;
+	stat->max = 0;
+}
+
+static void shared_data_init(struct test_shared_data *data)
+{
+	int i;
+
+	memset(data, 0, sizeof(*data));
+
+	for (i = 0; i < ARRAY_SIZE(data->latency_stat); i++)
+		latency_init(data->latency_stat + i);
+}
+
+static void stop_test(struct kvm_vm *vm, struct test_shared_data *data)
+{
+	atomic_store(&data->stop_test, true);
+	sync_global_to_guest(vm, data->stop_test);
+}
+
+static void guest_apic_enable(void)
+{
+	if (options.use_x2apic)
+		x2apic_enable();
+	else
+		xapic_enable();
+}
+
+static void guest_apic_write_reg(unsigned int reg, uint64_t val)
+{
+	if (options.use_x2apic)
+		x2apic_write_reg(reg, val);
+	else
+		xapic_write_reg(reg, val);
+}
+
+static void record_sample(struct test_shared_data *data, enum event_type etype,
+			 uint64_t ts, uint64_t latency)
+{
+	struct test_latency_stat *stat;
+
+	stat = &data->latency_stat[etype];
+
+	stat->count++;
+	stat->sum += latency;
+
+	if (stat->min > latency)
+		stat->min = latency;
+	if (stat->max < latency)
+		stat->max = latency;
+
+	if (etype == EVENT_TIMER_HANDLER &&
+	    latency > data->allowed_timer_latency_tsc) {
+		if (options.use_poll) {
+			GUEST_PRINTF("latency is too high %ld ns (> %ld ns)\n",
+				     tsc_to_ns(data, latency),
+				     options.allowed_timer_latency_ns);
+		} else
+			GUEST_ASSERT_LATENCY(latency);
+	}
+}
+
+static atomic_bool timer_interrupted;
+static atomic_uint_fast64_t timer_tsc;
+
+static inline bool tsc_before(u64 a, u64 b)
+{
+	return (s64)(a - b) < 0;
+}
+
+static void guest_timer_interrupt_handler(struct ex_regs *regs)
+{
+	uint64_t now = rdtsc();
+	uint64_t timer_tsc__ = atomic_load(&timer_tsc);
+
+	__GUEST_ASSERT(!atomic_load(&timer_interrupted),
+		       "timer handler is called multiple times per timer");
+	__GUEST_ASSERT(tsc_before(timer_tsc__, now),
+		       "timer is fired before armed time timer_tsc 0x%lx now 0x%lx",
+		       timer_tsc__, now);
+
+	record_sample(&shared_data, EVENT_TIMER_HANDLER, now, now - timer_tsc__);
+
+	shared_data.timer_interrupt_received++;
+	atomic_store(&timer_interrupted, true);
+	guest_apic_write_reg(APIC_EOI, 0);
+}
+
+static void __set_timer(struct test_shared_data *data,
+			uint64_t next_tsc, uint64_t apic_inc)
+{
+	if (options.use_oneshot_timer)
+		guest_apic_write_reg(APIC_TMICT, apic_inc);
+	else
+		wrmsr(MSR_IA32_TSC_DEADLINE, next_tsc);
+}
+
+static void set_timer(struct test_shared_data *data,
+		      uint64_t next_tsc, uint64_t apic_inc)
+{
+	atomic_store(&timer_tsc, next_tsc);
+	data->timer_interrupt_set++;
+	__set_timer(data, next_tsc, apic_inc);
+}
+
+static u64 to_apic_bus_cycle(struct test_shared_data *data, u64 tsc_delta)
+{
+	u64 ret;
+
+	if (!tsc_delta)
+		return 0;
+
+	ret = tsc_to_ns(data, tsc_delta) / data->apic_bus_cycle_ns;
+	if (!ret)
+		ret++;
+
+	return ret;
+}
+
+static void hlt_loop(struct test_shared_data *data)
+{
+	uint64_t inc, now, prev_tsc, next_tsc;
+
+	asm volatile("cli");
+	guest_apic_enable();
+
+	inc = data->timer_inc;
+
+	/* DIVISOR = 1 for oneshot timer case */
+	guest_apic_write_reg(APIC_TDCR, 0xb);
+	guest_apic_write_reg(APIC_LVTT,
+			     (options.use_oneshot_timer ?
+			      APIC_LVT_TIMER_ONESHOT :
+			      APIC_LVT_TIMER_TSCDEADLINE) |
+			     LOCAL_TIMER_VECTOR);
+
+	next_tsc = rdtsc() + inc;
+	if (!next_tsc)
+		next_tsc++;
+	atomic_store(&timer_interrupted, false);
+	set_timer(data, next_tsc, to_apic_bus_cycle(data, inc));
+
+	while (!atomic_load(&data->stop_test)) {
+		prev_tsc = rdtsc();
+
+		if (options.use_poll) {
+			asm volatile("sti");
+			while (!atomic_load(&timer_interrupted) &&
+			       rdtsc() < next_tsc + data->allowed_timer_latency_tsc)
+				cpu_relax();
+			asm volatile("cli");
+		} else
+			asm volatile("sti; hlt; cli");
+
+		now = rdtsc();
+
+		record_sample(data, EVENT_HLT_WAKEUP, now, now - prev_tsc);
+		data->hlt_count++;
+
+		if (atomic_load(&timer_interrupted)) {
+			while (next_tsc <= now)
+				next_tsc += inc;
+			if (!next_tsc)
+				next_tsc++;
+
+			atomic_store(&timer_interrupted, false);
+			set_timer(data, next_tsc,
+				  to_apic_bus_cycle(data, next_tsc - now));
+		} else {
+			uint64_t latency = now - next_tsc;
+
+			GUEST_ASSERT_LATENCY(latency);
+		}
+	}
+
+	/* Wait for the interrupt to arrive. */
+	now = rdtsc();
+	next_tsc = now + inc * 2;
+	asm volatile ("sti");
+	while (now < next_tsc || !atomic_load(&timer_interrupted)) {
+		cpu_relax();
+		now = rdtsc();
+	}
+	asm volatile ("cli");
+
+	/* Stop timer explicitly just in case. */
+	__set_timer(data, 0, 0);
+}
+
+static void guest_code(void)
+{
+	struct test_shared_data *data = &shared_data;
+
+	hlt_loop(data);
+
+	__GUEST_ASSERT(data->timer_interrupt_set == data->timer_interrupt_received,
+		       "timer interrupt lost set %ld received %ld",
+		       data->timer_interrupt_set, data->timer_interrupt_received);
+
+	GUEST_DONE();
+}
+
+static void __run_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	for (;;) {
+		vcpu_run(vcpu);
+
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_DONE:
+			pr_info("vcpu id %d passed\n", vcpu->id);
+			return;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			return;
+		case UCALL_PRINTF:
+			pr_info("%s", uc.buffer);
+			continue;
+		default:
+			TEST_FAIL("Unexpected ucall cmd: %ld", uc.cmd);
+			return;
+		}
+
+		return;
+	}
+}
+
+static void *run_vcpu(void *args)
+{
+	struct kvm_vcpu *vcpu = args;
+
+	__run_vcpu(vcpu);
+
+	return NULL;
+}
+
+static void print_result_type(struct test_shared_data *data,
+			      enum event_type etype, const char *event_name)
+{
+	struct test_latency_stat *stat = &data->latency_stat[etype];
+	uint64_t avg = 0;
+
+	if (stat->count)
+		avg = stat->sum / stat->count;
+
+	pr_info("%s latency (%ld samples)\tmin %ld avg %ld max %ld ns\n",
+		event_name, stat->count,
+		tsc_to_ns(data, stat->min), tsc_to_ns(data, avg),
+		tsc_to_ns(data, stat->max));
+}
+
+static void print_result(struct test_shared_data *data)
+{
+	pr_info("guest timer: %s timer period %ld ns\n",
+		options.use_oneshot_timer ?
+		"APIC oneshot timer" : "tsc deadline",
+		options.timer_inc_ns);
+
+	pr_info("tsc_khz %ld apic_bus_cycle_ns %ld\n",
+		data->tsc_khz, data->apic_bus_cycle_ns);
+
+	pr_info("hlt %ld timer set %ld received %ld\n",
+		data->hlt_count,
+		data->timer_interrupt_set, data->timer_interrupt_received);
+
+	print_result_type(data, EVENT_TIMER_HANDLER, "timer interrupt");
+	print_result_type(data, EVENT_HLT_WAKEUP, "halt wakeup");
+}
+
+static void print_exit_stats(struct kvm_vcpu *vcpu)
+{
+	char* stat_name[] = {
+		"exits",
+		"halt_exits",
+		"irq_exits",
+		"inject_tscdeadline"
+	};
+	uint64_t data;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(stat_name); i++) {
+		kvm_get_stat(&vcpu->stats, stat_name[i], &data, 1);
+		pr_info("%s: %ld ", stat_name[i], data);
+	}
+	pr_info("\n");
+}
+
+static void setup_timer_freq(struct kvm_vm *vm,
+			     struct test_shared_data *data)
+{
+	data->tsc_khz = __vm_ioctl(vm, KVM_GET_TSC_KHZ, NULL);
+	TEST_ASSERT(data->tsc_khz > 0, "KVM_GET_TSC_KHZ failed..");
+
+	data->apic_bus_cycle_ns = kvm_check_cap(KVM_CAP_X86_APIC_BUS_CYCLES_NS);
+	if (options.use_oneshot_timer)
+		data->timer_inc = options.timer_inc_ns * data->apic_bus_cycle_ns;
+	else
+		data->timer_inc = ns_to_tsc(data, options.timer_inc_ns);
+
+	data->allowed_timer_latency_tsc =
+		ns_to_tsc(data, options.allowed_timer_latency_ns);
+}
+
+static void setup(struct kvm_vm **vm__, struct kvm_vcpu **vcpu__)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vm_install_exception_handler(vm, LOCAL_TIMER_VECTOR,
+				     guest_timer_interrupt_handler);
+	setup_timer_freq(vm, &shared_data);
+
+	if (!options.use_oneshot_timer)
+		vcpu_set_cpuid_feature(vcpu, X86_FEATURE_TSC_DEADLINE_TIMER);
+
+	sync_global_to_guest(vm, options);
+	sync_global_to_guest(vm, shared_data);
+
+	*vm__ = vm;
+	*vcpu__ = vcpu;
+}
+
+static void print_stats(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	if (options.print_result) {
+		sync_global_from_guest(vm, *&shared_data);
+		print_result(&shared_data);
+		print_exit_stats(vcpu);
+	}
+}
+
+static void sigterm_handler(int signum, siginfo_t *info, void *arg_)
+{
+	atomic_store(&shared_data.terminated, true);
+}
+
+static int run_test(unsigned int duration)
+{
+	struct kvm_vcpu *vcpu;
+	struct sigaction sa;
+	struct kvm_vm *vm;
+	pthread_t thread;
+	int r;
+
+	shared_data_init(&shared_data);
+
+	setup(&vm, &vcpu);
+
+	sa = (struct sigaction) {
+		.sa_sigaction = sigterm_handler,
+	};
+	sigemptyset(&sa.sa_mask);
+	r = sigaction(SIGTERM, &sa, NULL);
+	TEST_ASSERT(!r, "sigaction");
+
+	r = pthread_create(&thread, NULL, run_vcpu, vcpu);
+	TEST_ASSERT(!r, "pthread_create");
+
+	while (duration > 0 && !atomic_load(&shared_data.terminated)) {
+		duration = sleep(duration);
+		TEST_ASSERT(duration >= 0, "sleep");
+	}
+
+	if (atomic_load(&shared_data.terminated)) {
+		pr_info("terminated\n");
+		print_stats(vm, vcpu);
+		return -EINTR;
+	}
+
+	stop_test(vm, &shared_data);
+
+	r = pthread_join(thread, NULL);
+	TEST_ASSERT(!r, "pthread_join");
+
+	print_stats(vm, vcpu);
+
+	kvm_vm_free(vm);
+	return 0;
+}
+
+static void help(const char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-l] [-d duration_in_sec] [-a allowed_timer_latency] [-p period_in_ns] [-o] [-O] [-x] [-X]\n",
+	       name);
+	puts("");
+	printf("-h: Display this help message.");
+	printf("-l: use idle loop instead of hlt\n");
+	printf("-d: specify test to run in second (default %d sec)\n",
+	       TEST_DURATION_DEFAULT_IN_SEC);
+	printf("-p: timer period in ns (default %d nsec)\n",
+	       DEFAULT_TIMER_INC_NS);
+	printf("-a: allowed timer latency in ns (default %d nsec)\n",
+	       DEFAULT_ALLOWED_TIMER_LATENCY_NS);
+	printf("-o: use APIC oneshot timer instead of TSC deadline timer\n");
+	printf("-t: use TSC deadline timer instead of APIC oneshot timer (default)\n");
+	printf("-P: print result stat\n");
+	printf("-x: use xAPIC mode\n");
+	printf("-X: use x2APIC mode (default)\n");
+	puts("");
+
+	exit(EXIT_SUCCESS);
+}
+
+int main(int argc, char **argv)
+{
+	int opt;
+	unsigned int duration = TEST_DURATION_DEFAULT_IN_SEC;
+
+	while ((opt = getopt(argc, argv, "hld:p:a:otxXP")) != -1) {
+		switch (opt) {
+		case 'l':
+			options.use_poll = true;
+			break;
+
+		case 'd':
+			duration = atoi_non_negative("test duration in sec", optarg);
+			break;
+		case 'p':
+			options.timer_inc_ns =
+				atoi_non_negative("timer period in nsec", optarg);
+			break;
+		case 'a':
+			options.allowed_timer_latency_ns =
+				atoi_non_negative("allowed timer latency in nsec",
+						  optarg);
+			break;
+
+
+		case 'x':
+			options.use_x2apic = false;
+			break;
+		case 'X':
+			options.use_x2apic = true;
+			break;
+
+		case 'o':
+			options.use_oneshot_timer = true;
+			break;
+		case 't':
+			options.use_oneshot_timer = false;
+			break;
+
+		case 'P':
+			options.print_result = true;
+			break;
+
+		case 'h':
+		default:
+			help(argv[0]);
+			break;
+		}
+	}
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GET_TSC_KHZ));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_TSC_CONTROL));
+	if (!options.use_oneshot_timer)
+		TEST_REQUIRE(kvm_has_cap(KVM_CAP_TSC_DEADLINE_TIMER));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_APIC_BUS_CYCLES_NS));
+	if (options.use_x2apic)
+		TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_X2APIC));
+
+	run_test(duration);
+
+	return 0;
+}
-- 
2.45.2


