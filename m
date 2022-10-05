Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7295F5D57
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 01:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiJEXwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 19:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJEXwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 19:52:24 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413528321B
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 16:52:23 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n9-20020a170902d2c900b001782ad97c7aso98786plc.8
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nua6Smb9f8kb2ftFr3Tl2uWpmC7MCH0h4nK29g3+pCk=;
        b=DPBdmKfPn9UPcqLZZ4gBqnHwKx3td5VfO/Gn0cdxo2DNwuox4ZS32YBalvDTEeQrFo
         CsXIyviSOUX1USpxVIDur/vdqjmD1OUsprRkG8FGyfv5+ExnvxegEtNYCrmFCcOKSWTQ
         jJlegt1C9FKric4DHHsfc3gij5kfU9+L57z0An/lJm7OpyeYf2mDuHTwb+XJndKktr2U
         2nHY6E1Wcl0fhhlPwRHpsI5hOTd9vi2o2aatoHPCL+jvbVJumDu4A9jceU4bTPaLvM+9
         C6ou5moVdVV8nDH5fiPG/FmDT2RxQW5mh4M7T5e9QCWAbl2RSsic77MzQYTRiDGgPDjP
         YYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nua6Smb9f8kb2ftFr3Tl2uWpmC7MCH0h4nK29g3+pCk=;
        b=P9Xw0hLmcE8Q9WiX848hSv3/EfvUUQArScKAAwjRybj6LwMdSSmLcTjySTi0vz72NX
         RaPVOOywTJYxrOaP0cJc2w5fZtdH3p4fHNDhbuH1led6jSb52Nnf3rInnfBR9xXJvRYN
         uMgGY/EFSRpWAmIeH/tPRGQrfossibAkSBplW3glcvYhgkuIiCX79ZHCS7kCfXh7zfu/
         NDfhp9zFMRXnBIAbCEabnvoZ1RdmiM34/6KDeiaGfIRyZwlfHgl9K0lH1OwdD0GvWtsH
         xLVS7xFH0ZjsBiir20zRS45iXWXCGOhUm3CtXAqKM5lzz8P7AjHwK6wGsLDI1GbxIO/F
         p6aA==
X-Gm-Message-State: ACrzQf2midck5n+aGp/feegtrcGrR5eX6XxCLRLT8bdrGLK44T4AQ9BI
        oKVaey+35bDLITQnzXDNAafQav83spM=
X-Google-Smtp-Source: AMsMyM4iVEhSB6zYpEEIgerahV8tKvQGQHiBFzl4qEjSdKFdhZXm3Z/fw/zQPKKoJ6HJ4nBXLdBiIbyGTmc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c944:b0:178:4568:9f99 with SMTP id
 i4-20020a170902c94400b0017845689f99mr1892656pla.98.1665013942850; Wed, 05 Oct
 2022 16:52:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Oct 2022 23:52:08 +0000
In-Reply-To: <20221005235212.57836-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221005235212.57836-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221005235212.57836-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 5/9] x86: nSVM: Add an exception test
 framework and tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Manali Shukla <manali.shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Manali Shukla <manali.shukla@amd.com>

Copy nVMX's test that verifies an exception occurring in L2 is
forwarded to the right place (L1 or L2).

The test verifies two conditions for each exception.
1) Exception generated in L2, is handled by L2 when L2 exception handler
   is registered.
2) Exception generated in L2, is handled by L1 when intercept exception
   bit map is set in L1.

Note, v2 SVM tests have no parameters, but the SVM framework doesn't
differentiate between v1 and v2 when setting the guest code.  Fudge
around this shortcoming by casting to test_guest_func when invoking
test_set_guest().

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
[sean: use common helpers to generate exception, call out this copies nVMX]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index e2ec954..805b2e0 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -10,6 +10,7 @@
 #include "isr.h"
 #include "apic.h"
 #include "delay.h"
+#include "x86/usermode.h"
 
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
 
@@ -3289,6 +3290,81 @@ static void svm_intr_intercept_mix_smi(void)
 	svm_intr_intercept_mix_run_guest(NULL, SVM_EXIT_SMI);
 }
 
+static void svm_l2_ac_test(void)
+{
+	bool hit_ac = false;
+
+	write_cr0(read_cr0() | X86_CR0_AM);
+	write_rflags(read_rflags() | X86_EFLAGS_AC);
+
+	run_in_user(generate_usermode_ac, AC_VECTOR, 0, 0, 0, 0, &hit_ac);
+	report(hit_ac, "Usermode #AC handled in L2");
+	vmmcall();
+}
+
+struct svm_exception_test {
+	u8 vector;
+	void (*guest_code)(void);
+};
+
+struct svm_exception_test svm_exception_tests[] = {
+	{ GP_VECTOR, generate_non_canonical_gp },
+	{ UD_VECTOR, generate_ud },
+	{ DE_VECTOR, generate_de },
+	{ DB_VECTOR, generate_single_step_db },
+	{ AC_VECTOR, svm_l2_ac_test },
+};
+
+static u8 svm_exception_test_vector;
+
+static void svm_exception_handler(struct ex_regs *regs)
+{
+	report(regs->vector == svm_exception_test_vector,
+		"Handling %s in L2's exception handler",
+		exception_mnemonic(svm_exception_test_vector));
+	vmmcall();
+}
+
+static void handle_exception_in_l2(u8 vector)
+{
+	handler old_handler = handle_exception(vector, svm_exception_handler);
+	svm_exception_test_vector = vector;
+
+	report(svm_vmrun() == SVM_EXIT_VMMCALL,
+		"%s handled by L2", exception_mnemonic(vector));
+
+	handle_exception(vector, old_handler);
+}
+
+static void handle_exception_in_l1(u32 vector)
+{
+	u32 old_ie = vmcb->control.intercept_exceptions;
+
+	vmcb->control.intercept_exceptions |= (1ULL << vector);
+
+	report(svm_vmrun() == (SVM_EXIT_EXCP_BASE + vector),
+		"%s handled by L1",  exception_mnemonic(vector));
+
+	vmcb->control.intercept_exceptions = old_ie;
+}
+
+static void svm_exception_test(void)
+{
+	struct svm_exception_test *t;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(svm_exception_tests); i++) {
+		t = &svm_exception_tests[i];
+		test_set_guest((test_guest_func)t->guest_code);
+
+		handle_exception_in_l2(t->vector);
+		vmcb_ident(vmcb);
+
+		handle_exception_in_l1(t->vector);
+		vmcb_ident(vmcb);
+	}
+}
+
 struct svm_test svm_tests[] = {
 	{ "null", default_supported, default_prepare,
 	  default_prepare_gif_clear, null_test,
@@ -3389,6 +3465,7 @@ struct svm_test svm_tests[] = {
 	TEST(svm_nm_test),
 	TEST(svm_int3_test),
 	TEST(svm_into_test),
+	TEST(svm_exception_test),
 	TEST(svm_lbrv_test0),
 	TEST(svm_lbrv_test1),
 	TEST(svm_lbrv_test2),
-- 
2.38.0.rc1.362.ged0d419d3c-goog

