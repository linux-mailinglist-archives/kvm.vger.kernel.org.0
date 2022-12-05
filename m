Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F976431B9
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiLETPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiLETO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:14:56 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8139E24F1C
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 11:14:48 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id m2-20020a17090a730200b0021020cce6adso17328268pjk.3
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 11:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K57oVOTIJXpguseziCpg/vQQxs6UXuw9AbSA2owsfi8=;
        b=HtNBFcKG2iy4lFtJgcQ2xtObzlJMApX2s5CCj602Z3YNcQZiiu4DinXAshfTLmpGL3
         yHwshknSCXvZA0MQjNAiuo2bOAn98fxg6mB1VPK7dqmIdlddw3Ajd5dYS/aXv9Emc27+
         2a27HuRsuArPQFL2LSU4Yhx2fw0vpwq0ncdumR/5cK4AqweQZ5i5KeG/peP2HSVqx09X
         u13F8680UwOBRQUDi2qWJoPx3Yo9pNYS5+zgScJauFsqeSJYIrCo3DA7Hqn4ZZF6xEM4
         KisoYUqZn+gXdB0IK2wtcE8ygz5SGy6M0Ant3QOdBaXxjx/DZQFA7W9m1uHje5ynkZKB
         B4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K57oVOTIJXpguseziCpg/vQQxs6UXuw9AbSA2owsfi8=;
        b=JyBsCaIWuA5FAUQt6SS6MS3aPEXflmzDFd1e6rjA4KOUFTE3mnlOMaBWn59WkDFYDP
         hVQemQ5c4W8pvI35E5J4vuoISe/dsE0vClWYgBxS8eWy8W4IsFr4YcqICHWYcIUvIemV
         4f+jlgqvM5Xt/frtC3+/NVafrTwtH6aT6y398ielyiKr8rljUSkMTiWgiI8M8/ACAS3K
         cyC/fiHL+jKTE/PsA53tzgTjwwqoyZZCDzk0CN7qdMOWrkbzmehjjpDd2/8uHM7uUkbE
         /CXdGnvoUBCup5s240pczt/njK8Xa9UEc39cTWxhlZhEwVRD2bH+z32QUdQd9tzzVGCt
         054Q==
X-Gm-Message-State: ANoB5pkLGIba9IvfG5jTkN0NDZBBqG3VH7RozQgTvmJTJ61t0eR25b1r
        3p32inZtM7mNizCksvvGDu+vFmZzmYGr
X-Google-Smtp-Source: AA0mqf7FV/ENQoUyINCmRHjVXNLyUgxjB3/KCvGBVqyeh1JKSVBqx3rnmDXbuGwxWkKaQz3VUz/rlt3Ks4rL
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:77cc:b0:219:1747:f19c with SMTP id
 e12-20020a17090a77cc00b002191747f19cmr48553663pjs.222.1670267688064; Mon, 05
 Dec 2022 11:14:48 -0800 (PST)
Date:   Mon,  5 Dec 2022 11:14:22 -0800
In-Reply-To: <20221205191430.2455108-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221205191430.2455108-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221205191430.2455108-6-vipinsh@google.com>
Subject: [Patch v3 05/13] KVM: selftests: Convert hyperv_features test to
 using KVM_X86_CPU_FEATURE()
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

hyperv_features test needs to set certain CPUID bits in Hyper-V feature
leaves but instead of open coding this, common KVM_X86_CPU_FEATURE()
infrastructure can be used.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/hyperv.h     | 141 ++++++++++++------
 .../selftests/kvm/x86_64/hyperv_features.c    |  67 ++++-----
 2 files changed, 127 insertions(+), 81 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index 9218bb5f44bf..ab455c4efc66 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -85,61 +85,108 @@
 #define HV_X64_MSR_SYNDBG_OPTIONS		0x400000FF
 
 /* HYPERV_CPUID_FEATURES.EAX */
