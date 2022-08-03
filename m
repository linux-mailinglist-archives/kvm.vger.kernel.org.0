Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50A3588DD8
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbiHCNtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238467AbiHCNtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:49:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3FB6949B7D
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 06:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659534440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yrgIt7wMB3BC2qaOIfwXyAq+Ql6s1w+HL8kkBqcizxc=;
        b=DoNKQ/i/eNpESUIv4THQUokke0SWq/mnA/qA/1akdJRiPq59nJ9f9yiUcnGXX6xOa3PDTJ
        1sNWhSeDOSRHFrg+ZyQlPba60zZM7DDHwxbm5CYzoCmEDOVcMY2bHz1P1GzPc29gAcM4M2
        Prfj89k6kkQ9kPn1iwxCM6vvQ/1H/UM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-UdSUlpx7NRqeRnPjMIngkg-1; Wed, 03 Aug 2022 09:47:17 -0400
X-MC-Unique: UdSUlpx7NRqeRnPjMIngkg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 816EC382C98A;
        Wed,  3 Aug 2022 13:47:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE2C22026D4C;
        Wed,  3 Aug 2022 13:47:13 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 38/40] KVM: selftests: evmcs_test: Introduce L2 TLB flush test
Date:   Wed,  3 Aug 2022 15:47:12 +0200
Message-Id: <20220803134712.399598-1-vkuznets@redhat.com>
In-Reply-To: <20220803134110.397885-1-vkuznets@redhat.com>
References: <20220803134110.397885-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 50 ++++++++++++++++++-
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
index c399058b36db..e8d7137f604f 100644
--- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
@@ -226,6 +226,8 @@ struct hv_enlightened_vmcs {
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_ENLIGHTENMENTSCONTROL    BIT(15)
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL                      0xFFFF
 
+#define HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH 0x10000031
+
 extern struct hv_enlightened_vmcs *current_evmcs;
 
 int vcpu_enable_evmcs(struct kvm_vcpu *vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 74f076ba574b..691dbe0a0881 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -16,6 +16,7 @@
 
 #include "kvm_util.h"
 
+#include "hyperv.h"
 #include "vmx.h"
 
 static int ud_count;
@@ -48,6 +49,8 @@ static inline void rdmsr_gs_base(void)
 
 void l2_guest_code(void)
 {
+	u64 unused;
+
 	GUEST_SYNC(7);
 
 	GUEST_SYNC(8);
@@ -64,15 +67,33 @@ void l2_guest_code(void)
 	vmcall();
 	rdmsr_gs_base(); /* intercepted */
 
+	/* L2 TLB flush tests */
+	hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
+			   HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS);
+	rdmsr_fs_base();
+	/*
+	 * Note: hypercall status (RAX) is not preserved correctly by L1 after
+	 * synthetic vmexit, use unchecked version.
+	 */
+	__hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
+			   HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS,
+			   &unused);
+	/* Make sure we're no issuing Hyper-V TLB flush call again */
+	__asm__ __volatile__ ("mov $0xdeadbeef, %rcx");
+
 	/* Done, exit to L1 and never come back.  */
 	vmcall();
 }
 
-void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages)
+void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages,
+		vm_vaddr_t hv_hcall_page_gpa)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
+	wrmsr(HV_X64_MSR_HYPERCALL, hv_hcall_page_gpa);
+
 	x2apic_enable();
 
 	GUEST_SYNC(1);
@@ -102,6 +123,14 @@ void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages)
 	vmwrite(PIN_BASED_VM_EXEC_CONTROL, vmreadz(PIN_BASED_VM_EXEC_CONTROL) |
 		PIN_BASED_NMI_EXITING);
 
+	/* L2 TLB flush setup */
+	current_evmcs->partition_assist_page = hv_pages->partition_assist_gpa;
+	current_evmcs->hv_enlightenments_control.nested_flush_hypercall = 1;
+	current_evmcs->hv_vm_id = 1;
+	current_evmcs->hv_vp_id = 1;
+	current_vp_assist->nested_control.features.directhypercall = 1;
+	*(u32 *)(hv_pages->partition_assist) = 0;
+
 	GUEST_ASSERT(!vmlaunch());
 	GUEST_ASSERT(vmptrstz() == hv_pages->enlightened_vmcs_gpa);
 
@@ -146,6 +175,18 @@ void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages)
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
+	*(u32 *)(hv_pages->partition_assist) = 1;
+	GUEST_ASSERT(!vmresume());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH);
+
 	GUEST_ASSERT(!vmresume());
 	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
 	GUEST_SYNC(11);
@@ -199,6 +240,7 @@ static struct kvm_vcpu *save_restore_vm(struct kvm_vm *vm,
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t vmx_pages_gva = 0, hv_pages_gva = 0;
+	vm_vaddr_t hcall_page;
 
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -212,12 +254,16 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS));
 
+	hcall_page = vm_vaddr_alloc_pages(vm, 1);
+	memset(addr_gva2hva(vm, hcall_page), 0x0,  getpagesize());
+
 	vcpu_set_hv_cpuid(vcpu);
 	vcpu_enable_evmcs(vcpu);
 
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
 	vcpu_alloc_hyperv_test_pages(vm, &hv_pages_gva);
-	vcpu_args_set(vcpu, 2, vmx_pages_gva, hv_pages_gva);
+	vcpu_args_set(vcpu, 3, vmx_pages_gva, hv_pages_gva, addr_gva2gpa(vm, hcall_page));
+	vcpu_set_msr(vcpu, HV_X64_MSR_VP_INDEX, vcpu->id);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
-- 
2.35.3

