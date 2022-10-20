Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F1160644F
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiJTPYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiJTPY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:24:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E69A1C19E4
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666279458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0hJ1g5jkerJHlBrDYBS6LrQ4Vr4DgDYn8+AbEGX4AeQ=;
        b=E5AorbjyciTXRAb+lYMXFvJyO8s0C7G3Bo7fUZFiPimse0D8G7v7Heqwpr5ZeROdez72WV
        Us71HZgopBvPUEdKkakFr7HOaG4MgNNLWXLnGbMrMhZ5nuPYTSeh0v5ijDVUhQS86NSW5H
        413axSbKWDF1UTrVIOvTUgxKgFKYbWY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-NJGG2MQEPIOqczDrtPO5ZA-1; Thu, 20 Oct 2022 11:24:16 -0400
X-MC-Unique: NJGG2MQEPIOqczDrtPO5ZA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1840C87A9E6
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:24:16 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB2B12024CB7;
        Thu, 20 Oct 2022 15:24:14 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 05/16] svm: use apic_start_timer/apic_stop_timer instead of open coding it
Date:   Thu, 20 Oct 2022 18:23:53 +0300
Message-Id: <20221020152404.283980-6-mlevitsk@redhat.com>
In-Reply-To: <20221020152404.283980-1-mlevitsk@redhat.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 x86/svm_tests.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index d734e5f7..19b35e95 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1147,9 +1147,10 @@ static void interrupt_test(struct svm_test *test)
 {
 	long long start, loops;
 
-	apic_write(APIC_LVTT, TIMER_VECTOR);
+	apic_setup_timer(TIMER_VECTOR, false);
+
 	irq_enable();
-	apic_write(APIC_TMICT, 1); //Timer Initial Count Register 0x380 one-shot
+	apic_start_timer(1);
 	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
 		asm volatile ("nop");
 
@@ -1160,12 +1161,12 @@ static void interrupt_test(struct svm_test *test)
 		vmmcall();
 	}
 
-	apic_write(APIC_TMICT, 0);
+	apic_stop_timer();
 	irq_disable();
 	vmmcall();
 
 	timer_fired = false;
-	apic_write(APIC_TMICT, 1);
+	apic_start_timer(1);
 	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
 		asm volatile ("nop");
 
@@ -1177,12 +1178,12 @@ static void interrupt_test(struct svm_test *test)
 	}
 
 	irq_enable();
-	apic_write(APIC_TMICT, 0);
+	apic_stop_timer();
 	irq_disable();
 
 	timer_fired = false;
 	start = rdtsc();
-	apic_write(APIC_TMICT, 1000000);
+	apic_start_timer(1000000);
 	safe_halt();
 
 	report(rdtsc() - start > 10000 && timer_fired,
@@ -1193,13 +1194,13 @@ static void interrupt_test(struct svm_test *test)
 		vmmcall();
 	}
 
-	apic_write(APIC_TMICT, 0);
+	apic_stop_timer();
 	irq_disable();
 	vmmcall();
 
 	timer_fired = false;
 	start = rdtsc();
-	apic_write(APIC_TMICT, 1000000);
+	apic_start_timer(1000000);
 	asm volatile ("hlt");
 
 	report(rdtsc() - start > 10000 && timer_fired,
@@ -1210,7 +1211,7 @@ static void interrupt_test(struct svm_test *test)
 		vmmcall();
 	}
 
-	apic_write(APIC_TMICT, 0);
+	apic_cleanup_timer();
 	irq_disable();
 }
 
@@ -1693,10 +1694,8 @@ static void reg_corruption_prepare(struct svm_test *test)
 	handle_irq(TIMER_VECTOR, reg_corruption_isr);
 
 	/* set local APIC to inject external interrupts */
-	apic_write(APIC_TMICT, 0);
-	apic_write(APIC_TDCR, 0);
-	apic_write(APIC_LVTT, TIMER_VECTOR | APIC_LVT_TIMER_PERIODIC);
-	apic_write(APIC_TMICT, 1000);
+	apic_setup_timer(TIMER_VECTOR, true);
+	apic_start_timer(1000);
 }
 
 static void reg_corruption_test(struct svm_test *test)
@@ -1742,8 +1741,7 @@ static bool reg_corruption_finished(struct svm_test *test)
 	}
 	return false;
 cleanup:
-	apic_write(APIC_LVTT, APIC_LVT_TIMER_MASK);
-	apic_write(APIC_TMICT, 0);
+	apic_cleanup_timer();
 	return true;
 
 }
-- 
2.26.3

