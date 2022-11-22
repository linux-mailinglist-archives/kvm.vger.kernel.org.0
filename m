Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38A0634137
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbiKVQPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiKVQPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:15:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7DD554FF
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R2CqqYJEyvfVoSFJGP+0inWQYMF/q6Cnr9ycO67ooaw=;
        b=P+k1ulTzj+s4sLmeug3VZ5pqDvWa5tGQJRkEOvOIQ5wBfvhOXFW1Fd10hihpouTW/QoHy9
        uvpvj0wmd6qsQCZ57RnlaM/1/haUFO4hDKMA5/QNht7D3OBGJptn3LcqkBQuuLZ3fDaxHg
        U3+p1QScM5OaheBsYdph2tMS3qXue4M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-sVJYt0vaN_enPYtLxSIeew-1; Tue, 22 Nov 2022 11:12:35 -0500
X-MC-Unique: sVJYt0vaN_enPYtLxSIeew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D725F811E7A;
        Tue, 22 Nov 2022 16:12:34 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB8F91121314;
        Tue, 22 Nov 2022 16:12:32 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v3 17/27] svm: correctly skip if NPT not supported
Date:   Tue, 22 Nov 2022 18:11:42 +0200
Message-Id: <20221122161152.293072-18-mlevitsk@redhat.com>
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

Fail SVM setup when NPT is not supported

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/svm_lib.c | 16 ++++++++++------
 lib/x86/svm_lib.h |  2 +-
 x86/svm.c         |  3 ++-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/lib/x86/svm_lib.c b/lib/x86/svm_lib.c
index cb80f08f..c7194909 100644
--- a/lib/x86/svm_lib.c
+++ b/lib/x86/svm_lib.c
@@ -77,11 +77,18 @@ static void setup_npt(void)
 	__setup_mmu_range(pml4e, 0, size, X86_MMU_MAP_USER);
 }
 
-void setup_svm(void)
+bool setup_svm(void)
 {
-	void *hsave = alloc_page();
+	void *hsave;
 	int i;
 
+	if (!npt_supported()) {
+		printf("NPT not detected - skipping SVM initialization\n");
+		return false;
+	}
+
+	hsave = alloc_page();
+
 	wrmsr(MSR_VM_HSAVE_PA, virt_to_phys(hsave));
 	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
 
@@ -89,14 +96,10 @@ void setup_svm(void)
 
 	msr_bitmap = (void *) ALIGN((ulong)msr_bitmap_area, PAGE_SIZE);
 
-	if (!npt_supported())
-		return;
 
 	for (i = 1; i < cpu_count(); i++)
 		on_cpu(i, (void *)set_additional_vcpu_msr, (void *)rdmsr(MSR_EFER));
 
-	printf("NPT detected - running all tests with NPT enabled\n");
-
 	/*
 	 * Nested paging supported - Build a nested page table
 	 * Build the page-table bottom-up and map everything with 4k
@@ -104,4 +107,5 @@ void setup_svm(void)
 	 */
 
 	setup_npt();
+	return true;
 }
diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
index b491eee6..f603ff93 100644
--- a/lib/x86/svm_lib.h
+++ b/lib/x86/svm_lib.h
@@ -49,7 +49,7 @@ static inline void clgi(void)
 	asm volatile ("clgi");
 }
 
-void setup_svm(void);
+bool setup_svm(void);
 
 u64 *npt_get_pte(u64 address);
 u64 *npt_get_pde(u64 address);
diff --git a/x86/svm.c b/x86/svm.c
index 9edf5500..cf246c37 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -264,7 +264,8 @@ int run_svm_tests(int ac, char **av, struct svm_test *svm_tests)
 		return report_summary();
 	}
 
-	setup_svm();
+	if (!setup_svm())
+		return 0;
 
 	vmcb = alloc_page();
 
-- 
2.34.3

