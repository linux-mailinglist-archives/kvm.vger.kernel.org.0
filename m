Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBB7614DF5
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 16:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiKAPML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 11:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiKAPLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 11:11:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BA61A215
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 08:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667315053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eWatxlMq9h5/6ZiuEVDHpKSL0QGfUneEfh/vp1E4gdo=;
        b=B8SyiEo8p2it/p0I1whxDzGfgQhTXaAgULVZVVZ6I8ri7zXdWpEaXqdWAoXh0CQMU+st/S
        8BYAmeOplGfgh3/mrusPSXr6TfmlAM+bAr+qUYEguWhj1kWSZmMArnD5dzOLt+tzvrq/KB
        7oDRgNQ86iHL0XpIrvb5X6RBXawtyeQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-TxDYaNqoNHWKYHzIcn1oew-1; Tue, 01 Nov 2022 10:57:06 -0400
X-MC-Unique: TxDYaNqoNHWKYHzIcn1oew-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D904C1C0BC6E;
        Tue,  1 Nov 2022 14:57:05 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FF30C2C8C5;
        Tue,  1 Nov 2022 14:57:03 +0000 (UTC)
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
Subject: [PATCH v13 47/48] KVM: selftests: hyperv_svm_test: Introduce L2 TLB flush test
Date:   Tue,  1 Nov 2022 15:54:25 +0100
Message-Id: <20221101145426.251680-48-vkuznets@redhat.com>
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
from L2 don't exit to L1 unless 'TlbLockCount' is set in the Partition
assist page.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/svm.h        |  4 ++
 .../selftests/kvm/x86_64/hyperv_svm_test.c    | 59 +++++++++++++++++--
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/svm.h b/tools/testing/selftests/kvm/include/x86_64/svm.h
index 483e6ae12f69..4803e1056055 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm.h
@@ -76,6 +76,10 @@ struct hv_vmcb_enlightenments {
  */
 #define HV_VMCB_NESTED_ENLIGHTENMENTS (1U << 31)
 
+/* Synthetic VM-Exit */
+#define HV_SVM_EXITCODE_ENL			0xf0000000
+#define HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH	(1)
+
 struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 intercept_cr;
 	u32 intercept_dr;
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index e30419766c8a..c408ccbeeb3b 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -25,6 +25,8 @@
 
 void l2_guest_code(void)
 {
+	u64 unused;
+
 	GUEST_SYNC(3);
 	/* Exit to L1 */
 	vmmcall();
@@ -38,11 +40,28 @@ void l2_guest_code(void)
 
 	GUEST_SYNC(5);
 
+	/* L2 TLB flush tests */
+	hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE |
+			 HV_HYPERCALL_FAST_BIT, 0x0,
+			 HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES |
+			 HV_FLUSH_ALL_PROCESSORS);
+	rdmsr_from_l2(MSR_FS_BASE);
+	/*
+	 * Note: hypercall status (RAX) is not preserved correctly by L1 after
+	 * synthetic vmexit, use unchecked version.
+	 */
+	__hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE |
+			   HV_HYPERCALL_FAST_BIT, 0x0,
+			   HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES |
+			   HV_FLUSH_ALL_PROCESSORS, &unused);
+
 	/* Done, exit to L1 and never come back.  */
 	vmmcall();
 }
 
-static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
+static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
+						    struct hyperv_test_pages *hv_pages,
+						    vm_vaddr_t pgs_gpa)
 {
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	struct vmcb *vmcb = svm->vmcb;
@@ -50,13 +69,23 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
 
 	GUEST_SYNC(1);
 
-	wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
+	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
+	enable_vp_assist(hv_pages->vp_assist_gpa, hv_pages->vp_assist);
 
 	GUEST_ASSERT(svm->vmcb_gpa);
 	/* Prepare for L2 execution. */
 	generic_svm_setup(svm, l2_guest_code,
 			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
+	/* L2 TLB flush setup */
+	hve->partition_assist_page = hv_pages->partition_assist_gpa;
+	hve->hv_enlightenments_control.nested_flush_hypercall = 1;
+	hve->hv_vm_id = 1;
+	hve->hv_vp_id = 1;
+	current_vp_assist->nested_control.features.directhypercall = 1;
+	*(u32 *)(hv_pages->partition_assist) = 0;
+
 	GUEST_SYNC(2);
 	run_guest(vmcb, svm->vmcb_gpa);
 	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
@@ -91,6 +120,20 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
 	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
 	vmcb->save.rip += 2; /* rdmsr */
 
+
+	/*
+	 * L2 TLB flush test. First VMCALL should be handled directly by L0,
+	 * no VMCALL exit expected.
+	 */
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
+	vmcb->save.rip += 2; /* rdmsr */
+	/* Enable synthetic vmexit */
+	*(u32 *)(hv_pages->partition_assist) = 1;
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT(vmcb->control.exit_code == HV_SVM_EXITCODE_ENL);
+	GUEST_ASSERT(vmcb->control.exit_info_1 == HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH);
+
 	run_guest(vmcb, svm->vmcb_gpa);
 	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
 	GUEST_SYNC(6);
@@ -100,8 +143,8 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t nested_gva = 0;
-
+	vm_vaddr_t nested_gva = 0, hv_pages_gva = 0;
+	vm_vaddr_t hcall_page;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
@@ -115,7 +158,13 @@ int main(int argc, char *argv[])
 	vcpu_set_hv_cpuid(vcpu);
 	run = vcpu->run;
 	vcpu_alloc_svm(vm, &nested_gva);
-	vcpu_args_set(vcpu, 1, nested_gva);
+	vcpu_alloc_hyperv_test_pages(vm, &hv_pages_gva);
+
+	hcall_page = vm_vaddr_alloc_pages(vm, 1);
+	memset(addr_gva2hva(vm, hcall_page), 0x0,  getpagesize());
+
+	vcpu_args_set(vcpu, 3, nested_gva, hv_pages_gva, addr_gva2gpa(vm, hcall_page));
+	vcpu_set_msr(vcpu, HV_X64_MSR_VP_INDEX, vcpu->id);
 
 	for (stage = 1;; stage++) {
 		vcpu_run(vcpu);
-- 
2.37.3

