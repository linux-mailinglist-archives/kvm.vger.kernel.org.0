Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2300860645B
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiJTPY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiJTPYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:24:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF46B3B990
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666279476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E3pn5TvHXk2TZI5OLfWsbF5ZEd6Y8Uf9ebGRHkZPE6U=;
        b=iFeqjlzWgO0x0MGDrtIU46hMmtj86GOuvpG7n/ePhrR9SlOSov8L2SB0jdXIarvnqIUmoh
        JGIKodHj8lWrVKM8xzx1cn9m/Be6vj/uo1n8z6f9xJJfoY2+QkRJF4flfukgkIN/BvVlOs
        CKWY1DRDoKjYvL4oo1g9/xX3i4jNwQE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-q7hDoPzePaeGWO3rWgxRrA-1; Thu, 20 Oct 2022 11:24:35 -0400
X-MC-Unique: q7hDoPzePaeGWO3rWgxRrA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D1383C10221
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:24:34 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B35C2024CB7;
        Thu, 20 Oct 2022 15:24:33 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 16/16] add IPI loss stress test
Date:   Thu, 20 Oct 2022 18:24:04 +0300
Message-Id: <20221020152404.283980-17-mlevitsk@redhat.com>
In-Reply-To: <20221020152404.283980-1-mlevitsk@redhat.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
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
 x86/ipi_stress.c    | 235 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |   5 +
 3 files changed, 242 insertions(+), 1 deletion(-)
 create mode 100644 x86/ipi_stress.c

