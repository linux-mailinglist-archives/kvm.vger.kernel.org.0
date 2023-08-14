Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92F977B7D5
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 13:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjHNLwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 07:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjHNLvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 07:51:48 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61119EA;
        Mon, 14 Aug 2023 04:51:47 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d2e1a72fcca58-68783b2e40bso2897484b3a.3;
        Mon, 14 Aug 2023 04:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692013907; x=1692618707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6QSg0DwA3NF38TCmKZOiHhuUw3mZXP23ciDh8DZpCwk=;
        b=dgcTCnjiK9l2MrqLnJReCG6zW9hUewSOsmYzj85gLMoYCtmsAcZB3TF+IoqKOWkgIP
         KKSOXj1TK3a+6t98a7loh0YwmQXNi3SDtufQ1rUo+b0tKKgK981JQ6E2ErGj9nUoSmtj
         7UOKETFgWcUUeoknLbA37k5JLuLrf7x9BBOyLO0tFfvNkduEUxcJRDym2OIztUkzAKDb
         HOCL9noAXeaQrcRadCdxfj7RiXaFk7339g7a4Kj9bNZedwTghItbJYN4CYVThRqSrBxu
         mJohcmGFdof4LZ/HVTECoZFfIXTPofGSabl0ComnKzmMslxc332rkCxpxDy5CJiythn7
         VO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692013907; x=1692618707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6QSg0DwA3NF38TCmKZOiHhuUw3mZXP23ciDh8DZpCwk=;
        b=kU5Zig8iGuGOXwWbaJqlgGlXryyCCxA/ghMPdoZoCMry94zazGvHsci+afID7PU3W1
         cdfoWDeK2arYn0tQTPY9W1Bkr8+RVem+0CfUdOujMUeGK9IUxvEZ4oGQr8bKXWj6n70L
         KbOjU9mbpEdiTUMwMcfJUYhP/dTE5uqB6SWl16F/DQKdvKcWgc70lFqf7BB9PT7Ux3Cx
         H2JhpJv+7dVgL11L8BEpjMUeONIovtZgpws8ifPtN1PkJMl45N/X5J5SVNoWh8E+GWKk
         sj7C+1vMZdL7VIhIG67MUh8IIPwGQh+UJnrF7l65QiMI9PLCaaUUcAWsSuGxa7Pwwr3C
         RWWg==
X-Gm-Message-State: AOJu0Yx/k5h0b+j99pw0MwC0L4j56Df5igQ8rg77ulXSWGpOufiOaGA7
        nppLIKdY4VVYTeU44mTrM0c=
X-Google-Smtp-Source: AGHT+IGXjiyPa/JAUvgPxAzmjGukAxQUa0qpeqQw6b2n4Y+XXkQWSvPXmRBa1zSO9uprefFKkFl5gg==
X-Received: by 2002:a05:6a21:6d88:b0:12f:90d8:9755 with SMTP id wl8-20020a056a216d8800b0012f90d89755mr10550114pzb.15.1692013906801;
        Mon, 14 Aug 2023 04:51:46 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x7-20020a63b207000000b0055386b1415dsm8407848pge.51.2023.08.14.04.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 04:51:46 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/11] KVM: selftests: Test consistency of PMU MSRs with Intel PMU version
Date:   Mon, 14 Aug 2023 19:51:05 +0800
Message-Id: <20230814115108.45741-9-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814115108.45741-1-cloudliang@tencent.com>
References: <20230814115108.45741-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

KVM user sapce may control the Intel guest PMU version number via
CPUID.0AH:EAX[07:00]. A test is added to check if a typical PMU register
that is not available at the current version number is leaking.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../kvm/x86_64/pmu_basic_functionality_test.c | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
index 3bbf3bd2846b..70adfad45010 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
@@ -16,6 +16,12 @@
 /* Guest payload for any performance counter counting */
 #define NUM_BRANCHES			10
 
+/*
+ * KVM implements the first two non-existent counters (MSR_P6_PERFCTRx)
+ * via kvm_pr_unimpl_wrmsr() instead of #GP.
+ */
+#define MSR_INTEL_ARCH_PMU_GPCTR (MSR_IA32_PERFCTR0 + 2)
+
 static const uint64_t perf_caps[] = {
 	0,
 	PMU_CAP_FW_WRITES,
@@ -341,6 +347,66 @@ static void intel_test_fixed_counters(void)
 	}
 }
 
+static void intel_guest_check_pmu_version(uint8_t version)
+{
+	switch (version) {
+	case 0:
+		GUEST_SYNC(wrmsr_safe(MSR_INTEL_ARCH_PMU_GPCTR, 0xffffull));
+	case 1:
+		GUEST_SYNC(wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, 0x1ull));
+	case 2:
+		/*
+		 * AnyThread Bit is only supported in version 3
+		 *
+		 * The strange thing is that when version=0, writing ANY-Any
+		 * Thread bit (bit 21) in MSR_P6_EVNTSEL0 and MSR_P6_EVNTSEL1
+		 * will not generate #GP. While writing ANY-Any Thread bit
+		 * (bit 21) in MSR_P6_EVNTSEL0+x (MAX_GP_CTR_NUM > x > 2) to
+		 * ANY-Any Thread bit (bit 21) will generate #GP.
+		 */
+		if (version == 0)
+			break;
+
+		GUEST_SYNC(wrmsr_safe(MSR_P6_EVNTSEL0,
+				      ARCH_PERFMON_EVENTSEL_ANY));
+		break;
+	default:
+		/* KVM currently supports up to pmu version 2 */
+		GUEST_SYNC(GP_VECTOR);
+	}
+
+	GUEST_DONE();
+}
+
+static void test_pmu_version_setup(struct kvm_vcpu *vcpu, uint8_t version,
+				   uint64_t expected)
+{
+	uint64_t msr_val = 0;
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_VERSION, version);
+
+	vcpu_args_set(vcpu, 1, version);
+	while (run_vcpu(vcpu, &msr_val) != UCALL_DONE)
+		TEST_ASSERT_EQ(expected, msr_val);
+}
+
+static void intel_test_pmu_version(void)
+{
+	uint8_t unsupported_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION) + 1;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint8_t version;
+
+	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS) > 2);
+
+	for (version = 0; version <= unsupported_version; version++) {
+		vm = pmu_vm_create_with_one_vcpu(&vcpu,
+						 intel_guest_check_pmu_version);
+		test_pmu_version_setup(vcpu, version, GP_VECTOR);
+		kvm_vm_free(vm);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
@@ -353,6 +419,7 @@ int main(int argc, char *argv[])
 	intel_test_arch_events();
 	intel_test_counters_num();
 	intel_test_fixed_counters();
+	intel_test_pmu_version();
 
 	return 0;
 }
-- 
2.39.3

