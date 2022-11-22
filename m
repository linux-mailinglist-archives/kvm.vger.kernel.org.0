Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A50634124
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbiKVQPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbiKVQOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3C974A9A
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+o9tMxuiWQ6rW+T85YjL7aTCI2Gs7aoPou5Lg/h/14s=;
        b=A2k+Py4XmgnkOIQR8Wvik4L5Md7me5T+156T5i0jZDxr0PafkXgV15A05vumgD3ykhXvB2
        QjOHQHJM+V3SV66QKIbfQZOrVlipJI6gyypluBkMmVKYsOPmXicQ6a2n0mpvHLace0tN0x
        EHsHDAyYvBS5+MNmvrWwIDglkpcNP7A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-zh_p39I_PEeS7gO4jBU8ng-1; Tue, 22 Nov 2022 11:12:10 -0500
X-MC-Unique: zh_p39I_PEeS7gO4jBU8ng-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8867338012E0;
        Tue, 22 Nov 2022 16:12:09 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E54C1121314;
        Tue, 22 Nov 2022 16:12:07 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v3 06/27] svm: use apic_start_timer/apic_stop_timer instead of open coding it
Date:   Tue, 22 Nov 2022 18:11:31 +0200
Message-Id: <20221122161152.293072-7-mlevitsk@redhat.com>
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

This simplified code and ensures that after a subtest used apic timer,
it won't affect next subtests which are run after it.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm_tests.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index a5fabd4a..a7641fb8 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1144,9 +1144,10 @@ static void interrupt_test(struct svm_test *test)
 {
 	long long start, loops;
 
-	apic_write(APIC_LVTT, TIMER_VECTOR);
+	apic_setup_timer(TIMER_VECTOR, APIC_LVT_TIMER_PERIODIC);
 	sti();
-	apic_write(APIC_TMICT, 1); //Timer Initial Count Register 0x380 one-shot
+	apic_start_timer(1);
+
 	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
 		asm volatile ("nop");
 
@@ -1157,12 +1158,12 @@ static void interrupt_test(struct svm_test *test)
 		vmmcall();
 	}
 
-	apic_write(APIC_TMICT, 0);
+	apic_stop_timer();
 	cli();
 	vmmcall();
 
 	timer_fired = false;
-	apic_write(APIC_TMICT, 1);
+	apic_start_timer(1);
 	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
 		asm volatile ("nop");
 
@@ -1174,12 +1175,12 @@ static void interrupt_test(struct svm_test *test)
 	}
 
 	sti();
-	apic_write(APIC_TMICT, 0);
+	apic_stop_timer();
 	cli();
 
 	timer_fired = false;
 	start = rdtsc();
-	apic_write(APIC_TMICT, 1000000);
+	apic_start_timer(1000000);
 	safe_halt();
 
 	report(rdtsc() - start > 10000 && timer_fired,
@@ -1190,13 +1191,13 @@ static void interrupt_test(struct svm_test *test)
 		vmmcall();
 	}
 
-	apic_write(APIC_TMICT, 0);
+	apic_stop_timer();
 	cli();
 	vmmcall();
 
 	timer_fired = false;
 	start = rdtsc();
-	apic_write(APIC_TMICT, 1000000);
+	apic_start_timer(1000000);
 	asm volatile ("hlt");
 
 	report(rdtsc() - start > 10000 && timer_fired,
@@ -1207,8 +1208,7 @@ static void interrupt_test(struct svm_test *test)
 		vmmcall();
 	}
 
-	apic_write(APIC_TMICT, 0);
-	cli();
+	apic_cleanup_timer();
 }
 
 static bool interrupt_finished(struct svm_test *test)
@@ -1686,10 +1686,8 @@ static void reg_corruption_prepare(struct svm_test *test)
 	handle_irq(TIMER_VECTOR, reg_corruption_isr);
 
 	/* set local APIC to inject external interrupts */
-	apic_write(APIC_TMICT, 0);
-	apic_write(APIC_TDCR, 0);
-	apic_write(APIC_LVTT, TIMER_VECTOR | APIC_LVT_TIMER_PERIODIC);
-	apic_write(APIC_TMICT, 1000);
+	apic_setup_timer(TIMER_VECTOR, APIC_LVT_TIMER_PERIODIC);
+	apic_start_timer(1000);
 }
 
 static void reg_corruption_test(struct svm_test *test)
@@ -1734,8 +1732,7 @@ static bool reg_corruption_finished(struct svm_test *test)
 	}
 	return false;
 cleanup:
-	apic_write(APIC_LVTT, APIC_LVT_TIMER_MASK);
-	apic_write(APIC_TMICT, 0);
+	apic_cleanup_timer();
 	return true;
 
 }
-- 
2.34.3

