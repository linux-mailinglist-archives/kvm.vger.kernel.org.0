Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E175677B7CF
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 13:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjHNLwH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 07:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjHNLvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 07:51:39 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA76EA;
        Mon, 14 Aug 2023 04:51:38 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d2e1a72fcca58-688142a392eso3041255b3a.3;
        Mon, 14 Aug 2023 04:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692013898; x=1692618698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Xx2H5qBp82cfooizXIXNIdk1Jryabv6Gra/eZNCPNc=;
        b=A6z0GNwCAKQ8ICz3mVzFFHUNd5hf45mUeTrH5+RSnNd7P87XEeVtTuWUzZUYZyemyh
         nTI3tTlrnY7v8DC5FvPSEqtGJ/XjrXozyAa/Ow4hjIikY4QYhhYk0w9d4DIDZ7mtpGBx
         Rptb5+y7Xv4TdeV96HkpKFbe0dBgInZCuhMzBU5olzB7WwZiST4LVqQHZ6QBZBH10mpw
         4rElbPs57tLAcNfIhq0dh1ELRc7nK8Tp4oPvIVFJGwZq6Q0q+umZo0uq3CACGuzkijPt
         PiXrhZ/lDTmDhj6a6UHbUARSxdjjXlvjfg6+F3py00ceGFyrClcs1ysxBZzcbp4vtFvZ
         CNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692013898; x=1692618698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Xx2H5qBp82cfooizXIXNIdk1Jryabv6Gra/eZNCPNc=;
        b=UeUvdglvpXnl/67zJr2f3WVtUmecAogUXnAAG+emWVNYCzWhWqbG74DxTfcNcdnuQn
         4ADSOPFLyfhMv+jIwnc7c8qg4WzKL+AZZzJ31l0PArp1zG8m34QHrLMNC+Z9v3XjG5hy
         o575NgOC3/pdLP8r328pcTM4ciN0RZjH2gAzzcgDHsyDA/sI+R/Y7Mr0HHgbUGPmC8PC
         yctXH+LXpyrfkuChJsd484T7lAJjDyHDGHL8jtuYP7dHaeYwG36DLazLgJJXvAe83a2L
         +5gPcxiEgYbcLjGKnk/0Gq5TXLl84Ql+TyUmyy5KqRGKPP+iN3jRW/Ol1GeuWTXI6BwF
         rpgg==
X-Gm-Message-State: AOJu0YxnGX1SUrCGY740z46lPFqEe4fJ7xGXmwmQqP5xFD3ykENNHFD+
        BfVS4zL75igHoyR+B6+65HY=
X-Google-Smtp-Source: AGHT+IEfFoMyU6qaasErQKedZB88qGgbQQBRBK/uofyA1ut8RAouMhrkGIOYVsDOExlL9zHjHB2Viw==
X-Received: by 2002:a05:6a20:dd85:b0:13d:c86b:d76d with SMTP id kw5-20020a056a20dd8500b0013dc86bd76dmr9054156pzb.60.1692013897944;
        Mon, 14 Aug 2023 04:51:37 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x7-20020a63b207000000b0055386b1415dsm8407848pge.51.2023.08.14.04.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 04:51:37 -0700 (PDT)
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
Subject: [PATCH v3 05/11] KVM: selftests: Test consistency of CPUID with num of gp counters
Date:   Mon, 14 Aug 2023 19:51:02 +0800
Message-Id: <20230814115108.45741-6-cloudliang@tencent.com>
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

Add test to check if non-existent counters can be accessed in guest after
determining the number of Intel generic performance counters by CPUID.
When the num of counters is less than 3, KVM does not emulate #GP if
a counter isn't present due to compatibility MSR_P6_PERFCTRx handling.
Nor will the KVM emulate more counters than it can support.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../kvm/x86_64/pmu_basic_functionality_test.c | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
index daa45aa285bb..b86033e51d5c 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
@@ -16,6 +16,11 @@
 /* Guest payload for any performance counter counting */
 #define NUM_BRANCHES			10
 
+static const uint64_t perf_caps[] = {
+	0,
+	PMU_CAP_FW_WRITES,
+};
+
 static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 						  void *guest_code)
 {
@@ -164,6 +169,78 @@ static void intel_test_arch_events(void)
 	}
 }
 
+static void guest_wr_and_rd_msrs(uint32_t base, uint8_t begin, uint8_t offset)
+{
+	uint8_t wr_vector, rd_vector;
+	uint64_t msr_val;
+	unsigned int i;
+
+	for (i = begin; i < begin + offset; i++) {
+		wr_vector = wrmsr_safe(base + i, 0xffff);
+		rd_vector = rdmsr_safe(base + i, &msr_val);
+		if (wr_vector == GP_VECTOR || rd_vector == GP_VECTOR)
+			GUEST_SYNC(GP_VECTOR);
+		else
+			GUEST_SYNC(msr_val);
+	}
+
+	GUEST_DONE();
+}
+
+/* Access the first out-of-range counter register to trigger #GP */
+static void test_oob_gp_counter(uint8_t eax_gp_num, uint8_t offset,
+				uint64_t perf_cap, uint64_t expected)
+{
+	uint32_t ctr_msr = MSR_IA32_PERFCTR0;
+	struct kvm_vcpu *vcpu;
+	uint64_t msr_val = 0;
+	struct kvm_vm *vm;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_wr_and_rd_msrs);
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_GP_COUNTERS,
+				eax_gp_num);
+
+	if (perf_cap & PMU_CAP_FW_WRITES)
+		ctr_msr = MSR_IA32_PMC0;
+
+	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, perf_cap);
+	vcpu_args_set(vcpu, 3, ctr_msr, eax_gp_num, offset);
+	while (run_vcpu(vcpu, &msr_val) != UCALL_DONE)
+		TEST_ASSERT_EQ(expected, msr_val);
+
+	kvm_vm_free(vm);
+}
+
+static void intel_test_counters_num(void)
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
+		if (perf_caps[i] & PMU_CAP_FW_WRITES)
+			test_oob_gp_counter(0, 1, perf_caps[i], GP_VECTOR);
+
+		test_oob_gp_counter(2, 1, perf_caps[i], GP_VECTOR);
+		test_oob_gp_counter(nr_gp_counters, 1, perf_caps[i], GP_VECTOR);
+
+		/* KVM doesn't emulate more counters than it can support. */
+		test_oob_gp_counter(nr_gp_counters + 1, 1, perf_caps[i],
+				    GP_VECTOR);
+
+		/* Test that KVM drops writes to MSR_P6_PERFCTR[0|1]. */
+		if (!perf_caps[i])
+			test_oob_gp_counter(0, 2, perf_caps[i], 0);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
@@ -174,6 +251,7 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
 
 	intel_test_arch_events();
+	intel_test_counters_num();
 
 	return 0;
 }
-- 
2.39.3

