Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0BD4E47E0
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 21:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiCVU6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 16:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbiCVU5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 16:57:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06D277643
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647982586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lva3jA1UIOJNHB5sO36A9Osjhwc6+VS5t3GMWJqc9AE=;
        b=IXLo3dOPdvw9FGBUQizsauLc5Op7/31TTltEKWZO3tY0VqJDeMkv3SDnIvBTplPtJM0bGf
        CtkTy0o6ExikX6awqKiYbYL2rtnP7skyFA4nIrfaYlHN7tin8VU6N3QUggOjjzaNP1IPf1
        6dHAnRFXOAwixyVret7qjjn0Lsl9ARo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-OV2mBMpxOvu_dFN-kb8agw-1; Tue, 22 Mar 2022 16:56:24 -0400
X-MC-Unique: OV2mBMpxOvu_dFN-kb8agw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83E3580231F
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 20:56:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62D19C26E9A;
        Tue, 22 Mar 2022 20:56:23 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 6/9] svm: add tests for LBR virtualization
Date:   Tue, 22 Mar 2022 22:56:10 +0200
Message-Id: <20220322205613.250925-7-mlevitsk@redhat.com>
In-Reply-To: <20220322205613.250925-1-mlevitsk@redhat.com>
References: <20220322205613.250925-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/processor.h |   1 +
 x86/svm.c           |   5 +
 x86/svm.h           |   5 +-
 x86/svm_tests.c     | 239 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 249 insertions(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 117032a..b01c3d0 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -187,6 +187,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_RDPRU		(CPUID(0x80000008, 0, EBX, 4))
 #define	X86_FEATURE_AMD_IBPB		(CPUID(0x80000008, 0, EBX, 12))
 #define	X86_FEATURE_NPT			(CPUID(0x8000000A, 0, EDX, 0))
+#define	X86_FEATURE_LBRV		(CPUID(0x8000000A, 0, EDX, 1))
 #define	X86_FEATURE_NRIPS		(CPUID(0x8000000A, 0, EDX, 3))
 #define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
 
diff --git a/x86/svm.c b/x86/svm.c
index 6f4e023..bb58d7c 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -70,6 +70,11 @@ bool vgif_supported(void)
 	return this_cpu_has(X86_FEATURE_VGIF);
 }
 
