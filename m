Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419C6634128
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbiKVQPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbiKVQOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F9F74CCD
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rB6S9dfR5qeXPPDbFn2FE10FK+2JQ16Y39yd3U0tLtA=;
        b=aRo03ndxy/mmUOR2N0aqZzgHlnnP401ym7+LhtlQoG7YWLt2aWYoqxwMFEaQHZrJVb+Bi+
        5Hqsj+u7V1egvYrbriG1+V1CXROGqk6Xxvwxjk8VxlLSuPJ9luNEAZZ8C+GelA1GahkeGx
        p5dHzMXe79d0rp/LaVMG06KLa6tIDM4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-pR0VY8cCNGGu-x_TrRwk8g-1; Tue, 22 Nov 2022 11:12:17 -0500
X-MC-Unique: pR0VY8cCNGGu-x_TrRwk8g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65464800186;
        Tue, 22 Nov 2022 16:12:16 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 691541121314;
        Tue, 22 Nov 2022 16:12:14 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v3 09/27] svm: add simple nested shutdown test.
Date:   Tue, 22 Nov 2022 18:11:34 +0200
Message-Id: <20221122161152.293072-10-mlevitsk@redhat.com>
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

Add a simple test that a shutdown in L2 is intercepted
correctly by the L1.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm_tests.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index a7641fb8..7a67132a 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -11,6 +11,7 @@
 #include "apic.h"
 #include "delay.h"
 #include "x86/usermode.h"
+#include "vmalloc.h"
 
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
 
@@ -3238,6 +3239,21 @@ static void svm_exception_test(void)
 	}
 }
 
+static void shutdown_intercept_test_guest(struct svm_test *test)
+{
+	asm volatile ("ud2");
+	report_fail("should not reach here\n");
+
+}
+static void svm_shutdown_intercept_test(void)
+{
+	test_set_guest(shutdown_intercept_test_guest);
+	vmcb->save.idtr.base = (u64)alloc_vpage();
+	vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
+	svm_vmrun();
+	report(vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
+}
+
 struct svm_test svm_tests[] = {
 	{ "null", default_supported, default_prepare,
 	  default_prepare_gif_clear, null_test,
@@ -3349,6 +3365,7 @@ struct svm_test svm_tests[] = {
 	TEST(svm_intr_intercept_mix_smi),
 	TEST(svm_tsc_scale_test),
 	TEST(pause_filter_test),
+	TEST(svm_shutdown_intercept_test),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
-- 
2.34.3

