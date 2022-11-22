Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F1A63413B
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbiKVQPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234289AbiKVQPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:15:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4B059FEB
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PfMdLweBiVq1o4WTC4i8amovSsSD+I0L+LYgTrQswSc=;
        b=OnJaKQsCKmliFOPnN+Y4Maope9k37VEX5o3WgNMV3wQpFCuwr47Q3klrUzuevaWGUuVAB3
        iYRJUBcmDi7v+zQUqJ5XvWJd3aM6C3w9iZ5zccKEDPwYAIy4Z9Wv3FcFe4o02Wy6NDkdDC
        0awW0uB+cnrK/LMXHgxZ2qNJodUpl0k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-2YgFqA_UMv6W81H-eM04Ig-1; Tue, 22 Nov 2022 11:12:42 -0500
X-MC-Unique: 2YgFqA_UMv6W81H-eM04Ig-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AED592999B42;
        Tue, 22 Nov 2022 16:12:41 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B47C31121314;
        Tue, 22 Nov 2022 16:12:39 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v3 20/27] svm: move v2 tests run into test_run
Date:   Tue, 22 Nov 2022 18:11:45 +0200
Message-Id: <20221122161152.293072-21-mlevitsk@redhat.com>
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

Move v2 tests running into test_run which allows to have code that runs the
test in one place and allows to run v2 tests on a non 0 vCPU if needed.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index 220bce66..2ab553a5 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -106,6 +106,13 @@ int svm_vmrun(void)
 
 static noinline void test_run(struct svm_test *test)
 {
+	if (test->v2) {
+		vmcb_ident(vmcb);
+		v2_test = test;
+		test->v2();
+		return;
+	}
+
 	cli();
 	vmcb_ident(vmcb);
 
@@ -196,21 +203,19 @@ int run_svm_tests(int ac, char **av, struct svm_test *svm_tests)
 			continue;
 		if (svm_tests[i].supported && !svm_tests[i].supported())
 			continue;
-		if (svm_tests[i].v2 == NULL) {
-			if (svm_tests[i].on_vcpu) {
-				if (cpu_count() <= svm_tests[i].on_vcpu)
-					continue;
-				on_cpu_async(svm_tests[i].on_vcpu, (void *)test_run, &svm_tests[i]);
-				while (!svm_tests[i].on_vcpu_done)
-					cpu_relax();
-			}
-			else
-				test_run(&svm_tests[i]);
-		} else {
-			vmcb_ident(vmcb);
-			v2_test = &(svm_tests[i]);
-			svm_tests[i].v2();
+
+		if (!svm_tests[i].on_vcpu) {
+			test_run(&svm_tests[i]);
+			continue;
 		}
+
+		if (cpu_count() <= svm_tests[i].on_vcpu)
+			continue;
+
+		on_cpu_async(svm_tests[i].on_vcpu, (void *)test_run, &svm_tests[i]);
+
+		while (!svm_tests[i].on_vcpu_done)
+			cpu_relax();
 	}
 
 	if (!matched)
-- 
2.34.3

