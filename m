Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487224AD958
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240197AbiBHNQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356428AbiBHMWB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 07:22:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD91FC03FEC0
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 04:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644322920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/6+psNmciWHUDVo6oLa5Yb6bs9XiKM91HW+xvMJKg9Y=;
        b=FeL1yis1DxswMJO4zddOl4z1wzHdn/16hWPc/KbHkaAbXVAF8+exQaIXdHDXJmK7RULMba
        vnIExSfY5XVZ2/RDDnJXZ1Y8DUiMC9NnU5pA1/WwcGxzJC1qPXGY+bCJZfVzFn1plznKId
        Z6WeVKFYhZpXwkiH0BXuzckwDt1Fwnk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-tMJt0m5xO3uHeTxPHIiQFw-1; Tue, 08 Feb 2022 07:21:56 -0500
X-MC-Unique: tMJt0m5xO3uHeTxPHIiQFw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C02231091DCD
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 12:21:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3E217ED84;
        Tue,  8 Feb 2022 12:21:54 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/7] svm: NMI is an "exception" and not interrupt in x86 land
Date:   Tue,  8 Feb 2022 14:21:44 +0200
Message-Id: <20220208122148.912913-4-mlevitsk@redhat.com>
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

This can interfere with later tests which do treat it
as an exception.

Fixes: d4db486 ("svm: Add test cases around NMI injection")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm_tests.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 7a97847..7586ef7 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1384,17 +1384,16 @@ static bool interrupt_check(struct svm_test *test)
 
 static volatile bool nmi_fired;
 
-static void nmi_handler(isr_regs_t *regs)
+static void nmi_handler(struct ex_regs *regs)
 {
     nmi_fired = true;
-    apic_write(APIC_EOI, 0);
 }
 
 static void nmi_prepare(struct svm_test *test)
 {
     default_prepare(test);
     nmi_fired = false;
-    handle_irq(NMI_VECTOR, nmi_handler);
+    handle_exception(NMI_VECTOR, nmi_handler);
     set_test_stage(test, 0);
 }
 
-- 
2.26.3

