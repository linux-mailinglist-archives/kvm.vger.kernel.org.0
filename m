Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCD664A741
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbiLLSho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbiLLShe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:37:34 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C7D12610
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:32 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id e6-20020aa78c46000000b005772151d489so370737pfd.15
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sz5Wduks+YLJq+6sNapaVEWpmAzRteIZERkQD0jVVik=;
        b=I5vmeyhc5AkkAt2ljLAlNzeeYI8l+GdPBBRg6Xri38CHab+FeJAqOgk+lE9D9fvhcE
         OqZ+HfeuDsbzsYUx7VPKTKTvIfnxO7iuX/1mFvryLWQ8jh55wpPPWeoXvdTeOoHVrDMh
         7N2olgFUeGtwvZ5JaxDTy7CG1MWFaaPAKb3j3YeCqsIVttbq0izNHGBiq2iWhy7xMMXP
         z6gh74evHGHfiSEbX9dXRM0dgzbXB+46SnccfeJzjwO2gpHrxyHspRr69uO/fpLnJw2k
         yWFf2dH0r6AIWa42/2cbsKUQCbwd7EpGcKTVx9wAgQXApGqEVKHa81RQY3UCo4MZ0kM5
         FJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sz5Wduks+YLJq+6sNapaVEWpmAzRteIZERkQD0jVVik=;
        b=jxKB74/nXHV7KwrzlijYRo4+ezyi9Gim/H2JJyNNvWUK8uWotZpoc8XYQf2RsVhfPl
         O7UtNm3aTctKEWfTKb7UcIVVrvQGJG3PNxKvfYgn979xE2atBmkw67HG+CUB+a+Z5LAG
         U8Rh5Cst0MpbnTjv09J6qiC/XIzJZeVRsIjzMoAJQmMDN750LDoYjXZdLFHDhrioeVZk
         BK0Tr+Zp5U1be6MrM1WqujlJmqSH+qHc9ALiVkgGmb6xtmkvfBHuO9Negesw0NYnYvud
         vD9t0PYNk69r3Prl+t6rHIm4N1SEPzMjsOFrSi++bzk920zrXdECQ/7IDCh2BlTUgmeP
         QjFQ==
X-Gm-Message-State: ANoB5pmyzECH81KaHEgLWF2Rv6Nt+try0Tkmg563XalbQ36Z0tvemVxW
        GfV1mQFp0XFxHoI/MfxauXpRBzV8M9mh
X-Google-Smtp-Source: AA0mqf5sCsss482CqTeai3NKIgU9pAa/xoj7AqR7t2Q67+dH0StemZlpE1u8/EwOB0OJk/xQtI7EfJTBbCm2
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:2a88:b0:220:1f03:129b with SMTP id
 j8-20020a17090a2a8800b002201f03129bmr219198pjd.0.1670870251485; Mon, 12 Dec
 2022 10:37:31 -0800 (PST)
Date:   Mon, 12 Dec 2022 10:37:12 -0800
In-Reply-To: <20221212183720.4062037-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221212183720.4062037-6-vipinsh@google.com>
Subject: [Patch v4 05/13] KVM: selftests: Convert hyperv_features test to
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
2.39.0.rc1.256.g54fd8350bd-goog

