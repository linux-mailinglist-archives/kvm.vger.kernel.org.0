Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14278634133
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbiKVQPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiKVQOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9CB60E88
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7zqMGdMMotKnVQlX2ysOzGt9PFcxTBHaqmPOncGgxng=;
        b=d0zWmwG2FHqy8nDWBv/rJoINoSVQe1ws0A2FAVu2fkxN17xhRvpOqfNoutB1rPJV5Fz+3M
        PGWVNwot4PXYL3cpmKIVRJHc2Wnq4clnfUJSC+j0474EMVLFHxgcizhdaCXGIV2U3l0OJq
        1ec36HIcqErWcST0g5nXthhPpOALPO8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-Op8MpuKDMQqQ2-RmOIY1Zw-1; Tue, 22 Nov 2022 11:12:23 -0500
X-MC-Unique: Op8MpuKDMQqQ2-RmOIY1Zw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D62B38012CA;
        Tue, 22 Nov 2022 16:12:23 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 417D3112132D;
        Tue, 22 Nov 2022 16:12:21 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v3 12/27] x86: add IPI stress test
Date:   Tue, 22 Nov 2022 18:11:37 +0200
Message-Id: <20221122161152.293072-13-mlevitsk@redhat.com>
In-Reply-To: <20221122161152.293072-1-mlevitsk@redhat.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds a test that sends IPIs between vCPUs and detects missing IPIs

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/Makefile.common |   3 +-
 x86/ipi_stress.c    | 167 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  10 +++
 3 files changed, 179 insertions(+), 1 deletion(-)
 create mode 100644 x86/ipi_stress.c

diff --git a/x86/Makefile.common b/x86/Makefile.common
index fa0a50e6..08cc036b 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -89,7 +89,8 @@ tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
                $(TEST_DIR)/eventinj.$(exe) \
                $(TEST_DIR)/smap.$(exe) \
                $(TEST_DIR)/umip.$(exe) \
-               $(TEST_DIR)/smm_int_window.$(exe)
+               $(TEST_DIR)/smm_int_window.$(exe) \
+               $(TEST_DIR)/ipi_stress.$(exe)
 
 # The following test cases are disabled when building EFI tests because they
 # use absolute addresses in their inline assembly code, which cannot compile
