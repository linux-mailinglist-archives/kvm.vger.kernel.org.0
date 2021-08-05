Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BADA3E10AB
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 10:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhHEI6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 04:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234449AbhHEI6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 04:58:23 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EE9C061765
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 01:58:08 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h13so5516369wrp.1
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 01:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WZJ8sApnM5wYW8QOW5ulsd7QikaFSQCDvJUPnNEkOo0=;
        b=IScr4heJatmtd7c0ux7+8fqRTCy0QLEnxyMUK3E8v3WOraAyiH85TYPywPRxhyadn3
         CCof3GkHeRiSmiDikLt2wWElthlFtUXVUsMUjPvTGbaPfGSOqjrS23KQ8EQxHhsjSn2a
         9n9gC0n9yYPEgvTiweqbkRarXGEfKIL1TSmHiX68ukPPkMbXDmpQSQkFek66Qs82P+K0
         beul0jB2WChU8B97v77teeeVZslGGcCQGO0g+Bc1bEFkvQRujH5fKirxoO69SA2XnCXM
         4KdhOHn54Dg/HedUJXCjKbef5hEqE0kybUk/5LT1K6qK7XDKvStOJCmzxP5EQ8l5Z4+W
         35vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WZJ8sApnM5wYW8QOW5ulsd7QikaFSQCDvJUPnNEkOo0=;
        b=MOpeQJGkF3y1OPWV5Aw4vuCI0sP1vIOlG7zMEmaGJEK3SXuI7jBydcWM8oXyUHUHrP
         o9bgu6d6zhp8vh1I+XJCfsVvoc5iPeMx2VNXd5JH+rwqq/qdMuqx5Ql0sL4++r78WxPz
         yAYOJX8DiYBu1t7qcOIRjPdKefNk2+WqFHtNqjfkw5vrl0zBFvKMAhXq0zdELOXw5jwG
         dblc0dd9lles3HyVNgEk21Nx86ZJGZ1dn/m5t241QkneqBFZaUU+D5cWdZMLEyDj6+WH
         Q94AFeDqh98TeHwwCeITTPhsOmCtTsDWJdQPaqdR5x6wgEfdXu33+4L64JoIM6hqw76v
         N1Ew==
X-Gm-Message-State: AOAM531t1vunYEiUgY8qe6skAQu+vbWwdLeyaOEiwngnoQMCfYxMI+tg
        703rOJp/WRmmsBnTTD7VnFLerHa1wnrNoA==
X-Google-Smtp-Source: ABdhPJzGdiWYrRF+VOtm90o3lq5LJvyHIsoxFmzIapUualQ8+U6yByDAfeRNGjbFzxNgrGrx2/N5lg==
X-Received: by 2002:a5d:6b8f:: with SMTP id n15mr3838814wrx.103.1628153887167;
        Thu, 05 Aug 2021 01:58:07 -0700 (PDT)
Received: from laral.fritz.box (200116b82b640800b3a4b41f77fc5e0e.dip.versatel-1u1.de. [2001:16b8:2b64:800:b3a4:b41f:77fc:5e0e])
        by smtp.gmail.com with ESMTPSA id l9sm5341322wro.92.2021.08.05.01.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 01:58:06 -0700 (PDT)
From:   Lara Lazier <laramglazier@gmail.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Lara Lazier <laramglazier@gmail.com>
Subject: [PATCH kvm-unit-tests] nSVM: test canonicalization of segment bases in VMLOAD
Date:   Thu,  5 Aug 2021 10:57:46 +0200
Message-Id: <20210805085746.95096-1-laramglazier@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

APM2 states that VMRUN and VMLOAD should canonicalize all base
addresses in the segment registers that have been loaded respectively.

Split up in test_canonicalization the TEST_CANONICAL for VMLOAD and
VMRUN. Added the respective test for KERNEL_GS.

Signed-off-by: Lara Lazier <laramglazier@gmail.com>
---
 x86/svm_tests.c | 51 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 7c7b19d..f6bccb7 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2460,32 +2460,51 @@ static void test_msrpm_iopm_bitmap_addrs(void)
 	vmcb->control.intercept = saved_intercept;
 }
 
