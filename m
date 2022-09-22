Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E075E65DB
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 16:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiIVOhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 10:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbiIVOhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 10:37:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F065AF6870
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 07:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663857433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDpfhu4EZUv8h03KdJkWlfIb8uO1yiASES1yDzWiyGA=;
        b=ZKXOw5H/ynUVz1a8vetve2SeXvEDR5KRkVlwPWgij2Vm2MLCiNRgDRsTu3iIgleujRaLIt
        lh+UOIc6eYZ3bM5zo+FgMweo/Ok6Z9tCoMC18WI68ws8fJFWvwxdj7T5gCt4kqhMEa0F0T
        V8H9ch/QMatjwEcVrhxQLRcny7OPSI8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671--1Ip1QuNN_2dnfTPdDQo3g-1; Thu, 22 Sep 2022 10:37:09 -0400
X-MC-Unique: -1Ip1QuNN_2dnfTPdDQo3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 387FA2932489;
        Thu, 22 Sep 2022 14:37:09 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A05340CFD05;
        Thu, 22 Sep 2022 14:37:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/6] KVM: selftests: Convert hyperv_features test to using KVM_X86_CPU_FEATURE()
Date:   Thu, 22 Sep 2022 16:36:54 +0200
Message-Id: <20220922143655.3721218-6-vkuznets@redhat.com>
In-Reply-To: <20220922143655.3721218-1-vkuznets@redhat.com>
References: <20220922143655.3721218-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hyperv_features test needs to set certain CPUID bits in Hyper-V feature
leaves but instead of open coding this, common KVM_X86_CPU_FEATURE()
infrastructure can be used.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/hyperv.h     | 141 ++++++++++++------
 .../selftests/kvm/x86_64/hyperv_features.c    |  58 +++----
 2 files changed, 118 insertions(+), 81 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index b66910702c0a..843748dde1ff 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -83,61 +83,108 @@
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
index 1383b979e90b..d4bd18bc580d 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -107,7 +107,6 @@ static void vcpu_reset_hv_cpuid(struct kvm_vcpu *vcpu)
 static void guest_test_msrs_access(void)
 {
 	struct kvm_cpuid2 *prev_cpuid = NULL;
-	struct kvm_cpuid_entry2 *feat, *dbg;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
@@ -134,9 +133,6 @@ static void guest_test_msrs_access(void)
 			vcpu_init_cpuid(vcpu, prev_cpuid);
 		}
 
-		feat = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES);
-		dbg = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES);
-
 		vm_init_descriptor_tables(vm);
 		vcpu_init_descriptor_tables(vcpu);
 
@@ -161,7 +157,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = 1;
 			break;
 		case 2:
