Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313E05535A4
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352551AbiFUPOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352553AbiFUPOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:14:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 538B51261E
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655824376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=emlUx4gUafbHC/k2dMx86pJY4QHfljo+DDH8e6vUpz0=;
        b=VL05eOM3FVnT1/7HWU0Ke77s8dxKgB4D99o/ipsZlUZ1q7CZtvsMy6ZijBY94DSJ84eK+p
        nNurgQk0eDWUAiT7NKHnHkXFR/8N03bYHqgbkqK3heLA6/tz/eN2II9TCAYQnRkrX3aE/+
        bXGK9QxX57A26rO3Nw7No0/btCxTtUs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-j_NHfUW5MO-iDRlirOJCQQ-1; Tue, 21 Jun 2022 11:12:55 -0400
X-MC-Unique: j_NHfUW5MO-iDRlirOJCQQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEA01808788
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:12:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5F3F1121314;
        Tue, 21 Jun 2022 15:12:53 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH] Add test for #SMI during interrupt window
Date:   Tue, 21 Jun 2022 18:12:52 +0300
Message-Id: <20220621151252.47288-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test tests a corner case in which KVM doesn't
preserve STI interrupt shadow when #SMI arrives during it.

Due to apparent fact that STI interrupt shadow blocks real interrupts as well,
and thus prevents a vCPU kick to make the CPU enter SMM,
during the interrupt shadow, a workaround was used:

An instruction which gets VMexit anyway, but retried by
KVM is used in the interrupt shadow.

While emulating such instruction KVM doesn't reset the interrupt shadow
(because it retries it), but it can notice the pending #SMI and enter SMM,
thus the test tests that interrupt shadow in this case is preserved.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/Makefile.common  |   3 +-
 x86/Makefile.x86_64  |   1 +
 x86/smm_int_window.c | 125 +++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg    |   5 ++
 4 files changed, 133 insertions(+), 1 deletion(-)
 create mode 100644 x86/smm_int_window.c

diff --git a/x86/Makefile.common b/x86/Makefile.common
index a600c72d..224a46ee 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -85,7 +85,8 @@ tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
                $(TEST_DIR)/tsx-ctrl.$(exe) \
                $(TEST_DIR)/eventinj.$(exe) \
                $(TEST_DIR)/smap.$(exe) \
-               $(TEST_DIR)/umip.$(exe)
+               $(TEST_DIR)/umip.$(exe) \
+               $(TEST_DIR)/smm_int_window.$(exe)
 
 # The following test cases are disabled when building EFI tests because they
 # use absolute addresses in their inline assembly code, which cannot compile
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index e19284ae..31479777 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -34,6 +34,7 @@ tests += $(TEST_DIR)/rdpru.$(exe)
 tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
 
+
 ifeq ($(CONFIG_EFI),y)
 tests += $(TEST_DIR)/amd_sev.$(exe)
 endif
diff --git a/x86/smm_int_window.c b/x86/smm_int_window.c
new file mode 100644
index 00000000..70c5336a
--- /dev/null
+++ b/x86/smm_int_window.c
@@ -0,0 +1,125 @@
+#include "libcflat.h"
+#include "apic.h"
+#include "processor.h"
+#include "smp.h"
+#include "isr.h"
+#include "delay.h"
+#include "asm/barrier.h"
+#include "alloc_page.h"
+
+volatile int bad_int_received;
+
+extern u64 shadow_label;
+
+static void dummy_ipi_isr(isr_regs_t *regs)
+{
+	/* should never reach here */
+	if (regs->rip == (u64)&shadow_label) {
+		bad_int_received++;
+	}
+	eoi();
+}
+
+
+#define SELF_INT_VECTOR 0xBB
+
+volatile bool test_ended;
+volatile bool send_smi;
+
+static void vcpu1_code(void *data)
+{
+	/*
+	 * Flood vCPU0 with #SMIs
+	 *
+	 * Note that kvm unit tests run with seabios and its #SMI handler
+	 * is only installed on vCPU0 (BSP).
+	 * Sending #SMI to any other CPU will crash the guest
+
+	 * */
+	setup_vm();
+
+	while (!test_ended) {
+
+		if (send_smi) {
+			apic_icr_write(APIC_INT_ASSERT | APIC_DEST_PHYSICAL | APIC_DM_SMI, 0);
+			send_smi = false;
+		}
+		cpu_relax();
+	}
+}
+
+#define MEM_ALLOC_ORDER 16
+
+int main(void)
+{
+	int i;
+	unsigned volatile char *mem;
+
+	setup_vm();
+	cli();
+
+	mem = alloc_pages_flags(MEM_ALLOC_ORDER, AREA_ANY | FLAG_DONTZERO);
+	assert(mem);
+
+	handle_irq(SELF_INT_VECTOR, dummy_ipi_isr);
+	on_cpu_async(1, vcpu1_code, NULL);
+
+	for  (i = 0 ; i < (1 << MEM_ALLOC_ORDER) ; i++) {
+
+		apic_icr_write(APIC_INT_ASSERT | APIC_DEST_PHYSICAL | APIC_DM_FIXED | SELF_INT_VECTOR, 0);
+
+		/* in case the sender is still sending #SMI, wait for it*/
+		while (send_smi)
+			;
+
+		/* ask the peer vCPU to send SMI to us */
+		send_smi = true;
+
+		asm volatile("sti");
+		asm volatile("shadow_label:\n");
+
+		/*
+		 * The below memory access should never get an interrupt because
+		 * it is in an interrupt shadow from the STI.
+		 *
+		 * Note that seems that even if a real interrupt happens, it will
+		 * still not interrupt this instruction, thus vCPU kick from
+		 * vCPU1, when it attempts to send #SMI to us is not enough itself,
+		 * to trigger the switch to SMM mode at this point.
+		 * Therefore STI;CLI sequence itself doesn't lead to #SMI happening
+		 * in between these instructions.
+		 *
+		 * So make the an instruction that accesses a fresh memory, which will
+		 * force the CPU to  #VMEXIT and just before resuming the guest,
+		 * KVM might notice incoming #SMI, and enter the SMM
+		 * with a still pending interrupt shadow.
+		 *
+		 * Also note that, just an #VMEXITing instruction like CPUID
+		 * can't be used here, because KVM itself will emulate it,
+		 * and clear the interrupt shadow, prior to entering the SMM.
+		 *
+		 * Test that in this case, the interrupt shadow is preserved,
+		 * which means that upon exit from #SMI  handler, the instruction
+		 * should still not get the pending interrupt
+		 */
+
+		*(mem+(i<<12)) = 1;
+
+		asm volatile("cli");
+
+		if (bad_int_received)
+			break;
+	}
+
+	test_ended = 1;
+
+	while (cpus_active() > 1)
+		cpu_relax();
+
+	if (bad_int_received)
+		report (0, "Unexpected interrupt received during interrupt shadow");
+	else
+		report(1, "Test passed");
+
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 37017971..0d90b802 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -455,3 +455,8 @@ file = cet.flat
 arch = x86_64
 smp = 2
 extra_params = -enable-kvm -m 2048 -cpu host
+
+[smm_int_window]
+file = smm_int_window.flat
+smp = 2
+extra_params = -machine smm=on -machine kernel-irqchip=on -m 2g
-- 
2.26.3

