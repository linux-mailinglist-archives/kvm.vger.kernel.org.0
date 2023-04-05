Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB0E6D71A7
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 02:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236735AbjDEApt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 20:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236730AbjDEApo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 20:45:44 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AB7469A
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 17:45:33 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id kp6-20020a170903280600b001a2945a7fdeso9224497plb.18
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 17:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680655533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iP4zSUAb/NsRt+s845gBr40fiLxdAbGQ8k72w+L3KVU=;
        b=mSg4XJa9URBJtOYdn6q0rE6QKLeOz5/E5d9ocqZ/qdi+Pd0RtRdL2ubTzMXMPjtcVV
         8g3rnux3TaudOHJGf5B+9KRf+6LHGfe1tpDwOQ99LrTeQAQuQ9o2o+3Aknds7wjEFOpJ
         2vI+lsLOr4Pcp1pGwartbgqTjJlrWZtHQFlDd77RLTgEB/kOqecF65FvDMoGn7udrblA
         ZnOvnxFaE83H+5wINSRJN9AA7ndGL3SL3lRnc/T/sr4KyTNYKrJNJVKt9uztJRL+4QVq
         3J4KP8Bc+NrFeVFRHrPclVM1YXAR5m0rg6bRtNlBUnI9ZHZKVUPeQBAZXoF5OLksTfkC
         IhmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680655533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iP4zSUAb/NsRt+s845gBr40fiLxdAbGQ8k72w+L3KVU=;
        b=K3v8S3suem6C/+fKXG5qMlZjWi1KnCgai997qLElLQRwLW+7HTZ7/nUSZ/vMZshiVt
         1gm/fbwqYj1ZMaRCqeI2F9ZB9JlMUENyS87O4fS+E9HW2LyFrdtZ0XTLr3ELyTDWgugi
         Sdq0maA2wLZvfPiyxL8jMBSo2L/ng/Qudehh1FyusBxhVWzUXPID+QR9lTCAFl93WMix
         TWqq0LDL6DePdNLGQpLlpgv5ntaApqZGHI4lVJSq5D6AOIasGX9KuFJuXXmdYhnZy+4T
         7N7+rD/kTFnS/jhmOPCQMC8zxvp1DdMiV0UtF5N8DXHdfN/pVp2OwYFipXhocebKBdCx
         QOcw==
X-Gm-Message-State: AAQBX9ewIXbZvpfuZm0H3zvDUakjxr384jLqe+TOAHOHFEWMyuf5Mlwl
        xxgLbO3QoEq8v/jv6WEbMsfRQvENehg=
X-Google-Smtp-Source: AKy350YXhm0xA+3ua/0QfznnDbOB+zBEBiVrN4FEKJKatYjny0JNnjDBNUrwse/CWlrwGOpinTETWSBN7gU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:150c:0:b0:514:26cf:9c05 with SMTP id
 v12-20020a63150c000000b0051426cf9c05mr739577pgl.7.1680655533462; Tue, 04 Apr
 2023 17:45:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 17:45:20 -0700
In-Reply-To: <20230405004520.421768-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405004520.421768-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405004520.421768-7-seanjc@google.com>
Subject: [PATCH v4 6/6] KVM: selftests: Add test to verify KVM's supported XCR0
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

Check both architectural rules and KVM's ABI for KVM_GET_SUPPORTED_CPUID
to ensure the supported xfeatures[1] don't violate any of them.

The architectural rules[2] and KVM's contract with userspace ensure for a
given feature, e.g. sse, avx, amx, etc... their associated xfeatures are
either all sets or none of them are set, and any dependencies are enabled
if needed.

[1] EDX:EAX of CPUID.(EAX=0DH,ECX=0)
[2] SDM vol 1, 13.3 ENABLING THE XSAVE FEATURE SET AND XSAVE-ENABLED
    FEATURES

Cc: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
[sean: expand comments, use a fancy X86_PROPERTY]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |  20 +++
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 132 ++++++++++++++++++
 3 files changed, 153 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 84a627c43795..18cadc669798 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -105,6 +105,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
 TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
 TEST_GEN_PROGS_x86_64 += x86_64/xapic_state_test
+TEST_GEN_PROGS_x86_64 += x86_64/xcr0_cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
 TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 187309f3e7e9..70c5469e4023 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -241,8 +241,11 @@ struct kvm_x86_cpu_property {
 #define X86_PROPERTY_PMU_NR_GP_COUNTERS		KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 8, 15)
 #define X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH	KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 24, 31)
 
+#define X86_PROPERTY_SUPPORTED_XCR0_LO		KVM_X86_CPU_PROPERTY(0xd,  0, EAX,  0, 31)
 #define X86_PROPERTY_XSTATE_MAX_SIZE_XCR0	KVM_X86_CPU_PROPERTY(0xd,  0, EBX,  0, 31)
 #define X86_PROPERTY_XSTATE_MAX_SIZE		KVM_X86_CPU_PROPERTY(0xd,  0, ECX,  0, 31)
+#define X86_PROPERTY_SUPPORTED_XCR0_HI		KVM_X86_CPU_PROPERTY(0xd,  0, EDX,  0, 31)
+
 #define X86_PROPERTY_XSTATE_TILE_SIZE		KVM_X86_CPU_PROPERTY(0xd, 18, EAX,  0, 31)
 #define X86_PROPERTY_XSTATE_TILE_OFFSET		KVM_X86_CPU_PROPERTY(0xd, 18, EBX,  0, 31)
 #define X86_PROPERTY_AMX_MAX_PALETTE_TABLES	KVM_X86_CPU_PROPERTY(0x1d, 0, EAX,  0, 31)
@@ -681,6 +684,15 @@ static inline bool this_pmu_has(struct kvm_x86_pmu_feature feature)
 	       !this_cpu_has(feature.anti_feature);
 }
 
