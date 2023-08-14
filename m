Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC8777B7D1
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 13:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjHNLwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 07:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjHNLvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 07:51:42 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B13EA;
        Mon, 14 Aug 2023 04:51:41 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d2e1a72fcca58-68842ebdcf7so174169b3a.0;
        Mon, 14 Aug 2023 04:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692013901; x=1692618701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61GfPmVPqdJQe4FEL90WRoo6PIXr9V7sVFEuh/ye+sc=;
        b=B7hUH7NJhTrBM477jFwBthlaB/D7bYwffvUYtQI3xqNIlGwtkH/pyT95qNZq0t4bYz
         DbSKjk8lt+QNdG99hQXLG9xHptdi1Amxx14vHOB0GZnVEncCgXoG99a17ZNLkzYJtovv
         S0wRgW7bCjvkdmKHHB+TGAKU2TgVi7rJCDuyFysPkCSQfA9/q4K0Gr8RYCUujXEJa5uC
         dJKIEv7eem2kRt/vvk+u4M90xyyxi+2FMD+7f0qO8d8aEac7+SeC8oDyC6ggRYOsyJ9r
         YgznWQvRUTh7FKcVafARVVlRlivGjyAkOqheGe/47Aq45yg3Dk+R8emC5XNYzdit5qkk
         lftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692013901; x=1692618701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61GfPmVPqdJQe4FEL90WRoo6PIXr9V7sVFEuh/ye+sc=;
        b=coNgWgmtwqH+WGYX+uwYPaPGj9nQnygnOoQPNrhS2TpuOvhIHNJZeLrIB9uUaaigrC
         d3oc+s0hyaBoslgvzXjaWUAAtVcJudbP3tCD1NpdRBejzy2xA632f2nDOTe58Ls8p7V0
         s7qXIyU8DFzZwoBkirolDxev3aP9yYQ38zyTWHW6BilxQDSPgBH9Q0IMmGnvP1tenTUU
         XU/yac959u+FrkHCyNE9oLhPS3fL70PxPzf7DYFJ40BYA6jZTaUrWCFc7mzF1v3yA7Lr
         cCKiIW61QWEPIV7EPeMQ4Io2HKiWPWnVM8WrsQ/WTUcO7EkxNDMFhVFrEuCwaS7oGFw1
         PjdA==
X-Gm-Message-State: AOJu0Yz2Fr6QQG4xkTiAr5t3uMY08JCSAa/o+Kyha8Do4ykwWctZ994g
        tHl0q36qxd/WkWXD739QYAo=
X-Google-Smtp-Source: AGHT+IHDMfCfk7rZyRXz+fCSGjAI06UJi8gP/yvncrO8BtZ+NL92ix98Bs7Nw43gYCH00+qyB3SgYQ==
X-Received: by 2002:a05:6a20:4325:b0:13f:cd07:2b60 with SMTP id h37-20020a056a20432500b0013fcd072b60mr14322356pzk.1.1692013900876;
        Mon, 14 Aug 2023 04:51:40 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x7-20020a63b207000000b0055386b1415dsm8407848pge.51.2023.08.14.04.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 04:51:40 -0700 (PDT)
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
Subject: [PATCH v3 06/11] KVM: selftests: Test consistency of CPUID with num of fixed counters
Date:   Mon, 14 Aug 2023 19:51:03 +0800
Message-Id: <20230814115108.45741-7-cloudliang@tencent.com>
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
Per SDM, fixed-function performance counter 'i' is supported if ECX[i] ||
(EDX[4:0] > i). KVM doesn't emulate more counters than it can support.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../kvm/x86_64/pmu_basic_functionality_test.c | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
index b86033e51d5c..db1c1230700a 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
@@ -212,10 +212,43 @@ static void test_oob_gp_counter(uint8_t eax_gp_num, uint8_t offset,
 	kvm_vm_free(vm);
 }
 
+static void intel_test_oob_fixed_ctr(uint8_t edx_fixed_num,
+				     uint32_t fixed_bitmask, uint64_t expected)
+{
+	uint8_t idx = edx_fixed_num;
+	struct kvm_vcpu *vcpu;
+	uint64_t msr_val = 0;
+	struct kvm_vm *vm;
+	bool visible;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_wr_and_rd_msrs);
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK,
+				fixed_bitmask);
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_FIXED_COUNTERS,
+				edx_fixed_num);
+
+	visible = fixed_counter_is_supported(vcpu, idx);
+
+	/* KVM doesn't emulate more fixed counters than it can support. */
+	if (idx >= kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS))
+		visible = false;
+
+	vcpu_args_set(vcpu, 3, MSR_CORE_PERF_FIXED_CTR0, idx, 1);
+	if (visible) {
+		while (run_vcpu(vcpu, &msr_val) != UCALL_DONE)
+			TEST_ASSERT_EQ(expected, msr_val);
+	}
+
+	kvm_vm_free(vm);
+}
+
 static void intel_test_counters_num(void)
 {
+	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
 	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	unsigned int i;
+	uint32_t ecx;
 
 	TEST_REQUIRE(nr_gp_counters > 2);
 
@@ -239,6 +272,14 @@ static void intel_test_counters_num(void)
 		if (!perf_caps[i])
 			test_oob_gp_counter(0, 2, perf_caps[i], 0);
 	}
+
+	for (ecx = 0;
+	     ecx <= kvm_cpu_property(X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK) + 1;
+	     ecx++) {
+		intel_test_oob_fixed_ctr(0, ecx, GP_VECTOR);
+		intel_test_oob_fixed_ctr(nr_fixed_counters, ecx, GP_VECTOR);
+		intel_test_oob_fixed_ctr(nr_fixed_counters + 1, ecx, GP_VECTOR);
+	}
 }
 
 int main(int argc, char *argv[])
-- 
2.39.3

