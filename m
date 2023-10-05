Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34ECC7BA53D
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbjJEQPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240917AbjJEQNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:13:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA268C23
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 07:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696516738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/LY4axRS36d7oYClxVQXChDpT6oDS0570aCeAUiKUZ8=;
        b=YctDGQRQgF5whdA9GFw5bNaU5bbRTR5onaLowYfucboZ6oEV3xHF99khI0SiB/52yxVb7h
        iskRaVGRyM2iGtRZdggGg0Gp73YsOxxxtTahNIXzSy1FPt8LGl3FgBK25qUb7jlStnKX37
        yUf91kEunm5guITYcCh+Thogry6xmrA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-YzPl-BixNdaHuF1X2AM5yA-1; Thu, 05 Oct 2023 10:38:51 -0400
X-MC-Unique: YzPl-BixNdaHuF1X2AM5yA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D36C803498;
        Thu,  5 Oct 2023 14:38:51 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.39.192.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11C0A40C6EA8;
        Thu,  5 Oct 2023 14:38:49 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v2 6/7] KVM: selftests: x86: Use TAP interface in the vmx_pmu_caps test
Date:   Thu,  5 Oct 2023 16:38:38 +0200
Message-ID: <20231005143839.365297-7-thuth@redhat.com>
In-Reply-To: <20231005143839.365297-1-thuth@redhat.com>
References: <20231005143839.365297-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the kvm_test_harness.h interface in this test to get TAP
output, so that it is easier for the user to see what the test
is doing.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 50 ++++---------------
 1 file changed, 11 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index ebbcb0a3f7438..20c9c411de9fb 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -15,6 +15,7 @@
 
 #include <linux/bitmap.h>
 
+#include "kvm_test_harness.h"
 #include "kvm_util.h"
 #include "vmx.h"
 
@@ -32,7 +33,7 @@ union perf_capabilities {
 		u64	anythread_deprecated:1;
 	};
 	u64	capabilities;
-};
+} host_cap;
 
 /*
  * The LBR format and most PEBS features are immutable, all other features are
@@ -73,19 +74,19 @@ static void guest_code(uint64_t current_val)
 	GUEST_DONE();
 }
 
+KVM_ONE_VCPU_TEST_SUITE(vmx_pmu_caps, guest_code);
+
 /*
  * Verify that guest WRMSRs to PERF_CAPABILITIES #GP regardless of the value
  * written, that the guest always sees the userspace controlled value, and that
  * PERF_CAPABILITIES is immutable after KVM_RUN.
  */
-static void test_guest_wrmsr_perf_capabilities(union perf_capabilities host_cap)
+KVM_ONE_VCPU_TEST(vmx_pmu_caps, guest_wrmsr_perf_capabilities)
 {
-	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	struct ucall uc;
 	int r, i;
 
-	vm_init_descriptor_tables(vm);
+	vm_init_descriptor_tables(vcpu->vm);
 	vcpu_init_descriptor_tables(vcpu);
 
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
@@ -117,31 +118,21 @@ static void test_guest_wrmsr_perf_capabilities(union perf_capabilities host_cap)
 		TEST_ASSERT(!r, "Post-KVM_RUN write '0x%llx'didn't fail",
 			    host_cap.capabilities ^ BIT_ULL(i));
 	}
-
-	kvm_vm_free(vm);
 }
 
 /*
  * Verify KVM allows writing PERF_CAPABILITIES with all KVM-supported features
  * enabled, as well as '0' (to disable all features).
  */
-static void test_basic_perf_capabilities(union perf_capabilities host_cap)
+KVM_ONE_VCPU_TEST(vmx_pmu_caps, basic_perf_capabilities)
 {
-	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, NULL);
-
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, 0);
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
-
-	kvm_vm_free(vm);
 }
 
-static void test_fungible_perf_capabilities(union perf_capabilities host_cap)
+KVM_ONE_VCPU_TEST(vmx_pmu_caps, fungible_perf_capabilities)
 {
 	const uint64_t fungible_caps = host_cap.capabilities & ~immutable_caps.capabilities;
-
-	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, NULL);
 	int bit;
 
 	for_each_set_bit(bit, &fungible_caps, 64) {
@@ -150,8 +141,6 @@ static void test_fungible_perf_capabilities(union perf_capabilities host_cap)
 			     host_cap.capabilities & ~BIT_ULL(bit));
 	}
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
-
-	kvm_vm_free(vm);
 }
 
 /*
@@ -160,14 +149,11 @@ static void test_fungible_perf_capabilities(union perf_capabilities host_cap)
  * separately as they are multi-bit values, e.g. toggling or setting a single
  * bit can generate a false positive without dedicated safeguards.
  */
-static void test_immutable_perf_capabilities(union perf_capabilities host_cap)
+KVM_ONE_VCPU_TEST(vmx_pmu_caps, immutable_perf_capabilities)
 {
 	const uint64_t reserved_caps = (~host_cap.capabilities |
 					immutable_caps.capabilities) &
 				       ~format_caps.capabilities;
-
-	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, NULL);
 	union perf_capabilities val = host_cap;
 	int r, bit;
 
@@ -201,8 +187,6 @@ static void test_immutable_perf_capabilities(union perf_capabilities host_cap)
 		TEST_ASSERT(!r, "Bad PEBS FMT = 0x%x didn't fail, host = 0x%x",
 			    val.pebs_format, host_cap.pebs_format);
 	}
-
-	kvm_vm_free(vm);
 }
 
 /*
@@ -211,17 +195,13 @@ static void test_immutable_perf_capabilities(union perf_capabilities host_cap)
  * LBR_TOS as those bits are writable across all uarch implementations (arch
  * LBRs will need to poke a different MSR).
  */
-static void test_lbr_perf_capabilities(union perf_capabilities host_cap)
+KVM_ONE_VCPU_TEST(vmx_pmu_caps, lbr_perf_capabilities)
 {
-	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm;
 	int r;
 
 	if (!host_cap.lbr_format)
 		return;
 
-	vm = vm_create_with_one_vcpu(&vcpu, NULL);
-
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
 	vcpu_set_msr(vcpu, MSR_LBR_TOS, 7);
 
@@ -229,14 +209,10 @@ static void test_lbr_perf_capabilities(union perf_capabilities host_cap)
 
 	r = _vcpu_set_msr(vcpu, MSR_LBR_TOS, 7);
 	TEST_ASSERT(!r, "Writing LBR_TOS should fail after disabling vPMU");
-
-	kvm_vm_free(vm);
 }
 
 int main(int argc, char *argv[])
 {
-	union perf_capabilities host_cap;
-
 	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
 
@@ -248,9 +224,5 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(host_cap.full_width_write,
 		    "Full-width writes should always be supported");
 
-	test_basic_perf_capabilities(host_cap);
-	test_fungible_perf_capabilities(host_cap);
-	test_immutable_perf_capabilities(host_cap);
-	test_guest_wrmsr_perf_capabilities(host_cap);
-	test_lbr_perf_capabilities(host_cap);
+	return test_harness_run(argc, argv);
 }
-- 
2.41.0