diff --git a/x86/ipi_stress.c b/x86/ipi_stress.c
new file mode 100644
index 00000000..dea3e605
--- /dev/null
+++ b/x86/ipi_stress.c
@@ -0,0 +1,167 @@
+#include "libcflat.h"
+#include "smp.h"
+#include "alloc.h"
+#include "apic.h"
+#include "processor.h"
+#include "isr.h"
+#include "asm/barrier.h"
+#include "delay.h"
+#include "desc.h"
+#include "msr.h"
+#include "vm.h"
+#include "types.h"
+#include "alloc_page.h"
+#include "vmalloc.h"
+#include "random.h"
+
+u64 num_iterations = 100000;
+float hlt_prob = 0.1;
+volatile bool end_test;
+
+#define APIC_TIMER_PERIOD (1000*1000*1000)
+
+struct cpu_test_state {
+	volatile u64 isr_count;
+	u64 last_isr_count;
+	struct random_state random;
+	int smp_id;
+} *cpu_states;
+
+
+static void ipi_interrupt_handler(isr_regs_t *r)
+{
+	cpu_states[smp_id()].isr_count++;
+	eoi();
+}
+
+static void local_timer_interrupt(isr_regs_t *r)
+{
+	struct cpu_test_state *state = &cpu_states[smp_id()];
+
+	u64 isr_count = state->isr_count;
+	unsigned long diff =  isr_count - state->last_isr_count;
+
+	if (!diff) {
+		printf("\n");
+		printf("hang detected!!\n");
+		end_test = true;
+		goto out;
+	}
+
+	printf("made %ld IPIs\n", diff * cpu_count());
+	state->last_isr_count = state->isr_count;
+out:
+	eoi();
+}
+
+static void wait_for_ipi(struct cpu_test_state *state)
+{
+	u64 old_count = state->isr_count;
+	bool use_halt = random_decision(&state->random, hlt_prob);
+
+	do {
+		if (use_halt) {
+			safe_halt();
+			cli();
+		} else
+			sti_nop_cli();
+
+	} while (old_count == state->isr_count);
+
+	assert(state->isr_count == old_count + 1);
+}
+
+
+static void vcpu_init(void *)
+{
+	struct cpu_test_state *state = &cpu_states[smp_id()];
+
+	memset(state, 0, sizeof(*state));
+
+	/* To make it easier to see iteration number in the trace */
+	handle_irq(0x40, ipi_interrupt_handler);
+	handle_irq(0x50, ipi_interrupt_handler);
+
+	state->random = get_prng();
+	state->isr_count = 0;
+	state->smp_id = smp_id();
+}
+
+static void vcpu_code(void *)
+{
+	struct cpu_test_state *state = &cpu_states[smp_id()];
+	int ncpus = cpu_count();
+	u64 i;
+	u8 target_smp_id;
+
+	if (state->smp_id > 0)
+		wait_for_ipi(state);
+
+	target_smp_id = state->smp_id == ncpus - 1 ? 0 : state->smp_id  + 1;
+
+	for (i = 0; i < num_iterations && !end_test; i++) {
+		// send IPI to a next vCPU in a circular fashion
+		apic_icr_write(APIC_INT_ASSERT |
+				APIC_DEST_PHYSICAL |
+				APIC_DM_FIXED |
+				(i % 2 ? 0x40 : 0x50),
+				target_smp_id);
+
+		if (i == (num_iterations - 1) && state->smp_id > 0)
+			break;
+
+		// wait for the IPI interrupt chain to come back to us
+		wait_for_ipi(state);
+	}
+}
+
+int main(int argc, void **argv)
+{
+	int cpu, ncpus = cpu_count();
+
+	handle_irq(0xF0, local_timer_interrupt);
+	apic_setup_timer(0xF0, APIC_LVT_TIMER_PERIODIC);
+
+	if (argc > 1) {
+		int hlt_param = atol(argv[1]);
+
+		if (hlt_param == 1)
+			hlt_prob = 100;
+		else if (hlt_param == 0)
+			hlt_prob = 0;
+	}
+
+	if (argc > 2)
+		num_iterations = atol(argv[2]);
+
+	setup_vm();
+	init_prng();
+
+	cpu_states = calloc(ncpus, sizeof(cpu_states[0]));
+
+	printf("found %d cpus\n", ncpus);
+	printf("running for %lld iterations\n",
+		(unsigned long long)num_iterations);
+
+	on_cpus(vcpu_init, NULL);
+
+	apic_start_timer(1000*1000*1000);
+
+	printf("test started, waiting to end...\n");
+
+	on_cpus(vcpu_code, NULL);
+
+	apic_stop_timer();
+	apic_cleanup_timer();
+
+	for (cpu = 0; cpu < ncpus; ++cpu) {
+		u64 result = cpu_states[cpu].isr_count;
+
+		report(result == num_iterations,
+				"Number of IPIs match (%lld)",
+				(unsigned long long)result);
+	}
+
+	free((void *)cpu_states);
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index df248dff..b0fd92fb 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -74,6 +74,16 @@ smp = 2
 file = smptest.flat
 smp = 3
 
+[ipi_stress]
+file = ipi_stress.flat
+extra_params = -cpu host,-x2apic -global kvm-pit.lost_tick_policy=discard -machine kernel-irqchip=on
+smp = 4
+
+[ipi_stress_x2apic]
+file = ipi_stress.flat
+extra_params = -cpu host,+x2apic -global kvm-pit.lost_tick_policy=discard -machine kernel-irqchip=on
+smp = 4
+
 [vmexit_cpuid]
 file = vmexit.flat
 extra_params = -append 'cpuid'
-- 
2.34.3

