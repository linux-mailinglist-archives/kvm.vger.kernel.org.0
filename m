Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEBC60645A
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiJTPYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiJTPYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:24:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4DD9FD0
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666279474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pc0PJYM3lwC71vN3eKm2Ue3Fv40c/24qHs/LlTQN2gQ=;
        b=VSi0Q5shVFJd1LC6Nwyhuh3xEDhZq2vPoySzIANQjO1eyd54gSiV2GW15Oz2jyjWdO0L8B
        11J3B+gR0vvbaW0U86OSQk2m0gvVk98q/KHOBJ7CaFN5bx+aIR74WWTd+aasZCEHwJquxR
        8c5SIxXWLsJjLZ/wz8I4NlC+H92VsSE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-PLiajsdTPBO_uDgonH-R9g-1; Thu, 20 Oct 2022 11:24:29 -0400
X-MC-Unique: PLiajsdTPBO_uDgonH-R9g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C700185A7A8
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:24:29 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B1032027061;
        Thu, 20 Oct 2022 15:24:27 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 13/16] svm: move vmcb_ident to svm_lib.c
Date:   Thu, 20 Oct 2022 18:24:01 +0300
Message-Id: <20221020152404.283980-14-mlevitsk@redhat.com>
In-Reply-To: <20221020152404.283980-1-mlevitsk@redhat.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/svm_lib.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/svm_lib.h |  4 ++++
 x86/svm.c         | 54 -----------------------------------------------
 x86/svm.h         |  1 -
 4 files changed, 58 insertions(+), 55 deletions(-)

diff --git a/lib/x86/svm_lib.c b/lib/x86/svm_lib.c
index 9e82e363..2b067c65 100644
--- a/lib/x86/svm_lib.c
+++ b/lib/x86/svm_lib.c
@@ -103,3 +103,57 @@ void setup_svm(void)
 
 	setup_npt();
 }
+
+void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
+			 u64 base, u32 limit, u32 attr)
+{
+	seg->selector = selector;
+	seg->attrib = attr;
+	seg->limit = limit;
+	seg->base = base;
+}
+
+void vmcb_ident(struct vmcb *vmcb)
+{
+	u64 vmcb_phys = virt_to_phys(vmcb);
+	struct vmcb_save_area *save = &vmcb->save;
+	struct vmcb_control_area *ctrl = &vmcb->control;
+	u32 data_seg_attr = 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
+		| SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
+	u32 code_seg_attr = 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
+		| SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;
+	struct descriptor_table_ptr desc_table_ptr;
+
+	memset(vmcb, 0, sizeof(*vmcb));
+	asm volatile ("vmsave %0" : : "a"(vmcb_phys) : "memory");
+	vmcb_set_seg(&save->es, read_es(), 0, -1U, data_seg_attr);
+	vmcb_set_seg(&save->cs, read_cs(), 0, -1U, code_seg_attr);
+	vmcb_set_seg(&save->ss, read_ss(), 0, -1U, data_seg_attr);
+	vmcb_set_seg(&save->ds, read_ds(), 0, -1U, data_seg_attr);
+	sgdt(&desc_table_ptr);
+	vmcb_set_seg(&save->gdtr, 0, desc_table_ptr.base, desc_table_ptr.limit, 0);
+	sidt(&desc_table_ptr);
+	vmcb_set_seg(&save->idtr, 0, desc_table_ptr.base, desc_table_ptr.limit, 0);
+	ctrl->asid = 1;
+	save->cpl = 0;
+	save->efer = rdmsr(MSR_EFER);
+	save->cr4 = read_cr4();
+	save->cr3 = read_cr3();
+	save->cr0 = read_cr0();
+	save->dr7 = read_dr7();
+	save->dr6 = read_dr6();
+	save->cr2 = read_cr2();
+	save->g_pat = rdmsr(MSR_IA32_CR_PAT);
+	save->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
+		(1ULL << INTERCEPT_VMMCALL) |
+		(1ULL << INTERCEPT_SHUTDOWN);
+	ctrl->iopm_base_pa = virt_to_phys(io_bitmap);
+	ctrl->msrpm_base_pa = virt_to_phys(msr_bitmap);
+
+	if (npt_supported()) {
+		ctrl->nested_ctl = 1;
+		ctrl->nested_cr3 = (u64)pml4e;
+		ctrl->tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
+	}
+}
diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
index 50664b24..27c3b137 100644
--- a/lib/x86/svm_lib.h
+++ b/lib/x86/svm_lib.h
@@ -54,7 +54,11 @@ static inline void clgi(void)
 	asm volatile ("clgi");
 }
 
