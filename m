Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFB9634129
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbiKVQPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234202AbiKVQOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFCA78D51
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Q8696iQnLEf/n5hLfcv6u+aW8uDnGU1lD812U05I3A=;
        b=WBD6YGUL3lfkBtLrgLPYwwIfaVkAJ6YVpxThv8SJfsPUB9P0EH3nRJMxti2QZ0zh7lfqhk
        c+bAlbS47MybZJGua6yUzPXFsqXdvfupzC6IPPfFcenCQoJLjhA9l3suiMAd+LaDogpnUE
        aonwT90JnzpymEAFu5JbsxuDe0C7k00=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-0RxWxZilMK-laeDB0No7UA-1; Tue, 22 Nov 2022 11:12:05 -0500
X-MC-Unique: 0RxWxZilMK-laeDB0No7UA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01E2D833A22;
        Tue, 22 Nov 2022 16:12:05 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 078901121314;
        Tue, 22 Nov 2022 16:12:02 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v3 04/27] svm: remove nop after stgi/clgi
Date:   Tue, 22 Nov 2022 18:11:29 +0200
Message-Id: <20221122161152.293072-5-mlevitsk@redhat.com>
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

Remove pointless nop after stgi/clgi - these instructions don't have an
interrupt window.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm_tests.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 02583236..88393fcf 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3026,7 +3026,7 @@ static void svm_intr_intercept_mix_run_guest(volatile int *counter, int expected
 }
 
 
-// subtest: test that enabling EFLAGS.IF is enought to trigger an interrupt
+// subtest: test that enabling EFLAGS.IF is enough to trigger an interrupt
 static void svm_intr_intercept_mix_if_guest(struct svm_test *test)
 {
 	asm volatile("nop;nop;nop;nop");
@@ -3065,7 +3065,6 @@ static void svm_intr_intercept_mix_gif_guest(struct svm_test *test)
 	report(!dummy_isr_recevied, "No interrupt expected");
 
 	stgi();
-	asm volatile("nop");
 	report(0, "must not reach here");
 }
 
@@ -3095,7 +3094,6 @@ static void svm_intr_intercept_mix_gif_guest2(struct svm_test *test)
 	report(!dummy_isr_recevied, "No interrupt expected");
 
 	stgi();
-	asm volatile("nop");
 	report(0, "must not reach here");
 }
 
@@ -3120,13 +3118,11 @@ static void svm_intr_intercept_mix_nmi_guest(struct svm_test *test)
 	cli(); // should have no effect
 
 	clgi();
-	asm volatile("nop");
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI, 0);
 	sti_nop(); // should have no effect
 	report(!nmi_recevied, "No NMI expected");
 
 	stgi();
-	asm volatile("nop");
 	report(0, "must not reach here");
 }
 
@@ -3150,11 +3146,9 @@ static void svm_intr_intercept_mix_smi_guest(struct svm_test *test)
 	asm volatile("nop;nop;nop;nop");
 
 	clgi();
-	asm volatile("nop");
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_SMI, 0);
 	sti_nop(); // should have no effect
 	stgi();
-	asm volatile("nop");
 	report(0, "must not reach here");
 }
 
-- 
2.34.3

