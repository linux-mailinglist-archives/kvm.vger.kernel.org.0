Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B71963412F
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbiKVQPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbiKVQOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864EB78D4F
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wyitGMd7mK0wdcANEHOaKxzE5H2FoeY5rTWAeyRRtQg=;
        b=BVYseWNNXgTmLEXoGFXqWfZ9EKhJiF3FRHXjtJYojlJjG+A/moAMkpPtumEdiQ+3gsISWf
        XfS37gO1foH6Jqte7AcCiY7HjTzpI97r06uHMFVpgL26Fyt0c2IeKB8V2Bd7QRvlOGKHh2
        D+y9m9EtKQ6o3NICRKaERI/2wX6asKU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-o8a65vIxMqq4wajt6ytB1A-1; Tue, 22 Nov 2022 11:12:12 -0500
X-MC-Unique: o8a65vIxMqq4wajt6ytB1A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D308A1C0896E;
        Tue, 22 Nov 2022 16:12:11 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D15351121314;
        Tue, 22 Nov 2022 16:12:09 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v3 07/27] x86: Add test for #SMI during interrupt window
Date:   Tue, 22 Nov 2022 18:11:32 +0200
Message-Id: <20221122161152.293072-8-mlevitsk@redhat.com>
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
 x86/smm_int_window.c | 118 +++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg    |   5 ++
 4 files changed, 126 insertions(+), 1 deletion(-)
 create mode 100644 x86/smm_int_window.c

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 365e199f..698a48ab 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -87,7 +87,8 @@ tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
                $(TEST_DIR)/emulator.$(exe) \
                $(TEST_DIR)/eventinj.$(exe) \
                $(TEST_DIR)/smap.$(exe) \
-               $(TEST_DIR)/umip.$(exe)
+               $(TEST_DIR)/umip.$(exe) \
+               $(TEST_DIR)/smm_int_window.$(exe)
 
 # The following test cases are disabled when building EFI tests because they
 # use absolute addresses in their inline assembly code, which cannot compile
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index f483dead..5d66b201 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -35,6 +35,7 @@ tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
 tests += $(TEST_DIR)/pmu_pebs.$(exe)
 
+
 ifeq ($(CONFIG_EFI),y)
 tests += $(TEST_DIR)/amd_sev.$(exe)
 endif
diff --git a/x86/smm_int_window.c b/x86/smm_int_window.c
new file mode 100644
index 00000000..d3a2b073
--- /dev/null
+++ b/x86/smm_int_window.c
@@ -0,0 +1,118 @@
+#include "libcflat.h"
+#include "apic.h"
+#include "processor.h"
+#include "smp.h"
+#include "isr.h"
+#include "asm/barrier.h"
+#include "alloc_page.h"
+#include "asm/page.h"
+
+#define SELF_INT_VECTOR 0xBB
+#define MEM_ALLOC_ORDER 16
+
+volatile int bad_int_received;
+volatile bool test_ended;
+volatile bool send_smi;
+
+extern unsigned long shadow_label;
+
+static void dummy_ipi_isr(isr_regs_t *regs)
+{
+	/*
+	 * Test that we never get the interrupt on the instruction which
+	 * is in interrupt shadow
+	 */
+	if (regs->rip == (unsigned long)&shadow_label)
+		bad_int_received++;
+	eoi();
+}
+
+static void vcpu1_code(void *data)
+{
+	/*
+	 * Flood vCPU0 with #SMIs
+	 *
+	 * Note that kvm unit tests run with seabios and its #SMI handler
+	 * is only installed on vCPU0 (BSP).
+	 * Sending #SMI to any other CPU will crash the guest
+	 */
+	setup_vm();
+
+	while (!test_ended) {
+		if (send_smi) {
+			apic_icr_write(APIC_INT_ASSERT | APIC_DEST_PHYSICAL | APIC_DM_SMI, 0);
+			send_smi = false;
+		}
+		cpu_relax();
+	}
+}
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
+	for  (i = 0 ; i < (1 << MEM_ALLOC_ORDER) && !bad_int_received ; i++) {
+
+		apic_icr_write(APIC_INT_ASSERT | APIC_DEST_PHYSICAL |
+			       APIC_DM_FIXED | SELF_INT_VECTOR, 0);
+
+		/* in case the sender is still sending #SMI, wait for it*/
+		while (send_smi)
+			;
+
+		/* ask the peer vCPU to send SMI to us */
+		send_smi = true;
+
+		/*
+		 * The below memory access should never get an interrupt because
+		 * it is in an interrupt shadow from the STI.
+		 *
+		 * Note that seems that even if a real interrupt happens, it will
+		 * still not interrupt this instruction, thus vCPU kick from
+		 * vCPU1, when it attempts to send #SMI to us is itself not enough,
+		 * to trigger the switch to SMM mode at this point.
+
+		 * Therefore STI;NOP;CLI sequence itself doesn't lead to #SMI happening
+		 * in between these instructions.
+		 *
+		 * So instead of NOP, make an instruction that accesses a fresh memory,
+		 * which will force the CPU to  #VMEXIT and just before resuming the guest,
+		 * KVM might notice the incoming #SMI, and enter the SMM
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
+		asm volatile(
+			"sti\n"
+			"shadow_label:\n"
+			"movl $1, %0\n"
+			"cli\n"
+			: "=m" (*(mem+i*PAGE_SIZE))
+			::
+		);
+	}
+
+	test_ended = 1;
+	while (cpus_active() > 1)
+		cpu_relax();
+
+	report(!bad_int_received, "No interrupts during the interrupt shadow");
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index f324e32d..e803ba03 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -478,3 +478,8 @@ file = cet.flat
 arch = x86_64
 smp = 2
 extra_params = -enable-kvm -m 2048 -cpu host
+
+[smm_int_window]
+file = smm_int_window.flat
+smp = 2
+extra_params = -machine smm=on -machine kernel-irqchip=on -m 2g
-- 
2.34.3