+void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
+				  u64 base, u32 limit, u32 attr);
+
 void setup_svm(void);
+void vmcb_ident(struct vmcb *vmcb);
 
 u64 *npt_get_pte(u64 address);
 u64 *npt_get_pde(u64 address);
diff --git a/x86/svm.c b/x86/svm.c
index bf8caf54..37b4cd38 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -63,15 +63,6 @@ void inc_test_stage(struct svm_test *test)
 	barrier();
 }
 
-static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
-			 u64 base, u32 limit, u32 attr)
-{
-	seg->selector = selector;
-	seg->attrib = attr;
-	seg->limit = limit;
-	seg->base = base;
-}
-
 static test_guest_func guest_main;
 
 void test_set_guest(test_guest_func func)
@@ -85,51 +76,6 @@ static void test_thunk(struct svm_test *test)
 	vmmcall();
 }
 
-void vmcb_ident(struct vmcb *vmcb)
-{
-	u64 vmcb_phys = virt_to_phys(vmcb);
-	struct vmcb_save_area *save = &vmcb->save;
-	struct vmcb_control_area *ctrl = &vmcb->control;
-	u32 data_seg_attr = 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
-		| SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
-	u32 code_seg_attr = 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
-		| SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;
-	struct descriptor_table_ptr desc_table_ptr;
-
-	memset(vmcb, 0, sizeof(*vmcb));
-	asm volatile ("vmsave %0" : : "a"(vmcb_phys) : "memory");
-	vmcb_set_seg(&save->es, read_es(), 0, -1U, data_seg_attr);
-	vmcb_set_seg(&save->cs, read_cs(), 0, -1U, code_seg_attr);
-	vmcb_set_seg(&save->ss, read_ss(), 0, -1U, data_seg_attr);
-	vmcb_set_seg(&save->ds, read_ds(), 0, -1U, data_seg_attr);
-	sgdt(&desc_table_ptr);
-	vmcb_set_seg(&save->gdtr, 0, desc_table_ptr.base, desc_table_ptr.limit, 0);
-	sidt(&desc_table_ptr);
-	vmcb_set_seg(&save->idtr, 0, desc_table_ptr.base, desc_table_ptr.limit, 0);
-	ctrl->asid = 1;
-	save->cpl = 0;
-	save->efer = rdmsr(MSR_EFER);
-	save->cr4 = read_cr4();
-	save->cr3 = read_cr3();
-	save->cr0 = read_cr0();
-	save->dr7 = read_dr7();
-	save->dr6 = read_dr6();
-	save->cr2 = read_cr2();
-	save->g_pat = rdmsr(MSR_IA32_CR_PAT);
-	save->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
-	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
-		(1ULL << INTERCEPT_VMMCALL) |
-		(1ULL << INTERCEPT_SHUTDOWN);
-	ctrl->iopm_base_pa = virt_to_phys(svm_get_io_bitmap());
-	ctrl->msrpm_base_pa = virt_to_phys(svm_get_msr_bitmap());
-
-	if (npt_supported()) {
-		ctrl->nested_ctl = 1;
-		ctrl->nested_cr3 = (u64)npt_get_pml4e();
-		ctrl->tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
-	}
-}
-
 struct regs regs;
 
 struct regs get_regs(void)
diff --git a/x86/svm.h b/x86/svm.h
index f4343883..623f2b36 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -55,7 +55,6 @@ bool default_finished(struct svm_test *test);
 int get_test_stage(struct svm_test *test);
 void set_test_stage(struct svm_test *test, int s);
 void inc_test_stage(struct svm_test *test);
-void vmcb_ident(struct vmcb *vmcb);
 struct regs get_regs(void);
 int __svm_vmrun(u64 rip);
 void __svm_bare_vmrun(void);
-- 
2.26.3