-#define HV_MSR_VP_RUNTIME_AVAILABLE		BIT(0)
-#define HV_MSR_TIME_REF_COUNT_AVAILABLE		BIT(1)
-#define HV_MSR_SYNIC_AVAILABLE			BIT(2)
-#define HV_MSR_SYNTIMER_AVAILABLE		BIT(3)
-#define HV_MSR_APIC_ACCESS_AVAILABLE		BIT(4)
-#define HV_MSR_HYPERCALL_AVAILABLE		BIT(5)
-#define HV_MSR_VP_INDEX_AVAILABLE		BIT(6)
-#define HV_MSR_RESET_AVAILABLE			BIT(7)
-#define HV_MSR_STAT_PAGES_AVAILABLE		BIT(8)
-#define HV_MSR_REFERENCE_TSC_AVAILABLE		BIT(9)
-#define HV_MSR_GUEST_IDLE_AVAILABLE		BIT(10)
-#define HV_ACCESS_FREQUENCY_MSRS		BIT(11)
-#define HV_ACCESS_REENLIGHTENMENT		BIT(13)
-#define HV_ACCESS_TSC_INVARIANT			BIT(15)
+#define HV_MSR_VP_RUNTIME_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 0)
+#define HV_MSR_TIME_REF_COUNT_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 1)
+#define HV_MSR_SYNIC_AVAILABLE			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 2)
+#define HV_MSR_SYNTIMER_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 3)
+#define HV_MSR_APIC_ACCESS_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 4)
+#define HV_MSR_HYPERCALL_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 5)
+#define HV_MSR_VP_INDEX_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 6)
+#define HV_MSR_RESET_AVAILABLE			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 7)
+#define HV_MSR_STAT_PAGES_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 8)
+#define HV_MSR_REFERENCE_TSC_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 9)
+#define HV_MSR_GUEST_IDLE_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 10)
+#define HV_ACCESS_FREQUENCY_MSRS		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 11)
+#define HV_ACCESS_REENLIGHTENMENT		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 13)
+#define HV_ACCESS_TSC_INVARIANT			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 15)
 
 /* HYPERV_CPUID_FEATURES.EBX */
-#define HV_CREATE_PARTITIONS			BIT(0)
-#define HV_ACCESS_PARTITION_ID			BIT(1)
-#define HV_ACCESS_MEMORY_POOL			BIT(2)
-#define HV_ADJUST_MESSAGE_BUFFERS		BIT(3)
-#define HV_POST_MESSAGES			BIT(4)
-#define HV_SIGNAL_EVENTS			BIT(5)
-#define HV_CREATE_PORT				BIT(6)
-#define HV_CONNECT_PORT				BIT(7)
-#define HV_ACCESS_STATS				BIT(8)
-#define HV_DEBUGGING				BIT(11)
-#define HV_CPU_MANAGEMENT			BIT(12)
-#define HV_ISOLATION				BIT(22)
+#define HV_CREATE_PARTITIONS		        \
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 0)
+#define HV_ACCESS_PARTITION_ID			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 1)
+#define HV_ACCESS_MEMORY_POOL			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 2)
+#define HV_ADJUST_MESSAGE_BUFFERS		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 3)
+#define HV_POST_MESSAGES			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 4)
+#define HV_SIGNAL_EVENTS			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 5)
+#define HV_CREATE_PORT				\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 6)
+#define HV_CONNECT_PORT				\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 7)
+#define HV_ACCESS_STATS				\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 8)
+#define HV_DEBUGGING				\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 11)
+#define HV_CPU_MANAGEMENT			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 12)
+#define HV_ISOLATION				\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 22)
 
 /* HYPERV_CPUID_FEATURES.EDX */
-#define HV_X64_MWAIT_AVAILABLE				BIT(0)
-#define HV_X64_GUEST_DEBUGGING_AVAILABLE		BIT(1)
-#define HV_X64_PERF_MONITOR_AVAILABLE			BIT(2)
-#define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE	BIT(3)
-#define HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE		BIT(4)
-#define HV_X64_GUEST_IDLE_STATE_AVAILABLE		BIT(5)
-#define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
-#define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
-#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
-#define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
+#define HV_X64_MWAIT_AVAILABLE				\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 0)
+#define HV_X64_GUEST_DEBUGGING_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 1)
+#define HV_X64_PERF_MONITOR_AVAILABLE			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 2)
+#define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE	\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 3)
+#define HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 4)
+#define HV_X64_GUEST_IDLE_STATE_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 5)
+#define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 8)
+#define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 10)
+#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 11)
+#define HV_STIMER_DIRECT_MODE_AVAILABLE			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 19)
 
 /* HYPERV_CPUID_ENLIGHTMENT_INFO.EAX */
