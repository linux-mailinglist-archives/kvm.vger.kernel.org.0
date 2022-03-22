Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D6E4E47E3
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 21:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbiCVU6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 16:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235295AbiCVU55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 16:57:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6AECF60D8
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647982587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SCxCaXzsD64dZT9vpoGEXZkTLWh1XKLyjXU/a5a7SwI=;
        b=gtkmjOwc/CvTFtSNqkJtInE1wBRd3XvQYAOJciqUTWiy6nkVqX07plCU0K08MnMvIzp/qi
        iByKWxPAWIhv9D7r7840tAWvpsWrGkYtQsP1n6mjxpcJCo196qTMXPpM5mPi10yt8uGFEd
        kGoIKdcsx+8ze+9/9UTlEwuqtU5v/J4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-JooZl315NRm1YQsBHozX1w-1; Tue, 22 Mar 2022 16:56:26 -0400
X-MC-Unique: JooZl315NRm1YQsBHozX1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 033BB811E78
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 20:56:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA04DC27E80;
        Tue, 22 Mar 2022 20:56:24 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 7/9] svm: add tests for case when L1 intercepts various hardware interrupts
Date:   Tue, 22 Mar 2022 22:56:11 +0200
Message-Id: <20220322205613.250925-8-mlevitsk@redhat.com>
In-Reply-To: <20220322205613.250925-1-mlevitsk@redhat.com>
References: <20220322205613.250925-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(an interrupt, SMI, NMI), but lets L2 control either EFLAG.IF or GIF

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm.h       |  11 +++
 x86/svm_tests.c | 194 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 205 insertions(+)

diff --git a/x86/svm.h b/x86/svm.h
index 58b9410..df1b1ac 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -426,6 +426,17 @@ void test_set_guest(test_guest_func func);
 extern struct vmcb *vmcb;
 extern struct svm_test svm_tests[];
 
+static inline void stgi(void)
+{
+    asm volatile ("stgi");
+}
+
+static inline void clgi(void)
+{
+    asm volatile ("clgi");
+}
+
+
 
 #define SAVE_GPR_C                              \
         "xchg %%rbx, regs+0x8\n\t"              \
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index b2ba283..ef8b5ee 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3312,6 +3312,195 @@ static void svm_lbrv_nested_test2(void)
 	check_lbr(&host_branch4_from, &host_branch4_to);
 }
 
