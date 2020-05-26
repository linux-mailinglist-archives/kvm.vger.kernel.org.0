Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCF41D9ED3
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 20:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgESSH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 14:07:57 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32321 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729185AbgESSH4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 May 2020 14:07:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589911675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=jSkbMzL80RhyCrT3ZnovTmqJc4ZMDL+dVOZ04nO1iEs=;
        b=Gsi/xEGqH/abMdni/AhgX2Z1O0999l7VvRQe05gK4B/qzyM63cIt3VPuRezvsliwN0RhMZ
        K8qWGTszjo2mjiOVTH8vlcgoUKKfUvNFxWMlss7gs8NH55N5JZy/xNbMXQXk6U10QMy7wZ
        QpQ2g2jCJ2JolclLl5UXnOV4qMjY1Fk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-UqvQheSgO6CDN0qpYEYNHQ-1; Tue, 19 May 2020 14:07:42 -0400
X-MC-Unique: UqvQheSgO6CDN0qpYEYNHQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72E90800D24;
        Tue, 19 May 2020 18:07:41 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBDF55D9DD;
        Tue, 19 May 2020 18:07:40 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     oupton@google.com
Subject: [PATCH 1/3] selftests: kvm: add a SVM version of state-test
Date:   Tue, 19 May 2020 14:07:38 -0400
Message-Id: <20200519180740.89884-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../testing/selftests/kvm/x86_64/state_test.c | 65 ++++++++++++++++---
 1 file changed, 55 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index 5b1a016edf55..1c5216f1ef0a 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -18,10 +18,42 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "vmx.h"
+#include "svm_util.h"
 
 #define VCPU_ID		5
+#define L2_GUEST_STACK_SIZE 64
+
+void svm_l2_guest_code(void)
+{
+	GUEST_SYNC(4);
+        /* Exit to L1 */
+	vmcall();
+	GUEST_SYNC(6);
+	/* Done, exit to L1 and never come back.  */
+	vmcall();
+}
+
+static void svm_l1_guest_code(struct svm_test_data *svm)
+{
+        unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb = svm->vmcb;
+
+	GUEST_ASSERT(svm->vmcb_gpa);
+	/* Prepare for L2 execution. */
+        generic_svm_setup(svm, svm_l2_guest_code,
+                          &l2_guest_stack[L2_GUEST_STACK_SIZE]);
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
 
-void l2_guest_code(void)
+void vmx_l2_guest_code(void)
 {
 	GUEST_SYNC(6);
 
@@ -42,9 +74,8 @@ void l2_guest_code(void)
 	vmcall();
 }
 
-void l1_guest_code(struct vmx_pages *vmx_pages)
+static void vmx_l1_guest_code(struct vmx_pages *vmx_pages)
 {
-#define L2_GUEST_STACK_SIZE 64
         unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 
 	GUEST_ASSERT(vmx_pages->vmcs_gpa);
@@ -56,7 +87,7 @@ void l1_guest_code(struct vmx_pages *vmx_pages)
 	GUEST_SYNC(4);
 	GUEST_ASSERT(vmptrstz() == vmx_pages->vmcs_gpa);
 
-	prepare_vmcs(vmx_pages, l2_guest_code,
+	prepare_vmcs(vmx_pages, vmx_l2_guest_code,
 		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
 	GUEST_SYNC(5);
@@ -106,20 +137,31 @@ void l1_guest_code(struct vmx_pages *vmx_pages)
 	GUEST_ASSERT(vmresume());
 }
 
-void guest_code(struct vmx_pages *vmx_pages)
+static u32 cpuid_ecx(u32 eax)
+{
+	u32 result;
+	asm volatile("cpuid" : "=c" (result) : "a" (eax));
+	return result;
+}
+
+static void __attribute__((__flatten__)) guest_code(void *arg)
 {
 	GUEST_SYNC(1);
 	GUEST_SYNC(2);
 
-	if (vmx_pages)
-		l1_guest_code(vmx_pages);
+	if (arg) {
+		if (cpuid_ecx(0x80000001) & CPUID_SVM)
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
@@ -136,8 +178,11 @@ int main(int argc, char *argv[])
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
2.18.2

