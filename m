Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690C7634125
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiKVQPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbiKVQOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B42742C5
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DzpsXjizQ1d1Z+TU7wUpzRDezGYZloQ0pHxqkvCEBIM=;
        b=Q8yCjyUGBGlURTmjG2yfoeYWus53RdyYkJ895z3XYzN3xEinWRp44uiGJLDceF9rdZau2C
        +UYwaFAp5BQUezRFZAthTYkvjoZMtHJwDY7U1eTCkPzykLgr7pzrbssVA7x0z8pT+GS4u1
        k1928mMDD1KfbYuWTA1M/VIDSxKlslk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-GtJq6xdHPve_ynqnybSWxA-1; Tue, 22 Nov 2022 11:12:07 -0500
X-MC-Unique: GtJq6xdHPve_ynqnybSWxA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45987833AF4;
        Tue, 22 Nov 2022 16:12:07 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AEB9111F3BB;
        Tue, 22 Nov 2022 16:12:05 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v3 05/27] svm: make svm_intr_intercept_mix_if/gif test a bit more robust
Date:   Tue, 22 Nov 2022 18:11:30 +0200
Message-Id: <20221122161152.293072-6-mlevitsk@redhat.com>
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

When injecting self IPI the test assumes that initial EFLAGS.IF flag is
zero, but previous tests might have set it.

Explicitly disable interrupts to avoid this assumption.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm_tests.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 88393fcf..a5fabd4a 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3045,6 +3045,7 @@ static void svm_intr_intercept_mix_if(void)
 	vmcb->save.rflags &= ~X86_EFLAGS_IF;
 
 	test_set_guest(svm_intr_intercept_mix_if_guest);
+	cli();
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | 0x55, 0);
 	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
 }
@@ -3077,6 +3078,7 @@ static void svm_intr_intercept_mix_gif(void)
 	vmcb->save.rflags &= ~X86_EFLAGS_IF;
 
 	test_set_guest(svm_intr_intercept_mix_gif_guest);
+	cli();
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | 0x55, 0);
 	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
 }
-- 
2.34.3