-			feat->eax |= HV_MSR_HYPERCALL_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_HYPERCALL_AVAILABLE);
 			/*
 			 * HV_X64_MSR_GUEST_OS_ID has to be written first to make
 			 * HV_X64_MSR_HYPERCALL available.
@@ -188,7 +184,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = 1;
 			break;
 		case 6:
-			feat->eax |= HV_MSR_VP_RUNTIME_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_VP_RUNTIME_AVAILABLE);
 			msr->idx = HV_X64_MSR_VP_RUNTIME;
 			msr->write = 0;
 			msr->fault_expected = 0;
@@ -207,7 +203,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = 1;
 			break;
 		case 9:
-			feat->eax |= HV_MSR_TIME_REF_COUNT_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_TIME_REF_COUNT_AVAILABLE);
 			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
 			msr->write = 0;
 			msr->fault_expected = 0;
@@ -226,7 +222,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = 1;
 			break;
 		case 12:
-			feat->eax |= HV_MSR_VP_INDEX_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_VP_INDEX_AVAILABLE);
 			msr->idx = HV_X64_MSR_VP_INDEX;
 			msr->write = 0;
 			msr->fault_expected = 0;
@@ -245,7 +241,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = 1;
 			break;
 		case 15:
-			feat->eax |= HV_MSR_RESET_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_RESET_AVAILABLE);
 			msr->idx = HV_X64_MSR_RESET;
 			msr->write = 0;
 			msr->fault_expected = 0;
@@ -263,7 +259,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = 1;
 			break;
 		case 18:
-			feat->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_REFERENCE_TSC_AVAILABLE);
 			msr->idx = HV_X64_MSR_REFERENCE_TSC;
 			msr->write = 0;
 			msr->fault_expected = 0;
@@ -290,7 +286,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = 1;
 			break;
 		case 22:
-			feat->eax |= HV_MSR_SYNIC_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_SYNIC_AVAILABLE);
 			msr->idx = HV_X64_MSR_EOM;
 			msr->write = 0;
 			msr->fault_expected = 0;
@@ -308,7 +304,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = 1;
 			break;
 		case 25:
-			feat->eax |= HV_MSR_SYNTIMER_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_SYNTIMER_AVAILABLE);
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 0;
 			msr->fault_expected = 0;
@@ -327,7 +323,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = 1;
 			break;
 		case 28:
-			feat->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_STIMER_DIRECT_MODE_AVAILABLE);
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 1;
 			msr->write_val = 1 << 12;
@@ -340,7 +336,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = 1;
 			break;
 		case 30:
-			feat->eax |= HV_MSR_APIC_ACCESS_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_APIC_ACCESS_AVAILABLE);
 			msr->idx = HV_X64_MSR_EOI;
 			msr->write = 1;
 			msr->write_val = 1;
@@ -353,7 +349,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = 1;
 			break;
 		case 32:
-			feat->eax |= HV_ACCESS_FREQUENCY_MSRS;
+			vcpu_set_cpuid_feature(vcpu, HV_ACCESS_FREQUENCY_MSRS);
 			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
 			msr->write = 0;
 			msr->fault_expected = 0;
@@ -372,7 +368,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = 1;
 			break;
 		case 35:
-			feat->eax |= HV_ACCESS_REENLIGHTENMENT;
+			vcpu_set_cpuid_feature(vcpu, HV_ACCESS_REENLIGHTENMENT);
 			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
 			msr->write = 0;
 			msr->fault_expected = 0;
@@ -397,7 +393,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = 1;
 			break;
 		case 39:
-			feat->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE);
 			msr->idx = HV_X64_MSR_CRASH_P0;
 			msr->write = 0;
 			msr->fault_expected = 0;
@@ -415,8 +411,8 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = 1;
 			break;
 		case 42:
-			feat->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
-			dbg->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
+			vcpu_set_cpuid_feature(vcpu, HV_FEATURE_DEBUG_MSRS_AVAILABLE);
+			vcpu_set_cpuid_feature(vcpu, HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING);
 			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
 			msr->write = 0;
 			msr->fault_expected = 0;
@@ -463,7 +459,6 @@ static void guest_test_msrs_access(void)
 
 static void guest_test_hcalls_access(void)
 {
-	struct kvm_cpuid_entry2 *feat, *recomm, *dbg;
 	struct kvm_cpuid2 *prev_cpuid = NULL;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
@@ -498,15 +493,11 @@ static void guest_test_hcalls_access(void)
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
 			hcall->control = 0xdeadbeef;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_CODE;
 			break;
@@ -516,7 +507,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 2:
-			feat->ebx |= HV_POST_MESSAGES;
+			vcpu_set_cpuid_feature(vcpu, HV_POST_MESSAGES);
 			hcall->control = HVCALL_POST_MESSAGE;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
@@ -526,7 +517,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 4:
-			feat->ebx |= HV_SIGNAL_EVENTS;
+			vcpu_set_cpuid_feature(vcpu, HV_SIGNAL_EVENTS);
 			hcall->control = HVCALL_SIGNAL_EVENT;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
@@ -536,12 +527,12 @@ static void guest_test_hcalls_access(void)
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
@@ -551,7 +542,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 9:
-			recomm->eax |= HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED;
+			vcpu_set_cpuid_feature(vcpu, HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED);
 			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
@@ -560,7 +551,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 11:
-			recomm->eax |= HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED;
+			vcpu_set_cpuid_feature(vcpu, HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED);
 			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
@@ -570,7 +561,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 13:
-			recomm->eax |= HV_X64_CLUSTER_IPI_RECOMMENDED;
+			vcpu_set_cpuid_feature(vcpu, HV_X64_CLUSTER_IPI_RECOMMENDED);
 			hcall->control = HVCALL_SEND_IPI;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
@@ -585,7 +576,6 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 16:
-			recomm->ebx = 0xfff;
 			hcall->control = HVCALL_NOTIFY_LONG_SPIN_WAIT;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
@@ -595,7 +585,7 @@ static void guest_test_hcalls_access(void)
 			hcall->ud_expected = true;
 			break;
 		case 18:
-			feat->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE);
 			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT;
 			hcall->ud_expected = false;
 			hcall->expect = HV_STATUS_SUCCESS;
-- 
2.37.3