+bool lbrv_supported(void)
+{
+    return this_cpu_has(X86_FEATURE_LBRV);
+}
+
 void default_prepare(struct svm_test *test)
 {
 	vmcb_ident(vmcb);
diff --git a/x86/svm.h b/x86/svm.h
index 6d072f4..58b9410 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -98,7 +98,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 event_inj;
 	u32 event_inj_err;
 	u64 nested_cr3;
-	u64 lbr_ctl;
+	u64 virt_ext;
 	u32 clean;
 	u32 reserved_5;
 	u64 next_rip;
@@ -360,6 +360,8 @@ struct __attribute__ ((__packed__)) vmcb {
 
 #define MSR_BITMAP_SIZE 8192
 
+#define LBR_CTL_ENABLE_MASK BIT_ULL(0)
+
 struct svm_test {
 	const char *name;
 	bool (*supported)(void);
@@ -405,6 +407,7 @@ u64 *npt_get_pml4e(void);
 bool smp_supported(void);
 bool default_supported(void);
 bool vgif_supported(void);
+bool lbrv_supported(void);
 void default_prepare(struct svm_test *test);
 void default_prepare_gif_clear(struct svm_test *test);
 bool default_finished(struct svm_test *test);
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 7586ef7..b2ba283 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3078,6 +3078,240 @@ static void svm_nm_test(void)
         "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
 }
 
+
+static bool check_lbr(u64 *from_excepted, u64 *to_expected)
+{
+	u64 from = rdmsr(MSR_IA32_LASTBRANCHFROMIP);
+	u64 to = rdmsr(MSR_IA32_LASTBRANCHTOIP);
+
+	if ((u64)from_excepted != from) {
+		report(false, "MSR_IA32_LASTBRANCHFROMIP, expected=0x%lx, actual=0x%lx",
+			(u64)from_excepted, from);
+		return false;
+	}
+
+	if ((u64)to_expected != to) {
+		report(false, "MSR_IA32_LASTBRANCHFROMIP, expected=0x%lx, actual=0x%lx",
+			(u64)from_excepted, from);
+		return false;
+	}
+
+	return true;
+}
+
+static bool check_dbgctl(u64 dbgctl, u64 dbgctl_expected)
+{
+	if (dbgctl != dbgctl_expected) {
+		report(false, "Unexpected MSR_IA32_DEBUGCTLMSR value 0x%lx", dbgctl);
+		return false;
+	}
+	return true;
+}
+
+
+#define DO_BRANCH(branch_name) \
+	asm volatile ( \
+		# branch_name "_from:" \
+		"jmp " # branch_name  "_to\n" \
+		"nop\n" \
+		"nop\n" \
+		# branch_name  "_to:" \
+		"nop\n" \
+	)
+
+
+extern u64 guest_branch0_from, guest_branch0_to;
+extern u64 guest_branch2_from, guest_branch2_to;
+
+extern u64 host_branch0_from, host_branch0_to;
+extern u64 host_branch2_from, host_branch2_to;
+extern u64 host_branch3_from, host_branch3_to;
+extern u64 host_branch4_from, host_branch4_to;
+
+u64 dbgctl;
+
+static void svm_lbrv_test_guest1(void)
+{
+	/*
+	 * This guest expects the LBR to be already enabled when it starts,
+	 * it does a branch, and then disables the LBR and then checks.
+	 */
+
+	DO_BRANCH(guest_branch0);
+
+	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+
+	if (dbgctl != DEBUGCTLMSR_LBR)
+		asm volatile("ud2\n");
+	if (rdmsr(MSR_IA32_DEBUGCTLMSR) != 0)
+		asm volatile("ud2\n");
+	if (rdmsr(MSR_IA32_LASTBRANCHFROMIP) != (u64)&guest_branch0_from)
+		asm volatile("ud2\n");
+	if (rdmsr(MSR_IA32_LASTBRANCHTOIP) != (u64)&guest_branch0_to)
+		asm volatile("ud2\n");
+
+	asm volatile ("vmmcall\n");
+}
+
+static void svm_lbrv_test_guest2(void)
+{
+	/*
+	 * This guest expects the LBR to be disabled when it starts,
+	 * enables it, does a branch, disables it and then checks.
+	 */
+
+	DO_BRANCH(guest_branch1);
+	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+
+	if (dbgctl != 0)
+		asm volatile("ud2\n");
+
+	if (rdmsr(MSR_IA32_LASTBRANCHFROMIP) != (u64)&host_branch2_from)
+		asm volatile("ud2\n");
+	if (rdmsr(MSR_IA32_LASTBRANCHTOIP) != (u64)&host_branch2_to)
+		asm volatile("ud2\n");
+
+
+	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
+	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	DO_BRANCH(guest_branch2);
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+
+	if (dbgctl != DEBUGCTLMSR_LBR)
+		asm volatile("ud2\n");
+	if (rdmsr(MSR_IA32_LASTBRANCHFROMIP) != (u64)&guest_branch2_from)
+		asm volatile("ud2\n");
+	if (rdmsr(MSR_IA32_LASTBRANCHTOIP) != (u64)&guest_branch2_to)
+		asm volatile("ud2\n");
+
+	asm volatile ("vmmcall\n");
+}
+
+static void svm_lbrv_test0(void)
+{
+	report(true, "Basic LBR test");
+	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
+	DO_BRANCH(host_branch0);
+	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+
+	check_dbgctl(dbgctl, DEBUGCTLMSR_LBR);
+	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	check_dbgctl(dbgctl, 0);
+
+	check_lbr(&host_branch0_from, &host_branch0_to);
+}
+
+static void svm_lbrv_test1(void)
+{
+	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(1)");
+
+	vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
+	vmcb->control.virt_ext = 0;
+
+	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
+	DO_BRANCH(host_branch1);
+	SVM_BARE_VMRUN;
+	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+
+	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
+		vmcb->control.exit_code);
+		return;
+	}
+
+	check_dbgctl(dbgctl, 0);
+	check_lbr(&guest_branch0_from, &guest_branch0_to);
+}
+
+static void svm_lbrv_test2(void)
+{
+	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(2)");
+
+	vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
+	vmcb->control.virt_ext = 0;
+
+	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
+	DO_BRANCH(host_branch2);
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+	SVM_BARE_VMRUN;
+	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+
+	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
+		vmcb->control.exit_code);
+		return;
+	}
+
+	check_dbgctl(dbgctl, 0);
+	check_lbr(&guest_branch2_from, &guest_branch2_to);
+}
+
+static void svm_lbrv_nested_test1(void)
+{
+	if (!lbrv_supported()) {
+		report_skip("LBRV not supported in the guest");
+		return;
+	}
+
+	report(true, "Test that with LBRV enabled, guest LBR state doesn't leak (1)");
+	vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
+	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
+	vmcb->save.dbgctl = DEBUGCTLMSR_LBR;
+
+	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
+	DO_BRANCH(host_branch3);
+	SVM_BARE_VMRUN;
+	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+
+	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
+		vmcb->control.exit_code);
+		return;
+	}
+
+	if (vmcb->save.dbgctl != 0) {
+		report(false, "unexpected virtual guest MSR_IA32_DEBUGCTLMSR value 0x%lx", vmcb->save.dbgctl);
+		return;
+	}
+
+	check_dbgctl(dbgctl, DEBUGCTLMSR_LBR);
+	check_lbr(&host_branch3_from, &host_branch3_to);
+}
+static void svm_lbrv_nested_test2(void)
+{
+	if (!lbrv_supported()) {
+		report_skip("LBRV not supported in the guest");
+		return;
+	}
+
+	report(true, "Test that with LBRV enabled, guest LBR state doesn't leak (2)");
+	vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
+	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
+
+	vmcb->save.dbgctl = 0;
+	vmcb->save.br_from = (u64)&host_branch2_from;
+	vmcb->save.br_to = (u64)&host_branch2_to;
+
+	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
+	DO_BRANCH(host_branch4);
+	SVM_BARE_VMRUN;
+	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+
+	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
+		vmcb->control.exit_code);
+		return;
+	}
+
+	check_dbgctl(dbgctl, DEBUGCTLMSR_LBR);
+	check_lbr(&host_branch4_from, &host_branch4_to);
+}
+
 struct svm_test svm_tests[] = {
     { "null", default_supported, default_prepare,
       default_prepare_gif_clear, null_test,
@@ -3200,5 +3434,10 @@ struct svm_test svm_tests[] = {
     TEST(svm_nm_test),
     TEST(svm_int3_test),
     TEST(svm_into_test),
+    TEST(svm_lbrv_test0),
+    TEST(svm_lbrv_test1),
+    TEST(svm_lbrv_test2),
+    TEST(svm_lbrv_nested_test1),
+    TEST(svm_lbrv_nested_test2),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.26.3

