Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC042634127
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbiKVQPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbiKVQOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A11479914
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GdF4iA89slSabFHBvp0G6JXHx+KX7fh+rsl20EPvLAM=;
        b=DslTDZjlTx4aZEmK85uAC7QnzXEn4t/051YD31YB/4SmH/eLaRv1r9q8p8k9Bw/nIeLJXY
        V4O8LNCM3TKY5pWNpnMUXy5uC3TAIksNGbQgMG6FtE6VVdU844+GUpSSFQ30+WidHRv7sR
        swKUJPTJA0zPe+BCBqrEHDLCKepKI6M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-Yjhi2ah5NqCLmzkJWBrKdw-1; Tue, 22 Nov 2022 11:12:19 -0500
X-MC-Unique: Yjhi2ah5NqCLmzkJWBrKdw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A93ED29AB418;
        Tue, 22 Nov 2022 16:12:18 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE35B1121314;
        Tue, 22 Nov 2022 16:12:16 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v3 10/27] SVM: add two tests for exitintinto on exception
Date:   Tue, 22 Nov 2022 18:11:35 +0200
Message-Id: <20221122161152.293072-11-mlevitsk@redhat.com>
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

Test that exitintinfo is set correctly when
exception happens during exception/interrupt delivery
and that exception is intercepted.

Note that those tests currently fail, due to few bugs in KVM.

Also note that those bugs are in KVM's common x86 code,
thus the issue exists on VMX as well and unit tests
that reproduce those on VMX will be written as well.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm_tests.c | 148 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 148 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 7a67132a..202e9271 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3254,6 +3254,145 @@ static void svm_shutdown_intercept_test(void)
 	report(vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
 }
 
+/*
+ * Test that nested exceptions are delivered correctly
+ * when parent exception is intercepted
+ */
+
+static void exception_merging_prepare(struct svm_test *test)
+{
+	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
+
+	/* break UD vector idt entry to get #GP*/
+	boot_idt[UD_VECTOR].type = 1;
+}
+
+static void exception_merging_test(struct svm_test *test)
+{
+	asm volatile ("ud2");
+}
+
+static bool exception_merging_finished(struct svm_test *test)
+{
+	u32 vec = vmcb->control.exit_int_info & SVM_EXITINTINFO_VEC_MASK;
+	u32 type = vmcb->control.exit_int_info & SVM_EXITINTINFO_TYPE_MASK;
+
+	if (vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + GP_VECTOR) {
+		report(false, "unexpected VM exit");
+		goto out;
+	}
+
+	if (!(vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID)) {
+		report(false, "EXITINTINFO not valid");
+		goto out;
+	}
+
+	if (type != SVM_EXITINTINFO_TYPE_EXEPT) {
+		report(false, "Incorrect event type in EXITINTINFO");
+		goto out;
+	}
+
+	if (vec != UD_VECTOR) {
+		report(false, "Incorrect vector in EXITINTINFO");
+		goto out;
+	}
+
+	set_test_stage(test, 1);
+out:
+	boot_idt[UD_VECTOR].type = 14;
+	return true;
+}
+
+static bool exception_merging_check(struct svm_test *test)
+{
+	return get_test_stage(test) == 1;
+}
+
+
+/*
+ * Test that if exception is raised during interrupt delivery,
+ * and that exception is intercepted, the interrupt is preserved
+ * in EXITINTINFO of the exception
+ */
+
+static void interrupt_merging_prepare(struct svm_test *test)
+{
+	/* intercept #GP */
+	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
+
+	/* set local APIC to inject external interrupts */
+	apic_setup_timer(TIMER_VECTOR, APIC_LVT_TIMER_PERIODIC);
+	apic_start_timer(100000);
+}
+
+#define INTERRUPT_MERGING_DELAY 100000000ULL
+
+static void interrupt_merging_test(struct svm_test *test)
+{
+	handle_irq(TIMER_VECTOR, timer_isr);
+	/* break timer vector IDT entry to get #GP on interrupt delivery */
+	boot_idt[TIMER_VECTOR].type = 1;
+
+	sti();
+	delay(INTERRUPT_MERGING_DELAY);
+}
+
+static bool interrupt_merging_finished(struct svm_test *test)
+{
+
+	u32 vec = vmcb->control.exit_int_info & SVM_EXITINTINFO_VEC_MASK;
+	u32 type = vmcb->control.exit_int_info & SVM_EXITINTINFO_TYPE_MASK;
+	u32 error_code = vmcb->control.exit_info_1;
+
+	/* exit on external interrupts is disabled, thus timer interrupt
+	 * should be attempted to be delivered, but due to incorrect IDT entry
+	 * an #GP should be raised
+	 */
+	if (vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + GP_VECTOR) {
+		report(false, "unexpected VM exit");
+		goto cleanup;
+	}
+
+	/* GP error code should be about an IDT entry, and due to external event */
+	if (error_code != (TIMER_VECTOR << 3 | 3)) {
+		report(false, "Incorrect error code of the GP exception");
+		goto cleanup;
+	}
+
+	/* Original interrupt should be preserved in EXITINTINFO */
+	if (!(vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID)) {
+		report(false, "EXITINTINFO not valid");
+		goto cleanup;
+	}
+
+	if (type != SVM_EXITINTINFO_TYPE_INTR) {
+		report(false, "Incorrect event type in EXITINTINFO");
+		goto cleanup;
+	}
+
+	if (vec != TIMER_VECTOR) {
+		report(false, "Incorrect vector in EXITINTINFO");
+		goto cleanup;
+	}
+
+	set_test_stage(test, 1);
+
+cleanup:
+	// restore the IDT gate
+	boot_idt[TIMER_VECTOR].type = 14;
+	wmb();
+	// eoi the interrupt we got #GP for
+	eoi();
+	apic_cleanup_timer();
+	return true;
+}
+
+static bool interrupt_merging_check(struct svm_test *test)
+{
+	return get_test_stage(test) == 1;
+}
+
+
 struct svm_test svm_tests[] = {
 	{ "null", default_supported, default_prepare,
 	  default_prepare_gif_clear, null_test,
@@ -3346,6 +3485,15 @@ struct svm_test svm_tests[] = {
 	{ "vgif", vgif_supported, prepare_vgif_enabled,
 	  default_prepare_gif_clear, test_vgif, vgif_finished,
 	  vgif_check },
+	{ "exception_merging", default_supported,
+	  exception_merging_prepare, default_prepare_gif_clear,
+	  exception_merging_test,  exception_merging_finished,
+	  exception_merging_check },
+	{ "interrupt_merging", default_supported,
+	  interrupt_merging_prepare, default_prepare_gif_clear,
+	  interrupt_merging_test,  interrupt_merging_finished,
+	  interrupt_merging_check },
+
 	TEST(svm_cr4_osxsave_test),
 	TEST(svm_guest_state_test),
 	TEST(svm_vmrun_errata_test),
-- 
2.34.3

