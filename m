Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8864E47E4
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 21:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbiCVU6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 16:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235087AbiCVU5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 16:57:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A8D6BE31
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647982581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/6+psNmciWHUDVo6oLa5Yb6bs9XiKM91HW+xvMJKg9Y=;
        b=HKbz0CyA4L9PPMvHpNQvN96gsdIOC9a1CZ+oEuVePggHgpjoFv9DgDl7v76oCl02H7JKl7
        izYKulGWByhXW2YqzIqWOOMLrN+DcGItzPz7pzmR37ur4v//AchgAg9z/82a6Ps1bLwtdc
        Zcqy66sTxib1erduwg3PpWOxkNXX8Pk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-XS31wkWUPD22u3_HgEjw8w-1; Tue, 22 Mar 2022 16:56:20 -0400
X-MC-Unique: XS31wkWUPD22u3_HgEjw8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15160185A7B2
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 20:56:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9D12C26E9A;
        Tue, 22 Mar 2022 20:56:18 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 3/9] svm: NMI is an "exception" and not interrupt in x86 land
Date:   Tue, 22 Mar 2022 22:56:07 +0200
Message-Id: <20220322205613.250925-4-mlevitsk@redhat.com>
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

