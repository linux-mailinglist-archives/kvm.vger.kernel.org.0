Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4C463413C
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbiKVQQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiKVQPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:15:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5F068C65
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rJZV4DSctNC8ptqIu5ModGlaur/b1UApkri58lF9gTM=;
        b=Rc/JJG1R5AqWfMHXdPpGi4TyTIAiaYqDBLqXta9ypLwsLl+aqE/8NzFQVSXDe2mjufkTqf
        PNzdb69EOczG+m7DyGdsXNGZ6p3btIt5Hjjq+Ff7h+yNcHgVO8zcB1LecZnfOrWzr5Eeyo
        aG963ywMYM6WWv10Rj43J/HQV64+8aw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-mbDFVvK6P36vCE3DzEpFmg-1; Tue, 22 Nov 2022 11:12:44 -0500
X-MC-Unique: mbDFVvK6P36vCE3DzEpFmg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2C023C0E456;
        Tue, 22 Nov 2022 16:12:43 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0363B1121314;
        Tue, 22 Nov 2022 16:12:41 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v3 21/27] svm: cleanup the default_prepare
Date:   Tue, 22 Nov 2022 18:11:46 +0200
Message-Id: <20221122161152.293072-22-mlevitsk@redhat.com>
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

default_prepare only calls vmcb_indent, which is called before
each test anyway

Also don't call this now empty function from other
.prepare functions

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm.c       |  1 -
 x86/svm_tests.c | 18 ------------------
 2 files changed, 19 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index 2ab553a5..5667402b 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -30,7 +30,6 @@ bool default_supported(void)
 
 void default_prepare(struct svm_test *test)
 {
-	vmcb_ident(vmcb);
 }
 
 void default_prepare_gif_clear(struct svm_test *test)
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 70e41300..3b68718e 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -69,7 +69,6 @@ static bool check_vmrun(struct svm_test *test)
 
 static void prepare_rsm_intercept(struct svm_test *test)
 {
-	default_prepare(test);
 	vmcb->control.intercept |= 1 << INTERCEPT_RSM;
 	vmcb->control.intercept_exceptions |= (1ULL << UD_VECTOR);
 }
@@ -115,7 +114,6 @@ static bool finished_rsm_intercept(struct svm_test *test)
 
 static void prepare_cr3_intercept(struct svm_test *test)
 {
-	default_prepare(test);
 	vmcb->control.intercept_cr_read |= 1 << 3;
 }
 
@@ -149,7 +147,6 @@ static void corrupt_cr3_intercept_bypass(void *_test)
 
 static void prepare_cr3_intercept_bypass(struct svm_test *test)
 {
-	default_prepare(test);
 	vmcb->control.intercept_cr_read |= 1 << 3;
 	on_cpu_async(1, corrupt_cr3_intercept_bypass, test);
 }
@@ -169,7 +166,6 @@ static void test_cr3_intercept_bypass(struct svm_test *test)
 
 static void prepare_dr_intercept(struct svm_test *test)
 {
-	default_prepare(test);
 	vmcb->control.intercept_dr_read = 0xff;
 	vmcb->control.intercept_dr_write = 0xff;
 }
@@ -310,7 +306,6 @@ static bool check_next_rip(struct svm_test *test)
 
 static void prepare_msr_intercept(struct svm_test *test)
 {
-	default_prepare(test);
 	vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
 	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
 	memset(svm_get_msr_bitmap(), 0xff, MSR_BITMAP_SIZE);
@@ -711,7 +706,6 @@ static bool tsc_adjust_supported(void)
 
 static void tsc_adjust_prepare(struct svm_test *test)
 {
-	default_prepare(test);
 	vmcb->control.tsc_offset = TSC_OFFSET_VALUE;
 
 	wrmsr(MSR_IA32_TSC_ADJUST, -TSC_ADJUST_VALUE);
@@ -811,7 +805,6 @@ static void svm_tsc_scale_test(void)
 
 static void latency_prepare(struct svm_test *test)
 {
-	default_prepare(test);
 	runs = LATENCY_RUNS;
 	latvmrun_min = latvmexit_min = -1ULL;
 	latvmrun_max = latvmexit_max = 0;
@@ -884,7 +877,6 @@ static bool latency_check(struct svm_test *test)
 
 static void lat_svm_insn_prepare(struct svm_test *test)
 {
-	default_prepare(test);
 	runs = LATENCY_RUNS;
 	latvmload_min = latvmsave_min = latstgi_min = latclgi_min = -1ULL;
 	latvmload_max = latvmsave_max = latstgi_max = latclgi_max = 0;
@@ -965,7 +957,6 @@ static void pending_event_prepare(struct svm_test *test)
 {
 	int ipi_vector = 0xf1;
 
-	default_prepare(test);
 
 	pending_event_ipi_fired = false;
 
@@ -1033,8 +1024,6 @@ static bool pending_event_check(struct svm_test *test)
 
 static void pending_event_cli_prepare(struct svm_test *test)
 {
-	default_prepare(test);
-
 	pending_event_ipi_fired = false;
 
 	handle_irq(0xf1, pending_event_ipi_isr);
@@ -1139,7 +1128,6 @@ static void timer_isr(isr_regs_t *regs)
 
 static void interrupt_prepare(struct svm_test *test)
 {
-	default_prepare(test);
 	handle_irq(TIMER_VECTOR, timer_isr);
 	timer_fired = false;
 	set_test_stage(test, 0);
@@ -1272,7 +1260,6 @@ static void nmi_handler(struct ex_regs *regs)
 
 static void nmi_prepare(struct svm_test *test)
 {
-	default_prepare(test);
 	nmi_fired = false;
 	handle_exception(NMI_VECTOR, nmi_handler);
 	set_test_stage(test, 0);
@@ -1450,7 +1437,6 @@ static void my_isr(struct ex_regs *r)
 
 static void exc_inject_prepare(struct svm_test *test)
 {
-	default_prepare(test);
 	handle_exception(DE_VECTOR, my_isr);
 	handle_exception(NMI_VECTOR, my_isr);
 }
@@ -1519,7 +1505,6 @@ static void virq_isr(isr_regs_t *regs)
 static void virq_inject_prepare(struct svm_test *test)
 {
 	handle_irq(0xf1, virq_isr);
-	default_prepare(test);
 	vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
 		(0x0f << V_INTR_PRIO_SHIFT); // Set to the highest priority
 	vmcb->control.int_vector = 0xf1;
@@ -1682,7 +1667,6 @@ static void reg_corruption_isr(isr_regs_t *regs)
 
 static void reg_corruption_prepare(struct svm_test *test)
 {
-	default_prepare(test);
 	set_test_stage(test, 0);
 
 	vmcb->control.int_ctl = V_INTR_MASKING_MASK;
@@ -1877,7 +1861,6 @@ static void host_rflags_db_handler(struct ex_regs *r)
 
 static void host_rflags_prepare(struct svm_test *test)
 {
-	default_prepare(test);
 	handle_exception(DB_VECTOR, host_rflags_db_handler);
 	set_test_stage(test, 0);
 }
@@ -2610,7 +2593,6 @@ static void svm_vmload_vmsave(void)
 
 static void prepare_vgif_enabled(struct svm_test *test)
 {
-	default_prepare(test);
 }
 
 static void test_vgif(struct svm_test *test)
-- 
2.34.3