-#define HV_X64_AS_SWITCH_RECOMMENDED			BIT(0)
-#define HV_X64_LOCAL_TLB_FLUSH_RECOMMENDED		BIT(1)
-#define HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED		BIT(2)
-#define HV_X64_APIC_ACCESS_RECOMMENDED			BIT(3)
-#define HV_X64_SYSTEM_RESET_RECOMMENDED			BIT(4)
-#define HV_X64_RELAXED_TIMING_RECOMMENDED		BIT(5)
-#define HV_DEPRECATING_AEOI_RECOMMENDED			BIT(9)
-#define HV_X64_CLUSTER_IPI_RECOMMENDED			BIT(10)
-#define HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED		BIT(11)
-#define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED		BIT(14)
+#define HV_X64_AS_SWITCH_RECOMMENDED			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 0)
+#define HV_X64_LOCAL_TLB_FLUSH_RECOMMENDED		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 1)
+#define HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 2)
+#define HV_X64_APIC_ACCESS_RECOMMENDED			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 3)
+#define HV_X64_SYSTEM_RESET_RECOMMENDED			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 4)
+#define HV_X64_RELAXED_TIMING_RECOMMENDED		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 5)
+#define HV_DEPRECATING_AEOI_RECOMMENDED			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 9)
+#define HV_X64_CLUSTER_IPI_RECOMMENDED			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 10)
+#define HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 11)
+#define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 14)
 
 /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
-#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
+#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES, 0, EAX, 1)
 
 /* Hypercalls */
 #define HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE	0x0002
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 4cf1368af48a..daad3e3cc7bb 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -13,6 +13,14 @@
 #include "processor.h"
 #include "hyperv.h"
 
+/*
+ * HYPERV_CPUID_ENLIGHTMENT_INFO.EBX is not a 'feature' CPUID leaf
+ * but to activate the feature it is sufficient to set it to a non-zero
+ * value. Use BIT(0) for that.
+ */
+#define HV_PV_SPINLOCKS_TEST            \
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EBX, 0)
+
 struct msr_data {
 	uint32_t idx;
 	bool fault_expected;
@@ -89,7 +97,6 @@ static void vcpu_reset_hv_cpuid(struct kvm_vcpu *vcpu)
 static void guest_test_msrs_access(void)
 {
 	struct kvm_cpuid2 *prev_cpuid = NULL;
-	struct kvm_cpuid_entry2 *feat, *dbg;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
@@ -116,9 +123,6 @@ static void guest_test_msrs_access(void)
 			vcpu_init_cpuid(vcpu, prev_cpuid);
 		}
 
-		feat = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES);
-		dbg = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES);
-
 		vm_init_descriptor_tables(vm);
 		vcpu_init_descriptor_tables(vcpu);
 
