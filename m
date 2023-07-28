Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9AE766521
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 09:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbjG1HT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 03:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbjG1HTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 03:19:17 -0400
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ADD3C26
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 00:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1690528749; x=1722064749;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MXR6P+beYHZGM0ya0cd8W4+wE6OLY1Busb8UzFqnnyU=;
  b=u1MOtJUCfRF76+Q78k9Lnh0Xu77w2pcTNzMe8Vpt3jSI00gCmpbWIQ19
   vlEAAfeyR7PtVSp0VCBWPYgMUfYFIEY0wHpVUEhPGb55jr6tT4lA3Kx+X
   rNyHovSFfqtrOHjbA97JrpQIJu7TrAMo0DuTBH6fK8MWKmPosAxKCAZF2
   Q=;
X-IronPort-AV: E=Sophos;i="6.01,236,1684800000"; 
   d="scan'208";a="19133024"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2023 07:19:05 +0000
Received: from EX19MTAUEC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id 65BAAAA968;
        Fri, 28 Jul 2023 07:19:04 +0000 (UTC)
Received: from EX19D008UEC001.ant.amazon.com (10.252.135.232) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 28 Jul 2023 07:19:02 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D008UEC001.ant.amazon.com (10.252.135.232) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 28 Jul 2023 07:19:02 +0000
Received: from dev-dsk-metikaya-1c-d447d167.eu-west-1.amazon.com
 (10.13.250.103) by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30 via Frontend Transport; Fri, 28 Jul 2023 07:19:01 +0000
From:   Metin Kaya <metikaya@amazon.co.uk>
To:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC:     <metikaya@amazon.co.uk>, <dwmw@amazon.co.uk>
Subject: [kvm-unit-tests PATCH] x86/access: Use HVMOP_flush_tlbs hypercall instead of invlpg() for Xen
Date:   Fri, 28 Jul 2023 07:18:57 +0000
Message-ID: <20230728071857.29991-1-metikaya@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU has ability of running guests under Xen starting from v8.0 [1].

And a patch is submitted to Linux/KVM to add hvm_op/HVMOP_flush_tlbs
hypercall support to KVM [2].

Hence, prefer HVMOP_flush_tlbs hypercall over invlpg instruction in Xen
environment *if* KVM has hvm_op/HVMOP_flush_tlbs hypercall implemented.

Also fix trivial formatting warnings for casting in invlpg() calls.

[1] https://qemu-project.gitlab.io/qemu/system/i386/xen.html
[2] https://lore.kernel.org/all/20230418101306.98263-1-metikaya@amazon.co.uk

Signed-off-by: Metin Kaya <metikaya@amazon.co.uk>
---
 x86/access.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 89 insertions(+), 3 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 70d81bf02d9d..0a858f807dde 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -4,6 +4,7 @@
 #include "asm/page.h"
 #include "x86/vm.h"
 #include "access.h"
+#include "alloc_page.h"
 
 #define true 1
 #define false 0
@@ -250,12 +251,90 @@ static void set_cr0_wp(int wp)
 	}
 }
 
