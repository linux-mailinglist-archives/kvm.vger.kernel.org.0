Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524024AD94F
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348479AbiBHNQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356135AbiBHMV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 07:21:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E336C03FEC0
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 04:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644322916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z4/Jlb9AQ/Zg16L1o8VwLht7TqAxZDtF3j78kpYMeAI=;
        b=XTlmoTQGmX8a3yFfR4XzqhKpVU5jIE7mvlw/3MMRHKBMnJhLW8i7ZVn8jdAl6YQ/opwJFf
        v4prHmwxz52eBMYJbeLKcdn8qodYD7kjuxWX85c+xie1ne5CzZoAzWf3VGr3pJmg1okXTG
        rLqe26td3LpaIlDe3sPUj7OuBjIJh9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-yan5bOktPH2QBa-jVnnjqg-1; Tue, 08 Feb 2022 07:21:55 -0500
X-MC-Unique: yan5bOktPH2QBa-jVnnjqg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5881419611C9
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 12:21:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CCF37CD67;
        Tue,  8 Feb 2022 12:21:53 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/7] svm: Fix reg_corruption test, to avoid timer interrupt firing in later tests.
Date:   Tue,  8 Feb 2022 14:21:43 +0200
Message-Id: <20220208122148.912913-3-mlevitsk@redhat.com>
In-Reply-To: <20220208122148.912913-1-mlevitsk@redhat.com>
References: <20220208122148.912913-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