@@ -143,7 +147,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 2:
-			feat->eax |= HV_MSR_HYPERCALL_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_HYPERCALL_AVAILABLE);
 			/*
 			 * HV_X64_MSR_GUEST_OS_ID has to be written first to make
 			 * HV_X64_MSR_HYPERCALL available.
@@ -170,7 +174,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 6:
-			feat->eax |= HV_MSR_VP_RUNTIME_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_VP_RUNTIME_AVAILABLE);
 			msr->idx = HV_X64_MSR_VP_RUNTIME;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -189,7 +193,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 9:
-			feat->eax |= HV_MSR_TIME_REF_COUNT_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_TIME_REF_COUNT_AVAILABLE);
 			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -208,7 +212,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 12:
-			feat->eax |= HV_MSR_VP_INDEX_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_VP_INDEX_AVAILABLE);
 			msr->idx = HV_X64_MSR_VP_INDEX;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -227,7 +231,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 15:
-			feat->eax |= HV_MSR_RESET_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_RESET_AVAILABLE);
 			msr->idx = HV_X64_MSR_RESET;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -245,7 +249,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 18:
-			feat->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_REFERENCE_TSC_AVAILABLE);
 			msr->idx = HV_X64_MSR_REFERENCE_TSC;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -272,7 +276,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 22:
-			feat->eax |= HV_MSR_SYNIC_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_SYNIC_AVAILABLE);
 			msr->idx = HV_X64_MSR_EOM;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -290,7 +294,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 25:
-			feat->eax |= HV_MSR_SYNTIMER_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_SYNTIMER_AVAILABLE);
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -309,7 +313,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 28:
-			feat->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_STIMER_DIRECT_MODE_AVAILABLE);
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = true;
 			msr->write_val = 1 << 12;
@@ -322,7 +326,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 30:
-			feat->eax |= HV_MSR_APIC_ACCESS_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_APIC_ACCESS_AVAILABLE);
 			msr->idx = HV_X64_MSR_EOI;
 			msr->write = true;
 			msr->write_val = 1;
@@ -335,7 +339,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 32:
-			feat->eax |= HV_ACCESS_FREQUENCY_MSRS;
+			vcpu_set_cpuid_feature(vcpu, HV_ACCESS_FREQUENCY_MSRS);
 			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -354,7 +358,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 35:
-			feat->eax |= HV_ACCESS_REENLIGHTENMENT;
+			vcpu_set_cpuid_feature(vcpu, HV_ACCESS_REENLIGHTENMENT);
 			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -379,7 +383,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 39:
-			feat->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE);
 			msr->idx = HV_X64_MSR_CRASH_P0;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -397,8 +401,8 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 42:
-			feat->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
-			dbg->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
+			vcpu_set_cpuid_feature(vcpu, HV_FEATURE_DEBUG_MSRS_AVAILABLE);
+			vcpu_set_cpuid_feature(vcpu, HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING);
 			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -445,7 +449,6 @@ static void guest_test_msrs_access(void)
 
 static void guest_test_hcalls_access(void)
 {
-	struct kvm_cpuid_entry2 *feat, *recomm, *dbg;
 	struct kvm_cpuid2 *prev_cpuid = NULL;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
@@ -480,15 +483,11 @@ static void guest_test_hcalls_access(void)
 			vcpu_init_cpuid(vcpu, prev_cpuid);
 		}
 
-		feat = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES);
-		recomm = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO);
-		dbg = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES);
-
 		run = vcpu->run;
 
 		switch (stage) {
 		case 0:
-			feat->eax |= HV_MSR_HYPERCALL_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_HYPERCALL_AVAILABLE);
 			hcall->control = 0xbeef;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_CODE;
 			break;
@@ -498,7 +497,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 2:
-			feat->ebx |= HV_POST_MESSAGES;
+			vcpu_set_cpuid_feature(vcpu, HV_POST_MESSAGES);
 			hcall->control = HVCALL_POST_MESSAGE;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
@@ -508,7 +507,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 4:
-			feat->ebx |= HV_SIGNAL_EVENTS;
+			vcpu_set_cpuid_feature(vcpu, HV_SIGNAL_EVENTS);
 			hcall->control = HVCALL_SIGNAL_EVENT;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
@@ -518,12 +517,12 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_CODE;
 			break;
 		case 6:
-			dbg->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
+			vcpu_set_cpuid_feature(vcpu, HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING);
 			hcall->control = HVCALL_RESET_DEBUG_SESSION;
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 7:
-			feat->ebx |= HV_DEBUGGING;
+			vcpu_set_cpuid_feature(vcpu, HV_DEBUGGING);
 			hcall->control = HVCALL_RESET_DEBUG_SESSION;
 			hcall->expect = HV_STATUS_OPERATION_DENIED;
 			break;
@@ -533,7 +532,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 9:
-			recomm->eax |= HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED;
+			vcpu_set_cpuid_feature(vcpu, HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED);
 			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
@@ -542,7 +541,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 11:
-			recomm->eax |= HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED;
+			vcpu_set_cpuid_feature(vcpu, HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED);
 			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
@@ -552,7 +551,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 13:
-			recomm->eax |= HV_X64_CLUSTER_IPI_RECOMMENDED;
+			vcpu_set_cpuid_feature(vcpu, HV_X64_CLUSTER_IPI_RECOMMENDED);
 			hcall->control = HVCALL_SEND_IPI;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
@@ -567,7 +566,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 16:
-			recomm->ebx = 0xfff;
+			vcpu_set_cpuid_feature(vcpu, HV_PV_SPINLOCKS_TEST);
 			hcall->control = HVCALL_NOTIFY_LONG_SPIN_WAIT;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
@@ -577,7 +576,7 @@ static void guest_test_hcalls_access(void)
 			hcall->ud_expected = true;
 			break;
 		case 18:
-			feat->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE);
 			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT;
 			hcall->ud_expected = false;
 			hcall->expect = HV_STATUS_SUCCESS;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

