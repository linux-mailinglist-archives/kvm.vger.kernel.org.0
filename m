Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E04B4E47E7
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 21:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbiCVU6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 16:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbiCVU5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 16:57:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8D7F60D8
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647982580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z4/Jlb9AQ/Zg16L1o8VwLht7TqAxZDtF3j78kpYMeAI=;
        b=A+jc6HVJSJSy4r3WUPxW8vGgrtv4rGn6TGc2m+EoY5hgNoJzU+VPHh3of8xPxEZmbKAOXQ
        Sdh9miuromfEdJ2KgRXhoEJDYv64Tm/0JNecdp5c1kQdmFUkVoIvHtJ0sdMXgj+kKzzAQP
        JJyoCyRc5nYllnQqztjx7xyuAglXMEE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-miDYK59GM4mDTd5SWqAYrA-1; Tue, 22 Mar 2022 16:56:18 -0400
X-MC-Unique: miDYK59GM4mDTd5SWqAYrA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9247B899EC1
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 20:56:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75D7EC27E80;
        Tue, 22 Mar 2022 20:56:17 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 2/9] svm: Fix reg_corruption test, to avoid timer interrupt firing in later tests.
Date:   Tue, 22 Mar 2022 22:56:06 +0200
Message-Id: <20220322205613.250925-3-mlevitsk@redhat.com>
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

The test were setting APIC periodic timer but not disabling it later.

Fixes: da338a3 ("SVM: add test for nested guest RIP corruption")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm_tests.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 0707786..7a97847 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1847,7 +1847,7 @@ static bool reg_corruption_finished(struct svm_test *test)
         report_pass("No RIP corruption detected after %d timer interrupts",
                     isr_cnt);
         set_test_stage(test, 1);
-        return true;
+        goto cleanup;
     }
 
     if (vmcb->control.exit_code == SVM_EXIT_INTR) {
@@ -1861,11 +1861,16 @@ static bool reg_corruption_finished(struct svm_test *test)
         if (guest_rip == insb_instruction_label && io_port_var != 0xAA) {
             report_fail("RIP corruption detected after %d timer interrupts",
                         isr_cnt);
-            return true;
+            goto cleanup;
         }
 
     }
     return false;
+cleanup:
+    apic_write(APIC_LVTT, APIC_LVT_TIMER_MASK);
+    apic_write(APIC_TMICT, 0);
+    return true;
+
 }
 
 static bool reg_corruption_check(struct svm_test *test)
-- 
2.26.3