+static __always_inline uint64_t this_cpu_supported_xcr0(void)
+{
+	if (!this_cpu_has_p(X86_PROPERTY_SUPPORTED_XCR0_LO))
+		return 0;
+
+	return this_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_LO) |
+	       ((uint64_t)this_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_HI) << 32);
+}
+
 typedef u32		__attribute__((vector_size(16))) sse128_t;
 #define __sse128_u	union { sse128_t vec; u64 as_u64[2]; u32 as_u32[4]; }
 #define sse128_lo(x)	({ __sse128_u t; t.vec = x; t.as_u64[0]; })
@@ -1104,6 +1116,14 @@ static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
 	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
 }
 
+static inline uint8_t xsetbv_safe(uint32_t index, uint64_t value)
+{
+	u32 eax = value;
+	u32 edx = value >> 32;
+
+	return kvm_asm_safe("xsetbv", "a" (eax), "d" (edx), "c" (index));
+}
+
 bool kvm_is_tdp_enabled(void);
 
 uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
new file mode 100644
index 000000000000..905bd5ae4431
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
@@ -0,0 +1,132 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * XCR0 cpuid test
+ *
+ * Copyright (C) 2022, Google LLC.
+ */
+
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "processor.h"
+
+/*
+ * Assert that architectural dependency rules are satisfied, e.g. that AVX is
+ * supported if and only if SSE is supported.
+ */
+#define ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0, xfeatures, dependencies)	  \
+do {										  \
+	uint64_t __supported = (supported_xcr0) & ((xfeatures) | (dependencies)); \
+										  \
+	GUEST_ASSERT_3((__supported & (xfeatures)) != (xfeatures) ||		  \
+		       __supported == ((xfeatures) | (dependencies)),		  \
+		       __supported, (xfeatures), (dependencies));		  \
+} while (0)
+
+/*
+ * Assert that KVM reports a sane, usable as-is XCR0.  Architecturally, a CPU
+ * isn't strictly required to _support_ all XFeatures related to a feature, but
+ * at the same time XSETBV will #GP if bundled XFeatures aren't enabled and
+ * disabled coherently.  E.g. a CPU can technically enumerate supported for
+ * XTILE_CFG but not XTILE_DATA, but attempting to enable XTILE_CFG without
+ * XTILE_DATA will #GP.
+ */
+#define ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0, xfeatures)		\
+do {									\
+	uint64_t __supported = (supported_xcr0) & (xfeatures);		\
+									\
+	GUEST_ASSERT_2(!__supported || __supported == (xfeatures),	\
+		       __supported, (xfeatures));			\
+} while (0)
+
+static void guest_code(void)
+{
+	uint64_t xcr0_reset;
+	uint64_t supported_xcr0;
+	int i, vector;
+
+	set_cr4(get_cr4() | X86_CR4_OSXSAVE);
+
+	xcr0_reset = xgetbv(0);
+	supported_xcr0 = this_cpu_supported_xcr0();
+
+	GUEST_ASSERT(xcr0_reset == XFEATURE_MASK_FP);
+
+	/* Check AVX */
+	ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0,
+				     XFEATURE_MASK_YMM,
+				     XFEATURE_MASK_SSE);
+
+	/* Check MPX */
+	ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0,
+				    XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
+
+	/* Check AVX-512 */
+	ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0,
+				     XFEATURE_MASK_AVX512,
+				     XFEATURE_MASK_SSE | XFEATURE_MASK_YMM);
+	ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0,
+				    XFEATURE_MASK_AVX512);
+
+	/* Check AMX */
+	ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0,
+				    XFEATURE_MASK_XTILE);
+
+	vector = xsetbv_safe(0, supported_xcr0);
+	GUEST_ASSERT_2(!vector, supported_xcr0, vector);
+
+	for (i = 0; i < 64; i++) {
+		if (supported_xcr0 & BIT_ULL(i))
+			continue;
+
+		vector = xsetbv_safe(0, supported_xcr0 | BIT_ULL(i));
+		GUEST_ASSERT_3(vector == GP_VECTOR, supported_xcr0, vector, BIT_ULL(i));
+	}
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVE));
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	while (1) {
+		vcpu_run(vcpu);
+
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Unexpected exit reason: %u (%s),\n",
+			    run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT_3(uc, "0x%lx 0x%lx 0x%lx");
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.40.0.348.gf938b09366-goog

