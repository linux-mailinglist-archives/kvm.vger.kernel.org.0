Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72C879B09F
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 01:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbjIKUsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236957AbjIKLov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 07:44:51 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A62CEB;
        Mon, 11 Sep 2023 04:44:46 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 41be03b00d2f7-564b6276941so3262546a12.3;
        Mon, 11 Sep 2023 04:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694432686; x=1695037486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9K+qWp9i2t8JmnqA2o3TCG4NeimZP3l5I18+7GSzxlM=;
        b=eSpnEZWF8H1iq/BH0GKLfVKghCUERke2lzVGl3OeSfPtkXCd7S/CcvhFv+zwaiPC+o
         ATHjE316DbNZxkmnY3BbIqYzRkb1gdz+SZe6DiES4wjkXxx9h3CNZS/vA8sfrNsJxoBc
         cCXKGzhtkqOnwPau2Ct6FmpzojuhjOoQk7sMnTskXTreBYn/6dB2YP7lq1CvgtUxdWGd
         0RMNEt0fmGuSHzETi0kHtAGfrTsu3iek7z0eV6YmyABAh423yw7FTwlo34zQ2sZGaYeG
         ivmJi2+Vt3NN06Blnr+2OYS6TF5TJ3k77AgLKvr4+EM49aVUy7041+Rnc/ps7IrqFqxQ
         kVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694432686; x=1695037486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9K+qWp9i2t8JmnqA2o3TCG4NeimZP3l5I18+7GSzxlM=;
        b=sYDZ1n9Bxf4oNxElUi34DLGzdv6djRvTi0RXSmJqNObYuGTwpjOskluQ92+IjfeAs5
         Quwgv6qVB2yXvzsF/z/DsfnEgufbta71sZKTT5jVt92/3WEz6aHBCTVZqiU+7V/OiFKo
         Yiz9S/1Exrs5geao6futfha7nt/sdiyY1WghZepwMrq1c4imqc0RsGkZRY6S4U0pPOWE
         0hz6DOmHfq9kHsWzkHhKZL/yeuSr53q8jminTelPI1UlG2z7mJvi0d6TrYzVl1aMS6/2
         g3COCH5xgaTQPcGYUcrcldPB/9w0Pyq6hlSMJmx5LgtHaLxy1ygfRHR/uefzJE6iIMms
         sVAg==
X-Gm-Message-State: AOJu0YwXJxSlCN5FZD04a/QlJatP1T0AWwS+gkROrtydQEjbz8geXx14
        5VrkXDrR3N9GHDlv8nZ7IAg=
X-Google-Smtp-Source: AGHT+IFimyGbGWkFuw2RSNw+/grqU6kys8DEnEj17GyVG1J8ZDQnQXJ+jKMvuqSjjtxdgLiuZ68v6A==
X-Received: by 2002:a17:90a:bd84:b0:268:1d1e:baaf with SMTP id z4-20020a17090abd8400b002681d1ebaafmr8640465pjr.17.1694432686380;
        Mon, 11 Sep 2023 04:44:46 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090a10c900b00273f65fa424sm3855390pje.8.2023.09.11.04.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 04:44:46 -0700 (PDT)
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
Subject: [PATCH v4 6/9] KVM: selftests: Test consistency of CPUID with num of gp counters
Date:   Mon, 11 Sep 2023 19:43:44 +0800
Message-Id: <20230911114347.85882-7-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230911114347.85882-1-cloudliang@tencent.com>
References: <20230911114347.85882-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

Add test to check if non-existent counters can be accessed in guest after
determining the number of Intel generic performance counters by CPUID.
When the num of counters is less than 3, KVM does not emulate #GP if
a counter isn't present due to compatibility MSR_P6_PERFCTRx handling.
Nor will the KVM emulate more counters than it can support.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index fe9f38a3557e..e636323e202c 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -17,6 +17,11 @@
 /* Guest payload for any performance counter counting */
 #define NUM_BRANCHES		10
 
+static const uint64_t perf_caps[] = {
+	0,
+	PMU_CAP_FW_WRITES,
+};
+
 static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 						  void *guest_code)
 {
@@ -189,6 +194,85 @@ static void test_intel_arch_events(void)
 	}
 }
 
+static void __guest_wrmsr_rdmsr(uint32_t counter_msr, uint8_t nr_msrs,
+				bool expect_gp)
+{
+	uint64_t msr_val;
+	uint8_t vector;
+
+	vector = wrmsr_safe(counter_msr + nr_msrs, 0xffff);
+	__GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,
+		       "Expected GP_VECTOR");
+
+	vector = rdmsr_safe(counter_msr + nr_msrs, &msr_val);
+	__GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,
+		       "Expected GP_VECTOR");
+
+	if (!expect_gp)
+		GUEST_ASSERT_EQ(msr_val, 0);
+
+	GUEST_DONE();
+}
+
+static void guest_rd_wr_gp_counter(void)
+{
+	uint8_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+	uint64_t perf_capabilities = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+	uint32_t counter_msr;
+	bool expect_gp = true;
+
+	if (perf_capabilities & PMU_CAP_FW_WRITES) {
+		counter_msr = MSR_IA32_PMC0;
+	} else {
+		counter_msr = MSR_IA32_PERFCTR0;
+
+		/* KVM drops writes to MSR_P6_PERFCTR[0|1]. */
+		if (nr_gp_counters == 0)
+			expect_gp = false;
+	}
+
+	__guest_wrmsr_rdmsr(counter_msr, nr_gp_counters, expect_gp);
+}
+
+/* Access the first out-of-range counter register to trigger #GP */
+static void test_oob_gp_counter(uint8_t eax_gp_num, uint64_t perf_cap)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_rd_wr_gp_counter);
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_GP_COUNTERS,
+				eax_gp_num);
+	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+static void test_intel_counters_num(void)
+{
+	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+	unsigned int i;
+
+	TEST_REQUIRE(nr_gp_counters > 2);
+
+	for (i = 0; i < ARRAY_SIZE(perf_caps); i++) {
+		/*
+		 * For compatibility reasons, KVM does not emulate #GP
+		 * when MSR_P6_PERFCTR[0|1] is not present, but it doesn't
+		 * affect checking the presence of MSR_IA32_PMCx with #GP.
+		 */
+		test_oob_gp_counter(0, perf_caps[i]);
+		test_oob_gp_counter(2, perf_caps[i]);
+		test_oob_gp_counter(nr_gp_counters, perf_caps[i]);
+
+		/* KVM doesn't emulate more counters than it can support. */
+		test_oob_gp_counter(nr_gp_counters + 1, perf_caps[i]);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
@@ -199,6 +283,7 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
 
 	test_intel_arch_events();
+	test_intel_counters_num();
 
 	return 0;
 }
-- 
2.39.3

