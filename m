Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C3A2B1D98
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 15:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgKMOjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 09:39:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726324AbgKMOjp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 09:39:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605278383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2hSIc4NCwTfXqPZCANFvroqBUVVU/829trViCkGb+q8=;
        b=MRkGO6+oPuzfqyTelONQmMPs8VLRcxOgxK8jIECifnWZ2r/PRWFYmj/GAqWgt7NLJ+iODd
        wxdZpiqH0F3/DTD5iBrmJu7pvZwHTFpYwnB3qmyIIQ/KnvtYycpXWuiObmMHaCks/UGg+z
        Q+JVxX5qIM3hr5GH9fda3WudZNCWG8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-5k4SgpMwM1mmUUke_j-e8w-1; Fri, 13 Nov 2020 09:39:41 -0500
X-MC-Unique: 5k4SgpMwM1mmUUke_j-e8w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 759FB1030988
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 14:39:39 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3643460C11
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 14:39:39 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86: svm: clean up CR3 tests
Date:   Fri, 13 Nov 2020 09:39:38 -0500
Message-Id: <20201113143938.1050040-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not execute the same test repeatedly, and run PCIDE=0 test
even if the PCID bit is set in CPUID.  Note which CR4 configuration
is in use for each test.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm_tests.c | 41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 2ad09b1..dc86efd 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2065,7 +2065,7 @@ static void basic_guest_main(struct svm_test *test)
 }
 
 #define SVM_TEST_CR_RESERVED_BITS(start, end, inc, cr, val, resv_mask,	\
-				  exit_code)				\
+				  exit_code, test_name)			\
 {									\
 	u64 tmp, mask;							\
 	int i;								\
@@ -2085,7 +2085,7 @@ static void basic_guest_main(struct svm_test *test)
 		case 4:							\
 			vmcb->save.cr4 = tmp;				\
 		}							\
-		report(svm_vmrun() == exit_code, "Test CR%d %d:%d: %lx",\
+		report(svm_vmrun() == exit_code, "Test CR%d " test_name "%d:%d: %lx",\
 		    cr, end, start, tmp);				\
 	}								\
 }
@@ -2208,7 +2208,7 @@ static void test_cr3(void)
 	u64 cr3_saved = vmcb->save.cr3;
 
 	SVM_TEST_CR_RESERVED_BITS(0, 63, 1, 3, cr3_saved,
-	    SVM_CR3_LONG_MBZ_MASK, SVM_EXIT_ERR);
+	    SVM_CR3_LONG_MBZ_MASK, SVM_EXIT_ERR, "");
 
 	vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_MBZ_MASK;
 	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
@@ -2216,7 +2216,7 @@ static void test_cr3(void)
 
 	/*
 	 * CR3 non-MBZ reserved bits based on different modes:
-	 *   [11:5] [2:0] - long mode
+	 *   [11:5] [2:0] - long mode (PCIDE=0)
 	 *          [2:0] - PAE legacy mode
 	 */
 	u64 cr4_saved = vmcb->save.cr4;
@@ -2228,26 +2228,23 @@ static void test_cr3(void)
 	if (this_cpu_has(X86_FEATURE_PCID)) {
 		vmcb->save.cr4 = cr4_saved | X86_CR4_PCIDE;
 		SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
-		    SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_VMMCALL);
+		    SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_VMMCALL, "(PCIDE=1) ");
 
 		vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_RESERVED_MASK;
 		report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
 		    vmcb->save.cr3);
-	} else {
+	}
 
-		vmcb->save.cr4 = cr4_saved & ~X86_CR4_PCIDE;
+	vmcb->save.cr4 = cr4_saved & ~X86_CR4_PCIDE;
 
-		/* Clear P (Present) bit in NPT in order to trigger #NPF */
-		pdpe[0] &= ~1ULL;
+	/* Clear P (Present) bit in NPT in order to trigger #NPF */
+	pdpe[0] &= ~1ULL;
 
-		SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
-		    SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_NPF);
+	SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
+	    SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_NPF, "(PCIDE=0) ");
 
-		pdpe[0] |= 1ULL;
-		vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_RESERVED_MASK;
-		report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
-		    vmcb->save.cr3);
-	}
+	pdpe[0] |= 1ULL;
+	vmcb->save.cr3 = cr3_saved;
 
 	/*
 	 * PAE legacy
@@ -2255,13 +2252,9 @@ static void test_cr3(void)
 	pdpe[0] &= ~1ULL;
 	vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;
 	SVM_TEST_CR_RESERVED_BITS(0, 2, 1, 3, cr3_saved,
-	    SVM_CR3_PAE_LEGACY_RESERVED_MASK, SVM_EXIT_NPF);
+	    SVM_CR3_PAE_LEGACY_RESERVED_MASK, SVM_EXIT_NPF, "(PAE) ");
 
 	pdpe[0] |= 1ULL;
-	vmcb->save.cr3 = cr3_saved & ~SVM_CR3_PAE_LEGACY_RESERVED_MASK;
-	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
-	    vmcb->save.cr3);
-
 	vmcb->save.cr3 = cr3_saved;
 	vmcb->save.cr4 = cr4_saved;
 }
@@ -2280,14 +2273,14 @@ static void test_cr4(void)
 	efer &= ~EFER_LME;
 	vmcb->save.efer = efer;
 	SVM_TEST_CR_RESERVED_BITS(12, 31, 1, 4, cr4_saved,
-	    SVM_CR4_LEGACY_RESERVED_MASK, SVM_EXIT_ERR);
+	    SVM_CR4_LEGACY_RESERVED_MASK, SVM_EXIT_ERR, "");
 
 	efer |= EFER_LME;
 	vmcb->save.efer = efer;
 	SVM_TEST_CR_RESERVED_BITS(12, 31, 1, 4, cr4_saved,
-	    SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR);
+	    SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR, "");
 	SVM_TEST_CR_RESERVED_BITS(32, 63, 4, 4, cr4_saved,
-	    SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR);
+	    SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR, "");
 
 	vmcb->save.cr4 = cr4_saved;
 	vmcb->save.efer = efer_saved;
-- 
2.26.2