-#define TEST_CANONICAL(seg_base, msg)					\
-	saved_addr = seg_base;						\
+#define TEST_CANONICAL_VMRUN(seg_base, msg)					\
+	saved_addr = seg_base;					\
 	seg_base = (seg_base & ((1ul << addr_limit) - 1)) | noncanonical_mask; \
-	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test %s.base for canonical form: %lx", msg, seg_base);							\
+	return_value = svm_vmrun(); \
+	report(return_value == SVM_EXIT_VMMCALL, \
+			"Successful VMRUN with noncanonical %s.base", msg); \
+	report(is_canonical(seg_base), \
+			"Test %s.base for canonical form: %lx", msg, seg_base); \
+	seg_base = saved_addr;
+
+
+#define TEST_CANONICAL_VMLOAD(seg_base, msg)					\
+	saved_addr = seg_base;					\
+	seg_base = (seg_base & ((1ul << addr_limit) - 1)) | noncanonical_mask; \
+	asm volatile ("vmload %0" : : "a"(vmcb_phys) : "memory"); \
+	asm volatile ("vmsave %0" : : "a"(vmcb_phys) : "memory"); \
+	report(is_canonical(seg_base), \
+			"Test %s.base for canonical form: %lx", msg, seg_base); \
 	seg_base = saved_addr;
 
 /*
  * VMRUN canonicalizes (i.e., sign-extend to bit 63) all base addresses
  • in the segment registers that have been loaded.
  */
-static void test_vmrun_canonicalization(void)
+static void test_canonicalization(void)
 {
 	u64 saved_addr;
-	u8 addr_limit = cpuid_maxphyaddr();
+	u64 return_value;
+	u64 addr_limit;
+	u64 vmcb_phys = virt_to_phys(vmcb);
+
+	addr_limit = (this_cpu_has(X86_FEATURE_LA57)) ? 57 : 48;
 	u64 noncanonical_mask = NONCANONICAL & ~((1ul << addr_limit) - 1);
 
-	TEST_CANONICAL(vmcb->save.es.base, "ES");
-	TEST_CANONICAL(vmcb->save.cs.base, "CS");
-	TEST_CANONICAL(vmcb->save.ss.base, "SS");
-	TEST_CANONICAL(vmcb->save.ds.base, "DS");
-	TEST_CANONICAL(vmcb->save.fs.base, "FS");
-	TEST_CANONICAL(vmcb->save.gs.base, "GS");
-	TEST_CANONICAL(vmcb->save.gdtr.base, "GDTR");
-	TEST_CANONICAL(vmcb->save.ldtr.base, "LDTR");
-	TEST_CANONICAL(vmcb->save.idtr.base, "IDTR");
-	TEST_CANONICAL(vmcb->save.tr.base, "TR");
+	TEST_CANONICAL_VMLOAD(vmcb->save.fs.base, "FS");
+	TEST_CANONICAL_VMLOAD(vmcb->save.gs.base, "GS");
+	TEST_CANONICAL_VMLOAD(vmcb->save.ldtr.base, "LDTR");
+	TEST_CANONICAL_VMLOAD(vmcb->save.tr.base, "TR");
+	TEST_CANONICAL_VMLOAD(vmcb->save.kernel_gs_base, "KERNEL GS");
+	TEST_CANONICAL_VMRUN(vmcb->save.es.base, "ES");
+	TEST_CANONICAL_VMRUN(vmcb->save.cs.base, "CS");
+	TEST_CANONICAL_VMRUN(vmcb->save.ss.base, "SS");
+	TEST_CANONICAL_VMRUN(vmcb->save.ds.base, "DS");
+	TEST_CANONICAL_VMRUN(vmcb->save.gdtr.base, "GDTR");
+	TEST_CANONICAL_VMRUN(vmcb->save.idtr.base, "IDTR");
 }
 
 static void svm_guest_state_test(void)
@@ -2497,7 +2516,7 @@ static void svm_guest_state_test(void)
 	test_cr4();
 	test_dr();
 	test_msrpm_iopm_bitmap_addrs();
-	test_vmrun_canonicalization();
+	test_canonicalization();
 }
 
 static void __svm_npt_rsvd_bits_test(u64 *pxe, u64 rsvd_bits, u64 efer,
-- 
2.25.1

