Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1652B614DC4
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 16:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiKAPFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 11:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiKAPDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 11:03:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58931F9C2
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TXHf/0Y+hrDc3yGNDHaxI7E3XRvFZKsBJzJ1YGIcvgQ=;
        b=dt1CmJRdIt29MnQx+azhWUN9KZ+KSEFk6nGlFg1rugqE4sJq+o9zT+rkOflOYYkLPPpRDr
        uJjpKnh1+76/TIwUQ+rWlsiLqcVxWYcRQ5/zY72oMKyugy17UeVQRAlsF9n3NJesWKT28A
        TIx4+gzL4PTcfMvaH77Hg8NPsTjN02o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-sy8_ck0ZPnqOjkJxC8FBzg-1; Tue, 01 Nov 2022 10:57:03 -0400
X-MC-Unique: sy8_ck0ZPnqOjkJxC8FBzg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 197AC810B3E;
        Tue,  1 Nov 2022 14:57:03 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E546FC15BA5;
        Tue,  1 Nov 2022 14:56:55 +0000 (UTC)
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
Subject: [PATCH v13 46/48] KVM: selftests: evmcs_test: Introduce L2 TLB flush test
Date:   Tue,  1 Nov 2022 15:54:24 +0100
Message-Id: <20221101145426.251680-47-vkuznets@redhat.com>
In-Reply-To: <20221101145426.251680-1-vkuznets@redhat.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
index 94d6059e9a12..901caf0e0939 100644
--- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
@@ -237,6 +237,8 @@ struct hv_enlightened_vmcs {
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_ENLIGHTENMENTSCONTROL    BIT(15)
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL                      0xFFFF
 
+#define HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH 0x10000031
+
 extern struct hv_enlightened_vmcs *current_evmcs;
 
 int vcpu_enable_evmcs(struct kvm_vcpu *vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index a9f511c192c2..d418954590b1 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -16,6 +16,7 @@
 
 #include "kvm_util.h"
 
+#include "hyperv.h"
 #include "vmx.h"
 
 static int ud_count;
@@ -32,6 +33,8 @@ static void guest_nmi_handler(struct ex_regs *regs)
 
 void l2_guest_code(void)
 {
+	u64 unused;
+
 	GUEST_SYNC(7);
 
 	GUEST_SYNC(8);
@@ -48,15 +51,31 @@ void l2_guest_code(void)
 	vmcall();
 	rdmsr_from_l2(MSR_GS_BASE); /* intercepted */
 
+	/* L2 TLB flush tests */
+	hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
+			 HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS);
+	rdmsr_from_l2(MSR_FS_BASE);
+	/*
+	 * Note: hypercall status (RAX) is not preserved correctly by L1 after
+	 * synthetic vmexit, use unchecked version.
+	 */
+	__hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
+			   HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS,
+			   &unused);
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
@@ -86,7 +105,17 @@ void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages)
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
+	GUEST_ASSERT_EQ(vmreadz(VM_EXIT_REASON), EXIT_REASON_EXCEPTION_NMI);
+	GUEST_ASSERT_EQ((vmreadz(VM_EXIT_INTR_INFO) & 0xff), NMI_VECTOR);
 	GUEST_ASSERT(vmptrstz() == hv_pages->enlightened_vmcs_gpa);
 
 	/*
@@ -130,6 +159,18 @@ void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages)
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
@@ -183,6 +224,7 @@ static struct kvm_vcpu *save_restore_vm(struct kvm_vm *vm,
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t vmx_pages_gva = 0, hv_pages_gva = 0;
+	vm_vaddr_t hcall_page;
 
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -196,12 +238,16 @@ int main(int argc, char *argv[])
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
2.37.3

