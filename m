Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AE450151B
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 17:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbiDNNgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 09:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244965AbiDNN2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 09:28:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 307699969D
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 06:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649942484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rZuJFI5+WrfKz8zXuuvBEC1ez7qdJgm1x6dbeUA0HMY=;
        b=YgT13rahRUmXoZXJXhwhS1lSTDtrmebw/6jJ0q0Ebhq5BAiHUAhx25s8m5jxiUsWd2BmvI
        NITCVCc1lGsELkVXcZ4IDQwdmWPFuixWxn8IjmW6234o+9BSkTznvhrvhcXK4ywL1exDH3
        xO/41F67/2wPZyWmUAsSt3m6/0wTKjI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-dQ0S61LNPKufHBq-p2uloA-1; Thu, 14 Apr 2022 09:21:21 -0400
X-MC-Unique: dQ0S61LNPKufHBq-p2uloA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B6BF802803;
        Thu, 14 Apr 2022 13:21:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE31F7C28;
        Thu, 14 Apr 2022 13:21:18 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 31/34] KVM: selftests: evmcs_test: Introduce L2 TLB flush test
Date:   Thu, 14 Apr 2022 15:20:10 +0200
Message-Id: <20220414132013.1588929-32-vkuznets@redhat.com>
In-Reply-To: <20220414132013.1588929-1-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable Hyper-V L2 TLB flush and check that Hyper-V TLB flush hypercalls
from L2 don't exit to L1 unless 'TlbLockCount' is set in the
Partition assist page.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/evmcs.h      |  2 +
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 52 ++++++++++++++++++-
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
index 9c965ba73dec..36c0a67d8602 100644
--- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
@@ -252,6 +252,8 @@ struct hv_enlightened_vmcs {
 #define HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_MASK	\
 		(~((1ull << HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT) - 1))
 
+#define HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH 0x10000031
+
 extern struct hv_enlightened_vmcs *current_evmcs;
 extern struct hv_vp_assist_page *current_vp_assist;
 
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index d12e043aa2ee..8d2aa7600d78 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -16,6 +16,7 @@
 
 #include "kvm_util.h"
 
+#include "hyperv.h"
 #include "vmx.h"
 
 #define VCPU_ID		5
@@ -49,6 +50,16 @@ static inline void rdmsr_gs_base(void)
 			      "r13", "r14", "r15");
 }
 
+static inline void hypercall(u64 control, vm_vaddr_t arg1, vm_vaddr_t arg2)
+{
+	asm volatile("mov %3, %%r8\n"
+		     "vmcall"
+		     : "+c" (control), "+d" (arg1)
+		     :  "r" (arg2)
+		     : "cc", "memory", "rax", "rbx", "r8", "r9", "r10",
+		       "r11", "r12", "r13", "r14", "r15");
+}
+
 void l2_guest_code(void)
 {
 	GUEST_SYNC(7);
@@ -67,15 +78,27 @@ void l2_guest_code(void)
 	vmcall();
 	rdmsr_gs_base(); /* intercepted */
 
+	/* L2 TLB flush tests */
+	hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
+		  HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS);
+	rdmsr_fs_base();
+	hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
+		  HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS);
+	/* Make sure we're no issuing Hyper-V TLB flush call again */
+	__asm__ __volatile__ ("mov $0xdeadbeef, %rcx");
+
 	/* Done, exit to L1 and never come back.  */
 	vmcall();
 }
 
-void guest_code(struct vmx_pages *vmx_pages)
+void guest_code(struct vmx_pages *vmx_pages, vm_vaddr_t pgs_gpa)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
+	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
+
 	x2apic_enable();
 
 	GUEST_SYNC(1);
@@ -105,6 +128,14 @@ void guest_code(struct vmx_pages *vmx_pages)
 	vmwrite(PIN_BASED_VM_EXEC_CONTROL, vmreadz(PIN_BASED_VM_EXEC_CONTROL) |
 		PIN_BASED_NMI_EXITING);
 
+	/* L2 TLB flush setup */
+	current_evmcs->partition_assist_page = vmx_pages->partition_assist_gpa;
+	current_evmcs->hv_enlightenments_control.nested_flush_hypercall = 1;
+	current_evmcs->hv_vm_id = 1;
+	current_evmcs->hv_vp_id = 1;
+	current_vp_assist->nested_control.features.directhypercall = 1;
+	*(u32 *)(vmx_pages->partition_assist) = 0;
+
 	GUEST_ASSERT(!vmlaunch());
 	GUEST_ASSERT(vmptrstz() == vmx_pages->enlightened_vmcs_gpa);
 
@@ -149,6 +180,18 @@ void guest_code(struct vmx_pages *vmx_pages)
 	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_MSR_READ);
 	current_evmcs->guest_rip += 2; /* rdmsr */
 
+	/*
+	 * L2 TLB flush test. First VMCALL should be handled directly by L0,
+	 * no VMCALL exit expected.
+	 */
+	GUEST_ASSERT(!vmresume());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_MSR_READ);
+	current_evmcs->guest_rip += 2; /* rdmsr */
+	/* Enable synthetic vmexit */
+	*(u32 *)(vmx_pages->partition_assist) = 1;
+	GUEST_ASSERT(!vmresume());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH);
+
 	GUEST_ASSERT(!vmresume());
 	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
 	GUEST_SYNC(11);
@@ -201,6 +244,7 @@ static void save_restore_vm(struct kvm_vm *vm)
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t vmx_pages_gva = 0;
+	vm_vaddr_t hcall_page;
 
 	struct kvm_vm *vm;
 	struct kvm_run *run;
@@ -217,11 +261,15 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
+	hcall_page = vm_vaddr_alloc_pages(vm, 1);
+	memset(addr_gva2hva(vm, hcall_page), 0x0,  getpagesize());
+
 	vcpu_set_hv_cpuid(vm, VCPU_ID);
 	vcpu_enable_evmcs(vm, VCPU_ID);
 
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+	vcpu_args_set(vm, VCPU_ID, 2, vmx_pages_gva, addr_gva2gpa(vm, hcall_page));
+	vcpu_set_msr(vm, VCPU_ID, HV_X64_MSR_VP_INDEX, VCPU_ID);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
-- 
2.35.1

