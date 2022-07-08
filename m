Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984A356BCA9
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 17:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbiGHOnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 10:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238433AbiGHOmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 10:42:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD1545721C
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 07:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657291374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T9ySlRX5Xpz4wzTsWodqgaUDYgCvJF8U7knTKwuoA8Y=;
        b=CUBUu0pmrmRGiYkT/j5YD+QtpJJAS5xKZwxWZ+SA86C3AWmvlpN1AYIn9GTeAQ+rmpvn3p
        o9E0sPYgT2iFNwANrCleweuCHNiyGrP8PC7Xhs7Mk39EqsM4plexep/bfF7vkHqD40qWOW
        4BQtDGbWluzZRierok/rI01HuS+IYTY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-3Uk8GVQNOayXI2BXnX070A-1; Fri, 08 Jul 2022 10:42:51 -0400
X-MC-Unique: 3Uk8GVQNOayXI2BXnX070A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 626BE294EDFC;
        Fri,  8 Jul 2022 14:42:50 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABD9A492C3B;
        Fri,  8 Jul 2022 14:42:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/25] KVM: selftests: Enable TSC scaling in evmcs selftest
Date:   Fri,  8 Jul 2022 16:42:08 +0200
Message-Id: <20220708144223.610080-11-vkuznets@redhat.com>
In-Reply-To: <20220708144223.610080-1-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The updated Enlightened VMCS v1 definition enables TSC scaling, test
that SECONDARY_EXEC_TSC_SCALING can now be enabled.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 31 +++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 8dda527cc080..80135b98dc3b 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -18,6 +18,9 @@
 
 #include "vmx.h"
 
+/* Test flags */
+#define HOST_HAS_TSC_SCALING BIT(0)
+
 static int ud_count;
 
 static void guest_ud_handler(struct ex_regs *regs)
@@ -64,11 +67,14 @@ void l2_guest_code(void)
 	vmcall();
 	rdmsr_gs_base(); /* intercepted */
 
+	/* TSC scaling */
+	vmcall();
+
 	/* Done, exit to L1 and never come back.  */
 	vmcall();
 }
 
-void guest_code(struct vmx_pages *vmx_pages)
+void guest_code(struct vmx_pages *vmx_pages, u64 test_flags)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
@@ -150,6 +156,18 @@ void guest_code(struct vmx_pages *vmx_pages)
 	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
 	GUEST_SYNC(11);
 
+	if (test_flags & HOST_HAS_TSC_SCALING) {
+		GUEST_ASSERT((rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2) >> 32) &
+			     SECONDARY_EXEC_TSC_SCALING);
+		/* Try enabling TSC scaling */
+		vmwrite(SECONDARY_VM_EXEC_CONTROL, vmreadz(SECONDARY_VM_EXEC_CONTROL) |
+			SECONDARY_EXEC_TSC_SCALING);
+		vmwrite(TSC_MULTIPLIER, 1);
+	}
+	GUEST_ASSERT(!vmresume());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	GUEST_SYNC(12);
+
 	/* Try enlightened vmptrld with an incorrect GPA */
 	evmcs_vmptrld(0xdeadbeef, vmx_pages->enlightened_vmcs);
 	GUEST_ASSERT(vmlaunch());
@@ -204,6 +222,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct ucall uc;
+	u64 test_flags = 0;
 	int stage;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
@@ -212,11 +231,19 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS));
 
+	if ((kvm_get_feature_msr(MSR_IA32_VMX_PROCBASED_CTLS2) >> 32) &
+	    SECONDARY_EXEC_TSC_SCALING) {
+		test_flags |= HOST_HAS_TSC_SCALING;
+		pr_info("TSC scaling is supported, adding to test\n");
+	} else {
+		pr_info("TSC scaling is not supported\n");
+	}
+
 	vcpu_set_hv_cpuid(vcpu);
 	vcpu_enable_evmcs(vcpu);
 
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vcpu, 1, vmx_pages_gva);
+	vcpu_args_set(vcpu, 2, vmx_pages_gva, test_flags);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
-- 
2.35.3

