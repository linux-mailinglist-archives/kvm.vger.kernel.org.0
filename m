Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26867716267
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 15:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbjE3Nnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 09:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbjE3Nn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 09:43:29 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB88118;
        Tue, 30 May 2023 06:43:26 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id 98e67ed59e1d1-2564dc37c3eso1934814a91.0;
        Tue, 30 May 2023 06:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685454205; x=1688046205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NVIgrWF0qVdt19S5E5bCe+l7dbI86Yc8ElTcaIuEvg8=;
        b=hRcz3g0XuhIp/cDoSASTSNyPBi2kDZnqsNHEe+M1zA0wGq+vANLEygNnAv/ncF/KNY
         dk5kAHgq6LewxH+R2kxR0GV+ApkunE/FlSC+FJInEi9Z2hqIIluZOI0MznO7MZ6L+csO
         wdrsypZVpPw7rG7niQUARh2wB3SN5kZKklzuSxQyi0CjsFbg4/STm+ss8cyM0Prts7Yf
         Ved6dV1/3qXjTWo9BObxoJsXPFkCM/R/dwosJeaHt4gNoSDO3cckQDgRwknWdxe5JUpn
         5CetnRcbEZrJ7PqnDtd/N0KF9sPFFaSxlyqxhv2+nWCeDnMQbhhkHq7Nyt+5MdN5a1gZ
         6TeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685454205; x=1688046205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NVIgrWF0qVdt19S5E5bCe+l7dbI86Yc8ElTcaIuEvg8=;
        b=RBmYF4rQSU9h2SfurCcDA1nBkLnB08H4lIL3HUq2wcQ6mywM/x8v0pg9KAqylDsDts
         7Bzxyhsn5lHLc0deiGuAzTCL3UWZQudOA0gjG8b0jFyQkOEdfemccKKs3xRPr3DWL8+8
         UTF30AN+IPHii1kMgLrfhTnbRwZofRheTKv52UVoFYMAZqm2CfyF9VruTJz94VsVdGg2
         WJvuXBxVpKhPOGL7UAqdgaEfqdOellnHpFVLr4YYECzd/8D4fFU5JmUAU01oQ7IkQ14v
         eV9MBQKfDiUR6lUp+WCN2w3gpkmbD7c+TPtyUGKTln8rWNlB6zzfG1dEDWhSjqPQMEnd
         oPJA==
X-Gm-Message-State: AC+VfDz/nghVy65WU1yvA2zYYDF4d0yb9opidWbKCc2puYfuANdxYUXV
        Iu9JbxyC5vt2JcLRZu2HLeE=
X-Google-Smtp-Source: ACHHUZ7i0Z64j7byq2AOL9h8KTVoFDnsCvooloRoO7bioFHK/57XVssdVtG6PJeQtV4l7QU9QZn8iA==
X-Received: by 2002:a17:90a:bb89:b0:253:2f1b:612b with SMTP id v9-20020a17090abb8900b002532f1b612bmr2491694pjr.11.1685454205648;
        Tue, 30 May 2023 06:43:25 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090ac24a00b00256a4d59bfasm1977186pjx.23.2023.05.30.06.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 06:43:25 -0700 (PDT)
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
Subject: [PATCH v2 5/8] KVM: selftests: Test consistency of CPUID with num of gp counters
Date:   Tue, 30 May 2023 21:42:45 +0800
Message-Id: <20230530134248.23998-6-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530134248.23998-1-cloudliang@tencent.com>
References: <20230530134248.23998-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Add test to check if non-existent counters can be accessed in guest after
determining the number of Intel generic performance counters by CPUID.
When the num of counters is less than 3, KVM does not emulate #GP if
a counter isn't present due to compatibility MSR_P6_PERFCTRx handling.
Nor will the KVM emulate more counters than it can support.

Co-developed-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 .../kvm/x86_64/pmu_basic_functionality_test.c | 88 +++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
index 81029d05367a..116437ac2095 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
@@ -16,6 +16,17 @@
 /* Guest payload for any performance counter counting */
 #define NUM_BRANCHES 10
 
+/*
+ * KVM implements the first two non-existent counters (MSR_P6_PERFCTRx)
+ * via kvm_pr_unimpl_wrmsr() instead of #GP.
+ */
+#define MSR_INTEL_ARCH_PMU_GPCTR (MSR_IA32_PERFCTR0 + 2)
+
+static const uint64_t perf_caps[] = {
+	0,
+	PMU_CAP_FW_WRITES,
+};
+
 static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 						  void *guest_code)
 {
@@ -169,9 +180,86 @@ static void intel_test_arch_events(void)
 	}
 }
 
+static void guest_wr_and_rd_msrs(uint32_t base, uint64_t value,
+				 uint8_t begin, uint8_t offset)
+{
+	unsigned int i;
+	uint8_t wr_vector, rd_vector;
+	uint64_t msr_val;
+
+	for (i = begin; i < begin + offset; i++) {
+		wr_vector = wrmsr_safe(base + i, value);
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
+				uint64_t perf_cap, uint64_t exported)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct kvm_cpuid_entry2 *entry;
+	uint32_t ctr_msr = MSR_IA32_PERFCTR0;
+	uint64_t msr_val;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_wr_and_rd_msrs);
+
+	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
+	entry->eax = (entry->eax & ~GP_CTR_NUM_MASK) |
+		(eax_gp_num << GP_CTR_NUM_OFS_BIT);
+	vcpu_set_cpuid(vcpu);
+
+	if (perf_cap & PMU_CAP_FW_WRITES)
+		ctr_msr = MSR_IA32_PMC0;
+
+	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, perf_cap);
+	vcpu_args_set(vcpu, 4, ctr_msr, 0xffff, eax_gp_num, offset);
+	while (run_vcpu(vcpu, &msr_val) != UCALL_DONE)
+		TEST_ASSERT(msr_val == exported,
+			    "Unexpected when testing gp counter num.");
+
+	kvm_vm_free(vm);
+}
+
+static void intel_test_counters_num(void)
+{
+	unsigned int i;
+	uint8_t kvm_gp_num = X86_INTEL_MAX_GP_CTR_NUM;
+
+	TEST_REQUIRE(kvm_gp_num > 2);
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
+		test_oob_gp_counter(kvm_gp_num, 1, perf_caps[i], GP_VECTOR);
+
+		/* KVM doesn't emulate more counters than it can support. */
+		test_oob_gp_counter(kvm_gp_num + 1, 1, perf_caps[i], GP_VECTOR);
+
+		/* Test that KVM drops writes to MSR_P6_PERFCTR[0|1]. */
+		if (perf_caps[i] == 0)
+			test_oob_gp_counter(0, 2, perf_caps[i], 0);
+	}
+}
+
 static void intel_test_pmu_cpuid(void)
 {
 	intel_test_arch_events();
+	intel_test_counters_num();
 }
 
 int main(int argc, char *argv[])
-- 
2.31.1