+
+// test that a nested guest which does enable INTR interception
+// but doesn't enable virtual interrupt masking works
+
+static volatile int dummy_isr_recevied;
+static void dummy_isr(isr_regs_t *regs)
+{
+	dummy_isr_recevied++;
+	eoi();
+}
+
+
+static volatile int nmi_recevied;
+static void dummy_nmi_handler(struct ex_regs *regs)
+{
+	nmi_recevied++;
+}
+
+
+static void svm_intr_intercept_mix_run_guest(volatile int *counter, int expected_vmexit)
+{
+	if (counter)
+		*counter = 0;
+
+	sti();  // host IF value should not matter
+	clgi(); // vmrun will set back GI to 1
+
+	svm_vmrun();
+
+	if (counter)
+		report(!*counter, "No interrupt expected");
+
+	stgi();
+
+	if (counter)
+		report(*counter == 1, "Interrupt is expected");
+
+	report (vmcb->control.exit_code == expected_vmexit, "Test expected VM exit");
+	report(vmcb->save.rflags & X86_EFLAGS_IF, "Guest should have EFLAGS.IF set now");
+	cli();
+}
+
+
+// subtest: test that enabling EFLAGS.IF is enought to trigger an interrupt
+static void svm_intr_intercept_mix_if_guest(struct svm_test *test)
+{
+	asm volatile("nop;nop;nop;nop");
+	report(!dummy_isr_recevied, "No interrupt expected");
+	sti();
+	asm volatile("nop");
+	report(0, "must not reach here");
+}
+
+static void svm_intr_intercept_mix_if(void)
+{
+	// make a physical interrupt to be pending
+	handle_irq(0x55, dummy_isr);
+
+	vmcb->control.intercept |= (1 << INTERCEPT_INTR);
+	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+	vmcb->save.rflags &= ~X86_EFLAGS_IF;
+
+	test_set_guest(svm_intr_intercept_mix_if_guest);
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | 0x55, 0);
+	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
+}
+
+
+// subtest: test that a clever guest can trigger an interrupt by setting GIF
+// if GIF is not intercepted
+static void svm_intr_intercept_mix_gif_guest(struct svm_test *test)
+{
+
+	asm volatile("nop;nop;nop;nop");
+	report(!dummy_isr_recevied, "No interrupt expected");
+
+	// clear GIF and enable IF
+	// that should still not cause VM exit
+	clgi();
+	sti();
+	asm volatile("nop");
+	report(!dummy_isr_recevied, "No interrupt expected");
+
+	stgi();
+	asm volatile("nop");
+	report(0, "must not reach here");
+}
+
+static void svm_intr_intercept_mix_gif(void)
+{
+	handle_irq(0x55, dummy_isr);
+
+	vmcb->control.intercept |= (1 << INTERCEPT_INTR);
+	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+	vmcb->save.rflags &= ~X86_EFLAGS_IF;
+
+	test_set_guest(svm_intr_intercept_mix_gif_guest);
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | 0x55, 0);
+	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
+}
+
+
+
+// subtest: test that a clever guest can trigger an interrupt by setting GIF
+// if GIF is not intercepted and interrupt comes after guest
+// started running
+static void svm_intr_intercept_mix_gif_guest2(struct svm_test *test)
+{
+	asm volatile("nop;nop;nop;nop");
+	report(!dummy_isr_recevied, "No interrupt expected");
+
+	clgi();
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | 0x55, 0);
+	report(!dummy_isr_recevied, "No interrupt expected");
+
+	stgi();
+	asm volatile("nop");
+	report(0, "must not reach here");
+}
+
+static void svm_intr_intercept_mix_gif2(void)
+{
+	handle_irq(0x55, dummy_isr);
+
+	vmcb->control.intercept |= (1 << INTERCEPT_INTR);
+	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+	vmcb->save.rflags |= X86_EFLAGS_IF;
+
+	test_set_guest(svm_intr_intercept_mix_gif_guest2);
+	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
+}
+
+
+// subtest: test that pending NMI will be handled when guest enables GIF
+static void svm_intr_intercept_mix_nmi_guest(struct svm_test *test)
+{
+	asm volatile("nop;nop;nop;nop");
+	report(!nmi_recevied, "No NMI expected");
+	cli(); // should have no effect
+
+	clgi();
+	asm volatile("nop");
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI, 0);
+	sti(); // should have no effect
+	asm volatile("nop");
+	report(!nmi_recevied, "No NMI expected");
+
+	stgi();
+	asm volatile("nop");
+	report(0, "must not reach here");
+}
+
+static void svm_intr_intercept_mix_nmi(void)
+{
+	handle_exception(2, dummy_nmi_handler);
+
+	vmcb->control.intercept |= (1 << INTERCEPT_NMI);
+	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+	vmcb->save.rflags |= X86_EFLAGS_IF;
+
+	test_set_guest(svm_intr_intercept_mix_nmi_guest);
+	svm_intr_intercept_mix_run_guest(&nmi_recevied, SVM_EXIT_NMI);
+}
+
+// test that pending SMI will be handled when guest enables GIF
+// TODO: can't really count #SMIs so just test that guest doesn't hang
+// and VMexits on SMI
+static void svm_intr_intercept_mix_smi_guest(struct svm_test *test)
+{
+	asm volatile("nop;nop;nop;nop");
+
+	clgi();
+	asm volatile("nop");
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_SMI, 0);
+	sti(); // should have no effect
+	asm volatile("nop");
+	stgi();
+	asm volatile("nop");
+	report(0, "must not reach here");
+}
+
+static void svm_intr_intercept_mix_smi(void)
+{
+	vmcb->control.intercept |= (1 << INTERCEPT_SMI);
+	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+	test_set_guest(svm_intr_intercept_mix_smi_guest);
+	svm_intr_intercept_mix_run_guest(NULL, SVM_EXIT_SMI);
+}
+
 struct svm_test svm_tests[] = {
     { "null", default_supported, default_prepare,
       default_prepare_gif_clear, null_test,
@@ -3439,5 +3628,10 @@ struct svm_test svm_tests[] = {
     TEST(svm_lbrv_test2),
     TEST(svm_lbrv_nested_test1),
     TEST(svm_lbrv_nested_test2),
+    TEST(svm_intr_intercept_mix_if),
+    TEST(svm_intr_intercept_mix_gif),
+    TEST(svm_intr_intercept_mix_gif2),
+    TEST(svm_intr_intercept_mix_nmi),
+    TEST(svm_intr_intercept_mix_smi),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.26.3

