Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0A5606454
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiJTPYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiJTPY3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:24:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB549558D
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666279461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u2MEWLku3rrMjsII8hzq6KbZdxHmv1/TqUgauk61G2g=;
        b=ZK3Wd54cOZihWelZ4QEExGG0gvYgvW+cDq3m1V2cj80V7xM5lhiykX50uUMBPHsvYIEQMs
        K2U9sFAmtEzXw+7f9X8Sl231JAOBiq1khTe1GP0ArCBxjrGl/xeIqzir0WW69rVgq1hHYA
        oX1s6X3pSEs3IepYsKK41lo+apwpocw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-REgdSpMcOmKFsDiqAxY99Q-1; Thu, 20 Oct 2022 11:24:13 -0400
X-MC-Unique: REgdSpMcOmKFsDiqAxY99Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E12512A59576
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:24:12 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B038B2028DC1;
        Thu, 20 Oct 2022 15:24:11 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 03/16] svm: use irq_enable instead of sti/nop
Date:   Thu, 20 Oct 2022 18:23:51 +0300
Message-Id: <20221020152404.283980-4-mlevitsk@redhat.com>
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

Use irq_enable instead of open coded sti;nop also while at it,
remove nop after stgi/clgi - these instructions don't have an
interrupt window.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm_tests.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index a6397821..a6b26e72 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3141,8 +3141,7 @@ static void svm_intr_intercept_mix_if_guest(struct svm_test *test)
 {
 	asm volatile("nop;nop;nop;nop");
 	report(!dummy_isr_recevied, "No interrupt expected");
-	sti();
-	asm volatile("nop");
+	irq_enable();
 	report(0, "must not reach here");
 }
 
@@ -3172,12 +3171,10 @@ static void svm_intr_intercept_mix_gif_guest(struct svm_test *test)
 	// clear GIF and enable IF
 	// that should still not cause VM exit
 	clgi();
-	sti();
-	asm volatile("nop");
+	irq_enable();
 	report(!dummy_isr_recevied, "No interrupt expected");
 
 	stgi();
-	asm volatile("nop");
 	report(0, "must not reach here");
 }
 
@@ -3207,7 +3204,6 @@ static void svm_intr_intercept_mix_gif_guest2(struct svm_test *test)
 	report(!dummy_isr_recevied, "No interrupt expected");
 
 	stgi();
-	asm volatile("nop");
 	report(0, "must not reach here");
 }
 
@@ -3232,14 +3228,11 @@ static void svm_intr_intercept_mix_nmi_guest(struct svm_test *test)
 	cli(); // should have no effect
 
 	clgi();
-	asm volatile("nop");
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI, 0);
-	sti(); // should have no effect
-	asm volatile("nop");
+	irq_enable();
 	report(!nmi_recevied, "No NMI expected");
 
 	stgi();
-	asm volatile("nop");
 	report(0, "must not reach here");
 }
 
@@ -3263,12 +3256,9 @@ static void svm_intr_intercept_mix_smi_guest(struct svm_test *test)
 	asm volatile("nop;nop;nop;nop");
 
 	clgi();
-	asm volatile("nop");
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_SMI, 0);
-	sti(); // should have no effect
-	asm volatile("nop");
+	irq_enable();
 	stgi();
-	asm volatile("nop");
 	report(0, "must not reach here");
 }
 
-- 
2.26.3

