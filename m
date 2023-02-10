Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D83669157E
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjBJAck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjBJAcT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:32:19 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE989366A0
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:32:05 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id x15-20020a25accf000000b008efe9505b2eso85103ybd.22
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3aMSIJQHTkJvFMLxQlPPsalL8o5N8wDIsCOXy+QNiY0=;
        b=OHSjSxyPoWtH1UdLZ5y+EA/aw1FemTa8ZC/EoS7IROYb3LEhdj525fOFetgEPeNPU0
         mpC5CqyY5mYornbMlS+7TbHD5wdcpHIScipEIbGaF4bYC1yNrUd6RYZTWM4avp2k6obu
         6w3H0joiT3dl7FlB2hVL8wXEHCpIJFbC1nuDMXq/nW7C0V/78NE1pW1t9fjYQGM0SIoN
         gyPdx8xM4v2cBxc0RSCkGN9Wv+EeKrSk7J6nfwNTRdP/oAKZIf5Ws7S/a0IfIa5HZcHH
         1URhV/u93ze1HSSSdE0J0h+IWRMIe+NKU6J1eI04jrLNjXmtOzMujNWBoVDO44zD5hKy
         Avaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3aMSIJQHTkJvFMLxQlPPsalL8o5N8wDIsCOXy+QNiY0=;
        b=O07sP0zsFgXQXwl5hKLk4Cx2A3ZbU2buj54sFbNDH/3ogbqYwzhF2PA7nPhEXMXkMp
         rOI5N2gTe1tmjIyl4gAbFyMy9dIcCLrWQZvz7RuknDAfqyJuX+hQH0cr95g9pmEvP12C
         2KIU5k9d75JI15ag9Fn8eEtio3+lxCVt5waqDMdUpe/9fT1yAwHLJTFOWeClmJflxTha
         FtXgnKjJRp1+CtBs6dN2jSncMJ+iRBlFPUwRiKEnaexIUud7xwAx4IN2YXt7g90RtW1d
         yeMPWkzTPAPTGfUzZPBJw6nHVQdufuX76RmPqL7s6ynBpm0qVd2dyeLEc+1hI9CLjxNf
         kKlw==
X-Gm-Message-State: AO0yUKU9VPwaoGEqq0f+3lptVwWL6MVXt3wQVNvp5OO8XW/sjV8ig9c9
        XRuUDt6yiFCtWNzwXGsiGSE4uDe4XlE=
X-Google-Smtp-Source: AK7set+aBnKaeDUYBuMdpXcJHAMzYLyR0344kzEnTPzWtTtz5ZAkLBUVQmIKQmhK4GlqYa1qHEHGEvIq+rE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:6983:0:b0:502:349d:a151 with SMTP id
 e125-20020a816983000000b00502349da151mr1612234ywc.295.1675989124804; Thu, 09
 Feb 2023 16:32:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Feb 2023 00:31:35 +0000
In-Reply-To: <20230210003148.2646712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210003148.2646712-9-seanjc@google.com>
Subject: [PATCH v2 08/21] KVM: selftests: Split PMU caps sub-tests to avoid
 writing MSR after KVM_RUN
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
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

Split the PERF_CAPABILITIES subtests into two parts so that the LBR format
testcases don't execute after KVM_RUN.  Now that KVM disallows changing
PERF_CAPABILITIES after KVM_RUN (same as guest CPUID), attempting to set
the MSR after KVM_RUN will yield false positives and/or false negatives
depending on what the test is trying to do.

Land the LBR format test in a more generic "immutable features" test in
anticipation of expanding its scope to other immutable features.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 51 +++++++++++--------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index c280ba1e6572..ac08c0fdd84d 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -41,24 +41,10 @@ static void guest_code(void)
 	wrmsr(MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
 }
 
-int main(int argc, char *argv[])
+static void test_fungible_perf_capabilities(union perf_capabilities host_cap)
 {
-	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
-	int ret;
-	union perf_capabilities host_cap;
-	uint64_t val;
-
-	host_cap.capabilities = kvm_get_feature_msr(MSR_IA32_PERF_CAPABILITIES);
-	host_cap.capabilities &= (PMU_CAP_FW_WRITES | PMU_CAP_LBR_FMT);
-
-	/* Create VM */
-	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
-
-	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
-	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
+	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	/* testcase 1, set capabilities when we have PDCM bit */
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_FW_WRITES);
@@ -70,7 +56,16 @@ int main(int argc, char *argv[])
 	vcpu_run(vcpu);
 	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), PMU_CAP_FW_WRITES);
 
-	/* testcase 2, check valid LBR formats are accepted */
+	kvm_vm_free(vm);
+}
+
+static void test_immutable_perf_capabilities(union perf_capabilities host_cap)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, NULL);
+	uint64_t val;
+	int ret;
+
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, 0);
 	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), 0);
 
@@ -78,8 +73,8 @@ int main(int argc, char *argv[])
 	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), (u64)host_cap.lbr_format);
 
 	/*
-	 * Testcase 3, check that an "invalid" LBR format is rejected.  Only an
-	 * exact match of the host's format (and 0/disabled) is allowed.
+	 * KVM only supports the host's native LBR format, as well as '0' (to
+	 * disable LBR support).  Verify KVM rejects all other LBR formats.
 	 */
 	for (val = 1; val <= PMU_CAP_LBR_FMT; val++) {
 		if (val == (host_cap.capabilities & PMU_CAP_LBR_FMT))
@@ -88,7 +83,23 @@ int main(int argc, char *argv[])
 		ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, val);
 		TEST_ASSERT(!ret, "Bad LBR FMT = 0x%lx didn't fail", val);
 	}
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	union perf_capabilities host_cap;
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
+
+	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
+	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
+
+	host_cap.capabilities = kvm_get_feature_msr(MSR_IA32_PERF_CAPABILITIES);
+	host_cap.capabilities &= (PMU_CAP_FW_WRITES | PMU_CAP_LBR_FMT);
+
+	test_fungible_perf_capabilities(host_cap);
+	test_immutable_perf_capabilities(host_cap);
 
 	printf("Completed perf capability tests.\n");
-	kvm_vm_free(vm);
 }
-- 
2.39.1.581.gbfd45094c4-goog

