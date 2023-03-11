Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1726B5710
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjCKAsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbjCKArX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:47:23 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA7B13E0A9
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:46:51 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id m9-20020a170902db0900b0019ea0e227e4so3616221plx.6
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678495611;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IhTBia6bsmV3yZc9hMtuCJ7+iIO3gStCyZPlx0VMvQQ=;
        b=Gvu/bH0wLcYdNxbtY2pIVUnwdv5diml4fm36b2o7zImi6GqKbDgWBNLkjS6TOYB0rW
         Kd6UijLo1FAp0KYUbGLQn3/3nXbBu5K1L+Uh75ozfpJCSu3tw3PS4q7BHxcpOQ3pEj/7
         1ju2iac7nsa5DhCdFGjlIFAo/Hndm/HTw/1VN667M51a2tGSZYktQp87TnLCzy3YnUcZ
         JeqVy7LmSj/zOM79hXzJjqsIjoIoHg7F7ltFynS7AA0/mD+HSLBGQk/D+34VWb42TNJr
         aMR8mhVhyUsUK32gscNSeEGxG6faDkskat7GMJ9ZbqtQuz9tDnJdByQ3u0wQ+BMfRMSB
         zkGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678495611;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IhTBia6bsmV3yZc9hMtuCJ7+iIO3gStCyZPlx0VMvQQ=;
        b=1CJzoMUZG7GgpBGMhBBM7VWWpLS7BSpojzifmv6simzjgpsib1N4zFNjuGFtzSwt/X
         4ffbsyvPgosQGwL3qkuie5mLxt0PAuVXuDStN0oqrOZzIeEci+90YynSOxibAoBnxUIN
         2PApnQAiNzzuOLwKIQyEMf4bNUUjboHFXHnFhGccSzRyAaFhnqOfYQnimI1hMU9ER6Au
         lZD61OLCDKM92EN16Ivr2NPlDoI3ubTWnbmeI7q8f4x+H8ndAhMVsW1wW67cfZyn/gLM
         rVRDsGbXZVfhEKz1pt25LxQXnJzfeesJTRVlcAOXpMXQAw0Zo5q/Gs7sm12BFBFz8eC5
         G+Vg==
X-Gm-Message-State: AO0yUKVYZuF2DHc5CNyn6UXnYSQ2CPCZ71OE8JPg1fp7o4o3CxqPyMs8
        5Tfmw65Y8OD5S4MW4FzOLagy+OdKmi0=
X-Google-Smtp-Source: AK7set9LcE4ENH9TQQNFoUglKcHLo4MbBBqYi2LpFazCMV3msaC/jCEvQ4EJN1xOYa/P2cAIO5AIfagl5T0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f705:0:b0:503:7cc9:3f8d with SMTP id
 x5-20020a63f705000000b005037cc93f8dmr9669146pgh.9.1678495611683; Fri, 10 Mar
 2023 16:46:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:46:13 -0800
In-Reply-To: <20230311004618.920745-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311004618.920745-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311004618.920745-17-seanjc@google.com>
Subject: [PATCH v3 16/21] KVM: selftests: Expand negative testing of guest
 writes to PERF_CAPABILITIES
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that the guest can't write 0 to PERF_CAPABILITIES, can't write the
current value, and can't toggle _any_ bits.  There is no reason to special
case the LBR format.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 61 ++++++++++++++++---
 1 file changed, 54 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index d91bf44a2e39..44fc6101a547 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -54,9 +54,59 @@ static const union perf_capabilities format_caps = {
 	.pebs_format = -1,
 };
 
-static void guest_code(void)
+static void guest_code(uint64_t current_val)
 {
-	wrmsr(MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
+	uint8_t vector;
+	int i;
+
+	vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES, current_val);
+	GUEST_ASSERT_2(vector == GP_VECTOR, current_val, vector);
+
+	vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES, 0);
+	GUEST_ASSERT_2(vector == GP_VECTOR, 0, vector);
+
+	for (i = 0; i < 64; i++) {
+		vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES,
+				    current_val ^ BIT_ULL(i));
+		GUEST_ASSERT_2(vector == GP_VECTOR,
+			       current_val ^ BIT_ULL(i), vector);
+	}
+
+	GUEST_DONE();
+}
+
+/*
+ * Verify that guest WRMSRs to PERF_CAPABILITIES #GP regardless of the value
+ * written, that the guest always sees the userspace controlled value, and that
+ * PERF_CAPABILITIES is immutable after KVM_RUN.
+ */
+static void test_guest_wrmsr_perf_capabilities(union perf_capabilities host_cap)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	struct ucall uc;
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
+
+	vcpu_args_set(vcpu, 1, host_cap.capabilities);
+	vcpu_run(vcpu);
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT_2(uc, "val = 0x%lx, vector = %lu");
+		break;
+	case UCALL_DONE:
+		break;
+	default:
+		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+	}
+
+	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), host_cap.capabilities);
+
+	kvm_vm_free(vm);
 }
 
 /*
@@ -79,7 +129,7 @@ static void test_fungible_perf_capabilities(union perf_capabilities host_cap)
 	const uint64_t fungible_caps = host_cap.capabilities & ~immutable_caps.capabilities;
 
 	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, NULL);
 	int bit;
 
 	for_each_set_bit(bit, &fungible_caps, 64) {
@@ -89,10 +139,6 @@ static void test_fungible_perf_capabilities(union perf_capabilities host_cap)
 	}
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
 
-	/* check whatever we write with KVM_SET_MSR is _not_ modified */
-	vcpu_run(vcpu);
-	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), host_cap.capabilities);
-
 	kvm_vm_free(vm);
 }
 
@@ -153,6 +199,7 @@ int main(int argc, char *argv[])
 	test_basic_perf_capabilities(host_cap);
 	test_fungible_perf_capabilities(host_cap);
 	test_immutable_perf_capabilities(host_cap);
+	test_guest_wrmsr_perf_capabilities(host_cap);
 
 	printf("Completed perf capability tests.\n");
 }
-- 
2.40.0.rc1.284.g88254d51c5-goog