+uint8_t *hypercall_page;
+
+#define __HYPERVISOR_hvm_op	34
+#define HVMOP_flush_tlbs	5
+
+static inline int do_hvm_op_flush_tlbs(void)
+{
+	long res = 0, _a1 = (long)(HVMOP_flush_tlbs), _a2 = (long)(NULL);
+
+	asm volatile ("call *%[offset]"
+#if defined(__x86_64__)
+		      : "=a" (res), "+D" (_a1), "+S" (_a2)
+#else
+		      : "=a" (res), "+b" (_a1), "+c" (_a2)
+#endif
+		      : [offset] "r" (hypercall_page + (__HYPERVISOR_hvm_op * 32))
+		      : "memory");
+
+	if (res)
+		printf("hvm_op/HVMOP_flush_tlbs failed: %ld.", res);
+
+	return (int)res;
+}
+
+#define XEN_CPUID_FIRST_LEAF    0x40000000
+#define XEN_CPUID_SIGNATURE_EBX 0x566e6558 /* "XenV" */
+#define XEN_CPUID_SIGNATURE_ECX 0x65584d4d /* "MMXe" */
+#define XEN_CPUID_SIGNATURE_EDX 0x4d4d566e /* "nVMM" */
+
+static void init_hypercalls(void)
+{
+	struct cpuid c;
+	u32 base;
+	bool found = false;
+
+	for (base = XEN_CPUID_FIRST_LEAF; base < XEN_CPUID_FIRST_LEAF + 0x10000;
+			base += 0x100) {
+		c = cpuid(base);
+		if ((c.b == XEN_CPUID_SIGNATURE_EBX) &&
+		    (c.c == XEN_CPUID_SIGNATURE_ECX) &&
+		    (c.d == XEN_CPUID_SIGNATURE_EDX) &&
+		    ((c.a - base) >= 2)) {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		printf("Using native invlpg instruction\n");
+		return;
+	}
+
+	hypercall_page = alloc_pages_flags(0, AREA_ANY | FLAG_DONTZERO);
+	if (!hypercall_page)
+		report_abort("failed to allocate hypercall page");
+
+	memset(hypercall_page, 0xc3, PAGE_SIZE);
+
+	c = cpuid(base + 2);
+	wrmsr(c.b, (u64)hypercall_page);
+	barrier();
+
+	if (hypercall_page[0] == 0xc3)
+		report_abort("Hypercall page not initialised correctly\n");
+
+	/*
+	 * Fall back to invlpg instruction if HVMOP_flush_tlbs hypercall is
+	 * unsupported.
+	 */
+	if (do_hvm_op_flush_tlbs()) {
+		printf("Using native invlpg instruction\n");
+		free_page(hypercall_page);
+		hypercall_page = NULL;
+		return;
+	}
+
+	printf("Using Xen HVMOP_flush_tlbs hypercall\n");
+}
+
 static void clear_user_mask(pt_element_t *ptep, int level, unsigned long virt)
 {
 	*ptep &= ~PT_USER_MASK;
 
 	/* Flush to avoid spurious #PF */
-	invlpg((void*)virt);
+	hypercall_page ? do_hvm_op_flush_tlbs() : invlpg((void *)virt);
 }
 
 static void set_user_mask(pt_element_t *ptep, int level, unsigned long virt)
@@ -263,7 +342,7 @@ static void set_user_mask(pt_element_t *ptep, int level, unsigned long virt)
 	*ptep |= PT_USER_MASK;
 
 	/* Flush to avoid spurious #PF */
-	invlpg((void*)virt);
+	hypercall_page ? do_hvm_op_flush_tlbs() : invlpg((void *)virt);
 }
 
 static unsigned set_cr4_smep(ac_test_t *at, int smep)
@@ -583,7 +662,7 @@ fault:
 static void __ac_set_expected_status(ac_test_t *at, bool flush)
 {
 	if (flush)
-		invlpg(at->virt);
+		hypercall_page ? do_hvm_op_flush_tlbs() : invlpg((void *)at->virt);
 
 	if (at->ptep)
 		at->expected_pte = *at->ptep;
@@ -1243,6 +1322,10 @@ void ac_test_run(int pt_levels, bool force_emulation)
 	printf("run\n");
 	tests = successes = 0;
 
+	setup_vm();
+
+	init_hypercalls();
+
 	shadow_cr0 = read_cr0();
 	shadow_cr4 = read_cr4();
 	shadow_cr3 = read_cr3();
@@ -1318,6 +1401,9 @@ void ac_test_run(int pt_levels, bool force_emulation)
 		successes += ac_test_cases[i](&pt_env);
 	}
 
+	if (hypercall_page)
+		free_page(hypercall_page);
+
 	printf("\n%d tests, %d failures\n", tests, tests - successes);
 
 	report(successes == tests, "%d-level paging tests%s", pt_levels,
-- 
2.40.1

