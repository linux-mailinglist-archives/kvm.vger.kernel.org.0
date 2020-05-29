Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7541E8213
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgE2PkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:40:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50899 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728000AbgE2Pjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 11:39:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CLX54l4QiZFy1AcgntBXNeV0JMREnmcfu0Nk3d7TYuI=;
        b=IBN6yOKxjzMWRjG2r/CFa7V0pzgf5/cmoR+Kqp31HHb+uphkp9Cq8fUXB6phhOdoMmQ9Yu
        kA+cT3dARIWINBiAnBp7h1jVncJ3OdBW6Vb439+XbmAq/rwFtT2uThZMCzz2yNCiVahhGY
        OGlNggPlFcRTjbsDp4Nfk6vWnsmxtWk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-P4ITo3yxMnqQZdBEtYXhqw-1; Fri, 29 May 2020 11:39:51 -0400
X-MC-Unique: P4ITo3yxMnqQZdBEtYXhqw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 027E81005510;
        Fri, 29 May 2020 15:39:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0E3510013C2;
        Fri, 29 May 2020 15:39:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 28/30] selftests: kvm: add a SVM version of state-test
Date:   Fri, 29 May 2020 11:39:32 -0400
Message-Id: <20200529153934.11694-29-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test is similar to the existing one for VMX, but simpler because we
don't have to test shadow VMCS or vmptrld/vmptrst/vmclear.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../testing/selftests/kvm/x86_64/state_test.c | 62 +++++++++++++++----
 1 file changed, 50 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index 5b1a016edf55..d43b6f99b66c 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -18,14 +18,46 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "vmx.h"
+#include "svm_util.h"
 
 #define VCPU_ID		5
+#define L2_GUEST_STACK_SIZE 256
 
-void l2_guest_code(void)
+void svm_l2_guest_code(void)
 {
+	GUEST_SYNC(4);
+	/* Exit to L1 */
+	vmcall();
 	GUEST_SYNC(6);
+	/* Done, exit to L1 and never come back.  */
+	vmcall();
+}
 
-        /* Exit to L1 */
+static void svm_l1_guest_code(struct svm_test_data *svm)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb = svm->vmcb;
+
+	GUEST_ASSERT(svm->vmcb_gpa);
+	/* Prepare for L2 execution. */
+	generic_svm_setup(svm, svm_l2_guest_code,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	GUEST_SYNC(3);
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+	GUEST_SYNC(5);
+	vmcb->save.rip += 3;
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+	GUEST_SYNC(7);
+}
+
+void vmx_l2_guest_code(void)
+{
+	GUEST_SYNC(6);
+
+	/* Exit to L1 */
 	vmcall();
 
 	/* L1 has now set up a shadow VMCS for us.  */
@@ -42,10 +74,9 @@ void l2_guest_code(void)
 	vmcall();
 }
 
-void l1_guest_code(struct vmx_pages *vmx_pages)
+static void vmx_l1_guest_code(struct vmx_pages *vmx_pages)
 {
-#define L2_GUEST_STACK_SIZE 64
-        unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 
 	GUEST_ASSERT(vmx_pages->vmcs_gpa);
 	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
@@ -56,7 +87,7 @@ void l1_guest_code(struct vmx_pages *vmx_pages)
 	GUEST_SYNC(4);
 	GUEST_ASSERT(vmptrstz() == vmx_pages->vmcs_gpa);
 
-	prepare_vmcs(vmx_pages, l2_guest_code,
+	prepare_vmcs(vmx_pages, vmx_l2_guest_code,
 		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
 	GUEST_SYNC(5);
@@ -106,20 +137,24 @@ void l1_guest_code(struct vmx_pages *vmx_pages)
 	GUEST_ASSERT(vmresume());
 }
 
-void guest_code(struct vmx_pages *vmx_pages)
+static void __attribute__((__flatten__)) guest_code(void *arg)
 {
 	GUEST_SYNC(1);
 	GUEST_SYNC(2);
 
-	if (vmx_pages)
-		l1_guest_code(vmx_pages);
+	if (arg) {
+		if (cpu_has_svm())
+			svm_l1_guest_code(arg);
+		else
+			vmx_l1_guest_code(arg);
+	}
 
 	GUEST_DONE();
 }
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva = 0;
+	vm_vaddr_t nested_gva = 0;
 
 	struct kvm_regs regs1, regs2;
 	struct kvm_vm *vm;
@@ -136,8 +171,11 @@ int main(int argc, char *argv[])
 	vcpu_regs_get(vm, VCPU_ID, &regs1);
 
 	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
-		vcpu_alloc_vmx(vm, &vmx_pages_gva);
-		vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+		if (kvm_get_supported_cpuid_entry(0x80000001)->ecx & CPUID_SVM)
+			vcpu_alloc_svm(vm, &nested_gva);
+		else
+			vcpu_alloc_vmx(vm, &nested_gva);
+		vcpu_args_set(vm, VCPU_ID, 1, nested_gva);
 	} else {
 		pr_info("will skip nested state checks\n");
 		vcpu_args_set(vm, VCPU_ID, 1, 0);
-- 
2.26.2