diff --git a/x86/Makefile.common b/x86/Makefile.common
index ed5e5c76..8e0b6661 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -86,7 +86,8 @@ tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
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
index 00000000..185f791e
--- /dev/null
+++ b/x86/ipi_stress.c
@@ -0,0 +1,235 @@
+#include "libcflat.h"
+#include "smp.h"
+#include "alloc.h"
+#include "apic.h"
+#include "processor.h"
+#include "isr.h"
+#include "asm/barrier.h"
+#include "delay.h"
+#include "svm.h"
+#include "desc.h"
+#include "msr.h"
+#include "vm.h"
+#include "types.h"
+#include "alloc_page.h"
+#include "vmalloc.h"
+#include "svm_lib.h"
+
+u64 num_iterations = -1;
+
+volatile u64 *isr_counts;
+bool use_svm;
+int hlt_allowed = -1;
+
+
+static int get_random(int min, int max)
+{
+	/* TODO : use rdrand to seed an PRNG instead */
+	u64 random_value = rdtsc() >> 4;
+
+	return min + random_value % (max - min + 1);
+}
+
+static void ipi_interrupt_handler(isr_regs_t *r)
+{
+	isr_counts[smp_id()]++;
+	eoi();
+}
+
+static void wait_for_ipi(volatile u64 *count)
+{
+	u64 old_count = *count;
+	bool use_halt;
+
+	switch (hlt_allowed) {
+	case -1:
+		use_halt = get_random(0,10000) == 0;
+		break;
+	case 0:
+		use_halt = false;
+		break;
+	case 1:
+		use_halt = true;
+		break;
+	default:
+		use_halt = false;
+		break;
+	}
+
+	do {
+		if (use_halt)
+			asm volatile ("sti;hlt;cli\n");
+		else
+			asm volatile ("sti;nop;cli");
+
+	} while (old_count == *count);
+}
+
+/******************************************************************************************************/
+
+#ifdef __x86_64__
+
+static void l2_guest_wait_for_ipi(volatile u64 *count)
+{
+	wait_for_ipi(count);
+	asm volatile("vmmcall");
+}
+
+static void l2_guest_dummy(void)
+{
+	asm volatile("vmmcall");
+}
+
+static void wait_for_ipi_in_l2(volatile u64 *count, struct svm_vcpu *vcpu)
+{
+	u64 old_count = *count;
+	bool irq_on_vmentry = get_random(0,1) == 0;
+
+	vcpu->vmcb->save.rip = (ulong)l2_guest_wait_for_ipi;
+	vcpu->regs.rdi = (u64)count;
+
+	vcpu->vmcb->save.rip = irq_on_vmentry ? (ulong)l2_guest_dummy : (ulong)l2_guest_wait_for_ipi;
+
+	do {
+		if (irq_on_vmentry)
+			vcpu->vmcb->save.rflags |= X86_EFLAGS_IF;
+		else
+			vcpu->vmcb->save.rflags &= ~X86_EFLAGS_IF;
+
+		asm volatile("clgi;nop;sti");
+		// GIF is set by VMRUN
+		SVM_VMRUN(vcpu->vmcb, &vcpu->regs);
+		// GIF is cleared by VMEXIT
+		asm volatile("cli;nop;stgi");
+
+		assert(vcpu->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+
+	} while (old_count == *count);
+}
+#endif
+
+/******************************************************************************************************/
+
+#define FIRST_TEST_VCPU 1
+
+static void vcpu_init(void *data)
+{
+	/* To make it easier to see iteration number in the trace */
+	handle_irq(0x40, ipi_interrupt_handler);
+	handle_irq(0x50, ipi_interrupt_handler);
+}
+
+static void vcpu_code(void *data)
+{
+	int ncpus = cpu_count();
+	int cpu = (long)data;
+#ifdef __x86_64__
+	struct svm_vcpu vcpu;
+#endif
+
+	u64 i;
+
+#ifdef __x86_64__
+	if (cpu == 2 && use_svm)
+		svm_vcpu_init(&vcpu);
+#endif
+
+	assert(cpu != 0);
+
+	if (cpu != FIRST_TEST_VCPU)
+		wait_for_ipi(&isr_counts[cpu]);
+
+	for (i = 0; i < num_iterations; i++)
+	{
+		u8 physical_dst = cpu == ncpus -1 ? 1 : cpu + 1;
+
+		// send IPI to a next vCPU in a circular fashion
+		apic_icr_write(APIC_INT_ASSERT |
+				APIC_DEST_PHYSICAL |
+				APIC_DM_FIXED |
+				(i % 2 ? 0x40 : 0x50),
+				physical_dst);
+
+		if (i == (num_iterations - 1) && cpu != FIRST_TEST_VCPU)
+			break;
+
+#ifdef __x86_64__
+		// wait for the IPI interrupt chain to come back to us
+		if (cpu == 2 && use_svm) {
+				wait_for_ipi_in_l2(&isr_counts[cpu], &vcpu);
+				continue;
+		}
+#endif
+		wait_for_ipi(&isr_counts[cpu]);
+	}
+}
+
+int main(int argc, void** argv)
+{
+	int cpu, ncpus = cpu_count();
+
+	assert(ncpus > 2);
+
+	if (argc > 1)
+		hlt_allowed = atol(argv[1]);
+
+	if (argc > 2)
+		num_iterations = atol(argv[2]);
+
+	setup_vm();
+
+#ifdef __x86_64__
+	if (svm_supported()) {
+		use_svm = true;
+		setup_svm();
+	}
+#endif
+
+	isr_counts = (volatile u64 *)calloc(ncpus, sizeof(u64));
+
+	printf("found %d cpus\n", ncpus);
+	printf("running for %lld iterations - test\n",
+		(long long unsigned int)num_iterations);
+
+
+	for (cpu = 0; cpu < ncpus; ++cpu)
+		on_cpu_async(cpu, vcpu_init, (void *)(long)cpu);
+
+	/* now let all the vCPUs end the IPI function*/
+	while (cpus_active() > 1)
+		  pause();
+
+	printf("starting test on all cpus but 0...\n");
+
+	for (cpu = ncpus-1; cpu >= FIRST_TEST_VCPU; cpu--)
+		on_cpu_async(cpu, vcpu_code, (void *)(long)cpu);
+
+	printf("test started, waiting to end...\n");
+
+	while (cpus_active() > 1) {
+
+		unsigned long isr_count1, isr_count2;
+
+		isr_count1 = isr_counts[1];
+		delay(5ULL*1000*1000*1000);
+		isr_count2 = isr_counts[1];
+
+		if (isr_count1 == isr_count2) {
+			printf("\n");
+			printf("hang detected!!\n");
+			break;
+		} else {
+			printf("made %ld IPIs \n", (isr_count2 - isr_count1)*(ncpus-1));
+		}
+	}
+
+	printf("\n");
+
+	for (cpu = 1; cpu < ncpus; ++cpu)
+		report(isr_counts[cpu] == num_iterations,
+				"Number of IPIs match (%lld)",
+				(long long unsigned int)isr_counts[cpu]);
+
+	free((void*)isr_counts);
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index ebb3fdfc..7655d2ba 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -61,6 +61,11 @@ smp = 2
 file = smptest.flat
 smp = 3
 
+[ipi_stress]
+file = ipi_stress.flat
+extra_params = -cpu host,-x2apic,-svm,-hypervisor -global kvm-pit.lost_tick_policy=discard -machine kernel-irqchip=on -append '0 50000'
+smp = 4
+
 [vmexit_cpuid]
 file = vmexit.flat
 extra_params = -append 'cpuid'
-- 
2.26.3

